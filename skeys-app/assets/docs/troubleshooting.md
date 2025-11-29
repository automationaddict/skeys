# Troubleshooting Guide

Solutions to common problems you might encounter while using skeys.

## Application Issues

### skeys Won't Start

**Symptoms**: Application doesn't launch, crashes on startup, or shows a blank window.

**Solutions**:

1. **Run from terminal to see errors**:
   ```bash
   # AppImage
   ./skeys-app-x86_64.AppImage

   # Installed package
   skeys-app
   ```

2. **Check for conflicting processes**:
   ```bash
   # See if another instance is running
   ps aux | grep skeys

   # Kill any hung processes
   killall skeys-app
   ```

3. **Reset application data**:
   ```bash
   # Backup first!
   cp -r ~/.config/skeys-app ~/.config/skeys-app.backup

   # Remove and restart
   rm -rf ~/.config/skeys-app
   ```

4. **Check permissions on SSH directory**:
   ```bash
   # Should be drwx------ (700)
   ls -la ~/.ssh

   # Fix if needed
   chmod 700 ~/.ssh
   ```

5. **Verify dependencies** (non-AppImage):
   ```bash
   # Ubuntu/Debian
   sudo apt-get install libgtk-3-0 libsecret-1-0

   # Fedora
   sudo dnf install gtk3 libsecret
   ```

### Application Freezes or Crashes

**Solutions**:

1. **Check system resources**:
   ```bash
   # View resource usage
   top
   # or
   htop
   ```

2. **Look for errors in system logs**:
   ```bash
   journalctl --user -xe | grep skeys
   ```

3. **Try resetting the window state**:
   ```bash
   rm ~/.config/skeys-app/window_state.json
   ```

4. **Update to the latest version** - Check the [releases page](https://github.com/automationaddict/skeys/releases)

### UI Elements Not Responding

**Solutions**:

1. **Toggle help panel** (F1) to refresh the UI
2. **Navigate to a different page** and back
3. **Restart the application**
4. **Check if running in Wayland** - some features work better on X11:
   ```bash
   # Force X11 mode
   GDK_BACKEND=x11 skeys-app
   ```

## SSH Key Issues

### Can't Generate SSH Key

**Symptoms**: "Generate Key" button doesn't work or shows errors.

**Solutions**:

1. **Check ssh-keygen is installed**:
   ```bash
   which ssh-keygen
   # Should show: /usr/bin/ssh-keygen

   # Install if missing
   sudo apt-get install openssh-client  # Ubuntu/Debian
   sudo dnf install openssh-clients      # Fedora
   ```

2. **Verify permissions on ~/.ssh**:
   ```bash
   chmod 700 ~/.ssh
   ```

3. **Check disk space**:
   ```bash
   df -h ~
   ```

4. **Try generating manually to see the error**:
   ```bash
   ssh-keygen -t ed25519 -C "test@example.com" -f ~/.ssh/test_key
   ```

### Key Not Showing in List

**Solutions**:

1. **Check key file location** - Keys must be in `~/.ssh/`
2. **Verify file permissions**:
   ```bash
   # Private keys should be -rw------- (600)
   chmod 600 ~/.ssh/id_*

   # Public keys should be -rw-r--r-- (644)
   chmod 644 ~/.ssh/id_*.pub
   ```

3. **Ensure key has matching .pub file** - skeys looks for pairs
4. **Refresh the key list** - Navigate away and back to SSH Keys page
5. **Check key format**:
   ```bash
   # Should show key type
   ssh-keygen -l -f ~/.ssh/id_ed25519
   ```

### Can't Delete SSH Key

**Symptoms**: Delete button disabled or operation fails.

**Solutions**:

1. **Remove key from agent first** - Can't delete keys that are loaded
2. **Check file permissions**:
   ```bash
   ls -l ~/.ssh/id_*
   # You should own the files
   ```

3. **Delete manually if needed**:
   ```bash
   rm ~/.ssh/id_keyname
   rm ~/.ssh/id_keyname.pub
   ```

## SSH Agent Issues

### Can't Add Key to Agent

**Symptoms**: "Add to Agent" fails or asks for passphrase repeatedly.

**Solutions**:

1. **Check if ssh-agent is running**:
   ```bash
   echo $SSH_AUTH_SOCK
   # Should show a path like /tmp/ssh-XXX/agent.12345
   ```

2. **Start ssh-agent if needed**:
   ```bash
   eval $(ssh-agent)
   ```

3. **Try adding manually to see the error**:
   ```bash
   ssh-add ~/.ssh/id_ed25519
   ```

4. **Verify passphrase** - Ensure you're entering the correct passphrase
5. **Check key file permissions** - Should be 600 (rw-------)

### Key Shows as Not in Agent But I Added It

**Solutions**:

1. **Refresh the agent view** - Navigate away and back
2. **Check with command line**:
   ```bash
   ssh-add -l
   ```

3. **The key might have expired** - Some keys have lifetime limits
4. **Agent might have restarted** - Keys are lost on agent restart

### Can't Remove Key from Agent

**Symptoms**: Remove button doesn't work or key remains loaded.

**Solutions**:

1. **Key might be loaded by another application** - skeys can only remove its own keys
2. **Try removing manually**:
   ```bash
   ssh-add -d ~/.ssh/id_ed25519
   ```

3. **Restart the ssh-agent**:
   ```bash
   # This removes ALL keys
   ssh-add -D
   ```

4. **Log out and back in** - This clears the agent completely

## Connection Issues

### "Connection Refused" Error

**Solutions**:

1. **Check if SSH server is running**:
   ```bash
   sudo systemctl status sshd
   # or
   sudo systemctl status ssh
   ```

2. **Start the server if stopped**:
   ```bash
   sudo systemctl start sshd
   ```

3. **Check if server is listening**:
   ```bash
   sudo netstat -tlnp | grep :22
   # or
   sudo ss -tlnp | grep :22
   ```

4. **Verify firewall isn't blocking**:
   ```bash
   # Ubuntu/Debian
   sudo ufw status
   sudo ufw allow 22/tcp

   # Fedora
   sudo firewall-cmd --list-all
   sudo firewall-cmd --add-service=ssh --permanent
   sudo firewall-cmd --reload
   ```

### "Permission Denied (publickey)" Error

**Solutions**:

1. **Ensure key is added to agent** - Go to [SSH Agent](skeys://help/agent)
2. **Verify public key is on the server**:
   ```bash
   ssh user@server "cat ~/.ssh/authorized_keys"
   # Should contain your public key
   ```

3. **Check server permissions**:
   ```bash
   # On the server
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/authorized_keys
   ```

4. **Test connection with verbose output**:
   ```bash
   ssh -vv user@server
   # Look for which key is being tried
   ```

5. **Verify the correct key is configured** in [Client Config](skeys://help/config-client)

### "Host Key Verification Failed" Error

**Solutions**:

1. **Host key has changed** - Could be legitimate or a security issue
2. **Verify the new fingerprint with server admin** - Critical step!
3. **Remove old key from known hosts**:
   ```bash
   ssh-keygen -R hostname
   # or use skeys Known Hosts page
   ```

4. **Reconnect and verify the new fingerprint**

## Server Configuration Issues

### Can't Edit Server Configuration

**Symptoms**: Save button disabled or changes don't persist.

**Solutions**:

1. **Server config requires sudo** - skeys will prompt for password
2. **Check file permissions**:
   ```bash
   ls -l /etc/ssh/sshd_config
   # Should be owned by root
   ```

3. **Verify you're in sudoers**:
   ```bash
   sudo -v
   ```

4. **Edit manually if needed**:
   ```bash
   sudo nano /etc/ssh/sshd_config
   # Then restart: sudo systemctl restart sshd
   ```

### Changes Don't Take Effect

**Solutions**:

1. **Restart SSH server after changes**:
   ```bash
   sudo systemctl restart sshd
   ```

2. **Check for syntax errors**:
   ```bash
   sudo sshd -t
   # Should show "config ok"
   ```

3. **Review server logs**:
   ```bash
   sudo journalctl -u sshd -xe
   ```

### Can't Start SSH Server

**Solutions**:

1. **Check for port conflicts**:
   ```bash
   sudo lsof -i :22
   # See what's using port 22
   ```

2. **Verify SSH is installed**:
   ```bash
   which sshd
   # Install if missing:
   sudo apt-get install openssh-server  # Ubuntu/Debian
   sudo dnf install openssh-server      # Fedora
   ```

3. **Check server logs for errors**:
   ```bash
   sudo journalctl -u sshd -n 50
   ```

4. **Test configuration**:
   ```bash
   sudo sshd -t
   ```

## Performance Issues

### Slow Application Startup

**Solutions**:

1. **Reduce number of keys** - Having many keys slows scanning
2. **Check for large known_hosts file**:
   ```bash
   wc -l ~/.ssh/known_hosts
   # If thousands of lines, consider cleaning up
   ```

3. **Disable automatic refresh** in settings (if available)
4. **Check system resources** - Ensure adequate RAM/CPU

### Slow Key Generation

**Solutions**:

1. **RSA 4096 is slower than Ed25519** - This is normal
2. **Check CPU usage** - Key generation is CPU-intensive
3. **Be patient** - Generating strong keys takes time

## File Permission Issues

### "Permission Denied" When Accessing SSH Files

**Solutions**:

1. **Fix ~/.ssh permissions**:
   ```bash
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/id_*
   chmod 644 ~/.ssh/id_*.pub
   chmod 600 ~/.ssh/config
   chmod 600 ~/.ssh/known_hosts
   chmod 600 ~/.ssh/authorized_keys
   ```

2. **Ensure you own the files**:
   ```bash
   ls -la ~/.ssh
   # Should show your username

   # Fix ownership if needed
   sudo chown -R $USER:$USER ~/.ssh
   ```

### Can't Save Configuration Files

**Solutions**:

1. **Client config** - Check `~/.ssh/config` permissions (should be 600)
2. **Server config** - Requires sudo, check you're in sudoers group
3. **Check disk space**:
   ```bash
   df -h ~
   ```

## Backup and Restore Issues

### Backup Fails to Create

**Solutions**:

1. **Check disk space**:
   ```bash
   df -h ~
   ```

2. **Verify permissions on source files** - All SSH files must be readable
3. **Choose a writable destination** - Ensure you can write to backup location
4. **Check for special characters** in filenames

### Restore Fails

**Solutions**:

1. **Verify backup file integrity**:
   ```bash
   file backup.tar.gz
   tar -tzf backup.tar.gz
   ```

2. **Ensure destination is writable**
3. **Back up current files first** before restoring
4. **Check for conflicts** - Files may already exist

## Getting More Help

### Enable Verbose Logging

For development or troubleshooting:

```bash
# Set debug environment variable
DEBUG=1 skeys-app

# Or check system logs
journalctl --user -f | grep skeys
```

### Collect Diagnostic Information

When reporting issues:

1. **skeys version**:
   - Check Settings → About

2. **System information**:
   ```bash
   uname -a
   cat /etc/os-release
   ```

3. **SSH version**:
   ```bash
   ssh -V
   ```

4. **Error messages** from terminal output

5. **Steps to reproduce** the problem

### Report Issues

- **GitHub Issues**: [github.com/automationaddict/skeys/issues](https://github.com/automationaddict/skeys/issues)
- Include diagnostic information above
- Sanitize any sensitive data (IPs, usernames, etc.)

## Related Topics

- [FAQ](skeys://help/faq) - Common questions
- [SSH Overview](skeys://help/ssh-overview) - Understanding SSH
- [Installation](skeys://help/install) - Install/uninstall guide
- [Quick Start](skeys://help/quick-start) - Getting started guide
