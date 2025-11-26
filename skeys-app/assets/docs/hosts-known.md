# Known Hosts

## Overview

The Known Hosts tab manages your `~/.ssh/known_hosts` file, which stores the public keys of SSH servers you've connected to. This is a critical security feature that protects you from man-in-the-middle attacks.

## How It Works

When you first connect to an SSH server, you see a prompt like:

```
The authenticity of host 'example.com (192.168.1.1)' can't be established.
ED25519 key fingerprint is SHA256:abc123...
Are you sure you want to continue connecting (yes/no)?
```

When you answer "yes", the server's public key is saved to your known_hosts file. On subsequent connections, SSH automatically verifies the server presents the same key.

## Why It Matters

If a server's key changes unexpectedly, SSH displays a warning:

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```

This could indicate:
- The server was reinstalled or upgraded
- The server's SSH keys were regenerated
- **A potential security breach (someone impersonating the server)**

Always verify with the server administrator before accepting a changed key.

## Managing Known Hosts

### Viewing Entries

Each entry shows:
- **Hostname** - The server address (or `[HASHED]` if privacy-protected)
- **Key Type** - ED25519, RSA, ECDSA, or other algorithm

### Removing Entries

Click the delete icon to remove a host entry. Do this when:
- The server was legitimately reinstalled
- You no longer access that server
- You need to accept a new key from the server

After removing an entry, the next connection will prompt you to verify the server's key again.

### Hashing Hosts

The **Hash All Hosts** button converts readable hostnames into cryptographic hashes. This provides privacy - if someone gains access to your known_hosts file, they cannot see which servers you connect to.

Hashed entries appear as `[HASHED]` in the list. You can still connect to these servers normally.

## Entry Formats

**Plain format:**
```
github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...
192.168.1.100 ssh-rsa AAAAB3NzaC1yc2EAAAA...
```

**Hashed format:**
```
|1|base64salt|base64hash ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...
```

**With port:**
```
[example.com]:2222 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...
```

## Key Types

- **ED25519** - Modern, secure, recommended
- **ECDSA** - Elliptic curve, widely supported
- **RSA** - Legacy, still common on older servers
- **DSA** - Deprecated, should not be used

## Security Best Practices

1. **Verify fingerprints** when first connecting to important servers
2. **Hash your known_hosts** for privacy protection
3. **Investigate warnings** about changed host keys thoroughly
4. **Clean up** old entries for servers you no longer access
5. **Never blindly accept** changed host keys

## Troubleshooting

### "Host key verification failed"

The server's key doesn't match what's stored. Either:
1. The server's key legitimately changed - verify with admin, then remove the old entry
2. Someone is attempting a man-in-the-middle attack - do not connect

### "Known hosts file corrupt"

The file may have been incorrectly edited. SKeys can help by removing problematic entries.

### Too many entries

Over time, the file can grow large. Use Hash All Hosts for privacy, and periodically remove entries for servers you no longer access.

## File Location

`~/.ssh/known_hosts`

This file is automatically created when you first accept a server's key.
