// Copyright (c) 2025 John Nelson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

package hosts

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"sync"

	"github.com/johnnelson/skeys-core/logging"
)

// AuthorizedKey represents an entry in authorized_keys
type AuthorizedKey struct {
	ID          string
	KeyType     string
	Fingerprint string
	Comment     string
	PublicKey   string
	Options     []string
	LineNumber  int
}

// AuthorizedKeysManager manages the authorized_keys file
type AuthorizedKeysManager struct {
	path      string
	log       *logging.Logger
	watcher   *authorizedKeysWatcher
	watcherMu sync.Mutex
}

// AuthorizedKeysOption is a functional option
type AuthorizedKeysOption func(*AuthorizedKeysManager)

// WithAuthorizedKeysPath sets a custom authorized_keys path
func WithAuthorizedKeysPath(path string) AuthorizedKeysOption {
	return func(m *AuthorizedKeysManager) {
		m.path = path
	}
}

// WithAuthorizedKeysLogger sets a custom logger
func WithAuthorizedKeysLogger(log *logging.Logger) AuthorizedKeysOption {
	return func(m *AuthorizedKeysManager) {
		m.log = log
	}
}

// NewAuthorizedKeysManager creates a new authorized_keys manager
func NewAuthorizedKeysManager(opts ...AuthorizedKeysOption) (*AuthorizedKeysManager, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get home directory: %w", err)
	}

	m := &AuthorizedKeysManager{
		path: filepath.Join(homeDir, ".ssh", "authorized_keys"),
		log:  logging.Nop(),
	}

	for _, opt := range opts {
		opt(m)
	}

	m.log.InfoWithFields("authorized_keys manager initialized", map[string]interface{}{
		"path": m.path,
	})

	return m, nil
}

// List returns all keys in authorized_keys
func (m *AuthorizedKeysManager) List() ([]*AuthorizedKey, error) {
	f, err := os.Open(m.path)
	if os.IsNotExist(err) {
		return []*AuthorizedKey{}, nil
	}
	if err != nil {
		return nil, fmt.Errorf("failed to open authorized_keys: %w", err)
	}
	defer f.Close()

	var keys []*AuthorizedKey
	scanner := bufio.NewScanner(f)
	lineNum := 0

	for scanner.Scan() {
		lineNum++
		line := strings.TrimSpace(scanner.Text())

		// Skip empty lines and comments
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		key := m.parseLine(line, lineNum)
		if key != nil {
			keys = append(keys, key)
		}
	}

	return keys, scanner.Err()
}

// parseLine parses a single authorized_keys line
func (m *AuthorizedKeysManager) parseLine(line string, lineNum int) *AuthorizedKey {
	key := &AuthorizedKey{
		ID:         fmt.Sprintf("%d", lineNum),
		LineNumber: lineNum,
		PublicKey:  line,
	}

	// Check for options at the beginning
	// Options format: option1,option2="value" keytype base64 comment
	parts := strings.Fields(line)
	if len(parts) < 2 {
		return nil
	}

	idx := 0

	// Check if first field is options (doesn't start with ssh- or ecdsa-)
	if !strings.HasPrefix(parts[0], "ssh-") && !strings.HasPrefix(parts[0], "ecdsa-") && !strings.HasPrefix(parts[0], "sk-") {
		key.Options = parseOptions(parts[0])
		idx++
	}

	if len(parts) <= idx+1 {
		return nil
	}

	key.KeyType = parts[idx]

	if len(parts) > idx+2 {
		key.Comment = strings.Join(parts[idx+2:], " ")
	}

	return key
}

// parseOptions parses the options field
func parseOptions(optStr string) []string {
	var options []string
	var current strings.Builder
	inQuote := false

	for _, c := range optStr {
		switch c {
		case '"':
			inQuote = !inQuote
			current.WriteRune(c)
		case ',':
			if inQuote {
				current.WriteRune(c)
			} else {
				if current.Len() > 0 {
					options = append(options, current.String())
					current.Reset()
				}
			}
		default:
			current.WriteRune(c)
		}
	}

	if current.Len() > 0 {
		options = append(options, current.String())
	}

	return options
}

// Add adds a new key to authorized_keys
func (m *AuthorizedKeysManager) Add(publicKey string, options []string) error {
	// Ensure directory exists
	dir := filepath.Dir(m.path)
	if err := os.MkdirAll(dir, 0700); err != nil {
		return fmt.Errorf("failed to create .ssh directory: %w", err)
	}

	// Build the line
	var line string
	if len(options) > 0 {
		line = strings.Join(options, ",") + " " + publicKey
	} else {
		line = publicKey
	}

	// Append to file
	f, err := os.OpenFile(m.path, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0600)
	if err != nil {
		return fmt.Errorf("failed to open authorized_keys: %w", err)
	}
	defer f.Close()

	if _, err := f.WriteString(line + "\n"); err != nil {
		return fmt.Errorf("failed to write key: %w", err)
	}

	return nil
}

// Remove removes a key by line number
func (m *AuthorizedKeysManager) Remove(lineNumber int) error {
	keys, err := m.List()
	if err != nil {
		return err
	}

	var remaining []string
	for _, key := range keys {
		if key.LineNumber != lineNumber {
			remaining = append(remaining, key.PublicKey)
		}
	}

	// Write back
	content := strings.Join(remaining, "\n")
	if len(remaining) > 0 {
		content += "\n"
	}

	return os.WriteFile(m.path, []byte(content), 0600)
}

// Update updates key options
func (m *AuthorizedKeysManager) Update(lineNumber int, options []string) error {
	keys, err := m.List()
	if err != nil {
		return err
	}

	var lines []string
	for _, key := range keys {
		if key.LineNumber == lineNumber {
			// Rebuild the line with new options
			parts := strings.Fields(key.PublicKey)
			idx := 0
			if len(key.Options) > 0 {
				idx = 1
			}

			var line string
			if len(options) > 0 {
				line = strings.Join(options, ",") + " " + strings.Join(parts[idx:], " ")
			} else {
				line = strings.Join(parts[idx:], " ")
			}
			lines = append(lines, line)
		} else {
			lines = append(lines, key.PublicKey)
		}
	}

	content := strings.Join(lines, "\n")
	if len(lines) > 0 {
		content += "\n"
	}

	return os.WriteFile(m.path, []byte(content), 0600)
}
