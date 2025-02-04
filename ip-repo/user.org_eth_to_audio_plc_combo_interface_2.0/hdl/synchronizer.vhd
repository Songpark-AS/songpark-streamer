library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchronizer is
    generic ( 
    STAGES : natural := 3;
    WIDTH : natural := 1 
    );
    Port ( clk : in STD_LOGIC;
           i : in STD_LOGIC;
           o : out STD_LOGIC);
end synchronizer;

architecture Behavioral of synchronizer is
    signal flipflops : std_logic_vector(stages-1 downto 0):= (others => '0');
    attribute ASYNC_REG : string;
    attribute ASYNC_REG of flipflops: signal is "true";
begin

    o <= flipflops(flipflops'high);

clk_proc: process(clk)
    begin
        if rising_edge(clk) then
            flipflops <= flipflops(flipflops'high-1 downto 0) & i;
        end if;
    end process;

end Behavioral;