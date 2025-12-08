# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Add include patches toggle for update settings
- Add help tooltips and search to SSH config UI
- **remote**: Add connection pool and storage improvements

### Build

- **go**: Bump github.com/pkg/sftp from 1.13.6 to 1.13.10 in /skeys-core (#5)
- **go**: Bump golang.org/x/crypto from 0.41.0 to 0.45.0 in /skeys-core (#7)

### Documentation

- Add component READMEs and improve network error feedback

### Fixed

- Correct Go module paths from johnnelson to automationaddict
- Sync key state when agent changes via daemon

### Miscellaneous

- Add git hooks and license headers
- Expand pre-commit checks and fix IPv6 address format

### Performance

- Optimize RemoteBloc and add network retry logic (#12) (#60)

### Testing

- Add CI workflow, Codecov, and keys package tests
- Add comprehensive unit tests for skeys-core packages
## [0.0.3] - 2025-11-28

### Added

- Add network info and firewall status to Server page
- Add real-time streaming to Hosts page
- Add real-time streaming to Config page
- Add real-time streaming to Remote page

### Other

- Standardize Go backend patterns for consistency
- Refactor streaming to shared broadcaster pattern
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
- Add global SSH directives support to Client Config
- Add Server status page and SSH system service support
- Add auto-update system with GitHub Releases distribution
- Add SSH service auto-start toggle
- Add real-time streaming to Server page with BLoC architecture

### Changed

- Replace polling with event-driven updates and add core version info
- Improve SSH service start failure error messages
