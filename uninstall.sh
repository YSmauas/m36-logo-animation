#!/system/bin/sh
MODDIR="/data/adb/modules/boot_animation"
LOGFILE="/data/local/tmp/m36_uninstall.log"

if [ -f "$MODDIR/logo_backup.bin" ]; then
  for part in "/dev/block/by-name/logo" "/dev/block/by-name/logo_a" "/dev/block/by-name/logo_b"; do
    if [ -e "$part" ]; then
      dd if="$MODDIR/logo_backup.bin" of="$part" 2>/dev/null
    fi
  done
fi