#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="${1:-}"
if [[ -z "$LOG_DIR" || ! -d "$LOG_DIR" ]]; then
  echo "Usage: $0 /path/to/log_dir" >&2
  exit 1
fi

APP_NAME="${APP_NAME:-$(basename "$LOG_DIR")}"   # override via env if needed
ARCHIVE_DIR="/var/backups/logs/$APP_NAME"
LOG_FILE="/var/log/${APP_NAME}_archive_log.txt"

TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"   # <-- exact format

mkdir -p "$ARCHIVE_DIR"

tar -czf "$ARCHIVE_DIR/$ARCHIVE_NAME" -C "$LOG_DIR" .

printf "[%(%F %T)T] OK: %s -> %s/%s\n" -1 "$LOG_DIR" "$ARCHIVE_DIR" "$ARCHIVE_NAME" >> "$LOG_FILE"
echo "Archived to $ARCHIVE_DIR/$ARCHIVE_NAME"

# Optional: prune older than 30 days
find "$ARCHIVE_DIR" -type f -name "logs_archive_*.tar.gz" -mtime +30 -delete 2>/dev/null || true
