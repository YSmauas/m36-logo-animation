#!/system/bin/sh
MODDIR=${0%/*}
LOGFILE="$MODDIR/install_log.txt"

echo "--- תחילת ריצה: $(date) ---" > "$LOGFILE"

while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5
done

setenforce 0
SLOT=$(getprop ro.boot.slot_suffix)
echo "סלוט פעיל: $SLOT" >> "$LOGFILE"

# 1. גיבוי אוטומטי
if [ ! -f "$MODDIR/logo_backup.bin" ]; then
  echo "מבצע גיבוי..." >> "$LOGFILE"
  if [ -e "/dev/block/by-name/logo$SLOT" ]; then
    dd if="/dev/block/by-name/logo$SLOT" of="$MODDIR/logo_backup.bin" 2>>"$LOGFILE"
  else
    dd if="/dev/block/by-name/logo" of="$MODDIR/logo_backup.bin" 2>>"$LOGFILE"
  fi
fi

# 2. צריבה מאובטחת
if [ ! -f "$MODDIR/.installed" ]; then
  NEW_SIZE=$(stat -c%s "$MODDIR/logo.bin")
  OLD_SIZE=$(stat -c%s "$MODDIR/logo_backup.bin")
  
  if [ "$NEW_SIZE" -gt "$OLD_SIZE" ]; then
    echo "שגיאה: קובץ גדול מדי! צריבה בוטלה." >> "$LOGFILE"
    setenforce 1
    exit 1
  fi

  for part in "/dev/block/by-name/logo" "/dev/block/by-name/logo_a" "/dev/block/by-name/logo_b"; do
    if [ -e "$part" ]; then
      echo "מנקה וצורב ל-$part..." >> "$LOGFILE"
      dd if=/dev/zero of="$part" bs=4k count=1024 2>/dev/null
      dd if="$MODDIR/logo.bin" of="$part" 2>>"$LOGFILE"
    fi
  done
  touch "$MODDIR/.installed"
  echo "הצריבה הסתיימה בהצלחה." >> "$LOGFILE"
fi

setenforce 1