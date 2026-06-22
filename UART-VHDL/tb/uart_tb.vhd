library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tb is
end uart_tb;

architecture Behavioral of uart_tb is
    
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal tick : std_logic := '0';
    signal start : std_logic := '0';

    signal data_in : std_logic_vector(7 downto 0);

    signal tx : std_logic;
    signal busy : std_logic;

    begin
        -- uut : unit under test
        uut : entity work.uart_tx
            port map (
                clk => clk,
                reset => reset,
                tick => tick,
                start => start,
                data_in => data_in,
                tx => tx,
                busy => busy
            );

        -- Clock generation : for 50 MHz clock (20 ns period)
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

        stimulus_process : process
        begin
            -- Reset the system
            reset <= '1';
            wait for 100 ns;
            reset <= '0';
            wait for 100 ns;
            -- Send a byte of data
            data_in <= "01000001"; -- ASCII 'A'
            start <= '1';
            wait for 20 ns;
            start <= '0';

            wait until busy = '0'; -- Wait until transmission is complete
            wait for 100 ns; -- Wait before ending simulation
            assert false 
            report "End of simulation" 
            severity failure;
        end process;
end Behavioral;