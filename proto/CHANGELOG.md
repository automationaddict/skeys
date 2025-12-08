# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Add network info and firewall status to Server page
- Add real-time streaming to Hosts page
- Add real-time streaming to Config page
- Add real-time streaming to Remote page
- Add include patches toggle for update settings
- **remote**: Add PushKeyToRemote RPC and connection status tracking

### Fixed

- Correct Go module paths from johnnelson to automationaddict
## [0.0.2] - 2025-11-28

### Added

- Initial commit: SKeys SSH key management application
- Add host key scanning and set version to 0.0.1
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
