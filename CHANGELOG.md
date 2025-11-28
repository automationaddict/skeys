# Changelog

All notable changes to this project will be documented in this file.

## [0.0.4] - 2025-11-28

### Added
- New app icon with rounded corners and blue theme
- App logo displayed in the About screen
- App logo displayed in the navigation rail sidebar

### Changed
- Updated all icon sizes (16px to 1024px) with new design

## [0.0.3] - 2025-11-27

### Added
- Real-time streaming to Remote, Config, and Hosts pages
- Network info and firewall status on Server page
- Shared broadcaster pattern for efficient streaming

### Changed
- Standardized Go backend patterns for consistency
- Refactored streaming architecture

## [0.0.2] - 2025-11-26

### Added
- Real-time streaming to Server page with BLoC architecture
- SSH service auto-start toggle
- Server help documentation with troubleshooting guide

### Fixed
- Nil pointer dereference in update check
- Improved SSH service start failure error messages

### Changed
- Use AppToast for server page messages

## [0.0.1] - 2025-11-25

### Added
- Initial release
- SSH key management (generate, delete, copy public key)
- SSH agent integration
- Host key verification and management
- Remote server configuration
- gRPC backend daemon
- Auto-update support
- Backup and restore functionality
