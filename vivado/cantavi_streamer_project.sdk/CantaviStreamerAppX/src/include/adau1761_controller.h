
#ifndef ADAU1761_CONTROLLER_H
#define ADAU1761_CONTROLLER_H


/****************** Include Files ********************/
#include <stdint.h>
#include "ui_control.h"

#define AUDIO_RATE	96

/* ADAU internal registers */
enum audio_regs {
	R0_CLOCK_CONTROL								= 0x00,
	R1_PLL_CONTROL 									= 0x02,
	R2_DIGITAL_MIC_JACK_DETECTION_CONTROL 			= 0x08,
	R3_RECORD_POWER_MANAGEMENT						= 0x09,
	R4_RECORD_MIXER_LEFT_CONTROL_0 					= 0x0A,
	R5_RECORD_MIXER_LEFT_CONTROL_1 					= 0x0B,
	R6_RECORD_MIXER_RIGHT_CONTROL_0 				= 0x0C,
	R7_RECORD_MIXER_RIGHT_CONTROL_1 				= 0x0D,
	R8_LEFT_DIFFERENTIAL_INPUT_VOLUME_CONTROL 		= 0x0E,
	R9_RIGHT_DIFFERENTIAL_INPUT_VOLUME_CONTROL 		= 0x0F,
	R10_RECORD_MICROPHONE_BIAS_CONTROL 				= 0x10,
	R11_ALC_CONTROL_0								= 0x11,
	R12_ALC_CONTROL_1								= 0x12,
	R13_ALC_CONTROL_2								= 0x13,
	R14_ALC_CONTROL_3								= 0x14,
	R15_SERIAL_PORT_CONTROL_0 						= 0x15,
	R16_SERIAL_PORT_CONTROL_1 						= 0x16,
	R17_CONVERTER_CONTROL_0 						= 0x17,
	R18_CONVERTER_CONTROL_1 						= 0x18,
	R19_ADC_CONTROL									= 0x19,
	R20_LEFT_INPUT_DIGITAL_VOLUME 					= 0x1A,
	R21_RIGHT_INPUT_DIGITAL_VOLUME 					= 0x1B,
	R22_PLAYBACK_MIXER_LEFT_CONTROL_0 				= 0x1C,
	R23_PLAYBACK_MIXER_LEFT_CONTROL_1 				= 0x1D,
	R24_PLAYBACK_MIXER_RIGHT_CONTROL_0 				= 0x1E,
	R25_PLAYBACK_MIXER_RIGHT_CONTROL_1 				= 0x1F,
	R26_PLAYBACK_LR_MIXER_LEFT_LINE_OUTPUT_CONTROL 	= 0x20,
	R27_PLAYBACK_LR_MIXER_RIGHT_LINE_OUTPUT_CONTROL = 0x21,
	R28_PLAYBACK_LR_MIXER_MONO_OUTPUT_CONTROL 		= 0x22,
	R29_PLAYBACK_HEADPHONE_LEFT_VOLUME_CONTROL 		= 0x23,
	R30_PLAYBACK_HEADPHONE_RIGHT_VOLUME_CONTROL 	= 0x24,
	R31_PLAYBACK_LINE_OUTPUT_LEFT_VOLUME_CONTROL 	= 0x25,
	R32_PLAYBACK_LINE_OUTPUT_RIGHT_VOLUME_CONTROL 	= 0x26,
	R33_PLAYBACK_MONO_OUTPUT_CONTROL 				= 0x27,
	R34_PLAYBACK_POP_CLICK_SUPPRESSION 				= 0x28,
	R35_PLAYBACK_POWER_MANAGEMENT 					= 0x29,
	R36_DAC_CONTROL_0 								= 0x2A,
	R37_DAC_CONTROL_1 								= 0x2B,
	R38_DAC_CONTROL_2 								= 0x2C,
	R39_SERIAL_PORT_PAD_CONTROL 					= 0x2D,
	R40_CONTROL_PORT_PAD_CONTROL_0 					= 0x2F,
	R41_CONTROL_PORT_PAD_CONTROL_1 					= 0x30,
	R42_JACK_DETECT_PIN_CONTROL 					= 0x31,
	R67_DEJITTER_CONTROL 							= 0x36,
	R58_SERIAL_INPUT_ROUTE_CONTROL					= 0xF2,
	R59_SERIAL_OUTPUT_ROUTE_CONTROL					= 0xF3,
	R61_DSP_ENABLE									= 0xF5,
	R62_DSP_RUN										= 0xF6,
	R63_DSP_SLEW_MODES								= 0xF7,
	R64_SERIAL_PORT_SAMPLING_RATE 					= 0xF8,
	R65_CLOCK_ENABLE_0 								= 0xF9,
	R66_CLOCK_ENABLE_1 								= 0xFA
};

#define ADAU1761_CONTROLLER_S00_AXI_SLV_REG0_OFFSET 0
#define ADAU1761_CONTROLLER_S00_AXI_SLV_REG1_OFFSET 4
#define ADAU1761_CONTROLLER_S00_AXI_SLV_REG2_OFFSET 8
#define ADAU1761_CONTROLLER_S00_AXI_SLV_REG3_OFFSET 12
#define ADAU1761_CONTROLLER_S00_AXI_SLV_REG4_OFFSET 16
#define ADAU1761_CONTROLLER_S00_AXI_SLV_REG5_OFFSET 20




//#define AUDIO_BASE XPAR_ADAU1761_CONTROLLER_0_S00_AXI_BASEADDR

#define AUDIO_BASE adau1761_base_0


#define CTRL_ADDR ADAU1761_CONTROLLER_S00_AXI_SLV_REG0_OFFSET
#define BUSY_ADDR ADAU1761_CONTROLLER_S00_AXI_SLV_REG1_OFFSET
#define WRITE_LOW_DATA_ADDR ADAU1761_CONTROLLER_S00_AXI_SLV_REG2_OFFSET
#define WRITE_HIGH_DATA_ADDR ADAU1761_CONTROLLER_S00_AXI_SLV_REG3_OFFSET
#define READ_LOW_DATA_ADDR ADAU1761_CONTROLLER_S00_AXI_SLV_REG4_OFFSET
#define READ_HIGH_DATA_ADDR ADAU1761_CONTROLLER_S00_AXI_SLV_REG5_OFFSET

#define RESET_POS 25
#define START_POS 24
#define READ_POS 19
#define NBYTES_POS 16
#define ADDR_POS 0



/**************************** Type Definitions *****************************/
//typedef unsigned long uint64_t;
//typedef unsigned int uint32_t;
/**
 *
 * Write a value to a ADAU1761_CONTROLLER register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the ADAU1761_CONTROLLERdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void ADAU1761_CONTROLLER_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define ADAU1761_CONTROLLER_mWriteReg(BaseAddress, RegOffset, Data) \
	*((unsigned *)((BaseAddress) + (RegOffset))) = (Data)

/**
 *
 * Read a value from a ADAU1761_CONTROLLER register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the ADAU1761_CONTROLLER device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 ADAU1761_CONTROLLER_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define ADAU1761_CONTROLLER_mReadReg(BaseAddress, RegOffset) \
    *(unsigned *)((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the ADAU1761_CONTROLLER instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
uint32_t ADAU1761_CONTROLLER_Reg_SelfTest(void * baseaddr_p);

void write_adau1761(uint32_t addr, uint64_t data, uint32_t nbytes);
uint64_t read_adau1761(uint32_t addr, uint32_t nbytes) ;
void reset_adau1761(void);
void init_adau1761(void);
int init_codec(void);

#endif // ADAU1761_CONTROLLER_H
