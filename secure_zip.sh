#!/bin/bash
set -euo pipefail

# ===== 用户配置 =====
MAX_KEEP=5
DEST_DIR="${HOME}/Desktop/SecureBackups"
# ====================

mkdir -p "$DEST_DIR"

PASS=$(LC_CTYPE=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c12)
TS=$(date +%Y%m%d_%H%M%S)
ARCHIVE="${DEST_DIR}/Backup_${TS}.7z"

if ! ZIP_CMD=$(command -v 7zz || command -v 7z); then
    osascript -e 'display alert "7-Zip未安装" message "请运行: brew install p7zip"'
    exit 1
fi

"$ZIP_CMD" a -t7z -mx=9 -mhe=on -p"$PASS" "$ARCHIVE" "$@" >/dev/null

security add-generic-password -s secure_zip -a latest -w "$PASS" -U 2>/dev/null || \
security add-generic-password -s secure_zip -a latest -w "$PASS" -U

ls -t "$DEST_DIR"/Backup_*.7z | tail -n +$((MAX_KEEP+1)) | xargs rm -f

osascript -e "display notification \"已创建: ${ARCHIVE##*/}\" with title \"安全压缩完成\""
