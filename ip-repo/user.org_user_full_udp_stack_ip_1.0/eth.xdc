# Ethernet constraints

# IDELAY on RGMII from PHY chip
set_property IDELAY_VALUE 0 [get_cells {phy_rx_ctl_idelay phy_rxd_idelay_*}]

#set_property ODELAY_VALUE 0 [get_cells {phy_tx_ctl_idelay}]

#set_property ODELAY_VALUE 16 [get_cells {phy_txd_idelay_*}]

