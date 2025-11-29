# Quick Start Guide

Get up and running with skeys in just a few minutes. This guide will walk you through the essential steps to start managing your SSH keys and connections.

## First Steps

### 1. Check SSH Server Status

When you first open skeys, check if your SSH server is running:

1. Navigate to **[SSH Server Status](skeys://help/server)** in the sidebar
2. View the current server status
3. Start the server if needed using the "Start Server" button

### 2. Generate Your First SSH Key

SSH keys are more secure than passwords and essential for modern SSH usage:

1. Go to **[SSH Keys](skeys://help/keys)** in the sidebar
2. Click the **"Generate Key"** button
3. Choose a key type:
   - **Ed25519** - Recommended for most users (modern, secure, fast)
   - **RSA 4096** - Good compatibility with older systems
4. Enter a name for your key (e.g., "github", "work-server")
5. Optionally add a passphrase for extra security
6. Click **"Generate"**

Your new key will appear in the keys list with its fingerprint and creation date.

### 3. Add Your Key to the SSH Agent

The SSH agent holds your keys in memory so you don't have to enter passphrases repeatedly:

1. In the **[SSH Keys](skeys://help/keys)** page, find your new key
2. Click the **"Add to Agent"** button
3. If your key has a passphrase, enter it
4. Optionally specify a service (e.g., "github.com") for easy identification

Your key is now loaded and ready to use!

### 4. Copy Your Public Key

To use your key with remote services (GitHub, servers, etc.), you need to copy the public key:

1. In the **[SSH Keys](skeys://help/keys)** page, find your key
2. Click the **"Copy Public Key"** button
3. Paste the key where needed:
   - **GitHub/GitLab**: Settings → SSH Keys
   - **Remote Server**: Paste into `~/.ssh/authorized_keys`

## Common Tasks

### Connect to a Remote Server

If you need to manage connections to remote SSH servers:

1. Go to **[Remote Servers](skeys://help/remotes)**
2. Click **"Add Remote"**
3. Enter the connection details:
   - Name (e.g., "My VPS")
   - Host (IP address or domain)
   - Port (usually 22)
   - User (your username on the server)
4. Click **"Add"**
5. Click **"Connect"** to establish the connection

### Configure SSH Client

Customize how SSH connects to different hosts:

1. Go to **[Configuration](skeys://help/config-client)** → **Client Config**
2. Click **"Add Host"** to create a new configuration entry
3. Set up host-specific options:
   - Host alias (shortcut name)
   - Hostname or IP
   - User
   - Port
   - Identity file (which key to use)
4. Save your configuration

Now you can use the alias instead of typing full connection details!

### Manage Known Hosts

When you connect to a server for the first time, its host key is stored:

1. Go to **[Hosts](skeys://help/hosts-known)** → **Known Hosts**
2. View all servers you've connected to
3. Verify fingerprints match what the server administrator provided
4. Remove entries for servers you no longer trust

### Test Your Connection

After adding a key to the agent:

1. In **[SSH Keys](skeys://help/keys)**, find your key
2. If the key is in the agent, you'll see a **"Test Connection"** button
3. Click it to verify your key works with the configured service
4. View connection results including latency and server version

## Essential Keyboard Shortcuts

- **F1** - Open help for the current page
- **Ctrl+H** - Open comprehensive help dialog

## Next Steps

Now that you're set up, explore more features:

- **[Backup & Restore](skeys://help/backup)** - Back up your SSH configuration
- **[Settings](skeys://help/settings-display)** - Customize skeys appearance and behavior
- **[SSH Agent](skeys://help/agent)** - Learn more about agent features
- **[Server Config](skeys://help/config-server)** - Configure your SSH server

## Need Help?

- Press **F1** on any page for context-specific help
- Check the **[FAQ](skeys://help/faq)** for common questions
- Visit **[Troubleshooting](skeys://help/troubleshooting)** if you encounter issues
- Read the **[SSH Overview](skeys://help/ssh-overview)** to understand SSH concepts

## Tips for Success

1. **Always use passphrases** - Protect your private keys with strong passphrases
2. **Use Ed25519 keys** - They're more secure and faster than RSA
3. **Keep keys backed up** - Use the backup feature regularly
4. **Verify host keys** - Always verify fingerprints on first connection
5. **Use the SSH agent** - It's more convenient and secure than typing passphrases repeatedly
6. **Give keys descriptive names** - Makes it easier to manage multiple keys

## Common Workflows

### Setting Up GitHub Access

1. Generate an Ed25519 key named "github"
2. Add it to the SSH agent with service "github.com"
3. Copy the public key
4. Add it to GitHub Settings → SSH Keys
5. Test with: `ssh -T git@github.com`

### Accessing a Remote Server

1. Generate a key for the server
2. Copy the public key
3. Log into the server and add the key to `~/.ssh/authorized_keys`
4. Add the key to the agent in skeys
5. Configure the host in Client Config for easy access
6. Connect using your configured alias

### Managing Multiple Keys

1. Generate separate keys for different purposes (work, personal, specific servers)
2. Give each key a descriptive name
3. Add all keys to the agent with appropriate service labels
4. Use Client Config to specify which key to use for each host
5. Monitor loaded keys in the SSH Agent page
