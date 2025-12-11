#!/bin/sh
# service.sh
# No warranty.
# No rights reserved.
# This is free software; you can redistribute it and/or modify it under the terms of The Unlicense.
PATH=/data/adb/ksu/bin:$PATH
MODDIR="/data/adb/modules/ksu_toolkit"
KSUDIR="/data/adb/ksu"
PACKAGES_LIST="/data/system/packages.list"

if [ -f "$KSUDIR/.manager_uid" ]; then
	uid=$(head -n1 "$KSUDIR/.manager_uid")

	# only set this when it is still installed
	# this way we dont get into a situation where theres a manager uid is set
	# but theres no manager
	if grep -q "$uid" "$PACKAGES_LIST" > /dev/null 2>&1; then
		"$MODDIR/toolkit" --setuid "$uid" > /dev/null 2>&1
	fi
fi

if [ -f "$KSUDIR/.umount_list" ]; then
	for i in $(grep -v "^#" "$KSUDIR/.umount_list"); do
		/data/adb/ksud kernel umount add "$i" -f 2
	done
	/data/adb/ksud kernel notify-module-mounted
fi

# EOF
