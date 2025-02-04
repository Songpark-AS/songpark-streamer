# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  set FIFO_ADDR_WIDTH [ipgui::add_param $IPINST -name "FIFO_ADDR_WIDTH"]
  set_property tooltip {Must be the same as in Eth 2 Audio block} ${FIFO_ADDR_WIDTH}
  set S_COUNT [ipgui::add_param $IPINST -name "S_COUNT"]
  set_property tooltip {Number of seq slots} ${S_COUNT}
  ipgui::add_param $IPINST -name "SEQ_BANK_FIFO_ADDR_WIDTH"
  ipgui::add_param $IPINST -name "CORE_VERSION"

}

proc update_PARAM_VALUE.CORE_VERSION { PARAM_VALUE.CORE_VERSION } {
	# Procedure called to update CORE_VERSION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CORE_VERSION { PARAM_VALUE.CORE_VERSION } {
	# Procedure called to validate CORE_VERSION
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_fm_audio_s_axis_TDATA_WIDTH { PARAM_VALUE.C_fm_audio_s_axis_TDATA_WIDTH } {
	# Procedure called to update C_fm_audio_s_axis_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_fm_audio_s_axis_TDATA_WIDTH { PARAM_VALUE.C_fm_audio_s_axis_TDATA_WIDTH } {
	# Procedure called to validate C_fm_audio_s_axis_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_fm_udp_s_axis_TDATA_WIDTH { PARAM_VALUE.C_fm_udp_s_axis_TDATA_WIDTH } {
	# Procedure called to update C_fm_udp_s_axis_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_fm_udp_s_axis_TDATA_WIDTH { PARAM_VALUE.C_fm_udp_s_axis_TDATA_WIDTH } {
	# Procedure called to validate C_fm_udp_s_axis_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_to_audio_m_axis_START_COUNT { PARAM_VALUE.C_to_audio_m_axis_START_COUNT } {
	# Procedure called to update C_to_audio_m_axis_START_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_to_audio_m_axis_START_COUNT { PARAM_VALUE.C_to_audio_m_axis_START_COUNT } {
	# Procedure called to validate C_to_audio_m_axis_START_COUNT
	return true
}

proc update_PARAM_VALUE.C_to_audio_m_axis_TDATA_WIDTH { PARAM_VALUE.C_to_audio_m_axis_TDATA_WIDTH } {
	# Procedure called to update C_to_audio_m_axis_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_to_audio_m_axis_TDATA_WIDTH { PARAM_VALUE.C_to_audio_m_axis_TDATA_WIDTH } {
	# Procedure called to validate C_to_audio_m_axis_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_to_udp_m_axis_START_COUNT { PARAM_VALUE.C_to_udp_m_axis_START_COUNT } {
	# Procedure called to update C_to_udp_m_axis_START_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_to_udp_m_axis_START_COUNT { PARAM_VALUE.C_to_udp_m_axis_START_COUNT } {
	# Procedure called to validate C_to_udp_m_axis_START_COUNT
	return true
}

proc update_PARAM_VALUE.C_to_udp_m_axis_TDATA_WIDTH { PARAM_VALUE.C_to_udp_m_axis_TDATA_WIDTH } {
	# Procedure called to update C_to_udp_m_axis_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_to_udp_m_axis_TDATA_WIDTH { PARAM_VALUE.C_to_udp_m_axis_TDATA_WIDTH } {
	# Procedure called to validate C_to_udp_m_axis_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DELAY_COUNT_WIDTH { PARAM_VALUE.DELAY_COUNT_WIDTH } {
	# Procedure called to update DELAY_COUNT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_COUNT_WIDTH { PARAM_VALUE.DELAY_COUNT_WIDTH } {
	# Procedure called to validate DELAY_COUNT_WIDTH
	return true
}

proc update_PARAM_VALUE.FIFO_ADDR_WIDTH { PARAM_VALUE.FIFO_ADDR_WIDTH } {
	# Procedure called to update FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_ADDR_WIDTH { PARAM_VALUE.FIFO_ADDR_WIDTH } {
	# Procedure called to validate FIFO_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.PACKET_LEN_WIDTH { PARAM_VALUE.PACKET_LEN_WIDTH } {
	# Procedure called to update PACKET_LEN_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PACKET_LEN_WIDTH { PARAM_VALUE.PACKET_LEN_WIDTH } {
	# Procedure called to validate PACKET_LEN_WIDTH
	return true
}

proc update_PARAM_VALUE.PACKET_SKIP_DEFAULT { PARAM_VALUE.PACKET_SKIP_DEFAULT } {
	# Procedure called to update PACKET_SKIP_DEFAULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PACKET_SKIP_DEFAULT { PARAM_VALUE.PACKET_SKIP_DEFAULT } {
	# Procedure called to validate PACKET_SKIP_DEFAULT
	return true
}

proc update_PARAM_VALUE.RTP_HDR_SEQ_WIDTH { PARAM_VALUE.RTP_HDR_SEQ_WIDTH } {
	# Procedure called to update RTP_HDR_SEQ_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RTP_HDR_SEQ_WIDTH { PARAM_VALUE.RTP_HDR_SEQ_WIDTH } {
	# Procedure called to validate RTP_HDR_SEQ_WIDTH
	return true
}

proc update_PARAM_VALUE.SEQ_BANK_FIFO_ADDR_WIDTH { PARAM_VALUE.SEQ_BANK_FIFO_ADDR_WIDTH } {
	# Procedure called to update SEQ_BANK_FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SEQ_BANK_FIFO_ADDR_WIDTH { PARAM_VALUE.SEQ_BANK_FIFO_ADDR_WIDTH } {
	# Procedure called to validate SEQ_BANK_FIFO_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.SHIFTS_PER_MILLISECOND { PARAM_VALUE.SHIFTS_PER_MILLISECOND } {
	# Procedure called to update SHIFTS_PER_MILLISECOND when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SHIFTS_PER_MILLISECOND { PARAM_VALUE.SHIFTS_PER_MILLISECOND } {
	# Procedure called to validate SHIFTS_PER_MILLISECOND
	return true
}

proc update_PARAM_VALUE.SYNC_COUNT_WIDTH { PARAM_VALUE.SYNC_COUNT_WIDTH } {
	# Procedure called to update SYNC_COUNT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_COUNT_WIDTH { PARAM_VALUE.SYNC_COUNT_WIDTH } {
	# Procedure called to validate SYNC_COUNT_WIDTH
	return true
}

proc update_PARAM_VALUE.S_COUNT { PARAM_VALUE.S_COUNT } {
	# Procedure called to update S_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_COUNT { PARAM_VALUE.S_COUNT } {
	# Procedure called to validate S_COUNT
	return true
}

proc update_PARAM_VALUE.TC_BIT_LENGTH { PARAM_VALUE.TC_BIT_LENGTH } {
	# Procedure called to update TC_BIT_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TC_BIT_LENGTH { PARAM_VALUE.TC_BIT_LENGTH } {
	# Procedure called to validate TC_BIT_LENGTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.S_COUNT { MODELPARAM_VALUE.S_COUNT PARAM_VALUE.S_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_COUNT}] ${MODELPARAM_VALUE.S_COUNT}
}

proc update_MODELPARAM_VALUE.PACKET_SKIP_DEFAULT { MODELPARAM_VALUE.PACKET_SKIP_DEFAULT PARAM_VALUE.PACKET_SKIP_DEFAULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PACKET_SKIP_DEFAULT}] ${MODELPARAM_VALUE.PACKET_SKIP_DEFAULT}
}

proc update_MODELPARAM_VALUE.SHIFTS_PER_MILLISECOND { MODELPARAM_VALUE.SHIFTS_PER_MILLISECOND PARAM_VALUE.SHIFTS_PER_MILLISECOND } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SHIFTS_PER_MILLISECOND}] ${MODELPARAM_VALUE.SHIFTS_PER_MILLISECOND}
}

proc update_MODELPARAM_VALUE.DELAY_COUNT_WIDTH { MODELPARAM_VALUE.DELAY_COUNT_WIDTH PARAM_VALUE.DELAY_COUNT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_COUNT_WIDTH}] ${MODELPARAM_VALUE.DELAY_COUNT_WIDTH}
}

proc update_MODELPARAM_VALUE.C_fm_udp_s_axis_TDATA_WIDTH { MODELPARAM_VALUE.C_fm_udp_s_axis_TDATA_WIDTH PARAM_VALUE.C_fm_udp_s_axis_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_fm_udp_s_axis_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_fm_udp_s_axis_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_fm_audio_s_axis_TDATA_WIDTH { MODELPARAM_VALUE.C_fm_audio_s_axis_TDATA_WIDTH PARAM_VALUE.C_fm_audio_s_axis_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_fm_audio_s_axis_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_fm_audio_s_axis_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_to_udp_m_axis_TDATA_WIDTH { MODELPARAM_VALUE.C_to_udp_m_axis_TDATA_WIDTH PARAM_VALUE.C_to_udp_m_axis_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_to_udp_m_axis_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_to_udp_m_axis_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_to_udp_m_axis_START_COUNT { MODELPARAM_VALUE.C_to_udp_m_axis_START_COUNT PARAM_VALUE.C_to_udp_m_axis_START_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_to_udp_m_axis_START_COUNT}] ${MODELPARAM_VALUE.C_to_udp_m_axis_START_COUNT}
}

proc update_MODELPARAM_VALUE.C_to_audio_m_axis_TDATA_WIDTH { MODELPARAM_VALUE.C_to_audio_m_axis_TDATA_WIDTH PARAM_VALUE.C_to_audio_m_axis_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_to_audio_m_axis_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_to_audio_m_axis_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_to_audio_m_axis_START_COUNT { MODELPARAM_VALUE.C_to_audio_m_axis_START_COUNT PARAM_VALUE.C_to_audio_m_axis_START_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_to_audio_m_axis_START_COUNT}] ${MODELPARAM_VALUE.C_to_audio_m_axis_START_COUNT}
}

proc update_MODELPARAM_VALUE.FIFO_ADDR_WIDTH { MODELPARAM_VALUE.FIFO_ADDR_WIDTH PARAM_VALUE.FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.FIFO_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.PACKET_LEN_WIDTH { MODELPARAM_VALUE.PACKET_LEN_WIDTH PARAM_VALUE.PACKET_LEN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PACKET_LEN_WIDTH}] ${MODELPARAM_VALUE.PACKET_LEN_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.SEQ_BANK_FIFO_ADDR_WIDTH { MODELPARAM_VALUE.SEQ_BANK_FIFO_ADDR_WIDTH PARAM_VALUE.SEQ_BANK_FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SEQ_BANK_FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.SEQ_BANK_FIFO_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.SYNC_COUNT_WIDTH { MODELPARAM_VALUE.SYNC_COUNT_WIDTH PARAM_VALUE.SYNC_COUNT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_COUNT_WIDTH}] ${MODELPARAM_VALUE.SYNC_COUNT_WIDTH}
}

proc update_MODELPARAM_VALUE.CORE_VERSION { MODELPARAM_VALUE.CORE_VERSION PARAM_VALUE.CORE_VERSION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CORE_VERSION}] ${MODELPARAM_VALUE.CORE_VERSION}
}

proc update_MODELPARAM_VALUE.RTP_HDR_SEQ_WIDTH { MODELPARAM_VALUE.RTP_HDR_SEQ_WIDTH PARAM_VALUE.RTP_HDR_SEQ_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RTP_HDR_SEQ_WIDTH}] ${MODELPARAM_VALUE.RTP_HDR_SEQ_WIDTH}
}

proc update_MODELPARAM_VALUE.TC_BIT_LENGTH { MODELPARAM_VALUE.TC_BIT_LENGTH PARAM_VALUE.TC_BIT_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TC_BIT_LENGTH}] ${MODELPARAM_VALUE.TC_BIT_LENGTH}
}

