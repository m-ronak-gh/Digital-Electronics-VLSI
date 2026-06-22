library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port (
        clk         : in  STD_LOGIC;
        we          : in  STD_LOGIC;

        read_addr1  : in  STD_LOGIC_VECTOR(1 downto 0);
        read_addr2  : in  STD_LOGIC_VECTOR(1 downto 0);
        write_addr  : in  STD_LOGIC_VECTOR(1 downto 0);

        write_data  : in  STD_LOGIC_VECTOR(3 downto 0);

        read_data1  : out STD_LOGIC_VECTOR(3 downto 0);
        read_data2  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end register_file;

architecture Behavioral of register_file is
    type reg_array is array (0 to 3) of STD_LOGIC_VECTOR(3 downto 0);
    signal regs : reg_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                regs(to_integer(unsigned(write_addr))) <= write_data;
            end if;
        end if;
    end process;

    read_data1 <= regs(to_integer(unsigned(read_addr1)));
    read_data2 <= regs(to_integer(unsigned(read_addr2)));
end Behavioral;