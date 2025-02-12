/**
 * =====================================================================================
 *
 *       Filename:  reg_io.h
 *
 *    Description:  Register read write helper macros and functions
 *    				with register offset definitions.
 *
 *         Author:  Thanx
 *   Organization:  Cantavi
 *
 * =====================================================================================
 */

#ifndef REG_IO_H
#define REG_IO_H

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdint.h>

/**
 * =======================================================
 * Macros for device file names
 * =======================================================
 */
//#define AUDIO_TO_AXI_DEVICE_0	"/dev/uio0"
//#define AXI_TO_AUDIO_DEVICE_0	"/dev/uio1"
//#define AXI_TO_AUDIO_DEVICE_1	"/dev/uio2"
//#define FILTER_DEVICE_0 			"/dev/uio3"
//#define VOLUME_DEVICE_0				"/dev/uio5"
//#define FILTER_DEVICE_1 			"/dev/uio4"
//#define VOLUME_DEVICE_1				"/dev/uio6"


#define AXI_TO_AUDIO_DEVICE_0		"/dev/uio0"
#define FILTER_DEVICE_0 			"/dev/uio1"
#define VOLUME_DEVICE_0				"/dev/uio2"
#define FILTER_DEVICE_1 			"/dev/uio3"
#define VOLUME_DEVICE_1				"/dev/uio4"

//#define AXI_TO_AUDIO_DEVICE_0		"/dev/uio5"
#define ZEDBOARDOLED_0				"/dev/uio5"
//#define AXI_TO_AUDIO_DEVICE_1		"/dev/uio6"
#define PMOD_CONTROLLER_0			"/dev/uio6"
#define AUDIO_TO_AXI_DEVICE_0		"/dev/uio7"

/**
 * =======================================================
 * Audio to AXI register offset definitions
 * =======================================================
 * rValue(2) <= adcLeftFIFOEmpty;
	rValue(3) <= adcRightFIFOEmpty;
	rValue(4) <= adcLeftFIFOFull;
	rValue(5) <= aacRightFIFOFull;
 */
#define AUDIO_TO_AXI_INTERFACE_REG0_OFFSET 0		//New IP read status// Write 0x03 to reset fifos
#define AUDIO_TO_AXI_INTERFACE_REG1_OFFSET 4		//New IP read L audio
#define AUDIO_TO_AXI_INTERFACE_REG2_OFFSET 8		//New IP read R audio
#define AUDIO_TO_AXI_INTERFACE_REG3_OFFSET 12

/**
 * =======================================================
 * AXI to Audio register offset definitions
 * =======================================================
 * rValue(2) <= dacLeftFIFOEmpty;
	rValue(3) <= dacRightFIFOEmpty;
	rValue(4) <= dacLeftFIFOFull;
	rValue(5) <= dacRightFIFOFull;
 */
#define AXI_TO_AUDIO_INTERFACE_REG0_OFFSET 0  // New IP read status// Write 0x03 to reset fifos
#define AXI_TO_AUDIO_INTERFACE_REG1_OFFSET 4  // New IP write L audio
#define AXI_TO_AUDIO_INTERFACE_REG2_OFFSET 8 // New IP write R audio
#define AXI_TO_AUDIO_INTERFACE_REG3_OFFSET 12

/**
 * =======================================================
 * FIR_Filter register offset definitions
 * =======================================================
 */
#define FILTER_CONTROL_REG0_OFFSET 0
#define FILTER_CONTROL_REG1_OFFSET 4
#define FILTER_CONTROL_REG2_OFFSET 8
#define FILTER_CONTROL_REG3_OFFSET 12
#define FILTER_CONTROL_REG4_OFFSET 16
#define FILTER_CONTROL_REG5_OFFSET 20
#define FILTER_CONTROL_REG6_OFFSET 24
#define FILTER_CONTROL_REG7_OFFSET 28
#define FILTER_CONTROL_REG8_OFFSET 32
#define FILTER_CONTROL_REG9_OFFSET 36
#define FILTER_CONTROL_REG10_OFFSET 40
#define FILTER_CONTROL_REG11_OFFSET 44
#define FILTER_CONTROL_REG12_OFFSET 48
#define FILTER_CONTROL_REG13_OFFSET 52
#define FILTER_CONTROL_REG14_OFFSET 56
#define FILTER_CONTROL_REG15_OFFSET 60
#define FILTER_CONTROL_REG16_OFFSET 64
#define FILTER_CONTROL_REG17_OFFSET 68
#define FILTER_CONTROL_REG18_OFFSET 72
#define FILTER_CONTROL_REG19_OFFSET 76

/**
 * =======================================================
 * Volume Control register offset definitions
 * =======================================================
 */
#define VOLUME_CONTROL_REG0_OFFSET 0
#define VOLUME_CONTROL_REG1_OFFSET 4
#define VOLUME_CONTROL_REG2_OFFSET 8
#define VOLUME_CONTROL_REG3_OFFSET 12

/**
 * =======================================================
 * PMOD register offset definitions
 * =======================================================
 */
#define PMOD_INTERFACE_REG0_OFFSET 0
#define PMOD_INTERFACE_REG1_OFFSET 4
#define PMOD_INTERFACE_REG2_OFFSET 8
#define PMOD_INTERFACE_REG3_OFFSET 12

/**
 * =======================================================
 * Macro to get the Arch specific page size
 * =======================================================
 */
#define PAGE_SIZE (sysconf(_SC_PAGESIZE))

/**
 * =======================================================
 * Device params struct
 * =======================================================
 */

typedef struct _dev_param {
	int dev_fd;
	void *base_address;
} dev_param;

/**
 * =======================================================
 * Channel ID enumarations
 * =======================================================
 */
typedef enum _CHANNEL_ID {
  CHANNEL_ID_L,
  CHANNEL_ID_R,
  CHANNEL_ID_MAX
}CHANNEL_ID;


/**
 * =======================================================
 * FIFO ID enumarations
 * =======================================================
 */
typedef enum _FIFO_ID {
  ADC_FIFO_ID,
  DAC_FIFO_ID,
  FIFI_ID_MAX
}FIFO_ID;

/**
 * =======================================================
 * Filter type enumarations
 * =======================================================
 */
typedef enum _FILTER_TYPE {
  FILTER_BAND_PASS = 1,
  FILTER_HIGH_PASS = 2,
  FILTER_LOW_PASS = 4,
  FILTER_TYPE_MAX
}FILTER_TYPE;

/**
 * =======================================================
 * Macro for writing data into memory mapped registers.
 *
 * @Param 	: BaseAddress	: Base address of the mapped
 * 						register area
 * @Param 	: RegOffset		: Offset from the base address
 * 						where the data need to write
 * @Param 	: Data				: Data to be written
 *
 * @Return 	: None
 *
 * =======================================================
 */
#define WriteReg(BaseAddress, RegOffset, Data) \
	*((unsigned *)((BaseAddress) + (RegOffset))) = (Data)

/**
 * =======================================================
 * Macro for reading data from memory mapped registers
 *
 * @Param 	: BaseAddress	: Base address of the mapped
 * 						register area
 * @Param 	: RegOffset		: Offset from the base address
 * 						where the data need to read
 *
 * @Return 	: Returns unsigned data read from the mapped
 * 			  		register area
 *
 * =======================================================
 */
#define ReadReg(BaseAddress, RegOffset) \
    *(unsigned *)((BaseAddress) + (RegOffset))

/**
 * =======================================================
 * Function to open the device file and map the register
 * area in to user accessible address space
 *
 * @Param		: device_file_name	: String specifies the
 * 			  		name of the device file
 *
 * @Return	: Returns the pointer to the mapped
 * 			  		Base address of the device file
 *
 * =======================================================
 */
dev_param map_device (const char *device_file_name);

/**
 * =======================================================
 * Function to unmap the register map from user space
 *
 * @Param		: pointer to the base address of the
 * 			  		mapped area.
 *
 * @Return	: None
 *
 * =======================================================
 */
void unmap_device (void *device_base);

#endif //REG_IO_H
