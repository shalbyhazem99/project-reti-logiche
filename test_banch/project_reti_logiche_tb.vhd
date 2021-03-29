
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY project_tb IS
END project_tb;

ARCHITECTURE projecttb OF project_tb IS
	CONSTANT c_CLOCK_PERIOD       : TIME := 15 ns;
	SIGNAL tb_done                : std_logic;
	SIGNAL mem_address            : std_logic_vector (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL tb_rst                 : std_logic := '0';
	SIGNAL tb_start               : std_logic := '0';
	SIGNAL tb_clk                 : std_logic := '0';
	SIGNAL mem_o_data, mem_i_data : std_logic_vector (7 DOWNTO 0);
	SIGNAL enable_wire            : std_logic;
	SIGNAL mem_we                 : std_logic;

	TYPE ram_type IS ARRAY (65535 DOWNTO 0) OF std_logic_vector(7 DOWNTO 0);

	SIGNAL i : std_logic_vector(3 DOWNTO 0) := "0000";

	-- delta=255 shift=0
	SIGNAL RAM0 : ram_type := (0 => std_logic_vector(to_unsigned(2, 8)), 
		1      => std_logic_vector(to_unsigned(2, 8)), 
		2      => std_logic_vector(to_unsigned(255, 8)), 
		3      => std_logic_vector(to_unsigned(241, 8)), 
		4      => std_logic_vector(to_unsigned(0, 8)), 
		5      => std_logic_vector(to_unsigned(250, 8)), 
		OTHERS => (OTHERS => '0')
	);
	-- delta=240 shift=1 
	SIGNAL RAM1 : ram_type := (0 => std_logic_vector(to_unsigned(1, 8)), 
		1      => std_logic_vector(to_unsigned(4, 8)), 
		2      => std_logic_vector(to_unsigned(141, 8)), 
		3      => std_logic_vector(to_unsigned(10, 8)), 
		4      => std_logic_vector(to_unsigned(56, 8)), 
		5      => std_logic_vector(to_unsigned(250, 8)), 
	OTHERS => (OTHERS => '0')); 
	-- delta=100 shift=2
	SIGNAL RAM2 : ram_type := (0 => std_logic_vector(to_unsigned(4, 8)), 
		1      => std_logic_vector(to_unsigned(1, 8)), 
		2      => std_logic_vector(to_unsigned(55, 8)), 
		3      => std_logic_vector(to_unsigned(78, 8)), 
		4      => std_logic_vector(to_unsigned(128, 8)), 
		5      => std_logic_vector(to_unsigned(155, 8)), 
		OTHERS => (OTHERS => '0')
	);
 
	-- delta=31 shift=3
	SIGNAL RAM3 : ram_type := (0 => std_logic_vector(to_unsigned(4, 8)), 
		1      => std_logic_vector(to_unsigned(1, 8)), 
		2      => std_logic_vector(to_unsigned(48, 8)), 
		3      => std_logic_vector(to_unsigned(24, 8)), 
		4      => std_logic_vector(to_unsigned(17, 8)), 
		5      => std_logic_vector(to_unsigned(45, 8)), 
		OTHERS => (OTHERS => '0')
	);
 
	-- delta=30 shift=4
	SIGNAL RAM4 : ram_type := (0 => std_logic_vector(to_unsigned(2, 8)), 
		1      => std_logic_vector(to_unsigned(2, 8)), 
		2      => std_logic_vector(to_unsigned(48, 8)), 
		3      => std_logic_vector(to_unsigned(24, 8)), 
		4      => std_logic_vector(to_unsigned(18, 8)), 
		5      => std_logic_vector(to_unsigned(45, 8)), 
		OTHERS => (OTHERS => '0')
	);
 
	-- delta=10 shift=5 
	SIGNAL RAM5 : ram_type := (0 => std_logic_vector(to_unsigned(2, 8)), 
		1      => std_logic_vector(to_unsigned(2, 8)), 
		2      => std_logic_vector(to_unsigned(250, 8)), 
		3      => std_logic_vector(to_unsigned(255, 8)), 
		4      => std_logic_vector(to_unsigned(252, 8)), 
		5      => std_logic_vector(to_unsigned(245, 8)), 
		OTHERS => (OTHERS => '0')
	);
 
	-- delta=3 shift=6
	SIGNAL RAM6 : ram_type := (0 => std_logic_vector(to_unsigned(2, 8)), 
		1      => std_logic_vector(to_unsigned(2, 8)), 
		2      => std_logic_vector(to_unsigned(76, 8)), 
		3      => std_logic_vector(to_unsigned(75, 8)), 
		4      => std_logic_vector(to_unsigned(74, 8)), 
		5      => std_logic_vector(to_unsigned(77, 8)), 
		OTHERS => (OTHERS => '0')
	);
 
	-- delta=2 shift=7 
	SIGNAL RAM7 : ram_type := (0 => std_logic_vector(to_unsigned(2, 8)), 
		1      => std_logic_vector(to_unsigned(2, 8)), 
		2      => std_logic_vector(to_unsigned(2, 8)), 
		3      => std_logic_vector(to_unsigned(1, 8)), 
		4      => std_logic_vector(to_unsigned(1, 8)), 
		5      => std_logic_vector(to_unsigned(0, 8)), 
		OTHERS => (OTHERS => '0')
	);
 
	-- delta=0 shift=8 
	SIGNAL RAM8 : ram_type := (0 => std_logic_vector(to_unsigned(2, 8)), 
		1      => std_logic_vector(to_unsigned(2, 8)), 
		2      => std_logic_vector(to_unsigned(255, 8)), 
		3      => std_logic_vector(to_unsigned(255, 8)), 
		4      => std_logic_vector(to_unsigned(255, 8)), 
		5      => std_logic_vector(to_unsigned(255, 8)), 
		OTHERS => (OTHERS => '0')
	);
 
	-- n_colonne=0 n_righe=0
	SIGNAL RAM9 : ram_type := (0 => std_logic_vector(to_unsigned(0, 8)), 
		1      => std_logic_vector(to_unsigned(0, 8)), 
		2      => std_logic_vector(to_unsigned(125, 8)), 
		3      => std_logic_vector(to_unsigned(32, 8)), 
		4      => std_logic_vector(to_unsigned(11, 8)), 
		5      => std_logic_vector(to_unsigned(45, 8)), 
		OTHERS => (OTHERS => '0')
	);
	--caso base 1x1 ,delta=0 shift=8
	SIGNAL RAM10 : ram_type := (0 => std_logic_vector(to_unsigned(1, 8)), 
		1      => std_logic_vector(to_unsigned(1, 8)), 
		2      => std_logic_vector(to_unsigned(125, 8)), 
		OTHERS => (OTHERS => '0')
	);
	-- per la verifica del reset (stessi dati della RAM8) 
	SIGNAL RAM11 : ram_type := (0 => std_logic_vector(to_unsigned(2, 8)), 
		1      => std_logic_vector(to_unsigned(2, 8)), 
		2      => std_logic_vector(to_unsigned(255, 8)), 
		3      => std_logic_vector(to_unsigned(255, 8)), 
		4      => std_logic_vector(to_unsigned(255, 8)), 
		5      => std_logic_vector(to_unsigned(255, 8)), 
	OTHERS => (OTHERS => '0')); 
	COMPONENT project_reti_logiche IS
		PORT 
		(
			i_clk     : IN std_logic;
			i_start   : IN std_logic;
			i_rst     : IN std_logic;
			i_data    : IN std_logic_vector(7 DOWNTO 0);
			o_address : OUT std_logic_vector(15 DOWNTO 0);
			o_done    : OUT std_logic;
			o_en      : OUT std_logic;
			o_we      : OUT std_logic;
			o_data    : OUT std_logic_vector (7 DOWNTO 0)
		);
	END COMPONENT project_reti_logiche;
BEGIN
	UUT : project_reti_logiche
	PORT MAP
	(
		i_clk     => tb_clk, 
		i_start   => tb_start, 
		i_rst     => tb_rst, 
		i_data    => mem_o_data, 
		o_address => mem_address, 
		o_done    => tb_done, 
		o_en      => enable_wire, 
		o_we      => mem_we, 
		o_data    => mem_i_data
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
				IF i = "0000" THEN
					IF mem_we = '1' THEN
						RAM0(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                      <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM0(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				ELSIF i = "0001" THEN
					IF mem_we = '1' THEN
						RAM1(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                      <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM1(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				ELSIF i = "0010" THEN
					IF mem_we = '1' THEN
						RAM2(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                      <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM2(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				ELSIF i = "0011" THEN
					IF mem_we = '1' THEN
						RAM3(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                      <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM3(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				ELSIF i = "0100" THEN
					IF mem_we = '1' THEN
						RAM4(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                      <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM4(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				ELSIF i = "0101" THEN
					IF mem_we = '1' THEN
						RAM5(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                      <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM5(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				ELSIF i = "0110" THEN
					IF mem_we = '1' THEN
						RAM6(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                      <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM6(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				ELSIF i = "0111" THEN
					IF mem_we = '1' THEN
						RAM7(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                      <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM7(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				ELSIF i = "1000" THEN
					IF mem_we = '1' THEN
						RAM8(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                      <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM8(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				ELSIF i = "1001" THEN
					IF mem_we = '1' THEN
						RAM9(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                      <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM9(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				ELSIF i = "1010" THEN
					IF mem_we = '1' THEN
						RAM10(conv_integer(mem_address)) <= mem_i_data;
						mem_o_data                       <= mem_i_data AFTER 1 ns;
					ELSE
						mem_o_data <= RAM10(conv_integer(mem_address)) AFTER 1 ns;
					END IF;
				END IF;
			ELSIF i = "1011" THEN
				IF mem_we = '1' THEN
					RAM11(conv_integer(mem_address)) <= mem_i_data;
					mem_o_data                       <= mem_i_data AFTER 1 ns;
				ELSE
					mem_o_data <= RAM11(conv_integer(mem_address)) AFTER 1 ns;
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
		i <= "0001";

		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;
		i <= "0010";
 
		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;
		i <= "0011";
 
		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;
		i <= "0100";
 
		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;
		i <= "0101";
 
		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;
		i <= "0110";
 
		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;
		i <= "0111";
 
		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;
		i <= "1000";
 
		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;
		i <= "1001";
 
		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;
		i <= "1010";
 
		WAIT FOR 100 ns;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		WAIT UNTIL tb_done = '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '0';
		WAIT FOR 100 ns;
		i <= "1011";
 
		WAIT FOR 100 ns;
		tb_start <= '1';
		--wait for 4 c_CLOCK_PERIOD
		WAIT FOR c_CLOCK_PERIOD;
		WAIT FOR c_CLOCK_PERIOD;
		WAIT FOR c_CLOCK_PERIOD;
		WAIT FOR c_CLOCK_PERIOD;
		--reset
		tb_rst <= '1';
		tb_start <= '0';
		--rielabora
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
		i <= "1100";
 
		-- delta=255 shift=0
		ASSERT RAM0(6) = std_logic_vector(to_unsigned(255, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 255 found " & INTEGER'image(to_integer(unsigned(RAM0(6)))) SEVERITY failure;
		ASSERT RAM0(7) = std_logic_vector(to_unsigned(241, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 241 found " & INTEGER'image(to_integer(unsigned(RAM0(7)))) SEVERITY failure;
		ASSERT RAM0(8) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM0(8)))) SEVERITY failure;
		ASSERT RAM0(9) = std_logic_vector(to_unsigned(250, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 250 found " & INTEGER'image(to_integer(unsigned(RAM0(9)))) SEVERITY failure;

		-- delta=240 shift=1
		ASSERT RAM1(6) = std_logic_vector(to_unsigned(255, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 255 found " & INTEGER'image(to_integer(unsigned(RAM1(6)))) SEVERITY failure;
		ASSERT RAM1(7) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM1(7)))) SEVERITY failure;
		ASSERT RAM1(8) = std_logic_vector(to_unsigned(92, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 92 found " & INTEGER'image(to_integer(unsigned(RAM1(8)))) SEVERITY failure;
		ASSERT RAM1(9) = std_logic_vector(to_unsigned(255, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 255 found " & INTEGER'image(to_integer(unsigned(RAM1(9)))) SEVERITY failure;
 
		-- delta=100 shift=2
		ASSERT RAM2(6) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM2(6)))) SEVERITY failure;
		ASSERT RAM2(7) = std_logic_vector(to_unsigned(92, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 92 found " & INTEGER'image(to_integer(unsigned(RAM2(7)))) SEVERITY failure;
		ASSERT RAM2(8) = std_logic_vector(to_unsigned(255, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 255 found " & INTEGER'image(to_integer(unsigned(RAM2(8)))) SEVERITY failure;
		ASSERT RAM2(9) = std_logic_vector(to_unsigned(255, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 255 found " & INTEGER'image(to_integer(unsigned(RAM2(9)))) SEVERITY failure;

		-- delta=31 shift=3
		ASSERT RAM3(6) = std_logic_vector(to_unsigned(248, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 248 found " & INTEGER'image(to_integer(unsigned(RAM3(6)))) SEVERITY failure;
		ASSERT RAM3(7) = std_logic_vector(to_unsigned(56, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 56 found " & INTEGER'image(to_integer(unsigned(RAM3(7)))) SEVERITY failure;
		ASSERT RAM3(8) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM3(8)))) SEVERITY failure;
		ASSERT RAM3(9) = std_logic_vector(to_unsigned(224, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 224 found " & INTEGER'image(to_integer(unsigned(RAM3(9)))) SEVERITY failure;

		-- delta=30 shift=4
		ASSERT RAM4(6) = std_logic_vector(to_unsigned(255, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 255 found " & INTEGER'image(to_integer(unsigned(RAM4(6)))) SEVERITY failure;
		ASSERT RAM4(7) = std_logic_vector(to_unsigned(96, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 96 found " & INTEGER'image(to_integer(unsigned(RAM4(7)))) SEVERITY failure;
		ASSERT RAM4(8) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM4(8)))) SEVERITY failure;
		ASSERT RAM4(9) = std_logic_vector(to_unsigned(255, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 255 found " & INTEGER'image(to_integer(unsigned(RAM4(9)))) SEVERITY failure;
 
		-- delta=10 shift=5
		ASSERT RAM5(6) = std_logic_vector(to_unsigned(160, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 160 found " & INTEGER'image(to_integer(unsigned(RAM5(6)))) SEVERITY failure;
		ASSERT RAM5(7) = std_logic_vector(to_unsigned(255, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 255 found " & INTEGER'image(to_integer(unsigned(RAM5(7)))) SEVERITY failure;
		ASSERT RAM5(8) = std_logic_vector(to_unsigned(224, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 244 found " & INTEGER'image(to_integer(unsigned(RAM5(8)))) SEVERITY failure;
		ASSERT RAM5(9) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM5(9)))) SEVERITY failure;
 
		-- delta=3 shift=6
		ASSERT RAM6(6) = std_logic_vector(to_unsigned(128, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 128 found " & INTEGER'image(to_integer(unsigned(RAM6(6)))) SEVERITY failure;
		ASSERT RAM6(7) = std_logic_vector(to_unsigned(64, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 64 found " & INTEGER'image(to_integer(unsigned(RAM6(7)))) SEVERITY failure;
		ASSERT RAM6(8) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM6(8)))) SEVERITY failure;
		ASSERT RAM6(9) = std_logic_vector(to_unsigned(192, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 192 found " & INTEGER'image(to_integer(unsigned(RAM6(9)))) SEVERITY failure;
 
		-- delta=2 shift=7
		ASSERT RAM7(6) = std_logic_vector(to_unsigned(255, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 255 found " & INTEGER'image(to_integer(unsigned(RAM7(6)))) SEVERITY failure;
		ASSERT RAM7(7) = std_logic_vector(to_unsigned(128, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 128 found " & INTEGER'image(to_integer(unsigned(RAM7(7)))) SEVERITY failure;
		ASSERT RAM7(8) = std_logic_vector(to_unsigned(128, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 128 found " & INTEGER'image(to_integer(unsigned(RAM7(8)))) SEVERITY failure;
		ASSERT RAM7(9) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM7(9)))) SEVERITY failure;
 
		-- delta=0 shift=8
		ASSERT RAM8(6) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM8(6)))) SEVERITY failure;
		ASSERT RAM8(7) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM8(7)))) SEVERITY failure;
		ASSERT RAM8(8) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM8(8)))) SEVERITY failure;
		ASSERT RAM8(9) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM8(9)))) SEVERITY failure;
 
		-- n_colonne=0 n_righe=0
		ASSERT RAM9(2) = std_logic_vector(to_unsigned(125, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 125 found " & INTEGER'image(to_integer(unsigned(RAM9(6)))) SEVERITY failure;
		ASSERT RAM9(3) = std_logic_vector(to_unsigned(32, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 32 found " & INTEGER'image(to_integer(unsigned(RAM9(7)))) SEVERITY failure;
		ASSERT RAM9(4) = std_logic_vector(to_unsigned(11, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 11 found " & INTEGER'image(to_integer(unsigned(RAM9(8)))) SEVERITY failure;
		ASSERT RAM9(5) = std_logic_vector(to_unsigned(45, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 45 found " & INTEGER'image(to_integer(unsigned(RAM9(9)))) SEVERITY failure;
 
		--caso base 1x1 ,delta=0 shift=8
		ASSERT RAM10(6) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM10(6)))) SEVERITY failure;
 
		--reset
		ASSERT RAM11(6) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM8(6)))) SEVERITY failure;
		ASSERT RAM11(7) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM8(7)))) SEVERITY failure;
		ASSERT RAM11(8) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM8(8)))) SEVERITY failure;
		ASSERT RAM11(9) = std_logic_vector(to_unsigned(0, 8)) REPORT " TEST FALLITO (WORKING ZONE). Expected 0 found " & INTEGER'image(to_integer(unsigned(RAM8(9)))) SEVERITY failure;
 
		ASSERT false REPORT "Simulation Ended! TEST PASSATO" SEVERITY failure;

	END PROCESS test;

END projecttb;