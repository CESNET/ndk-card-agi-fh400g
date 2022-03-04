# timing.sdc: Timing constraints
# Copyright (C) 2019 CESNET z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
#

derive_clock_uncertainty

# ==============================================================================
# Create Clock constraints
# ==============================================================================

#create_clock -name {altera_reserved_tck} -period 41.667 [get_ports { altera_reserved_tck }]
#set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}]

create_clock -name {AG_SYSCLK0} -period 10.000 -waveform { 0.000 5.000 } [get_ports { AG_SYSCLK0_P }]
create_clock -name {AG_SYSCLK1} -period 10.000 -waveform { 0.000 5.000 } [get_ports { AG_SYSCLK1_P }]

#create_clock -name {PCIE0_CLK0} -period "100MHz" [get_ports { PCIE0_CLK0_P }]
#create_clock -name {PCIE0_CLK1} -period "100MHz" [get_ports { PCIE0_CLK1_P }]
#create_clock -name {PCIE1_CLK0} -period "100MHz" [get_ports { PCIE1_CLK0_P }]
#create_clock -name {PCIE1_CLK1} -period "100MHz" [get_ports { PCIE1_CLK1_P }]
#create_clock -name {PCIE2_CLK0} -period "100MHz" [get_ports { PCIE2_CLK0_P }]
#create_clock -name {PCIE2_CLK1} -period "100MHz" [get_ports { PCIE2_CLK1_P }]
#create_clock -name {QSFP_REFCLK_P} -period "644.53125MHz" [get_ports { QSFP_REFCLK_P }]

set MI_CLK [get_clocks ag_i|s10_iopll_ip|iopll_0_outclk3]
set FHIP_TX_CLK [get_clocks ag_i|network_mod_i|eth_core_g[0].network_mod_core_i|eth_port_mode_sel_g.eth_ftile_g[0].ftile_eth_ip_i|eth_f_0|tx_clkout|ch23]

# Fix hold timing issues on FHIP
set_clock_groups -asynchronous -group $MI_CLK -group $FHIP_TX_CLK
