# Update Settings

## Overview

The Update tab allows you to check for new versions of SKeys, download updates, and configure automatic update behavior. Updates are distributed via GitHub Releases.

## Update Status

The status card at the top shows your current state:

- **Up to Date**: You're running the latest version
- **Update Available**: A new version is ready to download
- **Downloading**: An update is being downloaded
- **Ready to Install**: Downloaded update is ready to apply

### Checking for Updates

Click **Check Now** to manually check for the latest version. This queries the GitHub Releases API to find new versions.

### Downloading Updates

When an update is available, click **Download** to fetch the release tarball. The download shows progress with bytes transferred.

### Installing Updates

After download completes, click **Install** to apply the update. This will:

1. Verify the download checksum
2. Stop the running daemon
3. Back up the current installation
4. Extract and install the new version
5. Restart the daemon

The app will continue running during the update process.

## Automatic Updates

Configure how updates are handled automatically:

### Check Automatically

When enabled, SKeys checks for updates when the daemon starts. This happens in the background without interrupting your work.

### Download Automatically

When enabled, available updates are downloaded automatically in the background. You'll be notified when a download completes and is ready to install.

### Apply Automatically

When enabled, downloaded updates are installed automatically and the daemon restarts. Use this for a hands-off update experience.

### Include Prereleases

Enable this to receive beta and preview versions. Prereleases may include new features but could be less stable than regular releases.

## Update Process

### What Gets Updated

The update replaces:

- The Flutter application bundle
- The Go daemon binary
- Desktop entry and icons

### What's Preserved

Your data is never touched:

- SSH keys (`~/.ssh/`)
- Configuration (`~/.config/skeys/`)
- Cache (`~/.cache/skeys/`)

### Rollback

If an update fails, the previous version is automatically restored from the backup created during installation.

## Manual Update

You can also update manually by downloading from GitHub:

1. Visit the [Releases page](https://github.com/johnnelson/skeys/releases)
2. Download the latest tarball
3. Extract and run `./install.sh`

## Troubleshooting

### Update Check Fails

- Verify internet connectivity
- Check if GitHub is accessible
- Review daemon logs for errors

### Download Fails

- Check available disk space
- Verify network stability
- Try again later if GitHub is experiencing issues

### Installation Fails

- Review error messages in the status
- Check file permissions in `~/.local/share/skeys/`
- Ensure no other skeys processes are running

---

[Open Update Settings](skeys://settings/update)
