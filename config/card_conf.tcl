# card_conf.tcl: Default parameters for XpressSX AGI-FH400G
# Copyright (C) 2022 CESNET z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
# 			 Vladislav Valek <valekv@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# NOTE: For the detailed description of this file, visit the Configuration section
# in the documentation of the NDK-CORE repository.
#
# Mandatory project parameters
set PROJECT_NAME ""

# ------------------------------------------------------------------------------
# PCIe parameters (not all combinations work):
# ------------------------------------------------------------------------------
# Supported combinations for this card:
# 1x PCIe Gen5 x8x8 -- PCIE_GEN=5, PCIE_ENDPOINTS=2, PCIE_ENDPOINT_MODE=1
# 2x PCIe Gen4 x8x8 -- PCIE_GEN=4, PCIE_ENDPOINTS=4, PCIE_ENDPOINT_MODE=1 (Note: default configuration)
# 1x PCIe Gen4 x8x8 -- PCIE_GEN=4, PCIE_ENDPOINTS=2, PCIE_ENDPOINT_MODE=1 (Note: limited DMA performance)
# ------------------------------------------------------------------------------
# PCIe Generation (possible values: 4, 5):
# 4 = PCIe Gen4 (Stratix 10 with P-Tile or Agilex)
# 5 = PCIe Gen5 (Agilex with R-Tile)
set PCIE_GEN           4
# PCIe endpoints (possible values: 2, 4):
# 2 = 2x PCIe x16 in two slot OR 2x PCIe x8 in one slot (bifurcation x8+x8)
# 4 = 4x PCIe x8 in two slots (bifurcation x8+x8)
set PCIE_ENDPOINTS     4
# PCIe endpoint mode (possible values: 1):
# 1 = 2x8 lanes (bifurcation x8+x8)
set PCIE_ENDPOINT_MODE 1


# ------------------------------------------------------------------------------
# DMA parameters:
# ------------------------------------------------------------------------------
# The minimum number of RX/TX DMA channels for this card is 32.
set DMA_RX_CHANNELS      32
set DMA_TX_CHANNELS      32
# In blocking mode, packets are dropped only when the RX DMA channel is off.
# In non-blocking mode, packets are dropped whenever they cannot be sent.
set DMA_RX_BLOCKING_MODE true


# ------------------------------------------------------------------------------
# DDR4 parameters:
# ------------------------------------------------------------------------------
set MEM_PORTS 2


# ------------------------------------------------------------------------------
# Other parameters:
# ------------------------------------------------------------------------------
set TSU_ENABLE false

set TEST_FW_PCIE1_ONBOARD_DDR4 false

