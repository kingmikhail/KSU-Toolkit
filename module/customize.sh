#!/bin/sh
PATH=/data/adb/ksu/bin:$PATH
MODDIR="/data/adb/modules/KSUToolkit"

if [ ! "$KSU" = true ]; then
	abort "KernelSU or Forks"
fi

# this assumes CONFIG_COMPAT=y on CONFIG_ARM
arch=$(busybox uname -m)
echo "Detected: $arch"

case "$arch" in
	aarch64 | arm64 )
		ELF_BINARY="Toolkit-arm64"
		;;
	armv7l | armv8l )
		ELF_BINARY="Toolkit-arm"
		;;
	*)
		abort "$arch Not Supported"
		;;
esac

mv "$MODPATH/bin/$ELF_BINARY" "$MODPATH/Toolkit"
rm -rf "$MODPATH/bin"

chmod 755 "$MODPATH/Toolkit"

current_uid=$("$MODPATH/Toolkit" --getuid)

if ! "$MODPATH/Toolkit" --setuid "$current_uid" >/dev/null 2>&1; then
	abort "Custom Interface Not Available"
fi

# add symlink
KSU_BIN_DIR="/data/adb/ksu/bin"
if [ -d "$KSU_BIN_DIR" ]; then
	echo "Creating SymLink in $KSU_BIN_DIR"
	busybox ln -sf "$MODDIR/Toolkit" "$KSU_BIN_DIR/Toolkit"
fi

OLD_MODULE_DIR="/data/adb/modules/ksu_switch_manager"
if [ -d "$OLD_MODULE_DIR" ]; then
	touch "$OLD_MODULE_DIR/remove"
fi

# we troll a little

hot_install() {
	( sleep 3 ; 
		busybox rm -rf "$MODDIR" ; 
		mkdir -p "$MODDIR" ; 
		busybox cp -Lrf "$MODPATH"/* "$MODDIR" ; 
		busybox rm -rf "$MODPATH"
	) & # fork in background
}

echo "Perform Hot Install?"
echo "Press Volume UP within 6 Secs If So..."
if [ "$(busybox timeout 3 /system/bin/getevent -lq | grep -q KEY_VOLUMEUP 2>/dev/null ; echo $?)" -eq 0 ]; then
	hot_install
	echo "Hot Install Forked To Background"
else
	echo "No Volume UP Detected Within 6 Secs"
	echo "Performing Hot Install"
	hot_install
fi
echo "No Need To Reboot Device"

# EOF
