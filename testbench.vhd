library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end testbench; 

architecture tb of testbench is

--: components

component half_adder is
port(
  a: in std_logic;
  b: in std_logic;
  s: out std_logic;
  c: out std_logic);
end component;

component full_adder is
port(
  a: in std_logic;
  b: in std_logic;
  cin: in std_logic;
  s: out std_logic;
  c: out std_logic);
end component;

component ripple is
port(
  a: in STD_LOGIC_VECTOR (3 downto 0);
  b: in STD_LOGIC_VECTOR (3 downto 0);
  cin: in std_logic;
  s: out STD_LOGIC_VECTOR (3 downto 0);
  c4: out std_logic);
end component;

--: signals

signal ha_in, hb_in, hs_out, hc_out: std_logic;

signal fa_in, fb_in, fcin_in, fs_out, fc_out: std_logic;

signal ra_in, rb_in, rs_out: STD_LOGIC_VECTOR (3 downto 0);
signal rcin_in, rc_out: std_logic;

signal sa_in, sb_in, ss_out: STD_LOGIC_VECTOR (3 downto 0);
signal scin_in, sc_out: std_logic;

--: test_vectors

type half_adder_vector is record
        a, b, s, c: std_logic;
    end record;
    
type full_adder_vector is record
        a, b, cin, s, c: std_logic;
    end record;

type ripple_vector is record
        r5, r4, r3, r2, r1: std_logic;
    end record;
    
signal V: ripple_vector;
    
type half_adder_vector_array is array (natural range <>) of half_adder_vector;
    constant half_adder_vec : half_adder_vector_array := (
        ('0', '0', '0', '0'),
        ('0', '1', '1', '0'),
        ('1', '0', '1', '0'),
        ('1', '1', '0', '1')
    );
    
type full_adder_vector_array is array (natural range <>) of full_adder_vector;
    constant full_adder_vec : full_adder_vector_array := (
        ('0', '0', '0', '0', '0'),
        ('0', '0', '1', '1', '0'),
        ('0', '1', '0', '1', '0'),
        ('0', '1', '1', '0', '1'),
        ('1', '0', '0', '1', '0'),
        ('1', '0', '1', '0', '1'),
        ('1', '1', '0', '0', '1'),
        ('1', '1', '1', '1', '1')
    );
    
--: processes

begin

  HA: half_adder port map(ha_in, hb_in, hs_out, hc_out);
  FA: full_adder port map(fa_in, fb_in, fcin_in, fs_out, fc_out);
  RA: entity work.ripple(ripple_adder_arc) port map(ra_in, rb_in, rcin_in, rs_out, rc_out);
  RS: entity work.ripple(ripple_subtractor_arc) port map(sa_in, sb_in, scin_in, ss_out, sc_out);
  
  process
  begin
  
    for i in half_adder_vec'range loop
        ha_in <= half_adder_vec(i).a;
        hb_in <= half_adder_vec(i).b;
        wait for 1 ns;
        assert ( 
           (hs_out = half_adder_vec(i).s) and 
           (hc_out = half_adder_vec(i).c) 
        )
        report  "half adder, " & 
                "a = " & std_logic'image(ha_in) & 
                ", b = " & std_logic'image(hb_in)
             severity error;
    end loop;
    
    wait;
  end process;

  process
  begin
  
    for i in full_adder_vec'range loop
        fa_in <= full_adder_vec(i).a;
        fb_in <= full_adder_vec(i).b;
        fcin_in <= full_adder_vec(i).cin;
        wait for 1 ns;
        assert ( 
           (fs_out = full_adder_vec(i).s) and 
           (fc_out = full_adder_vec(i).c) 
        )
        report  "full adder, " & 
                "a = " & std_logic'image(fa_in) & 
                ", b = " & std_logic'image(fb_in) &
                ", cin = " & std_logic'image(fcin_in)
             severity error;
    end loop;
    
    wait;
  end process;
  
  process
  begin
  	
    for I in 0 to 15 loop
	  for J in 0 to 15 loop
        ra_in <= std_logic_vector(to_signed(I, ra_in'length));
        rb_in <= std_logic_vector(to_signed(J, rb_in'length));
        rcin_in <= '0';
        wait for 1 ns;
        assert(
            ((to_string(rc_out) & to_string(rs_out)) = to_string(std_logic_vector( to_signed(I + J, 5))))
        )
      	report "4-bit Adder, " & "test case: " & to_string(I * 16 + J) & ", Output: " & to_string(rc_out) & to_string(rs_out) & ", Expected: " & to_string(std_logic_vector( to_signed(I + J, 5))) severity Error;
      end loop;
	end loop;
    
    for I in 0 to 15 loop
	  for J in 0 to 15 loop
        ra_in <= std_logic_vector(to_signed(I, ra_in'length));
        rb_in <= std_logic_vector(to_signed(J, rb_in'length));
        rcin_in <= '1';
        wait for 1 ns;
        assert(
            ((to_string(rc_out) & to_string(rs_out)) = to_string(std_logic_vector( to_signed(I + J + 1, 5))))
        )
      	report "4-bit Adder, " & "test case: " & to_string(I * 16 + J) & ", Output: " & to_string(rc_out) & to_string(rs_out) & ", Expected: " & to_string(std_logic_vector( to_signed(I + J + 1, 5))) severity Error;
      end loop;
	end loop;
    
    wait;
    
    
  end process;
  
  process
  begin
  
    for I in 0 to 15 loop
	  for J in 0 to 15 loop
        sa_in <= std_logic_vector(to_signed(I, sa_in'length));
        sb_in <= std_logic_vector(to_signed(J, sb_in'length));
        scin_in <= '0';
        wait for 1 ns;
        assert(
            ((to_string(sc_out) & to_string(ss_out)) = to_string(std_logic_vector( to_signed(I + J, 5))))
        )
      	report "Subtractor M = 0, " & "test case: " & to_string(I * 16 + J) & ", Output: " & to_string(sc_out) & to_string(ss_out) & ", Expected: " & to_string(std_logic_vector( to_signed(I + J, 5))) severity Error;
      end loop;
	end loop;
    
    for I in 0 to 15 loop
	  for J in 0 to 15 loop
        sa_in <= std_logic_vector(to_signed(I, sa_in'length));
        sb_in <= std_logic_vector(to_signed(J, sb_in'length));
        scin_in <= '1';
        wait for 1 ns;
        assert(
            ((to_string(not sc_out) & to_string(ss_out)) = to_string(std_logic_vector( to_signed(I - J, 5))))
        )
      	report "Subtractor M = 1, " & "test case: " & to_string(I * 16 + J) & ", Output: " & to_string(not sc_out) & to_string(ss_out) & ", Expected: " & to_string(std_logic_vector( to_signed(I - J, 5))) severity Error;
      end loop;
	end loop;
    
    wait;
    
  end process;
end tb;