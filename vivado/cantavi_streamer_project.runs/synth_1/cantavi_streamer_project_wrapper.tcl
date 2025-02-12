# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z020clg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.cache/wt [current_project]
set_property parent.project_path /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.4 [current_project]
set_property ip_repo_paths {
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/CodecBridge_0.1
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/synchronizer_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/eth_udp_axi_arp_stack_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.eth_arp_udp_stack_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.cross_layer_switch_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/median_filter_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/org_audio2eth_interleaved_packetizer_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/PLC_DownStream_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/audio_fader_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_eth_to_audio_plc_combo_interface_2.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_time_sync_block_2.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/time_sync_blk_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/time_sync_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/myip-vhd_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/myip_vhd_axi_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_axis_audio_to_eth_axis_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/axis_audio_to_eth_axis_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_mixer_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_user_axi4_stream_delay_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/ntp_client_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_plc_seq_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/PLC_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-med-48-tm_sw/ip_repo/pkt_time_enforcer_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_pkt_seq_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/pkt_seq_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip_repo/pkt_seq_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/Volume_Pregain
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/SoC_Design/HDL/Audio_Mixer
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/pmod_controller_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/SoC_Design/IPs/OLED/ZedBoard_OLED_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/axi_to_audio_interface_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/ip_repo_vivado
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/audio_to_axi_interface_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/zedboard_audio
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/audio_to_axi_interface_2.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/axi_to_audio_interface_2.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_user_eth_eth_stack_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_user_eth_ip_stack_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_user_eth_rgmii_stack_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_user_eth_mac_stack_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_user_eth_udp_stack_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_user_full_udp_stack_ip_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_audio_to_eth_interface_2.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_eth_to_audio_interface_2.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_eth_to_axi_interface_2.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_axi_to_eth_interface_2.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_user_adau1761_controller_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_user_i2s_receiver_1.0
  /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/ip-repo/user.org_user_i2s_transmitter_1.0
} [current_project]
update_ip_catalog
set_property ip_cache_permissions disable [current_project]
add_files /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_ZedboardOLED_0_0/src/charLib/charLib.coe
read_verilog -library xil_defaultlib /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/hdl/cantavi_streamer_project_wrapper.v
add_files /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/cantavi_streamer_project.bd
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_processing_system7_0_0/cantavi_streamer_project_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_rst_ps7_0_100M_0/cantavi_streamer_project_rst_ps7_0_100M_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_rst_ps7_0_100M_0/cantavi_streamer_project_rst_ps7_0_100M_0.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_ZedboardOLED_0_0/src/charLib/charLib_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_axi_gpio_1_0/cantavi_streamer_project_axi_gpio_1_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_axi_gpio_1_0/cantavi_streamer_project_axi_gpio_1_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_axi_gpio_1_0/cantavi_streamer_project_axi_gpio_1_0.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_axi_gpio_2_0/cantavi_streamer_project_axi_gpio_2_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_axi_gpio_2_0/cantavi_streamer_project_axi_gpio_2_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_axi_gpio_2_0/cantavi_streamer_project_axi_gpio_2_0.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_axi_gpio_0_2/cantavi_streamer_project_axi_gpio_0_2_board.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_axi_gpio_0_2/cantavi_streamer_project_axi_gpio_0_2_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_axi_gpio_0_2/cantavi_streamer_project_axi_gpio_0_2.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_clk_wiz_0_0/cantavi_streamer_project_clk_wiz_0_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_clk_wiz_0_0/cantavi_streamer_project_clk_wiz_0_0.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_clk_wiz_0_0/cantavi_streamer_project_clk_wiz_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/ip/cantavi_streamer_project_auto_pc_0/cantavi_streamer_project_auto_pc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/cantavi_streamer_project_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/constrs_1/constraints/zed_audio.xdc
set_property used_in_implementation false [get_files /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/constrs_1/constraints/zed_audio.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top cantavi_streamer_project_wrapper -part xc7z020clg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef cantavi_streamer_project_wrapper.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file cantavi_streamer_project_wrapper_utilization_synth.rpt -pb cantavi_streamer_project_wrapper_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
