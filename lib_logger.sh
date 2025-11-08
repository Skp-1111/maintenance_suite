#!/usr/bin/env bash
# lib_logger.sh – shared logger library

LOG_DIR="/home/sankhep/maintenance-suite/logs"
MASTER_LOG="$LOG_DIR/maintenance_master.log"
mkdir -p "$LOG_DIR"

_log() {
  local level="$1"; shift
  echo "[$(date +'%F %T')] [$level] $*" | tee -a "$MASTER_LOG"
}

info()  { _log INFO  "$@"; }
warn()  { _log WARN  "$@"; }
error() { _log ERROR "$@"; }

