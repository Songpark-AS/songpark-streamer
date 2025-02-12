set_property PACKAGE_PIN AB10 [get_ports {phy_rxd_0[0]}]
set_property PACKAGE_PIN AB9 [get_ports {phy_rxd_0[2]}]
set_property PACKAGE_PIN AA11 [get_ports phy_rx_ctl_0]
set_property PACKAGE_PIN Y10 [get_ports {phy_rxd_0[1]}]
set_property PACKAGE_PIN AA9 [get_ports {phy_rxd_0[3]}]
# General configuration
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
# timing constraints
set_false_path -from [get_clocks clk_fpga_1] -to [get_clocks clk_fpga_0]
set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks clk_fpga_1]


set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks clk_fpga_2]
set_false_path -from [get_clocks clk_fpga_2] -to [get_clocks clk_fpga_0]

set_false_path -from [get_clocks clk_fpga_1] -to [get_clocks clk_fpga_2]
set_false_path -from [get_clocks clk_fpga_2] -to [get_clocks clk_fpga_1]

# ----------------------------------------------------------------------------------








# ----------------------------------------------------------------------------------



set_false_path -from [get_clocks clk_mmcm_out] -to [get_clocks clk_fpga_0]
set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks clk_mmcm_out]



set_false_path -from [get_clocks clk_mmcm_out] -to [get_clocks clk90_mmcm_out]
set_false_path -from [get_clocks clk90_mmcm_out] -to [get_clocks clk_mmcm_out]

# --------------------------------------------------------------------------------------

set_false_path -from [get_clocks clk_100_in] -to [get_clocks clk_fpga_0]
set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks clk_100_in]


set_false_path -from [get_clocks clk_100_in] -to [get_clocks clk_fpga_0]
set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks clk_100_in]



set_false_path -from [get_clocks clk_100_in] -to [get_clocks clk_mmcm_out]
set_false_path -from [get_clocks clk_mmcm_out] -to [get_clocks clk_100_in]

set_false_path -from [get_clocks clk_100_in] -to [get_clocks clk90_mmcm_out]
set_false_path -from [get_clocks clk90_mmcm_out] -to [get_clocks clk_100_in]


# 100 mhz clock
#create_clock -period 10.000 -name clk_100_in [get_ports clk_100_in]
#set_property PACKAGE_PIN Y9 [get_ports clk_100_in]
#set_property IOSTANDARD LVCMOS33 [get_ports clk_100M_in]
#set_clock_groups -asynchronous -group [get_clocks clk_100_in -include_generated_clocks]

# 100 mhz clock

set_property -dict {LOC Y9 IOSTANDARD LVCMOS33} [get_ports clk_100_in]
create_clock -period 10.000 -name clk_100_in -waveform {0.000 5.000} [get_ports clk_100_in]
set_clock_groups -asynchronous -group [get_clocks clk_100_in -include_generated_clocks]

## 24 mhz clock to audio chip
#set_property PACKAGE_PIN AB2 [get_ports AC_MCLK]
#set_property IOSTANDARD LVCMOS33 [get_ports AC_MCLK]


## I2S transfers audio samples
## i2s bit clock to ADAU1761
#set_property PACKAGE_PIN Y8 [get_ports AC_GPIO0]
#set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO0]

## i2s bit clock from ADAU1761
#set_property PACKAGE_PIN AA7 [get_ports AC_GPIO1]
#set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO1]

## i2s bit clock from ADAU1761
#set_property PACKAGE_PIN AA6 [get_ports AC_GPIO2]
#set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO2]

## i2s l/r 48 khz toggling signal from ADAU1761 (sample clock)
#set_property PACKAGE_PIN Y6 [get_ports AC_GPIO3]
#set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO3]


## I2C Data Interface to ADAU1761 (for configuration)
#set_property PACKAGE_PIN AB4 [get_ports AC_SCK]
#set_property IOSTANDARD LVCMOS33 [get_ports AC_SCK]

#set_property PACKAGE_PIN AB5 [get_ports AC_SDA]
#set_property IOSTANDARD LVCMOS33 [get_ports AC_SDA]

#set_property PACKAGE_PIN AB1 [get_ports AC_ADR0]
#set_property IOSTANDARD LVCMOS33 [get_ports AC_ADR0]

#set_property PACKAGE_PIN Y5 [get_ports AC_ADR1]
#set_property IOSTANDARD LVCMOS33 [get_ports AC_ADR1]


set_property PACKAGE_PIN AB4 [get_ports adau1761_cclk_0]

set_property PACKAGE_PIN AB1 [get_ports adau1761_clatchn_0]

set_property PACKAGE_PIN Y5 [get_ports adau1761_cdata_0]

set_property PACKAGE_PIN AB5 [get_ports adau1761_cout_0]

set_property PACKAGE_PIN AB2 [get_ports adau1761_mclk]

set_property PACKAGE_PIN AA7 [get_ports adau1761_adc_sdata_0]

set_property PACKAGE_PIN Y8 [get_ports adau1761_dac_sdata_0]

set_property PACKAGE_PIN AA6 [get_ports adau1761_bclk_0]
#[Place 30-876] Port 'adau1761_bclk_0'  is assigned to PACKAGE_PIN 'AA6'  which can only be used as the N side of a differential clock input.
#Please use the following constraint(s) to pass this DRC check:
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets adau1761_bclk_0_IBUF]


set_property PACKAGE_PIN Y6 [get_ports adau1761_lrclk_0]


#--------------------------------------------------------------------
set_property PACKAGE_PIN V4 [get_ports bclk1_0]
set_property PACKAGE_PIN W7 [get_ports lrclk1_0]
set_property PACKAGE_PIN U5 [get_ports mclk1_0]


set_property PACKAGE_PIN U6 [get_ports serial_data_out1_0]
set_property PACKAGE_PIN V5 [get_ports serial_data_in1_0]

set_property PACKAGE_PIN V7 [get_ports ctrl_sw_out_0]


# LEDs
set_property PACKAGE_PIN T22 [get_ports {led_0[0]}]
set_property PACKAGE_PIN T21 [get_ports {led_0[1]}]
set_property PACKAGE_PIN U22 [get_ports {led_0[2]}]
set_property PACKAGE_PIN U21 [get_ports {led_0[3]}]
set_property PACKAGE_PIN V22 [get_ports {led_0[4]}]
set_property PACKAGE_PIN W22 [get_ports {led_0[5]}]
set_property PACKAGE_PIN U19 [get_ports {led_0[6]}]
set_property PACKAGE_PIN U14 [get_ports {led_0[7]}]

#set_property -dict {LOC T22 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports led_0[0]]
#set_property -dict {LOC T21 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports led_0[1]]
#set_property -dict {LOC U22 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports led_0[2]]
#set_property -dict {LOC U21 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports led_0[3]]
#set_property -dict {LOC V22 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports led_0[4]]
#set_property -dict {LOC V22 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports led_0[5]]
#set_property -dict {LOC U19 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports led_0[6]]
#set_property -dict {LOC U14 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports led_0[7]]



# ----------------------------------------------------------------------------
# Audio Codec - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN AB1 [get_ports {AC_ADR0}];  # "AC-ADR0"
#set_property PACKAGE_PIN Y5  [get_ports {AC_ADR1}];  # "AC-ADR1"
#set_property PACKAGE_PIN Y8  [get_ports {SDATA_O}];  # "AC-GPIO0"
#set_property PACKAGE_PIN AA7 [get_ports {SDATA_I}];  # "AC-GPIO1"
#set_property PACKAGE_PIN AA6 [get_ports {BCLK_O}];  # "AC-GPIO2"
#set_property PACKAGE_PIN Y6  [get_ports {LRCLK_O}];  # "AC-GPIO3"
#set_property PACKAGE_PIN AB2 [get_ports {MCLK_O}];  # "AC-MCLK"
#set_property PACKAGE_PIN AB4 [get_ports {iic_rtl_scl_io}];  # "AC-SCK"
#set_property PACKAGE_PIN AB5 [get_ports {iic_rtl_sda_io}];  # "AC-SDA"

# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN Y9 [get_ports {GCLK}];  # "GCLK"

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13 ETH PHY P1
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN Y11  [get_ports {Rotary_a}];  # "JA1"
set_property PACKAGE_PIN AA8 [get_ports phy_int_n_0]
set_property PACKAGE_PIN AB11 [get_ports phy_pme_n_0]





# ----------------------------------------------------------------------------
# JB Pmod - Bank 13 ETH PHY P2
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN W12 [get_ports {JB1}];  # "JB1"
set_property PACKAGE_PIN W11 [get_ports phy_tx_clk_0]
set_property PACKAGE_PIN V10 [get_ports {phy_txd_0[1]}]
set_property PACKAGE_PIN W8 [get_ports {phy_txd_0[3]}]
#set_property PACKAGE_PIN V12 [get_ports ];  # "JB7"
#set_property PACKAGE_PIN W10 [get_ports phy_rx_clk_0];  # "JB8"
set_property PACKAGE_PIN V9 [get_ports {phy_txd_0[0]}]
set_property PACKAGE_PIN V8 [get_ports {phy_txd_0[2]}]

#set_property IOSTANDARD LVCMOS33 [get_ports phy_rx_clk_0];

set_property -dict {LOC W10 IOSTANDARD LVCMOS33} [get_ports phy_rx_clk_0]
#set_property CLOCK_BUFFER_TYPE BUFG [get_ports phy_rx_clk_0]
create_clock -period 8.000 -name phy_rx_clk_0 [get_ports phy_rx_clk_0]
#set_clock_groups -asynchronous -group [get_clocks phy_rx_clk_0 -include_generated_clocks];
#To allow the use of the BUFG on this tricky pin
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets phy_rx_clk_0_IBUF]




# ----------------------------------------------------------------------------
# JC Pmod - Bank 13  ETH PHY P3
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN AB6 [get_ports phy_tx_ctl_0]
set_property PACKAGE_PIN AB7 [get_ports phy_reset_n_0]
set_property PACKAGE_PIN AA4 [get_ports phy_mdc_0]
set_property PACKAGE_PIN Y4 [get_ports phy_mdio_0]





set_property -dict {LOC T6 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports tsync_out_0]
set_property -dict {LOC R6 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports sync_en_out_0]


#set_property -dict {LOC U4 IOSTANDARD LVCMOS33} [get_ports sync_en_in_0]
#set_property -dict {LOC T4 IOSTANDARD LVCMOS33} [get_ports tsync_in_0]

#[Place 30-574] Poor placement for routing between an IO pin and BUFG. If this sub optimal condition is acceptable for this design, you may use the CLOCK_DEDICATED_ROUTE constraint in the .xdc file to demote this message to a WARNING. However, the use of this override is highly discouraged. These examples can be used directly in the .xdc file to override this clock rule.


# ----------------------------------------------------------------------------
# JD Pmod - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN W7 [get_ports Rotary_a]
#set_property PACKAGE_PIN V7 [get_ports Rotary_b]
#set_property PACKAGE_PIN V4 [get_ports Button]
#set_property PACKAGE_PIN V5 [get_ports Switch]
#set_property PACKAGE_PIN W5 [get_ports dafsafaf];  # "JD3_N"
#set_property PACKAGE_PIN W6 [get_ports phy_pme_n];  # "JD3_P"
#set_property PACKAGE_PIN U5 [get_ports uart_txd_0];  # "JD4_N"
#set_property PACKAGE_PIN U6 [get_ports uart_rxd_0];  # "JD4_P"

#set_property -dict {LOC U5 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports uart_txd_0]
#set_property -dict {LOC U6 IOSTANDARD LVCMOS33} [get_ports uart_rxd_0]

# ----------------------------------------------------------------------------
# OLED Display - Bank 13
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN U10 [get_ports DC]
set_property PACKAGE_PIN U9 [get_ports RES]
set_property PACKAGE_PIN AB12 [get_ports SCLK]
set_property PACKAGE_PIN AA12 [get_ports SDIN]
set_property PACKAGE_PIN U11 [get_ports VBAT]
set_property PACKAGE_PIN U12 [get_ports VDD]

# ----------------------------------------------------------------------------
# HDMI Output - Bank 33
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN W18  [get_ports {HD_CLK}];  # "HD-CLK"
#set_property PACKAGE_PIN Y13  [get_ports {HD_D0}];  # "HD-D0"
#set_property PACKAGE_PIN AA13 [get_ports {HD_D1}];  # "HD-D1"
#set_property PACKAGE_PIN W13  [get_ports {HD_D10}];  # "HD-D10"
#set_property PACKAGE_PIN W15  [get_ports {HD_D11}];  # "HD-D11"
#set_property PACKAGE_PIN V15  [get_ports {HD_D12}];  # "HD-D12"
#set_property PACKAGE_PIN U17  [get_ports {HD_D13}];  # "HD-D13"
#set_property PACKAGE_PIN V14  [get_ports {HD_D14}];  # "HD-D14"
#set_property PACKAGE_PIN V13  [get_ports {HS_D15}];  # "HD-D15"
#set_property PACKAGE_PIN AA14 [get_ports {HD_D2}];  # "HD-D2"
#set_property PACKAGE_PIN Y14  [get_ports {HD_D3}];  # "HD-D3"
#set_property PACKAGE_PIN AB15 [get_ports {HD_D4}];  # "HD-D4"
#set_property PACKAGE_PIN AB16 [get_ports {HD_D5}];  # "HD-D5"
#set_property PACKAGE_PIN AA16 [get_ports {HD_D6}];  # "HD-D6"
#set_property PACKAGE_PIN AB17 [get_ports {HD_D7}];  # "HD-D7"
#set_property PACKAGE_PIN AA17 [get_ports {HD_D8}];  # "HD-D8"
#set_property PACKAGE_PIN Y15  [get_ports {HD_D9}];  # "HD-D9"
#set_property PACKAGE_PIN U16  [get_ports {HD_DE}];  # "HD-DE"
#set_property PACKAGE_PIN V17  [get_ports {HD_HSYNC}];  # "HD-HSYNC"
#set_property PACKAGE_PIN W16  [get_ports {HD_INT}];  # "HD-INT"
#set_property PACKAGE_PIN AA18 [get_ports {HD_SCL}];  # "HD-SCL"
#set_property PACKAGE_PIN Y16  [get_ports {HD_SDA}];  # "HD-SDA"
#set_property PACKAGE_PIN U15  [get_ports {HD_SPDIF}];  # "HD-SPDIF"
#set_property PACKAGE_PIN Y18  [get_ports {HD_SPDIFO}];  # "HD-SPDIFO"
#set_property PACKAGE_PIN W17  [get_ports {HD_VSYNC}];  # "HD-VSYNC"

# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN T22 [get_ports {LD0}];  # "LD0"
#set_property PACKAGE_PIN T21 [get_ports {LD1}];  # "LD1"
#set_property PACKAGE_PIN U22 [get_ports {LD2}];  # "LD2"
#set_property PACKAGE_PIN U21 [get_ports {LD3}];  # "LD3"
#set_property PACKAGE_PIN V22 [get_ports {LD4}];  # "LD4"
#set_property PACKAGE_PIN W22 [get_ports {LD5}];  # "LD5"
#set_property PACKAGE_PIN U19 [get_ports {LD6}];  # "LD6"
#set_property PACKAGE_PIN U14 [get_ports {LD7}];  # "LD7"

# ----------------------------------------------------------------------------
# VGA Output - Bank 33
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN Y21  [get_ports {VGA_B1}];  # "VGA-B1"
#set_property PACKAGE_PIN Y20  [get_ports {VGA_B2}];  # "VGA-B2"
#set_property PACKAGE_PIN AB20 [get_ports {VGA_B3}];  # "VGA-B3"
#set_property PACKAGE_PIN AB19 [get_ports {VGA_B4}];  # "VGA-B4"
#set_property PACKAGE_PIN AB22 [get_ports {VGA_G1}];  # "VGA-G1"
#set_property PACKAGE_PIN AA22 [get_ports {VGA_G2}];  # "VGA-G2"
#set_property PACKAGE_PIN AB21 [get_ports {VGA_G3}];  # "VGA-G3"
#set_property PACKAGE_PIN AA21 [get_ports {VGA_G4}];  # "VGA-G4"
#set_property PACKAGE_PIN AA19 [get_ports {VGA_HS}];  # "VGA-HS"
#set_property PACKAGE_PIN V20  [get_ports {VGA_R1}];  # "VGA-R1"
#set_property PACKAGE_PIN U20  [get_ports {VGA_R2}];  # "VGA-R2"
#set_property PACKAGE_PIN V19  [get_ports {VGA_R3}];  # "VGA-R3"
#set_property PACKAGE_PIN V18  [get_ports {VGA_R4}];  # "VGA-R4"
#set_property PACKAGE_PIN Y19  [get_ports {VGA_VS}];  # "VGA-VS"

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN P16 [get_ports btnc_0]
set_property PACKAGE_PIN R16 [get_ports btnd_0]
set_property PACKAGE_PIN N15 [get_ports btnl_0]
set_property PACKAGE_PIN R18 [get_ports btnr_0]
set_property PACKAGE_PIN T18 [get_ports btnu_0]

# ----------------------------------------------------------------------------
# USB OTG Reset - Bank 34
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN L16 [get_ports {OTG_VBUSOC}];  # "OTG-VBUSOC"

# ----------------------------------------------------------------------------
# XADC GIO - Bank 34
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN H15 [get_ports {XADC_GIO0}];  # "XADC-GIO0"
#set_property PACKAGE_PIN R15 [get_ports {XADC_GIO1}];  # "XADC-GIO1"
#set_property PACKAGE_PIN K15 [get_ports {XADC_GIO2}];  # "XADC-GIO2"
#set_property PACKAGE_PIN J15 [get_ports {XADC_GIO3}];  # "XADC-GIO3"

# ----------------------------------------------------------------------------
# Miscellaneous - Bank 34
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN K16 [get_ports {PUDC_B}];  # "PUDC_B"

## ----------------------------------------------------------------------------
## USB OTG Reset - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN G17 [get_ports {OTG_RESETN}];  # "OTG-RESETN"

## ----------------------------------------------------------------------------
## User DIP Switches - Bank 35
## ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN F22 [get_ports {sw_0[0]}]; # "SW0"
set_property PACKAGE_PIN G22 [get_ports {sw_0[1]}];  # "SW1"
set_property PACKAGE_PIN H22 [get_ports {sw_0[2]}];  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {sw_0[3]}];  # "SW3"
set_property PACKAGE_PIN H19 [get_ports {sw_0[4]}];  # "SW4"
set_property PACKAGE_PIN H18 [get_ports {sw_0[5]}];  # "SW5"
set_property PACKAGE_PIN H17 [get_ports {sw_0[6]}];  # "SW6"
set_property PACKAGE_PIN M15 [get_ports {sw_0[7]}];  # "SW7"

## ----------------------------------------------------------------------------
## XADC AD Channels - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN E16 [get_ports {AD0N_R}];  # "XADC-AD0N-R"
#set_property PACKAGE_PIN F16 [get_ports {AD0P_R}];  # "XADC-AD0P-R"
#set_property PACKAGE_PIN D17 [get_ports {AD8N_N}];  # "XADC-AD8N-R"
#set_property PACKAGE_PIN D16 [get_ports {AD8P_R}];  # "XADC-AD8P-R"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 13
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN R7 [get_ports {FMC_SCL}];  # "FMC-SCL"
#set_property PACKAGE_PIN U7 [get_ports {FMC_SDA}];  # "FMC-SDA"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 33
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN AB14 [get_ports {FMC_PRSNT}];  # "FMC-PRSNT"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 34
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN L19 [get_ports {FMC_CLK0_N}];  # "FMC-CLK0_N"
#set_property PACKAGE_PIN L18 [get_ports {FMC_CLK0_P}];  # "FMC-CLK0_P"
#set_property PACKAGE_PIN M20 [get_ports {FMC_LA00_CC_N}];  # "FMC-LA00_CC_N"
#set_property PACKAGE_PIN M19 [get_ports {FMC_LA00_CC_P}];  # "FMC-LA00_CC_P"
#set_property PACKAGE_PIN N20 [get_ports {FMC_LA01_CC_N}];  # "FMC-LA01_CC_N"
#set_property PACKAGE_PIN N19 [get_ports {FMC_LA01_CC_P}];  # "FMC-LA01_CC_P" - corrected 6/6/16 GE
#set_property PACKAGE_PIN P18 [get_ports {FMC_LA02_N}];  # "FMC-LA02_N"
#set_property PACKAGE_PIN P17 [get_ports {FMC_LA02_P}];  # "FMC-LA02_P"
#set_property PACKAGE_PIN P22 [get_ports {FMC_LA03_N}];  # "FMC-LA03_N"
#set_property PACKAGE_PIN N22 [get_ports {FMC_LA03_P}];  # "FMC-LA03_P"
#set_property PACKAGE_PIN M22 [get_ports {FMC_LA04_N}];  # "FMC-LA04_N"
#set_property PACKAGE_PIN M21 [get_ports {FMC_LA04_P}];  # "FMC-LA04_P"
#set_property PACKAGE_PIN K18 [get_ports {FMC_LA05_N}];  # "FMC-LA05_N"
#set_property PACKAGE_PIN J18 [get_ports {FMC_LA05_P}];  # "FMC-LA05_P"
#set_property PACKAGE_PIN L22 [get_ports {FMC_LA06_N}];  # "FMC-LA06_N"
#set_property PACKAGE_PIN L21 [get_ports {FMC_LA06_P}];  # "FMC-LA06_P"
#set_property PACKAGE_PIN T17 [get_ports {FMC_LA07_N}];  # "FMC-LA07_N"
#set_property PACKAGE_PIN T16 [get_ports {FMC_LA07_P}];  # "FMC-LA07_P"
#set_property PACKAGE_PIN J22 [get_ports {FMC_LA08_N}];  # "FMC-LA08_N"
#set_property PACKAGE_PIN J21 [get_ports {FMC_LA08_P}];  # "FMC-LA08_P"
#set_property PACKAGE_PIN R21 [get_ports {FMC_LA09_N}];  # "FMC-LA09_N"
#set_property PACKAGE_PIN R20 [get_ports {FMC_LA09_P}];  # "FMC-LA09_P"
#set_property PACKAGE_PIN T19 [get_ports {FMC_LA10_N}];  # "FMC-LA10_N"
#set_property PACKAGE_PIN R19 [get_ports {FMC_LA10_P}];  # "FMC-LA10_P"
#set_property PACKAGE_PIN N18 [get_ports {FMC_LA11_N}];  # "FMC-LA11_N"
#set_property PACKAGE_PIN N17 [get_ports {FMC_LA11_P}];  # "FMC-LA11_P"
#set_property PACKAGE_PIN P21 [get_ports {FMC_LA12_N}];  # "FMC-LA12_N"
#set_property PACKAGE_PIN P20 [get_ports {FMC_LA12_P}];  # "FMC-LA12_P"
#set_property PACKAGE_PIN M17 [get_ports {FMC_LA13_N}];  # "FMC-LA13_N"
#set_property PACKAGE_PIN L17 [get_ports {FMC_LA13_P}];  # "FMC-LA13_P"
#set_property PACKAGE_PIN K20 [get_ports {FMC_LA14_N}];  # "FMC-LA14_N"
#set_property PACKAGE_PIN K19 [get_ports {FMC_LA14_P}];  # "FMC-LA14_P"
#set_property PACKAGE_PIN J17 [get_ports {FMC_LA15_N}];  # "FMC-LA15_N"
#set_property PACKAGE_PIN J16 [get_ports {FMC_LA15_P}];  # "FMC-LA15_P"
#set_property PACKAGE_PIN K21 [get_ports {FMC_LA16_N}];  # "FMC-LA16_N"
#set_property PACKAGE_PIN J20 [get_ports {FMC_LA16_P}];  # "FMC-LA16_P"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN C19 [get_ports {FMC_CLK1_N}];  # "FMC-CLK1_N"
#set_property PACKAGE_PIN D18 [get_ports {FMC_CLK1_P}];  # "FMC-CLK1_P"
#set_property PACKAGE_PIN B20 [get_ports {FMC_LA17_CC_N}];  # "FMC-LA17_CC_N"
#set_property PACKAGE_PIN B19 [get_ports {FMC_LA17_CC_P}];  # "FMC-LA17_CC_P"
#set_property PACKAGE_PIN C20 [get_ports {FMC_LA18_CC_N}];  # "FMC-LA18_CC_N"
#set_property PACKAGE_PIN D20 [get_ports {FMC_LA18_CC_P}];  # "FMC-LA18_CC_P"
#set_property PACKAGE_PIN G16 [get_ports {FMC_LA19_N}];  # "FMC-LA19_N"
#set_property PACKAGE_PIN G15 [get_ports {FMC_LA19_P}];  # "FMC-LA19_P"
#set_property PACKAGE_PIN G21 [get_ports {FMC_LA20_N}];  # "FMC-LA20_N"
#set_property PACKAGE_PIN G20 [get_ports {FMC_LA20_P}];  # "FMC-LA20_P"
#set_property PACKAGE_PIN E20 [get_ports {FMC_LA21_N}];  # "FMC-LA21_N"
#set_property PACKAGE_PIN E19 [get_ports {FMC_LA21_P}];  # "FMC-LA21_P"
#set_property PACKAGE_PIN F19 [get_ports {FMC_LA22_N}];  # "FMC-LA22_N"
#set_property PACKAGE_PIN G19 [get_ports {FMC_LA22_P}];  # "FMC-LA22_P"
#set_property PACKAGE_PIN D15 [get_ports {FMC_LA23_N}];  # "FMC-LA23_N"
#set_property PACKAGE_PIN E15 [get_ports {FMC_LA23_P}];  # "FMC-LA23_P"
#set_property PACKAGE_PIN A19 [get_ports {FMC_LA24_N}];  # "FMC-LA24_N"
#set_property PACKAGE_PIN A18 [get_ports {FMC_LA24_P}];  # "FMC-LA24_P"
#set_property PACKAGE_PIN C22 [get_ports {FMC_LA25_N}];  # "FMC-LA25_N"
#set_property PACKAGE_PIN D22 [get_ports {FMC_LA25_P}];  # "FMC-LA25_P"
#set_property PACKAGE_PIN E18 [get_ports {FMC_LA26_N}];  # "FMC-LA26_N"
#set_property PACKAGE_PIN F18 [get_ports {FMC_LA26_P}];  # "FMC-LA26_P"
#set_property PACKAGE_PIN D21 [get_ports {FMC_LA27_N}];  # "FMC-LA27_N"
#set_property PACKAGE_PIN E21 [get_ports {FMC_LA27_P}];  # "FMC-LA27_P"
#set_property PACKAGE_PIN A17 [get_ports {FMC_LA28_N}];  # "FMC-LA28_N"
#set_property PACKAGE_PIN A16 [get_ports {FMC_LA28_P}];  # "FMC-LA28_P"
#set_property PACKAGE_PIN C18 [get_ports {FMC_LA29_N}];  # "FMC-LA29_N"
#set_property PACKAGE_PIN C17 [get_ports {FMC_LA29_P}];  # "FMC-LA29_P"
#set_property PACKAGE_PIN B15 [get_ports {FMC_LA30_N}];  # "FMC-LA30_N"
#set_property PACKAGE_PIN C15 [get_ports {FMC_LA30_P}];  # "FMC-LA30_P"
#set_property PACKAGE_PIN B17 [get_ports {FMC_LA31_N}];  # "FMC-LA31_N"
#set_property PACKAGE_PIN B16 [get_ports {FMC_LA31_P}];  # "FMC-LA31_P"
#set_property PACKAGE_PIN A22 [get_ports {FMC_LA32_N}];  # "FMC-LA32_N"
#set_property PACKAGE_PIN A21 [get_ports {FMC_LA32_P}];  # "FMC-LA32_P"
#set_property PACKAGE_PIN B22 [get_ports {FMC_LA33_N}];  # "FMC-LA33_N"
#set_property PACKAGE_PIN B21 [get_ports {FMC_LA33_P}];  # "FMC-LA33_P"


# ----------------------------------------------------------------------------
# IOSTANDARD Constraints
#
# Note that these IOSTANDARD constraints are applied to all IOs currently
# assigned within an I/O bank.  If these IOSTANDARD constraints are
# evaluated prior to other PACKAGE_PIN constraints being applied, then
# the IOSTANDARD specified will likely not be applied properly to those
# pins.  Therefore, bank wide IOSTANDARD constraints should be placed
# within the XDC file in a location that is evaluated AFTER all
# PACKAGE_PIN constraints within the target bank have been evaluated.
#
# Un-comment one or more of the following IOSTANDARD constraints according to
# the bank pin assignments that are required within a design.
# ----------------------------------------------------------------------------

# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]]

# Set the bank voltage for IO Bank 34 to 1.8V by default. FMC
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 34]]
#set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

# Set the bank voltage for IO Bank 35 to 1.8V by default. FMC
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 35]]
#set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]]





