-- **************************************************************
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.math_real.all;
library xil_defaultlib;
use xil_defaultlib.utils.all;
-- **************************************************************


entity filtered_io is
    generic (
        FILTER_LENGTH : integer := 15
        );
    port(
        data : out std_logic;
        input : in std_logic;
        reset : in std_logic;
        CLK : in std_logic
    );
end filtered_io;




architecture rtl of filtered_io is
    signal d : std_logic; -- spike event
    signal shift : std_logic_vector(2 downto 0);
    signal count : unsigned(log2ceil(FILTER_LENGTH) downto 0); -- time counter

begin

    process(reset, CLK,input)
    begin
        if reset = '1' then
            shift <= (others => '0');
        elsif rising_edge(clk) then
            shift <= shift(1 downto 0) & input; -- input port
        end if;
    end process;
    
    process(reset,clk,shift,count)
    begin
        if reset = '1' then
            d <= '0';
            count <= (others => '0');
        elsif rising_edge(clk) then
            if(count > FILTER_LENGTH) then
                if(d = '0') then
                    d <= '1';
                else
                    d <= '0';
                end if;
                count <= (others => '0');
            elsif(shift(2) /= d) then -- not equal
                count <= count + 1;
                d <= d;
            else
                count <= (others => '0');
                d <= d;
            end if;
        end if;
    end process;
    data <= d;
end rtl;