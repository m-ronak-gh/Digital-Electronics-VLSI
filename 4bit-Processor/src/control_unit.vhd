library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        opcode      : in  STD_LOGIC_VECTOR(3 downto 0);
        zero_flag   : in  STD_LOGIC;

        pc_enable   : out STD_LOGIC;
        reg_write   : out STD_LOGIC;
        halt        : out STD_LOGIC;
        alu_op      : out STD_LOGIC_VECTOR(3 downto 0)
    );
end control_unit;

architecture Behavioral of control_unit is

    type state_type is (FETCH, DECODE, EXECUTE);
    signal state : state_type := FETCH;

begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= FETCH;

        elsif rising_edge(clk) then
            case state is
                when FETCH =>
                    state <= DECODE;

                when DECODE =>
                    state <= EXECUTE;

                when EXECUTE =>
                    state <= FETCH;
            end case;
        end if;
    end process;

    process(state, opcode)
    begin

        -- Default outputs
        pc_enable <= '0';
        reg_write <= '0';
        halt      <= '0';
        alu_op    <= "0000";

        case state is
            when FETCH =>
                pc_enable <= '1';

            when DECODE =>
                null;

            when EXECUTE =>
                case opcode is
                    when "0011" =>     -- ADD
                        alu_op <= "0000";
                        reg_write <= '1';

                    when "0100" =>     -- SUB
                        alu_op <= "0001";
                        reg_write <= '1';

                    when "0101" =>     -- AND
                        alu_op <= "0010";
                        reg_write <= '1';

                    when "0110" =>     -- OR
                        alu_op <= "0011";
                        reg_write <= '1';

                    when "0111" =>     -- XOR
                        alu_op <= "0100";
                        reg_write <= '1';

                    when "1000" =>     -- NOT
                        alu_op <= "0101";
                        reg_write <= '1';

                    when "1011" =>     -- HLT
                        halt <= '1';

                    when others =>
                        null;
                end case;
        end case;
    end process;
end Behavioral;