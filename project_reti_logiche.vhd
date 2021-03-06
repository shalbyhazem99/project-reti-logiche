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
	 PREP_ELAB_VALUES, DONE,	
	READ_REQ, READ_ROW, READ_COLUMN, COMPARE_DATA, ELABORATE_DATA
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
						shift_level <= 9;
						next_state <= READ_REQ;
					ELSE
						o_done     <= '0';
						next_state <= WAIT_START;
					END IF;
				WHEN  READ_REQ =>
				    o_en            <= '1';
                    o_we            <= '0';
                    o_address       <= std_logic_vector(to_unsigned(count,16));
                    next_state      <= WAIT_MEM;
				WHEN WAIT_MEM => 
				    IF count=0 then 
				        next_state <= READ_COLUMN;
				    ELSIF count=1 then 
                        next_state <= READ_ROW;
				    ELSIF shift_level < 9 then 
				        next_state <= ELABORATE_DATA;
				    ELSE 
				        next_state <= COMPARE_DATA;
				    END IF;
				    --INCREMENTO DI COUNT
                    temp_integer := count;
                    count      <= temp_integer + 1;
				WHEN READ_COLUMN => 
					byte_to_read    <= TO_INTEGER(unsigned (i_data));
					next_state      <= READ_REQ;
				WHEN READ_ROW => 
					temp_integer := byte_to_read * TO_INTEGER(unsigned (i_data));
					byte_to_read <= temp_integer;
					next_state   <= READ_REQ;
				WHEN COMPARE_DATA => 
					IF count <= byte_to_read+2 THEN
					IF i_data < min THEN
						min <= i_data;
					END IF;
					IF i_data > max THEN
						max <= i_data;
					END IF;
					 --incremento count
						next_state <= READ_REQ;
					ELSE
						count      <= 2;
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
					next_state <= READ_REQ;
				WHEN elaborate_data => 
					IF count <= byte_to_read+2 THEN
						--elaborare il byte letto e scriverlo, enable memoria in write
						o_en      <= '1';
						o_we      <= '1';
						o_address <= std_logic_vector(to_unsigned(count + byte_to_read-1, 16)); --conversione su 16 bit
						--calcolo new_value del pixel corrente da scrivere
						temp_integer := (to_integer(unsigned(i_data) - unsigned(min))) * 2 ** shift_level;
						IF temp_integer > 255 THEN
							o_data <= (OTHERS => '1');
						ELSE
							o_data <= std_logic_vector(to_unsigned(temp_integer, 8));
						END IF;
						next_state <= READ_REQ;
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