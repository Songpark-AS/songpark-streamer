################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name phy_rx_clk_0 -period 8 [get_ports phy_rx_clk_0]
create_clock -name clk_100_in -period 10 [get_ports clk_100_in]
create_clock -name processing_system7_0_FCLK_CLK0 -period 10 [get_pins processing_system7_0/FCLK_CLK0]
create_clock -name processing_system7_0_FCLK_CLK1 -period 11 [get_pins processing_system7_0/FCLK_CLK1]
create_clock -name processing_system7_0_FCLK_CLK2 -period 8 [get_pins processing_system7_0/FCLK_CLK2]
create_clock -name processing_system7_0_FCLK_CLK3 -period 5 [get_pins processing_system7_0/FCLK_CLK3]

################################################################################