# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_fm_audio_s_axis_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_fm_udp_s_axis_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_to_audio_m_axis_START_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_to_audio_m_axis_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_to_udp_m_axis_START_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_to_udp_m_axis_TDATA_WIDTH" -parent ${Page_0}

  ipgui::add_param $IPINST -name "S_COUNT"
  ipgui::add_param $IPINST -name "PACKET_SKIP_DEFAULT"
  set SHIFTS_PER_MILLISECOND [ipgui::add_param $IPINST -name "SHIFTS_PER_MILLISECOND"]
  set_property tooltip {Clock shifts to make a an order unit} ${SHIFTS_PER_MILLISECOND}

}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
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

proc update_PARAM_VALUE.PACKET_SKIP_DEFAULT { PARAM_VALUE.PACKET_SKIP_DEFAULT } {
	# Procedure called to update PACKET_SKIP_DEFAULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PACKET_SKIP_DEFAULT { PARAM_VALUE.PACKET_SKIP_DEFAULT } {
	# Procedure called to validate PACKET_SKIP_DEFAULT
	return true
}

proc update_PARAM_VALUE.SHIFTS_PER_MILLISECOND { PARAM_VALUE.SHIFTS_PER_MILLISECOND } {
	# Procedure called to update SHIFTS_PER_MILLISECOND when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SHIFTS_PER_MILLISECOND { PARAM_VALUE.SHIFTS_PER_MILLISECOND } {
	# Procedure called to validate SHIFTS_PER_MILLISECOND
	return true
}

proc update_PARAM_VALUE.S_COUNT { PARAM_VALUE.S_COUNT } {
	# Procedure called to update S_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_COUNT { PARAM_VALUE.S_COUNT } {
	# Procedure called to validate S_COUNT
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

