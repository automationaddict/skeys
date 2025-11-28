# SSH Server Status

## Overview

The Server page displays the status of your SSH client and server installations, and provides controls for managing the SSH server service (sshd).

## System Information

Shows your Linux distribution and version. SKeys uses this to provide appropriate installation instructions if SSH components are missing.

### Backend Connection Status

In the top-right corner of the System Information card, you'll see the backend connection status:

- **Backend: Connected** (green): The app is connected to the skeys-daemon service
- **Backend: Disconnected** (red): Connection to the daemon has been lost
- **Backend: Reconnecting...** (orange): Attempting to restore the connection

If disconnected, click the status badge to open a dialog with:
- Error details (if available)
- Troubleshooting commands to check and restart the daemon
- A reconnect button to attempt restoration

The backend daemon (`skeys-daemon`) handles all SSH operations. If it becomes disconnected, most app features will be unavailable until the connection is restored.

## SSH Client

The SSH client (`ssh`) is used to connect to remote servers.

### Status Indicators

- **Installed**: Green checkmark when the SSH client is installed
- **Not Installed**: Red X with instructions to install

### Information Displayed

When installed, you'll see:

- **Version**: The installed OpenSSH client version
- **Binary**: Path to the ssh executable
- **System Config**: Location of `/etc/ssh/ssh_config` (system-wide settings)
- **User Config**: Location of `~/.ssh/config` (your personal settings)

### Installing the Client

If not installed, click "How to Install" for distribution-specific instructions. On most systems:

```bash
# Ubuntu/Debian
sudo apt install openssh-client

# Fedora/RHEL
sudo dnf install openssh-clients

# Arch Linux
sudo pacman -S openssh
```

## SSH Server

The SSH server (`sshd`) allows other computers to connect to your machine.

### Status Indicators

- **Running** (green): Server is active and accepting connections
- **Stopped** (orange): Server is installed but not running
- **Failed** (red): Server encountered an error
- **Not Installed**: Server package not installed

### Service Controls

When the server is installed, you can:

- **Start**: Launch the SSH server service
- **Stop**: Shut down the SSH server
- **Restart**: Stop and start the service (useful after config changes)

These operations require appropriate permissions and use systemd to manage the service. You'll be prompted for your password via a system dialog.

### Auto-start Toggle

The **Auto-start** switch controls whether the SSH server starts automatically when your computer boots:

- **On (Starts on boot)**: The SSH server will start automatically at system startup
- **Off (Manual start only)**: You must manually start the service when needed

Toggle this switch to enable or disable auto-start. This is equivalent to running `systemctl enable ssh` or `systemctl disable ssh`.

### Information Displayed

When installed, you'll see:

- **Version**: The installed OpenSSH server version
- **Binary**: Path to the sshd executable
- **Service**: The systemd service name (usually `sshd` or `ssh`)
- **PID**: Process ID when running
- **Started**: When the service was last started
- **Config**: Path to `/etc/ssh/sshd_config`

### Installing the Server

If not installed, click "How to Install" for distribution-specific instructions. On most systems:

```bash
# Ubuntu/Debian
sudo apt install openssh-server

# Fedora/RHEL
sudo dnf install openssh-server

# Arch Linux
sudo pacman -S openssh
```

After installation, enable and start the service:

```bash
sudo systemctl enable --now sshd
```

## Config File Status

For each configuration file, SKeys shows:

- **Exists**: Whether the file is present on disk
- **Readable**: Whether SKeys can read the file contents

If a config file shows "Not Readable", you may need to adjust permissions or use the Config tab to view server settings with elevated privileges.

## Common Tasks

### Check if SSH is Working

1. Verify the client shows "Installed"
2. If you need to accept incoming connections, ensure the server shows "Running"

### Troubleshoot Connection Issues

1. Check if the server is running
2. Verify the config file is readable
3. Use the Config tab to review settings

### After Config Changes

After modifying `/etc/ssh/sshd_config`:

1. Return to this page
2. Click "Restart" to apply changes
3. Verify the server returns to "Running" status

### Troubleshooting Service Failures

If the SSH server fails to start, SKeys will show an error message with details. Common issues:

- **sshd_config file is missing**: The configuration file was deleted or never created. Reinstall openssh-server: `sudo apt reinstall openssh-server`
- **Configuration error**: There's a syntax error in sshd_config. Run `sudo sshd -t` to check the config
- **Port already in use**: Another process is using port 22. Check with `sudo lsof -i :22`
- **Permission denied**: File permission issues. Check ownership of `/etc/ssh/` files

For detailed logs, run:
```bash
journalctl -u ssh.service -n 20
```

---

[View Server Status](skeys://server)
