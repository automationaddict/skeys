# SSH Overview

SSH (Secure Shell) is a cryptographic network protocol for secure communication over unsecured networks. This guide provides an overview of SSH concepts and how they relate to skeys.

## What is SSH?

SSH provides a secure channel over an unsecured network by using encryption. It's commonly used for:

- **Remote Login** - Securely access and control remote computers
- **Command Execution** - Run commands on remote systems
- **File Transfer** - Securely transfer files using SCP or SFTP
- **Port Forwarding** - Tunnel network connections through encrypted channels

## SSH Architecture

SSH operates on a client-server model:

### SSH Client

The **SSH client** is the software that initiates connections to remote SSH servers. It:

- Connects to remote systems
- Authenticates the user (using passwords or keys)
- Encrypts all communication
- Provides a secure terminal or file transfer session

**In skeys**: The client configuration manages your connection settings, host aliases, and connection options. See [Client Config](skeys://help/config-client) for details.

### SSH Server

The **SSH server** (also called SSH daemon or `sshd`) listens for incoming SSH connections. It:

- Accepts connections from SSH clients
- Authenticates connecting users
- Provides access to the system's resources
- Enforces security policies

**In skeys**: You can monitor and control your SSH server status, configure server settings, and view active connections. See [SSH Server Status](skeys://help/server) and [Server Config](skeys://help/config-server).

## Authentication Methods

SSH supports multiple authentication methods:

### Password Authentication

The simplest method where users authenticate with a username and password. While easy to use, password authentication is:

- Vulnerable to brute-force attacks
- Requires typing passwords repeatedly
- Not recommended for automated processes

### Public Key Authentication

The recommended method using cryptographic key pairs:

1. **Private Key** - Kept secret on the client side
2. **Public Key** - Shared with servers you want to access

When connecting:
- The server verifies you possess the private key
- No password needs to be transmitted
- More secure and convenient than passwords

**In skeys**: Generate and manage SSH keys in the [SSH Keys](skeys://help/keys) section.

### SSH Agent

The SSH agent is a helper program that:

- Holds your private keys in memory
- Provides keys to SSH clients when needed
- Eliminates the need to type passphrases repeatedly
- Improves security by never exposing private keys directly

**In skeys**: Manage loaded keys and configure the agent in the [SSH Agent](skeys://help/agent) section.

## Security Features

### Host Key Verification

When connecting to an SSH server for the first time, SSH verifies the server's identity using its host key:

1. The server presents its public host key
2. SSH asks you to verify the key fingerprint
3. Once accepted, the key is stored in `known_hosts`
4. Future connections verify against the stored key

This prevents man-in-the-middle attacks by ensuring you're connecting to the legitimate server.

**In skeys**: Manage known hosts and verify fingerprints in [Known Hosts](skeys://help/hosts-known).

### Encryption

All SSH communication is encrypted using strong cryptographic algorithms:

- **Symmetric encryption** for data transmission
- **Asymmetric encryption** for key exchange
- **Hashing** for data integrity verification

### Port Forwarding

SSH can securely tunnel other network connections:

- **Local forwarding** - Forward local ports to remote systems
- **Remote forwarding** - Forward remote ports to local systems
- **Dynamic forwarding** - Create a SOCKS proxy through SSH

## Common Use Cases

### Remote Server Administration

SSH is the standard way to manage remote Linux/Unix servers:

```bash
ssh user@server.example.com
```

### Secure File Transfer

Transfer files securely using SCP or SFTP:

```bash
scp file.txt user@server.example.com:/path/
sftp user@server.example.com
```

### Git and Version Control

SSH is commonly used for secure Git operations:

```bash
git clone git@github.com:user/repository.git
```

### Automated Processes

SSH keys enable secure automated processes:

- Deployment scripts
- Backup systems
- Monitoring tools
- CI/CD pipelines

## Best Practices

1. **Use Key-Based Authentication** - More secure than passwords
2. **Protect Private Keys** - Use strong passphrases
3. **Disable Root Login** - Use sudo for administrative tasks
4. **Keep Software Updated** - Apply security patches promptly
5. **Use Strong Key Types** - Prefer Ed25519 or RSA 4096-bit keys
6. **Verify Host Keys** - Always verify fingerprints on first connection
7. **Limit SSH Access** - Use firewalls and fail2ban for protection
8. **Regular Key Rotation** - Periodically generate new keys

## SSH Configuration Files

### Client Configuration (`~/.ssh/config`)

Defines connection settings, host aliases, and default options for SSH clients.

**In skeys**: Edit client configuration in [Client Config](skeys://help/config-client).

### Server Configuration (`/etc/ssh/sshd_config`)

Configures the SSH server behavior, security settings, and access policies.

**In skeys**: Edit server configuration in [Server Config](skeys://help/config-server).

### Known Hosts (`~/.ssh/known_hosts`)

Stores public keys of servers you've connected to for host verification.

**In skeys**: Manage entries in [Known Hosts](skeys://help/hosts-known).

### Authorized Keys (`~/.ssh/authorized_keys`)

Lists public keys allowed to authenticate to your account.

**In skeys**: Manage entries in [Authorized Keys](skeys://help/hosts-authorized).

## Learn More

- [SSH Keys](skeys://help/keys) - Managing SSH keys
- [SSH Agent](skeys://help/agent) - Using the SSH agent
- [Glossary](skeys://help/glossary) - SSH terminology reference
