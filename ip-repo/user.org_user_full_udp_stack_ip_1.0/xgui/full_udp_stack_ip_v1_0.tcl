# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "SESSION_USERS_COUNT"
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH"

}

proc update_PARAM_VALUE.AUDIO_FIFO_ADDR_WIDTH { PARAM_VALUE.AUDIO_FIFO_ADDR_WIDTH } {
	# Procedure called to update AUDIO_FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AUDIO_FIFO_ADDR_WIDTH { PARAM_VALUE.AUDIO_FIFO_ADDR_WIDTH } {
	# Procedure called to validate AUDIO_FIFO_ADDR_WIDTH
	return true
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

proc update_PARAM_VALUE.SESSION_USERS_COUNT { PARAM_VALUE.SESSION_USERS_COUNT } {
	# Procedure called to update SESSION_USERS_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SESSION_USERS_COUNT { PARAM_VALUE.SESSION_USERS_COUNT } {
	# Procedure called to validate SESSION_USERS_COUNT
	return true
}

proc update_PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH { PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH } {
	# Procedure called to update SYNC_FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH { PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH } {
	# Procedure called to validate SYNC_FIFO_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.UDP_DATA_WIDTH { PARAM_VALUE.UDP_DATA_WIDTH } {
	# Procedure called to update UDP_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UDP_DATA_WIDTH { PARAM_VALUE.UDP_DATA_WIDTH } {
	# Procedure called to validate UDP_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.UDP_IP_WIDTH { PARAM_VALUE.UDP_IP_WIDTH } {
	# Procedure called to update UDP_IP_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UDP_IP_WIDTH { PARAM_VALUE.UDP_IP_WIDTH } {
	# Procedure called to validate UDP_IP_WIDTH
	return true
}

proc update_PARAM_VALUE.UDP_LENGTH_WIDTH { PARAM_VALUE.UDP_LENGTH_WIDTH } {
	# Procedure called to update UDP_LENGTH_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UDP_LENGTH_WIDTH { PARAM_VALUE.UDP_LENGTH_WIDTH } {
	# Procedure called to validate UDP_LENGTH_WIDTH
	return true
}

proc update_PARAM_VALUE.UDP_MAC_WIDTH { PARAM_VALUE.UDP_MAC_WIDTH } {
	# Procedure called to update UDP_MAC_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UDP_MAC_WIDTH { PARAM_VALUE.UDP_MAC_WIDTH } {
	# Procedure called to validate UDP_MAC_WIDTH
	return true
}

proc update_PARAM_VALUE.UDP_PORT_WIDTH { PARAM_VALUE.UDP_PORT_WIDTH } {
	# Procedure called to update UDP_PORT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UDP_PORT_WIDTH { PARAM_VALUE.UDP_PORT_WIDTH } {
	# Procedure called to validate UDP_PORT_WIDTH
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

proc update_MODELPARAM_VALUE.UDP_DATA_WIDTH { MODELPARAM_VALUE.UDP_DATA_WIDTH PARAM_VALUE.UDP_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UDP_DATA_WIDTH}] ${MODELPARAM_VALUE.UDP_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.UDP_IP_WIDTH { MODELPARAM_VALUE.UDP_IP_WIDTH PARAM_VALUE.UDP_IP_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UDP_IP_WIDTH}] ${MODELPARAM_VALUE.UDP_IP_WIDTH}
}

proc update_MODELPARAM_VALUE.UDP_MAC_WIDTH { MODELPARAM_VALUE.UDP_MAC_WIDTH PARAM_VALUE.UDP_MAC_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UDP_MAC_WIDTH}] ${MODELPARAM_VALUE.UDP_MAC_WIDTH}
}

proc update_MODELPARAM_VALUE.UDP_LENGTH_WIDTH { MODELPARAM_VALUE.UDP_LENGTH_WIDTH PARAM_VALUE.UDP_LENGTH_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UDP_LENGTH_WIDTH}] ${MODELPARAM_VALUE.UDP_LENGTH_WIDTH}
}

proc update_MODELPARAM_VALUE.UDP_PORT_WIDTH { MODELPARAM_VALUE.UDP_PORT_WIDTH PARAM_VALUE.UDP_PORT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UDP_PORT_WIDTH}] ${MODELPARAM_VALUE.UDP_PORT_WIDTH}
}

proc update_MODELPARAM_VALUE.SESSION_USERS_COUNT { MODELPARAM_VALUE.SESSION_USERS_COUNT PARAM_VALUE.SESSION_USERS_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SESSION_USERS_COUNT}] ${MODELPARAM_VALUE.SESSION_USERS_COUNT}
}

proc update_MODELPARAM_VALUE.SYNC_FIFO_ADDR_WIDTH { MODELPARAM_VALUE.SYNC_FIFO_ADDR_WIDTH PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.SYNC_FIFO_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.AUDIO_FIFO_ADDR_WIDTH { MODELPARAM_VALUE.AUDIO_FIFO_ADDR_WIDTH PARAM_VALUE.AUDIO_FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AUDIO_FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.AUDIO_FIFO_ADDR_WIDTH}
}

