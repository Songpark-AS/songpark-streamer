CROSS_COMPILE?=arm-linux-gnueabihf-
export CROSS_COMPILE=arm-linux-gnueabihf-

obj-m += src/uio_pdrv_genirq.o

CC=$(CROSS_COMPILE)gcc
KDIR=/home/thanx/LinuxWorkspace/XilinxLinux/linux-xlnx/
INSTALL_DIR = /media/ZED_BOOT/

all:
	make -C $(KDIR) ARCH=arm M=$(PWD) modules

clean:
	make -C $(KDIR) ARCH=arm M=$(PWD) clean

install:
	cp uio_pdrv_genirq.ko $(INSTALL_DIR)

mount : 
	udevil mount /dev/mmcblk0p1 $(INSTALL_DIR)
	
umount : 
	udevil umount /dev/mmcblk0p1