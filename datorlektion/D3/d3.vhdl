library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity d3 is
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        sec_ones_7seg : out STD_LOGIC_VECTOR(6 downto 0);
        sec_tens_7seg : out STD_LOGIC_VECTOR(6 downto 0);
        min_ones_7seg : out STD_LOGIC_VECTOR(6 downto 0)
    );
end entity;
 
architecture behav of d3 is
    -- 7-segment display ROM for digits 0 to 9
    type rom is array (0 to 9) of std_logic_vector(6 downto 0);
    constant mem : rom := (
         "1000000", -- 0
         "1111001", -- 1
         "0100100", -- 2
         "0110000", -- 3
         "0011001", -- 4
         "0010010", -- 5
         "0000010", -- 6
         "1111000", -- 7
         "0000000", -- 8
         "0010000"  -- 9
    );

    signal r_sec_ones : integer range 0 to 9 := 0;
    signal r_sec_tens : integer range 0 to 5 := 0;
    signal r_min_ones : integer range 0 to 9 := 0;

    signal next_sec_ones : integer range 0 to 9;
    signal next_sec_tens : integer range 0 to 5;
    signal next_min_ones : integer range 0 to 9;
begin

    process(r_sec_ones, r_sec_tens, r_min_ones)
    begin
        if r_sec_ones = 9 then
            next_sec_ones <= 0;
            if r_sec_tens = 5 then
                next_sec_tens <= 0;
                if r_min_ones = 9 then
                    next_min_ones <= 0;
                else
                    next_min_ones <= r_min_ones + 1;
                end if;
            else
                next_sec_tens <= r_sec_tens + 1;
                next_min_ones <= r_min_ones;
            end if;
        else
            next_sec_ones <= r_sec_ones + 1;
            next_sec_tens <= r_sec_tens;
            next_min_ones <= r_min_ones;
        end if;
    end process;

    -- Seconds ones
    process(clk, reset)
    begin
        if reset = '1' then
            r_sec_ones <= 0;
        elsif rising_edge(clk) then
            r_sec_ones <= next_sec_ones;
        end if;
    end process;

    -- Seconds tens
    process(clk, reset)
    begin
        if reset = '1' then
            r_sec_tens <= 0;
        elsif rising_edge(clk) then
            r_sec_tens <= next_sec_tens;
        end if;
    end process;

    -- Minutes
    process(clk, reset)
    begin
        if reset = '1' then
            r_min_ones <= 0;
        elsif rising_edge(clk) then
            r_min_ones <= next_min_ones;
        end if;
    end process;

    sec_ones_7seg <= mem(r_sec_ones);
    sec_tens_7seg <= mem(r_sec_tens);
    min_ones_7seg <= mem(r_min_ones);
end architecture;