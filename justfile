# SKeys - SSH Key Management Application
# Justfile for task orchestration

# Default recipe
default:
    @just --list

# ============================================================
# Proto Generation
# ============================================================

# Generate all proto files
proto-gen: proto-gen-go proto-gen-dart
    @echo "Proto generation complete"

# Generate Go proto files
proto-gen-go:
    @echo "Generating Go proto files..."
    @mkdir -p skeys-daemon/api/gen/v1
    protoc \
        --proto_path=proto \
        --go_out=skeys-daemon/api/gen \
        --go_opt=paths=source_relative \
        --go-grpc_out=skeys-daemon/api/gen \
        --go-grpc_opt=paths=source_relative \
        proto/skeys/v1/*.proto
    @echo "Go proto files generated"

# Generate Dart proto files
proto-gen-dart:
    @echo "Generating Dart proto files..."
    @mkdir -p skeys-app/lib/core/generated/skeys/v1
    protoc \
        --proto_path=proto \
        --dart_out=grpc:skeys-app/lib/core/generated \
        proto/skeys/v1/*.proto
    @echo "Dart proto files generated"

# Clean generated proto files
proto-clean:
    rm -rf skeys-daemon/api/gen
    rm -rf skeys-app/lib/core/generated

# ============================================================
# Backend (Go)
# ============================================================

# Build the daemon
build-daemon:
    @echo "Building skeys-daemon..."
    cd skeys-daemon && go build -o bin/skeys-daemon ./cmd/skeys-daemon
    @echo "Daemon built: skeys-daemon/bin/skeys-daemon"

# Run the daemon
run-daemon: build-daemon
    @echo "Starting skeys-daemon..."
    ./skeys-daemon/bin/skeys-daemon

# Run daemon tests
test-daemon:
    @echo "Running daemon tests..."
    cd skeys-daemon && go test -v ./...

# Run core library tests
test-core:
    @echo "Running core library tests..."
    cd skeys-core && go test -v ./...

# Run all Go tests
test-go: test-core test-daemon

# Lint Go code
lint-go:
    @echo "Linting Go code..."
    cd skeys-core && golangci-lint run ./...
    cd skeys-daemon && golangci-lint run ./...

# Format Go code
fmt-go:
    @echo "Formatting Go code..."
    cd skeys-core && go fmt ./...
    cd skeys-daemon && go fmt ./...

# Tidy Go modules
tidy-go:
    @echo "Tidying Go modules..."
    cd skeys-core && go mod tidy
    cd skeys-daemon && go mod tidy

# ============================================================
# Frontend (Flutter)
# ============================================================

# Get Flutter dependencies
flutter-deps:
    @echo "Getting Flutter dependencies..."
    cd skeys-app && flutter pub get

# Build Flutter app for Linux
build-app: flutter-deps
    @echo "Building Flutter app..."
    cd skeys-app && flutter build linux

# Run Flutter app
run-app: build-daemon flutter-deps
    @echo "Starting Flutter app..."
    cd skeys-app && flutter run -d linux

# Run Flutter tests
test-app:
    @echo "Running Flutter tests..."
    cd skeys-app && flutter test

# Analyze Flutter code
analyze-app:
    @echo "Analyzing Flutter code..."
    cd skeys-app && flutter analyze

# Format Flutter code
fmt-app:
    @echo "Formatting Flutter code..."
    cd skeys-app && dart format lib test

# Generate Flutter code (freezed, json_serializable, etc.)
gen-app:
    @echo "Running Flutter code generation..."
    cd skeys-app && flutter pub run build_runner build --delete-conflicting-outputs

# Watch Flutter code generation
gen-app-watch:
    @echo "Watching Flutter code generation..."
    cd skeys-app && flutter pub run build_runner watch --delete-conflicting-outputs

# ============================================================
# Full Stack
# ============================================================

# Build everything
build: proto-gen build-daemon build-app
    @echo "Full build complete"

# Run all tests
test: test-go test-app
    @echo "All tests complete"

# Format all code
fmt: fmt-go fmt-app
    @echo "All code formatted"

# Lint/analyze all code
lint: lint-go analyze-app
    @echo "All code linted"

# Clean all build artifacts
clean: proto-clean
    rm -rf skeys-daemon/bin
    cd skeys-app && flutter clean
    @echo "Clean complete"

# ============================================================
# Development
# ============================================================

# Start development environment (daemon + app)
dev: build-daemon
    @echo "Starting development environment..."
    @echo "Run 'just run-daemon' in one terminal"
    @echo "Run 'just run-app' in another terminal"

# Install development dependencies
setup:
    @echo "Setting up development environment..."
    @echo "Checking Go..."
    go version
    @echo "Checking Flutter..."
    flutter --version
    @echo "Checking protoc..."
    protoc --version
    @echo "Installing protoc plugins..."
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
    dart pub global activate protoc_plugin
    @echo "Setup complete"

# Install the daemon to ~/.local/bin
install-daemon: build-daemon
    @echo "Installing daemon..."
    mkdir -p ~/.local/bin
    cp skeys-daemon/bin/skeys-daemon ~/.local/bin/
    @echo "Daemon installed to ~/.local/bin/skeys-daemon"

# Uninstall the daemon
uninstall-daemon:
    rm -f ~/.local/bin/skeys-daemon
    @echo "Daemon uninstalled"

# Install the app (binary, icons, and .desktop file)
install-app: build-app
    @echo "Installing SKeys app..."
    @# Install binary
    mkdir -p ~/.local/bin
    cp skeys-app/build/linux/x64/release/bundle/skeys_app ~/.local/bin/
    @# Install app bundle to ~/.local/share/skeys
    mkdir -p ~/.local/share/skeys
    cp -r skeys-app/build/linux/x64/release/bundle/* ~/.local/share/skeys/
    @# Install .desktop file
    mkdir -p ~/.local/share/applications
    sed "s|Exec=skeys_app|Exec=$HOME/.local/share/skeys/skeys_app|g" \
        skeys-app/linux/com.skeys.skeys_app.desktop > ~/.local/share/applications/com.skeys.skeys_app.desktop
    @# Install icons to hicolor theme
    mkdir -p ~/.local/share/icons/hicolor/16x16/apps
    mkdir -p ~/.local/share/icons/hicolor/32x32/apps
    mkdir -p ~/.local/share/icons/hicolor/48x48/apps
    mkdir -p ~/.local/share/icons/hicolor/64x64/apps
    mkdir -p ~/.local/share/icons/hicolor/128x128/apps
    mkdir -p ~/.local/share/icons/hicolor/256x256/apps
    mkdir -p ~/.local/share/icons/hicolor/512x512/apps
    mkdir -p ~/.local/share/icons/hicolor/1024x1024/apps
    cp skeys-app/linux/runner/icons/skeys_16.png ~/.local/share/icons/hicolor/16x16/apps/com.skeys.skeys_app.png
    cp skeys-app/linux/runner/icons/skeys_32.png ~/.local/share/icons/hicolor/32x32/apps/com.skeys.skeys_app.png
    cp skeys-app/linux/runner/icons/skeys_48.png ~/.local/share/icons/hicolor/48x48/apps/com.skeys.skeys_app.png
    cp skeys-app/linux/runner/icons/skeys_64.png ~/.local/share/icons/hicolor/64x64/apps/com.skeys.skeys_app.png
    cp skeys-app/linux/runner/icons/skeys_128.png ~/.local/share/icons/hicolor/128x128/apps/com.skeys.skeys_app.png
    cp skeys-app/linux/runner/icons/skeys_256.png ~/.local/share/icons/hicolor/256x256/apps/com.skeys.skeys_app.png
    cp skeys-app/linux/runner/icons/skeys_512.png ~/.local/share/icons/hicolor/512x512/apps/com.skeys.skeys_app.png
    cp skeys-app/linux/runner/icons/skeys_1024.png ~/.local/share/icons/hicolor/1024x1024/apps/com.skeys.skeys_app.png
    @# Update icon cache
    gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor || true
    @echo "SKeys app installed! You may need to log out and back in for the icon to appear in your launcher."

# Uninstall the app
uninstall-app:
    @echo "Uninstalling SKeys app..."
    rm -f ~/.local/bin/skeys_app
    rm -rf ~/.local/share/skeys
    rm -f ~/.local/share/applications/com.skeys.skeys_app.desktop
    rm -f ~/.local/share/icons/hicolor/16x16/apps/com.skeys.skeys_app.png
    rm -f ~/.local/share/icons/hicolor/32x32/apps/com.skeys.skeys_app.png
    rm -f ~/.local/share/icons/hicolor/48x48/apps/com.skeys.skeys_app.png
    rm -f ~/.local/share/icons/hicolor/64x64/apps/com.skeys.skeys_app.png
    rm -f ~/.local/share/icons/hicolor/128x128/apps/com.skeys.skeys_app.png
    rm -f ~/.local/share/icons/hicolor/256x256/apps/com.skeys.skeys_app.png
    rm -f ~/.local/share/icons/hicolor/512x512/apps/com.skeys.skeys_app.png
    rm -f ~/.local/share/icons/hicolor/1024x1024/apps/com.skeys.skeys_app.png
    gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor || true
    @echo "SKeys app uninstalled"

# Install everything (daemon + app)
install: install-daemon install-app
    @echo "Full installation complete"

# Uninstall everything
uninstall: uninstall-daemon uninstall-app
    @echo "Full uninstallation complete"
