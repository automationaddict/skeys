# SSH Keys

## Overview

The Keys screen is your central hub for managing SSH key pairs. SSH keys provide a secure, password-less method of authenticating to remote servers and services like GitHub, GitLab, and Bitbucket.

## What Are SSH Keys?

SSH keys come in pairs:

- **Private Key**: Kept secret on your local machine. Never share this file.
- **Public Key**: Shared with servers you want to access. Ends with `.pub`.

When you connect to a server, it challenges your private key to prove your identity without transmitting passwords.

## Key Types

### ED25519 (Recommended)
- Modern elliptic curve algorithm
- Strongest security with smallest key size
- Fastest performance
- Supported by all modern SSH implementations

### RSA
- Traditional algorithm, widely compatible
- Requires larger key sizes (4096 bits recommended)
- Good choice when ED25519 isn't supported

### ECDSA
- Elliptic curve alternative to RSA
- Good performance and security
- Some concerns about potential NSA backdoors

### Hardware Keys (SK)
- ED25519-SK and ECDSA-SK
- Require physical security keys (YubiKey, etc.)
- Highest security - private key never leaves the hardware

## Generating Keys

1. Click the **Generate Key** button
2. Enter a descriptive name (e.g., `github-work`, `server-prod`)
3. Select the key type (ED25519 recommended)
4. Optionally add a comment to identify the key
5. Optionally set a passphrase for extra security
6. Check **Add to SSH agent** to automatically load the key after creation

### Add to SSH Agent

When generating a new key, you can enable the **Add to SSH agent** option to immediately load the key into the agent. This is convenient when you want to use the key right away without manually adding it later.

### Passphrases

Adding a passphrase encrypts your private key. Even if someone obtains your key file, they cannot use it without the passphrase. The SSH agent can cache your passphrase so you don't need to enter it repeatedly.

## Managing Keys

### Copy Public Key
Click the menu on any key and select **Copy Public Key** to copy it to your clipboard. Paste this into:
- GitHub/GitLab SSH key settings
- Server's `~/.ssh/authorized_keys` file
- Cloud provider SSH key configuration

### Delete Keys
Remove keys you no longer need. This action is irreversible - the key pair will be permanently deleted from your system.

### Add to Agent
Click the menu on any key and select **Add to Agent** to load the key into the SSH agent. The agent holds your keys in memory so you can use them without re-entering your passphrase for each connection.

- **Keys without passphrase**: Added immediately to the agent
- **Passphrase-protected keys**: You'll be prompted to enter the passphrase before the key is loaded

Keys loaded in the agent are indicated by the shield icon. The key timeout setting (configured in Settings) determines how long the key remains in the agent.

### Test Connection
Click the menu on any key and select **Test Connection** to verify your key works with a remote server. This is useful for confirming your key is properly configured before using it for actual work.

#### Service Presets
Quick-select buttons for common Git hosting services:
- **GitHub**: Tests connection to `github.com` as user `git`
- **GitLab**: Tests connection to `gitlab.com` as user `git`
- **Bitbucket**: Tests connection to `bitbucket.org` as user `git`

#### Custom Host
Select **Custom** to test against any SSH server:
- **Host**: The server hostname or IP address
- **User**: The SSH username
- **Port**: The SSH port (default: 22)

#### Connection Results
After testing, you'll see:
- **Success/Failure status**: Whether authentication succeeded
- **Message**: Details about the connection result (e.g., GitHub shows your username)
- **Server Version**: The SSH server software version
- **Latency**: Round-trip connection time in milliseconds

#### Notes
- The key must be loaded in the SSH agent before testing
- For passphrase-protected keys, add the key to the agent first
- Connection tests use a 10-second timeout

## Key Indicators

- **Lock icon**: Key is protected with a passphrase
- **Open lock icon** (orange): Key has no passphrase protection
- **Shield icon**: Key is currently loaded in the SSH agent
- **Warning icon** (orange): Key age exceeds the warning threshold - consider rotating
- **Error icon** (red, pulsing): Key age exceeds the critical threshold - rotation strongly recommended

### Key Rotation Thresholds

Configure expiration thresholds in **Settings > Security**:
- **Warning threshold**: Days before showing an orange warning (default: 90 days)
- **Critical threshold**: Days before showing a red alert (default: 180 days)

These thresholds help you maintain good security hygiene by reminding you to rotate older keys.

## Best Practices

1. **Use unique keys** for different services/servers
2. **Add passphrases** to keys on shared or less secure machines
3. **Use ED25519** unless compatibility requires RSA
4. **Descriptive names** help identify key purposes
5. **Regular rotation** - consider replacing keys periodically
6. **Backup carefully** - store encrypted backups of important keys

## File Locations

Keys are stored in `~/.ssh/`:
- `~/.ssh/keyname` - Private key (permissions should be 600)
- `~/.ssh/keyname.pub` - Public key

## Troubleshooting

### "Permission denied" when connecting
- Ensure your public key is in the server's `authorized_keys`
- Check private key permissions: `chmod 600 ~/.ssh/keyname`
- Verify the correct key is being used

### Key not working with GitHub/GitLab
- Copy the entire public key including the `ssh-ed25519` prefix
- Ensure no extra whitespace or line breaks
- Check the key is added to the correct account
