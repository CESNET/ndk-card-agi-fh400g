# ndk_const.tcl: Base parameters for XpressSX AGI-FH400G
# Copyright (C) 2021 CESNET, z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

set OFM_PATH        $env(OFM_PATH)
set FIRMWARE_BASE   $env(FIRMWARE_BASE)
set COMBO_BASE      $env(COMBO_BASE)
set CARD_BASE       $env(CARD_BASE)
set NDK_CONST       $env(NDK_CONST)
set DEFAULT_CONST   $env(DEFAULT_CONST)
set USER_CONST      $env(USER_CONST)
set OUTPUT_NAME     $env(OUTPUT_NAME)

set CARD_COMMON_BASE $COMBO_BASE/ndk/core/intel

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

# Source default constants
source $DEFAULT_CONST

# Source application constants if they exists
if {$USER_CONST ne ""} {
	source $USER_CONST
}

# Source common core const scripts
source $CARD_COMMON_BASE/config/ndk_const.tcl

VhdlPkgBool TEST_FW_PCIE1_ONBOARD_DDR4 $TEST_FW_PCIE1_ONBOARD_DDR4
