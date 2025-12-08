# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- **remote**: Fix connection status tracking and TestConnection auth

### Build

- **go**: Bump github.com/pkg/sftp from 1.13.6 to 1.13.10 in /skeys-core (#5)
- **go**: Update sftp dependency in skeys-daemon to 1.13.10
- **go**: Bump google.golang.org/protobuf from 1.35.1 to 1.36.10 in /skeys-daemon (#6)
- **go**: Bump google.golang.org/grpc from 1.68.0 to 1.77.0 in /skeys-daemon (#8)

### Documentation

- Add component READMEs and improve network error feedback

### Fixed

- Sync key state when agent changes via daemon

### Performance

- Optimize RemoteBloc and add network retry logic (#12) (#60)

### Security

- **go**: Bump golang.org/x/crypto from 0.28.0 to 0.45.0 in /skeys-daemon (#3)
## [0.0.5] - 2025-11-28

### Added

- Add network info and firewall status to Server page
- Add real-time streaming to Hosts page
- Add real-time streaming to Config page
- Add real-time streaming to Remote page
- Add include patches toggle for update settings
- Separate dev and prod SSH agent sockets

### Fixed

- Improve gRPC connection resilience for long-running sessions
- Correct Go module paths from johnnelson to automationaddict
- Resolve UI freeze when adding keys to SSH agent

### Miscellaneous

- Add git hooks and license headers
- Bump build number to 0.0.4+2

### Other

- Standardize Go backend patterns for consistency

### Testing

- Add CI workflow, Codecov, and keys package tests
## [0.0.2] - 2025-11-28

### Added

- Initial commit: SKeys SSH key management application
- Add key expiration warnings and improve agent integration
- Add host key scanning and set version to 0.0.1
- Add managed SSH agent and native Go key generation
- Add SSH connection testing with toast notifications
- Add SSH config integration for skeys managed agent
- Add host key verification and prioritize SSH agent auth
- Add gRPC streaming for reactive UI updates and expand settings
- Add dev/prod separation with containerized daemon
- Add global SSH directives support to Client Config
- Add Server status page and SSH system service support
- Add auto-update system with GitHub Releases distribution
- Add SSH service auto-start toggle
- Add real-time streaming to Server page with BLoC architecture

### Changed

- Replace polling with event-driven updates and add core version info

### Fixed

- Fix nil pointer dereference in update check
