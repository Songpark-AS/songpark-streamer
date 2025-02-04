export ARCH=arm

if [ -n "${PATH}" ]; then
  export PATH=/media/tools/Xilinx/SDK/2018.3/bin:/media/tools/Xilinx/SDK/2018.3/gnu/microblaze/lin/bin:/media/tools/Xilinx/SDK/2018.3/gnu/arm/lin/bin:/media/tools/Xilinx/SDK/2018.3/gnu/microblaze/linux_toolchain/lin64_le/bin:/media/tools/Xilinx/SDK/2018.3/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:/media/tools/Xilinx/SDK/2018.3/gnu/aarch32/lin/gcc-arm-none-eabi/bin:/media/tools/Xilinx/SDK/2018.3/gnu/aarch64/lin/aarch64-linux/bin:/media/tools/Xilinx/SDK/2018.3/gnu/aarch64/lin/aarch64-none/bin:/media/tools/Xilinx/SDK/2018.3/gnu/armr5/lin/gcc-arm-none-eabi/bin:/media/tools/Xilinx/SDK/2018.3/tps/lnx64/cmake-3.3.2/bin:$PATH
else
  export PATH=/media/tools/Xilinx/SDK/2018.3/bin:/media/tools/Xilinx/SDK/2018.3/gnu/microblaze/lin/bin:/media/tools/Xilinx/SDK/2018.3/gnu/arm/lin/bin:/media/tools/Xilinx/SDK/2018.3/gnu/microblaze/linux_toolchain/lin64_le/bin:/media/tools/Xilinx/SDK/2018.3/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:/media/tools/Xilinx/SDK/2018.3/gnu/aarch32/lin/gcc-arm-none-eabi/bin:/media/tools/Xilinx/SDK/2018.3/gnu/aarch64/lin/aarch64-linux/bin:/media/tools/Xilinx/SDK/2018.3/gnu/aarch64/lin/aarch64-none/bin:/media/tools/Xilinx/SDK/2018.3/gnu/armr5/lin/gcc-arm-none-eabi/bin:/media/tools/Xilinx/SDK/2018.3/tps/lnx64/cmake-3.3.2/bin
fi

export CROSS_COMPILE=arm-linux-gnueabihf-
chmod +x ./configure
chmod +x ./aconfigure
./configure --disable-nftables --enable-libipq    \
            --with-xtlibdir=/lib/xtables \
            --host=arm-linux-gnueabihf \
            CC=arm-linux-gnueabihf-gcc CFLAGS="-mfloat-abi=hard -mfpu=neon --sysroot=/media/tools/Xilinx/SDK/2018.3/gnu/aarch32/lin/gcc-arm-linux-gnueabi/arm-linux-gnueabihf/libc" \
            LDFLAGS="-mfloat-abi=hard -mfpu=neon --sysroot=/media/tools/Xilinx/SDK/2018.3/gnu/aarch32/lin/gcc-arm-linux-gnueabi/arm-linux-gnueabihf/libc" \
            --prefix=/media/tools/Xilinx/SDK/2018.3/gnu/aarch32/lin/gcc-arm-linux-gnueabi/arm-linux-gnueabihf/libc/usr/ 
            
            
make clean 
make
