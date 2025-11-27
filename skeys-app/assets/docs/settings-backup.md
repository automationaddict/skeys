# Backup Settings

## Overview

The Backup tab allows you to export and import your SSH configuration. This is useful for migrating to a new computer, creating secure backups, or restoring after a system reinstall.

## Export Backup

Creates an encrypted archive of your SSH keys and configuration.

### What's Included

The backup can include:
- **SSH Keys**: Your private and public key pairs
- **SSH Config**: Your `~/.ssh/config` client configuration
- **Known Hosts**: Your `~/.ssh/known_hosts` file with trusted server fingerprints
- **Authorized Keys**: Your `~/.ssh/authorized_keys` file

You can select which items to include in the backup.

### Encryption

All backups are encrypted using **AES-256-GCM**, a strong authenticated encryption algorithm. You'll be prompted to create a password that protects the backup.

**Important:**
- Choose a strong, memorable password
- Without this password, the backup cannot be restored
- Store the password securely, separate from the backup file

### Backup File

The backup is saved as a `.skeys` file that you can store anywhere:
- External drive
- Cloud storage
- Another computer

## Import Backup

Restores SSH configuration from a previously created backup.

### Restore Process

1. Select a `.skeys` backup file
2. Enter the password used when creating the backup
3. Choose which items to restore
4. Confirm the import

### Conflict Handling

When importing, if files already exist:
- You'll be warned about potential overwrites
- Existing files can be backed up before replacement
- You can choose to skip conflicting items

## Best Practices

### Regular Backups

- Create backups before major system changes
- Keep backups updated when you add new keys
- Store multiple copies in different locations

### Security Considerations

- Use strong, unique passwords for backups
- Don't store backup passwords in the same location as backups
- Consider using a password manager for backup passwords
- Delete old backups when no longer needed

### Testing Backups

Periodically verify your backups work:
1. Create a backup
2. Test restoring to a temporary location (if possible)
3. Verify the contents are complete

---

[Open Backup Settings](skeys://settings/backup)
