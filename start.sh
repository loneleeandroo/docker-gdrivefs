#!/bin/sh

if [ ! -e /config/gdfs/credcache ]
then
	mkdir -p /config/gdfs
	gdfstool auth -u
	read -p "Please enter the authorization code: " code
	gdfstool auth -a /config/gdfs/credcache "$code"
fi

if [ -e /config/gdfs/credcache ]
then
	mkdir -p /media/gdrivefs
	gdfstool mount /config/gdfs/credcache /media/gdrivefs

	if [ $(mount | grep -c gdrivefs) > 0 ]
	then
		echo "Google Drive has been successfully mounted to /media/gdrivefs"
		echo "Please press Ctrl+p following by Ctrl+q to detach container"
		supervisord -c /etc/supervisor.conf -n
	else
		echo "Google Drive failed to mount"
	fi
fi
