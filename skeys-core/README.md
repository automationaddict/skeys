# SKeys Core

<p align="center">
  <strong>Reusable Go Library for SSH Operations</strong>
</p>

Business logic library providing SSH key management, agent operations, and host key handling.

---

## Overview

`skeys-core` contains the core functionality for SSH operations, designed to be consumed by the `skeys-daemon` gRPC server. It provides a clean API for key management, SSH agent operations, host key handling, and more.

## Packages

```
skeys-core/
├── agent/       # SSH agent client & managed agent
├── broadcast/   # Event broadcasting for file watchers
├── config/      # SSH config file parsing & management
├── executor/    # Safe command execution (allowlisted)
├── hosts/       # known_hosts & authorized_keys management
├── keys/        # Key generation, parsing, operations
├── logging/     # Structured logging (zerolog)
├── remote/      # Connection pool, SSH/SFTP operations
├── sshconfig/   # IdentityAgent directive management
├── storage/     # Key metadata persistence
├── system/      # System utilities
└── update/      # Application update management
```

## Package Details

### agent

SSH agent operations using native Go implementation.

| Component | Description |
|-----------|-------------|
| `AgentService` | Connect to SSH agents, add/remove/list keys |
| `ManagedAgent` | Spawn and manage a dedicated SSH agent process |

### config

SSH configuration file management.

| Component | Description |
|-----------|-------------|
| `ClientConfig` | Parse and modify `~/.ssh/config` |
| `ServerConfig` | Read `/etc/ssh/sshd_config` (with privilege escalation) |

### executor

Safe command execution with allowlisting.

- Prevents shell injection attacks
- Only allows predefined commands (ssh-keygen, ssh-add, etc.)
- No shell interpretation - arguments passed directly

### hosts

Host key management.

| Component | Description |
|-----------|-------------|
| `KnownHosts` | Manage `~/.ssh/known_hosts` |
| `AuthorizedKeys` | Manage `~/.ssh/authorized_keys` |

### keys

SSH key operations.

| Operation | Supported Types |
|-----------|-----------------|
| Generate | ED25519, RSA, ECDSA, SK (hardware) |
| Parse | All standard OpenSSH formats |
| Passphrase | Change, verify |

### remote

Remote SSH operations.

| Component | Description |
|-----------|-------------|
| `ConnectionPool` | Reusable SSH connections with keep-alive |
| `SFTPClient` | File operations over SFTP |

### storage

Persistent metadata storage.

- Key service associations
- Verified host information
- JSON-based file storage

### update

Application update management.

- GitHub releases API integration
- Semantic version comparison
- Download and verification

## Usage

```go
import (
    "github.com/automationaddict/skeys-core/keys"
    "github.com/automationaddict/skeys-core/agent"
)

// Generate a new key
keySvc := keys.NewService("/home/user/.ssh")
err := keySvc.Generate(keys.GenerateOptions{
    Name:       "my-key",
    Type:       keys.KeyTypeED25519,
    Passphrase: "secret",
})

// Add key to agent
agentSvc := agent.NewService()
err = agentSvc.AddKey("/home/user/.ssh/my-key", "secret", 0)
```

## Design Principles

### Adapter Pattern

Each package exposes a clean service interface. The `skeys-daemon` uses adapters to translate between gRPC requests and core service calls.

### Hybrid SSH Approach

| Approach | Use Case |
|----------|----------|
| Native Go | SSH connections, key parsing, agent protocol |
| CLI Wrappers | `ssh-keygen` for generation (better compatibility) |

### Safe Execution

All external command execution goes through the `executor` package which:
- Maintains an allowlist of permitted commands
- Passes arguments directly (no shell)
- Validates paths and arguments

## Testing

```bash
go test ./...
```

## Related Components

- [skeys-daemon](../skeys-daemon/) - gRPC server exposing this library
- [skeys-app](../skeys-app/) - Flutter frontend
- [proto](../proto/) - Protocol Buffer definitions
