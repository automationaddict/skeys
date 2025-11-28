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
  final String id;
  final String name;
  final String description;
  final String icon;
  final List<SshdDirectiveDefinition> directives;

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
  final String key;
  final String description;
  final String defaultValue;
  final SshdValueType valueType;
  final List<String>? allowedValues;
  final String? hint;
  final bool isAdvanced;

  const SshdDirectiveDefinition({
    required this.key,
    required this.description,
    required this.defaultValue,
    required this.valueType,
    this.allowedValues,
    this.hint,
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
      ),
      SshdDirectiveDefinition(
        key: 'ListenAddress',
        description: 'IP address to listen on',
        defaultValue: '0.0.0.0',
        valueType: SshdValueType.address,
        hint: '0.0.0.0 listens on all interfaces',
      ),
      SshdDirectiveDefinition(
        key: 'AddressFamily',
        description: 'IP address family to use',
        defaultValue: 'any',
        valueType: SshdValueType.selection,
        allowedValues: ['any', 'inet', 'inet6'],
      ),
      SshdDirectiveDefinition(
        key: 'TCPKeepAlive',
        description: 'Send TCP keepalive messages',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'ClientAliveInterval',
        description: 'Interval to send client alive messages (seconds)',
        defaultValue: '0',
        valueType: SshdValueType.integer,
        hint: '0 disables, recommended 300 for 5 minutes',
      ),
      SshdDirectiveDefinition(
        key: 'ClientAliveCountMax',
        description: 'Max client alive messages before disconnect',
        defaultValue: '3',
        valueType: SshdValueType.integer,
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
      ),
      SshdDirectiveDefinition(
        key: 'PubkeyAuthentication',
        description: 'Allow public key authentication',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'PasswordAuthentication',
        description: 'Allow password authentication',
        defaultValue: 'yes',
        valueType: SshdValueType.boolean,
      ),
      SshdDirectiveDefinition(
        key: 'PermitEmptyPasswords',
        description: 'Allow empty passwords',
        defaultValue: 'no',
        valueType: SshdValueType.boolean,
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
      ),
      SshdDirectiveDefinition(
        key: 'LoginGraceTime',
        description: 'Time allowed for authentication (seconds)',
        defaultValue: '120',
        valueType: SshdValueType.integer,
        hint: '0 disables timeout',
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
