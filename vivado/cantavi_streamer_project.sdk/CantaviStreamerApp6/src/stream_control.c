/**
 * =====================================================================================
 *
 *       Filename:  stream_control.c
 *
 *    Description:  audio stream control functions and macros
 *
 *        Version:  1.0
 *         Author:  Thanx
 *   Organization:  Cantavi
 *
 * =====================================================================================
 */

#include "include/stream_control.h"
#include <unistd.h> // for usleep
/**
 * =======================================================
 * read_stream reads 4 bytes unsigned data
 * from the specified channel
 * @param   : stream_base  : base address of the stream
 * @param   : channel      : channel ID
 * @return  : returns 4 bytes unsigned data
 * =======================================================
 */
unsigned read_stream (void *stream_base, CHANNEL_ID channel) {
  unsigned buffer = 0;
  if (stream_base == NULL) {
    return -1;
  }

//  if (channel == CHANNEL_ID_L) {
//    buffer = ReadReg(stream_base, AUDIO_TO_AXI_INTERFACE_REG0_OFFSET);
//  }
//  else if (channel == CHANNEL_ID_R) {
//    buffer = ReadReg(stream_base, AUDIO_TO_AXI_INTERFACE_REG1_OFFSET);
//  }
  if (channel == CHANNEL_ID_L) {
	  do{
		  buffer = ReadReg(stream_base, AUDIO_TO_AXI_INTERFACE_REG1_OFFSET);
		  if(buffer == 0xFF000000){
			  usleep(1/48000 * 1000000*16);
		  }
	  }while(buffer > 0xFF000000);

    }
    else if (channel == CHANNEL_ID_R) {
    	do{
			  buffer = ReadReg(stream_base, AUDIO_TO_AXI_INTERFACE_REG2_OFFSET);
			  if(buffer == 0xFF000000){
				  usleep(1/48000 * 1000000*16);
			  }
		  }while(buffer == 0xFF000000);
    }
  else {
    return -1;
  }
  return buffer;
}

/**
 * =======================================================
 * write_stream writes 4 bytes unsigned data
 * to the spicified channel
 * @param  stream_base  : base address of the stream
 * @param  channel      : channel ID
 * @param  data         : 4 bytes unsigned data
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int write_stream (void *stream_base, CHANNEL_ID channel, unsigned data) {
  if (stream_base == NULL) {
    return -1;
  }

//  if (channel == CHANNEL_ID_L) {
//    WriteReg(stream_base, AXI_TO_AUDIO_INTERFACE_REG0_OFFSET, data);
//  }
//  else if (channel == CHANNEL_ID_R) {
//    WriteReg(stream_base, AXI_TO_AUDIO_INTERFACE_REG1_OFFSET, data);
//  }
  if (channel == CHANNEL_ID_L) {
      WriteReg(stream_base, AXI_TO_AUDIO_INTERFACE_REG1_OFFSET, data);
    }
    else if (channel == CHANNEL_ID_R) {
      WriteReg(stream_base, AXI_TO_AUDIO_INTERFACE_REG2_OFFSET, data);
    }
  else {
    return -1;
  }
  return 0;
}



/**
 * =======================================================
 * read_fifo_staus reads 4 bytes unsigned data
 * from the specified channel
 * @param   : stream_base  : base address of the stream
 * @param   : fifo      : fifo ID
 * @return  : returns 4 bytes unsigned data
 * =======================================================
 *
 * rValue(2) <= dacLeftFIFOEmpty;
	rValue(3) <= dacRightFIFOEmpty;
	rValue(4) <= dacLeftFIFOFull;
	rValue(5) <= dacRightFIFOFull;
 * =======================================================
 */
unsigned read_fifo_status (void *stream_base, FIFO_ID fifo) {
  unsigned buffer = 0;
  if (stream_base == NULL) {
    return -1;
  }

  if (fifo == ADC_FIFO_ID) {
    buffer = ReadReg(stream_base, AUDIO_TO_AXI_INTERFACE_REG0_OFFSET);
    if(buffer&0x04){
    	//LeftFIFOEmpty
    }else if(buffer&0x08){
    	//RightFIFOEmpty
    }else if(buffer&0x10){
    	//LeftFIFOFull
    }else if(buffer&0x20){
    	//RightFIFOFull
    }
  }
  else if (fifo == DAC_FIFO_ID) {
    buffer = ReadReg(stream_base, AXI_TO_AUDIO_INTERFACE_REG0_OFFSET);
    if(buffer&0x04){
		//LeftFIFOEmpty
	}else if(buffer&0x08){
		//RightFIFOEmpty
	}else if(buffer&0x10){
		//LeftFIFOFull
	}else if(buffer&0x20){
		//RightFIFOFull
	}
  }

  else {
    return -1;
  }
  return buffer;
}

void reset_fifos(void *stream_base, FIFO_ID fifo, unsigned data){
	  if (fifo == ADC_FIFO_ID) {
	      WriteReg(stream_base, AXI_TO_AUDIO_INTERFACE_REG0_OFFSET, data);
	    }
	    else if (fifo == DAC_FIFO_ID) {
	      WriteReg(stream_base, AUDIO_TO_AXI_INTERFACE_REG0_OFFSET, data);
	    }
}
