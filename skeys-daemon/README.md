# SKeys Daemon

<p align="center">
  <strong>gRPC Backend Service for SKeys</strong>
</p>

Go-based daemon that exposes SSH management functionality over gRPC via Unix socket.

---

## Overview

The SKeys Daemon acts as the backend service for the SKeys application. It wraps the `skeys-core` library and exposes its functionality through a gRPC API, allowing the Flutter frontend to perform SSH operations.

## Architecture

```
skeys-daemon/
├── api/
│   └── gen/skeys/v1/        # Generated protobuf/gRPC code
├── cmd/skeys-daemon/        # Application entry point
└── internal/
    ├── adapter/             # Core-to-gRPC adapters
    └── server/              # gRPC server setup
```

## gRPC Services

| Service | Description |
|---------|-------------|
| `KeyService` | Key generation, listing, deletion, passphrase changes |
| `AgentService` | SSH agent operations (add/remove/list keys) |
| `ConfigService` | SSH config file management |
| `HostsService` | known_hosts and authorized_keys management |
| `RemoteService` | Connection testing, SFTP operations |
| `MetadataService` | Key metadata persistence |
| `UpdateService` | Application update checks |
| `VersionService` | Backend version information |

## Socket Paths

| Mode | gRPC Socket | Agent Socket |
|------|-------------|--------------|
| Production | `$XDG_RUNTIME_DIR/skeys/skeys.sock` | `$XDG_RUNTIME_DIR/skeys/skeys-agent.sock` |
| Development | `/tmp/skeys-dev.sock` | `/tmp/skeys-dev-agent.sock` |

## Running

### Production

The daemon is typically managed by systemd:

```bash
systemctl --user start skeys-daemon
systemctl --user status skeys-daemon
```

Or run manually:

```bash
skeys-daemon --socket /run/user/$UID/skeys/skeys.sock
```

### Development

Using Tilt (recommended for hot-reload):

```bash
just dev
```

Or manually with Docker:

```bash
docker-compose up skeys-daemon
```

## Command Line Options

| Flag | Description | Default |
|------|-------------|---------|
| `--socket` | Unix socket path for gRPC | `/tmp/skeys.sock` |
| `--log-level` | Logging level (debug, info, warn, error) | `info` |
| `--log-pretty` | Enable pretty-printed logs | `false` |

## Adapter Pattern

The daemon uses an adapter pattern to translate between gRPC and core services:

```go
// Adapter wraps core service for gRPC
type KeyAdapter struct {
    svc *keys.Service
}

// gRPC method implementation
func (a *KeyAdapter) ListKeys(ctx context.Context, req *pb.ListKeysRequest) (*pb.ListKeysResponse, error) {
    keys, err := a.svc.List()
    if err != nil {
        return nil, status.Error(codes.Internal, err.Error())
    }
    return &pb.ListKeysResponse{Keys: toProtoKeys(keys)}, nil
}
```

## Building

```bash
# Build binary
go build -o skeys-daemon ./cmd/skeys-daemon

# Build with version info
go build -ldflags "-X main.version=1.0.0" -o skeys-daemon ./cmd/skeys-daemon
```

## Docker

```bash
# Build image
docker build -t skeys-daemon .

# Run container
docker run -v /tmp:/tmp -v ~/.ssh:/home/user/.ssh skeys-daemon
```

## Security

- Unix socket permissions restrict access to current user
- Systemd hardening with `ProtectSystem=strict`, `ProtectHome=read-only`
- ReadWritePaths limited to `~/.ssh`, `~/.config/skeys`, `~/.cache/skeys`

## Testing

```bash
go test ./...
```

## Related Components

- [skeys-core](../skeys-core/) - Shared Go library
- [skeys-app](../skeys-app/) - Flutter frontend
- [proto](../proto/) - Protocol Buffer definitions
- [systemd](../systemd/) - Systemd service files
