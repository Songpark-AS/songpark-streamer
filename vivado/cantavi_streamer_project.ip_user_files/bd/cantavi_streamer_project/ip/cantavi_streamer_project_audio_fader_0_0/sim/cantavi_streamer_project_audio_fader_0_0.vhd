-- (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: user.org:user:audio_fader:1.0
-- IP Revision: 41

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cantavi_streamer_project_audio_fader_0_0 IS
  PORT (
    CLK_125 : IN STD_LOGIC;
    OUT_VOLCTRL_L : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    OUT_VOLCTRL_R : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    OUT_RDY : OUT STD_LOGIC;
    IN_SIG_L : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    IN_SIG_R : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    fade_enable_in : IN STD_LOGIC;
    new_sample_in : IN STD_LOGIC;
    replace_in_progress_in : IN STD_LOGIC;
    fade_direction_in : IN STD_LOGIC;
    fade_clear_in : IN STD_LOGIC;
    fade_max_in : IN STD_LOGIC;
    fade_min_in : IN STD_LOGIC;
    UP_STEP_PULSES : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    DOWN_STEP_PULSES : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    IN_COEF_MIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    IN_COEF_MAX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    OUT_COEF : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    RST_IN : IN STD_LOGIC
  );
END cantavi_streamer_project_audio_fader_0_0;

ARCHITECTURE cantavi_streamer_project_audio_fader_0_0_arch OF cantavi_streamer_project_audio_fader_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF cantavi_streamer_project_audio_fader_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT Audio_Fader_v1_0 IS
    GENERIC (
      C_S00_AXI_DATA_WIDTH : INTEGER; -- Width of S_AXI data bus
      C_S00_AXI_ADDR_WIDTH : INTEGER; -- Width of S_AXI address bus
      INTBIT_WIDTH : INTEGER;
      FRACBIT_WIDTH : INTEGER;
      STEP_WIDTH : INTEGER
    );
    PORT (
      CLK_125 : IN STD_LOGIC;
      OUT_VOLCTRL_L : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT_VOLCTRL_R : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT_RDY : OUT STD_LOGIC;
      IN_SIG_L : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
      IN_SIG_R : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
      fade_enable_in : IN STD_LOGIC;
      new_sample_in : IN STD_LOGIC;
      replace_in_progress_in : IN STD_LOGIC;
      fade_direction_in : IN STD_LOGIC;
      fade_clear_in : IN STD_LOGIC;
      fade_max_in : IN STD_LOGIC;
      fade_min_in : IN STD_LOGIC;
      UP_STEP_PULSES : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      DOWN_STEP_PULSES : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      IN_COEF_MIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      IN_COEF_MAX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      OUT_COEF : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      RST_IN : IN STD_LOGIC
    );
  END COMPONENT Audio_Fader_v1_0;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF CLK_125: SIGNAL IS "XIL_INTERFACENAME CLK_125, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF CLK_125: SIGNAL IS "xilinx.com:signal:clock:1.0 CLK_125 CLK";
BEGIN
  U0 : Audio_Fader_v1_0
    GENERIC MAP (
      C_S00_AXI_DATA_WIDTH => 32,
      C_S00_AXI_ADDR_WIDTH => 5,
      INTBIT_WIDTH => 24,
      FRACBIT_WIDTH => 8,
      STEP_WIDTH => 32
    )
    PORT MAP (
      CLK_125 => CLK_125,
      OUT_VOLCTRL_L => OUT_VOLCTRL_L,
      OUT_VOLCTRL_R => OUT_VOLCTRL_R,
      OUT_RDY => OUT_RDY,
      IN_SIG_L => IN_SIG_L,
      IN_SIG_R => IN_SIG_R,
      fade_enable_in => fade_enable_in,
      new_sample_in => new_sample_in,
      replace_in_progress_in => replace_in_progress_in,
      fade_direction_in => fade_direction_in,
      fade_clear_in => fade_clear_in,
      fade_max_in => fade_max_in,
      fade_min_in => fade_min_in,
      UP_STEP_PULSES => UP_STEP_PULSES,
      DOWN_STEP_PULSES => DOWN_STEP_PULSES,
      IN_COEF_MIN => IN_COEF_MIN,
      IN_COEF_MAX => IN_COEF_MAX,
      OUT_COEF => OUT_COEF,
      RST_IN => RST_IN
    );
END cantavi_streamer_project_audio_fader_0_0_arch;
