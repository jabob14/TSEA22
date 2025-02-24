library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity d3 is
  Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        sec_ones_7seg  : out STD_LOGIC_VECTOR(6 downto 0);
        sec_tens_7seg  : out STD_LOGIC_VECTOR(6 downto 0);
        min_ones_7seg  : out STD_LOGIC_VECTOR(6 downto 0)
    );
end entity;

architecture behav of d3 is
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

    signal carry_sec_ones : std_logic := '0';
    signal carry_sec_tens : std_logic := '0'; 

begin

-- Sec ones
process(clk, reset)
begin
    if reset = '1' then
        r_sec_ones     <= 0;
        carry_sec_ones <= '0';
    elsif rising_edge(clk) then
        if r_sec_ones = 9 then
            r_sec_ones     <= 0;
            carry_sec_ones <= '1';
        else
            r_sec_ones     <= r_sec_ones + 1;
            carry_sec_ones <= '0';
        end if;
    end if;
end process;

-- Sec tens
process(clk, reset)
begin
    if reset = '1' then
        r_sec_tens     <= 0;
        carry_sec_tens <= '0';
    elsif rising_edge(clk) then
        if carry_sec_ones = '1' then
            if r_sec_tens = 5 then
                r_sec_tens     <= 0;
                carry_sec_tens <= '1';
            else
                r_sec_tens     <= r_sec_tens + 1;
                carry_sec_tens <= '0';
            end if;
        end if;
    end if;
end process;

-- Minutes
process(clk, reset)
begin
    if reset = '1' then
        r_min_ones <= 0;
    elsif rising_edge(clk) then
        if carry_sec_tens = '1' then
            if r_min_ones = 9 then
                r_min_ones <= 0;
            else
                r_min_ones <= r_min_ones + 1;
            end if;
        end if;
    end if;
end process;

    sec_ones_7seg <= mem(r_sec_ones);
    sec_tens_7seg <= mem(r_sec_tens);
    min_ones_7seg <= mem(r_min_ones);

end architecture;