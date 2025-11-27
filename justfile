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

# Build the daemon (for local testing only, dev uses container)
build-daemon:
    @echo "Building skeys-daemon..."
    cd skeys-daemon && go build \
        -ldflags="-X main.version=dev -X main.commit=$(git rev-parse --short HEAD 2>/dev/null || echo unknown)" \
        -o bin/skeys-daemon ./cmd/skeys-daemon
    @echo "Daemon built: skeys-daemon/bin/skeys-daemon"

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

# Run Flutter app in dev mode (requires daemon via tilt up)
run-app: flutter-deps
    @echo "Starting Flutter app in dev mode..."
    @echo "Make sure daemon is running: tilt up"
    cd skeys-app && SKEYS_DEV=true flutter run -d linux

# Run Flutter tests
test-app:
    @echo "Running Flutter tests..."
    cd skeys-app && flutter test

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

# Clean all build artifacts
clean: proto-clean
    rm -rf skeys-daemon/bin
    cd skeys-app && flutter clean
    @echo "Clean complete"

# ============================================================
# Development (containerized daemon)
# ============================================================

# Start the full dev environment (daemon container + Flutter app)
# Builds the daemon image if source files have changed
tilt-up:
    @echo "Building daemon image..."
    COMMIT=$(git rev-parse --short HEAD) docker compose build daemon
    @echo "Starting Tilt..."
    COMMIT=$(git rev-parse --short HEAD) tilt up

# Stop the dev environment
tilt-down:
    tilt down
    rm -f /tmp/skeys-dev.sock

# Kill any orphaned dev processes/containers
tilt-kill:
    @echo "Killing orphaned dev processes..."
    -docker stop skeys-daemon-dev 2>/dev/null || true
    -docker rm skeys-daemon-dev 2>/dev/null || true
    -docker stop $$(docker ps -q --filter ancestor=skeys-daemon-dev) 2>/dev/null || true
    rm -f /tmp/skeys-dev.sock
    @echo "Cleanup complete"

# Install development dependencies
setup:
    @echo "Setting up development environment..."
    @echo "Checking Go..."
    go version
    @echo "Checking Flutter..."
    flutter --version
    @echo "Checking protoc..."
    protoc --version
    @echo "Checking Docker..."
    docker --version
    @echo "Checking Tilt..."
    tilt version
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

# Install the app (bundle, icons, and .desktop file)
install-app: build-app
    @echo "Installing SKeys app..."
    @# Clean any previous install first
    rm -rf ~/.local/share/skeys
    @# Install app bundle (binary + libs + data)
    mkdir -p ~/.local/share/skeys
    cp -r skeys-app/build/linux/x64/release/bundle/* ~/.local/share/skeys/
    @# Install .desktop file with correct path
    mkdir -p ~/.local/share/applications
    sed "s|Exec=skeys-app|Exec=$HOME/.local/share/skeys/skeys-app|g" \
        skeys-app/linux/com.skeys.skeys-app.desktop > ~/.local/share/applications/com.skeys.skeys-app.desktop
    @# Install icons to hicolor theme
    for size in 16 32 48 64 128 256 512 1024; do \
        mkdir -p ~/.local/share/icons/hicolor/$${size}x$${size}/apps; \
        cp skeys-app/linux/runner/icons/skeys_$${size}.png \
           ~/.local/share/icons/hicolor/$${size}x$${size}/apps/com.skeys.skeys-app.png; \
    done
    @# Update icon cache
    gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor || true
    @echo "SKeys app installed to ~/.local/share/skeys/"

# Uninstall the app
uninstall-app:
    @echo "Uninstalling SKeys app..."
    rm -rf ~/.local/share/skeys
    rm -f ~/.local/share/applications/com.skeys.skeys-app.desktop
    for size in 16 32 48 64 128 256 512 1024; do \
        rm -f ~/.local/share/icons/hicolor/$${size}x$${size}/apps/com.skeys.skeys-app.png; \
    done
    gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor || true
    @echo "SKeys app uninstalled"

# Install everything (daemon + app)
install: install-daemon install-app
    @echo "Full installation complete"

# Uninstall everything
uninstall: uninstall-daemon uninstall-app
    @echo "Full uninstallation complete"
