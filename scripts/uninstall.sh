#!/bin/bash
# SKeys Uninstallation Script
# Removes skeys and all associated files
set -euo pipefail

INSTALL_DIR="${HOME}/.local/share/skeys"
BIN_DIR="${HOME}/.local/bin"
SYSTEMD_DIR="${HOME}/.config/systemd/user"
APPLICATIONS_DIR="${HOME}/.local/share/applications"
ICONS_DIR="${HOME}/.local/share/icons/hicolor"
CACHE_DIR="${HOME}/.cache/skeys"
CONFIG_DIR="${HOME}/.config/skeys"
APP_DATA_DIR="${HOME}/.local/share/com.skeys.skeys-app"
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
SSH_CONFIG="${HOME}/.ssh/config"
# SharedPreferences file (Flutter shared_preferences plugin on Linux)
PREFS_FILE="${HOME}/.local/share/com.skeys.skeys-app/shared_preferences.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Reset the SSH config prompt flag in SharedPreferences
# This ensures the first-run dialog shows again on next install
reset_ssh_prompt_flag() {
    if [[ ! -f "$PREFS_FILE" ]]; then
        return
    fi

    # Check if jq is available for safe JSON editing
    if command -v jq &>/dev/null; then
        local tmp_file
        tmp_file=$(mktemp)
        if jq 'del(.["flutter.ssh_config_prompt_shown"])' "$PREFS_FILE" > "$tmp_file" 2>/dev/null; then
            mv "$tmp_file" "$PREFS_FILE"
            info "Reset SSH config prompt flag"
        else
            rm -f "$tmp_file"
        fi
    else
        # Fallback: use sed to remove the key (less safe but works for simple cases)
        if grep -q "flutter.ssh_config_prompt_shown" "$PREFS_FILE" 2>/dev/null; then
            sed -i 's/"flutter.ssh_config_prompt_shown":[^,}]*//' "$PREFS_FILE"
            # Clean up any resulting double commas or leading/trailing commas
            sed -i 's/,,/,/g; s/{,/{/g; s/,}/}/g' "$PREFS_FILE"
            info "Reset SSH config prompt flag"
        fi
    fi
}

# Remove skeys managed block from SSH config
remove_ssh_config() {
    if [[ ! -f "$SSH_CONFIG" ]]; then
        return
    fi

    # Check if the managed block exists
    if ! grep -q "# BEGIN skeys managed block" "$SSH_CONFIG" 2>/dev/null; then
        return
    fi

    info "Removing skeys configuration from SSH config..."

    # Create a backup
    cp "$SSH_CONFIG" "${SSH_CONFIG}.skeys-backup"

    # Remove lines between BEGIN and END markers (inclusive)
    sed -i '/# BEGIN skeys managed block/,/# END skeys managed block/d' "$SSH_CONFIG"

    # Remove any trailing empty lines at end of file
    sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$SSH_CONFIG" 2>/dev/null || true

    info "SSH config cleaned (backup at ${SSH_CONFIG}.skeys-backup)"
}

# Stop and disable systemd services
stop_services() {
    info "Stopping services..."

    # Stop and disable timer
    if systemctl --user is-active --quiet skeys-update.timer 2>/dev/null; then
        systemctl --user stop skeys-update.timer || true
    fi
    systemctl --user disable skeys-update.timer 2>/dev/null || true

    # Stop daemon service
    if systemctl --user is-active --quiet skeys-daemon.service 2>/dev/null; then
        systemctl --user stop skeys-daemon.service || true
    fi
    systemctl --user disable skeys-daemon.service 2>/dev/null || true
}

# Remove systemd unit files
remove_systemd() {
    info "Removing systemd services..."
    rm -f "${SYSTEMD_DIR}/skeys-daemon.service"
    rm -f "${SYSTEMD_DIR}/skeys-update.service"
    rm -f "${SYSTEMD_DIR}/skeys-update.timer"
    systemctl --user daemon-reload 2>/dev/null || true
}

# Remove installed files
remove_files() {
    info "Removing installed files..."

    # Remove app bundle
    rm -rf "$INSTALL_DIR"
    rm -rf "${INSTALL_DIR}.backup"

    # Remove daemon symlink
    rm -f "${BIN_DIR}/skeys-daemon"

    # Remove desktop entry
    rm -f "${APPLICATIONS_DIR}/com.skeys.skeys-app.desktop"

    # Remove icons
    for size in 16 32 48 64 128 256 512 1024; do
        rm -f "${ICONS_DIR}/${size}x${size}/apps/com.skeys.skeys-app.png"
    done

    # Update icon cache
    gtk-update-icon-cache -f -t "$ICONS_DIR" 2>/dev/null || true

    # Remove runtime sockets
    rm -f "${RUNTIME_DIR}/skeys.sock"
    rm -f "${RUNTIME_DIR}/skeys-agent.sock"
    rm -rf "${RUNTIME_DIR}/skeys"
}

# Optionally remove user data
remove_user_data() {
    echo ""
    read -p "Remove user configuration and cache? [y/N] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info "Removing user data..."
        rm -rf "$CACHE_DIR"
        rm -rf "$CONFIG_DIR"
        rm -rf "$APP_DATA_DIR"
    else
        info "Keeping user data in ${CONFIG_DIR}, ${CACHE_DIR}, and ${APP_DATA_DIR}"
    fi
}

main() {
    echo ""
    echo "  SKeys Uninstaller"
    echo ""

    if [[ ! -d "$INSTALL_DIR" ]]; then
        warn "SKeys does not appear to be installed"
        exit 0
    fi

    stop_services
    remove_ssh_config
    reset_ssh_prompt_flag
    remove_systemd
    remove_files

    # Only prompt for user data removal in interactive mode
    if [[ -t 0 ]]; then
        remove_user_data
    fi

    echo ""
    info "SKeys has been uninstalled"
    echo ""
}

main "$@"
