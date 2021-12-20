--------------------------------------------------------------------------------
--                       Normalizer_Z_64_64_64_F50_uid4
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, (2007-2020)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X
-- Output signals: Count R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Normalizer_Z_64_64_64_F50_uid4 is
    port (clk : in std_logic;
          X : in  std_logic_vector(63 downto 0);
          Count : out  std_logic_vector(6 downto 0);
          R : out  std_logic_vector(63 downto 0)   );
end entity;

architecture arch of Normalizer_Z_64_64_64_F50_uid4 is
signal level7 :  std_logic_vector(63 downto 0);
signal count6 :  std_logic;
signal level6 :  std_logic_vector(63 downto 0);
signal count5 :  std_logic;
signal level5 :  std_logic_vector(63 downto 0);
signal count4 :  std_logic;
signal level4 :  std_logic_vector(63 downto 0);
signal count3 :  std_logic;
signal level3 :  std_logic_vector(63 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(63 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(63 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(63 downto 0);
signal sCount :  std_logic_vector(6 downto 0);
begin
   level7 <= X ;
   count6<= '1' when level7(63 downto 0) = (63 downto 0=>'0') else '0';
   level6<= level7(63 downto 0) when count6='0' else (63 downto 0 => '0');

   count5<= '1' when level6(63 downto 32) = (63 downto 32=>'0') else '0';
   level5<= level6(63 downto 0) when count5='0' else level6(31 downto 0) & (31 downto 0 => '0');

   count4<= '1' when level5(63 downto 48) = (63 downto 48=>'0') else '0';
   level4<= level5(63 downto 0) when count4='0' else level5(47 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(63 downto 56) = (63 downto 56=>'0') else '0';
   level3<= level4(63 downto 0) when count3='0' else level4(55 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(63 downto 60) = (63 downto 60=>'0') else '0';
   level2<= level3(63 downto 0) when count2='0' else level3(59 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(63 downto 62) = (63 downto 62=>'0') else '0';
   level1<= level2(63 downto 0) when count1='0' else level2(61 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(63 downto 63) = (63 downto 63=>'0') else '0';
   level0<= level1(63 downto 0) when count0='0' else level1(62 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count6 & count5 & count4 & count3 & count2 & count1 & count0;
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
--                                 UInt2Posit
--                    (UInt2Posit_64_to_32_2_NT_F50_uid2)
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

entity ULong2Posit is
    port (clk : in std_logic;
          X : in  std_logic_vector(63 downto 0);
          R : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of ULong2Posit is
   component Normalizer_Z_64_64_64_F50_uid4 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(63 downto 0);
             Count : out  std_logic_vector(6 downto 0);
             R : out  std_logic_vector(63 downto 0)   );
   end component;

   component RightShifterSticky31_by_max_31_F50_uid6 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(30 downto 0);
             S : in  std_logic_vector(4 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(30 downto 0);
             Sticky : out  std_logic   );
   end component;

signal unsgnInt :  std_logic_vector(63 downto 0);
signal nzn :  std_logic;
signal intExp :  std_logic_vector(6 downto 0);
signal tmpFrac :  std_logic_vector(63 downto 0);
signal frac :  std_logic_vector(26 downto 0);
signal rndBit :  std_logic;
signal stkBit :  std_logic;
signal sf :  std_logic_vector(7 downto 0);
signal reg :  std_logic_vector(4 downto 0);
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
   unsgnInt <= X;
   nzn <= '0' when (unsgnInt = "0000000000000000000000000000000000000000000000000000000000000000") else '1';
-------------------- Count leading zeros & extract fraction --------------------
   LZOCAndShifter: Normalizer_Z_64_64_64_F50_uid4
      port map ( clk  => clk,
                 X => unsgnInt,
                 Count => intExp,
                 R => tmpFrac);
   frac <= tmpFrac(62 downto 36);
   rndBit <= tmpFrac(35);
   stkBit <= '0' when (tmpFrac(34 downto 0) = "00000000000000000000000000000000000") else '1';
----------------- Determine the scaling factor - regime & exp -----------------
   sf <= "00111111" - ("0" & intExp);
   reg <= sf(6 downto 2);
   expBits <= sf(1 downto 0);
---------------- Shift out fraction according to scaling factor ----------------
   padBit <= '1';
   paddedFrac <= '0' & expBits & frac & rndBit;
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
   result <= positNumber when nzn = '1' else (nzn & "000000000000000000000000000000");
   R <= '0' & result;
---------------------------- End of vhdl generation ----------------------------
end architecture;

