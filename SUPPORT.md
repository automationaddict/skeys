# Support

This document provides help for common issues and questions about SKeys.

## Getting Help

1. **In-App Help**: Press the help button in any screen for context-aware documentation
2. **This Document**: Common issues and troubleshooting below
3. **GitHub Issues**: [Report bugs or request features](https://github.com/automationaddict/skeys/issues)
4. **README**: [Setup and installation guide](README.md)

---

## Quick Reference

### File Locations

| File | Purpose |
|------|---------|
| `~/.ssh/` | SSH directory (permissions: 0700) |
| `~/.ssh/config` | Client configuration |
| `~/.ssh/known_hosts` | Trusted server keys |
| `~/.ssh/authorized_keys` | Keys allowed to connect to this machine |
| `~/.ssh/id_*` | SSH key pairs |
| `~/.config/skeys/` | SKeys configuration and metadata |
| `~/.local/share/skeys/` | Application installation |

### Visual Indicators

| Icon | Meaning |
|------|---------|
| Green lock | Key has passphrase protection |
| Orange lock | Key has no passphrase |
| Blue shield | Key loaded in SSH agent |
| Orange warning | Key age exceeds warning threshold |
| Red pulsing | Key age exceeds critical threshold |

---

## Common Issues

### Authentication Problems

#### "Permission denied (publickey)"

**Cause**: Your public key is not in the server's `authorized_keys` file.

**Solutions**:
1. Copy your public key: Keys → select key → Copy Public Key
2. Add it to the server's `~/.ssh/authorized_keys`
3. Verify permissions on the server:
   ```bash
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/authorized_keys
   ```

#### "Too many authentication failures"

**Cause**: SSH is trying multiple keys before finding the right one.

**Solution**: Restrict which key is used for a host:
1. Go to Config → Client
2. Add or edit a Host block for your server
3. Set `IdentityFile` to the specific key
4. Enable `IdentitiesOnly yes`

#### "Could not open connection to agent"

**Cause**: SSH agent is not running or the socket path is incorrect.

**Solutions**:
1. Check agent status in the Agent screen
2. Verify SKeys is configured as your SSH agent:
   - Settings → Security → Enable "Use skeys for SSH"
3. Restart the SKeys daemon:
   ```bash
   systemctl --user restart skeys-daemon
   ```

#### Key works in terminal but not in other apps

**Cause**: Other applications may not be using the SKeys agent.

**Solution**: Ensure `SSH_AUTH_SOCK` points to the SKeys agent:
1. Settings → Security → Enable "Use skeys for SSH"
2. Log out and back in for environment changes to take effect
3. Verify with: `echo $SSH_AUTH_SOCK`

### Key Management Issues

#### "No verified service found" when testing connection

**Cause**: The key was added to the agent without service verification.

**Solution**:
1. Remove the key from the agent
2. Re-add it with service verification:
   - Keys → select key → Add to Agent
   - Choose or enter the service (GitHub, GitLab, etc.)
   - Complete verification

#### Key not appearing in list

**Cause**: Key may not be in `~/.ssh/` or has incorrect naming.

**Solutions**:
1. Verify key exists: `ls -la ~/.ssh/`
2. Keys must have standard naming (no spaces or special characters)
3. Both private key and `.pub` file should exist

#### Passphrase not accepted

**Cause**: Incorrect passphrase or corrupted key file.

**Solutions**:
1. Verify you're using the correct passphrase
2. Test in terminal: `ssh-keygen -y -f ~/.ssh/keyname`
3. If key is corrupted, restore from backup

### Host Key Issues

#### "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED"

**Cause**: The server's SSH key has changed since you last connected.

**This could indicate**:
- Server was reinstalled or reconfigured (legitimate)
- Man-in-the-middle attack (security risk)

**Solution**:
1. Verify with the server administrator that the key change is legitimate
2. If legitimate, remove the old entry:
   - Hosts → Known Hosts → find and remove the entry
3. Reconnect to accept the new key

#### Unknown host warning on first connection

**Cause**: Normal behavior - SSH doesn't recognize the server yet.

**Solution**:
1. Verify the fingerprint with the server administrator
2. Accept the key to add it to known_hosts
3. Future connections will be verified automatically

### SSH Config Issues

#### Host settings not being applied

**Cause**: SSH config uses first-match ordering.

**Solutions**:
1. Check host pattern matches your hostname
2. Move more specific patterns above general ones:
   - Config → Client → drag to reorder
3. Use exact hostnames before wildcards

#### "Bad configuration option" error

**Cause**: Invalid option in SSH config.

**Solution**:
1. Config → Client → edit the problematic host
2. Remove or correct the invalid option
3. Common issues: typos, deprecated options, wrong value types

### Connection Issues

#### Connection timeout

**Causes**: Network issues, firewall blocking, or server down.

**Solutions**:
1. Test basic connectivity: `ping hostname`
2. Test SSH port: `nc -zv hostname 22`
3. Check firewall allows outbound SSH (port 22)
4. Try with verbose output: `ssh -v hostname`

#### Connection drops after inactivity

**Cause**: Network equipment or server closing idle connections.

**Solution**: Add keep-alive settings:
1. Config → Client → Global or specific host
2. Add: `ServerAliveInterval 60`
3. Add: `ServerAliveCountMax 3`

#### Jump host / bastion not working

**Cause**: ProxyJump not configured correctly.

**Solutions**:
1. Verify you can connect to the jump host directly
2. Config → Client → edit target host
3. Set `ProxyJump jumphost` (or `ProxyJump user@jumphost:port`)
4. Ensure keys for both hosts are available

### Agent Issues

#### Keys disappear from agent

**Cause**: Agent timeout or system restart.

**Solutions**:
1. Check timeout setting: Settings → Security → Agent Key Timeout
2. Increase timeout or set to "No Timeout"
3. Re-add keys after restart

#### Agent locked

**Cause**: Agent was locked with a passphrase.

**Solution**:
1. Agent → Unlock Agent
2. Enter the lock passphrase
3. If forgotten, restart the agent (keys will need to be re-added)

### Backup & Restore Issues

#### Can't restore backup

**Causes**: Wrong passphrase, corrupted file, or incompatible version.

**Solutions**:
1. Verify you're using the correct passphrase
2. Ensure the `.skbak` file is not corrupted
3. Check file permissions on the backup file

#### Restored keys don't work

**Cause**: Keys need to be re-added to the agent after restore.

**Solution**:
1. Keys are restored to `~/.ssh/`
2. Add them to the agent: Keys → select key → Add to Agent
3. Test connections

### Update Issues

#### Update check fails

**Cause**: No internet connectivity or GitHub API unreachable.

**Solutions**:
1. Verify network connectivity
2. Check if you can reach github.com
3. View daemon logs for details:
   ```bash
   journalctl --user -u skeys-daemon -f
   ```

#### Update installation fails

**Causes**: Permission issues, disk space, or app still running.

**Solutions**:
1. Close the SKeys application
2. Check available disk space
3. Verify write permissions to `~/.local/share/skeys/`
4. Try manual installation from [Releases](https://github.com/automationaddict/skeys/releases)

---

## Logs & Debugging

### Viewing Logs

```bash
# Daemon logs
journalctl --user -u skeys-daemon -f

# Recent logs
journalctl --user -u skeys-daemon --since "1 hour ago"

# All SKeys logs
journalctl --user -u skeys-daemon -u skeys-update
```

### Adjusting Log Level

1. Settings → Logging → Log Level
2. Set to "Debug" or "Trace" for detailed output
3. Reproduce the issue
4. Check logs for details
5. Reset to "Info" when done

### Service Status

```bash
# Check daemon status
systemctl --user status skeys-daemon

# Restart daemon
systemctl --user restart skeys-daemon

# Check update timer
systemctl --user status skeys-update.timer
```

---

## Security Best Practices

### Key Management

- Use ED25519 keys (modern, secure, fast)
- Always set a passphrase on private keys
- Rotate keys periodically (configure reminders in Settings)
- Use different keys for different purposes/servers

### Agent Security

- Set reasonable key timeouts (don't leave keys loaded indefinitely)
- Be cautious with agent forwarding (only to trusted servers)
- Lock the agent when stepping away

### SSH Config

- Use `IdentitiesOnly yes` to prevent key enumeration
- Set `HashKnownHosts yes` for privacy
- Use `StrictHostKeyChecking ask` (not `no`)

### Backups

- Use strong, unique passphrases for backups
- Store backups securely (encrypted storage)
- Delete backup files after restoring
- Never share backup files or passphrases

---

## Frequently Asked Questions

### Can I use SKeys alongside other SSH agents?

Yes, but only one agent can be active at a time. SKeys manages its own agent at `/run/user/$UID/skeys-agent.sock`. Enable "Use skeys for SSH" in Settings to make it your default.

### Does SKeys work with hardware keys (YubiKey)?

Yes. SKeys supports ED25519-SK and ECDSA-SK key types for FIDO2 hardware keys. Note that hardware keys cannot be backed up - they exist only on the physical device.

### Where is my data stored?

- SSH keys: `~/.ssh/`
- SKeys metadata: `~/.config/skeys/`
- Application: `~/.local/share/skeys/`
- Logs: systemd journal (`journalctl --user -u skeys-daemon`)

### Can I use SKeys on multiple machines?

Yes. Use the backup/restore feature to transfer your SSH configuration between machines. Keys are encrypted with your chosen passphrase during backup.

### Does SKeys phone home or collect telemetry?

No. SKeys has no telemetry, analytics, or network communication except:
- GitHub API for update checks (optional, can be disabled)
- SSH connections you explicitly initiate

### How do I completely remove SKeys?

Run the uninstaller:
```bash
~/.local/share/skeys/uninstall.sh
```

This removes all installed files. Add `--purge` to also remove configuration and cache.

---

## Still Need Help?

If your issue isn't covered here:

1. Search [existing issues](https://github.com/automationaddict/skeys/issues)
2. Open a [new issue](https://github.com/automationaddict/skeys/issues/new/choose) with:
   - SKeys version (Settings → About)
   - Linux distribution and version
   - Steps to reproduce
   - Relevant log output
