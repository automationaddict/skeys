# Authorized Keys

## Overview

The Authorized Keys tab manages your `~/.ssh/authorized_keys` file, which controls who can SSH into your machine. Each entry is a public key that grants its owner access to your account.

## How It Works

When someone tries to SSH into your machine:

1. Their SSH client presents their public key
2. Your SSH server checks if that key is in `~/.ssh/authorized_keys`
3. If found, they're challenged to prove they have the matching private key
4. If they pass, they're granted access

This enables passwordless, secure authentication.

## When to Use Authorized Keys

- **Remote access** - Allow yourself to SSH from other machines
- **Team access** - Grant colleagues access to shared servers
- **Automation** - Enable CI/CD systems, backup scripts, or monitoring tools
- **Git hosting** - Services like GitHub/GitLab use this for repository access

## Managing Authorized Keys

### Viewing Keys

Each entry shows:
- **Comment** - Usually identifies the key owner (e.g., `user@laptop`)
- **Key Type** - ED25519, RSA, ECDSA, or other algorithm

### Adding Keys

To allow someone to access your machine:

1. Obtain their **public key** (they can export it from SKeys)
2. Add it to your authorized_keys file
3. They can now SSH in using their corresponding private key

**Important:** Only add public keys you trust. Anyone with a matching private key can access your account.

### Removing Keys

Click the delete icon to revoke access. The key holder will immediately lose the ability to authenticate with that key.

Remove keys when:
- An employee leaves your organization
- A device is lost or compromised
- Access is no longer needed
- You're rotating keys for security

## Key Format

Standard format:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... user@hostname
```

Components:
- **Key type** - Algorithm (ssh-ed25519, ssh-rsa, etc.)
- **Public key** - Base64-encoded key data
- **Comment** - Optional identifier (recommended)

## Advanced Options

You can add restrictions before the key to limit what it can do:

```
command="/usr/bin/backup",no-port-forwarding ssh-ed25519 AAAAC3...
```

### Common Restrictions

| Option | Effect |
|--------|--------|
| `command="..."` | Only allow running specific commands |
| `no-port-forwarding` | Disable port forwarding |
| `no-X11-forwarding` | Disable X11 forwarding |
| `no-agent-forwarding` | Disable agent forwarding |
| `no-pty` | Disable terminal allocation |
| `from="..."` | Only allow from specific IPs/hostnames |
| `expiry-time="..."` | Key expires after specified date |

### Example: Backup-only Access

```
command="/usr/local/bin/backup-script",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-ed25519 AAAAC3... backup@server
```

This key can only run the backup script and nothing else.

### Example: IP Restriction

```
from="192.168.1.0/24,10.0.0.5" ssh-ed25519 AAAAC3... admin@office
```

This key only works from the specified IP addresses.

## Security Best Practices

1. **Use unique keys** - Each user/device should have their own key pair
2. **Add meaningful comments** - Include owner name and device for identification
3. **Review regularly** - Audit your authorized_keys periodically
4. **Remove promptly** - Revoke access immediately when no longer needed
5. **Use restrictions** - Limit capabilities for automated/service accounts
6. **Never share private keys** - Only distribute public keys
7. **Protect the file** - Ensure correct permissions (600 or 644)

## Troubleshooting

### "Permission denied (publickey)"

The key isn't authorized or there's a configuration issue:
- Verify the public key is correctly added to authorized_keys
- Check file permissions: `~/.ssh` should be 700, `authorized_keys` should be 600 or 644
- Ensure the key type is enabled in sshd_config
- Check SSH server logs for details

### Key works but restrictions don't apply

Restrictions must be on the same line, before the key type:
```
# Correct:
command="/bin/date" ssh-ed25519 AAAAC3...

# Wrong (restrictions on separate line):
command="/bin/date"
ssh-ed25519 AAAAC3...
```

### Can't remove a key

If the key appears locked or removal fails, check that:
- You have write permission to `~/.ssh/authorized_keys`
- No other process is locking the file
- The SSH daemon isn't caching the file

## File Location

`~/.ssh/authorized_keys`

This file must have restricted permissions (600 or 644) or SSH will refuse to use it.
