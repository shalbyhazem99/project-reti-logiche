----------------------------------------------------------------------------------
-- PROGETTO DI RETI LOGICHE by PROF. GIANLUCA PALERMO
--
-- SHALBY HAZEM HESHAM YOUSEF   (10596243)
-- PEREGO NICCOLO'              (10628782)
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY project_reti_logiche IS
	PORT
	(
		i_clk     : IN std_logic;
		i_rst     : IN std_logic; --viene sempre dato prima della prima elaborazione o durante il processo
		i_start   : IN std_logic; --da inizio all'elaborazione e rimane alto fino a che done non viene portato alto
		i_data    : IN std_logic_vector(7 DOWNTO 0);
		o_address : OUT std_logic_vector(15 DOWNTO 0);
		o_done    : OUT std_logic; --portato alto quando si finisce l'elaborazione
		o_en      : OUT std_logic; --memory enable
		o_we      : OUT std_logic; --write enable
		o_data    : OUT std_logic_vector (7 DOWNTO 0) --eventuale segnale da scrivere in memoria all'indirizzo o_address
	);
END project_reti_logiche;
ARCHITECTURE Behavioral OF project_reti_logiche IS
	TYPE stato IS (WT_RST, WT_STR, WAIT_MEM, RD_REQ, RD_ROW, RD_COL, CMP_DATA, PREP_EL, EL_DATA, DONE);
	SIGNAL next_state                       : stato;
	SIGNAL byte_to_read, count, shift_level : INTEGER;
	SIGNAL max, min                         : std_logic_vector(7 DOWNTO 0);
BEGIN
	PROCESS (i_clk, i_rst)
	VARIABLE temp_integer : INTEGER;
	VARIABLE temp_data    : std_logic_vector(15 DOWNTO 0);
	BEGIN
		IF i_rst = '1' THEN
			o_done     <= '0';
			o_en       <= '0';
			next_state <= WT_STR;
		ELSIF rising_edge(i_clk) THEN
			CASE next_state IS
				WHEN WT_STR => --wait start
					o_done <= '0';
					IF i_start = '1' THEN
						max         <= (OTHERS => '0');
						min         <= (OTHERS => '1');
						count       <= 0;
						shift_level <= 3; --valore di controllo quasiasi (tra i non assumibili da shift_level)
						next_state  <= RD_REQ;
					ELSE
						next_state <= WT_STR;
					END IF;
				WHEN RD_REQ => --read request
					o_en       <= '1';
					o_we       <= '0';
					o_address  <= std_logic_vector(to_unsigned(count, 16));
					next_state <= WAIT_MEM;
				WHEN WAIT_MEM => -- wait memory
					IF count = 0 THEN
						next_state <= RD_COL;
					ELSIF count = 1 THEN
						next_state <= RD_ROW;
					ELSE
						IF shift_level = 3 THEN
							next_state <= CMP_DATA;
						ELSE
							next_state <= EL_DATA;
						END IF;
					END IF;
					temp_integer := count + 1; --INCREMENTO DI COUNT
					count <= temp_integer;
				--gruppo stati: calcolo dimensioni
				WHEN RD_COL => --read column
					byte_to_read <= TO_INTEGER(unsigned (i_data));
					next_state   <= RD_REQ;
				WHEN RD_ROW => --read row
					temp_integer := byte_to_read * TO_INTEGER(unsigned (i_data));
					byte_to_read <= temp_integer;
					IF temp_integer > 0 THEN
						next_state <= RD_REQ;
					ELSE
						next_state <= DONE;
					END IF;
				--gruppo stati: ricerca di massimo e minimo
				WHEN CMP_DATA => --compare data
					IF count <= byte_to_read + 2 THEN
						IF i_data < min THEN
							min <= i_data;
						END IF;
						IF i_data > max THEN
							max <= i_data;
						END IF;
						next_state <= RD_REQ;
					ELSE
						count      <= 2;
						next_state <= PREP_EL;
					END IF;
				--gruppo stati: elaborazione 
				WHEN PREP_EL => --prepare elaboration
					--calcolo delta value e shift level
					temp_integer := TO_INTEGER(unsigned (max)) - TO_INTEGER(unsigned (min)); --delta_value
					IF temp_integer = 0 THEN
						shift_level <= 256;
					ELSIF temp_integer > 0 AND temp_integer < 3 THEN
						shift_level <= 128;
					ELSIF temp_integer > 2 AND temp_integer < 7 THEN
						shift_level <= 64;
					ELSIF temp_integer > 6 AND temp_integer < 15 THEN
						shift_level <= 32;
					ELSIF temp_integer > 14 AND temp_integer < 31 THEN
						shift_level <= 16;
					ELSIF temp_integer > 30 AND temp_integer < 63 THEN
						shift_level <= 8;
					ELSIF temp_integer > 62 AND temp_integer < 127 THEN
						shift_level <= 4;
					ELSIF temp_integer > 126 AND temp_integer < 255 THEN
						shift_level <= 2;
					ELSE
						shift_level <= 1;
					END IF;
					next_state <= RD_REQ;
				WHEN EL_DATA => --elaborate data
					IF count <= byte_to_read + 2 THEN
						--elaborare il byte letto e scriverlo, enable memoria in write
						o_en      <= '1';
						o_we      <= '1';
						o_address <= std_logic_vector(to_unsigned(count + byte_to_read - 1, 16)); --conversione su 16 bit
						--calcolo new_value del pixel corrente da scrivere
						temp_integer := to_integer(unsigned(i_data) - unsigned(min)) * shift_level;
						IF temp_integer >= 255 THEN
							o_data <= (OTHERS => '1');
						ELSE
							o_data <= std_logic_vector(to_unsigned(temp_integer, 8));
						END IF;
						next_state <= RD_REQ;
					ELSE
						next_state <= DONE;
					END IF;
				WHEN DONE =>
					o_done <= '1';
					IF (i_start = '0') THEN
						next_state <= WT_STR;
					ELSE
						next_state <= DONE;
					END IF;
				WHEN OTHERS =>
			END CASE;
		END IF;
	END PROCESS;
END Behavioral;