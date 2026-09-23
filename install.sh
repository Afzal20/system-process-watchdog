#!/usr/bin/env bash
# ==============================================================================
# Installer for System Process Watchdog Daemon
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}==>${NC} Installing System Process Watchdog Daemon..."

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] Error: Please run this installer with sudo or as root:${NC}"
    echo "    sudo ./install.sh"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Install binary
echo -e "${BLUE}==>${NC} Installing binary to /usr/local/bin/system-process-watchdog..."
cp "$SCRIPT_DIR/bin/system-process-watchdog" /usr/local/bin/system-process-watchdog
chmod +x /usr/local/bin/system-process-watchdog

# 2. Install configuration
if [ ! -f /etc/process-watchdog.conf ]; then
    echo -e "${BLUE}==>${NC} Installing default configuration to /etc/process-watchdog.conf..."
    cp "$SCRIPT_DIR/process-watchdog.conf" /etc/process-watchdog.conf
    chmod 644 /etc/process-watchdog.conf
else
    echo -e "${YELLOW}[i] Existing /etc/process-watchdog.conf found. Keeping your config.${NC}"
    echo -e "    (Reference template saved as /etc/process-watchdog.conf.example)"
    cp "$SCRIPT_DIR/process-watchdog.conf" /etc/process-watchdog.conf.example
fi

# 3. Install systemd service
echo -e "${BLUE}==>${NC} Installing systemd service..."
cp "$SCRIPT_DIR/process-watchdog.service" /etc/systemd/system/process-watchdog.service
chmod 644 /etc/systemd/system/process-watchdog.service

# 4. Enable and start daemon
echo -e "${BLUE}==>${NC} Reloading systemd and enabling service..."
systemctl daemon-reload
systemctl enable --now process-watchdog.service

echo ""
echo -e "${GREEN}✓ System Process Watchdog successfully installed and started!${NC}"
echo ""
echo "Useful Commands:"
echo "  • Check status : sudo systemctl status process-watchdog.service"
echo "  • Live logs    : sudo journalctl -u process-watchdog.service -f"
echo "  • Log file     : tail -f /var/log/process-watchdog.log"
echo "  • Edit config  : sudo nano /etc/process-watchdog.conf"
echo ""
