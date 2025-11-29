# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Improve settings dialog with new features and UI enhancements

### CI/CD

- Add GitHub workflow automation
- Add /review command for production-readiness audits

### Changed

- Separate ServerConfigBloc from ConfigBloc
- Simplify AddToAgentDialog BLoC dependencies

### Documentation

- Document AgentBloc manual subscription pattern

### Fixed

- Sync key state when agent changes via daemon
## [0.0.6] - 2025-11-28

### Added

- Add help tooltips and search to SSH config UI
- Add help tooltips to client config global directives

### Documentation

- Add component READMEs and improve network error feedback

### Fixed

- Show first-start dialog after reinstall and use XDG runtime dir
- Make help tooltips scrollable on smaller screens
- Add missing @override annotation in test mocks
- Add missing @override annotation in test mock

### Miscellaneous

- Update changelog for v0.0.6
## [0.0.5] - 2025-11-28

### Added

- Add include patches toggle for update settings
- Separate dev and prod SSH agent sockets

### Build

- Automate version and build number in CI

### Documentation

- Add documentation to core modules (batch 1/~13)
- Add public API documentation for core help, settings, shell modules
- Add public API documentation for features/agent module
- Add public API documentation for features/config bloc events
- Add public API documentation for features/config state and domain
- Add public API documentation for features/config presentation and repository
- Add public API documentation for features/hosts module
- Add public API documentation for features/keys module
- Add public API documentation for remaining features and main
- Fix remaining public API documentation issues

### Fixed

- Prevent dialog freeze when network unavailable in add key to agent
- Remove unused imports in Flutter test files
- Improve gRPC connection resilience for long-running sessions
- Correct Go module paths from johnnelson to automationaddict
- Resolve UI freeze when adding keys to SSH agent

### Miscellaneous

- Add git hooks and license headers
- Expand pre-commit checks and fix IPv6 address format
- Add TOML linting to pre-commit hook
- Add YAML and Markdown linting to pre-commit hook
- Bump build number to 0.0.4+2

### Testing

- Add CI workflow, Codecov, and keys package tests
- Add comprehensive unit tests for skeys-core packages
## [0.0.4] - 2025-11-28

### Added

- Add CHANGELOG.md and update release workflow

### Changed

- Update app icon and add logo to UI
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

- Add SSH service auto-start toggle
- Add real-time streaming to Server page with BLoC architecture

### Changed

- Improve SSH service start failure error messages
- Update server help docs with auto-start toggle and troubleshooting

### Fixed

- Fix nil pointer dereference in update check

### Other

- Use AppToast for server page messages
## [0.0.1] - 2025-11-28

### Added

- Initial commit: SKeys SSH key management application
- Add key expiration warnings and improve agent integration
- Add agent key timeout with per-key countdown and tab-aware help
- Add host key scanning and set version to 0.0.1
- Add managed SSH agent and native Go key generation
- Add SSH connection testing with toast notifications
- Add SSH config integration for skeys managed agent
- Add host key verification and prioritize SSH agent auth
- Add gRPC streaming for reactive UI updates and expand settings
- Add dev/prod separation with containerized daemon
- Add single instance enforcement using Unix socket
- Add expandable public key display to SSH keys and known hosts cards
- Add global SSH directives support to Client Config
- Add Server status page and SSH system service support
- Add auto-update system with GitHub Releases distribution

### Changed

- Update README with current project state and features
- Replace polling with event-driven updates and add core version info
- Update dependencies to latest compatible versions
- Improve UX with keyboard shortcuts, timer fix, and help panel

### Fixed

- Fix stale socket detection in backend launcher
- Fix help panel navigation to settings via service
- Fix UI freeze when re-adding key to agent and update app icons
- Fix dev container socket and XDG runtime mount
- Fix Flutter version in release workflow
- Fix GitHub repo URLs in documentation
- Fix install script stdout/stderr handling
- Fix install script to handle partial installations
