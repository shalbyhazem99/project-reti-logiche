----------------------------------------------------------------------------------
-- PROGETTO DI RETI LOGICHE by PROF. GIANLUCA PALERMO
--
-- SHALBY HAZEM HESHAM YOUSEF (10596243)
-- PEREGO NICCOLO'            (10628782)
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY project_reti_logiche IS
	PORT 
	(
		i_clk     : IN std_logic;
		i_rst     : IN std_logic; --viene sempre dato prima della prima elaborazione o durante il processo
		i_start   : IN std_logic; --dà inizio all'elaborazione e rimane alto fino a che done non viene portato alto
		i_data    : IN std_logic_vector(7 DOWNTO 0);
		o_address : OUT std_logic_vector(15 DOWNTO 0);
		o_done    : OUT std_logic; --portato alto quando si finisce l'elaborazione
		o_en      : OUT std_logic; --memory enable
		o_we      : OUT std_logic; --write enable
		o_data    : OUT std_logic_vector (7 DOWNTO 0) --eventuale segnale da scrivere in memoria all'indirizzo o-address
	);
END project_reti_logiche;

ARCHITECTURE Behavioral OF project_reti_logiche IS
	TYPE stato IS (WAIT_RESET, WAIT_START, WAIT_MEM, 
	COL_READ_REQ, COL_ROW_READ_READ_REQ, ROW_READ, 
	SFM_READ_REQ, SFM_READ, PREP_ELAB_VALUES, 
	DONE, SFE_READ_REQ, SFE_READ
	);
	SIGNAL next_state, current_state, wait_next_state : stato;
	SIGNAL byte_to_read, count, shift_level           : INTEGER;
	SIGNAL max, min                                   : std_logic_vector(7 DOWNTO 0);
BEGIN
	PROCESS (i_clk, i_rst)
	VARIABLE temp_integer : INTEGER;
	BEGIN
		IF i_rst = '1' THEN
			next_state <= WAIT_START;
		ELSIF rising_edge(i_clk) THEN
			CASE next_state IS
				WHEN WAIT_START => 
					IF i_start = '1' THEN
						max        <= (OTHERS => '0');
						min        <= (OTHERS => '1');
						count      <= 0;
						next_state <= COL_READ_REQ;
					ELSE
						o_done     <= '0';
						next_state <= WAIT_START;
					END IF;
				WHEN WAIT_MEM => 
					next_state <= wait_next_state;
				--gruppo stati calcolo dimensioni 
				WHEN COL_READ_REQ => 
					o_en            <= '1';
					o_we            <= '0';
					o_address       <= (OTHERS => '0');
					wait_next_state <= COL_ROW_READ_READ_REQ;
					next_state      <= WAIT_MEM;
				WHEN COL_ROW_READ_READ_REQ => 
					byte_to_read    <= TO_INTEGER(unsigned (i_data));
					o_en            <= '1';
					o_we            <= '0';
					o_address       <= (0 => '1', OTHERS => '0');
					wait_next_state <= ROW_READ;
					next_state      <= WAIT_MEM;
				WHEN ROW_READ => 
					temp_integer := byte_to_read * TO_INTEGER(unsigned (i_data));
					byte_to_read <= temp_integer;
					next_state   <= SFM_READ_REQ;
				-- gruppo stati calcolo valori massimo e minimo
				WHEN SFM_READ_REQ => 
					o_en            <= '1';
					o_we            <= '0';
					o_address       <= std_logic_vector(to_unsigned(count + 2, 16)); --conversione su 16 bit
					wait_next_state <= SFM_READ;
					next_state      <= WAIT_MEM;
				WHEN SFM_READ => 
					IF i_data < min THEN
						min <= i_data;
					END IF;
					IF i_data > max THEN
						max <= i_data;
					END IF;
					IF count < byte_to_read - 1 THEN --incremento count
						temp_integer := count;
						count      <= temp_integer + 1;
						next_state <= SFM_READ_REQ;
					ELSE
						count      <= 0;
						next_state <= PREP_ELAB_VALUES;
					END IF;
				--gruppo stati elaborazione effettiva
				WHEN PREP_ELAB_VALUES => 
					--calcolo delta value e shif level
					temp_integer := TO_INTEGER(unsigned (max)) - TO_INTEGER(unsigned (min)); --delta_value
					IF temp_integer = 0 THEN
						shift_level <= 8;
					ELSIF temp_integer > 0 AND temp_integer < 3 THEN
						shift_level <= 7;
					ELSIF temp_integer > 2 AND temp_integer < 7 THEN
						shift_level <= 6;
					ELSIF temp_integer > 6 AND temp_integer < 15 THEN
						shift_level <= 5;
					ELSIF temp_integer > 14 AND temp_integer < 31 THEN
						shift_level <= 4;
					ELSIF temp_integer > 30 AND temp_integer < 63 THEN
						shift_level <= 3;
					ELSIF temp_integer > 62 AND temp_integer < 127 THEN
						shift_level <= 2;
					ELSIF temp_integer > 126 AND temp_integer < 255 THEN
						shift_level <= 1;
					ELSE
						shift_level <= 0;
					END IF;
					next_state <= SFE_READ_REQ;
				WHEN SFE_READ_REQ => 
					o_en            <= '1';
					o_we            <= '0';
					o_address       <= std_logic_vector(to_unsigned(count + 2, 16)); --conversione su 16 bit
					wait_next_state <= SFE_READ;
					next_state      <= WAIT_MEM;
				WHEN SFE_READ => 
					IF count < byte_to_read THEN
						--elaborare il byte letto e scriverlo, enable memoria in write
						o_en      <= '1';
						o_we      <= '1';
						o_address <= std_logic_vector(to_unsigned(count + byte_to_read + 2, 16)); --conversione su 16 bit
						--calcolo new_value del pixel corrente da scrivere
						temp_integer := (to_integer(unsigned(i_data) - unsigned(min))) * 2 ** shift_level;
						IF temp_integer > 255 THEN
							o_data <= (OTHERS => '1');
						ELSE
							o_data <= std_logic_vector(to_unsigned(temp_integer, 8));
						END IF;
						--incremento count
						temp_integer := count;
						count      <= temp_integer + 1;
						next_state <= SFE_READ_REQ;
					ELSE
						next_state <= DONE;
					END IF;
				WHEN DONE => 
					o_done <= '1';
					IF (i_start = '0') THEN
						next_state <= WAIT_START;
					ELSE
						next_state <= DONE;
					END IF;
				WHEN OTHERS => 
			END CASE;
		END IF;
	END PROCESS;
END Behavioral;