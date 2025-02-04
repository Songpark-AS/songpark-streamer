-- File: median_filter.vhd
-- 
-- Date: Fri Sep 18 22:28:36 2020


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

library xil_defaultlib;
use xil_defaultlib.pck_medfilter_010.all;

entity median_filter is
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
end entity median_filter;
-- Sort Array with N values 

architecture MedFilter of median_filter is



--signal xcnt: unsigned(2 downto 0);
--signal sort_merge_hi_merge_hi_merge_feed_in_a: signed (23 downto 0);
--signal sort_merge_hi_merge_lo_merge_feed_in_a: signed (23 downto 0);
--signal sort_merge_hi_merge_comp_comp_0_a_1: signed (23 downto 0);
--signal sort_merge_hi_merge_comp_comp_0_a_2: signed (23 downto 0);
--signal sort_merge_lo_merge_hi_merge_feed_in_a: signed (23 downto 0);
--signal sort_merge_lo_merge_lo_merge_feed_in_a: signed (23 downto 0);
--signal sort_merge_lo_merge_comp_comp_0_a_1: signed (23 downto 0);
--signal sort_merge_lo_merge_comp_comp_0_a_2: signed (23 downto 0);
--signal sort_merge_comp_comp_1_a_1: signed (23 downto 0);
--signal sort_merge_comp_comp_1_a_2: signed (23 downto 0);
--signal sort_merge_comp_comp_0_a_1: signed (23 downto 0);
--signal sort_merge_comp_comp_0_a_2: signed (23 downto 0);
--signal sort_hi_sort_merge_hi_merge_feed_in_a: signed (23 downto 0);
--signal sort_hi_sort_merge_lo_merge_feed_in_a: signed (23 downto 0);
--signal sort_hi_sort_merge_comp_comp_0_a_1: signed (23 downto 0);
--signal sort_hi_sort_merge_comp_comp_0_a_2: signed (23 downto 0);
--signal sort_lo_sort_merge_hi_merge_feed_in_a: signed (23 downto 0);
--signal sort_lo_sort_merge_lo_merge_feed_in_a: signed (23 downto 0);
--signal sort_lo_sort_merge_comp_comp_0_a_1: signed (23 downto 0);
--signal sort_lo_sort_merge_comp_comp_0_a_2: signed (23 downto 0);
--type t_array_x_list is array(0 to 4-1) of signed (23 downto 0);
--signal x_list: t_array_x_list;
--type t_array_y_list is array(0 to 4-1) of signed (23 downto 0);
--signal y_list: t_array_y_list;

--begin




---- Combinatorial logic 

--sort_lo_sort_merge_comp_comp_0_a_1 <= x_list(0);

---- Combinatorial logic 

--sort_lo_sort_merge_comp_comp_0_a_2 <= x_list(1);

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_LO_SORT_MERGE_COMP_0_LOGIC: process (sort_lo_sort_merge_comp_comp_0_a_1, sort_lo_sort_merge_comp_comp_0_a_2) is
--begin
--    if ('1' = stdl(sort_lo_sort_merge_comp_comp_0_a_1 > sort_lo_sort_merge_comp_comp_0_a_2)) then
--        sort_lo_sort_merge_lo_merge_feed_in_a <= sort_lo_sort_merge_comp_comp_0_a_2;
--        sort_lo_sort_merge_hi_merge_feed_in_a <= sort_lo_sort_merge_comp_comp_0_a_1;
--    else
--        sort_lo_sort_merge_lo_merge_feed_in_a <= sort_lo_sort_merge_comp_comp_0_a_1;
--        sort_lo_sort_merge_hi_merge_feed_in_a <= sort_lo_sort_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_LO_SORT_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--sort_merge_comp_comp_0_a_1 <= sort_lo_sort_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--sort_merge_comp_comp_1_a_1 <= sort_lo_sort_merge_hi_merge_feed_in_a;

---- Combinatorial logic 

--sort_hi_sort_merge_comp_comp_0_a_1 <= x_list(2);

---- Combinatorial logic 

--sort_hi_sort_merge_comp_comp_0_a_2 <= x_list(3);

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_HI_SORT_MERGE_COMP_0_LOGIC: process (sort_hi_sort_merge_comp_comp_0_a_1, sort_hi_sort_merge_comp_comp_0_a_2) is
--begin
--    if ('0' = stdl(sort_hi_sort_merge_comp_comp_0_a_1 > sort_hi_sort_merge_comp_comp_0_a_2)) then
--        sort_hi_sort_merge_lo_merge_feed_in_a <= sort_hi_sort_merge_comp_comp_0_a_2;
--        sort_hi_sort_merge_hi_merge_feed_in_a <= sort_hi_sort_merge_comp_comp_0_a_1;
--    else
--        sort_hi_sort_merge_lo_merge_feed_in_a <= sort_hi_sort_merge_comp_comp_0_a_1;
--        sort_hi_sort_merge_hi_merge_feed_in_a <= sort_hi_sort_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_HI_SORT_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--sort_merge_comp_comp_0_a_2 <= sort_hi_sort_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--sort_merge_comp_comp_1_a_2 <= sort_hi_sort_merge_hi_merge_feed_in_a;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_COMP_0_LOGIC: process (sort_merge_comp_comp_0_a_1, sort_merge_comp_comp_0_a_2) is
--begin
--    if ('1' = stdl(sort_merge_comp_comp_0_a_1 > sort_merge_comp_comp_0_a_2)) then
--        sort_merge_lo_merge_comp_comp_0_a_1 <= sort_merge_comp_comp_0_a_2;
--        sort_merge_hi_merge_comp_comp_0_a_1 <= sort_merge_comp_comp_0_a_1;
--    else
--        sort_merge_lo_merge_comp_comp_0_a_1 <= sort_merge_comp_comp_0_a_1;
--        sort_merge_hi_merge_comp_comp_0_a_1 <= sort_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_COMP_1_LOGIC: process (sort_merge_comp_comp_1_a_1, sort_merge_comp_comp_1_a_2) is
--begin
--    if ('1' = stdl(sort_merge_comp_comp_1_a_1 > sort_merge_comp_comp_1_a_2)) then
--        sort_merge_lo_merge_comp_comp_0_a_2 <= sort_merge_comp_comp_1_a_2;
--        sort_merge_hi_merge_comp_comp_0_a_2 <= sort_merge_comp_comp_1_a_1;
--    else
--        sort_merge_lo_merge_comp_comp_0_a_2 <= sort_merge_comp_comp_1_a_1;
--        sort_merge_hi_merge_comp_comp_0_a_2 <= sort_merge_comp_comp_1_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_COMP_1_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_LO_MERGE_COMP_0_LOGIC: process (sort_merge_lo_merge_comp_comp_0_a_1, sort_merge_lo_merge_comp_comp_0_a_2) is
--begin
--    if ('1' = stdl(sort_merge_lo_merge_comp_comp_0_a_1 > sort_merge_lo_merge_comp_comp_0_a_2)) then
--        sort_merge_lo_merge_lo_merge_feed_in_a <= sort_merge_lo_merge_comp_comp_0_a_2;
--        sort_merge_lo_merge_hi_merge_feed_in_a <= sort_merge_lo_merge_comp_comp_0_a_1;
--    else
--        sort_merge_lo_merge_lo_merge_feed_in_a <= sort_merge_lo_merge_comp_comp_0_a_1;
--        sort_merge_lo_merge_hi_merge_feed_in_a <= sort_merge_lo_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_LO_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--y_list(0) <= sort_merge_lo_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--y_list(1) <= sort_merge_lo_merge_hi_merge_feed_in_a;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_HI_MERGE_COMP_0_LOGIC: process (sort_merge_hi_merge_comp_comp_0_a_1, sort_merge_hi_merge_comp_comp_0_a_2) is
--begin
--    if ('1' = stdl(sort_merge_hi_merge_comp_comp_0_a_1 > sort_merge_hi_merge_comp_comp_0_a_2)) then
--        sort_merge_hi_merge_lo_merge_feed_in_a <= sort_merge_hi_merge_comp_comp_0_a_2;
--        sort_merge_hi_merge_hi_merge_feed_in_a <= sort_merge_hi_merge_comp_comp_0_a_1;
--    else
--        sort_merge_hi_merge_lo_merge_feed_in_a <= sort_merge_hi_merge_comp_comp_0_a_1;
--        sort_merge_hi_merge_hi_merge_feed_in_a <= sort_merge_hi_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_HI_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--y_list(2) <= sort_merge_hi_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--y_list(3) <= sort_merge_hi_merge_hi_merge_feed_in_a;

--MEDIAN_FILTER_RTL_IN: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (reset = '1') then
--            xcnt <= to_unsigned(1, 3);
--            x_list(0) <= to_signed(0, 24);
--            x_list(1) <= to_signed(0, 24);
--            x_list(2) <= to_signed(0, 24);
--            x_list(3) <= to_signed(0, 24);
--        else
--            if ((xcnt = 4) and bool(dvi)) then
--                x_list(to_integer(signed(resize(xcnt, 4)) - 1)) <= xin;
--                xcnt <= to_unsigned(1, 3);
--            elsif bool(dvi) then
--                x_list(to_integer(signed(resize(xcnt, 4)) - 1)) <= xin;
--                xcnt <= (xcnt + 1);
--            end if;
--        end if;
--    end if;
--end process MEDIAN_FILTER_RTL_IN;


--yout <= shift_right((y_list(2) + y_list((2 + 1))), 1);


signal xcnt: unsigned(1 downto 0);
signal sort_merge_hi_merge_feed_in_a: signed (23 downto 0);
signal sort_merge_lo_merge_feed_in_a: signed (23 downto 0);
signal sort_merge_comp_comp_0_a_1: signed (23 downto 0);
signal sort_merge_comp_comp_0_a_2: signed (23 downto 0);
type t_array_x_list is array(0 to 2-1) of signed (23 downto 0);
signal x_list: t_array_x_list;
type t_array_y_list is array(0 to 2-1) of signed (23 downto 0);
signal y_list: t_array_y_list;

begin




-- Combinatorial logic 

sort_merge_comp_comp_0_a_1 <= x_list(0);

-- Combinatorial logic 

sort_merge_comp_comp_0_a_2 <= x_list(1);

-- Combinatorial logic 
MEDIAN_FILTER_SORT_MERGE_COMP_0_LOGIC: process (sort_merge_comp_comp_0_a_1, sort_merge_comp_comp_0_a_2) is
begin
    if ('1' = stdl(sort_merge_comp_comp_0_a_1 > sort_merge_comp_comp_0_a_2)) then
        sort_merge_lo_merge_feed_in_a <= sort_merge_comp_comp_0_a_2;
        sort_merge_hi_merge_feed_in_a <= sort_merge_comp_comp_0_a_1;
    else
        sort_merge_lo_merge_feed_in_a <= sort_merge_comp_comp_0_a_1;
        sort_merge_hi_merge_feed_in_a <= sort_merge_comp_comp_0_a_2;
    end if;
end process MEDIAN_FILTER_SORT_MERGE_COMP_0_LOGIC;

-- Combinatorial logic 

y_list(0) <= sort_merge_lo_merge_feed_in_a;

-- Combinatorial logic 

y_list(1) <= sort_merge_hi_merge_feed_in_a;

MEDIAN_FILTER_RTL_IN: process (clk) is
begin
    if rising_edge(clk) then
        if (reset = '1') then
            xcnt <= to_unsigned(1, 2);
            x_list(0) <= to_signed(0, 24);
            x_list(1) <= to_signed(0, 24);
        else
            if ((xcnt = 2) and bool(dvi)) then
                x_list(to_integer(signed(resize(xcnt, 3)) - 1)) <= xin;
                xcnt <= to_unsigned(1, 2);
            elsif bool(dvi) then
                x_list(to_integer(signed(resize(xcnt, 3)) - 1)) <= xin;
                xcnt <= (xcnt + 1);
            end if;
        end if;
    end if;
end process MEDIAN_FILTER_RTL_IN;


yout <= y_list(1);

end architecture MedFilter;

--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
--use std.textio.all;

--library xil_defaultlib;
--use xil_defaultlib.pck_medfilter_010.all;

--entity median_filter is
--generic (
--		-- Users to add parameters here
		
--                SIGBIT_WIDTH  : integer := 24;
--               ORDBIT_WIDTH  : integer := 6
--		-- User parameters ends
--		-- Do not modify the parameters beyond this line
--	);
--    port (
--        clk: in std_logic;
--        reset: in std_logic;
--        xin: in signed (SIGBIT_WIDTH - 1 downto 0);
--        dvi: in std_logic;
--        yout: out signed (SIGBIT_WIDTH - 1 downto 0)
--    );
--end entity median_filter;
---- Sort Array with N values 

--architecture MedFilter of median_filter is



--signal xcnt: unsigned(3 downto 0);
--signal sort_merge_hi_merge_hi_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_hi_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_hi_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_hi_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_lo_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_lo_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_lo_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_lo_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_comp_comp_1_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_comp_comp_1_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_hi_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_hi_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_hi_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_hi_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_hi_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_lo_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_lo_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_lo_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_lo_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_comp_comp_1_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_comp_comp_1_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_lo_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_comp_comp_3_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_comp_comp_3_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_comp_comp_2_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_comp_comp_2_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_comp_comp_1_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_comp_comp_1_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_hi_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_hi_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_hi_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_hi_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_lo_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_lo_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_lo_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_lo_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_comp_comp_1_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_comp_comp_1_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_hi_sort_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_hi_sort_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_hi_sort_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_hi_sort_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_lo_sort_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_lo_sort_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_lo_sort_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_hi_sort_lo_sort_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_hi_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_hi_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_hi_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_hi_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_lo_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_lo_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_lo_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_lo_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_comp_comp_1_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_comp_comp_1_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_hi_sort_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_hi_sort_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_hi_sort_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_hi_sort_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_lo_sort_merge_hi_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_lo_sort_merge_lo_merge_feed_in_a: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_lo_sort_merge_comp_comp_0_a_1: signed (SIGBIT_WIDTH - 1 downto 0);
--signal sort_lo_sort_lo_sort_merge_comp_comp_0_a_2: signed (SIGBIT_WIDTH - 1 downto 0);
--type t_array_x_list is array(0 to 8-1) of signed (SIGBIT_WIDTH - 1 downto 0);
--signal x_list: t_array_x_list;
--type t_array_y_list is array(0 to 8-1) of signed (SIGBIT_WIDTH - 1 downto 0);
--signal y_list: t_array_y_list;

--begin




---- Combinatorial logic 

--sort_lo_sort_lo_sort_merge_comp_comp_0_a_1 <= x_list(0);

---- Combinatorial logic 

--sort_lo_sort_lo_sort_merge_comp_comp_0_a_2 <= x_list(1);

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_LO_SORT_LO_SORT_MERGE_COMP_0_LOGIC: process (sort_lo_sort_lo_sort_merge_comp_comp_0_a_2, sort_lo_sort_lo_sort_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_lo_sort_lo_sort_merge_comp_comp_0_a_1 > sort_lo_sort_lo_sort_merge_comp_comp_0_a_2)) then
--        sort_lo_sort_lo_sort_merge_lo_merge_feed_in_a <= sort_lo_sort_lo_sort_merge_comp_comp_0_a_2;
--        sort_lo_sort_lo_sort_merge_hi_merge_feed_in_a <= sort_lo_sort_lo_sort_merge_comp_comp_0_a_1;
--    else
--        sort_lo_sort_lo_sort_merge_lo_merge_feed_in_a <= sort_lo_sort_lo_sort_merge_comp_comp_0_a_1;
--        sort_lo_sort_lo_sort_merge_hi_merge_feed_in_a <= sort_lo_sort_lo_sort_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_LO_SORT_LO_SORT_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--sort_lo_sort_merge_comp_comp_0_a_1 <= sort_lo_sort_lo_sort_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--sort_lo_sort_merge_comp_comp_1_a_1 <= sort_lo_sort_lo_sort_merge_hi_merge_feed_in_a;

---- Combinatorial logic 

--sort_lo_sort_hi_sort_merge_comp_comp_0_a_1 <= x_list(2);

---- Combinatorial logic 

--sort_lo_sort_hi_sort_merge_comp_comp_0_a_2 <= x_list(3);

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_LO_SORT_HI_SORT_MERGE_COMP_0_LOGIC: process (sort_lo_sort_hi_sort_merge_comp_comp_0_a_2, sort_lo_sort_hi_sort_merge_comp_comp_0_a_1) is
--begin
--    if ('0' = stdl(sort_lo_sort_hi_sort_merge_comp_comp_0_a_1 > sort_lo_sort_hi_sort_merge_comp_comp_0_a_2)) then
--        sort_lo_sort_hi_sort_merge_lo_merge_feed_in_a <= sort_lo_sort_hi_sort_merge_comp_comp_0_a_2;
--        sort_lo_sort_hi_sort_merge_hi_merge_feed_in_a <= sort_lo_sort_hi_sort_merge_comp_comp_0_a_1;
--    else
--        sort_lo_sort_hi_sort_merge_lo_merge_feed_in_a <= sort_lo_sort_hi_sort_merge_comp_comp_0_a_1;
--        sort_lo_sort_hi_sort_merge_hi_merge_feed_in_a <= sort_lo_sort_hi_sort_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_LO_SORT_HI_SORT_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--sort_lo_sort_merge_comp_comp_0_a_2 <= sort_lo_sort_hi_sort_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--sort_lo_sort_merge_comp_comp_1_a_2 <= sort_lo_sort_hi_sort_merge_hi_merge_feed_in_a;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_LO_SORT_MERGE_COMP_0_LOGIC: process (sort_lo_sort_merge_comp_comp_0_a_2, sort_lo_sort_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_lo_sort_merge_comp_comp_0_a_1 > sort_lo_sort_merge_comp_comp_0_a_2)) then
--        sort_lo_sort_merge_lo_merge_comp_comp_0_a_1 <= sort_lo_sort_merge_comp_comp_0_a_2;
--        sort_lo_sort_merge_hi_merge_comp_comp_0_a_1 <= sort_lo_sort_merge_comp_comp_0_a_1;
--    else
--        sort_lo_sort_merge_lo_merge_comp_comp_0_a_1 <= sort_lo_sort_merge_comp_comp_0_a_1;
--        sort_lo_sort_merge_hi_merge_comp_comp_0_a_1 <= sort_lo_sort_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_LO_SORT_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_LO_SORT_MERGE_COMP_1_LOGIC: process (sort_lo_sort_merge_comp_comp_1_a_2, sort_lo_sort_merge_comp_comp_1_a_1) is
--begin
--    if ('1' = stdl(sort_lo_sort_merge_comp_comp_1_a_1 > sort_lo_sort_merge_comp_comp_1_a_2)) then
--        sort_lo_sort_merge_lo_merge_comp_comp_0_a_2 <= sort_lo_sort_merge_comp_comp_1_a_2;
--        sort_lo_sort_merge_hi_merge_comp_comp_0_a_2 <= sort_lo_sort_merge_comp_comp_1_a_1;
--    else
--        sort_lo_sort_merge_lo_merge_comp_comp_0_a_2 <= sort_lo_sort_merge_comp_comp_1_a_1;
--        sort_lo_sort_merge_hi_merge_comp_comp_0_a_2 <= sort_lo_sort_merge_comp_comp_1_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_LO_SORT_MERGE_COMP_1_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_LO_SORT_MERGE_LO_MERGE_COMP_0_LOGIC: process (sort_lo_sort_merge_lo_merge_comp_comp_0_a_2, sort_lo_sort_merge_lo_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_lo_sort_merge_lo_merge_comp_comp_0_a_1 > sort_lo_sort_merge_lo_merge_comp_comp_0_a_2)) then
--        sort_lo_sort_merge_lo_merge_lo_merge_feed_in_a <= sort_lo_sort_merge_lo_merge_comp_comp_0_a_2;
--        sort_lo_sort_merge_lo_merge_hi_merge_feed_in_a <= sort_lo_sort_merge_lo_merge_comp_comp_0_a_1;
--    else
--        sort_lo_sort_merge_lo_merge_lo_merge_feed_in_a <= sort_lo_sort_merge_lo_merge_comp_comp_0_a_1;
--        sort_lo_sort_merge_lo_merge_hi_merge_feed_in_a <= sort_lo_sort_merge_lo_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_LO_SORT_MERGE_LO_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--sort_merge_comp_comp_0_a_1 <= sort_lo_sort_merge_lo_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--sort_merge_comp_comp_1_a_1 <= sort_lo_sort_merge_lo_merge_hi_merge_feed_in_a;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_LO_SORT_MERGE_HI_MERGE_COMP_0_LOGIC: process (sort_lo_sort_merge_hi_merge_comp_comp_0_a_2, sort_lo_sort_merge_hi_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_lo_sort_merge_hi_merge_comp_comp_0_a_1 > sort_lo_sort_merge_hi_merge_comp_comp_0_a_2)) then
--        sort_lo_sort_merge_hi_merge_lo_merge_feed_in_a <= sort_lo_sort_merge_hi_merge_comp_comp_0_a_2;
--        sort_lo_sort_merge_hi_merge_hi_merge_feed_in_a <= sort_lo_sort_merge_hi_merge_comp_comp_0_a_1;
--    else
--        sort_lo_sort_merge_hi_merge_lo_merge_feed_in_a <= sort_lo_sort_merge_hi_merge_comp_comp_0_a_1;
--        sort_lo_sort_merge_hi_merge_hi_merge_feed_in_a <= sort_lo_sort_merge_hi_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_LO_SORT_MERGE_HI_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--sort_merge_comp_comp_2_a_1 <= sort_lo_sort_merge_hi_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--sort_merge_comp_comp_3_a_1 <= sort_lo_sort_merge_hi_merge_hi_merge_feed_in_a;

---- Combinatorial logic 

--sort_hi_sort_lo_sort_merge_comp_comp_0_a_1 <= x_list(4);

---- Combinatorial logic 

--sort_hi_sort_lo_sort_merge_comp_comp_0_a_2 <= x_list(5);

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_HI_SORT_LO_SORT_MERGE_COMP_0_LOGIC: process (sort_hi_sort_lo_sort_merge_comp_comp_0_a_2, sort_hi_sort_lo_sort_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_hi_sort_lo_sort_merge_comp_comp_0_a_1 > sort_hi_sort_lo_sort_merge_comp_comp_0_a_2)) then
--        sort_hi_sort_lo_sort_merge_lo_merge_feed_in_a <= sort_hi_sort_lo_sort_merge_comp_comp_0_a_2;
--        sort_hi_sort_lo_sort_merge_hi_merge_feed_in_a <= sort_hi_sort_lo_sort_merge_comp_comp_0_a_1;
--    else
--        sort_hi_sort_lo_sort_merge_lo_merge_feed_in_a <= sort_hi_sort_lo_sort_merge_comp_comp_0_a_1;
--        sort_hi_sort_lo_sort_merge_hi_merge_feed_in_a <= sort_hi_sort_lo_sort_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_HI_SORT_LO_SORT_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--sort_hi_sort_merge_comp_comp_0_a_1 <= sort_hi_sort_lo_sort_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--sort_hi_sort_merge_comp_comp_1_a_1 <= sort_hi_sort_lo_sort_merge_hi_merge_feed_in_a;

---- Combinatorial logic 

--sort_hi_sort_hi_sort_merge_comp_comp_0_a_1 <= x_list(6);

---- Combinatorial logic 

--sort_hi_sort_hi_sort_merge_comp_comp_0_a_2 <= x_list(7);

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_HI_SORT_HI_SORT_MERGE_COMP_0_LOGIC: process (sort_hi_sort_hi_sort_merge_comp_comp_0_a_2, sort_hi_sort_hi_sort_merge_comp_comp_0_a_1) is
--begin
--    if ('0' = stdl(sort_hi_sort_hi_sort_merge_comp_comp_0_a_1 > sort_hi_sort_hi_sort_merge_comp_comp_0_a_2)) then
--        sort_hi_sort_hi_sort_merge_lo_merge_feed_in_a <= sort_hi_sort_hi_sort_merge_comp_comp_0_a_2;
--        sort_hi_sort_hi_sort_merge_hi_merge_feed_in_a <= sort_hi_sort_hi_sort_merge_comp_comp_0_a_1;
--    else
--        sort_hi_sort_hi_sort_merge_lo_merge_feed_in_a <= sort_hi_sort_hi_sort_merge_comp_comp_0_a_1;
--        sort_hi_sort_hi_sort_merge_hi_merge_feed_in_a <= sort_hi_sort_hi_sort_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_HI_SORT_HI_SORT_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--sort_hi_sort_merge_comp_comp_0_a_2 <= sort_hi_sort_hi_sort_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--sort_hi_sort_merge_comp_comp_1_a_2 <= sort_hi_sort_hi_sort_merge_hi_merge_feed_in_a;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_HI_SORT_MERGE_COMP_0_LOGIC: process (sort_hi_sort_merge_comp_comp_0_a_2, sort_hi_sort_merge_comp_comp_0_a_1) is
--begin
--    if ('0' = stdl(sort_hi_sort_merge_comp_comp_0_a_1 > sort_hi_sort_merge_comp_comp_0_a_2)) then
--        sort_hi_sort_merge_lo_merge_comp_comp_0_a_1 <= sort_hi_sort_merge_comp_comp_0_a_2;
--        sort_hi_sort_merge_hi_merge_comp_comp_0_a_1 <= sort_hi_sort_merge_comp_comp_0_a_1;
--    else
--        sort_hi_sort_merge_lo_merge_comp_comp_0_a_1 <= sort_hi_sort_merge_comp_comp_0_a_1;
--        sort_hi_sort_merge_hi_merge_comp_comp_0_a_1 <= sort_hi_sort_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_HI_SORT_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_HI_SORT_MERGE_COMP_1_LOGIC: process (sort_hi_sort_merge_comp_comp_1_a_2, sort_hi_sort_merge_comp_comp_1_a_1) is
--begin
--    if ('0' = stdl(sort_hi_sort_merge_comp_comp_1_a_1 > sort_hi_sort_merge_comp_comp_1_a_2)) then
--        sort_hi_sort_merge_lo_merge_comp_comp_0_a_2 <= sort_hi_sort_merge_comp_comp_1_a_2;
--        sort_hi_sort_merge_hi_merge_comp_comp_0_a_2 <= sort_hi_sort_merge_comp_comp_1_a_1;
--    else
--        sort_hi_sort_merge_lo_merge_comp_comp_0_a_2 <= sort_hi_sort_merge_comp_comp_1_a_1;
--        sort_hi_sort_merge_hi_merge_comp_comp_0_a_2 <= sort_hi_sort_merge_comp_comp_1_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_HI_SORT_MERGE_COMP_1_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_HI_SORT_MERGE_LO_MERGE_COMP_0_LOGIC: process (sort_hi_sort_merge_lo_merge_comp_comp_0_a_2, sort_hi_sort_merge_lo_merge_comp_comp_0_a_1) is
--begin
--    if ('0' = stdl(sort_hi_sort_merge_lo_merge_comp_comp_0_a_1 > sort_hi_sort_merge_lo_merge_comp_comp_0_a_2)) then
--        sort_hi_sort_merge_lo_merge_lo_merge_feed_in_a <= sort_hi_sort_merge_lo_merge_comp_comp_0_a_2;
--        sort_hi_sort_merge_lo_merge_hi_merge_feed_in_a <= sort_hi_sort_merge_lo_merge_comp_comp_0_a_1;
--    else
--        sort_hi_sort_merge_lo_merge_lo_merge_feed_in_a <= sort_hi_sort_merge_lo_merge_comp_comp_0_a_1;
--        sort_hi_sort_merge_lo_merge_hi_merge_feed_in_a <= sort_hi_sort_merge_lo_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_HI_SORT_MERGE_LO_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--sort_merge_comp_comp_0_a_2 <= sort_hi_sort_merge_lo_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--sort_merge_comp_comp_1_a_2 <= sort_hi_sort_merge_lo_merge_hi_merge_feed_in_a;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_HI_SORT_MERGE_HI_MERGE_COMP_0_LOGIC: process (sort_hi_sort_merge_hi_merge_comp_comp_0_a_2, sort_hi_sort_merge_hi_merge_comp_comp_0_a_1) is
--begin
--    if ('0' = stdl(sort_hi_sort_merge_hi_merge_comp_comp_0_a_1 > sort_hi_sort_merge_hi_merge_comp_comp_0_a_2)) then
--        sort_hi_sort_merge_hi_merge_lo_merge_feed_in_a <= sort_hi_sort_merge_hi_merge_comp_comp_0_a_2;
--        sort_hi_sort_merge_hi_merge_hi_merge_feed_in_a <= sort_hi_sort_merge_hi_merge_comp_comp_0_a_1;
--    else
--        sort_hi_sort_merge_hi_merge_lo_merge_feed_in_a <= sort_hi_sort_merge_hi_merge_comp_comp_0_a_1;
--        sort_hi_sort_merge_hi_merge_hi_merge_feed_in_a <= sort_hi_sort_merge_hi_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_HI_SORT_MERGE_HI_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--sort_merge_comp_comp_2_a_2 <= sort_hi_sort_merge_hi_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--sort_merge_comp_comp_3_a_2 <= sort_hi_sort_merge_hi_merge_hi_merge_feed_in_a;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_COMP_0_LOGIC: process (sort_merge_comp_comp_0_a_2, sort_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_merge_comp_comp_0_a_1 > sort_merge_comp_comp_0_a_2)) then
--        sort_merge_lo_merge_comp_comp_0_a_1 <= sort_merge_comp_comp_0_a_2;
--        sort_merge_hi_merge_comp_comp_0_a_1 <= sort_merge_comp_comp_0_a_1;
--    else
--        sort_merge_lo_merge_comp_comp_0_a_1 <= sort_merge_comp_comp_0_a_1;
--        sort_merge_hi_merge_comp_comp_0_a_1 <= sort_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_COMP_1_LOGIC: process (sort_merge_comp_comp_1_a_2, sort_merge_comp_comp_1_a_1) is
--begin
--    if ('1' = stdl(sort_merge_comp_comp_1_a_1 > sort_merge_comp_comp_1_a_2)) then
--        sort_merge_lo_merge_comp_comp_1_a_1 <= sort_merge_comp_comp_1_a_2;
--        sort_merge_hi_merge_comp_comp_1_a_1 <= sort_merge_comp_comp_1_a_1;
--    else
--        sort_merge_lo_merge_comp_comp_1_a_1 <= sort_merge_comp_comp_1_a_1;
--        sort_merge_hi_merge_comp_comp_1_a_1 <= sort_merge_comp_comp_1_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_COMP_1_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_COMP_2_LOGIC: process (sort_merge_comp_comp_2_a_2, sort_merge_comp_comp_2_a_1) is
--begin
--    if ('1' = stdl(sort_merge_comp_comp_2_a_1 > sort_merge_comp_comp_2_a_2)) then
--        sort_merge_lo_merge_comp_comp_0_a_2 <= sort_merge_comp_comp_2_a_2;
--        sort_merge_hi_merge_comp_comp_0_a_2 <= sort_merge_comp_comp_2_a_1;
--    else
--        sort_merge_lo_merge_comp_comp_0_a_2 <= sort_merge_comp_comp_2_a_1;
--        sort_merge_hi_merge_comp_comp_0_a_2 <= sort_merge_comp_comp_2_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_COMP_2_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_COMP_3_LOGIC: process (sort_merge_comp_comp_3_a_2, sort_merge_comp_comp_3_a_1) is
--begin
--    if ('1' = stdl(sort_merge_comp_comp_3_a_1 > sort_merge_comp_comp_3_a_2)) then
--        sort_merge_lo_merge_comp_comp_1_a_2 <= sort_merge_comp_comp_3_a_2;
--        sort_merge_hi_merge_comp_comp_1_a_2 <= sort_merge_comp_comp_3_a_1;
--    else
--        sort_merge_lo_merge_comp_comp_1_a_2 <= sort_merge_comp_comp_3_a_1;
--        sort_merge_hi_merge_comp_comp_1_a_2 <= sort_merge_comp_comp_3_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_COMP_3_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_LO_MERGE_COMP_0_LOGIC: process (sort_merge_lo_merge_comp_comp_0_a_2, sort_merge_lo_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_merge_lo_merge_comp_comp_0_a_1 > sort_merge_lo_merge_comp_comp_0_a_2)) then
--        sort_merge_lo_merge_lo_merge_comp_comp_0_a_1 <= sort_merge_lo_merge_comp_comp_0_a_2;
--        sort_merge_lo_merge_hi_merge_comp_comp_0_a_1 <= sort_merge_lo_merge_comp_comp_0_a_1;
--    else
--        sort_merge_lo_merge_lo_merge_comp_comp_0_a_1 <= sort_merge_lo_merge_comp_comp_0_a_1;
--        sort_merge_lo_merge_hi_merge_comp_comp_0_a_1 <= sort_merge_lo_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_LO_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_LO_MERGE_COMP_1_LOGIC: process (sort_merge_lo_merge_comp_comp_1_a_2, sort_merge_lo_merge_comp_comp_1_a_1) is
--begin
--    if ('1' = stdl(sort_merge_lo_merge_comp_comp_1_a_1 > sort_merge_lo_merge_comp_comp_1_a_2)) then
--        sort_merge_lo_merge_lo_merge_comp_comp_0_a_2 <= sort_merge_lo_merge_comp_comp_1_a_2;
--        sort_merge_lo_merge_hi_merge_comp_comp_0_a_2 <= sort_merge_lo_merge_comp_comp_1_a_1;
--    else
--        sort_merge_lo_merge_lo_merge_comp_comp_0_a_2 <= sort_merge_lo_merge_comp_comp_1_a_1;
--        sort_merge_lo_merge_hi_merge_comp_comp_0_a_2 <= sort_merge_lo_merge_comp_comp_1_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_LO_MERGE_COMP_1_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_LO_MERGE_LO_MERGE_COMP_0_LOGIC: process (sort_merge_lo_merge_lo_merge_comp_comp_0_a_2, sort_merge_lo_merge_lo_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_merge_lo_merge_lo_merge_comp_comp_0_a_1 > sort_merge_lo_merge_lo_merge_comp_comp_0_a_2)) then
--        sort_merge_lo_merge_lo_merge_lo_merge_feed_in_a <= sort_merge_lo_merge_lo_merge_comp_comp_0_a_2;
--        sort_merge_lo_merge_lo_merge_hi_merge_feed_in_a <= sort_merge_lo_merge_lo_merge_comp_comp_0_a_1;
--    else
--        sort_merge_lo_merge_lo_merge_lo_merge_feed_in_a <= sort_merge_lo_merge_lo_merge_comp_comp_0_a_1;
--        sort_merge_lo_merge_lo_merge_hi_merge_feed_in_a <= sort_merge_lo_merge_lo_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_LO_MERGE_LO_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--y_list(0) <= sort_merge_lo_merge_lo_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--y_list(1) <= sort_merge_lo_merge_lo_merge_hi_merge_feed_in_a;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_LO_MERGE_HI_MERGE_COMP_0_LOGIC: process (sort_merge_lo_merge_hi_merge_comp_comp_0_a_2, sort_merge_lo_merge_hi_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_merge_lo_merge_hi_merge_comp_comp_0_a_1 > sort_merge_lo_merge_hi_merge_comp_comp_0_a_2)) then
--        sort_merge_lo_merge_hi_merge_lo_merge_feed_in_a <= sort_merge_lo_merge_hi_merge_comp_comp_0_a_2;
--        sort_merge_lo_merge_hi_merge_hi_merge_feed_in_a <= sort_merge_lo_merge_hi_merge_comp_comp_0_a_1;
--    else
--        sort_merge_lo_merge_hi_merge_lo_merge_feed_in_a <= sort_merge_lo_merge_hi_merge_comp_comp_0_a_1;
--        sort_merge_lo_merge_hi_merge_hi_merge_feed_in_a <= sort_merge_lo_merge_hi_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_LO_MERGE_HI_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--y_list(2) <= sort_merge_lo_merge_hi_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--y_list(3) <= sort_merge_lo_merge_hi_merge_hi_merge_feed_in_a;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_HI_MERGE_COMP_0_LOGIC: process (sort_merge_hi_merge_comp_comp_0_a_2, sort_merge_hi_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_merge_hi_merge_comp_comp_0_a_1 > sort_merge_hi_merge_comp_comp_0_a_2)) then
--        sort_merge_hi_merge_lo_merge_comp_comp_0_a_1 <= sort_merge_hi_merge_comp_comp_0_a_2;
--        sort_merge_hi_merge_hi_merge_comp_comp_0_a_1 <= sort_merge_hi_merge_comp_comp_0_a_1;
--    else
--        sort_merge_hi_merge_lo_merge_comp_comp_0_a_1 <= sort_merge_hi_merge_comp_comp_0_a_1;
--        sort_merge_hi_merge_hi_merge_comp_comp_0_a_1 <= sort_merge_hi_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_HI_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_HI_MERGE_COMP_1_LOGIC: process (sort_merge_hi_merge_comp_comp_1_a_2, sort_merge_hi_merge_comp_comp_1_a_1) is
--begin
--    if ('1' = stdl(sort_merge_hi_merge_comp_comp_1_a_1 > sort_merge_hi_merge_comp_comp_1_a_2)) then
--        sort_merge_hi_merge_lo_merge_comp_comp_0_a_2 <= sort_merge_hi_merge_comp_comp_1_a_2;
--        sort_merge_hi_merge_hi_merge_comp_comp_0_a_2 <= sort_merge_hi_merge_comp_comp_1_a_1;
--    else
--        sort_merge_hi_merge_lo_merge_comp_comp_0_a_2 <= sort_merge_hi_merge_comp_comp_1_a_1;
--        sort_merge_hi_merge_hi_merge_comp_comp_0_a_2 <= sort_merge_hi_merge_comp_comp_1_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_HI_MERGE_COMP_1_LOGIC;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_HI_MERGE_LO_MERGE_COMP_0_LOGIC: process (sort_merge_hi_merge_lo_merge_comp_comp_0_a_2, sort_merge_hi_merge_lo_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_merge_hi_merge_lo_merge_comp_comp_0_a_1 > sort_merge_hi_merge_lo_merge_comp_comp_0_a_2)) then
--        sort_merge_hi_merge_lo_merge_lo_merge_feed_in_a <= sort_merge_hi_merge_lo_merge_comp_comp_0_a_2;
--        sort_merge_hi_merge_lo_merge_hi_merge_feed_in_a <= sort_merge_hi_merge_lo_merge_comp_comp_0_a_1;
--    else
--        sort_merge_hi_merge_lo_merge_lo_merge_feed_in_a <= sort_merge_hi_merge_lo_merge_comp_comp_0_a_1;
--        sort_merge_hi_merge_lo_merge_hi_merge_feed_in_a <= sort_merge_hi_merge_lo_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_HI_MERGE_LO_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--y_list(4) <= sort_merge_hi_merge_lo_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--y_list(5) <= sort_merge_hi_merge_lo_merge_hi_merge_feed_in_a;

---- Combinatorial logic 
--MEDIAN_FILTER_SORT_MERGE_HI_MERGE_HI_MERGE_COMP_0_LOGIC: process (sort_merge_hi_merge_hi_merge_comp_comp_0_a_2, sort_merge_hi_merge_hi_merge_comp_comp_0_a_1) is
--begin
--    if ('1' = stdl(sort_merge_hi_merge_hi_merge_comp_comp_0_a_1 > sort_merge_hi_merge_hi_merge_comp_comp_0_a_2)) then
--        sort_merge_hi_merge_hi_merge_lo_merge_feed_in_a <= sort_merge_hi_merge_hi_merge_comp_comp_0_a_2;
--        sort_merge_hi_merge_hi_merge_hi_merge_feed_in_a <= sort_merge_hi_merge_hi_merge_comp_comp_0_a_1;
--    else
--        sort_merge_hi_merge_hi_merge_lo_merge_feed_in_a <= sort_merge_hi_merge_hi_merge_comp_comp_0_a_1;
--        sort_merge_hi_merge_hi_merge_hi_merge_feed_in_a <= sort_merge_hi_merge_hi_merge_comp_comp_0_a_2;
--    end if;
--end process MEDIAN_FILTER_SORT_MERGE_HI_MERGE_HI_MERGE_COMP_0_LOGIC;

---- Combinatorial logic 

--y_list(6) <= sort_merge_hi_merge_hi_merge_lo_merge_feed_in_a;

---- Combinatorial logic 

--y_list(7) <= sort_merge_hi_merge_hi_merge_hi_merge_feed_in_a;

--MEDIAN_FILTER_RTL_IN: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (reset = '1') then
--            xcnt <= to_unsigned(1, 4);
--            x_list(0) <= to_signed(0, SIGBIT_WIDTH);
--            x_list(1) <= to_signed(0, SIGBIT_WIDTH);
--            x_list(2) <= to_signed(0, SIGBIT_WIDTH);
--            x_list(3) <= to_signed(0, SIGBIT_WIDTH);
--            x_list(4) <= to_signed(0, SIGBIT_WIDTH);
--            x_list(5) <= to_signed(0, SIGBIT_WIDTH);
--            x_list(6) <= to_signed(0, SIGBIT_WIDTH);
--            x_list(7) <= to_signed(0, SIGBIT_WIDTH);
--        else
--            if ((xcnt = 8) and bool(dvi)) then
--                x_list(to_integer(signed(resize(xcnt, 5)) - 1)) <= xin;
--                xcnt <= to_unsigned(1, 4);
--            elsif bool(dvi) then
--                x_list(to_integer(signed(resize(xcnt, 5)) - 1)) <= xin;
--                xcnt <= (xcnt + 1);
--            end if;
--        end if;
--    end if;
--end process MEDIAN_FILTER_RTL_IN;


--yout <= shift_right((y_list(4) + y_list((4 + 1))), 1);

--end architecture MedFilter;
