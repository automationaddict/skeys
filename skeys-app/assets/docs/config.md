# SSH Configuration

## Overview

The Config screen allows you to view and manage your SSH client configuration. This configuration controls how SSH connects to remote servers, including host aliases, connection options, and authentication settings.

## What is SSH Config?

The SSH config file (`~/.ssh/config`) lets you:

- Create aliases for frequently accessed servers
- Set default options for specific hosts
- Configure jump hosts (bastion servers)
- Specify which keys to use for which servers
- Set connection timeouts and keep-alive settings

## Configuration Structure

### Host Blocks

Each server configuration starts with a `Host` directive:

```
Host myserver
    HostName server.example.com
    User admin
    Port 22
    IdentityFile ~/.ssh/myserver_key
```

Now you can connect with just: `ssh myserver`

### Wildcards

Use `*` to set defaults for all connections:

```
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

## Common Options

### Connection Settings

| Option | Description | Example |
|--------|-------------|---------|
| `HostName` | Actual server address | `192.168.1.100` |
| `User` | Login username | `admin` |
| `Port` | SSH port | `22` |
| `IdentityFile` | Private key to use | `~/.ssh/id_ed25519` |

### Security Options

| Option | Description | Example |
|--------|-------------|---------|
| `IdentitiesOnly` | Only use specified keys | `yes` |
| `PreferredAuthentications` | Auth methods to try | `publickey` |
| `StrictHostKeyChecking` | Verify host keys | `ask` |

### Performance Options

| Option | Description | Example |
|--------|-------------|---------|
| `Compression` | Enable compression | `yes` |
| `ServerAliveInterval` | Keep-alive interval (seconds) | `60` |
| `ServerAliveCountMax` | Max missed keep-alives | `3` |
| `ConnectionAttempts` | Retry attempts | `3` |

### Proxy/Jump Host Options

| Option | Description | Example |
|--------|-------------|---------|
| `ProxyJump` | Jump through another host | `bastion` |
| `ProxyCommand` | Custom proxy command | `ssh -W %h:%p bastion` |

## Example Configurations

### GitHub/GitLab

```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_key
    IdentitiesOnly yes

Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/gitlab_key
    IdentitiesOnly yes
```

### Jump Host (Bastion)

```
Host bastion
    HostName bastion.example.com
    User admin
    IdentityFile ~/.ssh/bastion_key

Host internal-server
    HostName 10.0.0.50
    User deploy
    ProxyJump bastion
    IdentityFile ~/.ssh/internal_key
```

### Multiple Keys for Same Host

```
Host work-github
    HostName github.com
    User git
    IdentityFile ~/.ssh/work_github

Host personal-github
    HostName github.com
    User git
    IdentityFile ~/.ssh/personal_github
```

## Managing Configuration

### Viewing Options
The Config screen displays all host configurations with their associated options. Click on a host to see its full configuration.

### Editing
Configuration can be edited directly in the `~/.ssh/config` file. Changes take effect on the next SSH connection.

## Best Practices

1. **Use specific keys per host** with `IdentitiesOnly yes`
2. **Set sensible timeouts** to detect dropped connections
3. **Use jump hosts** for accessing internal networks
4. **Create aliases** for frequently accessed servers
5. **Comment your config** for future reference

## Troubleshooting

### "Too many authentication failures"
Add `IdentitiesOnly yes` to prevent SSH from trying all keys.

### Connection timeouts
Add keep-alive settings:
```
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

### Key not being used
Ensure `IdentityFile` path is correct and the key exists.

## File Location

- Client config: `~/.ssh/config`
- System-wide: `/etc/ssh/ssh_config`
