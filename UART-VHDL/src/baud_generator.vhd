library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity baud_generator is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        tick : out STD_LOGIC
    );
end baud_generator;

architecture Behavioral of baud_generator is
    constant CLOCK_FREQ : integer := 50000000;
    constant BAUD_RATE  : integer := 9600;
    constant DIVISOR : integer := CLOCK_FREQ / BAUD_RATE;
    
    signal counter : integer range 0 to DIVISOR - 1 := 0;

begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            tick <= '0';
        elsif rising_edge(clk) then
            if counter = DIVISOR - 1 then
                counter <= 0;
                tick <= '1';
            else
                counter <= counter + 1;
                tick <= '0';
            end if;
        end if;
    end process;
end Behavioral;