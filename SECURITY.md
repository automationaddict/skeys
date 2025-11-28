# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue, please report it responsibly.

### How to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to the project maintainer. You can find contact information in the repository or reach out through GitHub's private vulnerability reporting feature.

### What to Include

When reporting a vulnerability, please include:

- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact
- Any suggested fixes (optional)

### What to Expect

- **Acknowledgment**: We will acknowledge receipt within 48 hours
- **Assessment**: We will assess the vulnerability and determine its severity
- **Updates**: We will keep you informed of our progress
- **Resolution**: We aim to resolve critical issues within 30 days
- **Credit**: We will credit reporters in release notes (unless you prefer anonymity)

## Security Measures

SKeys implements several security measures:

### Key Protection
- Private keys never leave the local system
- Passphrase-protected keys are indicated in the UI
- Key operations use native Go crypto libraries

### Command Execution
- Allowlisted commands only (no shell injection)
- No shell interpretation of user input
- Safe execution patterns throughout

### Data Protection
- Encrypted backups using AES-256-GCM
- Host key verification with fingerprint display
- No telemetry or data collection

### Communication
- Local Unix socket for daemon communication
- No network exposure of the daemon

## Best Practices for Users

- Use strong passphrases for SSH keys
- Enable key rotation reminders
- Regularly review authorized_keys
- Keep SKeys updated to the latest version
- Review host keys before trusting

## Scope

This security policy applies to the SKeys application and its components:

- `skeys-app` (Flutter frontend)
- `skeys-daemon` (Go backend)
- `skeys-core` (Go library)
- Installation scripts

Third-party dependencies are outside the scope of this policy but we monitor for known vulnerabilities.
