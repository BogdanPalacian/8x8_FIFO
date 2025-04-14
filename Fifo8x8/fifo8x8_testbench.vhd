library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo8x8_testbench is
end fifo8x8_testbench;

architecture Behavioral of fifo8x8_testbench is
    component FIFO_8x8
        Port (
            clk       : in std_logic;
            reset     : in std_logic;
            wr        : in std_logic;
            rd        : in std_logic;
            wadd      : in std_logic_vector(2 downto 0);
            radd      : in std_logic_vector(2 downto 0);
            data_in   : in std_logic_vector(7 downto 0);
            data_out  : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal wr        : std_logic := '0';
    signal rd        : std_logic := '0';
    signal wadd      : std_logic_vector(2 downto 0) := (others => '0');
    signal radd      : std_logic_vector(2 downto 0) := (others => '0');
    signal data_in   : std_logic_vector(7 downto 0) := (others => '0');
    signal data_out  : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: FIFO_8x8
        Port map (
            clk     => clk,
            reset   => reset,
            wr      => wr,
            rd      => rd,
            wadd    => wadd,
            radd    => radd,
            data_in => data_in,
            data_out => data_out
        );

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    
    process
    begin
        --reset fifo
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        --test writing data 0...70
        for i in 0 to 7 loop
            wr <= '1';
            wadd <= std_logic_vector(to_unsigned(i, 3)); 
            data_in <= std_logic_vector(to_unsigned(i * 10, 8)); 
            wait for clk_period;
            wr <= '0';
            wait for clk_period;
        end loop;

        --test reading data from fifo
        for i in 0 to 7 loop
            rd <= '1';
            radd <= std_logic_vector(to_unsigned(i, 3));
            wait for clk_period;
            rd <= '0';
            wait for clk_period;
    
            assert data_out = std_logic_vector(to_unsigned(i * 10, 8))
                report "Data mismatch at address " & integer'image(i)
                severity error;
        end loop;

       
        wait;
    end process;

end Behavioral;
