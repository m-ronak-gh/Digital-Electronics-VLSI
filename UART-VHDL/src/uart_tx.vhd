library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
    port (
        clk : in  std_logic;
        reset : in  std_logic;
        tick : in  std_logic;
        start : in  std_logic;
        data_in : in  std_logic_vector(7 downto 0);
        
        tx : out std_logic;
        busy : out std_logic
    );
end entity uart_tx;

architecture Behavioral of uart_tx is
    type state_type is (
        IDLE,
        START_BIT,
        DATA_BITS,
        STOP_BIT
    );

    signal current_state : state_type := IDLE;
    signal shift_reg : std_logic_vector(7 downto 0);
    signal bit_index : integer range 0 to 7 := 0;

begin
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
            shift_reg <= (others => '0');
            bit_index <= 0;
            tx <= '1';
            busy <= '0';

        elsif rising_edge(clk) then
            case current_state is
                when IDLE =>
                    tx <= '1';
                    busy <= '0';
                    if start = '1' then
                        shift_reg <= data_in;
                        bit_index <= 0;
                        busy <= '1';
                        current_state <= START_BIT;
                    end if;
                when START_BIT =>
                    tx <= '0';
                    busy <= '1';
                    if tick = '1' then
                        current_state <= DATA_BITS;
                    end if;
                    current_state <= DATA_BITS;
                when DATA_BITS =>
                    busy <= '1';
                    tx <= shift_reg(bit_index);
                    if tick = '1' then
                        if bit_index = 7 then
                            current_state <= STOP_BIT;
                            bit_index <= 0;
                        else
                            bit_index <= bit_index + 1;
                            current_state <= DATA_BITS;
                        end if;
                    end if;
                when STOP_BIT =>
                    tx <= '1';
                    busy <= '1';
                    if tick = '1' then
                        current_state <= IDLE;
                    end if;
                when others =>
                    current_state <= IDLE;
            end case;
        end if;
    end process;
end Behavioral;