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
--                       PositFastDecoder_64_2_F50_uid4
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X
-- Output signals: Sign SF Frac NZN

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositFastDecoder_64_2_F50_uid4 is
    port (clk : in std_logic;
          X : in  std_logic_vector(63 downto 0);
          Sign : out  std_logic;
          SF : out  std_logic_vector(8 downto 0);
          Frac : out  std_logic_vector(58 downto 0);
          NZN : out  std_logic   );
end entity;

architecture arch of PositFastDecoder_64_2_F50_uid4 is
   component Normalizer_ZO_62_62_62_F50_uid6 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(61 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(61 downto 0)   );
   end component;

signal sgn :  std_logic;
signal pNZN :  std_logic;
signal rc :  std_logic;
signal regPosit :  std_logic_vector(61 downto 0);
signal regLength :  std_logic_vector(5 downto 0);
signal shiftedPosit :  std_logic_vector(61 downto 0);
signal k :  std_logic_vector(6 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal exp :  std_logic_vector(1 downto 0);
signal pSF :  std_logic_vector(8 downto 0);
signal pFrac :  std_logic_vector(58 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
--------------------------- Sign bit & special cases ---------------------------
   sgn <= X(63);
   pNZN <= '0' when (X(62 downto 0) = "000000000000000000000000000000000000000000000000000000000000000") else '1';
-------------- Count leading zeros/ones of regime & shift it out --------------
   rc <= X(62);
   regPosit <= X(61 downto 0);
   RegimeCounter: Normalizer_ZO_62_62_62_F50_uid6
      port map ( clk  => clk,
                 OZb => rc,
                 X => regPosit,
                 Count => regLength,
                 R => shiftedPosit);
----------------- Determine the scaling factor - regime & exp -----------------
   k <= "0" & regLength when rc /= sgn else "1" & NOT(regLength);
   sgnVect <= (others => sgn);
   exp <= shiftedPosit(60 downto 59) XOR sgnVect;
   pSF <= k & exp;
------------------------------- Extract fraction -------------------------------
   pFrac <= shiftedPosit(58 downto 0);
   Sign <= sgn;
   SF <= pSF;
   Frac <= pFrac;
   NZN <= pNZN;
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
--                       PositFastDecoder_64_2_F50_uid8
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X
-- Output signals: Sign SF Frac NZN

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositFastDecoder_64_2_F50_uid8 is
    port (clk : in std_logic;
          X : in  std_logic_vector(63 downto 0);
          Sign : out  std_logic;
          SF : out  std_logic_vector(8 downto 0);
          Frac : out  std_logic_vector(58 downto 0);
          NZN : out  std_logic   );
end entity;

architecture arch of PositFastDecoder_64_2_F50_uid8 is
   component Normalizer_ZO_62_62_62_F50_uid10 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(61 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(61 downto 0)   );
   end component;

signal sgn :  std_logic;
signal pNZN :  std_logic;
signal rc :  std_logic;
signal regPosit :  std_logic_vector(61 downto 0);
signal regLength :  std_logic_vector(5 downto 0);
signal shiftedPosit :  std_logic_vector(61 downto 0);
signal k :  std_logic_vector(6 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal exp :  std_logic_vector(1 downto 0);
signal pSF :  std_logic_vector(8 downto 0);
signal pFrac :  std_logic_vector(58 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
--------------------------- Sign bit & special cases ---------------------------
   sgn <= X(63);
   pNZN <= '0' when (X(62 downto 0) = "000000000000000000000000000000000000000000000000000000000000000") else '1';
-------------- Count leading zeros/ones of regime & shift it out --------------
   rc <= X(62);
   regPosit <= X(61 downto 0);
   RegimeCounter: Normalizer_ZO_62_62_62_F50_uid10
      port map ( clk  => clk,
                 OZb => rc,
                 X => regPosit,
                 Count => regLength,
                 R => shiftedPosit);
----------------- Determine the scaling factor - regime & exp -----------------
   k <= "0" & regLength when rc /= sgn else "1" & NOT(regLength);
   sgnVect <= (others => sgn);
   exp <= shiftedPosit(60 downto 59) XOR sgnVect;
   pSF <= k & exp;
------------------------------- Extract fraction -------------------------------
   pFrac <= shiftedPosit(58 downto 0);
   Sign <= sgn;
   SF <= pSF;
   Frac <= pFrac;
   NZN <= pNZN;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid14
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid14 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid14 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid16
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid16 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid16 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid18
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid18 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid18 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid20
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid20 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid20 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid22
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid22 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid22 is
signal Rtmp :  std_logic_vector(60 downto 0);
signal X_d1 :  std_logic_vector(60 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid24
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid24 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid24 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid26
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid26 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid26 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid28
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid28 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid28 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid30
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid30 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid30 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid32
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid32 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid32 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid34
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid34 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid34 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid36
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid36 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid36 is
signal Rtmp :  std_logic_vector(60 downto 0);
signal X_d1 :  std_logic_vector(60 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
            Cin_d1 <=  Cin;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid38
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid38 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid38 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid40
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid40 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid40 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid42
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid42 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid42 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid44
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid44 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid44 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid46
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid46 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid46 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid48
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid48 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid48 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid50
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid50 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid50 is
signal Rtmp :  std_logic_vector(60 downto 0);
signal X_d1 :  std_logic_vector(60 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
            Cin_d1 <=  Cin;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid52
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid52 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid52 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid54
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid54 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid54 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid56
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid56 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid56 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid58
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid58 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid58 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid60
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid60 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid60 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid62
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid62 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid62 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid64
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid64 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid64 is
signal Rtmp :  std_logic_vector(60 downto 0);
signal X_d1 :  std_logic_vector(60 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
            Cin_d1 <=  Cin;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid66
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid66 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid66 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid68
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid68 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid68 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid70
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid70 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid70 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid72
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid72 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid72 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid74
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid74 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid74 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid76
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid76 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid76 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid78
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid78 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid78 is
signal Rtmp :  std_logic_vector(60 downto 0);
signal X_d1 :  std_logic_vector(60 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
            Cin_d1 <=  Cin;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid80
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid80 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid80 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid82
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid82 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid82 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid84
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid84 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid84 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid86
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid86 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid86 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid88
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid88 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid88 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid90
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid90 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid90 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid92
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid92 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid92 is
signal Rtmp :  std_logic_vector(60 downto 0);
signal X_d1 :  std_logic_vector(60 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
            Cin_d1 <=  Cin;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid94
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid94 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid94 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid96
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid96 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid96 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid98
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid98 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid98 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid100
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid100 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid100 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid102
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid102 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid102 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid104
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid104 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid104 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid106
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid106 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid106 is
signal Rtmp :  std_logic_vector(60 downto 0);
signal X_d1 :  std_logic_vector(60 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
            Cin_d1 <=  Cin;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid108
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid108 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid108 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid110
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid110 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid110 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid112
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid112 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid112 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid114
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid114 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid114 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid116
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid116 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid116 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid118
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid118 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid118 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid120
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid120 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid120 is
signal Rtmp :  std_logic_vector(60 downto 0);
signal X_d1 :  std_logic_vector(60 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
            Cin_d1 <=  Cin;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid122
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid122 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid122 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid124
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid124 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid124 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid126
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid126 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid126 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid128
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid128 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid128 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid130
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid130 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid130 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid132
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid132 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid132 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid134
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid134 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid134 is
signal Rtmp :  std_logic_vector(60 downto 0);
signal X_d1 :  std_logic_vector(60 downto 0);
signal Y_d1 :  std_logic_vector(60 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
            Y_d1 <=  Y;
            Cin_d1 <=  Cin;
         end if;
      end process;
   Rtmp <= X_d1 + Y_d1 + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid136
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid136 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid136 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_61_F50_uid138
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_61_F50_uid138 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(60 downto 0)   );
end entity;

architecture arch of IntAdder_61_F50_uid138 is
signal Rtmp :  std_logic_vector(60 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_65_F50_uid140
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_65_F50_uid140 is
    port (clk : in std_logic;
          X : in  std_logic_vector(64 downto 0);
          Y : in  std_logic_vector(64 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(64 downto 0)   );
end entity;

architecture arch of IntAdder_65_F50_uid140 is
signal Rtmp :  std_logic_vector(64 downto 0);
signal Cin_d1, Cin_d2, Cin_d3, Cin_d4, Cin_d5, Cin_d6, Cin_d7, Cin_d8, Cin_d9 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            Cin_d1 <=  Cin;
            Cin_d2 <=  Cin_d1;
            Cin_d3 <=  Cin_d2;
            Cin_d4 <=  Cin_d3;
            Cin_d5 <=  Cin_d4;
            Cin_d6 <=  Cin_d5;
            Cin_d7 <=  Cin_d6;
            Cin_d8 <=  Cin_d7;
            Cin_d9 <=  Cin_d8;
         end if;
      end process;
   Rtmp <= X + Y + Cin_d9;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_65_F50_uid142
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_65_F50_uid142 is
    port (clk : in std_logic;
          X : in  std_logic_vector(64 downto 0);
          Y : in  std_logic_vector(64 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(64 downto 0)   );
end entity;

architecture arch of IntAdder_65_F50_uid142 is
signal Rtmp :  std_logic_vector(64 downto 0);
signal Cin_d1, Cin_d2, Cin_d3, Cin_d4, Cin_d5, Cin_d6, Cin_d7, Cin_d8, Cin_d9 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            Cin_d1 <=  Cin;
            Cin_d2 <=  Cin_d1;
            Cin_d3 <=  Cin_d2;
            Cin_d4 <=  Cin_d3;
            Cin_d5 <=  Cin_d4;
            Cin_d6 <=  Cin_d5;
            Cin_d7 <=  Cin_d6;
            Cin_d8 <=  Cin_d7;
            Cin_d9 <=  Cin_d8;
         end if;
      end process;
   Rtmp <= X + Y + Cin_d9;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           FixDiv_1_59_F50_uid12
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 9 cycles
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

entity FixDiv_1_59_F50_uid12 is
    port (clk : in std_logic;
          X : in  std_logic_vector(60 downto 0);
          Y : in  std_logic_vector(60 downto 0);
          R : out  std_logic_vector(63 downto 0)   );
end entity;

architecture arch of FixDiv_1_59_F50_uid12 is
   component IntAdder_61_F50_uid14 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid16 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid18 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid20 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid22 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid24 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid26 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid28 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid30 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid32 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid34 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid36 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid38 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid40 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid42 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid44 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid46 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid48 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid50 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid52 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid54 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid56 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid58 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid60 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid62 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid64 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid66 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid68 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid70 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid72 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid74 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid76 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid78 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid80 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid82 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid84 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid86 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid88 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid90 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid92 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid94 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid96 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid98 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid100 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid102 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid104 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid106 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid108 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid110 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid112 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid114 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid116 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid118 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid120 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid122 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid124 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid126 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid128 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid130 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid132 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid134 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid136 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_61_F50_uid138 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(60 downto 0)   );
   end component;

   component IntAdder_65_F50_uid140 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(64 downto 0);
             Y : in  std_logic_vector(64 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(64 downto 0)   );
   end component;

   component IntAdder_65_F50_uid142 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(64 downto 0);
             Y : in  std_logic_vector(64 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(64 downto 0)   );
   end component;

signal X_minus_two :  std_logic;
signal Y_plus_one :  std_logic;
signal corner_case, corner_case_d1, corner_case_d2, corner_case_d3, corner_case_d4, corner_case_d5, corner_case_d6, corner_case_d7, corner_case_d8, corner_case_d9 :  std_logic;
signal X_sign, X_sign_d1, X_sign_d2, X_sign_d3, X_sign_d4, X_sign_d5, X_sign_d6, X_sign_d7, X_sign_d8, X_sign_d9 :  std_logic;
signal div, div_d1, div_d2, div_d3, div_d4, div_d5, div_d6, div_d7, div_d8, div_d9 :  std_logic_vector(60 downto 0);
signal div_sign, div_sign_d1, div_sign_d2, div_sign_d3, div_sign_d4, div_sign_d5, div_sign_d6, div_sign_d7, div_sign_d8, div_sign_d9 :  std_logic;
signal diff_signs :  std_logic;
signal div_ge_tmp :  std_logic;
signal div_gr, div_gr_d1, div_gr_d2, div_gr_d3, div_gr_d4, div_gr_d5, div_gr_d6, div_gr_d7, div_gr_d8, div_gr_d9 :  std_logic;
signal n_0 :  std_logic_vector(60 downto 0);
signal append_0 :  std_logic;
signal neg_div, neg_div_d1, neg_div_d2, neg_div_d3, neg_div_d4, neg_div_d5, neg_div_d6, neg_div_d7, neg_div_d8, neg_div_d9 :  std_logic_vector(60 downto 0);
signal one_bit :  std_logic;
signal s_1, s_1_d1, s_1_d2, s_1_d3, s_1_d4, s_1_d5, s_1_d6, s_1_d7, s_1_d8, s_1_d9 :  std_logic;
signal r_0 :  std_logic_vector(60 downto 0);
signal pm_div_1 :  std_logic_vector(60 downto 0);
signal n_1 :  std_logic_vector(60 downto 0);
signal rem_z_0 :  std_logic;
signal z_1 :  std_logic;
signal s_2, s_2_d1, s_2_d2, s_2_d3, s_2_d4, s_2_d5, s_2_d6, s_2_d7, s_2_d8, s_2_d9 :  std_logic;
signal r_1 :  std_logic_vector(60 downto 0);
signal pm_div_2 :  std_logic_vector(60 downto 0);
signal n_2 :  std_logic_vector(60 downto 0);
signal rem_z_1 :  std_logic;
signal z_2 :  std_logic;
signal s_3, s_3_d1, s_3_d2, s_3_d3, s_3_d4, s_3_d5, s_3_d6, s_3_d7, s_3_d8, s_3_d9 :  std_logic;
signal r_2 :  std_logic_vector(60 downto 0);
signal pm_div_3 :  std_logic_vector(60 downto 0);
signal n_3 :  std_logic_vector(60 downto 0);
signal rem_z_2 :  std_logic;
signal z_3, z_3_d1 :  std_logic;
signal s_4, s_4_d1, s_4_d2, s_4_d3, s_4_d4, s_4_d5, s_4_d6, s_4_d7, s_4_d8, s_4_d9 :  std_logic;
signal r_3 :  std_logic_vector(60 downto 0);
signal pm_div_4 :  std_logic_vector(60 downto 0);
signal n_4, n_4_d1 :  std_logic_vector(60 downto 0);
signal rem_z_3 :  std_logic;
signal z_4 :  std_logic;
signal s_5, s_5_d1, s_5_d2, s_5_d3, s_5_d4, s_5_d5, s_5_d6, s_5_d7, s_5_d8 :  std_logic;
signal r_4 :  std_logic_vector(60 downto 0);
signal pm_div_5 :  std_logic_vector(60 downto 0);
signal n_5 :  std_logic_vector(60 downto 0);
signal rem_z_4 :  std_logic;
signal z_5 :  std_logic;
signal s_6, s_6_d1, s_6_d2, s_6_d3, s_6_d4, s_6_d5, s_6_d6, s_6_d7, s_6_d8 :  std_logic;
signal r_5 :  std_logic_vector(60 downto 0);
signal pm_div_6 :  std_logic_vector(60 downto 0);
signal n_6 :  std_logic_vector(60 downto 0);
signal rem_z_5 :  std_logic;
signal z_6 :  std_logic;
signal s_7, s_7_d1, s_7_d2, s_7_d3, s_7_d4, s_7_d5, s_7_d6, s_7_d7, s_7_d8 :  std_logic;
signal r_6 :  std_logic_vector(60 downto 0);
signal pm_div_7 :  std_logic_vector(60 downto 0);
signal n_7 :  std_logic_vector(60 downto 0);
signal rem_z_6 :  std_logic;
signal z_7 :  std_logic;
signal s_8, s_8_d1, s_8_d2, s_8_d3, s_8_d4, s_8_d5, s_8_d6, s_8_d7, s_8_d8 :  std_logic;
signal r_7 :  std_logic_vector(60 downto 0);
signal pm_div_8 :  std_logic_vector(60 downto 0);
signal n_8 :  std_logic_vector(60 downto 0);
signal rem_z_7 :  std_logic;
signal z_8 :  std_logic;
signal s_9, s_9_d1, s_9_d2, s_9_d3, s_9_d4, s_9_d5, s_9_d6, s_9_d7, s_9_d8 :  std_logic;
signal r_8 :  std_logic_vector(60 downto 0);
signal pm_div_9 :  std_logic_vector(60 downto 0);
signal n_9 :  std_logic_vector(60 downto 0);
signal rem_z_8 :  std_logic;
signal z_9 :  std_logic;
signal s_10, s_10_d1, s_10_d2, s_10_d3, s_10_d4, s_10_d5, s_10_d6, s_10_d7, s_10_d8 :  std_logic;
signal r_9 :  std_logic_vector(60 downto 0);
signal pm_div_10 :  std_logic_vector(60 downto 0);
signal n_10 :  std_logic_vector(60 downto 0);
signal rem_z_9 :  std_logic;
signal z_10, z_10_d1 :  std_logic;
signal s_11, s_11_d1, s_11_d2, s_11_d3, s_11_d4, s_11_d5, s_11_d6, s_11_d7, s_11_d8 :  std_logic;
signal r_10 :  std_logic_vector(60 downto 0);
signal pm_div_11 :  std_logic_vector(60 downto 0);
signal n_11, n_11_d1 :  std_logic_vector(60 downto 0);
signal rem_z_10 :  std_logic;
signal z_11 :  std_logic;
signal s_12, s_12_d1, s_12_d2, s_12_d3, s_12_d4, s_12_d5, s_12_d6, s_12_d7, s_12_d8 :  std_logic;
signal r_11 :  std_logic_vector(60 downto 0);
signal pm_div_12 :  std_logic_vector(60 downto 0);
signal n_12 :  std_logic_vector(60 downto 0);
signal rem_z_11 :  std_logic;
signal z_12 :  std_logic;
signal s_13, s_13_d1, s_13_d2, s_13_d3, s_13_d4, s_13_d5, s_13_d6, s_13_d7 :  std_logic;
signal r_12 :  std_logic_vector(60 downto 0);
signal pm_div_13 :  std_logic_vector(60 downto 0);
signal n_13 :  std_logic_vector(60 downto 0);
signal rem_z_12 :  std_logic;
signal z_13 :  std_logic;
signal s_14, s_14_d1, s_14_d2, s_14_d3, s_14_d4, s_14_d5, s_14_d6, s_14_d7 :  std_logic;
signal r_13 :  std_logic_vector(60 downto 0);
signal pm_div_14 :  std_logic_vector(60 downto 0);
signal n_14 :  std_logic_vector(60 downto 0);
signal rem_z_13 :  std_logic;
signal z_14 :  std_logic;
signal s_15, s_15_d1, s_15_d2, s_15_d3, s_15_d4, s_15_d5, s_15_d6, s_15_d7 :  std_logic;
signal r_14 :  std_logic_vector(60 downto 0);
signal pm_div_15 :  std_logic_vector(60 downto 0);
signal n_15 :  std_logic_vector(60 downto 0);
signal rem_z_14 :  std_logic;
signal z_15 :  std_logic;
signal s_16, s_16_d1, s_16_d2, s_16_d3, s_16_d4, s_16_d5, s_16_d6, s_16_d7 :  std_logic;
signal r_15 :  std_logic_vector(60 downto 0);
signal pm_div_16 :  std_logic_vector(60 downto 0);
signal n_16 :  std_logic_vector(60 downto 0);
signal rem_z_15 :  std_logic;
signal z_16 :  std_logic;
signal s_17, s_17_d1, s_17_d2, s_17_d3, s_17_d4, s_17_d5, s_17_d6, s_17_d7 :  std_logic;
signal r_16 :  std_logic_vector(60 downto 0);
signal pm_div_17 :  std_logic_vector(60 downto 0);
signal n_17 :  std_logic_vector(60 downto 0);
signal rem_z_16 :  std_logic;
signal z_17, z_17_d1 :  std_logic;
signal s_18, s_18_d1, s_18_d2, s_18_d3, s_18_d4, s_18_d5, s_18_d6, s_18_d7 :  std_logic;
signal r_17 :  std_logic_vector(60 downto 0);
signal pm_div_18 :  std_logic_vector(60 downto 0);
signal n_18, n_18_d1 :  std_logic_vector(60 downto 0);
signal rem_z_17 :  std_logic;
signal z_18 :  std_logic;
signal s_19, s_19_d1, s_19_d2, s_19_d3, s_19_d4, s_19_d5, s_19_d6, s_19_d7 :  std_logic;
signal r_18 :  std_logic_vector(60 downto 0);
signal pm_div_19 :  std_logic_vector(60 downto 0);
signal n_19 :  std_logic_vector(60 downto 0);
signal rem_z_18 :  std_logic;
signal z_19 :  std_logic;
signal s_20, s_20_d1, s_20_d2, s_20_d3, s_20_d4, s_20_d5, s_20_d6 :  std_logic;
signal r_19 :  std_logic_vector(60 downto 0);
signal pm_div_20 :  std_logic_vector(60 downto 0);
signal n_20 :  std_logic_vector(60 downto 0);
signal rem_z_19 :  std_logic;
signal z_20 :  std_logic;
signal s_21, s_21_d1, s_21_d2, s_21_d3, s_21_d4, s_21_d5, s_21_d6 :  std_logic;
signal r_20 :  std_logic_vector(60 downto 0);
signal pm_div_21 :  std_logic_vector(60 downto 0);
signal n_21 :  std_logic_vector(60 downto 0);
signal rem_z_20 :  std_logic;
signal z_21 :  std_logic;
signal s_22, s_22_d1, s_22_d2, s_22_d3, s_22_d4, s_22_d5, s_22_d6 :  std_logic;
signal r_21 :  std_logic_vector(60 downto 0);
signal pm_div_22 :  std_logic_vector(60 downto 0);
signal n_22 :  std_logic_vector(60 downto 0);
signal rem_z_21 :  std_logic;
signal z_22 :  std_logic;
signal s_23, s_23_d1, s_23_d2, s_23_d3, s_23_d4, s_23_d5, s_23_d6 :  std_logic;
signal r_22 :  std_logic_vector(60 downto 0);
signal pm_div_23 :  std_logic_vector(60 downto 0);
signal n_23 :  std_logic_vector(60 downto 0);
signal rem_z_22 :  std_logic;
signal z_23 :  std_logic;
signal s_24, s_24_d1, s_24_d2, s_24_d3, s_24_d4, s_24_d5, s_24_d6 :  std_logic;
signal r_23 :  std_logic_vector(60 downto 0);
signal pm_div_24 :  std_logic_vector(60 downto 0);
signal n_24 :  std_logic_vector(60 downto 0);
signal rem_z_23 :  std_logic;
signal z_24, z_24_d1 :  std_logic;
signal s_25, s_25_d1, s_25_d2, s_25_d3, s_25_d4, s_25_d5, s_25_d6 :  std_logic;
signal r_24 :  std_logic_vector(60 downto 0);
signal pm_div_25 :  std_logic_vector(60 downto 0);
signal n_25 :  std_logic_vector(60 downto 0);
signal rem_z_24, rem_z_24_d1 :  std_logic;
signal z_25 :  std_logic;
signal s_26, s_26_d1, s_26_d2, s_26_d3, s_26_d4, s_26_d5, s_26_d6 :  std_logic;
signal r_25 :  std_logic_vector(60 downto 0);
signal pm_div_26 :  std_logic_vector(60 downto 0);
signal n_26 :  std_logic_vector(60 downto 0);
signal rem_z_25 :  std_logic;
signal z_26 :  std_logic;
signal s_27, s_27_d1, s_27_d2, s_27_d3, s_27_d4, s_27_d5 :  std_logic;
signal r_26 :  std_logic_vector(60 downto 0);
signal pm_div_27 :  std_logic_vector(60 downto 0);
signal n_27 :  std_logic_vector(60 downto 0);
signal rem_z_26 :  std_logic;
signal z_27 :  std_logic;
signal s_28, s_28_d1, s_28_d2, s_28_d3, s_28_d4, s_28_d5 :  std_logic;
signal r_27 :  std_logic_vector(60 downto 0);
signal pm_div_28 :  std_logic_vector(60 downto 0);
signal n_28 :  std_logic_vector(60 downto 0);
signal rem_z_27 :  std_logic;
signal z_28 :  std_logic;
signal s_29, s_29_d1, s_29_d2, s_29_d3, s_29_d4, s_29_d5 :  std_logic;
signal r_28 :  std_logic_vector(60 downto 0);
signal pm_div_29 :  std_logic_vector(60 downto 0);
signal n_29 :  std_logic_vector(60 downto 0);
signal rem_z_28 :  std_logic;
signal z_29 :  std_logic;
signal s_30, s_30_d1, s_30_d2, s_30_d3, s_30_d4, s_30_d5 :  std_logic;
signal r_29 :  std_logic_vector(60 downto 0);
signal pm_div_30 :  std_logic_vector(60 downto 0);
signal n_30 :  std_logic_vector(60 downto 0);
signal rem_z_29 :  std_logic;
signal z_30 :  std_logic;
signal s_31, s_31_d1, s_31_d2, s_31_d3, s_31_d4, s_31_d5 :  std_logic;
signal r_30 :  std_logic_vector(60 downto 0);
signal pm_div_31 :  std_logic_vector(60 downto 0);
signal n_31 :  std_logic_vector(60 downto 0);
signal rem_z_30 :  std_logic;
signal z_31, z_31_d1 :  std_logic;
signal s_32, s_32_d1, s_32_d2, s_32_d3, s_32_d4, s_32_d5 :  std_logic;
signal r_31 :  std_logic_vector(60 downto 0);
signal pm_div_32 :  std_logic_vector(60 downto 0);
signal n_32 :  std_logic_vector(60 downto 0);
signal rem_z_31, rem_z_31_d1 :  std_logic;
signal z_32 :  std_logic;
signal s_33, s_33_d1, s_33_d2, s_33_d3, s_33_d4, s_33_d5 :  std_logic;
signal r_32 :  std_logic_vector(60 downto 0);
signal pm_div_33 :  std_logic_vector(60 downto 0);
signal n_33 :  std_logic_vector(60 downto 0);
signal rem_z_32 :  std_logic;
signal z_33 :  std_logic;
signal s_34, s_34_d1, s_34_d2, s_34_d3, s_34_d4 :  std_logic;
signal r_33 :  std_logic_vector(60 downto 0);
signal pm_div_34 :  std_logic_vector(60 downto 0);
signal n_34 :  std_logic_vector(60 downto 0);
signal rem_z_33 :  std_logic;
signal z_34 :  std_logic;
signal s_35, s_35_d1, s_35_d2, s_35_d3, s_35_d4 :  std_logic;
signal r_34 :  std_logic_vector(60 downto 0);
signal pm_div_35 :  std_logic_vector(60 downto 0);
signal n_35 :  std_logic_vector(60 downto 0);
signal rem_z_34 :  std_logic;
signal z_35 :  std_logic;
signal s_36, s_36_d1, s_36_d2, s_36_d3, s_36_d4 :  std_logic;
signal r_35 :  std_logic_vector(60 downto 0);
signal pm_div_36 :  std_logic_vector(60 downto 0);
signal n_36 :  std_logic_vector(60 downto 0);
signal rem_z_35 :  std_logic;
signal z_36 :  std_logic;
signal s_37, s_37_d1, s_37_d2, s_37_d3, s_37_d4 :  std_logic;
signal r_36 :  std_logic_vector(60 downto 0);
signal pm_div_37 :  std_logic_vector(60 downto 0);
signal n_37 :  std_logic_vector(60 downto 0);
signal rem_z_36 :  std_logic;
signal z_37 :  std_logic;
signal s_38, s_38_d1, s_38_d2, s_38_d3, s_38_d4 :  std_logic;
signal r_37 :  std_logic_vector(60 downto 0);
signal pm_div_38 :  std_logic_vector(60 downto 0);
signal n_38 :  std_logic_vector(60 downto 0);
signal rem_z_37 :  std_logic;
signal z_38, z_38_d1 :  std_logic;
signal s_39, s_39_d1, s_39_d2, s_39_d3, s_39_d4 :  std_logic;
signal r_38 :  std_logic_vector(60 downto 0);
signal pm_div_39 :  std_logic_vector(60 downto 0);
signal n_39 :  std_logic_vector(60 downto 0);
signal rem_z_38, rem_z_38_d1 :  std_logic;
signal z_39 :  std_logic;
signal s_40, s_40_d1, s_40_d2, s_40_d3, s_40_d4 :  std_logic;
signal r_39 :  std_logic_vector(60 downto 0);
signal pm_div_40 :  std_logic_vector(60 downto 0);
signal n_40 :  std_logic_vector(60 downto 0);
signal rem_z_39 :  std_logic;
signal z_40 :  std_logic;
signal s_41, s_41_d1, s_41_d2, s_41_d3 :  std_logic;
signal r_40 :  std_logic_vector(60 downto 0);
signal pm_div_41 :  std_logic_vector(60 downto 0);
signal n_41 :  std_logic_vector(60 downto 0);
signal rem_z_40 :  std_logic;
signal z_41 :  std_logic;
signal s_42, s_42_d1, s_42_d2, s_42_d3 :  std_logic;
signal r_41 :  std_logic_vector(60 downto 0);
signal pm_div_42 :  std_logic_vector(60 downto 0);
signal n_42 :  std_logic_vector(60 downto 0);
signal rem_z_41 :  std_logic;
signal z_42 :  std_logic;
signal s_43, s_43_d1, s_43_d2, s_43_d3 :  std_logic;
signal r_42 :  std_logic_vector(60 downto 0);
signal pm_div_43 :  std_logic_vector(60 downto 0);
signal n_43 :  std_logic_vector(60 downto 0);
signal rem_z_42 :  std_logic;
signal z_43 :  std_logic;
signal s_44, s_44_d1, s_44_d2, s_44_d3 :  std_logic;
signal r_43 :  std_logic_vector(60 downto 0);
signal pm_div_44 :  std_logic_vector(60 downto 0);
signal n_44 :  std_logic_vector(60 downto 0);
signal rem_z_43 :  std_logic;
signal z_44 :  std_logic;
signal s_45, s_45_d1, s_45_d2, s_45_d3 :  std_logic;
signal r_44 :  std_logic_vector(60 downto 0);
signal pm_div_45 :  std_logic_vector(60 downto 0);
signal n_45 :  std_logic_vector(60 downto 0);
signal rem_z_44 :  std_logic;
signal z_45, z_45_d1 :  std_logic;
signal s_46, s_46_d1, s_46_d2, s_46_d3 :  std_logic;
signal r_45 :  std_logic_vector(60 downto 0);
signal pm_div_46 :  std_logic_vector(60 downto 0);
signal n_46 :  std_logic_vector(60 downto 0);
signal rem_z_45, rem_z_45_d1 :  std_logic;
signal z_46 :  std_logic;
signal s_47, s_47_d1, s_47_d2, s_47_d3 :  std_logic;
signal r_46 :  std_logic_vector(60 downto 0);
signal pm_div_47 :  std_logic_vector(60 downto 0);
signal n_47 :  std_logic_vector(60 downto 0);
signal rem_z_46 :  std_logic;
signal z_47 :  std_logic;
signal s_48, s_48_d1, s_48_d2 :  std_logic;
signal r_47 :  std_logic_vector(60 downto 0);
signal pm_div_48 :  std_logic_vector(60 downto 0);
signal n_48 :  std_logic_vector(60 downto 0);
signal rem_z_47 :  std_logic;
signal z_48 :  std_logic;
signal s_49, s_49_d1, s_49_d2 :  std_logic;
signal r_48 :  std_logic_vector(60 downto 0);
signal pm_div_49 :  std_logic_vector(60 downto 0);
signal n_49 :  std_logic_vector(60 downto 0);
signal rem_z_48 :  std_logic;
signal z_49 :  std_logic;
signal s_50, s_50_d1, s_50_d2 :  std_logic;
signal r_49 :  std_logic_vector(60 downto 0);
signal pm_div_50 :  std_logic_vector(60 downto 0);
signal n_50 :  std_logic_vector(60 downto 0);
signal rem_z_49 :  std_logic;
signal z_50 :  std_logic;
signal s_51, s_51_d1, s_51_d2 :  std_logic;
signal r_50 :  std_logic_vector(60 downto 0);
signal pm_div_51 :  std_logic_vector(60 downto 0);
signal n_51 :  std_logic_vector(60 downto 0);
signal rem_z_50 :  std_logic;
signal z_51 :  std_logic;
signal s_52, s_52_d1, s_52_d2 :  std_logic;
signal r_51 :  std_logic_vector(60 downto 0);
signal pm_div_52 :  std_logic_vector(60 downto 0);
signal n_52 :  std_logic_vector(60 downto 0);
signal rem_z_51 :  std_logic;
signal z_52, z_52_d1 :  std_logic;
signal s_53, s_53_d1, s_53_d2 :  std_logic;
signal r_52 :  std_logic_vector(60 downto 0);
signal pm_div_53 :  std_logic_vector(60 downto 0);
signal n_53 :  std_logic_vector(60 downto 0);
signal rem_z_52, rem_z_52_d1 :  std_logic;
signal z_53 :  std_logic;
signal s_54, s_54_d1, s_54_d2 :  std_logic;
signal r_53 :  std_logic_vector(60 downto 0);
signal pm_div_54 :  std_logic_vector(60 downto 0);
signal n_54 :  std_logic_vector(60 downto 0);
signal rem_z_53 :  std_logic;
signal z_54 :  std_logic;
signal s_55, s_55_d1 :  std_logic;
signal r_54 :  std_logic_vector(60 downto 0);
signal pm_div_55 :  std_logic_vector(60 downto 0);
signal n_55 :  std_logic_vector(60 downto 0);
signal rem_z_54 :  std_logic;
signal z_55 :  std_logic;
signal s_56, s_56_d1 :  std_logic;
signal r_55 :  std_logic_vector(60 downto 0);
signal pm_div_56 :  std_logic_vector(60 downto 0);
signal n_56 :  std_logic_vector(60 downto 0);
signal rem_z_55 :  std_logic;
signal z_56 :  std_logic;
signal s_57, s_57_d1 :  std_logic;
signal r_56 :  std_logic_vector(60 downto 0);
signal pm_div_57 :  std_logic_vector(60 downto 0);
signal n_57 :  std_logic_vector(60 downto 0);
signal rem_z_56 :  std_logic;
signal z_57 :  std_logic;
signal s_58, s_58_d1 :  std_logic;
signal r_57 :  std_logic_vector(60 downto 0);
signal pm_div_58 :  std_logic_vector(60 downto 0);
signal n_58 :  std_logic_vector(60 downto 0);
signal rem_z_57 :  std_logic;
signal z_58 :  std_logic;
signal s_59, s_59_d1 :  std_logic;
signal r_58 :  std_logic_vector(60 downto 0);
signal pm_div_59 :  std_logic_vector(60 downto 0);
signal n_59 :  std_logic_vector(60 downto 0);
signal rem_z_58 :  std_logic;
signal z_59, z_59_d1 :  std_logic;
signal s_60, s_60_d1 :  std_logic;
signal r_59 :  std_logic_vector(60 downto 0);
signal pm_div_60 :  std_logic_vector(60 downto 0);
signal n_60 :  std_logic_vector(60 downto 0);
signal rem_z_59, rem_z_59_d1 :  std_logic;
signal z_60 :  std_logic;
signal s_61, s_61_d1 :  std_logic;
signal r_60 :  std_logic_vector(60 downto 0);
signal pm_div_61 :  std_logic_vector(60 downto 0);
signal n_61 :  std_logic_vector(60 downto 0);
signal rem_z_60 :  std_logic;
signal z_61 :  std_logic;
signal s_62 :  std_logic;
signal r_61 :  std_logic_vector(60 downto 0);
signal pm_div_62 :  std_logic_vector(60 downto 0);
signal n_62 :  std_logic_vector(60 downto 0);
signal rem_z_61 :  std_logic;
signal z_62 :  std_logic;
signal s_63 :  std_logic;
signal r_62 :  std_logic_vector(60 downto 0);
signal pm_div_63 :  std_logic_vector(60 downto 0);
signal n_63 :  std_logic_vector(60 downto 0);
signal rem_z_62 :  std_logic;
signal z_63 :  std_logic;
signal q_1 :  std_logic_vector(64 downto 0);
signal q_2 :  std_logic_vector(64 downto 0);
signal quotient_tmp :  std_logic_vector(64 downto 0);
signal rem_sign :  std_logic;
signal rem_div_sign :  std_logic;
signal rem_dvr_sign :  std_logic;
signal div_div_sign, div_div_sign_d1, div_div_sign_d2, div_div_sign_d3, div_div_sign_d4, div_div_sign_d5, div_div_sign_d6, div_div_sign_d7, div_div_sign_d8, div_div_sign_d9 :  std_logic;
signal interm_zero_rem :  std_logic;
signal q_config :  std_logic_vector(4 downto 0);
signal zz :  std_logic;
signal sub_add_ulp :  std_logic_vector(64 downto 0);
signal quotient_aux :  std_logic_vector(64 downto 0);
signal quotient :  std_logic_vector(63 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            corner_case_d1 <=  corner_case;
            corner_case_d2 <=  corner_case_d1;
            corner_case_d3 <=  corner_case_d2;
            corner_case_d4 <=  corner_case_d3;
            corner_case_d5 <=  corner_case_d4;
            corner_case_d6 <=  corner_case_d5;
            corner_case_d7 <=  corner_case_d6;
            corner_case_d8 <=  corner_case_d7;
            corner_case_d9 <=  corner_case_d8;
            X_sign_d1 <=  X_sign;
            X_sign_d2 <=  X_sign_d1;
            X_sign_d3 <=  X_sign_d2;
            X_sign_d4 <=  X_sign_d3;
            X_sign_d5 <=  X_sign_d4;
            X_sign_d6 <=  X_sign_d5;
            X_sign_d7 <=  X_sign_d6;
            X_sign_d8 <=  X_sign_d7;
            X_sign_d9 <=  X_sign_d8;
            div_d1 <=  div;
            div_d2 <=  div_d1;
            div_d3 <=  div_d2;
            div_d4 <=  div_d3;
            div_d5 <=  div_d4;
            div_d6 <=  div_d5;
            div_d7 <=  div_d6;
            div_d8 <=  div_d7;
            div_d9 <=  div_d8;
            div_sign_d1 <=  div_sign;
            div_sign_d2 <=  div_sign_d1;
            div_sign_d3 <=  div_sign_d2;
            div_sign_d4 <=  div_sign_d3;
            div_sign_d5 <=  div_sign_d4;
            div_sign_d6 <=  div_sign_d5;
            div_sign_d7 <=  div_sign_d6;
            div_sign_d8 <=  div_sign_d7;
            div_sign_d9 <=  div_sign_d8;
            div_gr_d1 <=  div_gr;
            div_gr_d2 <=  div_gr_d1;
            div_gr_d3 <=  div_gr_d2;
            div_gr_d4 <=  div_gr_d3;
            div_gr_d5 <=  div_gr_d4;
            div_gr_d6 <=  div_gr_d5;
            div_gr_d7 <=  div_gr_d6;
            div_gr_d8 <=  div_gr_d7;
            div_gr_d9 <=  div_gr_d8;
            neg_div_d1 <=  neg_div;
            neg_div_d2 <=  neg_div_d1;
            neg_div_d3 <=  neg_div_d2;
            neg_div_d4 <=  neg_div_d3;
            neg_div_d5 <=  neg_div_d4;
            neg_div_d6 <=  neg_div_d5;
            neg_div_d7 <=  neg_div_d6;
            neg_div_d8 <=  neg_div_d7;
            neg_div_d9 <=  neg_div_d8;
            s_1_d1 <=  s_1;
            s_1_d2 <=  s_1_d1;
            s_1_d3 <=  s_1_d2;
            s_1_d4 <=  s_1_d3;
            s_1_d5 <=  s_1_d4;
            s_1_d6 <=  s_1_d5;
            s_1_d7 <=  s_1_d6;
            s_1_d8 <=  s_1_d7;
            s_1_d9 <=  s_1_d8;
            s_2_d1 <=  s_2;
            s_2_d2 <=  s_2_d1;
            s_2_d3 <=  s_2_d2;
            s_2_d4 <=  s_2_d3;
            s_2_d5 <=  s_2_d4;
            s_2_d6 <=  s_2_d5;
            s_2_d7 <=  s_2_d6;
            s_2_d8 <=  s_2_d7;
            s_2_d9 <=  s_2_d8;
            s_3_d1 <=  s_3;
            s_3_d2 <=  s_3_d1;
            s_3_d3 <=  s_3_d2;
            s_3_d4 <=  s_3_d3;
            s_3_d5 <=  s_3_d4;
            s_3_d6 <=  s_3_d5;
            s_3_d7 <=  s_3_d6;
            s_3_d8 <=  s_3_d7;
            s_3_d9 <=  s_3_d8;
            z_3_d1 <=  z_3;
            s_4_d1 <=  s_4;
            s_4_d2 <=  s_4_d1;
            s_4_d3 <=  s_4_d2;
            s_4_d4 <=  s_4_d3;
            s_4_d5 <=  s_4_d4;
            s_4_d6 <=  s_4_d5;
            s_4_d7 <=  s_4_d6;
            s_4_d8 <=  s_4_d7;
            s_4_d9 <=  s_4_d8;
            n_4_d1 <=  n_4;
            s_5_d1 <=  s_5;
            s_5_d2 <=  s_5_d1;
            s_5_d3 <=  s_5_d2;
            s_5_d4 <=  s_5_d3;
            s_5_d5 <=  s_5_d4;
            s_5_d6 <=  s_5_d5;
            s_5_d7 <=  s_5_d6;
            s_5_d8 <=  s_5_d7;
            s_6_d1 <=  s_6;
            s_6_d2 <=  s_6_d1;
            s_6_d3 <=  s_6_d2;
            s_6_d4 <=  s_6_d3;
            s_6_d5 <=  s_6_d4;
            s_6_d6 <=  s_6_d5;
            s_6_d7 <=  s_6_d6;
            s_6_d8 <=  s_6_d7;
            s_7_d1 <=  s_7;
            s_7_d2 <=  s_7_d1;
            s_7_d3 <=  s_7_d2;
            s_7_d4 <=  s_7_d3;
            s_7_d5 <=  s_7_d4;
            s_7_d6 <=  s_7_d5;
            s_7_d7 <=  s_7_d6;
            s_7_d8 <=  s_7_d7;
            s_8_d1 <=  s_8;
            s_8_d2 <=  s_8_d1;
            s_8_d3 <=  s_8_d2;
            s_8_d4 <=  s_8_d3;
            s_8_d5 <=  s_8_d4;
            s_8_d6 <=  s_8_d5;
            s_8_d7 <=  s_8_d6;
            s_8_d8 <=  s_8_d7;
            s_9_d1 <=  s_9;
            s_9_d2 <=  s_9_d1;
            s_9_d3 <=  s_9_d2;
            s_9_d4 <=  s_9_d3;
            s_9_d5 <=  s_9_d4;
            s_9_d6 <=  s_9_d5;
            s_9_d7 <=  s_9_d6;
            s_9_d8 <=  s_9_d7;
            s_10_d1 <=  s_10;
            s_10_d2 <=  s_10_d1;
            s_10_d3 <=  s_10_d2;
            s_10_d4 <=  s_10_d3;
            s_10_d5 <=  s_10_d4;
            s_10_d6 <=  s_10_d5;
            s_10_d7 <=  s_10_d6;
            s_10_d8 <=  s_10_d7;
            z_10_d1 <=  z_10;
            s_11_d1 <=  s_11;
            s_11_d2 <=  s_11_d1;
            s_11_d3 <=  s_11_d2;
            s_11_d4 <=  s_11_d3;
            s_11_d5 <=  s_11_d4;
            s_11_d6 <=  s_11_d5;
            s_11_d7 <=  s_11_d6;
            s_11_d8 <=  s_11_d7;
            n_11_d1 <=  n_11;
            s_12_d1 <=  s_12;
            s_12_d2 <=  s_12_d1;
            s_12_d3 <=  s_12_d2;
            s_12_d4 <=  s_12_d3;
            s_12_d5 <=  s_12_d4;
            s_12_d6 <=  s_12_d5;
            s_12_d7 <=  s_12_d6;
            s_12_d8 <=  s_12_d7;
            s_13_d1 <=  s_13;
            s_13_d2 <=  s_13_d1;
            s_13_d3 <=  s_13_d2;
            s_13_d4 <=  s_13_d3;
            s_13_d5 <=  s_13_d4;
            s_13_d6 <=  s_13_d5;
            s_13_d7 <=  s_13_d6;
            s_14_d1 <=  s_14;
            s_14_d2 <=  s_14_d1;
            s_14_d3 <=  s_14_d2;
            s_14_d4 <=  s_14_d3;
            s_14_d5 <=  s_14_d4;
            s_14_d6 <=  s_14_d5;
            s_14_d7 <=  s_14_d6;
            s_15_d1 <=  s_15;
            s_15_d2 <=  s_15_d1;
            s_15_d3 <=  s_15_d2;
            s_15_d4 <=  s_15_d3;
            s_15_d5 <=  s_15_d4;
            s_15_d6 <=  s_15_d5;
            s_15_d7 <=  s_15_d6;
            s_16_d1 <=  s_16;
            s_16_d2 <=  s_16_d1;
            s_16_d3 <=  s_16_d2;
            s_16_d4 <=  s_16_d3;
            s_16_d5 <=  s_16_d4;
            s_16_d6 <=  s_16_d5;
            s_16_d7 <=  s_16_d6;
            s_17_d1 <=  s_17;
            s_17_d2 <=  s_17_d1;
            s_17_d3 <=  s_17_d2;
            s_17_d4 <=  s_17_d3;
            s_17_d5 <=  s_17_d4;
            s_17_d6 <=  s_17_d5;
            s_17_d7 <=  s_17_d6;
            z_17_d1 <=  z_17;
            s_18_d1 <=  s_18;
            s_18_d2 <=  s_18_d1;
            s_18_d3 <=  s_18_d2;
            s_18_d4 <=  s_18_d3;
            s_18_d5 <=  s_18_d4;
            s_18_d6 <=  s_18_d5;
            s_18_d7 <=  s_18_d6;
            n_18_d1 <=  n_18;
            s_19_d1 <=  s_19;
            s_19_d2 <=  s_19_d1;
            s_19_d3 <=  s_19_d2;
            s_19_d4 <=  s_19_d3;
            s_19_d5 <=  s_19_d4;
            s_19_d6 <=  s_19_d5;
            s_19_d7 <=  s_19_d6;
            s_20_d1 <=  s_20;
            s_20_d2 <=  s_20_d1;
            s_20_d3 <=  s_20_d2;
            s_20_d4 <=  s_20_d3;
            s_20_d5 <=  s_20_d4;
            s_20_d6 <=  s_20_d5;
            s_21_d1 <=  s_21;
            s_21_d2 <=  s_21_d1;
            s_21_d3 <=  s_21_d2;
            s_21_d4 <=  s_21_d3;
            s_21_d5 <=  s_21_d4;
            s_21_d6 <=  s_21_d5;
            s_22_d1 <=  s_22;
            s_22_d2 <=  s_22_d1;
            s_22_d3 <=  s_22_d2;
            s_22_d4 <=  s_22_d3;
            s_22_d5 <=  s_22_d4;
            s_22_d6 <=  s_22_d5;
            s_23_d1 <=  s_23;
            s_23_d2 <=  s_23_d1;
            s_23_d3 <=  s_23_d2;
            s_23_d4 <=  s_23_d3;
            s_23_d5 <=  s_23_d4;
            s_23_d6 <=  s_23_d5;
            s_24_d1 <=  s_24;
            s_24_d2 <=  s_24_d1;
            s_24_d3 <=  s_24_d2;
            s_24_d4 <=  s_24_d3;
            s_24_d5 <=  s_24_d4;
            s_24_d6 <=  s_24_d5;
            z_24_d1 <=  z_24;
            s_25_d1 <=  s_25;
            s_25_d2 <=  s_25_d1;
            s_25_d3 <=  s_25_d2;
            s_25_d4 <=  s_25_d3;
            s_25_d5 <=  s_25_d4;
            s_25_d6 <=  s_25_d5;
            rem_z_24_d1 <=  rem_z_24;
            s_26_d1 <=  s_26;
            s_26_d2 <=  s_26_d1;
            s_26_d3 <=  s_26_d2;
            s_26_d4 <=  s_26_d3;
            s_26_d5 <=  s_26_d4;
            s_26_d6 <=  s_26_d5;
            s_27_d1 <=  s_27;
            s_27_d2 <=  s_27_d1;
            s_27_d3 <=  s_27_d2;
            s_27_d4 <=  s_27_d3;
            s_27_d5 <=  s_27_d4;
            s_28_d1 <=  s_28;
            s_28_d2 <=  s_28_d1;
            s_28_d3 <=  s_28_d2;
            s_28_d4 <=  s_28_d3;
            s_28_d5 <=  s_28_d4;
            s_29_d1 <=  s_29;
            s_29_d2 <=  s_29_d1;
            s_29_d3 <=  s_29_d2;
            s_29_d4 <=  s_29_d3;
            s_29_d5 <=  s_29_d4;
            s_30_d1 <=  s_30;
            s_30_d2 <=  s_30_d1;
            s_30_d3 <=  s_30_d2;
            s_30_d4 <=  s_30_d3;
            s_30_d5 <=  s_30_d4;
            s_31_d1 <=  s_31;
            s_31_d2 <=  s_31_d1;
            s_31_d3 <=  s_31_d2;
            s_31_d4 <=  s_31_d3;
            s_31_d5 <=  s_31_d4;
            z_31_d1 <=  z_31;
            s_32_d1 <=  s_32;
            s_32_d2 <=  s_32_d1;
            s_32_d3 <=  s_32_d2;
            s_32_d4 <=  s_32_d3;
            s_32_d5 <=  s_32_d4;
            rem_z_31_d1 <=  rem_z_31;
            s_33_d1 <=  s_33;
            s_33_d2 <=  s_33_d1;
            s_33_d3 <=  s_33_d2;
            s_33_d4 <=  s_33_d3;
            s_33_d5 <=  s_33_d4;
            s_34_d1 <=  s_34;
            s_34_d2 <=  s_34_d1;
            s_34_d3 <=  s_34_d2;
            s_34_d4 <=  s_34_d3;
            s_35_d1 <=  s_35;
            s_35_d2 <=  s_35_d1;
            s_35_d3 <=  s_35_d2;
            s_35_d4 <=  s_35_d3;
            s_36_d1 <=  s_36;
            s_36_d2 <=  s_36_d1;
            s_36_d3 <=  s_36_d2;
            s_36_d4 <=  s_36_d3;
            s_37_d1 <=  s_37;
            s_37_d2 <=  s_37_d1;
            s_37_d3 <=  s_37_d2;
            s_37_d4 <=  s_37_d3;
            s_38_d1 <=  s_38;
            s_38_d2 <=  s_38_d1;
            s_38_d3 <=  s_38_d2;
            s_38_d4 <=  s_38_d3;
            z_38_d1 <=  z_38;
            s_39_d1 <=  s_39;
            s_39_d2 <=  s_39_d1;
            s_39_d3 <=  s_39_d2;
            s_39_d4 <=  s_39_d3;
            rem_z_38_d1 <=  rem_z_38;
            s_40_d1 <=  s_40;
            s_40_d2 <=  s_40_d1;
            s_40_d3 <=  s_40_d2;
            s_40_d4 <=  s_40_d3;
            s_41_d1 <=  s_41;
            s_41_d2 <=  s_41_d1;
            s_41_d3 <=  s_41_d2;
            s_42_d1 <=  s_42;
            s_42_d2 <=  s_42_d1;
            s_42_d3 <=  s_42_d2;
            s_43_d1 <=  s_43;
            s_43_d2 <=  s_43_d1;
            s_43_d3 <=  s_43_d2;
            s_44_d1 <=  s_44;
            s_44_d2 <=  s_44_d1;
            s_44_d3 <=  s_44_d2;
            s_45_d1 <=  s_45;
            s_45_d2 <=  s_45_d1;
            s_45_d3 <=  s_45_d2;
            z_45_d1 <=  z_45;
            s_46_d1 <=  s_46;
            s_46_d2 <=  s_46_d1;
            s_46_d3 <=  s_46_d2;
            rem_z_45_d1 <=  rem_z_45;
            s_47_d1 <=  s_47;
            s_47_d2 <=  s_47_d1;
            s_47_d3 <=  s_47_d2;
            s_48_d1 <=  s_48;
            s_48_d2 <=  s_48_d1;
            s_49_d1 <=  s_49;
            s_49_d2 <=  s_49_d1;
            s_50_d1 <=  s_50;
            s_50_d2 <=  s_50_d1;
            s_51_d1 <=  s_51;
            s_51_d2 <=  s_51_d1;
            s_52_d1 <=  s_52;
            s_52_d2 <=  s_52_d1;
            z_52_d1 <=  z_52;
            s_53_d1 <=  s_53;
            s_53_d2 <=  s_53_d1;
            rem_z_52_d1 <=  rem_z_52;
            s_54_d1 <=  s_54;
            s_54_d2 <=  s_54_d1;
            s_55_d1 <=  s_55;
            s_56_d1 <=  s_56;
            s_57_d1 <=  s_57;
            s_58_d1 <=  s_58;
            s_59_d1 <=  s_59;
            z_59_d1 <=  z_59;
            s_60_d1 <=  s_60;
            rem_z_59_d1 <=  rem_z_59;
            s_61_d1 <=  s_61;
            div_div_sign_d1 <=  div_div_sign;
            div_div_sign_d2 <=  div_div_sign_d1;
            div_div_sign_d3 <=  div_div_sign_d2;
            div_div_sign_d4 <=  div_div_sign_d3;
            div_div_sign_d5 <=  div_div_sign_d4;
            div_div_sign_d6 <=  div_div_sign_d5;
            div_div_sign_d7 <=  div_div_sign_d6;
            div_div_sign_d8 <=  div_div_sign_d7;
            div_div_sign_d9 <=  div_div_sign_d8;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
----------------------- Non-Restoring Division algorithm -----------------------
   X_minus_two <= '1' when X = "1000000000000000000000000000000000000000000000000000000000000" else '0';
   Y_plus_one <= '1' when Y = "0100000000000000000000000000000000000000000000000000000000000" else '0';
   corner_case <= X_minus_two AND Y_plus_one;
   X_sign <= X(60);
   div <= Y;
   div_sign <= Y(60);
   diff_signs <= X_sign XOR div_sign;
   div_ge_tmp <= '1' when Y(59 downto 0) > X(59 downto 0) else '0';
   div_gr <= '0';
   n_0 <= X when div_gr='1' else (X(60) & X(60 downto 1));
   append_0 <= '0' when div_gr='1' else X(0);
   neg_div <= NOT(Y);
   one_bit <= '1' ;
   -- Iteration 1
   s_1 <= NOT(n_0(60) XOR div_sign);
   r_0 <= n_0(59 downto 0) & append_0;
   pm_div_1 <= div when s_1='0' else neg_div;
   sub_0: IntAdder_61_F50_uid14
      port map ( clk  => clk,
                 Cin => s_1,
                 X => r_0,
                 Y => pm_div_1,
                 R => n_1);
   rem_z_0 <= '1' when n_1 = 0 else '0';
   z_1 <= rem_z_0;
   -- Iteration 2
   s_2 <= NOT(n_1(60) XOR div_sign);
   r_1 <= n_1(59 downto 0) & '0';
   pm_div_2 <= div when s_2='0' else neg_div;
   sub_1: IntAdder_61_F50_uid16
      port map ( clk  => clk,
                 Cin => s_2,
                 X => r_1,
                 Y => pm_div_2,
                 R => n_2);
   rem_z_1 <= '1' when n_2 = 0 else '0';
   z_2 <= rem_z_1 OR z_1;
   -- Iteration 3
   s_3 <= NOT(n_2(60) XOR div_sign);
   r_2 <= n_2(59 downto 0) & '0';
   pm_div_3 <= div when s_3='0' else neg_div;
   sub_2: IntAdder_61_F50_uid18
      port map ( clk  => clk,
                 Cin => s_3,
                 X => r_2,
                 Y => pm_div_3,
                 R => n_3);
   rem_z_2 <= '1' when n_3 = 0 else '0';
   z_3 <= rem_z_2 OR z_2;
   -- Iteration 4
   s_4 <= NOT(n_3(60) XOR div_sign);
   r_3 <= n_3(59 downto 0) & '0';
   pm_div_4 <= div when s_4='0' else neg_div;
   sub_3: IntAdder_61_F50_uid20
      port map ( clk  => clk,
                 Cin => s_4,
                 X => r_3,
                 Y => pm_div_4,
                 R => n_4);
   rem_z_3 <= '1' when n_4_d1 = 0 else '0';
   z_4 <= rem_z_3 OR z_3_d1;
   -- Iteration 5
   s_5 <= NOT(n_4_d1(60) XOR div_sign_d1);
   r_4 <= n_4(59 downto 0) & '0';
   pm_div_5 <= div_d1 when s_5='0' else neg_div_d1;
   sub_4: IntAdder_61_F50_uid22
      port map ( clk  => clk,
                 Cin => s_5,
                 X => r_4,
                 Y => pm_div_5,
                 R => n_5);
   rem_z_4 <= '1' when n_5 = 0 else '0';
   z_5 <= rem_z_4 OR z_4;
   -- Iteration 6
   s_6 <= NOT(n_5(60) XOR div_sign_d1);
   r_5 <= n_5(59 downto 0) & '0';
   pm_div_6 <= div_d1 when s_6='0' else neg_div_d1;
   sub_5: IntAdder_61_F50_uid24
      port map ( clk  => clk,
                 Cin => s_6,
                 X => r_5,
                 Y => pm_div_6,
                 R => n_6);
   rem_z_5 <= '1' when n_6 = 0 else '0';
   z_6 <= rem_z_5 OR z_5;
   -- Iteration 7
   s_7 <= NOT(n_6(60) XOR div_sign_d1);
   r_6 <= n_6(59 downto 0) & '0';
   pm_div_7 <= div_d1 when s_7='0' else neg_div_d1;
   sub_6: IntAdder_61_F50_uid26
      port map ( clk  => clk,
                 Cin => s_7,
                 X => r_6,
                 Y => pm_div_7,
                 R => n_7);
   rem_z_6 <= '1' when n_7 = 0 else '0';
   z_7 <= rem_z_6 OR z_6;
   -- Iteration 8
   s_8 <= NOT(n_7(60) XOR div_sign_d1);
   r_7 <= n_7(59 downto 0) & '0';
   pm_div_8 <= div_d1 when s_8='0' else neg_div_d1;
   sub_7: IntAdder_61_F50_uid28
      port map ( clk  => clk,
                 Cin => s_8,
                 X => r_7,
                 Y => pm_div_8,
                 R => n_8);
   rem_z_7 <= '1' when n_8 = 0 else '0';
   z_8 <= rem_z_7 OR z_7;
   -- Iteration 9
   s_9 <= NOT(n_8(60) XOR div_sign_d1);
   r_8 <= n_8(59 downto 0) & '0';
   pm_div_9 <= div_d1 when s_9='0' else neg_div_d1;
   sub_8: IntAdder_61_F50_uid30
      port map ( clk  => clk,
                 Cin => s_9,
                 X => r_8,
                 Y => pm_div_9,
                 R => n_9);
   rem_z_8 <= '1' when n_9 = 0 else '0';
   z_9 <= rem_z_8 OR z_8;
   -- Iteration 10
   s_10 <= NOT(n_9(60) XOR div_sign_d1);
   r_9 <= n_9(59 downto 0) & '0';
   pm_div_10 <= div_d1 when s_10='0' else neg_div_d1;
   sub_9: IntAdder_61_F50_uid32
      port map ( clk  => clk,
                 Cin => s_10,
                 X => r_9,
                 Y => pm_div_10,
                 R => n_10);
   rem_z_9 <= '1' when n_10 = 0 else '0';
   z_10 <= rem_z_9 OR z_9;
   -- Iteration 11
   s_11 <= NOT(n_10(60) XOR div_sign_d1);
   r_10 <= n_10(59 downto 0) & '0';
   pm_div_11 <= div_d1 when s_11='0' else neg_div_d1;
   sub_10: IntAdder_61_F50_uid34
      port map ( clk  => clk,
                 Cin => s_11,
                 X => r_10,
                 Y => pm_div_11,
                 R => n_11);
   rem_z_10 <= '1' when n_11_d1 = 0 else '0';
   z_11 <= rem_z_10 OR z_10_d1;
   -- Iteration 12
   s_12 <= NOT(n_11(60) XOR div_sign_d1);
   r_11 <= n_11(59 downto 0) & '0';
   pm_div_12 <= div_d2 when s_12_d1='0' else neg_div_d2;
   sub_11: IntAdder_61_F50_uid36
      port map ( clk  => clk,
                 Cin => s_12,
                 X => r_11,
                 Y => pm_div_12,
                 R => n_12);
   rem_z_11 <= '1' when n_12 = 0 else '0';
   z_12 <= rem_z_11 OR z_11;
   -- Iteration 13
   s_13 <= NOT(n_12(60) XOR div_sign_d2);
   r_12 <= n_12(59 downto 0) & '0';
   pm_div_13 <= div_d2 when s_13='0' else neg_div_d2;
   sub_12: IntAdder_61_F50_uid38
      port map ( clk  => clk,
                 Cin => s_13,
                 X => r_12,
                 Y => pm_div_13,
                 R => n_13);
   rem_z_12 <= '1' when n_13 = 0 else '0';
   z_13 <= rem_z_12 OR z_12;
   -- Iteration 14
   s_14 <= NOT(n_13(60) XOR div_sign_d2);
   r_13 <= n_13(59 downto 0) & '0';
   pm_div_14 <= div_d2 when s_14='0' else neg_div_d2;
   sub_13: IntAdder_61_F50_uid40
      port map ( clk  => clk,
                 Cin => s_14,
                 X => r_13,
                 Y => pm_div_14,
                 R => n_14);
   rem_z_13 <= '1' when n_14 = 0 else '0';
   z_14 <= rem_z_13 OR z_13;
   -- Iteration 15
   s_15 <= NOT(n_14(60) XOR div_sign_d2);
   r_14 <= n_14(59 downto 0) & '0';
   pm_div_15 <= div_d2 when s_15='0' else neg_div_d2;
   sub_14: IntAdder_61_F50_uid42
      port map ( clk  => clk,
                 Cin => s_15,
                 X => r_14,
                 Y => pm_div_15,
                 R => n_15);
   rem_z_14 <= '1' when n_15 = 0 else '0';
   z_15 <= rem_z_14 OR z_14;
   -- Iteration 16
   s_16 <= NOT(n_15(60) XOR div_sign_d2);
   r_15 <= n_15(59 downto 0) & '0';
   pm_div_16 <= div_d2 when s_16='0' else neg_div_d2;
   sub_15: IntAdder_61_F50_uid44
      port map ( clk  => clk,
                 Cin => s_16,
                 X => r_15,
                 Y => pm_div_16,
                 R => n_16);
   rem_z_15 <= '1' when n_16 = 0 else '0';
   z_16 <= rem_z_15 OR z_15;
   -- Iteration 17
   s_17 <= NOT(n_16(60) XOR div_sign_d2);
   r_16 <= n_16(59 downto 0) & '0';
   pm_div_17 <= div_d2 when s_17='0' else neg_div_d2;
   sub_16: IntAdder_61_F50_uid46
      port map ( clk  => clk,
                 Cin => s_17,
                 X => r_16,
                 Y => pm_div_17,
                 R => n_17);
   rem_z_16 <= '1' when n_17 = 0 else '0';
   z_17 <= rem_z_16 OR z_16;
   -- Iteration 18
   s_18 <= NOT(n_17(60) XOR div_sign_d2);
   r_17 <= n_17(59 downto 0) & '0';
   pm_div_18 <= div_d2 when s_18='0' else neg_div_d2;
   sub_17: IntAdder_61_F50_uid48
      port map ( clk  => clk,
                 Cin => s_18,
                 X => r_17,
                 Y => pm_div_18,
                 R => n_18);
   rem_z_17 <= '1' when n_18_d1 = 0 else '0';
   z_18 <= rem_z_17 OR z_17_d1;
   -- Iteration 19
   s_19 <= NOT(n_18(60) XOR div_sign_d2);
   r_18 <= n_18(59 downto 0) & '0';
   pm_div_19 <= div_d3 when s_19_d1='0' else neg_div_d3;
   sub_18: IntAdder_61_F50_uid50
      port map ( clk  => clk,
                 Cin => s_19,
                 X => r_18,
                 Y => pm_div_19,
                 R => n_19);
   rem_z_18 <= '1' when n_19 = 0 else '0';
   z_19 <= rem_z_18 OR z_18;
   -- Iteration 20
   s_20 <= NOT(n_19(60) XOR div_sign_d3);
   r_19 <= n_19(59 downto 0) & '0';
   pm_div_20 <= div_d3 when s_20='0' else neg_div_d3;
   sub_19: IntAdder_61_F50_uid52
      port map ( clk  => clk,
                 Cin => s_20,
                 X => r_19,
                 Y => pm_div_20,
                 R => n_20);
   rem_z_19 <= '1' when n_20 = 0 else '0';
   z_20 <= rem_z_19 OR z_19;
   -- Iteration 21
   s_21 <= NOT(n_20(60) XOR div_sign_d3);
   r_20 <= n_20(59 downto 0) & '0';
   pm_div_21 <= div_d3 when s_21='0' else neg_div_d3;
   sub_20: IntAdder_61_F50_uid54
      port map ( clk  => clk,
                 Cin => s_21,
                 X => r_20,
                 Y => pm_div_21,
                 R => n_21);
   rem_z_20 <= '1' when n_21 = 0 else '0';
   z_21 <= rem_z_20 OR z_20;
   -- Iteration 22
   s_22 <= NOT(n_21(60) XOR div_sign_d3);
   r_21 <= n_21(59 downto 0) & '0';
   pm_div_22 <= div_d3 when s_22='0' else neg_div_d3;
   sub_21: IntAdder_61_F50_uid56
      port map ( clk  => clk,
                 Cin => s_22,
                 X => r_21,
                 Y => pm_div_22,
                 R => n_22);
   rem_z_21 <= '1' when n_22 = 0 else '0';
   z_22 <= rem_z_21 OR z_21;
   -- Iteration 23
   s_23 <= NOT(n_22(60) XOR div_sign_d3);
   r_22 <= n_22(59 downto 0) & '0';
   pm_div_23 <= div_d3 when s_23='0' else neg_div_d3;
   sub_22: IntAdder_61_F50_uid58
      port map ( clk  => clk,
                 Cin => s_23,
                 X => r_22,
                 Y => pm_div_23,
                 R => n_23);
   rem_z_22 <= '1' when n_23 = 0 else '0';
   z_23 <= rem_z_22 OR z_22;
   -- Iteration 24
   s_24 <= NOT(n_23(60) XOR div_sign_d3);
   r_23 <= n_23(59 downto 0) & '0';
   pm_div_24 <= div_d3 when s_24='0' else neg_div_d3;
   sub_23: IntAdder_61_F50_uid60
      port map ( clk  => clk,
                 Cin => s_24,
                 X => r_23,
                 Y => pm_div_24,
                 R => n_24);
   rem_z_23 <= '1' when n_24 = 0 else '0';
   z_24 <= rem_z_23 OR z_23;
   -- Iteration 25
   s_25 <= NOT(n_24(60) XOR div_sign_d3);
   r_24 <= n_24(59 downto 0) & '0';
   pm_div_25 <= div_d3 when s_25='0' else neg_div_d3;
   sub_24: IntAdder_61_F50_uid62
      port map ( clk  => clk,
                 Cin => s_25,
                 X => r_24,
                 Y => pm_div_25,
                 R => n_25);
   rem_z_24 <= '1' when n_25 = 0 else '0';
   z_25 <= rem_z_24_d1 OR z_24_d1;
   -- Iteration 26
   s_26 <= NOT(n_25(60) XOR div_sign_d3);
   r_25 <= n_25(59 downto 0) & '0';
   pm_div_26 <= div_d4 when s_26_d1='0' else neg_div_d4;
   sub_25: IntAdder_61_F50_uid64
      port map ( clk  => clk,
                 Cin => s_26,
                 X => r_25,
                 Y => pm_div_26,
                 R => n_26);
   rem_z_25 <= '1' when n_26 = 0 else '0';
   z_26 <= rem_z_25 OR z_25;
   -- Iteration 27
   s_27 <= NOT(n_26(60) XOR div_sign_d4);
   r_26 <= n_26(59 downto 0) & '0';
   pm_div_27 <= div_d4 when s_27='0' else neg_div_d4;
   sub_26: IntAdder_61_F50_uid66
      port map ( clk  => clk,
                 Cin => s_27,
                 X => r_26,
                 Y => pm_div_27,
                 R => n_27);
   rem_z_26 <= '1' when n_27 = 0 else '0';
   z_27 <= rem_z_26 OR z_26;
   -- Iteration 28
   s_28 <= NOT(n_27(60) XOR div_sign_d4);
   r_27 <= n_27(59 downto 0) & '0';
   pm_div_28 <= div_d4 when s_28='0' else neg_div_d4;
   sub_27: IntAdder_61_F50_uid68
      port map ( clk  => clk,
                 Cin => s_28,
                 X => r_27,
                 Y => pm_div_28,
                 R => n_28);
   rem_z_27 <= '1' when n_28 = 0 else '0';
   z_28 <= rem_z_27 OR z_27;
   -- Iteration 29
   s_29 <= NOT(n_28(60) XOR div_sign_d4);
   r_28 <= n_28(59 downto 0) & '0';
   pm_div_29 <= div_d4 when s_29='0' else neg_div_d4;
   sub_28: IntAdder_61_F50_uid70
      port map ( clk  => clk,
                 Cin => s_29,
                 X => r_28,
                 Y => pm_div_29,
                 R => n_29);
   rem_z_28 <= '1' when n_29 = 0 else '0';
   z_29 <= rem_z_28 OR z_28;
   -- Iteration 30
   s_30 <= NOT(n_29(60) XOR div_sign_d4);
   r_29 <= n_29(59 downto 0) & '0';
   pm_div_30 <= div_d4 when s_30='0' else neg_div_d4;
   sub_29: IntAdder_61_F50_uid72
      port map ( clk  => clk,
                 Cin => s_30,
                 X => r_29,
                 Y => pm_div_30,
                 R => n_30);
   rem_z_29 <= '1' when n_30 = 0 else '0';
   z_30 <= rem_z_29 OR z_29;
   -- Iteration 31
   s_31 <= NOT(n_30(60) XOR div_sign_d4);
   r_30 <= n_30(59 downto 0) & '0';
   pm_div_31 <= div_d4 when s_31='0' else neg_div_d4;
   sub_30: IntAdder_61_F50_uid74
      port map ( clk  => clk,
                 Cin => s_31,
                 X => r_30,
                 Y => pm_div_31,
                 R => n_31);
   rem_z_30 <= '1' when n_31 = 0 else '0';
   z_31 <= rem_z_30 OR z_30;
   -- Iteration 32
   s_32 <= NOT(n_31(60) XOR div_sign_d4);
   r_31 <= n_31(59 downto 0) & '0';
   pm_div_32 <= div_d4 when s_32='0' else neg_div_d4;
   sub_31: IntAdder_61_F50_uid76
      port map ( clk  => clk,
                 Cin => s_32,
                 X => r_31,
                 Y => pm_div_32,
                 R => n_32);
   rem_z_31 <= '1' when n_32 = 0 else '0';
   z_32 <= rem_z_31_d1 OR z_31_d1;
   -- Iteration 33
   s_33 <= NOT(n_32(60) XOR div_sign_d4);
   r_32 <= n_32(59 downto 0) & '0';
   pm_div_33 <= div_d5 when s_33_d1='0' else neg_div_d5;
   sub_32: IntAdder_61_F50_uid78
      port map ( clk  => clk,
                 Cin => s_33,
                 X => r_32,
                 Y => pm_div_33,
                 R => n_33);
   rem_z_32 <= '1' when n_33 = 0 else '0';
   z_33 <= rem_z_32 OR z_32;
   -- Iteration 34
   s_34 <= NOT(n_33(60) XOR div_sign_d5);
   r_33 <= n_33(59 downto 0) & '0';
   pm_div_34 <= div_d5 when s_34='0' else neg_div_d5;
   sub_33: IntAdder_61_F50_uid80
      port map ( clk  => clk,
                 Cin => s_34,
                 X => r_33,
                 Y => pm_div_34,
                 R => n_34);
   rem_z_33 <= '1' when n_34 = 0 else '0';
   z_34 <= rem_z_33 OR z_33;
   -- Iteration 35
   s_35 <= NOT(n_34(60) XOR div_sign_d5);
   r_34 <= n_34(59 downto 0) & '0';
   pm_div_35 <= div_d5 when s_35='0' else neg_div_d5;
   sub_34: IntAdder_61_F50_uid82
      port map ( clk  => clk,
                 Cin => s_35,
                 X => r_34,
                 Y => pm_div_35,
                 R => n_35);
   rem_z_34 <= '1' when n_35 = 0 else '0';
   z_35 <= rem_z_34 OR z_34;
   -- Iteration 36
   s_36 <= NOT(n_35(60) XOR div_sign_d5);
   r_35 <= n_35(59 downto 0) & '0';
   pm_div_36 <= div_d5 when s_36='0' else neg_div_d5;
   sub_35: IntAdder_61_F50_uid84
      port map ( clk  => clk,
                 Cin => s_36,
                 X => r_35,
                 Y => pm_div_36,
                 R => n_36);
   rem_z_35 <= '1' when n_36 = 0 else '0';
   z_36 <= rem_z_35 OR z_35;
   -- Iteration 37
   s_37 <= NOT(n_36(60) XOR div_sign_d5);
   r_36 <= n_36(59 downto 0) & '0';
   pm_div_37 <= div_d5 when s_37='0' else neg_div_d5;
   sub_36: IntAdder_61_F50_uid86
      port map ( clk  => clk,
                 Cin => s_37,
                 X => r_36,
                 Y => pm_div_37,
                 R => n_37);
   rem_z_36 <= '1' when n_37 = 0 else '0';
   z_37 <= rem_z_36 OR z_36;
   -- Iteration 38
   s_38 <= NOT(n_37(60) XOR div_sign_d5);
   r_37 <= n_37(59 downto 0) & '0';
   pm_div_38 <= div_d5 when s_38='0' else neg_div_d5;
   sub_37: IntAdder_61_F50_uid88
      port map ( clk  => clk,
                 Cin => s_38,
                 X => r_37,
                 Y => pm_div_38,
                 R => n_38);
   rem_z_37 <= '1' when n_38 = 0 else '0';
   z_38 <= rem_z_37 OR z_37;
   -- Iteration 39
   s_39 <= NOT(n_38(60) XOR div_sign_d5);
   r_38 <= n_38(59 downto 0) & '0';
   pm_div_39 <= div_d5 when s_39='0' else neg_div_d5;
   sub_38: IntAdder_61_F50_uid90
      port map ( clk  => clk,
                 Cin => s_39,
                 X => r_38,
                 Y => pm_div_39,
                 R => n_39);
   rem_z_38 <= '1' when n_39 = 0 else '0';
   z_39 <= rem_z_38_d1 OR z_38_d1;
   -- Iteration 40
   s_40 <= NOT(n_39(60) XOR div_sign_d5);
   r_39 <= n_39(59 downto 0) & '0';
   pm_div_40 <= div_d6 when s_40_d1='0' else neg_div_d6;
   sub_39: IntAdder_61_F50_uid92
      port map ( clk  => clk,
                 Cin => s_40,
                 X => r_39,
                 Y => pm_div_40,
                 R => n_40);
   rem_z_39 <= '1' when n_40 = 0 else '0';
   z_40 <= rem_z_39 OR z_39;
   -- Iteration 41
   s_41 <= NOT(n_40(60) XOR div_sign_d6);
   r_40 <= n_40(59 downto 0) & '0';
   pm_div_41 <= div_d6 when s_41='0' else neg_div_d6;
   sub_40: IntAdder_61_F50_uid94
      port map ( clk  => clk,
                 Cin => s_41,
                 X => r_40,
                 Y => pm_div_41,
                 R => n_41);
   rem_z_40 <= '1' when n_41 = 0 else '0';
   z_41 <= rem_z_40 OR z_40;
   -- Iteration 42
   s_42 <= NOT(n_41(60) XOR div_sign_d6);
   r_41 <= n_41(59 downto 0) & '0';
   pm_div_42 <= div_d6 when s_42='0' else neg_div_d6;
   sub_41: IntAdder_61_F50_uid96
      port map ( clk  => clk,
                 Cin => s_42,
                 X => r_41,
                 Y => pm_div_42,
                 R => n_42);
   rem_z_41 <= '1' when n_42 = 0 else '0';
   z_42 <= rem_z_41 OR z_41;
   -- Iteration 43
   s_43 <= NOT(n_42(60) XOR div_sign_d6);
   r_42 <= n_42(59 downto 0) & '0';
   pm_div_43 <= div_d6 when s_43='0' else neg_div_d6;
   sub_42: IntAdder_61_F50_uid98
      port map ( clk  => clk,
                 Cin => s_43,
                 X => r_42,
                 Y => pm_div_43,
                 R => n_43);
   rem_z_42 <= '1' when n_43 = 0 else '0';
   z_43 <= rem_z_42 OR z_42;
   -- Iteration 44
   s_44 <= NOT(n_43(60) XOR div_sign_d6);
   r_43 <= n_43(59 downto 0) & '0';
   pm_div_44 <= div_d6 when s_44='0' else neg_div_d6;
   sub_43: IntAdder_61_F50_uid100
      port map ( clk  => clk,
                 Cin => s_44,
                 X => r_43,
                 Y => pm_div_44,
                 R => n_44);
   rem_z_43 <= '1' when n_44 = 0 else '0';
   z_44 <= rem_z_43 OR z_43;
   -- Iteration 45
   s_45 <= NOT(n_44(60) XOR div_sign_d6);
   r_44 <= n_44(59 downto 0) & '0';
   pm_div_45 <= div_d6 when s_45='0' else neg_div_d6;
   sub_44: IntAdder_61_F50_uid102
      port map ( clk  => clk,
                 Cin => s_45,
                 X => r_44,
                 Y => pm_div_45,
                 R => n_45);
   rem_z_44 <= '1' when n_45 = 0 else '0';
   z_45 <= rem_z_44 OR z_44;
   -- Iteration 46
   s_46 <= NOT(n_45(60) XOR div_sign_d6);
   r_45 <= n_45(59 downto 0) & '0';
   pm_div_46 <= div_d6 when s_46='0' else neg_div_d6;
   sub_45: IntAdder_61_F50_uid104
      port map ( clk  => clk,
                 Cin => s_46,
                 X => r_45,
                 Y => pm_div_46,
                 R => n_46);
   rem_z_45 <= '1' when n_46 = 0 else '0';
   z_46 <= rem_z_45_d1 OR z_45_d1;
   -- Iteration 47
   s_47 <= NOT(n_46(60) XOR div_sign_d6);
   r_46 <= n_46(59 downto 0) & '0';
   pm_div_47 <= div_d7 when s_47_d1='0' else neg_div_d7;
   sub_46: IntAdder_61_F50_uid106
      port map ( clk  => clk,
                 Cin => s_47,
                 X => r_46,
                 Y => pm_div_47,
                 R => n_47);
   rem_z_46 <= '1' when n_47 = 0 else '0';
   z_47 <= rem_z_46 OR z_46;
   -- Iteration 48
   s_48 <= NOT(n_47(60) XOR div_sign_d7);
   r_47 <= n_47(59 downto 0) & '0';
   pm_div_48 <= div_d7 when s_48='0' else neg_div_d7;
   sub_47: IntAdder_61_F50_uid108
      port map ( clk  => clk,
                 Cin => s_48,
                 X => r_47,
                 Y => pm_div_48,
                 R => n_48);
   rem_z_47 <= '1' when n_48 = 0 else '0';
   z_48 <= rem_z_47 OR z_47;
   -- Iteration 49
   s_49 <= NOT(n_48(60) XOR div_sign_d7);
   r_48 <= n_48(59 downto 0) & '0';
   pm_div_49 <= div_d7 when s_49='0' else neg_div_d7;
   sub_48: IntAdder_61_F50_uid110
      port map ( clk  => clk,
                 Cin => s_49,
                 X => r_48,
                 Y => pm_div_49,
                 R => n_49);
   rem_z_48 <= '1' when n_49 = 0 else '0';
   z_49 <= rem_z_48 OR z_48;
   -- Iteration 50
   s_50 <= NOT(n_49(60) XOR div_sign_d7);
   r_49 <= n_49(59 downto 0) & '0';
   pm_div_50 <= div_d7 when s_50='0' else neg_div_d7;
   sub_49: IntAdder_61_F50_uid112
      port map ( clk  => clk,
                 Cin => s_50,
                 X => r_49,
                 Y => pm_div_50,
                 R => n_50);
   rem_z_49 <= '1' when n_50 = 0 else '0';
   z_50 <= rem_z_49 OR z_49;
   -- Iteration 51
   s_51 <= NOT(n_50(60) XOR div_sign_d7);
   r_50 <= n_50(59 downto 0) & '0';
   pm_div_51 <= div_d7 when s_51='0' else neg_div_d7;
   sub_50: IntAdder_61_F50_uid114
      port map ( clk  => clk,
                 Cin => s_51,
                 X => r_50,
                 Y => pm_div_51,
                 R => n_51);
   rem_z_50 <= '1' when n_51 = 0 else '0';
   z_51 <= rem_z_50 OR z_50;
   -- Iteration 52
   s_52 <= NOT(n_51(60) XOR div_sign_d7);
   r_51 <= n_51(59 downto 0) & '0';
   pm_div_52 <= div_d7 when s_52='0' else neg_div_d7;
   sub_51: IntAdder_61_F50_uid116
      port map ( clk  => clk,
                 Cin => s_52,
                 X => r_51,
                 Y => pm_div_52,
                 R => n_52);
   rem_z_51 <= '1' when n_52 = 0 else '0';
   z_52 <= rem_z_51 OR z_51;
   -- Iteration 53
   s_53 <= NOT(n_52(60) XOR div_sign_d7);
   r_52 <= n_52(59 downto 0) & '0';
   pm_div_53 <= div_d7 when s_53='0' else neg_div_d7;
   sub_52: IntAdder_61_F50_uid118
      port map ( clk  => clk,
                 Cin => s_53,
                 X => r_52,
                 Y => pm_div_53,
                 R => n_53);
   rem_z_52 <= '1' when n_53 = 0 else '0';
   z_53 <= rem_z_52_d1 OR z_52_d1;
   -- Iteration 54
   s_54 <= NOT(n_53(60) XOR div_sign_d7);
   r_53 <= n_53(59 downto 0) & '0';
   pm_div_54 <= div_d8 when s_54_d1='0' else neg_div_d8;
   sub_53: IntAdder_61_F50_uid120
      port map ( clk  => clk,
                 Cin => s_54,
                 X => r_53,
                 Y => pm_div_54,
                 R => n_54);
   rem_z_53 <= '1' when n_54 = 0 else '0';
   z_54 <= rem_z_53 OR z_53;
   -- Iteration 55
   s_55 <= NOT(n_54(60) XOR div_sign_d8);
   r_54 <= n_54(59 downto 0) & '0';
   pm_div_55 <= div_d8 when s_55='0' else neg_div_d8;
   sub_54: IntAdder_61_F50_uid122
      port map ( clk  => clk,
                 Cin => s_55,
                 X => r_54,
                 Y => pm_div_55,
                 R => n_55);
   rem_z_54 <= '1' when n_55 = 0 else '0';
   z_55 <= rem_z_54 OR z_54;
   -- Iteration 56
   s_56 <= NOT(n_55(60) XOR div_sign_d8);
   r_55 <= n_55(59 downto 0) & '0';
   pm_div_56 <= div_d8 when s_56='0' else neg_div_d8;
   sub_55: IntAdder_61_F50_uid124
      port map ( clk  => clk,
                 Cin => s_56,
                 X => r_55,
                 Y => pm_div_56,
                 R => n_56);
   rem_z_55 <= '1' when n_56 = 0 else '0';
   z_56 <= rem_z_55 OR z_55;
   -- Iteration 57
   s_57 <= NOT(n_56(60) XOR div_sign_d8);
   r_56 <= n_56(59 downto 0) & '0';
   pm_div_57 <= div_d8 when s_57='0' else neg_div_d8;
   sub_56: IntAdder_61_F50_uid126
      port map ( clk  => clk,
                 Cin => s_57,
                 X => r_56,
                 Y => pm_div_57,
                 R => n_57);
   rem_z_56 <= '1' when n_57 = 0 else '0';
   z_57 <= rem_z_56 OR z_56;
   -- Iteration 58
   s_58 <= NOT(n_57(60) XOR div_sign_d8);
   r_57 <= n_57(59 downto 0) & '0';
   pm_div_58 <= div_d8 when s_58='0' else neg_div_d8;
   sub_57: IntAdder_61_F50_uid128
      port map ( clk  => clk,
                 Cin => s_58,
                 X => r_57,
                 Y => pm_div_58,
                 R => n_58);
   rem_z_57 <= '1' when n_58 = 0 else '0';
   z_58 <= rem_z_57 OR z_57;
   -- Iteration 59
   s_59 <= NOT(n_58(60) XOR div_sign_d8);
   r_58 <= n_58(59 downto 0) & '0';
   pm_div_59 <= div_d8 when s_59='0' else neg_div_d8;
   sub_58: IntAdder_61_F50_uid130
      port map ( clk  => clk,
                 Cin => s_59,
                 X => r_58,
                 Y => pm_div_59,
                 R => n_59);
   rem_z_58 <= '1' when n_59 = 0 else '0';
   z_59 <= rem_z_58 OR z_58;
   -- Iteration 60
   s_60 <= NOT(n_59(60) XOR div_sign_d8);
   r_59 <= n_59(59 downto 0) & '0';
   pm_div_60 <= div_d8 when s_60='0' else neg_div_d8;
   sub_59: IntAdder_61_F50_uid132
      port map ( clk  => clk,
                 Cin => s_60,
                 X => r_59,
                 Y => pm_div_60,
                 R => n_60);
   rem_z_59 <= '1' when n_60 = 0 else '0';
   z_60 <= rem_z_59_d1 OR z_59_d1;
   -- Iteration 61
   s_61 <= NOT(n_60(60) XOR div_sign_d8);
   r_60 <= n_60(59 downto 0) & '0';
   pm_div_61 <= div_d8 when s_61='0' else neg_div_d8;
   sub_60: IntAdder_61_F50_uid134
      port map ( clk  => clk,
                 Cin => s_61,
                 X => r_60,
                 Y => pm_div_61,
                 R => n_61);
   rem_z_60 <= '1' when n_61 = 0 else '0';
   z_61 <= rem_z_60 OR z_60;
   -- Iteration 62
   s_62 <= NOT(n_61(60) XOR div_sign_d9);
   r_61 <= n_61(59 downto 0) & '0';
   pm_div_62 <= div_d9 when s_62='0' else neg_div_d9;
   sub_61: IntAdder_61_F50_uid136
      port map ( clk  => clk,
                 Cin => s_62,
                 X => r_61,
                 Y => pm_div_62,
                 R => n_62);
   rem_z_61 <= '1' when n_62 = 0 else '0';
   z_62 <= rem_z_61 OR z_61;
   -- Iteration 63
   s_63 <= NOT(n_62(60) XOR div_sign_d9);
   r_62 <= n_62(59 downto 0) & '0';
   pm_div_63 <= div_d9 when s_63='0' else neg_div_d9;
   sub_62: IntAdder_61_F50_uid138
      port map ( clk  => clk,
                 Cin => s_63,
                 X => r_62,
                 Y => pm_div_63,
                 R => n_63);
   rem_z_62 <= '1' when n_63 = 0 else '0';
   z_63 <= rem_z_62 OR z_62;
   -- Convert the quotient to the digit set {0,1}
   q_1 <= "00" & s_1_d9 & s_2_d9 & s_3_d9 & s_4_d9 & s_5_d8 & s_6_d8 & s_7_d8 & s_8_d8 & s_9_d8 & s_10_d8 & s_11_d8 & s_12_d8 & s_13_d7 & s_14_d7 & s_15_d7 & s_16_d7 & s_17_d7 & s_18_d7 & s_19_d7 & s_20_d6 & s_21_d6 & s_22_d6 & s_23_d6 & s_24_d6 & s_25_d6 & s_26_d6 & s_27_d5 & s_28_d5 & s_29_d5 & s_30_d5 & s_31_d5 & s_32_d5 & s_33_d5 & s_34_d4 & s_35_d4 & s_36_d4 & s_37_d4 & s_38_d4 & s_39_d4 & s_40_d4 & s_41_d3 & s_42_d3 & s_43_d3 & s_44_d3 & s_45_d3 & s_46_d3 & s_47_d3 & s_48_d2 & s_49_d2 & s_50_d2 & s_51_d2 & s_52_d2 & s_53_d2 & s_54_d2 & s_55_d1 & s_56_d1 & s_57_d1 & s_58_d1 & s_59_d1 & s_60_d1 & s_61_d1 & s_62 & s_63 ;
   q_2 <= "11" & s_1_d9 & s_2_d9 & s_3_d9 & s_4_d9 & s_5_d8 & s_6_d8 & s_7_d8 & s_8_d8 & s_9_d8 & s_10_d8 & s_11_d8 & s_12_d8 & s_13_d7 & s_14_d7 & s_15_d7 & s_16_d7 & s_17_d7 & s_18_d7 & s_19_d7 & s_20_d6 & s_21_d6 & s_22_d6 & s_23_d6 & s_24_d6 & s_25_d6 & s_26_d6 & s_27_d5 & s_28_d5 & s_29_d5 & s_30_d5 & s_31_d5 & s_32_d5 & s_33_d5 & s_34_d4 & s_35_d4 & s_36_d4 & s_37_d4 & s_38_d4 & s_39_d4 & s_40_d4 & s_41_d3 & s_42_d3 & s_43_d3 & s_44_d3 & s_45_d3 & s_46_d3 & s_47_d3 & s_48_d2 & s_49_d2 & s_50_d2 & s_51_d2 & s_52_d2 & s_53_d2 & s_54_d2 & s_55_d1 & s_56_d1 & s_57_d1 & s_58_d1 & s_59_d1 & s_60_d1 & s_61_d1 & s_62 & s_63 ;
   sub_quotient: IntAdder_65_F50_uid140
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => q_1,
                 Y => q_2,
                 R => quotient_tmp);
   -- Correction step
   rem_sign <= n_63(60);
   rem_div_sign <= NOT(rem_z_62) AND (rem_sign XOR X_sign_d9);
   rem_dvr_sign <= rem_sign XOR div_sign_d9;
   div_div_sign <= X_sign XOR div_sign;
   interm_zero_rem <= NOT(rem_z_62) AND z_63;
   q_config <= '0' & div_div_sign_d9 & interm_zero_rem & rem_dvr_sign & corner_case_d9;
   zz <= '0';
   with q_config  select  sub_add_ulp <= 
      "11111111111111111111111111111111111111111111111111111111111111111" when "10000" | "10010" | "10100" | "10110",
      "0000000000000000000000000000000000000000000000000000000000000000" & '1' when "11000" | "11010" | "11100" | "11110",
      "11111111111111111111111111111111111111111111111111111111111111111" when "00110" | "01110",
      "0000000000000000000000000000000000000000000000000000000000000000" & '1' when "00100" | "01100",
      "11111111111111111111111111111111111111111111111111111111111111111" when "00001" | "00011" | "00101" | "00111" | "01001" | "01011" | "01101" | "01111" | "10001" | "10011" | "10101" | "10111" | "11001" | "11011" | "11101" | "11111",
      "00000000000000000000000000000000000000000000000000000000000000000" when others;
   correct_quotient: IntAdder_65_F50_uid142
      port map ( clk  => clk,
                 Cin => zz,
                 X => quotient_tmp,
                 Y => sub_add_ulp,
                 R => quotient_aux);
   quotient <= quotient_aux(64 downto 1) when div_gr_d9='1' else (quotient_aux(63 downto 0));
   R <= quotient;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                 RightShifterSticky63_by_max_63_F50_uid146
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

entity RightShifterSticky63_by_max_63_F50_uid146 is
    port (clk : in std_logic;
          X : in  std_logic_vector(62 downto 0);
          S : in  std_logic_vector(5 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(62 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky63_by_max_63_F50_uid146 is
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
--                      PositFastEncoder_64_2_F50_uid144
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021)
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

entity PositFastEncoder_64_2_F50_uid144 is
    port (clk : in std_logic;
          Sign : in  std_logic;
          SF : in  std_logic_vector(9 downto 0);
          Frac : in  std_logic_vector(58 downto 0);
          Guard : in  std_logic;
          Sticky : in  std_logic;
          NZN : in  std_logic;
          R : out  std_logic_vector(63 downto 0)   );
end entity;

architecture arch of PositFastEncoder_64_2_F50_uid144 is
   component RightShifterSticky63_by_max_63_F50_uid146 is
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
signal NZN_d1, NZN_d2, NZN_d3, NZN_d4, NZN_d5, NZN_d6, NZN_d7, NZN_d8, NZN_d9, NZN_d10 :  std_logic;
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
            NZN_d2 <=  NZN_d1;
            NZN_d3 <=  NZN_d2;
            NZN_d4 <=  NZN_d3;
            NZN_d5 <=  NZN_d4;
            NZN_d6 <=  NZN_d5;
            NZN_d7 <=  NZN_d6;
            NZN_d8 <=  NZN_d7;
            NZN_d9 <=  NZN_d8;
            NZN_d10 <=  NZN_d9;
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
   RegimeGenerator: RightShifterSticky63_by_max_63_F50_uid146
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
   unsignedPosit <= roundedPosit when NZN_d10 = '1' else (others => '0');
   R <= Sign_d1 & unsignedPosit;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                                  PositDiv64
--                          (PositDiv_64_2_F50_uid2)
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021)
--------------------------------------------------------------------------------
-- Pipeline depth: 10 cycles
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

entity PositDiv64 is
    port (clk : in std_logic;
          X : in  std_logic_vector(63 downto 0);
          Y : in  std_logic_vector(63 downto 0);
          R : out  std_logic_vector(63 downto 0)   );
end entity;

architecture arch of PositDiv64 is
   component PositFastDecoder_64_2_F50_uid4 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(63 downto 0);
             Sign : out  std_logic;
             SF : out  std_logic_vector(8 downto 0);
             Frac : out  std_logic_vector(58 downto 0);
             NZN : out  std_logic   );
   end component;

   component PositFastDecoder_64_2_F50_uid8 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(63 downto 0);
             Sign : out  std_logic;
             SF : out  std_logic_vector(8 downto 0);
             Frac : out  std_logic_vector(58 downto 0);
             NZN : out  std_logic   );
   end component;

   component FixDiv_1_59_F50_uid12 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(60 downto 0);
             Y : in  std_logic_vector(60 downto 0);
             R : out  std_logic_vector(63 downto 0)   );
   end component;

   component PositFastEncoder_64_2_F50_uid144 is
      port ( clk : in std_logic;
             Sign : in  std_logic;
             SF : in  std_logic_vector(9 downto 0);
             Frac : in  std_logic_vector(58 downto 0);
             Guard : in  std_logic;
             Sticky : in  std_logic;
             NZN : in  std_logic;
             R : out  std_logic_vector(63 downto 0)   );
   end component;

signal X_sgn :  std_logic;
signal X_sf, X_sf_d1, X_sf_d2, X_sf_d3, X_sf_d4, X_sf_d5, X_sf_d6, X_sf_d7, X_sf_d8, X_sf_d9 :  std_logic_vector(8 downto 0);
signal X_f :  std_logic_vector(58 downto 0);
signal X_nzn :  std_logic;
signal Y_sgn :  std_logic;
signal Y_sf, Y_sf_d1, Y_sf_d2, Y_sf_d3, Y_sf_d4, Y_sf_d5, Y_sf_d6, Y_sf_d7, Y_sf_d8, Y_sf_d9 :  std_logic_vector(8 downto 0);
signal Y_f :  std_logic_vector(58 downto 0);
signal Y_nzn :  std_logic;
signal XY_nzn, XY_nzn_d1, XY_nzn_d2, XY_nzn_d3, XY_nzn_d4, XY_nzn_d5, XY_nzn_d6, XY_nzn_d7, XY_nzn_d8, XY_nzn_d9 :  std_logic;
signal X_nar, X_nar_d1, X_nar_d2, X_nar_d3, X_nar_d4, X_nar_d5, X_nar_d6, X_nar_d7, X_nar_d8, X_nar_d9 :  std_logic;
signal Y_nar, Y_nar_d1, Y_nar_d2, Y_nar_d3, Y_nar_d4, Y_nar_d5, Y_nar_d6, Y_nar_d7, Y_nar_d8, Y_nar_d9 :  std_logic;
signal Y_zero, Y_zero_d1, Y_zero_d2, Y_zero_d3, Y_zero_d4, Y_zero_d5, Y_zero_d6, Y_zero_d7, Y_zero_d8, Y_zero_d9 :  std_logic;
signal XX_f :  std_logic_vector(60 downto 0);
signal YY_f :  std_logic_vector(60 downto 0);
signal XY_f :  std_logic_vector(63 downto 0);
signal XY_sgn :  std_logic;
signal shift_1 :  std_logic;
signal shift_2 :  std_logic;
signal shift_case :  std_logic_vector(1 downto 0);
signal XY_frac :  std_logic_vector(58 downto 0);
signal grd :  std_logic;
signal stk_tmp :  std_logic_vector(2 downto 0);
signal stk :  std_logic;
signal XY_sf :  std_logic_vector(9 downto 0);
signal XY_finalSgn :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_sf_d1 <=  X_sf;
            X_sf_d2 <=  X_sf_d1;
            X_sf_d3 <=  X_sf_d2;
            X_sf_d4 <=  X_sf_d3;
            X_sf_d5 <=  X_sf_d4;
            X_sf_d6 <=  X_sf_d5;
            X_sf_d7 <=  X_sf_d6;
            X_sf_d8 <=  X_sf_d7;
            X_sf_d9 <=  X_sf_d8;
            Y_sf_d1 <=  Y_sf;
            Y_sf_d2 <=  Y_sf_d1;
            Y_sf_d3 <=  Y_sf_d2;
            Y_sf_d4 <=  Y_sf_d3;
            Y_sf_d5 <=  Y_sf_d4;
            Y_sf_d6 <=  Y_sf_d5;
            Y_sf_d7 <=  Y_sf_d6;
            Y_sf_d8 <=  Y_sf_d7;
            Y_sf_d9 <=  Y_sf_d8;
            XY_nzn_d1 <=  XY_nzn;
            XY_nzn_d2 <=  XY_nzn_d1;
            XY_nzn_d3 <=  XY_nzn_d2;
            XY_nzn_d4 <=  XY_nzn_d3;
            XY_nzn_d5 <=  XY_nzn_d4;
            XY_nzn_d6 <=  XY_nzn_d5;
            XY_nzn_d7 <=  XY_nzn_d6;
            XY_nzn_d8 <=  XY_nzn_d7;
            XY_nzn_d9 <=  XY_nzn_d8;
            X_nar_d1 <=  X_nar;
            X_nar_d2 <=  X_nar_d1;
            X_nar_d3 <=  X_nar_d2;
            X_nar_d4 <=  X_nar_d3;
            X_nar_d5 <=  X_nar_d4;
            X_nar_d6 <=  X_nar_d5;
            X_nar_d7 <=  X_nar_d6;
            X_nar_d8 <=  X_nar_d7;
            X_nar_d9 <=  X_nar_d8;
            Y_nar_d1 <=  Y_nar;
            Y_nar_d2 <=  Y_nar_d1;
            Y_nar_d3 <=  Y_nar_d2;
            Y_nar_d4 <=  Y_nar_d3;
            Y_nar_d5 <=  Y_nar_d4;
            Y_nar_d6 <=  Y_nar_d5;
            Y_nar_d7 <=  Y_nar_d6;
            Y_nar_d8 <=  Y_nar_d7;
            Y_nar_d9 <=  Y_nar_d8;
            Y_zero_d1 <=  Y_zero;
            Y_zero_d2 <=  Y_zero_d1;
            Y_zero_d3 <=  Y_zero_d2;
            Y_zero_d4 <=  Y_zero_d3;
            Y_zero_d5 <=  Y_zero_d4;
            Y_zero_d6 <=  Y_zero_d5;
            Y_zero_d7 <=  Y_zero_d6;
            Y_zero_d8 <=  Y_zero_d7;
            Y_zero_d9 <=  Y_zero_d8;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
---------------------------- Decode X & Y operands ----------------------------
   X_decoder: PositFastDecoder_64_2_F50_uid4
      port map ( clk  => clk,
                 X => X,
                 Frac => X_f,
                 NZN => X_nzn,
                 SF => X_sf,
                 Sign => X_sgn);
   Y_decoder: PositFastDecoder_64_2_F50_uid8
      port map ( clk  => clk,
                 X => Y,
                 Frac => Y_f,
                 NZN => Y_nzn,
                 SF => Y_sf,
                 Sign => Y_sgn);
--------------------------------- Divide X & Y ---------------------------------
   -- Sign and Special Cases Computation
   XY_nzn <= X_nzn AND Y_nzn;
   X_nar <= X_sgn AND NOT(X_nzn);
   Y_nar <= Y_sgn AND NOT(Y_nzn);
   Y_zero <= NOT(Y_sgn OR Y_nzn);
   -- Divide the fractions (using FloPoCo module FixDivider)
   XX_f <= X_sgn & NOT(X_sgn) & X_f;
   YY_f <= Y_sgn & NOT(Y_sgn) & Y_f;
   FracDivider: FixDiv_1_59_F50_uid12
      port map ( clk  => clk,
                 X => XX_f,
                 Y => YY_f,
                 R => XY_f);
   -- Normalize fraction
   XY_sgn <= XY_f(63);
   shift_1 <= XY_f(63) XNOR XY_f(62);
   shift_2 <= XY_f(63) AND XY_f(62) AND XY_f(61);
   shift_case <= shift_1 & shift_2;
   with shift_case  select  XY_frac <= 
      XY_f(59 downto 1) when "11",
      XY_f(60 downto 2) when "10",
      XY_f(61 downto 3) when others;
   with shift_case  select  grd <= 
      XY_f(0) when "11",
      XY_f(1) when "10",
      XY_f(2) when others;
   with shift_case  select  stk_tmp <= 
      "000" when "11",
      XY_f(0 downto 0) & "00" when "10",
      XY_f(1 downto 0) & "0" when others;
   stk <= '0' when (stk_tmp=0) else '1';
   -- Subtract the exponent values
   XY_sf <= (X_sf_d9(X_sf_d9'high) & X_sf_d9) - (Y_sf_d9(Y_sf_d9'high) & Y_sf_d9) - shift_1 - shift_2;
----------------------------- Generate final posit -----------------------------
   XY_finalSgn <= XY_sgn when XY_nzn_d9 = '1' else (X_nar_d9 OR Y_nar_d9 OR Y_zero_d9);
   PositEncoder: PositFastEncoder_64_2_F50_uid144
      port map ( clk  => clk,
                 Frac => XY_frac,
                 Guard => grd,
                 NZN => XY_nzn,
                 SF => XY_sf,
                 Sign => XY_finalSgn,
                 Sticky => stk,
                 R => R);
---------------------------- End of vhdl generation ----------------------------
end architecture;

