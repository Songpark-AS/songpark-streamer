CROSS_COMPILE?=arm-linux-gnueabihf-
APP_NAME?=cantavi_streamer
CC = $(CROSS_COMPILE)gcc
CCSIZE = $(CROSS_COMPILE)size
INSTALL_DIR = /media/ZED_ROOT/
IDIR = ./include
CFLAGS = -I$(IDIR) --std=gnu99 -O0
LIBS = -lrt -lpthread


all : $(APP_NAME) 

$(APP_NAME) : 
	$(CC) src/cantavi_streamer.c  $(CFLAGS) $(LIBS) -o $(APP_NAME)
	$(CCSIZE) $(APP_NAME)


clean:
	rm -rf *.o $(APP_NAME)

install: $(APP_NAME)
	
	cp $(APP_NAME) $(INSTALL_DIR)
	
mount : 
	udevil mount /dev/mmcblk0p1 $(INSTALL_DIR)/usr/bin
	
umount : 
	udevil umount /dev/mmcblk0p1