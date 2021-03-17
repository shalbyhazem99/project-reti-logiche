
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY project_tb IS
END project_tb;

ARCHITECTURE projecttb OF project_tb IS
	CONSTANT c_CLOCK_PERIOD : TIME := 15 ns;
	SIGNAL tb_done : std_logic;
	SIGNAL mem_address : std_logic_vector (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL tb_rst : std_logic := '0';
	SIGNAL tb_start : std_logic := '0';
	SIGNAL tb_clk : std_logic := '0';
	SIGNAL mem_o_data, mem_i_data : std_logic_vector (7 DOWNTO 0);
	SIGNAL enable_wire : std_logic;
	SIGNAL mem_we : std_logic;

	TYPE ram_type IS ARRAY (65535 DOWNTO 0) OF std_logic_vector(7 DOWNTO 0);
	SIGNAL RAM : ram_type := (0 => std_logic_vector(to_unsigned(4, 8)), 
		1 => std_logic_vector(to_unsigned(4, 8)), 
		2 => std_logic_vector(to_unsigned(52, 8)), 
		3 => std_logic_vector(to_unsigned(55, 8)), 
		4 => std_logic_vector(to_unsigned(122, 8)), 
		5 => std_logic_vector(to_unsigned(70, 8)), 
		6 => std_logic_vector(to_unsigned(62, 8)), 
		7 => std_logic_vector(to_unsigned(59, 8)), 
		8 => std_logic_vector(to_unsigned(68, 8)), 
		9 => std_logic_vector(to_unsigned(113, 8)), 
		10 => std_logic_vector(to_unsigned(85, 8)), 
		11 => std_logic_vector(to_unsigned(71, 8)), 
		12 => std_logic_vector(to_unsigned(59, 8)), 
		13 => std_logic_vector(to_unsigned(64, 8)), 
		14 => std_logic_vector(to_unsigned(87, 8)), 
		15 => std_logic_vector(to_unsigned(78, 8)), 
		16 => std_logic_vector(to_unsigned(68, 8)), 
		17 => std_logic_vector(to_unsigned(69, 8)), 
	OTHERS => (OTHERS => '0')); 

	COMPONENT project_reti_logiche IS
		PORT (
			i_clk : IN std_logic;
			i_start : IN std_logic;
			i_rst : IN std_logic;
			i_data : IN std_logic_vector(7 DOWNTO 0);
			o_address : OUT std_logic_vector(15 DOWNTO 0);
			o_done : OUT std_logic;
			o_en : OUT std_logic;
			o_we : OUT std_logic;
			o_data : OUT std_logic_vector (7 DOWNTO 0)
		);
	END COMPONENT project_reti_logiche;
BEGIN
	UUT : project_reti_logiche
	PORT MAP(
		i_clk => tb_clk, 
		i_start => tb_start, 
		i_rst => tb_rst, 
		i_data => mem_o_data, 
		o_address => mem_address, 
		o_done => tb_done, 
		o_en => enable_wire, 
		o_we => mem_we, 
		o_data => mem_i_data
	);

	p_CLK_GEN : PROCESS IS
	BEGIN
		WAIT FOR c_CLOCK_PERIOD/2;
		tb_clk <= NOT tb_clk;
	END PROCESS p_CLK_GEN;
	MEM : PROCESS (tb_clk)
	BEGIN
		IF tb_clk'EVENT AND tb_clk = '1' THEN
			IF enable_wire = '1' THEN
				IF mem_we = '1' THEN
					RAM(conv_integer(mem_address)) <= mem_i_data;
					mem_o_data <= mem_i_data AFTER 1 ns;
				ELSE
					mem_o_data <= RAM(conv_integer(mem_address)) AFTER 1 ns;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	test : PROCESS IS
	BEGIN
		WAIT FOR 100 ns;
		WAIT FOR c_CLOCK_PERIOD;
		tb_rst <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT FOR 100 ns;
		tb_rst <= '0';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;

		-- Immagine originale = [52,55,122,70,62,59,68,113,85,71,59,64,87,78,68,69] 
		-- Immagine di output = [0,12,255,72,40,28,64,244,132,76,28,48,140,104,64,68] 
 
		ASSERT RAM(18) = std_logic_vector(to_unsigned(0, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM(18)))) SEVERITY failure;
		ASSERT RAM(19) = std_logic_vector(to_unsigned(12, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 12 found " & INTEGER'image(to_integer(unsigned(RAM(19)))) SEVERITY failure;
		ASSERT RAM(20) = std_logic_vector(to_unsigned(255, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 255 found " & INTEGER'image(to_integer(unsigned(RAM(20)))) SEVERITY failure;
		ASSERT RAM(21) = std_logic_vector(to_unsigned(72, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 72 found " & INTEGER'image(to_integer(unsigned(RAM(21)))) SEVERITY failure;
		ASSERT RAM(22) = std_logic_vector(to_unsigned(40, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 40 found " & INTEGER'image(to_integer(unsigned(RAM(22)))) SEVERITY failure;
		ASSERT RAM(23) = std_logic_vector(to_unsigned(28, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 28 found " & INTEGER'image(to_integer(unsigned(RAM(23)))) SEVERITY failure;
		ASSERT RAM(24) = std_logic_vector(to_unsigned(64, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 64 found " & INTEGER'image(to_integer(unsigned(RAM(24)))) SEVERITY failure;
		ASSERT RAM(25) = std_logic_vector(to_unsigned(244, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 244 found " & INTEGER'image(to_integer(unsigned(RAM(25)))) SEVERITY failure;
		ASSERT RAM(26) = std_logic_vector(to_unsigned(132, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 132 found " & INTEGER'image(to_integer(unsigned(RAM(26)))) SEVERITY failure;
		ASSERT RAM(27) = std_logic_vector(to_unsigned(76, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 76 found " & INTEGER'image(to_integer(unsigned(RAM(27)))) SEVERITY failure;
		ASSERT RAM(28) = std_logic_vector(to_unsigned(28, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 28 found " & INTEGER'image(to_integer(unsigned(RAM(28)))) SEVERITY failure;
		ASSERT RAM(29) = std_logic_vector(to_unsigned(48, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 48 found " & INTEGER'image(to_integer(unsigned(RAM(29)))) SEVERITY failure;
		ASSERT RAM(30) = std_logic_vector(to_unsigned(140, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 140 found " & INTEGER'image(to_integer(unsigned(RAM(30)))) SEVERITY failure;
		ASSERT RAM(31) = std_logic_vector(to_unsigned(104, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 104 found " & INTEGER'image(to_integer(unsigned(RAM(31)))) SEVERITY failure;
		ASSERT RAM(32) = std_logic_vector(to_unsigned(64, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 64 found " & INTEGER'image(to_integer(unsigned(RAM(32)))) SEVERITY failure;
		ASSERT RAM(33) = std_logic_vector(to_unsigned(68, 8)) REPORT "TEST FALLITO (WORKING ZONE). Expected 68 found " & INTEGER'image(to_integer(unsigned(RAM(33)))) SEVERITY failure;

		ASSERT false REPORT "Simulation Ended! TEST PASSATO" SEVERITY failure;
	END PROCESS test;

END projecttb;