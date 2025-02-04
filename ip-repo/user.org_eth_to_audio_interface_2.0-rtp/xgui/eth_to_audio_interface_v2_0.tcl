# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"


}

proc update_PARAM_VALUE.AXIS_UDP_DATA_WIDTH { PARAM_VALUE.AXIS_UDP_DATA_WIDTH } {
	# Procedure called to update AXIS_UDP_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIS_UDP_DATA_WIDTH { PARAM_VALUE.AXIS_UDP_DATA_WIDTH } {
	# Procedure called to validate AXIS_UDP_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.BUF_COUNT_W { PARAM_VALUE.BUF_COUNT_W } {
	# Procedure called to update BUF_COUNT_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUF_COUNT_W { PARAM_VALUE.BUF_COUNT_W } {
	# Procedure called to validate BUF_COUNT_W
	return true
}

proc update_PARAM_VALUE.PACKET_COUNT_W { PARAM_VALUE.PACKET_COUNT_W } {
	# Procedure called to update PACKET_COUNT_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PACKET_COUNT_W { PARAM_VALUE.PACKET_COUNT_W } {
	# Procedure called to validate PACKET_COUNT_W
	return true
}

proc update_PARAM_VALUE.SEQ_WIDTH { PARAM_VALUE.SEQ_WIDTH } {
	# Procedure called to update SEQ_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SEQ_WIDTH { PARAM_VALUE.SEQ_WIDTH } {
	# Procedure called to validate SEQ_WIDTH
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

proc update_MODELPARAM_VALUE.AXIS_UDP_DATA_WIDTH { MODELPARAM_VALUE.AXIS_UDP_DATA_WIDTH PARAM_VALUE.AXIS_UDP_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIS_UDP_DATA_WIDTH}] ${MODELPARAM_VALUE.AXIS_UDP_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.PACKET_COUNT_W { MODELPARAM_VALUE.PACKET_COUNT_W PARAM_VALUE.PACKET_COUNT_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PACKET_COUNT_W}] ${MODELPARAM_VALUE.PACKET_COUNT_W}
}

proc update_MODELPARAM_VALUE.BUF_COUNT_W { MODELPARAM_VALUE.BUF_COUNT_W PARAM_VALUE.BUF_COUNT_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUF_COUNT_W}] ${MODELPARAM_VALUE.BUF_COUNT_W}
}

proc update_MODELPARAM_VALUE.SEQ_WIDTH { MODELPARAM_VALUE.SEQ_WIDTH PARAM_VALUE.SEQ_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SEQ_WIDTH}] ${MODELPARAM_VALUE.SEQ_WIDTH}
}

