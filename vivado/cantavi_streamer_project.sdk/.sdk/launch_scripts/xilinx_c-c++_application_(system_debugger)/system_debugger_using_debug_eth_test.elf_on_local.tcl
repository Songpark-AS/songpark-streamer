connect -url tcp:127.0.0.1:3121
source /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6/vivado/cantavi_streamer_project.sdk/cantavi_streamer_project_wrapper_hw_platform_4/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248AA3EB1"} -index 0
loadhw -hw /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6/vivado/cantavi_streamer_project.sdk/cantavi_streamer_project_wrapper_hw_platform_4/system.hdf -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248AA3EB1"} -index 0
stop
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248AA3EB1"} -index 0
rst -processor
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248AA3EB1"} -index 0
dow /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6/vivado/cantavi_streamer_project.sdk/eth_test/Debug/eth_test.elf
configparams force-mem-access 0
bpadd -addr &main
