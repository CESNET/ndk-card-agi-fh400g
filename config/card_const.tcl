# card_const.tcl: Card specific parameters for XpressSX AGI-FH400G
# Copyright (C) 2022 CESNET, z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
# 			 Vladislav Valek <valekv@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# WARNING: The user should not deliberately change parameters in this file or
# change the order of file sourcing. For the description of this file, visit the
# configuration section in the documentation of the NDK-CORE repostiory

set CARD_NAME "COMBO-400G1"
# Achitecture of Clock generator
set CLOCK_GEN_ARCH "INTEL"
# Achitecture of PCIe module
set PCIE_MOD_ARCH "R_TILE"
# Achitecture of Network module
set NET_MOD_ARCH "F_TILE"
# Achitecture of SDM/SYSMON module
set SDM_SYSMON_ARCH "INTEL_SDM"

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

VhdlPkgBool TEST_FW_PCIE1_ONBOARD_DDR4 $TEST_FW_PCIE1_ONBOARD_DDR4
