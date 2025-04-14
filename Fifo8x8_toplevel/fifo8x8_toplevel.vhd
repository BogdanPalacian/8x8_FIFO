library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo8x8_toplevel is
    Port (
        clk        : in std_logic;
        reset      : in std_logic;
        btn_wr     : in std_logic;
        btn_rd     : in std_logic;
        data_in    : in std_logic_vector(7 downto 0);
        cat        : out std_logic_vector(6 downto 0);
        an         : out std_logic_vector(3 downto 0)
    );
end fifo8x8_toplevel;

architecture Behavioral of fifo8x8_toplevel is

    component debouncer
        Port (
            clk : in std_logic;
            btn : in std_logic;
            en  : out std_logic
        );
    end component;

    component display_7seg
        Port (
            digit0 : in std_logic_vector(3 downto 0);
            digit1 : in std_logic_vector(3 downto 0);
            digit2 : in std_logic_vector(3 downto 0);
            digit3 : in std_logic_vector(3 downto 0);
            clk    : in std_logic;
            cat    : out std_logic_vector(6 downto 0);
            an     : out std_logic_vector(3 downto 0)
        );
    end component;

    component FIFO_Control
        Port (
            clk    : in std_logic;
            reset  : in std_logic;
            wr     : in std_logic;
            rd     : in std_logic;
            wadd   : out std_logic_vector(2 downto 0);
            radd   : out std_logic_vector(2 downto 0);
            empty  : out std_logic;
            full   : out std_logic
        );
    end component;

    -- Component Declaration for FIFO 8x8 Memory
    component FIFO_8x8
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
    end component;

    --internal siganls for fifo contreol
    signal wr      : std_logic;
    signal rd      : std_logic;
    signal wadd    : std_logic_vector(2 downto 0);
    signal radd    : std_logic_vector(2 downto 0);
    signal empty   : std_logic;
    signal full    : std_logic;
    signal data_out: std_logic_vector(7 downto 0);

    --debounced wr and rd
    signal wr_en : std_logic;
    signal rd_en : std_logic;

    --first 2 digits address last 2 value
    signal display_digit0 : std_logic_vector(3 downto 0);
    signal display_digit1 : std_logic_vector(3 downto 0);
    signal display_digit2 : std_logic_vector(3 downto 0);
    signal display_digit3 : std_logic_vector(3 downto 0);

begin
    --debouncer for wr
    debouncer_wr : debouncer
        Port map (
            clk => clk,
            btn => btn_wr,
            en  => wr_en
        );

    --debouncer for rd
    debouncer_rd : debouncer
        Port map (
            clk => clk,
            btn => btn_rd,
            en  => rd_en
        );

    fifo_control : FIFO_Control
        Port map (
            clk    => clk,
            reset  => reset,
            wr     => wr_en,
            rd     => rd_en,
            wadd   => wadd,
            radd   => radd,
            empty  => empty,
            full   => full
        );

    fifo_memory : FIFO_8x8
        Port map (
            clk     => clk,
            reset   => reset,
            wr      => wr_en,
            rd      => rd_en,
            wadd    => wadd,
            radd    => radd,
            data_in => data_in,
            data_out => data_out
        );

    --setup ssd
    display_digit0 <= radd(3 downto 0);--address
    display_digit1 <= "0000" ;--only first digits needed
    display_digit2 <= data_out(3 downto 0);
    display_digit3 <= data_out(7 downto 4);

    ssd_display : display_7seg
        Port map (
            digit0 => display_digit0,
            digit1 => display_digit1,
            digit2 => display_digit2,
            digit3 => display_digit3,
            clk    => clk,
            cat    => cat,
            an     => an
        );

end Behavioral;
