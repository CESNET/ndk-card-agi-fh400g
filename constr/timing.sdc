# timing.sdc: Timing constraints
# Copyright (C) 2022 CESNET z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

derive_clock_uncertainty

create_clock -name {altera_reserved_tck} -period 41.667 [get_ports { altera_reserved_tck }]

create_clock -name {AG_SYSCLK0} -period 10.000 [get_ports { AG_SYSCLK0_P }]
create_clock -name {AG_SYSCLK1} -period 10.000 [get_ports { AG_SYSCLK1_P }]

create_clock -name {PCIE0_CLK0} -period 10.000 [get_ports { PCIE0_CLK0_P }]
create_clock -name {PCIE0_CLK1} -period 10.000 [get_ports { PCIE0_CLK1_P }]
create_clock -name {PCIE1_CLK0} -period 10.000 [get_ports { PCIE1_CLK0_P }]
create_clock -name {PCIE1_CLK1} -period 10.000 [get_ports { PCIE1_CLK1_P }]
#create_clock -name {PCIE2_CLK0} -period 10.000 [get_ports { PCIE2_CLK0_P }]
#create_clock -name {PCIE2_CLK1} -period 10.000 [get_ports { PCIE2_CLK1_P }]
create_clock -name {QSFP_REFCLK_P} -period 6.400 [get_ports { QSFP_REFCLK_P }]

# Cut (set_false_path) this JTAG clock from all other clocks in the design
set_clock_groups -asynchronous -group [get_clocks altera_reserved_tck]

set MI_CLK [get_clocks ag_i|clk_gen_i|iopll_i|iopll_0_outclk3]
set FHIP_400G_CLK [get_clocks ag_i|network_mod_i|eth_core_g[0].network_mod_core_i|eth_port_mode_sel_g.ftile_eth_ip_i|eth_f_0|tx_clkout|ch23]
set FHIP_100G_CLK [get_clocks ag_i|network_mod_i|eth_core_g[0].network_mod_core_i|eth_port_mode_sel_g.eth_ftile_g[0].ftile_eth_ip_i|eth_f_0|tx_clkout|ch23]

# Fix hold timing issues on FHIP
set_clock_groups -asynchronous -group $MI_CLK -group $FHIP_400G_CLK
set_clock_groups -asynchronous -group $MI_CLK -group $FHIP_100G_CLK
