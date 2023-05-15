--------------------------------------------------------------------------------
--                     Normalizer_ZO_497_497_497_F50_uid4
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

entity Normalizer_ZO_497_497_497_F50_uid4 is
    port (clk : in std_logic;
          X : in  std_logic_vector(496 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(8 downto 0);
          R : out  std_logic_vector(496 downto 0)   );
end entity;

architecture arch of Normalizer_ZO_497_497_497_F50_uid4 is
signal level9 :  std_logic_vector(496 downto 0);
signal sozb :  std_logic;
signal count8 :  std_logic;
signal level8 :  std_logic_vector(496 downto 0);
signal count7 :  std_logic;
signal level7 :  std_logic_vector(496 downto 0);
signal count6 :  std_logic;
signal level6 :  std_logic_vector(496 downto 0);
signal count5 :  std_logic;
signal level5 :  std_logic_vector(496 downto 0);
signal count4 :  std_logic;
signal level4 :  std_logic_vector(496 downto 0);
signal count3 :  std_logic;
signal level3 :  std_logic_vector(496 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(496 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(496 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(496 downto 0);
signal sCount :  std_logic_vector(8 downto 0);
begin
   level9 <= X ;
   sozb<= OZb;
   count8<= '1' when level9(496 downto 241) = (496 downto 241=>sozb) else '0';
   level8<= level9(496 downto 0) when count8='0' else level9(240 downto 0) & (255 downto 0 => '0');

   count7<= '1' when level8(496 downto 369) = (496 downto 369=>sozb) else '0';
   level7<= level8(496 downto 0) when count7='0' else level8(368 downto 0) & (127 downto 0 => '0');

   count6<= '1' when level7(496 downto 433) = (496 downto 433=>sozb) else '0';
   level6<= level7(496 downto 0) when count6='0' else level7(432 downto 0) & (63 downto 0 => '0');

   count5<= '1' when level6(496 downto 465) = (496 downto 465=>sozb) else '0';
   level5<= level6(496 downto 0) when count5='0' else level6(464 downto 0) & (31 downto 0 => '0');

   count4<= '1' when level5(496 downto 481) = (496 downto 481=>sozb) else '0';
   level4<= level5(496 downto 0) when count4='0' else level5(480 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(496 downto 489) = (496 downto 489=>sozb) else '0';
   level3<= level4(496 downto 0) when count3='0' else level4(488 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(496 downto 493) = (496 downto 493=>sozb) else '0';
   level2<= level3(496 downto 0) when count2='0' else level3(492 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(496 downto 495) = (496 downto 495=>sozb) else '0';
   level1<= level2(496 downto 0) when count1='0' else level2(494 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(496 downto 496) = (496 downto 496=>sozb) else '0';
   level0<= level1(496 downto 0) when count0='0' else level1(495 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count8 & count7 & count6 & count5 & count4 & count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                  RightShifterSticky63_by_max_63_F50_uid8
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
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

entity RightShifterSticky63_by_max_63_F50_uid8 is
    port (clk : in std_logic;
          X : in  std_logic_vector(62 downto 0);
          S : in  std_logic_vector(5 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(62 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky63_by_max_63_F50_uid8 is
signal ps, ps_d1 :  std_logic_vector(5 downto 0);
signal Xpadded :  std_logic_vector(62 downto 0);
signal level6 :  std_logic_vector(62 downto 0);
signal stk5 :  std_logic;
signal level5 :  std_logic_vector(62 downto 0);
signal stk4 :  std_logic;
signal level4 :  std_logic_vector(62 downto 0);
signal stk3, stk3_d1 :  std_logic;
signal level3, level3_d1 :  std_logic_vector(62 downto 0);
signal stk2 :  std_logic;
signal level2, level2_d1 :  std_logic_vector(62 downto 0);
signal stk1 :  std_logic;
signal level1, level1_d1 :  std_logic_vector(62 downto 0);
signal stk0 :  std_logic;
signal level0 :  std_logic_vector(62 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            ps_d1 <=  ps;
            stk3_d1 <=  stk3;
            level3_d1 <=  level3;
            level2_d1 <=  level2;
            level1_d1 <=  level1;
         end if;
      end process;
   ps<= S;
   Xpadded <= X;
   level6<= Xpadded;
   stk5 <= '1' when (level6(31 downto 0)/="00000000000000000000000000000000" and ps(5)='1')   else '0';
   level5 <=  level6 when  ps(5)='0'    else (31 downto 0 => padBit) & level6(62 downto 32);
   stk4 <= '1' when (level5(15 downto 0)/="0000000000000000" and ps(4)='1') or stk5 ='1'   else '0';
   level4 <=  level5 when  ps(4)='0'    else (15 downto 0 => padBit) & level5(62 downto 16);
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps(3)='1') or stk4 ='1'   else '0';
   level3 <=  level4 when  ps(3)='0'    else (7 downto 0 => padBit) & level4(62 downto 8);
   stk2 <= '1' when (level3_d1(3 downto 0)/="0000" and ps_d1(2)='1') or stk3_d1 ='1'   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => padBit) & level3(62 downto 4);
   stk1 <= '1' when (level2_d1(1 downto 0)/="00" and ps_d1(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => padBit) & level2(62 downto 2);
   stk0 <= '1' when (level1_d1(0 downto 0)/="0" and ps_d1(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => padBit) & level1(62 downto 1);
   R <= level0;
   Sticky <= stk0;
end architecture;

--------------------------------------------------------------------------------
--                       PositFastEncoder_64_2_F50_uid6
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

entity PositFastEncoder_64_2_F50_uid6 is
    port (clk : in std_logic;
          Sign : in  std_logic;
          SF : in  std_logic_vector(9 downto 0);
          Frac : in  std_logic_vector(58 downto 0);
          Guard : in  std_logic;
          Sticky : in  std_logic;
          NZN : in  std_logic;
          R : out  std_logic_vector(63 downto 0)   );
end entity;

architecture arch of PositFastEncoder_64_2_F50_uid6 is
   component RightShifterSticky63_by_max_63_F50_uid8 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(62 downto 0);
             S : in  std_logic_vector(5 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(62 downto 0);
             Sticky : out  std_logic   );
   end component;

signal rc :  std_logic;
signal rcVect :  std_logic_vector(6 downto 0);
signal k :  std_logic_vector(6 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal exp :  std_logic_vector(1 downto 0);
signal ovf, ovf_d1 :  std_logic;
signal regValue :  std_logic_vector(5 downto 0);
signal regNeg :  std_logic;
signal padBit :  std_logic;
signal inputShifter :  std_logic_vector(62 downto 0);
signal shiftedPosit :  std_logic_vector(62 downto 0);
signal stkBit :  std_logic;
signal unroundedPosit, unroundedPosit_d1 :  std_logic_vector(62 downto 0);
signal lsb, lsb_d1 :  std_logic;
signal rnd, rnd_d1 :  std_logic;
signal stk :  std_logic;
signal round :  std_logic;
signal roundedPosit :  std_logic_vector(62 downto 0);
signal unsignedPosit :  std_logic_vector(62 downto 0);
signal Sign_d1 :  std_logic;
signal Sticky_d1 :  std_logic;
signal NZN_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            ovf_d1 <=  ovf;
            unroundedPosit_d1 <=  unroundedPosit;
            lsb_d1 <=  lsb;
            rnd_d1 <=  rnd;
            Sign_d1 <=  Sign;
            Sticky_d1 <=  Sticky;
            NZN_d1 <=  NZN;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
----------------------------- Get value of regime -----------------------------
   rc <= SF(SF'high);
   rcVect <= (others => rc);
   k <= SF(8 downto 2) XOR rcVect;
   sgnVect <= (others => Sign);
   exp <= SF(1 downto 0) XOR sgnVect;
   -- Check for regime overflow
   ovf <= '1' when (k > "0111101") else '0';
   regValue <= k(5 downto 0) when ovf = '0' else "111110";
-------------- Generate regime - shift out exponent and fraction --------------
   regNeg <= Sign XOR rc;
   padBit <= NOT(regNeg);
   inputShifter <= regNeg & exp & Frac & Guard;
   RegimeGenerator: RightShifterSticky63_by_max_63_F50_uid8
      port map ( clk  => clk,
                 S => regValue,
                 X => inputShifter,
                 padBit => padBit,
                 R => shiftedPosit,
                 Sticky => stkBit);
   unroundedPosit <= padBit & shiftedPosit(62 downto 1);
---------------------------- Round to nearest even ----------------------------
   lsb <= shiftedPosit(1);
   rnd <= shiftedPosit(0);
   stk <= stkBit OR Sticky_d1;
   round <= rnd_d1 AND (lsb_d1 OR stk OR ovf_d1);
   roundedPosit <= unroundedPosit_d1 + round;
-------------------------- Check sign & Special Cases --------------------------
   unsignedPosit <= roundedPosit when NZN_d1 = '1' else (others => '0');
   R <= Sign_d1 & unsignedPosit;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                                Quire2Posit64
--                   (Quire2Posit_64_2_Quire_1024_F50_uid2)
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

entity Quire2Posit64 is
    port (clk : in std_logic;
          X : in  std_logic_vector(1023 downto 0);
          R : out  std_logic_vector(63 downto 0)   );
end entity;

architecture arch of Quire2Posit64 is
   component Normalizer_ZO_497_497_497_F50_uid4 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(496 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(8 downto 0);
             R : out  std_logic_vector(496 downto 0)   );
   end component;

   component PositFastEncoder_64_2_F50_uid6 is
      port ( clk : in std_logic;
             Sign : in  std_logic;
             SF : in  std_logic_vector(9 downto 0);
             Frac : in  std_logic_vector(58 downto 0);
             Guard : in  std_logic;
             Sticky : in  std_logic;
             NZN : in  std_logic;
             R : out  std_logic_vector(63 downto 0)   );
   end component;

signal sgn :  std_logic;
signal carryBits :  std_logic_vector(277 downto 0);
signal carryAllZeros :  std_logic;
signal carryAllOnes :  std_logic;
signal ovf :  std_logic;
signal stkTmp :  std_logic;
signal positRange :  std_logic_vector(496 downto 0);
signal intExp :  std_logic_vector(8 downto 0);
signal tmpFrac :  std_logic_vector(496 downto 0);
signal intExpZero :  std_logic;
signal intExpMax :  std_logic;
signal positZero :  std_logic;
signal frac :  std_logic_vector(58 downto 0);
signal rnd :  std_logic;
signal stkBit :  std_logic;
signal stk :  std_logic;
signal maxExp :  std_logic_vector(9 downto 0);
signal sfTmp :  std_logic_vector(9 downto 0);
signal sf :  std_logic_vector(9 downto 0);
signal nzn :  std_logic;
begin
--------------------------- Start of vhdl generation ---------------------------
   sgn <= X(1023);
------------------------- Check for overflow/underflow -------------------------
   carryBits <= X(1022 downto 745);
   carryAllZeros <= '1' when (carryBits = 0) else '0';
   carryAllOnes <= '1' when (NOT(carryBits) = 0) else '0';
   with sgn  select  ovf <= 
      carryAllOnes when '0',
      carryAllZeros when '1',
      '-' when others;
   -- Sticky bits that will be discarded - underflow prevention
   stkTmp <= '0' when (X(247 downto 0) = 0) else '1';
----------------- Count leading zeros/ones & extract fraction -----------------
   positRange <= X(744 downto 248);
   LZOCAndShifter: Normalizer_ZO_497_497_497_F50_uid4
      port map ( clk  => clk,
                 OZb => sgn,
                 X => positRange,
                 Count => intExp,
                 R => tmpFrac);
   intExpZero <= '1' when (intExp = "000000000") else '0';
   intExpMax <= '1' when (intExp = "111111111") else '0';
   with sgn  select  positZero <= 
      intExpMax when '0',
      intExpZero when '1',
      '-' when others;
   frac <= tmpFrac(495 downto 437);
   rnd <= tmpFrac(436);
   stkBit <= '0' when (tmpFrac(435 downto 0) = 0) else '1';
   stk <= stkBit OR stkTmp;
----------------- Determine the scaling factor - regime & exp -----------------
   maxExp <= "0011111000";
   sfTmp <= maxExp - ("0" & intExp);
   sf <= sfTmp when ovf='0' else maxExp;
----------------------------- Generate final posit -----------------------------
   nzn <= NOT(carryAllZeros) OR NOT(positZero) OR stkTmp;
   PositEncoder: PositFastEncoder_64_2_F50_uid6
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

