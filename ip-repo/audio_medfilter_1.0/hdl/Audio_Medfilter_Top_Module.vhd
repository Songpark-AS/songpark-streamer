library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Audio_medfilter_Top_Module is
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

end Audio_medfilter_Top_Module;

architecture Behavioral of Audio_medfilter_Top_Module is
	component AmplifierFP
     generic ( INTBIT_WIDTH    	:   integer;
			 FRACBIT_WIDTH		:	 integer); 
		port(
			CLK     : in  std_logic;
			RESET   : in  std_logic;
			IN_SIG  : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
			IN_COEF : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
			OUT_AMP : out signed((INTBIT_WIDTH - 1) downto 0) := (others => '0'); --amplifier output
			OUT_RDY : out std_logic
		);
	end component;
	
	
	component Gain_Sweep
     generic ( INTBIT_WIDTH    	:   integer;
			 FRACBIT_WIDTH		:	 integer;
			 STEP_WIDTH			: integer); 
			 
		port(
			--		OUT_VOLCTRL_L : out signed((INTBIT_WIDTH - 1) downto 0) := (others => '0'); -- 24 bit signed output
--		OUT_VOLCTRL_R : out signed((INTBIT_WIDTH - 1) downto 0) := (others => '0'); -- 24 bit signed output
		OUT_RDY       : out STD_LOGIC;
		fade_direction_in    : in STD_LOGIC;
		fade_clear_in        : in STD_LOGIC;
		
		fade_max_in          : in STD_LOGIC;
		fade_min_in          : in STD_LOGIC;
		
		fade_enable_in    : in STD_LOGIC;
		new_sample_in    : in STD_LOGIC;
		replace_in_progress_in    : in STD_LOGIC;

--		IN_SIG_L      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
--		IN_SIG_R      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
		UP_STEP_PULSES	: in std_logic_vector(STEP_WIDTH-1 downto 0);
		DOWN_STEP_PULSES	: in std_logic_vector(STEP_WIDTH-1 downto 0);
		IN_COEF_MIN     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		IN_COEF_MAX     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		OUT_COEF     : out  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		
		CLK_HI_IN    : in  STD_LOGIC;
		RESET         : in  STD_LOGIC
		);
	end component;

	signal AMP_OUT_L, AMP_OUT_R : signed((INTBIT_WIDTH - 1) downto 0) := (others => '0');
	signal VOLCTRL_L, VOLCTRL_R : signed((INTBIT_WIDTH - 1) downto 0) := (others => '0');
	signal volctrl_ready_l      : std_logic                           := '0';
	signal volctrl_ready_r      : std_logic                           := '0';
	
	
	signal OUT_COEF_L     : signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
	signal OUT_COEF_R     : signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1

begin
	AmplifierFP_L : AmplifierFP 
        generic map(
            INTBIT_WIDTH  => INTBIT_WIDTH,
            FRACBIT_WIDTH => FRACBIT_WIDTH
        )port map(
			CLK     => CLK_HI_IN,
			RESET   => RESET,
			IN_SIG  => IN_SIG_L,
			IN_COEF => OUT_COEF_L,
			OUT_AMP => AMP_OUT_L,
			OUT_RDY => volctrl_ready_l
		);

	AmplifierFP_R : AmplifierFP 
        generic map(
            INTBIT_WIDTH  => INTBIT_WIDTH,
            FRACBIT_WIDTH => FRACBIT_WIDTH
        )port map(
			CLK     => CLK_HI_IN,
			RESET   => RESET,
			IN_SIG  => IN_SIG_R,
			IN_COEF => OUT_COEF_R,
			OUT_AMP => AMP_OUT_R,
			OUT_RDY => volctrl_ready_r
		);
		
		
    
    GainSweep_R : Gain_Sweep 
        generic map(
            INTBIT_WIDTH  => INTBIT_WIDTH,
            FRACBIT_WIDTH => FRACBIT_WIDTH,
            STEP_WIDTH  => STEP_WIDTH
        )port map(
			CLK_HI_IN     => CLK_HI_IN,
			RESET   => RESET,
			
			fade_direction_in => fade_direction_in,
			fade_clear_in     => fade_clear_in,
			fade_enable_in => fade_enable_in,
			new_sample_in => new_sample_in,
            replace_in_progress_in => replace_in_progress_in,
            
            fade_max_in   => fade_max_in,
            fade_min_in   => fade_min_in,
			
			DOWN_STEP_PULSES  => DOWN_STEP_PULSES,
			UP_STEP_PULSES  => UP_STEP_PULSES,
			IN_COEF_MIN  => IN_COEF_MIN,
			IN_COEF_MAX  => IN_COEF_MAX,
			
			OUT_COEF  => OUT_COEF_R,

			OUT_RDY => volctrl_ready_r
		);
		
     GainSweep_L : Gain_Sweep 
        generic map(
            INTBIT_WIDTH  => INTBIT_WIDTH,
            FRACBIT_WIDTH => FRACBIT_WIDTH,
            STEP_WIDTH  => STEP_WIDTH
        )port map(
			CLK_HI_IN     => CLK_HI_IN,
			RESET   => RESET,
			
			fade_direction_in => fade_direction_in,
			fade_clear_in     => fade_clear_in,
			fade_enable_in => fade_enable_in,
			new_sample_in => new_sample_in,
            replace_in_progress_in => replace_in_progress_in,
            
            fade_max_in   => fade_max_in,
            fade_min_in   => fade_min_in,
			
			DOWN_STEP_PULSES  => DOWN_STEP_PULSES,
			UP_STEP_PULSES  => UP_STEP_PULSES,
			
			IN_COEF_MIN  => IN_COEF_MIN,
			IN_COEF_MAX  => IN_COEF_MAX,
			
			OUT_COEF  => OUT_COEF_L,

			OUT_RDY => volctrl_ready_r
		);

    

	seq_proc : process(CLK_HI_IN)
	begin
		if (CLK_HI_IN'event and CLK_HI_IN = '1') then
			--  update the ready signal when new values gets written to the buffer
			if (volctrl_ready_l = '1') then
				VOLCTRL_L <= AMP_OUT_L;
			end if;
			if (volctrl_ready_r = '1') then
				VOLCTRL_R <= AMP_OUT_R;
			end if;
		end if;
	end process;
	
	
	
	
	
	

	OUT_RDY <= volctrl_ready_l or volctrl_ready_r;

	--OUT_VOLCTRL_L <= VOLCTRL_L when fade_enable_in = '1' else IN_SIG_L;
	--OUT_VOLCTRL_R <= VOLCTRL_R when fade_enable_in = '1' else IN_SIG_R;
	OUT_VOLCTRL_L <= VOLCTRL_L;
	OUT_VOLCTRL_R <= VOLCTRL_R;

end Behavioral;
