# card_const.tcl: Card specific parameters for XpressSX AGI-FH400G
# Copyright (C) 2022 CESNET, z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
# 			 Vladislav Valek <valekv@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# WARNING: The user should not deliberately change parameters in this file or
# change the order of file sourcing. For the description of this file, visit the
# configuration section in the documentation of the NDK-CORE repostiory

set OUTPUT_NAME     $env(OUTPUT_NAME)
set OFM_PATH        $env(OFM_PATH)
set COMBO_BASE      $env(COMBO_BASE)
set FIRMWARE_BASE   $env(FIRMWARE_BASE)
set CARD_BASE       $env(CARD_BASE)
set CORE_BASE		$env(CORE_BASE)

set CORE_CONF  $CORE_BASE/config/core_conf.tcl
set CORE_CONST $CORE_BASE/config/core_const.tcl

set CARD_CONF  $env(CARD_CONF)
set CARD_CONST $env(CARD_CONST)

set APP_CONF $env(APP_CONF)

source $OFM_PATH/build/VhdlPkgGen.tcl
source $OFM_PATH/build/Shared.tcl

set CARD_NAME "COMBO-400G1"
# Achitecture of Clock generator
set CLOCK_GEN_ARCH "INTEL"
# Achitecture of PCIe module
set PCIE_MOD_ARCH "R_TILE"
# Achitecture of Network module
set NET_MOD_ARCH "F_TILE"
# Achitecture of SDM/SYSMON module
set SDM_SYSMON_ARCH "INTEL_SDM"

VhdlPkgBegin

# Source CORE user configurable parameters
source $CORE_CONF

# Source card specific user configurable parameters
source $CARD_CONF

# Source application user configurable parameters
if {$APP_CONF ne ""} {
	source $APP_CONF
}

# ==============================================================================
# Card specific parameters (development only)
# ==============================================================================

# ------------------------------------------------------------------------------
# ETH parameters:
# ------------------------------------------------------------------------------
# Number of Ethernet ports, must match number of items in list ETH_PORTS_SPEED !
set ETH_PORTS          1
# Speed for each one of the ETH_PORTS (allowed values: 400, 200, 100, 50, 40, 25, 10)
# ETH_PORT_SPEED is an array where each index represents given ETH_PORT and
# each index has associated a required port speed.
# NOTE: at this moment, all ports must have same speed !
set ETH_PORT_SPEED(0)  $env(ETH_PORT_SPEED)
# Number of channels for each one of the ETH_PORTS (allowed values: 1, 2, 4, 8)
# ETH_PORT_CHAN is an array where each index represents given ETH_PORT and
# each index has associated a required number of channels this port has.
# NOTE: at this moment, all ports must have same number of channels !
set ETH_PORT_CHAN(0)   $env(ETH_PORT_CHAN)
# Number of lanes for each one of the ETH_PORTS
# Typical values: 4 (QSFP), 8 (QSFP-DD)
set ETH_PORT_LANES(0)  8
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# DMA parameters:
# ------------------------------------------------------------------------------
# This variable can be set in COREs *.mk file or as a parameter when launching the make
set DMA_TYPE    $env(DMA_TYPE)

# ------------------------------------------------------------------------------
# Other parameters:
# ------------------------------------------------------------------------------
if {$TEST_FW_PCIE1_ONBOARD_DDR4} {
	set MEM_PORTS 1
}

# ==============================================================================

# Generating the VHDL package
source $CORE_CONST

VhdlPkgBool TEST_FW_PCIE1_ONBOARD_DDR4 $TEST_FW_PCIE1_ONBOARD_DDR4
