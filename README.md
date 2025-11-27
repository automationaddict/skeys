# SKeys

<p align="center">
  <strong>SSH Key Management for Linux Desktop</strong>
</p>

<p align="center">
  A modern, native Linux application for managing your SSH ecosystem with a Flutter frontend and Go backend.
</p>

---

## Features

### SSH Key Management
- Generate ED25519, RSA, ECDSA, and hardware-backed (SK) keys
- Passphrase protection with visual indicators
- Copy public keys to clipboard
- Key age tracking with configurable rotation reminders

### SSH Agent Integration
- Managed SSH agent with automatic lifecycle
- Add/remove keys with optional timeout
- Service verification before adding keys (GitHub, GitLab, Bitbucket, custom)
- Test connections with stored service metadata
- SSH config integration (`IdentityAgent` directive)

### Host Key Management
- View and manage `~/.ssh/known_hosts`
- Host key verification dialogs with fingerprint display
- Hash hostnames for privacy
- Manage `~/.ssh/authorized_keys`

### SSH Config Editor
- Visual editor for `~/.ssh/config` client settings
- Server config viewer for `/etc/ssh/sshd_config` (read-only with privilege escalation)

### Remote Connections
- Connection pool with keep-alive
- Test SSH connections with latency measurement
- SFTP file operations

### Settings & Customization
- Key rotation warning/critical thresholds
- Agent key timeout configuration
- Text size adjustment
- Log level configuration
- Encrypted backup/restore

### Help System
- Context-aware documentation
- Searchable help panel
- Bidirectional navigation between settings and help

## Architecture

```
skeys/
├── skeys-core/          # Go library (reusable business logic)
├── skeys-daemon/        # gRPC server exposing skeys-core
├── skeys-app/           # Flutter Linux desktop application
├── proto/               # Protocol Buffer service definitions
└── justfile             # Task runner commands
```

### Two-Process Design

The application runs as two binaries:

1. **Flutter App** (`skeys-app`) - Native Linux GUI using Material 3
2. **Go Daemon** (`skeys-daemon`) - Backend service for SSH operations

Communication happens over a Unix socket (`/tmp/skeys-daemon.sock`) using gRPC. The Flutter app automatically spawns and manages the daemon lifecycle.

### Design Principles

- **Adapter Pattern**: Clean separation between transport (gRPC) and business logic
- **BLoC Pattern**: Flutter state management with reactive streams
- **Hybrid SSH**: Native Go crypto for connections, CLI wrappers for system integration
- **Safe Execution**: Allowlisted commands, no shell interpretation

## Requirements

- Linux (tested on Ubuntu 22.04+)
- Go 1.22+
- Flutter 3.x with Linux desktop support
- Protocol Buffers compiler (`protoc`)
- Just (command runner)

## Quick Start

### Install Dependencies

```bash
# Ubuntu/Debian
sudo apt-get install -y protobuf-compiler

# Go protoc plugins
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Dart protoc plugin
dart pub global activate protoc_plugin

# Verify setup
just setup
```

### Build & Run

```bash
# Generate proto files and build everything
just build

# Or run in development mode
just run-app
```

## Development

### Project Structure

```
skeys-core/              # Go library
├── keys/                # Key generation, parsing, operations
├── config/              # SSH config management
├── hosts/               # known_hosts, authorized_keys
├── agent/               # SSH agent, managed agent
├── remote/              # Connection pool, SFTP
├── storage/             # Key metadata persistence
└── executor/            # Safe command execution

skeys-daemon/            # gRPC server
├── cmd/skeys-daemon/    # Entry point
├── internal/server/     # Server setup
└── internal/adapter/    # Core-to-gRPC adapters

skeys-app/               # Flutter application
├── lib/core/            # Shared infrastructure
│   ├── backend/         # Daemon launcher
│   ├── grpc/            # gRPC client
│   ├── help/            # Help system
│   ├── settings/        # Settings dialog
│   └── shell/           # App shell, navigation
└── lib/features/        # Feature modules
    ├── keys/            # Key management UI
    ├── config/          # Config editor UI
    ├── hosts/           # Host management UI
    ├── agent/           # Agent UI
    └── remote/          # Remote connections UI
```

### Justfile Commands

| Command | Description |
|---------|-------------|
| `just setup` | Verify development dependencies |
| `just proto-gen` | Generate Go and Dart proto files |
| `just build` | Build daemon and Flutter app |
| `just run-app` | Run Flutter app (spawns daemon) |
| `just run-daemon` | Run daemon standalone |
| `just test` | Run all tests |
| `just fmt` | Format all code |
| `just lint` | Lint/analyze all code |
| `just clean` | Clean build artifacts |

### Proto Services

| Service | Description |
|---------|-------------|
| `KeyService` | Key CRUD, generation, public key export |
| `ConfigService` | Client/server SSH config management |
| `HostsService` | known_hosts and authorized_keys |
| `AgentService` | SSH agent operations, managed agent |
| `RemoteService` | Connection testing, SFTP |
| `MetadataService` | Key metadata persistence |
| `VersionService` | Backend version information |

## File Locations

| File | Purpose |
|------|---------|
| `~/.ssh/config` | SSH client configuration |
| `~/.ssh/known_hosts` | Trusted host keys |
| `~/.ssh/authorized_keys` | Authorized public keys |
| `~/.ssh/id_*` | SSH key pairs |
| `/tmp/skeys-daemon.sock` | Unix socket (runtime) |
| `/run/user/$UID/skeys-agent.sock` | Managed agent socket |

## Security Considerations

- Private keys never leave the local system
- Passphrase-protected keys show lock indicator
- Command execution uses allowlist (no shell injection)
- Host key verification with fingerprint display
- Encrypted backups using AES-256-GCM

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Follow existing code style
4. Add tests for new functionality
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

---

<p align="center">
  <em>Keep your SSH keys on track!</em>
</p>
