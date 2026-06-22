library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu_top is
    Port (
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC
    );
end cpu_top;

architecture Structural of cpu_top is
    -- Program Counter
    signal pc             : STD_LOGIC_VECTOR(3 downto 0);
    signal pc_enable      : STD_LOGIC;
    signal pc_load        : STD_LOGIC := '0';

    -- Instruction
    signal instruction    : STD_LOGIC_VECTOR(7 downto 0);
    signal opcode         : STD_LOGIC_VECTOR(3 downto 0);

    -- Register File
    signal reg_write      : STD_LOGIC;
    signal read_data1     : STD_LOGIC_VECTOR(3 downto 0);
    signal read_data2     : STD_LOGIC_VECTOR(3 downto 0);
    signal alu_result     : STD_LOGIC_VECTOR(3 downto 0);

    -- ALU
    signal alu_op         : STD_LOGIC_VECTOR(3 downto 0);
    signal zero_flag      : STD_LOGIC;

    -- Halt
    signal halt           : STD_LOGIC;
begin

-- Program Counter
PC_INST : entity work.program_counter
port map(
    clk     => clk,
    reset   => reset,
    enable  => pc_enable,
    load    => pc_load,
    pc_in   => (others => '0'),
    pc_out  => pc
);

-- Instruction Memory
ROM_INST : entity work.instruction_memory
port map(
    address     => pc,
    instruction => instruction
);

opcode <= instruction(7 downto 4);

-- Register File
REG_INST : entity work.register_file
port map(
    clk         => clk,
    we          => reg_write,

    read_addr1  => "00",
    read_addr2  => "01",
    write_addr  => "00",

    write_data  => alu_result,

    read_data1  => read_data1,
    read_data2  => read_data2
);

-- ALU
ALU_INST : entity work.alu
port map(
    A       => read_data1,
    B       => read_data2,

    ALU_OP  => alu_op,

    RESULT  => alu_result,
    ZERO    => zero_flag
);

-- Control Unit
CTRL_INST : entity work.control_unit
port map(

    clk         => clk,
    reset       => reset,

    opcode      => opcode,
    zero_flag   => zero_flag,

    pc_enable   => pc_enable,
    reg_write   => reg_write,
    halt        => halt,
    alu_op      => alu_op
);
end Structural;