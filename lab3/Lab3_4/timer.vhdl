-- timer.vhdl
-- Tryckknapp (T0) "startknapp" startar nedräkningen av timern från 8.
-- Timern räknar sedan ned autonomt till 0 och stannar.
-- Utsignal "alarm" tänds när timern visar 0
-- Typically connect the following at the connector area of DigiMod
-- sclk <-- 1Hz

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity timer is
  port (clk        : in  std_logic; -- clk is 1 Hz
        reset      : in  std_logic; -- aktiv hög
        startknapp : in  std_logic; -- aktiv hög
        alarm      : out std_logic;
        seg        : out std_logic_vector(6 downto 0);
        dp         : out std_logic;
        an         : out std_logic_vector(3 downto 0)
       );
end entity;

architecture rtl of timer is
  -- signals etc
    -- Synkroniserade insignaler
    signal s_sync    : std_logic;

    signal alarm_sync: std_logic;
    signal run   : std_logic;
    signal count : unsigned(3 downto 0) := (others => '0'); -- Räknarens värde

  -- 7-segments avkodning, segments t�nds med 0
  type rom is array (0 to 8) of std_logic_vector(6 downto 0);
  constant mem : rom := (
    "1000000", -- 0
    "1111001", -- 1
    "0100100", -- 2
    "0110000", -- 3
    "0011001", -- 4
    "0010010", -- 5
    "0000010", -- 6
    "1111000", -- 7
    "0000000"  -- 8
  );

begin
  process(clk)
  begin
    if rising_edge(clk) then
    s_sync <= startknapp;
    end if;
  end process;

  process(clk, reset)
  begin
    if reset = '1' then
      run <= '0';
      alarm_sync <= '1';
      count      <= (others => '0');

    elsif rising_edge(clk) then

      if s_sync = '1' and run = '0' then  --count = to_unsigned(0, 4) 
        run <= '1';
        count      <= to_unsigned(8,4);
        alarm_sync <= '0';

      elsif run = '1' and count /= to_unsigned(0, 4) then
        count <= count - to_unsigned(1, 4);

      elsif run = '1' and count = to_unsigned(0, 4) then
        alarm_sync <= '1';
        run <= '0';
      end if;
    end if;
  end process;
  seg <= mem(to_integer(count));
  dp  <= '1';  -- Ingen punkt
  an  <= "1110";  -- Välj sista siffran
  alarm <= alarm_sync;
end architecture;