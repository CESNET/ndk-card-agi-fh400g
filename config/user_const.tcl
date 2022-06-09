# user_const.tcl: Default parameters for XpressSX AGI-FH400G
# Copyright (C) 2019 CESNET z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
#

# Source default common values
source $CARD_COMMON_BASE/config/user_const.tcl

# Mandatory project parameters
set PROJECT_NAME ""

# User-defined generics
set USER_GENERIC0 0
set USER_GENERIC1 0
set USER_GENERIC2 0
set USER_GENERIC3 0

# ETH parameters:
# ===============
set ETH_ENABLE         true
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

# ==============================================================================
# PCIe parameters (not all combinations work):
# ==============================================================================
# Supported combinations for this card:
# 1x PCIe Gen5 x8x8 -- PCIE_GEN=5, PCIE_ENDPOINTS=2, PCIE_ENDPOINT_MODE=1
# 2x PCIe Gen4 x8x8 -- PCIE_GEN=4, PCIE_ENDPOINTS=4, PCIE_ENDPOINT_MODE=1 (Note: default configuration)
# 1x PCIe Gen4 x8x8 -- PCIE_GEN=4, PCIE_ENDPOINTS=2, PCIE_ENDPOINT_MODE=1 (Note: limited DMA performance)
# ------------------------------------------------------------------------------
# PCIe Generation (possible values: 3, 4, 5):
# 3 = PCIe Gen3
# 4 = PCIe Gen4 (Stratix 10 with P-Tile or Agilex)
# 5 = PCIe Gen5 (Agilex with R-Tile)
set PCIE_GEN           4
# PCIe endpoints (possible values: 1, 2, 4):
# 1 = 1x PCIe x16 in one slot
# 2 = 2x PCIe x16 in two slot OR 2x PCIe x8 in one slot (bifurcation x8+x8)
# 4 = 4x PCIe x8 in two slots (bifurcation x8+x8)
set PCIE_ENDPOINTS     4
# PCIe endpoint mode (possible values: 0, 1):
# 0 = 1x16 lanes
# 1 = 2x8 lanes (bifurcation x8+x8)
set PCIE_ENDPOINT_MODE 1
# ------------------------------------------------------------------------------

# ==============================================================================
# DMA parameters:
# ==============================================================================
# If you do not have access to a non-public repository with DMA IP, set to false.
# If the DMA module is disabled, loopback will be implemented instead.
set DMA_ENABLE           true
# The minimum number of RX/TX DMA channels for this card is 32.
set DMA_RX_CHANNELS      32
set DMA_TX_CHANNELS      32
# In blocking mode, packets are dropped only when the RX DMA channel is off.
# In non-blocking mode, packets are dropped whenever they cannot be sent.
set DMA_RX_BLOCKING_MODE true
# ------------------------------------------------------------------------------

# DDR4 parameters:
# ===============
set MEM_PORTS 2

# Other parameters:
# =================
set TSU_ENABLE false

set TEST_FW_PCIE1_ONBOARD_DDR4 false
if {$TEST_FW_PCIE1_ONBOARD_DDR4} {
	set MEM_PORTS 1
}
