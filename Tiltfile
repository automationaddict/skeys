# SKeys Development Environment
# Run with: tilt up

# Use docker-compose for the daemon
# docker-compose handles building the image
docker_compose('docker-compose.yml')

# Manual trigger mode prevents unwanted restarts during Flutter development
# Rebuilds still happen on tilt down/up cycle
dc_resource('daemon', trigger_mode=TRIGGER_MODE_MANUAL)

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
