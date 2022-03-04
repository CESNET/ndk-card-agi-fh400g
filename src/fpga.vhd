-- fpga.vhd: 400G1 board top level entity and architecture
-- Copyright (C) 2020 CESNET z. s. p. o.
-- Author(s): Jakub Cabal <cabal@cesnet.cz>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.combo_const.all;
use work.combo_user_const.all;

use work.math_pack.all;
use work.type_pack.all;
use work.dma_bus_pack.all;

entity FPGA is
port (
    -- =========================================================================
    --  GENERAL INTERFACES
    -- =========================================================================
    -- HW ID pins
    HW_ID            : in    std_logic_vector(3 downto 0);
    -- User LEDs
    AG_LED_G         : out   std_logic_vector(1 downto 0);
    AG_LED_R         : out   std_logic_vector(1 downto 0);
    -- I2C interface (access to I2C peripherals from FPGA)
    AG_I2C_SCLK      : inout std_logic;
    AG_I2C_SDA       : inout std_logic;

    -- =========================================================================
    --  GENERAL CLOCKS AND PLL STATUS SIGNALS
    -- =========================================================================
    -- External differential clocks (programmable via Ext. PLL)
    AG_SYSCLK0_P     : in    std_logic;
    AG_SYSCLK1_P     : in    std_logic;
    -- External PLL status
    AG_CLK_INT_N     : in    std_logic; -- indicates a change of LOL
    AG_CLK_GEN_LOL_N : in    std_logic; -- Loss Of Lock
    -- External 1PPS clock input
    AG_EXT_SYNC_1HZ  : in    std_logic;

    -- =========================================================================
    --  GENERAL RESETS
    -- =========================================================================
    AG_DEV_POR_N     : in    std_logic; -- Card Power on Reset status
    AG_RST_N         : in    std_logic; -- Card Reset status
    AG_SOFT_RST      : out   std_logic; -- Card Soft Reset request
    AG_M10_RST_N     : out   std_logic; -- MAX10 Reset request

    -- =========================================================================
    --  MAX10 CONFIGURATION INTERFACE
    -- =========================================================================
    -- Agilex can controlled MAX10 booting or reconfiguration
    AG_M10_IMG_SEL_N : out   std_logic; -- MAX10 image selection
    AG_M10_REBOOT    : out   std_logic; -- MAX10 reboot request
    M10_AG_STATUS_N  : in    std_logic; -- MAX10 status
    M10_AG_DONE      : in    std_logic; -- MAX10 configuration done
        
    -- =========================================================================
    --  AGILEX CONFIGURATION REUEST INTERFACE
    -- =========================================================================
    -- Agilex can requested FPGA reboot via MAX10
    AG_CFG_IMG_SEL   : out   std_logic;	-- Agilex image selection
    AG_REQ_CONF_N    : out   std_logic; -- Agilex configuration reuest

    -- =========================================================================
    --  FLASH INTERFACE (disable for now, QSPI flash used by default)
    -- =========================================================================
    --FLASH_A                 : out   std_logic_vector(26 downto 0); -- Memory Address bus
    --FLASH_D                 : inout std_logic_vector(15 downto 0); -- Memory Data bus
    --FLASH_CE0_N             : out   std_logic;                     -- Memory 0 Chip Enable (active is LOW)
    --FLASH_CE1_N             : out   std_logic;                     -- Memory 0 Chip Enable (active is LOW)
    --FLASH_OE_N              : out   std_logic;                     -- Memory Output Enable (both, active is LOW)
    --FLASH_WE_N              : out   std_logic;                     -- Memory Write Enable (both, active is LOW)
    --FLASH_RY_BY_N           : in    std_logic;                     -- Memory Ready/busy signal (both)
    --FLASH_BYTE_N            : out   std_logic;                     -- Memory data bus width (8bits for both, active is LOW)
    --FLASH_WP_N              : out   std_logic;                     -- Memory data Write protect signal (for both, active is LOW)
    --FLASH_RST_N             : out   std_logic;                     -- Memory reset signal (for both, active is LOW)     

    -- =========================================================================
    --  PCIE INTERFACES
    -- =========================================================================
    -- PCIe global
    PCIE_WAKE               : out   std_logic;
    PCIE_CLKREQ             : out   std_logic;
    -- External PCIe clock selection: 1 = PCIe is slave,
    --                                0 = PCIe is master (card interconnection)
    PCIE1_CLK_SEL_N         : out   std_logic;
    PCIE2_CLK_SEL_N         : out   std_logic;
    -- PCIe0 (Edge Connector)
    PCIE0_CLK0_P            : in    std_logic;
    PCIE0_CLK1_P            : in    std_logic;
    PCIE0_PERST_N           : in    std_logic;
    PCIE0_RX_P              : in    std_logic_vector(15 downto 0);
    PCIE0_RX_N              : in    std_logic_vector(15 downto 0);
    PCIE0_TX_P              : out   std_logic_vector(15 downto 0);
    PCIE0_TX_N              : out   std_logic_vector(15 downto 0);
    -- PCIe1 (External Connector or card interconnection)
    PCIE1_CLK0_P            : in    std_logic;
    PCIE1_CLK1_P            : in    std_logic;
    PCIE1_PERST_N           : in    std_logic;
    PCIE1_RX_P              : in    std_logic_vector(15 downto 0);
    PCIE1_RX_N              : in    std_logic_vector(15 downto 0);
    PCIE1_TX_P              : out   std_logic_vector(15 downto 0);
    PCIE1_TX_N              : out   std_logic_vector(15 downto 0);
    -- PCIe2 (External Connector or card interconnection)
    --PCIE2_CLK0_P            : in    std_logic;
    --PCIE2_CLK1_P            : in    std_logic;
    --PCIE2_PERST_N           : in    std_logic;
    --PCIE2_RX_P              : in    std_logic_vector(15 downto 0);
    --PCIE2_RX_N              : in    std_logic_vector(15 downto 0);
    --PCIE2_TX_P              : out   std_logic_vector(15 downto 0);
    --PCIE2_TX_N              : out   std_logic_vector(15 downto 0);

    -- =========================================================================
    --  QSFP INTERFACES - F-TILE TODO!!!!!
    -- =========================================================================
    -- QSFP control
    QSFP_I2C_SCL            : inout std_logic;
    QSFP_I2C_SDA            : inout std_logic;
    QSFP_MODSEL_N           : out   std_logic;
    QSFP_LPMODE             : out   std_logic;
    QSFP_RESET_N            : out   std_logic;
    QSFP_MODPRS_N           : in    std_logic;
    QSFP_INT_N              : in    std_logic;
    QSFP_REFCLK0_P          : in    std_logic;
    --QSFP_REFCLK0_N          : in    std_logic;
    --QSFP_REFCLK1_P          : in    std_logic;
    --QSFP_REFCLK1_N          : in    std_logic;
    QSFP_RX_P               : in    std_logic_vector(7 downto 0);
    QSFP_RX_N               : in    std_logic_vector(7 downto 0);
    QSFP_TX_P               : out   std_logic_vector(7 downto 0);
    QSFP_TX_N               : out   std_logic_vector(7 downto 0);
    QSFP_LED_G              : out   std_logic_vector(7 downto 0);
    QSFP_LED_R              : out   std_logic_vector(7 downto 0)

    -- =========================================================================
    --  SODIMM INTERFACES (disable in first version)
    -- =========================================================================
    ---- SODIMM0 port
    --SODIMM0_REFCLK_P : in    std_logic;
    --SODIMM0_OCT_RZQ  : in    std_logic;
    --SODIMM0_PCK      : out   std_logic_vector(2-1 downto 0);
    --SODIMM0_NCK      : out   std_logic_vector(2-1 downto 0);
    --SODIMM0_A        : out   std_logic_vector(17-1 downto 0);
    --SODIMM0_NACT     : out   std_logic;
    --SODIMM0_BA       : out   std_logic_vector(2-1 downto 0);
    --SODIMM0_BG       : out   std_logic_vector(2-1 downto 0);
    --SODIMM0_CKE      : out   std_logic_vector(2-1 downto 0);
    --SODIMM0_NCS      : out   std_logic_vector(4-1 downto 0);
    --SODIMM0_ODT      : out   std_logic_vector(2-1 downto 0);
    --SODIMM0_NRST     : out   std_logic;
    --SODIMM0_PAR      : out   std_logic;
    --SODIMM0_NALERT   : in    std_logic;
    --SODIMM0_PDQS     : inout std_logic_vector(9-1 downto 0);
    --SODIMM0_NDQS     : inout std_logic_vector(9-1 downto 0);
    --SODIMM0_DM_DBI   : inout std_logic_vector(9-1 downto 0);
    --SODIMM0_DQ       : inout std_logic_vector(64-1 downto 0);
    --SODIMM0_CHKB     : inout std_logic_vector(8-1 downto 0);
    ---- SODIMM1 port
    --SODIMM1_REFCLK_P : in    std_logic;
    --SODIMM1_OCT_RZQ  : in    std_logic;
    --SODIMM1_PCK      : out   std_logic_vector(2-1 downto 0);
    --SODIMM1_NCK      : out   std_logic_vector(2-1 downto 0);
    --SODIMM1_A        : out   std_logic_vector(17-1 downto 0);
    --SODIMM1_NACT     : out   std_logic;
    --SODIMM1_BA       : out   std_logic_vector(2-1 downto 0);
    --SODIMM1_BG       : out   std_logic_vector(2-1 downto 0);
    --SODIMM1_CKE      : out   std_logic_vector(2-1 downto 0);
    --SODIMM1_NCS      : out   std_logic_vector(4-1 downto 0);
    --SODIMM1_ODT      : out   std_logic_vector(2-1 downto 0);
    --SODIMM1_NRST     : out   std_logic;
    --SODIMM1_PAR      : out   std_logic;
    --SODIMM1_NALERT   : in    std_logic;
    --SODIMM1_PDQS     : inout std_logic_vector(9-1 downto 0);
    --SODIMM1_NDQS     : inout std_logic_vector(9-1 downto 0);
    --SODIMM1_DM_DBI   : inout std_logic_vector(9-1 downto 0);
    --SODIMM1_DQ       : inout std_logic_vector(64-1 downto 0);
    --SODIMM1_CHKB     : inout std_logic_vector(8-1 downto 0);

    -- =========================================================================
    --  HPS (HARD PROCESSOR SYSTEM) INTERFACES (disable in first version)
    -- =========================================================================
    --HPS_CLK_100MHZ   : in    std_logic;
    ---- SD Card interface
    --HPS_MMC_CLK      : out   std_logic;
    --HPS_MMC_CMD      : inout std_logic;
    --HPS_MMC_DATA     : inout std_logic_vector(3 downto 0);
    ---- USB interface
    --HPS_USB_CLK      : in    std_logic;
    --HPS_USB_STP      : out   std_logic;
    --HPS_USB_DIR      : in    std_logic;
    --HPS_USB_NXT      : in    std_logic;
    --HPS_USB_DATA     : inout std_logic_vector(7 downto 0);
    ---- UART interface
    --HPS_UART_CTS     : in    std_logic;
    --HPS_UART_RTS     : out   std_logic;
    --HPS_UART_TXD     : out   std_logic;
    --HPS_UART_RXD     : in    std_logic;
    ---- I2C interface (access to I2C peripherals from HPS)
    --HPS_I2C1_SDA     : inout std_logic;
    --HPS_I2C1_SCL     : inout std_logic;
    ---- SPI interface (master) connected to MAX10
    --HPS_M10_SPI_MOSI : out   std_logic;
    --HPS_M10_SPI_MISO : in    std_logic;
    --HPS_M10_SPI_SS_N : out   std_logic;
    --HPS_M10_SPI_SCK  : out   std_logic;
    ---- General interface between HPS and MAX10
    --HPS_M10_RST_N    : inout std_logic; -- HPS reset request from MAX10
    --HPS_M10_INT_N    : inout std_logic; -- HPS interrupt request from MAX10
    --HPS_M10_ACK      : inout std_logic; -- Optional acknowledgment of an operation

    -- =========================================================================
    --  HPS (HARD PROCESSOR SYSTEM) - DDR4 INTERFACE (disable in first version)
    -- =========================================================================
    --HPS_DDR4_REFCLK_P : in    std_logic;
    --HPS_DDR4_OCT_RZQ  : in    std_logic;
    --HPS_DDR4_DQ       : inout std_logic_vector(64-1 downto 0);
    --HPS_DDR4_DSQ      : inout std_logic_vector(8-1 downto 0);
    --HPS_DDR4_DSQ_N    : inout std_logic_vector(8-1 downto 0);
    --HPS_DDR4_DBI_N    : inout std_logic_vector(8-1 downto 0);
    --HPS_DDR4_BA       : out   std_logic_vector(2-1 downto 0);
    --HPS_DDR4_BG       : out   std_logic_vector(1-1 downto 0);
    --HPS_DDR4_ADDR     : out   std_logic_vector(17-1 downto 0);
    --HPS_DDR4_ALERT_N  : in    std_logic;
    --HPS_DDR4_RST_N    : out   std_logic;
    --HPS_DDR4_CS_N     : out   std_logic;
    --HPS_DDR4_ACT_N    : out   std_logic;
    --HPS_DDR4_ODT_N    : out   std_logic;
    --HPS_DDR4_CKE      : out   std_logic;
    --HPS_DDR4_CK       : out   std_logic;
    --HPS_DDR4_CK_N     : out   std_logic;
    --HPS_DDR4_PAR      : out   std_logic
);
end entity;

architecture FULL of FPGA is

    constant PCIE_LANES                 : integer := 16;
    constant PCIE_CLKS                  : integer := 2;
    constant PCIE_CONS                  : integer := 2;
    constant MISC_IN_WIDTH              : integer := 8;
    constant MISC_OUT_WIDTH             : integer := 8;
    constant ETH_LANES                  : integer := 8;

begin

    AG_I2C_SCLK	<= 'Z';
    AG_I2C_SDA	<= 'Z';
    
    AG_SOFT_RST  <= '0';
    AG_M10_RST_N <= '1';

    AG_M10_IMG_SEL_N <= '1';
    AG_M10_REBOOT    <= '0';

    AG_CFG_IMG_SEL <= '0';
    AG_REQ_CONF_N  <= '1';

    PCIE_WAKE       <= '1';
    PCIE_CLKREQ     <= '1';
    PCIE1_CLK_SEL_N	<= '1';
    PCIE2_CLK_SEL_N	<= '1';

    ag_i : entity work.FPGA_COMMON
    generic map (
        PCIE_CONS               => PCIE_CONS,
        PCIE_LANES              => PCIE_LANES,
        PCIE_CLKS               => PCIE_CLKS,

        PCI_VENDOR_ID           => X"18EC",
        PCI_DEVICE_ID           => X"C400",
        PCI_SUBVENDOR_ID        => X"0000",
        PCI_SUBDEVICE_ID        => X"0000",
        
        ETH_PORTS               => ETH_PORTS,
        ETH_PORT_SPEED          => ETH_PORT_SPEED,
        ETH_PORT_CHAN           => ETH_PORT_CHAN,
        ETH_PORT_LEDS           => 8,
        ETH_LANES               => ETH_LANES,

        QSFP_PORTS              => ETH_PORTS,
        QSFP_I2C_PORTS          => ETH_PORTS,

        STATUS_LEDS             => 2,

        MISC_IN_WIDTH           => MISC_IN_WIDTH,
        MISC_OUT_WIDTH          => MISC_OUT_WIDTH,

        USER_GENERIC0           => USER_GENERIC0,
        USER_GENERIC1           => USER_GENERIC1,
        USER_GENERIC2           => USER_GENERIC2,
        USER_GENERIC3           => USER_GENERIC3,

        BOARD                   => "400G1",
        DEVICE                  => "AGILEX",

        PCIE_ENDPOINTS          => PCIE_ENDPOINTS,
        PCIE_ENDPOINT_TYPE      => "R_TILE",
        PCIE_ENDPOINT_MODE      => PCIE_ENDPOINT_MODE,

        DMA_ENDPOINTS           => tsel(PCIE_ENDPOINT_MODE=1,PCIE_ENDPOINTS,2*PCIE_ENDPOINTS),
        DMA_MODULES             => 1,
        DMA_RX_CHANNELS         => DMA_RX_CHANNELS,
        DMA_TX_CHANNELS         => DMA_TX_CHANNELS
    )
    port map(
        SYSCLK                  => AG_SYSCLK0_P,
        SYSRST                  => '0',

        PCIE_SYSCLK             => PCIE1_CLK1_P & PCIE1_CLK0_P & PCIE0_CLK1_P & PCIE0_CLK0_P,
        PCIE_SYSRST_N           => PCIE1_PERST_N & PCIE0_PERST_N,

        PCIE_RX_P(1*PCIE_LANES-1 downto 0*PCIE_LANES) => PCIE0_RX_P,
        PCIE_RX_P(2*PCIE_LANES-1 downto 1*PCIE_LANES) => PCIE1_RX_P,
        PCIE_RX_N(1*PCIE_LANES-1 downto 0*PCIE_LANES) => PCIE0_RX_N,
        PCIE_RX_N(2*PCIE_LANES-1 downto 1*PCIE_LANES) => PCIE1_RX_N,

        PCIE_TX_P(1*PCIE_LANES-1 downto 0*PCIE_LANES) => PCIE0_TX_P,
        PCIE_TX_P(2*PCIE_LANES-1 downto 1*PCIE_LANES) => PCIE1_TX_P,
        PCIE_TX_N(1*PCIE_LANES-1 downto 0*PCIE_LANES) => PCIE0_TX_N,
        PCIE_TX_N(2*PCIE_LANES-1 downto 1*PCIE_LANES) => PCIE1_TX_N,

        ETH_REFCLK_P(0)         => QSFP_REFCLK0_P,
        ETH_REFCLK_N(0)         => '0',
        ETH_RX_P                => QSFP_RX_P,
        ETH_RX_N                => QSFP_RX_N,
        ETH_TX_P                => QSFP_TX_P,
        ETH_TX_N                => QSFP_TX_N,

        ETH_LED_R               => QSFP_LED_R,
        ETH_LED_G               => QSFP_LED_G,

        QSFP_I2C_SCL(0)         => QSFP_I2C_SCL,
        QSFP_I2C_SDA(0)         => QSFP_I2C_SDA,

        QSFP_MODSEL_N(0)        => QSFP_MODSEL_N,
        QSFP_LPMODE(0)          => QSFP_LPMODE,
        QSFP_RESET_N(0)         => QSFP_RESET_N,
        QSFP_MODPRS_N(0)        => QSFP_MODPRS_N,
        QSFP_INT_N(0)           => QSFP_INT_N,

        STATUS_LED_G            => AG_LED_G,
        STATUS_LED_R            => AG_LED_R,

        MISC_IN                 => (others => '0'),
        MISC_OUT                => open
    );

end architecture;
