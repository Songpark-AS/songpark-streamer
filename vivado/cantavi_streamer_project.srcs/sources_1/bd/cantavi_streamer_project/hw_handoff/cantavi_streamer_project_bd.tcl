
################################################################
# This is a generated script based on design: cantavi_streamer_project
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source cantavi_streamer_project_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART em.avnet.com:zed:part0:1.4 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name cantavi_streamer_project

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: ZedCodec
proc create_hier_cell_ZedCodec { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ZedCodec() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  # Create pins
  create_bd_pin -dir I adau1761_adc_sdata_0
  create_bd_pin -dir I adau1761_bclk_0
  create_bd_pin -dir O adau1761_cclk_0
  create_bd_pin -dir O adau1761_cdata_0
  create_bd_pin -dir O adau1761_clatchn_0
  create_bd_pin -dir I adau1761_cout_0
  create_bd_pin -dir O adau1761_dac_sdata_0
  create_bd_pin -dir I adau1761_lrclk_0
  create_bd_pin -dir O adau1761_mclk
  create_bd_pin -dir O bclk1_0
  create_bd_pin -dir I clk_125
  create_bd_pin -dir O ctrl_sw_out_0
  create_bd_pin -dir I -from 23 -to 0 hphone_l
  create_bd_pin -dir I -from 23 -to 0 hphone_r
  create_bd_pin -dir O -from 23 -to 0 line_in_l_125
  create_bd_pin -dir O -from 23 -to 0 line_in_r_125
  create_bd_pin -dir O lrclk1_0
  create_bd_pin -dir O mclk1_0
  create_bd_pin -dir I mclk_cw
  create_bd_pin -dir O next_adc_sample
  create_bd_pin -dir O next_dac_sample
  create_bd_pin -dir I -type rst rst
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -type rst s00_axi_aresetn
  create_bd_pin -dir I serial_data_in1_0
  create_bd_pin -dir O serial_data_out1_0
  create_bd_pin -dir I -from 7 -to 0 sw

  # Create instance: adau1761_controller_0, and set properties
  set adau1761_controller_0 [ create_bd_cell -type ip -vlnv user.org:user:adau1761_controller:1.0 adau1761_controller_0 ]

  # Create instance: i2s_receiver_from_codec_adc_0, and set properties
  set i2s_receiver_from_codec_adc_0 [ create_bd_cell -type ip -vlnv user.org:user:i2s_receiver:1.0 i2s_receiver_from_codec_adc_0 ]

  # Create instance: i2s_transmitter_to_codec_dac_0, and set properties
  set i2s_transmitter_to_codec_dac_0 [ create_bd_cell -type ip -vlnv user.org:user:i2s_transmitter:1.0 i2s_transmitter_to_codec_dac_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins adau1761_controller_0/S00_AXI]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins i2s_transmitter_to_codec_dac_0/hphone_l_valid] [get_bd_pins i2s_transmitter_to_codec_dac_0/hphone_r_valid]
  connect_bd_net -net adau1761_adc_sdata_0 [get_bd_pins adau1761_adc_sdata_0] [get_bd_pins i2s_receiver_from_codec_adc_0/serial_data_in2]
  connect_bd_net -net adau1761_bclk_0 [get_bd_pins adau1761_bclk_0] [get_bd_pins i2s_receiver_from_codec_adc_0/bclk] [get_bd_pins i2s_transmitter_to_codec_dac_0/bclk]
  connect_bd_net -net adau1761_controller_0_adau1761_cclk [get_bd_pins adau1761_cclk_0] [get_bd_pins adau1761_controller_0/adau1761_cclk]
  connect_bd_net -net adau1761_controller_0_adau1761_cdata [get_bd_pins adau1761_cdata_0] [get_bd_pins adau1761_controller_0/adau1761_cdata]
  connect_bd_net -net adau1761_controller_0_adau1761_clatchn [get_bd_pins adau1761_clatchn_0] [get_bd_pins adau1761_controller_0/adau1761_clatchn]
  connect_bd_net -net adau1761_cout_0_1 [get_bd_pins adau1761_cout_0] [get_bd_pins adau1761_controller_0/adau1761_cout]
  connect_bd_net -net adau1761_lrclk_0 [get_bd_pins adau1761_lrclk_0] [get_bd_pins i2s_receiver_from_codec_adc_0/lrclk] [get_bd_pins i2s_transmitter_to_codec_dac_0/lrclk]
  connect_bd_net -net clk_125_1 [get_bd_pins clk_125] [get_bd_pins i2s_receiver_from_codec_adc_0/clk_125] [get_bd_pins i2s_transmitter_to_codec_dac_0/clk_125]
  connect_bd_net -net hphone_l_1 [get_bd_pins hphone_l] [get_bd_pins i2s_transmitter_to_codec_dac_0/hphone_l]
  connect_bd_net -net hphone_r_1 [get_bd_pins hphone_r] [get_bd_pins i2s_transmitter_to_codec_dac_0/hphone_r]
  connect_bd_net -net i2s_receiver_from_codec_adc_0_bclk1 [get_bd_pins bclk1_0] [get_bd_pins i2s_receiver_from_codec_adc_0/bclk1]
  connect_bd_net -net i2s_receiver_from_codec_adc_0_ctrl_sw_out [get_bd_pins ctrl_sw_out_0] [get_bd_pins i2s_receiver_from_codec_adc_0/ctrl_sw_out] [get_bd_pins i2s_transmitter_to_codec_dac_0/ctrl_sw]
  connect_bd_net -net i2s_receiver_from_codec_adc_0_line_in_l_125 [get_bd_pins line_in_l_125] [get_bd_pins i2s_receiver_from_codec_adc_0/line_in_l_125]
  connect_bd_net -net i2s_receiver_from_codec_adc_0_line_in_r_125 [get_bd_pins line_in_r_125] [get_bd_pins i2s_receiver_from_codec_adc_0/line_in_r_125]
  connect_bd_net -net i2s_receiver_from_codec_adc_0_lrclk1 [get_bd_pins lrclk1_0] [get_bd_pins i2s_receiver_from_codec_adc_0/lrclk1]
  connect_bd_net -net i2s_receiver_from_codec_adc_0_mclk [get_bd_pins adau1761_mclk] [get_bd_pins i2s_receiver_from_codec_adc_0/mclk]
  connect_bd_net -net i2s_receiver_from_codec_adc_0_mclk1 [get_bd_pins mclk1_0] [get_bd_pins i2s_receiver_from_codec_adc_0/mclk1]
  connect_bd_net -net i2s_receiver_from_codec_adc_0_next_adc_sample [get_bd_pins next_adc_sample] [get_bd_pins i2s_receiver_from_codec_adc_0/next_adc_sample_out]
  connect_bd_net -net i2s_transmitter_0_sd [get_bd_pins adau1761_dac_sdata_0] [get_bd_pins i2s_transmitter_to_codec_dac_0/serial_data_out2]
  connect_bd_net -net i2s_transmitter_to_codec_dac_0_next_dac_sample [get_bd_pins next_dac_sample] [get_bd_pins i2s_transmitter_to_codec_dac_0/next_dac_sample]
  connect_bd_net -net i2s_transmitter_to_codec_dac_0_serial_data_out1 [get_bd_pins serial_data_out1_0] [get_bd_pins i2s_transmitter_to_codec_dac_0/serial_data_out1]
  connect_bd_net -net mclk_cw_1 [get_bd_pins mclk_cw] [get_bd_pins i2s_receiver_from_codec_adc_0/mclk_cw]
  connect_bd_net -net rst_1 [get_bd_pins rst] [get_bd_pins i2s_receiver_from_codec_adc_0/rst]
  connect_bd_net -net s00_axi_aclk_1 [get_bd_pins s00_axi_aclk] [get_bd_pins adau1761_controller_0/s00_axi_aclk]
  connect_bd_net -net s00_axi_aresetn_1 [get_bd_pins s00_axi_aresetn] [get_bd_pins adau1761_controller_0/s00_axi_aresetn] [get_bd_pins i2s_transmitter_to_codec_dac_0/S_AXIS_ARESETN]
  connect_bd_net -net serial_data_in1_0_1 [get_bd_pins serial_data_in1_0] [get_bd_pins i2s_receiver_from_codec_adc_0/serial_data_in1]
  connect_bd_net -net sw_1 [get_bd_pins sw] [get_bd_pins i2s_receiver_from_codec_adc_0/sw]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: AudioProcessingChannel
proc create_hier_cell_AudioProcessingChannel { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_AudioProcessingChannel() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI2
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI3
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 fm_audio_s_axis
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 fm_udp_s_axis
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 to_udp_m_axis

  # Create pins
  create_bd_pin -dir I -type clk CLK_125
  create_bd_pin -dir O FILTER_DONE
  create_bd_pin -dir I -from 23 -to 0 IN_SIG_L
  create_bd_pin -dir I -from 23 -to 0 IN_SIG_R
  create_bd_pin -dir O -from 23 -to 0 OUT_VOLCTRL_L
  create_bd_pin -dir O -from 23 -to 0 OUT_VOLCTRL_R
  create_bd_pin -dir O SAMPLE_TRIG
  create_bd_pin -dir O fifo_empty_out
  create_bd_pin -dir O fifo_full_out
  create_bd_pin -dir I fm_audio_hdr_valid
  create_bd_pin -dir I -type rst fm_audio_s_axis_aresetn
  create_bd_pin -dir O irq_out
  create_bd_pin -dir I new_sample_in
  create_bd_pin -dir O -from 15 -to 0 path_rx_seq_num_out
  create_bd_pin -dir O -from 31 -to 0 path_rx_tc_code_out
  create_bd_pin -dir O path_tc_valid_out
  create_bd_pin -dir O -from 31 -to 0 path_tx_tc_code_out
  create_bd_pin -dir I rst_in
  create_bd_pin -dir O -from 15 -to 0 rx_packet_seq_cnt_out
  create_bd_pin -dir O -from 31 -to 0 rx_time_code_out
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -type rst s00_axi_aresetn
  create_bd_pin -dir O s_ch1_audio_payload_hdr_ready
  create_bd_pin -dir O status1_out
  create_bd_pin -dir O status2_out
  create_bd_pin -dir I sync_en_in_0
  create_bd_pin -dir I -from 31 -to 0 sync_time_code_in
  create_bd_pin -dir O -from 31 -to 0 sync_time_code_out
  create_bd_pin -dir I tc_adjust_in
  create_bd_pin -dir I -from 31 -to 0 tc_count_adjust
  create_bd_pin -dir I tc_sync_en_int_in
  create_bd_pin -dir O to_udp_hdr_valid
  create_bd_pin -dir I tsync_in_0

  # Create instance: FILTER_IIR_1, and set properties
  set FILTER_IIR_1 [ create_bd_cell -type ip -vlnv tsotnep:userLibrary:FILTER_IIR:1.0 FILTER_IIR_1 ]

  # Create instance: Volume_Pregain_1, and set properties
  set Volume_Pregain_1 [ create_bd_cell -type ip -vlnv tsotnep:userLibrary:Volume_Pregain:1.0 Volume_Pregain_1 ]

  # Create instance: audio_fader_0, and set properties
  set audio_fader_0 [ create_bd_cell -type ip -vlnv user.org:user:audio_fader:1.0 audio_fader_0 ]

  # Create instance: audio_fader_1, and set properties
  set audio_fader_1 [ create_bd_cell -type ip -vlnv user.org:user:audio_fader:1.0 audio_fader_1 ]

  # Create instance: eth_to_audio_plc_com_0, and set properties
  set eth_to_audio_plc_com_0 [ create_bd_cell -type ip -vlnv me:user:eth_to_audio_plc_combo_interface:2.0 eth_to_audio_plc_com_0 ]
  set_property -dict [ list \
   CONFIG.CIC_SIG_OUT_WIDTH {28} \
   CONFIG.COMP_SIG_OUT_WIDTH {28} \
   CONFIG.ENTRY_FADE_LENGTH {96} \
   CONFIG.EXIT_FADE_LENGTH {96} \
   CONFIG.FIFO_ADDR_WIDTH {8} \
   CONFIG.LIFO_ADDR_WIDTH {13} \
   CONFIG.REL_PIPE_LENGTH {12} \
   CONFIG.S_COUNT {32} \
 ] $eth_to_audio_plc_com_0

  # Create instance: mixer_1, and set properties
  set mixer_1 [ create_bd_cell -type ip -vlnv user.org:user:mixer:1.0 mixer_1 ]

  # Create instance: synchronizer_3, and set properties
  set synchronizer_3 [ create_bd_cell -type ip -vlnv user.org:user:synchronizer:1.0 synchronizer_3 ]

  # Create instance: synchronizer_4, and set properties
  set synchronizer_4 [ create_bd_cell -type ip -vlnv user.org:user:synchronizer:1.0 synchronizer_4 ]

  # Create instance: synchronizer_5, and set properties
  set synchronizer_5 [ create_bd_cell -type ip -vlnv user.org:user:synchronizer:1.0 synchronizer_5 ]

  # Create instance: synchronizer_6, and set properties
  set synchronizer_6 [ create_bd_cell -type ip -vlnv user.org:user:synchronizer:1.0 synchronizer_6 ]

  # Create instance: user_org_plc_seq_ip_0, and set properties
  set user_org_plc_seq_ip_0 [ create_bd_cell -type ip -vlnv user.org:user:user_org_plc_seq_ip:1.0 user_org_plc_seq_ip_0 ]
  set_property -dict [ list \
   CONFIG.CORE_VERSION {22} \
   CONFIG.FIFO_ADDR_WIDTH {10} \
   CONFIG.SEQ_BANK_FIFO_ADDR_WIDTH {9} \
   CONFIG.S_COUNT {64} \
 ] $user_org_plc_seq_ip_0

  # Create interface connections
  connect_bd_intf_net -intf_net audio_to_eth_interfa_0_m_audio_payload_axis [get_bd_intf_pins fm_audio_s_axis] [get_bd_intf_pins user_org_plc_seq_ip_0/fm_audio_s_axis]
  connect_bd_intf_net -intf_net full_udp_stack_ip_0_m_ch1_audio_payload_axis [get_bd_intf_pins fm_udp_s_axis] [get_bd_intf_pins user_org_plc_seq_ip_0/fm_udp_s_axis]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins S00_AXI1] [get_bd_intf_pins Volume_Pregain_1/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M05_AXI [get_bd_intf_pins S00_AXI3] [get_bd_intf_pins FILTER_IIR_1/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M06_AXI [get_bd_intf_pins S00_AXI2] [get_bd_intf_pins eth_to_audio_plc_com_0/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M12_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins user_org_plc_seq_ip_0/S00_AXI]
  connect_bd_intf_net -intf_net user_org_plc_seq_ip_0_to_audio_m_axis [get_bd_intf_pins eth_to_audio_plc_com_0/s_ch1_audio_payload_axis] [get_bd_intf_pins user_org_plc_seq_ip_0/to_audio_m_axis]
  connect_bd_intf_net -intf_net user_org_plc_seq_ip_0_to_udp_m_axis [get_bd_intf_pins to_udp_m_axis] [get_bd_intf_pins user_org_plc_seq_ip_0/to_udp_m_axis]

  # Create port connections
  connect_bd_net -net FILTER_IIR_1_FILTER_DONE [get_bd_pins FILTER_DONE] [get_bd_pins FILTER_IIR_1/FILTER_DONE]
  connect_bd_net -net Net [get_bd_pins eth_to_audio_plc_com_0/newsample_125_out] [get_bd_pins synchronizer_3/sync_clk] [get_bd_pins synchronizer_4/sync_clk] [get_bd_pins synchronizer_5/sync_clk] [get_bd_pins synchronizer_6/sync_clk]
  connect_bd_net -net Net1 [get_bd_pins fm_audio_s_axis_aresetn] [get_bd_pins user_org_plc_seq_ip_0/fm_audio_s_axis_aresetn] [get_bd_pins user_org_plc_seq_ip_0/fm_udp_s_axis_aresetn] [get_bd_pins user_org_plc_seq_ip_0/to_audio_m_axis_aresetn] [get_bd_pins user_org_plc_seq_ip_0/to_udp_m_axis_aresetn]
  connect_bd_net -net Volume_Pregain_1_OUT_RDY [get_bd_pins SAMPLE_TRIG] [get_bd_pins FILTER_IIR_1/SAMPLE_TRIG] [get_bd_pins Volume_Pregain_1/OUT_RDY]
  connect_bd_net -net ZedCodec_next_adc_sample [get_bd_pins new_sample_in] [get_bd_pins audio_fader_0/new_sample_in] [get_bd_pins audio_fader_1/new_sample_in] [get_bd_pins eth_to_audio_plc_com_0/newsample_in] [get_bd_pins user_org_plc_seq_ip_0/new_sample_in]
  connect_bd_net -net audio_fader_0_OUT_VOLCTRL_L [get_bd_pins audio_fader_0/OUT_VOLCTRL_L] [get_bd_pins mixer_1/audio_channel_a_left_in]
  connect_bd_net -net audio_fader_0_OUT_VOLCTRL_R [get_bd_pins audio_fader_0/OUT_VOLCTRL_R] [get_bd_pins mixer_1/audio_channel_a_right_in]
  connect_bd_net -net audio_fader_1_OUT_VOLCTRL_L [get_bd_pins audio_fader_1/OUT_VOLCTRL_L] [get_bd_pins mixer_1/audio_channel_b_left_in]
  connect_bd_net -net audio_fader_1_OUT_VOLCTRL_R [get_bd_pins audio_fader_1/OUT_VOLCTRL_R] [get_bd_pins mixer_1/audio_channel_b_right_in]
  connect_bd_net -net audio_to_eth_interfa_0_m_audio_payload_hdr_valid [get_bd_pins fm_audio_hdr_valid] [get_bd_pins user_org_plc_seq_ip_0/fm_audio_hdr_valid]
  connect_bd_net -net clk_wiz_0_clk_100_out [get_bd_pins s00_axi_aclk] [get_bd_pins FILTER_IIR_1/s00_axi_aclk] [get_bd_pins Volume_Pregain_1/s00_axi_aclk] [get_bd_pins eth_to_audio_plc_com_0/s00_axi_aclk] [get_bd_pins user_org_plc_seq_ip_0/s00_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_125_out1 [get_bd_pins CLK_125] [get_bd_pins audio_fader_0/CLK_125] [get_bd_pins audio_fader_1/CLK_125] [get_bd_pins eth_to_audio_plc_com_0/CLK_125] [get_bd_pins user_org_plc_seq_ip_0/clk_125] [get_bd_pins user_org_plc_seq_ip_0/fm_audio_s_axis_aclk] [get_bd_pins user_org_plc_seq_ip_0/fm_udp_s_axis_aclk] [get_bd_pins user_org_plc_seq_ip_0/to_audio_m_axis_aclk] [get_bd_pins user_org_plc_seq_ip_0/to_udp_m_axis_aclk]
  connect_bd_net -net eth_to_audio_plc_com_0_COEF_MAX_OUT [get_bd_pins audio_fader_0/IN_COEF_MAX] [get_bd_pins audio_fader_1/IN_COEF_MAX] [get_bd_pins eth_to_audio_plc_com_0/COEF_MAX_OUT]
  connect_bd_net -net eth_to_audio_plc_com_0_COEF_MIN_OUT [get_bd_pins audio_fader_0/IN_COEF_MIN] [get_bd_pins audio_fader_1/IN_COEF_MIN] [get_bd_pins eth_to_audio_plc_com_0/COEF_MIN_OUT]
  connect_bd_net -net eth_to_audio_plc_com_0_DOWN_STEP_PULSES_OUT [get_bd_pins audio_fader_0/DOWN_STEP_PULSES] [get_bd_pins audio_fader_1/DOWN_STEP_PULSES] [get_bd_pins eth_to_audio_plc_com_0/DOWN_STEP_PULSES_OUT]
  connect_bd_net -net eth_to_audio_plc_com_0_UP_STEP_PULSES_OUT [get_bd_pins audio_fader_0/UP_STEP_PULSES] [get_bd_pins audio_fader_1/UP_STEP_PULSES] [get_bd_pins eth_to_audio_plc_com_0/UP_STEP_PULSES_OUT]
  connect_bd_net -net eth_to_audio_plc_com_0_current_sync_time_out [get_bd_pins eth_to_audio_plc_com_0/current_sync_time_out] [get_bd_pins user_org_plc_seq_ip_0/current_sync_time_in]
  connect_bd_net -net eth_to_audio_plc_com_0_dpk_audio_l_out [get_bd_pins eth_to_audio_plc_com_0/dpk_audio_l_out] [get_bd_pins synchronizer_4/signal_in]
  connect_bd_net -net eth_to_audio_plc_com_0_dpk_audio_r_out [get_bd_pins eth_to_audio_plc_com_0/dpk_audio_r_out] [get_bd_pins synchronizer_5/signal_in]
  connect_bd_net -net eth_to_audio_plc_com_0_fade_dpk_clear_out [get_bd_pins audio_fader_0/fade_clear_in] [get_bd_pins eth_to_audio_plc_com_0/fade_dpk_clear_out]
  connect_bd_net -net eth_to_audio_plc_com_0_fade_dpk_enable_out [get_bd_pins audio_fader_0/fade_enable_in] [get_bd_pins eth_to_audio_plc_com_0/fade_dpk_enable_out]
  connect_bd_net -net eth_to_audio_plc_com_0_fade_dpk_max_out [get_bd_pins audio_fader_0/fade_max_in] [get_bd_pins eth_to_audio_plc_com_0/fade_dpk_max_out]
  connect_bd_net -net eth_to_audio_plc_com_0_fade_dpk_min_out [get_bd_pins audio_fader_0/fade_min_in] [get_bd_pins eth_to_audio_plc_com_0/fade_dpk_min_out]
  connect_bd_net -net eth_to_audio_plc_com_0_fade_dpkt_direction_out [get_bd_pins audio_fader_0/fade_direction_in] [get_bd_pins eth_to_audio_plc_com_0/fade_dpkt_direction_out]
  connect_bd_net -net eth_to_audio_plc_com_0_fade_plc_clear_out [get_bd_pins audio_fader_1/fade_clear_in] [get_bd_pins eth_to_audio_plc_com_0/fade_plc_clear_out]
  connect_bd_net -net eth_to_audio_plc_com_0_fade_plc_direction_out [get_bd_pins audio_fader_1/fade_direction_in] [get_bd_pins eth_to_audio_plc_com_0/fade_plc_direction_out]
  connect_bd_net -net eth_to_audio_plc_com_0_fade_plc_enable_out [get_bd_pins audio_fader_1/fade_enable_in] [get_bd_pins eth_to_audio_plc_com_0/fade_plc_enable_out]
  connect_bd_net -net eth_to_audio_plc_com_0_fade_plc_max_out [get_bd_pins audio_fader_1/fade_max_in] [get_bd_pins eth_to_audio_plc_com_0/fade_plc_max_out]
  connect_bd_net -net eth_to_audio_plc_com_0_fade_plc_min_out [get_bd_pins audio_fader_1/fade_min_in] [get_bd_pins eth_to_audio_plc_com_0/fade_plc_min_out]
  connect_bd_net -net eth_to_audio_plc_com_0_fifo_empty_out [get_bd_pins eth_to_audio_plc_com_0/fifo_empty_out] [get_bd_pins user_org_plc_seq_ip_0/fifo_empty_in]
  connect_bd_net -net eth_to_audio_plc_com_0_fifo_full_out [get_bd_pins eth_to_audio_plc_com_0/fifo_full_out] [get_bd_pins user_org_plc_seq_ip_0/fifo_full_in]
  connect_bd_net -net eth_to_audio_plc_com_0_fifo_occ_out [get_bd_pins eth_to_audio_plc_com_0/fifo_occ_out] [get_bd_pins user_org_plc_seq_ip_0/fifo_occ_in]
  connect_bd_net -net eth_to_audio_plc_com_0_irq_out [get_bd_pins irq_out] [get_bd_pins eth_to_audio_plc_com_0/irq_out]
  connect_bd_net -net eth_to_audio_plc_com_0_next_play_out_time_out [get_bd_pins eth_to_audio_plc_com_0/next_play_out_time_out] [get_bd_pins user_org_plc_seq_ip_0/next_play_out_time_in]
  connect_bd_net -net eth_to_audio_plc_com_0_play_out_delay_out [get_bd_pins eth_to_audio_plc_com_0/play_out_delay_out] [get_bd_pins user_org_plc_seq_ip_0/play_out_delay_in]
  connect_bd_net -net eth_to_audio_plc_com_0_plc_audio_l_out [get_bd_pins eth_to_audio_plc_com_0/plc_audio_l_out] [get_bd_pins synchronizer_6/signal_in]
  connect_bd_net -net eth_to_audio_plc_com_0_plc_audio_r_out [get_bd_pins eth_to_audio_plc_com_0/plc_audio_r_out] [get_bd_pins synchronizer_3/signal_in]
  connect_bd_net -net eth_to_audio_plc_com_0_plc_pkt_end_out [get_bd_pins eth_to_audio_plc_com_0/plc_pkt_end_out] [get_bd_pins user_org_plc_seq_ip_0/replace_pkt_end_in]
  connect_bd_net -net eth_to_audio_plc_com_0_replace_pkt_out [get_bd_pins eth_to_audio_plc_com_0/replace_pkt_out] [get_bd_pins user_org_plc_seq_ip_0/replace_pkt_in]
  connect_bd_net -net eth_to_audio_plc_com_0_rst_out [get_bd_pins audio_fader_0/RST_IN] [get_bd_pins audio_fader_1/RST_IN] [get_bd_pins eth_to_audio_plc_com_0/rst_out]
  connect_bd_net -net eth_to_audio_plc_com_0_rx_packet_seq_cnt_out [get_bd_pins rx_packet_seq_cnt_out] [get_bd_pins eth_to_audio_plc_com_0/rx_packet_seq_cnt_out]
  connect_bd_net -net eth_to_audio_plc_com_0_rx_time_code_out [get_bd_pins rx_time_code_out] [get_bd_pins eth_to_audio_plc_com_0/rx_time_code_out]
  connect_bd_net -net eth_to_audio_plc_com_0_s_ch1_audio_payload_hdr_ready [get_bd_pins s_ch1_audio_payload_hdr_ready] [get_bd_pins eth_to_audio_plc_com_0/s_ch1_audio_payload_hdr_ready]
  connect_bd_net -net eth_to_audio_plc_com_0_skip_slot_out [get_bd_pins eth_to_audio_plc_com_0/skip_slot_out] [get_bd_pins user_org_plc_seq_ip_0/skip_slot_in]
  connect_bd_net -net eth_to_audio_plc_com_0_sync_time_code_out -boundary_type lower [get_bd_pins sync_time_code_out]
  connect_bd_net -net mixer_1_audio_mixed_a_b_left_out [get_bd_pins OUT_VOLCTRL_L] [get_bd_pins FILTER_IIR_1/AUDIO_IN_L] [get_bd_pins Volume_Pregain_1/IN_SIG_L] [get_bd_pins mixer_1/audio_mixed_a_b_left_out]
  connect_bd_net -net mixer_1_audio_mixed_a_b_right_out [get_bd_pins OUT_VOLCTRL_R] [get_bd_pins FILTER_IIR_1/AUDIO_IN_R] [get_bd_pins Volume_Pregain_1/IN_SIG_R] [get_bd_pins mixer_1/audio_mixed_a_b_right_out]
  connect_bd_net -net rst_in_1 [get_bd_pins rst_in] [get_bd_pins user_org_plc_seq_ip_0/rst_in]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins s00_axi_aresetn] [get_bd_pins FILTER_IIR_1/s00_axi_aresetn] [get_bd_pins Volume_Pregain_1/s00_axi_aresetn] [get_bd_pins eth_to_audio_plc_com_0/s00_axi_aresetn] [get_bd_pins eth_to_audio_plc_com_0/s_ch1_audio_payload_axis_aresetn] [get_bd_pins user_org_plc_seq_ip_0/s00_axi_aresetn]
  connect_bd_net -net sync_en_in_0_1 [get_bd_pins sync_en_in_0] [get_bd_pins eth_to_audio_plc_com_0/tc_sync_en_in] [get_bd_pins user_org_plc_seq_ip_0/sync_en_in]
  connect_bd_net -net sync_time_code_in_1 [get_bd_pins sync_time_code_in] [get_bd_pins eth_to_audio_plc_com_0/sync_time_code_in]
  connect_bd_net -net synchronizer_3_signal_out [get_bd_pins audio_fader_1/IN_SIG_R] [get_bd_pins synchronizer_3/signal_out]
  connect_bd_net -net synchronizer_4_signal_out [get_bd_pins audio_fader_0/IN_SIG_L] [get_bd_pins synchronizer_4/signal_out]
  connect_bd_net -net synchronizer_5_signal_out [get_bd_pins audio_fader_0/IN_SIG_R] [get_bd_pins synchronizer_5/signal_out]
  connect_bd_net -net synchronizer_6_signal_out [get_bd_pins audio_fader_1/IN_SIG_L] [get_bd_pins synchronizer_6/signal_out]
  connect_bd_net -net time_sync_0_tc_adjust_out -boundary_type lower [get_bd_pins tc_adjust_in]
  connect_bd_net -net time_sync_0_tc_count_adjusted_out -boundary_type lower [get_bd_pins tc_count_adjust]
  connect_bd_net -net time_sync_0_tc_start -boundary_type lower [get_bd_pins tc_sync_en_int_in]
  connect_bd_net -net tsync_in_0_1 [get_bd_pins tsync_in_0] [get_bd_pins user_org_plc_seq_ip_0/tsync_in]
  connect_bd_net -net user_org_plc_seq_ip_0_fifo_empty_out [get_bd_pins fifo_empty_out] [get_bd_pins user_org_plc_seq_ip_0/fifo_empty_out]
  connect_bd_net -net user_org_plc_seq_ip_0_fifo_full_out [get_bd_pins fifo_full_out] [get_bd_pins user_org_plc_seq_ip_0/fifo_full_out]
  connect_bd_net -net user_org_plc_seq_ip_0_new_pkt_ready_out [get_bd_pins eth_to_audio_plc_com_0/new_pkt_ready_in] [get_bd_pins user_org_plc_seq_ip_0/new_pkt_ready_out]
  connect_bd_net -net user_org_plc_seq_ip_0_packet_available_out [get_bd_pins eth_to_audio_plc_com_0/packet_available_in] [get_bd_pins user_org_plc_seq_ip_0/packet_available_out]
  connect_bd_net -net user_org_plc_seq_ip_0_path_rx_seq_num_out [get_bd_pins path_rx_seq_num_out] [get_bd_pins user_org_plc_seq_ip_0/path_rx_seq_num_out]
  connect_bd_net -net user_org_plc_seq_ip_0_path_rx_tc_code_out [get_bd_pins path_rx_tc_code_out] [get_bd_pins user_org_plc_seq_ip_0/path_rx_tc_code_out]
  connect_bd_net -net user_org_plc_seq_ip_0_path_tc_valid_out [get_bd_pins path_tc_valid_out] [get_bd_pins user_org_plc_seq_ip_0/path_tc_valid_out]
  connect_bd_net -net user_org_plc_seq_ip_0_path_tx_tc_code_out [get_bd_pins path_tx_tc_code_out] [get_bd_pins user_org_plc_seq_ip_0/path_tx_tc_code_out]
  connect_bd_net -net user_org_plc_seq_ip_0_status1_out [get_bd_pins status1_out] [get_bd_pins user_org_plc_seq_ip_0/status1_out]
  connect_bd_net -net user_org_plc_seq_ip_0_status2_out [get_bd_pins status2_out] [get_bd_pins user_org_plc_seq_ip_0/status2_out]
  connect_bd_net -net user_org_plc_seq_ip_0_to_udp_hdr_valid [get_bd_pins to_udp_hdr_valid] [get_bd_pins user_org_plc_seq_ip_0/to_udp_hdr_valid]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set DC [ create_bd_port -dir O DC ]
  set RES [ create_bd_port -dir O RES ]
  set SCLK [ create_bd_port -dir O SCLK ]
  set SDIN [ create_bd_port -dir O SDIN ]
  set VBAT [ create_bd_port -dir O VBAT ]
  set VDD [ create_bd_port -dir O VDD ]
  set adau1761_adc_sdata_0 [ create_bd_port -dir I adau1761_adc_sdata_0 ]
  set adau1761_bclk_0 [ create_bd_port -dir I adau1761_bclk_0 ]
  set adau1761_cclk_0 [ create_bd_port -dir O adau1761_cclk_0 ]
  set adau1761_cdata_0 [ create_bd_port -dir O adau1761_cdata_0 ]
  set adau1761_clatchn_0 [ create_bd_port -dir O adau1761_clatchn_0 ]
  set adau1761_cout_0 [ create_bd_port -dir I adau1761_cout_0 ]
  set adau1761_dac_sdata_0 [ create_bd_port -dir O adau1761_dac_sdata_0 ]
  set adau1761_lrclk_0 [ create_bd_port -dir I adau1761_lrclk_0 ]
  set adau1761_mclk [ create_bd_port -dir O -type clk adau1761_mclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {12288786} \
 ] $adau1761_mclk
  set bclk1_0 [ create_bd_port -dir O bclk1_0 ]
  set btnc_0 [ create_bd_port -dir I btnc_0 ]
  set btnd_0 [ create_bd_port -dir I btnd_0 ]
  set btnl_0 [ create_bd_port -dir I btnl_0 ]
  set btnr_0 [ create_bd_port -dir I btnr_0 ]
  set btnu_0 [ create_bd_port -dir I btnu_0 ]
  set clk_100_in [ create_bd_port -dir I -type clk clk_100_in ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   CONFIG.PHASE {0.000} \
 ] $clk_100_in
  set ctrl_sw_out_0 [ create_bd_port -dir O ctrl_sw_out_0 ]
  set led_0 [ create_bd_port -dir O -from 7 -to 0 led_0 ]
  set lrclk1_0 [ create_bd_port -dir O lrclk1_0 ]
  set mclk1_0 [ create_bd_port -dir O mclk1_0 ]
  set phy_int_n_0 [ create_bd_port -dir I phy_int_n_0 ]
  set phy_mdc_0 [ create_bd_port -dir O phy_mdc_0 ]
  set phy_mdio_0 [ create_bd_port -dir IO phy_mdio_0 ]
  set phy_pme_n_0 [ create_bd_port -dir I phy_pme_n_0 ]
  set phy_reset_n_0 [ create_bd_port -dir O phy_reset_n_0 ]
  set phy_rx_clk_0 [ create_bd_port -dir I -type clk phy_rx_clk_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $phy_rx_clk_0
  set phy_rx_ctl_0 [ create_bd_port -dir I phy_rx_ctl_0 ]
  set phy_rxd_0 [ create_bd_port -dir I -from 3 -to 0 phy_rxd_0 ]
  set phy_tx_clk_0 [ create_bd_port -dir O phy_tx_clk_0 ]
  set phy_tx_ctl_0 [ create_bd_port -dir O phy_tx_ctl_0 ]
  set phy_txd_0 [ create_bd_port -dir O -from 3 -to 0 phy_txd_0 ]
  set serial_data_in1_0 [ create_bd_port -dir I serial_data_in1_0 ]
  set serial_data_out1_0 [ create_bd_port -dir O serial_data_out1_0 ]
  set sw_0 [ create_bd_port -dir I -from 7 -to 0 sw_0 ]
  set sync_en_out_0 [ create_bd_port -dir O sync_en_out_0 ]
  set tsync_out_0 [ create_bd_port -dir O tsync_out_0 ]

  # Create instance: AudioProcessingChannel
  create_hier_cell_AudioProcessingChannel [current_bd_instance .] AudioProcessingChannel

  # Create instance: FILTER_IIR_0, and set properties
  set FILTER_IIR_0 [ create_bd_cell -type ip -vlnv tsotnep:userLibrary:FILTER_IIR:1.0 FILTER_IIR_0 ]

  # Create instance: Volume_Pregain_0, and set properties
  set Volume_Pregain_0 [ create_bd_cell -type ip -vlnv tsotnep:userLibrary:Volume_Pregain:1.0 Volume_Pregain_0 ]

  # Create instance: ZedCodec
  create_hier_cell_ZedCodec [current_bd_instance .] ZedCodec

  # Create instance: ZedboardOLED_0, and set properties
  set ZedboardOLED_0 [ create_bd_cell -type ip -vlnv tamu.edu:user:ZedboardOLED:1.0 ZedboardOLED_0 ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_GPIO_WIDTH {5} \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.GPIO_BOARD_INTERFACE {btns_5bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_GPIO_WIDTH {8} \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.GPIO_BOARD_INTERFACE {sws_8bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_1

  # Create instance: axi_gpio_2, and set properties
  set axi_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {8} \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.GPIO_BOARD_INTERFACE {leds_8bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_2

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {201.426} \
   CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288} \
   CONFIG.CLKOUT2_JITTER {130.958} \
   CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.ENABLE_CLOCK_MONITOR {false} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {81.375} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_0

  # Create instance: eth_udp_axi_arp_stack_0, and set properties
  set eth_udp_axi_arp_stack_0 [ create_bd_cell -type ip -vlnv user.org:user:eth_udp_axi_arp_stack:1.0 eth_udp_axi_arp_stack_0 ]

  # Create instance: mixer_0, and set properties
  set mixer_0 [ create_bd_cell -type ip -vlnv user.org:user:mixer:1.0 mixer_0 ]

  # Create instance: org_audio2eth_interl_0, and set properties
  set org_audio2eth_interl_0 [ create_bd_cell -type ip -vlnv user.org:user:org_audio2eth_interleaved_packetizer:1.0 org_audio2eth_interl_0 ]
  set_property -dict [ list \
   CONFIG.PACKET_LEN_WIDTH {16} \
 ] $org_audio2eth_interl_0

  # Create instance: pmod_controller_0, and set properties
  set pmod_controller_0 [ create_bd_cell -type ip -vlnv ttu.ee:user:pmod_controller:1.0 pmod_controller_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {90.909088} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666667} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN0_BASEADDR {0xE0008000} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_HIGHADDR {0xE0008FFF} \
   CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN1_BASEADDR {0xE0009000} \
   CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN1_HIGHADDR {0xE0009FFF} \
   CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN1_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {90909088} \
   CONFIG.PCW_CLK2_FREQ {125000000} \
   CONFIG.PCW_CLK3_FREQ {200000000} \
   CONFIG.PCW_CORE0_FIQ_INTR {0} \
   CONFIG.PCW_CORE0_IRQ_INTR {0} \
   CONFIG.PCW_CORE1_FIQ_INTR {0} \
   CONFIG.PCW_CORE1_IRQ_INTR {0} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
   CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
   CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_BASEADDR {0xE000B000} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_HIGHADDR {0xE000BFFF} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_BASEADDR {0xE000C000} \
   CONFIG.PCW_ENET1_ENET1_IO {EMIO} \
   CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET1_GRP_MDIO_IO {EMIO} \
   CONFIG.PCW_ENET1_HIGHADDR {0xE000CFFF} \
   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_4K_TIMER {0} \
   CONFIG.PCW_EN_CAN0 {0} \
   CONFIG.PCW_EN_CAN1 {0} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {1} \
   CONFIG.PCW_EN_CLK3_PORT {1} \
   CONFIG.PCW_EN_CLKTRIG0_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG2_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_CAN0 {0} \
   CONFIG.PCW_EN_EMIO_CAN1 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_ENET1 {1} \
   CONFIG.PCW_EN_EMIO_GPIO {0} \
   CONFIG.PCW_EN_EMIO_I2C0 {0} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
   CONFIG.PCW_EN_EMIO_PJTAG {0} \
   CONFIG.PCW_EN_EMIO_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {0} \
   CONFIG.PCW_EN_EMIO_SPI1 {0} \
   CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
   CONFIG.PCW_EN_EMIO_TRACE {0} \
   CONFIG.PCW_EN_EMIO_TTC0 {1} \
   CONFIG.PCW_EN_EMIO_TTC1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {0} \
   CONFIG.PCW_EN_EMIO_WDT {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_ENET1 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {0} \
   CONFIG.PCW_EN_I2C1 {0} \
   CONFIG.PCW_EN_MODEM_UART0 {0} \
   CONFIG.PCW_EN_MODEM_UART1 {0} \
   CONFIG.PCW_EN_PJTAG {0} \
   CONFIG.PCW_EN_PTP_ENET0 {0} \
   CONFIG.PCW_EN_PTP_ENET1 {0} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SDIO1 {0} \
   CONFIG.PCW_EN_SMC {0} \
   CONFIG.PCW_EN_SPI0 {0} \
   CONFIG.PCW_EN_SPI1 {0} \
   CONFIG.PCW_EN_TRACE {0} \
   CONFIG.PCW_EN_TTC0 {1} \
   CONFIG.PCW_EN_TTC1 {0} \
   CONFIG.PCW_EN_UART0 {0} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {0} \
   CONFIG.PCW_EN_USB1 {0} \
   CONFIG.PCW_EN_WDT {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {11} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK3_BUF {TRUE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {90} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {125} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {1} \
   CONFIG.PCW_GP0_EN_MODIFIABLE_TXN {1} \
   CONFIG.PCW_GP0_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP0_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GP1_EN_MODIFIABLE_TXN {1} \
   CONFIG.PCW_GP1_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP1_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GPIO_BASEADDR {0xE000A000} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_BASEADDR {0xE0004000} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_HIGHADDR {0xE0004FFF} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_BASEADDR {0xE0005000} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_HIGHADDR {0xE0005FFF} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
   CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
   CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} \
   CONFIG.PCW_INCLUDE_TRACE_BUFFER {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_IRQ_F2P_MODE {DIRECT} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {disabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {disabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {disabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {disabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {disabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {inout} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {disabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {disabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {disabled} \
   CONFIG.PCW_MIO_16_SLEW {fast} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {disabled} \
   CONFIG.PCW_MIO_17_SLEW {fast} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {disabled} \
   CONFIG.PCW_MIO_18_SLEW {fast} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {disabled} \
   CONFIG.PCW_MIO_19_SLEW {fast} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {disabled} \
   CONFIG.PCW_MIO_1_SLEW {fast} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {disabled} \
   CONFIG.PCW_MIO_20_SLEW {fast} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {disabled} \
   CONFIG.PCW_MIO_21_SLEW {fast} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {disabled} \
   CONFIG.PCW_MIO_22_SLEW {fast} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {disabled} \
   CONFIG.PCW_MIO_23_SLEW {fast} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {disabled} \
   CONFIG.PCW_MIO_24_SLEW {fast} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {disabled} \
   CONFIG.PCW_MIO_25_SLEW {fast} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {disabled} \
   CONFIG.PCW_MIO_26_SLEW {fast} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {disabled} \
   CONFIG.PCW_MIO_27_SLEW {fast} \
   CONFIG.PCW_MIO_28_DIRECTION {out} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {disabled} \
   CONFIG.PCW_MIO_28_SLEW {fast} \
   CONFIG.PCW_MIO_29_DIRECTION {out} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {disabled} \
   CONFIG.PCW_MIO_29_SLEW {fast} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {fast} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {disabled} \
   CONFIG.PCW_MIO_30_SLEW {fast} \
   CONFIG.PCW_MIO_31_DIRECTION {out} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {disabled} \
   CONFIG.PCW_MIO_31_SLEW {fast} \
   CONFIG.PCW_MIO_32_DIRECTION {out} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {disabled} \
   CONFIG.PCW_MIO_32_SLEW {fast} \
   CONFIG.PCW_MIO_33_DIRECTION {out} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {disabled} \
   CONFIG.PCW_MIO_33_SLEW {fast} \
   CONFIG.PCW_MIO_34_DIRECTION {in} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {disabled} \
   CONFIG.PCW_MIO_34_SLEW {fast} \
   CONFIG.PCW_MIO_35_DIRECTION {in} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {disabled} \
   CONFIG.PCW_MIO_35_SLEW {fast} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {disabled} \
   CONFIG.PCW_MIO_36_SLEW {fast} \
   CONFIG.PCW_MIO_37_DIRECTION {in} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {disabled} \
   CONFIG.PCW_MIO_37_SLEW {fast} \
   CONFIG.PCW_MIO_38_DIRECTION {in} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {disabled} \
   CONFIG.PCW_MIO_38_SLEW {fast} \
   CONFIG.PCW_MIO_39_DIRECTION {in} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {disabled} \
   CONFIG.PCW_MIO_39_SLEW {fast} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {fast} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {disabled} \
   CONFIG.PCW_MIO_40_SLEW {fast} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {disabled} \
   CONFIG.PCW_MIO_41_SLEW {fast} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {disabled} \
   CONFIG.PCW_MIO_42_SLEW {fast} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {disabled} \
   CONFIG.PCW_MIO_43_SLEW {fast} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {disabled} \
   CONFIG.PCW_MIO_44_SLEW {fast} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {disabled} \
   CONFIG.PCW_MIO_45_SLEW {fast} \
   CONFIG.PCW_MIO_46_DIRECTION {in} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {disabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {disabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {disabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {disabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {fast} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {disabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {disabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {disabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {disabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {fast} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {fast} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {fast} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {disabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#UART 1#UART 1#GPIO#GPIO#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#gpio[8]#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#gpio[28]#gpio[29]#gpio[30]#gpio[31]#gpio[32]#gpio[33]#gpio[34]#gpio[35]#gpio[36]#gpio[37]#gpio[38]#gpio[39]#clk#cmd#data[0]#data[1]#data[2]#data[3]#wp#cd#tx#rx#gpio[50]#gpio[51]#mdc#mdio} \
   CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP0_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP0_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP1_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP1_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_NAND_CYCLES_T_AR {1} \
   CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
   CONFIG.PCW_NAND_CYCLES_T_RC {11} \
   CONFIG.PCW_NAND_CYCLES_T_REA {1} \
   CONFIG.PCW_NAND_CYCLES_T_RR {1} \
   CONFIG.PCW_NAND_CYCLES_T_WC {11} \
   CONFIG.PCW_NAND_CYCLES_T_WP {1} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_CS0_T_PC {1} \
   CONFIG.PCW_NOR_CS0_T_RC {11} \
   CONFIG.PCW_NOR_CS0_T_TR {1} \
   CONFIG.PCW_NOR_CS0_T_WC {11} \
   CONFIG.PCW_NOR_CS0_T_WP {1} \
   CONFIG.PCW_NOR_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_CS1_T_PC {1} \
   CONFIG.PCW_NOR_CS1_T_RC {11} \
   CONFIG.PCW_NOR_CS1_T_TR {1} \
   CONFIG.PCW_NOR_CS1_T_WC {11} \
   CONFIG.PCW_NOR_CS1_T_WP {1} \
   CONFIG.PCW_NOR_CS1_WE_TIME {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
   CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
   CONFIG.PCW_P2F_CAN0_INTR {0} \
   CONFIG.PCW_P2F_CAN1_INTR {0} \
   CONFIG.PCW_P2F_CTI_INTR {0} \
   CONFIG.PCW_P2F_DMAC0_INTR {0} \
   CONFIG.PCW_P2F_DMAC1_INTR {0} \
   CONFIG.PCW_P2F_DMAC2_INTR {0} \
   CONFIG.PCW_P2F_DMAC3_INTR {0} \
   CONFIG.PCW_P2F_DMAC4_INTR {0} \
   CONFIG.PCW_P2F_DMAC5_INTR {0} \
   CONFIG.PCW_P2F_DMAC6_INTR {0} \
   CONFIG.PCW_P2F_DMAC7_INTR {0} \
   CONFIG.PCW_P2F_DMAC_ABORT_INTR {0} \
   CONFIG.PCW_P2F_ENET0_INTR {0} \
   CONFIG.PCW_P2F_ENET1_INTR {0} \
   CONFIG.PCW_P2F_GPIO_INTR {0} \
   CONFIG.PCW_P2F_I2C0_INTR {0} \
   CONFIG.PCW_P2F_I2C1_INTR {0} \
   CONFIG.PCW_P2F_QSPI_INTR {0} \
   CONFIG.PCW_P2F_SDIO0_INTR {0} \
   CONFIG.PCW_P2F_SDIO1_INTR {0} \
   CONFIG.PCW_P2F_SMC_INTR {0} \
   CONFIG.PCW_P2F_SPI0_INTR {0} \
   CONFIG.PCW_P2F_SPI1_INTR {0} \
   CONFIG.PCW_P2F_UART0_INTR {0} \
   CONFIG.PCW_P2F_UART1_INTR {0} \
   CONFIG.PCW_P2F_USB0_INTR {0} \
   CONFIG.PCW_P2F_USB1_INTR {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.063} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.062} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.065} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.083} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.007} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.010} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.006} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.048} \
   CONFIG.PCW_PACKAGE_NAME {clg484} \
   CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_PERIPHERAL_BOARD_PRESET {part0} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_WP_IO {MIO 46} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SDIO0_BASEADDR {0xE0100000} \
   CONFIG.PCW_SDIO0_HIGHADDR {0xE0100FFF} \
   CONFIG.PCW_SDIO1_BASEADDR {0xE0101000} \
   CONFIG.PCW_SDIO1_HIGHADDR {0xE0101FFF} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_CYCLE_T0 {NA} \
   CONFIG.PCW_SMC_CYCLE_T1 {NA} \
   CONFIG.PCW_SMC_CYCLE_T2 {NA} \
   CONFIG.PCW_SMC_CYCLE_T3 {NA} \
   CONFIG.PCW_SMC_CYCLE_T4 {NA} \
   CONFIG.PCW_SMC_CYCLE_T5 {NA} \
   CONFIG.PCW_SMC_CYCLE_T6 {NA} \
   CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
   CONFIG.PCW_SPI0_BASEADDR {0xE0006000} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI0_HIGHADDR {0xE0006FFF} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI1_BASEADDR {0xE0007000} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI1_HIGHADDR {0xE0007FFF} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {0} \
   CONFIG.PCW_S_AXI_ACP_ARUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_AWUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_ID_WIDTH {3} \
   CONFIG.PCW_S_AXI_GP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_GP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP2_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP3_ID_WIDTH {6} \
   CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_TRACE_BUFFER_CLOCK_DELAY {12} \
   CONFIG.PCW_TRACE_BUFFER_FIFO_SIZE {128} \
   CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
   CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PCW_TTC0_BASEADDR {0xE0104000} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_HIGHADDR {0xE0104fff} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
   CONFIG.PCW_TTC1_BASEADDR {0xE0105000} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_HIGHADDR {0xE0105fff} \
   CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_BASEADDR {0xE0000000} \
   CONFIG.PCW_UART0_BAUD_RATE {115200} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_HIGHADDR {0xE0000FFF} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_UART1_BASEADDR {0xE0001000} \
   CONFIG.PCW_UART1_BAUD_RATE {115200} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_HIGHADDR {0xE0001FFF} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.41} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.411} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.341} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.358} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {2048 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {68.4725} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {71.086} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {66.794} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {108.7385} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.025} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.028} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {-0.061} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {64.1705} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {63.686} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {68.46} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {105.4895} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333313} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M16 HA-15E} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {14} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {45.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {36.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {49.5} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
   CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NONE} \
   CONFIG.PCW_USB0_BASEADDR {0xE0102000} \
   CONFIG.PCW_USB0_HIGHADDR {0xE0102fff} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB0_USB0_IO {<Select>} \
   CONFIG.PCW_USB1_BASEADDR {0xE0103000} \
   CONFIG.PCW_USB1_HIGHADDR {0xE0103fff} \
   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
   CONFIG.PCW_USB_RESET_SELECT {<Select>} \
   CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
   CONFIG.PCW_USE_AXI_NONSECURE {0} \
   CONFIG.PCW_USE_CORESIGHT {0} \
   CONFIG.PCW_USE_CROSS_TRIGGER {0} \
   CONFIG.PCW_USE_CR_FABRIC {1} \
   CONFIG.PCW_USE_DDR_BYPASS {0} \
   CONFIG.PCW_USE_DEBUG {0} \
   CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {0} \
   CONFIG.PCW_USE_DMA0 {0} \
   CONFIG.PCW_USE_DMA1 {0} \
   CONFIG.PCW_USE_DMA2 {0} \
   CONFIG.PCW_USE_DMA3 {0} \
   CONFIG.PCW_USE_EXPANDED_IOP {0} \
   CONFIG.PCW_USE_EXPANDED_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_HIGH_OCM {0} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_PROC_EVENT_BUS {0} \
   CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_S_AXI_ACP {0} \
   CONFIG.PCW_USE_S_AXI_GP0 {0} \
   CONFIG.PCW_USE_S_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {0} \
   CONFIG.PCW_USE_S_AXI_HP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP2 {0} \
   CONFIG.PCW_USE_S_AXI_HP3 {0} \
   CONFIG.PCW_USE_TRACE {0} \
   CONFIG.PCW_USE_TRACE_DATA_EDGE_DETECTOR {0} \
   CONFIG.PCW_VALUE_SILVERSION {3} \
   CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {16} \
 ] $ps7_0_axi_periph

  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create instance: time_sync_block_0, and set properties
  set time_sync_block_0 [ create_bd_cell -type ip -vlnv me:user:time_sync_block:2.0 time_sync_block_0 ]

  # Create instance: user_cross_layer_swi_0, and set properties
  set user_cross_layer_swi_0 [ create_bd_cell -type ip -vlnv user.org:user:user_cross_layer_switch:1.0 user_cross_layer_swi_0 ]
  set_property -dict [ list \
   CONFIG.FROM_CS_FIFO_ADDR_WIDTH {9} \
   CONFIG.RX_FIFO_ADDR_WIDTH {12} \
   CONFIG.RX_HDR_FIFO_DEPTH {64} \
   CONFIG.TX_FIFO_ADDR_WIDTH {12} \
 ] $user_cross_layer_swi_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {10} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net AudioProcessingChannel_to_udp_m_axis [get_bd_intf_pins AudioProcessingChannel/to_udp_m_axis] [get_bd_intf_pins eth_udp_axi_arp_stack_0/s_audio_payload_axis]
  connect_bd_intf_net -intf_net eth_udp_axi_arp_stack_0_m_time_sync_payload_axis [get_bd_intf_pins eth_udp_axi_arp_stack_0/m_time_sync_payload_axis] [get_bd_intf_pins time_sync_block_0/s_time_sync_axis]
  connect_bd_intf_net -intf_net eth_udp_axi_arp_stack_0_to_sw_tx_axis [get_bd_intf_pins eth_udp_axi_arp_stack_0/to_sw_tx_axis] [get_bd_intf_pins user_cross_layer_swi_0/s_from_cs_axis]
  connect_bd_intf_net -intf_net fm_audio_s_axis_1 [get_bd_intf_pins AudioProcessingChannel/fm_audio_s_axis] [get_bd_intf_pins org_audio2eth_interl_0/m_audio_payload_axis]
  connect_bd_intf_net -intf_net fm_udp_s_axis_1 [get_bd_intf_pins AudioProcessingChannel/fm_udp_s_axis] [get_bd_intf_pins eth_udp_axi_arp_stack_0/m_ch1_audio_payload_axis]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins FILTER_IIR_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins Volume_Pregain_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins ZedboardOLED_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins AudioProcessingChannel/S00_AXI1] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M05_AXI [get_bd_intf_pins AudioProcessingChannel/S00_AXI3] [get_bd_intf_pins ps7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M06_AXI [get_bd_intf_pins AudioProcessingChannel/S00_AXI2] [get_bd_intf_pins ps7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M07_AXI [get_bd_intf_pins pmod_controller_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M08_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M09_AXI [get_bd_intf_pins axi_gpio_2/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M10_AXI [get_bd_intf_pins org_audio2eth_interl_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M11_AXI [get_bd_intf_pins eth_udp_axi_arp_stack_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M12_AXI [get_bd_intf_pins AudioProcessingChannel/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M13_AXI [get_bd_intf_pins ZedCodec/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M13_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M14_AXI [get_bd_intf_pins ps7_0_axi_periph/M14_AXI] [get_bd_intf_pins time_sync_block_0/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M15_AXI [get_bd_intf_pins ps7_0_axi_periph/M15_AXI] [get_bd_intf_pins user_cross_layer_swi_0/S00_AXI]
  connect_bd_intf_net -intf_net time_sync_block_0_m_time_sync_axis [get_bd_intf_pins eth_udp_axi_arp_stack_0/s_time_sync_payload_axis] [get_bd_intf_pins time_sync_block_0/m_time_sync_axis]
  connect_bd_intf_net -intf_net user_cross_layer_swi_0_m_to_cs_axis [get_bd_intf_pins eth_udp_axi_arp_stack_0/from_sw_rx_axis] [get_bd_intf_pins user_cross_layer_swi_0/m_to_cs_axis]

  # Create port connections
  connect_bd_net -net AudioProcessingChannel_path_rx_seq_num_out [get_bd_pins AudioProcessingChannel/path_rx_seq_num_out] [get_bd_pins org_audio2eth_interl_0/rx_packet_seq_cnt_in]
  connect_bd_net -net AudioProcessingChannel_path_rx_tc_code_out [get_bd_pins AudioProcessingChannel/path_rx_tc_code_out] [get_bd_pins org_audio2eth_interl_0/rx_time_code_in] [get_bd_pins time_sync_block_0/path_rx_tc_code_in]
  connect_bd_net -net AudioProcessingChannel_path_tc_valid_out [get_bd_pins AudioProcessingChannel/path_tc_valid_out] [get_bd_pins time_sync_block_0/path_tc_valid_in]
  connect_bd_net -net AudioProcessingChannel_path_tx_tc_code_out [get_bd_pins AudioProcessingChannel/path_tx_tc_code_out] [get_bd_pins time_sync_block_0/path_tx_tc_code_in]
  connect_bd_net -net FILTER_IIR_0_FILTER_DONE [get_bd_pins FILTER_IIR_0/FILTER_DONE] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net FILTER_IIR_1_FILTER_DONE [get_bd_pins AudioProcessingChannel/FILTER_DONE] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net Net [get_bd_pins processing_system7_0/ENET1_GMII_RXD] [get_bd_pins user_cross_layer_swi_0/to_ps_gmii_rxd]
  connect_bd_net -net Net1 [get_bd_ports phy_mdio_0] [get_bd_pins user_cross_layer_swi_0/phy_mdio]
  connect_bd_net -net Net2 [get_bd_pins processing_system7_0/ENET1_GMII_TX_CLK] [get_bd_pins user_cross_layer_swi_0/ps_gmii_tx_clk]
  connect_bd_net -net Volume_Pregain_0_OUT_RDY [get_bd_pins FILTER_IIR_0/SAMPLE_TRIG] [get_bd_pins Volume_Pregain_0/OUT_RDY] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net Volume_Pregain_1_OUT_RDY [get_bd_pins AudioProcessingChannel/SAMPLE_TRIG] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net Volume_Pregain_1_OUT_VOLCTRL_L [get_bd_pins AudioProcessingChannel/OUT_VOLCTRL_L] [get_bd_pins mixer_0/audio_channel_b_left_in]
  connect_bd_net -net Volume_Pregain_1_OUT_VOLCTRL_R [get_bd_pins AudioProcessingChannel/OUT_VOLCTRL_R] [get_bd_pins mixer_0/audio_channel_b_right_in]
  connect_bd_net -net ZedCodec_adau1761_mclk [get_bd_ports adau1761_mclk] [get_bd_pins ZedCodec/adau1761_mclk]
  connect_bd_net -net ZedCodec_bclk1_0 [get_bd_ports bclk1_0] [get_bd_pins ZedCodec/bclk1_0]
  connect_bd_net -net ZedCodec_ctrl_sw_out_0 [get_bd_ports ctrl_sw_out_0] [get_bd_pins ZedCodec/ctrl_sw_out_0]
  connect_bd_net -net ZedCodec_line_in_l_125 [get_bd_pins AudioProcessingChannel/IN_SIG_L] [get_bd_pins FILTER_IIR_0/AUDIO_IN_L] [get_bd_pins Volume_Pregain_0/IN_SIG_L] [get_bd_pins ZedCodec/line_in_l_125] [get_bd_pins mixer_0/audio_channel_a_left_in] [get_bd_pins org_audio2eth_interl_0/line_in_l_in]
  connect_bd_net -net ZedCodec_line_in_r_125 [get_bd_pins AudioProcessingChannel/IN_SIG_R] [get_bd_pins FILTER_IIR_0/AUDIO_IN_R] [get_bd_pins Volume_Pregain_0/IN_SIG_R] [get_bd_pins ZedCodec/line_in_r_125] [get_bd_pins mixer_0/audio_channel_a_right_in] [get_bd_pins org_audio2eth_interl_0/line_in_r_in]
  connect_bd_net -net ZedCodec_lrclk1_0 [get_bd_ports lrclk1_0] [get_bd_pins ZedCodec/lrclk1_0]
  connect_bd_net -net ZedCodec_mclk1_0 [get_bd_ports mclk1_0] [get_bd_pins ZedCodec/mclk1_0]
  connect_bd_net -net ZedCodec_next_adc_sample [get_bd_pins AudioProcessingChannel/new_sample_in] [get_bd_pins ZedCodec/next_adc_sample] [get_bd_pins org_audio2eth_interl_0/newsample_in] [get_bd_pins time_sync_block_0/newsample_in]
  connect_bd_net -net ZedCodec_serial_data_out1_0 [get_bd_ports serial_data_out1_0] [get_bd_pins ZedCodec/serial_data_out1_0]
  connect_bd_net -net ZedboardOLED_0_DC [get_bd_ports DC] [get_bd_pins ZedboardOLED_0/DC]
  connect_bd_net -net ZedboardOLED_0_RES [get_bd_ports RES] [get_bd_pins ZedboardOLED_0/RES]
  connect_bd_net -net ZedboardOLED_0_SCLK [get_bd_ports SCLK] [get_bd_pins ZedboardOLED_0/SCLK]
  connect_bd_net -net ZedboardOLED_0_SDIN [get_bd_ports SDIN] [get_bd_pins ZedboardOLED_0/SDIN]
  connect_bd_net -net ZedboardOLED_0_VBAT [get_bd_ports VBAT] [get_bd_pins ZedboardOLED_0/VBAT]
  connect_bd_net -net ZedboardOLED_0_VDD [get_bd_ports VDD] [get_bd_pins ZedboardOLED_0/VDD]
  connect_bd_net -net adau1761_adc_sdata_0 [get_bd_ports adau1761_adc_sdata_0] [get_bd_pins ZedCodec/adau1761_adc_sdata_0]
  connect_bd_net -net adau1761_bclk_0 [get_bd_ports adau1761_bclk_0] [get_bd_pins ZedCodec/adau1761_bclk_0]
  connect_bd_net -net adau1761_controller_0_adau1761_cclk [get_bd_ports adau1761_cclk_0] [get_bd_pins ZedCodec/adau1761_cclk_0]
  connect_bd_net -net adau1761_controller_0_adau1761_cdata [get_bd_ports adau1761_cdata_0] [get_bd_pins ZedCodec/adau1761_cdata_0]
  connect_bd_net -net adau1761_controller_0_adau1761_clatchn [get_bd_ports adau1761_clatchn_0] [get_bd_pins ZedCodec/adau1761_clatchn_0]
  connect_bd_net -net adau1761_cout_0_1 [get_bd_ports adau1761_cout_0] [get_bd_pins ZedCodec/adau1761_cout_0]
  connect_bd_net -net adau1761_lrclk_0 [get_bd_ports adau1761_lrclk_0] [get_bd_pins ZedCodec/adau1761_lrclk_0]
  connect_bd_net -net axi_gpio_0_ip2intc_irpt [get_bd_pins axi_gpio_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_gpio_1_ip2intc_irpt [get_bd_pins axi_gpio_1/ip2intc_irpt] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net axi_gpio_2_ip2intc_irpt [get_bd_pins axi_gpio_2/ip2intc_irpt] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net btnc_0_1 [get_bd_ports btnc_0] [get_bd_pins eth_udp_axi_arp_stack_0/btnc]
  connect_bd_net -net btnd_0_1 [get_bd_ports btnd_0] [get_bd_pins eth_udp_axi_arp_stack_0/btnd]
  connect_bd_net -net btnl_0_1 [get_bd_ports btnl_0] [get_bd_pins eth_udp_axi_arp_stack_0/btnl]
  connect_bd_net -net btnr_0_1 [get_bd_ports btnr_0] [get_bd_pins eth_udp_axi_arp_stack_0/btnr]
  connect_bd_net -net btnu_0_1 [get_bd_ports btnu_0] [get_bd_pins eth_udp_axi_arp_stack_0/btnu]
  connect_bd_net -net clk_100_in_1 [get_bd_ports clk_100_in] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_100_out [get_bd_pins AudioProcessingChannel/s00_axi_aclk] [get_bd_pins FILTER_IIR_0/s00_axi_aclk] [get_bd_pins Volume_Pregain_0/s00_axi_aclk] [get_bd_pins ZedCodec/s00_axi_aclk] [get_bd_pins ZedboardOLED_0/s00_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_gpio_2/s_axi_aclk] [get_bd_pins eth_udp_axi_arp_stack_0/s00_axi_aclk] [get_bd_pins org_audio2eth_interl_0/s00_axi_aclk] [get_bd_pins pmod_controller_0/s00_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/M05_ACLK] [get_bd_pins ps7_0_axi_periph/M06_ACLK] [get_bd_pins ps7_0_axi_periph/M07_ACLK] [get_bd_pins ps7_0_axi_periph/M08_ACLK] [get_bd_pins ps7_0_axi_periph/M09_ACLK] [get_bd_pins ps7_0_axi_periph/M10_ACLK] [get_bd_pins ps7_0_axi_periph/M11_ACLK] [get_bd_pins ps7_0_axi_periph/M12_ACLK] [get_bd_pins ps7_0_axi_periph/M13_ACLK] [get_bd_pins ps7_0_axi_periph/M14_ACLK] [get_bd_pins ps7_0_axi_periph/M15_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins time_sync_block_0/s00_axi_aclk] [get_bd_pins user_cross_layer_swi_0/s00_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_125_out1 [get_bd_pins AudioProcessingChannel/CLK_125] [get_bd_pins ZedCodec/clk_125] [get_bd_pins eth_udp_axi_arp_stack_0/clk_125_in] [get_bd_pins org_audio2eth_interl_0/CLK_125] [get_bd_pins time_sync_block_0/CLK_125] [get_bd_pins user_cross_layer_swi_0/clk_125_out]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins ZedCodec/mclk_cw] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins eth_udp_axi_arp_stack_0/clk_100_in] [get_bd_pins user_cross_layer_swi_0/clk_100_in]
  connect_bd_net -net eth_to_audio_plc_com_0_irq_out [get_bd_pins AudioProcessingChannel/irq_out] [get_bd_pins xlconcat_0/In9]
  connect_bd_net -net eth_to_audio_plc_com_0_s_ch1_audio_payload_hdr_ready [get_bd_pins AudioProcessingChannel/s_ch1_audio_payload_hdr_ready] [get_bd_pins eth_udp_axi_arp_stack_0/m_ch1_audio_payload_hdr_ready]
  connect_bd_net -net eth_udp_axi_arp_stack_0_led [get_bd_ports led_0] [get_bd_pins eth_udp_axi_arp_stack_0/led]
  connect_bd_net -net eth_udp_axi_arp_stack_0_media_pkt_tx_en_out [get_bd_pins eth_udp_axi_arp_stack_0/media_pkt_tx_en_out] [get_bd_pins time_sync_block_0/media_pkt_tx_en_in]
  connect_bd_net -net eth_udp_axi_arp_stack_0_s_audio_payload_hdr_ready [get_bd_pins eth_udp_axi_arp_stack_0/s_audio_payload_hdr_ready] [get_bd_pins org_audio2eth_interl_0/m_audio_payload_hdr_ready]
  connect_bd_net -net eth_udp_axi_arp_stack_0_s_time_sync_payload_hdr_ready [get_bd_pins eth_udp_axi_arp_stack_0/s_time_sync_payload_hdr_ready] [get_bd_pins time_sync_block_0/m_time_sync_hdr_ready]
  connect_bd_net -net fm_audio_hdr_valid_1 [get_bd_pins AudioProcessingChannel/fm_audio_hdr_valid] [get_bd_pins org_audio2eth_interl_0/m_audio_payload_hdr_valid]
  connect_bd_net -net fm_audio_s_axis_aresetn_1 [get_bd_pins AudioProcessingChannel/fm_audio_s_axis_aresetn] [get_bd_pins eth_udp_axi_arp_stack_0/stream_resetn_out]
  connect_bd_net -net i2s_transmitter_0_sd [get_bd_ports adau1761_dac_sdata_0] [get_bd_pins ZedCodec/adau1761_dac_sdata_0]
  connect_bd_net -net mixer_0_audio_mixed_a_b_left_out [get_bd_pins ZedCodec/hphone_l] [get_bd_pins mixer_0/audio_mixed_a_b_left_out]
  connect_bd_net -net mixer_0_audio_mixed_a_b_right_out [get_bd_pins ZedCodec/hphone_r] [get_bd_pins mixer_0/audio_mixed_a_b_right_out]
  connect_bd_net -net org_audio2eth_interl_0_irq_out [get_bd_pins org_audio2eth_interl_0/irq_out] [get_bd_pins xlconcat_0/In8]
  connect_bd_net -net org_audio2eth_interl_0_sync_en_out [get_bd_ports sync_en_out_0] [get_bd_pins org_audio2eth_interl_0/sync_en_out]
  connect_bd_net -net org_audio2eth_interl_0_tsync_out [get_bd_ports tsync_out_0] [get_bd_pins org_audio2eth_interl_0/tsync_out]
  connect_bd_net -net org_audio2eth_interl_0_udp_payload_length [get_bd_pins eth_udp_axi_arp_stack_0/udp_payload_length] [get_bd_pins org_audio2eth_interl_0/udp_payload_length]
  connect_bd_net -net phy_int_n_0_1 [get_bd_ports phy_int_n_0] [get_bd_pins user_cross_layer_swi_0/phy_int_n]
  connect_bd_net -net phy_pme_n_0_1 [get_bd_ports phy_pme_n_0] [get_bd_pins user_cross_layer_swi_0/phy_pme_n]
  connect_bd_net -net phy_rx_clk_0_1 [get_bd_ports phy_rx_clk_0] [get_bd_pins user_cross_layer_swi_0/phy_rx_clk]
  connect_bd_net -net phy_rx_ctl_0_1 [get_bd_ports phy_rx_ctl_0] [get_bd_pins user_cross_layer_swi_0/phy_rx_ctl]
  connect_bd_net -net phy_rxd_0_1 [get_bd_ports phy_rxd_0] [get_bd_pins user_cross_layer_swi_0/phy_rxd]
  connect_bd_net -net pmod_controller_0_Rotary_event [get_bd_pins pmod_controller_0/Rotary_event] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net processing_system7_0_ENET1_GMII_TXD [get_bd_pins processing_system7_0/ENET1_GMII_TXD] [get_bd_pins user_cross_layer_swi_0/from_ps_gmii_txd]
  connect_bd_net -net processing_system7_0_ENET1_GMII_TX_EN [get_bd_pins processing_system7_0/ENET1_GMII_TX_EN] [get_bd_pins user_cross_layer_swi_0/from_ps_gmii_tx_en]
  connect_bd_net -net processing_system7_0_ENET1_GMII_TX_ER [get_bd_pins processing_system7_0/ENET1_GMII_TX_ER] [get_bd_pins user_cross_layer_swi_0/from_ps_gmii_tx_er]
  connect_bd_net -net processing_system7_0_ENET1_MDIO_MDC [get_bd_pins processing_system7_0/ENET1_MDIO_MDC] [get_bd_pins user_cross_layer_swi_0/mdc_o]
  connect_bd_net -net processing_system7_0_ENET1_MDIO_O [get_bd_pins processing_system7_0/ENET1_MDIO_O] [get_bd_pins user_cross_layer_swi_0/mdio_o]
  connect_bd_net -net processing_system7_0_ENET1_MDIO_T [get_bd_pins processing_system7_0/ENET1_MDIO_T] [get_bd_pins user_cross_layer_swi_0/mdio_t]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins user_cross_layer_swi_0/clk_90_in]
  connect_bd_net -net processing_system7_0_FCLK_CLK2 [get_bd_pins processing_system7_0/FCLK_CLK2] [get_bd_pins user_cross_layer_swi_0/clk_125_in]
  connect_bd_net -net processing_system7_0_FCLK_CLK3 [get_bd_pins processing_system7_0/FCLK_CLK3] [get_bd_pins user_cross_layer_swi_0/clk_200_in]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins clk_wiz_0/resetn] [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_100M_interconnect_aresetn [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins rst_ps7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins AudioProcessingChannel/s00_axi_aresetn] [get_bd_pins FILTER_IIR_0/s00_axi_aresetn] [get_bd_pins Volume_Pregain_0/s00_axi_aresetn] [get_bd_pins ZedCodec/s00_axi_aresetn] [get_bd_pins ZedboardOLED_0/s00_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_gpio_2/s_axi_aresetn] [get_bd_pins eth_udp_axi_arp_stack_0/reset_n] [get_bd_pins eth_udp_axi_arp_stack_0/s00_axi_aresetn] [get_bd_pins org_audio2eth_interl_0/s00_axi_aresetn] [get_bd_pins pmod_controller_0/s00_axi_aresetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/M05_ARESETN] [get_bd_pins ps7_0_axi_periph/M06_ARESETN] [get_bd_pins ps7_0_axi_periph/M07_ARESETN] [get_bd_pins ps7_0_axi_periph/M08_ARESETN] [get_bd_pins ps7_0_axi_periph/M09_ARESETN] [get_bd_pins ps7_0_axi_periph/M10_ARESETN] [get_bd_pins ps7_0_axi_periph/M11_ARESETN] [get_bd_pins ps7_0_axi_periph/M12_ARESETN] [get_bd_pins ps7_0_axi_periph/M13_ARESETN] [get_bd_pins ps7_0_axi_periph/M14_ARESETN] [get_bd_pins ps7_0_axi_periph/M15_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins time_sync_block_0/s00_axi_aresetn] [get_bd_pins user_cross_layer_swi_0/reset_n] [get_bd_pins user_cross_layer_swi_0/s00_axi_aresetn]
  connect_bd_net -net serial_data_in1_0_1 [get_bd_ports serial_data_in1_0] [get_bd_pins ZedCodec/serial_data_in1_0]
  connect_bd_net -net sw_0_1 [get_bd_ports sw_0] [get_bd_pins ZedCodec/sw]
  connect_bd_net -net sync_en_in_0_1 [get_bd_pins AudioProcessingChannel/sync_en_in_0] [get_bd_pins org_audio2eth_interl_0/tc_sync_en_in] [get_bd_pins time_sync_block_0/tc_sync_en_out]
  connect_bd_net -net time_sync_block_0_initiate_sync_request_out [get_bd_pins eth_udp_axi_arp_stack_0/initiate_sync_request_in] [get_bd_pins time_sync_block_0/initiate_sync_request_out]
  connect_bd_net -net time_sync_block_0_initiate_sync_response_out [get_bd_pins eth_udp_axi_arp_stack_0/initiate_sync_response_in] [get_bd_pins time_sync_block_0/initiate_sync_response_out]
  connect_bd_net -net time_sync_block_0_m_audio_payload_hdr_valid [get_bd_pins eth_udp_axi_arp_stack_0/s_time_sync_payload_hdr_valid] [get_bd_pins time_sync_block_0/m_time_sync_hdr_valid]
  connect_bd_net -net time_sync_block_0_s_time_sync_hdr_ready [get_bd_pins eth_udp_axi_arp_stack_0/m_time_sync_payload_hdr_ready] [get_bd_pins time_sync_block_0/s_time_sync_hdr_ready]
  connect_bd_net -net time_sync_block_0_status1_out [get_bd_pins eth_udp_axi_arp_stack_0/tsync_status1_in] [get_bd_pins time_sync_block_0/status1_out]
  connect_bd_net -net time_sync_block_0_status2_out [get_bd_pins eth_udp_axi_arp_stack_0/tsync_status2_in] [get_bd_pins time_sync_block_0/status2_out]
  connect_bd_net -net time_sync_block_0_sync_done_out [get_bd_pins eth_udp_axi_arp_stack_0/sync_done_in] [get_bd_pins time_sync_block_0/sync_done_out]
  connect_bd_net -net time_sync_block_0_sync_request_rx_out [get_bd_pins eth_udp_axi_arp_stack_0/sync_request_rx_in] [get_bd_pins time_sync_block_0/sync_request_rx_out]
  connect_bd_net -net time_sync_block_0_sync_time_code_out [get_bd_pins AudioProcessingChannel/sync_time_code_in] [get_bd_pins org_audio2eth_interl_0/tx_time_code_in] [get_bd_pins time_sync_block_0/sync_time_code_out]
  connect_bd_net -net time_sync_block_0_udp_payload_length [get_bd_pins eth_udp_axi_arp_stack_0/s_time_sync_payload_length] [get_bd_pins time_sync_block_0/udp_payload_length]
  connect_bd_net -net user_cross_layer_swi_0_from_ps_error_bad_fcs [get_bd_pins eth_udp_axi_arp_stack_0/from_sw_rx_error_bad_fcs] [get_bd_pins user_cross_layer_swi_0/from_ps_error_bad_fcs]
  connect_bd_net -net user_cross_layer_swi_0_from_ps_error_bad_frame [get_bd_pins eth_udp_axi_arp_stack_0/from_sw_rx_error_bad_frame] [get_bd_pins user_cross_layer_swi_0/from_ps_error_bad_frame]
  connect_bd_net -net user_cross_layer_swi_0_from_ps_fifo_status_bad_frame [get_bd_pins eth_udp_axi_arp_stack_0/from_sw_tx_fifo_bad_frame] [get_bd_pins user_cross_layer_swi_0/from_ps_fifo_status_bad_frame]
  connect_bd_net -net user_cross_layer_swi_0_from_ps_fifo_status_good_frame [get_bd_pins eth_udp_axi_arp_stack_0/from_sw_tx_fifo_good_frame] [get_bd_pins user_cross_layer_swi_0/from_ps_fifo_status_good_frame]
  connect_bd_net -net user_cross_layer_swi_0_from_ps_fifo_status_overflow [get_bd_pins eth_udp_axi_arp_stack_0/from_sw_tx_fifo_overflow] [get_bd_pins user_cross_layer_swi_0/from_ps_fifo_status_overflow]
  connect_bd_net -net user_cross_layer_swi_0_mac_status_bad_frame [get_bd_pins eth_udp_axi_arp_stack_0/from_sw_rx_fifo_bad_frame] [get_bd_pins user_cross_layer_swi_0/mac_status_bad_frame]
  connect_bd_net -net user_cross_layer_swi_0_mac_status_good_frame [get_bd_pins eth_udp_axi_arp_stack_0/from_sw_rx_fifo_good_frame] [get_bd_pins user_cross_layer_swi_0/mac_status_good_frame]
  connect_bd_net -net user_cross_layer_swi_0_mac_status_overflow [get_bd_pins eth_udp_axi_arp_stack_0/from_sw_rx_fifo_overflow] [get_bd_pins user_cross_layer_swi_0/mac_status_overflow]
  connect_bd_net -net user_cross_layer_swi_0_mdio_i [get_bd_pins processing_system7_0/ENET1_MDIO_I] [get_bd_pins user_cross_layer_swi_0/mdio_i]
  connect_bd_net -net user_cross_layer_swi_0_phy_mdc [get_bd_ports phy_mdc_0] [get_bd_pins user_cross_layer_swi_0/phy_mdc]
  connect_bd_net -net user_cross_layer_swi_0_phy_reset_n [get_bd_ports phy_reset_n_0] [get_bd_pins user_cross_layer_swi_0/phy_reset_n]
  connect_bd_net -net user_cross_layer_swi_0_phy_tx_clk [get_bd_ports phy_tx_clk_0] [get_bd_pins user_cross_layer_swi_0/phy_tx_clk]
  connect_bd_net -net user_cross_layer_swi_0_phy_tx_ctl [get_bd_ports phy_tx_ctl_0] [get_bd_pins user_cross_layer_swi_0/phy_tx_ctl]
  connect_bd_net -net user_cross_layer_swi_0_phy_txd [get_bd_ports phy_txd_0] [get_bd_pins user_cross_layer_swi_0/phy_txd]
  connect_bd_net -net user_cross_layer_swi_0_ps_gmii_rx_clk [get_bd_pins processing_system7_0/ENET1_GMII_RX_CLK] [get_bd_pins user_cross_layer_swi_0/ps_gmii_rx_clk]
  connect_bd_net -net user_cross_layer_swi_0_rst_out [get_bd_pins AudioProcessingChannel/rst_in] [get_bd_pins ZedCodec/rst] [get_bd_pins eth_udp_axi_arp_stack_0/rst_in] [get_bd_pins user_cross_layer_swi_0/rst_out]
  connect_bd_net -net user_cross_layer_swi_0_sel_status [get_bd_pins eth_udp_axi_arp_stack_0/sw_sel_status] [get_bd_pins user_cross_layer_swi_0/sel_status]
  connect_bd_net -net user_cross_layer_swi_0_to_ps_gmii_col [get_bd_pins processing_system7_0/ENET1_GMII_COL] [get_bd_pins user_cross_layer_swi_0/to_ps_gmii_col]
  connect_bd_net -net user_cross_layer_swi_0_to_ps_gmii_crs [get_bd_pins processing_system7_0/ENET1_GMII_CRS] [get_bd_pins user_cross_layer_swi_0/to_ps_gmii_crs]
  connect_bd_net -net user_cross_layer_swi_0_to_ps_gmii_rx_dv [get_bd_pins processing_system7_0/ENET1_GMII_RX_DV] [get_bd_pins user_cross_layer_swi_0/to_ps_gmii_rx_dv]
  connect_bd_net -net user_cross_layer_swi_0_to_ps_gmii_rx_er [get_bd_pins processing_system7_0/ENET1_GMII_RX_ER] [get_bd_pins user_cross_layer_swi_0/to_ps_gmii_rx_er]
  connect_bd_net -net user_org_plc_seq_ip_0_fifo_empty_out [get_bd_pins AudioProcessingChannel/fifo_empty_out] [get_bd_pins eth_udp_axi_arp_stack_0/fifo_empty_in]
  connect_bd_net -net user_org_plc_seq_ip_0_fifo_full_out [get_bd_pins AudioProcessingChannel/fifo_full_out] [get_bd_pins eth_udp_axi_arp_stack_0/fifo_full_in]
  connect_bd_net -net user_org_plc_seq_ip_0_status1_out [get_bd_pins AudioProcessingChannel/status1_out] [get_bd_pins eth_udp_axi_arp_stack_0/seq_status1_in]
  connect_bd_net -net user_org_plc_seq_ip_0_status2_out [get_bd_pins AudioProcessingChannel/status2_out] [get_bd_pins eth_udp_axi_arp_stack_0/seq_status2_in]
  connect_bd_net -net user_org_plc_seq_ip_0_to_udp_hdr_valid [get_bd_pins AudioProcessingChannel/to_udp_hdr_valid] [get_bd_pins eth_udp_axi_arp_stack_0/s_audio_payload_hdr_valid]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs FILTER_IIR_0/S00_AXI/S00_AXI_reg] SEG_FILTER_IIR_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AudioProcessingChannel/FILTER_IIR_1/S00_AXI/S00_AXI_reg] SEG_FILTER_IIR_1_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs Volume_Pregain_0/S00_AXI/S00_AXI_reg] SEG_Volume_Pregain_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AudioProcessingChannel/Volume_Pregain_1/S00_AXI/S00_AXI_reg] SEG_Volume_Pregain_1_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ZedboardOLED_0/S00_AXI/S00_AXI_reg] SEG_ZedboardOLED_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ZedCodec/adau1761_controller_0/S00_AXI/S00_AXI_reg] SEG_adau1761_controller_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41210000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41220000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_2/S_AXI/Reg] SEG_axi_gpio_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C70000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AudioProcessingChannel/eth_to_audio_plc_com_0/S00_AXI/S00_AXI_reg] SEG_eth_to_audio_plc_com_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs eth_udp_axi_arp_stack_0/S00_AXI/S00_AXI_reg] SEG_eth_udp_axi_arp_stack_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs org_audio2eth_interl_0/S00_AXI/S00_AXI_reg] SEG_org_audio2eth_interl_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C90000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs pmod_controller_0/S00_AXI/S00_AXI_reg] SEG_pmod_controller_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43CB0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs time_sync_block_0/S00_AXI/S00_AXI_reg] SEG_time_sync_block_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43CC0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs user_cross_layer_swi_0/S00_AXI/S00_AXI_reg] SEG_user_cross_layer_swi_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43CA0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AudioProcessingChannel/user_org_plc_seq_ip_0/S00_AXI/S00_AXI_reg] SEG_user_org_plc_seq_ip_0_S00_AXI_reg


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


