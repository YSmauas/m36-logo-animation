SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

print_modname() {
  ui_print "*******************************"
  ui_print "  M36 Logo & Animation Changer "
  ui_print "      Author: @נחלס דון         "
  ui_print "*******************************"
}

on_install() {
  ui_print "- מתחיל התקנה עבור נגן M36..."
  ui_print "- מכין קבצי אנימציה ב-product/media..."
  ui_print "- מעתיק קובץ לוגו (logo.bin) למערכת..."
  ui_print "- שים לב: נדרשים 2 ריבוטים לסיום התהליך!"
}

set_permissions() {
  set_perm_recursive $MODPATH/system/product/media 0 0 0755 0644
  set_perm $MODPATH/service.sh 0 0 0755
  set_perm $MODPATH/logo.bin 0 0 0644
}