# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "RX_HDR_FIFO_BANK_COUNT"
  ipgui::add_param $IPINST -name "MIN_FRAME_LENGTH"
  ipgui::add_param $IPINST -name "RX_HDR_FIFO_DEPTH"
  ipgui::add_param $IPINST -name "FROM_PS_FIFO_ADDR_WIDTH"
  ipgui::add_param $IPINST -name "FROM_CS_FIFO_ADDR_WIDTH"

}

proc update_PARAM_VALUE.C_S_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.FROM_CS_FIFO_ADDR_WIDTH { PARAM_VALUE.FROM_CS_FIFO_ADDR_WIDTH } {
	# Procedure called to update FROM_CS_FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FROM_CS_FIFO_ADDR_WIDTH { PARAM_VALUE.FROM_CS_FIFO_ADDR_WIDTH } {
	# Procedure called to validate FROM_CS_FIFO_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.FROM_PS_FIFO_ADDR_WIDTH { PARAM_VALUE.FROM_PS_FIFO_ADDR_WIDTH } {
	# Procedure called to update FROM_PS_FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FROM_PS_FIFO_ADDR_WIDTH { PARAM_VALUE.FROM_PS_FIFO_ADDR_WIDTH } {
	# Procedure called to validate FROM_PS_FIFO_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.IFG_DELAY { PARAM_VALUE.IFG_DELAY } {
	# Procedure called to update IFG_DELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IFG_DELAY { PARAM_VALUE.IFG_DELAY } {
	# Procedure called to validate IFG_DELAY
	return true
}

proc update_PARAM_VALUE.MIN_FRAME_LENGTH { PARAM_VALUE.MIN_FRAME_LENGTH } {
	# Procedure called to update MIN_FRAME_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MIN_FRAME_LENGTH { PARAM_VALUE.MIN_FRAME_LENGTH } {
	# Procedure called to validate MIN_FRAME_LENGTH
	return true
}

proc update_PARAM_VALUE.RX_FIFO_ADDR_WIDTH { PARAM_VALUE.RX_FIFO_ADDR_WIDTH } {
	# Procedure called to update RX_FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_FIFO_ADDR_WIDTH { PARAM_VALUE.RX_FIFO_ADDR_WIDTH } {
	# Procedure called to validate RX_FIFO_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.RX_HDR_FIFO_BANK_COUNT { PARAM_VALUE.RX_HDR_FIFO_BANK_COUNT } {
	# Procedure called to update RX_HDR_FIFO_BANK_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_HDR_FIFO_BANK_COUNT { PARAM_VALUE.RX_HDR_FIFO_BANK_COUNT } {
	# Procedure called to validate RX_HDR_FIFO_BANK_COUNT
	return true
}

proc update_PARAM_VALUE.RX_HDR_FIFO_DEPTH { PARAM_VALUE.RX_HDR_FIFO_DEPTH } {
	# Procedure called to update RX_HDR_FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_HDR_FIFO_DEPTH { PARAM_VALUE.RX_HDR_FIFO_DEPTH } {
	# Procedure called to validate RX_HDR_FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH { PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH } {
	# Procedure called to update SYNC_FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH { PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH } {
	# Procedure called to validate SYNC_FIFO_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.TARGET { PARAM_VALUE.TARGET } {
	# Procedure called to update TARGET when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TARGET { PARAM_VALUE.TARGET } {
	# Procedure called to validate TARGET
	return true
}

proc update_PARAM_VALUE.TX_FIFO_ADDR_WIDTH { PARAM_VALUE.TX_FIFO_ADDR_WIDTH } {
	# Procedure called to update TX_FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TX_FIFO_ADDR_WIDTH { PARAM_VALUE.TX_FIFO_ADDR_WIDTH } {
	# Procedure called to validate TX_FIFO_ADDR_WIDTH
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

proc update_MODELPARAM_VALUE.TARGET { MODELPARAM_VALUE.TARGET PARAM_VALUE.TARGET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TARGET}] ${MODELPARAM_VALUE.TARGET}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S_AXIS_TDATA_WIDTH PARAM_VALUE.C_S_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIS_TDATA_WIDTH}
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

proc update_MODELPARAM_VALUE.SYNC_FIFO_ADDR_WIDTH { MODELPARAM_VALUE.SYNC_FIFO_ADDR_WIDTH PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.SYNC_FIFO_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.RX_HDR_FIFO_BANK_COUNT { MODELPARAM_VALUE.RX_HDR_FIFO_BANK_COUNT PARAM_VALUE.RX_HDR_FIFO_BANK_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_HDR_FIFO_BANK_COUNT}] ${MODELPARAM_VALUE.RX_HDR_FIFO_BANK_COUNT}
}

proc update_MODELPARAM_VALUE.FROM_PS_FIFO_ADDR_WIDTH { MODELPARAM_VALUE.FROM_PS_FIFO_ADDR_WIDTH PARAM_VALUE.FROM_PS_FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FROM_PS_FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.FROM_PS_FIFO_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.MIN_FRAME_LENGTH { MODELPARAM_VALUE.MIN_FRAME_LENGTH PARAM_VALUE.MIN_FRAME_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MIN_FRAME_LENGTH}] ${MODELPARAM_VALUE.MIN_FRAME_LENGTH}
}

proc update_MODELPARAM_VALUE.TX_FIFO_ADDR_WIDTH { MODELPARAM_VALUE.TX_FIFO_ADDR_WIDTH PARAM_VALUE.TX_FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TX_FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.TX_FIFO_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.RX_FIFO_ADDR_WIDTH { MODELPARAM_VALUE.RX_FIFO_ADDR_WIDTH PARAM_VALUE.RX_FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.RX_FIFO_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.IFG_DELAY { MODELPARAM_VALUE.IFG_DELAY PARAM_VALUE.IFG_DELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IFG_DELAY}] ${MODELPARAM_VALUE.IFG_DELAY}
}

proc update_MODELPARAM_VALUE.RX_HDR_FIFO_DEPTH { MODELPARAM_VALUE.RX_HDR_FIFO_DEPTH PARAM_VALUE.RX_HDR_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_HDR_FIFO_DEPTH}] ${MODELPARAM_VALUE.RX_HDR_FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.FROM_CS_FIFO_ADDR_WIDTH { MODELPARAM_VALUE.FROM_CS_FIFO_ADDR_WIDTH PARAM_VALUE.FROM_CS_FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FROM_CS_FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.FROM_CS_FIFO_ADDR_WIDTH}
}

