--------------------------------------------------------------------------------
--                     Normalizer_ZO_241_241_241_F50_uid4
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

entity Normalizer_ZO_241_241_241_F50_uid4 is
    port (clk : in std_logic;
          X : in  std_logic_vector(240 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(7 downto 0);
          R : out  std_logic_vector(240 downto 0)   );
end entity;

architecture arch of Normalizer_ZO_241_241_241_F50_uid4 is
signal level8 :  std_logic_vector(240 downto 0);
signal sozb :  std_logic;
signal count7 :  std_logic;
signal level7 :  std_logic_vector(240 downto 0);
signal count6 :  std_logic;
signal level6 :  std_logic_vector(240 downto 0);
signal count5 :  std_logic;
signal level5 :  std_logic_vector(240 downto 0);
signal count4 :  std_logic;
signal level4 :  std_logic_vector(240 downto 0);
signal count3 :  std_logic;
signal level3 :  std_logic_vector(240 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(240 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(240 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(240 downto 0);
signal sCount :  std_logic_vector(7 downto 0);
begin
   level8 <= X ;
   sozb<= OZb;
   count7<= '1' when level8(240 downto 113) = (240 downto 113=>sozb) else '0';
   level7<= level8(240 downto 0) when count7='0' else level8(112 downto 0) & (127 downto 0 => '0');

   count6<= '1' when level7(240 downto 177) = (240 downto 177=>sozb) else '0';
   level6<= level7(240 downto 0) when count6='0' else level7(176 downto 0) & (63 downto 0 => '0');

   count5<= '1' when level6(240 downto 209) = (240 downto 209=>sozb) else '0';
   level5<= level6(240 downto 0) when count5='0' else level6(208 downto 0) & (31 downto 0 => '0');

   count4<= '1' when level5(240 downto 225) = (240 downto 225=>sozb) else '0';
   level4<= level5(240 downto 0) when count4='0' else level5(224 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(240 downto 233) = (240 downto 233=>sozb) else '0';
   level3<= level4(240 downto 0) when count3='0' else level4(232 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(240 downto 237) = (240 downto 237=>sozb) else '0';
   level2<= level3(240 downto 0) when count2='0' else level3(236 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(240 downto 239) = (240 downto 239=>sozb) else '0';
   level1<= level2(240 downto 0) when count1='0' else level2(238 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(240 downto 240) = (240 downto 240=>sozb) else '0';
   level0<= level1(240 downto 0) when count0='0' else level1(239 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count7 & count6 & count5 & count4 & count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                  RightShifterSticky31_by_max_31_F50_uid8
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

entity RightShifterSticky31_by_max_31_F50_uid8 is
    port (clk : in std_logic;
          X : in  std_logic_vector(30 downto 0);
          S : in  std_logic_vector(4 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(30 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky31_by_max_31_F50_uid8 is
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
--                       PositFastEncoder_32_2_F50_uid6
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: Sign SF Frac Guard Sticky NZN
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositFastEncoder_32_2_F50_uid6 is
    port (clk : in std_logic;
          Sign : in  std_logic;
          SF : in  std_logic_vector(8 downto 0);
          Frac : in  std_logic_vector(26 downto 0);
          Guard : in  std_logic;
          Sticky : in  std_logic;
          NZN : in  std_logic;
          R : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of PositFastEncoder_32_2_F50_uid6 is
   component RightShifterSticky31_by_max_31_F50_uid8 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(30 downto 0);
             S : in  std_logic_vector(4 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(30 downto 0);
             Sticky : out  std_logic   );
   end component;

signal rc :  std_logic;
signal rcVect :  std_logic_vector(5 downto 0);
signal k :  std_logic_vector(5 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal exp :  std_logic_vector(1 downto 0);
signal ovf :  std_logic;
signal regValue :  std_logic_vector(4 downto 0);
signal regNeg :  std_logic;
signal padBit :  std_logic;
signal inputShifter :  std_logic_vector(30 downto 0);
signal shiftedPosit :  std_logic_vector(30 downto 0);
signal stkBit :  std_logic;
signal unroundedPosit, unroundedPosit_d1 :  std_logic_vector(30 downto 0);
signal lsb :  std_logic;
signal rnd :  std_logic;
signal stk :  std_logic;
signal round, round_d1 :  std_logic;
signal roundedPosit :  std_logic_vector(30 downto 0);
signal unsignedPosit :  std_logic_vector(30 downto 0);
signal Sign_d1 :  std_logic;
signal NZN_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            unroundedPosit_d1 <=  unroundedPosit;
            round_d1 <=  round;
            Sign_d1 <=  Sign;
            NZN_d1 <=  NZN;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
----------------------------- Get value of regime -----------------------------
   rc <= SF(SF'high);
   rcVect <= (others => rc);
   k <= SF(7 downto 2) XOR rcVect;
   sgnVect <= (others => Sign);
   exp <= SF(1 downto 0) XOR sgnVect;
   -- Check for regime overflow
   ovf <= '1' when (k > "011101") else '0';
   regValue <= k(4 downto 0) when ovf = '0' else "11110";
-------------- Generate regime - shift out exponent and fraction --------------
   regNeg <= Sign XOR rc;
   padBit <= NOT(regNeg);
   inputShifter <= regNeg & exp & Frac & Guard;
   RegimeGenerator: RightShifterSticky31_by_max_31_F50_uid8
      port map ( clk  => clk,
                 S => regValue,
                 X => inputShifter,
                 padBit => padBit,
                 R => shiftedPosit,
                 Sticky => stkBit);
   unroundedPosit <= padBit & shiftedPosit(30 downto 1);
---------------------------- Round to nearest even ----------------------------
   lsb <= shiftedPosit(1);
   rnd <= shiftedPosit(0);
   stk <= stkBit OR Sticky;
   round <= rnd AND (lsb OR stk OR ovf);
   roundedPosit <= unroundedPosit_d1 + round_d1;
-------------------------- Check sign & Special Cases --------------------------
   unsignedPosit <= roundedPosit when NZN_d1 = '1' else (others => '0');
   R <= Sign_d1 & unsignedPosit;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                                Quire2Posit
--                   (Quire2Posit_32_2_Quire_512_F50_uid2)
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
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

entity Quire2Posit is
    port (clk : in std_logic;
          X : in  std_logic_vector(511 downto 0);
          R : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of Quire2Posit is
   component Normalizer_ZO_241_241_241_F50_uid4 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(240 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(7 downto 0);
             R : out  std_logic_vector(240 downto 0)   );
   end component;

   component PositFastEncoder_32_2_F50_uid6 is
      port ( clk : in std_logic;
             Sign : in  std_logic;
             SF : in  std_logic_vector(8 downto 0);
             Frac : in  std_logic_vector(26 downto 0);
             Guard : in  std_logic;
             Sticky : in  std_logic;
             NZN : in  std_logic;
             R : out  std_logic_vector(31 downto 0)   );
   end component;

signal sgn :  std_logic;
signal carryBits :  std_logic_vector(149 downto 0);
signal carryAllZeros :  std_logic;
signal carryAllOnes :  std_logic;
signal ovf :  std_logic;
signal stkTmp :  std_logic;
signal positRange :  std_logic_vector(240 downto 0);
signal intExp :  std_logic_vector(7 downto 0);
signal tmpFrac :  std_logic_vector(240 downto 0);
signal intExpZero :  std_logic;
signal intExpMax :  std_logic;
signal positZero :  std_logic;
signal frac :  std_logic_vector(26 downto 0);
signal rnd :  std_logic;
signal stkBit :  std_logic;
signal stk :  std_logic;
signal maxExp :  std_logic_vector(8 downto 0);
signal sfTmp :  std_logic_vector(8 downto 0);
signal sf :  std_logic_vector(8 downto 0);
signal nzn :  std_logic;
begin
--------------------------- Start of vhdl generation ---------------------------
   sgn <= X(511);
------------------------- Check for overflow/underflow -------------------------
   carryBits <= X(510 downto 361);
   carryAllZeros <= '1' when (carryBits = 0) else '0';
   carryAllOnes <= '1' when (NOT(carryBits) = 0) else '0';
   with sgn  select  ovf <= 
      carryAllOnes when '0',
      carryAllZeros when '1',
      '-' when others;
   -- Sticky bits that will be discarded - underflow prevention
   stkTmp <= '0' when (X(119 downto 0) = 0) else '1';
----------------- Count leading zeros/ones & extract fraction -----------------
   positRange <= X(360 downto 120);
   LZOCAndShifter: Normalizer_ZO_241_241_241_F50_uid4
      port map ( clk  => clk,
                 OZb => sgn,
                 X => positRange,
                 Count => intExp,
                 R => tmpFrac);
   intExpZero <= '1' when (intExp = "00000000") else '0';
   intExpMax <= '1' when (intExp = "11111111") else '0';
   with sgn  select  positZero <= 
      intExpMax when '0',
      intExpZero when '1',
      '-' when others;
   frac <= tmpFrac(239 downto 213);
   rnd <= tmpFrac(212);
   stkBit <= '0' when (tmpFrac(211 downto 0) = 0) else '1';
   stk <= stkBit OR stkTmp;
----------------- Determine the scaling factor - regime & exp -----------------
   maxExp <= "001111000";
   sfTmp <= maxExp - ("0" & intExp);
   sf <= sfTmp when ovf='0' else maxExp;
----------------------------- Generate final posit -----------------------------
   nzn <= NOT(carryAllZeros) OR NOT(positZero) OR stkTmp;
   PositEncoder: PositFastEncoder_32_2_F50_uid6
      port map ( clk  => clk,
                 Frac => frac,
                 Guard => rnd,
                 NZN => nzn,
                 SF => sf,
                 Sign => sgn,
                 Sticky => stk,
                 R => R);
---------------------------- End of vhdl generation ----------------------------
end architecture;

