library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is 
  Generic(
    NBITS : integer := 8
  );
  Port(
    i_w         : in  std_logic;
    i_start     : in  std_logic;

    o_z0        : out std_logic_vector(NBITS-1 DOWNTO 0);
    o_z1        : out std_logic_vector(NBITS-1 DOWNTO 0);
    o_z2        : out std_logic_vector(NBITS-1 DOWNTO 0);
    o_z3        : out std_logic_vector(NBITS-1 DOWNTO 0);
    o_done      : out std_logic;

    o_mem_addr  : out std_logic_vector(2*NBITS-1 DOWNTO 0);
    i_mem_data  : in  std_logic_vector(NBITS-1 DOWNTO 0);
    o_mem_we    : out std_logic;
    o_mem_en    : out std_logic;

    i_clk       : in  std_logic;
    i_rst       : in  std_logic
  );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

  type vettore is array (0 TO 3) of std_logic_vector(o_z0'RANGE);
  signal uscite       : vettore;
  signal target       : std_logic_vector(1 DOWNTO 0);
  signal mem_addr     : std_logic_vector(15 DOWNTO 0);
  type state_type is (RESET, START, READ1, READ0, READADDR, MEMREAD, MEMWRITE, DONE);
  signal state, next_state : state_type;
  
begin

  OL : process(state)
  begin
    case state is
      when RESET      =>
        -- Reset uscite e ff uscite
        o_z0        <= (Others => '0');
        o_z1        <= (Others => '0');
        o_z2        <= (Others => '0');
        o_z3        <= (Others => '0');
        o_done      <= '0';
        
        -- Reset comandi memoria
        o_mem_addr  <= (Others => '0');
        o_mem_we    <= '0';
        o_mem_en    <= '0';
        
      when START      =>
        -- Reset uscite e ff uscite
        o_z0        <= (Others => '0');
        o_z1        <= (Others => '0');
        o_z2        <= (Others => '0');
        o_z3        <= (Others => '0');
        o_done      <= '0';
        -- Reset comandi memoria
        o_mem_addr  <= (Others => '0');
        o_mem_we    <= '0';
        o_mem_en    <= '0';
      
      when MEMREAD    =>
        o_mem_addr  <= mem_addr;
        o_mem_we    <= '0';
        o_mem_en    <= '1';
      
      when MEMWRITE   =>         
        o_mem_en   <= '0';
                
      when DONE       =>
        o_z0       <= uscite(0);
        o_z1       <= uscite(1);
        o_z2       <= uscite(2);
        o_z3       <= uscite(3);
        o_done     <= '1';
      when Others     =>
      
    end case;
  
  end process OL;
  
  TL : process(state, i_start, i_rst)
  begin 
    case state is
      when RESET      =>
        if i_rst = '0' then
          next_state  <= START;
        else
          next_state  <= RESET;
        end if;    
      when START      =>
        if i_start = '1' then
          next_state <= READ1;
        else
          next_state <= START;
        end if;
      when READ1      =>
        next_state <= READ0;
      when READ0 | READADDR  =>
        if i_start = '1' then
          next_state <= READADDR;
        else
          next_state <= MEMREAD;
        end if;
      when MEMREAD    =>
        next_state  <= MEMWRITE;
      when MEMWRITE   =>
        next_state    <= DONE;
      when DONE       =>
        next_state  <= START;
      when Others     =>
        next_state  <= RESET;
    end case;
  end process TL;

  SL : process(i_clk, i_rst)
  begin
    if rising_edge(i_clk) then     
      case next_state is
        when RESET      =>
          uscite      <= (Others => (Others => '0'));
          target      <= (Others => '0');
          mem_addr    <= (Others => '0');
          
        when START      =>
          target      <= (Others => '0');
          mem_addr    <= (Others => '0');
  
        when READ1      =>
          target(1)   <= i_w;
          
        when READ0      =>
          target(0)   <= i_w;
          
        when READADDR   =>
        -- Implement sr_SIPO functionality in READADDR case
          mem_addr(15 DOWNTO 1) <= mem_addr(14 DOWNTO 0);
          mem_addr(0) <= i_w;
        when MEMREAD    =>                                                                                      
           
        when MEMWRITE   =>
          
        when DONE       =>
          uscite(to_integer(unsigned(target))) <= i_mem_data;
      end case;
      state <= next_state;
    end if;
    if i_rst = '1' then
      state <= RESET;
    end if;
  end process SL;

end Behavioral;
