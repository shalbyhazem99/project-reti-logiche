----------------------------------------------------------------------------------
-- PROGETTO DI RETI LOGICHE
--
-- SHALBY HAZEM HESHAM YOUSEF (10596243)
-- PEREGO
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY project_reti_logiche IS
	PORT 
	(
		i_clk     : IN std_logic;
		i_rst     : IN std_logic; --viene sempre dato prima della prima elaborazione
		i_start   : IN std_logic; --da inizio all'elaborazione e rimane alto fino a che done non viene portato alto
		i_data    : IN std_logic_vector(7 DOWNTO 0);
		o_address : OUT std_logic_vector(15 DOWNTO 0);
		o_done    : OUT std_logic; --portato alto quando si finisce l'elaborazione
		o_en      : OUT std_logic; --memory enable
		o_we      : OUT std_logic; --write enable
		o_data    : OUT std_logic_vector (7 DOWNTO 0) --eventuale segnale da scrivere in memoria all'indirizzo o-address
	);
END project_reti_logiche;

ARCHITECTURE Behavioral OF project_reti_logiche IS
	TYPE stato IS (WAIT_RESET, WAIT_START, WAIT_MEMORY, 
	READ_COLUMN_REQ, READ_COLUMN, 
	READ_ROW_REQ, READ_ROW, 
	READ_DATA_REQ, READ_DATA, 
	START_ELABORATING, END_ELABORATING, 
	READ_DATA_REQ_PHASE2, READ_DATA_PHASE2
	);

	CONSTANT column_address                           : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
	CONSTANT row_address                              : std_logic_vector(15 DOWNTO 0) := (0 => '1', OTHERS => '0'); --
	CONSTANT all_one                                  : std_logic_vector(7 DOWNTO 0) := (OTHERS => '1'); --255

	SIGNAL next_state, current_state, wait_next_state : stato;
	SIGNAL byte_to_read, count, shift_level           : INTEGER;
	SIGNAL max, min                                   : std_logic_vector(7 DOWNTO 0);
BEGIN
	PROCESS (i_clk, i_rst)
	BEGIN
		IF i_rst = '1' THEN
			current_state <= WAIT_START;
		ELSIF rising_edge(i_clk) THEN
			current_state <= next_state;
		END IF;
	END PROCESS;

	PROCESS (current_state, i_start)
	VARIABLE temp_integer : INTEGER;
	VARIABLE temp_pixel   : std_logic_vector(7 DOWNTO 0);
		BEGIN
			CASE current_state IS
				WHEN WAIT_START => 
					o_done <= '0';
					IF i_start = '1' THEN
						max        <= (OTHERS => '0');
						min        <= (OTHERS => '1');
						count      <= 0;
						next_state <= READ_COLUMN_REQ;
					ELSE
						next_state <= WAIT_START;
					END IF;

				WHEN WAIT_MEMORY => 
					next_state <= wait_next_state;
				WHEN READ_COLUMN_REQ => 
					o_en            <= '1';
					o_we            <= '0';
					o_address       <= column_address;
					wait_next_state <= READ_COLUMN;
					next_state      <= WAIT_MEMORY;
				WHEN READ_COLUMN => 
					byte_to_read <= TO_INTEGER(unsigned (i_data));
					next_state   <= READ_row_req;
				WHEN READ_ROW_REQ => 
					o_en            <= '1';
					o_we            <= '0';
					o_address       <= row_address;
					wait_next_state <= READ_ROW;
					next_state      <= WAIT_MEMORY;
				WHEN READ_ROW => 
					temp_integer := byte_to_read * TO_INTEGER(unsigned (i_data));
					byte_to_read <= temp_integer;
					next_state   <= READ_DATA_REQ;
					-- calcolo massimo e minimo
				WHEN READ_DATA_REQ => 
					o_en            <= '1';
					o_we            <= '0';
					o_address       <= std_logic_vector(to_unsigned(count + 2, 16)); --conversione su 16 bit
					wait_next_state <= READ_DATA;
					next_state      <= WAIT_MEMORY;

				WHEN READ_DATA => 
					IF i_data < min THEN
						min <= i_data;
					END IF;
					IF i_data > max THEN
						max <= i_data;
					END IF;
					IF count < byte_to_read - 1 THEN --INCREMENTO COUNT
						temp_integer := count;
						count      <= temp_integer + 1;
						next_state <= READ_DATA_REQ;
					ELSE
						count      <= 0;
						next_state <= START_ELABORATING;

					END IF;
				WHEN START_ELABORATING => 
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
					next_state <= READ_DATA_REQ_PHASE2;
				WHEN READ_DATA_REQ_PHASE2 => 
					o_en            <= '1';
					o_we            <= '0';
					o_address       <= std_logic_vector(to_unsigned(count + 2, 16)); --conversione su 16 bit
					wait_next_state <= READ_DATA_PHASE2;
					next_state      <= WAIT_MEMORY;
				WHEN READ_DATA_PHASE2 => 
					IF count < byte_to_read THEN
						--elaborare il byte letto e scriverlo
						o_en      <= '1';
						o_we      <= '1';
						o_address <= std_logic_vector(to_unsigned(count + byte_to_read + 2, 16)); --conversione su 16 bit
						--calcolo dato da scrivere
						temp_integer := (to_integer(unsigned(i_data) - unsigned(min)) * 2 * shift_level);
						IF temp_integer > 255 THEN
							o_data <= all_one;
						ELSE 
							o_data <= std_logic_vector(to_unsigned(temp_integer, 8));
						END IF;
 
						--INCREMENTO COUNT
						temp_integer := count;
						count      <= temp_integer + 1;
 
						next_state <= READ_DATA_REQ_PHASE2;
					ELSE
						next_state <= END_ELABORATING;
					END IF;
 
				WHEN END_ELABORATING => 
					o_done     <= '1';
					next_state <= WAIT_START;

				WHEN OTHERS => 
			END CASE;
		END PROCESS;
END Behavioral;