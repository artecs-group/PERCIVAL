--------------------------------------------------------------------------------
--                 LZOCShifter_30_to_30_counting_32_F50_uid6
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2007-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: I OZb
-- Output signals: Count O

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LZOCShifter_30_to_30_counting_32_F50_uid6 is
    port (clk : in std_logic;
          I : in  std_logic_vector(29 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(4 downto 0);
          O : out  std_logic_vector(29 downto 0)   );
end entity;

architecture arch of LZOCShifter_30_to_30_counting_32_F50_uid6 is
signal level5 :  std_logic_vector(29 downto 0);
signal sozb :  std_logic;
signal count4 :  std_logic;
signal level4 :  std_logic_vector(29 downto 0);
signal count3 :  std_logic;
signal level3 :  std_logic_vector(29 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(29 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(29 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(29 downto 0);
signal sCount :  std_logic_vector(4 downto 0);
begin
   level5 <= I ;
   sozb<= OZb;
   count4<= '1' when level5(29 downto 14) = (29 downto 14=>sozb) else '0';
   level4<= level5(29 downto 0) when count4='0' else level5(13 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(29 downto 22) = (29 downto 22=>sozb) else '0';
   level3<= level4(29 downto 0) when count3='0' else level4(21 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(29 downto 26) = (29 downto 26=>sozb) else '0';
   level2<= level3(29 downto 0) when count2='0' else level3(25 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(29 downto 28) = (29 downto 28=>sozb) else '0';
   level1<= level2(29 downto 0) when count1='0' else level2(27 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(29 downto 29) = (29 downto 29=>sozb) else '0';
   level0<= level1(29 downto 0) when count0='0' else level1(28 downto 0) & (0 downto 0 => '0');

   O <= level0;
   sCount <= count4 & count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                        PositDecoder1_32_2_F50_uid4
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo, Alberto A. del Barrio, Guillermo Botella, 2020
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: Input
-- Output signals: Sign SF Frac Zero Inf Abs_in

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositDecoder1_32_2_F50_uid4 is
    port (clk : in std_logic;
          Input : in  std_logic_vector(31 downto 0);
          Sign : out  std_logic;
          SF : out  std_logic_vector(7 downto 0);
          Frac : out  std_logic_vector(26 downto 0);
          Zero : out  std_logic;
          Inf : out  std_logic;
          Abs_in : out  std_logic_vector(30 downto 0)   );
end entity;

architecture arch of PositDecoder1_32_2_F50_uid4 is
   component LZOCShifter_30_to_30_counting_32_F50_uid6 is
      port ( clk : in std_logic;
             I : in  std_logic_vector(29 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(4 downto 0);
             O : out  std_logic_vector(29 downto 0)   );
   end component;

signal s :  std_logic;
signal special :  std_logic;
signal is_zero :  std_logic;
signal is_NAR :  std_logic;
signal v_sign :  std_logic_vector(30 downto 0);
signal p_abs :  std_logic_vector(30 downto 0);
signal rc :  std_logic;
signal shifter_input :  std_logic_vector(29 downto 0);
signal lzCount :  std_logic_vector(4 downto 0);
signal shifted_p :  std_logic_vector(29 downto 0);
signal k :  std_logic_vector(5 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
------------------------------- Extract Sign bit -------------------------------
   s <= Input(31);
   Sign <= s;
-------------------------------- Special Cases --------------------------------
   special <= '1' when Input(30 downto 0) = 0 else '0';
   -- 1 if Input is zero
   is_zero <= not(s) AND special;
   Zero <= is_zero;
   -- 1 if Input is infinity
   is_NAR<= s AND special;
   Inf <= is_NAR;
--------------------------- 2's Complement of Input ---------------------------
   v_sign <= (others => s);
   p_abs <= (v_sign XOR Input(30 downto 0)) + s;
   rc <= p_abs(p_abs'high);
-------------- Count leading zeros/ones of regime & shift it out --------------
   shifter_input <= p_abs(29 downto 0);
   lzoc: LZOCShifter_30_to_30_counting_32_F50_uid6
      port map ( clk  => clk,
                 I => shifter_input,
                 OZb => rc,
                 Count => lzCount,
                 O => shifted_p);
------------------------------- Extract fraction -------------------------------
   Frac <= shifted_p(26 downto 0);
-------------------- Extract scaling factor - regime & exp --------------------
   k <= "0" & lzCount when rc = '1' else
      NOT("0" & lzCount);
   SF <= k & shifted_p(28 downto 27);
   Abs_in <= p_abs;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                 LZOCShifter_30_to_30_counting_32_F50_uid10
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2007-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: I OZb
-- Output signals: Count O

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LZOCShifter_30_to_30_counting_32_F50_uid10 is
    port (clk : in std_logic;
          I : in  std_logic_vector(29 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(4 downto 0);
          O : out  std_logic_vector(29 downto 0)   );
end entity;

architecture arch of LZOCShifter_30_to_30_counting_32_F50_uid10 is
signal level5 :  std_logic_vector(29 downto 0);
signal sozb :  std_logic;
signal count4 :  std_logic;
signal level4 :  std_logic_vector(29 downto 0);
signal count3 :  std_logic;
signal level3 :  std_logic_vector(29 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(29 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(29 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(29 downto 0);
signal sCount :  std_logic_vector(4 downto 0);
begin
   level5 <= I ;
   sozb<= OZb;
   count4<= '1' when level5(29 downto 14) = (29 downto 14=>sozb) else '0';
   level4<= level5(29 downto 0) when count4='0' else level5(13 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(29 downto 22) = (29 downto 22=>sozb) else '0';
   level3<= level4(29 downto 0) when count3='0' else level4(21 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(29 downto 26) = (29 downto 26=>sozb) else '0';
   level2<= level3(29 downto 0) when count2='0' else level3(25 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(29 downto 28) = (29 downto 28=>sozb) else '0';
   level1<= level2(29 downto 0) when count1='0' else level2(27 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(29 downto 29) = (29 downto 29=>sozb) else '0';
   level0<= level1(29 downto 0) when count0='0' else level1(28 downto 0) & (0 downto 0 => '0');

   O <= level0;
   sCount <= count4 & count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                        PositDecoder1_32_2_F50_uid8
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo, Alberto A. del Barrio, Guillermo Botella, 2020
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: Input
-- Output signals: Sign SF Frac Zero Inf Abs_in

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositDecoder1_32_2_F50_uid8 is
    port (clk : in std_logic;
          Input : in  std_logic_vector(31 downto 0);
          Sign : out  std_logic;
          SF : out  std_logic_vector(7 downto 0);
          Frac : out  std_logic_vector(26 downto 0);
          Zero : out  std_logic;
          Inf : out  std_logic;
          Abs_in : out  std_logic_vector(30 downto 0)   );
end entity;

architecture arch of PositDecoder1_32_2_F50_uid8 is
   component LZOCShifter_30_to_30_counting_32_F50_uid10 is
      port ( clk : in std_logic;
             I : in  std_logic_vector(29 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(4 downto 0);
             O : out  std_logic_vector(29 downto 0)   );
   end component;

signal s :  std_logic;
signal special :  std_logic;
signal is_zero :  std_logic;
signal is_NAR :  std_logic;
signal v_sign :  std_logic_vector(30 downto 0);
signal p_abs :  std_logic_vector(30 downto 0);
signal rc :  std_logic;
signal shifter_input :  std_logic_vector(29 downto 0);
signal lzCount :  std_logic_vector(4 downto 0);
signal shifted_p :  std_logic_vector(29 downto 0);
signal k :  std_logic_vector(5 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
------------------------------- Extract Sign bit -------------------------------
   s <= Input(31);
   Sign <= s;
-------------------------------- Special Cases --------------------------------
   special <= '1' when Input(30 downto 0) = 0 else '0';
   -- 1 if Input is zero
   is_zero <= not(s) AND special;
   Zero <= is_zero;
   -- 1 if Input is infinity
   is_NAR<= s AND special;
   Inf <= is_NAR;
--------------------------- 2's Complement of Input ---------------------------
   v_sign <= (others => s);
   p_abs <= (v_sign XOR Input(30 downto 0)) + s;
   rc <= p_abs(p_abs'high);
-------------- Count leading zeros/ones of regime & shift it out --------------
   shifter_input <= p_abs(29 downto 0);
   lzoc: LZOCShifter_30_to_30_counting_32_F50_uid10
      port map ( clk  => clk,
                 I => shifter_input,
                 OZb => rc,
                 Count => lzCount,
                 O => shifted_p);
------------------------------- Extract fraction -------------------------------
   Frac <= shifted_p(26 downto 0);
-------------------- Extract scaling factor - regime & exp --------------------
   k <= "0" & lzCount when rc = '1' else
      NOT("0" & lzCount);
   SF <= k & shifted_p(28 downto 27);
   Abs_in <= p_abs;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                  RightShifterSticky30_by_max_30_F50_uid12
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X S
-- Output signals: R Sticky

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity RightShifterSticky30_by_max_30_F50_uid12 is
    port (clk : in std_logic;
          X : in  std_logic_vector(29 downto 0);
          S : in  std_logic_vector(4 downto 0);
          R : out  std_logic_vector(29 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky30_by_max_30_F50_uid12 is
signal ps :  std_logic_vector(4 downto 0);
signal level5 :  std_logic_vector(29 downto 0);
signal stk4 :  std_logic;
signal level4 :  std_logic_vector(29 downto 0);
signal stk3 :  std_logic;
signal level3 :  std_logic_vector(29 downto 0);
signal stk2 :  std_logic;
signal level2 :  std_logic_vector(29 downto 0);
signal stk1 :  std_logic;
signal level1 :  std_logic_vector(29 downto 0);
signal stk0 :  std_logic;
signal level0 :  std_logic_vector(29 downto 0);
begin
   ps<= S;
   level5<= X;
   stk4 <= '1' when (level5(15 downto 0)/="0000000000000000" and ps(4)='1')   else '0';
   level4 <=  level5 when  ps(4)='0'    else (15 downto 0 => '0') & level5(29 downto 16);
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps(3)='1') or stk4 ='1'   else '0';
   level3 <=  level4 when  ps(3)='0'    else (7 downto 0 => '0') & level4(29 downto 8);
   stk2 <= '1' when (level3(3 downto 0)/="0000" and ps(2)='1') or stk3 ='1'   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => '0') & level3(29 downto 4);
   stk1 <= '1' when (level2(1 downto 0)/="00" and ps(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => '0') & level2(29 downto 2);
   stk0 <= '1' when (level1(0 downto 0)/="0" and ps(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => '0') & level1(29 downto 1);
   R <= level0;
   Sticky <= stk0;
end architecture;

--------------------------------------------------------------------------------
--                 LZCShifter_32_to_32_counting_64_F50_uid14
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2007-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: I
-- Output signals: Count O

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LZCShifter_32_to_32_counting_64_F50_uid14 is
    port (clk : in std_logic;
          I : in  std_logic_vector(31 downto 0);
          Count : out  std_logic_vector(5 downto 0);
          O : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of LZCShifter_32_to_32_counting_64_F50_uid14 is
signal level6 :  std_logic_vector(31 downto 0);
signal count5 :  std_logic;
signal level5 :  std_logic_vector(31 downto 0);
signal count4 :  std_logic;
signal level4 :  std_logic_vector(31 downto 0);
signal count3 :  std_logic;
signal level3 :  std_logic_vector(31 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(31 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(31 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(31 downto 0);
signal sCount :  std_logic_vector(5 downto 0);
begin
   level6 <= I ;
   count5<= '1' when level6(31 downto 0) = (31 downto 0=>'0') else '0';
   level5<= level6(31 downto 0) when count5='0' else (31 downto 0 => '0');

   count4<= '1' when level5(31 downto 16) = (31 downto 16=>'0') else '0';
   level4<= level5(31 downto 0) when count4='0' else level5(15 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(31 downto 24) = (31 downto 24=>'0') else '0';
   level3<= level4(31 downto 0) when count3='0' else level4(23 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(31 downto 28) = (31 downto 28=>'0') else '0';
   level2<= level3(31 downto 0) when count2='0' else level3(27 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(31 downto 30) = (31 downto 30=>'0') else '0';
   level1<= level2(31 downto 0) when count1='0' else level2(29 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(31 downto 31) = (31 downto 31=>'0') else '0';
   level0<= level1(31 downto 0) when count0='0' else level1(30 downto 0) & (0 downto 0 => '0');

   O <= level0;
   sCount <= count5 & count4 & count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                  RightShifterSticky32_by_max_30_F50_uid18
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

entity RightShifterSticky32_by_max_30_F50_uid18 is
    port (clk : in std_logic;
          X : in  std_logic_vector(31 downto 0);
          S : in  std_logic_vector(4 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(31 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky32_by_max_30_F50_uid18 is
signal ps :  std_logic_vector(4 downto 0);
signal level5 :  std_logic_vector(31 downto 0);
signal stk4 :  std_logic;
signal level4 :  std_logic_vector(31 downto 0);
signal stk3 :  std_logic;
signal level3 :  std_logic_vector(31 downto 0);
signal stk2 :  std_logic;
signal level2 :  std_logic_vector(31 downto 0);
signal stk1 :  std_logic;
signal level1 :  std_logic_vector(31 downto 0);
signal stk0 :  std_logic;
signal level0 :  std_logic_vector(31 downto 0);
begin
   ps<= S;
   level5<= X;
   stk4 <= '1' when (level5(15 downto 0)/="0000000000000000" and ps(4)='1')   else '0';
   level4 <=  level5 when  ps(4)='0'    else (15 downto 0 => padBit) & level5(31 downto 16);
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps(3)='1') or stk4 ='1'   else '0';
   level3 <=  level4 when  ps(3)='0'    else (7 downto 0 => padBit) & level4(31 downto 8);
   stk2 <= '1' when (level3(3 downto 0)/="0000" and ps(2)='1') or stk3 ='1'   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => padBit) & level3(31 downto 4);
   stk1 <= '1' when (level2(1 downto 0)/="00" and ps(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => padBit) & level2(31 downto 2);
   stk0 <= '1' when (level1(0 downto 0)/="0" and ps(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => padBit) & level1(31 downto 1);
   R <= level0;
   Sticky <= stk0;
end architecture;

--------------------------------------------------------------------------------
--                        PositEncoder_32_2_F50_uid16
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo, Alberto A. del Barrio, Guillermo Botella, 2020
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: Sign SF Frac Round Sticky Zero Inf
-- Output signals: O

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositEncoder_32_2_F50_uid16 is
    port (clk : in std_logic;
          Sign : in  std_logic;
          SF : in  std_logic_vector(8 downto 0);
          Frac : in  std_logic_vector(26 downto 0);
          Round : in  std_logic;
          Sticky : in  std_logic;
          Zero : in  std_logic;
          Inf : in  std_logic;
          O : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of PositEncoder_32_2_F50_uid16 is
   component RightShifterSticky32_by_max_30_F50_uid18 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(31 downto 0);
             S : in  std_logic_vector(4 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(31 downto 0);
             Sticky : out  std_logic   );
   end component;

signal e :  std_logic_vector(1 downto 0);
signal k :  std_logic_vector(5 downto 0);
signal rc :  std_logic;
signal v_rc :  std_logic_vector(5 downto 0);
signal offset_tmp :  std_logic_vector(5 downto 0);
signal reg_ovf :  std_logic;
signal pad :  std_logic;
signal input_shifter :  std_logic_vector(31 downto 0);
signal shift_offset :  std_logic_vector(4 downto 0);
signal shifted_posit, shifted_posit_d1 :  std_logic_vector(31 downto 0);
signal shifted_sb :  std_logic;
signal stk :  std_logic;
signal rnd :  std_logic;
signal lsb :  std_logic;
signal round_r, round_r_d1 :  std_logic;
signal vSign, vSign_d1, vSign_d2 :  std_logic_vector(30 downto 0);
signal rounded_p :  std_logic_vector(30 downto 0);
signal final_p :  std_logic_vector(30 downto 0);
signal computedO :  std_logic_vector(31 downto 0);
signal Sign_d1, Sign_d2 :  std_logic;
signal Zero_d1 :  std_logic;
signal Inf_d1, Inf_d2 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            shifted_posit_d1 <=  shifted_posit;
            round_r_d1 <=  round_r;
            vSign_d1 <=  vSign;
            vSign_d2 <=  vSign_d1;
            Sign_d1 <=  Sign;
            Sign_d2 <=  Sign_d1;
            Zero_d1 <=  Zero;
            Inf_d1 <=  Inf;
            Inf_d2 <=  Inf_d1;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
----------------------------- Get value of regime -----------------------------
   e <= SF(1 downto 0);
   k <= SF(7 downto 2);
   rc <= SF(8);
   v_rc <= (others => rc) ;
   offset_tmp <= k XOR v_rc;
   -- Check for regime overflow
   reg_ovf <= '1' when (offset_tmp > CONV_STD_LOGIC_VECTOR(29,6)) else '0';
-------------- Generate regime - shift out exponent and fraction --------------
   pad <= not rc;
   input_shifter <= pad & rc & e & Frac & Round;
   shift_offset <= 
      "11110" when reg_ovf = '1' else
      offset_tmp(4 downto 0);
   right_signed_shifter: RightShifterSticky32_by_max_30_F50_uid18
      port map ( clk  => clk,
                 S => shift_offset,
                 X => input_shifter,
                 padBit => pad,
                 R => shifted_posit,
                 Sticky => shifted_sb);
---------------------------- Round to nearest even ----------------------------
   stk <= shifted_sb OR Sticky;
   rnd <= shifted_posit(0);
   lsb <= shifted_posit(1);
   round_r <= rnd AND (lsb OR stk OR reg_ovf);
-------------------------- Check sign & Special Cases --------------------------
   -- Two's complement if posit is negative
   vSign <= (others => Sign);
   rounded_p <= shifted_posit_d1(31 downto 1) + round_r_d1;
   final_p <= (vSign_d2 XOR rounded_p) + Sign_d2;
   computedO <= (31 => Inf_d2, others => '0')  when (Zero_d1='1' or Inf_d2='1') else
      Sign_d2 & final_p;
   O <= computedO;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                                  PositAdd
--                         (PositAdd1_32_2_F50_uid2)
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo, Alberto A. del Barrio, Guillermo Botella, 2020
--------------------------------------------------------------------------------
-- Pipeline depth: 2 cycles
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

entity PositAdd is
    port (clk : in std_logic;
          X : in  std_logic_vector(31 downto 0);
          Y : in  std_logic_vector(31 downto 0);
          R : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of PositAdd is
   component PositDecoder1_32_2_F50_uid4 is
      port ( clk : in std_logic;
             Input : in  std_logic_vector(31 downto 0);
             Sign : out  std_logic;
             SF : out  std_logic_vector(7 downto 0);
             Frac : out  std_logic_vector(26 downto 0);
             Zero : out  std_logic;
             Inf : out  std_logic;
             Abs_in : out  std_logic_vector(30 downto 0)   );
   end component;

   component PositDecoder1_32_2_F50_uid8 is
      port ( clk : in std_logic;
             Input : in  std_logic_vector(31 downto 0);
             Sign : out  std_logic;
             SF : out  std_logic_vector(7 downto 0);
             Frac : out  std_logic_vector(26 downto 0);
             Zero : out  std_logic;
             Inf : out  std_logic;
             Abs_in : out  std_logic_vector(30 downto 0)   );
   end component;

   component RightShifterSticky30_by_max_30_F50_uid12 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(29 downto 0);
             S : in  std_logic_vector(4 downto 0);
             R : out  std_logic_vector(29 downto 0);
             Sticky : out  std_logic   );
   end component;

   component LZCShifter_32_to_32_counting_64_F50_uid14 is
      port ( clk : in std_logic;
             I : in  std_logic_vector(31 downto 0);
             Count : out  std_logic_vector(5 downto 0);
             O : out  std_logic_vector(31 downto 0)   );
   end component;

   component PositEncoder_32_2_F50_uid16 is
      port ( clk : in std_logic;
             Sign : in  std_logic;
             SF : in  std_logic_vector(8 downto 0);
             Frac : in  std_logic_vector(26 downto 0);
             Round : in  std_logic;
             Sticky : in  std_logic;
             Zero : in  std_logic;
             Inf : in  std_logic;
             O : out  std_logic_vector(31 downto 0)   );
   end component;

signal sign_X :  std_logic;
signal sf_X :  std_logic_vector(7 downto 0);
signal frac_X :  std_logic_vector(26 downto 0);
signal z_X :  std_logic;
signal inf_X :  std_logic;
signal X_abs :  std_logic_vector(30 downto 0);
signal sign_Y :  std_logic;
signal sf_Y :  std_logic_vector(7 downto 0);
signal frac_Y :  std_logic_vector(26 downto 0);
signal z_Y :  std_logic;
signal inf_Y :  std_logic;
signal Y_abs :  std_logic_vector(30 downto 0);
signal OP, OP_d1 :  std_logic;
signal inf :  std_logic;
signal is_larger :  std_logic;
signal larger_sign :  std_logic;
signal larger_sf :  std_logic_vector(7 downto 0);
signal larger_frac, larger_frac_d1 :  std_logic_vector(27 downto 0);
signal smaller_frac :  std_logic_vector(29 downto 0);
signal sf_diff :  std_logic_vector(7 downto 0);
signal sf_sign :  std_logic;
signal sf_signVect :  std_logic_vector(7 downto 0);
signal offset :  std_logic_vector(7 downto 0);
signal shift_saturate :  std_logic;
signal frac_offset :  std_logic_vector(4 downto 0);
signal shifted_frac, shifted_frac_d1 :  std_logic_vector(29 downto 0);
signal sticky, sticky_d1 :  std_logic;
signal add_frac :  std_logic_vector(31 downto 0);
signal nZerosNew :  std_logic_vector(5 downto 0);
signal normFrac :  std_logic_vector(31 downto 0);
signal sf_tmp, sf_tmp_d1 :  std_logic_vector(8 downto 0);
signal sf_final :  std_logic_vector(8 downto 0);
signal frac :  std_logic_vector(26 downto 0);
signal stk :  std_logic;
signal rnd :  std_logic;
signal z :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            OP_d1 <=  OP;
            larger_frac_d1 <=  larger_frac;
            shifted_frac_d1 <=  shifted_frac;
            sticky_d1 <=  sticky;
            sf_tmp_d1 <=  sf_tmp;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
------------------------------- Data Extraction -------------------------------
   X_decoder: PositDecoder1_32_2_F50_uid4
      port map ( clk  => clk,
                 Input => X,
                 Abs_in => X_abs,
                 Frac => frac_X,
                 Inf => inf_X,
                 SF => sf_X,
                 Sign => sign_X,
                 Zero => z_X);
   Y_decoder: PositDecoder1_32_2_F50_uid8
      port map ( clk  => clk,
                 Input => Y,
                 Abs_in => Y_abs,
                 Frac => frac_Y,
                 Inf => inf_Y,
                 SF => sf_Y,
                 Sign => sign_Y,
                 Zero => z_Y);
---------------------- Sign and Special Cases Computation ----------------------
   OP <= sign_X XOR sign_Y;
   inf <= inf_X OR inf_Y;
---------------------- Compare operands and adjust values ----------------------
   is_larger<= '1' when X_abs > Y_abs else '0';
   with is_larger  select  larger_sign <= 
      sign_X when '1',
      sign_Y when '0',
      '-' when others;
   with is_larger  select  larger_sf <= 
      sf_X when '1',
      sf_Y when '0',
      "--------" when others;
   with is_larger  select  larger_frac <= 
      ((NOT z_X) & frac_X) when '1',
      ((NOT z_Y) & frac_Y) when '0',
      "----------------------------" when others;
   with is_larger  select  smaller_frac <= 
      ((NOT z_Y) & frac_Y & "00")  when '1',
      ((NOT z_X) & frac_X & "00")  when '0',
      "------------------------------" when others;
   -- exponent difference
   sf_diff <= sf_X - sf_Y;
   sf_sign <= sf_diff(sf_diff'high);
   sf_signVect <= (others => sf_sign);
   offset <= (sf_signVect XOR sf_diff) + sf_sign;
   shift_saturate <= '0' when (offset(7 downto 5) = 0) else '1';
   frac_offset <= CONV_STD_LOGIC_VECTOR(30,5) when shift_saturate = '1' else offset(4 downto 0);
------------------------------- Align fractions -------------------------------
   RightShifterFraction: RightShifterSticky30_by_max_30_F50_uid12
      port map ( clk  => clk,
                 S => frac_offset,
                 X => smaller_frac,
                 R => shifted_frac,
                 Sticky => sticky);
---------------------------- Add aligned fractions ----------------------------
   with OP_d1  select  add_frac <= 
      ('0' & larger_frac_d1 & "000") + ('0' & shifted_frac_d1 & sticky_d1) when '0',
      ('0' & larger_frac_d1 & "000") - ('0' & shifted_frac_d1 & sticky_d1) when '1',
      "--------------------------------" when others;
   -- Normalization of add_frac
   FractionNormalizer: LZCShifter_32_to_32_counting_64_F50_uid14
      port map ( clk  => clk,
                 I => add_frac,
                 Count => nZerosNew,
                 O => normFrac);
   -- Adjust exponent
   sf_tmp<= (larger_sf(larger_sf'high) & larger_sf) + '1';
   sf_final<= sf_tmp_d1 - ("000" & nZerosNew);
--------------------------- Data Rounding & Encoding ---------------------------
   frac <= normFrac(30 downto 4);
   stk<= normFrac(2) or normFrac(1) or normFrac(0);
   rnd<= normFrac(3);
   z <= '1' when nZerosNew = "111111" else '0';
   R_encoding: PositEncoder_32_2_F50_uid16
      port map ( clk  => clk,
                 Frac => frac,
                 Inf => inf,
                 Round => rnd,
                 SF => sf_final,
                 Sign => larger_sign,
                 Sticky => stk,
                 Zero => z,
                 O => R);
---------------------------- End of vhdl generation ----------------------------
end architecture;

