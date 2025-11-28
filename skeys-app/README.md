# SKeys App

<p align="center">
  <strong>Flutter Desktop Application for SKeys</strong>
</p>

Native Linux desktop application for SSH key management with a modern Material 3 interface.

---

## Overview

The SKeys App provides a GUI for managing SSH keys, agents, host keys, and SSH configurations. It communicates with the `skeys-daemon` backend over gRPC via Unix socket.

## Architecture

```
lib/
├── core/                    # Shared infrastructure
│   ├── backend/             # Daemon launcher & lifecycle
│   ├── di/                  # Dependency injection (get_it)
│   ├── generated/           # Generated protobuf/gRPC code
│   ├── grpc/                # gRPC client wrapper
│   ├── help/                # Context-aware help system
│   ├── logging/             # Structured logging
│   ├── notifications/       # Toast notifications
│   ├── settings/            # Settings dialog & service
│   ├── shell/               # App shell, navigation rail
│   └── ssh_config/          # SSH config integration dialog
├── features/                # Feature modules (BLoC pattern)
│   ├── agent/               # SSH agent management
│   ├── config/              # SSH config editor
│   ├── hosts/               # known_hosts & authorized_keys
│   ├── keys/                # Key generation & management
│   ├── metadata/            # Key metadata storage
│   ├── remote/              # Remote connection testing
│   └── update/              # In-app updates
└── main.dart                # Entry point
```

## Key Technologies

| Technology | Purpose |
|------------|---------|
| Flutter 3.x | Linux desktop UI framework |
| BLoC | State management |
| gRPC | Backend communication |
| Material 3 | Design system |
| get_it | Dependency injection |

## Development

### Prerequisites

- Flutter SDK with Linux desktop support enabled
- Running `skeys-daemon` instance

### Running in Dev Mode

```bash
# Start the daemon first (via Tilt or manually)
just dev

# Run the app with dev mode flag
SKEYS_DEV=true flutter run -d linux
```

In dev mode, the app connects to `/tmp/skeys-dev.sock` and expects an externally-managed daemon.

### Building

```bash
# Debug build
flutter build linux

# Release build
flutter build linux --release
```

### Testing

```bash
flutter test
```

## Feature Structure

Each feature follows the BLoC pattern:

```
features/keys/
├── bloc/
│   ├── keys_bloc.dart       # Business logic
│   ├── keys_event.dart      # Input events
│   └── keys_state.dart      # UI state
├── domain/
│   └── key_entity.dart      # Domain models
├── presentation/
│   ├── keys_page.dart       # Main page widget
│   └── widgets/             # Reusable widgets
└── repository/
    └── keys_repository.dart # Data layer (gRPC calls)
```

## Socket Paths

| Mode | Socket Path |
|------|-------------|
| Production | `$XDG_RUNTIME_DIR/skeys/skeys.sock` |
| Development | `/tmp/skeys-dev.sock` |

## Related Components

- [skeys-daemon](../skeys-daemon/) - Go backend service
- [skeys-core](../skeys-core/) - Shared Go library
- [proto](../proto/) - Protocol Buffer definitions
