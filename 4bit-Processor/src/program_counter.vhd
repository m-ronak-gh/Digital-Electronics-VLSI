library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_counter is
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        enable  : in  STD_LOGIC;
        load    : in  STD_LOGIC;
        pc_in   : in  STD_LOGIC_VECTOR(3 downto 0);

        pc_out  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end program_counter;

architecture Behavioral of program_counter is
    signal pc_reg : unsigned(3 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');

        elsif rising_edge(clk) then
            if load = '1' then
                pc_reg <= unsigned(pc_in);

            elsif enable = '1' then
                pc_reg <= pc_reg + 1;
            end if;
        end if;
    end process;

    pc_out <= std_logic_vector(pc_reg);
end Behavioral;