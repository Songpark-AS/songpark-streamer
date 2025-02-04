

/***************************** Include Files *******************************/
#include <stdio.h>
#include "include/adau1761_controller.h"
/************************** Function Definitions ***************************/
/*
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */



void write_adau1761(uint32_t addr, uint64_t data, uint32_t nbytes) {
    uint32_t busy;
    uint32_t control_word = (nbytes - 1) << NBYTES_POS | addr << ADDR_POS;
    uint32_t data_low = data << (8 * (8 - nbytes));
    uint32_t data_high = (data << (8 * (8 - nbytes))) >> 32;
    ADAU1761_CONTROLLER_mWriteReg(AUDIO_BASE, WRITE_LOW_DATA_ADDR, data_low);
    ADAU1761_CONTROLLER_mWriteReg(AUDIO_BASE, WRITE_HIGH_DATA_ADDR, data_high);
    ADAU1761_CONTROLLER_mWriteReg(AUDIO_BASE, CTRL_ADDR, control_word);
    ADAU1761_CONTROLLER_mWriteReg(AUDIO_BASE, CTRL_ADDR, control_word | (1<<START_POS));
    while ((busy = ADAU1761_CONTROLLER_mReadReg(AUDIO_BASE, BUSY_ADDR)))
        ;
}

uint64_t read_adau1761(uint32_t addr, uint32_t nbytes) {
    uint32_t busy;
    uint32_t control_word = 1 << READ_POS | (nbytes - 1) << NBYTES_POS | addr << ADDR_POS;
    uint64_t data_low;
    uint64_t data_high;
    ADAU1761_CONTROLLER_mWriteReg(AUDIO_BASE, CTRL_ADDR, control_word);
    ADAU1761_CONTROLLER_mWriteReg(AUDIO_BASE, CTRL_ADDR, control_word | (1<<START_POS));
    while ((busy = ADAU1761_CONTROLLER_mReadReg(AUDIO_BASE, BUSY_ADDR)))
        ;
    data_low = ADAU1761_CONTROLLER_mReadReg(AUDIO_BASE, READ_LOW_DATA_ADDR);
    data_high = ADAU1761_CONTROLLER_mReadReg(AUDIO_BASE, READ_HIGH_DATA_ADDR);
    return ((data_high << 32) | data_low) & ((1LL << 8 * nbytes) - 1);
}

void reset_adau1761(void) {
	printf("write adau1761 \n\r");
	printf ("Adau1761 Device address is::0x%08X!!!\n",AUDIO_BASE);
    ADAU1761_CONTROLLER_mWriteReg(AUDIO_BASE, CTRL_ADDR, 1<<RESET_POS);
    ADAU1761_CONTROLLER_mWriteReg(AUDIO_BASE, CTRL_ADDR, 0);
    printf("read adau1761 \n\r");
    read_adau1761(0, 1);
    read_adau1761(0, 1);
    read_adau1761(0, 1);
}

/***
The problem seems to be the PLL that is used within the ADAU 1761 codec which causes the signal jitter.
The solution:
1. in the ZYNQ device configure the clock-PLL to generate 12.5MHz MCLK output (Xilinx uses 10 MHz)
2. in the i2s_audio. c driver modify the AudioPllConfig() routine:
- send 0x01 to the R0_CLOCK_CONTROL register. This disables the internal PLL of the codec and uses the MCLK with divider 256 (i.e generates 48.828kHz sample rate) also enables the core clock.
- disable sending 0xF to the R0_CLOCK_CONTROL register at the end of the routine!

 *
 *
 */
void init_adau1761(void) {
    volatile int i;
    //  setup PLL
    //write_adau1761(0x4000, 0x0e, 1);
    //  Configure PLL
    //write_adau1761(0x4002, 0x007d000c2301, 6);
    //  Wait for PLL to lock
//    printf("init_adau1761()::Wait for PLL to lock \n\r");
//    while (!(read_adau1761(0x4002, 6) & 2))
//        ;
    //  Enable clock to core
//    write_adau1761(0x4000, 0xf, 1);
//    write_adau1761(0x4000, 0x01, 1); // MCLK == 24.576 fs == 96kHz
//    write_adau1761(0x4000, 0x03, 1); // MCLK == 24.576 fs == 48kHz
    write_adau1761(0x4000, 0x01, 1);   // MCLK == 12.288 fs == 48kHz
    //  delay
    usleep(1000000);

    //  I2S master mode
    write_adau1761(0x4015, 0x01, 1);
    //  left mixer enable, mic 6dB
//    write_adau1761(0x400a, 0x0f, 1);
//    write_adau1761(0x400a, 0x5b, 1);//0db
    write_adau1761(0x400a, 0x01, 1);//muted
    //  left mixer enable, mic 0dB
    //write_adau1761(0x400a, 0x01, 1);
    //  left 6db
//    write_adau1761(0x400b, 0x07, 1);
    write_adau1761(0x400b, 0x0D, 1);//0db
    //  left 0db
    //write_adau1761(0x400b, 0x05, 1);
    //  right mixer enable, mic 6dB
//    write_adau1761(0x400c, 0x0f, 1);
//    write_adau1761(0x400c, 0x5b, 1);//0db
    write_adau1761(0x400c, 0x01, 1);//muted
    //  right mixer enable, mic 0dB
    //write_adau1761(0x400c, 0x01, 1);
    //  right 6db
//    write_adau1761(0x400d, 0x07, 1);
    write_adau1761(0x400d, 0x0D, 1);//0db
    //  right 0db
    //write_adau1761(0x400d, 0x05, 1);
    // Mic bias
    write_adau1761(0x4010, 0x5, 1);
    //  Playback left mixer unmute, enable, Unmutes the left DAC input to the left channel playback mixer (Mixer 3).
    write_adau1761(0x401c, 0x21, 1);
//    write_adau1761(0x401d, 0x66, 1); not needed we need to control the local input play back from the core vol

    //  Playback right mixer unmute, enable, Unmutes the right DAC input to the right channel playback mixer (Mixer 4).
    write_adau1761(0x401e, 0x41, 1);
    //write_adau1761(0x401e, 0x6D, 1);

//    write_adau1761(0x401f, 0x66, 1);  not needed we need to control the local input play back from the core vol


    //  Enable line out mixer left
	write_adau1761(0x4020, 0x05, 1);
	//  Enable line out mixer right
	write_adau1761(0x4021, 0x11, 1);


    //  Enable headphone output left
    write_adau1761(0x4023, 0xe7, 1);
    //  Enable headphone output right
    write_adau1761(0x4024, 0xe7, 1);

    //  Enable line out left
    write_adau1761(0x4025, 0xe7, 1);
    //  Enable line out right
    write_adau1761(0x4026, 0xe7, 1);

    //Configure ADC/DAC sample rate 96khz
#if (AUDIO_RATE == 96)
    write_adau1761(0x4017, 0x06, 1); //96KHz
#elif(AUDIO_RATE == 48)
    write_adau1761(0x4017, 0x00, 1);//48kHz
#else
#error("Please set the audio sampling rate!!!");
#endif

    //Configure SERIAL port sample rate    96khz

#if (AUDIO_RATE == 96)
    write_adau1761(0x40F8, 0x06, 1);//96kHz
#elif(AUDIO_RATE == 48)
    write_adau1761(0x40F8, 0x00, 1);//48kHz
#else
#error("Please set the audio sampling rate!!!");
#endif


    //Configure DSP sample rate  Set to input data rate
    write_adau1761(0x40EB, 0x07, 1);//take line rate
//    write_adau1761(0x40EB, 0x01, 1);//48kHz

    write_adau1761(0x40f5, 0x00, 1);
    write_adau1761(0x40f6, 0x00, 1);
    write_adau1761(0x40f7, 0x00, 1);



    //  Enable both ADCs
    write_adau1761(0x4019, 0x13, 1);//Both channels on reverse mic polarity
    //  Enable playback both channels
    write_adau1761(0x4029, 0x03, 1);
    //  Enable both DACs
    write_adau1761(0x402a, 0x03, 1);


    // Set DAC volume to 0 db
    write_adau1761(0x402b, 0x00, 1);
    write_adau1761(0x402c, 0x00, 1);



    //  Serial input L0,R0 to DAC L,R
    write_adau1761(0x40f2, 0x01, 1);
    //  Serial output ADC L,R to serial output L0,R0
    write_adau1761(0x40f3, 0x01, 1);
    //  Enable clocks to all engines
    write_adau1761(0x40f9, 0x7f, 1);
//    write_adau1761(0x40f9, 0x0B, 1);
    //  Enable both clock generators
    write_adau1761(0x40fa, 0x03, 1);
}

void init_adau1761_pll(void) {
    volatile int i;
    //  setup PLL
    write_adau1761(0x4000, 0x0e, 1);
    //  Configure PLL
    write_adau1761(0x4002, 0x007d000c2301, 6);//24MHz
//    write_adau1761(0x4002, 0x007d000c2001, 6);//12.288MHz
    //  Wait for PLL to lock
    printf("init_adau1761()::Wait for PLL to lock \n\r");
    while (!(read_adau1761(0x4002, 6) & 2))
        ;
    //  Enable clock to core
    write_adau1761(0x4000, 0xf, 1);
    //  delay
    usleep(1000000);

    //  I2S master mode
    write_adau1761(0x4015, 0x01, 1);
    //  left mixer enable, mic 6dB
    write_adau1761(0x400a, 0x0f, 1);
    //  left mixer enable, mic 0dB
    //write_adau1761(0x400a, 0x01, 1);
    //  left 6db
    write_adau1761(0x400b, 0x07, 1);
    //  left 0db
    //write_adau1761(0x400b, 0x05, 1);
    //  right mixer enable, mic 6dB
    write_adau1761(0x400c, 0x0f, 1);
    //  right mixer enable, mic 0dB
    //write_adau1761(0x400c, 0x01, 1);
    //  right 6db
    write_adau1761(0x400d, 0x07, 1);
    //  right 0db
    //write_adau1761(0x400d, 0x05, 1);
    // Mic bias
    write_adau1761(0x4010, 0x5, 1);
    //  Playback left mixer unmute, enable
    write_adau1761(0x401c, 0x21, 1);
//    write_adau1761(0x401d, 0x66, 1); not needed we need to control the local input play back from the core vol

    //  Playback right mixer unmute, enable
    write_adau1761(0x401e, 0x21, 1);
    //write_adau1761(0x401e, 0x6D, 1);

//    write_adau1761(0x401f, 0x66, 1);  not needed we need to control the local input play back from the core vol


    //  Enable line out mixer left
	write_adau1761(0x4020, 0x05, 1);
	//  Enable line out mixer right
	write_adau1761(0x4021, 0x11, 1);


    //  Enable headphone output left
    write_adau1761(0x4023, 0xe7, 1);
    //  Enable headphone output right
    write_adau1761(0x4024, 0xe7, 1);

    //  Enable line out left
    write_adau1761(0x4025, 0xe7, 1);
    //  Enable line out right
    write_adau1761(0x4026, 0xe7, 1);

    //Configure ADC/DAC sample rate 96khz
#if (AUDIO_RATE == 96)
    write_adau1761(0x4017, 0x06, 1); //96KHz
#elif(AUDIO_RATE == 48)
    write_adau1761(0x4017, 0x00, 1);//48kHz
#else
#error("Please set the audio sampling rate!!!");
#endif

    //Configure SERIAL port sample rate    96khz

#if (AUDIO_RATE == 96)
    write_adau1761(0x40F8, 0x06, 1);//96kHz
#elif(AUDIO_RATE == 48)
    write_adau1761(0x40F8, 0x00, 1);//48kHz
#else
#error("Please set the audio sampling rate!!!");
#endif


    //Configure DSP sample rate  Set to input data rate
    write_adau1761(0x40EB, 0x07, 1);//take line rate
//    write_adau1761(0x40EB, 0x01, 1);//48kHz

    write_adau1761(0x40f5, 0x00, 1);
    write_adau1761(0x40f6, 0x00, 1);
    write_adau1761(0x40f7, 0x00, 1);



    //  Enable both ADCs
    write_adau1761(0x4019, 0x03, 1);
    //  Enable playback both channels
    write_adau1761(0x4029, 0x03, 1);
    //  Enable both DACs
    write_adau1761(0x402a, 0x03, 1);


    // Set DAC volume to 0 db
    write_adau1761(0x402b, 0x00, 1);
    write_adau1761(0x402c, 0x00, 1);



    //  Serial input L0,R0 to DAC L,R
    write_adau1761(0x40f2, 0x01, 1);
    //  Serial output ADC L,R to serial output L0,R0
    write_adau1761(0x40f3, 0x01, 1);
    //  Enable clocks to all engines
    write_adau1761(0x40f9, 0x7f, 1);
//    write_adau1761(0x40f9, 0x0B, 1);
    //  Enable both clock generators
    write_adau1761(0x40fa, 0x03, 1);
}


/* ---------------------------------------------------------------------------- *
 * 								AudioConfigureJacks()							*
 * ---------------------------------------------------------------------------- *
 * Configures audio codes's various mixers, ADC's, DAC's, and amplifiers to
 * accept stereo input from line in and push stereo output to line out.
 * ---------------------------------------------------------------------------- */
void AudioConfigureJacks()
{
	write_adau1761(R4_RECORD_MIXER_LEFT_CONTROL_0, 0x01, 0x01); //enable mixer 1
	write_adau1761(R5_RECORD_MIXER_LEFT_CONTROL_1, 0x07, 0x01); //unmute Left channel of line in into mxr 1 and set gain to 6 db
	write_adau1761(R6_RECORD_MIXER_RIGHT_CONTROL_0, 0x01, 0x01); //enable mixer 2
	write_adau1761(R7_RECORD_MIXER_RIGHT_CONTROL_1, 0x07, 0x01); //unmute Right channel of line in into mxr 2 and set gain to 6 db
	write_adau1761(R19_ADC_CONTROL, 0x13, 0x01); //enable ADCs

	write_adau1761(R22_PLAYBACK_MIXER_LEFT_CONTROL_0, 0x21, 0x01); //unmute Left DAC into Mxr 3; enable mxr 3
	write_adau1761(R24_PLAYBACK_MIXER_RIGHT_CONTROL_0, 0x41, 0x01); //unmute Right DAC into Mxr4; enable mxr 4
	write_adau1761(R26_PLAYBACK_LR_MIXER_LEFT_LINE_OUTPUT_CONTROL, 0x05, 0x01); //unmute Mxr3 into Mxr5 and set gain to 6db; enable mxr 5
	write_adau1761(R27_PLAYBACK_LR_MIXER_RIGHT_LINE_OUTPUT_CONTROL, 0x11, 0x01); //unmute Mxr4 into Mxr6 and set gain to 6db; enable mxr 6
	write_adau1761(R29_PLAYBACK_HEADPHONE_LEFT_VOLUME_CONTROL, 0xFF, 0x01);//Mute Left channel of HP port (LHP)
	write_adau1761(R30_PLAYBACK_HEADPHONE_RIGHT_VOLUME_CONTROL, 0xFF, 0x01); //Mute Right channel of HP port (LHP)
	//write_adau1761(R31_PLAYBACK_LINE_OUTPUT_LEFT_VOLUME_CONTROL, 0xE6, 0x01); //set LOUT volume (0db); unmute left channel of Line out port; set Line out port to line out mode
	//write_adau1761(R32_PLAYBACK_LINE_OUTPUT_RIGHT_VOLUME_CONTROL, 0xE6, 0x01); // set ROUT volume (0db); unmute right channel of Line out port; set Line out port to line out mode
	write_adau1761(R31_PLAYBACK_LINE_OUTPUT_LEFT_VOLUME_CONTROL, 0xFE, 0x01); //set LOUT volume (0db); unmute left channel of Line out port; set Line out port to line out mode
	write_adau1761(R32_PLAYBACK_LINE_OUTPUT_RIGHT_VOLUME_CONTROL, 0xFE, 0x01); // set ROUT volume (0db); unmute right channel of Line out port; set Line out port to line out mode
	write_adau1761(R35_PLAYBACK_POWER_MANAGEMENT, 0x03, 0x01); //enable left and right channel playback (not sure exactly what this does...)
	write_adau1761(R36_DAC_CONTROL_0, 0x03, 0x01); //enable both DACs

	write_adau1761(R58_SERIAL_INPUT_ROUTE_CONTROL, 0x01, 0x01); //Connect I2S serial port output (SDATA_O) to DACs
	write_adau1761(R59_SERIAL_OUTPUT_ROUTE_CONTROL, 0x01, 0x01); //connect I2S serial port input (SDATA_I) to ADCs

	write_adau1761(R65_CLOCK_ENABLE_0, 0x7F, 0x01); //Enable clocks
	write_adau1761(R66_CLOCK_ENABLE_1, 0x03, 0x01); //Enable rest of clocks
}

/* ---------------------------------------------------------------------------- *
 * 								LineinLineoutConfig()							*
 * ---------------------------------------------------------------------------- *
 * Configures Line-In input, ADC's, DAC's, Line-Out and HP-Out.
 * ---------------------------------------------------------------------------- */
void LineinLineoutConfig() {

	write_adau1761(R17_CONVERTER_CONTROL_0, 0x05, 0x01);//48 KHz
	write_adau1761(R64_SERIAL_PORT_SAMPLING_RATE, 0x05, 0x01);//48 KHz
	write_adau1761(R19_ADC_CONTROL, 0x13, 0x01);
	write_adau1761(R36_DAC_CONTROL_0, 0x03, 0x01);
	write_adau1761(R35_PLAYBACK_POWER_MANAGEMENT, 0x03, 0x01);
	write_adau1761(R58_SERIAL_INPUT_ROUTE_CONTROL, 0x01, 0x01);
	write_adau1761(R59_SERIAL_OUTPUT_ROUTE_CONTROL, 0x01, 0x01);
	write_adau1761(R65_CLOCK_ENABLE_0, 0x7F, 0x01);
	write_adau1761(R66_CLOCK_ENABLE_1, 0x03, 0x01);

	write_adau1761(R4_RECORD_MIXER_LEFT_CONTROL_0, 0x01, 0x01);
	write_adau1761(R5_RECORD_MIXER_LEFT_CONTROL_1, 0x05, 0x01);//0 dB gain
	write_adau1761(R6_RECORD_MIXER_RIGHT_CONTROL_0, 0x01, 0x01);
	write_adau1761(R7_RECORD_MIXER_RIGHT_CONTROL_1, 0x05, 0x01);//0 dB gain

	write_adau1761(R22_PLAYBACK_MIXER_LEFT_CONTROL_0, 0x21, 0x01);
	write_adau1761(R24_PLAYBACK_MIXER_RIGHT_CONTROL_0, 0x41, 0x01);
	write_adau1761(R26_PLAYBACK_LR_MIXER_LEFT_LINE_OUTPUT_CONTROL, 0x03, 0x01);//0 dB
	write_adau1761(R27_PLAYBACK_LR_MIXER_RIGHT_LINE_OUTPUT_CONTROL, 0x09, 0x01);//0 dB
	write_adau1761(R29_PLAYBACK_HEADPHONE_LEFT_VOLUME_CONTROL, 0xE7, 0x01);//0 dB
	write_adau1761(R30_PLAYBACK_HEADPHONE_RIGHT_VOLUME_CONTROL, 0xE7, 0x01);//0 dB
	write_adau1761(R31_PLAYBACK_LINE_OUTPUT_LEFT_VOLUME_CONTROL, 0xE6, 0x01);//0 dB
	write_adau1761(R32_PLAYBACK_LINE_OUTPUT_RIGHT_VOLUME_CONTROL, 0xE6, 0x01);//0 dB
}


void init_adau1761_xil(void) {
	volatile int i;
	    //  setup PLL
	    //write_adau1761(0x4000, 0x0e, 1);
	    //  Configure PLL
	    //write_adau1761(0x4002, 0x007d000c2301, 6);
	    //  Wait for PLL to lock
	//    printf("init_adau1761()::Wait for PLL to lock \n\r");
	//    while (!(read_adau1761(0x4002, 6) & 2))
	//        ;
	    //  Enable clock to core
	//    write_adau1761(0x4000, 0xf, 1);
	    //write_adau1761(0x4000, 0x01, 1); // MCLK == 24.576/2
	    write_adau1761(0x4000, 0x03, 1); // MCLK == 24.576
	    //  delay
	    usleep(1000000);

	    //  I2S master mode
	    write_adau1761(0x4015, 0x01, 1);
	    //  left mixer enable, mic 6dB
	//    write_adau1761(0x400a, 0x0f, 1);
	//    write_adau1761(0x400a, 0x5b, 1);//0db
	    write_adau1761(0x400a, 0x01, 1);//muted
	    //  left mixer enable, mic 0dB
	    //write_adau1761(0x400a, 0x01, 1);
	    //  left 6db
	//    write_adau1761(0x400b, 0x07, 1);
	    write_adau1761(0x400b, 0x0D, 1);//0db
	    //  left 0db
	    //write_adau1761(0x400b, 0x05, 1);
	    //  right mixer enable, mic 6dB
	//    write_adau1761(0x400c, 0x0f, 1);
	//    write_adau1761(0x400c, 0x5b, 1);//0db
	    write_adau1761(0x400c, 0x01, 1);//muted
	    //  right mixer enable, mic 0dB
	    //write_adau1761(0x400c, 0x01, 1);
	    //  right 6db
	//    write_adau1761(0x400d, 0x07, 1);
	    write_adau1761(0x400d, 0x0D, 1);//0db
	    //  right 0db
	    //write_adau1761(0x400d, 0x05, 1);
	    // Mic bias
	    write_adau1761(0x4010, 0x5, 1);
	    //  Playback left mixer unmute, enable, Unmutes the left DAC input to the left channel playback mixer (Mixer 3).
	    write_adau1761(0x401c, 0x21, 1);
	//    write_adau1761(0x401d, 0x66, 1); not needed we need to control the local input play back from the core vol

	    //  Playback right mixer unmute, enable, Unmutes the right DAC input to the right channel playback mixer (Mixer 4).
	    write_adau1761(0x401e, 0x41, 1);
	    //write_adau1761(0x401e, 0x6D, 1);

	//    write_adau1761(0x401f, 0x66, 1);  not needed we need to control the local input play back from the core vol


	    //  Enable line out mixer left
		write_adau1761(0x4020, 0x05, 1);
		//  Enable line out mixer right
		write_adau1761(0x4021, 0x11, 1);


	    //  Enable headphone output left
	    write_adau1761(0x4023, 0xe7, 1);
	    //  Enable headphone output right
	    write_adau1761(0x4024, 0xe7, 1);

	    //  Enable line out left
	    write_adau1761(0x4025, 0xe7, 1);
	    //  Enable line out right
	    write_adau1761(0x4026, 0xe7, 1);

	    //Configure ADC/DAC sample rate 96khz
	#if (AUDIO_RATE == 96)
	    write_adau1761(0x4017, 0x06, 1); //96KHz
	#elif(AUDIO_RATE == 48)
	    write_adau1761(0x4017, 0x00, 1);//48kHz
	#else
	#error("Please set the audio sampling rate!!!");
	#endif

	    //Configure SERIAL port sample rate    96khz

	#if (AUDIO_RATE == 96)
	    write_adau1761(0x40F8, 0x06, 1);//96kHz
	#elif(AUDIO_RATE == 48)
	    write_adau1761(0x40F8, 0x00, 1);//48kHz
	#else
	#error("Please set the audio sampling rate!!!");
	#endif


	    //Configure DSP sample rate  Set to input data rate
	    write_adau1761(0x40EB, 0x07, 1);//take line rate
	//    write_adau1761(0x40EB, 0x01, 1);//48kHz

	    write_adau1761(0x40f5, 0x00, 1);
	    write_adau1761(0x40f6, 0x00, 1);
	    write_adau1761(0x40f7, 0x00, 1);



	    //  Enable both ADCs
	    write_adau1761(0x4019, 0x13, 1);//Both channels on reverse mic polarity
	    //  Enable playback both channels
	    write_adau1761(0x4029, 0x03, 1);
	    //  Enable both DACs
	    write_adau1761(0x402a, 0x03, 1);


	    // Set DAC volume to 0 db
	    write_adau1761(0x402b, 0x00, 1);
	    write_adau1761(0x402c, 0x00, 1);



	    //  Serial input L0,R0 to DAC L,R
	    write_adau1761(0x40f2, 0x01, 1);
	    //  Serial output ADC L,R to serial output L0,R0
	    write_adau1761(0x40f3, 0x01, 1);
	    //  Enable clocks to all engines
	    write_adau1761(0x40f9, 0x7f, 1);
	//    write_adau1761(0x40f9, 0x0B, 1);
	    //  Enable both clock generators
	    write_adau1761(0x40fa, 0x03, 1);


    AudioConfigureJacks();
    LineinLineoutConfig();




}


int init_codec(void){
	    printf("Initializing reset_adau1761 \n\r");
	    reset_adau1761();
	    printf("Initializing init_adau1761 \n\r");
	    init_adau1761();
	    printf("Audio on adau1761 ready \n\r");
}

//
//int main()
//{
//	int i =0;
//    init_platform();
//
//    print("Initializing reset_adau1761 \n\r");
//    reset_adau1761();
//    print("Initializing init_adau1761 \n\r");
//    init_adau1761();
//    print("Audio looping on adau1761 ready \n\r");
//     while(1){
//    	 if(i==0){
//    		 print("Hope you hear the sound in a loop\n\r");
//    	 }
//    	 i = (i + 1) % 0x00FFFFFF;
//
//
//     }
//
//
//    cleanup_platform();
//    return 0;
//}

