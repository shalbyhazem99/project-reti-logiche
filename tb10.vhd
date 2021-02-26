
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity project_tb is
end project_tb;

architecture projecttb of project_tb is
constant c_CLOCK_PERIOD         : time := 15 ns;
signal   tb_done                : std_logic;
signal   mem_address            : std_logic_vector (15 downto 0) := (others => '0');
signal   tb_rst                 : std_logic := '0';
signal   tb_start               : std_logic := '0';
signal   tb_clk                 : std_logic := '0';
signal   mem_o_data,mem_i_data  : std_logic_vector (7 downto 0);
signal   enable_wire            : std_logic;
signal   mem_we                 : std_logic;

type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);

signal i: std_logic_vector(3 downto 0) := "0000";

signal RAM0: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)),
			 1 => std_logic_vector(to_unsigned(  2  , 8)),
			 2 => std_logic_vector(to_unsigned(  255  , 8)),
			 3 => std_logic_vector(to_unsigned(  241  , 8)),
			 4 => std_logic_vector(to_unsigned(  0  , 8)),
			 5 => std_logic_vector(to_unsigned(  250  , 8)),
                         others => (others =>'0'));
             -- delta=255 shift=0

signal RAM1: ram_type := (0 => std_logic_vector(to_unsigned(  1  , 8)),
			 1 => std_logic_vector(to_unsigned(  4  , 8)),
			 2 => std_logic_vector(to_unsigned(  141  , 8)),
			 3 => std_logic_vector(to_unsigned(  10  , 8)),
			 4 => std_logic_vector(to_unsigned(  56  , 8)),
			 5 => std_logic_vector(to_unsigned(  250  , 8)),
                         others => (others =>'0'));         
			 -- delta=240 shift=1    

signal RAM2: ram_type := (0 => std_logic_vector(to_unsigned(  4  , 8)),
			 1 => std_logic_vector(to_unsigned(  1  , 8)),
			 2 => std_logic_vector(to_unsigned(  55  , 8)),
			 3 => std_logic_vector(to_unsigned(  78  , 8)),
			 4 => std_logic_vector(to_unsigned(  128  , 8)),
			 5 => std_logic_vector(to_unsigned(  155  , 8)),
                         others => (others =>'0')); 
              -- delta=100 shift=2                

signal RAM3: ram_type := (0 => std_logic_vector(to_unsigned(  4  , 8)),
			 1 => std_logic_vector(to_unsigned(  1  , 8)),
			 2 => std_logic_vector(to_unsigned(  48  , 8)),
			 3 => std_logic_vector(to_unsigned(  24  , 8)),
			 4 => std_logic_vector(to_unsigned(  17  , 8)),
			 5 => std_logic_vector(to_unsigned(  45  , 8)),
                         others => (others =>'0'));
             -- delta=31 shift=3              

signal RAM4: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)),
			 1 => std_logic_vector(to_unsigned(  2  , 8)),
			 2 => std_logic_vector(to_unsigned(  48  , 8)),
			 3 => std_logic_vector(to_unsigned(  24  , 8)),
			 4 => std_logic_vector(to_unsigned(  18  , 8)),
			 5 => std_logic_vector(to_unsigned(  45  , 8)),
                         others => (others =>'0')); 
             -- delta=30 shift=4
             
signal RAM5: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)),
			 1 => std_logic_vector(to_unsigned(  2  , 8)),
			 2 => std_logic_vector(to_unsigned( 250  , 8)),
			 3 => std_logic_vector(to_unsigned( 255  , 8)),
			 4 => std_logic_vector(to_unsigned( 252   , 8)),
			 5 => std_logic_vector(to_unsigned( 245  , 8)),
                         others => (others =>'0'));
             -- delta=10 shift=5

signal RAM6: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)),
			 1 => std_logic_vector(to_unsigned(  2  , 8)),
			 2 => std_logic_vector(to_unsigned(  76  , 8)),
			 3 => std_logic_vector(to_unsigned(  75  , 8)),
			 4 => std_logic_vector(to_unsigned(  74  , 8)),
			 5 => std_logic_vector(to_unsigned(  77  , 8)),
                         others => (others =>'0')); 
             -- delta=3 shift=6
             
signal RAM7: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)),
			 1 => std_logic_vector(to_unsigned(  2  , 8)),
			 2 => std_logic_vector(to_unsigned(  2  , 8)),
			 3 => std_logic_vector(to_unsigned(  1  , 8)),
			 4 => std_logic_vector(to_unsigned(  1  , 8)),
			 5 => std_logic_vector(to_unsigned(  0  , 8)),
                         others => (others =>'0')); 
             -- delta=2 shift=7
             
signal RAM8: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)),
			 1 => std_logic_vector(to_unsigned(  2  , 8)),
			 2 => std_logic_vector(to_unsigned(  255  , 8)),
			 3 => std_logic_vector(to_unsigned(  255  , 8)),
			 4 => std_logic_vector(to_unsigned(  255  , 8)),
			 5 => std_logic_vector(to_unsigned(  255  , 8)),
                         others => (others =>'0'));
             -- delta=0 shift=8 

signal RAM9: ram_type := (0 => std_logic_vector(to_unsigned(  4  , 8)),
			 1 => std_logic_vector(to_unsigned(  0  , 8)),
			 2 => std_logic_vector(to_unsigned(  125  , 8)),
			 3 => std_logic_vector(to_unsigned(  32  , 8)),
			 4 => std_logic_vector(to_unsigned(  11  , 8)),
			 5 => std_logic_vector(to_unsigned(  45  , 8)),
                         others => (others =>'0'));
             -- n_colonne=0 n_righe=0

signal RAM10: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)),
			 1 => std_logic_vector(to_unsigned(  2  , 8)),
			 2 => std_logic_vector(to_unsigned(  10  , 8)),
			 3 => std_logic_vector(to_unsigned(  10  , 8)),
			 4 => std_logic_vector(to_unsigned(  11  , 8)),
			 5 => std_logic_vector(to_unsigned(  10  , 8)),
                         others => (others =>'0'));      
             -- delta=1 shift=7            
                                                                                                                                                                         
component project_reti_logiche is
port (
      i_clk         : in  std_logic;
      i_start       : in  std_logic;
      i_rst         : in  std_logic;
      i_data        : in  std_logic_vector(7 downto 0);
      o_address     : out std_logic_vector(15 downto 0);
      o_done        : out std_logic;
      o_en          : out std_logic;
      o_we          : out std_logic;
      o_data        : out std_logic_vector (7 downto 0)
      );
end component project_reti_logiche;


begin
UUT: project_reti_logiche
port map (
          i_clk      	=> tb_clk,
          i_start       => tb_start,
          i_rst      	=> tb_rst,
          i_data    	=> mem_o_data,
          o_address  	=> mem_address,
          o_done      	=> tb_done,
          o_en   	=> enable_wire,
          o_we 		=> mem_we,
          o_data    	=> mem_i_data
          );

p_CLK_GEN : process is
begin
    wait for c_CLOCK_PERIOD/2;
    tb_clk <= not tb_clk;
end process p_CLK_GEN;


MEM : process(tb_clk)
begin
if tb_clk'event and tb_clk = '1' then
    if enable_wire = '1' then
        if i = "0000" then
            if mem_we = '1' then
                RAM0(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM0(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i ="0001" then
            if mem_we = '1' then
                RAM1(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM1(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "0010" then 
            if mem_we = '1' then
                RAM2(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM2(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "0011" then 
            if mem_we = '1' then
                RAM3(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM3(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "0100" then 
            if mem_we = '1' then
                RAM4(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM4(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "0101" then 
            if mem_we = '1' then
                RAM5(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM5(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "0110" then 
            if mem_we = '1' then
                RAM6(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM6(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "0111" then 
            if mem_we = '1' then
                RAM7(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM7(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "1000" then 
            if mem_we = '1' then
                RAM8(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM8(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "1001" then 
            if mem_we = '1' then
                RAM9(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM9(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "1010" then 
            if mem_we = '1' then
                RAM10(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM10(conv_integer(mem_address)) after 1 ns;
            end if;
        end if;
    end if;
end if;
end process;


test : process is
begin 
    wait for 100 ns;
    wait for c_CLOCK_PERIOD;
    tb_rst <= '1';
    wait for c_CLOCK_PERIOD;
    wait for 100 ns;
    tb_rst <= '0';
    wait for c_CLOCK_PERIOD;
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "0001";

    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "0010";

    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "0011";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "0100";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "0101";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "0110";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "0111";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "1000";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "1001";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "1010";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "1011";
    
    
    -- delta=255 shift=0
	assert RAM0(6) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM0(6))))  severity failure; 
	assert RAM0(7) = std_logic_vector(to_unsigned( 241 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  241  found " & integer'image(to_integer(unsigned(RAM0(7))))  severity failure; 
	assert RAM0(8) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM0(8))))  severity failure; 
	assert RAM0(9) = std_logic_vector(to_unsigned( 250 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  250  found " & integer'image(to_integer(unsigned(RAM0(9))))  severity failure;

    -- delta=240 shift=1
	assert RAM1(6) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM1(6))))  severity failure; 
	assert RAM1(7) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM1(7))))  severity failure; 
	assert RAM1(8) = std_logic_vector(to_unsigned( 92 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  92  found " & integer'image(to_integer(unsigned(RAM1(8))))  severity failure; 
	assert RAM1(9) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM1(9))))  severity failure;
	
	-- delta=100 shift=2
	assert RAM2(6) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM2(6))))  severity failure; 
	assert RAM2(7) = std_logic_vector(to_unsigned( 92 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  92  found " & integer'image(to_integer(unsigned(RAM2(7))))  severity failure; 
	assert RAM2(8) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM2(8))))  severity failure; 
	assert RAM2(9) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM2(9))))  severity failure;

    -- delta=31 shift=3
    assert RAM3(6) = std_logic_vector(to_unsigned( 248 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  248  found " & integer'image(to_integer(unsigned(RAM3(6))))  severity failure; 
	assert RAM3(7) = std_logic_vector(to_unsigned( 56 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  56  found " & integer'image(to_integer(unsigned(RAM3(7))))  severity failure; 
	assert RAM3(8) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM3(8))))  severity failure; 
	assert RAM3(9) = std_logic_vector(to_unsigned( 224 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  224  found " & integer'image(to_integer(unsigned(RAM3(9))))  severity failure;

    -- delta=30 shift=4
    assert RAM4(6) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM4(6))))  severity failure; 
	assert RAM4(7) = std_logic_vector(to_unsigned( 96 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  96  found " & integer'image(to_integer(unsigned(RAM4(7))))  severity failure; 
	assert RAM4(8) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM4(8))))  severity failure; 
	assert RAM4(9) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM4(9))))  severity failure;
	
	-- delta=10 shift=5
    assert RAM5(6) = std_logic_vector(to_unsigned( 160 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  160  found " & integer'image(to_integer(unsigned(RAM5(6))))  severity failure; 
	assert RAM5(7) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM5(7))))  severity failure; 
	assert RAM5(8) = std_logic_vector(to_unsigned( 224 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  244  found " & integer'image(to_integer(unsigned(RAM5(8))))  severity failure; 
	assert RAM5(9) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM5(9))))  severity failure;
	
	-- delta=3 shift=6
    assert RAM6(6) = std_logic_vector(to_unsigned( 128 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM6(6))))  severity failure; 
	assert RAM6(7) = std_logic_vector(to_unsigned( 64 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  64  found " & integer'image(to_integer(unsigned(RAM6(7))))  severity failure; 
	assert RAM6(8) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM6(8))))  severity failure; 
	assert RAM6(9) = std_logic_vector(to_unsigned( 192 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  192  found " & integer'image(to_integer(unsigned(RAM6(9))))  severity failure;
	
	-- delta=2 shift=7
    assert RAM7(6) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM7(6))))  severity failure; 
	assert RAM7(7) = std_logic_vector(to_unsigned( 128 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM7(7))))  severity failure; 
	assert RAM7(8) = std_logic_vector(to_unsigned( 128 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM7(8))))  severity failure; 
	assert RAM7(9) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM7(9))))  severity failure;
	
	-- delta=0 shift=8
    assert RAM8(6) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM8(6))))  severity failure; 
	assert RAM8(7) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM8(7))))  severity failure; 
	assert RAM8(8) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM8(8))))  severity failure; 
	assert RAM8(9) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM8(9))))  severity failure;
	
	-- n_colonne=0 n_righe=0
    assert RAM9(2) = std_logic_vector(to_unsigned( 125 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  125  found " & integer'image(to_integer(unsigned(RAM9(6))))  severity failure; 
	assert RAM9(3) = std_logic_vector(to_unsigned( 32 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  32  found " & integer'image(to_integer(unsigned(RAM9(7))))  severity failure; 
	assert RAM9(4) = std_logic_vector(to_unsigned( 11 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  11  found " & integer'image(to_integer(unsigned(RAM9(8))))  severity failure; 
	assert RAM9(5) = std_logic_vector(to_unsigned( 45 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  45  found " & integer'image(to_integer(unsigned(RAM9(9))))  severity failure;
	
	-- delta=2 shift=7
    assert RAM10(6) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM10(6))))  severity failure; 
	assert RAM10(7) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM10(7))))  severity failure; 
	assert RAM10(8) = std_logic_vector(to_unsigned( 128 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM10(8))))  severity failure; 
	assert RAM10(9) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM10(9))))  severity failure;
	
    assert false report "Simulation Ended! TEST PASSATO" severity failure;

end process test;

end projecttb; 


