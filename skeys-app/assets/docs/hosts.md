# Host Management

## Overview

The Hosts screen manages two critical SSH security files: **known_hosts** (servers you trust) and **authorized_keys** (keys allowed to access your machine).

## Known Hosts

### What is known_hosts?

The `~/.ssh/known_hosts` file stores the public keys of servers you've connected to. When you first connect to a server, SSH asks you to verify its fingerprint. Once accepted, the key is saved to prevent man-in-the-middle attacks on future connections.

### Why It Matters

If a server's key changes unexpectedly, SSH warns you:

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```

This could indicate:
- The server was reinstalled
- The server's SSH keys were regenerated
- **A potential security breach (someone impersonating the server)**

### Managing Known Hosts

#### Viewing Entries
The Hosts tab shows all trusted servers with their key types (ED25519, RSA, ECDSA).

#### Removing Entries
Remove a host entry when:
- The server was legitimately reinstalled
- You no longer access that server
- The entry is outdated

Click the delete icon next to any entry to remove it.

#### Hashing Hosts
The **Hash All Hosts** button converts readable hostnames into hashed values. This provides privacy - if someone gains access to your known_hosts file, they cannot see which servers you connect to.

Hashed entries appear as `[HASHED]` in the list.

### Known Hosts Formats

**Plain format:**
```
github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...
```

**Hashed format:**
```
|1|base64hash|base64hash ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...
```

## Authorized Keys

### What is authorized_keys?

The `~/.ssh/authorized_keys` file lists public keys that are allowed to log into your account. When someone connects to your machine using SSH, their public key is checked against this file.

### When to Use Authorized Keys

- Allow remote access to your machine
- Set up automated systems (CI/CD, backups)
- Enable team members to access shared servers
- Configure passwordless authentication

### Managing Authorized Keys

#### Adding Keys
Add a public key to allow that key holder to SSH into your machine:
1. Obtain the user's public key (they can find it in SKeys)
2. Click **Add Key**
3. Paste the complete public key

#### Removing Keys
Remove a key to revoke access. The key holder will no longer be able to authenticate.

### Key Format

Authorized keys follow this format:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... user@hostname
```

The comment (e.g., `user@hostname`) helps identify whose key it is.

### Advanced Options

You can add restrictions before the key:

```
command="/usr/bin/backup",no-port-forwarding ssh-ed25519 AAAAC3...
```

Common restrictions:
- `command="..."` - Only allow specific commands
- `no-port-forwarding` - Disable port forwarding
- `no-X11-forwarding` - Disable X11 forwarding
- `no-agent-forwarding` - Disable agent forwarding
- `from="..."` - Only allow from specific IPs

## Security Best Practices

### Known Hosts
1. **Verify fingerprints** when first connecting to important servers
2. **Hash your known_hosts** for privacy
3. **Investigate warnings** about changed host keys
4. **Clean up** old entries periodically

### Authorized Keys
1. **Use unique keys** for each user/purpose
2. **Add comments** to identify key owners
3. **Review regularly** and remove unused keys
4. **Use restrictions** for automated/limited-access keys
5. **Never share private keys** - only add public keys

## File Locations

- Known hosts: `~/.ssh/known_hosts`
- Authorized keys: `~/.ssh/authorized_keys`

## Troubleshooting

### "Host key verification failed"
The server's key has changed. Verify with the server admin before removing the old entry.

### "Permission denied (publickey)"
Your public key isn't in the server's authorized_keys, or the key file has incorrect permissions.

### Too many entries in known_hosts
Use the Hash All Hosts feature, or manually clean up entries for servers you no longer access.
