#!/bin/sh

PASSWD_OUT=$(passwd -l root 2>&1)
PASSWD_ECO=$?

if { [ "$PASSWD_ECO" -eq "1" ] && [ "$PASSWD_OUT" = "passwd: password for root is already locked" ]; } ||
     [ "$PASSWD_ECO" -eq "0" ]; then
	exit 0;
fi

echo "$PASSWD_OUT"
exit "$PASSWD_ECO"
