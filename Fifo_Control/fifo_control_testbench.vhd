library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo_control_testbench is
end fifo_control_testbench;

architecture Behavioral of fifo_control_testbench is
    
    component FIFO_Control
        Port (
            clk     : in std_logic;
            reset   : in std_logic;
            wr      : in std_logic;
            rd      : in std_logic;
            radd    : out std_logic_vector(2 downto 0);
            wadd    : out std_logic_vector(2 downto 0);
            empty   : out std_logic;
            full    : out std_logic
        );
    end component;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal wr      : std_logic := '0';
    signal rd      : std_logic := '0';
    signal radd    : std_logic_vector(2 downto 0);
    signal wadd    : std_logic_vector(2 downto 0);
    signal empty   : std_logic;
    signal full    : std_logic;

    constant clk_period : time := 10 ns;

begin
    uut: FIFO_Control Port Map (
        clk     => clk,
        reset   => reset,
        wr      => wr,
        rd      => rd,
        radd    => radd,
        wadd    => wadd,
        empty   => empty,
        full    => full
    );

    --generate clock
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    
    test : process
    begin
        -- empty fifo control
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        --test write till full
        for i in 0 to 7 loop --here modify
            wr <= '1';
            wait for clk_period;
            wr <= '0';
            wait for clk_period;
        end loop;

        assert (full = '1') report "Full condition failed" severity error;

        --test read till empty
        for i in 0 to 7 loop
            rd <= '1';
            wait for clk_period;
            rd <= '0';
            wait for clk_period;
        end loop;

        assert (empty = '1') report "Empty condition failed" severity error;

        --test sequential write and read
        wr <= '1'; wait for clk_period; wr <= '0'; 
        rd <= '1'; wait for clk_period; rd <= '0'; 

        assert (empty = '1' and full = '0') report "Single read/write failed" severity error;

        wait;
    end process;

end Behavioral;
