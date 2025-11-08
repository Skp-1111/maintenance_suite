
#!/usr/bin/env bash
# log_monitor.sh - checks system logs for warnings or failures
set -euo pipefail
trap 'error "Script aborted or failed at line $LINENO"; exit 1' ERR INT TERM
source /home/sankhep/maintenance-suite/scripts/lib_logger.sh
info "Starting $(basename "$0")"

LOG_FILE="/home/sankhep/maintenance-suite/logs/log_monitor_$(date +'%F_%H%M%S').log"
mkdir -p "$(dirname "$LOG_FILE")"

TARGET_LOG=${1:-/var/log/auth.log}
PATTERN=${2:-"Failed password|error|CRON"}

echo "[$(date +'%F %T')] Scanning $TARGET_LOG for pattern: $PATTERN" | tee -a "$LOG_FILE"

if [ ! -r "$TARGET_LOG" ]; then
  echo "Cannot read $TARGET_LOG (try with sudo)" | tee -a "$LOG_FILE"
  exit 1
fi

tail -n 500 "$TARGET_LOG" | grep -E -n "$PATTERN" | tee -a "$LOG_FILE" || \
  echo "No matches found in last 500 lines." | tee -a "$LOG_FILE"

echo "[$(date +'%F %T')] Log monitor finished." | tee -a "$LOG_FILE"
