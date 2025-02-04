----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/27/2020 08:46:06 PM
-- Design Name: 
-- Module Name: pck_interpolator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pck_interpolator is

    function MY_TO_INTEGER (ARG: SIGNED) return INTEGER;
    function MY_TO_INTEGER (ARG: UNSIGNED) return NATURAL;

    attribute enum_encoding: string;

--    function stdl (arg: boolean) return std_logic;

--    function stdl (arg: integer) return std_logic;

--    function to_unsigned (arg: boolean; size: natural) return unsigned;

--    function to_signed (arg: boolean; size: natural) return signed;

--    function to_integer(arg: boolean) return integer;

--    function to_integer(arg: std_logic) return integer;

--    function to_unsigned (arg: std_logic; size: natural) return unsigned;

--    function to_signed (arg: std_logic; size: natural) return signed;

    function bool (arg: std_logic) return boolean;

    function bool (arg: unsigned) return boolean;

    function bool (arg: signed) return boolean;

    function bool (arg: integer) return boolean;

    function "-" (arg: unsigned) return signed;

    function tern_op(cond: boolean; if_true: std_logic; if_false: std_logic) return std_logic;

    function tern_op(cond: boolean; if_true: unsigned; if_false: unsigned) return unsigned;

    function tern_op(cond: boolean; if_true: signed; if_false: signed) return signed;

end pck_interpolator;


package body pck_interpolator is


    constant NO_WARNING: BOOLEAN := FALSE; -- default to emit warnings

    function stdl (arg: boolean) return std_logic is
    begin
        if arg then
            return '1';
        else
            return '0';
        end if;
    end function stdl;

    function stdl (arg: integer) return std_logic is
    begin
        if arg /= 0 then
            return '1';
        else
            return '0';
        end if;
    end function stdl;
    
    
    function MY_TO_INTEGER1 (ARG: SIGNED) return INTEGER is
    variable XARG: SIGNED(ARG'LENGTH-1 downto 0);
  begin
    if (ARG'LENGTH < 1) then
      assert NO_WARNING
          report "NUMERIC_CUS.MY_TO_INTEGER: null detected, returning 0"
          severity WARNING;
      return 0;
    end if;
    XARG := TO_01(ARG, 'X');
    if (XARG(XARG'LEFT)='X') then
      assert NO_WARNING
          report "NUMERIC_CUS.MY_TO_INTEGER: metavalue detected, returning 0"
          severity WARNING;
      return 0;
    end if;
    if XARG(XARG'LEFT) = '0' then
      return MY_TO_INTEGER(UNSIGNED(XARG));
    else
      return (- (MY_TO_INTEGER(UNSIGNED(- (XARG + 1)))) -1);
    end if;
  end MY_TO_INTEGER1;


-- Id: D.1
  function MY_TO_INTEGER1 (ARG: UNSIGNED) return NATURAL is
    constant ARG_LEFT: INTEGER := ARG'LENGTH-1;
    alias XXARG: UNSIGNED(ARG_LEFT downto 0) is ARG;
    variable XARG: UNSIGNED(ARG_LEFT downto 0);
    variable RESULT: NATURAL := 0;
  begin
    if (ARG'LENGTH < 1) then
      assert NO_WARNING
          report "NUMERIC_CUS.TO_INTEGER: null detected, returning 0"
          severity WARNING;
      return 0;
    end if;
    XARG := TO_01(XXARG, 'X');
    if (XARG(XARG'LEFT)='X') then
      assert NO_WARNING
          report "NUMERIC_CUS.TO_INTEGER: metavalue detected, returning 0"
          severity WARNING;
      return 0;
    end if;
    for I in XARG'RANGE loop
      report "result'value = " & integer'image(RESULT);
      RESULT := RESULT+RESULT;
      if XARG(I) = '1' then
        RESULT := RESULT + 1;
      end if;
    end loop;
    return RESULT;
  end MY_TO_INTEGER1;
  
  
  -- Id: D.1
function MY_TO_INTEGER(ARG: UNSIGNED) return NATURAL is
    constant ARG_LEFT:INTEGER:= ARG'length-1;
    alias XXARG:UNSIGNED(ARG_LEFT downto 0) is ARG;
    variable XARG:UNSIGNED(ARG_LEFT downto 0); 
    variable RESULT: NATURAL:= 0;
    variable w : INTEGER:= 1;  -- weight factor
begin
  if (ARG'length<1) then
    assert NO_WARNING
    report "numeric_cus.TO_INTEGER: null arg"
    severity warning;
    return 0;
    end if;
  XARG:= TO_01(XXARG);
  if (XARG(XARG'left)='X') then
    assert NO_WARNING
    report "numeric_cus.TO_INTEGER: metavalue arg set to 0"
    severity warning;
    return 0;
    end if;
  for i in XARG'reverse_range loop
    if XARG (i) = '1' then
      RESULT:= RESULT + w;
      end if;
    if (i /= XARG'left) then w := w + w;
      end if;
    end loop;
  return RESULT;
  end MY_TO_INTEGER;

     -- Id: D.2
function MY_TO_INTEGER(ARG: SIGNED) return INTEGER is
begin
  if ARG(ARG'left) = '0' then
    return MY_TO_INTEGER( UNSIGNED (ARG)) ;
  else
    return (- (MY_TO_INTEGER( UNSIGNED ( - (ARG + 1)))) -1);
    end if;
  end MY_TO_INTEGER;

--    function to_unsigned (arg: boolean; size: natural) return unsigned is
--        variable res: unsigned(size-1 downto 0) := (others => '0');
--    begin
--        if arg then
--            res(0):= '1';
--        end if;
--        return res;
--    end function to_unsigned;

--    function to_signed (arg: boolean; size: natural) return signed is
--        variable res: signed(size-1 downto 0) := (others => '0');
--    begin
--        if arg then
--            res(0) := '1';
--        end if;
--        return res; 
--    end function to_signed;

--    function to_integer(arg: boolean) return integer is
--    begin
--        if arg then
--            return 1;
--        else
--            return 0;
--        end if;
--    end function to_integer;

--    function to_integer(arg: std_logic) return integer is
--    begin
--        if arg = '1' then
--            return 1;
--        else
--            return 0;
--        end if;
--    end function to_integer;

--    function to_unsigned (arg: std_logic; size: natural) return unsigned is
--        variable res: unsigned(size-1 downto 0) := (others => '0');
--    begin
--        res(0):= arg;
--        return res;
--    end function to_unsigned;

--    function to_signed (arg: std_logic; size: natural) return signed is
--        variable res: signed(size-1 downto 0) := (others => '0');
--    begin
--        res(0) := arg;
--        return res; 
--    end function to_signed;

    function bool (arg: std_logic) return boolean is
    begin
        return arg = '1';
    end function bool;

    function bool (arg: unsigned) return boolean is
    begin
        return arg /= 0;
    end function bool;

    function bool (arg: signed) return boolean is
    begin
        return arg /= 0;
    end function bool;

    function bool (arg: integer) return boolean is
    begin
        return arg /= 0;
    end function bool;

    function "-" (arg: unsigned) return signed is
    begin
        return - signed(resize(arg, arg'length+1));
    end function "-";

    function tern_op(cond: boolean; if_true: std_logic; if_false: std_logic) return std_logic is
    begin
        if cond then
            return if_true;
        else
            return if_false;
        end if;
    end function tern_op;

    function tern_op(cond: boolean; if_true: unsigned; if_false: unsigned) return unsigned is
    begin
        if cond then
            return if_true;
        else
            return if_false;
        end if;
    end function tern_op;

    function tern_op(cond: boolean; if_true: signed; if_false: signed) return signed is
    begin
        if cond then
            return if_true;
        else
            return if_false;
        end if;
    end function tern_op;

end pck_interpolator;
