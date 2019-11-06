#!/bin/bash

# Todo
# - download and install wireguard as per forum post
# - add to install script add this to cron.weekly

OLDPWD=$(pwd)

if [ ! -d /usr/local/src/WireGuard ]
then
	mkdir -p /usr/local/src
	cd /usr/local/src
	git clone https://git.zx2c4.com/WireGuard
	cd /usr/local/src/WireGuard
else
	cd /usr/local/src/WireGuard
	git pull
fi

cd /usr/local/src/WireGuard/src
KERNELDIR=/usr/src/linux make
KERNELDIR=/usr/src/linux make install
depmod -a
modprobe wireguard

cd "${OLDPWD}"
