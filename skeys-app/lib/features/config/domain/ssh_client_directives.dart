// Copyright (c) 2025 John Nelson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// SSH Client (ssh_config) directive definitions.
//
// This file contains comprehensive definitions for common ssh_config directives,
// with detailed help text for user documentation.

/// Represents an SSH client directive definition with help text.
class SshClientDirectiveDefinition {
  /// The directive key (e.g., 'ServerAliveInterval').
  final String key;

  /// Default value for this directive.
  final String defaultValue;

  /// Short description of the directive.
  final String description;

  /// Detailed help text (10-20 lines) explaining the directive.
  final String? helpText;

  /// Creates an SshClientDirectiveDefinition.
  const SshClientDirectiveDefinition({
    required this.key,
    required this.defaultValue,
    required this.description,
    this.helpText,
  });
}

/// Map of SSH client directive keys to their definitions for quick lookup.
final Map<String, SshClientDirectiveDefinition> sshClientDirectiveMap = {
  for (final directive in sshClientDirectives) directive.key: directive,
};

/// Gets the help text for a given directive key, or null if not found.
String? getSshClientDirectiveHelpText(String key) {
  return sshClientDirectiveMap[key]?.helpText;
}

/// Gets the description for a given directive key, or null if not found.
String? getSshClientDirectiveDescription(String key) {
  return sshClientDirectiveMap[key]?.description;
}

/// List of common SSH client directives with detailed help text.
const List<SshClientDirectiveDefinition> sshClientDirectives = [
  // Connection & keepalive
  SshClientDirectiveDefinition(
    key: 'ServerAliveInterval',
    defaultValue: '60',
    description: 'Send keepalive every N seconds',
    helpText:
        '''Specifies the interval in seconds between keepalive messages sent to the server.

How it works:
- SSH client sends a message through the encrypted channel every N seconds
- The server must respond, proving the connection is still active
- If no response is received, ServerAliveCountMax determines when to disconnect

Common values:
- 60: Good balance for most connections (recommended)
- 30: More aggressive, better for unstable networks
- 0: Disable (not recommended, connection may silently die)

Use cases:
- Prevents firewalls/NAT from closing idle connections
- Detects dead connections faster than TCP keepalive
- Essential for long-running sessions or tunnels''',
  ),
  SshClientDirectiveDefinition(
    key: 'ServerAliveCountMax',
    defaultValue: '3',
    description: 'Max keepalive failures before disconnect',
    helpText:
        '''Maximum number of keepalive messages that can go unanswered before SSH disconnects.

How it works:
- Works together with ServerAliveInterval
- Total timeout = ServerAliveInterval × ServerAliveCountMax
- With defaults (60s × 3), connection dies after ~3 minutes of no response

Common values:
- 3: Default, reasonable for most cases
- 1: Aggressive, disconnect quickly on network issues
- 5-10: More tolerant of brief network interruptions

Example scenarios:
- ServerAliveInterval=60, ServerAliveCountMax=3 → 180s timeout
- ServerAliveInterval=30, ServerAliveCountMax=2 → 60s timeout

Lower values detect dead connections faster but may cause
false disconnects on networks with occasional packet loss.''',
  ),
  SshClientDirectiveDefinition(
    key: 'ConnectTimeout',
    defaultValue: '30',
    description: 'Connection timeout in seconds',
    helpText:
        '''Maximum time in seconds to wait when establishing a new SSH connection.

This timeout applies to:
- Initial TCP connection establishment
- DNS resolution (if not already cached)
- SSH protocol negotiation

Common values:
- 30: Good default for most situations
- 10: Fast timeout for local network connections
- 60+: For slow networks or high-latency connections

Does NOT affect:
- Authentication timeout (separate setting)
- Data transfer timeouts
- Keepalive intervals

Setting this too low may cause connections to fail on
slow networks. Setting too high wastes time when servers
are truly unreachable.''',
  ),
  SshClientDirectiveDefinition(
    key: 'TCPKeepAlive',
    defaultValue: 'yes',
    description: 'Enable TCP keepalive messages',
    helpText: '''Enable TCP-level keepalive messages to detect dead connections.

How it works:
- Uses the operating system's TCP keepalive mechanism
- Sends periodic probes at the TCP layer (not encrypted)
- Helps detect when network path is broken

Comparison with ServerAliveInterval:
- TCPKeepAlive: OS-level, not encrypted, detects network issues
- ServerAliveInterval: Application-level, encrypted, more reliable

Recommendation:
- Enable both for best connection stability
- TCPKeepAlive catches network-level issues
- ServerAliveInterval catches application-level issues

Setting to "no" may cause connections to hang indefinitely
if the network path dies without proper termination.''',
  ),
  SshClientDirectiveDefinition(
    key: 'Compression',
    defaultValue: 'yes',
    description: 'Enable compression for slow networks',
    helpText: '''Enable compression of all data sent over the SSH connection.

How it works:
- Uses zlib compression on the encrypted data stream
- Can significantly reduce bandwidth for text-heavy transfers
- Has CPU overhead for compression/decompression

When to enable:
- Slow network connections (DSL, mobile, satellite)
- Transferring compressible data (text, logs, code)
- Remote editing or terminal sessions over WAN

When to disable:
- Fast local networks (LAN, localhost)
- Already-compressed data (videos, archives, images)
- CPU-constrained systems

Modern fast networks often don't benefit from compression
as the CPU overhead exceeds the time saved.''',
  ),
  // Security & authentication
  SshClientDirectiveDefinition(
    key: 'HashKnownHosts',
    defaultValue: 'yes',
    description: 'Hash hostnames in known_hosts file for privacy',
    helpText:
        '''Hash hostnames and addresses in the known_hosts file for privacy.

How it works:
- Hostnames are stored as cryptographic hashes instead of plain text
- You can still connect normally (SSH hashes and compares)
- Attackers who access known_hosts can't see which servers you use

Security benefit:
- If your known_hosts file is compromised, attackers can't
  easily identify your servers to target
- Protects against reconnaissance if laptop is stolen/hacked

Tradeoffs:
- Cannot manually inspect which hosts are in the file
- Cannot use wildcards (*.example.com) with hashing
- Harder to clean up old/invalid entries

Recommendation: Enable for security-conscious users.
The minor inconvenience is worth the privacy benefit.''',
  ),
  SshClientDirectiveDefinition(
    key: 'StrictHostKeyChecking',
    defaultValue: 'ask',
    description: 'Behavior for unknown host keys',
    helpText:
        '''Controls SSH behavior when connecting to hosts with unknown or changed keys.

Valid values:
- ask: Prompt user to verify new keys (recommended default)
- yes: Refuse to connect to unknown hosts
- no: Automatically accept all host keys (insecure!)
- accept-new: Accept new hosts, reject changed keys

Security implications:
- "yes" is most secure but requires pre-populating known_hosts
- "ask" balances security with usability
- "no" is vulnerable to man-in-the-middle attacks

What happens when key changes:
- SSH refuses connection (possible attack or server rebuild)
- You must manually remove old key to connect

For automated scripts, use "accept-new" rather than "no"
to get protection against key changes while allowing
new hosts.''',
  ),
  SshClientDirectiveDefinition(
    key: 'VerifyHostKeyDNS',
    defaultValue: 'ask',
    description: 'Verify host keys using DNS SSHFP records',
    helpText: '''Verify host keys against SSHFP records published in DNS.

How it works:
- Server admin publishes host key fingerprints as DNS SSHFP records
- SSH client queries DNS and compares with server's key
- Adds an additional layer of verification

Valid values:
- yes: Automatically trust SSHFP records (requires DNSSEC)
- no: Don't use DNS for host key verification
- ask: Show SSHFP verification result, still prompt user

Requirements:
- Server admin must publish SSHFP records
- Ideally used with DNSSEC for integrity
- Without DNSSEC, DNS records could be spoofed

This is a defense-in-depth measure. Even without DNSSEC,
it raises the bar for attackers who must now compromise
both the connection AND DNS.''',
  ),
  SshClientDirectiveDefinition(
    key: 'UpdateHostKeys',
    defaultValue: 'ask',
    description: 'Accept updated host keys from server',
    helpText:
        '''Controls whether to accept additional host keys from the server.

How it works:
- Servers may have multiple host keys (RSA, ECDSA, Ed25519)
- After successful authentication, server can advertise other keys
- This allows learning new keys through trusted connection

Valid values:
- yes: Automatically add new keys to known_hosts
- no: Don't accept new keys
- ask: Prompt before adding new keys

Use cases:
- Server is rotating to stronger key algorithms
- Learning Ed25519 key after initially connecting with RSA
- Preparing for key rotation before old key expires

Security: This is generally safe because you're already
authenticated. The new keys are learned through the
already-verified encrypted channel.''',
  ),
  SshClientDirectiveDefinition(
    key: 'CheckHostIP',
    defaultValue: 'yes',
    description: 'Check host IP against known_hosts',
    helpText:
        '''Check the host IP address in addition to the hostname in known_hosts.

How it works:
- SSH stores both hostname and IP address of known hosts
- On connection, both are verified against known_hosts
- Helps detect DNS spoofing attacks

When enabled:
- SSH warns if hostname resolves to different IP than stored
- Protects against DNS cache poisoning
- May cause warnings when IPs legitimately change

When to disable:
- Hosts with frequently changing IPs (dynamic DNS)
- Load-balanced hosts (different IPs on each connection)
- Cloud instances that get new IPs after restart

For most static servers, keep this enabled for additional
security against DNS-based attacks.''',
  ),
  SshClientDirectiveDefinition(
    key: 'PasswordAuthentication',
    defaultValue: 'yes',
    description: 'Allow password authentication',
    helpText: '''Controls whether SSH client offers password authentication.

How it works:
- When enabled, SSH may prompt for password if keys fail
- Password is sent encrypted through SSH tunnel
- Server must also allow password auth for it to work

Security considerations:
- Passwords are vulnerable to brute force attacks
- Keys are cryptographically stronger
- Disable if you only use key-based authentication

Recommendation:
- Set to "no" if you have key authentication working
- Reduces attack surface (no password prompts)
- Prevents accidental password exposure

Note: This is client-side setting. Server's PasswordAuthentication
in sshd_config must also be configured appropriately.''',
  ),
  SshClientDirectiveDefinition(
    key: 'PubkeyAuthentication',
    defaultValue: 'yes',
    description: 'Enable public key authentication',
    helpText: '''Enable public key (SSH key) authentication.

How it works:
- Client proves identity using private key
- Server verifies against public key in authorized_keys
- Much stronger than password authentication

Why use key authentication:
- Cryptographically secure (2048+ bits vs short passwords)
- No password transmitted (even encrypted)
- Can use passphrase-protected keys for two-factor
- Enables passwordless automation when appropriate

Valid values:
- yes: Enable public key authentication (recommended)
- no: Disable (rarely needed)
- unbound: Keys not bound to specific host
- host-bound: Keys bound to originating host

Keep this enabled for secure SSH access. Combine with
IdentitiesOnly to control which keys are offered.''',
  ),
  // Agent & keys
  SshClientDirectiveDefinition(
    key: 'AddKeysToAgent',
    defaultValue: 'yes',
    description: 'Automatically add keys to ssh-agent',
    helpText:
        '''Automatically add keys to the SSH agent after successful authentication.

How it works:
- When you use a key (and enter passphrase), it's added to agent
- Subsequent connections use cached key without passphrase
- Key remains in agent until timeout or agent restart

Valid values:
- yes: Always add keys to agent
- no: Never add keys automatically
- ask: Prompt before adding
- confirm: Require confirmation for each agent use

Benefits:
- Enter passphrase once, use key many times
- Convenient for frequent connections
- Works with sKeys agent integration

Security note: Keys in agent can be used by anyone
with access to the agent socket. Use with appropriate
socket permissions and consider time limits.''',
  ),
  SshClientDirectiveDefinition(
    key: 'IdentitiesOnly',
    defaultValue: 'yes',
    description: 'Only use explicitly configured identity files',
    helpText: '''Only use identity keys explicitly configured in ssh_config.

How it works:
- Without this, SSH tries all keys in agent + default files
- With this enabled, only IdentityFile entries are used
- Prevents accidentally offering wrong keys to servers

Why enable:
- You have many keys and want specific key per host
- Prevents "too many authentication failures" errors
- More predictable authentication behavior
- Required for some servers that lock out after failed attempts

Example configuration:
  Host github.com
    IdentityFile ~/.ssh/github_key
    IdentitiesOnly yes

This ensures only github_key is offered, not your
work keys, personal keys, etc.''',
  ),
  SshClientDirectiveDefinition(
    key: 'ForwardAgent',
    defaultValue: 'no',
    description: 'Forward SSH agent to remote hosts',
    helpText: '''Forward your local SSH agent to remote hosts.

How it works:
- Your local agent is accessible on the remote server
- You can SSH from remote server using your local keys
- Enables multi-hop SSH without copying keys

Security warning:
- Root users on remote server can use your forwarded agent
- Malicious software on remote server can access your keys
- Only enable for trusted servers you control

Valid values:
- yes: Forward agent (use with caution)
- no: Don't forward agent (recommended default)

Safer alternatives:
- ProxyJump: SSH directly through jump host
- Copy needed keys to remote server (if appropriate)
- Use separate keys for different purposes

Only enable this when you trust the remote server
AND need to SSH further from that server.''',
  ),
  // Files & paths
  SshClientDirectiveDefinition(
    key: 'UserKnownHostsFile',
    defaultValue: '~/.ssh/known_hosts',
    description: 'Path to known hosts file',
    helpText: '''Specifies the file for storing known host keys.

Default: ~/.ssh/known_hosts

How it works:
- SSH stores verified host keys in this file
- On reconnection, keys are compared to detect changes
- Multiple files can be specified (space-separated)

Common configurations:
- Default file: ~/.ssh/known_hosts
- Additional file: ~/.ssh/known_hosts.d/work
- Disable: /dev/null (not recommended)

Use cases for custom paths:
- Separate known_hosts for work vs personal
- Shared known_hosts in team environments
- Testing without modifying main known_hosts

Note: You can specify multiple files. SSH checks all
of them and adds new hosts to the first file.''',
  ),
  SshClientDirectiveDefinition(
    key: 'IdentityFile',
    defaultValue: '~/.ssh/id_ed25519',
    description: 'Path to private key file',
    helpText: '''Specifies the private key file to use for authentication.

Default locations SSH checks:
- ~/.ssh/id_ed25519 (Ed25519, recommended)
- ~/.ssh/id_ecdsa (ECDSA)
- ~/.ssh/id_rsa (RSA)

How it works:
- SSH offers this key for public key authentication
- Multiple IdentityFile lines can be specified
- Keys are tried in order until one succeeds

Best practices:
- Use Ed25519 keys (modern, secure, fast)
- Use different keys for different purposes
- Combine with IdentitiesOnly for control

Example per-host configuration:
  Host work-server
    IdentityFile ~/.ssh/work_key
    IdentitiesOnly yes
  Host personal-server
    IdentityFile ~/.ssh/personal_key

This ensures the right key is used for each server.''',
  ),
  SshClientDirectiveDefinition(
    key: 'ControlPath',
    defaultValue: '~/.ssh/sockets/%r@%h-%p',
    description: 'Path for control socket',
    helpText: '''Path for the Unix socket used for connection multiplexing.

Tokens available:
- %r: Remote username
- %h: Remote hostname
- %p: Remote port
- %L: Local hostname
- %n: Original hostname (before canonicalization)

Example paths:
- ~/.ssh/sockets/%r@%h-%p (recommended)
- /tmp/ssh-%r@%h:%p (alternative)
- ~/.ssh/cm-%C (uses hash, avoids long paths)

Requirements:
- Directory must exist (create ~/.ssh/sockets/)
- Must be on local filesystem (not NFS)
- Socket path must not exceed OS limits (~100 chars)

Used with ControlMaster/ControlPersist for connection
sharing. Multiple sessions to same host share one TCP
connection, reducing latency and authentication overhead.''',
  ),
  // Multiplexing
  SshClientDirectiveDefinition(
    key: 'ControlMaster',
    defaultValue: 'auto',
    description: 'Enable connection sharing',
    helpText: '''Enable multiplexing multiple sessions over a single connection.

Valid values:
- yes: This connection becomes master, others connect to it
- no: Don't use connection sharing
- auto: Become master if no existing socket, else use existing
- ask: Prompt whether to become master
- autoask: Auto for master, ask for reuse

How it works:
- First connection creates master socket (ControlPath)
- Subsequent connections use existing master
- Only one TCP connection and authentication needed

Benefits:
- Faster subsequent connections (no TCP handshake/auth)
- Reduced server load
- All sessions share one connection

Best setting: "auto" handles most cases automatically.
Use with ControlPath and ControlPersist for full benefit.''',
  ),
  SshClientDirectiveDefinition(
    key: 'ControlPersist',
    defaultValue: '600',
    description: 'Keep master connection open (seconds)',
    helpText: '''Keep the master connection open after the last session closes.

Valid values:
- yes: Keep open indefinitely
- no: Close when last session ends
- <seconds>: Keep open for specified time (e.g., 600)

How it works:
- When last terminal/session closes, master stays open
- New sessions can instantly reuse existing connection
- After timeout, master connection closes automatically

Common values:
- 600 (10 minutes): Good for active work sessions
- 3600 (1 hour): Heavy use, many connections
- yes: Keep open until manually closed or system restart

Benefits:
- Instant reconnection during active work
- No repeated authentication
- Reduced latency

Use "ssh -O exit hostname" to manually close a
persistent master connection when needed.''',
  ),
  // Forwarding
  SshClientDirectiveDefinition(
    key: 'ForwardX11',
    defaultValue: 'no',
    description: 'Enable X11 forwarding',
    helpText: '''Enable X11 (graphical application) forwarding over SSH.

How it works:
- Remote GUI applications display on your local screen
- X11 protocol tunneled through SSH connection
- Requires X server running locally

Security considerations:
- X11 has known security weaknesses
- Remote applications could potentially access your display
- Use ForwardX11Trusted=no for sandboxing (default)

When to enable:
- Running graphical applications on remote server
- Using remote IDEs, file managers, or tools
- Displaying plots from remote Jupyter/Python

Requirements:
- Local: X11 server (XQuartz on Mac, X.Org on Linux)
- Remote: xauth installed, X11Forwarding yes in sshd_config

For occasional use, enable per-connection with "ssh -X"
rather than globally.''',
  ),
  SshClientDirectiveDefinition(
    key: 'ForwardX11Trusted',
    defaultValue: 'no',
    description: 'Trust remote X11 clients',
    helpText: '''Grant remote X11 clients full access to your display.

Valid values:
- yes: Full access (equivalent to ssh -Y)
- no: Restricted/sandboxed access (default, ssh -X)

Security implications:
- yes: Remote apps can snoop keyboard, capture screen
- no: Remote apps are sandboxed, limited X11 access

When "no" might break things:
- Some older applications need full X11 access
- Complex GUI toolkits may not work in sandbox mode
- You'll see "untrusted X11 forwarding" errors

Recommendation:
- Keep "no" as default for security
- Use "ssh -Y" for specific sessions needing full access
- Only set to "yes" for fully trusted servers

The sandbox provides meaningful protection against
malicious or compromised remote applications.''',
  ),
  SshClientDirectiveDefinition(
    key: 'GatewayPorts',
    defaultValue: 'no',
    description: 'Allow remote hosts to connect to local forwards',
    helpText: '''Allow remote hosts to connect to ports forwarded on local side.

How it works:
- Normally, local forwards (-L) bind only to localhost
- With GatewayPorts, they bind to all interfaces
- Other machines on your network can use the tunnel

Valid values:
- yes: Bind to all interfaces (0.0.0.0)
- no: Bind only to localhost (127.0.0.1)

Security warning:
- Enabling exposes forwarded ports to your whole network
- Anyone who can reach your machine can use the tunnel
- Only enable when you specifically need this

Use case example:
- You forward a database port from remote server
- With GatewayPorts=yes, colleagues can also access it
- Their traffic goes through your SSH tunnel

Keep this "no" unless you have a specific need and
understand the security implications.''',
  ),
  // Misc
  SshClientDirectiveDefinition(
    key: 'AddressFamily',
    defaultValue: 'any',
    description: 'IPv4/IPv6 preference',
    helpText: '''Specifies which address family to use for connections.

Valid values:
- any: Use either IPv4 or IPv6 (default)
- inet: Force IPv4 only
- inet6: Force IPv6 only

When to change:
- Network issues with one protocol but not other
- Forcing IPv4 when IPv6 DNS is misconfigured
- Testing connectivity with specific protocol

Troubleshooting:
- If connections hang, try forcing IPv4 (inet)
- Some networks have broken IPv6 that times out
- ISP may have IPv6 issues

For most users, "any" works well and lets SSH
choose the best available protocol. Only change
if you're experiencing specific connectivity issues.''',
  ),
  SshClientDirectiveDefinition(
    key: 'BatchMode',
    defaultValue: 'no',
    description: 'Disable prompts for batch/script mode',
    helpText: '''Disable all interactive prompts for use in scripts.

How it works:
- SSH never prompts for passwords or confirmations
- Connection fails rather than waiting for input
- Ideal for automated scripts and cron jobs

What BatchMode disables:
- Password prompts
- Passphrase prompts for keys
- Host key verification prompts
- Any other interactive input

When to enable:
- Automated backup scripts
- Cron jobs that SSH to remote servers
- CI/CD pipelines
- Any non-interactive SSH usage

Requirements for BatchMode:
- Must use key-based authentication
- Keys must be in agent or have no passphrase
- Hosts must be in known_hosts (or StrictHostKeyChecking=no)

Prevents scripts from hanging waiting for input
that will never come.''',
  ),
  SshClientDirectiveDefinition(
    key: 'VisualHostKey',
    defaultValue: 'no',
    description: 'Display visual ASCII art host key',
    helpText: '''Display an ASCII art representation of the host key.

How it works:
- Shows a "randomart" image when connecting
- Each host key produces unique visual pattern
- Easier to notice key changes than hex strings

Example output:
+---[ED25519 256]---+
|       .o=+.      |
|      . o.+.o     |
|       o = + o    |
|        B * + .   |
|       S B * +    |
+----[SHA256]------+

Benefits:
- Humans recognize visual patterns better than hex
- Easier to spot if key suddenly changes
- Fun conversation starter!

Limitations:
- Still hard to memorize many different patterns
- Not a replacement for proper key verification
- More useful for single frequently-accessed servers

Enable if you want visual feedback, but don't rely on
it as your only key verification method.''',
  ),
  SshClientDirectiveDefinition(
    key: 'LogLevel',
    defaultValue: 'INFO',
    description: 'Logging verbosity level',
    helpText: '''Sets the verbosity level of SSH client logging.

Valid values (increasing verbosity):
- QUIET: Suppress most messages
- FATAL: Only fatal errors
- ERROR: Errors only
- INFO: Standard informational messages (default)
- VERBOSE: More detailed output
- DEBUG/DEBUG1: Debug messages
- DEBUG2: More debug messages
- DEBUG3: Maximum debug output

When to increase:
- Troubleshooting connection problems
- Debugging authentication failures
- Understanding what SSH is doing

When to decrease:
- Automated scripts where output should be minimal
- Suppressing annoying but harmless warnings

For debugging, use DEBUG or DEBUG1 first. Higher levels
produce enormous output. Can also use "ssh -v" (or -vv, -vvv)
for per-connection debugging without changing config.''',
  ),
  // GSSAPI (Kerberos)
  SshClientDirectiveDefinition(
    key: 'GSSAPIAuthentication',
    defaultValue: 'yes',
    description: 'Enable GSSAPI authentication',
    helpText: '''Enable GSSAPI (Kerberos) authentication.

How it works:
- Uses Kerberos tickets for SSH authentication
- Provides single sign-on in Kerberos environments
- Common in enterprise/corporate networks

When enabled:
- SSH attempts GSSAPI auth if you have valid Kerberos ticket
- Falls back to other methods if GSSAPI fails
- May add slight delay if GSSAPI is attempted but unavailable

When to enable:
- Corporate environment with Kerberos/Active Directory
- HPC clusters with Kerberos authentication
- Any environment using Kerberos for identity

When to disable:
- No Kerberos infrastructure
- Seeing delays from GSSAPI attempts
- Connecting to servers that don't support it

If you're not using Kerberos, disabling this can
slightly speed up connection establishment.''',
  ),
  SshClientDirectiveDefinition(
    key: 'GSSAPIDelegateCredentials',
    defaultValue: 'no',
    description: 'Delegate GSSAPI credentials',
    helpText: '''Forward Kerberos credentials to the remote host.

How it works:
- Your Kerberos ticket is forwarded to remote server
- Remote server can act on your behalf (e.g., access NFS)
- Similar concept to SSH agent forwarding

Security warning:
- Remote server gets your Kerberos identity
- Admin on remote server could impersonate you
- Only enable for trusted servers

Valid values:
- yes: Delegate credentials
- no: Don't delegate (default, safer)

When needed:
- Accessing Kerberized services from remote host
- NFS mounts that require your Kerberos identity
- Multi-hop access through Kerberos infrastructure

Keep this "no" unless you specifically need to
access Kerberos-protected resources from the remote
server using your credentials.''',
  ),
  SshClientDirectiveDefinition(
    key: 'IdentityAgent',
    defaultValue: 'SSH_AUTH_SOCK',
    description: 'Path to SSH agent socket',
    helpText:
        '''Specifies the UNIX socket used to communicate with the SSH agent.

How it works:
- SSH uses this socket to access keys stored in the agent
- Default uses SSH_AUTH_SOCK environment variable
- Can specify explicit path or "none" to disable

Common values:
- SSH_AUTH_SOCK: Use environment variable (default)
- /path/to/socket: Explicit socket path
- none: Disable agent use entirely

Use cases:
- Using sKeys agent: /tmp/skeys-agent.sock
- Multiple agents: Different paths per host
- Disabling agent: Set to "none" to force key file use

Example per-host configuration:
  Host work-server
    IdentityAgent /run/user/1000/skeys-agent.sock
  Host no-agent-server
    IdentityAgent none

sKeys sets this automatically when managing SSH agent
integration for your keys.''',
  ),
];
