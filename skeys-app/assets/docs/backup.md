# Backup & Restore

## Overview

The Backup & Restore feature allows you to export your entire SSH configuration to a single encrypted file, making it easy to migrate to a new computer or create secure backups of your SSH setup.

## What Gets Backed Up?

### SSH Keys
- All private and public key pairs
- Key files are stored with their original names
- Permissions are preserved during restore

### SSH Config
- Your `~/.ssh/config` file
- Host aliases and connection settings
- Custom options per host

### Known Hosts
- The `~/.ssh/known_hosts` file
- Trusted server fingerprints
- Protects against future MITM attacks

### Authorized Keys (Optional)
- The `~/.ssh/authorized_keys` file
- Keys that can access your machine
- Usually not needed for migration

## Creating a Backup

### Step 1: Open Settings
Click the settings icon in the navigation rail, then select the "Backup" tab.

### Step 2: Click Export
This opens the export dialog with backup options.

### Step 3: Select What to Include
- **SSH Keys**: Your private and public key pairs
- **SSH Config**: Host aliases and settings
- **Known Hosts**: Trusted server fingerprints
- **Authorized Keys**: Keys allowed to access your machine (usually not needed)

### Step 4: Set a Strong Passphrase
Your backup will be encrypted with this passphrase. Requirements:
- At least 8 characters
- Use a mix of letters, numbers, and symbols
- Don't reuse passwords from other accounts
- **Store this passphrase securely** - you'll need it to restore

### Step 5: Choose Save Location
Select where to save the `.skbak` file.

## Restoring from Backup

### Step 1: Open Import Dialog
Go to Settings > Backup > Import

### Step 2: Select Backup File
Click to browse for your `.skbak` file.

### Step 3: Enter Passphrase
Enter the passphrase you used when creating the backup.

### Step 4: Unlock and Preview
Click "Unlock" to decrypt and preview the backup contents:
- Source computer name
- Creation date
- Number of keys
- What's included

### Step 5: Select What to Restore
Choose which items to restore. You might not need everything:
- Keys: Usually want these
- Config: Usually want this
- Known Hosts: Recommended to keep your own
- Authorized Keys: Usually skip unless replacing

### Step 6: Handle Existing Files
- **Skip existing**: Won't overwrite any files that already exist
- **Overwrite existing**: Replace all matching files with backup versions

### Step 7: Restore
Click "Restore" to import the selected items.

## Security

### Encryption
Backups are encrypted with:
- **AES-256-GCM**: Military-grade encryption
- **PBKDF2**: 100,000 iterations for key derivation
- **Random salt**: Unique encryption per backup

### What This Means
- Without the passphrase, the backup is unreadable
- Each backup uses unique encryption parameters
- Brute-force attacks are computationally infeasible

### Best Practices

1. **Use a strong passphrase** - This is your only protection
2. **Store the passphrase separately** - Use a password manager
3. **Don't email backups** - Transfer via secure means (USB, secure file share)
4. **Delete old backups** - Don't leave copies lying around
5. **Verify after restore** - Test that SSH still works

## File Format

Backup files use the `.skbak` extension and contain:
- Magic header for format verification
- Encrypted tarball with gzip compression
- Metadata (creation time, source hostname)

## Migration Workflow

### Moving to a New Computer

1. **On old computer:**
   - Export backup with all options
   - Use a strong passphrase
   - Transfer file securely to new computer

2. **On new computer:**
   - Install SKeys
   - Import backup
   - Enter passphrase
   - Select all items to restore

3. **Verify:**
   - Test SSH connections
   - Verify keys are working
   - Check config aliases work

### Creating Regular Backups

1. Export backup monthly or after adding new keys
2. Use consistent passphrases (or store in password manager)
3. Keep backups in a secure location (encrypted drive, secure cloud)
4. Rotate old backups periodically

## Troubleshooting

### "Incorrect passphrase"
- Double-check the passphrase
- Ensure CAPS LOCK is off
- Try typing it in a text field first to verify

### "Decryption failed"
- The file may be corrupted
- Try a different backup if available
- Ensure the file wasn't modified during transfer

### Keys not working after restore
- Check file permissions: keys should be 600
- Verify the correct key is being used
- Try adding the key to the SSH agent

### Config not loading
- Check for syntax errors
- Verify file permissions (should be 644)
- Restart your terminal

## Limitations

- Backup doesn't include SSH agent state
- Hardware keys (YubiKey, etc.) can't be backed up
- Very large known_hosts files may be slow

## Privacy

- Backups contain sensitive private keys
- Encrypted backups are safe for cloud storage
- Unencrypted data never leaves your computer
