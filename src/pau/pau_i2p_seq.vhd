--------------------------------------------------------------------------------
--                      Normalizer_ZO_31_31_31_F50_uid4
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, (2007-2020)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X OZb
-- Output signals: Count R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Normalizer_ZO_31_31_31_F50_uid4 is
    port (clk : in std_logic;
          X : in  std_logic_vector(30 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(4 downto 0);
          R : out  std_logic_vector(30 downto 0)   );
end entity;

architecture arch of Normalizer_ZO_31_31_31_F50_uid4 is
signal level5 :  std_logic_vector(30 downto 0);
signal sozb :  std_logic;
signal count4 :  std_logic;
signal level4 :  std_logic_vector(30 downto 0);
signal count3 :  std_logic;
signal level3 :  std_logic_vector(30 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(30 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(30 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(30 downto 0);
signal sCount :  std_logic_vector(4 downto 0);
begin
   level5 <= X ;
   sozb<= OZb;
   count4<= '1' when level5(30 downto 15) = (30 downto 15=>sozb) else '0';
   level4<= level5(30 downto 0) when count4='0' else level5(14 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(30 downto 23) = (30 downto 23=>sozb) else '0';
   level3<= level4(30 downto 0) when count3='0' else level4(22 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(30 downto 27) = (30 downto 27=>sozb) else '0';
   level2<= level3(30 downto 0) when count2='0' else level3(26 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(30 downto 29) = (30 downto 29=>sozb) else '0';
   level1<= level2(30 downto 0) when count1='0' else level2(28 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(30 downto 30) = (30 downto 30=>sozb) else '0';
   level0<= level1(30 downto 0) when count0='0' else level1(29 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count4 & count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                  RightShifterSticky31_by_max_31_F50_uid6
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X S padBit
-- Output signals: R Sticky

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity RightShifterSticky31_by_max_31_F50_uid6 is
    port (clk : in std_logic;
          X : in  std_logic_vector(30 downto 0);
          S : in  std_logic_vector(4 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(30 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky31_by_max_31_F50_uid6 is
signal ps :  std_logic_vector(4 downto 0);
signal Xpadded :  std_logic_vector(30 downto 0);
signal level5 :  std_logic_vector(30 downto 0);
signal stk4 :  std_logic;
signal level4 :  std_logic_vector(30 downto 0);
signal stk3 :  std_logic;
signal level3 :  std_logic_vector(30 downto 0);
signal stk2 :  std_logic;
signal level2 :  std_logic_vector(30 downto 0);
signal stk1 :  std_logic;
signal level1 :  std_logic_vector(30 downto 0);
signal stk0 :  std_logic;
signal level0 :  std_logic_vector(30 downto 0);
begin
   ps<= S;
   Xpadded <= X;
   level5<= Xpadded;
   stk4 <= '1' when (level5(15 downto 0)/="0000000000000000" and ps(4)='1')   else '0';
   level4 <=  level5 when  ps(4)='0'    else (15 downto 0 => padBit) & level5(30 downto 16);
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps(3)='1') or stk4 ='1'   else '0';
   level3 <=  level4 when  ps(3)='0'    else (7 downto 0 => padBit) & level4(30 downto 8);
   stk2 <= '1' when (level3(3 downto 0)/="0000" and ps(2)='1') or stk3 ='1'   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => padBit) & level3(30 downto 4);
   stk1 <= '1' when (level2(1 downto 0)/="00" and ps(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => padBit) & level2(30 downto 2);
   stk0 <= '1' when (level1(0 downto 0)/="0" and ps(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => padBit) & level1(30 downto 1);
   R <= level0;
   Sticky <= stk0;
end architecture;

--------------------------------------------------------------------------------
--                                 Int2Posit
--                     (Int2Posit_32_to_32_2_NT_F50_uid2)
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Int2Posit is
    port (clk : in std_logic;
          X : in  std_logic_vector(31 downto 0);
          R : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of Int2Posit is
   component Normalizer_ZO_31_31_31_F50_uid4 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(30 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(4 downto 0);
             R : out  std_logic_vector(30 downto 0)   );
   end component;

   component RightShifterSticky31_by_max_31_F50_uid6 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(30 downto 0);
             S : in  std_logic_vector(4 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(30 downto 0);
             Sticky : out  std_logic   );
   end component;

signal sgn :  std_logic;
signal unsgnInt :  std_logic_vector(30 downto 0);
signal nzn :  std_logic;
signal intExp :  std_logic_vector(4 downto 0);
signal tmpFrac :  std_logic_vector(30 downto 0);
signal frac :  std_logic_vector(26 downto 0);
signal rndBit :  std_logic;
signal stkBit :  std_logic;
signal sf :  std_logic_vector(7 downto 0);
signal minusOne :  std_logic;
signal reg :  std_logic_vector(4 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal expBits :  std_logic_vector(1 downto 0);
signal padBit :  std_logic;
signal paddedFrac :  std_logic_vector(30 downto 0);
signal shiftedFrac :  std_logic_vector(30 downto 0);
signal sticky :  std_logic;
signal validFrac :  std_logic_vector(30 downto 0);
signal lsb :  std_logic;
signal rnd :  std_logic;
signal round :  std_logic;
signal positNumber :  std_logic_vector(30 downto 0);
signal result :  std_logic_vector(30 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
------------------------------- Extract Sign bit -------------------------------
   sgn <= X(31);
   unsgnInt <= X(30 downto 0);
   nzn <= '0' when (unsgnInt = "0000000000000000000000000000000") else '1';
----------------- Count leading zeros/ones & extract fraction -----------------
   LZOCAndShifter: Normalizer_ZO_31_31_31_F50_uid4
      port map ( clk  => clk,
                 OZb => sgn,
                 X => unsgnInt,
                 Count => intExp,
                 R => tmpFrac);
   frac <= tmpFrac(29 downto 3);
   rndBit <= tmpFrac(2);
   stkBit <= '0' when (tmpFrac(1 downto 0) = "00") else '1';
----------------- Determine the scaling factor - regime & exp -----------------
   sf <= "00011110" - ("000" & intExp);
   minusOne <= sf(sf'high);
   reg <= sf(6 downto 2);
   sgnVect <= (others => sgn);
   expBits <= sf(1 downto 0) XOR sgnVect;
---------------- Shift out fraction according to scaling factor ----------------
   padBit <= NOT sgn;
   paddedFrac <= sgn & expBits & frac & rndBit;
   RightShifterComponent: RightShifterSticky31_by_max_31_F50_uid6
      port map ( clk  => clk,
                 S => reg,
                 X => paddedFrac,
                 padBit => padBit,
                 R => shiftedFrac,
                 Sticky => sticky);
   validFrac <= padBit & shiftedFrac(30 downto 1);
   lsb <= shiftedFrac(1);
   rnd <= shiftedFrac(0);
   round <= rnd AND (lsb OR sticky OR stkBit);
   positNumber <= validFrac + round;
   result <= positNumber when (nzn AND NOT(minusOne)) = '1' else (nzn & "000000000000000000000000000000");
   R <= sgn & result;
---------------------------- End of vhdl generation ----------------------------
end architecture;

