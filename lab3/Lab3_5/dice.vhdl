-- dice.vhdl
-- Tryckknapp (T0) "roll" rullar t�rningen
-- roll=0 : t�rningen ligger stilla och visar ett v�rde
-- roll=1 : t�rningen rullar
-- Str�mbrytare (S0) "fake" v�ljer riktig eller falsk t�rning
-- fake=0 : riktig t�rning, dvs samma sannolikhet f�r 1,2,3,4,5 och 6
-- fake=1 : falsk t�rning, dvs tre g�nger h�gre sannolikhet f�r 6
-- Typically connect the following at the connector area of DigiMod
-- sclk <-- 32kHz

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity dice is
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    roll  : in  std_logic;
    fake  : in  std_logic;
    seg   : out std_logic_vector(6 downto 0);
    dp    : out std_logic;
    an    : out std_logic_vector(3 downto 0));
end entity;

architecture arch of dice is

  signal seg_sync: std_logic_vector(6 downto 0) := (others => '0');
  signal value : unsigned(3 downto 0) := (others => '0');

  type rom is array (0 to 5) of std_logic_vector(6 downto 0);
  constant mem : rom := (
    "1111001", -- 1
    "0100100", -- 2
    "0110000", -- 3
    "0011001", -- 4
    "0010010", -- 5
    "0000010"  -- 6
  );

  type rom1 is array (0 to 7) of std_logic_vector(6 downto 0);
  constant fake_mem : rom1 := (
    "1111001", -- 1
    "0100100", -- 2
    "0110000", -- 3
    "0011001", -- 4
    "0010010", -- 5
    "0000010", -- 6
    "0000010", -- 6
    "0000010"  -- 6
  );
begin
  process(clk, reset)
  begin
    if reset = '1' then
      value    <= (others => '0');
      seg_sync <= (others => '0');
    elsif rising_edge(clk) then
      if roll = '1' then
        if fake = '1' then
          if value = to_unsigned(7, 4) then
            value <= (others => '0');
          else
            value <= value + 1;
          end if;
        else
          if value = to_unsigned(5, 4) then
            value <= (others => '0');
          else
            value <= value + 1;
          end if;
        end if;
      end if;
      if fake = '1' then
        seg_sync <= fake_mem(to_integer(value));
      else
        seg_sync <= mem(to_integer(value));
      end if;
    end if;
  end process;
  seg <= seg_sync;
  dp  <= '1';  -- Ingen punkt
  an  <= "1110";  -- V�lj sista siffran
end architecture;