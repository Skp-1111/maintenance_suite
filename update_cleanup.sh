#!/usr/bin/env bash
# update_cleanup.sh - perform system updates and cleanup
set -euo pipefail
trap 'error "Script aborted or failed at line $LINENO"; exit 1' ERR INT TERM
source /home/sankhep/maintenance-suite/scripts/lib_logger.sh
info "Starting $(basename "$0")"


LOG_FILE="/home/sankhep/maintenance-suite/logs/update_cleanup_$(date +'%F_%H%M%S').log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "[$(date +'%F %T')] Starting system update and cleanup"

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get autoremove -y
  sudo apt-get autoclean -y
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf upgrade -y
  sudo dnf autoremove -y
else
  echo "Unsupported package manager."
  exit 2
fi

echo "[$(date +'%F %T')] Update and cleanup completed."
