# Logging Settings

## Overview

The Logging tab controls the verbosity of application logs. This is primarily useful for troubleshooting issues or understanding what the application is doing.

## Log Level

Sets the minimum severity of messages that are logged.

### Available Levels

From most to least verbose:

#### Trace
- **Everything, very verbose**
- Logs all operations including low-level details
- Useful for deep debugging
- May impact performance and create large logs
- Not recommended for normal use

#### Debug
- **Detailed debugging information**
- Logs internal operations and state changes
- Helpful when troubleshooting specific issues
- More verbose than needed for daily use

#### Info (Recommended)
- **Important events**
- Logs significant operations like connections, key additions
- Good balance of visibility and noise
- Recommended for normal use

#### Warning
- **Warnings and errors only**
- Logs potential problems and actual errors
- Quiet mode - only shows issues
- Good when everything is working well

#### Error
- **Errors only**
- Only logs actual failures
- Minimal output
- May miss important context for troubleshooting

### Choosing a Log Level

| Situation | Recommended Level |
|-----------|------------------|
| Normal daily use | Info |
| Something isn't working | Debug |
| Investigating a specific bug | Trace |
| Running on limited resources | Warning |
| Production/stable environment | Warning or Error |

## Log Locations

Both the desktop app and daemon log to the systemd journal, which handles storage, rotation, and retention automatically.

### Desktop App

Logs are tagged with `skeys-app`. To view:

```
journalctl --user -t skeys-app -f
```

### Daemon

Logs are from the `skeys-daemon` service. To view:

```
journalctl --user -u skeys-daemon -f
```

### Useful Commands

View all SKeys logs together:
```
journalctl --user -t skeys-app -u skeys-daemon -f
```

View logs from the last hour:
```
journalctl --user -t skeys-app --since "1 hour ago"
```

View logs from a specific boot:
```
journalctl --user -t skeys-app -b
```

Export logs to a file:
```
journalctl --user -t skeys-app -u skeys-daemon --no-pager > skeys-logs.txt
```

## Troubleshooting with Logs

When reporting issues:
1. Set log level to **Debug** or **Trace**
2. Reproduce the problem
3. Capture the relevant log output
4. Include logs with your bug report

**Note:** Be careful sharing logs publicly as they may contain:
- File paths
- Server hostnames
- Key fingerprints

Review logs before sharing and redact sensitive information.

---

[Open Logging Settings](skeys://settings/logging)
