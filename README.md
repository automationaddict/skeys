# SKeys - SSH Key Management Application

A comprehensive SSH management GUI application with a Flutter frontend and Go backend, designed for Linux desktop.

## Project Overview

SKeys provides a modern interface for managing your SSH ecosystem:
- **SSH Keys**: Generate, delete, modify, and push keys to remote servers
- **SSH Config**: Manage `~/.ssh/config` client configuration and `/etc/ssh/sshd_config` server configuration
- **Known Hosts**: View, remove, and hash entries in `~/.ssh/known_hosts`
- **Authorized Keys**: Manage `~/.ssh/authorized_keys`
- **SSH Agent**: Add/remove keys, lock/unlock the agent
- **Remote Servers**: Connect to and manage remote servers

## Architecture

```
skeys/
├── skeys-core/          # Reusable Go library (business logic)
├── skeys-daemon/        # gRPC server wrapping skeys-core
├── skeys-app/           # Flutter desktop application
├── proto/               # Shared Protocol Buffer definitions
└── justfile             # Task orchestration
```

### Design Principles

1. **Decoupled Backend**: `skeys-core` is a standalone Go library that can be reused by other applications (CLI tools, other GUIs, etc.)

2. **Adapter Pattern**: The daemon adapts the core library to gRPC, and the Flutter app adapts gRPC to domain entities

3. **BLoC Pattern**: Flutter uses Business Logic Component pattern for state management

4. **Hybrid SSH Approach**:
   - Native Go libraries (`golang.org/x/crypto/ssh`) for connections and parsing
   - CLI wrappers (`ssh-keygen`, `ssh-add`) for key operations requiring system integration

5. **Unix Socket IPC**: Backend spawned by Flutter as child process, communicating via Unix socket with gRPC

## Project Components

### skeys-core (Go Library)

Reusable SSH management library with these packages:

| Package | Description |
|---------|-------------|
| `keys` | SSH key CRUD operations, generation via ssh-keygen |
| `config` | Client (~/.ssh/config) and server (sshd_config) management |
| `hosts` | known_hosts and authorized_keys management |
| `agent` | SSH agent interaction (native Go + ssh-add wrapper) |
| `remote` | SSH connection pool, command execution, SFTP |
| `executor` | Safe command execution with allowlist |

**Dependencies:**
- `golang.org/x/crypto` - SSH protocol implementation
- `github.com/kevinburke/ssh_config` - SSH config parsing
- `github.com/pkg/sftp` - SFTP client

### skeys-daemon (gRPC Server)

Wraps skeys-core with gRPC services:

```
cmd/skeys-daemon/main.go    # Entry point, Unix socket listener
internal/server/server.go   # gRPC server setup
internal/adapter/           # Adapters from core services to gRPC
```

**Key Features:**
- Unix socket listener (default: `/tmp/skeys-daemon.sock`)
- Graceful shutdown on SIGINT/SIGTERM
- Adapter pattern separates transport from business logic

### proto (Protocol Buffers)

Service definitions in `proto/skeys/v1/`:

| Proto File | Services |
|------------|----------|
| `common.proto` | Shared types (Target, TargetType) |
| `keys.proto` | KeyService - key management |
| `config.proto` | ConfigService - SSH config management |
| `hosts.proto` | HostsService - known_hosts/authorized_keys |
| `agent.proto` | AgentService - SSH agent operations |
| `remote.proto` | RemoteService - remote connections |

### skeys-app (Flutter Desktop)

Linux desktop application using:

| Technology | Purpose |
|------------|---------|
| `flutter_bloc` | State management (BLoC pattern) |
| `grpc` | Backend communication |
| `get_it` | Dependency injection |
| `go_router` | Navigation |
| `equatable` | Value equality for entities |

**Structure:**
```
lib/
├── main.dart                    # Entry point
├── core/
│   ├── backend/                 # BackendLauncher (spawns daemon)
│   ├── grpc/                    # GrpcClient
│   ├── di/                      # Dependency injection
│   ├── router/                  # Navigation
│   ├── theme/                   # Material 3 theming
│   ├── shell/                   # App shell with NavigationRail
│   └── generated/               # Proto-generated Dart code
└── features/
    ├── keys/                    # SSH key management
    │   ├── domain/              # KeyEntity
    │   ├── repository/          # KeysRepository (adapter)
    │   ├── bloc/                # KeysBloc, events, states
    │   └── presentation/        # KeysPage, widgets
    ├── config/                  # SSH config management
    ├── hosts/                   # known_hosts/authorized_keys
    ├── agent/                   # SSH agent
    └── remote/                  # Remote servers
```

## Development Setup

### Prerequisites

- Go 1.22+
- Flutter 3.x (with Linux desktop support)
- Protocol Buffers compiler (`protoc`)
- Just (command runner)

### Install Dependencies

```bash
# Install protoc (Ubuntu/Debian)
sudo apt-get install -y protobuf-compiler

# Install Go protoc plugins
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Install Dart protoc plugin
dart pub global activate protoc_plugin

# Verify setup
just setup
```

### Build & Run

```bash
# Generate proto files (Go + Dart)
just proto-gen

# Build everything
just build

# Run daemon (terminal 1)
just run-daemon

# Run Flutter app (terminal 2)
just run-app
```

### Justfile Commands

| Command | Description |
|---------|-------------|
| `just setup` | Verify/install development dependencies |
| `just proto-gen` | Generate Go and Dart proto files |
| `just proto-gen-go` | Generate only Go proto files |
| `just proto-gen-dart` | Generate only Dart proto files |
| `just build` | Build everything (proto, daemon, app) |
| `just build-daemon` | Build Go daemon |
| `just build-app` | Build Flutter app |
| `just run-daemon` | Start the backend daemon |
| `just run-app` | Start the Flutter app |
| `just test` | Run all tests |
| `just test-go` | Run Go tests only |
| `just test-app` | Run Flutter tests only |
| `just fmt` | Format all code |
| `just lint` | Lint/analyze all code |
| `just clean` | Clean all build artifacts |
| `just install-daemon` | Install daemon to ~/.local/bin |

## Communication Flow

```
┌─────────────────┐     Unix Socket      ┌─────────────────┐
│   Flutter App   │◄───────gRPC─────────►│  skeys-daemon   │
│   (skeys-app)   │                      │                 │
└─────────────────┘                      └────────┬────────┘
                                                  │
                                                  │ uses
                                                  ▼
                                         ┌─────────────────┐
                                         │   skeys-core    │
                                         │   (Go Library)  │
                                         └────────┬────────┘
                                                  │
                              ┌───────────────────┼───────────────────┐
                              │                   │                   │
                              ▼                   ▼                   ▼
                        ┌───────────┐      ┌───────────┐      ┌───────────┐
                        │ Native Go │      │    CLI    │      │   Files   │
                        │  crypto   │      │ Wrappers  │      │  (~/.ssh) │
                        └───────────┘      └───────────┘      └───────────┘
                         SSH conns          ssh-keygen         config
                         Parsing            ssh-add            keys
                         Agent              ssh-agent          known_hosts
```

## Key Implementation Details

### Safe Command Execution

`skeys-core/keys/executor.go` implements a safe executor with:
- Allowlist of permitted commands (`ssh-keygen`, `ssh-add`, `ssh-agent`)
- Shell metacharacter validation
- No shell interpretation (direct exec)

### Privilege Escalation

For server config (`/etc/ssh/sshd_config`), the core library supports:
- `pkexec` (PolicyKit) - preferred
- `sudo` - fallback
- Custom executor interface for testing

### Connection Pooling

`skeys-core/remote/connection.go` provides:
- Connection pool with configurable size
- Keep-alive pings
- Idle connection cleanup
- SFTP integration

### Flutter Dependency Injection

`skeys-app/lib/core/di/injection.dart` sets up:
1. `BackendLauncher` - spawns daemon on app start
2. `GrpcClient` - connects to daemon socket
3. Repository implementations (adapter pattern)
4. BLoC factories

## File Locations

| File | Purpose |
|------|---------|
| `~/.ssh/config` | SSH client configuration |
| `~/.ssh/known_hosts` | Known host keys |
| `~/.ssh/authorized_keys` | Authorized public keys |
| `~/.ssh/id_*` | SSH key pairs |
| `/etc/ssh/sshd_config` | SSH server configuration |
| `/tmp/skeys-daemon.sock` | Unix socket (runtime) |

## TODO / Future Work

- [ ] Complete proto code generation setup
- [ ] Add integration tests
- [ ] Implement key push to remote servers
- [ ] Add SSH config validation
- [ ] Support for hardware security keys (FIDO2)
- [ ] Backup/restore functionality
- [ ] Key rotation reminders

## License

[Add license here]
