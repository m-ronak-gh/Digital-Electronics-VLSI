library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_system_tb is
end uart_system_tb;

architecture Behavioral of uart_system_tb is
    signal clk            : STD_LOGIC := '0';
    signal reset          : STD_LOGIC := '0';
    signal tick           : STD_LOGIC := '0';

    signal start          : STD_LOGIC := '0';
    signal data_in        : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    signal data_out       : STD_LOGIC_VECTOR(7 downto 0);
    signal data_valid     : STD_LOGIC;

    signal busy           : STD_LOGIC;
    signal framing_error  : STD_LOGIC;

begin
    uut : entity work.uart_top
    port map(

        clk => clk,
        reset => reset,
        tick => tick,

        start => start,
        data_in => data_in,

        data_out => data_out,
        data_valid => data_valid,

        busy => busy,
        framing_error => framing_error

    );

    clock_process : process
    begin
        while true loop

            clk <= '0';
            wait for 10 ns;

            clk <= '1';
            wait for 10 ns;

        end loop;
    end process;

    tick_process : process
    begin
        while true loop

            tick <= '0';
            wait for 180 ns;

            tick <= '1';
            wait for 20 ns;

        end loop;
    end process;

    stimulus : process
    begin
        -- Reset
        reset <= '1';
        wait for 100 ns;

        reset <= '0';
        wait for 100 ns;

        -- Send A

        data_in <= "01000001";

        start <= '1';
        wait for 20 ns;
        start <= '0';

        wait until data_valid='1';

        assert data_out="01000001"
        report "A Failed"
        severity error;

        wait for 200 ns;

        -- Send 5

        data_in <= "00110101";

        start <= '1';
        wait for 20 ns;
        start <= '0';

        wait until data_valid='1';

        assert data_out="00110101"
        report "5 Failed"
        severity error;

        -- Verify no framing error
        assert framing_error='0'
        report "Unexpected Framing Error"
        severity error;

        report " ALL UART TESTS PASSED SUCCESSFULLY ";
        wait for 200 ns;

        assert false
        report "Simulation Finished"
        severity failure;
    end process;

    -- Monitor
    monitor : process(clk)
    begin
        if rising_edge(clk) then
            if data_valid='1' then
                report "Received Byte = "
                    & integer'image(
                        to_integer(unsigned(data_out))
                    );
            end if;
        end if;
    end process;
end Behavioral;