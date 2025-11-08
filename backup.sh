

#!/usr/bin/env bash
# backup.sh - incremental backup using rsync
# Usage: sudo ./backup.sh
set -euo pipefail
trap 'error "Script aborted or failed at line $LINENO"; exit 1' ERR INT TERM
source /home/sankhep/maintenance-suite/scripts/lib_logger.sh
info "Starting $(basename "$0")"

# --- Configuration ---
SRC_LIST=(/etc /home)                  # directories to back up
DEST_DIR="/home/sankhep/maintenance-suite/backups"

TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")
LOG_FILE="${HOME}/maintenance-suite/logs/backup_${TIMESTAMP}.log"
RETENTION_DAYS=14                      # remove backups older than this
RSYNC_OPTS="-aHAX --delete --numeric-ids --partial --info=progress2 --exclude=/home/sankhep/maintenance-suite"

# --- Helpers ---
log() { echo "[$(date +'%F %T')] $*"; }
mkdir -p "$DEST_DIR" "$(dirname "$LOG_FILE")"

log "Starting backup. Destination: $DEST_DIR" | tee -a "$LOG_FILE"

for SRC in "${SRC_LIST[@]}"; do
  if [ -d "$SRC" ]; then
    DST="${DEST_DIR}/$(basename "$SRC")_${TIMESTAMP}/"
    log "Backing up $SRC -> $DST" | tee -a "$LOG_FILE"
    rsync $RSYNC_OPTS "$SRC" "$DST" 2>&1 | tee -a "$LOG_FILE"
  else
    log "Warning: source $SRC does not exist, skipping." | tee -a "$LOG_FILE"
  fi
done

# prune old backups
log "Removing backups older than ${RETENTION_DAYS} days" | tee -a "$LOG_FILE"
find "$DEST_DIR" -maxdepth 1 -type d -mtime +"$RETENTION_DAYS" -print0 | xargs -r -0 rm -rf

log "Backup completed." | tee -a "$LOG_FILE"
exit 0
