#!/bin/sh
# service.sh
# No warranty.
# No rights reserved.
# This is free software; you can redistribute it and/or modify it under the terms of The Unlicense.
KSUDIR="/data/adb/ksu"

rm -rf "$KSUDIR/.manager_uid" "$KSUDIR/.manager_version" "$KSUDIR/.umount_list"

rm "$KSUDIR/bin/toolkit"
