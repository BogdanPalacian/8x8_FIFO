library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO_Control is
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
end FIFO_Control;

architecture Behavioral of FIFO_Control is
    signal radd_reg : unsigned(2 downto 0) := "000";
    signal wadd_reg : unsigned(2 downto 0) := "000";
    signal empty_reg : std_logic := '1';
    signal full_reg  : std_logic := '0';
    
begin
    -- Update the outputs
    radd <= std_logic_vector(radd_reg);
    wadd <= std_logic_vector(wadd_reg);
    empty <= empty_reg;
    full <= full_reg;

    process(clk, reset)
    begin
        if reset = '1' then
            radd_reg <= (others => '0');
            wadd_reg <= (others => '0');
            empty_reg <= '1';
            full_reg <= '0';
        elsif rising_edge(clk) then
        
            --write
            if wr = '1' and full_reg = '0' then
                wadd_reg <= wadd_reg + 1;  --increment the address for next write
                empty_reg <= '0';  --not empty as i have written
            end if;

            --read
            if rd = '1' and empty_reg = '0' then
                radd_reg <= radd_reg + 1; --increment address for next read
                full_reg <= '0'; --if i read it cant be full
            end if;

            --full and empty formula
            if wadd_reg + 1 = radd_reg then
                full_reg <= '1';
            else
                full_reg <= '0';
            end if;

            if wadd_reg = radd_reg and full_reg = '0' then
                empty_reg <= '1';
            end if;
        end if;
    end process;
end Behavioral;
