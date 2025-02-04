# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"


}

proc update_PARAM_VALUE.ARP_CACHE_ADDR_WIDTH { PARAM_VALUE.ARP_CACHE_ADDR_WIDTH } {
	# Procedure called to update ARP_CACHE_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ARP_CACHE_ADDR_WIDTH { PARAM_VALUE.ARP_CACHE_ADDR_WIDTH } {
	# Procedure called to validate ARP_CACHE_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.ARP_REQUEST_RETRY_COUNT { PARAM_VALUE.ARP_REQUEST_RETRY_COUNT } {
	# Procedure called to update ARP_REQUEST_RETRY_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ARP_REQUEST_RETRY_COUNT { PARAM_VALUE.ARP_REQUEST_RETRY_COUNT } {
	# Procedure called to validate ARP_REQUEST_RETRY_COUNT
	return true
}

proc update_PARAM_VALUE.ARP_REQUEST_RETRY_INTERVAL { PARAM_VALUE.ARP_REQUEST_RETRY_INTERVAL } {
	# Procedure called to update ARP_REQUEST_RETRY_INTERVAL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ARP_REQUEST_RETRY_INTERVAL { PARAM_VALUE.ARP_REQUEST_RETRY_INTERVAL } {
	# Procedure called to validate ARP_REQUEST_RETRY_INTERVAL
	return true
}

proc update_PARAM_VALUE.ARP_REQUEST_TIMEOUT { PARAM_VALUE.ARP_REQUEST_TIMEOUT } {
	# Procedure called to update ARP_REQUEST_TIMEOUT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ARP_REQUEST_TIMEOUT { PARAM_VALUE.ARP_REQUEST_TIMEOUT } {
	# Procedure called to validate ARP_REQUEST_TIMEOUT
	return true
}

proc update_PARAM_VALUE.UDP_CHECKSUM_GEN_ENABLE { PARAM_VALUE.UDP_CHECKSUM_GEN_ENABLE } {
	# Procedure called to update UDP_CHECKSUM_GEN_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UDP_CHECKSUM_GEN_ENABLE { PARAM_VALUE.UDP_CHECKSUM_GEN_ENABLE } {
	# Procedure called to validate UDP_CHECKSUM_GEN_ENABLE
	return true
}

proc update_PARAM_VALUE.UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH { PARAM_VALUE.UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH } {
	# Procedure called to update UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH { PARAM_VALUE.UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH } {
	# Procedure called to validate UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH { PARAM_VALUE.UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH } {
	# Procedure called to update UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH { PARAM_VALUE.UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH } {
	# Procedure called to validate UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.ARP_CACHE_ADDR_WIDTH { MODELPARAM_VALUE.ARP_CACHE_ADDR_WIDTH PARAM_VALUE.ARP_CACHE_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ARP_CACHE_ADDR_WIDTH}] ${MODELPARAM_VALUE.ARP_CACHE_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.ARP_REQUEST_RETRY_COUNT { MODELPARAM_VALUE.ARP_REQUEST_RETRY_COUNT PARAM_VALUE.ARP_REQUEST_RETRY_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ARP_REQUEST_RETRY_COUNT}] ${MODELPARAM_VALUE.ARP_REQUEST_RETRY_COUNT}
}

proc update_MODELPARAM_VALUE.ARP_REQUEST_RETRY_INTERVAL { MODELPARAM_VALUE.ARP_REQUEST_RETRY_INTERVAL PARAM_VALUE.ARP_REQUEST_RETRY_INTERVAL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ARP_REQUEST_RETRY_INTERVAL}] ${MODELPARAM_VALUE.ARP_REQUEST_RETRY_INTERVAL}
}

proc update_MODELPARAM_VALUE.ARP_REQUEST_TIMEOUT { MODELPARAM_VALUE.ARP_REQUEST_TIMEOUT PARAM_VALUE.ARP_REQUEST_TIMEOUT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ARP_REQUEST_TIMEOUT}] ${MODELPARAM_VALUE.ARP_REQUEST_TIMEOUT}
}

proc update_MODELPARAM_VALUE.UDP_CHECKSUM_GEN_ENABLE { MODELPARAM_VALUE.UDP_CHECKSUM_GEN_ENABLE PARAM_VALUE.UDP_CHECKSUM_GEN_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UDP_CHECKSUM_GEN_ENABLE}] ${MODELPARAM_VALUE.UDP_CHECKSUM_GEN_ENABLE}
}

proc update_MODELPARAM_VALUE.UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH { MODELPARAM_VALUE.UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH PARAM_VALUE.UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH { MODELPARAM_VALUE.UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH PARAM_VALUE.UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH}
}

