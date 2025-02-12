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

#include "stream_control.h"
#include "ui_control.h"
#include <adau1761_controller.h>
#include <unistd.h> // for usleep
#include "log.h"

#define SAMPLE_RATE (AUDIO_RATE*1.0)

//#define debug(x...) do{ printf("DEBUG::"); printf(x); printf("\n");}while(0)
//#define info(x...) do{ printf("INFO::"); printf(x); printf("\n");}while(0)
//#define warn(x...) do{ printf("WARN::"); printf(x); printf("\n");}while(0)
//#define error(x...) do{ printf("ERROR::"); printf(x); printf("\n");}while(0)
/**
 * =======================================================
 * read_stream reads 4 bytes unsigned int data
 * from the specified channel
 * @param   : stream_base  : base address of the stream
 * @param   : channel      : channel ID
 * @return  : returns 4 bytes unsigned int data
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
 * write_stream writes 4 bytes unsigned int data
 * to the spicified channel
 * @param  stream_base  : base address of the stream
 * @param  channel      : channel ID
 * @param  data         : 4 bytes unsigned int data
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int write_stream (void *stream_base, CHANNEL_ID channel, unsigned int data) {
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
 * read_fifo_staus reads 4 bytes unsigned int data
 * from the specified channel
 * @param   : stream_base  : base address of the stream
 * @param   : fifo      : fifo ID
 * @return  : returns 4 bytes unsigned int data
 * =======================================================
 *
 * rValue(2) <= dacLeftFIFOEmpty;
	rValue(3) <= dacRightFIFOEmpty;
	rValue(4) <= dacLeftFIFOFull;
	rValue(5) <= dacRightFIFOFull;
 * =======================================================
 */
unsigned read_fifo_status (void *stream_base, FIFO_ID fifo) {
  unsigned d, buffer = 0;
  if (stream_base == NULL) {
    return -1;
  }

  if (fifo == ADC_FIFO_ID) {
    buffer = ReadReg(stream_base, AUDIO_TO_AXI_INTERFACE_REG0_OFFSET);
    d=buffer;
        info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
        	      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

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
    d=buffer;
    info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
    	      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));


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

void reset_adc_fifos(void *stream_base){
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d|0x03);
	      sleep(1);
	      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d&0xFFFFFFFC);

}


void reset_dac_fifos(void *stream_base){
	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET);
	      WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET, d|0x03);
	      sleep(1);
	      WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET, d&0xFFFFFFFC);

}


void set_buf_corr_on(void *stream_base){
	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET);
	      WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET, d|0x20);

	      d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET);
		  info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void get_e2a_status(void *stream_base){

	      unsigned d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET);
		  info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}

void clear_buf_corr(void *stream_base){
	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET);
	      WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET, d&0xFFFFFFDF);

	      d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET);
		  info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}

unsigned int get_dpkt_replace_events(void *stream_base){
	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG28_OFFSET);

		  info("Reg28: %d", d);

		  return d;

}


unsigned int get_pkt_seq_skiped(void *stream_base){
	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG24_OFFSET);

		  info("Reg24: %d", d);

		  return d;

}

void set_drop_allowance(void *stream_base, int val){

    WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG27_OFFSET, val);
    sleep(1);
   unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG27_OFFSET);
	  info("Reg27:%d", d);

}

void set_rx_osl(void *stream_base, int val){

    WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG26_OFFSET, val);
    sleep(1);
   unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG26_OFFSET);
	  info("Reg26:%d", d);

}

void set_rx_esl(void *stream_base, int val){

    WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG25_OFFSET, val);
    sleep(1);
   unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG25_OFFSET);
	  info("Reg25:%d", d);

}



void set_rx_hdr_strip(void *stream_base){

	      WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG10_OFFSET, 0x01);
	      sleep(1);
	     unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG10_OFFSET);
		  info("Reg10: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void clear_rx_hdr_strip(void *stream_base){

	      WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG10_OFFSET, 0x00);
	      sleep(1);
	      unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG10_OFFSET);
		  info("Reg10: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void set_buf_corr_window(void *stream_base, unsigned data){

	      WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG23_OFFSET, data);
	     unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG23_OFFSET);
		  info("Reg23: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}



void set_test_mode_on(void *stream_base){
		  unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET)|0x00000080;
	      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d);
}

void set_test_mode(void *stream_base, unsigned mode){
	unsigned int d=0;
	switch(mode){
	case 0:
		d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET)&0xFFFFF1FF;//
		break;
	case 1:
			d = (ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET)&0xFFFFF1FF)|0x00000200;
			break;
	case 2:
		    d = (ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET)&0xFFFFF1FF)|0x00000400;
			break;
	case 3:
			d = (ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET)&0xFFFFF1FF)|0x00000600;
			break;
	case 4:
				d = (ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET)&0xFFFFF1FF)|0x00000800;
				break;

	default:
		d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET)&0xFFFFF1FF;
		break;
	}
	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d);
}


void set_test_mode_off(void *stream_base){
		  unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d&0xFFFFFF7F);

	      d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	      	      info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}





void set_xtest_mode_on(void *stream_base){
		  //unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET)|0x00000080;
	      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG7_OFFSET, 0x01);

	      unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG7_OFFSET);
	      	info("Reg7: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	      		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}

void set_xtest_mode(void *stream_base, unsigned mode){
	unsigned int d=0;
	switch(mode){
	case 0:
		d = 0;//
		break;
	case 1:
			d = 1;
			break;
	case 2:
		    d = 2;
			break;
	case 3:
			d = 3;
			break;
	case 4:
			d = 4;
			break;

	default:
		d = 0;
		break;
	}
	WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG8_OFFSET, d);
	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG8_OFFSET);
			      	      info("Reg8: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}


void set_xtest_mode_off(void *stream_base){
//		  unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG7_OFFSET);
	      WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG7_OFFSET, 0);

	      unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG7_OFFSET);
	      	      info("Reg7: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}
int time_sync_done_check(void *stream_base){
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		info("Check Sync Done Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
		return ((d&0x00000004) > 0) ? 1 : 0;//bit 2 is done bit
}

int time_sync_responded_check(void *stream_base){
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		info("Check Sync Resp Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
		return ((d&0x00000010) > 0) ? 1 : 0;//bit 4 is done bit
}

void set_sync_on(void *stream_base){
		      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG6_OFFSET, 1);

		      unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG6_OFFSET);
		      	      info("Reg6: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	}
void time_sync_en(void *stream_base){

	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, 0x01);
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	info("Sync-Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	}

void time_sync_mock_en(void *stream_base){
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d|1<<5);
	d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	info("Sync-Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	}

void time_sync_mock_off(void *stream_base){
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d&0xFFFFFFDF);
	d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	info("Sync-Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	}

unsigned get_media_latency(void *time_base){
	unsigned d = ReadReg(time_base, PKT_SEQ_INTERFACE_REG14_OFFSET);
		info("Sync-Reg14: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
		return d;
}

unsigned get_media_round_latency(void *time_base){
	unsigned d = ReadReg(time_base, PKT_SEQ_INTERFACE_REG13_OFFSET);
		info("Sync-Reg13: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
		return d;
}


void set_sync_pkt_dly(void *stream_base, unsigned int v){
	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG5_OFFSET, v);
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG4_OFFSET);
	info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}

void set_sync_rst(void *stream_base){
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d|0x04);//now on bit 2

		d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		info("Sync Reg0 Rst: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
		sleep(1);
		WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d&0xFFFFFFFB);
		d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		info("Sync Reg0 Rst: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

		WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, 0);
		d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		info("Sync Reg0 Clr: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void set_sync_cycle(void *stream_base){
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d|0x04);//now on bit 2

	d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
//	info("Sync Reg0 Rst: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	sleep(1);
	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d&0xFFFFFFFB);
	d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
//	info("Sync Reg0 Rst: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, 0);
	d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
//	info("Sync Reg0 Clr: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	sleep(1);
	//----------------------------------------------------------------
	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, 0x01);
//	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
//	info("Sync-Reg0 Enb: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}



void time_tms_en(void *stream_base){

	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d|0x02);
	d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	}

void time_tms_off(void *stream_base){
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d&0xFFFFFFFD);
	d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	}

unsigned int get_tms_delays(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG10_OFFSET);
	info("The last one way delay from remote device to this device is::%f ms\n", d/SAMPLE_RATE);
	info("Reg10: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}

unsigned int get_tms_delay_mean(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG11_OFFSET);
	info("The one way delay mean of 16 from remote device to this device is::%f ms\n", d/SAMPLE_RATE);
	info("Reg11: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


void set_owdly_cnt(void *stream_base, unsigned int c){
	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG8_OFFSET, c);

	unsigned d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG8_OFFSET);
		info("Reg8: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}
//void set_sync_rst(void *stream_base){
//	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG4_OFFSET, 1);
//	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG4_OFFSET);
//	info("Reg4: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
//
//	sleep(1);
//
//	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG4_OFFSET, 0);
//	d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG4_OFFSET);
//	info("Reg4: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
//
//}

void time_sync_off(void *stream_base){

	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, 0);
	unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	info("TS:Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	}


void time_sync_tx_en(){
	unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);

	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x01);

	unsigned int d = ReadReg(full_udp_stack_ip_base_0, ETH_UDP_REG15_OFFSET);
	info("Reg0F-Ctrl: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));


	}


void time_sync_tx_off(void *stream_base){//Only for debug::dangerous will block reponses so to call it!!!!
	unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFE);

	unsigned int d = ReadReg(full_udp_stack_ip_base_0, ETH_UDP_REG15_OFFSET);
		info("Reg0F-Ctrl: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	}

void initiate_sync(){
	unsigned int d = ReadReg(full_udp_stack_ip_base_0, ETH_UDP_REG15_OFFSET);
		      WriteReg(full_udp_stack_ip_base_0, ETH_UDP_REG15_OFFSET, d|1);
		      d = ReadReg(full_udp_stack_ip_base_0, ETH_UDP_REG15_OFFSET);
		      		      	      info("ERegF: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		      		      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

			  WriteReg(time_sync_base_0, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, 1);
						  d = ReadReg(full_udp_stack_ip_base_0, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
											  info("TReg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
													  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
		      sleep(1);

		      WriteReg(full_udp_stack_ip_base_0, ETH_UDP_REG15_OFFSET, d&0xFFFFFFFE);
		      		      d = ReadReg(full_udp_stack_ip_base_0, ETH_UDP_REG15_OFFSET);
		      		      		      	      info("ERegF: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		      		      		      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));


		      WriteReg(time_sync_base_0, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, 0);
		      d = ReadReg(time_sync_base_0, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		      	      info("Reg0-D: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	}





void set_sync_off(void *stream_base){
		      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG6_OFFSET, 0);
		      unsigned int d = ReadReg(full_udp_stack_ip_base_0, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);

		      		      sleep(1);

		      		      WriteReg(full_udp_stack_ip_base_0, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d&0xFFFFFFFE);
		      d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG6_OFFSET);
		      info("Reg6: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		      		      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	}


void set_tx_hdr_length(void *stream_base, unsigned int data){

	WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG9_OFFSET, data);
	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG9_OFFSET);
		      	      info("Reg9: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}

void set_pcnt_mode_on(void *stream_base){
		  unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET)|0x00000040;
	      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d);

	      d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	      	      info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}


void set_pcnt_mode_off(void *stream_base){
		  unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d&0xFFFFFFBF);

	      d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	      	      info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	      	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}



void set_stream_send_on(void *stream_base){
		  unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d|0x00000100);
	      d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
	      info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	    		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void set_stream_send_off(void *stream_base){
		  unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		  info("A2EReg0 B4: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  				  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	      WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET, d&0xFFFFFEFF);

	      d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		  info("A2EReg0 AF: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}


unsigned get_a2e_state(void *stream_base){
		  unsigned int d = ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET);
		  info("A2E State Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

		  return d;
}



unsigned int get_test_mode(void *stream_base){
		if(ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG0_OFFSET)&0x00000080){
			info("We are in test mode no ADC just a counter\n");
	      return 1;
		}else{
			info("We are in run mode.\n");
		}
}

void set_stream_plen(void *stream_base, unsigned int data){

	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG3_OFFSET, data);
	WriteReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG7_OFFSET, (data-14)/6);
	info("We are setting pkt len to ::%d RL samples\n", ((data-14)/6));

}
unsigned int get_stream_plen(void *stream_base){

	return ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG3_OFFSET);

}
void set_stream_blen(void *stream_base, unsigned int data){

	WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG5_OFFSET, data);

}

void get_media_tx_pcount(void *stream_base, unsigned int data){

	ReadReg(stream_base, AUDIO_TO_ETH_INTERFACE_REG4_OFFSET);

}

unsigned int get_instant_playout_time(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG16_OFFSET);
	info("Reg16: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


unsigned int get_rx_time_code(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG18_OFFSET);
	info("Reg18: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


unsigned int get_rx_time_code_eff(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG19_OFFSET);
	info("Reg19: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


unsigned int get_rx_time_code_fout(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG21_OFFSET);
	info("Reg21: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}



unsigned int get_rx_time_code_occ(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG20_OFFSET);
	info("Reg20: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


unsigned int get_playout_delay(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG11_OFFSET);
	info("Reg11: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


void set_loop_limit(void *stream_base, unsigned int data){

	WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG29_OFFSET, data);
	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG11_OFFSET);
		info("Reg29: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}

void set_playout_delay(void *stream_base, unsigned int data){

	WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG11_OFFSET, data);
	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG11_OFFSET);
		info("Reg11: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}

unsigned int get_instant_playout_writes(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG15_OFFSET);
	info("Reg15: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


unsigned int get_sync_time(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG13_OFFSET);
	info("Reg13: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


unsigned int get_all_eth2audio(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET);
	info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG1_OFFSET);
	info("Reg1: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG2_OFFSET);
	info("Reg2: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG3_OFFSET);
	info("Reg3: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG4_OFFSET);
	info("Reg4: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG5_OFFSET);
	info("Reg5: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG6_OFFSET);
	info("Reg6: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG7_OFFSET);
	info("Reg7: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG8_OFFSET);
	info("Reg8: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG9_OFFSET);
	info("Reg9: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG10_OFFSET);
	info("Reg10: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG11_OFFSET);
	info("Reg11: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG12_OFFSET);
	info("Reg12: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG13_OFFSET);
	info("Reg13: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG14_OFFSET);
	info("Reg14: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG15_OFFSET);
	info("Reg15: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG16_OFFSET);
	info("Reg16: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG17_OFFSET);
	info("Reg17: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG18_OFFSET);
	info("Reg18: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG19_OFFSET);
	info("Reg19: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG23_OFFSET);
		info("Reg23: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG24_OFFSET);
		info("Reg24: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	return d;
}

unsigned int get_dac_fifo_occ(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG23_OFFSET);
	info("Reg23: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


unsigned int get_dac_ofifo_occ(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG23_OFFSET);
	info("Reg23: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}

unsigned int get_dac_dump_pkts(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG22_OFFSET);
	info("Reg22: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}

unsigned int get_dac_efifo_occ(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG24_OFFSET);
	info("Reg24: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}

unsigned int get_dummy(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG18_OFFSET);
	info("Reg18: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


unsigned int get_instant_playout_reads(void *stream_base){

	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG14_OFFSET);
	info("Reg14: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


void reset_pkt_seq(void *stream_base){
	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET, d|0x01);
	//WriteReg(stream_base, PKT_TIME_ENFORCER_REG0_OFFSET, 0x01);
	sleep(1);

	//WriteReg(stream_base, PKT_TIME_ENFORCER_REG0_OFFSET, 0x00);
	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET, d&0xFFFFFFFE);
d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
info("Reg1: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}

void disble_pkt_seq(void *stream_base){
	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET, d|0x02);

	d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
	info("Reg1: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void enable_pkt_seq(void *stream_base){
	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET, d&0xFFFFFFFD);
	d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
	info("Reg1: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void set_stream_porder(void *stream_base, unsigned int data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG0_OFFSET, data);
	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG0_OFFSET);
		info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
						  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}

void set_stream_pkt_wait_enable(void *stream_base){

	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
		WriteReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET, d&0xFFFFFFFB);

		d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
			info("Reg1: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
							  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}


void set_stream_pkt_wait_disable(void *stream_base){

	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
		WriteReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET, d|0x00000004);

		d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
			info("Reg1: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
							  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}


void set_stream_pkt_send_delay_enable(void *stream_base){

	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
		WriteReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET, d&0xFFFFFFF7);

		d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
			info("Reg1: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
							  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}


void set_stream_pkt_send_delay_disable(void *stream_base){

	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
		WriteReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET, d|0x00000008);

		d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG1_OFFSET);
			info("Reg1: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
							  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}



void set_plc_disable(void *stream_base){
unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG0_OFFSET);
		WriteReg(stream_base, PKT_SEQ_INTERFACE_REG0_OFFSET, d&0xFFFFFFEF);


		d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG0_OFFSET);
			info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
							  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}


void set_plc_enable(void *stream_base){

	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG0_OFFSET);
		WriteReg(stream_base, PKT_SEQ_INTERFACE_REG0_OFFSET, d|0x00000010);

		d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG0_OFFSET);
			info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
							  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}



void set_stream_pkt_wait(void *stream_base, unsigned long data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG2_OFFSET, data&0x00000000FFFFFFFF);
	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG3_OFFSET, (data&0xFFFFFFFF00000000)>>32);

	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG2_OFFSET);
	info("Reg2: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG3_OFFSET);
	info("Reg3: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}

void set_stream_pkt_send_delay(void *stream_base, unsigned long data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG4_OFFSET, data&0x00000000FFFFFFFF);
	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG5_OFFSET, (data&0xFFFFFFFF00000000)>>32);

	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG4_OFFSET);
	info("Reg4: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG5_OFFSET);
	info("Reg5: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void set_stream_rx_pkt_size(void *stream_base, unsigned long data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG7_OFFSET, data&0x00000000FFFFFFFF);


	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG7_OFFSET);
	info("Reg7: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void set_stream_rx_buf_lim(void *stream_base, unsigned long data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG6_OFFSET, data&0x00000000FFFFFFFF);


	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG6_OFFSET);
	info("Reg6: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void set_stream_rx_buf_dlim(void *stream_base, unsigned int data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG9_OFFSET, data);


	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG9_OFFSET);
	info("Reg9: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}



void set_stream_rx_buf_docc_lim(void *stream_base, unsigned int data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG11_OFFSET, data);


//	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG11_OFFSET);
//	info("Reg11: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}




void set_stream_rx_buf_slack(void *stream_base, unsigned int data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG10_OFFSET, data);


//	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG11_OFFSET);
//	info("Reg11: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void set_stream_rx_buf_lim2(void *stream_base, unsigned long data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG6_OFFSET, data&0x00000000FFFFFFFF);


	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG6_OFFSET);
	info("Reg6: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


void set_plc_replace_delay(void *stream_base, unsigned int data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG8_OFFSET, data);


	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG8_OFFSET);
	info("Reg8: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}

void set_seq_replace_lock_delay(void *stream_base, unsigned int data){

	WriteReg(stream_base, PKT_SEQ_INTERFACE_REG10_OFFSET, data);


	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG10_OFFSET);
	info("Reg10: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}


unsigned int get_stream_porder(void *stream_base){

	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG0_OFFSET);
		info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
						  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
		return d;
}


unsigned int get_seq_gs(void *stream_base){

	unsigned int d = ReadReg(stream_base, PKT_SEQ_INTERFACE_REG22_OFFSET);
	info("replace_inprogress_out, new_pkt_ready_out, replace_pkt_end_in, replace_pkt_in, 1'b0, to_audio_m_axis_tlast, to_audio_m_axis_tready, to_audio_m_axis_tvalid, 1'b0, fm_udp_s_axis_tlast, fm_udp_s_axis_tready, fm_udp_s_axis_tvalid");
		info("Reg22: "BYTE_TO_BINARY_NIB_PATTERN" "BYTE_TO_BINARY_NIB_PATTERN" "BYTE_TO_BINARY_NIB_PATTERN" "BYTE_TO_BINARY_NIB_PATTERN"\n",
						  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
		return d;
}


unsigned int get_pkts_dropped(void *stream_base){
	return ReadReg(stream_base, PKT_TIME_ENFORCER_REG12_OFFSET);
}

unsigned int get_pkts_replaced(void *stream_base){
	return ReadReg(stream_base, PKT_TIME_ENFORCER_REG13_OFFSET);
}

unsigned int get_seq_pkts_rx(void *stream_base){
	return ReadReg(stream_base, PKT_TIME_ENFORCER_REG21_OFFSET);
}

unsigned int get_seq_pkts_tx(void *stream_base){
	return ReadReg(stream_base, PKT_TIME_ENFORCER_REG20_OFFSET);
}

unsigned int get_seq_pkts_ov(void *stream_base){
	return ReadReg(stream_base, PKT_TIME_ENFORCER_REG19_OFFSET);
}




unsigned long get_pkts_drop_spkt_limit(void *stream_base){
	unsigned long d1 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG3_OFFSET);
	unsigned long d2 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG4_OFFSET);

	return (d2<<32)|d1;
}


unsigned long get_pkts_drop_spkt_locked_limit(void *stream_base){
	unsigned long d1 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG21_OFFSET);
	unsigned long d2 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG22_OFFSET);

	return (d2<<32)|d1;
}


unsigned long get_pkts_adrop_spkt_limit(void *stream_base){
	unsigned long d1 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG5_OFFSET);
	unsigned long d2 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG6_OFFSET);

	return (d2<<32)|d1;
}


unsigned int set_pkts_ptrx_lock(void *stream_base, unsigned int d1){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG8_OFFSET,d1);
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG8_OFFSET);
	if(d&0x01==1){
			info("Packet timming unit locked..:: %08X\n",d);
		}else{
			info("Packet timming unit unlocked..:: %08X\n",d);
		}
	info("Reg8: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	return d;
}


unsigned int set_pkts_pt_accum(void *stream_base, unsigned int d1){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG9_OFFSET,d1);
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG9_OFFSET);
	if(d&0x01==1){
			info("Packet timming unit accum enabled..:: %08X\n",d);
		}else{
			info("Packet timming unit accum disabled..:: %08X\n",d);
		}
	info("Reg9: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	return d;
}


unsigned int get_pkts_pt_accum(void *stream_base){
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG9_OFFSET);
	if(d&0x01==1){
			info("Packet timming unit accum enabled..:: %08X\n",d);
		}else{
			info("Packet timming unit accum disabled..:: %08X\n",d);
		}
	info("Reg9: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	return d;
}



unsigned int set_pkts_pt_diff_status(void *stream_base, unsigned int d1){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG20_OFFSET,d1);
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG20_OFFSET);
	if(d&0x01==1){
			info("Packet timming unit diff enabled..:: %08X\n",d);
		}else{
			info("Packet timming unit diff disabled..:: %08X\n",d);
		}
	info("Reg20: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	return d;
}


unsigned int get_pkts_pt_diff_status(void *stream_base){
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG20_OFFSET);
	if(d&0x01==1){
			info("Packet timming unit accum enabled..:: %08X\n",d);
		}else{
			info("Packet timming unit accum disabled..:: %08X\n",d);
		}
	info("Reg20: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	return d;
}

unsigned int get_pkts_ptrx_lock(void *stream_base){
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG8_OFFSET);
	if(d&0x01==1){
			info("Packet timming unit locked..:: %08X\n",d);
		}else{
			info("Packet timming unit unlocked..:: %08X\n",d);
		}
	info("Reg8: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
		      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	return d;
}


unsigned int get_pkts_pt_disable(void *stream_base){
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG2_OFFSET);
	if(d&0x01==1){
		info("Packet timming unit disabled..:: %08X\n",d);
	}else{
		info("Packet timming unit enabled..:: %08X\n",d);
	}
	info("Reg2: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	return d;
}

unsigned int get_stream_blen(void *stream_base){

	return ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG5_OFFSET);

}

unsigned int get_media_channel_state(void *stream_base){
	unsigned int d = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET);
	info("E2A Reg0:: %08X\n",d);
	info("E2A Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return ((d & (1<<7)) > 0 ? 1 : 0);

}


void enable_media_channel_monitoring(void *stream_base){
	unsigned int d =ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET);// (1<<8);

	WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET , d|(1<<8));
	return;

}

void disable_media_channel_monitoring(void *stream_base){
	unsigned int d =ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET);// (1<<8);

	WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET , d&0xFFFFFEFF);
	return;

}


void set_media_channel_timeout_count(void *stream_base, unsigned int d){
//	unsigned int d =ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG17_OFFSET);// (1<<7);

	WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG17_OFFSET , d);

	return;

}


unsigned int get_stream_readout_delay(void *stream_base){
	unsigned int d1 = ReadReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG6_OFFSET);
	info("The  RX buffer occupancy :: %d\n",((int)d1));
	return d1;

}


unsigned int get_stream_net_delay(void *stream_base){

	return ReadReg(stream_base, PKT_TIME_ENFORCER_REG10_OFFSET);

}

unsigned int get_stream_pktbuild_delay(void *stream_base){

	return ReadReg(stream_base, PKT_TIME_ENFORCER_REG11_OFFSET);

}


unsigned long get_stream_accum_pkt_delay(void *stream_base){

		unsigned int d1 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG12_OFFSET);
		unsigned int d2 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG13_OFFSET);
		info("The Accum Packet to Packet delay is :: %d\n",(d1));
		info("The Accum Packet to Packet delay is :: %f ms\n",(d1)/SAMPLE_RATE);
		return d1;
	}

unsigned long get_stream_spkt_delay(void *stream_base){

		unsigned int d1 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG14_OFFSET);
		unsigned int d2 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG15_OFFSET);
		info("The Packet to Packet delay is :: %d\n",(d1));
		info("The Packet to Packet delay is :: %f ms\n",(d1)/SAMPLE_RATE);
		return d1;

}

unsigned int set_stream_net_delay(void *stream_base, unsigned int d1){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG10_OFFSET,d1);
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG10_OFFSET);

	info("Reg10: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	return d;
}


unsigned int set_stream_pktbuild_delay(void *stream_base, unsigned int d1){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG11_OFFSET,d1);
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG11_OFFSET);

	info("Reg11: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
	return d;
}



void set_spkt_to_pkt_delay_limit(void *stream_base, unsigned long data){

	WriteReg(stream_base, PKT_TIME_ENFORCER_REG3_OFFSET, data&0x00000000FFFFFFFF);
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG4_OFFSET, (data&0xFFFFFFFF00000000)>>32);

}


void set_spkt_to_pkt_locked_delay_limit(void *stream_base, unsigned long data){

	WriteReg(stream_base, PKT_TIME_ENFORCER_REG21_OFFSET, data&0x00000000FFFFFFFF);
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG22_OFFSET, (data&0xFFFFFFFF00000000)>>32);

}



void set_diff_pkt_to_pkt_delay_limit(void *stream_base, unsigned long data){

	WriteReg(stream_base, PKT_TIME_ENFORCER_REG16_OFFSET, data&0x00000000FFFFFFFF);
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG17_OFFSET, (data&0xFFFFFFFF00000000)>>32);

	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG16_OFFSET);

		info("Reg16: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));


		d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG17_OFFSET);

	info("Reg17: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

}

unsigned long get_diff_pkt_to_pkt_delay_limit(void *stream_base){

		unsigned int d1 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG16_OFFSET);
		unsigned int d2 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG17_OFFSET);
		info("The Diff Packet to Packet delay Limit is :: %d\n",(d1));
		info("The Diff Packet to Packet delay Limit is :: %f ms\n",(d1)/SAMPLE_RATE);
		return d1;
	}


unsigned long get_diff_pkt_to_pkt_delay(void *stream_base){

		unsigned int d1 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG18_OFFSET);
		unsigned int d2 = ReadReg(stream_base, PKT_TIME_ENFORCER_REG19_OFFSET);
		info("The Accum Packet to Packet delay is :: %d\n",(d1));
		info("The Accum Packet to Packet delay is :: %f ms\n",(d1)/SAMPLE_RATE);
		return d1;
	}
unsigned long get_in_exec_state(void *stream_base){

	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG15_OFFSET);

	info("IN_EXEC_STATE: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}

unsigned long get_out_exec_state(void *stream_base){

	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG16_OFFSET);

	info("OUT_EXEC_STATE: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}


unsigned long get_core_version(void *stream_base){

	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG32_OFFSET);

	info("CORE_VERSION: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
				      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));

	return d;
}

void set_accum_pkt_to_pkt_delay_limit(void *stream_base, unsigned long data){

	WriteReg(stream_base, PKT_TIME_ENFORCER_REG5_OFFSET, data&0x00000000FFFFFFFF);
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG6_OFFSET, (data&0xFFFFFFFF00000000)>>32);

}


void reset_pkt_time_enf(void *stream_base){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG0_OFFSET, 0x01);
	sleep(1);
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG0_OFFSET, 0x00);
}
void reset_pkt_time_enf_rx(void *stream_base){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG1_OFFSET, 0x01);
	sleep(1);
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG1_OFFSET, 0x00);
}
void pkt_time_enf_disable(void *stream_base){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG2_OFFSET, 0x01);
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG2_OFFSET);
	info("Reg2: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}
void pkt_time_enf_enable(void *stream_base){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG2_OFFSET, 0x00);
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG2_OFFSET);
	info("Reg2: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}


void pkt_to_pkt_locked_drop_enable(void *stream_base){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG23_OFFSET, 0x01);
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG23_OFFSET);
	info("Reg23: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}


void pkt_to_pkt_locked_drop_disable(void *stream_base){
	WriteReg(stream_base, PKT_TIME_ENFORCER_REG23_OFFSET, 0x00);
	unsigned int d = ReadReg(stream_base, PKT_TIME_ENFORCER_REG23_OFFSET);
	info("Reg23: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
			      BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}



void stream_source_select(void *stream_base, FIFO_ID fifo, unsigned int data){
	  if (fifo == ADC_FIFO_ID) {
	      WriteReg(stream_base, ETH_TO_AUDIO_INTERFACE_REG0_OFFSET, data);
	    }
	    else if (fifo == DAC_FIFO_ID) {
	      WriteReg(stream_base, AUDIO_TO_AXI_INTERFACE_REG0_OFFSET, data);
	    }
}

void write_audio_to_eth_param(void *audio_to_eth_base, AUDIO_TO_ETH_REG_ID param, unsigned int data){
	if (param == PAYLEN_REG_ID) {
		  WriteReg(audio_to_eth_base, ETH_UDP_REG3_OFFSET, data);
		}
}


void write_eth_param(void *eth_base, ETH_PARAM_ID param, unsigned int data){
	if (param == LOCAL_IP_ID) {
		  WriteReg(eth_base, ETH_UDP_REG2_OFFSET, data);
		}
		else if (param == GTWAY_IP_ID) {
		  WriteReg(eth_base, ETH_UDP_REG3_OFFSET, data);
		}
		else if (param == MASK_IP_ID) {
		  WriteReg(eth_base, ETH_UDP_REG4_OFFSET, data);
		}
	else if (param == DEST_IP_ID) {
	  WriteReg(eth_base, ETH_UDP_REG5_OFFSET, data);
	  WriteReg(eth_base, ETH_UDP_REG7_OFFSET, data);
	  WriteReg(eth_base, ETH_UDP_REG9_OFFSET, data);
	  WriteReg(eth_base, ETH_UDP_REG11_OFFSET, data);
	  WriteReg(eth_base, ETH_UDP_REG13_OFFSET, data);
	}
	else if (param == DEST_PORT_ID) {
		  WriteReg(eth_base, ETH_UDP_REG6_OFFSET, data);
		  WriteReg(eth_base, ETH_UDP_REG8_OFFSET, data);
		  WriteReg(eth_base, ETH_UDP_REG10_OFFSET, data);
		  WriteReg(eth_base, ETH_UDP_REG12_OFFSET, data);
		  WriteReg(eth_base, ETH_UDP_REG14_OFFSET, data);
		}

	else if (param == PKT_LEN_ID) {//not writen from command but depends on payload command
		  WriteReg(eth_base, ETH_UDP_REG18_OFFSET, data);
		}
	else if (param == ETH_CONTROL_ID) {//not writen from command but depends on payload command
		WriteReg(eth_base, ETH_UDP_REG15_OFFSET, data);
	}
	else if (param == SYNC_IP_ID) {
		WriteReg(eth_base, ETH_UDP_REG16_OFFSET, data);
	}
	else if (param == SYNC_PORT_ID) {
		WriteReg(eth_base, ETH_UDP_REG6_OFFSET, data);
	}
	else if (param == ARP1_ID) {//0x12//IP Addr
		WriteReg(eth_base, ETH_UDP_REG18_OFFSET, data);
	}
	else if (param == ARP2_ID) {//0x13//IP Addr
		WriteReg(eth_base, ETH_UDP_REG19_OFFSET, data);
	}
	else if (param == ARP3_ID) {//0x14//IP Addr
		WriteReg(eth_base, ETH_UDP_REG20_OFFSET, data);
	}
	else if (param == ARP4_ID) {//0x15//IP Addr
		WriteReg(eth_base, ETH_UDP_REG21_OFFSET, data);
	}
	else if (param == ARP5_ID) {//0x16//IP Addr
		WriteReg(eth_base, ETH_UDP_REG22_OFFSET, data);
	}else{
		info("\n-----------------write_eth_param parameter undefined....--------------\n");
	}
}



void write_switch_param(void *sw_base, SW_PARAM_ID param, unsigned int data){

	switch(param){
//	case LMAC_ID: needs separate function
//	break;
	case PORT1_ID:
		WriteReg(sw_base, ETH_UDP_REG2_OFFSET, data);
		break;
	case PORT2_ID:
		WriteReg(sw_base, ETH_UDP_REG3_OFFSET, data);
		break;
	case PORT3_ID:
		WriteReg(sw_base, ETH_UDP_REG4_OFFSET, data);
		break;
	case PORT4_ID:
		WriteReg(sw_base, ETH_UDP_REG5_OFFSET, data);
		break;
	case PORT5_ID:
		WriteReg(sw_base, ETH_UDP_REG6_OFFSET, data);
		break;
	case PORT6_ID:
		WriteReg(sw_base, ETH_UDP_REG7_OFFSET, data);
		break;
	case PORT7_ID:
		WriteReg(sw_base, ETH_UDP_REG8_OFFSET, data);
		break;
	case PORT8_ID:
		WriteReg(sw_base, ETH_UDP_REG9_OFFSET, data);
		break;
	case SW_CONTROL_ID:
		WriteReg(sw_base, ETH_UDP_REG15_OFFSET, data);
		break;
	default:
		info("Switch parameter ID not found!!\n");
		break;
	}



}


void print_switch_param(void *sw_base){
 unsigned int d;
d = ReadReg(sw_base, ETH_UDP_REG2_OFFSET);
info("SW_UDP Filter Table: PORT1: %d\n",d);
d = ReadReg(sw_base, ETH_UDP_REG3_OFFSET);
info("SW_UDP Filter Table: PORT2: %d\n",d);
d = ReadReg(sw_base, ETH_UDP_REG4_OFFSET);
info("SW_UDP Filter Table: PORT3: %d\n",d);
d = ReadReg(sw_base, ETH_UDP_REG5_OFFSET);
info("SW_UDP Filter Table: PORT4: %d\n",d);
d = ReadReg(sw_base, ETH_UDP_REG6_OFFSET);
info("SW_UDP Filter Table: PORT5: %d\n",d);
d = ReadReg(sw_base, ETH_UDP_REG7_OFFSET);
info("SW_UDP Filter Table: PORT6: %d\n",d);
d = ReadReg(sw_base, ETH_UDP_REG8_OFFSET);
info("SW_UDP Filter Table: PORT7: %d\n",d);
d = ReadReg(sw_base, ETH_UDP_REG9_OFFSET);
info("SW_UDP Filter Table: PORT8: %d\n",d);
}


void write_eth_mac(void *eth_base, ETH_PARAM_ID param, unsigned char * mac){
	if (param == MAC_ID) {

	  WriteReg(eth_base, ETH_UDP_REG0_OFFSET, (unsigned)(mac[0]<<16|mac[1]<<8|mac[2]));
	  WriteReg(eth_base, ETH_UDP_REG1_OFFSET, (unsigned)(mac[3]<<16|mac[4]<<8|mac[5]));

	}else if (param == ARP1_ID) {//Gateway MAC position 0x17, 0x18

	  WriteReg(eth_base, ETH_UDP_REG23_OFFSET, (unsigned)(mac[0]<<16|mac[1]<<8|mac[2]));
	  WriteReg(eth_base, ETH_UDP_REG24_OFFSET, (unsigned)(mac[3]<<16|mac[4]<<8|mac[5]));

	}else if (param == ARP2_ID) {//AMAC2 position 0x19, 0x1A

	  WriteReg(eth_base, ETH_UDP_REG25_OFFSET, (unsigned)(mac[0]<<16|mac[1]<<8|mac[2]));
	  WriteReg(eth_base, ETH_UDP_REG26_OFFSET, (unsigned)(mac[3]<<16|mac[4]<<8|mac[5]));

	}else if (param == ARP3_ID) {//AMAC3 position 0x1B, 0x1C

	  WriteReg(eth_base, ETH_UDP_REG27_OFFSET, (unsigned)(mac[0]<<16|mac[1]<<8|mac[2]));
	  WriteReg(eth_base, ETH_UDP_REG28_OFFSET, (unsigned)(mac[3]<<16|mac[4]<<8|mac[5]));

	}else if (param == ARP4_ID) {//AMAC4 position 0x1D, 0x1E

	  WriteReg(eth_base, ETH_UDP_REG29_OFFSET, (unsigned)(mac[0]<<16|mac[1]<<8|mac[2]));
	  WriteReg(eth_base, ETH_UDP_REG30_OFFSET, (unsigned)(mac[3]<<16|mac[4]<<8|mac[5]));

	}else if (param == ARP5_ID) {//AMAC5 position 0x1F, 0x20

	  WriteReg(eth_base, ETH_UDP_REG31_OFFSET, (unsigned)(mac[0]<<16|mac[1]<<8|mac[2]));
	  WriteReg(eth_base, ETH_UDP_REG32_OFFSET, (unsigned)(mac[3]<<16|mac[4]<<8|mac[5]));

	}else{
		info("\n--------------------write_eth_mac: Eth MAC undefined..............");
	}
}



unsigned long read_eth_mac(void *eth_base, ETH_PARAM_ID param, char* ip){
	unsigned int d0, d1;
	unsigned long mac ;
	if (param == MAC_REG_ID) {
	  d0 = ReadReg(eth_base, ETH_UDP_REG0_OFFSET);
	  d1 = ReadReg(eth_base, ETH_UDP_REG1_OFFSET);
	  info("MAC Address Part 1: 0x%X\n",d0);
	  info("MAC Address Part 2: 0x%X\n",d1);
	  info("MAC Address: %02X:%02X:%02X:%02X:%02X:%02X\n", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
	  sprintf(ip, "%02X:%02X:%02X:%02X:%02X:%02X\0", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
	}
	else if (param == ARP_MAC1_REG_ID) {//Gateway MAC position 0x17, 0x18
	  d0 = ReadReg(eth_base, ETH_UDP_REG23_OFFSET);
	  d1 = ReadReg(eth_base, ETH_UDP_REG24_OFFSET);
	  info("ARP MAC1 Address Part 1: 0x%X\n",d0);
	  info("ARP MAC1 Address Part 2: 0x%X\n",d1);
	  info("ARP MAC1 Address: %02X:%02X:%02X:%02X:%02X:%02X\n", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
	  sprintf(ip, "%02X:%02X:%02X:%02X:%02X:%02X\0", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
	}
	else if (param == ARP_MAC2_REG_ID) {//AMAC2 position 0x19, 0x1A
	  d0 = ReadReg(eth_base, ETH_UDP_REG25_OFFSET);
	  d1 = ReadReg(eth_base, ETH_UDP_REG26_OFFSET);
	  info("ARP MAC2 Address Part 1: 0x%X\n",d0);
	  info("ARP MAC2 Address Part 2: 0x%X\n",d1);
	  info("ARP MAC2 Address: %02X:%02X:%02X:%02X:%02X:%02X\n", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
	  sprintf(ip, "%02X:%02X:%02X:%02X:%02X:%02X\0", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
	}
	else if (param == ARP_MAC3_REG_ID) {//AMAC3 position 0x1B, 0x1C
		  d0 = ReadReg(eth_base, ETH_UDP_REG27_OFFSET);
		  d1 = ReadReg(eth_base, ETH_UDP_REG28_OFFSET);
		  info("ARP MAC3 Address Part 1: 0x%X\n",d0);
		  info("ARP MAC3 Address Part 2: 0x%X\n",d1);
		  info("ARP MAC3 Address: %02X:%02X:%02X:%02X:%02X:%02X\n", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
		  sprintf(ip, "%02X:%02X:%02X:%02X:%02X:%02X\0", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
		}
	else if (param == ARP_MAC4_REG_ID) {//AMAC4 position 0x1D, 0x1E
		  d0 = ReadReg(eth_base, ETH_UDP_REG29_OFFSET);
		  d1 = ReadReg(eth_base, ETH_UDP_REG30_OFFSET);
		  info("ARP MAC4 Address Part 1: 0x%X\n",d0);
		  info("ARP MAC4 Address Part 2: 0x%X\n",d1);
		  info("ARP MAC4 Address: %02X:%02X:%02X:%02X:%02X:%02X\n", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
		  sprintf(ip, "%02X:%02X:%02X:%02X:%02X:%02X\0", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
		}
	else if (param == ARP_MAC5_REG_ID) {//AMAC5 position 0x1F, 0x20
		  d0 = ReadReg(eth_base, ETH_UDP_REG31_OFFSET);
		  d1 = ReadReg(eth_base, ETH_UDP_REG32_OFFSET);
		  info("ARP MAC5 Address Part 1: 0x%X\n",d0);
		  info("ARP MAC5 Address Part 2: 0x%X\n",d1);
		  info("ARP MAC5 Address: %02X:%02X:%02X:%02X:%02X:%02X\n", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
		  sprintf(ip, "%02X:%02X:%02X:%02X:%02X:%02X\0", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
		}
	else if (param == ARP_OMAC_REG_ID) {//AMAC5 position 0x1F, 0x20
		  d0 = ReadReg(eth_base, ETH_UDP_REG33_OFFSET);
		  d1 = ReadReg(eth_base, ETH_UDP_REG34_OFFSET);
		  info("ARP OMAC Address Part 1: 0x%X\n",d0);
		  info("ARP OMAC Address Part 2: 0x%X\n",d1);
		  info("ARP MACO Address: %02X:%02X:%02X:%02X:%02X:%02X\n", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
		  sprintf(ip, "%02X:%02X:%02X:%02X:%02X:%02X\0", (d0 >> 16) & 0x000000FF, (d0 >> 8) & 0x000000FF, d0 & 0x000000FF, (d1 >> 16) & 0x000000FF, (d1 >> 8) & 0x000000FF, d1 & 0x000000FF);
		}
	else{
		return -1;
	}
	mac = ((d0&0x00FFFFFF)<<24) | (d1&0x00FFFFFF);
	return mac;
}

/**
 * =======================================================
 * read_eth_status_regs reads 4 bytes unsigned int data
 * from the specified channel
 * @param   : eth_base  : base address of the stream
 * @param   : param      : reg ID
 * @return  : returns 4 bytes unsigned int data
 * =======================================================
 *  slv_reg0_mac;
 *  slv_reg1_mac;
 *  slv_reg2_local_ip;
 *  slv_reg3_gateway_ip;
 *  slv_reg4_subnet_mask;
 *  slv_reg5_dest_ip;
 *  slv_reg6_dest_port;
 *  slv_reg7_loop_timer;
 *  slv_reg8_latency_timer;
 *  slv_reg9_sample_fifo_timer;
 *  slv_regA_net_errors;
 *  slv_regB_lost_packets;
 *  slv_regC_tx_packets;
 *  slv_regD_rx_packets;
 *  slv_regE_length;
 *  slv_regF_ctrl;
 * =======================================================
 */
unsigned read_eth_param (void *eth_base, ETH_REG_ID param) {
	unsigned buffer = 0;
	if (eth_base == NULL) {
		info("Error eth_base address is NULL..\n\n");
		return -1;
	}

    if (param == LOCAL_IP_REG_ID) {
    	buffer = ReadReg(eth_base, ETH_UDP_REG2_OFFSET);
	}
	else if (param == GTWAY_IP_REG_ID) {
		buffer = ReadReg(eth_base, ETH_UDP_REG3_OFFSET);
	}
	else if (param == MASK_IP_REG_ID) {
		buffer = ReadReg(eth_base, ETH_UDP_REG4_OFFSET);
	}
  	else if (param == DEST_IP_REG_ID) {
  		buffer = ReadReg(eth_base, ETH_UDP_REG5_OFFSET);
  	}
  	else if (param == SYNC_PORT_REG_ID) {
  		buffer = ReadReg(eth_base, ETH_UDP_REG6_OFFSET);
  		}
  	else if (param == DEST_PORT_REG_ID) {
  		buffer = ReadReg(eth_base, ETH_UDP_REG6_OFFSET);
	}
  	else if (param == LOOP_TIMER_REG_ID) {
  	  	buffer = ReadReg(eth_base, ETH_UDP_REG7_OFFSET);
    }
  	else if (param == LATENCY_TIMER_REG_ID) {
  	  	buffer = ReadReg(eth_base, ETH_UDP_REG8_OFFSET);
  	}
  	else if (param == SAMPLE_FIFO_TIMER_REG_ID) {
  	  	buffer = ReadReg(eth_base, ETH_UDP_REG9_OFFSET);
  	}
  	else if (param == NET_ERRORS_REG_ID) {
  	  	buffer = ReadReg(eth_base, ETH_UDP_REG10_OFFSET);
  	}
  	else if (param == LOST_PACKETS_REG_ID) {
  	  	buffer = ReadReg(eth_base, ETH_UDP_REG11_OFFSET);
  	}
  	else if (param == TX_PACKETS_REG_ID) {
  	  	buffer = ReadReg(eth_base, ETH_UDP_REG12_OFFSET);
  	}
  	else if (param == RX_PACKETS_REG_ID) {
  	  	buffer = ReadReg(eth_base, ETH_UDP_REG13_OFFSET);
  	}
  	else if (param == PACKET_LENGTH_REG_ID) {
  	  	buffer = ReadReg(eth_base, ETH_UDP_REG18_OFFSET);
  	}
  	else if (param == ETH_CONTROL_REG_ID) {//not read from command but depends on payload command
  		buffer = ReadReg(eth_base, ETH_UDP_REG15_OFFSET);
	}
  	else if (param == ARP_STATE_REG_ID) {
  	  	buffer = ReadReg(eth_base, ETH_UDP_REG14_OFFSET);
  	  	unsigned int d = buffer;
  	  	info("ARP state bits ::\n");
  	  	info("Reg14: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
  	  					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
  	  	}
	else {
		info("Error requested register does not exist..\n\n");
		return -1;

	}
  return buffer;
}


unsigned read_eth_reg (void *eth_base, int num) {
	unsigned int d = ReadReg(eth_base, num*4);
	info("ETH REG 0x%02X ::\n", num);
	  	  	info("Reg: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	  	  					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}



unsigned read_switch_reg (void *eth_base, int num) {
	unsigned int d = ReadReg(eth_base, num*4);
	info("SW REG 0x%X ::\n", num);
	  	  	info("Reg: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	  	  					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}



unsigned read_sync_reg (void *eth_base, int num) {
	unsigned int d = ReadReg(eth_base, num*4);
	info("TS REG 0x%02X ::\n", num);
	  	  	info("Reg: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	  	  					  BYTE_TO_BINARY(d>>24),BYTE_TO_BINARY(d>>16),BYTE_TO_BINARY(d>>8), BYTE_TO_BINARY(d));
}
