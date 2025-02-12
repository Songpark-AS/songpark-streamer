-- File: cic_filter.vhd
-- Generated by MyHDL 0.10
-- Date: Thu Aug 27 20:41:04 2020


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

use work.pck_interpolator.all;

entity cic_filter is
generic (
        SIG_IN_WIDTH :integer := 24;
        SIG_OUT_WIDTH :integer := 28
    );
port (
        clk: in std_logic;
        rst: in std_logic;
        x: in signed (23 downto 0);
        dvi: in std_logic;
        y: out signed (27 downto 0);
        dvo: out std_logic
    );
end entity cic_filter;
-- Cascade Integrator-Comb (CIC) Filter
-- 
-- This module is an fixed-point implementation of CIC filter with configurable
-- parameters.
-- 
-- Ports:
-- ------
-- clk:  System clock, must be equal to or greater than the max
--       sample rate after interpolation or before decimation
-- rst:  System reset
-- x:    2's compliment input
-- dvi:  data valid input, flow control signal for the different rates
-- y:    2's compliment output
-- dvo:  data valid output, flow control signal for the different rates
-- 
-- Parameters:
-- -----------
-- M:      CIC order
-- D:      Comb delay
-- R:      Decimation/interpolation value
-- Q:      Input word size (7,15,31...)
-- Type:   'Dec', 'Int', 'UpDown', or None

architecture cic_filter_arch of cic_filter is



signal xi: signed (27 downto 0) := to_signed(0, 28);
signal dvoi: std_logic;
signal Dec_x: signed (27 downto 0)  := to_signed(0, 28);
signal Acci_2_x: signed (27 downto 0)  := to_signed(0, 28);
signal Acci_1_x: signed (27 downto 0)  := to_signed(0, 28);
signal Int_cnt: unsigned(0 downto 0)  := to_unsigned(0, 1);
signal Int_x: signed (27 downto 0)  := to_signed(0, 28);
signal Cmbi_2_subx: signed (27 downto 0)  := to_signed(0, 28);
signal Cmbi_2_x: signed (27 downto 0)  := to_signed(0, 28);
signal Cmbi_2_dlyi_1_x: signed (27 downto 0)  := to_signed(0, 28);
signal Cmbi_1_subx: signed (27 downto 0)  := to_signed(0, 28);
signal Cmbi_1_x: signed (27 downto 0)  := to_signed(0, 28);
signal Cmbi_1_dlyi_1_x: signed (27 downto 0)  := to_signed(0, 28);
signal Cmbi_0_subx: signed (23 downto 0)  := to_signed(0, 24);
signal Cmbi_0_dlyi_1_x: signed (23 downto 0)   := to_signed(0, 24);

begin




CIC_FILTER_CMBI_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (rst = '1') then
            Cmbi_1_x <= to_signed(0, 28);
        else
            if (dvi = '1') then
                Cmbi_1_x <= (resize(x, 28) - Cmbi_0_subx);
            end if;
        end if;
    end if;
end process CIC_FILTER_CMBI_0_RTL;

CIC_FILTER_CMBI_0_DLYI_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (dvi = '1') then
            Cmbi_0_dlyi_1_x <= x;
        end if;
    end if;
end process CIC_FILTER_CMBI_0_DLYI_0_RTL;

CIC_FILTER_CMBI_0_DLYI_1_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (dvi = '1') then
            Cmbi_0_subx <= Cmbi_0_dlyi_1_x;
        end if;
    end if;
end process CIC_FILTER_CMBI_0_DLYI_1_RTL;

CIC_FILTER_CMBI_1_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (rst = '1') then
            Cmbi_2_x <= to_signed(0, 28);
        else
            if (dvoi ='1') then
                Cmbi_2_x <= (Cmbi_1_x - Cmbi_1_subx);
            end if;
        end if;
    end if;
end process CIC_FILTER_CMBI_1_RTL;

CIC_FILTER_CMBI_1_DLYI_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (dvoi = '1') then
            Cmbi_1_dlyi_1_x <= Cmbi_1_x;
        end if;
    end if;
end process CIC_FILTER_CMBI_1_DLYI_0_RTL;

CIC_FILTER_CMBI_1_DLYI_1_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (dvoi = '1') then
            Cmbi_1_subx <= Cmbi_1_dlyi_1_x;
        end if;
    end if;
end process CIC_FILTER_CMBI_1_DLYI_1_RTL;

CIC_FILTER_CMBI_2_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (rst ='1') then
            Int_x <= to_signed(0, 28);
        else
            if (dvoi ='1') then
                Int_x <= (Cmbi_2_x - Cmbi_2_subx);
            end if;
        end if;
    end if;
end process CIC_FILTER_CMBI_2_RTL;

CIC_FILTER_CMBI_2_DLYI_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (dvoi = '1') then
            Cmbi_2_dlyi_1_x <= Cmbi_2_x;
        end if;
    end if;
end process CIC_FILTER_CMBI_2_DLYI_0_RTL;

CIC_FILTER_CMBI_2_DLYI_1_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (dvoi = '1') then
            Cmbi_2_subx <= Cmbi_2_dlyi_1_x;
        end if;
    end if;
end process CIC_FILTER_CMBI_2_DLYI_1_RTL;

CIC_FILTER_ACCI_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (rst = '1') then
            Acci_1_x <= to_signed(0, 28);
        else
            if (dvoi = '1') then
                Acci_1_x <= (Acci_1_x + xi);
            end if;
        end if;
    end if;
end process CIC_FILTER_ACCI_0_RTL;

CIC_FILTER_ACCI_1_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (rst = '1') then
            Acci_2_x <= to_signed(0, 28);
        else
            if (dvoi = '1') then
                Acci_2_x <= (Acci_2_x + Acci_1_x);
            end if;
        end if;
    end if;
end process CIC_FILTER_ACCI_1_RTL;

CIC_FILTER_ACCI_2_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if (rst = '1') then
            Dec_x <= to_signed(0, 28);
        else
            if (dvoi = '1') then
                Dec_x <= (Dec_x + Acci_2_x);
            end if;
        end if;
    end if;
end process CIC_FILTER_ACCI_2_RTL;


y <= Dec_x;
dvo <= dvoi;

CIC_FILTER_INT_RTL1: process (clk) is
begin
    if rising_edge(clk) then
        if (rst = '1') then
            xi <= to_signed(0, 28);
        else
            if (dvi = '1') then
                xi <= Int_x;
                dvoi <= '1';
            elsif (Int_cnt > 0) then
                xi <= to_signed(0, 28);
                dvoi <= '1';
            else
                xi <= to_signed(0, 28);
                dvoi <= '0';
            end if;
        end if;
    end if;
end process CIC_FILTER_INT_RTL1;

CIC_FILTER_INT_RTL2: process (clk) is
begin
    if rising_edge(clk) then
        if (rst = '1') then
            Int_cnt <= to_unsigned(0, 1);
        else
            if (dvi = '1') then
                Int_cnt <= to_unsigned(2 - 1, 1);
            elsif (Int_cnt > 0) then
                Int_cnt <= (Int_cnt + 1);
            end if;
        end if;
    end if;
end process CIC_FILTER_INT_RTL2;

end architecture cic_filter_arch;
