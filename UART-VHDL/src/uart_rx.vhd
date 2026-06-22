library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    Port(
        clk            : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        tick           : in  STD_LOGIC;
        rx             : in  STD_LOGIC;

        data_out       : out STD_LOGIC_VECTOR(7 downto 0);
        data_valid     : out STD_LOGIC;
        framing_error  : out STD_LOGIC
    );
end uart_rx;

architecture Behavioral of uart_rx is

    type state_type is (
        IDLE,
        START_BIT,
        DATA_BITS,
        STOP_BIT
    );

    signal current_state : state_type := IDLE;
    signal shift_reg      : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal bit_index      : integer range 0 to 7 := 0;

begin

    process(clk, reset)
    begin
        if reset = '1' then

            current_state <= IDLE;
            shift_reg <= (others => '0');
            bit_index <= 0;

            data_out <= (others => '0');
            data_valid <= '0';
            framing_error <= '0';

        elsif rising_edge(clk) then

            -- Default outputs
            data_valid <= '0';
            framing_error <= '0';

            case current_state is

                when IDLE =>

                    if rx = '0' then
                        bit_index <= 0;
                        current_state <= START_BIT;
                    end if;

                when START_BIT =>

                    if tick = '1' then
                        current_state <= DATA_BITS;
                    end if;

                when DATA_BITS =>

                    if tick = '1' then

                        shift_reg(bit_index) <= rx;

                        if bit_index = 7 then
                            current_state <= STOP_BIT;
                        else
                            bit_index <= bit_index + 1;
                        end if;

                    end if;

                when STOP_BIT =>

                    if tick = '1' then

                        if rx = '1' then
                            data_out <= shift_reg;
                            data_valid <= '1';
                        else
                            framing_error <= '1';
                        end if;

                        current_state <= IDLE;

                    end if;

                when others =>

                    current_state <= IDLE;

            end case;

        end if;

    end process;

end Behavioral;