# Frequently Asked Questions (FAQ)

Common questions and answers about using skeys.

## General Questions

### What is skeys?

skeys is a comprehensive SSH key and server management application for Linux. It provides a user-friendly interface for generating SSH keys, managing the SSH agent, configuring SSH clients and servers, and monitoring SSH connections.

### Do I need to know about SSH to use skeys?

Not necessarily! skeys is designed to make SSH accessible to everyone. However, reading the [SSH Overview](skeys://help/ssh-overview) will help you understand what's happening behind the scenes.

### Is skeys free and open source?

Yes! skeys is released under the MIT License. You can view the source code, contribute, and use it for free at [github.com/automationaddict/skeys](https://github.com/automationaddict/skeys).

### What operating systems does skeys support?

Currently, skeys supports Linux distributions including Ubuntu, Debian, Fedora, and other modern distributions. Windows and macOS support is not currently available.

## SSH Keys

### What type of SSH key should I generate?

For most users, **Ed25519** is recommended. It's:
- More secure than RSA
- Faster to generate and use
- Uses smaller keys (better performance)

Use **RSA 4096** only if you need compatibility with older systems that don't support Ed25519.

### Should I use a passphrase for my SSH key?

**Yes!** A passphrase adds an extra layer of security. Even if someone steals your private key file, they can't use it without the passphrase. The SSH agent will remember your passphrase during your session, so you only need to enter it once.

### How many SSH keys should I have?

It's good practice to have separate keys for different purposes:
- One for GitHub/GitLab
- One for work servers
- One for personal projects
- One for each critical server

This limits the damage if any single key is compromised.

### Can I use the same SSH key on multiple computers?

Technically yes, but it's not recommended. Each computer should have its own key pair for security. If one computer is compromised, you only need to revoke that one key.

### What's the difference between public and private keys?

- **Private key**: Secret file that stays on your computer. Never share this!
- **Public key**: Can be freely shared. You upload this to servers/services you want to access.

Think of it like a lock and key: The public key is the lock (can be shared), and the private key opens that lock (must be kept secret).

### Where are my SSH keys stored?

Private keys are stored in `~/.ssh/` with names like:
- `~/.ssh/id_ed25519` (private key)
- `~/.ssh/id_ed25519.pub` (public key)

skeys also stores metadata about your keys in its application database.

## SSH Agent

### What is the SSH agent?

The SSH agent is a program that holds your private keys in memory. Instead of typing your passphrase every time you use SSH, you type it once when adding the key to the agent, and the agent handles authentication from then on.

### Do I need to add my key to the agent every time I restart?

It depends on your system configuration. By default, keys are removed from the agent when you log out. Some systems can be configured to persist keys across sessions, but this has security implications.

### How do I know if my key is in the agent?

In skeys:
1. Go to [SSH Agent](skeys://help/agent)
2. View the list of loaded keys
3. Keys show their service, fingerprint, and how long they've been loaded

### Why can't I remove a key from the agent?

Some keys may be loaded by other applications or system services. skeys can only remove keys that it added to the agent. You may need to restart your session to clear all keys.

## SSH Server

### Do I need an SSH server to use skeys?

Not necessarily! You need an SSH server if you want to:
- Accept incoming SSH connections
- Let others connect to your computer via SSH
- Set up remote access to your machine

You don't need a server just to connect to other servers or use SSH keys with services like GitHub.

### Can skeys configure my SSH server?

Yes! Go to [Server Config](skeys://help/config-server) to configure settings like:
- Which port to listen on
- Whether to allow password authentication
- Whether to allow root login
- Authorized key locations

### How do I allow someone to SSH into my computer?

1. Make sure your SSH server is running
2. Get their public key
3. Go to [Authorized Keys](skeys://help/hosts-authorized)
4. Add their public key to your authorized keys
5. They can now connect using their private key

### Why can't I edit server configuration?

Server configuration requires sudo (administrator) privileges. skeys will prompt you for your password when you try to save server configuration changes.

## Connections and Known Hosts

### What is a host key fingerprint?

A host key fingerprint is a short representation of a server's public key. When you connect to a server for the first time, SSH shows you the fingerprint so you can verify you're connecting to the right server (not an imposter).

### Should I verify host key fingerprints?

**Yes!** Especially for important connections. Ask the server administrator for the correct fingerprint and verify it matches before accepting. This prevents man-in-the-middle attacks.

### I got a "host key changed" warning. What should I do?

This warning appears when a server's host key doesn't match the one stored in your known_hosts file. This could mean:
- The server was reinstalled
- The server's SSH was reconfigured
- **Security risk**: Someone is intercepting your connection

**Action**: Contact the server administrator to verify the new fingerprint before accepting it.

### How do I remove a known host?

1. Go to [Known Hosts](skeys://help/hosts-known)
2. Find the host in the list
3. Click the delete/remove button
4. The next connection will ask you to verify the host key again

## Configuration

### What's the difference between client and server config?

- **[Client Config](skeys://help/config-client)**: Controls how you connect to other servers (outgoing connections)
- **[Server Config](skeys://help/config-server)**: Controls how others connect to your computer (incoming connections)

### Can I use skeys with my existing SSH configuration?

Yes! skeys reads and writes standard SSH configuration files. You can continue using command-line SSH tools alongside skeys.

### Will skeys overwrite my SSH config?

skeys is careful with your SSH configuration. It:
- Backs up files before modifying them
- Preserves comments and formatting when possible
- Only modifies what you explicitly change through the UI

## Backups

### What does skeys backup?

The backup feature includes:
- SSH keys (both public and private)
- SSH client configuration
- SSH server configuration
- Known hosts
- Authorized keys
- skeys application settings

### How often should I back up?

Create a backup:
- After generating new keys
- Before making major configuration changes
- Regularly (weekly or monthly) for peace of mind
- Before reinstalling your system

### Where should I store backups?

Store backups in a secure location:
- External hard drive
- Encrypted USB drive
- Secure cloud storage (ensure it's encrypted!)
- Password manager (some support file attachments)

**Never** store unencrypted backups containing private keys on shared or public storage.

## Troubleshooting

### skeys can't connect to the SSH server

Check that:
1. The SSH server is running
2. Port 22 (or your custom port) is open
3. Your firewall isn't blocking connections
4. The sshd service is enabled: `sudo systemctl status sshd`

### My key isn't working with GitHub/GitLab

Ensure:
1. You copied the **public** key (ends in `.pub`)
2. You copied the entire key (common mistake: missing the end)
3. The key is added to the agent
4. Your git remote URL uses SSH format: `git@github.com:user/repo.git`

### I forgot my key passphrase

Unfortunately, there's no way to recover a lost passphrase. You'll need to:
1. Generate a new key
2. Update all services with the new public key
3. Remove the old key from those services

This is why passphrases protect your keys so well!

### skeys won't start

Try:
1. Running from terminal to see error messages
2. Checking permissions on `~/.ssh/` (should be 700)
3. Checking for conflicting SSH processes
4. Reviewing [Troubleshooting](skeys://help/troubleshooting) guide

## Advanced Topics

### Can I import existing keys into skeys?

Yes! Any keys already in `~/.ssh/` will automatically appear in skeys. The app scans for keys on startup and refresh.

### Does skeys support hardware security keys (YubiKey, etc.)?

Currently, skeys focuses on software-based SSH keys. Hardware key support may be added in future versions.

### Can I use skeys on a server without a GUI?

skeys is a desktop application that requires a graphical interface. For servers, use command-line SSH tools.

### How do I contribute to skeys?

Visit the [GitHub repository](https://github.com/automationaddict/skeys) to:
- Report bugs
- Request features
- Submit pull requests
- Improve documentation

## Still Have Questions?

- Check the [Troubleshooting](skeys://help/troubleshooting) guide
- Read the [SSH Overview](skeys://help/ssh-overview) for SSH concepts
- Visit the [GitHub Issues](https://github.com/automationaddict/skeys/issues) page
- Press **F1** on any page for context-specific help
