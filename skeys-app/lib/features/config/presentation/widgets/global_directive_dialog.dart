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

import 'package:flutter/material.dart';

import '../../domain/config_entity.dart';

/// Dialog for adding or editing a global SSH directive.
class GlobalDirectiveDialog extends StatefulWidget {
  /// The existing directive to edit, or null for a new directive.
  final GlobalDirective? directive;

  /// Callback when the directive is saved.
  final void Function(String key, String value) onSave;

  /// Creates a GlobalDirectiveDialog widget.
  const GlobalDirectiveDialog({
    super.key,
    this.directive,
    required this.onSave,
  });

  @override
  State<GlobalDirectiveDialog> createState() => _GlobalDirectiveDialogState();
}

class _GlobalDirectiveDialogState extends State<GlobalDirectiveDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _keyController;
  late TextEditingController _valueController;
  String? _selectedPreset;
  String? _selectedDropdownValue;

  final _keyFocusNode = FocusNode();
  final _valueFocusNode = FocusNode();

  // SSH directives with constrained value options
  // Reference: https://man.openbsd.org/ssh_config
  static const _directiveValueOptions = <String, List<String>>{
    // Boolean directives (yes/no)
    'BatchMode': ['yes', 'no'],
    'CheckHostIP': ['yes', 'no'],
    'ClearAllForwardings': ['yes', 'no'],
    'Compression': ['yes', 'no'],
    'EnableEscapeCommandline': ['yes', 'no'],
    'EnableSSHKeysign': ['yes', 'no'],
    'ExitOnForwardFailure': ['yes', 'no'],
    'ForkAfterAuthentication': ['yes', 'no'],
    'ForwardX11': ['yes', 'no'],
    'ForwardX11Trusted': ['yes', 'no'],
    'GatewayPorts': ['yes', 'no'],
    'GSSAPIAuthentication': ['yes', 'no'],
    'GSSAPIDelegateCredentials': ['yes', 'no'],
    'GSSAPIKeyExchange': ['yes', 'no'],
    'GSSAPIRenewalForcesRekey': ['yes', 'no'],
    'GSSAPIServerIdentity': ['yes', 'no'],
    'GSSAPITrustDns': ['yes', 'no'],
    'HashKnownHosts': ['yes', 'no'],
    'HostbasedAuthentication': ['yes', 'no'],
    'IdentitiesOnly': ['yes', 'no'],
    'KbdInteractiveAuthentication': ['yes', 'no'],
    'NoHostAuthenticationForLocalhost': ['yes', 'no'],
    'PasswordAuthentication': ['yes', 'no'],
    'PermitLocalCommand': ['yes', 'no'],
    'ProxyUseFdpass': ['yes', 'no'],
    'StdinNull': ['yes', 'no'],
    'StreamLocalBindUnlink': ['yes', 'no'],
    'TCPKeepAlive': ['yes', 'no'],
    'UseKeychain': ['yes', 'no'],
    'VisualHostKey': ['yes', 'no'],
    // Deprecated but still in use
    'ChallengeResponseAuthentication': ['yes', 'no'],

    // Multi-value directives
    'AddKeysToAgent': ['yes', 'no', 'ask', 'confirm'],
    'AddressFamily': ['any', 'inet', 'inet6'],
    'CanonicalizeHostname': ['yes', 'no', 'always', 'none'],
    'ControlMaster': ['yes', 'no', 'ask', 'auto', 'autoask'],
    'FingerprintHash': ['md5', 'sha256'],
    'ForwardAgent': ['yes', 'no'],
    'IPQoS': [
      'af11',
      'af12',
      'af13',
      'af21',
      'af22',
      'af23',
      'af31',
      'af32',
      'af33',
      'af41',
      'af42',
      'af43',
      'cs0',
      'cs1',
      'cs2',
      'cs3',
      'cs4',
      'cs5',
      'cs6',
      'cs7',
      'ef',
      'le',
      'lowdelay',
      'throughput',
      'reliability',
      'none',
    ],
    'LogLevel': [
      'QUIET',
      'FATAL',
      'ERROR',
      'INFO',
      'VERBOSE',
      'DEBUG',
      'DEBUG1',
      'DEBUG2',
      'DEBUG3',
    ],
    'ObscureKeystrokeTiming': ['yes', 'no'],
    'PubkeyAuthentication': ['yes', 'no', 'unbound', 'host-bound'],
    'RequestTTY': ['no', 'yes', 'force', 'auto'],
    'SessionType': ['none', 'subsystem', 'default'],
    'StrictHostKeyChecking': ['yes', 'no', 'ask', 'accept-new', 'off'],
    'Tunnel': ['yes', 'no', 'point-to-point', 'ethernet'],
    'UpdateHostKeys': ['yes', 'no', 'ask'],
    'VerifyHostKeyDNS': ['yes', 'no', 'ask'],
    'WarnWeakCrypto': ['yes', 'no'],
  };

  // Common SSH global directives for quick selection
  static const _commonDirectives = [
    // Connection & keepalive
    _DirectivePreset(
      'ServerAliveInterval',
      '60',
      'Send keepalive every N seconds',
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
    _DirectivePreset(
      'ServerAliveCountMax',
      '3',
      'Max keepalive failures before disconnect',
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
    _DirectivePreset(
      'ConnectTimeout',
      '30',
      'Connection timeout in seconds',
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
    _DirectivePreset(
      'TCPKeepAlive',
      'yes',
      'Enable TCP keepalive messages',
      helpText:
          '''Enable TCP-level keepalive messages to detect dead connections.

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
    _DirectivePreset(
      'Compression',
      'yes',
      'Enable compression for slow networks',
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
    _DirectivePreset(
      'HashKnownHosts',
      'yes',
      'Hash hostnames in known_hosts file for privacy',
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
    _DirectivePreset(
      'StrictHostKeyChecking',
      'ask',
      'Behavior for unknown host keys',
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
    _DirectivePreset(
      'VerifyHostKeyDNS',
      'ask',
      'Verify host keys using DNS SSHFP records',
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
    _DirectivePreset(
      'UpdateHostKeys',
      'ask',
      'Accept updated host keys from server',
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
    _DirectivePreset(
      'CheckHostIP',
      'yes',
      'Check host IP against known_hosts',
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
    _DirectivePreset(
      'PasswordAuthentication',
      'yes',
      'Allow password authentication',
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
    _DirectivePreset(
      'PubkeyAuthentication',
      'yes',
      'Enable public key authentication',
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
    _DirectivePreset(
      'AddKeysToAgent',
      'yes',
      'Automatically add keys to ssh-agent',
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
    _DirectivePreset(
      'IdentitiesOnly',
      'yes',
      'Only use explicitly configured identity files',
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
    _DirectivePreset(
      'ForwardAgent',
      'no',
      'Forward SSH agent to remote hosts',
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
    _DirectivePreset(
      'UserKnownHostsFile',
      '~/.ssh/known_hosts',
      'Path to known hosts file',
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
    _DirectivePreset(
      'IdentityFile',
      '~/.ssh/id_ed25519',
      'Path to private key file',
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
    _DirectivePreset(
      'ControlPath',
      '~/.ssh/sockets/%r@%h-%p',
      'Path for control socket',
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
    _DirectivePreset(
      'ControlMaster',
      'auto',
      'Enable connection sharing',
      helpText:
          '''Enable multiplexing multiple sessions over a single connection.

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
    _DirectivePreset(
      'ControlPersist',
      '600',
      'Keep master connection open (seconds)',
      helpText:
          '''Keep the master connection open after the last session closes.

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
    _DirectivePreset(
      'ForwardX11',
      'no',
      'Enable X11 forwarding',
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
    _DirectivePreset(
      'ForwardX11Trusted',
      'no',
      'Trust remote X11 clients',
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
    _DirectivePreset(
      'GatewayPorts',
      'no',
      'Allow remote hosts to connect to local forwards',
      helpText:
          '''Allow remote hosts to connect to ports forwarded on local side.

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
    _DirectivePreset(
      'AddressFamily',
      'any',
      'IPv4/IPv6 preference',
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
    _DirectivePreset(
      'BatchMode',
      'no',
      'Disable prompts for batch/script mode',
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
    _DirectivePreset(
      'VisualHostKey',
      'no',
      'Display visual ASCII art host key',
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
    _DirectivePreset(
      'LogLevel',
      'INFO',
      'Logging verbosity level',
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
    _DirectivePreset(
      'GSSAPIAuthentication',
      'yes',
      'Enable GSSAPI authentication',
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
    _DirectivePreset(
      'GSSAPIDelegateCredentials',
      'no',
      'Delegate GSSAPI credentials',
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
  ];

  bool get _isEditing => widget.directive != null;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.directive?.key ?? '');
    _valueController = TextEditingController(
      text: widget.directive?.value ?? '',
    );
    // Initialize dropdown value if this directive has constrained options
    if (widget.directive != null) {
      final options = _directiveValueOptions[widget.directive!.key];
      if (options != null && options.contains(widget.directive!.value)) {
        _selectedDropdownValue = widget.directive!.value;
      }
    }
  }

  /// Returns the allowed values for the current directive, or null if free-form
  List<String>? get _currentValueOptions {
    final key = _keyController.text;
    return _directiveValueOptions[key];
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    _keyFocusNode.dispose();
    _valueFocusNode.dispose();
    super.dispose();
  }

  void _selectPreset(_DirectivePreset preset) {
    setState(() {
      _selectedPreset = preset.key;
      _keyController.text = preset.key;
      _valueController.text = preset.defaultValue;
      // Set dropdown value if this directive has constrained options
      final options = _directiveValueOptions[preset.key];
      if (options != null && options.contains(preset.defaultValue)) {
        _selectedDropdownValue = preset.defaultValue;
      } else {
        _selectedDropdownValue = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.settings, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    _isEditing ? 'Edit Directive' : 'Add Global Directive',
                    style: theme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick select presets (only for new directives)
                      if (!_isEditing) ...[
                        Text(
                          'Common Directives',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _commonDirectives.map((preset) {
                            final isSelected = _selectedPreset == preset.key;
                            return _buildPresetChip(
                              preset,
                              isSelected,
                              theme,
                              colorScheme,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          'Or enter custom directive:',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Key field
                      TextFormField(
                        controller: _keyController,
                        focusNode: _keyFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Directive Name',
                          hintText: 'e.g., HashKnownHosts',
                          prefixIcon: Icon(Icons.key),
                        ),
                        enabled: !_isEditing, // Can't change key when editing
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _valueFocusNode.requestFocus(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a directive name';
                          }
                          if (value.contains(' ')) {
                            return 'Directive name cannot contain spaces';
                          }
                          return null;
                        },
                        onChanged: (_) {
                          setState(() => _selectedPreset = null);
                        },
                      ),
                      const SizedBox(height: 16),
                      // Value field - dropdown for constrained options, text field otherwise
                      _buildValueField(theme, colorScheme),
                      const SizedBox(height: 16),
                      // Info box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Global directives apply to all SSH connections unless overridden by a Host block.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _save,
                    child: Text(_isEditing ? 'Save' : 'Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(
    _DirectivePreset preset,
    bool isSelected,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    // Use rich tooltip if helpText is available, otherwise simple tooltip
    if (preset.helpText != null) {
      return Tooltip(
        richMessage: WidgetSpan(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 350),
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    preset.key,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onInverseSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preset.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onInverseSurface.withValues(
                        alpha: 0.8,
                      ),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    preset.helpText!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onInverseSurface,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        waitDuration: const Duration(milliseconds: 300),
        showDuration: const Duration(seconds: 15),
        child: FilterChip(
          label: Text(preset.key),
          selected: isSelected,
          onSelected: (_) => _selectPreset(preset),
        ),
      );
    }

    // Fallback to simple tooltip
    return Tooltip(
      message: preset.description,
      child: FilterChip(
        label: Text(preset.key),
        selected: isSelected,
        onSelected: (_) => _selectPreset(preset),
      ),
    );
  }

  Widget _buildValueField(ThemeData theme, ColorScheme colorScheme) {
    final options = _currentValueOptions;

    // If directive has constrained options, show dropdown
    if (options != null) {
      return DropdownButtonFormField<String>(
        initialValue: _selectedDropdownValue,
        decoration: const InputDecoration(
          labelText: 'Value',
          prefixIcon: Icon(Icons.list),
        ),
        items: options.map((option) {
          return DropdownMenuItem<String>(value: option, child: Text(option));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedDropdownValue = value;
            _valueController.text = value ?? '';
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a value';
          }
          return null;
        },
      );
    }

    // Otherwise show free-form text field
    return TextFormField(
      controller: _valueController,
      focusNode: _valueFocusNode,
      decoration: InputDecoration(
        labelText: 'Value',
        hintText: 'e.g., yes, no, or a path',
        prefixIcon: const Icon(Icons.text_fields),
        helperText: _getValueHelperText(),
      ),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _save(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  String? _getValueHelperText() {
    final key = _keyController.text.toLowerCase();
    if (key.contains('interval') ||
        key.contains('timeout') ||
        key.contains('count')) {
      return 'Enter a number (seconds or count)';
    }
    if (key.contains('file') || key.contains('path')) {
      return 'Enter a file path';
    }
    return null;
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      // Use dropdown value if available, otherwise text controller
      final value = _currentValueOptions != null
          ? (_selectedDropdownValue ?? '')
          : _valueController.text.trim();
      widget.onSave(_keyController.text.trim(), value);
      Navigator.of(context).pop();
    }
  }
}

class _DirectivePreset {
  final String key;
  final String defaultValue;
  final String description;
  final String? helpText;

  const _DirectivePreset(
    this.key,
    this.defaultValue,
    this.description, {
    this.helpText,
  });
}
