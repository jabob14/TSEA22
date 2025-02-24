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

begin
    process(clk, reset)
        variable sec_ones_v : integer range 0 to 9;
        variable sec_tens_v : integer range 0 to 5;
        variable min_ones_v : integer range 0 to 9;
    begin
        if reset = '1' then
            sec_ones_v := 0;
            sec_tens_v := 0;
            min_ones_v := 0;

        elsif rising_edge(clk) then
            sec_ones_v := r_sec_ones;
            sec_tens_v := r_sec_tens;
            min_ones_v := r_min_ones;

            if sec_ones_v = 9 then
                sec_ones_v := 0;
                if sec_tens_v = 5 then
                    sec_tens_v := 0;
                    if min_ones_v = 9 then
                        min_ones_v := 0;
                    else
                        min_ones_v := min_ones_v + 1;
                    end if;
                else
                    sec_tens_v := sec_tens_v + 1;
                end if;
            else
                sec_ones_v := sec_ones_v + 1;
            end if;
        end if;
        
        r_sec_ones <= sec_ones_v;
        r_sec_tens <= sec_tens_v;
        r_min_ones <= min_ones_v;
    end process;
    sec_ones_7seg <= mem(r_sec_ones);
    sec_tens_7seg <= mem(r_sec_tens);
    min_ones_7seg <= mem(r_min_ones);

end architecture;