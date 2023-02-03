# Modules.tcl: script to compile XpressSX AGI-FH400G
# Copyright (C) 2022 CESNET z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# converting input list to associative array
array set ARCHGRP_ARR $ARCHGRP

# Paths
set BOOT_CTRL_BASE "$OFM_PATH/../core/intel/src/comp/boot_ctrl"

# Components
lappend COMPONENTS [list "FPGA_COMMON" $ARCHGRP_ARR(CORE_BASE)  $ARCHGRP]
lappend COMPONENTS [list "BOOT_CTRL"   $BOOT_CTRL_BASE          "FULL"]

# IP sources
set MOD "$MOD $ENTITY_BASE/ip/iopll_ip.ip"
set MOD "$MOD $ENTITY_BASE/ip/reset_release_ip.ip"
set MOD "$MOD $ENTITY_BASE/ip/rtile_pcie_2x8.ip"
set MOD "$MOD $ENTITY_BASE/ip/sodimm.ip"
set MOD "$MOD $ENTITY_BASE/ip/sodimm_cal.ip"
set MOD "$MOD $ENTITY_BASE/ip/OnBoard_DDR4.ip"
set MOD "$MOD $ENTITY_BASE/ip/emif_agi027_cal.ip"
set MOD "$MOD $ENTITY_BASE/ip/mailbox_client_ip.ip"

if {$ARCHGRP_ARR(NET_MOD_ARCH) == "F_TILE"} {
    if {$ARCHGRP_ARR(ETH_PORT_SPEED,0) == 400} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_1x400g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_1x400g.ip"
    }
    if {$ARCHGRP_ARR(ETH_PORT_SPEED,0) == 200} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_2x200g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_2x200g.ip"
    }
    if {$ARCHGRP_ARR(ETH_PORT_SPEED,0) == 100} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_4x100g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_2x100g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_4x100g.ip"
    }
    if {$ARCHGRP_ARR(ETH_PORT_SPEED,0) == 50} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_8x50g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_8x50g.ip"
    }
    if {$ARCHGRP_ARR(ETH_PORT_SPEED,0) == 40} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_2x40g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_2x40g.ip"
    }
    if {$ARCHGRP_ARR(ETH_PORT_SPEED,0) == 25} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_8x25g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_8x25g.ip"
    }
    if {$ARCHGRP_ARR(ETH_PORT_SPEED,0) == 10} {
        set MOD "$MOD $ENTITY_BASE/ip/ftile_pll_8x10g.ip"
        set MOD "$MOD $ENTITY_BASE/ip/ftile_eth_8x10g.ip"
    }
}

# Top-level
set MOD "$MOD $OFM_PATH/comp/ctrls/flash/flashctrl.vhd"
set MOD "$MOD $ENTITY_BASE/fpga.vhd"
