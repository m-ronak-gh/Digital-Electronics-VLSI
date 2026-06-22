library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        A       : in  STD_LOGIC_VECTOR(3 downto 0);
        B       : in  STD_LOGIC_VECTOR(3 downto 0);
        ALU_OP  : in  STD_LOGIC_VECTOR(3 downto 0);

        RESULT  : out STD_LOGIC_VECTOR(3 downto 0);
        ZERO    : out STD_LOGIC
    );
end alu;

architecture Behavioral of alu is
    signal result_int : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(A, B, ALU_OP)
    begin
        case ALU_OP is
            when "0000" =>
                result_int <= std_logic_vector(unsigned(A) + unsigned(B));

            when "0001" =>
                result_int <= std_logic_vector(unsigned(A) - unsigned(B));

            when "0010" =>
                result_int <= A and B;

            when "0011" =>
                result_int <= A or B;

            when "0100" =>
                result_int <= A xor B;

            when "0101" =>
                result_int <= not A;

            when others =>
                result_int <= (others => '0');

        end case;

    end process;

    RESULT <= result_int;

    ZERO <= '1' when result_int = "0000" else '0';

end Behavioral;