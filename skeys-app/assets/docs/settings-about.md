# About SKeys

## Overview

The About tab displays version information for both the Flutter application and the Go backend daemon.

## Version Information

### Flutter App

Shows information about the frontend application:

- **Version**: The application version from pubspec.yaml (e.g., 0.0.1)
- **Build**: The build number for this release
- **Dart**: The Dart SDK version the app is running on

### Go Backend

Shows information about the backend daemon:

- **Version**: The daemon version (e.g., 0.0.1)
- **Commit**: The git commit hash of the build (first 7 characters)
- **Go**: The Go runtime version (e.g., go1.22.0)

## Architecture

SKeys uses a two-process architecture:

1. **Flutter App**: The graphical user interface you interact with
2. **Go Daemon**: The backend service that performs SSH operations

These communicate over a Unix socket using gRPC. The Flutter app automatically starts and manages the daemon process.

## Data Locations

SKeys stores data in the following locations:

| Location | Purpose |
|----------|---------|
| `~/.ssh/` | Your SSH keys (private and public) |
| `~/.config/skeys/` | SKeys configuration files |
| `~/.local/share/skeys/` | Application binaries and data |
| `~/.cache/skeys/` | Temporary cache files |

These paths follow the XDG Base Directory Specification for Linux applications.

## Reset Settings

If you need to restore all settings to their default values, use the **Reset** button on this tab. This will reset:

- Theme and text size preferences
- Log level
- Key expiration warning thresholds
- Agent timeout settings
- Update check preferences

Your SSH keys and data are **never affected** by a reset. Only application preferences are restored to defaults.

## Reporting Issues

When reporting bugs or issues, please include:
- Both version numbers (Flutter app and Go backend)
- The Dart and Go versions shown
- Your operating system and version
- Steps to reproduce the issue

This helps us diagnose problems more quickly.

---

[Open About Settings](skeys://settings/about)
