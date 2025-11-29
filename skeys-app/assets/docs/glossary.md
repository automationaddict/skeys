# SSH Glossary

Common SSH terms and definitions to help you understand SSH concepts and skeys features.

## A

### Agent Forwarding
Allows your SSH agent to authenticate on remote servers you connect to from another remote server. Enables "hopping" through multiple servers using your local keys.

### Asymmetric Encryption
Encryption using a pair of keys: a public key (shared openly) and a private key (kept secret). Also called public-key cryptography.

### Authenticated Keys File
See [Authorized Keys](#authorized-keys).

### Authorized Keys
A file (`~/.ssh/authorized_keys`) containing public keys that are allowed to authenticate to a user account. Each line represents one authorized key.

## C

### Client
The SSH client is software that initiates connections to SSH servers. Examples include OpenSSH's `ssh` command, PuTTY, and skeys.

### Client Configuration
The SSH client configuration file (`~/.ssh/config`) that defines connection settings, host aliases, and default options.

## D

### Daemon
A background process that runs continuously. The SSH server is often called the SSH daemon (`sshd`).

## E

### ECDSA
Elliptic Curve Digital Signature Algorithm - a key type that uses elliptic curve cryptography. Provides good security with smaller key sizes (typically 256, 384, or 521 bits).

### Ed25519
A modern, high-security key type using elliptic curve cryptography. Recommended for new keys due to its strong security and excellent performance.

### Encryption
The process of encoding information so only authorized parties can read it. SSH encrypts all communication between client and server.

## F

### Fingerprint
A short hash of a public key used for easy verification. Instead of comparing the entire key, you can verify the fingerprint (typically shown in SHA256 or MD5 format).

### Forward Agent
See [Agent Forwarding](#agent-forwarding).

## H

### Host
A computer system accessible over a network. In SSH context, typically refers to the remote server you're connecting to.

### Host Key
The SSH server's public key used to identify and verify the server. Prevents man-in-the-middle attacks by ensuring you're connecting to the correct server.

### Host Key Verification
The process of checking a server's host key against a previously stored key in the `known_hosts` file to ensure server identity.

## I

### Identity File
A file containing an SSH private key. Default identity files are `~/.ssh/id_rsa`, `~/.ssh/id_ed25519`, etc.

## K

### Key Pair
A set of two cryptographic keys: a public key and a private key. Used for SSH authentication.

### Known Hosts
A file (`~/.ssh/known_hosts`) that stores public host keys of servers you've connected to, used for host verification on subsequent connections.

## L

### Local Forwarding
Port forwarding that makes a remote service available on your local machine. Format: `-L local_port:remote_host:remote_port`

## M

### Man-in-the-Middle Attack
An attack where someone intercepts communication between client and server, potentially reading or modifying data. SSH prevents this through host key verification.

## P

### Passphrase
A password used to encrypt a private key file. Provides additional security by ensuring that even if someone steals the key file, they cannot use it without the passphrase.

### Port
A communication endpoint on a computer. SSH typically uses port 22, but can be configured to use other ports.

### Port Forwarding
Tunneling network connections through an SSH connection. See [Local Forwarding](#local-forwarding) and [Remote Forwarding](#remote-forwarding).

### Private Key
The secret part of a key pair that must be kept secure. Used to authenticate to servers and decrypt messages encrypted with the corresponding public key.

### Public Key
The shareable part of a key pair that can be freely distributed. Servers use this to verify you possess the corresponding private key without exposing it.

### Public Key Authentication
An authentication method using cryptographic key pairs instead of passwords. More secure and convenient for regular use.

## R

### Remote Forwarding
Port forwarding that makes a local service available on the remote server. Format: `-R remote_port:local_host:local_port`

### RSA
Rivest-Shamir-Adleman - a widely-used key type. RSA keys are typically 2048, 3072, or 4096 bits. While still secure (especially at 4096 bits), Ed25519 is preferred for new keys.

## S

### SCP (Secure Copy Protocol)
A protocol for securely copying files between hosts using SSH. Command: `scp source destination`

### Server
The SSH server (daemon) that accepts incoming SSH connections and provides access to system resources.

### Server Configuration
The SSH server configuration file (`/etc/ssh/sshd_config`) that controls server behavior, security settings, and access policies.

### SFTP (SSH File Transfer Protocol)
A secure file transfer protocol that runs over SSH. More feature-rich than SCP, providing a full file system interface.

### Shell
A command-line interface for interacting with an operating system. SSH provides secure shell access to remote systems.

### SSH (Secure Shell)
A cryptographic network protocol for secure communication over unsecured networks. Commonly used for remote login and command execution.

### SSH Agent
A helper program that stores private keys in memory and provides them to SSH clients when needed. Eliminates repeated passphrase entry.

### SSH Config
See [Client Configuration](#client-configuration) or [Server Configuration](#server-configuration).

### SSHD
The SSH daemon (server) that listens for and accepts SSH connections.

### Symmetric Encryption
Encryption using the same key for both encryption and decryption. SSH uses symmetric encryption for the bulk of data transfer after the initial key exchange.

## T

### Terminal
A text-based interface for entering commands and viewing output. SSH provides secure terminal access to remote systems.

### Tunnel
An encrypted connection that carries other network traffic through SSH. See [Port Forwarding](#port-forwarding).

## U

### User Authentication
The process of verifying a user's identity before granting access. SSH supports multiple methods including passwords and public keys.

## Related Topics

- [SSH Overview](skeys://help/ssh-overview) - Learn about SSH concepts
- [SSH Keys](skeys://help/keys) - Managing SSH keys
- [SSH Agent](skeys://help/agent) - Using the SSH agent
- [Configuration](skeys://help/config-client) - SSH configuration
