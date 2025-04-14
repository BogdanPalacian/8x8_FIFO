library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO_8x8 is
    Port (
        clk     : in std_logic;
        reset   : in std_logic;
        wr      : in std_logic;
        rd      : in std_logic;
        wadd    : in std_logic_vector(2 downto 0);
        radd    : in std_logic_vector(2 downto 0);
        data_in : in std_logic_vector(7 downto 0);
        data_out: out std_logic_vector(7 downto 0)
    );
end FIFO_8x8;

architecture Behavioral of FIFO_8x8 is
    --actual memory
    type reg_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal registers : reg_array := (others => (others => '0'));

    signal write_enable : std_logic_vector(7 downto 0); 
    signal selected_data : std_logic_vector(7 downto 0); 

begin
    --decode wadd using decoder to generate write enable
    process(wadd)
    begin
        write_enable <= (others => '0');
        if wr = '1' then
            write_enable(to_integer(unsigned(wadd))) <= '1';
        end if;
    end process;

    --register set 8 registers of 8 bits
    process(clk, reset)
    begin
        if reset = '1' then
            registers <= (others => (others => '0'));
        elsif rising_edge(clk) then
            for i in 0 to 7 loop
                if write_enable(i) = '1' then
                    registers(i) <= data_in;
                end if;
            end loop;
        end if;
    end process;

    --read he value to be givven as utput works like multiplexer
    process(radd, registers)
    begin
        selected_data <= registers(to_integer(unsigned(radd)));
    end process;

    --if rd then provide the output if not put them on high impedance
    process(rd, selected_data)
    begin
        if rd = '1' then
            data_out <= selected_data;
        else
            data_out <= (others => 'Z');
        end if;
    end process;

end Behavioral;
