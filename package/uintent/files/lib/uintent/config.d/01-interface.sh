#!/bin/sh

. /lib/functions.sh
. /lib/functions/system.sh

case $(board_name) in
zyxel,nwa50ax|\
zyxel,nwa55axe)
	uplink_port="lan"
	;;
ubnt,unifiac-lite|\
ubnt,unifiac-mesh)
	uplink_port="eth0"
	;;
esac

mkdir -p /lib/uintent/board

echo -n "$uplink_port" > /lib/uintent/board/uplink_port
