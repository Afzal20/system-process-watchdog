#!/usr/bin/env bash
# ==============================================================================
# Uninstaller for System Process Watchdog Daemon
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] Error: Please run this uninstaller with sudo or as root:${NC}"
    echo "    sudo ./uninstall.sh"
    exit 1
fi

echo -e "${BLUE}==>${NC} Stopping and disabling process-watchdog.service..."
systemctl stop process-watchdog.service 2>/dev/null || true
systemctl disable process-watchdog.service 2>/dev/null || true

echo -e "${BLUE}==>${NC} Removing service file..."
rm -f /etc/systemd/system/process-watchdog.service
systemctl daemon-reload

echo -e "${BLUE}==>${NC} Removing binary..."
rm -f /usr/local/bin/system-process-watchdog

echo -e "${BLUE}==>${NC} (Configuration file /etc/process-watchdog.conf preserved for safety)"

echo ""
echo -e "${GREEN}✓ System Process Watchdog successfully uninstalled.${NC}"
