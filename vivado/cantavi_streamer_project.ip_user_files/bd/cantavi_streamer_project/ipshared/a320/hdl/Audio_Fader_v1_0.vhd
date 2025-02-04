library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Audio_Fader_v1_0 is
	generic (
		-- Users to add parameters here
		
                INTBIT_WIDTH  : integer := 24;
                FRACBIT_WIDTH : integer := 8; --now, its calculated below, in port mapping
		STEP_WIDTH			: integer := 32;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 5
	);
	port (
		-- Users to add ports here
                CLK_125    : in STD_LOGIC;
                OUT_VOLCTRL_L : out signed((24 - 1) downto 0) := (others => '0'); -- 24 bit signed output
                OUT_VOLCTRL_R : out signed((24 - 1) downto 0) := (others => '0'); -- 24 bit signed output
                OUT_RDY       : out STD_LOGIC;
        
                IN_SIG_L      : in  signed((24 - 1) downto 0); --amplifier input signal 24-bit
                IN_SIG_R      : in  signed((24 - 1) downto 0); --amplifier input signal 24-bit
                
		fade_enable_in    : in STD_LOGIC;
                new_sample_in    : in STD_LOGIC;
                replace_in_progress_in    : in STD_LOGIC;
		fade_direction_in    : in STD_LOGIC;
		fade_clear_in        : in STD_LOGIC;
		
		fade_max_in          : in STD_LOGIC;
		fade_min_in          : in STD_LOGIC;
		
		
                
--        IN_COEF_L     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
--		IN_COEF_R     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1        
        UP_STEP_PULSES	: in std_logic_vector(STEP_WIDTH-1 downto 0);
		DOWN_STEP_PULSES	: in std_logic_vector(STEP_WIDTH-1 downto 0);
		IN_COEF_MIN     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		IN_COEF_MAX     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		OUT_COEF     : out  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
        RST_IN        : in STD_LOGIC
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
--		s00_axi_aclk	: in std_logic;
--		s00_axi_aresetn	: in std_logic;
--		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
--		s00_axi_awprot	: in std_logic_vector(2 downto 0);
--		s00_axi_awvalid	: in std_logic;
--		s00_axi_awready	: out std_logic;
--		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
--		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
--		s00_axi_wvalid	: in std_logic;
--		s00_axi_wready	: out std_logic;
--		s00_axi_bresp	: out std_logic_vector(1 downto 0);
--		s00_axi_bvalid	: out std_logic;
--		s00_axi_bready	: in std_logic;
--		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
--		s00_axi_arprot	: in std_logic_vector(2 downto 0);
--		s00_axi_arvalid	: in std_logic;
--		s00_axi_arready	: out std_logic;
--		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
--		s00_axi_rresp	: out std_logic_vector(1 downto 0);
--		s00_axi_rvalid	: out std_logic;
--		s00_axi_rready	: in std_logic
	);
end Audio_Fader_v1_0;

architecture arch_imp of Audio_Fader_v1_0 is

	-- component declaration
	
	component Audio_Fader_Top_Module is
		generic(
        INTBIT_WIDTH  	: integer;
        FRACBIT_WIDTH 	: integer;
        STEP_WIDTH		: integer
	);
	port(
		OUT_VOLCTRL_L : out signed((INTBIT_WIDTH - 1) downto 0) := (others => '0'); -- 24 bit signed output
		OUT_VOLCTRL_R : out signed((INTBIT_WIDTH - 1) downto 0) := (others => '0'); -- 24 bit signed output
		OUT_RDY       : out STD_LOGIC;
		
		new_sample_in    : in STD_LOGIC;
		replace_in_progress_in    : in STD_LOGIC;
		
		fade_enable_in    : in STD_LOGIC;
		fade_direction_in    : in STD_LOGIC;
		fade_clear_in        : in STD_LOGIC;
		
		fade_max_in          : in STD_LOGIC;
		fade_min_in          : in STD_LOGIC;

		IN_SIG_L      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
		IN_SIG_R      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
		
		
		UP_STEP_PULSES	: in std_logic_vector(STEP_WIDTH-1 downto 0);
		DOWN_STEP_PULSES	: in std_logic_vector(STEP_WIDTH-1 downto 0);
		IN_COEF_MIN  : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		IN_COEF_MAX  : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1

--		IN_COEF_L     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
--		IN_COEF_R     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1

		CLK_HI_IN    : in  STD_LOGIC;
		RESET         : in  STD_LOGIC
	);

end component Audio_Fader_Top_Module;
	
	
--	component Audio_Fader_v1_0_S00_AXI is
--		generic (
--		C_S_AXI_DATA_WIDTH	: integer	:= 32;
--		C_S_AXI_ADDR_WIDTH	: integer	:= 5;
		
--                INTBIT_WIDTH  : integer;
--                FRACBIT_WIDTH : integer;
--		STEP_WIDTH   	: integer
--		);
--		port (
--                OUT_VOLCTRL_L : out signed((24 - 1) downto 0) := (others => '0'); -- 24 bit signed output
--                OUT_VOLCTRL_R : out signed((24 - 1) downto 0) := (others => '0'); -- 24 bit signed output
--                OUT_RDY       : out STD_LOGIC;
        
--                IN_SIG_L      : in  signed((24 - 1) downto 0); --amplifier input signal 24-bit
--                IN_SIG_R      : in  signed((24 - 1) downto 0); --amplifier input signal 24-bit
                
--		fade_enable_in    : in STD_LOGIC;
--                new_sample_in    : in STD_LOGIC;
--                replace_in_progress_in    : in STD_LOGIC;
		
--		fade_direction_in    : in STD_LOGIC;
--		fade_clear_in        : in STD_LOGIC;
                
--		S_AXI_ACLK	: in std_logic;
--		S_AXI_ARESETN	: in std_logic;
--		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
--		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
--		S_AXI_AWVALID	: in std_logic;
--		S_AXI_AWREADY	: out std_logic;
--		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
--		S_AXI_WVALID	: in std_logic;
--		S_AXI_WREADY	: out std_logic;
--		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
--		S_AXI_BVALID	: out std_logic;
--		S_AXI_BREADY	: in std_logic;
--		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
--		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
--		S_AXI_ARVALID	: in std_logic;
--		S_AXI_ARREADY	: out std_logic;
--		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
--		S_AXI_RVALID	: out std_logic;
--		S_AXI_RREADY	: in std_logic
--		);
--	end component Audio_Fader_v1_0_S00_AXI;

begin

-- Instantiation of Axi Bus Interface S00_AXI
--Audio_Fader_v1_0_S00_AXI_inst : Audio_Fader_v1_0_S00_AXI
--	generic map (
--		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
--		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH,
		
--                INTBIT_WIDTH  => INTBIT_WIDTH,
--                FRACBIT_WIDTH => FRACBIT_WIDTH,
--		STEP_WIDTH  => STEP_WIDTH
--	)
--	port map (
--                OUT_VOLCTRL_L => OUT_VOLCTRL_L,
--                OUT_VOLCTRL_R => OUT_VOLCTRL_R,
--                OUT_RDY       => OUT_RDY,
--                IN_SIG_L      => IN_SIG_L,
--                IN_SIG_R      => IN_SIG_R,	
		
--		fade_direction_in => fade_direction_in,
--		fade_clear_in     => fade_clear_in,
		
--                fade_enable_in => fade_enable_in,
--		new_sample_in  => new_sample_in,
--                replace_in_progress_in => replace_in_progress_in,
                
--		S_AXI_ACLK	=> s00_axi_aclk,
--		S_AXI_ARESETN	=> s00_axi_aresetn,
--		S_AXI_AWADDR	=> s00_axi_awaddr,
--		S_AXI_AWPROT	=> s00_axi_awprot,
--		S_AXI_AWVALID	=> s00_axi_awvalid,
--		S_AXI_AWREADY	=> s00_axi_awready,
--		S_AXI_WDATA	=> s00_axi_wdata,
--		S_AXI_WSTRB	=> s00_axi_wstrb,
--		S_AXI_WVALID	=> s00_axi_wvalid,
--		S_AXI_WREADY	=> s00_axi_wready,
--		S_AXI_BRESP	=> s00_axi_bresp,
--		S_AXI_BVALID	=> s00_axi_bvalid,
--		S_AXI_BREADY	=> s00_axi_bready,
--		S_AXI_ARADDR	=> s00_axi_araddr,
--		S_AXI_ARPROT	=> s00_axi_arprot,
--		S_AXI_ARVALID	=> s00_axi_arvalid,
--		S_AXI_ARREADY	=> s00_axi_arready,
--		S_AXI_RDATA	=> s00_axi_rdata,
--		S_AXI_RRESP	=> s00_axi_rresp,
--		S_AXI_RVALID	=> s00_axi_rvalid,
--		S_AXI_RREADY	=> s00_axi_rready
--	);

	-- Add user logic here
-- Add user logic here
Audio_Fader_Top_Module_inst : Audio_Fader_Top_Module
        generic map(
            INTBIT_WIDTH  => INTBIT_WIDTH,
            FRACBIT_WIDTH => FRACBIT_WIDTH,
	    STEP_WIDTH  => STEP_WIDTH
        )
        port map(
            OUT_VOLCTRL_L => OUT_VOLCTRL_L,
            OUT_VOLCTRL_R => OUT_VOLCTRL_R,
            OUT_RDY       => OUT_RDY,
            IN_SIG_L      => IN_SIG_L,
            IN_SIG_R      => IN_SIG_R,
            CLK_HI_IN    => CLK_125,
	    
	    fade_direction_in => fade_direction_in,
	    fade_clear_in     => fade_clear_in,
	    fade_enable_in => fade_enable_in,
	    
	    fade_max_in   => fade_max_in,
        fade_min_in   => fade_min_in,
            
            new_sample_in => new_sample_in,
            replace_in_progress_in => replace_in_progress_in,
--            IN_COEF_L     => signed(IN_COEF_L),
--            IN_COEF_R     => signed(IN_COEF_R),
	    DOWN_STEP_PULSES  => DOWN_STEP_PULSES,
	    UP_STEP_PULSES    => UP_STEP_PULSES,
	    
            IN_COEF_MIN  => signed(IN_COEF_MIN),
	    IN_COEF_MAX  => signed(IN_COEF_MAX),
            RESET         => RST_IN
        );
	-- User logic ends

end arch_imp;
