library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory is
    Port (
        address     : in  STD_LOGIC_VECTOR(3 downto 0);
        instruction : out STD_LOGIC_VECTOR(7 downto 0)
    );
end instruction_memory;

architecture Behavioral of instruction_memory is

    type rom_type is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);

    constant ROM : rom_type := (

        0 => "00010011", -- LDI R0,3
        1 => "00010110", -- LDI R1,2
        2 => "00100001", -- ADD
        3 => "00110001", -- SUB
        4 => "01100001", -- XOR
        5 => "10110000", -- HLT

        others => "00000000"
    );

begin

    instruction <= ROM(to_integer(unsigned(address)));

end Behavioral;