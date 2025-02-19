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

begin

end architecture;
