# Installing Gentoo 64bit on the Raspberry Pi 4

Create the working directory

    mkdir installFiles
    cd raspberrypi

Fetch the firmware files from github

    git clone -b stable --depth=1 https://github.com/raspberrypi/firmware

Fetch the tools from github

    git clone https://github.com/raspberrypi/tools

Build the needed armstub8-gic.bin

    cd tools/armstubs
    make CC8=aarch64-unknown-linux-gnu-gcc LD8=aarch64-unknown-linux-gnu-ld OBJCOPY8=aarch64-unknown-linux-gnu-objcopy OBJDUMP8=aarch64-unknown-linux-gnu-objdump armstub8-gic.bin
    cd ../..

Grab the latest Raspberry pi Kernel sources and install

    git clone https://github.com/raspberrypi/linux
    git checkout rpi-4.19.y

Build the kernel using the Rapberry 

    cd linux
    make bcmrpi3_defconfig

Use menuconfig to make some adjustments to the kernel config

    make menuconfig
    
Change the default Frequency governor to be ondemand

    CPU Power Management > CPU Frequency scaling > Default CPUFreq governor

Save the config and exit
Make the kernel

    make -j4




mount /boot

cp -rv /usr/local/src/raspberrypi/firmware/boot/* /boot

mv /boot/bcm2711-rpi-4-b.dtb /boot/bcm2711-rpi-4-b.dtb_32
cp /usr/src/linux/arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dtb /boot

cp /usr/local/src/raspberrypi/tools/armstubs/armstub8-gic.bin /boot

cp /boot/kernel8.img /boot/kernel8.old
cp /usr/src/linux/arch/arm64/boot/Image /boot/kernel8.img

umount /boot