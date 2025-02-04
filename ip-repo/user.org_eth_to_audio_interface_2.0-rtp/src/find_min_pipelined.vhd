library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
 
entity RTLTD_SLV_PIPELINE_SEARCH is
--Pipeline search, log(n)+1 clocks, n-1 comparators if data size is power of 2;
--Not to be used until thoroughly tested, it has not been!
 
  generic (
    C_MAX_DATA_SIZE : natural := 32;
    C_DATA_SIZE     : natural := 6;
    SEQ_WIDTH :integer := 8;
    C_LEN_BIT_SIZE     : natural := 4
    );
   
  port (
    aclk            : in  std_logic; --usual
    aresetn         : in  std_logic;  --culprits
    
    SeqNumber1   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    SeqNumber2   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    SeqNumber3   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    SeqNumber4   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    SeqNumber5   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    SeqNumber6   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    
    fifo1Waiting :in  std_logic;
    fifo2Waiting :in  std_logic;
    fifo3Waiting :in  std_logic;
    fifo4Waiting :in  std_logic;
    fifo5Waiting :in  std_logic;
    fifo6Waiting :in  std_logic;
    
    find_min   : in std_logic;
    
    lowestIndex  :out std_logic_vector (SEQ_WIDTH-1 downto 0);
    done     : out std_logic
    
    );
     
end RTLTD_SLV_PIPELINE_SEARCH;
     
architecture arch_imp of RTLTD_SLV_PIPELINE_SEARCH is

  type T_DATA  is array(C_DATA_SIZE-1   downto 0) of natural range 0 to 65535;
  type T_INDEX is array(C_DATA_SIZE / 2 downto 0) of natural range 0 to C_MAX_DATA_SIZE - 1;
  type T_STATE is (ST_IDLE, ST_SRCH);
  signal state      : T_STATE;
  signal idx        : T_INDEX;
  signal data_in    : T_DATA;
  signal ps_reset   : std_logic; -- soft reset from, usually, my control register interface
--  signal find_min   : std_logic; -- '1' to find smallest 
  signal start_f    : std_logic; -- single cycle start pulse
  signal done_f     : std_logic; -- single cycle end pulse
  signal srch_idx   : natural range 0 to C_DATA_SIZE - 1; --result of search
  signal length     : natural range 0 to C_DATA_SIZE / 2; --used in algorithm
  
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
              length <= to_integer(shift_right(to_unsigned(data_in'length,C_LEN_BIT_SIZE ), 1)); --if odd we lose a value so must check it at the end
              for i in to_integer(shift_right(to_unsigned(data_in'length,C_LEN_BIT_SIZE ), 1)) downto 0 loop 
                idx(i) <= i; 
              end loop; 
              state <= ST_SRCH;
            end if;
          
          when ST_SRCH =>
            for i in (length - 1) downto 0 loop
              if ((data_in(idx(i + i)) > data_in(idx(i + i + 1))) xor (find_min = '1')) then 
                idx(i) <= idx(i + i); 
              else 
                idx(i) <= idx(i + i + 1);
              end if;
            end loop;
  
            if (length > 1) then 
              length <= to_integer(shift_right(to_unsigned(length,C_LEN_BIT_SIZE), 1));
            else -- Means we are at the end 
              srch_idx  <= idx(0); -- set ouput to what ever is at index 0
              --check for odd length -- in odd length the last value is not checked above so we give it special attention
              if ((data_in'length mod 2) = 1) then
                if ((data_in(data_in'length-1) > data_in(idx(0))) xor (find_min = '1')) then 
                    srch_idx <= data_in'length-1;
              end if; 
              done_f    <= '1';
              state     <= ST_IDLE;
            end if;
            end if;
        
          when others =>        
        end case;
      end if;
    end if;
  end process;
 
 lowestIndex <= std_logic_vector(to_unsigned(srch_idx,lowestIndex'length));
 done <= done_f;
 
 data_in(0) <= to_integer(unsigned(SeqNumber1));
 data_in(1) <= to_integer(unsigned(SeqNumber2));
 data_in(2) <= to_integer(unsigned(SeqNumber3));
 data_in(3) <= to_integer(unsigned(SeqNumber4));
 data_in(4) <= to_integer(unsigned(SeqNumber5));
 data_in(5) <= to_integer(unsigned(SeqNumber6));
 
 
end arch_imp;