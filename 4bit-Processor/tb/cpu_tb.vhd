library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_tb is
end cpu_tb;

architecture Behavioral of cpu_tb is
    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
begin
    DUT : entity work.cpu_top
    port map(
        clk   => clk,
        reset => reset
    );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;

            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    stimulus : process
    begin
        wait for 20 ns;

        reset <= '0';

        wait for 500 ns;

        wait;
    end process;
end Behavioral;