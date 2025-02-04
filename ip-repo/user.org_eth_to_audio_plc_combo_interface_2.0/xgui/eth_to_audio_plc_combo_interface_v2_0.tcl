# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  set BUF_COUNT_W [ipgui::add_param $IPINST -name "BUF_COUNT_W"]
  set_property tooltip {Buffer count bit width} ${BUF_COUNT_W}
  set PACKET_COUNT_W [ipgui::add_param $IPINST -name "PACKET_COUNT_W"]
  set_property tooltip {Packet count bit width} ${PACKET_COUNT_W}
  ipgui::add_param $IPINST -name "FIFO_ADDR_WIDTH"
  ipgui::add_param $IPINST -name "TC_BIT_LENGTH"
  ipgui::add_param $IPINST -name "PACKET_SEQ_W"
  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -widget comboBox
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH"
  set S_COUNT [ipgui::add_param $IPINST -name "S_COUNT"]
  set_property tooltip {This is the slot count of the seq} ${S_COUNT}
  ipgui::add_param $IPINST -name "LIFO_ADDR_WIDTH"
  ipgui::add_param $IPINST -name "CIC_SIG_OUT_WIDTH"
  ipgui::add_param $IPINST -name "EXIT_FADE_LENGTH"
  ipgui::add_param $IPINST -name "ENTRY_FADE_LENGTH"
  ipgui::add_param $IPINST -name "REL_PIPE_LENGTH"
  ipgui::add_param $IPINST -name "SIM_PKT_LEN_WIDTH"

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

proc update_PARAM_VALUE.CIC_SIG_IN_WIDTH { PARAM_VALUE.CIC_SIG_IN_WIDTH } {
	# Procedure called to update CIC_SIG_IN_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CIC_SIG_IN_WIDTH { PARAM_VALUE.CIC_SIG_IN_WIDTH } {
	# Procedure called to validate CIC_SIG_IN_WIDTH
	return true
}

proc update_PARAM_VALUE.CIC_SIG_OUT_WIDTH { PARAM_VALUE.CIC_SIG_OUT_WIDTH } {
	# Procedure called to update CIC_SIG_OUT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CIC_SIG_OUT_WIDTH { PARAM_VALUE.CIC_SIG_OUT_WIDTH } {
	# Procedure called to validate CIC_SIG_OUT_WIDTH
	return true
}

proc update_PARAM_VALUE.COMP_SIG_OUT_WIDTH { PARAM_VALUE.COMP_SIG_OUT_WIDTH } {
	# Procedure called to update COMP_SIG_OUT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COMP_SIG_OUT_WIDTH { PARAM_VALUE.COMP_SIG_OUT_WIDTH } {
	# Procedure called to validate COMP_SIG_OUT_WIDTH
	return true
}

proc update_PARAM_VALUE.ENTRY_FADE_LENGTH { PARAM_VALUE.ENTRY_FADE_LENGTH } {
	# Procedure called to update ENTRY_FADE_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENTRY_FADE_LENGTH { PARAM_VALUE.ENTRY_FADE_LENGTH } {
	# Procedure called to validate ENTRY_FADE_LENGTH
	return true
}

proc update_PARAM_VALUE.EXIT_FADE_LENGTH { PARAM_VALUE.EXIT_FADE_LENGTH } {
	# Procedure called to update EXIT_FADE_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXIT_FADE_LENGTH { PARAM_VALUE.EXIT_FADE_LENGTH } {
	# Procedure called to validate EXIT_FADE_LENGTH
	return true
}

proc update_PARAM_VALUE.FIFO_ADDR_WIDTH { PARAM_VALUE.FIFO_ADDR_WIDTH } {
	# Procedure called to update FIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_ADDR_WIDTH { PARAM_VALUE.FIFO_ADDR_WIDTH } {
	# Procedure called to validate FIFO_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.FIFO_DATA_WIDTH { PARAM_VALUE.FIFO_DATA_WIDTH } {
	# Procedure called to update FIFO_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_DATA_WIDTH { PARAM_VALUE.FIFO_DATA_WIDTH } {
	# Procedure called to validate FIFO_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.FRACBIT_WIDTH { PARAM_VALUE.FRACBIT_WIDTH } {
	# Procedure called to update FRACBIT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRACBIT_WIDTH { PARAM_VALUE.FRACBIT_WIDTH } {
	# Procedure called to validate FRACBIT_WIDTH
	return true
}

proc update_PARAM_VALUE.GLITCH_FILTER_LENGTH { PARAM_VALUE.GLITCH_FILTER_LENGTH } {
	# Procedure called to update GLITCH_FILTER_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.GLITCH_FILTER_LENGTH { PARAM_VALUE.GLITCH_FILTER_LENGTH } {
	# Procedure called to validate GLITCH_FILTER_LENGTH
	return true
}

proc update_PARAM_VALUE.INTBIT_WIDTH { PARAM_VALUE.INTBIT_WIDTH } {
	# Procedure called to update INTBIT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INTBIT_WIDTH { PARAM_VALUE.INTBIT_WIDTH } {
	# Procedure called to validate INTBIT_WIDTH
	return true
}

proc update_PARAM_VALUE.LIFO_ADDR_WIDTH { PARAM_VALUE.LIFO_ADDR_WIDTH } {
	# Procedure called to update LIFO_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LIFO_ADDR_WIDTH { PARAM_VALUE.LIFO_ADDR_WIDTH } {
	# Procedure called to validate LIFO_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.PACKET_COUNT_W { PARAM_VALUE.PACKET_COUNT_W } {
	# Procedure called to update PACKET_COUNT_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PACKET_COUNT_W { PARAM_VALUE.PACKET_COUNT_W } {
	# Procedure called to validate PACKET_COUNT_W
	return true
}

proc update_PARAM_VALUE.PACKET_SEQ_W { PARAM_VALUE.PACKET_SEQ_W } {
	# Procedure called to update PACKET_SEQ_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PACKET_SEQ_W { PARAM_VALUE.PACKET_SEQ_W } {
	# Procedure called to validate PACKET_SEQ_W
	return true
}

proc update_PARAM_VALUE.REL_PIPE_LENGTH { PARAM_VALUE.REL_PIPE_LENGTH } {
	# Procedure called to update REL_PIPE_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REL_PIPE_LENGTH { PARAM_VALUE.REL_PIPE_LENGTH } {
	# Procedure called to validate REL_PIPE_LENGTH
	return true
}

proc update_PARAM_VALUE.SIM_PKT_LEN_WIDTH { PARAM_VALUE.SIM_PKT_LEN_WIDTH } {
	# Procedure called to update SIM_PKT_LEN_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIM_PKT_LEN_WIDTH { PARAM_VALUE.SIM_PKT_LEN_WIDTH } {
	# Procedure called to validate SIM_PKT_LEN_WIDTH
	return true
}

proc update_PARAM_VALUE.STEP_WIDTH { PARAM_VALUE.STEP_WIDTH } {
	# Procedure called to update STEP_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STEP_WIDTH { PARAM_VALUE.STEP_WIDTH } {
	# Procedure called to validate STEP_WIDTH
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

proc update_MODELPARAM_VALUE.FIFO_ADDR_WIDTH { MODELPARAM_VALUE.FIFO_ADDR_WIDTH PARAM_VALUE.FIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.FIFO_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.GLITCH_FILTER_LENGTH { MODELPARAM_VALUE.GLITCH_FILTER_LENGTH PARAM_VALUE.GLITCH_FILTER_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.GLITCH_FILTER_LENGTH}] ${MODELPARAM_VALUE.GLITCH_FILTER_LENGTH}
}

proc update_MODELPARAM_VALUE.TC_BIT_LENGTH { MODELPARAM_VALUE.TC_BIT_LENGTH PARAM_VALUE.TC_BIT_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TC_BIT_LENGTH}] ${MODELPARAM_VALUE.TC_BIT_LENGTH}
}

proc update_MODELPARAM_VALUE.PACKET_SEQ_W { MODELPARAM_VALUE.PACKET_SEQ_W PARAM_VALUE.PACKET_SEQ_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PACKET_SEQ_W}] ${MODELPARAM_VALUE.PACKET_SEQ_W}
}

proc update_MODELPARAM_VALUE.S_COUNT { MODELPARAM_VALUE.S_COUNT PARAM_VALUE.S_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_COUNT}] ${MODELPARAM_VALUE.S_COUNT}
}

proc update_MODELPARAM_VALUE.STEP_WIDTH { MODELPARAM_VALUE.STEP_WIDTH PARAM_VALUE.STEP_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STEP_WIDTH}] ${MODELPARAM_VALUE.STEP_WIDTH}
}

proc update_MODELPARAM_VALUE.INTBIT_WIDTH { MODELPARAM_VALUE.INTBIT_WIDTH PARAM_VALUE.INTBIT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INTBIT_WIDTH}] ${MODELPARAM_VALUE.INTBIT_WIDTH}
}

proc update_MODELPARAM_VALUE.FRACBIT_WIDTH { MODELPARAM_VALUE.FRACBIT_WIDTH PARAM_VALUE.FRACBIT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRACBIT_WIDTH}] ${MODELPARAM_VALUE.FRACBIT_WIDTH}
}

proc update_MODELPARAM_VALUE.FIFO_DATA_WIDTH { MODELPARAM_VALUE.FIFO_DATA_WIDTH PARAM_VALUE.FIFO_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_DATA_WIDTH}] ${MODELPARAM_VALUE.FIFO_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.LIFO_ADDR_WIDTH { MODELPARAM_VALUE.LIFO_ADDR_WIDTH PARAM_VALUE.LIFO_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LIFO_ADDR_WIDTH}] ${MODELPARAM_VALUE.LIFO_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.CIC_SIG_OUT_WIDTH { MODELPARAM_VALUE.CIC_SIG_OUT_WIDTH PARAM_VALUE.CIC_SIG_OUT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CIC_SIG_OUT_WIDTH}] ${MODELPARAM_VALUE.CIC_SIG_OUT_WIDTH}
}

proc update_MODELPARAM_VALUE.CIC_SIG_IN_WIDTH { MODELPARAM_VALUE.CIC_SIG_IN_WIDTH PARAM_VALUE.CIC_SIG_IN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CIC_SIG_IN_WIDTH}] ${MODELPARAM_VALUE.CIC_SIG_IN_WIDTH}
}

proc update_MODELPARAM_VALUE.COMP_SIG_OUT_WIDTH { MODELPARAM_VALUE.COMP_SIG_OUT_WIDTH PARAM_VALUE.COMP_SIG_OUT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COMP_SIG_OUT_WIDTH}] ${MODELPARAM_VALUE.COMP_SIG_OUT_WIDTH}
}

proc update_MODELPARAM_VALUE.REL_PIPE_LENGTH { MODELPARAM_VALUE.REL_PIPE_LENGTH PARAM_VALUE.REL_PIPE_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REL_PIPE_LENGTH}] ${MODELPARAM_VALUE.REL_PIPE_LENGTH}
}

proc update_MODELPARAM_VALUE.EXIT_FADE_LENGTH { MODELPARAM_VALUE.EXIT_FADE_LENGTH PARAM_VALUE.EXIT_FADE_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXIT_FADE_LENGTH}] ${MODELPARAM_VALUE.EXIT_FADE_LENGTH}
}

proc update_MODELPARAM_VALUE.ENTRY_FADE_LENGTH { MODELPARAM_VALUE.ENTRY_FADE_LENGTH PARAM_VALUE.ENTRY_FADE_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENTRY_FADE_LENGTH}] ${MODELPARAM_VALUE.ENTRY_FADE_LENGTH}
}

proc update_MODELPARAM_VALUE.SIM_PKT_LEN_WIDTH { MODELPARAM_VALUE.SIM_PKT_LEN_WIDTH PARAM_VALUE.SIM_PKT_LEN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIM_PKT_LEN_WIDTH}] ${MODELPARAM_VALUE.SIM_PKT_LEN_WIDTH}
}

