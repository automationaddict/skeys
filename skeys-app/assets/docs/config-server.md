# SSH Server Configuration

## Overview

The Server Config tab displays the SSH daemon (sshd) configuration. This controls how your machine accepts incoming SSH connections, including authentication methods, security settings, and access controls.

**Note:** Server configuration requires root/sudo access to modify and typically requires restarting the SSH service for changes to take effect.

## What is sshd_config?

The SSH daemon configuration file (`/etc/ssh/sshd_config`) controls:

- Who can connect to your machine via SSH
- Which authentication methods are allowed
- Security restrictions and hardening options
- Port and network settings
- Logging and auditing

## Common Options

### Authentication Settings

| Option | Description | Recommended |
|--------|-------------|-------------|
| `PermitRootLogin` | Allow root SSH login | `no` or `prohibit-password` |
| `PubkeyAuthentication` | Allow public key auth | `yes` |
| `PasswordAuthentication` | Allow password auth | `no` (use keys) |
| `PermitEmptyPasswords` | Allow empty passwords | `no` |
| `ChallengeResponseAuthentication` | Allow challenge-response | `no` |

### Security Settings

| Option | Description | Recommended |
|--------|-------------|-------------|
| `Protocol` | SSH protocol version | `2` |
| `X11Forwarding` | Allow X11 forwarding | `no` (unless needed) |
| `AllowTcpForwarding` | Allow TCP forwarding | `no` (unless needed) |
| `MaxAuthTries` | Max auth attempts | `3` |
| `LoginGraceTime` | Time for login (seconds) | `60` |

### Access Control

| Option | Description | Example |
|--------|-------------|---------|
| `AllowUsers` | Users allowed to connect | `admin deploy` |
| `AllowGroups` | Groups allowed to connect | `ssh-users` |
| `DenyUsers` | Users denied access | `guest` |
| `DenyGroups` | Groups denied access | `noremote` |

### Network Settings

| Option | Description | Default |
|--------|-------------|---------|
| `Port` | SSH listening port | `22` |
| `ListenAddress` | IP addresses to bind | `0.0.0.0` |
| `AddressFamily` | IP version | `any` |

## Security Best Practices

1. **Disable password authentication** - Use SSH keys only
   ```
   PasswordAuthentication no
   ```

2. **Disable root login** - Use a regular user with sudo
   ```
   PermitRootLogin no
   ```

3. **Use SSH protocol 2 only**
   ```
   Protocol 2
   ```

4. **Limit authentication attempts**
   ```
   MaxAuthTries 3
   ```

5. **Restrict user access**
   ```
   AllowUsers admin deploy
   ```

6. **Change default port** (optional, security through obscurity)
   ```
   Port 2222
   ```

## Applying Changes

After modifying `/etc/ssh/sshd_config`:

1. **Test configuration** (important!)
   ```
   sudo sshd -t
   ```

2. **Restart SSH service**
   ```
   sudo systemctl restart sshd
   # or
   sudo service ssh restart
   ```

**Warning:** Always keep an existing SSH session open when making changes, in case the new configuration locks you out.

## File Location

- Server config: `/etc/ssh/sshd_config`
- Drop-in configs: `/etc/ssh/sshd_config.d/`
