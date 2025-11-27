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
4. For RSA keys, select the bit size (4096 recommended)
5. For ECDSA keys, select the curve size (256, 384, or 521 bits)
6. Optionally add a comment to identify the key
7. Optionally set a passphrase for extra security
8. Check **Add to SSH agent** to automatically load the key after creation

### Passphrases

Adding a passphrase encrypts your private key. Even if someone obtains your key file, they cannot use it without the passphrase. The SSH agent can cache your passphrase so you don't need to enter it repeatedly.

When setting a passphrase, you'll need to confirm it by entering it twice.

## Managing Keys

### Copy Public Key
Click the menu on any key and select **Copy Public Key** to copy it to your clipboard. Paste this into:
- GitHub/GitLab SSH key settings
- Server's `~/.ssh/authorized_keys` file
- Cloud provider SSH key configuration

### Delete Keys
Remove keys you no longer need. This action is irreversible - the key pair will be permanently deleted from your system.

### Add to Agent

Click the menu on any key and select **Add to Agent** to load the key into the SSH agent. This opens a dialog where you must verify the key works with a service before it's added.

#### Service Verification

Before adding a key to the agent, you'll verify it works with a service:

1. **Select a service** - Choose from presets (GitHub, GitLab, Bitbucket) or Custom
2. **Enter passphrase** (if required) - For passphrase-protected keys
3. **Click "Verify & Add"** - Tests the connection and adds the key if successful

This verification step ensures your key is properly configured before you start using it.

#### Service Presets

Quick-select buttons for common Git hosting services:
- **GitHub**: Tests connection to `github.com` as user `git`
- **GitLab**: Tests connection to `gitlab.com` as user `git`
- **Bitbucket**: Tests connection to `bitbucket.org` as user `git`

#### Custom Host

Select **Custom** to verify against any SSH server:
- **Host**: The server hostname or IP address
- **User**: The SSH username
- **Port**: The SSH port (default: 22)

#### Host Key Verification

When connecting to a host for the first time, you'll see an **Unknown Host** dialog. This is a critical security step that protects you from man-in-the-middle attacks.

##### What is a Host Key?

Every SSH server has a unique cryptographic key that identifies it. The first time you connect to a server, SSH asks you to verify this key is legitimate. This prevents attackers from impersonating servers you trust.

##### Unknown Host Dialog

The dialog displays:
- **Host**: The server hostname you're connecting to
- **Port**: The SSH port (usually 22)
- **Key Type**: The cryptographic algorithm (e.g., ED25519, RSA, ECDSA)
- **Fingerprint**: A unique hash identifying this specific server key

The fingerprint looks like: `SHA256:ABC123...` (a long string of characters)

##### Verifying the Fingerprint

Before clicking **Trust & Connect**, you should verify the fingerprint is correct:

1. **For GitHub/GitLab/Bitbucket**: Compare against their published fingerprints in their documentation
2. **For your own servers**: Get the fingerprint from your server administrator or check the server directly
3. **For cloud providers**: Check the instance console or provider documentation

You can click the copy button next to the fingerprint to copy it for comparison.

##### Your Options

- **Trust & Connect**: Accepts the host key, adds it to your `~/.ssh/known_hosts` file, and continues with the connection. Only click this if you've verified the fingerprint.
- **Cancel**: Aborts the connection without saving the host key. Use this if you're unsure or the fingerprint doesn't match.

##### Host Key Mismatch Warning

If you see a **Host Key Mismatch** warning with a red alert, the server's key has changed since you last connected. This is a serious warning that could indicate:

- **Legitimate change**: The server was reinstalled, upgraded, or had its SSH keys regenerated
- **Security threat**: Someone may be intercepting your connection (man-in-the-middle attack)

The dialog shows:
- A prominent red warning banner
- The new key information (host, key type, fingerprint)
- Instructions to contact your administrator

**Do not proceed** until you've confirmed with your server administrator that the key change is legitimate. If verified, you'll need to remove the old entry from `~/.ssh/known_hosts` before reconnecting (you can do this from the Known Hosts screen).

#### Stored Service Information

After successful verification, SKeys remembers which service you verified with. This allows quick re-testing via the **Test Connection** menu option without re-entering details.

### Test Connection

After a key is loaded in the agent, the **Test Connection** option appears in the key's menu. This re-tests the connection using the service you originally verified with.

#### Connection Results
After testing, you'll see:
- **Success/Failure status**: Whether authentication succeeded
- **Message**: Details about the connection result (e.g., GitHub shows your username)
- **Server Version**: The SSH server software version
- **Latency**: Round-trip connection time in milliseconds

#### Notes
- Test Connection only appears for keys currently loaded in the agent
- Uses the service/host information stored during the "Add to Agent" verification
- If no service info is stored, you'll be prompted to re-add the key to set it up
- Connection tests use a 10-second timeout

## Key Indicators

Each key in the list shows status indicators:

- **Lock icon** (green): Key is protected with a passphrase
- **Open lock icon** (orange): Key has no passphrase protection
- **Shield icon** (blue): Key is currently loaded in the SSH agent
- **Warning icon** (orange): Key age exceeds the warning threshold - consider rotating
- **Error icon** (red, pulsing): Key age exceeds the critical threshold - rotation strongly recommended

### Key Rotation Thresholds

Configure expiration thresholds in **Settings > Security**:
- **Warning threshold**: Days before showing an orange warning (default: 90 days)
- **Critical threshold**: Days before showing a red alert (default: 180 days)

These thresholds help you maintain good security hygiene by reminding you to rotate older keys. Keys older than the warning threshold show a yellow indicator, while keys older than the critical threshold show a pulsing red indicator.

## Best Practices

1. **Use unique keys** for different services/servers
2. **Add passphrases** to keys on shared or less secure machines
3. **Use ED25519** unless compatibility requires RSA
4. **Descriptive names** help identify key purposes
5. **Regular rotation** - consider replacing keys periodically
6. **Backup carefully** - store encrypted backups of important keys
7. **Verify host keys** - always confirm fingerprints for new hosts

## File Locations

Keys are stored in `~/.ssh/`:
- `~/.ssh/keyname` - Private key (permissions should be 600)
- `~/.ssh/keyname.pub` - Public key

## Troubleshooting

### "Permission denied" when connecting
- Ensure your public key is in the server's `authorized_keys`
- Check private key permissions: `chmod 600 ~/.ssh/keyname`
- Verify the correct key is being used
- Make sure the key is loaded in the SSH agent

### Key not working with GitHub/GitLab
- Copy the entire public key including the `ssh-ed25519` prefix
- Ensure no extra whitespace or line breaks
- Check the key is added to the correct account

### "No verified service found" when testing connection
- The key needs to be re-added to the agent with service verification
- Use **Add to Agent** and select a service to verify against

### Host key mismatch warning
- The server's host key has changed since you last connected
- Verify with your server administrator that the change is legitimate
- If legitimate, remove the old entry from `~/.ssh/known_hosts` and reconnect
