#!/bin/bash

# Todo
# - if kernel date file doesnt exist create empty file
# - compare kernel file date with last
# - download kernel sources and setup as per forum post
# - create setup script to install this to cron.weekly

OLDPWD=$(pwd)

# Fetch the firmware files from github

if [ ! -d /usr/local/src/raspberrypi/firmware ]
then
	echo "No Pi Firmware, downloading"
	if [ ! -d /usr/local/src/raspberrypi ]
	then
		mkdir -p /usr/local/src/raspberrypi
	fi
	cd /usr/local/src/raspberrypi
	git clone -b stable --depth=1 https://github.com/raspberrypi/firmware
else
	echo "Updating Pi Firmware"
	cd /usr/local/src/raspberrypi/firmware
	git pull
fi

cd "${OLDPWD}"


# Fetch the tools from github

if [ ! -d /usr/local/src/raspberrypi/tools ]
then
	echo "No Tools, downloading"
	cd /usr/local/src/raspberrypi
	git clone https://github.com/raspberrypi/tools
else
	echo "Updating tools"
	cd /usr/local/src/raspberrypi/tools
	git pull
fi

cd /usr/local/src/raspberrypi/tools/armstubs
make CC8=aarch64-unknown-linux-gnu-gcc LD8=aarch64-unknown-linux-gnu-ld OBJCOPY8=aarch64-unknown-linux-gnu-objcopy OBJDUMP8=aarch64-unknown-linux-gnu-objdump armstub8-gic.bin

cd "${OLDPWD}"


# Grab the latest Raspbery pi Kernel sources and install

if [ ! -d /usr/src/linux ]
then
	echo "No Kernel Sources, downloading"
	cd /usr/src/
	git clone https://github.com/raspberrypi/linux
	git checkout rpi-4.19.y
	cd /usr/src/linux
else
	echo "Kernel exists, updating souces from git"
	cd /usr/src/linux
	git pull
fi

modprobe configs
zcat /proc/config.gz > .config
make -j4
make modules_install

mount /boot

cp -rv /usr/local/src/raspberrypi/firmware/boot/* /boot

mv /boot/bcm2711-rpi-4-b.dtb /boot/bcm2711-rpi-4-b.dtb_32
cp /usr/src/linux/arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dtb /boot

cp /usr/local/src/raspberrypi/tools/armstubs/armstub8-gic.bin /boot

cp /boot/kernel8.img /boot/kernel8.old
cp /usr/src/linux/arch/arm64/boot/Image /boot/kernel8.img

umount /boot

cd "${OLDPWD}"
