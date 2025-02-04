# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${Page_0}


}

proc update_PARAM_VALUE.GMT_OFFSET { PARAM_VALUE.GMT_OFFSET } {
	# Procedure called to update GMT_OFFSET when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.GMT_OFFSET { PARAM_VALUE.GMT_OFFSET } {
	# Procedure called to validate GMT_OFFSET
	return true
}

proc update_PARAM_VALUE.g_DST_MAC { PARAM_VALUE.g_DST_MAC } {
	# Procedure called to update g_DST_MAC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_DST_MAC { PARAM_VALUE.g_DST_MAC } {
	# Procedure called to validate g_DST_MAC
	return true
}

proc update_PARAM_VALUE.g_IP_DST { PARAM_VALUE.g_IP_DST } {
	# Procedure called to update g_IP_DST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_IP_DST { PARAM_VALUE.g_IP_DST } {
	# Procedure called to validate g_IP_DST
	return true
}

proc update_PARAM_VALUE.g_IP_SRC { PARAM_VALUE.g_IP_SRC } {
	# Procedure called to update g_IP_SRC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_IP_SRC { PARAM_VALUE.g_IP_SRC } {
	# Procedure called to validate g_IP_SRC
	return true
}

proc update_PARAM_VALUE.g_SIMULATION { PARAM_VALUE.g_SIMULATION } {
	# Procedure called to update g_SIMULATION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_SIMULATION { PARAM_VALUE.g_SIMULATION } {
	# Procedure called to validate g_SIMULATION
	return true
}

proc update_PARAM_VALUE.g_SRC_MAC { PARAM_VALUE.g_SRC_MAC } {
	# Procedure called to update g_SRC_MAC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_SRC_MAC { PARAM_VALUE.g_SRC_MAC } {
	# Procedure called to validate g_SRC_MAC
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


proc update_MODELPARAM_VALUE.g_SIMULATION { MODELPARAM_VALUE.g_SIMULATION PARAM_VALUE.g_SIMULATION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_SIMULATION}] ${MODELPARAM_VALUE.g_SIMULATION}
}

proc update_MODELPARAM_VALUE.g_DST_MAC { MODELPARAM_VALUE.g_DST_MAC PARAM_VALUE.g_DST_MAC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_DST_MAC}] ${MODELPARAM_VALUE.g_DST_MAC}
}

proc update_MODELPARAM_VALUE.g_SRC_MAC { MODELPARAM_VALUE.g_SRC_MAC PARAM_VALUE.g_SRC_MAC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_SRC_MAC}] ${MODELPARAM_VALUE.g_SRC_MAC}
}

proc update_MODELPARAM_VALUE.g_IP_SRC { MODELPARAM_VALUE.g_IP_SRC PARAM_VALUE.g_IP_SRC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_IP_SRC}] ${MODELPARAM_VALUE.g_IP_SRC}
}

proc update_MODELPARAM_VALUE.g_IP_DST { MODELPARAM_VALUE.g_IP_DST PARAM_VALUE.g_IP_DST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_IP_DST}] ${MODELPARAM_VALUE.g_IP_DST}
}

proc update_MODELPARAM_VALUE.GMT_OFFSET { MODELPARAM_VALUE.GMT_OFFSET PARAM_VALUE.GMT_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.GMT_OFFSET}] ${MODELPARAM_VALUE.GMT_OFFSET}
}

