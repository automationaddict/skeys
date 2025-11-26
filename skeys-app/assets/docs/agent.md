# SSH Agent

## Overview

The Agent screen lets you manage the SSH authentication agent - a program that holds your private keys in memory so you don't have to enter passphrases repeatedly.

## What is the SSH Agent?

The SSH agent is a background process that:

- Stores decrypted private keys in memory
- Responds to authentication requests from SSH clients
- Eliminates the need to type passphrases for every connection
- Securely forwards your authentication to remote servers

## How It Works

```
┌─────────────┐     ┌───────────┐     ┌──────────────┐
│ SSH Client  │────>│ SSH Agent │────>│ Remote Server│
│             │     │ (has keys)│     │              │
└─────────────┘     └───────────┘     └──────────────┘
```

1. You add a key to the agent (entering passphrase once)
2. SSH client asks agent to authenticate
3. Agent signs the challenge with your private key
4. Server verifies and grants access

The private key never leaves your machine - only signatures are transmitted.

## Managing Keys in the Agent

### Adding Keys
Load a key into the agent to use it for authentication without entering its passphrase each time.

1. Select a key from the list
2. Click **Add to Agent**
3. Enter the passphrase if the key is encrypted

### Removing Keys
Remove keys from the agent when:
- You're finished working for the day
- Using a shared computer
- Reducing exposure of sensitive keys

### Key Timeout
SKeys can automatically remove keys from the agent after a specified time. Configure this in **Settings > Security > SSH Agent Timeout**.

- **No timeout**: Keys remain until agent restarts or manually removed
- **Timed**: Keys automatically removed after the specified duration (10 minutes to 8 hours)

The current timeout setting is displayed in the **Actions** card on this screen.

**Note:** The timeout applies when keys are added to the agent via SKeys. Keys added externally (e.g., via command line) may not have a timeout.

## Agent Forwarding

Agent forwarding allows you to use your local keys on remote servers without copying private keys.

### How Agent Forwarding Works

```
┌──────────┐     ┌────────────┐     ┌────────────┐
│  Local   │────>│  Server A  │────>│  Server B  │
│ Machine  │     │ (forwards) │     │            │
│ (agent)  │<────│            │<────│            │
└──────────┘     └────────────┘     └────────────┘
```

Your local agent handles authentication even when you're logged into Server A and connecting to Server B.

### Enabling Agent Forwarding

In `~/.ssh/config`:
```
Host jumpserver
    ForwardAgent yes
```

Or use `-A` flag:
```
ssh -A user@jumpserver
```

### Security Warning

Only enable agent forwarding to trusted servers. A compromised server with forwarding enabled can use your keys for the duration of your session.

## Agent Types

### SSH Agent (ssh-agent)
The standard OpenSSH agent. Started automatically on most systems.

### GNOME Keyring
Integrates with the GNOME desktop, providing a graphical interface for managing keys.

### GPG Agent
Can serve as an SSH agent, useful if you also use GPG keys.

## Best Practices

### Security

1. **Don't forward to untrusted servers** - Agent forwarding exposes your keys
2. **Set a key timeout** in Settings > Security for automatic key removal
3. **Lock/remove keys** when stepping away
4. **Use separate keys** for high-security servers

### Convenience

1. **Add frequently-used keys** at login
2. **Use SSH config** to specify which keys for which hosts
3. **Configure agent startup** in your shell profile

## Common Agent Tasks

### Check Loaded Keys
View which keys are currently in the agent.

### Clear All Keys
Remove all keys from the agent. Useful when:
- Switching contexts (work to personal)
- Before leaving your computer
- After completing sensitive work

### Add Key with Timeout
Add a key that automatically removes itself after a specified time.

## Troubleshooting

### "Could not open connection to agent"
The agent isn't running. Start it with:
```bash
eval $(ssh-agent)
```

### Key not being used despite being in agent
Check `IdentitiesOnly` in SSH config - it may be restricting which keys are offered.

### "Agent refused operation"
The key might be locked or the agent may have restrictions. Try removing and re-adding the key.

### Agent forwarding not working
1. Ensure `AllowAgentForwarding yes` on the server
2. Check `ForwardAgent yes` in your config
3. Verify the agent socket path is correct

## Environment Variables

- `SSH_AUTH_SOCK` - Path to the agent socket
- `SSH_AGENT_PID` - Process ID of the agent

## File Locations

- Agent socket: Usually in `/tmp` or `/run/user/<uid>/`
- Keyring socket: `/run/user/<uid>/keyring/ssh`
