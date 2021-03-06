-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"
-- CREATED		"Thu May 27 16:27:01 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY top IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		clkMBR :  IN  STD_LOGIC;
		ACC :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		ALUIN :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		BRIN :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		BROUT :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		CARcIN :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		CAROUT :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		CONTROLIN :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		IROUT :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		MAROUT :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		PCOUT :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		RAAMOUT :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		RAMIN :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END top;

ARCHITECTURE bdf_type OF top IS 

ATTRIBUTE black_box : BOOLEAN;
ATTRIBUTE noopt : BOOLEAN;

COMPONENT lpm_ram_dq_0
	PORT(inclock : IN STD_LOGIC;
		 we : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;
ATTRIBUTE black_box OF lpm_ram_dq_0: COMPONENT IS true;
ATTRIBUTE noopt OF lpm_ram_dq_0: COMPONENT IS true;

COMPONENT lpm_rom_1
	PORT(inclock : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;
ATTRIBUTE black_box OF lpm_rom_1: COMPONENT IS true;
ATTRIBUTE noopt OF lpm_rom_1: COMPONENT IS true;

COMPONENT alu
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 ACCclear : IN STD_LOGIC;
		 aluCONTR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 BR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 PCjmp : OUT STD_LOGIC;
		 ACC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT br
	PORT(MBR_BRc : IN STD_LOGIC;
		 MBR_BR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 BRout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT car
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 CAR : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 CARc : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 OP : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 CARout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mbr
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 MBR_OPc : IN STD_LOGIC;
		 ACC_MBRc : IN STD_LOGIC;
		 R : IN STD_LOGIC;
		 W : IN STD_LOGIC;
		 ACC_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 RAM_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 MBR_BR : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 MBR_MAR : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 MBR_OP : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 MBR_PC : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 MBR_RAM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pc
	PORT(clk : IN STD_LOGIC;
		 PCjmp : IN STD_LOGIC;
		 PCc1 : IN STD_LOGIC;
		 PCinc : IN STD_LOGIC;
		 PCc3 : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 CONTRalu : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 MBR_PC : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 PCout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT controlr
	PORT(control : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R : OUT STD_LOGIC;
		 W : OUT STD_LOGIC;
		 RW : OUT STD_LOGIC;
		 PCc1 : OUT STD_LOGIC;
		 PCinc : OUT STD_LOGIC;
		 PCc3 : OUT STD_LOGIC;
		 ACCclear : OUT STD_LOGIC;
		 MBR_MARc : OUT STD_LOGIC;
		 PC_MARc : OUT STD_LOGIC;
		 ACC_MBRc : OUT STD_LOGIC;
		 MBR_OPc : OUT STD_LOGIC;
		 MBR_BRc : OUT STD_LOGIC;
		 CAR : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 CARc : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 CONTRout : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ir
	PORT(opcode : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 IRout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mar
	PORT(clk : IN STD_LOGIC;
		 PC_MARc : IN STD_LOGIC;
		 MBR_MARc : IN STD_LOGIC;
		 MBR_MAR : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 PC : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 MARout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_30 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_29 :  STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN 
ACC <= SYNTHESIZED_WIRE_16;
ALUIN <= SYNTHESIZED_WIRE_30;
BRIN <= SYNTHESIZED_WIRE_8;
BROUT <= SYNTHESIZED_WIRE_6;
CARcIN <= SYNTHESIZED_WIRE_10;
CAROUT <= SYNTHESIZED_WIRE_3;
CONTROLIN <= SYNTHESIZED_WIRE_24;
IROUT <= SYNTHESIZED_WIRE_11;
MAROUT <= SYNTHESIZED_WIRE_1;
PCOUT <= SYNTHESIZED_WIRE_29;
RAAMOUT <= SYNTHESIZED_WIRE_17;
RAMIN <= SYNTHESIZED_WIRE_2;



b2v_inst : lpm_ram_dq_0
PORT MAP(inclock => clkMBR,
		 we => SYNTHESIZED_WIRE_0,
		 address => SYNTHESIZED_WIRE_1,
		 data => SYNTHESIZED_WIRE_2,
		 q => SYNTHESIZED_WIRE_17);


b2v_inst1 : lpm_rom_1
PORT MAP(inclock => clkMBR,
		 address => SYNTHESIZED_WIRE_3,
		 q => SYNTHESIZED_WIRE_24);


b2v_inst2 : alu
PORT MAP(clk => clk,
		 reset => reset,
		 ACCclear => SYNTHESIZED_WIRE_4,
		 aluCONTR => SYNTHESIZED_WIRE_30,
		 BR => SYNTHESIZED_WIRE_6,
		 PCjmp => SYNTHESIZED_WIRE_18,
		 ACC => SYNTHESIZED_WIRE_16);


b2v_inst3 : br
PORT MAP(MBR_BRc => SYNTHESIZED_WIRE_7,
		 MBR_BR => SYNTHESIZED_WIRE_8,
		 BRout => SYNTHESIZED_WIRE_6);


b2v_inst4 : car
PORT MAP(clk => clk,
		 reset => reset,
		 CAR => SYNTHESIZED_WIRE_9,
		 CARc => SYNTHESIZED_WIRE_10,
		 OP => SYNTHESIZED_WIRE_11,
		 CARout => SYNTHESIZED_WIRE_3);


b2v_inst5 : mbr
PORT MAP(clk => clkMBR,
		 reset => reset,
		 MBR_OPc => SYNTHESIZED_WIRE_12,
		 ACC_MBRc => SYNTHESIZED_WIRE_13,
		 R => SYNTHESIZED_WIRE_14,
		 W => SYNTHESIZED_WIRE_15,
		 ACC_MBR => SYNTHESIZED_WIRE_16,
		 RAM_MBR => SYNTHESIZED_WIRE_17,
		 MBR_BR => SYNTHESIZED_WIRE_8,
		 MBR_MAR => SYNTHESIZED_WIRE_28,
		 MBR_OP => SYNTHESIZED_WIRE_25,
		 MBR_PC => SYNTHESIZED_WIRE_23,
		 MBR_RAM => SYNTHESIZED_WIRE_2);


b2v_inst6 : pc
PORT MAP(clk => clk,
		 PCjmp => SYNTHESIZED_WIRE_18,
		 PCc1 => SYNTHESIZED_WIRE_19,
		 PCinc => SYNTHESIZED_WIRE_20,
		 PCc3 => SYNTHESIZED_WIRE_21,
		 reset => reset,
		 CONTRalu => SYNTHESIZED_WIRE_30,
		 MBR_PC => SYNTHESIZED_WIRE_23,
		 PCout => SYNTHESIZED_WIRE_29);


b2v_inst7 : controlr
PORT MAP(control => SYNTHESIZED_WIRE_24,
		 R => SYNTHESIZED_WIRE_14,
		 W => SYNTHESIZED_WIRE_15,
		 RW => SYNTHESIZED_WIRE_0,
		 PCc1 => SYNTHESIZED_WIRE_19,
		 PCinc => SYNTHESIZED_WIRE_20,
		 PCc3 => SYNTHESIZED_WIRE_21,
		 ACCclear => SYNTHESIZED_WIRE_4,
		 MBR_MARc => SYNTHESIZED_WIRE_27,
		 PC_MARc => SYNTHESIZED_WIRE_26,
		 ACC_MBRc => SYNTHESIZED_WIRE_13,
		 MBR_OPc => SYNTHESIZED_WIRE_12,
		 MBR_BRc => SYNTHESIZED_WIRE_7,
		 CAR => SYNTHESIZED_WIRE_9,
		 CARc => SYNTHESIZED_WIRE_10,
		 CONTRout => SYNTHESIZED_WIRE_30);


b2v_inst8 : ir
PORT MAP(opcode => SYNTHESIZED_WIRE_25,
		 IRout => SYNTHESIZED_WIRE_11);


b2v_inst9 : mar
PORT MAP(clk => clk,
		 PC_MARc => SYNTHESIZED_WIRE_26,
		 MBR_MARc => SYNTHESIZED_WIRE_27,
		 MBR_MAR => SYNTHESIZED_WIRE_28,
		 PC => SYNTHESIZED_WIRE_29,
		 MARout => SYNTHESIZED_WIRE_1);


END bdf_type;