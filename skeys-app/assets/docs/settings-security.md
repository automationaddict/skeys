# Security Settings

## Overview

The Security tab contains settings related to SSH key security and agent behavior. These settings help you maintain good security hygiene.

## Key Rotation Reminders

SSH keys should be rotated periodically as a security best practice. SKeys can remind you when keys are getting old by showing visual indicators on the Keys screen.

### Warning Threshold

Sets the number of days after which a key shows an orange warning indicator. The default is **90 days**.

When a key exceeds this age:
- An orange warning icon appears next to the key
- Hovering over the icon shows the key's age and the threshold

This is a gentle reminder that you might want to consider rotating the key soon.

### Critical Threshold

Sets the number of days after which a key shows a red critical indicator. The default is **180 days**.

When a key exceeds this age:
- A red error icon appears next to the key
- The icon pulses to draw attention
- Hovering shows the key's age and a strong recommendation to rotate

Keys at this age should be rotated as soon as practical.

### Choosing Thresholds

The right thresholds depend on your security requirements:

- **High-security environments**: 30-day warning, 60-day critical
- **Standard use**: 90-day warning, 180-day critical (defaults)
- **Low-risk environments**: 180-day warning, 365-day critical

## SSH Agent Timeout

Controls how long keys remain loaded in the SSH agent after being added.

### Key Timeout

When you add a key to the agent, you can set it to automatically expire after a certain time. This is useful for:

- **Security**: Keys are automatically removed when not needed
- **Shared workstations**: Prevents keys from remaining loaded after you leave
- **Compliance**: Some security policies require key timeout

### Timeout Values

- **No timeout** (0): Keys remain in the agent until manually removed or the agent restarts
- **10 minutes to 8 hours**: Keys are automatically removed after this duration

The timeout is applied when keys are added to the agent. Changing this setting does not affect keys already loaded.

## SSH Config Integration

Configures your system to use the SKeys-managed SSH agent for all SSH connections.

### Use skeys for SSH

When enabled, SKeys adds an `IdentityAgent` directive to your `~/.ssh/config` file. This tells SSH commands (ssh, git, scp, etc.) to use the SKeys agent instead of the default system agent.

**Benefits:**
- All SSH operations use keys managed by SKeys
- Consistent key management across all tools
- Key timeout settings apply to all connections

**When enabled:**
- SSH commands automatically use SKeys agent
- Status shows "SSH commands will use keys managed by skeys"

**When disabled:**
- SSH commands use the default system agent
- You can still use SKeys for key management, but must manually specify the agent

### How It Works

SKeys manages its own SSH agent that runs alongside the daemon. When you enable this setting, it modifies your SSH config to point to this agent's socket file.

The configuration added looks like:
```
# skeys managed agent
Host *
    IdentityAgent /run/user/1000/skeys-agent.sock
```

---

[Open Security Settings](skeys://settings/security)
