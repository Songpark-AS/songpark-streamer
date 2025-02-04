set -e
udevil mount /dev/mmcblk0p1 /media/ZED_BOOT

sudo cp /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6/vivado/cantavi_streamer_project.sdk/FSBL/bootimage/BOOT.bin /media/ZED_BOOT/BOOT.bin
sudo cp /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6/vivado/cantavi_streamer_project.sdk/device_tree_bsp_1/devicetree.dtb /media/ZED_BOOT/devicetree.dtb

sudo cp /home/thanx/LinuxWorkspace/XilinxLinux/linux-xlnx/arch/arm/boot/uImage /media/ZED_BOOT/uImage


#sudo cp /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6/vivado/cantavi_streamer_project.sdk/uio_driver/src/uio_pdrv_genirq.ko /media/ZED_BOOT/




udevil umount /dev/mmcblk0p1


udevil mount /dev/mmcblk0p2 /media/ZED_ROOT
#sudo tar xvf linaro-stretch-developer-20170706-43.tar.gz --strip-components=1 -C /media/ZED_ROOT/
sudo cp /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6/vivado/cantavi_streamer_project.sdk/CantaviStreamerApp6/cantavi_streamer /media/ZED_ROOT/usr/bin/cantavi_streamer
#sudo rm -R /media/ZED_ROOT/lib/modules/4.14.0-xilinx/kernel/drivers
sudo mkdir -p /media/ZED_ROOT/lib/modules/4.14.0-xilinx/kernel/drivers/ezdma
sudo mkdir -p /media/ZED_ROOT/lib/modules/4.14.0-xilinx/kernel/drivers/uio
#sudo cp /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/trimble/ezdma/examples/loopback/bd/ezdma_loopback/project_1.sdk/driver/ezdma.ko /media/ZED_ROOT/lib/modules/4.14.0-xilinx/kernel/drivers/ezdma/ezdma.ko
sudo cp /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6/vivado/cantavi_streamer_project.sdk/uio_driver/src/uio_pdrv_genirq.ko /media/ZED_ROOT/lib/modules/4.14.0-xilinx/kernel/drivers/uio/
udevil umount /dev/mmcblk0p2
