-- File: cic_filter.vhd1


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



--signal xi: signed (27 downto 0) := to_signed(0, 28);
--signal dvoi: std_logic;
--signal Dec_x: signed (27 downto 0)  := to_signed(0, 28);
--signal Acci_2_x: signed (27 downto 0)  := to_signed(0, 28);
--signal Acci_1_x: signed (27 downto 0)  := to_signed(0, 28);
--signal Int_cnt: unsigned(0 downto 0)  := to_unsigned(0, 1);
--signal Int_x: signed (27 downto 0)  := to_signed(0, 28);
--signal Cmbi_2_subx: signed (27 downto 0)  := to_signed(0, 28);
--signal Cmbi_2_x: signed (27 downto 0)  := to_signed(0, 28);
--signal Cmbi_2_dlyi_1_x: signed (27 downto 0)  := to_signed(0, 28);
--signal Cmbi_1_subx: signed (27 downto 0)  := to_signed(0, 28);
--signal Cmbi_1_x: signed (27 downto 0)  := to_signed(0, 28);
--signal Cmbi_1_dlyi_1_x: signed (27 downto 0)  := to_signed(0, 28);
--signal Cmbi_0_subx: signed (23 downto 0)  := to_signed(0, 24);
--signal Cmbi_0_dlyi_1_x: signed (23 downto 0)   := to_signed(0, 24);

--begin




--CIC_FILTER_CMBI_0_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (rst = '1') then
--            Cmbi_1_x <= to_signed(0, 28);
--        else
--            if (dvi = '1') then
--                Cmbi_1_x <= (resize(x, 28) - Cmbi_0_subx);
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_CMBI_0_RTL;

--CIC_FILTER_CMBI_0_DLYI_0_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (dvi = '1') then
--            Cmbi_0_dlyi_1_x <= x;
--        end if;
--    end if;
--end process CIC_FILTER_CMBI_0_DLYI_0_RTL;

--CIC_FILTER_CMBI_0_DLYI_1_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (dvi = '1') then
--            Cmbi_0_subx <= Cmbi_0_dlyi_1_x;
--        end if;
--    end if;
--end process CIC_FILTER_CMBI_0_DLYI_1_RTL;

--CIC_FILTER_CMBI_1_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (rst = '1') then
--            Cmbi_2_x <= to_signed(0, 28);
--        else
--            if (dvoi ='1') then
--                Cmbi_2_x <= (Cmbi_1_x - Cmbi_1_subx);
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_CMBI_1_RTL;

--CIC_FILTER_CMBI_1_DLYI_0_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (dvoi = '1') then
--            Cmbi_1_dlyi_1_x <= Cmbi_1_x;
--        end if;
--    end if;
--end process CIC_FILTER_CMBI_1_DLYI_0_RTL;

--CIC_FILTER_CMBI_1_DLYI_1_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (dvoi = '1') then
--            Cmbi_1_subx <= Cmbi_1_dlyi_1_x;
--        end if;
--    end if;
--end process CIC_FILTER_CMBI_1_DLYI_1_RTL;

--CIC_FILTER_CMBI_2_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (rst ='1') then
--            Int_x <= to_signed(0, 28);
--        else
--            if (dvoi ='1') then
--                Int_x <= (Cmbi_2_x - Cmbi_2_subx);
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_CMBI_2_RTL;

--CIC_FILTER_CMBI_2_DLYI_0_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (dvoi = '1') then
--            Cmbi_2_dlyi_1_x <= Cmbi_2_x;
--        end if;
--    end if;
--end process CIC_FILTER_CMBI_2_DLYI_0_RTL;

--CIC_FILTER_CMBI_2_DLYI_1_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (dvoi = '1') then
--            Cmbi_2_subx <= Cmbi_2_dlyi_1_x;
--        end if;
--    end if;
--end process CIC_FILTER_CMBI_2_DLYI_1_RTL;

--CIC_FILTER_ACCI_0_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (rst = '1') then
--            Acci_1_x <= to_signed(0, 28);
--        else
--            if (dvoi = '1') then
--                Acci_1_x <= (Acci_1_x + xi);
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_ACCI_0_RTL;

--CIC_FILTER_ACCI_1_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (rst = '1') then
--            Acci_2_x <= to_signed(0, 28);
--        else
--            if (dvoi = '1') then
--                Acci_2_x <= (Acci_2_x + Acci_1_x);
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_ACCI_1_RTL;

--CIC_FILTER_ACCI_2_RTL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (rst = '1') then
--            Dec_x <= to_signed(0, 28);
--        else
--            if (dvoi = '1') then
--                Dec_x <= (Dec_x + Acci_2_x);
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_ACCI_2_RTL;


--y <= Dec_x;
--dvo <= dvoi;

--CIC_FILTER_INT_RTL1: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (rst = '1') then
--            xi <= to_signed(0, 28);
--        else
--            if (dvi = '1') then
--                xi <= Int_x;
--                dvoi <= '1';
--            elsif (Int_cnt > 0) then
--                xi <= to_signed(0, 28);
--                dvoi <= '1';
--            else
--                xi <= to_signed(0, 28);
--                dvoi <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_INT_RTL1;

--CIC_FILTER_INT_RTL2: process (clk) is
--begin
--    if rising_edge(clk) then
--        if (rst = '1') then
--            Int_cnt <= to_unsigned(0, 1);
--        else
--            if (dvi = '1') then
--                Int_cnt <= to_unsigned(2 - 1, 1);
--            elsif (Int_cnt > 0) then
--                Int_cnt <= (Int_cnt + 1);
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_INT_RTL2;

















signal xi: signed (27 downto 0);
signal dvoi: std_logic;
signal combd0_0_subx: signed (23 downto 0);
signal combd0_0_y: signed (27 downto 0);
signal combd0_0_cmb_dly0_0_y: signed (23 downto 0);
signal combd1_0_subx: signed (27 downto 0);
signal combd1_0_y: signed (27 downto 0);
signal combd1_0_cmb_dly2_0_y: signed (27 downto 0);
signal combd2_0_subx: signed (27 downto 0);
signal combd2_0_y: signed (27 downto 0);
signal combd2_0_cmb_dly4_0_y: signed (27 downto 0);
signal accum0_0_y: signed (27 downto 0);
signal accum1_0_y: signed (27 downto 0);
signal accum2_0_y: signed (27 downto 0);
signal interpolate0_0_cnt: unsigned(0 downto 0);

begin




CICFILTER_COMBD0_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(rst) then
            combd0_0_y <= to_signed(0, 28);
        else
            if bool(dvi) then
                combd0_0_y <= (resize(x, 28) - combd0_0_subx);
            end if;
        end if;
    end if;
end process CICFILTER_COMBD0_0_RTL;

CICFILTER_COMBD0_0_CMB_DLY0_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(dvi) then
            combd0_0_cmb_dly0_0_y <= x;
        end if;
    end if;
end process CICFILTER_COMBD0_0_CMB_DLY0_0_RTL;

CICFILTER_COMBD0_0_CMB_DLY1_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(dvi) then
            combd0_0_subx <= combd0_0_cmb_dly0_0_y;
        end if;
    end if;
end process CICFILTER_COMBD0_0_CMB_DLY1_0_RTL;

CICFILTER_COMBD1_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(rst) then
            combd1_0_y <= to_signed(0, 28);
        else
            if bool(dvoi) then
                combd1_0_y <= (combd0_0_y - combd1_0_subx);
            end if;
        end if;
    end if;
end process CICFILTER_COMBD1_0_RTL;

CICFILTER_COMBD1_0_CMB_DLY2_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(dvoi) then
            combd1_0_cmb_dly2_0_y <= combd0_0_y;
        end if;
    end if;
end process CICFILTER_COMBD1_0_CMB_DLY2_0_RTL;

CICFILTER_COMBD1_0_CMB_DLY3_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(dvoi) then
            combd1_0_subx <= combd1_0_cmb_dly2_0_y;
        end if;
    end if;
end process CICFILTER_COMBD1_0_CMB_DLY3_0_RTL;

CICFILTER_COMBD2_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(rst) then
            combd2_0_y <= to_signed(0, 28);
        else
            if bool(dvoi) then
                combd2_0_y <= (combd1_0_y - combd2_0_subx);
            end if;
        end if;
    end if;
end process CICFILTER_COMBD2_0_RTL;

CICFILTER_COMBD2_0_CMB_DLY4_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(dvoi) then
            combd2_0_cmb_dly4_0_y <= combd1_0_y;
        end if;
    end if;
end process CICFILTER_COMBD2_0_CMB_DLY4_0_RTL;

CICFILTER_COMBD2_0_CMB_DLY5_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(dvoi) then
            combd2_0_subx <= combd2_0_cmb_dly4_0_y;
        end if;
    end if;
end process CICFILTER_COMBD2_0_CMB_DLY5_0_RTL;

CICFILTER_ACCUM0_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(rst) then
            accum0_0_y <= to_signed(0, 28);
        else
            if bool(dvoi) then
                accum0_0_y <= (accum0_0_y + xi);
            end if;
        end if;
    end if;
end process CICFILTER_ACCUM0_0_RTL;

CICFILTER_ACCUM1_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(rst) then
            accum1_0_y <= to_signed(0, 28);
        else
            if bool(dvoi) then
                accum1_0_y <= (accum1_0_y + accum0_0_y);
            end if;
        end if;
    end if;
end process CICFILTER_ACCUM1_0_RTL;

CICFILTER_ACCUM2_0_RTL: process (clk) is
begin
    if rising_edge(clk) then
        if bool(rst) then
            accum2_0_y <= to_signed(0, 28);
        else
            if bool(dvoi) then
                accum2_0_y <= (accum2_0_y + accum1_0_y);
            end if;
        end if;
    end if;
end process CICFILTER_ACCUM2_0_RTL;


y <= accum2_0_y;
dvo <= dvoi;

CICFILTER_INTERPOLATE0_0_RTL1: process (clk) is
begin
    if rising_edge(clk) then
        if bool(rst) then
            xi <= to_signed(0, 28);
        else
            if bool(dvi) then
                xi <= combd2_0_y;
                dvoi <= '1';
            elsif (interpolate0_0_cnt > 0) then
                xi <= to_signed(0, 28);
                dvoi <= '1';
            else
                xi <= to_signed(0, 28);
                dvoi <= '0';
            end if;
        end if;
    end if;
end process CICFILTER_INTERPOLATE0_0_RTL1;

CICFILTER_INTERPOLATE0_0_RTL2: process (clk) is
begin
    if rising_edge(clk) then
        if bool(rst) then
            interpolate0_0_cnt <= to_unsigned(0, 1);
        else
            if bool(dvi) then
                interpolate0_0_cnt <= to_unsigned(2 - 1, 1);
            elsif (interpolate0_0_cnt > 0) then
                interpolate0_0_cnt <= (interpolate0_0_cnt + 1);
            end if;
        end if;
    end if;
end process CICFILTER_INTERPOLATE0_0_RTL2;





end architecture cic_filter_arch;



--LIBRARY IEEE;
--USE IEEE.std_logic_1164.all;
--use ieee.numeric_std.all;

---- implementazione del CIC con organizzazione classica
---- ovvero comb - zeroinsertion - integrator

---- ho inserito due clock per evitare l inserimento di un
---- oscillatore interno. Essendo uno strumento di 
---- interpolazione, la frequenza di uscita sar? maggiore
---- di quella di ingresso,

--ENTITY cic_filter IS
--  generic (
--          SIG_IN_WIDTH :integer := 24;
--        SIG_OUT_WIDTH :integer := 24
--  );
--  port(
--    x  : in std_logic_vector(SIG_IN_WIDTH-1 downto 0);
--    clock_slow     : in std_logic;
--    clock_fast     : in std_logic;
--    rst       : in std_logic; 
--    y     : out std_logic_vector(SIG_IN_WIDTH-1 downto 0);
--    dvo : out std_logic
--  );
--END cic_filter;

--architecture BEHAVIOURAL of cic_filter is
  
--  component integrator_block
--  generic (N:integer );
--  port(
--    input      : in std_logic_vector(N-1 downto 0);
--    carry_in   : in std_logic;
--    clock     : in std_logic;
--    reset     : in std_logic;
--    carry_out : out std_logic;
--    output     : out std_logic_vector(N-1 downto 0)
--  );
--end component;

--component comb_block_c
--  generic (N:integer );
--  port(
--    input      : in std_logic_vector(N-1 downto 0);
--    carry_in   : in std_logic;
--    clock     : in std_logic;
--    reset     : in std_logic;
--    carry_out : out std_logic;
--    output     : out std_logic_vector(N-1 downto 0)
--  );
--end component;

--component shifter_n 
--generic (M:integer ; N:integer);
--  port (
--    input : in std_logic_vector(M-1 downto 0);
--    output : out std_logic_vector(N-1 downto 0)
--  );   
--end component; 
 

--component zero_insertion 
--  generic (N: integer);
--  port(
--    x       : in std_logic_vector(N-1 downto 0);
--    clock     : in std_logic;
--    reset     : in std_logic;
--    y     : out std_logic_vector(N-1 downto 0)  
--  );
--END component;


---- la costante M ? calcolata secondo una precisa formula,
---- descritta nella relazione. La formula prevede
---- il calcolo della dimensione massima di ogni stadio,
---- compreso l ultimo (M)
--constant M : integer := SIG_IN_WIDTH+6;

---- Ho usato un array di carry out per facilitare
---- il debug. Infatti se il filtro funziona, non avremo
---- mai carry out, e questo ? verificabile 
---- ispezioanndo l array
--type myarray is array(7 downto 0) of std_logic;
--signal carry : myarray ;


---- sono stati usati numerosi segnali separati
---- per interconnettere i vari step
---- Questo permette anche un facile debug, infatti
---- il segnale9 ? quello che esce dall ultimo stadio
---- integrator e a M bit, cosi da verificarne la
---- forma d onda con la versione arrotondata al
---- bit MSB o LSB
--signal xe : std_logic_vector(SIG_IN_WIDTH downto 0) ;
--signal segnale1 : std_logic_vector(SIG_IN_WIDTH downto 0) ;
--signal segnale2 : std_logic_vector(SIG_IN_WIDTH+1 downto 0) ;
--signal segnale3 : std_logic_vector(SIG_IN_WIDTH+2 downto 0) ;
--signal segnale4 : std_logic_vector(SIG_IN_WIDTH+3 downto 0) ;
--signal segnale5 : std_logic_vector(SIG_IN_WIDTH+3 downto 0) ;
--signal segnale6 : std_logic_vector(SIG_IN_WIDTH+3 downto 0) ;
--signal segnale7 : std_logic_vector(SIG_IN_WIDTH+3 downto 0) ;
--signal segnale8 : std_logic_vector(SIG_IN_WIDTH+4 downto 0) ;
--signal segnale9 : std_logic_vector(SIG_IN_WIDTH+5 downto 0) ;

--signal segnale1e : std_logic_vector(SIG_IN_WIDTH+1 downto 0) ;
--signal segnale2e : std_logic_vector(SIG_IN_WIDTH+2 downto 0) ;
--signal segnale3e : std_logic_vector(SIG_IN_WIDTH+3 downto 0) ;
--signal segnale4e : std_logic_vector(SIG_IN_WIDTH+4 downto 0) ;
--signal segnale5e : std_logic_vector(SIG_IN_WIDTH+4 downto 0) ;
--signal segnale6e : std_logic_vector(SIG_IN_WIDTH+4 downto 0) ;
--signal segnale7e : std_logic_vector(SIG_IN_WIDTH+4 downto 0) ;
--signal segnale8e : std_logic_vector(SIG_IN_WIDTH+5 downto 0) ;
  
--signal check : std_logic := '0';
  
--begin
          
  
--  SH1: shifter_n
--  generic map( SIG_IN_WIDTH,SIG_IN_WIDTH+1)
--  port map(x,xe); 
  
--  COMB0: comb_block_c
--  generic map(SIG_IN_WIDTH+1)
--  port map(xe,'0',clock_slow,rst,carry(0),segnale1);
 
--  SH2: shifter_n
--  generic map(SIG_IN_WIDTH+1,SIG_IN_WIDTH+2)
--  port map(segnale1,segnale1e);    
    
--  COMB1: comb_block_c
--  generic map(SIG_IN_WIDTH+2)
--  port map(segnale1e,'0',clock_slow,rst,carry(1),segnale2);
  
--  SH3: shifter_n
--  generic map(SIG_IN_WIDTH+2,SIG_IN_WIDTH+3)
--  port map(segnale2,segnale2e);  
    
--  COMB2: comb_block_c
--  generic map(SIG_IN_WIDTH+3)
--  port map(segnale2e,'0',clock_slow,rst,carry(2),segnale3);
    
--  SH4: shifter_n
--  generic map(SIG_IN_WIDTH+3,SIG_IN_WIDTH+4)
--  port map(segnale3,segnale3e); 
    
--  COMB3: comb_block_c
--  generic map(SIG_IN_WIDTH+4)
--  port map(segnale3e,'0',clock_slow,rst,carry(3),segnale4);
    
--  ZIN: zero_insertion
--  generic map(SIG_IN_WIDTH+4)
--  port map(segnale4,clock_fast,rst,segnale5);
    
--  INT1: integrator_block
--  generic map(SIG_IN_WIDTH+4)
--  port map(segnale5,'0',clock_fast,rst,carry(4),segnale6);
    
--  INT2: integrator_block
--  generic map(SIG_IN_WIDTH+4)
--  port map(segnale6,'0',clock_fast,rst,carry(5),segnale7);
    
--  SH5: shifter_n
--  generic map(SIG_IN_WIDTH+4,SIG_IN_WIDTH+5)
--  port map(segnale7,segnale7e); 
  
--  INT3: integrator_block
--  generic map(SIG_IN_WIDTH+5)
--  port map(segnale7e,'0',clock_fast,rst,carry(6),segnale8);
    
--  SH6: shifter_n
--  generic map(SIG_IN_WIDTH+5,SIG_IN_WIDTH+6)
--  port map(segnale8,segnale8e); 

--  INT4: integrator_block
--  generic map(SIG_IN_WIDTH+6)
--  port map(segnale8e,'0',clock_fast,rst,carry(7),segnale9);
    
---- sull ultimo segnale avviene la semplificazione 
---- sul MSB, ovvero si tagliano i picchi:
---- se il valore di y ? piu grande del massimo
---- rappresentabile, in y va il massimo rappresentabile
---- altrimenti se supera il limite inferiore, in y
---- avremo il valore minimo possibile su SIG_IN_WIDTH bit
--  process(segnale9)
--    begin
--      TRUK: for i in 0 to SIG_IN_WIDTH-1 loop
--        y(i) <= segnale9(i);
--      end loop;

    
--    if segnale9(M-1) = '0' then
--      DIO1: for i in M-2 downto SIG_IN_WIDTH-1 loop
--        if segnale9(i) /= '0' then
--          y <= ("0111111111111111"&"11111111" );
--          exit;
--        end if;
--      end loop;
--    end if;
--    if segnale9(M-1) = '1' then
--      DIO2: for i in M-2 downto SIG_IN_WIDTH-1 loop
--        if segnale9(i) /= '1' then
--          y <= ("1000000000000000"&"00000000");
--          exit;
--        end if;
--      end loop;
--    end if;
   

-- end process;

    
--end BEHAVIOURAL;




--M=6, D=1, R=2
--entity cic_filter is
--generic (
--        SIG_IN_WIDTH :integer := 24;
--        SIG_OUT_WIDTH :integer := 31
--    );
--    port (
--        clk: in std_logic;
--        rst: in std_logic;
--        x: in signed (23 downto 0);
--        dvi: in std_logic;
--        y: out signed (SIG_OUT_WIDTH-1 downto 0);
--        dvo: out std_logic
--    );
--end entity cic_filter;
---- The complet CIC filter
---- 
---- Inputs:
----     x (data): the x(n) data in feed
----     ------------------------
----     dvi (bool): the exstiror calc hold input. calc is done only if 
----     `dvi` is True
----     
----     clk(bool): clock feed
----     rst(bool): reset feed
---- 
---- Outputs:
----     y (data):  the y(n) output of y(n)=y(n-1)+x(n)
----     ----------------------
----     dvo: the exstior calc hold output. will be false if 
----     `dvi` is False
---- Parm:
----     M: the number of stages
----     D: the Z delay order
----     R: the decimation/Interpolation ratio
----     Type (None, 'Dec', 'Interp'): type of CIC filter
--architecture cic_filter_arch of cic_filter is



--signal Interp_Comb_DWire: signed (30 downto 0);
--signal Interp_Comp_EWire: std_logic;
--signal Dec_ena_in: std_logic;
--signal Dec_x: signed (30 downto 0);
--signal Integrtor_i_5_ena_in: std_logic;
--signal Integrtor_i_5_x: signed (30 downto 0);
--signal Integrtor_i_4_ena_in: std_logic;
--signal Integrtor_i_4_x: signed (30 downto 0);
--signal Integrtor_i_3_ena_in: std_logic;
--signal Integrtor_i_3_x: signed (30 downto 0);
--signal Integrtor_i_2_ena_in: std_logic;
--signal Integrtor_i_2_x: signed (30 downto 0);
--signal Integrtor_i_1_ena_in: std_logic;
--signal Integrtor_i_1_x: signed (30 downto 0);
--signal Integrtor_i_0_ena_in: std_logic;
--signal Integrtor_i_0_x: signed (30 downto 0);
--signal Comb_i_5_ena_in: std_logic;
--signal Comb_i_5_x: signed (30 downto 0);
--signal Comb_i_5_subx: signed (30 downto 0);
--signal Comb_i_4_ena_in: std_logic;
--signal Comb_i_4_x: signed (30 downto 0);
--signal Comb_i_4_subx: signed (30 downto 0);
--signal Comb_i_3_ena_in: std_logic;
--signal Comb_i_3_x: signed (30 downto 0);
--signal Comb_i_3_subx: signed (30 downto 0);
--signal Comb_i_2_ena_in: std_logic;
--signal Comb_i_2_x: signed (30 downto 0);
--signal Comb_i_2_subx: signed (30 downto 0);
--signal Comb_i_1_ena_in: std_logic;
--signal Comb_i_1_x: signed (30 downto 0);
--signal Comb_i_1_subx: signed (30 downto 0);
--signal Comb_i_0_subx: signed (30 downto 0);
--signal Interp_count: unsigned(0 downto 0);

--begin




--CIC_FILTER_INTERP_PASSCONTROL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Interp_Comb_DWire <= to_signed(0, 31);
--        else
--            if bool(dvi) then
--                Interp_Comb_DWire <= resize(x, 31);
--                Interp_Comp_EWire <= '1';
--            elsif (Interp_count > 0) then
--                Interp_Comb_DWire <= to_signed(0, 31);
--                Interp_Comp_EWire <= '1';
--            else
--                Interp_Comb_DWire <= to_signed(0, 31);
--                Interp_Comp_EWire <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_INTERP_PASSCONTROL;

--CIC_FILTER_INTERP_COUNTCONTROL: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Interp_count <= to_unsigned(0, 1);
--        else
--            if bool(dvi) then
--                Interp_count <= to_unsigned(2 - 1, 1);
--            elsif (Interp_count > 0) then
--                Interp_count <= (Interp_count + 1);
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_INTERP_COUNTCONTROL;

--CIC_FILTER_COMB_I_0_ZDELAY_I_0_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(Interp_Comp_EWire) then
--            Comb_i_0_subx <= Interp_Comb_DWire;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_0_ZDELAY_I_0_LOGIC;

--CIC_FILTER_COMB_I_0_LOGC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Comb_i_1_x <= to_signed(0, 31);
--        else
--            if bool(Interp_Comp_EWire) then
--                Comb_i_1_x <= (Interp_Comb_DWire - Comb_i_0_subx);
--                Comb_i_1_ena_in <= '1';
--            else
--                Comb_i_1_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_0_LOGC;

--CIC_FILTER_COMB_I_1_ZDELAY_I_0_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(Comb_i_1_ena_in) then
--            Comb_i_1_subx <= Comb_i_1_x;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_1_ZDELAY_I_0_LOGIC;

--CIC_FILTER_COMB_I_1_LOGC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Comb_i_2_x <= to_signed(0, 31);
--        else
--            if bool(Comb_i_1_ena_in) then
--                Comb_i_2_x <= (Comb_i_1_x - Comb_i_1_subx);
--                Comb_i_2_ena_in <= '1';
--            else
--                Comb_i_2_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_1_LOGC;

--CIC_FILTER_COMB_I_2_ZDELAY_I_0_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(Comb_i_2_ena_in) then
--            Comb_i_2_subx <= Comb_i_2_x;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_2_ZDELAY_I_0_LOGIC;

--CIC_FILTER_COMB_I_2_LOGC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Comb_i_3_x <= to_signed(0, 31);
--        else
--            if bool(Comb_i_2_ena_in) then
--                Comb_i_3_x <= (Comb_i_2_x - Comb_i_2_subx);
--                Comb_i_3_ena_in <= '1';
--            else
--                Comb_i_3_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_2_LOGC;

--CIC_FILTER_COMB_I_3_ZDELAY_I_0_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(Comb_i_3_ena_in) then
--            Comb_i_3_subx <= Comb_i_3_x;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_3_ZDELAY_I_0_LOGIC;

--CIC_FILTER_COMB_I_3_LOGC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Comb_i_4_x <= to_signed(0, 31);
--        else
--            if bool(Comb_i_3_ena_in) then
--                Comb_i_4_x <= (Comb_i_3_x - Comb_i_3_subx);
--                Comb_i_4_ena_in <= '1';
--            else
--                Comb_i_4_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_3_LOGC;

--CIC_FILTER_COMB_I_4_ZDELAY_I_0_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(Comb_i_4_ena_in) then
--            Comb_i_4_subx <= Comb_i_4_x;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_4_ZDELAY_I_0_LOGIC;

--CIC_FILTER_COMB_I_4_LOGC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Comb_i_5_x <= to_signed(0, 31);
--        else
--            if bool(Comb_i_4_ena_in) then
--                Comb_i_5_x <= (Comb_i_4_x - Comb_i_4_subx);
--                Comb_i_5_ena_in <= '1';
--            else
--                Comb_i_5_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_4_LOGC;

--CIC_FILTER_COMB_I_5_ZDELAY_I_0_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(Comb_i_5_ena_in) then
--            Comb_i_5_subx <= Comb_i_5_x;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_5_ZDELAY_I_0_LOGIC;

--CIC_FILTER_COMB_I_5_LOGC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Integrtor_i_0_x <= to_signed(0, 31);
--        else
--            if bool(Comb_i_5_ena_in) then
--                Integrtor_i_0_x <= (Comb_i_5_x - Comb_i_5_subx);
--                Integrtor_i_0_ena_in <= '1';
--            else
--                Integrtor_i_0_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_COMB_I_5_LOGC;

--CIC_FILTER_INTEGRTOR_I_0_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Integrtor_i_1_x <= to_signed(0, 31);
--        else
--            if bool(Integrtor_i_0_ena_in) then
--                Integrtor_i_1_x <= (Integrtor_i_1_x + Integrtor_i_0_x);
--                Integrtor_i_1_ena_in <= '1';
--            else
--                Integrtor_i_1_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_INTEGRTOR_I_0_LOGIC;

--CIC_FILTER_INTEGRTOR_I_1_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Integrtor_i_2_x <= to_signed(0, 31);
--        else
--            if bool(Integrtor_i_1_ena_in) then
--                Integrtor_i_2_x <= (Integrtor_i_2_x + Integrtor_i_1_x);
--                Integrtor_i_2_ena_in <= '1';
--            else
--                Integrtor_i_2_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_INTEGRTOR_I_1_LOGIC;

--CIC_FILTER_INTEGRTOR_I_2_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Integrtor_i_3_x <= to_signed(0, 31);
--        else
--            if bool(Integrtor_i_2_ena_in) then
--                Integrtor_i_3_x <= (Integrtor_i_3_x + Integrtor_i_2_x);
--                Integrtor_i_3_ena_in <= '1';
--            else
--                Integrtor_i_3_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_INTEGRTOR_I_2_LOGIC;

--CIC_FILTER_INTEGRTOR_I_3_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Integrtor_i_4_x <= to_signed(0, 31);
--        else
--            if bool(Integrtor_i_3_ena_in) then
--                Integrtor_i_4_x <= (Integrtor_i_4_x + Integrtor_i_3_x);
--                Integrtor_i_4_ena_in <= '1';
--            else
--                Integrtor_i_4_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_INTEGRTOR_I_3_LOGIC;

--CIC_FILTER_INTEGRTOR_I_4_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Integrtor_i_5_x <= to_signed(0, 31);
--        else
--            if bool(Integrtor_i_4_ena_in) then
--                Integrtor_i_5_x <= (Integrtor_i_5_x + Integrtor_i_4_x);
--                Integrtor_i_5_ena_in <= '1';
--            else
--                Integrtor_i_5_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_INTEGRTOR_I_4_LOGIC;

--CIC_FILTER_INTEGRTOR_I_5_LOGIC: process (clk) is
--begin
--    if rising_edge(clk) then
--        if bool(rst) then
--            Dec_x <= to_signed(0, 31);
--        else
--            if bool(Integrtor_i_5_ena_in) then
--                Dec_x <= (Dec_x + Integrtor_i_5_x);
--                Dec_ena_in <= '1';
--            else
--                Dec_ena_in <= '0';
--            end if;
--        end if;
--    end if;
--end process CIC_FILTER_INTEGRTOR_I_5_LOGIC;


--y <= Dec_x;
--dvo <= Dec_ena_in;

--end architecture cic_filter_arch;
