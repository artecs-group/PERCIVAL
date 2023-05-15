--------------------------------------------------------------------------------
--                      Normalizer_ZO_62_62_62_F50_uid6
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

entity Normalizer_ZO_62_62_62_F50_uid6 is
    port (clk : in std_logic;
          X : in  std_logic_vector(61 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(5 downto 0);
          R : out  std_logic_vector(61 downto 0)   );
end entity;

architecture arch of Normalizer_ZO_62_62_62_F50_uid6 is
signal level6 :  std_logic_vector(61 downto 0);
signal sozb :  std_logic;
signal count5 :  std_logic;
signal level5 :  std_logic_vector(61 downto 0);
signal count4 :  std_logic;
signal level4 :  std_logic_vector(61 downto 0);
signal count3 :  std_logic;
signal level3 :  std_logic_vector(61 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(61 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(61 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(61 downto 0);
signal sCount :  std_logic_vector(5 downto 0);
begin
   level6 <= X ;
   sozb<= OZb;
   count5<= '1' when level6(61 downto 30) = (61 downto 30=>sozb) else '0';
   level5<= level6(61 downto 0) when count5='0' else level6(29 downto 0) & (31 downto 0 => '0');

   count4<= '1' when level5(61 downto 46) = (61 downto 46=>sozb) else '0';
   level4<= level5(61 downto 0) when count4='0' else level5(45 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(61 downto 54) = (61 downto 54=>sozb) else '0';
   level3<= level4(61 downto 0) when count3='0' else level4(53 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(61 downto 58) = (61 downto 58=>sozb) else '0';
   level2<= level3(61 downto 0) when count2='0' else level3(57 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(61 downto 60) = (61 downto 60=>sozb) else '0';
   level1<= level2(61 downto 0) when count1='0' else level2(59 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(61 downto 61) = (61 downto 61=>sozb) else '0';
   level0<= level1(61 downto 0) when count0='0' else level1(60 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count5 & count4 & count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                         PositDecoder_64_2_F50_uid4
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X
-- Output signals: Sign SF Frac Zero Inf Abs_in

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositDecoder_64_2_F50_uid4 is
    port (clk : in std_logic;
          X : in  std_logic_vector(63 downto 0);
          Sign : out  std_logic;
          SF : out  std_logic_vector(8 downto 0);
          Frac : out  std_logic_vector(58 downto 0);
          Zero : out  std_logic;
          Inf : out  std_logic;
          Abs_in : out  std_logic_vector(62 downto 0)   );
end entity;

architecture arch of PositDecoder_64_2_F50_uid4 is
   component Normalizer_ZO_62_62_62_F50_uid6 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(61 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(61 downto 0)   );
   end component;

signal s :  std_logic;
signal remainP :  std_logic_vector(62 downto 0);
signal special :  std_logic;
signal is_zero :  std_logic;
signal is_NAR :  std_logic;
signal v_sign :  std_logic_vector(62 downto 0);
signal p_abs :  std_logic_vector(62 downto 0);
signal rc :  std_logic;
signal regPosit :  std_logic_vector(61 downto 0);
signal regLength :  std_logic_vector(5 downto 0);
signal shiftedPosit :  std_logic_vector(61 downto 0);
signal k :  std_logic_vector(6 downto 0);
signal pSF :  std_logic_vector(8 downto 0);
signal pFrac :  std_logic_vector(58 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
--------------------------- Sign bit & special cases ---------------------------
   s <= X(63);
   remainP <= X(62 downto 0);
   special <= '1' when (remainP = "000000000000000000000000000000000000000000000000000000000000000") else '0';
   is_zero <= not(s) AND special;
   is_NAR<= s AND special;
----------------------- Get absolute value of the Posit -----------------------
   v_sign <= (others => s);
   p_abs <= (v_sign XOR remainP) + s;
-------------- Count leading zeros/ones of regime & shift it out --------------
   rc <= p_abs(p_abs'high);
   regPosit <= p_abs(61 downto 0);
   RegimeCounter: Normalizer_ZO_62_62_62_F50_uid6
      port map ( clk  => clk,
                 OZb => rc,
                 X => regPosit,
                 Count => regLength,
                 R => shiftedPosit);
----------------- Determine the scaling factor - regime & exp -----------------
   k <= 
      "0" & regLength when rc = '1' else
      "1" & NOT(regLength);
   pSF <= k & shiftedPosit(60 downto 59);
------------------------------- Extract fraction -------------------------------
   pFrac <= shiftedPosit(58 downto 0);
   -- Prepare outputs
   Sign <= s;
   SF <= pSF;
   Frac <= pFrac;
   Zero <= is_zero;
   Inf <= is_NAR;
   Abs_in <= p_abs;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                      Normalizer_ZO_62_62_62_F50_uid10
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

entity Normalizer_ZO_62_62_62_F50_uid10 is
    port (clk : in std_logic;
          X : in  std_logic_vector(61 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(5 downto 0);
          R : out  std_logic_vector(61 downto 0)   );
end entity;

architecture arch of Normalizer_ZO_62_62_62_F50_uid10 is
signal level6 :  std_logic_vector(61 downto 0);
signal sozb :  std_logic;
signal count5 :  std_logic;
signal level5 :  std_logic_vector(61 downto 0);
signal count4 :  std_logic;
signal level4 :  std_logic_vector(61 downto 0);
signal count3 :  std_logic;
signal level3 :  std_logic_vector(61 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(61 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(61 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(61 downto 0);
signal sCount :  std_logic_vector(5 downto 0);
begin
   level6 <= X ;
   sozb<= OZb;
   count5<= '1' when level6(61 downto 30) = (61 downto 30=>sozb) else '0';
   level5<= level6(61 downto 0) when count5='0' else level6(29 downto 0) & (31 downto 0 => '0');

   count4<= '1' when level5(61 downto 46) = (61 downto 46=>sozb) else '0';
   level4<= level5(61 downto 0) when count4='0' else level5(45 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(61 downto 54) = (61 downto 54=>sozb) else '0';
   level3<= level4(61 downto 0) when count3='0' else level4(53 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(61 downto 58) = (61 downto 58=>sozb) else '0';
   level2<= level3(61 downto 0) when count2='0' else level3(57 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(61 downto 60) = (61 downto 60=>sozb) else '0';
   level1<= level2(61 downto 0) when count1='0' else level2(59 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(61 downto 61) = (61 downto 61=>sozb) else '0';
   level0<= level1(61 downto 0) when count0='0' else level1(60 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count5 & count4 & count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                         PositDecoder_64_2_F50_uid8
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X
-- Output signals: Sign SF Frac Zero Inf Abs_in

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositDecoder_64_2_F50_uid8 is
    port (clk : in std_logic;
          X : in  std_logic_vector(63 downto 0);
          Sign : out  std_logic;
          SF : out  std_logic_vector(8 downto 0);
          Frac : out  std_logic_vector(58 downto 0);
          Zero : out  std_logic;
          Inf : out  std_logic;
          Abs_in : out  std_logic_vector(62 downto 0)   );
end entity;

architecture arch of PositDecoder_64_2_F50_uid8 is
   component Normalizer_ZO_62_62_62_F50_uid10 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(61 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(61 downto 0)   );
   end component;

signal s :  std_logic;
signal remainP :  std_logic_vector(62 downto 0);
signal special :  std_logic;
signal is_zero :  std_logic;
signal is_NAR :  std_logic;
signal v_sign :  std_logic_vector(62 downto 0);
signal p_abs :  std_logic_vector(62 downto 0);
signal rc :  std_logic;
signal regPosit :  std_logic_vector(61 downto 0);
signal regLength :  std_logic_vector(5 downto 0);
signal shiftedPosit :  std_logic_vector(61 downto 0);
signal k :  std_logic_vector(6 downto 0);
signal pSF :  std_logic_vector(8 downto 0);
signal pFrac :  std_logic_vector(58 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
--------------------------- Sign bit & special cases ---------------------------
   s <= X(63);
   remainP <= X(62 downto 0);
   special <= '1' when (remainP = "000000000000000000000000000000000000000000000000000000000000000") else '0';
   is_zero <= not(s) AND special;
   is_NAR<= s AND special;
----------------------- Get absolute value of the Posit -----------------------
   v_sign <= (others => s);
   p_abs <= (v_sign XOR remainP) + s;
-------------- Count leading zeros/ones of regime & shift it out --------------
   rc <= p_abs(p_abs'high);
   regPosit <= p_abs(61 downto 0);
   RegimeCounter: Normalizer_ZO_62_62_62_F50_uid10
      port map ( clk  => clk,
                 OZb => rc,
                 X => regPosit,
                 Count => regLength,
                 R => shiftedPosit);
----------------- Determine the scaling factor - regime & exp -----------------
   k <= 
      "0" & regLength when rc = '1' else
      "1" & NOT(regLength);
   pSF <= k & shiftedPosit(60 downto 59);
------------------------------- Extract fraction -------------------------------
   pFrac <= shiftedPosit(58 downto 0);
   -- Prepare outputs
   Sign <= s;
   SF <= pSF;
   Frac <= pFrac;
   Zero <= is_zero;
   Inf <= is_NAR;
   Abs_in <= p_abs;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                  RightShifterSticky64_by_max_62_F50_uid14
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

entity RightShifterSticky64_by_max_62_F50_uid14 is
    port (clk : in std_logic;
          X : in  std_logic_vector(63 downto 0);
          S : in  std_logic_vector(5 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(63 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky64_by_max_62_F50_uid14 is
signal ps :  std_logic_vector(5 downto 0);
signal Xpadded :  std_logic_vector(63 downto 0);
signal level6 :  std_logic_vector(63 downto 0);
signal stk5 :  std_logic;
signal level5 :  std_logic_vector(63 downto 0);
signal stk4 :  std_logic;
signal level4 :  std_logic_vector(63 downto 0);
signal stk3 :  std_logic;
signal level3 :  std_logic_vector(63 downto 0);
signal stk2 :  std_logic;
signal level2 :  std_logic_vector(63 downto 0);
signal stk1 :  std_logic;
signal level1 :  std_logic_vector(63 downto 0);
signal stk0 :  std_logic;
signal level0 :  std_logic_vector(63 downto 0);
begin
   ps<= S;
   Xpadded <= X;
   level6<= Xpadded;
   stk5 <= '1' when (level6(31 downto 0)/="00000000000000000000000000000000" and ps(5)='1')   else '0';
   level5 <=  level6 when  ps(5)='0'    else (31 downto 0 => padBit) & level6(63 downto 32);
   stk4 <= '1' when (level5(15 downto 0)/="0000000000000000" and ps(4)='1') or stk5 ='1'   else '0';
   level4 <=  level5 when  ps(4)='0'    else (15 downto 0 => padBit) & level5(63 downto 16);
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps(3)='1') or stk4 ='1'   else '0';
   level3 <=  level4 when  ps(3)='0'    else (7 downto 0 => padBit) & level4(63 downto 8);
   stk2 <= '1' when (level3(3 downto 0)/="0000" and ps(2)='1') or stk3 ='1'   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => padBit) & level3(63 downto 4);
   stk1 <= '1' when (level2(1 downto 0)/="00" and ps(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => padBit) & level2(63 downto 2);
   stk0 <= '1' when (level1(0 downto 0)/="0" and ps(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => padBit) & level1(63 downto 1);
   R <= level0;
   Sticky <= stk0;
end architecture;

--------------------------------------------------------------------------------
--                        PositEncoder_64_2_F50_uid12
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: Sign SF Frac Round Sticky Zero Inf
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositEncoder_64_2_F50_uid12 is
    port (clk : in std_logic;
          Sign : in  std_logic;
          SF : in  std_logic_vector(9 downto 0);
          Frac : in  std_logic_vector(58 downto 0);
          Round : in  std_logic;
          Sticky : in  std_logic;
          Zero : in  std_logic;
          Inf : in  std_logic;
          R : out  std_logic_vector(63 downto 0)   );
end entity;

architecture arch of PositEncoder_64_2_F50_uid12 is
   component RightShifterSticky64_by_max_62_F50_uid14 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(63 downto 0);
             S : in  std_logic_vector(5 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(63 downto 0);
             Sticky : out  std_logic   );
   end component;

signal e :  std_logic_vector(1 downto 0);
signal k :  std_logic_vector(6 downto 0);
signal rc :  std_logic;
signal v_rc :  std_logic_vector(6 downto 0);
signal offset_tmp :  std_logic_vector(6 downto 0);
signal reg_ovf, reg_ovf_d1 :  std_logic;
signal pad :  std_logic;
signal input_shifter :  std_logic_vector(63 downto 0);
signal shift_offset :  std_logic_vector(5 downto 0);
signal shifted_posit, shifted_posit_d1 :  std_logic_vector(63 downto 0);
signal stkBit, stkBit_d1 :  std_logic;
signal lsb, lsb_d1 :  std_logic;
signal rnd, rnd_d1 :  std_logic;
signal stk :  std_logic;
signal round_r :  std_logic;
signal rounded_p :  std_logic_vector(62 downto 0);
signal vSign, vSign_d1 :  std_logic_vector(62 downto 0);
signal final_p :  std_logic_vector(62 downto 0);
signal result :  std_logic_vector(63 downto 0);
signal Sign_d1 :  std_logic;
signal Sticky_d1 :  std_logic;
signal Zero_d1 :  std_logic;
signal Inf_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            reg_ovf_d1 <=  reg_ovf;
            shifted_posit_d1 <=  shifted_posit;
            stkBit_d1 <=  stkBit;
            lsb_d1 <=  lsb;
            rnd_d1 <=  rnd;
            vSign_d1 <=  vSign;
            Sign_d1 <=  Sign;
            Sticky_d1 <=  Sticky;
            Zero_d1 <=  Zero;
            Inf_d1 <=  Inf;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
----------------------------- Get value of regime -----------------------------
   e <= SF(1 downto 0);
   k <= SF(8 downto 2);
   rc <= SF(9);
   v_rc <= (others => rc) ;
   offset_tmp <= k XOR v_rc;
   -- Check for regime overflow
   reg_ovf <= '1' when (offset_tmp >= 62) else '0';
-------------- Generate regime - shift out exponent and fraction --------------
   pad <= not rc;
   input_shifter <= pad & rc & e & Frac & Round;
   shift_offset <= "111110" when reg_ovf = '1' else offset_tmp(5 downto 0);
   RegimeGenerator: RightShifterSticky64_by_max_62_F50_uid14
      port map ( clk  => clk,
                 S => shift_offset,
                 X => input_shifter,
                 padBit => pad,
                 R => shifted_posit,
                 Sticky => stkBit);
---------------------------- Round to nearest even ----------------------------
   lsb <= shifted_posit(1);
   rnd <= shifted_posit(0);
   stk <= stkBit_d1 OR Sticky_d1;
   round_r <= rnd_d1 AND (lsb_d1 OR stk OR reg_ovf_d1);
   rounded_p <= shifted_posit_d1(63 downto 1) + round_r;
-------------------------- Check sign & Special cases --------------------------
   -- Two's complement if posit is negative
   vSign <= (others => Sign);
   final_p <= (vSign_d1 XOR rounded_p) + Sign_d1;
   result <= (63 => Inf_d1, others => '0')  when (Zero_d1 OR Inf_d1) = '1' else (Sign_d1 & final_p);
   R <= result;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                                  ApproxPositDiv64
--                          (ApproxPositDiv_64_2_F50_uid2)
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity ApproxPositDiv64 is
    port (clk : in std_logic;
          X : in  std_logic_vector(63 downto 0);
          Y : in  std_logic_vector(63 downto 0);
          R : out  std_logic_vector(63 downto 0)   );
end entity;

architecture arch of ApproxPositDiv64 is
   component PositDecoder_64_2_F50_uid4 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(63 downto 0);
             Sign : out  std_logic;
             SF : out  std_logic_vector(8 downto 0);
             Frac : out  std_logic_vector(58 downto 0);
             Zero : out  std_logic;
             Inf : out  std_logic;
             Abs_in : out  std_logic_vector(62 downto 0)   );
   end component;

   component PositDecoder_64_2_F50_uid8 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(63 downto 0);
             Sign : out  std_logic;
             SF : out  std_logic_vector(8 downto 0);
             Frac : out  std_logic_vector(58 downto 0);
             Zero : out  std_logic;
             Inf : out  std_logic;
             Abs_in : out  std_logic_vector(62 downto 0)   );
   end component;

   component PositEncoder_64_2_F50_uid12 is
      port ( clk : in std_logic;
             Sign : in  std_logic;
             SF : in  std_logic_vector(9 downto 0);
             Frac : in  std_logic_vector(58 downto 0);
             Round : in  std_logic;
             Sticky : in  std_logic;
             Zero : in  std_logic;
             Inf : in  std_logic;
             R : out  std_logic_vector(63 downto 0)   );
   end component;

signal sign_X :  std_logic;
signal sf_X :  std_logic_vector(8 downto 0);
signal f_X :  std_logic_vector(58 downto 0);
signal z_X :  std_logic;
signal inf_X :  std_logic;
signal sign_Y :  std_logic;
signal sf_Y :  std_logic_vector(8 downto 0);
signal f_Y :  std_logic_vector(58 downto 0);
signal z_Y :  std_logic;
signal inf_Y :  std_logic;
signal op_X :  std_logic_vector(67 downto 0);
signal op_Y :  std_logic_vector(67 downto 0);
signal sign :  std_logic;
signal zero :  std_logic;
signal inf :  std_logic;
signal add_r :  std_logic_vector(68 downto 0);
signal sf :  std_logic_vector(9 downto 0);
signal frac :  std_logic_vector(58 downto 0);
signal rnd :  std_logic;
signal stk :  std_logic;
begin
--------------------------- Start of vhdl generation ---------------------------
---------------------------- Decode X & Y operands ----------------------------
   X_decoder: PositDecoder_64_2_F50_uid4
      port map ( clk  => clk,
                 X => X,
                 Abs_in => open,
                 Frac => f_X,
                 Inf => inf_X,
                 SF => sf_X,
                 Sign => sign_X,
                 Zero => z_X);
   Y_decoder: PositDecoder_64_2_F50_uid8
      port map ( clk  => clk,
                 X => Y,
                 Abs_in => open,
                 Frac => f_Y,
                 Inf => inf_Y,
                 SF => sf_Y,
                 Sign => sign_Y,
                 Zero => z_Y);
   -- Gather operands
   op_X <= sf_X & f_X;
   op_Y <= sf_Y & f_Y;
---------------------- Sign and Special cases computation ----------------------
   sign <= sign_X XOR sign_Y;
   zero <= z_X OR z_Y;
   inf <= inf_X OR inf_Y OR z_Y;
-------------------- Add exponents & fractions all together --------------------
   add_r <= (op_X(op_X'high) & op_X) - (op_Y(op_Y'high) & op_Y);
   sf <= add_r(68 downto 59);
   frac <= add_r(58 downto 0);
-------------------------------- Data Encoding --------------------------------
   rnd <= '0';
   stk <= '0';
   R_encoding: PositEncoder_64_2_F50_uid12
      port map ( clk  => clk,
                 Frac => frac,
                 Inf => inf,
                 Round => rnd,
                 SF => sf,
                 Sign => sign,
                 Sticky => stk,
                 Zero => zero,
                 R => R);
---------------------------- End of vhdl generation ----------------------------
end architecture;

