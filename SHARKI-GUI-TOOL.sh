#!/bin/bash
# 🦈 SHARKI GUI TOOL — توقيع رقمي لا يُنسى

RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

adb devices | grep device > /dev/null || {
  zenity --error --text="❌ لا يوجد جهاز متصل"
  exit 1
}

CHOICE=$(zenity --list --title="🦈 SHARKI GUI" \
--width=500 --height=350 \
--column="عملية" --column="الوصف" \
"📤 إزالة FRP" "بدون روت" \
"🌍 تغيير CSC" "إلى VZW أو غيره" \
"🛡️ تعطيل Knox" "إيقاف الحماية" \
"📦 تثبيت APK" "من ملف خارجي" \
"🧹 فورمات" "تهيئة كاملة" \
"📊 معلومات" "عرض النظام" \
"❌ خروج" "إنهاء")

case $CHOICE in
  "📤 إزالة FRP") adb shell am broadcast -a android.intent.action.MASTER_CLEAR ;;
  "🌍 تغيير CSC") NEW_CSC=$(zenity --entry --title="🌍 CSC" --text="أدخل رمز CSC"); adb shell am broadcast -a android.intent.action.CSC_CHANGE --es csc "$NEW_CSC" ;;
  "🛡️ تعطيل Knox") adb shell pm disable-user --user 0 com.sec.knox.seandroid ;;
  "📦 تثبيت APK") APK_PATH=$(zenity --file-selection); adb install "$APK_PATH" ;;
  "🧹 فورمات") adb shell recovery --wipe_data ;;
  "📊 معلومات") INFO=$(adb shell getprop | grep -E 'ro.product|ro.build|ro.serial'); zenity --text-info --filename=<(echo "$INFO") ;;
  "❌ خروج") zenity --info --text="🦈 انتهت الجلسة" ;;
  *) zenity --error --text="❌ اختيار غير صالح" ;;
esac
