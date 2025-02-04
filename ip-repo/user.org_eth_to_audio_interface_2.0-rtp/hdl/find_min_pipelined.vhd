library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
 
entity RTLTD_SLV_PIPELINE_SEARCH is
--Pipeline search, log(n)+1 clocks, n-1 comparators if data size is power of 2;
--Not to be used until thoroughly tested, it has not been!
 
  generic (
    C_MAX_DATA_SIZE : integer := 64;
    C_DATA_SIZE     : integer := 21
    );
   
  port (
    aclk            : in  std_logic; --usual
    aresetn         : in  std_logic  --culprits
    );
     
end RTLTD_SLV_PIPELINE_SEARCH;
     
architecture arch_imp of RTLTD_SLV_PIPELINE_SEARCH is

  type T_DATA  is array(C_DATA_SIZE-1   downto 0) of integer range 0 to 65535;
  type T_INDEX is array(C_DATA_SIZE / 2 downto 0) of integer range 0 to C_MAX_DATA_SIZE - 1;
  type T_STATE is (ST_IDLE, ST_SRCH);
  signal state      : T_STATE;
  signal idx        : T_INDEX;
  signal data_in    : T_DATA;
  signal ps_reset   : std_logic; -- soft reset from, usually, my control register interface
  signal find_min   : std_logic; -- '1' to find smallest 
  signal start_f    : std_logic; -- single cycle start pulse
  signal done_f     : std_logic; -- single cycle end pulse
  signal srch_idx   : integer range 0 to C_DATA_SIZE - 1; --result of search
  signal len     : integer range 0 to C_DATA_SIZE / 2; --used in algorithm
  
begin

  
search : process( aclk )
  begin
    if (rising_edge( aclk )) then
      if (( aresetn = '0' ) or ( ps_reset = '1' )) then
        state   <= ST_IDLE;
        done_f  <= '0';
      else 
        case state is
          when ST_IDLE =>
            done_f <= '0';
            
            if (start_f = '1') then
              len <= shift_right(to_unsigned(data_in'length,15), 1); --if odd we lose a value so must check it at the end
              for i in shift_right(data_in'length ,1) downto 0 loop idx(i) <= i; end loop; 

          
              state <= ST_SRCH;
            end if;
          
          when ST_SRCH =>
            for i in (len - 1) downto 0 loop
              if ((data_in(idx(i + i)) > data_in(idx(i + i + 1))) xor (find_min = '1')) then idx(i) <= idx(i + i); else idx(i) <= idx(i + i + 1);
            end loop;
  
            if (len > 1) then 
              len <= shift_right(len, 1);
            else
              srch_idx  <= idx(0);
              --check for odd length
              if ((data_in'length and 1) = 1) then
                if ((data_in(data_in'length-1) > data_in(idx(0))) xor (find_min = '1')) then srch_idx <= data_in'length-1;
              end if; 
              done_f    <= '1';
              state     <= ST_IDLE;
            end if;
        
          when others =>        
        end case;
      end if;
    end if;
  end process;
 
end arch_imp;