// Package remote provides SSH remote connection management.
package remote

import (
	"context"
	"crypto/sha256"
	"encoding/base64"
	"errors"
	"fmt"
	"net"
	"os"
	"path/filepath"
	"strings"

	"golang.org/x/crypto/ssh"
	"golang.org/x/crypto/ssh/knownhosts"
)

// HostKeyStatus represents the status of host key verification
type HostKeyStatus int

const (
	HostKeyStatusUnspecified HostKeyStatus = iota
	HostKeyStatusVerified                  // Host key matched known_hosts
	HostKeyStatusUnknown                   // Host not in known_hosts
	HostKeyStatusMismatch                  // Host key changed (possible MITM attack)
	HostKeyStatusAdded                     // Host key was added to known_hosts
)

// HostKeyInfo contains information about a host key
type HostKeyInfo struct {
	Hostname    string
	Port        int
	KeyType     string
	Fingerprint string
	PublicKey   string
}

// HostKeyVerifier handles host key verification against known_hosts
type HostKeyVerifier struct {
	knownHostsPath string
}

// NewHostKeyVerifier creates a new host key verifier
func NewHostKeyVerifier() (*HostKeyVerifier, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get home directory: %w", err)
	}

	return &HostKeyVerifier{
		knownHostsPath: filepath.Join(homeDir, ".ssh", "known_hosts"),
	}, nil
}

// CheckHostKey checks if a host key is in known_hosts
// Returns the status and host key info
func (v *HostKeyVerifier) CheckHostKey(ctx context.Context, host string, port int) (HostKeyStatus, *HostKeyInfo, error) {
	if port == 0 {
		port = 22
	}

	// Format hostname for callback - needs host:port for knownhosts.SplitHostPort
	hostname := net.JoinHostPort(host, fmt.Sprintf("%d", port))

	// Check if known_hosts file exists
	if _, err := os.Stat(v.knownHostsPath); os.IsNotExist(err) {
		// No known_hosts file, host is unknown
		return HostKeyStatusUnknown, nil, nil
	}

	// Try to create a host key callback to check if host is known
	callback, err := knownhosts.New(v.knownHostsPath)
	if err != nil {
		return HostKeyStatusUnspecified, nil, fmt.Errorf("failed to parse known_hosts: %w", err)
	}

	// Scan the host to get its actual key
	hostKey, keyType, err := v.scanHostKey(host, port)
	if err != nil {
		return HostKeyStatusUnspecified, nil, fmt.Errorf("failed to scan host key: %w", err)
	}

	// Format address for callback
	addr := &net.TCPAddr{
		IP:   net.ParseIP(host),
		Port: port,
	}
	// If host is a name not IP, use a fake IP but the callback uses hostname
	if addr.IP == nil {
		addr = &net.TCPAddr{IP: net.IPv4(127, 0, 0, 1), Port: port}
	}

	// Check the key against known_hosts
	err = callback(hostname, addr, hostKey)
	if err == nil {
		// Host key matches
		return HostKeyStatusVerified, &HostKeyInfo{
			Hostname:    host,
			Port:        port,
			KeyType:     keyType,
			Fingerprint: fingerprint(hostKey),
			PublicKey:   base64.StdEncoding.EncodeToString(hostKey.Marshal()),
		}, nil
	}

	// Check if it's a key mismatch
	var keyErr *knownhosts.KeyError
	if errors.As(err, &keyErr) {
		if len(keyErr.Want) > 0 {
			// Key mismatch - known host but different key
			return HostKeyStatusMismatch, &HostKeyInfo{
				Hostname:    host,
				Port:        port,
				KeyType:     keyType,
				Fingerprint: fingerprint(hostKey),
				PublicKey:   base64.StdEncoding.EncodeToString(hostKey.Marshal()),
			}, nil
		}
		// Host not in known_hosts
		return HostKeyStatusUnknown, &HostKeyInfo{
			Hostname:    host,
			Port:        port,
			KeyType:     keyType,
			Fingerprint: fingerprint(hostKey),
			PublicKey:   base64.StdEncoding.EncodeToString(hostKey.Marshal()),
		}, nil
	}

	return HostKeyStatusUnspecified, nil, fmt.Errorf("unexpected error checking host key: %w", err)
}

// AddHostKey adds a host key to known_hosts
func (v *HostKeyVerifier) AddHostKey(host string, port int, keyType, publicKeyB64 string) error {
	if port == 0 {
		port = 22
	}

	// Decode the public key
	pubKeyBytes, err := base64.StdEncoding.DecodeString(publicKeyB64)
	if err != nil {
		return fmt.Errorf("failed to decode public key: %w", err)
	}

	pubKey, err := ssh.ParsePublicKey(pubKeyBytes)
	if err != nil {
		return fmt.Errorf("failed to parse public key: %w", err)
	}

	// Format the hostname
	hostname := host
	if port != 22 {
		hostname = fmt.Sprintf("[%s]:%d", host, port)
	}

	// Create the known_hosts line
	line := knownhosts.Line([]string{hostname}, pubKey)

	// Ensure .ssh directory exists
	sshDir := filepath.Dir(v.knownHostsPath)
	if err := os.MkdirAll(sshDir, 0700); err != nil {
		return fmt.Errorf("failed to create .ssh directory: %w", err)
	}

	// Append to known_hosts
	f, err := os.OpenFile(v.knownHostsPath, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0600)
	if err != nil {
		return fmt.Errorf("failed to open known_hosts: %w", err)
	}
	defer f.Close()

	if _, err := f.WriteString(line + "\n"); err != nil {
		return fmt.Errorf("failed to write to known_hosts: %w", err)
	}

	return nil
}

// CreateHostKeyCallback creates an SSH host key callback for connections
// If trustUnknown is true, unknown hosts will be accepted (but not added)
func (v *HostKeyVerifier) CreateHostKeyCallback(trustUnknown bool) (ssh.HostKeyCallback, error) {
	// Check if known_hosts exists
	if _, err := os.Stat(v.knownHostsPath); os.IsNotExist(err) {
		if trustUnknown {
			return ssh.InsecureIgnoreHostKey(), nil
		}
		// Return a callback that rejects everything as unknown
		return func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			return &knownhosts.KeyError{
				Want: []knownhosts.KnownKey{},
			}
		}, nil
	}

	callback, err := knownhosts.New(v.knownHostsPath)
	if err != nil {
		return nil, fmt.Errorf("failed to parse known_hosts: %w", err)
	}

	if trustUnknown {
		// Wrap the callback to accept unknown hosts
		return func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			err := callback(hostname, remote, key)
			if err != nil {
				var keyErr *knownhosts.KeyError
				if errors.As(err, &keyErr) && len(keyErr.Want) == 0 {
					// Unknown host, accept it
					return nil
				}
			}
			return err
		}, nil
	}

	return callback, nil
}

// scanHostKey connects to a host and retrieves its host key
func (v *HostKeyVerifier) scanHostKey(host string, port int) (ssh.PublicKey, string, error) {
	addr := fmt.Sprintf("%s:%d", host, port)

	var hostKey ssh.PublicKey
	var keyType string

	config := &ssh.ClientConfig{
		User: "probe", // Doesn't matter, we just want the host key
		Auth: []ssh.AuthMethod{},
		HostKeyCallback: func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			hostKey = key
			keyType = key.Type()
			// Return error to abort the connection after getting the key
			return errors.New("got host key")
		},
	}

	// Connect just to get the host key
	conn, err := net.DialTimeout("tcp", addr, config.Timeout)
	if err != nil {
		return nil, "", fmt.Errorf("failed to connect: %w", err)
	}
	defer conn.Close()

	// Start SSH handshake - this will fail but we'll have the host key
	_, _, _, _ = ssh.NewClientConn(conn, addr, config)

	if hostKey == nil {
		return nil, "", errors.New("failed to retrieve host key")
	}

	return hostKey, keyType, nil
}

// fingerprint calculates the SHA256 fingerprint of a public key
func fingerprint(key ssh.PublicKey) string {
	hash := sha256.Sum256(key.Marshal())
	return "SHA256:" + strings.TrimRight(base64.StdEncoding.EncodeToString(hash[:]), "=")
}
