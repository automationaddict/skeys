# Remote Servers

## Overview

The Remotes screen enables you to manage SSH keys and configurations on remote servers. Connect to servers and perform key management operations without leaving SKeys.

## What Can You Do?

### Remote Key Management
- View SSH keys on remote servers
- Generate new keys directly on remote systems
- Copy keys between local and remote machines
- Delete keys from remote servers

### Remote Configuration
- View and edit SSH configs on remote servers
- Manage authorized_keys remotely
- Configure remote known_hosts

## Connecting to Servers

### Adding a Remote Connection

1. Click **Add Remote**
2. Enter the connection details:
   - **Host**: Server address or SSH config alias
   - **User**: Your username on the server
   - **Port**: SSH port (default: 22)
3. Select the authentication method:
   - **Key**: Use an SSH key from your local machine
   - **Agent**: Use keys loaded in your SSH agent

### Connection Requirements

The remote server must have:
- SSH access enabled
- Your public key in `authorized_keys` (or password authentication)
- Appropriate permissions on `~/.ssh` directory

## Key Operations

### Pushing Keys to Remote

Deploy your local public key to a remote server's `authorized_keys`:

1. Select a local key
2. Choose a remote server
3. Click **Push Key**

This grants you future access using that key.

### Pulling Keys from Remote

Copy a remote server's public key to your local machine:

1. Connect to the remote server
2. Select the key to copy
3. Click **Pull Key**

### Generating Remote Keys

Create new SSH keys directly on the remote server:

1. Connect to the remote server
2. Click **Generate Key**
3. Configure key options (type, name, passphrase)

Useful for:
- Server-to-server authentication
- Git deployment keys
- Service account keys

## Use Cases

### Setting Up New Server Access

1. Generate a local key (or use existing)
2. Add the remote server connection
3. Push your public key to the server
4. Verify access works

### Server Migration

1. Connect to the old server
2. View/export its keys and config
3. Connect to the new server
4. Recreate or copy the necessary keys

### Team Onboarding

1. Collect team members' public keys
2. Connect to shared servers
3. Add each key to authorized_keys

### Revoking Access

1. Connect to the remote server
2. Navigate to authorized_keys
3. Remove the appropriate public key

## Jump Hosts (Bastion Servers)

For servers behind firewalls, configure jump hosts:

```
Host internal
    HostName 10.0.0.50
    User deploy
    ProxyJump bastion
```

SKeys will automatically route through the bastion server.

## Security Considerations

### Principle of Least Privilege
- Only push keys to servers you need to access
- Use separate keys for different security levels
- Remove access promptly when no longer needed

### Audit Trail
- Track which keys are deployed where
- Regularly review authorized_keys on critical servers
- Document the purpose of each deployed key

### Key Rotation
- Periodically generate new keys
- Update authorized_keys across servers
- Remove old keys after transition

## Connection Pooling

SKeys maintains connection pools for efficiency:
- Connections are reused for multiple operations
- Idle connections are cleaned up automatically
- Failed connections are retried with backoff

## Troubleshooting

### Connection Refused
- Verify the server address and port
- Check if SSH is running on the server
- Ensure firewall allows SSH traffic

### Authentication Failed
- Verify your key is in the server's authorized_keys
- Check key permissions on both ends
- Try adding the key to your agent first

### Permission Denied on Remote Operations
- Check file permissions on remote `~/.ssh`
- Verify you have write access for modifications
- Some operations require root/sudo

### Timeout Issues
- Check network connectivity
- Verify jump host configuration if applicable
- Consider connection keep-alive settings

## Best Practices

1. **Use key-based auth** - More secure than passwords
2. **Label remote connections** - Use descriptive names
3. **Regular audits** - Review remote authorized_keys periodically
4. **Document deployments** - Track where keys are pushed
5. **Test after changes** - Verify access still works

## Connection Limits

- Maximum concurrent connections: 10
- Idle timeout: 10 minutes
- Keep-alive interval: 30 seconds

These can be adjusted in advanced settings if needed.
