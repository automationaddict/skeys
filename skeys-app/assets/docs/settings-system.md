# System Settings

## Overview

The System tab provides visibility into the running SKeys processes and control over the systemd service. Use this tab to monitor process health and manage automatic startup.

## Desktop Application

Shows all running instances of the SKeys desktop application (`skeys-app`).

### Process Information

For each running instance, you'll see:

- **PID**: The process ID
- **Start Method**: How the process was started (e.g., Terminal, systemd, App launcher)
- **Started**: When the process was launched
- **Command**: The full command line used to start the process

### Multiple Instances

Normally, only one desktop application instance should be running. If you see multiple instances:

- The card border turns orange as a warning
- This may indicate the single-instance lock failed
- Consider closing extra instances to avoid conflicts

## Daemon

Shows all running instances of the SKeys daemon (`skeys-daemon`).

### Process Information

Similar to the desktop app, each daemon instance displays:

- **PID**: The process ID
- **Start Method**: How the daemon was started
- **Started**: When the daemon was launched
- **Command**: The full command line

### Expected State

The daemon should typically be:

- Running as a single instance
- Started by systemd for automatic startup
- Active whenever you need SSH key management

If no daemon is running, SSH agent functionality will not be available.

## Systemd Service

Controls the `skeys-daemon.service` user service that manages the daemon.

### Status Indicators

- **Active**: Green if the service is currently running, red if stopped
- **Enabled**: Blue if set to start on login, gray if disabled

### Control Buttons

- **Start**: Start the daemon service (disabled if already running)
- **Stop**: Stop the daemon service (disabled if not running)
- **Restart**: Stop and restart the daemon service

### Start on Login

The switch controls whether the daemon starts automatically when you log in:

- **Enabled**: The daemon starts automatically on login via systemd
- **Disabled**: You must start the daemon manually

For normal use, keep this enabled so SSH agent functionality is always available.

### Systemd Commands

Behind the scenes, the controls run these commands:

- Start: `systemctl --user start skeys-daemon`
- Stop: `systemctl --user stop skeys-daemon`
- Restart: `systemctl --user restart skeys-daemon`
- Enable: `systemctl --user enable skeys-daemon`
- Disable: `systemctl --user disable skeys-daemon`

## Troubleshooting

### Daemon Not Starting

If the daemon won't start:

1. Check the systemd service status: `systemctl --user status skeys-daemon`
2. View logs: `journalctl --user -u skeys-daemon`
3. Ensure the daemon binary exists at the expected location

### Multiple Daemons Running

If multiple daemon instances are running:

1. This can cause socket conflicts
2. Stop all instances and restart via systemd
3. Check if something else is spawning the daemon

### Service Not Found

If systemd commands fail with "service not found":

1. The service file may not be installed
2. Run `systemctl --user daemon-reload` to reload service files
3. Reinstall SKeys if the service file is missing

---

[Open System Settings](skeys://settings/system)
