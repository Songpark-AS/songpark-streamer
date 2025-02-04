
 PARAMETER VERSION = 2.2.0


BEGIN OS
 PARAMETER OS_NAME = device_tree
 PARAMETER PROC_INSTANCE = ps7_cortexa9_0
 PARAMETER console_device = ps7_uart_1
 PARAMETER main_memory = ps7_ddr_0
END


BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu_cortexa9
 PARAMETER HW_INSTANCE = ps7_cortexa9_0
END


BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = AudioProcessingChannel_FILTER_IIR_1
 PARAMETER clock-names = s00_axi_aclk
 PARAMETER clocks = clkc 15
 PARAMETER compatible = xlnx,FILTER-IIR-1.0
 PARAMETER reg = 0x43c10000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 7
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = AudioProcessingChannel_Volume_Pregain_1
 PARAMETER clock-names = s00_axi_aclk
 PARAMETER clocks = clkc 15
 PARAMETER compatible = xlnx,Volume-Pregain-1.0
 PARAMETER reg = 0x43c30000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 4
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = AudioProcessingChannel_eth_to_audio_plc_com_0
 PARAMETER clock-names = CLK_125 s00_axi_aclk
 PARAMETER clocks = misc_clk_0>, <&clkc 15
 PARAMETER compatible = xlnx,eth-to-audio-plc-combo-interface-2.0
 PARAMETER reg = 0x43c70000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 7
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = AudioProcessingChannel_user_org_plc_seq_ip_0
 PARAMETER clock-names = clk_125 fm_udp_s_axis_aclk fm_audio_s_axis_aclk to_udp_m_axis_aclk to_audio_m_axis_aclk s00_axi_aclk
 PARAMETER clocks = misc_clk_0>, <&misc_clk_0>, <&misc_clk_0>, <&misc_clk_0>, <&misc_clk_0>, <&clkc 15
 PARAMETER compatible = xlnx,user-org-plc-seq-ip-1.0
 PARAMETER reg = 0x43ca0000 0x10000
 PARAMETER xlnx,fm-audio-s-axis-tdata-width = 8
 PARAMETER xlnx,fm-udp-s-axis-tdata-width = 8
 PARAMETER xlnx,s00-axi-addr-width = 8
 PARAMETER xlnx,s00-axi-data-width = 32
 PARAMETER xlnx,to-audio-m-axis-start-count = 32
 PARAMETER xlnx,to-audio-m-axis-tdata-width = 8
 PARAMETER xlnx,to-udp-m-axis-start-count = 32
 PARAMETER xlnx,to-udp-m-axis-tdata-width = 8
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = FILTER_IIR_0
 PARAMETER clock-names = s00_axi_aclk
 PARAMETER clocks = clkc 15
 PARAMETER compatible = xlnx,FILTER-IIR-1.0
 PARAMETER reg = 0x43c00000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 7
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = Volume_Pregain_0
 PARAMETER clock-names = s00_axi_aclk
 PARAMETER clocks = clkc 15
 PARAMETER compatible = xlnx,Volume-Pregain-1.0
 PARAMETER reg = 0x43c20000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 4
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ZedCodec_adau1761_controller_0
 PARAMETER clock-names = s00_axi_aclk
 PARAMETER clocks = clkc 15
 PARAMETER compatible = xlnx,adau1761-controller-1.0
 PARAMETER reg = 0x43c40000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 5
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ZedboardOLED_0
 PARAMETER clock-names = s00_axi_aclk
 PARAMETER clocks = clkc 15
 PARAMETER compatible = xlnx,ZedboardOLED-1.0
 PARAMETER reg = 0x43c50000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 7
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = gpio
 PARAMETER HW_INSTANCE = axi_gpio_0
 PARAMETER clock-names = s_axi_aclk
 PARAMETER clocks = clkc 15
 PARAMETER compatible = xlnx,axi-gpio-2.0 xlnx,xps-gpio-1.00.a
 PARAMETER interrupt-names = ip2intc_irpt
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 34 4
 PARAMETER reg = 0x41200000 0x10000
 PARAMETER xlnx,all-inputs = 1
 PARAMETER xlnx,all-inputs-2 = 0
 PARAMETER xlnx,all-outputs = 0
 PARAMETER xlnx,all-outputs-2 = 0
 PARAMETER xlnx,dout-default = 0x00000000
 PARAMETER xlnx,dout-default-2 = 0x00000000
 PARAMETER xlnx,gpio-width = 5
 PARAMETER xlnx,gpio2-width = 32
 PARAMETER xlnx,interrupt-present = 1
 PARAMETER xlnx,is-dual = 0
 PARAMETER xlnx,tri-default = 0xFFFFFFFF
 PARAMETER xlnx,tri-default-2 = 0xFFFFFFFF
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = gpio
 PARAMETER HW_INSTANCE = axi_gpio_1
 PARAMETER clock-names = s_axi_aclk
 PARAMETER clocks = clkc 15
 PARAMETER compatible = xlnx,axi-gpio-2.0 xlnx,xps-gpio-1.00.a
 PARAMETER interrupt-names = ip2intc_irpt
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 35 4
 PARAMETER reg = 0x41210000 0x10000
 PARAMETER xlnx,all-inputs = 1
 PARAMETER xlnx,all-inputs-2 = 0
 PARAMETER xlnx,all-outputs = 0
 PARAMETER xlnx,all-outputs-2 = 0
 PARAMETER xlnx,dout-default = 0x00000000
 PARAMETER xlnx,dout-default-2 = 0x00000000
 PARAMETER xlnx,gpio-width = 8
 PARAMETER xlnx,gpio2-width = 32
 PARAMETER xlnx,interrupt-present = 1
 PARAMETER xlnx,is-dual = 0
 PARAMETER xlnx,tri-default = 0xFFFFFFFF
 PARAMETER xlnx,tri-default-2 = 0xFFFFFFFF
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = gpio
 PARAMETER HW_INSTANCE = axi_gpio_2
 PARAMETER clock-names = s_axi_aclk
 PARAMETER clocks = clkc 15
 PARAMETER compatible = xlnx,axi-gpio-2.0 xlnx,xps-gpio-1.00.a
 PARAMETER interrupt-names = ip2intc_irpt
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 36 4
 PARAMETER reg = 0x41220000 0x10000
 PARAMETER xlnx,all-inputs = 0
 PARAMETER xlnx,all-inputs-2 = 0
 PARAMETER xlnx,all-outputs = 1
 PARAMETER xlnx,all-outputs-2 = 0
 PARAMETER xlnx,dout-default = 0x00000000
 PARAMETER xlnx,dout-default-2 = 0x00000000
 PARAMETER xlnx,gpio-width = 8
 PARAMETER xlnx,gpio2-width = 32
 PARAMETER xlnx,interrupt-present = 1
 PARAMETER xlnx,is-dual = 0
 PARAMETER xlnx,tri-default = 0xFFFFFFFF
 PARAMETER xlnx,tri-default-2 = 0xFFFFFFFF
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = org_audio2eth_interl_0
 PARAMETER clock-names = CLK_125 s00_axi_aclk
 PARAMETER clocks = misc_clk_0>, <&clkc 15
 PARAMETER compatible = xlnx,org-audio2eth-interleaved-packetizer-1.0
 PARAMETER reg = 0x43c60000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 7
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = pmod_controller_0
 PARAMETER clock-names = s00_axi_aclk
 PARAMETER clocks = clkc 15
 PARAMETER compatible = xlnx,pmod-controller-1.0
 PARAMETER interrupt-names = Rotary_event
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 33 4
 PARAMETER reg = 0x43c90000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 4
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_afi_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_afi_1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_afi_2
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_afi_3
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_coresight_comp_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ddrps
 PARAMETER HW_INSTANCE = ps7_ddr_0
 PARAMETER reg = 0x0 0x20000000
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ddrcps
 PARAMETER HW_INSTANCE = ps7_ddrc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = devcfg
 PARAMETER HW_INSTANCE = ps7_dev_cfg_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = none
 PARAMETER HW_INSTANCE = ps7_dma_ns
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = dmaps
 PARAMETER HW_INSTANCE = ps7_dma_s
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = emacps
 PARAMETER HW_INSTANCE = ps7_ethernet_0
 PARAMETER phy-mode = rgmii-id
 PARAMETER xlnx,ptp-enet-clock = 111111115
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = emacps
 PARAMETER HW_INSTANCE = ps7_ethernet_1
 PARAMETER local-mac-address = 00 0a 35 00 00 08
 PARAMETER xlnx,ptp-enet-clock = 111111115
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = globaltimerps
 PARAMETER HW_INSTANCE = ps7_globaltimer_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = gpiops
 PARAMETER HW_INSTANCE = ps7_gpio_0
 PARAMETER emio-gpio-width = 64
 PARAMETER gpio-mask-high = 0
 PARAMETER gpio-mask-low = 22016
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_gpv_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_intc_dist_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_iop_bus_config_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_l2cachec_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ocmcps
 PARAMETER HW_INSTANCE = ps7_ocmc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = pl310ps
 PARAMETER HW_INSTANCE = ps7_pl310_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = pmups
 PARAMETER HW_INSTANCE = ps7_pmu_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = qspips
 PARAMETER HW_INSTANCE = ps7_qspi_0
 PARAMETER is-dual = 0
 PARAMETER spi-rx-bus-width = 4
 PARAMETER spi-tx-bus-width = 4
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_qspi_linear_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ramps
 PARAMETER HW_INSTANCE = ps7_ram_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = none
 PARAMETER HW_INSTANCE = ps7_ram_1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_scuc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = scugic
 PARAMETER HW_INSTANCE = ps7_scugic_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = scutimer
 PARAMETER HW_INSTANCE = ps7_scutimer_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = scuwdt
 PARAMETER HW_INSTANCE = ps7_scuwdt_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_sd_0
 PARAMETER xlnx,has-cd = 1
 PARAMETER xlnx,has-power = 0
 PARAMETER xlnx,has-wp = 1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = slcrps
 PARAMETER HW_INSTANCE = ps7_slcr_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ttcps
 PARAMETER HW_INSTANCE = ps7_ttc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartps
 PARAMETER HW_INSTANCE = ps7_uart_1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = xadcps
 PARAMETER HW_INSTANCE = ps7_xadc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = time_sync_block_0
 PARAMETER clock-names = CLK_125 s00_axi_aclk
 PARAMETER clocks = misc_clk_0>, <&clkc 15
 PARAMETER compatible = xlnx,time-sync-block-2.0
 PARAMETER reg = 0x43cb0000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 7
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = user_cross_layer_swi_0
 PARAMETER clock-names = phy_rx_clk s00_axi_aclk
 PARAMETER clocks = misc_clk_0>, <&clkc 15
 PARAMETER compatible = xlnx,user-cross-layer-switch-1.0
 PARAMETER reg = 0x43cc0000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 8
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = eth_udp_axi_arp_stack_0
 PARAMETER clock-names = clk_100_in clk_125_in s00_axi_aclk
 PARAMETER clocks = misc_clk_1>, <&misc_clk_0>, <&clkc 15
 PARAMETER compatible = xlnx,eth-udp-axi-arp-stack-1.0
 PARAMETER reg = 0x43c80000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 8
 PARAMETER xlnx,s00-axi-data-width = 32
END


