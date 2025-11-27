# SKeys Development Environment
# Run with: tilt up

# Use docker-compose for the daemon
docker_compose('docker-compose.yml')

# Rebuild daemon image when Go files change
dc_resource('daemon', trigger_mode=TRIGGER_MODE_AUTO)

# Instructions
print("""
╔══════════════════════════════════════════════════════════════╗
║  SKeys Development Environment                               ║
╠══════════════════════════════════════════════════════════════╣
║  just tilt-up    → Start daemon container                    ║
║  just run-app    → Start Flutter app (separate terminal)     ║
║  just tilt-down  → Stop daemon                               ║
║  just tilt-kill  → Kill orphaned processes                   ║
║                                                              ║
║  Daemon socket: /tmp/skeys-dev.sock                          ║
╚══════════════════════════════════════════════════════════════╝
""")
