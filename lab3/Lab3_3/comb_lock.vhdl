-- comb_lock.vhdl
-- x1 styrs av vänster skjutomkopplare S1
-- x0 styrs av höger skjutomkopplare S0
-- Typically connect the following at the connector area of DigiMod
-- sclk <-- 32kHz

library ieee;
  use ieee.std_logic_1164.all;

entity comb_lock is
  port (clk   : in  std_logic; -- "fast enough"
        reset : in  std_logic; -- active high
        x1    : in  std_logic; -- x1 is left
        x0    : in  std_logic; -- x0 is right
        u     : out std_logic
       );
end entity;

architecture rtl of comb_lock is
  -- signals etc
  signal x0_sync  : std_logic;
  signal x1_sync  : std_logic;
  signal q0       : std_logic;
  signal q1       : std_logic;
  signal q0_plus  : std_logic;
  signal q1_plus  : std_logic;
begin
  
-- Synkronisera Insignaler
  process (clk)
  begin
    if rising_edge(clk) then
      x0_sync <= x0;
      x1_sync <= x1;
      q0 <= q0_plus;
      q1 <= q1_plus;
    end if;
  end process;

  process(clk, reset)
  begin
    if reset = '1' then
      q0_plus <= '0';
      q1_plus <= '0';
    elsif rising_edge(clk) then
      q0_plus <= not(not(q1 and x1_sync and x0_sync)and not(not(x1_sync) and not(x0_sync)) and not(q1 and q0));
      q1_plus <= not(not(not(x1_sync) and x0_sync and q0) and not(x0_sync and q1) and not(x1_sync and q1 and x0_sync));
    end if;
  end process;

-- Utsignaler
  u <= (q1 and q0);
end architecture;
