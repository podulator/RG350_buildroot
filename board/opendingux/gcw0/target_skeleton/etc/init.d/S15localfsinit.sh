#!/bin/sh

if [ -z "$1" ] || [ "x$1" = "xstart" ]; then

	# Wait for /media/data to be mounted
	# (as /usr/local is a symlink to /media/data/local).
	# /tmp/.media_data_is_mounted is created by a udev rule.
	/usr/bin/udevadm settle --exit-if-exists=/tmp/.media_data_is_mounted
	rm /tmp/.media_data_is_mounted

	mkdir -p /media/data/apps

	mkdir -p /media/data/local
	for i in bin etc home lib sbin share; do
		mkdir -p /usr/local/$i
	done

	mount -o remount,rw /media
	ln -s data/local/home /media/home
	mount -o remount,ro /media

	if [ ! -f /usr/local/etc/shadow ]; then
		echo 'root:*:::::::' > /usr/local/etc/shadow
		chmod 600 /usr/local/etc/shadow
	fi

	if [ ! -f /usr/local/etc/timezone ]; then
		echo 'CET-1CEST,M3.5.0,M10.5.0' > /usr/local/etc/timezone
	fi
fi
