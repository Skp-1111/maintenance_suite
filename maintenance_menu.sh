#!/usr/bin/env bash
# maintenance_menu.sh - interactive menu for system maintenance
set -euo pipefail

SCRIPTS_DIR="/home/sankhep/maintenance-suite/scripts"

while true; do
  clear
  echo "======================================="
  echo "     SYSTEM MAINTENANCE MENU"
  echo "======================================="
  echo "1. Run Backup"
  echo "2. Run System Update & Cleanup"
  echo "3. Run Log Monitor"
  echo "4. Run All Tasks (Backup + Update + Log Monitor)"
  echo "5. Exit"
  echo "---------------------------------------"
  read -rp "Choose an option [1-5]: " choice

  case "$choice" in
    1)
      echo "Running Backup..."
      sudo bash "$SCRIPTS_DIR/backup.sh"
      ;;
    2)
      echo "Running System Update & Cleanup..."
      sudo bash "$SCRIPTS_DIR/update_cleanup.sh"
      ;;
    3)
      echo "Running Log Monitor..."
      sudo bash "$SCRIPTS_DIR/log_monitor.sh"
      ;;
    4)
      echo "Running All Tasks..."
      sudo bash "$SCRIPTS_DIR/backup.sh"
      sudo bash "$SCRIPTS_DIR/update_cleanup.sh"
      sudo bash "$SCRIPTS_DIR/log_monitor.sh"
      ;;
    5)
      echo "Exiting Maintenance Suite. Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid choice. Please select between 1-5."
      ;;
  esac

  echo
  read -rp "Press Enter to return to menu..."
done
