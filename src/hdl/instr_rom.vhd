
-------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2011/2012,2020
--
-- Instruction ROM
--
-- author:
-- Ivan Kastelan (ivan.kastelan@rt-rk.com)
-- Milos Subotic (milos.subotic@uns.ac.rs)
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity instr_rom is
	port(
		iA : in  std_logic_vector(15 downto 0);
		oQ : out std_logic_vector(14 downto 0)
	);
end entity instr_rom;

-- ubaciti sadrzaj *.txt datoteke generisane pomocu lprsasm ------
architecture Behavioral of instr_rom is
begin
    oQ <= "000010000000000"  when iA = 0 else
          "000110000000000"  when iA = 1 else
          "100000110000000"  when iA = 2 else
          "000110000000000"  when iA = 3 else
          "100000111000000"  when iA = 4 else
          "000110000000000"  when iA = 5 else
          "100000100000000"  when iA = 6 else
          "000110000000000"  when iA = 7 else
          "100000101000000"  when iA = 8 else
          "100000000000111"  when iA = 9 else
          "010101000001001"  when iA = 10 else
          "100000000000111"  when iA = 11 else
          "010001000001011"  when iA = 12 else
          "000010000000000"  when iA = 13 else
          "000010001001001"  when iA = 14 else
          "000001001001110"  when iA = 15 else
          "110000000000001"  when iA = 16 else
          "100000000000000"  when iA = 17 else
          "100000011000000"  when iA = 18 else
          "000110001001000"  when iA = 19 else
          "110000000011001"  when iA = 20 else
          "000110000000000"  when iA = 21 else
          "100000011000000"  when iA = 22 else
          "000110001001000"  when iA = 23 else
          "110000000011001"  when iA = 24 else
          "000110000000000"  when iA = 25 else
          "100000011000000"  when iA = 26 else
          "000110001001000"  when iA = 27 else
          "110000000011001"  when iA = 28 else
          "000110000000000"  when iA = 29 else
          "100000011000000"  when iA = 30 else
          "000110001001000"  when iA = 31 else
          "110000000011001"  when iA = 32 else
          "000110000000000"  when iA = 33 else
          "100000011000000"  when iA = 34 else
          "000110001001000"  when iA = 35 else
          "110000000011001"  when iA = 36 else
          "000010000000000"  when iA = 37 else
          "000110001001000"  when iA = 38 else
          "110000000000001"  when iA = 39 else
          "010000000001001"  when iA = 40 else
          "000000000000000";
end Behavioral;
------------------------------------------------------------------
