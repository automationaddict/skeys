# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Improve settings dialog with new features and UI enhancements
- Add keyboard navigation and focus indicators to Display settings (#20) (#144)
- Add color swatch preview to theme selector (#387)
- Implement comprehensive help system with tree navigation (#389)
- **help**: Add index page, SSH overview, and glossary to help system
- **help**: Add Quick Start, Installation, FAQ, and Troubleshooting guides
- **hooks**: Add worktree branch verification and fix failing test

### Changed

- Separate ServerConfigBloc from ConfigBloc
- Simplify AddToAgentDialog BLoC dependencies
- Remove GetIt dependency from Display settings (#21) (#284)

### Documentation

- Document AgentBloc manual subscription pattern

### Fixed

- Sync key state when agent changes via daemon
- Add error handling for SharedPreferences failures in Display settings (#13) (#76)
- Eliminate race condition in Display settings by using ListenableBuilder
- Add validation and logging to TextScale and AppThemeMode enum loading (#22) (#145)
- **help**: Add missing settings tabs to HelpNavigationService
- **shell**: Prevent icon flickering on hot restart (#392)
- **tests**: Use textContaining for partial text match

### Performance

- Optimize RemoteBloc and add network retry logic (#12) (#60)
- Add state validation to prevent unnecessary settings updates (#15)

### Testing

- Add comprehensive unit and widget tests for Display settings (#14) (#139)
## [0.0.6] - 2025-11-28

### Added

- Add include patches toggle for update settings
- Add help tooltips and search to SSH config UI
- Add help tooltips to client config global directives

### Build

- Automate version and build number in CI

### Changed

- Update app icon and add logo to UI

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
- Add component READMEs and improve network error feedback

### Fixed

- Prevent dialog freeze when network unavailable in add key to agent
- Remove unused imports in Flutter test files
- Improve gRPC connection resilience for long-running sessions
- Resolve UI freeze when adding keys to SSH agent
- Show first-start dialog after reinstall and use XDG runtime dir
- Make help tooltips scrollable on smaller screens
- Add missing @override annotation in test mocks
- Add missing @override annotation in test mock

### Miscellaneous

- Add git hooks and license headers
- Bump build number to 0.0.4+2

### Testing

- Add CI workflow, Codecov, and keys package tests
## [0.0.3] - 2025-11-28

### Added

- Add network info and firewall status to Server page
- Add real-time streaming to Hosts page
- Add real-time streaming to Config page
- Add real-time streaming to Remote page

### Other

- Refactor streaming to shared broadcaster pattern
## [0.0.2] - 2025-11-28

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
- Add SSH service auto-start toggle
- Add real-time streaming to Server page with BLoC architecture

### Changed

- Replace polling with event-driven updates and add core version info
- Update dependencies to latest compatible versions
- Improve UX with keyboard shortcuts, timer fix, and help panel
- Update server help docs with auto-start toggle and troubleshooting

### Fixed

- Fix stale socket detection in backend launcher
- Fix help panel navigation to settings via service
- Fix UI freeze when re-adding key to agent and update app icons
- Fix GitHub repo URLs in documentation

### Other

- Use AppToast for server page messages
