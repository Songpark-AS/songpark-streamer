library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Audio_medfilter_v1_0 is
	generic (
		-- Users to add parameters here
		
        SIGBIT_WIDTH  : integer := 24;
        ORDBIT_WIDTH  : integer := 6
	);
	port (
		-- Users to add ports here
        SAMPLE_CLK    : in STD_LOGIC;
        OUT_MED_L : out signed((24 - 1) downto 0) := (others => '0'); -- 24 bit signed output
        OUT_MED_R : out signed((24 - 1) downto 0) := (others => '0'); -- 24 bit signed output
        

        IN_SIG_L      : in  signed((24 - 1) downto 0); --amplifier input signal 24-bit
        IN_SIG_R      : in  signed((24 - 1) downto 0); --amplifier input signal 24-bit

        RST_IN        : in STD_LOGIC		
	);
end Audio_medfilter_v1_0;

architecture arch_imp of Audio_medfilter_v1_0 is

	-- component declaration
	
	


component median_filter is
generic (
		-- Users to add parameters here
		
                SIGBIT_WIDTH  : integer := 24;
               ORDBIT_WIDTH  : integer := 6
		-- User parameters ends
		-- Do not modify the parameters beyond this line
	);
    port (
        clk: in std_logic;
        reset: in std_logic;
        xin: in signed (SIGBIT_WIDTH - 1 downto 0);
        dvi: in std_logic;
        yout: out signed (SIGBIT_WIDTH - 1 downto 0)
    );
end component median_filter;
	
	


begin



	-- Add user logic here
-- Add user logic here
    medfilter_L_inst : median_filter
        generic map(
            SIGBIT_WIDTH  => SIGBIT_WIDTH,            
	        ORDBIT_WIDTH  => ORDBIT_WIDTH
        )
        port map(
            
        clk  => SAMPLE_CLK,
	    RESET         => RST_IN,
	    xin => IN_SIG_L,
	    dvi => '1',
	    yout => OUT_MED_L    
            
        );
        
        
        
        medfilter_R_inst : median_filter
        generic map(
            SIGBIT_WIDTH  => SIGBIT_WIDTH,            
	        ORDBIT_WIDTH  => ORDBIT_WIDTH
        )
        port map(
            
        clk       => SAMPLE_CLK,
	    RESET     => RST_IN,
	    xin       => IN_SIG_R,
	    dvi       => '1',
	    yout      => OUT_MED_R    
            
        );
	-- User logic ends

end arch_imp;
