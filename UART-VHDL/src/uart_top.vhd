library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_top is
    Port(

        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        tick : in STD_LOGIC;

        start : in STD_LOGIC;
        data_in : in STD_LOGIC_VECTOR(7 downto 0);

        data_out : out STD_LOGIC_VECTOR(7 downto 0);
        data_valid : out STD_LOGIC;

        busy : out STD_LOGIC;
        framing_error : out STD_LOGIC

    );
end uart_top;

architecture Behavioral of uart_top is

    signal tx_wire : STD_LOGIC;

begin
    -- UART Transmitter
    tx_inst : entity work.uart_tx
    port map(

        clk => clk,
        reset => reset,
        tick => tick,

        start => start,
        data_in => data_in,

        tx => tx_wire,
        busy => busy

    );

    -- UART Receiver
    rx_inst : entity work.uart_rx
    port map(

        clk => clk,
        reset => reset,
        tick => tick,

        rx => tx_wire,

        data_out => data_out,
        data_valid => data_valid,
        framing_error => framing_error

    );

end Behavioral;