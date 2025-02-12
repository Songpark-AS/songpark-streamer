# 
# Report generation script generated by Vivado
# 

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
proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}


start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7z020clg484-1
  set_property board_part em.avnet.com:zed:part0:1.4 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.cache/wt [current_project]
  set_property parent.project_path /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.xpr [current_project]
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
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.runs/synth_1/cantavi_streamer_project_wrapper.dcp
  set_msg_config -source 4 -id {BD 41-1661} -limit 0
  set_param project.isImplRun true
  add_files /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/sources_1/bd/cantavi_streamer_project/cantavi_streamer_project.bd
  set_param project.isImplRun false
  read_xdc /home/thanx/HDL-Workspace/Xilinx_SDK_Workspace/MyAudio/CantaviStreamer6-single-tc-grplc-int-tm_sw_sip_cc_MKT/vivado/cantavi_streamer_project.srcs/constrs_1/constraints/zed_audio.xdc
  set_param project.isImplRun true
  link_design -top cantavi_streamer_project_wrapper -part xc7z020clg484-1
  set_param project.isImplRun false
  write_hwdef -force -file cantavi_streamer_project_wrapper.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force cantavi_streamer_project_wrapper_opt.dcp
  create_report "impl_1_opt_report_drc_0" "report_drc -file cantavi_streamer_project_wrapper_drc_opted.rpt -pb cantavi_streamer_project_wrapper_drc_opted.pb -rpx cantavi_streamer_project_wrapper_drc_opted.rpx"
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  if { [llength [get_debug_cores -quiet] ] > 0 }  { 
    implement_debug_core 
  } 
  place_design 
  write_checkpoint -force cantavi_streamer_project_wrapper_placed.dcp
  create_report "impl_1_place_report_io_0" "report_io -file cantavi_streamer_project_wrapper_io_placed.rpt"
  create_report "impl_1_place_report_utilization_0" "report_utilization -file cantavi_streamer_project_wrapper_utilization_placed.rpt -pb cantavi_streamer_project_wrapper_utilization_placed.pb"
  create_report "impl_1_place_report_control_sets_0" "report_control_sets -verbose -file cantavi_streamer_project_wrapper_control_sets_placed.rpt"
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force cantavi_streamer_project_wrapper_routed.dcp
  create_report "impl_1_route_report_drc_0" "report_drc -file cantavi_streamer_project_wrapper_drc_routed.rpt -pb cantavi_streamer_project_wrapper_drc_routed.pb -rpx cantavi_streamer_project_wrapper_drc_routed.rpx"
  create_report "impl_1_route_report_methodology_0" "report_methodology -file cantavi_streamer_project_wrapper_methodology_drc_routed.rpt -pb cantavi_streamer_project_wrapper_methodology_drc_routed.pb -rpx cantavi_streamer_project_wrapper_methodology_drc_routed.rpx"
  create_report "impl_1_route_report_power_0" "report_power -file cantavi_streamer_project_wrapper_power_routed.rpt -pb cantavi_streamer_project_wrapper_power_summary_routed.pb -rpx cantavi_streamer_project_wrapper_power_routed.rpx"
  create_report "impl_1_route_report_route_status_0" "report_route_status -file cantavi_streamer_project_wrapper_route_status.rpt -pb cantavi_streamer_project_wrapper_route_status.pb"
  create_report "impl_1_route_report_timing_summary_0" "report_timing_summary -max_paths 10 -file cantavi_streamer_project_wrapper_timing_summary_routed.rpt -pb cantavi_streamer_project_wrapper_timing_summary_routed.pb -rpx cantavi_streamer_project_wrapper_timing_summary_routed.rpx -warn_on_violation "
  create_report "impl_1_route_report_incremental_reuse_0" "report_incremental_reuse -file cantavi_streamer_project_wrapper_incremental_reuse_routed.rpt"
  create_report "impl_1_route_report_clock_utilization_0" "report_clock_utilization -file cantavi_streamer_project_wrapper_clock_utilization_routed.rpt"
  create_report "impl_1_route_report_bus_skew_0" "report_bus_skew -warn_on_violation -file cantavi_streamer_project_wrapper_bus_skew_routed.rpt -pb cantavi_streamer_project_wrapper_bus_skew_routed.pb -rpx cantavi_streamer_project_wrapper_bus_skew_routed.rpx"
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force cantavi_streamer_project_wrapper_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  catch { write_mem_info -force cantavi_streamer_project_wrapper.mmi }
  write_bitstream -force cantavi_streamer_project_wrapper.bit 
  catch { write_sysdef -hwdef cantavi_streamer_project_wrapper.hwdef -bitfile cantavi_streamer_project_wrapper.bit -meminfo cantavi_streamer_project_wrapper.mmi -file cantavi_streamer_project_wrapper.sysdef }
  catch {write_debug_probes -quiet -force cantavi_streamer_project_wrapper}
  catch {file copy -force cantavi_streamer_project_wrapper.ltx debug_nets.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

