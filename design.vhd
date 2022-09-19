--: Half Adder

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;

--: entity

entity half_adder is
port(
  a: in std_logic;
  b: in std_logic;
  s: out std_logic;
  c: out std_logic);
end half_adder;

--: architecture

architecture half_adder_arc of half_adder is
begin
  process(a, b) is
  begin
    s <= a xor b;
    c <= a and b;
  end process;
end half_adder_arc;

--: Full Adder

library IEEE;
use IEEE.std_logic_1164.all;

--: entity

entity full_adder is
port(
  a: in std_logic;
  b: in std_logic;
  cin: in std_logic;
  s: out std_logic;
  c: out std_logic);
end full_adder;

--: architecture

architecture full_adder_arc of full_adder is

signal s1,c1,c2 : std_logic:='0';

begin
  
  h1: entity work.half_adder(half_adder_arc)
    port map(
	  a => a,
      b => b,
      s => s1,
      c => c1
    );
    
  h2: entity work.half_adder(half_adder_arc)
    port map(
	  a => s1,
      b => cin,
      s => s,
      c => c2
    );
    
   process(c1, c2) is
   begin
     c <= c1 or c2;
   end process;    
   
end full_adder_arc;

--: 4-Bit Ripple Adder // 4-Bit Ripple Subtractor

library IEEE;
use IEEE.std_logic_1164.all;

--: entity

entity ripple is
port(
  a: in STD_LOGIC_VECTOR (3 downto 0);
  b: in STD_LOGIC_VECTOR (3 downto 0);
  cin: in std_logic;
  s: out STD_LOGIC_VECTOR (3 downto 0);
  c4: out std_logic);
end ripple;

--: adder architecture

architecture ripple_adder_arc of ripple is

signal c1,c2,c3 : std_logic:='0';

begin

  f1: entity work.full_adder(full_adder_arc)
      port map(a(0), b(0), cin, s(0), c1);

  f2: entity work.full_adder(full_adder_arc)
      port map(a(1), b(1), c1, s(1), c2);

  f3: entity work.full_adder(full_adder_arc)
      port map(a(2), b(2), c2, s(2), c3);
      
  f4: entity work.full_adder(full_adder_arc)
      port map(a(3), b(3), c3, s(3), c4);

end ripple_adder_arc;

--: subtractor architecture

architecture ripple_subtractor_arc of ripple is

signal c1,c2,c3 : std_logic:='0';

begin

  s1: entity work.full_adder(full_adder_arc)
      port map(a(0), b(0) xor cin, cin, s(0), c1);

  s2: entity work.full_adder(full_adder_arc)
      port map(a(1), b(1) xor cin, c1, s(1), c2);

  s3: entity work.full_adder(full_adder_arc)
      port map(a(2), b(2) xor cin, c2, s(2), c3);
      
  s4: entity work.full_adder(full_adder_arc)
      port map(a(3), b(3) xor cin, c3, s(3), c4);

end ripple_subtractor_arc;