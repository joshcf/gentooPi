#!/bin/bash

# Todo
# - if kernel date file doesnt exist create empty file
# - compare kernel file date with last
# - download kernel sources and setup as per forum post
# - create setup script to install this to cron.weekly

OLDPWD=$(pwd)

# Create the working directory

mkdir installFiles
cd raspberrypi
WORKINGDIR=$(pwd)


# Fetch the firmware files from github

git clone -b stable --depth=1 https://github.com/raspberrypi/firmware

# Fetch the tools from github

git clone https://github.com/raspberrypi/tools

# Build the needed armstub8-gic.bin

cd /tools/armstubs
make CC8=aarch64-unknown-linux-gnu-gcc LD8=aarch64-unknown-linux-gnu-ld OBJCOPY8=aarch64-unknown-linux-gnu-objcopy OBJDUMP8=aarch64-unknown-linux-gnu-objdump armstub8-gic.bin

cd "${WORKINGDIR}"

# Grab the latest Raspberry pi Kernel sources and install

git clone https://github.com/raspberrypi/linux
git checkout rpi-4.19.y

# Build the kernel using the Rapberry 

cd linux

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
