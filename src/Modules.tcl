# Modules.tcl: script to compile XpressSX AGI-FH400G
# Copyright (C) 2021 CESNET z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
#

# Globally defined variables
global CARD_COMMON_BASE
global NET_MOD_ARCH
global ETH_PORT_SPEED
global BOARD
set BOARD "400G1"

set COMPONENTS [list [list "FPGA_COMMON" $CARD_COMMON_BASE $BOARD]]

# IP sources
set MOD "$MOD $ENTITY_BASE/ip/iopll_ip.ip"
set MOD "$MOD $ENTITY_BASE/ip/reset_release_ip.ip"
set MOD "$MOD $ENTITY_BASE/ip/rtile_pcie_2x8.ip"
set MOD "$MOD $ENTITY_BASE/ip/sodimm.ip"
set MOD "$MOD $ENTITY_BASE/ip/sodimm_cal.ip"
set MOD "$MOD $ENTITY_BASE/ip/OnBoard_DDR4.ip"
set MOD "$MOD $ENTITY_BASE/ip/emif_agi027_cal.ip"

if {$NET_MOD_ARCH == "F_TILE"} {
    if {$ETH_PORT_SPEED(0) == 400} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_1x400g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_1x400g.ip"
    }
    if {$ETH_PORT_SPEED(0) == 200} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_2x200g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_2x200g.ip"
    }
    if {$ETH_PORT_SPEED(0) == 100} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_4x100g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_4x100g.ip"
    }
    if {$ETH_PORT_SPEED(0) == 50} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_8x50g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_8x50g.ip"
    }
    if {$ETH_PORT_SPEED(0) == 40} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_2x40g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_2x40g.ip"
    }
    if {$ETH_PORT_SPEED(0) == 25} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_8x25g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_8x25g.ip"
    }
    if {$ETH_PORT_SPEED(0) == 10} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_8x10g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_8x10g.ip"
    }
}

# Top-level
set MOD "$MOD $OFM_PATH/comp/ctrls/flash/flashctrl.vhd"
set MOD "$MOD $ENTITY_BASE/fpga.vhd"
