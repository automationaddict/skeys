# Installation & Uninstallation

This guide covers how to install, update, and uninstall skeys on your system.

## System Requirements

- **Operating System**: Linux (Ubuntu 20.04+, Debian 11+, Fedora 35+, or similar)
- **Desktop Environment**: X11 or Wayland
- **Dependencies**: OpenSSH (usually pre-installed)
- **Disk Space**: ~100 MB

## Installation

### AppImage (Recommended)

The easiest way to run skeys is using the AppImage:

1. **Download the latest release**:
   - Visit the [skeys releases page](https://github.com/automationaddict/skeys/releases)
   - Download `skeys-app-x86_64.AppImage`

2. **Make it executable**:
   ```bash
   chmod +x skeys-app-x86_64.AppImage
   ```

3. **Run skeys**:
   ```bash
   ./skeys-app-x86_64.AppImage
   ```

4. **Optional - Add to Applications Menu**:
   ```bash
   # Create desktop entry
   cat > ~/.local/share/applications/skeys.desktop <<'EOF'
   [Desktop Entry]
   Name=skeys
   Comment=SSH Key and Server Management
   Exec=/path/to/skeys-app-x86_64.AppImage
   Icon=skeys
   Terminal=false
   Type=Application
   Categories=Utility;Network;
   EOF
   ```

### Flatpak

Install via Flatpak for better integration:

1. **Add the Flathub repository** (if not already added):
   ```bash
   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
   ```

2. **Install skeys**:
   ```bash
   flatpak install flathub com.github.automationaddict.skeys
   ```

3. **Run skeys**:
   ```bash
   flatpak run com.github.automationaddict.skeys
   ```

### Debian/Ubuntu Package

Install the `.deb` package on Debian-based systems:

1. **Download the package**:
   - Visit the [skeys releases page](https://github.com/automationaddict/skeys/releases)
   - Download `skeys-app_<version>_amd64.deb`

2. **Install the package**:
   ```bash
   sudo dpkg -i skeys-app_<version>_amd64.deb
   ```

3. **Install dependencies** (if needed):
   ```bash
   sudo apt-get install -f
   ```

4. **Run skeys**:
   ```bash
   skeys-app
   ```

### RPM Package (Fedora, RHEL, CentOS)

Install the `.rpm` package on RPM-based systems:

1. **Download the package**:
   - Visit the [skeys releases page](https://github.com/automationaddict/skeys/releases)
   - Download `skeys-app-<version>.x86_64.rpm`

2. **Install the package**:
   ```bash
   sudo rpm -i skeys-app-<version>.x86_64.rpm
   ```

   Or using DNF:
   ```bash
   sudo dnf install skeys-app-<version>.x86_64.rpm
   ```

3. **Run skeys**:
   ```bash
   skeys-app
   ```

### Build from Source

For the latest development version or to contribute:

1. **Install dependencies**:
   ```bash
   # Flutter SDK
   # Install from https://flutter.dev/docs/get-started/install/linux

   # Build tools
   sudo apt-get install cmake ninja-build libgtk-3-dev
   ```

2. **Clone the repository**:
   ```bash
   git clone https://github.com/automationaddict/skeys.git
   cd skeys/skeys-app
   ```

3. **Get dependencies**:
   ```bash
   flutter pub get
   ```

4. **Build the application**:
   ```bash
   flutter build linux --release
   ```

5. **Run the built application**:
   ```bash
   ./build/linux/x64/release/bundle/skeys-app
   ```

## First Run

On first launch, skeys will:

1. Check for SSH server installation
2. Create necessary directories in `~/.ssh/`
3. Initialize the application database
4. Show the welcome screen

## Updating

### AppImage

1. Download the latest AppImage from the releases page
2. Replace your existing AppImage file
3. Run the new version

### Flatpak

```bash
flatpak update com.github.automationaddict.skeys
```

### Debian/Ubuntu Package

```bash
# Download the new .deb package
sudo dpkg -i skeys-app_<new-version>_amd64.deb
```

### RPM Package

```bash
# Download the new .rpm package
sudo rpm -U skeys-app-<new-version>.x86_64.rpm
```

## Uninstallation

### AppImage

1. **Delete the AppImage file**:
   ```bash
   rm /path/to/skeys-app-x86_64.AppImage
   ```

2. **Remove desktop entry** (if created):
   ```bash
   rm ~/.local/share/applications/skeys.desktop
   ```

3. **Optional - Remove user data**:
   ```bash
   # Warning: This will delete all skeys settings and backups
   rm -rf ~/.config/skeys-app
   rm -rf ~/.local/share/skeys-app
   ```

4. **SSH files remain untouched**:
   - Your SSH keys, configurations, and known hosts remain in `~/.ssh/`
   - skeys never modifies your SSH files during uninstallation

### Flatpak

```bash
# Uninstall the application
flatpak uninstall com.github.automationaddict.skeys

# Optional - Remove user data
rm -rf ~/.var/app/com.github.automationaddict.skeys
```

### Debian/Ubuntu Package

```bash
# Remove the package
sudo dpkg -r skeys-app

# Or remove including configuration files
sudo dpkg --purge skeys-app

# Optional - Remove user data
rm -rf ~/.config/skeys-app
rm -rf ~/.local/share/skeys-app
```

### RPM Package

```bash
# Remove the package
sudo rpm -e skeys-app

# Or using DNF
sudo dnf remove skeys-app

# Optional - Remove user data
rm -rf ~/.config/skeys-app
rm -rf ~/.local/share/skeys-app
```

## Data Locations

Understanding where skeys stores data:

### Application Data

- **Configuration**: `~/.config/skeys-app/`
  - Application settings
  - Window size and position
  - Theme preferences

- **Application Database**: `~/.local/share/skeys-app/`
  - Key metadata
  - Server connections
  - Backup records

### SSH Data (Managed but Not Owned)

skeys manages but does not own these standard SSH locations:

- **SSH Keys**: `~/.ssh/id_*`
- **SSH Config**: `~/.ssh/config`
- **Server Config**: `/etc/ssh/sshd_config` (requires sudo)
- **Known Hosts**: `~/.ssh/known_hosts`
- **Authorized Keys**: `~/.ssh/authorized_keys`

**Important**: Uninstalling skeys NEVER deletes your SSH keys or configurations. These files remain on your system and can be used by any SSH client.

## Troubleshooting Installation

### AppImage Won't Run

**Problem**: Double-clicking the AppImage does nothing

**Solution**: Make sure it's executable:
```bash
chmod +x skeys-app-x86_64.AppImage
./skeys-app-x86_64.AppImage
```

### Missing Dependencies

**Problem**: Error about missing libraries

**Solution**: Install required libraries:
```bash
# Ubuntu/Debian
sudo apt-get install libgtk-3-0 libsecret-1-0

# Fedora
sudo dnf install gtk3 libsecret
```

### Permission Denied

**Problem**: Cannot access SSH server configuration

**Solution**: skeys needs sudo privileges to modify server configuration. The app will prompt you when needed.

### Flatpak Sandbox Issues

**Problem**: Cannot access SSH files

**Solution**: Flatpak version has necessary permissions configured. If issues persist:
```bash
# Grant additional permissions
flatpak override --user --filesystem=~/.ssh com.github.automationaddict.skeys
```

## Backup Before Uninstalling

Before uninstalling skeys, consider backing up:

1. **Use the built-in backup feature**:
   - Go to [Backup & Restore](skeys://help/backup)
   - Create a backup of your SSH configuration
   - Save the backup file somewhere safe

2. **Manual backup**:
   ```bash
   # Backup SSH directory
   tar -czf ssh-backup-$(date +%Y%m%d).tar.gz ~/.ssh/

   # Backup skeys settings
   tar -czf skeys-settings-$(date +%Y%m%d).tar.gz ~/.config/skeys-app/
   ```

## Clean Uninstall Checklist

If you want to completely remove all traces of skeys:

- [ ] Uninstall the application using your installation method
- [ ] Remove user configuration: `rm -rf ~/.config/skeys-app`
- [ ] Remove user data: `rm -rf ~/.local/share/skeys-app`
- [ ] Remove desktop entry (if created manually)
- [ ] Remove any saved backups
- [ ] **(Optional)** Remove SSH data - **Warning**: This removes your SSH keys!

## Related Topics

- [Quick Start](skeys://help/quick-start) - Get started after installation
- [Backup & Restore](skeys://help/backup) - Back up your configuration
- [Troubleshooting](skeys://help/troubleshooting) - Common issues and solutions
- [FAQ](skeys://help/faq) - Frequently asked questions
