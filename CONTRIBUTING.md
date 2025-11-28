# Contributing to SKeys

Thank you for your interest in contributing to SKeys! This document provides guidelines and instructions for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Set up the development environment (see [README.md](README.md#quick-start))

## Development Setup

### Prerequisites

- Linux (tested on Ubuntu 22.04+)
- Go 1.22+
- Flutter 3.x with Linux desktop support
- Protocol Buffers compiler (`protoc`)
- Just (command runner)

### Install Dependencies

```bash
# Ubuntu/Debian
sudo apt-get install -y protobuf-compiler

# Go protoc plugins
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Dart protoc plugin
dart pub global activate protoc_plugin

# Verify setup
just setup
```

### Build & Run

```bash
# Generate proto files and build everything
just build

# Run in development mode
just run-app
```

## How to Contribute

### Reporting Bugs

Before submitting a bug report:

1. Check existing [issues](https://github.com/automationaddict/skeys/issues) to avoid duplicates
2. Collect relevant information:
   - OS version and distribution
   - SKeys version (`just version` or Settings > About)
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant logs (`~/.local/state/skeys/logs/`)

### Suggesting Features

Feature requests are welcome! Please:

1. Check existing issues for similar suggestions
2. Describe the use case and problem it solves
3. Explain how you envision the feature working

### Pull Requests

1. **Create a feature branch** from `master`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**:
   - Follow existing code style and patterns
   - Add tests for new functionality
   - Update documentation if needed

3. **Run quality checks**:
   ```bash
   just fmt      # Format code
   just lint     # Run linters
   just test     # Run tests
   ```

4. **Commit with conventional commits**:
   ```bash
   git commit -m "feat: add new feature"
   git commit -m "fix: resolve issue with X"
   git commit -m "docs: update README"
   ```

5. **Push and open a PR**:
   - Provide a clear description of changes
   - Reference any related issues
   - Ensure CI checks pass

## Code Style

### Go

- Follow standard Go conventions
- Use `gofmt` for formatting
- Run `golangci-lint` for static analysis

### Dart/Flutter

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` for formatting
- Run `flutter analyze` for static analysis

### Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code restructuring |
| `test` | Adding/updating tests |
| `chore` | Maintenance tasks |

## Project Structure

```
skeys/
├── skeys-core/      # Go library (business logic)
├── skeys-daemon/    # gRPC server
├── skeys-app/       # Flutter application
├── proto/           # Protocol Buffer definitions
└── justfile         # Task runner commands
```

See [README.md](README.md#development) for detailed structure.

## Testing

```bash
# Run all tests
just test

# Run Go tests only
just test-go

# Run Flutter tests only
just test-flutter

# Run with coverage
just coverage
```

## Questions?

- Open a [discussion](https://github.com/automationaddict/skeys/discussions) for general questions
- Check existing issues and documentation first

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
