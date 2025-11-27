# SSH Client Configuration

## Overview

The Client Config screen allows you to manage your SSH client configuration (`~/.ssh/config`). This screen has two sections:

1. **Global Settings** - Options that apply to all SSH connections
2. **Host Configurations** - Settings for specific hosts or host patterns

## Screen Layout

### Global Settings

The collapsible Global Settings card at the top displays directives that apply to all SSH connections unless overridden by a host-specific configuration.

**To add a global directive:**
1. Click the **+** button in the Global Settings header
2. Select from common presets (e.g., HashKnownHosts, AddKeysToAgent) or enter a custom directive
3. Set the value and click **Add**

**To edit or delete a directive:**
- Click on any directive to edit it
- Use the menu (three dots) to edit or delete

### Host Configurations

Below Global Settings, you'll see your configured hosts. SSH uses a "first match wins" approach, so the order matters.

**To add a new host:**
1. Click the **Add Host** button
2. Choose the entry type (Host or Match block)
3. Enter the host pattern(s) and options
4. Click **Save**

**To reorder hosts:**
- Drag hosts using the handle on the left to change their priority

**To edit or delete a host:**
- Click on any host to edit it
- Use the menu (three dots) to edit or delete

## Understanding SSH Config

### Global Directives

Global directives appear at the top of your SSH config file, before any Host blocks. They set default behavior for all connections.

Common global directives:

| Directive | Description | Example Values |
|-----------|-------------|----------------|
| `HashKnownHosts` | Hash hostnames in known_hosts for privacy | `yes`, `no` |
| `AddKeysToAgent` | Auto-add keys to ssh-agent | `yes`, `no`, `confirm` |
| `IdentitiesOnly` | Only use explicitly configured keys | `yes`, `no` |
| `ServerAliveInterval` | Send keepalive every N seconds | `60` |
| `ServerAliveCountMax` | Max keepalive failures before disconnect | `3` |
| `Compression` | Enable compression for slow networks | `yes`, `no` |
| `StrictHostKeyChecking` | How to handle unknown host keys | `yes`, `no`, `ask` |

### Host Blocks

Each host configuration starts with a `Host` directive followed by a pattern:

```
Host myserver
    HostName server.example.com
    User admin
    Port 22
    IdentityFile ~/.ssh/myserver_key
```

Now you can connect with just: `ssh myserver`

### Match Blocks

Match blocks provide conditional configuration based on various criteria:

```
Match host *.internal.example.com
    ProxyJump bastion
    User deploy
```

### Pattern Matching

- `*` - Matches any sequence of characters
- `?` - Matches exactly one character
- `!` - Negates the pattern

Example patterns:
- `Host *` - Matches all hosts (catch-all defaults)
- `Host *.example.com` - Matches any subdomain
- `Host server-?` - Matches server-1, server-2, etc.

## Host Configuration Options

### Basic Options

| Option | Description |
|--------|-------------|
| **Patterns** | Host aliases or patterns this block applies to |
| **Hostname** | Actual server address (IP or domain) |
| **User** | Login username |
| **Port** | SSH port (default: 22) |
| **IdentityFile** | Private key to use for authentication |

### Connection Options

| Option | Description |
|--------|-------------|
| **ProxyJump** | Jump through another host (bastion) |
| **ProxyCommand** | Custom proxy command |
| **ServerAliveInterval** | Keepalive interval in seconds |
| **ServerAliveCountMax** | Max missed keepalives |

### Security Options

| Option | Description |
|--------|-------------|
| **ForwardAgent** | Forward SSH agent to remote host |
| **IdentitiesOnly** | Only use specified identity files |
| **StrictHostKeyChecking** | Host key verification behavior |
| **Compression** | Enable/disable compression |

### Advanced Options

Click **Show Advanced Options** in the dialog to access additional settings or add custom options not listed above.

## Example Configurations

### GitHub/GitLab with Specific Keys

```
Host github.com
    User git
    IdentityFile ~/.ssh/github_key
    IdentitiesOnly yes

Host gitlab.com
    User git
    IdentityFile ~/.ssh/gitlab_key
    IdentitiesOnly yes
```

### Jump Host (Bastion Server)

```
Host bastion
    HostName bastion.example.com
    User admin
    IdentityFile ~/.ssh/bastion_key

Host internal-*
    ProxyJump bastion
    User deploy
```

### Multiple Identities for Same Host

```
Host work-github
    HostName github.com
    User git
    IdentityFile ~/.ssh/work_key

Host personal-github
    HostName github.com
    User git
    IdentityFile ~/.ssh/personal_key
```

## Best Practices

1. **Use global defaults wisely** - Set `ServerAliveInterval` and `AddKeysToAgent` globally
2. **Order matters** - Put specific host patterns before wildcards (first match wins)
3. **Use specific keys per host** - Set `IdentitiesOnly yes` to prevent key enumeration
4. **Use the Key Picker** - Click the key icon when editing IdentityFile to select from your managed keys
5. **Create meaningful aliases** - Use short, memorable names for frequently accessed servers

## Troubleshooting

### "Too many authentication failures"
SSH tried too many keys before finding the right one. Solution:
- Add `IdentitiesOnly yes` to your global settings or specific hosts
- Ensure the correct `IdentityFile` is specified

### Connection timeouts
Add keepalive settings to maintain connections:
- Set global `ServerAliveInterval` to `60`
- Set global `ServerAliveCountMax` to `3`

### Wrong key being used
- Verify `IdentityFile` path is correct
- Enable `IdentitiesOnly` to prevent SSH from trying other keys
- Check host pattern order (first match wins)

### Host not matching expected config
Remember: SSH uses **first match wins**. If a more general pattern (like `Host *`) appears before your specific host, it will match first. Drag entries to reorder them.

## File Location

- User config: `~/.ssh/config`
- System-wide: `/etc/ssh/ssh_config` (read-only defaults)

Changes made in skeys are saved to your user config file and take effect on the next SSH connection.
