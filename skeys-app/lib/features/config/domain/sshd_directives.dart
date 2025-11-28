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

// SSH Server (sshd_config) directive definitions.
//
// This file contains comprehensive definitions for all sshd_config directives,
// organized into logical categories for the UI.

/// Represents a category of SSH server directives.
class SshdDirectiveCategory {
  /// Unique identifier for the category.
  final String id;

  /// Display name for the category.
  final String name;

  /// Description of what this category contains.
  final String description;

  /// Icon identifier for the category.
  final String icon;

  /// List of directives in this category.
  final List<SshdDirectiveDefinition> directives;

  /// Creates an SshdDirectiveCategory with the given parameters.
  const SshdDirectiveCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.directives,
  });
}

/// Defines an SSH server directive with its allowed values and metadata.
class SshdDirectiveDefinition {
  /// The directive key name as used in sshd_config.
  final String key;

  /// Human-readable description of what this directive does.
  final String description;

  /// The default value if not specified.
  final String defaultValue;

  /// The type of value this directive accepts.
  final SshdValueType valueType;

  /// List of allowed values for selection-type directives.
  final List<String>? allowedValues;

  /// Additional hint text for users.
  final String? hint;

  /// Detailed help text explaining the directive (10-20 lines).
  final String? helpText;

  /// Whether this is an advanced directive (hidden by default).
  final bool isAdvanced;

  /// Creates an SshdDirectiveDefinition with the given parameters.
  const SshdDirectiveDefinition({
    required this.key,
    required this.description,
    required this.defaultValue,
    required this.valueType,
    this.allowedValues,
    this.hint,
    this.helpText,
    this.isAdvanced = false,
  });
}

/// The type of value a directive accepts.
enum SshdValueType {
  /// yes/no boolean
  boolean,

  /// Selection from predefined list
  selection,

  /// Integer number
  integer,

  /// Time duration (e.g., "30s", "5m", "1h")
  duration,

  /// File path
  path,

  /// Space-separated list
  list,

  /// Free-form string
  string,

  /// Port number or range
  port,

  /// IP address or hostname
  address,
}

/// All SSH server directive categories and their directives.
const sshdDirectiveCategories = <SshdDirectiveCategory>[
  // ==========================================================================
  // Network & Ports
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'network',
    name: 'Network & Ports',
    description: 'Network interfaces, ports, and connection settings',
    icon: 'network',
    directives: [
      SshdDirectiveDefinition(
        key: 'Port',
        description: 'Port number to listen on',
        defaultValue: '22',
        valueType: SshdValueType.port,
        hint: 'Can specify multiple ports',
        helpText:
            '''Specifies the port number that sshd listens for connections on. The default is 22.

Multiple port directives are permitted. Changing this from the default port 22 can reduce automated scanning attacks, but security through obscurity is not a substitute for proper security measures.

Common alternative ports include 2222, 8022, or high ports above 1024. If using a non-standard port, clients must specify it with ssh -p <port> or in their SSH config.

Note: Ports below 1024 require root privileges to bind.''',
      ),
      SshdDirectiveDefinition(
        key: 'ListenAddress',
        description: 'IP address to listen on',
        defaultValue: '0.0.0.0',
        valueType: SshdValueType.address,
        hint: '0.0.0.0 listens on all interfaces',
        helpText: '''Specifies the local addresses sshd should listen on.

The default value 0.0.0.0 means sshd will listen on all available IPv4 interfaces. Use :: for all IPv6 interfaces.

You can restrict SSH access to specific network interfaces by specifying their IP addresses. This is useful for:
- Limiting SSH to internal networks only
- Binding to VPN interfaces
- Multi-homed servers with public/private networks

Multiple ListenAddress directives are permitted. If port is not specified, sshd will listen on the address for all Port options.

Example: ListenAddress 192.168.1.1 (internal network only)''',
      ),
      SshdDirectiveDefinition(
        key: 'AddressFamily',
        description: 'IP address family to use',
        defaultValue: 'any',
        valueType: SshdValueType.selection,
        allowedValues: ['any', 'inet', 'inet6'],
        helpText: '''Specifies which address family should be used by sshd.

Valid values:
- any: Listen on both IPv4 and IPv6 (default)
- inet: IPv4 only
- inet6: IPv6 only

Use "inet" if your network doesn't support IPv6, or "inet6" in IPv6-only environments. The default "any" works for most configurations.

This setting is applied before ListenAddress, so ensure compatibility between these options.''',
      ),
      SshdDirectiveDefinition(
        key: 'TCPKeepAlive',
        description: 'Send TCP keepalive messages',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
        helpText:
            '''Specifies whether the system should send TCP keepalive messages to the other side.

When enabled (yes), connections will be terminated if the network goes down or the client host crashes. This properly cleans up dead connections.

Disabling TCP keepalives means connections won't die if the route is temporarily down, but it also means ghost connections can accumulate.

Note: TCP keepalives are spoofable. For cryptographically secure connection liveness checking, use ClientAliveInterval instead or in addition.''',
      ),
      SshdDirectiveDefinition(
        key: 'ClientAliveInterval',
        description: 'Interval to send client alive messages (seconds)',
        defaultValue: '0',
        valueType: SshdValueType.integer,
        hint: '0 disables, recommended 300 for 5 minutes',
        helpText:
            '''Sets a timeout interval in seconds after which if no data has been received from the client, sshd will send a message through the encrypted channel to request a response.

The default is 0, meaning these messages won't be sent. Unlike TCP keepalive, these messages are sent through the encrypted channel and cannot be spoofed.

Common values:
- 0: Disabled (default)
- 300: 5 minutes (good for most scenarios)
- 60: 1 minute (aggressive, detects dead clients faster)

Combined with ClientAliveCountMax, this determines when idle connections are closed. For example, interval=300 with count=3 means disconnect after 15 minutes of no response.''',
      ),
      SshdDirectiveDefinition(
        key: 'ClientAliveCountMax',
        description: 'Max client alive messages before disconnect',
        defaultValue: '3',
        valueType: SshdValueType.integer,
        helpText:
            '''Sets the number of client alive messages which may be sent without sshd receiving any response from the client.

If this threshold is reached while client alive messages are being sent, sshd will disconnect the client, terminating the session. The default value is 3.

With ClientAliveInterval=300 and ClientAliveCountMax=3, unresponsive clients will be disconnected after approximately 15 minutes of inactivity.

Setting this to 0 disables the client alive check entirely (not recommended as it can lead to orphaned connections consuming resources).''',
      ),
      SshdDirectiveDefinition(
        key: 'MaxStartups',
        description: 'Max concurrent unauthenticated connections',
        defaultValue: '10:30:100',
        valueType: SshdValueType.string,
        hint: 'start:rate:full - rate limiting format',
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'MaxSessions',
        description: 'Max sessions per network connection',
        defaultValue: '10',
        valueType: SshdValueType.integer,
      ),
      SshdDirectiveDefinition(
        key: 'PerSourceMaxStartups',
        description: 'Max unauthenticated connections per source',
        defaultValue: 'none',
        valueType: SshdValueType.string,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'PerSourceNetBlockSize',
        description: 'Network block size for per-source limits',
        defaultValue: '32:128',
        valueType: SshdValueType.string,
        hint: 'IPv4:IPv6 prefix lengths',
        isAdvanced: true,
      ),
    ],
  ),

  // ==========================================================================
  // Authentication
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'authentication',
    name: 'Authentication',
    description: 'Login and authentication methods',
    icon: 'auth',
    directives: [
      SshdDirectiveDefinition(
        key: 'PermitRootLogin',
        description: 'Allow root login via SSH',
        defaultValue: 'prohibit-password',
        valueType: SshdValueType.selection,
        allowedValues: [
          'yes',
          'no',
          'prohibit-password',
          'forced-commands-only',
        ],
        helpText: '''Specifies whether root can log in using SSH.

Valid values:
- yes: Root login is permitted
- no: Root login is completely disabled
- prohibit-password: Root login allowed only with public key authentication (recommended)
- forced-commands-only: Root login only with public key when a command is specified in authorized_keys

Security recommendation: Use "prohibit-password" or "no". Direct root login with passwords is vulnerable to brute-force attacks.

Best practice is to log in as a regular user and use sudo for administrative tasks. This provides better audit trails and limits exposure.''',
      ),
      SshdDirectiveDefinition(
        key: 'PubkeyAuthentication',
        description: 'Allow public key authentication',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
        helpText: '''Specifies whether public key authentication is allowed.

Public key authentication is more secure than password authentication because:
- Keys are cryptographically strong and not vulnerable to brute-force
- Private keys never leave the client machine
- Can be protected with passphrases for additional security
- Supports hardware security keys (FIDO2/U2F)

When enabled, users authenticate by proving they possess the private key corresponding to a public key in their ~/.ssh/authorized_keys file.

Strongly recommended to keep this enabled (yes) and is the preferred authentication method for SSH.''',
      ),
      SshdDirectiveDefinition(
        key: 'PasswordAuthentication',
        description: 'Allow password authentication',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
        helpText: '''Specifies whether password authentication is allowed.

Security considerations:
- Passwords are vulnerable to brute-force attacks
- Can be intercepted if typed on compromised machines
- Often reused across services, increasing risk

For maximum security, disable password authentication (set to "no") and use only public key authentication. Before disabling:
1. Ensure you have working SSH key authentication
2. Test key login in a separate session before disconnecting
3. Have console access as backup

Note: If UsePAM is enabled, this setting might be overridden by PAM configuration.''',
      ),
      SshdDirectiveDefinition(
        key: 'PermitEmptyPasswords',
        description: 'Allow empty passwords',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
        helpText:
            '''Specifies whether to allow login to accounts with empty password strings when password authentication is allowed.

This should ALWAYS be set to "no" (the default). Allowing empty passwords is an extreme security risk, as anyone can access accounts without any credentials.

The only scenario where this might be considered is in isolated test environments, but even then it's not recommended.

This setting has no effect if PasswordAuthentication is disabled.''',
      ),
      SshdDirectiveDefinition(
        key: 'ChallengeResponseAuthentication',
        description: 'Allow challenge-response authentication',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'KbdInteractiveAuthentication',
        description: 'Allow keyboard-interactive authentication',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'AuthenticationMethods',
        description: 'Required authentication methods',
        defaultValue: 'any',
        valueType: SshdValueType.string,
        hint: 'e.g., "publickey,password" for 2FA',
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'MaxAuthTries',
        description: 'Max authentication attempts per connection',
        defaultValue: '6',
        valueType: SshdValueType.integer,
        helpText:
            '''Specifies the maximum number of authentication attempts permitted per connection.

Once the number of failures reaches half this value, additional failures are logged. The default is 6.

Lower values (3-4) can help mitigate brute-force attacks by disconnecting attackers faster. However, setting this too low may inconvenience legitimate users who mistype passwords.

This works in conjunction with tools like fail2ban, which can ban IPs after repeated failed attempts across multiple connections.

For servers exposed to the internet, consider a value of 3-4 combined with rate limiting (MaxStartups) and fail2ban.''',
      ),
      SshdDirectiveDefinition(
        key: 'LoginGraceTime',
        description: 'Time allowed for authentication (seconds)',
        defaultValue: '120',
        valueType: SshdValueType.integer,
        hint: '0 disables timeout',
        helpText:
            '''Specifies the time in seconds the server waits for a user to successfully log in before disconnecting.

If the user does not authenticate within this time, the connection is dropped. The default is 120 seconds (2 minutes).

Setting this to 0 disables the limit (not recommended as it allows connections to hang indefinitely).

A shorter value (30-60 seconds) can help free up resources from abandoned connections and slow down automated attacks, but may frustrate users with slow network connections or those who need time to enter passwords.''',
      ),
      SshdDirectiveDefinition(
        key: 'StrictModes',
        description: 'Check file permissions before accepting login',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'UsePAM',
        description: 'Use PAM for authentication',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'ExposeAuthInfo',
        description: 'Write auth info to user environment',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
        isAdvanced: true,
      ),
    ],
  ),

  // ==========================================================================
  // Public Key Settings
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'publickey',
    name: 'Public Key Settings',
    description: 'Public key authentication configuration',
    icon: 'key',
    directives: [
      SshdDirectiveDefinition(
        key: 'AuthorizedKeysFile',
        description: 'Path to authorized keys file',
        defaultValue: '.ssh/authorized_keys',
        valueType: SshdValueType.path,
        hint: 'Relative to user home directory',
      ),
      SshdDirectiveDefinition(
        key: 'AuthorizedKeysCommand',
        description: 'Command to retrieve authorized keys',
        defaultValue: 'none',
        valueType: SshdValueType.path,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'AuthorizedKeysCommandUser',
        description: 'User to run authorized keys command',
        defaultValue: 'none',
        valueType: SshdValueType.string,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'AuthorizedPrincipalsFile',
        description: 'Path to authorized principals file',
        defaultValue: 'none',
        valueType: SshdValueType.path,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'PubkeyAcceptedAlgorithms',
        description: 'Accepted public key algorithms',
        defaultValue: 'default',
        valueType: SshdValueType.list,
        hint: 'Comma-separated list of algorithms',
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'PubkeyAuthOptions',
        description: 'Public key authentication options',
        defaultValue: 'none',
        valueType: SshdValueType.selection,
        allowedValues: ['none', 'touch-required', 'verify-required'],
        isAdvanced: true,
      ),
    ],
  ),

  // ==========================================================================
  // Host Keys
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'hostkeys',
    name: 'Host Keys',
    description: 'Server host key configuration',
    icon: 'hostkey',
    directives: [
      SshdDirectiveDefinition(
        key: 'HostKey',
        description: 'Path to host private key',
        defaultValue: '/etc/ssh/ssh_host_ed25519_key',
        valueType: SshdValueType.path,
        hint: 'Can specify multiple host keys',
      ),
      SshdDirectiveDefinition(
        key: 'HostKeyAlgorithms',
        description: 'Host key algorithms to offer',
        defaultValue: 'default',
        valueType: SshdValueType.list,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'HostCertificate',
        description: 'Path to host certificate',
        defaultValue: 'none',
        valueType: SshdValueType.path,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'RekeyLimit',
        description: 'Max data before rekeying',
        defaultValue: 'default none',
        valueType: SshdValueType.string,
        hint: 'e.g., "1G 1h" for 1GB or 1 hour',
        isAdvanced: true,
      ),
    ],
  ),

  // ==========================================================================
  // Cryptography
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'crypto',
    name: 'Cryptography',
    description: 'Ciphers, MACs, and key exchange algorithms',
    icon: 'crypto',
    directives: [
      SshdDirectiveDefinition(
        key: 'Ciphers',
        description: 'Allowed encryption ciphers',
        defaultValue: 'default',
        valueType: SshdValueType.list,
        hint: 'Comma-separated list',
      ),
      SshdDirectiveDefinition(
        key: 'MACs',
        description: 'Allowed MAC algorithms',
        defaultValue: 'default',
        valueType: SshdValueType.list,
        hint: 'Comma-separated list',
      ),
      SshdDirectiveDefinition(
        key: 'KexAlgorithms',
        description: 'Key exchange algorithms',
        defaultValue: 'default',
        valueType: SshdValueType.list,
        hint: 'Comma-separated list',
      ),
      SshdDirectiveDefinition(
        key: 'FingerprintHash',
        description: 'Hash algorithm for fingerprints',
        defaultValue: 'sha256',
        valueType: SshdValueType.selection,
        allowedValues: ['md5', 'sha256'],
      ),
    ],
  ),

  // ==========================================================================
  // Access Control
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'access',
    name: 'Access Control',
    description: 'User and group access restrictions',
    icon: 'access',
    directives: [
      SshdDirectiveDefinition(
        key: 'AllowUsers',
        description: 'Users allowed to login',
        defaultValue: '',
        valueType: SshdValueType.list,
        hint: 'Space-separated, supports user@host patterns',
        helpText:
            '''Specifies a whitelist of user names that are allowed to log in.

If specified, login is allowed only for users whose names match one of the patterns. Patterns support wildcards (* and ?) and can include HOST patterns: USER@HOST.

Examples:
- "john alice" - Only john and alice can login
- "admin@192.168.1.*" - admin only from 192.168.1.x network
- "*@10.0.0.*" - Any user from 10.0.0.x network

This directive is processed after DenyUsers. If both AllowUsers and AllowGroups are specified, the user must match at least one pattern from both.

Leave empty (default) to allow all users not in DenyUsers.''',
      ),
      SshdDirectiveDefinition(
        key: 'DenyUsers',
        description: 'Users denied from login',
        defaultValue: '',
        valueType: SshdValueType.list,
        hint: 'Space-separated list',
      ),
      SshdDirectiveDefinition(
        key: 'AllowGroups',
        description: 'Groups allowed to login',
        defaultValue: '',
        valueType: SshdValueType.list,
        hint: 'Space-separated list',
      ),
      SshdDirectiveDefinition(
        key: 'DenyGroups',
        description: 'Groups denied from login',
        defaultValue: '',
        valueType: SshdValueType.list,
        hint: 'Space-separated list',
      ),
    ],
  ),

  // ==========================================================================
  // Session & Environment
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'session',
    name: 'Session & Environment',
    description: 'Session behavior and environment settings',
    icon: 'session',
    directives: [
      SshdDirectiveDefinition(
        key: 'PrintMotd',
        description: 'Print message of the day',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'PrintLastLog',
        description: 'Print last login time',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'Banner',
        description: 'Path to banner file shown before login',
        defaultValue: 'none',
        valueType: SshdValueType.path,
      ),
      SshdDirectiveDefinition(
        key: 'PermitUserEnvironment',
        description: 'Process ~/.ssh/environment',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'AcceptEnv',
        description: 'Environment variables to accept from client',
        defaultValue: '',
        valueType: SshdValueType.list,
        hint: 'e.g., LANG LC_*',
      ),
      SshdDirectiveDefinition(
        key: 'SetEnv',
        description: 'Environment variables to set',
        defaultValue: '',
        valueType: SshdValueType.list,
        hint: 'NAME=value format',
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'PermitUserRC',
        description: 'Execute ~/.ssh/rc',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'Compression',
        description: 'Enable compression',
        defaultValue: 'yes',
        valueType: SshdValueType.selection,
        allowedValues: ['yes', 'no', 'delayed'],
      ),
      SshdDirectiveDefinition(
        key: 'UseDNS',
        description: 'Use DNS for client hostname lookup',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
      ),
    ],
  ),

  // ==========================================================================
  // Forwarding
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'forwarding',
    name: 'Forwarding',
    description: 'Port forwarding and tunneling',
    icon: 'forwarding',
    directives: [
      SshdDirectiveDefinition(
        key: 'AllowTcpForwarding',
        description: 'Allow TCP port forwarding',
        defaultValue: 'yes',
        valueType: SshdValueType.selection,
        allowedValues: ['yes', 'no', 'local', 'remote', 'all'],
        helpText: '''Specifies whether TCP forwarding is permitted.

Values:
- yes/all: Both local and remote forwarding allowed
- no: No TCP forwarding allowed
- local: Only local (client to server) forwarding allowed
- remote: Only remote (server to client) forwarding allowed

TCP forwarding allows tunneling arbitrary TCP connections through SSH. While useful for secure access to internal services, it can be a security risk if users can forward to sensitive internal resources.

Consider "no" for restricted shell accounts or jump hosts where you want to limit what users can access. Note: Disabling this does not improve security unless users are also denied shell access.''',
      ),
      SshdDirectiveDefinition(
        key: 'AllowStreamLocalForwarding',
        description: 'Allow Unix socket forwarding',
        defaultValue: 'yes',
        valueType: SshdValueType.selection,
        allowedValues: ['yes', 'no', 'local', 'remote', 'all'],
      ),
      SshdDirectiveDefinition(
        key: 'AllowAgentForwarding',
        description: 'Allow SSH agent forwarding',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
        helpText: '''Specifies whether SSH agent forwarding is permitted.

Agent forwarding allows you to use your local SSH keys on a remote server without copying them there. When enabled, the remote server can request your local ssh-agent to authenticate on your behalf.

Security warning: If a remote server is compromised, an attacker with root access could hijack your forwarded agent socket to authenticate as you to other servers.

Best practices:
- Only forward to trusted servers
- Use ssh -J (ProxyJump) instead when possible
- Consider "no" for shared or less-trusted servers

Alternative: Use ProxyJump (-J) to bounce through servers without exposing your agent.''',
      ),
      SshdDirectiveDefinition(
        key: 'GatewayPorts',
        description: 'Allow remote hosts to connect to forwarded ports',
        defaultValue: 'no',
        valueType: SshdValueType.selection,
        allowedValues: ['no', 'yes', 'clientspecified'],
      ),
      SshdDirectiveDefinition(
        key: 'PermitTunnel',
        description: 'Allow tunnel device forwarding',
        defaultValue: 'no',
        valueType: SshdValueType.selection,
        allowedValues: ['no', 'yes', 'point-to-point', 'ethernet'],
      ),
      SshdDirectiveDefinition(
        key: 'PermitOpen',
        description: 'Destinations allowed for port forwarding',
        defaultValue: 'any',
        valueType: SshdValueType.list,
        hint: 'host:port or "any" or "none"',
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'PermitListen',
        description: 'Addresses allowed for remote forwarding',
        defaultValue: 'any',
        valueType: SshdValueType.list,
        hint: 'host:port or "any" or "none"',
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'DisableForwarding',
        description: 'Disable all forwarding',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
      ),
    ],
  ),

  // ==========================================================================
  // X11 Forwarding
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'x11',
    name: 'X11 Forwarding',
    description: 'X Window System forwarding',
    icon: 'x11',
    directives: [
      SshdDirectiveDefinition(
        key: 'X11Forwarding',
        description: 'Allow X11 forwarding',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
        helpText:
            '''Specifies whether X11 forwarding is permitted, allowing remote GUI applications to display on your local screen.

When enabled, users can run graphical applications on the server and have them display locally by using "ssh -X" or "ssh -Y".

Security note: X11 forwarding can be a security risk because it allows the remote server to interact with your local X server. A compromised server could potentially:
- Capture keystrokes from other applications
- Take screenshots
- Inject input into other windows

Use "ssh -X" (untrusted) rather than "ssh -Y" (trusted) when possible, and only enable X11Forwarding if you need to run GUI applications remotely.''',
      ),
      SshdDirectiveDefinition(
        key: 'X11DisplayOffset',
        description: 'First display number for forwarding',
        defaultValue: '10',
        valueType: SshdValueType.integer,
      ),
      SshdDirectiveDefinition(
        key: 'X11UseLocalhost',
        description: 'Bind X11 to localhost only',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'XAuthLocation',
        description: 'Path to xauth program',
        defaultValue: '/usr/bin/xauth',
        valueType: SshdValueType.path,
      ),
    ],
  ),

  // ==========================================================================
  // SFTP & Subsystems
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'sftp',
    name: 'SFTP & Subsystems',
    description: 'SFTP server and subsystem configuration',
    icon: 'sftp',
    directives: [
      SshdDirectiveDefinition(
        key: 'Subsystem',
        description: 'External subsystem (e.g., sftp)',
        defaultValue: 'sftp /usr/lib/openssh/sftp-server',
        valueType: SshdValueType.string,
        hint: 'name command format',
      ),
      SshdDirectiveDefinition(
        key: 'ChrootDirectory',
        description: 'Chroot directory for sessions',
        defaultValue: 'none',
        valueType: SshdValueType.path,
        hint: '%h for home, %u for user',
      ),
      SshdDirectiveDefinition(
        key: 'ForceCommand',
        description: 'Command to execute instead of shell',
        defaultValue: 'none',
        valueType: SshdValueType.string,
        isAdvanced: true,
      ),
    ],
  ),

  // ==========================================================================
  // Logging
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'logging',
    name: 'Logging',
    description: 'Logging and audit settings',
    icon: 'logging',
    directives: [
      SshdDirectiveDefinition(
        key: 'SyslogFacility',
        description: 'Syslog facility code',
        defaultValue: 'AUTH',
        valueType: SshdValueType.selection,
        allowedValues: [
          'DAEMON',
          'USER',
          'AUTH',
          'LOCAL0',
          'LOCAL1',
          'LOCAL2',
          'LOCAL3',
          'LOCAL4',
          'LOCAL5',
          'LOCAL6',
          'LOCAL7',
        ],
      ),
      SshdDirectiveDefinition(
        key: 'LogLevel',
        description: 'Logging verbosity level',
        defaultValue: 'INFO',
        valueType: SshdValueType.selection,
        allowedValues: [
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
      ),
    ],
  ),

  // ==========================================================================
  // GSSAPI / Kerberos
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'gssapi',
    name: 'GSSAPI / Kerberos',
    description: 'GSSAPI and Kerberos authentication',
    icon: 'gssapi',
    directives: [
      SshdDirectiveDefinition(
        key: 'GSSAPIAuthentication',
        description: 'Allow GSSAPI authentication',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'GSSAPICleanupCredentials',
        description: 'Destroy credentials on logout',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'GSSAPIStrictAcceptorCheck',
        description: 'Strict GSSAPI acceptor check',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'GSSAPIKeyExchange',
        description: 'Allow GSSAPI key exchange',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'KerberosAuthentication',
        description: 'Allow Kerberos authentication',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'KerberosOrLocalPasswd',
        description: 'Fall back to local password',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'KerberosTicketCleanup',
        description: 'Destroy tickets on logout',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'KerberosGetAFSToken',
        description: 'Get AFS token after authentication',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
        isAdvanced: true,
      ),
    ],
  ),

  // ==========================================================================
  // Advanced Security
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'security',
    name: 'Advanced Security',
    description: 'Advanced security settings',
    icon: 'security',
    directives: [
      SshdDirectiveDefinition(
        key: 'PermitTTY',
        description: 'Allow PTY allocation',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'IgnoreRhosts',
        description: 'Ignore .rhosts and .shosts files',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'IgnoreUserKnownHosts',
        description: 'Ignore user known_hosts file',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'HostbasedAuthentication',
        description: 'Allow host-based authentication',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'HostbasedUsesNameFromPacketOnly',
        description: 'Use only packet hostname for host-based auth',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'RevokedKeys',
        description: 'Path to revoked keys file',
        defaultValue: 'none',
        valueType: SshdValueType.path,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'TrustedUserCAKeys',
        description: 'Path to trusted CA keys',
        defaultValue: 'none',
        valueType: SshdValueType.path,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'CASignatureAlgorithms',
        description: 'Allowed CA signature algorithms',
        defaultValue: 'default',
        valueType: SshdValueType.list,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'SecurityKeyProvider',
        description: 'Library for security key support',
        defaultValue: 'internal',
        valueType: SshdValueType.string,
        isAdvanced: true,
      ),
    ],
  ),

  // ==========================================================================
  // Daemon Settings
  // ==========================================================================
  SshdDirectiveCategory(
    id: 'daemon',
    name: 'Daemon Settings',
    description: 'SSH daemon process settings',
    icon: 'daemon',
    directives: [
      SshdDirectiveDefinition(
        key: 'PidFile',
        description: 'Path to PID file',
        defaultValue: '/run/sshd.pid',
        valueType: SshdValueType.path,
      ),
      SshdDirectiveDefinition(
        key: 'VersionAddendum',
        description: 'Text to append to version string',
        defaultValue: 'none',
        valueType: SshdValueType.string,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'ModuliFile',
        description: 'Path to moduli file for DH',
        defaultValue: '/etc/ssh/moduli',
        valueType: SshdValueType.path,
        isAdvanced: true,
      ),
      SshdDirectiveDefinition(
        key: 'IPQoS',
        description: 'IP Quality of Service',
        defaultValue: 'lowdelay throughput',
        valueType: SshdValueType.string,
        hint: 'interactive bulk format',
        isAdvanced: true,
      ),
    ],
  ),
];

/// Map of directive key to its definition for quick lookup.
final sshdDirectiveMap = {
  for (final category in sshdDirectiveCategories)
    for (final directive in category.directives) directive.key: directive,
};

/// Get the category for a given directive key.
SshdDirectiveCategory? getCategoryForDirective(String key) {
  for (final category in sshdDirectiveCategories) {
    for (final directive in category.directives) {
      if (directive.key == key) {
        return category;
      }
    }
  }
  return null;
}
