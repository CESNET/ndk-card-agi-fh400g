# Quartus.inc.tcl: Quartus.tcl include for XpressSX AGI-FH400G
# Copyright (C) 2021 CESNET z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
#

# NDK constants (populates all NDK variables from env)
source $env(NDK_CONST)

# Include card common script
source $CARD_COMMON_BASE/Quartus.inc.tcl

# Main component
lappend HIERARCHY(COMPONENTS) \
    [list "TOPLEVEL" $CARD_BASE/src "FULL"]

# Design parameters
set SYNTH_FLAGS(MODULE) "FPGA"
set SYNTH_FLAGS(FPGA)   "AGIB027R29A1E2VR0"
# Enable Quartus Support-Logic Generation stage
set SYNTH_FLAGS(QUARTUS_TLG) 1

# QSF constraints for specific parts of the design
set SYNTH_FLAGS(CONSTR) ""
set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/timing.sdc"
set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/sodimm.qsf"
set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/hps.qsf"
set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/pcie_misc.qsf"
set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/pcie0.qsf"
set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/qsfp_misc.qsf"
set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/general.qsf"

if {$PCIE_ENDPOINT_MODE == 1} {
    set PCIE_HIPS [expr $PCIE_ENDPOINTS/2]
} else {
    set PCIE_HIPS $PCIE_ENDPOINTS
}

if {$PCIE_HIPS == 2} {
    set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/pcie1.qsf"
} else {
    set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/pcie1_virtual.qsf"
}

if {$ETH_ENABLE} {
    set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/qsfp.qsf"
} else {
    set SYNTH_FLAGS(CONSTR) "$SYNTH_FLAGS(CONSTR) $CARD_BASE/constr/qsfp_virtual.qsf"
}
