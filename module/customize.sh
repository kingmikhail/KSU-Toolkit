#!/bin/sh

chmod 755 "$MODPATH/uid_tool"

current_uid=$("$MODPATH/uid_tool" --getuid)

if ! "$MODPATH/uid_tool" --setuid "$current_uid" >/dev/null 2>&1; then
	abort "[!] custom interface not available!"
fi

# EOF
