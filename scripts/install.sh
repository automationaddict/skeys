#!/bin/bash
# SKeys Installation Script
# Downloads and installs skeys from GitHub releases
set -euo pipefail

GITHUB_REPO="automationaddict/skeys"
INSTALL_DIR="${HOME}/.local/share/skeys"
BIN_DIR="${HOME}/.local/bin"
SYSTEMD_DIR="${HOME}/.config/systemd/user"
APPLICATIONS_DIR="${HOME}/.local/share/applications"
ICONS_DIR="${HOME}/.local/share/icons/hicolor"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1" >&2; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; exit 1; }

# Check for required commands
check_requirements() {
    for cmd in curl tar; do
        if ! command -v "$cmd" &> /dev/null; then
            error "$cmd is required but not installed"
        fi
    done
}

# Get the latest release version from GitHub
get_latest_version() {
    local version
    version=$(curl -fsSL "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" | \
        grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [[ -z "$version" ]]; then
        error "Failed to get latest version from GitHub"
    fi
    echo "$version"
}

# Download and verify release tarball
download_release() {
    local version="$1"
    local tarball="skeys-${version}-linux-x64.tar.gz"
    local url="https://github.com/${GITHUB_REPO}/releases/download/${version}/${tarball}"
    local checksum_url="${url}.sha256"
    local temp_dir
    temp_dir=$(mktemp -d)

    info "Downloading skeys ${version}..."
    curl -fsSL -o "${temp_dir}/${tarball}" "$url" || error "Failed to download release"

    info "Verifying checksum..."
    curl -fsSL -o "${temp_dir}/${tarball}.sha256" "$checksum_url" || warn "No checksum available, skipping verification"

    if [[ -f "${temp_dir}/${tarball}.sha256" ]]; then
        cd "$temp_dir"
        if ! sha256sum -c "${tarball}.sha256" &> /dev/null; then
            error "Checksum verification failed"
        fi
        info "Checksum verified"
    fi

    echo "${temp_dir}/${tarball}"
}

# Stop running services before update
stop_services() {
    if systemctl --user is-active --quiet skeys-daemon.service 2>/dev/null; then
        info "Stopping skeys-daemon service..."
        systemctl --user stop skeys-daemon.service || true
    fi
}

# Create required data directories
# These must exist before systemd starts the daemon due to ReadWritePaths
create_data_dirs() {
    mkdir -p "${HOME}/.config/skeys"
    mkdir -p "${HOME}/.cache/skeys"
    mkdir -p "${HOME}/.local/share/skeys"
}

# Install files from tarball
install_files() {
    local tarball="$1"

    # Create parent directories
    mkdir -p "$BIN_DIR" "$SYSTEMD_DIR" "$APPLICATIONS_DIR"

    # Create data directories required by systemd sandboxing
    create_data_dirs

    # Handle existing installation directory
    if [[ -d "$INSTALL_DIR" ]]; then
        if [[ -f "${INSTALL_DIR}/skeys-app" ]]; then
            info "Backing up existing installation..."
            rm -rf "${INSTALL_DIR}.backup"
            mv "$INSTALL_DIR" "${INSTALL_DIR}.backup"
        else
            # Partial/failed install - just remove it
            info "Removing incomplete installation..."
            rm -rf "$INSTALL_DIR"
        fi
    fi

    # Create fresh install directory
    mkdir -p "$INSTALL_DIR"

    # Extract tarball
    info "Extracting files..."
    tar -xzf "$tarball" -C "$INSTALL_DIR" --strip-components=1

    # Make binaries executable
    chmod +x "${INSTALL_DIR}/skeys-app"
    chmod +x "${INSTALL_DIR}/skeys-daemon"

    # Symlink daemon to PATH
    ln -sf "${INSTALL_DIR}/skeys-daemon" "${BIN_DIR}/skeys-daemon"

    # Install .desktop file with correct path
    info "Installing desktop entry..."
    sed "s|Exec=skeys-app|Exec=${INSTALL_DIR}/skeys-app|g" \
        "${INSTALL_DIR}/com.skeys.skeys-app.desktop" > \
        "${APPLICATIONS_DIR}/com.skeys.skeys-app.desktop"

    # Install icons
    info "Installing icons..."
    for size in 16 32 48 64 128 256 512 1024; do
        local icon_dir="${ICONS_DIR}/${size}x${size}/apps"
        mkdir -p "$icon_dir"
        if [[ -f "${INSTALL_DIR}/icons/skeys_${size}.png" ]]; then
            cp "${INSTALL_DIR}/icons/skeys_${size}.png" \
               "${icon_dir}/com.skeys.skeys-app.png"
        fi
    done

    # Update icon cache
    gtk-update-icon-cache -f -t "$ICONS_DIR" 2>/dev/null || true
}

# Install and enable systemd services
install_systemd() {
    info "Installing systemd services..."

    # Copy service files
    if [[ -d "${INSTALL_DIR}/systemd" ]]; then
        cp "${INSTALL_DIR}/systemd/"*.service "$SYSTEMD_DIR/" 2>/dev/null || true
        cp "${INSTALL_DIR}/systemd/"*.timer "$SYSTEMD_DIR/" 2>/dev/null || true
    fi

    # Reload systemd
    systemctl --user daemon-reload

    # Enable and start update timer
    if [[ -f "${SYSTEMD_DIR}/skeys-update.timer" ]]; then
        systemctl --user enable skeys-update.timer 2>/dev/null || true
        systemctl --user start skeys-update.timer 2>/dev/null || true
    fi

    info "Systemd services installed"
}

# Cleanup temporary files
cleanup() {
    local tarball="$1"
    local temp_dir
    temp_dir=$(dirname "$tarball")
    rm -rf "$temp_dir"
}

# Main installation flow
main() {
    echo ""
    echo "  ███████╗██╗  ██╗███████╗██╗   ██╗███████╗"
    echo "  ██╔════╝██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝"
    echo "  ███████╗█████╔╝ █████╗   ╚████╔╝ ███████╗"
    echo "  ╚════██║██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║"
    echo "  ███████║██║  ██╗███████╗   ██║   ███████║"
    echo "  ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝"
    echo ""
    echo "  SSH Key Management"
    echo ""

    check_requirements

    local version="${1:-}"
    if [[ -z "$version" ]]; then
        info "Fetching latest version..."
        version=$(get_latest_version)
    fi

    info "Installing skeys ${version}"

    stop_services

    local tarball
    tarball=$(download_release "$version")

    install_files "$tarball"
    install_systemd
    cleanup "$tarball"

    echo ""
    info "Installation complete!"
    echo ""
    echo "  Launch skeys from your application menu, or run:"
    echo "    ${INSTALL_DIR}/skeys-app"
    echo ""
    echo "  To uninstall, run:"
    echo "    curl -fsSL https://github.com/${GITHUB_REPO}/releases/latest/download/uninstall.sh | bash"
    echo ""
}

main "$@"
