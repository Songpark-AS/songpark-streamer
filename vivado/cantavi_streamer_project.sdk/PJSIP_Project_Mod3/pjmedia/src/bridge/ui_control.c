/*
 * =====================================================================================
 *
 *       Filename:  ui_control.c
 *
 *    Description:  User interface functions
 *
 *         Author:  Thanx
 *   Organization:  Cantavi
 *
 * =====================================================================================
 */
// Client side implementation of UDP client-server model
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>  //Header file for sleep(). man 3 sleep for details.
#include <pthread.h>
#include <errno.h>
#include "bridge/ui_control.h"
#include "bridge/udpclient.h"
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include "bridge/adau1761_controller.h"
#include "bridge/network.h"
#include <unistd.h>
#include <signal.h>
//#include "pjsip/pjsua.h"

//#include "pjsua_app_common.h"

#define SAMPLE_RATE (AUDIO_RATE*1.0)

char * VER = "10.8-tm-96-med-int";

//#define debug(x...) PJ_LOG(3,(THIS_FILE, x));
//#define info(x...) PJ_LOG(4,(THIS_FILE, x));
//#define warn(x...) PJ_LOG(2,(THIS_FILE, x));
//#define error(x...) PJ_LOG(1,(THIS_FILE, x));

#define debug(x...) do{ printf("DEBUG::"); printf(x); printf("\n");}while(0)
#define info(x...) do{ printf("INFO::"); printf(x); printf("\n");}while(0)
#define warn(x...) do{ printf("WARN::"); printf(x); printf("\n");}while(0)
#define error(x...) do{ printf("ERROR::"); printf(x); printf("\n");}while(0)

/**
 * =======================================================
 * Device base address pointers
 * =======================================================
 */
void *zedboard_oled_base_0;
void *pmod_controller_base_0;
void *filter_control_base_0;
void *filter_control_base_1;
void *volume_control_base_0;
void *volume_control_base_1;
void *eth_to_audio_base_0;
void *audio_to_eth_base_0;
void *hyb_switch_ip_base_0;
void *full_udp_stack_ip_base_0;
void *eth_packet_sequencer_base_0;
void *packet_time_enforcer_base_0;
void *adau1761_base_0;
void *time_sync_base_0;


dev_param zedboard_oled_params_0;
dev_param pmod_controller_params_0;
dev_param filter_control_params_0;
dev_param filter_control_params_1;
dev_param volume_control_params_0;
dev_param volume_control_params_1;

dev_param eth_to_audio_params_0;
dev_param audio_to_eth_params_0;
dev_param eth_packet_sequencer_params_0;
dev_param hyb_switch_ip_params_0;
dev_param full_udp_stack_ip_params_0;
dev_param packet_time_enforcer_params_0;
dev_param adau1761_params_0;
dev_param time_sync_params_0;



int exportfd, directionfd;




int GPIO_BTN_0;
int GPIO_BTN_1;
int GPIO_BTN_2;
int GPIO_BTN_3;
int GPIO_BTN_4;

int GPIO_LED_0;
int GPIO_LED_1;
int GPIO_LED_2;
int GPIO_LED_3;
int GPIO_LED_4;
int GPIO_LED_5;
int GPIO_LED_6;
int GPIO_LED_7;

pthread_t axi_to_net_mq_reader_thread;
pthread_t axi_to_net_mq_writer_thread; // thread to write network audio data to fifo
pthread_t net_to_axi_mq_reader_thread; // thread to write fifo audio data to axi audio
pthread_t net_to_axi_mq_writer_thread;
//pthread_t loopback_thread; // thread to loop back audio in to out through axi
pthread_t ui_input_reader_thread; //main ui input reading thread
pthread_t ui_draw_thread; // ui draw thread

pthread_t firewall_mock_thread; //main ui input reading thread




pthread_t pmod_thread;
//pthread_t recv_thread;
pthread_t button_thread;




ui_parameters params; //shared structure variable to ui_parameters structure

server_addr saddr;




int quit_flag; // flag to control the threads

mqd_t msgq_axi_to_net_r; // reader fifo descripter
mqd_t msgq_axi_to_net_w; // writer fifo descripter
struct mq_attr attr_axi_to_net_r; // reader fifo attributes
struct mq_attr attr_axi_to_net_w; // writer fifo attributes



mqd_t msgq_net_to_axi_r; // reader fifo descripter
mqd_t msgq_net_to_axi_w; // writer fifo descripter
struct mq_attr attr_net_to_axi_r; // reader fifo attributes
struct mq_attr attr_net_to_axi_w; // writer fifo attributes


unsigned long total_bytes_send_to_net = 0;
unsigned long total_bytes_send_to_dma = 0;
unsigned long total_bytes_read_from_net=0;
unsigned long axi_to_net_mq_w_error_count =0;
unsigned long axi_to_net_mq_r_error_count =0;
unsigned long net_to_axi_mq_w_error_count =0;
unsigned long net_to_axi_mq_r_error_count =0;
unsigned long net_read_error_count =0;
unsigned long net_send_error_count =0;
unsigned long audio_to_eth_reg_w_error_count=0;
unsigned long axi_to_net_reg_w_error_count=0;


#define FIFO_SIZE 512
#define AXI_PKT_SIZE FIFO_SIZE/8
#define UDP_PKT_SIZE AXI_PKT_SIZE*4
unsigned volatile pkt_len = 96;
unsigned pkt_len_rl_samples = 96;

char local_ip[64];
char public_ip[64];
char local_mac[64];
char dest_ip[64];
char mask_ip[64];
char gateway_ip[64];
char contact_ip_addr [32];

unsigned dest_port=7809;
unsigned sync_port=7809;

unsigned sw_port1;
unsigned sw_port2;
unsigned sw_port3;
unsigned sw_port4;
unsigned sw_port5;
unsigned sw_port6;
unsigned sw_port7;
unsigned sw_port8;

unsigned monitor = 0;

char menuBuf[17] = {65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65};
int cursorPos = 0;
int menuPos = 0;
char menuitem[MENULENGTH][32] = {
	"VOL_AUX_L   \0",
	"VOL_AUX_R   \0",
	"VOL_STREAM_L\0",
	"VOL_STREAM_R\0",
	"AUX_LowP    \0",
	"AUX_BandP   \0",
	"AUX_HighP   \0",
	"STREAM_LowP \0",
	"STREAM_BandP\0",
	"STREAM_HighP\0",
	"Net Counts\0",
	"MAC\0",
	"LOCAL IP\0",
  "DEST IP\0",
  "GTWAY IP\0",
  "MASK IP\0",
  "DEST PORT\0",
  "PKT LEN\0",
  "LOOP TIMER\0",
  "LATENCY TIMER\0",
  "SAMPLE FIFO TIMER\0",
  "NET ERRORS\0",
  "LOST PACKETS\0",
  "TX PACKETS\0",
  "RX PACKETS\0",
  "PACKET LENGTH\0",
  "ETH CONTROL\0",
  "RX BUF LENGTH\0",
  "SEQ ORD\0",
};
int setting[MENULENGTH] = {5, 5, 5, 5, 0, 0, 0, 0, 0, 0};
int settingRange[MENULENGTH] = {10, 10, 10, 10, 1, 1, 1, 1, 1, 1};

int menuUp = 0;
int menuDown = 0;
int menuSelect = 0;
int volSwitch = 0;
int globalVol = 8;
int sockfd;


struct arg_struct {
    int port;
    int sdelay;
    char ip[16];

};

struct arg_struct nargs;


int disable_sync = 0;

//void *send_audio_function(void *arg);
void *pmod_function(void *arg);
void *recv_function(void *arg);
void *button_function(void *arg);

void *axi_to_net_mq_reader(void *arg);
void *axi_to_net_mq_writer (void* data);
void *net_to_axi_mq_reader (void *data);
void *net_to_axi_mq_writer (void *data);



unsigned rate = SAMPLE_RATE;
unsigned orate = SAMPLE_RATE;




void *axi_to_net_mq_reader(void *arg)
{
//	unsigned buf[AXI_PKT_SIZE];
	unsigned buffer[AXI_PKT_SIZE];
	int fd_fifo;
	int IRQEnable = 1;
	int n,z;
//	char buffer[sizeof(unsigned)*AXI_PKT_SIZE];
//	char *hello = "Hello from client";


	while (1)
	{
		n = mq_receive(msgq_axi_to_net_r, (char*)buffer, AXI_PKT_SIZE*4, 0);
		if (n == -1) {
			error("axi_to_net send_audio_to_network : mq_receive(msgq_axi_to_net_r)\n");

		      axi_to_net_mq_r_error_count++;

		      sleep(1);
		}else
		{
			z = udp_client_send(buffer,n);
			if (z != -1) {
	//			sleep(2);
	//			info( "Pkt sent.\n");
				//return 0;
				total_bytes_send_to_net +=z;
			}
			else{
				error("Error:: udp_send => sleeping for 1s :: Code=%d\n",z);
				//		    		//exit(1);

				net_send_error_count++;
				sleep(1);
	//	        return 1;
			}
	//			    info( "Hello message sent.\n");
		}
	}

}


/**
 * =======================================================
 * reads audio data from axi and writes it into axi
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */



void *axi_to_net_mq_writer (void* data) {
	//  unsigned l_buff = 0;
	//  unsigned r_buff = 0;
	  unsigned buffer[AXI_PKT_SIZE];
	  unsigned i = 0;
	  unsigned tmpL = 0;
	  unsigned tmpR = 0;
//	  while (1) {
//		  //info( "Waiting for L data\n");
//		  for (i =0; i<AXI_PKT_SIZE; i++){
//				buffer[i] = read_stream (audio_to_eth_base_0, CHANNEL_ID_L);
//
//				i++;
//
//				buffer[i] = read_stream (audio_to_eth_base_0, CHANNEL_ID_R);
//				tmpR = buffer[i];
//
//		  }
//
//
//	    //buffer[0] = l_buff;
//	    if (mq_send(msgq_axi_to_net_w, (char *)buffer, sizeof(buffer) , 0) != 0) {
//	          perror ("axi_to_net audio_axi_reader: mq_send");
//	          axi_to_net_mq_w_error_count++;
//	          sleep(1);
//	        }
//
//
//	  }

	  return NULL;
}

/**
 * =======================================================
 * reads audio data from network and writes it into fifo
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */
void *net_to_axi_mq_reader (void *data) {
  unsigned buffer[UDP_PKT_SIZE/4];
  int i=0, n=0;
//  while (1) {
//	  n = mq_receive(msgq_net_to_axi_r, (char*)buffer, UDP_PKT_SIZE, 0);
//    if (n == -1) {
//      perror ("net_to_axi network_reader_stream : mq_receive(msgq_id_r)\n");
//
//      net_to_axi_mq_r_error_count++;
//
//      sleep(1);
//    }else{
//
//		for(i=0; i<n/4;i++){
//			if (write_stream (axi_to_audio_base_0, CHANNEL_ID_L, buffer[i]) != 0) {
//			  fprintf (stderr, "network_stream : write_stream(axi_to_audio_base_1, CHANNEL_ID_L)");
//
//			  audio_to_eth_reg_w_error_count++;
//
//			  sleep(1);
//			}
//
//			i++;
//
//			if (write_stream (axi_to_audio_base_0, CHANNEL_ID_R, buffer[i]) != 0) {
//			  fprintf (stderr, "network_stream : write_stream(axi_to_audio_base_1, CHANNEL_ID_R)");
//
//			  audio_to_eth_reg_w_error_count++;
//			  sleep(1);
//			}
//		}
//    }
//
//  }

  return NULL;
}

/**
 * =======================================================
 * reads audio data from fifo and writes it into axi
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */
void *net_to_axi_mq_writer (void *data) {
  char buffer[UDP_PKT_SIZE];
  int n =0;
  while (1) {
	  n = udp_client_recv(buffer, UDP_PKT_SIZE);
    if (n == -1) {
    	error("Error :: net_to_axi_mq_writer no udp pkt received\n");

	  net_read_error_count++;

      sleep(1);
    }else{
    	total_bytes_read_from_net += n;
		if (mq_send(msgq_net_to_axi_w, (char*)buffer, n, 0) != 0) {
			error("Error :: net_to_axi network_writer_stream : mq_send");

		  net_to_axi_mq_w_error_count++;

		  sleep(1);
		}
    }

  }

  return NULL;
}

/**
 * =======================================================
 * read and parse user input
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */
void *ui_input_reader (void *data) {
  char c[16];
  unsigned buf ;
  unsigned long tmp ;
  unsigned int gain = 0;
  unsigned int dest_ip = 0;
  unsigned int source_ip = 0;
  unsigned int gw_ip = 0;
  unsigned int mac = 0;
  unsigned int dest_port = 0;
  unsigned int sw_port = 0;
  unsigned char ip[128]={0};
  unsigned char log_str[128]={0};
  unsigned char ipAddress[4];
  unsigned char macAddress[6];

  oled_clear(zedboard_oled_params_0.base_address);
  	sprintf(&menuBuf[0], "%s", "Welcome");
  	oled_print_message(&menuBuf[0], 0, zedboard_oled_params_0.base_address);
  	sprintf(&menuBuf[0], "%s-%s-", "Cantavi", "S");
  	oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

  	ui_draw();
  while (1) {
    SET_STATUS("Enter Command\n");
    //ui_draw();
    scanf ("%s",c);
    if(strcmp (c,"vol") == 0) {
    		SET_STATUS("Entered global gain\n");
            ui_draw();
            scanf ("%d",&gain);
            params.v_global = gain;
            globalVol = gain;

            set_volume (volume_control_base_0, params.vl_lpbk*gain, CHANNEL_ID_L);
            set_volume (volume_control_base_0, params.vr_lpbk*gain, CHANNEL_ID_R);

            set_volume (volume_control_base_1, params.vl_net*gain, CHANNEL_ID_L);
            set_volume (volume_control_base_1, params.vr_net*gain, CHANNEL_ID_R);

            oled_clear(zedboard_oled_params_0.base_address);
            sprintf(&menuBuf[0], "%s%3d", "VOL_GLOBAL", gain);
            oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

            update_leds();
            ui_vol_draw();
      }else if(strcmp (c,"vll") == 0) {
        SET_STATUS("Entered left gain\n");
        ui_vol_draw();
        scanf ("%d",&gain);
        set_volume (volume_control_base_0, params.v_global*gain, CHANNEL_ID_L);
        params.vl_lpbk = gain;
        setting[1] = params.vl_lpbk;
        oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%3d", menuitem[0], setting[1]);
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

        ui_vol_draw();
      }
      else if(strcmp (c,"vlr") == 0) {
        SET_STATUS("Entered right gain\n");
        ui_vol_draw();
        scanf ("%d",&gain);
        set_volume (volume_control_base_0, params.v_global*gain, CHANNEL_ID_R);
        params.vr_lpbk = gain;
        setting[0] = gain;

        oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%3d", menuitem[1], setting[0]);
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

        ui_vol_draw();
      }
      else if(strcmp (c,"netvoll") == 0) {
        SET_STATUS("Entered left gain\n");
        ui_vol_draw();
        scanf ("%d",&gain);
        set_volume (volume_control_base_1, params.v_global*gain, CHANNEL_ID_L);
        params.vl_net = gain;
        setting[3] = gain;

        oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%3d", menuitem[2], setting[3]);
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

        ui_vol_draw();
      }
      else if(strcmp (c,"netvolr") == 0) {
        SET_STATUS("Entered right gain\n");
        ui_vol_draw();
        scanf ("%d",&gain);
        set_volume (volume_control_base_1, params.v_global*gain, CHANNEL_ID_R);
        params.vr_net = gain;
        setting[2] = gain;
        oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%3d", menuitem[3], setting[2]);
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
        ui_vol_draw();
      }
      else if ( strcmp (c, "lfhe") == 0){
          set_filter_type (filter_control_base_0, FILTER_HIGH_PASS, 1);
          params.filter_h_lpbk = 1;
          setting[6] = 1;
          oled_clear(zedboard_oled_params_0.base_address);
          sprintf(&menuBuf[0], "%s%3d", menuitem[6], setting[5]);
          oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "lfhd") == 0){
          set_filter_type (filter_control_base_0, FILTER_HIGH_PASS, 0);
          params.filter_h_lpbk = 0;
          setting[6] = 0;
          oled_clear(zedboard_oled_params_0.base_address);
          		sprintf(&menuBuf[0], "%s%3d", menuitem[6], setting[6]);
          		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "lfbe") == 0){
          set_filter_type (filter_control_base_0, FILTER_BAND_PASS, 1);
          params.filter_b_lpbk = 1;
          setting[5] = 1;
          oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[0], "%s%3d", menuitem[5], setting[5]);
                    oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "lfbd") == 0){
          set_filter_type (filter_control_base_0, FILTER_BAND_PASS, 0);
          params.filter_b_lpbk = 0;
          setting[5] = 0;
          oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[0], "%s%3d", menuitem[5], setting[5]);
                    oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "lfle") == 0){
          set_filter_type (filter_control_base_0, FILTER_LOW_PASS, 1);
          params.filter_l_lpbk = 1;
          setting[4] = 1;
          oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[0], "%s%3d", menuitem[4], setting[4]);
                    oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "lfld") == 0){
          set_filter_type (filter_control_base_0, FILTER_LOW_PASS, 0);
          params.filter_l_lpbk = 0;
          setting[4] = 0;
          oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[0], "%s%3d", menuitem[4], setting[4]);
                    oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "nfhe") == 0){
          set_filter_type (filter_control_base_1, FILTER_HIGH_PASS, 1);
          params.filter_h_net = 1;
          setting[9] = 1;
          oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[1], "%s%3d", menuitem[9], setting[9]);
                    oled_print_message(&menuBuf[1], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "nfhd") == 0){
          set_filter_type (filter_control_base_1, FILTER_HIGH_PASS, 0);
          params.filter_h_net = 0;
          setting[9] = 0;
          oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[1], "%s%3d", menuitem[9], setting[9]);
                    oled_print_message(&menuBuf[1], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "nfbe") == 0){
          set_filter_type (filter_control_base_1, FILTER_BAND_PASS, 1);
          params.filter_b_net = 1;
          setting[8] = 1;
          oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[1], "%s%3d", menuitem[8], setting[8]);
                    oled_print_message(&menuBuf[1], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "nfbd") == 0){
          set_filter_type (filter_control_base_1, FILTER_BAND_PASS, 0);
          params.filter_b_net = 0;
          setting[8] = 0;
          oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[1], "%s%3d", menuitem[8], setting[8]);
                    oled_print_message(&menuBuf[1], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "nfle") == 0){
          set_filter_type (filter_control_base_1, FILTER_LOW_PASS, 1);
          params.filter_l_net = 1;
          setting[7] = 1;
          oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[1], "%s%3d", menuitem[7], setting[7]);
                    oled_print_message(&menuBuf[1], 1, zedboard_oled_params_0.base_address);
          ui_draw();
      }
      else if ( strcmp (c, "nfld") == 0){
          set_filter_type (filter_control_base_1, FILTER_LOW_PASS, 0);
          params.filter_l_net = 0;
          setting[7] = 0;
          ui_draw();
      }
      else if ( strcmp (c, "rate") == 0){
			  scanf ("%d",&rate);
			  if(rate == 96){
				write_adau1761(0x40F8, 0x06, 1);//96kHz
				write_adau1761(0x4017, 0x06, 1); //96KHz
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "SampRate=%d kHz", rate);
				info( "The new sample rate is %d kHz", rate);
				orate = rate;
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }else if(rate == 48){
				write_adau1761(0x40F8, 0x00, 1);//48kHz
				write_adau1761(0x4017, 0x00, 1);//48kHz
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "SampRate=%d kHz", rate);
				orate = rate;
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }else{
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "Invalid sample rate");
				  info( "The invalid sample rate::%d kHz, old sample rate is %d kHz", rate,orate);
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
			  }

			}
      else if ( strcmp (c, "nstats") == 0){

			info( "total_bytes_send_to_dma count is::%d\n",total_bytes_send_to_dma);
			info( "total_bytes_send_to_net count is::%d\n",total_bytes_send_to_net);
			info( "total_bytes_read_from_net count is::%d\n",total_bytes_read_from_net);
			info( "audio_to_eth_reg_w_error count is::%d\n",audio_to_eth_reg_w_error_count);
//			info( "axi_to_net_reg_w_error count is::%d\n",axi_to_net_reg_w_error_count);
			info( "axi_to_net_mq_r_error count is::%d\n",axi_to_net_mq_r_error_count);
			info( "net_to_axi_mq_w_error count is::%d\n",net_to_axi_mq_w_error_count);
			info( "net_to_axi_mq_r_error count is::%d\n",net_to_axi_mq_r_error_count);
			info( "net_read_error count is::%d\n",net_read_error_count);
			info( "net_send_error count is::%d\n",net_send_error_count);
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s::%3d", menuitem[10], total_bytes_send_to_net);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();

      }
      else if ( strcmp (c, "astatus") == 0){
    	  int buffer = read_fifo_status (audio_to_eth_base_0, ADC_FIFO_ID);
    	  if(buffer&0x04){
    	      	//LeftFIFOEmpty
    		  info( "ADC left audio fifo Empty :: val::0x%02X\n",buffer);
    	  }
    	  if(buffer&0x08){
    	      	//RightFIFOEmpty
    		  info( "ADC right audio fifo Empty :: val::0X%02X\n",buffer);
    	      }
    	  if(buffer&0x10){
    	      	//LeftFIFOFull
    		  info( "ADC left audio fifo Full :: val::0x%02X\n",buffer);
    	      }
    	  if(buffer&0x20){
    	      	//RightFIFOFull
    		  info( "ADC right audio fifo Full :: val::0x%02X\n",buffer);
    	      }
    	  if(buffer&0x3C == 0){
    		  info( "All ADC audio fifo Flags clear :: val::0X%02X\n",buffer);
    	  }
    	  info( "All ADC audio fifo Flags:: val::0X%02X\n",buffer);
    	  ui_draw();
      }
      else if ( strcmp (c, "dstatus") == 0){
    	  int buffer = read_fifo_status (eth_to_audio_base_0, DAC_FIFO_ID);
    	  if(buffer&0x04){
    	      	      	//LeftFIFOEmpty
			  info( "DAC left audio fifo Empty :: val::0x%02X\n",buffer);
		  }
		  if(buffer&0x08){
				//RightFIFOEmpty
			  info( "DAC right audio fifo Empty :: val::0x%02X\n",buffer);
			  }
		  if(buffer&0x10){
				//LeftFIFOFull
			  info( "DAC left audio fifo Full :: val::0x%02X\n",buffer);
			  }
		  if(buffer&0x20){
				//RightFIFOFull
			  info( "DAC right audio fifo Full :: val::0x%02X\n",buffer);
			  }
		  if(buffer&0x3C == 0){
			  info( "All DAC audio fifo Flags clear :: val::0x%02X\n",buffer);
		  }
		  info( "All DAC audio fifo Flags :: val::0x%02X\n",buffer);
		  ui_draw();
      }
      else if ( strcmp (c, "areset") == 0){
    	  reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
    	  info( "ADC audio FIFOs Reset\n");
    	  oled_clear(zedboard_oled_params_0.base_address);
    	  sprintf(&menuBuf[0], "%s", "ADC FIFOs Rst");
    	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
    	  ui_draw();
      }

      else if ( strcmp (c, "dreset") == 0){
      //          	  time_sync_tx_off(full_udp_stack_ip_base_0);
      //          	  time_sync_off(time_sync_base_0);
      //          	  set_sync_rst(time_sync_base_0);
      //          	  sleep(1);
      //      			time_sync_en(time_sync_base_0);
      //      			usleep(100);
      //      			sleep(2);
      //      			time_sync_tx_en(full_udp_stack_ip_base_0);
      //      		  printf("Enable time sync...\n");

                	  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
                	  printf("DAC audio FIFOs Reset\n>");
                	  oled_clear(zedboard_oled_params_0.base_address);
                	  sprintf(&menuBuf[0], "%s", "DAC FIFOs Rst");
                	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                	  ui_draw();
                  }

      else if ( strcmp (c, "reset") == 0){

          	 set_sync_rst(time_sync_base_0);

          	  printf("Reset time sync...\n");
          	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
      			 write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|2);
      			 sleep(1);
      			write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFD);
      			printf("Stream core reset status was:0x%X\n>",buf);

      			reset_pkt_seq(eth_packet_sequencer_base_0);

      		printf("PLC Pkt seq Reset\n>");

      		time_sync_tx_en(full_udp_stack_ip_base_0);
      		usleep(100);
      		time_sync_en(time_sync_base_0);

      		printf("Enable time sync...\n");
      		///reset_pkt_time_enf(packet_time_enforcer_base_0);


      		//printf("Pkt timing unit reset\n>");
      			  reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
      			  printf("ADC audio FIFOs Reset\n");
      			  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
      			  printf("DAC audio FIFOs Reset\n>");


      			 oled_clear(zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "%s", "Full Stream Rst");
      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			ui_draw();
            }


      else if ( strcmp (c, "preset") == 0){
    	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
    	  reset_pkt_seq(eth_packet_sequencer_base_0);

    	  info("PLC Pkt seq Reset\n>");
          	  oled_clear(zedboard_oled_params_0.base_address);
          	  sprintf(&menuBuf[0], "%s", "PKT SEQ Rst");
          	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          	  ui_draw();
            }

      else if ( strcmp (c, "pbtreset") == 0){
          	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
    	  	  //reset_pkt_time_enf(packet_time_enforcer_base_0);


    	  	  info("Pkt timing unit reset\n>");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "PKT TU Rst");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
		  }
      else if ( strcmp (c, "pbtrreset") == 0){
                	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
    	  	  	  reset_pkt_time_enf_rx(packet_time_enforcer_base_0);

    	  	  	  info("Pkt timing unit reset rx\n>");
      			  oled_clear(zedboard_oled_params_0.base_address);
      			  sprintf(&menuBuf[0], "%s", "PKT TU RX Rst");
      			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			  ui_draw();
      		  }
      else if ( strcmp (c, "pbtoff") == 0){
                	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
    	  	  	  pkt_time_enf_disable(packet_time_enforcer_base_0);

    	  	  	  info("Pkt timing unit disable\n>");
      			  oled_clear(zedboard_oled_params_0.base_address);
      			  sprintf(&menuBuf[0], "%s", "PKT TU OFF");
      			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			  ui_draw();
      		  }

      else if ( strcmp (c, "pbton") == 0){
                      	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
          	  	  	  pkt_time_enf_enable(packet_time_enforcer_base_0);

          	  	  info("Pkt timing unit enable\n>");
            			  oled_clear(zedboard_oled_params_0.base_address);
            			  sprintf(&menuBuf[0], "%s", "PKT TU ON");
            			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            			  ui_draw();
            		  }


      else if ( strcmp (c, "pseqoff") == 0){
          	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
          	  disble_pkt_seq(eth_packet_sequencer_base_0);

          	info("Pkt seq Disabled\n>");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "PKT SEQ OFF");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
		  }

      else if ( strcmp (c, "pseqon") == 0){
                	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
                	  enable_pkt_seq(eth_packet_sequencer_base_0);

      			  info("Pkt seq Enabled\n>");
      			  oled_clear(zedboard_oled_params_0.base_address);
      			  sprintf(&menuBuf[0], "%s", "PKT SEQ ON");
      			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			  ui_draw();
      		  }


      else if ( strcmp (c, "creset") == 0){
                	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
                	      	  write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x80000000);//bit 31
                	      	info("Stream core reset status was:0x%X\n>",buf);
                	      	 sleep(1);
                	      	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0x7FFFFFFF);
                	      	info("Stream core reset status now:0x%X\n>",buf&0x7FFFFFFF);
                	      	oled_clear(zedboard_oled_params_0.base_address);
                	      	sprintf(&menuBuf[0], "%s", "Stream Core Rst");
                	      	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                	      	ui_draw();
                  }
      else if ( strcmp (c, "sreset") == 0){
                            	  unsigned buf = read_eth_param (hyb_switch_ip_base_0, ETH_CONTROL_REG_ID);
                            	write_eth_param(hyb_switch_ip_base_0, ETH_CONTROL_ID, buf|0x80000000);
                            				 sleep(1);
                            				write_eth_param(hyb_switch_ip_base_0, ETH_CONTROL_ID, buf&0x7FFFFFFF);
                            	      	printf("Switch core reset status was:0x%X\n>",buf);
                            	      	oled_clear(zedboard_oled_params_0.base_address);
                            	      	sprintf(&menuBuf[0], "%s", "Switch Core Rst");
                            	      	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                            	      	ui_draw();
                              }
            else if ( strcmp (c, "freset") == 0){

          	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
          	     write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x80000000);
          	     sleep(1);
      			write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0x7FFFFFFF);
      			info("Stream core reset status was:0x%X\n>",buf);

      			reset_pkt_seq(eth_packet_sequencer_base_0);

				info("PLC Pkt seq Reset\n>");
				///reset_pkt_time_enf(packet_time_enforcer_base_0);


				//info("Pkt timing unit reset\n>");
               	  reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
               	  info("ADC audio FIFOs Reset\n");
               	  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
               	  info("DAC audio FIFOs Reset\n>");


               	 oled_clear(zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "%s", "Full Stream Rst");
      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			ui_draw();
                 }

            else if ( strcmp (c, "rxrsync") == 0){

            	unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
            	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x80000000);
				 sleep(1);
				write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0x7FFFFFFF);
				info("Stream core reset status was:0x%X\n>",buf);

				reset_pkt_seq(eth_packet_sequencer_base_0);

				info("Pkt seq Reset\n>");
				//reset_pkt_time_enf(packet_time_enforcer_base_0);


				//info("Pkt timing unit reset\n>");
				  reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
				  info("ADC audio FIFOs Reset\n");
				  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
				  info("DAC audio FIFOs Reset\n>");
                     	 oled_clear(zedboard_oled_params_0.base_address);
            			sprintf(&menuBuf[0], "%s", "RX re sync");
            			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            			ui_draw();
                       }

      else if ( strcmp (c, "strteston") == 0){
			  set_test_mode_on(audio_to_eth_base_0);//wValue(7);
			  info("Put Audio to Ethernet IP in test mode\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "Test Mode: ON");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
		  }
      else if ( strcmp (c, "strtestm1") == 0){
      			  set_test_mode(audio_to_eth_base_0, 0);//wValue(10 down to 9);
      			  info("Put Audio to Ethernet IP in test ramp mode\n");
      			oled_clear(zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "%s", "LR Ramp");
      		    oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
      			ui_draw();
      		  }
      else if ( strcmp (c, "strtestm2") == 0){
			  set_test_mode(audio_to_eth_base_0, 1);//wValue(10 down to 9);
			  info("Put Audio to Ethernet IP in test fixed LR=0x55 mode\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "LR 0x555555");
			  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			  ui_draw();
			ui_draw();
		  }
      else if ( strcmp (c, "strtestm3") == 0){
			  set_test_mode(audio_to_eth_base_0, 2);//wValue(10 down to 9);
			  info("Put Audio to Ethernet IP in test fixed L=0x00 R=0xFF mode\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "L=0x00 R=0xFF");
			 oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			 ui_draw();
			ui_draw();
		  }
      else if ( strcmp (c, "strtestm4") == 0){
			  set_test_mode(audio_to_eth_base_0, 3);//wValue(10 down to 9);
			  info("Put Audio to Ethernet IP in test bit flip mode\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "LR FLIP");
			  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			  ui_draw();
		  }
      else if ( strcmp (c, "strtestm5") == 0){
     			  set_test_mode(audio_to_eth_base_0, 4);//wValue(10 down to 9);
     			  info("Put Audio to Ethernet IP in test sine wave mode\n");
     			  oled_clear(zedboard_oled_params_0.base_address);
     			  sprintf(&menuBuf[0], "%s", "LR SQW");
     			  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
     			  ui_draw();
     		  }
      else if ( strcmp (c, "strtestoff") == 0){
			  set_test_mode_off(audio_to_eth_base_0);//wValue(7);
			  info("Put Audio to Ethernet IP in test mode\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "Test Mode: OFF");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

			ui_draw();
			}

    //------------------------------------------------------------------------------------------------------
      else if ( strcmp (c, "getskip") == 0){
                	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
                	  int d = get_pkt_seq_skiped(eth_packet_sequencer_base_0);

                      	  printf("Pkt seq get skipped pakets:%d\n>",d);
                      	  oled_clear(zedboard_oled_params_0.base_address);
                      	  sprintf(&menuBuf[0], "%s:%d", "PKT SEQ SKP", d);
                      	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                      	  ui_draw();
                        }

            else if ( strcmp (c, "setdrl") == 0){//done
                      	  	  int allw = 12;
                      	  	  scanf ("%d",&allw);
                      	  	set_drop_allowance(eth_to_audio_base_0, allw);//wValue(7);
                        		  printf("Ethernet to Audio drop allowance set\n");
                        		  oled_clear(zedboard_oled_params_0.base_address);
                        		  sprintf(&menuBuf[0], "%s:%d", "Eth2Aud DRL", allw);
                        		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                        		  ui_draw();
                        	  }
            else if ( strcmp (c, "setesl") == 0){//done
          	  	  int allw = 12;
          	  	  scanf ("%d",&allw);
                	  set_rx_esl(eth_to_audio_base_0, allw);//wValue(7);
            		  printf("Ethernet to Audio even packet wait allowance set\n");
            		  oled_clear(zedboard_oled_params_0.base_address);
            		  sprintf(&menuBuf[0], "%s:%d", "Eth2Aud EAL", allw);
            		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            		  ui_draw();
            	  }

            else if ( strcmp (c, "setosl") == 0){//done
                	  	  int allw = 30;
                	  	  scanf ("%d",&allw);
                      	  set_rx_osl(eth_to_audio_base_0, allw);//wValue(7);
                  		  printf("Ethernet to Audio odd packet wait allowance set\n");
                  		  oled_clear(zedboard_oled_params_0.base_address);
                  		  sprintf(&menuBuf[0], "%s:%d", "Eth2Aud OAL", allw);
                  		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                  		  ui_draw();
                  	  }



      else if ( strcmp (c, "sethdrstrip") == 0){//done
    	  set_rx_hdr_strip(eth_to_audio_base_0);//wValue(7);
		  info("Ethernet to Audio IP header strip on\n");
		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s", "HDR Strip: ON");
		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		  ui_draw();
	  }
      else if ( strcmp (c, "clearhdrstrip") == 0){//done
          	clear_rx_hdr_strip(eth_to_audio_base_0);//wValue(7);
			info("Ethernet to Audio IP header strip off\n");
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "HDR Strip: OFF");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
		  }


      else if ( strcmp (c, "strxteston") == 0){
      			  set_xtest_mode_on(eth_to_audio_base_0);//wValue(7);
      			  info("Put Ethernet to Audio IP in test mode\n");
      			  oled_clear(zedboard_oled_params_0.base_address);
      			  sprintf(&menuBuf[0], "%s", "xTest Mode: ON");
      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			ui_draw();
      		  }
            else if ( strcmp (c, "strxtestm1") == 0){
            			  set_xtest_mode(eth_to_audio_base_0, 0);//wValue(10 down to 9);
            			  info("Put Ethernet to Audio IP in test ramp mode\n");
            			oled_clear(zedboard_oled_params_0.base_address);
            			sprintf(&menuBuf[0], "%s", "LR Ramp");
            		    oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
            			ui_draw();
            		  }
            else if ( strcmp (c, "strxtestm2") == 0){
      			  set_xtest_mode(eth_to_audio_base_0, 1);//wValue(10 down to 9);
      			  info("Put Ethernet to Audio IP in test fixed LR=0x55 mode\n");
      			  oled_clear(zedboard_oled_params_0.base_address);
      			  sprintf(&menuBuf[0], "%s", "LR 0x555555");
      			  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
      			  ui_draw();
      			ui_draw();
      		  }
            else if ( strcmp (c, "strxtestm3") == 0){
      			  set_xtest_mode(eth_to_audio_base_0, 2);//wValue(10 down to 9);
      			  info("Put Ethernet to Audio IP in test fixed L=0x00 R=0xFF mode\n");
      			  oled_clear(zedboard_oled_params_0.base_address);
      			  sprintf(&menuBuf[0], "%s", "L=0x00 R=0xFF");
      			 oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
      			 ui_draw();
      			ui_draw();
      		  }
            else if ( strcmp (c, "strxtestm4") == 0){
      			  set_xtest_mode(eth_to_audio_base_0, 3);//wValue(10 down to 9);
      			  info("Put Ethernet to Audio IP in test bit flip mode\n");
      			  oled_clear(zedboard_oled_params_0.base_address);
      			  sprintf(&menuBuf[0], "%s", "LR FLIP");
      			  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
      			  ui_draw();
      		  }
            else if ( strcmp (c, "strxtestm5") == 0){
           			  set_xtest_mode(eth_to_audio_base_0, 4);//wValue(10 down to 9);
           			  info("Put Ethernet to Audio IP in test square wave mode\n");
           			  oled_clear(zedboard_oled_params_0.base_address);
           			  sprintf(&menuBuf[0], "%s", "LR SQR");
           			  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
           			  ui_draw();
           		  }
            else if ( strcmp (c, "strxtestoff") == 0){
      			  set_xtest_mode_off(eth_to_audio_base_0);//wValue(7);
      			  info("Put Ethernet to Audio IP in test mode\n");
      			  oled_clear(zedboard_oled_params_0.base_address);
      			  sprintf(&menuBuf[0], "%s", "xTest Mode: OFF");
      			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

      			ui_draw();
      			}
            else if ( strcmp (c, "sethdrlen") == 0){
            	scanf ("%d",&tmp);
			  set_tx_hdr_length(eth_to_audio_base_0, tmp);//wValue(7);
			  info("Set hdr length...\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s%d", "HDR LEN:",tmp);
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

			ui_draw();
			}
    //------------------------------------------------------------------------------------------------------
            else if ( strcmp (c, "sync") == 0){

            	time_sync_tx_en(full_udp_stack_ip_base_0);
            	usleep(100);
            	time_sync_en(time_sync_base_0);
			  info("Enable time sync...\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SYNC: ON");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
		  }

            else if ( strcmp (c, "syncoff") == 0){

				time_sync_off(time_sync_base_0);
				//time_sync_tx_off(full_udp_stack_ip_base_0);
			  info("Disable time sync...\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SYNC: OFF");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
		  }
            else if ( strcmp (c, "syncrst") == 0){

			  set_sync_rst(time_sync_base_0);
			  info("Reset time sync...\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SYNC: RST");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
		  }


            else if ( strcmp (c, "syncdly") == 0){

            	scanf ("%d",&tmp);
                        	set_sync_pkt_dly(time_sync_base_0,tmp);

            			  info("Set time sync response wait delay...\n");
            			  oled_clear(zedboard_oled_params_0.base_address);
            			  sprintf(&menuBuf[0], "%s", "SYNC: DLY");
            			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            			ui_draw();
            		  }

	else if ( strcmp (c, "setsyncon") == 0){

					initiate_sync(time_sync_base_0);
				  set_sync_on(audio_to_eth_base_0);
				  info("Enable time sync...\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "SYNC: ON");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }

	else if ( strcmp (c, "setsyncoff") == 0){

				  set_sync_off(audio_to_eth_base_0);
				  info("Disable time sync...\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "SYNC: OFF");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }



	else if ( strcmp (c, "tgsync") == 0){

						set_sync_off(audio_to_eth_base_0);
					sleep(1);
					  set_sync_on(audio_to_eth_base_0);
					  info("Toggle time sync...\n");
					  oled_clear(zedboard_oled_params_0.base_address);
					  sprintf(&menuBuf[0], "%s", "SYNC: ON");
					  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					ui_draw();
				  }

	else if ( strcmp (c, "bver") == 0){


							  printf("The BP version is: %s\n",VER);
							  oled_clear(zedboard_oled_params_0.base_address);
							  sprintf(&menuBuf[0], "%s %s", "Core Ver:", VER);
							  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
							ui_draw();
						  }

		else if(strcmp (c,"cver") == 0)
				{
					  //SET_STATUS("Enter payload length in 24 bit samples:\n");

					  tmp = get_core_version(eth_packet_sequencer_base_0);//in micro seconds
					  info("The FPGA core version is: %0.1f\n",tmp/10.0);
					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "OXecS=%d",tmp);
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
				}

	else if ( strcmp (c, "setowdlycnt") == 0){

					scanf ("%d",&tmp);
					  set_owdly_cnt(time_sync_base_0, tmp);
					  info("Enable time sync...\n");
					  oled_clear(zedboard_oled_params_0.base_address);
					  sprintf(&menuBuf[0], "%s %f", "SETONWDLY:",tmp/125e6);
					  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					ui_draw();
				  }
	else if ( strcmp (c, "latency") == 0){


				time_sync_en(time_sync_base_0);
				usleep(100);
				time_sync_tx_en(full_udp_stack_ip_base_0);
			  info("Enable time sync...\n");
			  sleep(1);
			  time_tms_off(time_sync_base_0);
			  usleep(100);
			  time_tms_en(time_sync_base_0);
			  usleep(100);
			  time_sync_tx_en(full_udp_stack_ip_base_0);
			  info("Measuring time delay...\n");
			  sleep(3);
			  get_tms_delays(time_sync_base_0);
			  get_tms_delay_mean(time_sync_base_0);
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "MDLAY: ..");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
//		tmp = get_media_latency(time_sync_base_0);
//
//					info("The running media packets latency is: %0.1f ms\n",tmp/SAMPLE_RATE);
//					  oled_clear(zedboard_oled_params_0.base_address);
//					  sprintf(&menuBuf[0], "%s", "MDLAY: ..");
//					  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
//					  ui_draw();
		   }
	else if ( strcmp (c, "mlat") == 0){
			tmp = get_media_latency(time_sync_base_0);

			info("The running media packets latency is: %0.1f ms\n",tmp/SAMPLE_RATE);
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "MDLAY: ..");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
		   }
      else if ( strcmp (c, "strpktcon") == 0){

			  set_pcnt_mode_on(audio_to_eth_base_0);
			  info("Enable UDP packet tx...\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "Pkt Count: ON");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
		  }
      else if ( strcmp (c, "strpktcoff") == 0){

			  set_pcnt_mode_off(audio_to_eth_base_0);
			  info("Disable UDP packet count\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "Pkt Count: OFF");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
			}

      else if ( strcmp (c, "strsndon") == 0){

      			  set_stream_send_on(audio_to_eth_base_0);
      			  info("Enable UDP payload generation\n");
      			oled_clear(zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "%s", "Pkt Send: ON");
      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			ui_draw();
      		  }
            else if ( strcmp (c, "strsndoff") == 0){

      			  set_stream_send_off(audio_to_eth_base_0);
      			  info("Disable UDP payload generation \n");
      			oled_clear(zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "%s", "Pkt Send: OFF");
      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			ui_draw();
      			}

      else if ( strcmp (c, "strselarm") == 0){
          	  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
          	  info("Play arm stream\n>");
          	oled_clear(zedboard_oled_params_0.base_address);
          	sprintf(&menuBuf[0], "%s", "Pkt Send: ARM");
          	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          	ui_draw();
            }
      else if ( strcmp (c, "strseleth") == 0){
               	  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
               	  info("Play Eth stream\n>");
               	oled_clear(zedboard_oled_params_0.base_address);
               	sprintf(&menuBuf[0], "%s", "Pkt Send: ETH");
               	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
               	ui_draw();
                 }

      else if ( strcmp (c, "start") == 0){
//    	  set_sync_off(audio_to_eth_base_0);
    	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);

		write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x02);
		buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
//		info("Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//						  BYTE_TO_BINARY(buf>>24),BYTE_TO_BINARY(buf>>16),BYTE_TO_BINARY(buf>>8), BYTE_TO_BINARY(buf));

		set_stream_send_on(audio_to_eth_base_0);
				usleep(200);
				reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
//				init_incall_timed_task_handler();// In the SIP UA layer
		printf("Stream tx started status was:0x%X\n>",buf);
//		sleep(1);
//		initiate_sync(time_sync_base_0);
//		set_sync_on(audio_to_eth_base_0);
//		info("Enable time sync...\n");
		oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s", "UDP Send: ON");
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		ui_draw();
      }

      else if ( strcmp (c, "strrxon") == 0){
          	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
          	      	  write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x04);
          	      	info("Stream rx started status was:0x%X\n>",buf);
          	      	oled_clear(zedboard_oled_params_0.base_address);
          	      	sprintf(&menuBuf[0], "%s", "UDP Rx: ON");
          	      	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          	      	ui_draw();
            }


      else if ( strcmp (c, "stop") == 0){
    	  set_stream_send_off(audio_to_eth_base_0);
    	  info("Disable Audio payload generation \n");
    	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
    	  set_sync_off(audio_to_eth_base_0);
    	  info("Disable time sync...\n");
    	  write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFD);
    	  oled_clear(zedboard_oled_params_0.base_address);
    	  sprintf(&menuBuf[0], "%s", "UDP Send: OFF");
    	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
    	  buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
    	  info( "Stream tx stopped status was:0x%X\n>",buf);
    	  info("Stop timed tasks...\n");
//    	  deinit_incall_timed_task_handler();
    	  signal(SIGALRM, SIG_IGN);          /* ignore this signal       */
            }
      else if ( strcmp (c, "strrxstop") == 0){
          	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
          	  write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFB);
          	  oled_clear(zedboard_oled_params_0.base_address);
          	  sprintf(&menuBuf[0], "%s", "UDP Receive: OFF");
          	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          	  info( "Stream rx stopped status was:0x%X\n>",buf);
                  }
      else if(strcmp (c,"strmac") == 0) {
		  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
    	  scanf("%s",ip);
		  extractMacAddress(ip,&macAddress[0]);
		  info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
		  //write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, ((macAddress[0]<<40)|(macAddress[1]<<32)|macAddress[2]<<24)|(macAddress[3]<<16)|(macAddress[4]<<8)|(macAddress[5]);
		  write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, &macAddress[0]);
		  oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s", menuitem[11]);
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%02x%02x%02x%02x%02x%02x",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

		  ui_draw();
	}
      else if(strcmp (c,"strsip") == 0) {
      		  //SET_STATUS("Enter Dest IP Address (xxx.xxx.xxx.xxx format): ");
          	  scanf("%s",ip);
      		  extractIpAddress(ip,&ipAddress[0]);
      		  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
      		  write_eth_param(full_udp_stack_ip_base_0, SYNC_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

      		  oled_clear(zedboard_oled_params_0.base_address);
      		  sprintf(&menuBuf[0], "%s", menuitem[13]);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", ip);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

      		  ui_draw();
      	}

      else if(strcmp (c,"strdip") == 0) {
		  //SET_STATUS("Enter Dest IP Address (xxx.xxx.xxx.xxx format): ");
    	  scanf("%s",ip);
		  extractIpAddress(ip,&ipAddress[0]);
		  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
		  write_eth_param(full_udp_stack_ip_base_0, DEST_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s", menuitem[13]);
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s", ip);
		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

		  ui_draw();
	}
      else if(strcmp (c,"strlip") == 0) {
      		  //SET_STATUS("Enter Local IP Address (xxx.xxx.xxx.xxx format): ");
    	  scanf("%s",ip);
      		  extractIpAddress(ip,&ipAddress[0]);
      		  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
      		write_eth_param(full_udp_stack_ip_base_0, LOCAL_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

      		  oled_clear(zedboard_oled_params_0.base_address);
      		sprintf(&menuBuf[0], "%s", menuitem[12]);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", ip);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

      		  ui_draw();
      	}

      else if(strcmp (c,"strsip") == 0) {
      		  //SET_STATUS("Enter Dest IP Address (xxx.xxx.xxx.xxx format): ");
          	  scanf("%s",ip);
      		  extractIpAddress(ip,&ipAddress[0]);
      		  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
      		  write_eth_param(full_udp_stack_ip_base_0, SYNC_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

      		  oled_clear(zedboard_oled_params_0.base_address);
      		  sprintf(&menuBuf[0], "%s", "SYNC_IP:");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", ip);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

      		  ui_draw();
      	}

      else if(strcmp (c,"strgip") == 0) {
           		  //SET_STATUS("Enter Gateway IP Address (xxx.xxx.xxx.xxx format): ");
           		  scanf("%s",ip);
           		  extractIpAddress(ip,&ipAddress[0]);
           		  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
           		write_eth_param(full_udp_stack_ip_base_0, GTWAY_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

           		  oled_clear(zedboard_oled_params_0.base_address);
           		sprintf(&menuBuf[0], "%s", menuitem[14]);
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", ip);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

           		  ui_draw();
           	}
      else if(strcmp (c,"strmask") == 0) {
                 		  //SET_STATUS("Enter Netmask IP Address (xxx.xxx.xxx.xxx format): ");
    	  scanf("%s",ip);
		  extractIpAddress(ip,&ipAddress[0]);
		  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
		  write_eth_param(full_udp_stack_ip_base_0, MASK_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s", menuitem[15]);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", ip);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
		  ui_draw();
     }

      else if(strcmp (c,"strport") == 0) {
              //SET_STATUS("Enter port:\n");

              scanf ("%d",&dest_port);
              write_eth_param(full_udp_stack_ip_base_0, DEST_PORT_ID, dest_port);

              oled_clear(zedboard_oled_params_0.base_address);
              sprintf(&menuBuf[0], "%s", menuitem[16]);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d", dest_port);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
              ui_draw();
            }
      else if(strcmp (c,"strsport") == 0) {
                    //SET_STATUS("Enter port:\n");

                    scanf ("%d",&dest_port);
                    write_eth_param(full_udp_stack_ip_base_0, SYNC_PORT_ID, dest_port);

                    oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[0], "%s", "SYNC PORT");
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%d", dest_port);
					oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
                    ui_draw();
                  }

      else if(strcmp (c,"setswp1") == 0) {
		  //SET_STATUS("Enter port:\n");

		  scanf ("%d",&sw_port);
		  write_switch_param(hyb_switch_ip_base_0, PORT1_ID, sw_port);

		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s", "SW PORT1");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d", sw_port);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
		  ui_draw();
		}

      else if(strcmp (c,"setswp2") == 0) {
      		  //SET_STATUS("Enter port:\n");

      		  scanf ("%d",&sw_port);
      		  write_switch_param(hyb_switch_ip_base_0, PORT2_ID, sw_port);

      		  oled_clear(zedboard_oled_params_0.base_address);
      		  sprintf(&menuBuf[0], "%s", "SW PORT2");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%d", sw_port);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
      		  ui_draw();
      		}

      else if(strcmp (c,"setswp3") == 0) {
		  //SET_STATUS("Enter port:\n");

		  scanf ("%d",&sw_port);
		  write_switch_param(hyb_switch_ip_base_0, PORT3_ID, sw_port);

		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s", "SW PORT3");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d", sw_port);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
		  ui_draw();
		}

      else if(strcmp (c,"setswp4") == 0) {
		  //SET_STATUS("Enter port:\n");

		  scanf ("%d",&sw_port);
		  write_switch_param(hyb_switch_ip_base_0, PORT4_ID, sw_port);

		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s", "SW PORT4");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d", sw_port);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
		  ui_draw();
		}
      else if(strcmp (c,"setswp5") == 0) {
		  //SET_STATUS("Enter port:\n");

		  scanf ("%d",&sw_port);
		  write_switch_param(hyb_switch_ip_base_0, PORT5_ID, sw_port);

		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s", "SW PORT5");
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%d", sw_port);
		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
		  ui_draw();
		}
      else if(strcmp (c,"setswp6") == 0) {
		  //SET_STATUS("Enter port:\n");

		  scanf ("%d",&sw_port);
		  write_switch_param(hyb_switch_ip_base_0, PORT6_ID, sw_port);

		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s", "SW PORT6");
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%d", sw_port);
		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
		  ui_draw();
		}
      else if(strcmp (c,"setswp7") == 0) {
		  //SET_STATUS("Enter port:\n");

		  scanf ("%d",&sw_port);
		  write_switch_param(hyb_switch_ip_base_0, PORT7_ID, sw_port);

		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s", "SW PORT7");
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%d", sw_port);
		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
		  ui_draw();
		}
      else if(strcmp (c,"setswp8") == 0) {
		  //SET_STATUS("Enter port:\n");

		  scanf ("%d",&sw_port);
		  write_switch_param(hyb_switch_ip_base_0, PORT8_ID, sw_port);

		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s", "SW PORT8");
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%d", sw_port);
		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
		  ui_draw();
		}
      else if(strcmp (c,"strnsp") == 0) {//cant set speed
      		  //SET_STATUS("Enter Net speed 0=10M, 1=100M, 2=1G: ");
      		  scanf ("%d",&tmp);

      		buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
      		if(tmp == 0){
      		   write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFF9);
      		}else if(tmp == 1){
       		   write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFB);
       		}else if(tmp == 2){
       		   write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFD);
       		}


      		  oled_clear(zedboard_oled_params_0.base_address);
      		sprintf(&menuBuf[0], "%s%s", menuitem[12], ip);
      		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

      		  ui_draw();
      	}
      else if(strcmp (c,"strplen") == 0) {
                    //SET_STATUS("Enter payload length in 24 bit samples:\n");
                    //UDP header is 8 bytes
                    scanf ("%d",&tmp);
                    int c = (tmp-12-2)%4;
                    pkt_len = tmp-12-2;
                    pkt_len_rl_samples = pkt_len/4;
                    if (c > 0){
                    	info( "Warning:: Bad packet length:: The packet length formula is:: 4xN + 14 \n Choose N wisely!!!\n");
                    }
                    //write_eth_param(full_udp_stack_ip_base_0, PKT_LEN_ID, ((tmp*3) +8);//+8 done in fpga
                    //write_audio_to_eth_param(audio_to_eth_base_0, PAYLEN_REG_ID, tmp*3);
                    set_stream_plen(audio_to_eth_base_0,tmp);
                    oled_clear(zedboard_oled_params_0.base_address);
            		sprintf(&menuBuf[0], "Pkt Length:%5d", (tmp));
            		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                    ui_draw();
                  }

      else if(strcmp (c,"strporder") == 0) {

                          scanf ("%d",&tmp);

                          set_stream_porder(eth_packet_sequencer_base_0,tmp);
                          oled_clear(zedboard_oled_params_0.base_address);
                  		sprintf(&menuBuf[0], "Pkt Seq Odr:%d", (tmp));
                  		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                          ui_draw();
                        }
//      else if(strcmp (c,"setsqwdly") == 0) {//PKT_WAIT_DELAY
//
//                                scanf ("%d",&tmp);
//
//                                set_stream_pkt_wait(eth_packet_sequencer_base_0,tmp*(0x40);//in micro seconds
//                                oled_clear(zedboard_oled_params_0.base_address);
//                        		sprintf(&menuBuf[0], "Pkt Seq WDly:%d us", (tmp));
//                        		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
//                                ui_draw();
//                              }
      else if(strcmp (c,"setppdly") == 0) {//PKT_WAIT_DELAY

                                      scanf ("%d",&tmp);

                                      set_stream_pkt_wait(eth_packet_sequencer_base_0,tmp*(0x40));//in micro seconds
                                      oled_clear(zedboard_oled_params_0.base_address);
                              		sprintf(&menuBuf[0], "Pkt Seq WDly:%d us", (tmp));
                              		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                                      ui_draw();
                                    }
      else if(strcmp (c,"setsqsdly") == 0) {//PKT_SEND_DELAY

                                      scanf ("%d",&tmp);

                                      set_stream_pkt_send_delay(eth_packet_sequencer_base_0,tmp*(0x40));//in micro seconds
                                      oled_clear(zedboard_oled_params_0.base_address);
                              		sprintf(&menuBuf[0], "Pkt Seq SDly:%d us", (tmp));
                              		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                                      ui_draw();
                                    }


      else if(strcmp (c,"setplcpktsize") == 0)
      {
				SET_STATUS("Set PLC packet size (same as incoming rx packet size)\n");
				//UDP header is 8 bytes
				scanf ("%d",&tmp);
				int c = (tmp-2)%6;

				if (c > 0){
					info( "Warning:: Bad packet length:: The packet length formula is:: 4xN + 14 \n Choose N wisely!!!\n");
				}

				set_stream_rx_pkt_size(eth_packet_sequencer_base_0,(tmp-2));//in bytes
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "PLC pSz:%d", ((tmp-2)));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }


      else if(strcmp (c,"setpblim") == 0) {
				//SET_STATUS("Enter payload length in 24 bit samples:\n");
				//UDP header is 8 bytes
				scanf ("%d",&tmp);

				//set_stream_rx_buf_lim(eth_packet_sequencer_base_0,tmp);//in micro seconds
				set_stream_rx_buf_lim2(eth_to_audio_base_0,tmp);//in micro seconds
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "PoBlim:%d ", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }


      else if(strcmp (c,"setdlim") == 0) {
      				//SET_STATUS("Enter payload length in 24 bit samples:\n");
      				//UDP header is 8 bytes
      				scanf ("%d",&tmp);
      				set_stream_rx_buf_dlim(eth_to_audio_base_0,tmp);//in micro seconds
      				oled_clear(zedboard_oled_params_0.base_address);
      				sprintf(&menuBuf[0], "Dlim:%d ", (tmp));
      				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      				ui_draw();
      			  }

      else if(strcmp (c,"setbslk") == 0) {
            				//SET_STATUS("Enter payload length in 24 bit samples:\n");
            				//UDP header is 8 bytes
            				scanf ("%d",&tmp);
            				set_stream_rx_buf_slack(eth_to_audio_base_0,tmp);//in micro seconds
            				oled_clear(zedboard_oled_params_0.base_address);
            				sprintf(&menuBuf[0], "BSlk:%d ", (tmp));
            				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            				ui_draw();
            			  }
      else if(strcmp (c,"setbdlm") == 0) {
                  				//SET_STATUS("Enter payload length in 24 bit samples:\n");
                  				//UDP header is 8 bytes
                  				scanf ("%d",&tmp);
                  				set_stream_rx_buf_docc_lim(eth_to_audio_base_0,tmp);//in micro seconds
                  				oled_clear(zedboard_oled_params_0.base_address);
                  				sprintf(&menuBuf[0], "Bdoc:%d ", (tmp));
                  				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                  				ui_draw();
                  			  }
      else if(strcmp (c,"setprdly") == 0) {
     				//SET_STATUS("Enter payload length in 24 bit samples:\n");
     				//UDP header is 8 bytes
     				scanf ("%d",&tmp);

     				set_plc_replace_delay(eth_packet_sequencer_base_0,tmp);//in clocks
     				oled_clear(zedboard_oled_params_0.base_address);
     				sprintf(&menuBuf[0], "RepDly:%d ", (tmp));
     				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
     				ui_draw();
     			  }
      else if(strcmp (c,"setsqlkdly") == 0) {
           				//SET_STATUS("Enter payload length in 24 bit samples:\n");
           				//UDP header is 8 bytes
           				scanf ("%d",&tmp);
           				set_seq_replace_lock_delay(eth_packet_sequencer_base_0,tmp);//in clocks
           				oled_clear(zedboard_oled_params_0.base_address);
           				sprintf(&menuBuf[0], "SQLkDly:%d ", (tmp));
           				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
           				ui_draw();
           			  }
      else if(strcmp (c,"sqwon") == 0) {
							  //SET_STATUS("Enter payload length in 24 bit samples:\n");

							  set_stream_pkt_wait_enable(eth_packet_sequencer_base_0);//in micro seconds
							  oled_clear(zedboard_oled_params_0.base_address);
							sprintf(&menuBuf[0], "Pkt Seq Dly:CUS");
							oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
							  ui_draw();
							}
      else if(strcmp (c,"sqwoff") == 0) {

							set_stream_pkt_wait_disable(eth_packet_sequencer_base_0);//in micro seconds
							oled_clear(zedboard_oled_params_0.base_address);
							sprintf(&menuBuf[0], "Pkt Seq Dly:DFT");
							oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
							ui_draw();
						  }
      else if(strcmp (c,"sqsdon") == 0) {

      							  set_stream_pkt_send_delay_enable(eth_packet_sequencer_base_0);//in micro seconds
      							  oled_clear(zedboard_oled_params_0.base_address);
      							sprintf(&menuBuf[0], "Pkt Seq Dly:CUS");
      							oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      							  ui_draw();
      							}
            else if(strcmp (c,"sqsdoff") == 0) {

      							set_stream_pkt_send_delay_disable(eth_packet_sequencer_base_0);//in micro seconds
      							oled_clear(zedboard_oled_params_0.base_address);
      							sprintf(&menuBuf[0], "Pkt Seq Dly:DFT");
      							oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      							ui_draw();
      						  }
            else if(strcmp (c,"plcoff") == 0) {

            	    set_plc_disable(eth_to_audio_base_0);//in micro seconds
					oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "PLC:OFF");
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					ui_draw();
				  }
            else if(strcmp (c,"plcon") == 0) {

					set_plc_enable(eth_to_audio_base_0);//in micro seconds
					oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "PLC:ON");
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					ui_draw();
				  }
            else if(strcmp (c,"strblen") == 0) {
                          //SET_STATUS("Enter payload length in 24 bit samples:\n");
                          //UDP header is 8 bytes
                          scanf ("%d",&tmp);
                          //write_eth_param(full_udp_stack_ip_base_0, PKT_LEN_ID, ((tmp*3) +8);//+8 done in fpga
                          //write_audio_to_eth_param(audio_to_eth_base_0, PAYLEN_REG_ID, tmp*3);
                          set_stream_blen(eth_to_audio_base_0,tmp);
                          sleep(1);
                          reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right

                          oled_clear(zedboard_oled_params_0.base_address);
                  		sprintf(&menuBuf[0], "%s:%5d", menuitem[27], (tmp));
                  		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                          ui_draw();
                        }
      else if(strcmp (c,"delay") == 0) {
    	  scanf ("%d",&tmp);
    	  set_playout_delay(eth_to_audio_base_0,tmp*SAMPLE_RATE);
    	  oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s:%5d", "POUDLY", (tmp));
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		ui_draw();
      }
      else if(strcmp (c,"getpoutdly") == 0) {
			//SET_STATUS("Enter payload length in 24 bit samples:\n");
			//UDP header is 8 bytes
			tmp = get_playout_delay(eth_to_audio_base_0);
			info( "The current audio playout delay is:%d samples\n",(tmp));
			info( "The current audio playout delay is:%f ms\n",(tmp/SAMPLE_RATE));
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d samples", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d ms", (tmp/SAMPLE_RATE));
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			ui_draw();
		  }

      else if(strcmp (c,"getpouttime") == 0) {
      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
      			//UDP header is 8 bytes
      			tmp = get_instant_playout_time(eth_to_audio_base_0);
      			info( "The current audio playout time is:%f ms\n",(tmp/SAMPLE_RATE));
      			oled_clear(zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "TCO:%d ", (tmp));
      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "%d ms", (tmp/SAMPLE_RATE));
      			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
      			ui_draw();
      		  }
      else if(strcmp (c,"getsynctime") == 0) {
			//SET_STATUS("Enter payload length in 24 bit samples:\n");
			//UDP header is 8 bytes
			tmp = get_sync_time(eth_to_audio_base_0);
			info( "The current audio sync time is:%f ms\n",(tmp/SAMPLE_RATE));
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "TC:%d ", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d ms", (tmp/SAMPLE_RATE));
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			ui_draw();
		  }
      else if(strcmp (c,"getalle2a") == 0) {
      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
      			//UDP header is 8 bytes

    	  info( "All reg values for the Eth to audio block\n");
      			get_all_eth2audio(eth_to_audio_base_0);
      			info( "The current audio sync time is:%f ms\n",(tmp/SAMPLE_RATE));
      			oled_clear(zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "TC:%d ", (tmp));
      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "%d ms", (tmp/SAMPLE_RATE));
      			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
      			ui_draw();
      		  }
      else if(strcmp (c,"getrxtc") == 0) {
      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
      			//UDP header is 8 bytes
      			tmp =  get_rx_time_code(eth_to_audio_base_0);
      			info( "The current audio rxtc is:%d samples\n",(tmp));
      			info( "The current audio rxtc is:%f ms\n",(tmp/SAMPLE_RATE));
      			oled_clear(zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "rtc:%d smp", (tmp));
      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "rtc:%d ms", (tmp/SAMPLE_RATE));
      			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
      			ui_draw();
      		  }

      else if(strcmp (c,"getrxtceff") == 0) {
				//SET_STATUS("Enter payload length in 24 bit samples:\n");
				//UDP header is 8 bytes
				tmp =  get_rx_time_code_eff(eth_to_audio_base_0);
				info( "The current audio rxtceff is:%d samples\n",(tmp));
				info( "The current audio rxtceff is:%f ms\n",(tmp/SAMPLE_RATE));
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "rtc:%d smp", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "rtc:%d ms", (tmp/SAMPLE_RATE));
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
				ui_draw();
			  }

      else if(strcmp (c,"getrxtcocc") == 0) {
			//SET_STATUS("Enter payload length in 24 bit samples:\n");
			//UDP header is 8 bytes
			tmp =  get_rx_time_code_occ(eth_to_audio_base_0);
			info( "The current audio rxtc is:%d samples\n",(tmp));
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "rtcocc:%d smp", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

			ui_draw();
		  }
      else if(strcmp (c,"setlooplimit") == 0) {
          	  scanf ("%d",&tmp);
          	  set_loop_limit(eth_to_audio_base_0,tmp);
          	  oled_clear(zedboard_oled_params_0.base_address);
      		sprintf(&menuBuf[0], "%s:%5d", "LOOPLIM", (tmp));
      		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      		ui_draw();
            }
      else if(strcmp (c,"gettc") == 0) {
    	  unsigned long tmp1, tmp2, tmp3;
			//SET_STATUS("Enter payload length in 24 bit samples:\n");
			//UDP header is 8 bytes
    	  tmp =  get_rx_time_code(eth_to_audio_base_0);
		  printf("The current audio rxtc is:%0.3f ms\n",(tmp/SAMPLE_RATE));
  //		  tmp = get_rx_time_code_fout(eth_to_audio_base_0);
  //		  printf("The current audio rxtcfout is:%0.3f ms\n",(tmp/SAMPLE_RATE));
		  tmp1 =  get_rx_time_code_eff(eth_to_audio_base_0);
		  printf("The current audio rxtceff is:%0.3f ms\n",(tmp1/SAMPLE_RATE));
		  tmp2 = get_playout_delay(eth_to_audio_base_0);
		  printf("The current audio playout delay is: %0.3f\n----------------------------------------\n",(tmp2/SAMPLE_RATE));
		  printf("The current audio sched playout time is: %0.3f\n",((tmp1+tmp2)/SAMPLE_RATE));
		  tmp = get_sync_time(eth_to_audio_base_0);
		  printf("The current audio sync time is:%0.3f ms\n",(tmp/SAMPLE_RATE));
		  tmp = get_instant_playout_time(eth_to_audio_base_0);
		  printf("The current audio playout time is:%0.3f ms\n",(tmp/SAMPLE_RATE));
		  tmp = get_dac_ofifo_occ(eth_to_audio_base_0);
		  printf("The current odd audio buf sample count is:%d samples\n",(tmp));
		  tmp = get_dac_efifo_occ(eth_to_audio_base_0);
		  printf("The current even audio buf sample count is:%d samples\n",(tmp));
		  tmp = get_dac_dump_pkts(eth_to_audio_base_0);
		  printf("The num of dropped pkts in dpkt is:%d pks\n",(tmp));
		  tmp = get_pkts_dropped(eth_packet_sequencer_base_0);
		  printf("The number of sq packets dropped is:%d\n",tmp);
		  tmp = get_pkt_seq_skiped(eth_packet_sequencer_base_0);
		  printf("The number of sq packets skipped is:%d\n",tmp);
		tmp = get_dpkt_replace_events(eth_to_audio_base_0);
    	      	    	  printf("The number of dpkt replace events is:%d\n",tmp);
    	  //    	  tmp = get_media_latency(time_sync_base_0);
    	  //    	  printf("The running media packets latency is: %0.1f ms\n",tmp/SAMPLE_RATE);


    	  //			tmp =  get_rx_time_code_occ(eth_to_audio_base_0);
    	  //			printf("The current audio rxtc occ is:%d\n",(tmp));

    	  			oled_clear(zedboard_oled_params_0.base_address);
    	  			sprintf(&menuBuf[0], "tsyncvars");
    	  			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

    	  			ui_draw();
		  }
      else if(strcmp (c,"getpoutr") == 0) {
      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
      			//UDP header is 8 bytes
      			tmp = get_instant_playout_reads(eth_to_audio_base_0);
      			info( "The current audio playout reads is:%d samples\n",(tmp));
      			oled_clear(zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "%d samples", (tmp));
      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			ui_draw();
      		  }
      else if(strcmp (c,"getpoutw") == 0) {
      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
      			//UDP header is 8 bytes
      			tmp = get_instant_playout_writes(eth_to_audio_base_0);
      			info( "The current audio playout writes is:%d samples\n",(tmp));

      			oled_clear(zedboard_oled_params_0.base_address);
      			sprintf(&menuBuf[0], "%d samples", (tmp));
      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      			oled_print_message(&menuBuf[1], 2, zedboard_oled_params_0.base_address);
      			ui_draw();
      		  }


      else if(strcmp (c,"getfocc") == 0) {
				//SET_STATUS("Enter payload length in 24 bit samples:\n");
				//UDP header is 8 bytes
				tmp = get_dac_fifo_occ(eth_to_audio_base_0);
				info( "The current audio buf sample count is:%d samples\n",(tmp));

				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "BUF OCC::");
				sprintf(&menuBuf[1], "%d samples", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				oled_print_message(&menuBuf[1], 2, zedboard_oled_params_0.base_address);
				ui_draw();
			  }
      else if(strcmp (c,"setcrwin") == 0) {

          	  set_buf_corr_window(eth_to_audio_base_0,tmp);
          	  oled_clear(zedboard_oled_params_0.base_address);
      		sprintf(&menuBuf[0], "%s:%5d", "POUDLY", (tmp));
      		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      		ui_draw();
            }

      else if ( strcmp (c, "tgsrcorr") == 0){
			  clear_buf_corr(eth_to_audio_base_0);
			  sleep(1);
          	  set_buf_corr_on(eth_to_audio_base_0);
			  info( "Toggle sample rate correction\n>");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SRCorr:ON");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
		  }

      else if ( strcmp (c, "setcoron") == 0){
    	  set_buf_corr_on(eth_to_audio_base_0);
          	  info( "Enable sample rate correction\n>");
          	  oled_clear(zedboard_oled_params_0.base_address);
          	  sprintf(&menuBuf[0], "%s", "SRCorr:ON");
          	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
          	  ui_draw();
            }



      else if ( strcmp (c, "setcoroff") == 0){
          	  clear_buf_corr(eth_to_audio_base_0);
			  info( "Disable sample rate correction\n>");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SRCorr:OFF");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
		  }
      else if ( strcmp (c, "gete2astatus") == 0){
    	  	  info( "Eth to Audio ststus is::\n>");
    	  	  get_e2a_status(eth_to_audio_base_0);

			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "ETH2AUD:Status");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
		  }

      else if(strcmp (c,"getmac") == 0) {
      		  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
          	  //scanf("%s",ip);
      		  //extractMacAddress(ip,&macAddress[0]);
      		  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
      		read_eth_mac(full_udp_stack_ip_base_0, MAC_REG_ID,&ip[0]);
      		//info( "\nMAC Address:");
//      		      		   print_mac(tmp, ip);
      		  oled_clear(zedboard_oled_params_0.base_address);
      		sprintf(&menuBuf[0], "%s", menuitem[11]);
      		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      		sprintf(&menuBuf[0], "%s", ip);
      		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

      		  ui_draw();
      	}

            else if(strcmp (c,"getdip") == 0) {
      		  //SET_STATUS("Enter Dest IP Address (xxx.xxx.xxx.xxx format): ");
          	  //scanf("%s",ip);
      		  //extractIpAddress(ip,&ipAddress[0]);
            //info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
      		  tmp=read_eth_param(full_udp_stack_ip_base_0, DEST_IP_REG_ID);
      		info( "\nDest Ip Address:");
      		   print_ip(tmp, ip);
      		  oled_clear(zedboard_oled_params_0.base_address);
      		  sprintf(&menuBuf[0], "%s", menuitem[13]);
      		  		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      		  		sprintf(&menuBuf[0], "%s", ip);
      		  		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

      		  ui_draw();
      	}
            else if(strcmp (c,"getlip") == 0) {

            		tmp = read_eth_param(full_udp_stack_ip_base_0, LOCAL_IP_REG_ID);
            		info( "\nLocal Ip Address:");
            		print_ip(tmp, &ip[0]);
            		  oled_clear(zedboard_oled_params_0.base_address);
            		sprintf(&menuBuf[0], "%s", menuitem[12]);
            				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            				sprintf(&menuBuf[0], "%s", ip);
            				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

            		  ui_draw();
            	}

            else if(strcmp (c,"getgip") == 0) {

                 		tmp=read_eth_param(full_udp_stack_ip_base_0, GTWAY_IP_REG_ID);

                 		      		info( "\nGateway Ip Address:");
                 		      		  print_ip(tmp, ip);

                 		  oled_clear(zedboard_oled_params_0.base_address);
                 		sprintf(&menuBuf[0], "%s", menuitem[14]);
                 				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                 				sprintf(&menuBuf[0], "%s", ip);
                 				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

                 		  ui_draw();
                 	}
            else if(strcmp (c,"getmask") == 0) {

      		  tmp=read_eth_param(full_udp_stack_ip_base_0, MASK_IP_REG_ID);
      		info( "\nMask Ip Address:");
      		  print_ip(tmp, ip);
      		  oled_clear(zedboard_oled_params_0.base_address);
      		  sprintf(&menuBuf[0], "%s", menuitem[15]);
      		  		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
      		  		sprintf(&menuBuf[0], "%s", ip);
      		  		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
      		  ui_draw();
           }

            else if(strcmp (c,"getport") == 0) {
            	dest_port = read_eth_param(full_udp_stack_ip_base_0, DEST_PORT_REG_ID);
            	info( "The port is:%d\n",dest_port);
                    oled_clear(zedboard_oled_params_0.base_address);
                    sprintf(&menuBuf[0], "%s", menuitem[16]);
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%d", dest_port);
					oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
                    ui_draw();
                  }

            else if(strcmp (c,"getsport") == 0) {
                        	dest_port = read_eth_param(full_udp_stack_ip_base_0, SYNC_PORT_REG_ID);
                        	info( "The sync port is:%d\n",dest_port);
                                oled_clear(zedboard_oled_params_0.base_address);
                                sprintf(&menuBuf[0], "%s", menuitem[16]);
            					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            					sprintf(&menuBuf[0], "%d", dest_port);
            					oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
                                ui_draw();
                              }

            else if(strcmp (c,"getplen") == 0) {

                          tmp = get_stream_plen(audio_to_eth_base_0);
                          info( "The udp payload size is:%d\n",tmp);
                          oled_clear(zedboard_oled_params_0.base_address);
                  		sprintf(&menuBuf[0], "%s%5d", menuitem[25], (tmp));
                  		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                          ui_draw();
                        }
            else if(strcmp (c,"getporder") == 0) {

				  tmp = get_stream_porder(eth_packet_sequencer_base_0);
				  info( "The udp packet sequencer order is:%d\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%5d", menuitem[26], (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}
            else if(strcmp (c,"getpdrop") == 0) {

//				  tmp = get_pkts_dropped(packet_time_enforcer_base_0);
            	tmp = get_pkts_dropped(eth_packet_sequencer_base_0);
				  info( "The number of packets dropped is:%u\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%d", "NPD:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}
            else if(strcmp (c,"getpreplaced") == 0) {

            //				  tmp = get_pkts_dropped(packet_time_enforcer_base_0);
                        	tmp = get_pkts_replaced(eth_packet_sequencer_base_0);
            				  info( "The number of packets replaced is:%u\n",tmp);
            				  oled_clear(zedboard_oled_params_0.base_address);
            				sprintf(&menuBuf[0], "%s%d", "NPR:", (tmp));
            				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            				  ui_draw();
            				}
            else if(strcmp (c,"getsqgs") == 0) {

				  tmp = get_seq_gs(eth_packet_sequencer_base_0);
				  info( "The udp packet sequencer gs is:%08x\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%5d", "GST:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}
			else if(strcmp (c,"getsqrx") == 0) {

//				  tmp = get_pkts_dropped(packet_time_enforcer_base_0);
				tmp = get_seq_pkts_rx(eth_packet_sequencer_base_0);
				  info( "The number of packets sqrx is:%u\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%d", "SRX:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}
			else if(strcmp (c,"getsqtx") == 0) {//get_seq_pkts_rx

//				  tmp = get_pkts_dropped(packet_time_enforcer_base_0);
				tmp = get_seq_pkts_tx(eth_packet_sequencer_base_0);
				  info( "The number of packets sqtx is:%u\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%d", "STX:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}
			else if(strcmp (c,"getsqov") == 0) {//get_seq_pkts_rx

//				  tmp = get_pkts_dropped(packet_time_enforcer_base_0);
				tmp = get_seq_pkts_ov(eth_packet_sequencer_base_0);
				  info( "The number of packets sqov is:%u\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%d", "SOV:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}
            else if(strcmp (c,"setptl1") == 0) {//spkt2pkt
				//SET_STATUS("Enter payload length in 24 bit samples:\n");
				//UDP header is 8 bytes
				scanf ("%d",&tmp);
				//write_eth_param(full_udp_stack_ip_base_0, PKT_LEN_ID, ((tmp*3) +8);//+8 done in fpga
				//write_audio_to_eth_param(audio_to_eth_base_0, PAYLEN_REG_ID, tmp*3);
				set_spkt_to_pkt_delay_limit(packet_time_enforcer_base_0,tmp);//just sample clock counts no need to multiply by 2
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "Buffer2Drop:%d", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }

            else if(strcmp (c,"setptpidl") == 0) {//spkt2pkt_locked
				scanf ("%d",&tmp);
				set_spkt_to_pkt_locked_delay_limit(packet_time_enforcer_base_0,tmp);//just sample clock counts no need to multiply by 2
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "BL2Drop:%d", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }

		  else if(strcmp (c,"setptl2") == 0) {//spkt2pkt

			  scanf ("%d",&tmp);//in milliseconds

			  set_accum_pkt_to_pkt_delay_limit(packet_time_enforcer_base_0,tmp);//just sample clock counts no need to multiply by 2
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "BufferA2Drop:%d", (tmp));
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

            else if(strcmp (c,"getptl1") == 0) {

			  tmp = get_pkts_drop_spkt_limit(packet_time_enforcer_base_0);
			  info( "The delayed pkt2pkt drop limit is:%d\n",(tmp));
			  info( "The delayed pkt2pkt drop limit is:%u ms\n",(tmp/(SAMPLE_RATE)));//just sample clock counts no need to multiply by 2
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s%10u", "PDLM:", (tmp));
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}
            else if(strcmp (c,"getptpidl") == 0) {

			  tmp = get_pkts_drop_spkt_locked_limit(packet_time_enforcer_base_0);
			  info( "The delayed pkt2pkt secondary drop limit is:%d\n",(tmp));
			  info( "The delayed pkt2pkt secondary drop limit is:%u ms\n",(tmp/(SAMPLE_RATE)));//just sample clock counts no need to multiply by 2
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s%10u", "PDSLM:", (tmp));
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}
            else if(strcmp (c,"getptl2") == 0) {

			  tmp = get_pkts_adrop_spkt_limit(packet_time_enforcer_base_0);
			  info( "The delayed pkt running drop limit is:%d\n",(tmp));
			  info( "The delayed pkt running drop limit is:%u ms\n",(tmp/(SAMPLE_RATE)));
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%10u", "RDLM:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

            else if(strcmp (c,"getptlock") == 0) {

			  tmp = get_pkts_ptrx_lock(packet_time_enforcer_base_0);
			  info( "The packet timming unit lock status is:%08X\n",tmp);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%d", "LOCK:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}


            else if(strcmp (c,"ptpidon") == 0) {

            	pkt_to_pkt_locked_drop_enable(packet_time_enforcer_base_0);
            			  info( "The packet timming unit pid tatus is on.\n");
            			  oled_clear(zedboard_oled_params_0.base_address);
            			sprintf(&menuBuf[0], "%s", "PID:ON");
            			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            			  ui_draw();
            			}
            else if(strcmp (c,"ptpidoff") == 0) {

                        	pkt_to_pkt_locked_drop_disable(packet_time_enforcer_base_0);
                        			  info( "The packet timming unit pid tatus is off.\n");
                        			  oled_clear(zedboard_oled_params_0.base_address);
                        			sprintf(&menuBuf[0], "%s", "PID:OFF");
                        			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
                        			  ui_draw();
                        			}
            else if(strcmp (c,"getptstatus") == 0) {
            	tmp = get_pkts_pt_accum(packet_time_enforcer_base_0);
            			tmp = get_pkts_ptrx_lock(packet_time_enforcer_base_0);
            			  tmp = get_pkts_pt_disable(packet_time_enforcer_base_0);

            			  info( "The packet timming unit status is:%08X\n",(tmp==0)?1:0);
            			  oled_clear(zedboard_oled_params_0.base_address);
            			sprintf(&menuBuf[0], "%s%d", "PBT:", (tmp));
            			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            			  ui_draw();
            			}

            else if(strcmp (c,"setptlock") == 0) {

			  tmp = set_pkts_ptrx_lock(packet_time_enforcer_base_0, 1);
			  info( "The packet timming unit lock status is:%08X\n",tmp);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%10u", "LOCK:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

            else if(strcmp (c,"setptaccum") == 0) {

            			  tmp = set_pkts_pt_accum(packet_time_enforcer_base_0, 1);
            			  info( "The packet timming unit accum status is:%08X\n",tmp);
            			  oled_clear(zedboard_oled_params_0.base_address);
            			sprintf(&menuBuf[0], "%s%10u", "ACCUM:", (tmp));
            			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
            			  ui_draw();
            			}
            else if(strcmp (c,"clrptaccum") == 0) {

			  tmp = set_pkts_pt_accum(packet_time_enforcer_base_0, 0);
			  info( "The packet timming unit accum status is:%08X\n",tmp);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%10u", "ACCUM:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}


            else if(strcmp (c,"getptaccum") == 0) {

			  tmp = get_pkts_pt_accum(packet_time_enforcer_base_0);
			  info( "The packet timming unit accum status is:%08X\n",tmp);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%10u", "ACCUM:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

            else if(strcmp (c,"clrptlock") == 0) {

			  tmp = set_pkts_ptrx_lock(packet_time_enforcer_base_0, 0);
			  info( "The packet timming unit lock status is:%u\n",tmp);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%10u", "LOCK:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

            else if(strcmp (c,"getblen") == 0) {

				  tmp = get_stream_blen(eth_to_audio_base_0);
				  info( "The audio rx buff sample count is:%d\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%d", "RXBOCP:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}
            else if(strcmp (c,"getbrdly") == 0) {

			  tmp = get_stream_readout_delay(eth_to_audio_base_0);
			  info( "The current audio rx buff readout delay is:%f ms\n",(tmp/SAMPLE_RATE));
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%d", "BRDLY:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

		else if(strcmp (c,"getnetdly") == 0) {

		  tmp = get_stream_net_delay(packet_time_enforcer_base_0);
		  info( "The current audio network delay is:%f ms\n",(tmp/SAMPLE_RATE));
		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s%d", "NETDLY:", (tmp));
		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		  ui_draw();
		}

		else if(strcmp (c,"getpktbuilddly") == 0) {

		  tmp = get_stream_pktbuild_delay(packet_time_enforcer_base_0);
		  info( "The current audio pkt build delay is:%f ms\n",(tmp/SAMPLE_RATE));
		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s%d", "PKTBUILD:", (tmp));
		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		  ui_draw();
		}


		else if(strcmp (c,"getpkt2pktdly") == 0) {

				  tmp = get_stream_spkt_delay(packet_time_enforcer_base_0);
				  info( "The current audio pkt to pkt delay is:%f ms\n",(tmp/SAMPLE_RATE));
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s%d", "PKTBUILD:", (tmp));
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}


		else if(strcmp (c,"getaccpktdly") == 0) {

			  tmp = get_stream_accum_pkt_delay(packet_time_enforcer_base_0);
			  info( "The current audio pkt accum delay is:%f ms\n",(tmp/SAMPLE_RATE));
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s%d", "PKTBUILD:", (tmp));
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}





		else if(strcmp (c,"setnetdly") == 0) {
			scanf ("%d",&tmp);
		  tmp = set_stream_net_delay(packet_time_enforcer_base_0,tmp);
		  info( "The current audio network delay is:%d sample counts\n",(tmp));
		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s%d", "NETDLY:", (tmp));
		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		  ui_draw();
		}

		else if(strcmp (c,"setpktdly") == 0) {
			scanf ("%d",&tmp);
		  tmp = set_stream_pktbuild_delay(packet_time_enforcer_base_0, tmp);
		  info( "The current audio pkt build delay is:%d sample clocks\n",(tmp));
		  oled_clear(zedboard_oled_params_0.base_address);
		  sprintf(&menuBuf[0], "%s%d", "PKTBUILD:", (tmp));
		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		  ui_draw();
		}



		else if(strcmp (c,"ptdfon") == 0) {

					  tmp = set_pkts_pt_diff_status(packet_time_enforcer_base_0, 1);
					  info( "The packet timming unit diff status is:%08X\n",tmp);
					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%s%u", "ACCUM:", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
					}
		else if(strcmp (c,"ptdfoff") == 0) {

		  tmp = set_pkts_pt_diff_status(packet_time_enforcer_base_0, 0);
		  info( "The packet timming unit diff status is:%08X\n",tmp);
		  oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%10u", "ACCUM:", (tmp));
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		  ui_draw();
		}


		else if(strcmp (c,"getptdiffs") == 0) {

		  tmp = get_pkts_pt_diff_status(packet_time_enforcer_base_0);
		  info( "The packet timming unit diff status is:%08X\n",tmp);
		  oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%u", "ACCUM:", (tmp));
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		  ui_draw();
		}


		else if(strcmp (c,"setptdiffl") == 0) {//spkt2pkt

		  scanf ("%d",&tmp);//in milliseconds

		  set_diff_pkt_to_pkt_delay_limit(packet_time_enforcer_base_0,tmp);//just sample clock counts no need to multiply by 2
		  oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "BufferA2Drop:%d", (tmp));
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		  ui_draw();
		}

		else if(strcmp (c,"getptdiffl") == 0) {

		  tmp = get_diff_pkt_to_pkt_delay_limit(packet_time_enforcer_base_0);
		  info( "The delayed diff pkt2pkt drop limit is:%d\n",(tmp));
		  info( "The delayed diff pkt2pkt drop limit is:%u ms\n",(tmp/(SAMPLE_RATE)));//just sample clock counts no need to multiply by 2
		  oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%u", "PDLM:", (tmp));
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
		  ui_draw();
		}


		else if(strcmp (c,"getptdiffv") == 0) {

				  tmp = get_diff_pkt_to_pkt_delay(packet_time_enforcer_base_0);
				  info( "The diff pkt2pkt drop is:%d\n",(tmp));
				  info( "The diff pkt2pkt drop is:%u ms\n",(tmp/(SAMPLE_RATE)));//just sample clock counts no need to multiply by 2
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%u", "PDLM:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}

		else if(strcmp (c,"getsqos") == 0)
		{
			  //SET_STATUS("Enter payload length in 24 bit samples:\n");

			  tmp = get_out_exec_state(eth_packet_sequencer_base_0);//in micro seconds
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "OXecS=%d",tmp);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
		}

		else if(strcmp (c,"getsqis") == 0)
				{
					  //SET_STATUS("Enter payload length in 24 bit samples:\n");

					  tmp = get_in_exec_state(eth_packet_sequencer_base_0);//in micro seconds
					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "IXecS=%d",tmp);
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
				}
		else if ( strcmp (c, "monitor") == 0){

				info("Sart monitoring task...\n");
				monitor = 1;
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", "Monitoring on");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
				 }
		else if ( strcmp (c, "halt") == 0){

				info("Stop monitoring task...\n");
				monitor = 0;

				oled_clear(zedboard_oled_params_0.base_address);

				sprintf(&menuBuf[0], "%s", "Stop Mon");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			}
		else if ( strcmp (c, "stremon") == 0){

			info("Enable stream break monitoring...\n");
			enable_media_channel_monitoring(eth_to_audio_base_0);
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "Stream Mon on");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
			 }
		else if ( strcmp (c, "strdmon") == 0){

			info("Disable stream break monitoring...\n");
			disable_media_channel_monitoring(eth_to_audio_base_0);
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "Stream Mon off");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
			 }

		else if(strcmp (c,"mockf") == 0)
					{

			info( "Enable sync mock udp tx...\n");
					time_sync_tx_en(full_udp_stack_ip_base_0);
					usleep(1000);
					time_sync_mock_en(time_sync_base_0);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "-MockF-");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			  SET_STATUS("Mock Enabled");
		}

		else if(strcmp (c,"log_tpx") == 0) {
			unsigned char desc_str[256]={0};
			memset(desc_str, 0, sizeof(desc_str));
		      		  //SET_STATUS("Enter Dest IP Address (xxx.xxx.xxx.xxx format): ");
		          	  scanf("%s",log_str);
		          	  snprintf(desc_str, sizeof(desc_str), "TPX_LOG::%s",log_str);
		          	write_log_point(desc_str);

		      	}
      else if (strcmp (c, "help") == 0) {
        printf("|==================+================================================|\n");
        printf("|Command           |Description                                     |\n");
        printf("|==================+================================================|\n");
        printf("|vol <gain value>  |volume gain for global level					 |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|vll <gain value>  |volume gain for left channel of loopback stream |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|vlr <gain value>  |volume gain for right channel of loopback stream|\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|vnl <gain value>  |volume gain for left channel of network stream  |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|vnr <gain value>  |volume gain for right channel of network stream |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    lfhe/lfhd     |High pass enable/Disable for loopback           |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    lfbe/lfbd     |Band pass enable/Disable for loopback           |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    lfle/lfld     |Low pass enable/Disable for loopback            |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    nfhe/nfhd     |High pass enable/Disable for network            |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    nfbe/nfbd     |Band pass enable/Disable for network            |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    nfle/nfld     |Low pass enable/Disable for network             |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    nstats        |Byte counts and error counts for the network    |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    astatus       |Hardware ADC audio FIFO Status                  |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    dstatus       |Hardware DAC audio FIFO Status                  |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    areset        |Hardware ADC audio FIFO Reset                   |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    reset        |Hardware DAC audio FIFO Reset                   |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    freset        | Resets the udp core and the audio fifos.       |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    preset   		| Resets the packet sequencer  					 |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    creset 		| Resets just the udp core.						 |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    rxrsync 		| Re-syncronise the receive audio chain       	 |\n");
        printf("|------------------+------------------------------------------------|\n");
		printf("|    strstart      |Start streaming                                 |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strstop       |Stop streaming                                  |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strseleth     |Play ETH stream                                 |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strselarm     |Play ARM stream                                 |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strdip <ip>   |Streaming destination IP                        |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strlip <ip>   |Streaming local IP                              |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strport <port>|Streaming port                                  |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strgip <ip>   |Streaming gateway IP                            |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strmask <ip>  |Streaming netmask IP                            |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strmac <mac>  |Streaming MAC Address                           |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strnsp <sp>   |Streaming net speed                             |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    strplen <len> |Streaming payload packet length                 |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|  strporder <ord> |Set streaming packet sequencer order      |\n");
        printf("|------------------+------------------------------------------------|\n");
		printf("|    getdip       |Read streaming destination IP                   |\n");
		printf("|------------------+------------------------------------------------|\n");
		printf("|    getlip       |Read streaming local IP                         |\n");
		printf("|------------------+------------------------------------------------|\n");
		printf("|    getport      |Read streaming port                             |\n");
		printf("|------------------+------------------------------------------------|\n");
		printf("|    getgip       |Read streaming gateway IP                       |\n");
		printf("|------------------+------------------------------------------------|\n");
		printf("|    getmask      |Read streaming netmask IP                       |\n");
		printf("|------------------+------------------------------------------------|\n");
		printf("|    getmac       |Read streaming MAC Address                      |\n");
		printf("|------------------+------------------------------------------------|\n");
		printf("|    getnsp       |Read streaming net speed                        |\n");
		printf("|------------------+------------------------------------------------|\n");
		printf("|    getplen      |Read streaming payload packet length            |\n");
		printf("|------------------+------------------------------------------------|\n");
		printf("|    getblen      |Read streaming rx sample buffer length          |\n");
		printf("|------------------+------------------------------------------------|\n");
	    printf("|    getporder    |Read streaming packet sequencer order            |\n");
        printf("|------------------+------------------------------------------------|\n");
        printf("|    exit     		|Exit the application				             |\n");
        printf("|==================+================================================|\n");
        getchar ();
        getchar ();
      }else if ( strcmp (c, "exit") == 0){
    	  gain = 0;
    	  globalVol = gain;

		  set_volume (volume_control_base_0, params.vl_lpbk*gain, CHANNEL_ID_L);
		  set_volume (volume_control_base_0, params.vr_lpbk*gain, CHANNEL_ID_R);

		  set_volume (volume_control_base_1, params.vl_net*gain, CHANNEL_ID_L);
		  set_volume (volume_control_base_1, params.vr_net*gain, CHANNEL_ID_R);
		  update_leds();

		  oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s", "  BYE   ");
		oled_print_message(&menuBuf[0], 0, zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[1], "%s-%s-", "Cantavi", "S");
		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
		bridge_exit ();
        SET_STATUS("Shutting down audio.\nClosing app\n");
        exit(0);
      }
      else {
        SET_STATUS("Invalid Command\n");
        info("Invalid Command\n");
        oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s", "  INVALID  ");
		oled_print_message(&menuBuf[0], 0, zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s", "  Command  ");
		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

        ui_draw();
      }
  }
  return NULL;
}

/**
 * =======================================================
 * draw the user interface
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */
void ui_vol_draw () {
    system ("clear");
    printf("|============+============+============|\n");
    printf("| Parameters +  Loopback  +   Network  |\n");
    printf("|============+============+============|\n");
    printf("|  Volume_G  +    %4d    +    %4d    |\n", params.v_global, params.v_global);
    printf("|------------+------------+------------|\n");
    printf("|  Volume_L  +    %4d    +    %4d    |\n", params.vl_lpbk, params.vl_net);
    printf("|------------+------------+------------|\n");
    printf("|  Volume_R  +    %4d    +    %4d    |\n", params.vr_lpbk, params.vr_net);
    printf("|------------+------------+------------|\n");
    printf("|  FILTER_B  +    %-4s    +    %-4s    |\n", (params.filter_b_lpbk ? "On":"Off"), (params.filter_b_net ? "On":"Off"));
    printf("|------------+------------+------------|\n");
    printf("|  FILTER_L  +    %-4s    +    %-4s    |\n",(params.filter_l_lpbk ? "On":"Off"), (params.filter_l_net ? "On":"Off"));
    printf("|------------+------------+------------|\n");
    printf("|  FILTER_H  +    %-4s    +    %-4s    |\n", (params.filter_h_lpbk ? "On":"Off"), (params.filter_h_net ? "On":"Off"));
    printf("|============+============+============|\n");
    printf("\n%s\n", params.status);

}

/**
 * =======================================================
 * draw the user interface
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */
void ui_draw () {
    //system ("clear");//causes minicom to clear
    info( "\n%s\n", params.status);
    info( "\n>:");

}


int hw_nodes_init(){
	eth_to_audio_params_0 = map_device (ETH_TO_AUDIO_DEVICE_0);
		    if (eth_to_audio_params_0.base_address == NULL) {
		    	error( "ui_init : eth_to_audio_params_0");
		       return -1;
		    }else{
		  	  eth_to_audio_base_0 = eth_to_audio_params_0.base_address;
		    }

		filter_control_params_0 = map_device(FILTER_DEVICE_0);
		  if (filter_control_params_0.base_address == NULL) {
			  error("ui_init : filter_control_params_0");
			 return -1;
		  }else{
			  filter_control_base_0 = filter_control_params_0.base_address;
		  }

		  volume_control_params_0 = map_device(VOLUME_DEVICE_0);
			if (volume_control_params_0.base_address == NULL) {
				error("ui_init : volume_control_params_0");
			   return -1;
			}else{
			  volume_control_base_0 = volume_control_params_0.base_address;
			}

		  filter_control_params_1 = map_device(FILTER_DEVICE_1);
		  if (filter_control_params_1.base_address == NULL) {
			  error("ui_init : filter_control_params_1");
			 return -1;
		  }else{
			  filter_control_base_1 = filter_control_params_1.base_address;
		  }


		  volume_control_params_1 = map_device(VOLUME_DEVICE_1);
		    if (volume_control_params_1.base_address == NULL) {
		    	error("ui_init : volume_control_params_1");
		       return -1;
		    }else{
		  	  volume_control_base_1 = volume_control_params_1.base_address;
		    }

		zedboard_oled_params_0 = map_device (ZEDBOARDOLED_0);

	  if (zedboard_oled_params_0.base_address == NULL) {
		  error("ui_init : zedboard_oled_params_0");
	     return -1;
	  }else{
		  zedboard_oled_base_0 = zedboard_oled_params_0.base_address;
	  }

	  pmod_controller_params_0 = map_device(PMOD_CONTROLLER_0);
	  if (pmod_controller_params_0.base_address == NULL) {
		  error("ui_init : pmod_controller_params_0");
	     return -1;
	  }else{
		  pmod_controller_base_0 = pmod_controller_params_0.base_address;
	  }


	   audio_to_eth_params_0 = map_device (AUDIO_TO_ETH_DEVICE_0);
	      if (audio_to_eth_params_0.base_address == NULL) {
	    	  error("ui_init : audio_to_eth_params_0");
	         return -1;
	      }else{
	      	audio_to_eth_base_0 = audio_to_eth_params_0.base_address;
	      }

	      hyb_switch_ip_params_0 = map_device (HYB_SWITCH_IP_0);
	      		if (hyb_switch_ip_params_0.base_address == NULL) {
	      			error("ui_init : hyb_switch_ip_params_0");
	      		   return -1;
	      		}else{
	      			hyb_switch_ip_base_0 = hyb_switch_ip_params_0.base_address;
	      		}

	      full_udp_stack_ip_params_0 = map_device (FULL_UDP_STACK_IP_0);
			if (full_udp_stack_ip_params_0.base_address == NULL) {
				error("ui_init : full_udp_stack_ip_params_0");
			   return -1;
			}else{
				full_udp_stack_ip_base_0 = full_udp_stack_ip_params_0.base_address;
			}


	      eth_packet_sequencer_params_0 = map_device (ETH_PLC_SEQ_0);
	            if (eth_packet_sequencer_params_0.base_address == NULL) {
	            	error("ui_init : eth_plc_packet_sequencer_params_0");
	               return -1;
	            }else{
	            	eth_packet_sequencer_base_0 = eth_packet_sequencer_params_0.base_address;
	            }

	//            packet_time_enforcer_params_0 = map_device (PACKET_TIME_ENFORCER_0);
	//            if (eth_packet_sequencer_params_0.base_address == NULL) {
	//               perror ("ui_init : packet_time_enforcer_params_0");
	//               return -1;
	//            }else{
	//            	packet_time_enforcer_base_0 = packet_time_enforcer_params_0.base_address;
	//            }



				adau1761_params_0 = map_device (ADAU1761_CODEC_0);
				if (adau1761_params_0.base_address == NULL) {
					error("ui_init : adau1761_params_0 error");
				   return -1;
				}else{
					adau1761_base_0 = adau1761_params_0.base_address;
				}

				time_sync_params_0 = map_device (TIME_SYNC_0);
				if (time_sync_params_0.base_address == NULL) {
					error("ui_init : time_sync_params_0 error");
				   return -1;
				}else{
					time_sync_base_0 = time_sync_params_0.base_address;
				}
return 0;
}







int bit_ip2str(pj_in_addr * addr, char * ip_str){
//	struct sockaddr_in sa;
//	char str[INET_ADDRSTRLEN];

	// store this IP address in sa:
//	inet_pton(AF_INET, "192.0.2.33", &(sa.sin_addr);

	// now get it back and print it
	inet_ntop(AF_INET, addr, ip_str, INET_ADDRSTRLEN);

	info( "%s\n", ip_str); // prints "192.0.2.33"
}


int str2bit_ip(pj_in_addr * addr, char * ip_str){
//	struct sockaddr_in sa;
//	char str[INET_ADDRSTRLEN];

	// store this IP address in sa:
	inet_pton(AF_INET, ip_str, addr);

	// now get it back and print it
//	inet_ntop(AF_INET, addr, ip_str, INET_ADDRSTRLEN);

//	info( "%s\n", ip_str); // prints "192.0.2.33"
}



void bridge_run_command(char * cmd){
	char *c;
	  unsigned buf ;
	  unsigned long tmp ;
	  unsigned int gain = 0;
	  unsigned int dest_ip = 0;
	  unsigned int source_ip = 0;
	  unsigned int gw_ip = 0;
	  unsigned int mac = 0;
	  unsigned int dest_port = 0;
	  unsigned int sw_port = 0;
	  unsigned char ip[128]={0};
	  unsigned char log_str[128]={0};
	  unsigned char ipAddress[4];
	  unsigned char macAddress[6];
//	scanf ("%s",c);
	  const char token[2] = " ";//must be a null terminated string

	  SET_STATUS("Command success..");
	   /* get the first token */
	   c = strtok(cmd, token);


	    if(strcmp (c,"vol") == 0) {
	    		SET_STATUS("Entered global gain\n");
	            ui_draw();
//	            scanf ("%d",&gain);
	            gain = atoi(strtok(NULL, token));
	            params.v_global = gain;
	            globalVol = gain;

	            set_volume (volume_control_base_0, params.vl_lpbk*gain, CHANNEL_ID_L);
	            set_volume (volume_control_base_0, params.vr_lpbk*gain, CHANNEL_ID_R);

	            set_volume (volume_control_base_1, params.vl_net*gain, CHANNEL_ID_L);
	            set_volume (volume_control_base_1, params.vr_net*gain, CHANNEL_ID_R);

	            oled_clear(zedboard_oled_params_0.base_address);
	            sprintf(&menuBuf[0], "%s%3d", "VOL_GLOBAL", gain);
	            oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

	            update_leds();
	            ui_vol_draw();
	      }else if(strcmp (c,"vll") == 0) {
	        SET_STATUS("Entered left gain\n");
	        ui_vol_draw();
//	        scanf ("%d",&gain);
	        gain = atoi(strtok(NULL, token));
	        set_volume (volume_control_base_0, params.v_global*gain, CHANNEL_ID_L);
	        params.vl_lpbk = gain;
	        setting[1] = params.vl_lpbk;
	        oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%3d", menuitem[0], setting[1]);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

	        ui_vol_draw();
	      }
	      else if(strcmp (c,"vlr") == 0) {
	        SET_STATUS("Entered right gain\n");
	        ui_vol_draw();
//	        scanf ("%d",&gain);
	        gain = atoi(strtok(NULL, token));
	        set_volume (volume_control_base_0, params.v_global*gain, CHANNEL_ID_R);
	        params.vr_lpbk = gain;
	        setting[0] = gain;

	        oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%3d", menuitem[1], setting[0]);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

	        ui_vol_draw();
	      }
	      else if(strcmp (c,"netvoll") == 0) {
	        SET_STATUS("Entered left gain\n");
	        ui_vol_draw();
//	        scanf ("%d",&gain);
	        gain = atoi(strtok(NULL, token));
	        set_volume (volume_control_base_1, params.v_global*gain, CHANNEL_ID_L);
	        params.vl_net = gain;
	        setting[3] = gain;

	        oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%3d", menuitem[2], setting[3]);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

	        ui_vol_draw();
	      }
	      else if(strcmp (c,"netvolr") == 0) {
	        SET_STATUS("Entered right gain\n");
	        ui_vol_draw();
//	        scanf ("%d",&gain);
	        gain = atoi(strtok(NULL, token));
	        set_volume (volume_control_base_1, params.v_global*gain, CHANNEL_ID_R);
	        params.vr_net = gain;
	        setting[2] = gain;
	        oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%3d", menuitem[3], setting[2]);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	        ui_vol_draw();
	      }
	      else if ( strcmp (c, "lfhe") == 0){
	          set_filter_type (filter_control_base_0, FILTER_HIGH_PASS, 1);
	          params.filter_h_lpbk = 1;
	          setting[6] = 1;
	          oled_clear(zedboard_oled_params_0.base_address);
	          sprintf(&menuBuf[0], "%s%3d", menuitem[6], setting[5]);
	          oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "lfhd") == 0){
	          set_filter_type (filter_control_base_0, FILTER_HIGH_PASS, 0);
	          params.filter_h_lpbk = 0;
	          setting[6] = 0;
	          oled_clear(zedboard_oled_params_0.base_address);
	          		sprintf(&menuBuf[0], "%s%3d", menuitem[6], setting[6]);
	          		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "lfbe") == 0){
	          set_filter_type (filter_control_base_0, FILTER_BAND_PASS, 1);
	          params.filter_b_lpbk = 1;
	          setting[5] = 1;
	          oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[0], "%s%3d", menuitem[5], setting[5]);
	                    oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "lfbd") == 0){
	          set_filter_type (filter_control_base_0, FILTER_BAND_PASS, 0);
	          params.filter_b_lpbk = 0;
	          setting[5] = 0;
	          oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[0], "%s%3d", menuitem[5], setting[5]);
	                    oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "lfle") == 0){
	          set_filter_type (filter_control_base_0, FILTER_LOW_PASS, 1);
	          params.filter_l_lpbk = 1;
	          setting[4] = 1;
	          oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[0], "%s%3d", menuitem[4], setting[4]);
	                    oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "lfld") == 0){
	          set_filter_type (filter_control_base_0, FILTER_LOW_PASS, 0);
	          params.filter_l_lpbk = 0;
	          setting[4] = 0;
	          oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[0], "%s%3d", menuitem[4], setting[4]);
	                    oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "nfhe") == 0){
	          set_filter_type (filter_control_base_1, FILTER_HIGH_PASS, 1);
	          params.filter_h_net = 1;
	          setting[9] = 1;
	          oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[1], "%s%3d", menuitem[9], setting[9]);
	                    oled_print_message(&menuBuf[1], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "nfhd") == 0){
	          set_filter_type (filter_control_base_1, FILTER_HIGH_PASS, 0);
	          params.filter_h_net = 0;
	          setting[9] = 0;
	          oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[1], "%s%3d", menuitem[9], setting[9]);
	                    oled_print_message(&menuBuf[1], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "nfbe") == 0){
	          set_filter_type (filter_control_base_1, FILTER_BAND_PASS, 1);
	          params.filter_b_net = 1;
	          setting[8] = 1;
	          oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[1], "%s%3d", menuitem[8], setting[8]);
	                    oled_print_message(&menuBuf[1], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "nfbd") == 0){
	          set_filter_type (filter_control_base_1, FILTER_BAND_PASS, 0);
	          params.filter_b_net = 0;
	          setting[8] = 0;
	          oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[1], "%s%3d", menuitem[8], setting[8]);
	                    oled_print_message(&menuBuf[1], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "nfle") == 0){
	          set_filter_type (filter_control_base_1, FILTER_LOW_PASS, 1);
	          params.filter_l_net = 1;
	          setting[7] = 1;
	          oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[1], "%s%3d", menuitem[7], setting[7]);
	                    oled_print_message(&menuBuf[1], 1, zedboard_oled_params_0.base_address);
	          ui_draw();
	      }
	      else if ( strcmp (c, "nfld") == 0){
	          set_filter_type (filter_control_base_1, FILTER_LOW_PASS, 0);
	          params.filter_l_net = 0;
	          setting[7] = 0;
	          ui_draw();
	      }
	      else if ( strcmp (c, "rate") == 0){

	          	  scanf ("%d",&rate);
	          	if(rate == 96){
				write_adau1761(0x40F8, 0x06, 1);//96kHz
				write_adau1761(0x4017, 0x06, 1); //96KHz
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "SampRate=%d kHz", rate);
				info( "The new sample rate is %d kHz", rate);
				orate = rate;
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }else if(rate == 48){
				write_adau1761(0x40F8, 0x00, 1);//48kHz
				write_adau1761(0x4017, 0x00, 1);//48kHz
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "SampRate=%d kHz", rate);
				orate = rate;
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }else{
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "Invalid sample rate");
				  info( "The invalid sample rate::%d kHz, old sample rate is %d kHz", rate,orate);
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
			  }


	            }
	      else if ( strcmp (c, "nstats") == 0){

				info( "total_bytes_send_to_dma count is::%d\n",total_bytes_send_to_dma);
				info( "total_bytes_send_to_net count is::%d\n",total_bytes_send_to_net);
				info( "total_bytes_read_from_net count is::%d\n",total_bytes_read_from_net);
				info( "audio_to_eth_reg_w_error count is::%d\n",audio_to_eth_reg_w_error_count);
	//			info( "axi_to_net_reg_w_error count is::%d\n",axi_to_net_reg_w_error_count);
				info( "axi_to_net_mq_r_error count is::%d\n",axi_to_net_mq_r_error_count);
				info( "net_to_axi_mq_w_error count is::%d\n",net_to_axi_mq_w_error_count);
				info( "net_to_axi_mq_r_error count is::%d\n",net_to_axi_mq_r_error_count);
				info( "net_read_error count is::%d\n",net_read_error_count);
				info( "net_send_error count is::%d\n",net_send_error_count);
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s::%3d", menuitem[10], total_bytes_send_to_net);
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();

	      }
	      else if ( strcmp (c, "astatus") == 0){
	    	  int buffer = read_fifo_status (audio_to_eth_base_0, ADC_FIFO_ID);
	    	  if(buffer&0x04){
	    	      	//LeftFIFOEmpty
	    		  info( "ADC left audio fifo Empty :: val::0x%02X\n",buffer);
	    	  }
	    	  if(buffer&0x08){
	    	      	//RightFIFOEmpty
	    		  info( "ADC right audio fifo Empty :: val::0X%02X\n",buffer);
	    	      }
	    	  if(buffer&0x10){
	    	      	//LeftFIFOFull
	    		  info( "ADC left audio fifo Full :: val::0x%02X\n",buffer);
	    	      }
	    	  if(buffer&0x20){
	    	      	//RightFIFOFull
	    		  info( "ADC right audio fifo Full :: val::0x%02X\n",buffer);
	    	      }
	    	  if(buffer&0x3C == 0){
	    		  info( "All ADC audio fifo Flags clear :: val::0X%02X\n",buffer);
	    	  }
	    	  info( "All ADC audio fifo Flags:: val::0X%02X\n",buffer);
	    	  ui_draw();
	      }
	      else if ( strcmp (c, "dstatus") == 0){
	    	  int buffer = read_fifo_status (eth_to_audio_base_0, DAC_FIFO_ID);
	    	  if(buffer&0x04){
	    	      	      	//LeftFIFOEmpty
				  info( "DAC left audio fifo Empty :: val::0x%02X\n",buffer);
			  }
			  if(buffer&0x08){
					//RightFIFOEmpty
				  info( "DAC right audio fifo Empty :: val::0x%02X\n",buffer);
				  }
			  if(buffer&0x10){
					//LeftFIFOFull
				  info( "DAC left audio fifo Full :: val::0x%02X\n",buffer);
				  }
			  if(buffer&0x20){
					//RightFIFOFull
				  info( "DAC right audio fifo Full :: val::0x%02X\n",buffer);
				  }
			  if(buffer&0x3C == 0){
				  info( "All DAC audio fifo Flags clear :: val::0x%02X\n",buffer);
			  }
			  info( "All DAC audio fifo Flags :: val::0x%02X\n",buffer);
			  ui_draw();
	      }
	      else if ( strcmp (c, "areset") == 0){
	    	  reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
	    	  info( "ADC audio FIFOs Reset\n");
	    	  oled_clear(zedboard_oled_params_0.base_address);
	    	  sprintf(&menuBuf[0], "%s", "ADC FIFOs Rst");
	    	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	    	  ui_draw();
	      }

	      else if ( strcmp (c, "dreset") == 0){
	      //          	  time_sync_tx_off(full_udp_stack_ip_base_0);
	      //          	  time_sync_off(time_sync_base_0);
	      //          	  set_sync_rst(time_sync_base_0);
	      //          	  sleep(1);
	      //      			time_sync_en(time_sync_base_0);
	      //      			usleep(100);
	      //      			sleep(2);
	      //      			time_sync_tx_en(full_udp_stack_ip_base_0);
	      //      		  printf("Enable time sync...\n");

	                	  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
	                	  printf("DAC audio FIFOs Reset\n>");
	                	  oled_clear(zedboard_oled_params_0.base_address);
	                	  sprintf(&menuBuf[0], "%s", "DAC FIFOs Rst");
	                	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                	  ui_draw();
	                  }
	      else if ( strcmp (c, "reset") == 0){

	    	  set_sync_rst(time_sync_base_0);

	          	  printf("Reset time sync...\n");
	          	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	          	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x80000000);
				 sleep(1);
				write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0x7FFFFFFF);
	      			printf("Stream core reset status was:0x%X\n>",buf);

	      			reset_pkt_seq(eth_packet_sequencer_base_0);

	      		printf("PLC Pkt seq Reset\n>");

	      		time_sync_tx_en(full_udp_stack_ip_base_0);
	      		usleep(100);
	      		time_sync_en(time_sync_base_0);

	      		printf("Enable time sync...\n");
	      		///reset_pkt_time_enf(packet_time_enforcer_base_0);


	      		//printf("Pkt timing unit reset\n>");
	      			  reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
	      			  printf("ADC audio FIFOs Reset\n");
	      			  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
	      			  printf("DAC audio FIFOs Reset\n>");


	      			 oled_clear(zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "%s", "Full Stream Rst");
	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			ui_draw();
	            }

	      else if ( strcmp (c, "preset") == 0){
	    	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
	    	  reset_pkt_seq(eth_packet_sequencer_base_0);

	          	  info( "PLC Pkt seq Reset\n>");
	          	  oled_clear(zedboard_oled_params_0.base_address);
	          	  sprintf(&menuBuf[0], "%s", "PKT SEQ Rst");
	          	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          	  ui_draw();
	            }

	      else if ( strcmp (c, "pbtreset") == 0){
	          	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
	    	  	  //reset_pkt_time_enf(packet_time_enforcer_base_0);


				  info( "Pkt timing unit reset\n>");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "PKT TU Rst");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
			  }
	      else if ( strcmp (c, "pbtrreset") == 0){
	                	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
	    	  	  	  reset_pkt_time_enf_rx(packet_time_enforcer_base_0);

	      			  info( "Pkt timing unit reset rx\n>");
	      			  oled_clear(zedboard_oled_params_0.base_address);
	      			  sprintf(&menuBuf[0], "%s", "PKT TU RX Rst");
	      			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			  ui_draw();
	      		  }
	      else if ( strcmp (c, "pbtoff") == 0){
	                	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
	    	  	  	  pkt_time_enf_disable(packet_time_enforcer_base_0);

	      			  info( "Pkt timing unit disable\n>");
	      			  oled_clear(zedboard_oled_params_0.base_address);
	      			  sprintf(&menuBuf[0], "%s", "PKT TU OFF");
	      			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			  ui_draw();
	      		  }

	      else if ( strcmp (c, "pbton") == 0){
	                      	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
	          	  	  	  pkt_time_enf_enable(packet_time_enforcer_base_0);

	            			  info( "Pkt timing unit enable\n>");
	            			  oled_clear(zedboard_oled_params_0.base_address);
	            			  sprintf(&menuBuf[0], "%s", "PKT TU ON");
	            			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	            			  ui_draw();
	            		  }


	      else if ( strcmp (c, "pseqoff") == 0){
	          	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
	          	  disble_pkt_seq(eth_packet_sequencer_base_0);

				  info( "Pkt seq Disabled\n>");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "PKT SEQ OFF");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
			  }

	      else if ( strcmp (c, "pseqon") == 0){
	                	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
	                	  enable_pkt_seq(eth_packet_sequencer_base_0);

	      			  info( "Pkt seq Enabled\n>");
	      			  oled_clear(zedboard_oled_params_0.base_address);
	      			  sprintf(&menuBuf[0], "%s", "PKT SEQ ON");
	      			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			  ui_draw();
	      		  }


	      else if ( strcmp (c, "creset") == 0){
	                	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	                	  write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x80000000);
								 sleep(1);
								write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0x7FFFFFFF);
								info( "Stream core reset status was:0x%X\n>",buf);

	                	      	oled_clear(zedboard_oled_params_0.base_address);
	                	      	sprintf(&menuBuf[0], "%s", "Stream Core Rst");
	                	      	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                	      	ui_draw();
	                  }
	      else if ( strcmp (c, "sreset") == 0){
	                            	  unsigned buf = read_eth_param (hyb_switch_ip_base_0, ETH_CONTROL_REG_ID);
	                            	write_eth_param(hyb_switch_ip_base_0, ETH_CONTROL_ID, buf|0x80000000);
	                            				 sleep(1);
	                            				write_eth_param(hyb_switch_ip_base_0, ETH_CONTROL_ID, buf&0x7FFFFFFF);
	                            	      	printf("Switch core reset status was:0x%X\n>",buf);
	                            	      	oled_clear(zedboard_oled_params_0.base_address);
	                            	      	sprintf(&menuBuf[0], "%s", "Switch Core Rst");
	                            	      	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                            	      	ui_draw();
	                              }
	            else if ( strcmp (c, "freset") == 0){

	          	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	          	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x80000000);
				 sleep(1);
				write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0x7FFFFFFF);
				info( "Stream core reset status was:0x%X\n>",buf);

	      			reset_pkt_seq(eth_packet_sequencer_base_0);

					info( "PLC Pkt seq Reset\n>");
					///reset_pkt_time_enf(packet_time_enforcer_base_0);


					//info( "Pkt timing unit reset\n>");
	               	  reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
	               	  info( "ADC audio FIFOs Reset\n");
	               	  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
	               	  info( "DAC audio FIFOs Reset\n>");


	               	 oled_clear(zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "%s", "Full Stream Rst");
	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			ui_draw();
	                 }

	            else if ( strcmp (c, "rxrsync") == 0){

	            	unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	            	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x80000000);
					 sleep(1);
					write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0x7FFFFFFF);
					info( "Stream core reset status was:0x%X\n>",buf);

					reset_pkt_seq(eth_packet_sequencer_base_0);

					info( "Pkt seq Reset\n>");
					//reset_pkt_time_enf(packet_time_enforcer_base_0);


					//info( "Pkt timing unit reset\n>");
					  reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
					  info( "ADC audio FIFOs Reset\n");
					  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
					  info( "DAC audio FIFOs Reset\n>");
	                     	 oled_clear(zedboard_oled_params_0.base_address);
	            			sprintf(&menuBuf[0], "%s", "RX re sync");
	            			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	            			ui_draw();
	                       }

	      else if ( strcmp (c, "strteston") == 0){
				  set_test_mode_on(audio_to_eth_base_0);//wValue(7);
				  info( "Put Audio to Ethernet IP in test mode\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "Test Mode: ON");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }
	      else if ( strcmp (c, "strtestm1") == 0){
	      			  set_test_mode(audio_to_eth_base_0, 0);//wValue(10 down to 9);
	      			  info( "Put Audio to Ethernet IP in test ramp mode\n");
	      			oled_clear(zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "%s", "LR Ramp");
	      		    oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	      			ui_draw();
	      		  }
	      else if ( strcmp (c, "strtestm2") == 0){
				  set_test_mode(audio_to_eth_base_0, 1);//wValue(10 down to 9);
				  info( "Put Audio to Ethernet IP in test fixed LR=0x55 mode\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "LR 0x555555");
				  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
				  ui_draw();
				ui_draw();
			  }
	      else if ( strcmp (c, "strtestm3") == 0){
				  set_test_mode(audio_to_eth_base_0, 2);//wValue(10 down to 9);
				  info( "Put Audio to Ethernet IP in test fixed L=0x00 R=0xFF mode\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "L=0x00 R=0xFF");
				 oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
				 ui_draw();
				ui_draw();
			  }
	      else if ( strcmp (c, "strtestm4") == 0){
				  set_test_mode(audio_to_eth_base_0, 3);//wValue(10 down to 9);
				  info( "Put Audio to Ethernet IP in test bit flip mode\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "LR FLIP");
				  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
				  ui_draw();
			  }
	      else if ( strcmp (c, "strtestm5") == 0){
	     			  set_test_mode(audio_to_eth_base_0, 4);//wValue(10 down to 9);
	     			  info( "Put Audio to Ethernet IP in test sine wave mode\n");
	     			  oled_clear(zedboard_oled_params_0.base_address);
	     			  sprintf(&menuBuf[0], "%s", "LR SQW");
	     			  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	     			  ui_draw();
	     		  }
	      else if ( strcmp (c, "strtestoff") == 0){
				  set_test_mode_off(audio_to_eth_base_0);//wValue(7);
				  info( "Put Audio to Ethernet IP in test mode\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "Test Mode: OFF");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

				ui_draw();
				}

	    //------------------------------------------------------------------------------------------------------
	      else if ( strcmp (c, "getskip") == 0){
	                	  //reset_pkt_seq(eth_to_audio_base_0, DAC_FIFO_ ID,0x03);//LSB is left, MSB is Right
	                	  int d = get_pkt_seq_skiped(eth_packet_sequencer_base_0);

	                      	  printf("Pkt seq get skipped pakets:%d\n>",d);
	                      	  oled_clear(zedboard_oled_params_0.base_address);
	                      	  sprintf(&menuBuf[0], "%s:%d", "PKT SEQ SKP", d);
	                      	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                      	  ui_draw();
	                        }

	            else if ( strcmp (c, "setdrl") == 0){//done
	                      	  	  int allw = 12;
	                      	  	  scanf ("%d",&allw);
	                      	  	set_drop_allowance(eth_to_audio_base_0, allw);//wValue(7);
	                        		  printf("Ethernet to Audio drop allowance set\n");
	                        		  oled_clear(zedboard_oled_params_0.base_address);
	                        		  sprintf(&menuBuf[0], "%s:%d", "Eth2Aud DRL", allw);
	                        		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                        		  ui_draw();
	                        	  }
	            else if ( strcmp (c, "setesl") == 0){//done
	          	  	  int allw = 12;
	          	  	  scanf ("%d",&allw);
	                	  set_rx_esl(eth_to_audio_base_0, allw);//wValue(7);
	            		  printf("Ethernet to Audio even packet wait allowance set\n");
	            		  oled_clear(zedboard_oled_params_0.base_address);
	            		  sprintf(&menuBuf[0], "%s:%d", "Eth2Aud EAL", allw);
	            		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	            		  ui_draw();
	            	  }

	            else if ( strcmp (c, "setosl") == 0){//done
	                	  	  int allw = 30;
	                	  	  scanf ("%d",&allw);
	                      	  set_rx_osl(eth_to_audio_base_0, allw);//wValue(7);
	                  		  printf("Ethernet to Audio odd packet wait allowance set\n");
	                  		  oled_clear(zedboard_oled_params_0.base_address);
	                  		  sprintf(&menuBuf[0], "%s:%d", "Eth2Aud OAL", allw);
	                  		  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                  		  ui_draw();
	                  	  }

	      else if ( strcmp (c, "sethdrstrip") == 0){//done
	    	  set_rx_hdr_strip(eth_to_audio_base_0);//wValue(7);
			  info( "Ethernet to Audio IP header strip on\n");
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "HDR Strip: ON");
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
		  }
	      else if ( strcmp (c, "clearhdrstrip") == 0){//done
	          	clear_rx_hdr_strip(eth_to_audio_base_0);//wValue(7);
				info( "Ethernet to Audio IP header strip off\n");
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", "HDR Strip: OFF");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }


	      else if ( strcmp (c, "strxteston") == 0){
	      			  set_xtest_mode_on(eth_to_audio_base_0);//wValue(7);
	      			  info( "Put Ethernet to Audio IP in test mode\n");
	      			  oled_clear(zedboard_oled_params_0.base_address);
	      			  sprintf(&menuBuf[0], "%s", "xTest Mode: ON");
	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			ui_draw();
	      		  }
	            else if ( strcmp (c, "strxtestm1") == 0){
	            			  set_xtest_mode(eth_to_audio_base_0, 0);//wValue(10 down to 9);
	            			  info( "Put Ethernet to Audio IP in test ramp mode\n");
	            			oled_clear(zedboard_oled_params_0.base_address);
	            			sprintf(&menuBuf[0], "%s", "LR Ramp");
	            		    oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	            			ui_draw();
	            		  }
	            else if ( strcmp (c, "strxtestm2") == 0){
	      			  set_xtest_mode(eth_to_audio_base_0, 1);//wValue(10 down to 9);
	      			  info( "Put Ethernet to Audio IP in test fixed LR=0x55 mode\n");
	      			  oled_clear(zedboard_oled_params_0.base_address);
	      			  sprintf(&menuBuf[0], "%s", "LR 0x555555");
	      			  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	      			  ui_draw();
	      			ui_draw();
	      		  }
	            else if ( strcmp (c, "strxtestm3") == 0){
	      			  set_xtest_mode(eth_to_audio_base_0, 2);//wValue(10 down to 9);
	      			  info( "Put Ethernet to Audio IP in test fixed L=0x00 R=0xFF mode\n");
	      			  oled_clear(zedboard_oled_params_0.base_address);
	      			  sprintf(&menuBuf[0], "%s", "L=0x00 R=0xFF");
	      			 oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	      			 ui_draw();
	      			ui_draw();
	      		  }
	            else if ( strcmp (c, "strxtestm4") == 0){
	      			  set_xtest_mode(eth_to_audio_base_0, 3);//wValue(10 down to 9);
	      			  info( "Put Ethernet to Audio IP in test bit flip mode\n");
	      			  oled_clear(zedboard_oled_params_0.base_address);
	      			  sprintf(&menuBuf[0], "%s", "LR FLIP");
	      			  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	      			  ui_draw();
	      		  }
	            else if ( strcmp (c, "strxtestm5") == 0){
	           			  set_xtest_mode(eth_to_audio_base_0, 4);//wValue(10 down to 9);
	           			  info( "Put Ethernet to Audio IP in test square wave mode\n");
	           			  oled_clear(zedboard_oled_params_0.base_address);
	           			  sprintf(&menuBuf[0], "%s", "LR SQR");
	           			  oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	           			  ui_draw();
	           		  }
	            else if ( strcmp (c, "strxtestoff") == 0){
	      			  set_xtest_mode_off(eth_to_audio_base_0);//wValue(7);
	      			  info( "Put Ethernet to Audio IP in test mode\n");
	      			  oled_clear(zedboard_oled_params_0.base_address);
	      			  sprintf(&menuBuf[0], "%s", "xTest Mode: OFF");
	      			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

	      			ui_draw();
	      			}
	            else if ( strcmp (c, "sethdrlen") == 0){
//	            	scanf ("%d",&tmp);
	            	tmp = atoi(strtok(NULL, token));
				  set_tx_hdr_length(eth_to_audio_base_0, tmp);//wValue(7);
				  info( "Set hdr length...\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s%d", "HDR LEN:",tmp);
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

				ui_draw();
				}
	    //------------------------------------------------------------------------------------------------------
	            else if ( strcmp (c, "sync") == 0){

	            	time_sync_tx_en(full_udp_stack_ip_base_0);
	            	usleep(100);
	            	time_sync_en(time_sync_base_0);
				  info( "Enable time sync...\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "SYNC: ON");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }

	            else if ( strcmp (c, "syncoff") == 0){

					time_sync_off(time_sync_base_0);
					//time_sync_tx_off(full_udp_stack_ip_base_0);
				  info( "Disable time sync...\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "SYNC: OFF");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }
	            else if ( strcmp (c, "syncrst") == 0){

				  set_sync_rst(time_sync_base_0);
				  info( "Reset time sync...\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "SYNC: RST");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
			  }


	            else if ( strcmp (c, "syncdly") == 0){

//	            	scanf ("%d",&tmp);
	            	tmp = atoi(strtok(NULL, token));
	                set_sync_pkt_dly(time_sync_base_0,tmp);

					  info( "Set time sync response wait delay...\n");
					  oled_clear(zedboard_oled_params_0.base_address);
					  sprintf(&menuBuf[0], "%s", "SYNC: DLY");
					  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					ui_draw();
				  }

		else if ( strcmp (c, "setsyncon") == 0){

						initiate_sync(time_sync_base_0);
					  set_sync_on(audio_to_eth_base_0);
					  info( "Enable time sync...\n");
					  oled_clear(zedboard_oled_params_0.base_address);
					  sprintf(&menuBuf[0], "%s", "SYNC: ON");
					  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					ui_draw();
				  }

		else if ( strcmp (c, "setsyncoff") == 0){

					  set_sync_off(audio_to_eth_base_0);
					  info( "Disable time sync...\n");
					  oled_clear(zedboard_oled_params_0.base_address);
					  sprintf(&menuBuf[0], "%s", "SYNC: OFF");
					  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					ui_draw();
				  }



		else if ( strcmp (c, "tgsync") == 0){

							set_sync_off(audio_to_eth_base_0);
						sleep(1);
						  set_sync_on(audio_to_eth_base_0);
						  info( "Toggle time sync...\n");
						  oled_clear(zedboard_oled_params_0.base_address);
						  sprintf(&menuBuf[0], "%s", "SYNC: ON");
						  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
						ui_draw();
					  }

		else if ( strcmp (c, "bver") == 0){


									  info("The BP version is: %s\n",VER);
									  oled_clear(zedboard_oled_params_0.base_address);
									  sprintf(&menuBuf[0], "%s %s", "Core Ver:", VER);
									  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
									ui_draw();
								  }

				else if(strcmp (c,"cver") == 0)
						{
							  //SET_STATUS("Enter payload length in 24 bit samples:\n");

							  tmp = get_core_version(eth_packet_sequencer_base_0);//in micro seconds
							  info("The FPGA core version is: %0.1f\n",tmp/10.0);
							  oled_clear(zedboard_oled_params_0.base_address);
							sprintf(&menuBuf[0], "OXecS=%d",tmp);
							oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
							  ui_draw();
						}

		else if ( strcmp (c, "setowdlycnt") == 0){

//						scanf ("%d",&tmp);
			tmp = atoi(strtok(NULL, token));
						  set_owdly_cnt(time_sync_base_0, tmp);
						  info( "Enable time sync...\n");
						  oled_clear(zedboard_oled_params_0.base_address);
						  sprintf(&menuBuf[0], "%s %f", "SETONWDLY:",tmp/125e6);
						  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
						ui_draw();
					  }
		else if ( strcmp (c, "latency") == 0){


					time_sync_en(time_sync_base_0);
					usleep(100);
					time_sync_tx_en(full_udp_stack_ip_base_0);
				  info( "Enable time sync...\n");
				  sleep(1);
				  time_tms_off(time_sync_base_0);
				  usleep(100);
				  time_tms_en(time_sync_base_0);
				  usleep(100);
				  time_sync_tx_en(full_udp_stack_ip_base_0);
				  info( "Measuring time delay...\n");
				  sleep(3);
				  get_tms_delays(time_sync_base_0);
				  get_tms_delay_mean(time_sync_base_0);
				  time_tms_off(time_sync_base_0);
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "MDLAY: ..");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
//					tmp = get_media_latency(time_sync_base_0);
//
//					info("The running media packets latency is: %0.1f ms\n",tmp/SAMPLE_RATE);
//					  oled_clear(zedboard_oled_params_0.base_address);
//					  sprintf(&menuBuf[0], "%s", "MDLAY: ..");
//					  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
//					  ui_draw();

			   }
		else if ( strcmp (c, "mlat") == 0){
				tmp = get_media_latency(time_sync_base_0);

				printf("The media packets is: %0.1f ms\n",tmp/SAMPLE_RATE);
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "MDLAY: ..");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
			   }
	      else if ( strcmp (c, "strpktcon") == 0){

				  set_pcnt_mode_on(audio_to_eth_base_0);
				  info( "Enable UDP packet count\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "Pkt Count: ON");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }
	      else if ( strcmp (c, "strpktcoff") == 0){

				  set_pcnt_mode_off(audio_to_eth_base_0);
				  info( "Disable UDP packet count\n");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "Pkt Count: OFF");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
				}

	      else if ( strcmp (c, "strsndon") == 0){

	      			  set_stream_send_on(audio_to_eth_base_0);
	      			  info( "Enable Audio payload generation\n");
	      			oled_clear(zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "%s", "Pkt Send: ON");
	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			ui_draw();
	      		  }
	            else if ( strcmp (c, "strsndoff") == 0){

	      			  set_stream_send_off(audio_to_eth_base_0);
	      			  info( "Disable Audio payload generation \n");
	      			oled_clear(zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "%s", "Pkt Send: OFF");
	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			ui_draw();
	      			}

	      else if ( strcmp (c, "strselarm") == 0){
	          	  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
	          	  info( "Play arm stream\n>");
	          	oled_clear(zedboard_oled_params_0.base_address);
	          	sprintf(&menuBuf[0], "%s", "Pkt Send: ARM");
	          	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          	ui_draw();
	            }
	      else if ( strcmp (c, "strseleth") == 0){
	               	  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
	               	  info( "Play Eth stream\n>");
	               	oled_clear(zedboard_oled_params_0.base_address);
	               	sprintf(&menuBuf[0], "%s", "Pkt Send: ETH");
	               	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	               	ui_draw();
	                 }

	      else if ( strcmp (c, "start") == 0){
	//    	  set_sync_off(audio_to_eth_base_0);
	    	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);

			write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x02);
			buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	//		info( "Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
	//						  BYTE_TO_BINARY(buf>>24),BYTE_TO_BINARY(buf>>16),BYTE_TO_BINARY(buf>>8), BYTE_TO_BINARY(buf);
			set_stream_send_on(audio_to_eth_base_0);
			usleep(200);
			reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
//			init_incall_timed_task_handler();// In the SIP UA layer
			printf("Stream tx started status was:0x%X\n>",buf);
	//		sleep(1);
	//		initiate_sync(time_sync_base_0);
	//		set_sync_on(audio_to_eth_base_0);
//			info( "Enable time sync...\n");
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "UDP Send: ON");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
	      }

	      else if ( strcmp (c, "strrxon") == 0){
	          	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	          	      	  write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x04);
	          	      	info( "Stream rx started status was:0x%X\n>",buf);
	          	      	oled_clear(zedboard_oled_params_0.base_address);
	          	      	sprintf(&menuBuf[0], "%s", "UDP Rx: ON");
	          	      	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          	      	ui_draw();
	            }


	      else if ( strcmp (c, "stop") == 0){
	    	  info("Disable Audio payload generation \n");
	    	      	  set_stream_send_off(audio_to_eth_base_0);
	    	      	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	    	      	  set_sync_off(audio_to_eth_base_0);
	    	      	  info("Disable time sync...\n");
	    	      	  write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFD);
	    	      	  oled_clear(zedboard_oled_params_0.base_address);
	    	      	  sprintf(&menuBuf[0], "%s", "UDP Send: OFF");
	    	      	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	    	      	  buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	    	      	  info("Stream tx stopped status was:0x%X\n>",buf);
	    	      	  info("Stop timed tasks...\n");
	    	  //    	  deinit_incall_timed_task_handler();
	    	      	  signal(SIGALRM, SIG_IGN);          /* ignore this signal       */
	            }
	      else if ( strcmp (c, "strrxstop") == 0){
	          	  unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	          	  write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFB);
	          	  oled_clear(zedboard_oled_params_0.base_address);
	          	  sprintf(&menuBuf[0], "%s", "UDP Receive: OFF");
	          	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          	  info( "Stream rx stopped status was:0x%X\n>",buf);
	         }
	      else if(strcmp (c,"strmac") == 0) {
			  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
//	    	  scanf("%s",ip);
	    	  sprintf(ip, "%s",strtok(NULL, token));
			  extractMacAddress(ip,&macAddress[0]);
			  info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
			  //write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, ((macAddress[0]<<40)|(macAddress[1]<<32)|macAddress[2]<<24)|(macAddress[3]<<16)|(macAddress[4]<<8)|(macAddress[5]);
			  write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, &macAddress[0]);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", menuitem[11]);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%02x%02x%02x%02x%02x%02x",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

			  ui_draw();
		}
	      else if(strcmp (c,"strsip") == 0) {
	      		  //SET_STATUS("Enter Dest IP Address (xxx.xxx.xxx.xxx format): ");
//	          	  scanf("%s",ip);
	    	      sprintf(ip, "%s",strtok(NULL, token));
	      		  extractIpAddress(ip,&ipAddress[0]);
	      		  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
	      		  write_eth_param(full_udp_stack_ip_base_0, SYNC_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

	      		  oled_clear(zedboard_oled_params_0.base_address);
	      		  sprintf(&menuBuf[0], "%s", menuitem[13]);
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", ip);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	      		  ui_draw();
	      	}

	      else if(strcmp (c,"strdip") == 0) {
			  //SET_STATUS("Enter Dest IP Address (xxx.xxx.xxx.xxx format): ");
//	    	  scanf("%s",ip);
	    	  sprintf(ip, "%s",strtok(NULL, token));
			  extractIpAddress(ip,&ipAddress[0]);
			  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
			  write_eth_param(full_udp_stack_ip_base_0, DEST_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", menuitem[13]);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", ip);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

			  ui_draw();
		}
	      else if(strcmp (c,"strlip") == 0) {
	      		  //SET_STATUS("Enter Local IP Address (xxx.xxx.xxx.xxx format): ");
//	    	  scanf("%s",ip);
	    	  sprintf(ip, "%s",strtok(NULL, token));
	      		  extractIpAddress(ip,&ipAddress[0]);
	      		  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
	      		write_eth_param(full_udp_stack_ip_base_0, LOCAL_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

	      		  oled_clear(zedboard_oled_params_0.base_address);
	      		sprintf(&menuBuf[0], "%s", menuitem[12]);
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", ip);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	      		  ui_draw();
	      	}

	      else if(strcmp (c,"strsip") == 0) {
	      		  //SET_STATUS("Enter Dest IP Address (xxx.xxx.xxx.xxx format): ");
//	          	  scanf("%s",ip);
	          	sprintf(ip, "%s",strtok(NULL, token));
	      		  extractIpAddress(ip,&ipAddress[0]);
	      		  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
	      		  write_eth_param(full_udp_stack_ip_base_0, SYNC_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

	      		  oled_clear(zedboard_oled_params_0.base_address);
	      		  sprintf(&menuBuf[0], "%s", "SYNC_IP:");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", ip);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	      		  ui_draw();
	      	}

	      else if(strcmp (c,"strgip") == 0) {
	           		  //SET_STATUS("Enter Gateway IP Address (xxx.xxx.xxx.xxx format): ");
//	           		  scanf("%s",ip);
	           		sprintf(ip, "%s",strtok(NULL, token));
	           		  extractIpAddress(ip,&ipAddress[0]);
	           		  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
	           		write_eth_param(full_udp_stack_ip_base_0, GTWAY_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

	           		  oled_clear(zedboard_oled_params_0.base_address);
	           		sprintf(&menuBuf[0], "%s", menuitem[14]);
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%s", ip);
					oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	           		  ui_draw();
	           	}
	      else if(strcmp (c,"strmask") == 0) {
	                 		  //SET_STATUS("Enter Netmask IP Address (xxx.xxx.xxx.xxx format): ");
//	    	  scanf("%s",ip);
	    	  sprintf(ip, "%s",strtok(NULL, token));
			  extractIpAddress(ip,&ipAddress[0]);
			  info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
			  write_eth_param(full_udp_stack_ip_base_0, MASK_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", menuitem[15]);
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", ip);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			  ui_draw();
	     }

	      else if(strcmp (c,"strport") == 0) {
	              //SET_STATUS("Enter port:\n");

//	              scanf ("%d",&dest_port);
	              dest_port = atoi(strtok(NULL, token));
	              write_eth_param(full_udp_stack_ip_base_0, DEST_PORT_ID, dest_port);

	              oled_clear(zedboard_oled_params_0.base_address);
	              sprintf(&menuBuf[0], "%s", menuitem[16]);
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%d", dest_port);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	              ui_draw();
	            }
	      else if(strcmp (c,"strsport") == 0) {
	                    //SET_STATUS("Enter port:\n");

//	                    scanf ("%d",&dest_port);
	                    dest_port = atoi(strtok(NULL, token));
	                    write_eth_param(full_udp_stack_ip_base_0, SYNC_PORT_ID, dest_port);

	                    oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[0], "%s", "SYNC PORT");
						oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
						sprintf(&menuBuf[0], "%d", dest_port);
						oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	                    ui_draw();
	                  }

	      else if(strcmp (c,"setswp1") == 0) {
			  //SET_STATUS("Enter port:\n");

//			  scanf ("%d",&sw_port);
			  sw_port = atoi(strtok(NULL, token));
			  write_switch_param(hyb_switch_ip_base_0, PORT1_ID, sw_port);

			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SW PORT1");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%d", sw_port);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

	      else if(strcmp (c,"setswp2") == 0) {
	      		  //SET_STATUS("Enter port:\n");

//	      		  scanf ("%d",&sw_port);
	      		sw_port = atoi(strtok(NULL, token));
	      		  write_switch_param(hyb_switch_ip_base_0, PORT2_ID, sw_port);

	      		  oled_clear(zedboard_oled_params_0.base_address);
	      		  sprintf(&menuBuf[0], "%s", "SW PORT2");
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%d", sw_port);
					oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	      		  ui_draw();
	      		}

	      else if(strcmp (c,"setswp3") == 0) {
			  //SET_STATUS("Enter port:\n");

//			  scanf ("%d",&sw_port);
			  sw_port = atoi(strtok(NULL, token));
			  write_switch_param(hyb_switch_ip_base_0, PORT3_ID, sw_port);

			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SW PORT3");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%d", sw_port);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

	      else if(strcmp (c,"setswp4") == 0) {
			  //SET_STATUS("Enter port:\n");

//			  scanf ("%d",&sw_port);
			  sw_port = atoi(strtok(NULL, token));
			  write_switch_param(hyb_switch_ip_base_0, PORT4_ID, sw_port);

			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SW PORT4");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%d", sw_port);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			  ui_draw();
			}
	      else if(strcmp (c,"setswp5") == 0) {
			  //SET_STATUS("Enter port:\n");

//			  scanf ("%d",&sw_port);
	    	  sw_port = atoi(strtok(NULL, token));
			  write_switch_param(hyb_switch_ip_base_0, PORT5_ID, sw_port);

			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SW PORT5");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d", sw_port);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			  ui_draw();
			}
	      else if(strcmp (c,"setswp6") == 0) {
			  //SET_STATUS("Enter port:\n");

//			  scanf ("%d",&sw_port);
			  sw_port = atoi(strtok(NULL, token));
			  write_switch_param(hyb_switch_ip_base_0, PORT6_ID, sw_port);

			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SW PORT6");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d", sw_port);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			  ui_draw();
			}
	      else if(strcmp (c,"setswp7") == 0) {
			  //SET_STATUS("Enter port:\n");

//			  scanf ("%d",&sw_port);
	    	  sw_port = atoi(strtok(NULL, token));
			  write_switch_param(hyb_switch_ip_base_0, PORT7_ID, sw_port);

			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SW PORT7");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d", sw_port);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			  ui_draw();
			}
	      else if(strcmp (c,"setswp8") == 0) {
			  //SET_STATUS("Enter port:\n");

//			  scanf ("%d",&sw_port);
			  sw_port = atoi(strtok(NULL, token));
			  write_switch_param(hyb_switch_ip_base_0, PORT8_ID, sw_port);

			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s", "SW PORT8");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d", sw_port);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			  ui_draw();
			}
	      else if(strcmp (c,"strnsp") == 0) {//cant set speed
	      		  //SET_STATUS("Enter Net speed 0=10M, 1=100M, 2=1G: ");
//	      		  scanf ("%d",&tmp);
	      		tmp = atoi(strtok(NULL, token));
	      		buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	      		if(tmp == 0){
	      		   write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFF9);
	      		}else if(tmp == 1){
	       		   write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFB);
	       		}else if(tmp == 2){
	       		   write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFD);
	       		}


	      		  oled_clear(zedboard_oled_params_0.base_address);
	      		sprintf(&menuBuf[0], "%s%s", menuitem[12], ip);
	      		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

	      		  ui_draw();
	      	}
	      else if(strcmp (c,"strplen") == 0) {
	                    //SET_STATUS("Enter payload length in 24 bit samples:\n");
	                    //UDP header is 8 bytes
//	                    scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));
	                    int c = (tmp-12-2)%4;
	                    pkt_len = tmp-12-2;
	                    pkt_len_rl_samples = pkt_len/4;
	                    if (c > 0){
	                    	info( "Warning:: Bad packet length:: The packet length formula is:: 4xN + 14 \n Choose N wisely!!!\n");
	                    }
	                    //write_eth_param(full_udp_stack_ip_base_0, PKT_LEN_ID, ((tmp*3) +8);//+8 done in fpga
	                    //write_audio_to_eth_param(audio_to_eth_base_0, PAYLEN_REG_ID, tmp*3);
	                    set_stream_plen(audio_to_eth_base_0,tmp);
	                    oled_clear(zedboard_oled_params_0.base_address);
	            		sprintf(&menuBuf[0], "Pkt Length:%5d", (tmp));
	            		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                    ui_draw();
	                  }

	      else if(strcmp (c,"strporder") == 0) {

//	                          scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));

	                          set_stream_porder(eth_packet_sequencer_base_0,tmp);
	                          oled_clear(zedboard_oled_params_0.base_address);
	                  		sprintf(&menuBuf[0], "Pkt Seq Odr:%d", (tmp));
	                  		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                          ui_draw();
	                        }
	//      else if(strcmp (c,"setsqwdly") == 0) {//PKT_WAIT_DELAY
	//
	//                                scanf ("%d",&tmp);
	//
	//                                set_stream_pkt_wait(eth_packet_sequencer_base_0,tmp*(0x40);//in micro seconds
	//                                oled_clear(zedboard_oled_params_0.base_address);
	//                        		sprintf(&menuBuf[0], "Pkt Seq WDly:%d us", (tmp));
	//                        		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	//                                ui_draw();
	//                              }
	      else if(strcmp (c,"setppdly") == 0) {//PKT_WAIT_DELAY

//	                                      scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));

	                                      set_stream_pkt_wait(eth_packet_sequencer_base_0,tmp*(0x40));//in micro seconds
	                                      oled_clear(zedboard_oled_params_0.base_address);
	                              		sprintf(&menuBuf[0], "Pkt Seq WDly:%d us", (tmp));
	                              		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                                      ui_draw();
	                                    }
	      else if(strcmp (c,"setsqsdly") == 0) {//PKT_SEND_DELAY

//	                                      scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));

	                                      set_stream_pkt_send_delay(eth_packet_sequencer_base_0,tmp*(0x40));//in micro seconds
	                                      oled_clear(zedboard_oled_params_0.base_address);
	                              		sprintf(&menuBuf[0], "Pkt Seq SDly:%d us", (tmp));
	                              		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                                      ui_draw();
	                                    }


	      else if(strcmp (c,"setplcpktsize") == 0)
	      {
					SET_STATUS("Set PLC packet size (same as incoming rx packet size)\n");
					//UDP header is 8 bytes
//					scanf ("%d",&tmp);
					tmp = atoi(strtok(NULL, token));
					int c = (tmp-2)%6;

					if (c > 0){
						info( "Warning:: Bad packet length:: The packet length formula is:: 6xN + 2 \n Choose N wisely!!!\n");
					}

					set_stream_rx_pkt_size(eth_packet_sequencer_base_0,(tmp-2));//in bytes
					oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "PLC pSz:%d", ((tmp-2)));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					ui_draw();
				  }


	      else if(strcmp (c,"setpblim") == 0) {
					//SET_STATUS("Enter payload length in 24 bit samples:\n");
					//UDP header is 8 bytes
//					scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));

//					set_stream_rx_buf_lim(eth_packet_sequencer_base_0,tmp);//in micro seconds
					set_stream_rx_buf_lim2(eth_to_audio_base_0,tmp);//in micro seconds
					oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "PoBlim:%d ", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					ui_draw();
				  }


	      else if(strcmp (c,"setdlim") == 0) {
	      				//SET_STATUS("Enter payload length in 24 bit samples:\n");
	      				//UDP header is 8 bytes
//	      				scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));
	      				set_stream_rx_buf_dlim(eth_to_audio_base_0,tmp);//in micro seconds
	      				oled_clear(zedboard_oled_params_0.base_address);
	      				sprintf(&menuBuf[0], "Dlim:%d ", (tmp));
	      				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      				ui_draw();
	      			  }

	      else if(strcmp (c,"setbslk") == 0) {
			//SET_STATUS("Enter payload length in 24 bit samples:\n");
			//UDP header is 8 bytes
			//	            				scanf ("%d",&tmp);
			tmp = atoi(strtok(NULL, token));
			set_stream_rx_buf_slack(eth_to_audio_base_0,tmp);//in micro seconds
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "BSlk:%d ", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
			}
	      else if(strcmp (c,"setbdlm") == 0) {
	                  				//SET_STATUS("Enter payload length in 24 bit samples:\n");
	                  				//UDP header is 8 bytes
//	                  				scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));
			set_stream_rx_buf_docc_lim(eth_to_audio_base_0,tmp);//in micro seconds
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "Bdoc:%d ", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
		  }
	      else if(strcmp (c,"setprdly") == 0) {
	     				//SET_STATUS("Enter payload length in 24 bit samples:\n");
	     				//UDP header is 8 bytes
//	     				scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));

			set_plc_replace_delay(eth_packet_sequencer_base_0,tmp);//in clocks
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "RepDly:%d ", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
		  }
	      else if(strcmp (c,"setsqlkdly") == 0) {
	           				//SET_STATUS("Enter payload length in 24 bit samples:\n");
	           				//UDP header is 8 bytes
//	           				scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));
				set_seq_replace_lock_delay(eth_packet_sequencer_base_0,tmp);//in clocks
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "SQLkDly:%d ", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }
	      else if(strcmp (c,"sqwon") == 0) {
								  //SET_STATUS("Enter payload length in 24 bit samples:\n");

			  set_stream_pkt_wait_enable(eth_packet_sequencer_base_0);//in micro seconds
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "Pkt Seq Dly:CUS");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}
	      else if(strcmp (c,"sqwoff") == 0) {

			set_stream_pkt_wait_disable(eth_packet_sequencer_base_0);//in micro seconds
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "Pkt Seq Dly:DFT");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
		  }
	      else if(strcmp (c,"sqsdon") == 0) {

			  set_stream_pkt_send_delay_enable(eth_packet_sequencer_base_0);//in micro seconds
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "Pkt Seq Dly:CUS");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}
		else if(strcmp (c,"sqsdoff") == 0) {

				set_stream_pkt_send_delay_disable(eth_packet_sequencer_base_0);//in micro seconds
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "Pkt Seq Dly:DFT");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }
		else if(strcmp (c,"plcoff") == 0) {

				set_plc_disable(eth_to_audio_base_0);//in micro seconds
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "PLC:OFF");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }
		else if(strcmp (c,"plcon") == 0) {

				set_plc_enable(eth_to_audio_base_0);//in micro seconds
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "PLC:ON");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			  }
		else if(strcmp (c,"strblen") == 0) {
					  //SET_STATUS("Enter payload length in 24 bit samples:\n");
					  //UDP header is 8 bytes
//	                          scanf ("%d",&tmp);
					  tmp = atoi(strtok(NULL, token));
					  //write_eth_param(full_udp_stack_ip_base_0, PKT_LEN_ID, ((tmp*3) +8);//+8 done in fpga
					  //write_audio_to_eth_param(audio_to_eth_base_0, PAYLEN_REG_ID, tmp*3);
					  set_stream_blen(eth_to_audio_base_0,tmp);
					  sleep(1);
					  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right

					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%s:%5d", menuitem[27], (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
					}
	      else if(strcmp (c,"delay") == 0) {
//	    	  scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));
	    	  set_playout_delay(eth_to_audio_base_0,tmp*SAMPLE_RATE);
	    	  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s:%5d", "POUDLY", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			ui_draw();
	      }
	      else if(strcmp (c,"getpoutdly") == 0) {
				//SET_STATUS("Enter payload length in 24 bit samples:\n");
				//UDP header is 8 bytes
				tmp = get_playout_delay(eth_to_audio_base_0);
				info( "The current audio playout delay is:%d samples\n",(tmp));
				info( "The current audio playout delay is:%f ms\n",(tmp/SAMPLE_RATE));
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%d samples", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%d ms", (tmp/SAMPLE_RATE));
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
				ui_draw();
			  }

	      else if(strcmp (c,"getpouttime") == 0) {
	      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
	      			//UDP header is 8 bytes
	      			tmp = get_instant_playout_time(eth_to_audio_base_0);
	      			info( "The current audio playout time is:%f ms\n",(tmp/SAMPLE_RATE));
	      			oled_clear(zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "TCO:%d ", (tmp));
	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "%d ms", (tmp/SAMPLE_RATE));
	      			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	      			ui_draw();
	      		  }
	      else if(strcmp (c,"getsynctime") == 0) {
				//SET_STATUS("Enter payload length in 24 bit samples:\n");
				//UDP header is 8 bytes
				tmp = get_sync_time(eth_to_audio_base_0);
				info( "The current audio sync time is:%f ms\n",(tmp/SAMPLE_RATE));
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "TC:%d ", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%d ms", (tmp/SAMPLE_RATE));
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
				ui_draw();
			  }
	      else if(strcmp (c,"getalle2a") == 0) {
	      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
	      			//UDP header is 8 bytes

	    	  info( "All reg values for the Eth to audio block\n");
			get_all_eth2audio(eth_to_audio_base_0);
			info( "The current audio sync time is:%f ms\n",(tmp/SAMPLE_RATE));
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "TC:%d ", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%d ms", (tmp/SAMPLE_RATE));
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			ui_draw();
		  }
	      else if(strcmp (c,"getrxtc") == 0) {
	      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
	      			//UDP header is 8 bytes
	      			tmp =  get_rx_time_code(eth_to_audio_base_0);
	      			info( "The current audio rxtc is:%d samples\n",(tmp));
	      			info( "The current audio rxtc is:%f ms\n",(tmp/SAMPLE_RATE));
	      			oled_clear(zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "rtc:%d smp", (tmp));
	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "rtc:%d ms", (tmp/SAMPLE_RATE));
	      			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	      			ui_draw();
	      		  }

	      else if(strcmp (c,"getrxtceff") == 0) {
					//SET_STATUS("Enter payload length in 24 bit samples:\n");
					//UDP header is 8 bytes
					tmp =  get_rx_time_code_eff(eth_to_audio_base_0);
					info( "The current audio rxtceff is:%d samples\n",(tmp));
					info( "The current audio rxtceff is:%f ms\n",(tmp/SAMPLE_RATE));
					oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "rtc:%d smp", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "rtc:%d ms", (tmp/SAMPLE_RATE));
					oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
					ui_draw();
				  }

	      else if(strcmp (c,"getrxtcocc") == 0) {
				//SET_STATUS("Enter payload length in 24 bit samples:\n");
				//UDP header is 8 bytes
				tmp =  get_rx_time_code_occ(eth_to_audio_base_0);
				info( "The current audio rxtc is:%d samples\n",(tmp));
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "rtcocc:%d smp", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

				ui_draw();
			  }
	      else if(strcmp (c,"setlooplimit") == 0) {
//	          	  scanf ("%d",&tmp);
	    	  tmp = atoi(strtok(NULL, token));
	          	  set_loop_limit(eth_to_audio_base_0,tmp);
	          	  oled_clear(zedboard_oled_params_0.base_address);
	      		sprintf(&menuBuf[0], "%s:%5d", "LOOPLIM", (tmp));
	      		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      		ui_draw();
	            }

	      else if(strcmp (c,"geta2es") == 0) {
	      	      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
	      	      			//UDP header is 8 bytes
//	      	      			tmp = get_instant_playout_reads(eth_to_audio_base_0);
	      	      			get_a2e_state(eth_to_audio_base_0);
//	      	      			info( "The current audio playout reads is:%d samples\n",(tmp));
	      	      			oled_clear(zedboard_oled_params_0.base_address);
	      	      			sprintf(&menuBuf[0], "%X state", (tmp));
	      	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      	      			ui_draw();
	      	      		  }
	      else if(strcmp (c,"gettc") == 0) {
	    	  unsigned long tmp1, tmp2, tmp3;
				//SET_STATUS("Enter payload length in 24 bit samples:\n");
				//UDP header is 8 bytes

	    	  tmp =  get_rx_time_code(eth_to_audio_base_0);
	    	      	  		  printf("The current audio rxtc is:%0.3f ms\n",(tmp/SAMPLE_RATE));
	    	      	  //		  tmp = get_rx_time_code_fout(eth_to_audio_base_0);
	    	      	  //		  printf("The current audio rxtcfout is:%0.3f ms\n",(tmp/SAMPLE_RATE));
	    	      	  		  tmp1 =  get_rx_time_code_eff(eth_to_audio_base_0);
	    	      	  	      printf("The current audio rxtceff is:%0.3f ms\n",(tmp1/SAMPLE_RATE));
	    	      	      	  tmp2 = get_playout_delay(eth_to_audio_base_0);
	    	      	      	  printf("The current audio playout delay is: %0.3f\n----------------------------------------\n",(tmp2/SAMPLE_RATE));
	    	      	      	  printf("The current audio sched playout time is: %0.3f\n",((tmp1+tmp2)/SAMPLE_RATE));
	    	      	      	  tmp = get_sync_time(eth_to_audio_base_0);
	    	      	      	  printf("The current audio sync time is:%0.3f ms\n",(tmp/SAMPLE_RATE));
	    	      	      	  tmp = get_instant_playout_time(eth_to_audio_base_0);
	    	      	      	  printf("The current audio playout time is:%0.3f ms\n",(tmp/SAMPLE_RATE));
	    	      	      	  tmp = get_dac_ofifo_occ(eth_to_audio_base_0);
	    	      	      	  printf("The current odd audio buf sample count is:%d samples\n",(tmp));
	    	      	      	  tmp = get_dac_efifo_occ(eth_to_audio_base_0);
	    	      	      	  printf("The current even audio buf sample count is:%d samples\n",(tmp));
	    	      	      	  tmp = get_dac_dump_pkts(eth_to_audio_base_0);
	    	      	      	  printf("The num of dropped pkts in dpkt is:%d pks\n",(tmp));
	    	      	      	  tmp = get_pkts_dropped(eth_packet_sequencer_base_0);
	    	      	      	  printf("The number of sq packets dropped is:%d\n",tmp);
	    	      	      	  tmp = get_pkt_seq_skiped(eth_packet_sequencer_base_0);
	    	      	      	  printf("The number of sq packets skipped is:%d\n",tmp);
	    	      	      	tmp = get_dpkt_replace_events(eth_to_audio_base_0);
	    	      	      	    	  printf("The number of dpkt replace events is:%d\n",tmp);

	    	      	  //    	  tmp = get_media_latency(time_sync_base_0);
	    	      	  //    	  printf("The running media packets latency is: %0.1f ms\n",tmp/SAMPLE_RATE);


	    	      	  //			tmp =  get_rx_time_code_occ(eth_to_audio_base_0);
	    	      	  //			printf("The current audio rxtc occ is:%d\n",(tmp));

	    	      	  			oled_clear(zedboard_oled_params_0.base_address);
	    	      	  			sprintf(&menuBuf[0], "tsyncvars");
	    	      	  			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

	    	      	  			ui_draw();
			  }
	      else if(strcmp (c,"getpoutr") == 0) {
	      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
	      			//UDP header is 8 bytes
	      			tmp = get_instant_playout_reads(eth_to_audio_base_0);
	      			info( "The current audio playout reads is:%d samples\n",(tmp));
	      			oled_clear(zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "%d samples", (tmp));
	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			ui_draw();
	      		  }
	      else if(strcmp (c,"getpoutw") == 0) {
	      			//SET_STATUS("Enter payload length in 24 bit samples:\n");
	      			//UDP header is 8 bytes
	      			tmp = get_instant_playout_writes(eth_to_audio_base_0);
	      			info( "The current audio playout writes is:%d samples\n",(tmp));

	      			oled_clear(zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "%d samples", (tmp));
	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			oled_print_message(&menuBuf[1], 2, zedboard_oled_params_0.base_address);
	      			ui_draw();
	      		  }


	      else if(strcmp (c,"getfocc") == 0) {
					//SET_STATUS("Enter payload length in 24 bit samples:\n");
					//UDP header is 8 bytes
					tmp = get_dac_fifo_occ(eth_to_audio_base_0);
					info( "The current audio buf sample count is:%d samples\n",(tmp));

					oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "BUF OCC::");
					sprintf(&menuBuf[1], "%d samples", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					oled_print_message(&menuBuf[1], 2, zedboard_oled_params_0.base_address);
					ui_draw();
				  }
	      else if(strcmp (c,"setcrwin") == 0) {

	          	  set_buf_corr_window(eth_to_audio_base_0,tmp);
	          	  oled_clear(zedboard_oled_params_0.base_address);
	      		sprintf(&menuBuf[0], "%s:%5d", "POUDLY", (tmp));
	      		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      		ui_draw();
	            }

	      else if ( strcmp (c, "tgsrcorr") == 0){
				  clear_buf_corr(eth_to_audio_base_0);
				  sleep(1);
	          	  set_buf_corr_on(eth_to_audio_base_0);
				  info( "Toggle sample rate correction\n>");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "SRCorr:ON");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
			  }

	      else if ( strcmp (c, "setcoron") == 0){
	    	  set_buf_corr_on(eth_to_audio_base_0);
	          	  info( "Enable sample rate correction\n>");
	          	  oled_clear(zedboard_oled_params_0.base_address);
	          	  sprintf(&menuBuf[0], "%s", "SRCorr:ON");
	          	  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	          	  ui_draw();
	            }



	      else if ( strcmp (c, "setcoroff") == 0){
	          	  clear_buf_corr(eth_to_audio_base_0);
				  info( "Disable sample rate correction\n>");
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "SRCorr:OFF");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
			  }
	      else if ( strcmp (c, "gete2astatus") == 0){
	    	  	  info( "Eth to Audio ststus is::\n>");
	    	  	  get_e2a_status(eth_to_audio_base_0);

				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s", "ETH2AUD:Status");
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
			  }

	      else if(strcmp (c,"getmac") == 0) {
	      		  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
	          	  //scanf("%s",ip);
	      		  //extractMacAddress(ip,&macAddress[0]);
	      		  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
	      		read_eth_mac(full_udp_stack_ip_base_0, MAC_REG_ID,&ip[0]);
	      		//info( "\nMAC Address:");
	//      		      		   print_mac(tmp, ip);
	      		  oled_clear(zedboard_oled_params_0.base_address);
	      		sprintf(&menuBuf[0], "%s", menuitem[11]);
	      		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      		sprintf(&menuBuf[0], "%s", ip);
	      		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	      		  ui_draw();
	      	}
	      else if(strcmp (c,"getarps") == 0) {
	      				  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
	      				  //scanf("%s",ip);
	      				  //extractMacAddress(ip,&macAddress[0]);
	      				  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
	      				read_eth_param(full_udp_stack_ip_base_0, ARP_STATE_REG_ID);
	      				//info( "\nMAC Address:");
	      	//      		      		   print_mac(tmp, ip);
	      				  oled_clear(zedboard_oled_params_0.base_address);
	      				sprintf(&menuBuf[0], "%s", "ARPS:");
	      				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      				sprintf(&menuBuf[0], "%s", ip);
	      				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	      				  ui_draw();
	      	      	      	}

	      else if(strcmp (c,"getereg") == 0) {
	    	  char * str = strtok(NULL, token);
	    	  int reg = 0;
	    	  if(str != NULL){
	    		  reg = atoi(str);
	    	  }else{
	    		  info( "Bad command got c=%s and NULL");
	    		  return;
	    	  }
			  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
			  //scanf("%s",ip);
			  //extractMacAddress(ip,&macAddress[0]);
			  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
			reg = read_eth_reg(full_udp_stack_ip_base_0, reg);
			//info( "\nMAC Address:");
//      		      		   print_mac(tmp, ip);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "EREG:");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%X", reg);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

			  ui_draw();
				}
	      else if(strcmp (c,"gettreg") == 0) {
	      	    	  char * str = strtok(NULL, token);
	      	    	  int reg = 0;
	      	    	  if(str != NULL){
	      	    		  reg = atoi(str);
	      	    	  }else{
	      	    		  info( "Bad command got c=%s and NULL");
	      	    		  return;
	      	    	  }
	      			  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
	      			  //scanf("%s",ip);
	      			  //extractMacAddress(ip,&macAddress[0]);
	      			  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
	      			reg = read_sync_reg(time_sync_base_0, reg);
	      			//info( "\nMAC Address:");
	      //      		      		   print_mac(tmp, ip);
	      			  oled_clear(zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "%s", "TREG:");
	      			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      			sprintf(&menuBuf[0], "%X", reg);
	      			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	      			  ui_draw();
	      				}
	      else if(strcmp (c,"getsreg") == 0) {
	    	  char * str = strtok(NULL, token);
			  int reg = 0;
			  if(str != NULL){
				  reg = atoi(str);
			  }else{
				  info( "Bad command got c=%s and NULL");
				  return;
			  }

			  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
			  //scanf("%s",ip);
			  //extractMacAddress(ip,&macAddress[0]);
			  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
//	      	      	      				reg = read_eth_reg(full_udp_stack_ip_base_0, reg);
			  reg = read_switch_reg(hyb_switch_ip_base_0, reg);
			//info( "\nMAC Address:");
//      		      		   print_mac(tmp, ip);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "SwREG:");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%X", reg);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

			  ui_draw();
				}
	      else if(strcmp (c,"getomac") == 0) {
			  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
			  //scanf("%s",ip);
			  //extractMacAddress(ip,&macAddress[0]);
			  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
			read_eth_mac(full_udp_stack_ip_base_0, ARP_OMAC_REG_ID,&ip[0]);
			//info( "\nMAC Address:");
//      		      		   print_mac(tmp, ip);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "ARPO:");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", ip);
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

			  ui_draw();
				}
	      else if(strcmp (c,"getamac1") == 0) {
				  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
				  //scanf("%s",ip);
				  //extractMacAddress(ip,&macAddress[0]);
				  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
				read_eth_mac(full_udp_stack_ip_base_0, ARP_MAC1_REG_ID,&ip[0]);
				//info( "\nMAC Address:");
	//      		      		   print_mac(tmp, ip);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", "ARP1:");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", ip);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

				  ui_draw();
	      	      	}
	      else if(strcmp (c,"getamac2") == 0) {
				  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
				  //scanf("%s",ip);
				  //extractMacAddress(ip,&macAddress[0]);
				  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
				read_eth_mac(full_udp_stack_ip_base_0, ARP_MAC2_REG_ID,&ip[0]);
				//info( "\nMAC Address:");
	//      		      		   print_mac(tmp, ip);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", "ARP2:");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", ip);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

				  ui_draw();
	     	    }
	      else if(strcmp (c,"getamac3") == 0) {
				  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
				  //scanf("%s",ip);
				  //extractMacAddress(ip,&macAddress[0]);
				  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
				read_eth_mac(full_udp_stack_ip_base_0, ARP_MAC3_REG_ID,&ip[0]);
				//info( "\nMAC Address:");
	//      		      		   print_mac(tmp, ip);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", "ARP3:");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", ip);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

				  ui_draw();
			}
	      else if(strcmp (c,"getamac4") == 0) {
				  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
				  //scanf("%s",ip);
				  //extractMacAddress(ip,&macAddress[0]);
				  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
				read_eth_mac(full_udp_stack_ip_base_0, ARP_MAC4_REG_ID,&ip[0]);
				//info( "\nMAC Address:");
	//      		      		   print_mac(tmp, ip);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", "ARP4:");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", ip);
				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

				  ui_draw();
			}
	      else if(strcmp (c,"getamac5") == 0) {
	      				  //SET_STATUS("Enter MAC Address (xx.xx.xx.xx.xx.xx format)");
	      				  //scanf("%s",ip);
	      				  //extractMacAddress(ip,&macAddress[0]);
	      				  //info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
	      				read_eth_mac(full_udp_stack_ip_base_0, ARP_MAC5_REG_ID,&ip[0]);
	      				//info( "\nMAC Address:");
	      	//      		      		   print_mac(tmp, ip);
	      				  oled_clear(zedboard_oled_params_0.base_address);
	      				sprintf(&menuBuf[0], "%s", "ARP5:");
	      				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      				sprintf(&menuBuf[0], "%s", ip);
	      				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	      				  ui_draw();
	      			}
	            else if(strcmp (c,"getdip") == 0) {
	      		  //SET_STATUS("Enter Dest IP Address (xxx.xxx.xxx.xxx format): ");
	          	  //scanf("%s",ip);
	      		  //extractIpAddress(ip,&ipAddress[0]);
	            //info( "\nIp Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
	      		  tmp=read_eth_param(full_udp_stack_ip_base_0, DEST_IP_REG_ID);
	      		info( "\nDest Ip Address:");
	      		   print_ip(tmp, ip);
	      		  oled_clear(zedboard_oled_params_0.base_address);
	      		  sprintf(&menuBuf[0], "%s", menuitem[13]);
	      		  		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      		  		sprintf(&menuBuf[0], "%s", ip);
	      		  		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	      		  ui_draw();
	      	}
	            else if(strcmp (c,"getlip") == 0) {

	            		tmp = read_eth_param(full_udp_stack_ip_base_0, LOCAL_IP_REG_ID);
	            		info( "\nLocal Ip Address:");
	            		print_ip(tmp, &ip[0]);
	            		  oled_clear(zedboard_oled_params_0.base_address);
	            		sprintf(&menuBuf[0], "%s", menuitem[12]);
	            				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	            				sprintf(&menuBuf[0], "%s", ip);
	            				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	            		  ui_draw();
	            	}

	            else if(strcmp (c,"getgip") == 0) {

	                 		tmp=read_eth_param(full_udp_stack_ip_base_0, GTWAY_IP_REG_ID);

	                 		      		info( "\nGateway Ip Address:");
	                 		      		  print_ip(tmp, ip);

	                 		  oled_clear(zedboard_oled_params_0.base_address);
	                 		sprintf(&menuBuf[0], "%s", menuitem[14]);
	                 				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                 				sprintf(&menuBuf[0], "%s", ip);
	                 				oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	                 		  ui_draw();
	                 	}
	            else if(strcmp (c,"getmask") == 0) {

	      		  tmp=read_eth_param(full_udp_stack_ip_base_0, MASK_IP_REG_ID);
	      		info( "\nMask Ip Address:");
	      		  print_ip(tmp, ip);
	      		  oled_clear(zedboard_oled_params_0.base_address);
	      		  sprintf(&menuBuf[0], "%s", menuitem[15]);
	      		  		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	      		  		sprintf(&menuBuf[0], "%s", ip);
	      		  		oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	      		  ui_draw();
	           }

	            else if(strcmp (c,"getport") == 0) {
	            	dest_port = read_eth_param(full_udp_stack_ip_base_0, DEST_PORT_REG_ID);
	            	info( "The port is:%d\n",dest_port);
	                    oled_clear(zedboard_oled_params_0.base_address);
	                    sprintf(&menuBuf[0], "%s", menuitem[16]);
						oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
						sprintf(&menuBuf[0], "%d", dest_port);
						oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	                    ui_draw();
	                  }
	            else if(strcmp (c,"getsport") == 0) {
						dest_port = read_eth_param(full_udp_stack_ip_base_0, SYNC_PORT_REG_ID);
						info( "The sync port is:%d\n",dest_port);
							oled_clear(zedboard_oled_params_0.base_address);
							sprintf(&menuBuf[0], "%s", menuitem[16]);
							oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
							sprintf(&menuBuf[0], "%d", dest_port);
							oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
							ui_draw();
						  }
	            else if(strcmp (c,"getplen") == 0) {

	                          tmp = get_stream_plen(audio_to_eth_base_0);
	                          info( "The udp payload size is:%d\n",tmp);
	                          oled_clear(zedboard_oled_params_0.base_address);
	                  		sprintf(&menuBuf[0], "%s%5d", menuitem[25], (tmp));
	                  		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                          ui_draw();
	                        }
	            else if(strcmp (c,"getporder") == 0) {

					  tmp = get_stream_porder(eth_packet_sequencer_base_0);
					  info( "The udp packet sequencer order is:%d\n",tmp);
					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%s%5d", menuitem[26], (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
					}
	            else if(strcmp (c,"getpdrop") == 0) {

	//				  tmp = get_pkts_dropped(packet_time_enforcer_base_0);
	            	tmp = get_pkts_dropped(eth_packet_sequencer_base_0);
					  info( "The number of packets dropped is:%u\n",tmp);
					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%s%d", "NPD:", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
					}
	            else if(strcmp (c,"getpreplaced") == 0) {

	            //				  tmp = get_pkts_dropped(packet_time_enforcer_base_0);
	                        	tmp = get_pkts_replaced(eth_packet_sequencer_base_0);
	            				  info( "The number of packets replaced is:%u\n",tmp);
	            				  oled_clear(zedboard_oled_params_0.base_address);
	            				sprintf(&menuBuf[0], "%s%d", "NPR:", (tmp));
	            				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	            				  ui_draw();
	            				}
	            else if(strcmp (c,"getsqgs") == 0) {

					  tmp = get_seq_gs(eth_packet_sequencer_base_0);
					  info( "The udp packet sequencer gs is:%08x\n",tmp);
					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%s%5d", "GST:", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
					}
				else if(strcmp (c,"getsqrx") == 0) {

	//				  tmp = get_pkts_dropped(packet_time_enforcer_base_0);
					tmp = get_seq_pkts_rx(eth_packet_sequencer_base_0);
					  info( "The number of packets sqrx is:%u\n",tmp);
					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%s%d", "SRX:", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
					}
				else if(strcmp (c,"getsqtx") == 0) {//get_seq_pkts_rx

	//				  tmp = get_pkts_dropped(packet_time_enforcer_base_0);
					tmp = get_seq_pkts_tx(eth_packet_sequencer_base_0);
					  info( "The number of packets sqtx is:%u\n",tmp);
					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%s%d", "STX:", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
					}
				else if(strcmp (c,"getsqov") == 0) {//get_seq_pkts_rx

				//				  tmp = get_pkts_dropped(packet_time_enforcer_base_0);
								tmp = get_seq_pkts_ov(eth_packet_sequencer_base_0);
								  info( "The number of packets sqov is:%u\n",tmp);
								  oled_clear(zedboard_oled_params_0.base_address);
								sprintf(&menuBuf[0], "%s%d", "SOV:", (tmp));
								oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
								  ui_draw();
								}
	            else if(strcmp (c,"setptl1") == 0) {//spkt2pkt
					//SET_STATUS("Enter payload length in 24 bit samples:\n");
					//UDP header is 8 bytes
//					scanf ("%d",&tmp);
	            	tmp = atoi(strtok(NULL, token));
					//write_eth_param(full_udp_stack_ip_base_0, PKT_LEN_ID, ((tmp*3) +8);//+8 done in fpga
					//write_audio_to_eth_param(audio_to_eth_base_0, PAYLEN_REG_ID, tmp*3);
					set_spkt_to_pkt_delay_limit(packet_time_enforcer_base_0,tmp);//just sample clock counts no need to multiply by 2
					oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "Buffer2Drop:%d", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					ui_draw();
				  }

	            else if(strcmp (c,"setptpidl") == 0) {//spkt2pkt_locked
//	            				scanf ("%d",&tmp);
	            	tmp = atoi(strtok(NULL, token));
	            				set_spkt_to_pkt_locked_delay_limit(packet_time_enforcer_base_0,tmp);//just sample clock counts no need to multiply by 2
	            				oled_clear(zedboard_oled_params_0.base_address);
	            				sprintf(&menuBuf[0], "BL2Drop:%d", (tmp));
	            				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	            				ui_draw();
	            			  }

			  else if(strcmp (c,"setptl2") == 0) {//spkt2pkt

//				  scanf ("%d",&tmp);//in milliseconds
				  tmp = atoi(strtok(NULL, token));

				  set_accum_pkt_to_pkt_delay_limit(packet_time_enforcer_base_0,tmp);//just sample clock counts no need to multiply by 2
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "BufferA2Drop:%d", (tmp));
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}

	            else if(strcmp (c,"getptl1") == 0) {

				  tmp = get_pkts_drop_spkt_limit(packet_time_enforcer_base_0);
				  info( "The delayed pkt2pkt drop limit is:%d\n",(tmp));
				  info( "The delayed pkt2pkt drop limit is:%u ms\n",(tmp/(SAMPLE_RATE)));//just sample clock counts no need to multiply by 2
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s%10u", "PDLM:", (tmp));
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}
	            else if(strcmp (c,"getptpidl") == 0) {

				  tmp = get_pkts_drop_spkt_locked_limit(packet_time_enforcer_base_0);
				  info( "The delayed pkt2pkt secondary drop limit is:%d\n",(tmp));
				  info( "The delayed pkt2pkt secondary drop limit is:%u ms\n",(tmp/(SAMPLE_RATE)));//just sample clock counts no need to multiply by 2
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s%10u", "PDSLM:", (tmp));
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}
	            else if(strcmp (c,"getptl2") == 0) {

				  tmp = get_pkts_adrop_spkt_limit(packet_time_enforcer_base_0);
				  info( "The delayed pkt running drop limit is:%d\n",(tmp));
				  info( "The delayed pkt running drop limit is:%u ms\n",(tmp/(SAMPLE_RATE)));
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%10u", "RDLM:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}

	            else if(strcmp (c,"getptlock") == 0) {

				  tmp = get_pkts_ptrx_lock(packet_time_enforcer_base_0);
				  info( "The packet timming unit lock status is:%08X\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%d", "LOCK:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}


	            else if(strcmp (c,"ptpidon") == 0) {

	            	pkt_to_pkt_locked_drop_enable(packet_time_enforcer_base_0);
	            			  info( "The packet timming unit pid tatus is on.\n");
	            			  oled_clear(zedboard_oled_params_0.base_address);
	            			sprintf(&menuBuf[0], "%s", "PID:ON");
	            			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	            			  ui_draw();
	            			}
	            else if(strcmp (c,"ptpidoff") == 0) {

	                        	pkt_to_pkt_locked_drop_disable(packet_time_enforcer_base_0);
	                        			  info( "The packet timming unit pid tatus is off.\n");
	                        			  oled_clear(zedboard_oled_params_0.base_address);
	                        			sprintf(&menuBuf[0], "%s", "PID:OFF");
	                        			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	                        			  ui_draw();
	                        			}
	            else if(strcmp (c,"getptstatus") == 0) {
	            	tmp = get_pkts_pt_accum(packet_time_enforcer_base_0);
	            			tmp = get_pkts_ptrx_lock(packet_time_enforcer_base_0);
	            			  tmp = get_pkts_pt_disable(packet_time_enforcer_base_0);

	            			  info( "The packet timming unit status is:%08X\n",tmp==0?1:0);
	            			  oled_clear(zedboard_oled_params_0.base_address);
	            			sprintf(&menuBuf[0], "%s%d", "PBT:", (tmp));
	            			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	            			  ui_draw();
	            			}

	            else if(strcmp (c,"setptlock") == 0) {

				  tmp = set_pkts_ptrx_lock(packet_time_enforcer_base_0, 1);
				  info( "The packet timming unit lock status is:%08X\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%10u", "LOCK:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}

	            else if(strcmp (c,"setptaccum") == 0) {

	            			  tmp = set_pkts_pt_accum(packet_time_enforcer_base_0, 1);
	            			  info( "The packet timming unit accum status is:%08X\n",tmp);
	            			  oled_clear(zedboard_oled_params_0.base_address);
	            			sprintf(&menuBuf[0], "%s%10u", "ACCUM:", (tmp));
	            			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	            			  ui_draw();
	            			}
	            else if(strcmp (c,"clrptaccum") == 0) {

				  tmp = set_pkts_pt_accum(packet_time_enforcer_base_0, 0);
				  info( "The packet timming unit accum status is:%08X\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%10u", "ACCUM:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}


	            else if(strcmp (c,"getptaccum") == 0) {

				  tmp = get_pkts_pt_accum(packet_time_enforcer_base_0);
				  info( "The packet timming unit accum status is:%08X\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%10u", "ACCUM:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}

	            else if(strcmp (c,"clrptlock") == 0) {

				  tmp = set_pkts_ptrx_lock(packet_time_enforcer_base_0, 0);
				  info( "The packet timming unit lock status is:%u\n",tmp);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%10u", "LOCK:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}

	            else if(strcmp (c,"getblen") == 0) {

					  tmp = get_stream_blen(eth_to_audio_base_0);
					  info( "The audio rx buff sample count is:%d\n",tmp);
					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%s%d", "RXBOCP:", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
					}
	            else if(strcmp (c,"getbrdly") == 0) {

				  tmp = get_stream_readout_delay(eth_to_audio_base_0);
				  info( "The current audio rx buff readout delay is:%f ms\n",(tmp/SAMPLE_RATE));
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s%d", "BRDLY:", (tmp));
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}

			else if(strcmp (c,"getnetdly") == 0) {

			  tmp = get_stream_net_delay(packet_time_enforcer_base_0);
			  info( "The current audio network delay is:%f ms\n",(tmp/SAMPLE_RATE));
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s%d", "NETDLY:", (tmp));
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

			else if(strcmp (c,"getpktbuilddly") == 0) {

			  tmp = get_stream_pktbuild_delay(packet_time_enforcer_base_0);
			  info( "The current audio pkt build delay is:%f ms\n",(tmp/SAMPLE_RATE));
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s%d", "PKTBUILD:", (tmp));
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}


			else if(strcmp (c,"getpkt2pktdly") == 0) {

					  tmp = get_stream_spkt_delay(packet_time_enforcer_base_0);
					  info( "The current audio pkt to pkt delay is:%f ms\n",(tmp/SAMPLE_RATE));
					  oled_clear(zedboard_oled_params_0.base_address);
					  sprintf(&menuBuf[0], "%s%d", "PKTBUILD:", (tmp));
					  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
					}


			else if(strcmp (c,"getaccpktdly") == 0) {

				  tmp = get_stream_accum_pkt_delay(packet_time_enforcer_base_0);
				  info( "The current audio pkt accum delay is:%f ms\n",(tmp/SAMPLE_RATE));
				  oled_clear(zedboard_oled_params_0.base_address);
				  sprintf(&menuBuf[0], "%s%d", "PKTBUILD:", (tmp));
				  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				}





			else if(strcmp (c,"setnetdly") == 0) {
//				scanf ("%d",&tmp);
				tmp = atoi(strtok(NULL, token));
			  tmp = set_stream_net_delay(packet_time_enforcer_base_0,tmp);
			  info( "The current audio network delay is:%d sample counts\n",(tmp));
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s%d", "NETDLY:", (tmp));
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

			else if(strcmp (c,"setpktdly") == 0) {
//				scanf ("%d",&tmp);
				tmp = atoi(strtok(NULL, token));
			  tmp = set_stream_pktbuild_delay(packet_time_enforcer_base_0, tmp);
			  info( "The current audio pkt build delay is:%d sample clocks\n",(tmp));
			  oled_clear(zedboard_oled_params_0.base_address);
			  sprintf(&menuBuf[0], "%s%d", "PKTBUILD:", (tmp));
			  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}



			else if(strcmp (c,"ptdfon") == 0) {

			  tmp = set_pkts_pt_diff_status(packet_time_enforcer_base_0, 1);
			  info( "The packet timming unit diff status is:%08X\n",tmp);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%u", "ACCUM:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}
			else if(strcmp (c,"ptdfoff") == 0) {

			  tmp = set_pkts_pt_diff_status(packet_time_enforcer_base_0, 0);
			  info( "The packet timming unit diff status is:%08X\n",tmp);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%10u", "ACCUM:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}


			else if(strcmp (c,"getptdiffs") == 0) {

			  tmp = get_pkts_pt_diff_status(packet_time_enforcer_base_0);
			  info( "The packet timming unit diff status is:%08X\n",tmp);
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%u", "ACCUM:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}


			else if(strcmp (c,"setptdiffl") == 0) {//spkt2pkt

//			  scanf ("%d",&tmp);//in milliseconds
			  tmp = atoi(strtok(NULL, token));

			  set_diff_pkt_to_pkt_delay_limit(packet_time_enforcer_base_0,tmp);//just sample clock counts no need to multiply by 2
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "BufferA2Drop:%d", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}

			else if(strcmp (c,"getptdiffl") == 0) {

			  tmp = get_diff_pkt_to_pkt_delay_limit(packet_time_enforcer_base_0);
			  info( "The delayed diff pkt2pkt drop limit is:%d\n",(tmp));
			  info( "The delayed diff pkt2pkt drop limit is:%u ms\n",(tmp/(SAMPLE_RATE)));//just sample clock counts no need to multiply by 2
			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s%u", "PDLM:", (tmp));
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			  ui_draw();
			}


			else if(strcmp (c,"getptdiffv") == 0) {

					  tmp = get_diff_pkt_to_pkt_delay(packet_time_enforcer_base_0);
					  info( "The diff pkt2pkt drop is:%d\n",(tmp));
					  info( "The diff pkt2pkt drop is:%u ms\n",(tmp/(SAMPLE_RATE)));//just sample clock counts no need to multiply by 2
					  oled_clear(zedboard_oled_params_0.base_address);
					sprintf(&menuBuf[0], "%s%u", "PDLM:", (tmp));
					oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
					  ui_draw();
					}

			else if(strcmp (c,"getsqos") == 0)
			{
				  //SET_STATUS("Enter payload length in 24 bit samples:\n");

				  tmp = get_out_exec_state(eth_packet_sequencer_base_0);//in micro seconds
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "OXecS=%d",tmp);
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
			}

			else if(strcmp (c,"getsqis") == 0)
					{
						  //SET_STATUS("Enter payload length in 24 bit samples:\n");

						  tmp = get_in_exec_state(eth_packet_sequencer_base_0);//in micro seconds
						  oled_clear(zedboard_oled_params_0.base_address);
						sprintf(&menuBuf[0], "IXecS=%d",tmp);
						oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
						  ui_draw();
					}

			else if(strcmp (c,"mockf") == 0)
			{

				info( "Enable sync mock udp tx...\n");
						time_sync_tx_en(full_udp_stack_ip_base_0);
						usleep(1000);
						time_sync_mock_en(time_sync_base_0);
				  oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "-MockF-");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				  ui_draw();
				  SET_STATUS("Mock Enabled");
			}
			else if ( strcmp (c, "monitor") == 0){

				info("Start monitoring task...\n");
				monitor = 1;
				oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", "Monitoring on");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
				 }
			else if(strcmp (c,"log_tpx") == 0) {
				unsigned char desc_str[256]={0};
				memset(desc_str, 0, sizeof(desc_str));
						  //SET_STATUS("Enter Dest IP Address (xxx.xxx.xxx.xxx format): ");
						  scanf("%s",log_str);
						  snprintf(desc_str, sizeof(desc_str), "TPX_LOG::%s",log_str);
						write_log_point(desc_str);

					}
		else if ( strcmp (c, "halt") == 0){

				info("Stop monitoring task...\n");
				monitor = 0;

				oled_clear(zedboard_oled_params_0.base_address);

				sprintf(&menuBuf[0], "%s", "Stop Mon");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
				ui_draw();
			}
	      else if (strcmp (c, "help") == 0) {
	        printf("|==================+================================================|\n");
	        printf("|Command           |Description                                     |\n");
	        printf("|==================+================================================|\n");
	        printf("|vol <gain value>  |volume gain for global level					 |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|vll <gain value>  |volume gain for left channel of loopback stream |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|vlr <gain value>  |volume gain for right channel of loopback stream|\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|vnl <gain value>  |volume gain for left channel of network stream  |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|vnr <gain value>  |volume gain for right channel of network stream |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    lfhe/lfhd     |High pass enable/Disable for loopback           |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    lfbe/lfbd     |Band pass enable/Disable for loopback           |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    lfle/lfld     |Low pass enable/Disable for loopback            |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    nfhe/nfhd     |High pass enable/Disable for network            |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    nfbe/nfbd     |Band pass enable/Disable for network            |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    nfle/nfld     |Low pass enable/Disable for network             |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    nstats        |Byte counts and error counts for the network    |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    astatus       |Hardware ADC audio FIFO Status                  |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    dstatus       |Hardware DAC audio FIFO Status                  |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    areset        |Hardware ADC audio FIFO Reset                   |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    reset        |Hardware DAC audio FIFO Reset                   |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    freset        | Resets the udp core and the audio fifos.       |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    preset   		| Resets the packet sequencer  					 |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    creset 		| Resets just the udp core.						 |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    rxrsync 		| Re-syncronise the receive audio chain       	 |\n");
	        printf("|------------------+------------------------------------------------|\n");
			printf("|    strstart      |Start streaming                                 |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strstop       |Stop streaming                                  |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strseleth     |Play ETH stream                                 |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strselarm     |Play ARM stream                                 |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strdip <ip>   |Streaming destination IP                        |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strlip <ip>   |Streaming local IP                              |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strport <port>|Streaming port                                  |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strgip <ip>   |Streaming gateway IP                            |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strmask <ip>  |Streaming netmask IP                            |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strmac <mac>  |Streaming MAC Address                           |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strnsp <sp>   |Streaming net speed                             |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    strplen <len> |Streaming payload packet length                 |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|  strporder <ord> |Set streaming packet sequencer order      |\n");
	        printf("|------------------+------------------------------------------------|\n");
			printf("|    getdip       |Read streaming destination IP                   |\n");
			printf("|------------------+------------------------------------------------|\n");
			printf("|    getlip       |Read streaming local IP                         |\n");
			printf("|------------------+------------------------------------------------|\n");
			printf("|    getport      |Read streaming port                             |\n");
			printf("|------------------+------------------------------------------------|\n");
			printf("|    getgip       |Read streaming gateway IP                       |\n");
			printf("|------------------+------------------------------------------------|\n");
			printf("|    getmask      |Read streaming netmask IP                       |\n");
			printf("|------------------+------------------------------------------------|\n");
			printf("|    getmac       |Read streaming MAC Address                      |\n");
			printf("|------------------+------------------------------------------------|\n");
			printf("|    getnsp       |Read streaming net speed                        |\n");
			printf("|------------------+------------------------------------------------|\n");
			printf("|    getplen      |Read streaming payload packet length            |\n");
			printf("|------------------+------------------------------------------------|\n");
			printf("|    getblen      |Read streaming rx sample buffer length          |\n");
			printf("|------------------+------------------------------------------------|\n");
		    printf("|    getporder    |Read streaming packet sequencer order            |\n");
	        printf("|------------------+------------------------------------------------|\n");
	        printf("|    exit     		|Exit the application				             |\n");
	        printf("|==================+================================================|\n");
	        getchar ();
	        getchar ();
	      }else if ( strcmp (c, "exit") == 0){
	    	  gain = 0;
	    	  globalVol = gain;

			  set_volume (volume_control_base_0, params.vl_lpbk*gain, CHANNEL_ID_L);
			  set_volume (volume_control_base_0, params.vr_lpbk*gain, CHANNEL_ID_R);

			  set_volume (volume_control_base_1, params.vl_net*gain, CHANNEL_ID_L);
			  set_volume (volume_control_base_1, params.vr_net*gain, CHANNEL_ID_R);
			  update_leds();

			  oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "  BYE   ");
			oled_print_message(&menuBuf[0], 0, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[1], "%s-%s-", "Cantavi", "S");
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
			bridge_exit ();
	        SET_STATUS("Shutting down audio.\nClosing app\n");
	        exit(0);
	      }
	      else {
	        SET_STATUS("Invalid Command\n");
	        info("Invalid Command\n");
	        oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "  INVALID  ");
			oled_print_message(&menuBuf[0], 0, zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "  Command  ");
			oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);

	        ui_draw();
	      }

}
//called from logging_on_tx_msg in pjsua_core
void bridge_update_media_port(char * buf, char * type){
	//Contact: <sip:9112@84.209.168.110:5060;ob>
	//m=audio 7813 RTP/AVP
	int dlenstr = strlen(buf);
	int tlenstr = strlen(type);
	char port_str[16];

	if (dlenstr > 0 && tlenstr > 0)
	{
			debug( "*********************************EXTRACT PORT NUMBER********************************");
			char *pfound = strstr(buf, "m=audio"); //pointer to the first character found 'C' in the string saux
				    if (pfound != NULL)
				    {
						char * s_end = pfound + strlen("m=audio");
						if(s_end != NULL){
							char *afound = strstr(s_end, " "); //find position of ' ' in substring
							if(afound != NULL){
								char * port_start = afound + 1;

								char *cfound = strstr(port_start, " "); //find position of ' ' in substring
								if(cfound != NULL){
									//TX 1176 bytes Response msg 200/INVITE/cseq=1048
									char *tfound = strstr(type, "Response msg 200/INVITE");//Response msg 200/INVITE/cseq=799 (rdata0xb4c00e9c)
									char *rfound = strstr(type, "Request msg INVITE");//Request msg INVITE/cseq=16080 (rdata0xb4c0129c)
									if(tfound != NULL || rfound != NULL){
										char * port_end = cfound;//cfound - 1; cuts last digit
										memset(port_str, 0, sizeof(port_str));
										memcpy(port_str, port_start, (port_end-port_start));
										int port = atoi(port_str);
										info( "\n*************************************EXTRACTED IP***********************************\n");
										info( "AUDIO PORT STR:%s  PORT INT:%d", port_str, port);
										info( "\n************************************************************************************\n");
										if(dest_port != port){
											info("----------FIX::Updating last given port from: %d to %d -------------", dest_port, port);
										}

										dest_port = port;
										bridge_set_dest_port(port);

										debug( "\nbridge_update_media_port:From SIP Layer (Do not rely on SIP Switch ACKs)::\n"
													"::Dest address=%s \n"
													 "::udp_port=%d , port used for both sync and audio\n",contact_ip_addr, dest_port);
										print_switch_param(hyb_switch_ip_base_0);

									}else{
										info( "\n*************************This is not an INVITE message**************************\n");
									}
								}else{
									info( "\n*********************************NO ' ' FIELD********************************\n");
								}
							}else{
								info( "*********************************NO ' ' FIELD********************************");
							}
						}else{
							info( "*********************************NO m=audio FIELD********************************");
						}






	    }else{
	    	debug( "*****************THIS SIP MESSAGE HAS NO MEDIA PORT*********************");
	    }
	}

}

//This is a deveiation fron the SIP Protocol it is called from pjsua_core.c logging_on_rx_msg(pjsip_rx_data *rdata)
void bridge_set_contact_ip(char * buf, char * type){
	//Contact: <sip:9112@84.209.168.110:5060;ob>
	int dlenstr = strlen(buf);
	int tlenstr = strlen(type);

	if (dlenstr > 0 && tlenstr > 0)
	{
	    char *pfound = strstr(buf, "Contact: <sip:"); //pointer to the first character found 'C' in the string saux
	    if (pfound != NULL)
	    {
			char * s_end = pfound + strlen("Contact: <sip:");
			if(s_end != NULL){
				char *afound = strstr(s_end, "@"); //find position of @ in substring
				if(afound != NULL){
					char * ip_start = afound + 1;

					char *cfound = strstr(ip_start, ":"); //find position of : in substring
					if(cfound != NULL){
						char *tfound = strstr(type, "Response msg 200/INVITE");//Response msg 200/INVITE/cseq=799 (rdata0xb4c00e9c)
						char *rfound = strstr(type, "Request msg INVITE");//Request msg INVITE/cseq=16080 (rdata0xb4c0129c)
						if(tfound != NULL || rfound != NULL){
							char * ip_end = cfound;//cfound - 1; cuts last digit
							memset(contact_ip_addr, 0, sizeof(contact_ip_addr));
							memcpy(contact_ip_addr, ip_start, (ip_end-ip_start));

							info( "\n*************************************EXTRACTED IP***********************************\n");
							info( "IP:%s", contact_ip_addr);
							info( "\n************************************************************************************\n");

							if(rfound != NULL){
								disable_sync = 1;
//								set_sync_rst(time_sync_base_0);
								info( "\n*************************INCOMING CALL NO SYNC**************************\n");
							}else{
								disable_sync = 0;
//								set_sync_rst(time_sync_base_0);
								info( "\n*************************OUT GOING CALL DO SYNC**************************\n");
							}

						}else{
							info( "\n*************************This is not an INVITE message**************************\n");
						}
					}else{
						info( "\n*********************************NO COLON FIELD********************************\n");
					}
				}else{
					info( "*********************************NO @ FIELD********************************");
				}
			}else{
				info( "*********************************NO CONTACT FIELD********************************");
			}
	    }
	}

}

int bridge_is_timesync_responded(){
	return time_sync_responded_check(time_sync_base_0);
}

int bridge_is_timesync_done(){
	return time_sync_done_check(time_sync_base_0);
}

int bridge_is_timesync_good(){
	return (time_sync_responded_check(time_sync_base_0) || time_sync_done_check(time_sync_base_0));
}


void bridge_reset_net_stack(){
	unsigned buf1 = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	  write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf1|0x80000000);//bit 31
	info( "Stream core reset status was:0x%X\n>",buf1);

	unsigned buf = read_eth_param (hyb_switch_ip_base_0, ETH_CONTROL_REG_ID);
		write_switch_param(hyb_switch_ip_base_0, SW_CONTROL_ID, buf|0x80000000);//bit 31
			info( "Switch core reset status was:0x%X\n>",buf);

	 sleep(2);
	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf1&0x7FFFFFFF);
	info( "Stream core reset status now:0x%X\n>",buf1&0x7FFFFFFF);

	//---------------------------------------------------------------------------------------
		 write_switch_param(hyb_switch_ip_base_0, SW_CONTROL_ID, buf&0x7FFFFFFF);
		info( "Switch core reset status now:0x%X\n>",buf&0x7FFFFFFF);



	oled_clear(zedboard_oled_params_0.base_address);
	sprintf(&menuBuf[0], "%s", "Stream Core Rst");
	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
}
int set_hw_local_net(){
	//-------------------------------------------------------------------------------------
		//
		//  mkfifo("/tmp/myfifo", 0666);
		//  mkfifo("/tmp/axififo", 0666);
		char macAddress[7];
		char ipAddress[4];
		memset(macAddress,0,sizeof(macAddress));


	  //-------------------------------------------------------------------------------------
	  //info( "Setting up UDP Client on server ip_address=%s:: and port=%d\n",argv[1], atoi(argv[2]);
	//  sprintf(saddr.ip, argv[1]);

	//  sprintf(local_mac, argv[1]);
	//  sprintf(local_ip, argv[2]);
	//  sprintf(gateway_ip, argv[4]);
	//  sprintf(mask_ip, argv[5]);
		  memset(gateway_ip, 0, sizeof(gateway_ip));
	  if (getGateway(gateway_ip) == 0){
		  info( "Got gateway address:: %s\n",gateway_ip);
	  }else{
		  error("Failed to get gateway address, exiting, run dhclient manually: exiting!!\n");
		  return (-1);
	  }

	  memset(macAddress, 0, sizeof(macAddress));
	  if(getMacAddress(macAddress) == 0){
		  info( "Got MAC Address:: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
	  }else{
		  error("Failed to get mac address, exiting, run ifconfig: exiting!!\n");
		  return (-2);
	  }
	  memset(mask_ip, 0, sizeof(mask_ip));
	  if(getNetMask(mask_ip) ==0){
		  info( "Got address mask:: %s\n",mask_ip);
	  }else{
		  error("Failed to get address mask, exiting, run dhclient manually: exiting!!\n");
		  return (-3);
	  }


	  if(getLocalIP(local_ip) == 0){
		  info( "Got local ip address:: %s\n",local_ip);
		  extractIpAddress(local_ip,&ipAddress[0]);
		  info( "Extracted Local Ip Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
		  write_eth_param(full_udp_stack_ip_base_0, LOCAL_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));
	  }else{
		  error( "Failed to get gateway address, exiting, run dhclient manually: exiting!!\n");
		  return (-4);
	  }

	  memset(public_ip, 0, sizeof(public_ip));
	  if(getPublicIP(public_ip) == 0){
		  //Becareful here, getting the address is simple, but the use of the address depends on us knowing the NAT strategy of the router

//	  		  info( "Got public ip address:: %s\n",public_ip);
		  info( "\nPublic Ip Address: %03d. %03d. %03d. %03d\n",public_ip[0],public_ip[1],public_ip[2],public_ip[3]);
//		  write_eth_param(full_udp_stack_ip_base_0, LOCAL_IP_ID, (public_ip[0]<<24)|(public_ip[1]<<16)|(public_ip[2]<<8)|(public_ip[3]);

		  info( "----------------------------We will use the local to keep the router happy----------------\n");
	  }else{
		  error("Failed to get public address, exiting, check your internet connection: exiting!!\n");
		  exit(-5);
	  }


	  //extractMacAddress(local_mac,&macAddress[0]);
	  		info( "\nMac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
	  		//write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, ((macAddress[0]<<40)|(macAddress[1]<<32)|macAddress[2]<<24)|(macAddress[3]<<16)|(macAddress[4]<<8)|(macAddress[5]);
	  		write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, &macAddress[0]);

//	  		extractIpAddress(local_ip,&ipAddress[0]);
//	  		info( "\nLocal Ip Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
//	  		write_eth_param(full_udp_stack_ip_base_0, LOCAL_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]);

//	  		extractIpAddress(public_ip,&ipAddress[0]);
//			info( "\nPublic Ip Address: %03d. %03d. %03d. %03d\n",public_ip[0],public_ip[1],public_ip[2],public_ip[3]);
//			write_eth_param(full_udp_stack_ip_base_0, LOCAL_IP_ID, (public_ip[0]<<24)|(public_ip[1]<<16)|(public_ip[2]<<8)|(public_ip[3]);



	  		extractIpAddress(dest_ip,&ipAddress[0]);
	  		info( "\nDest Ip Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
	  		write_eth_param(full_udp_stack_ip_base_0, DEST_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));


	  		extractIpAddress(mask_ip,&ipAddress[0]);
	  		info( "\nMask Ip Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
	  		write_eth_param(full_udp_stack_ip_base_0, MASK_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));

	  		extractIpAddress(gateway_ip,&ipAddress[0]);
	  		info( "\nGateway Ip Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
	  		write_eth_param(full_udp_stack_ip_base_0, GTWAY_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));


	  		set_stream_plen(audio_to_eth_base_0, (12+(4*48)) + 2);//2 bytes for src and typ

	  		reset_adc_fifos(audio_to_eth_base_0);
	  	    reset_dac_fifos(eth_to_audio_base_0);

	  		oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "HW Net: Init");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

			return 0;

}



int bridge_set_hw_dest_net(char * dest_ip, int dst_port){

	info( "\nbridge_set_hw_dest_net(char * dest_ip, int dest_port):From SIP Layer::\n"
			"::Contact Addr=%s \n Dest address=%s \n"
			 "::udp_port=%d , port used for both sync and audio\n", dest_ip,contact_ip_addr, dst_port);

//		fire_up_mock_thread(contact_ip_addr, dest_port, &firewall_mock_thread);


		write_switch_param(hyb_switch_ip_base_0, PORT1_ID, dst_port);
//		write_switch_param(hyb_switch_ip_base_0, PORT2_ID, sync_port);

		write_eth_param(full_udp_stack_ip_base_0, DEST_PORT_ID, dst_port);
//			write_eth_param(full_udp_stack_ip_base_0, SYNC_PORT_ID, sync_port);

		// set the sync port in our one port strategy to keep SIP happy
		write_eth_param(full_udp_stack_ip_base_0, SYNC_PORT_ID, dst_port);

		dest_port = dst_port;

//		bridge_set_dest_ip(dest_ip);
		bridge_set_dest_ip(contact_ip_addr);
//		run_arping("eth1", dest_ip, ARP1_ID);//now run in bridge_set_dest_ip(dest_ip);

		print_switch_param(hyb_switch_ip_base_0);

		oled_clear(zedboard_oled_params_0.base_address);
				sprintf(&menuBuf[0], "%s", "Dest Net: Set");
				oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

				return 0;

}


//Called fromm pjsua_acc.c
  void bridge_update_public_ip(char * via_addr_buf){
	char ipAddress[4];
	char my_new_ip_addr[PJ_INET6_ADDRSTRLEN+10];

	char *ip_end = strstr(via_addr_buf, ":"); //find position of @ in substring
	if(ip_end > 0){
		memset(my_new_ip_addr, 0, sizeof(my_new_ip_addr));
		memcpy(my_new_ip_addr, via_addr_buf, (ip_end-via_addr_buf));



		extractIpAddress(my_new_ip_addr,&ipAddress[0]);
		info( "\n*******************NOT UPDATING LOCAL IP CAUSES ROUTER AND FIREWALL PROBLEMS******************\n");
		info( "\nbridge_update_local_ip(char * via_addr_buf):New Local Ip Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
		//write_eth_param(full_udp_stack_ip_base_0, DEST_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]);

	//	info( "\nUpdate Local Ip Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
//		write_eth_param(full_udp_stack_ip_base_0, LOCAL_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]);
		info( "\n*******************************************************************************************\n");
	}else{
		error("\n************************COULD NOT UPDATE LOCAL IP***********************************\n");
	}
}


  void bridge_set_local_ip(char * ip){
  	char ipAddress[4];



  	extractIpAddress(ip,&ipAddress[0]);
  	info( "\nbridge_set_local_ip(char * ip):Local Ip Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
  	//write_eth_param(full_udp_stack_ip_base_0, DEST_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]);

  //	info( "\nUpdate Local Ip Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
  	write_eth_param(full_udp_stack_ip_base_0, LOCAL_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));


  }


void bridge_set_dest_ip(char * ip){
	char ipAddress[4];
	extractIpAddress(ip,&ipAddress[0]);
    info( "\nbridge_set_dest_ip(char * ip):Dest Ip Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
    write_eth_param(full_udp_stack_ip_base_0, DEST_IP_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));
    //Check if local of public

    if(check_ip_net(ip, gateway_ip) == 1){//local IP
    	info( "This is a local LAN IP run ARPING....");
    	run_arping("eth1", ip, ARP1_ID);//also writes to ARP Table in the FPGA
    }else{//public so it just needs the gateway
    	//read router MAC from ARP cache
    	info( "This is a public IP take gateway....");
    	update_arp_table(ip,gateway_ip);
//    	info( "\nARP response Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
//		write_eth_param(full_udp_stack_ip_base_0, ARP1_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]);
//
//
//		info( "\nARP response Mac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",arp_resp->sender_mac[0],arp_resp->sender_mac[1],arp_resp->sender_mac[2],arp_resp->sender_mac[3],arp_resp->sender_mac[4],arp_resp->sender_mac[5]);
//		//write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, ((arp_resp->sender_mac[0]<<40)|(arp_resp->sender_mac[1]<<32)|arp_resp->sender_mac[2]<<24)|(arp_resp->sender_mac[3]<<16)|(arp_resp->sender_mac[4]<<8)|(arp_resp->sender_mac[5]);
//		write_eth_mac(full_udp_stack_ip_base_0, ARP1_ID, &arp_resp->sender_mac[0]);

    }


}

void bridge_set_dest_port(int port){
	write_switch_param(hyb_switch_ip_base_0, PORT1_ID, port);
	//		write_switch_param(hyb_switch_ip_base_0, PORT2_ID, sync_port);

			write_eth_param(full_udp_stack_ip_base_0, DEST_PORT_ID, port);
	//			write_eth_param(full_udp_stack_ip_base_0, SYNC_PORT_ID, sync_port);
}

void bridge_set_sync_port(int port){
	info( "bridge_set_sync_port(int port): Enable time sync...\n");
//	write_switch_param(hyb_switch_ip_base_0, PORT1_ID, dest_port);
	write_switch_param(hyb_switch_ip_base_0, PORT2_ID, port);

//	write_eth_param(full_udp_stack_ip_base_0, DEST_PORT_ID, port);
	write_eth_param(full_udp_stack_ip_base_0, SYNC_PORT_ID, port);
}


void check_eregs(){
	char cmd[64];
	memset(cmd, 0, sizeof(cmd));
	info( "---------------------Read switch debug registers------------------------------\n");
	sprintf(cmd,"%s","getsreg 35");
	bridge_run_command(cmd);
	sleep(1);
	sprintf(cmd,"%s","getsreg 36");
		bridge_run_command(cmd);
	sleep(1);
	sprintf(cmd,"%s","getsreg 37");
		bridge_run_command(cmd);
	sleep(1);
	sprintf(cmd,"%s","getsreg 38");
		bridge_run_command(cmd);
	sleep(1);
	info( "-------------------------Read eth debug registers----------------------------\n");
	sprintf(cmd,"%s","getereg 35");//0x23
		bridge_run_command(cmd);
	sleep(1);
	sprintf(cmd,"%s","getereg 36");//0x24
			bridge_run_command(cmd);
	sleep(1);
	sprintf(cmd,"%s","getereg 37");//0x25
			bridge_run_command(cmd);
	sleep(1);
	sprintf(cmd,"%s","getereg 38");//0x26
			bridge_run_command(cmd);
	sleep(1);
	sprintf(cmd,"%s","getereg 39");//0x27
			bridge_run_command(cmd);
	info( "--------------------------------------------------------------------------\n");

}

int bridge_sync_cycle(){
	time_sync_tx_en(full_udp_stack_ip_base_0);
	set_sync_cycle(time_sync_base_0);
//	if(time_sync_done_check(time_sync_base_0)){//Linux is much faster than the network
//		info( "Time variables good....\n");
//	}else{
//		info( "Sync attempt failed....\n");
//	}
}

int init_hw_sync(){

	if(disable_sync == 0){
		info( "init_hw_sync():Enable time sync...\n");
		int sync_retry = 0;
		deinit_hw_sync();
		while((time_sync_done_check(time_sync_base_0)== 0) && (sync_retry < 10)){
			deinit_hw_sync();
			info( "Enable time sync udp tx...\n");
			time_sync_tx_en(full_udp_stack_ip_base_0);
			usleep(1000);
			info( "Trigger time sync udp tx...\n");
			time_sync_en(time_sync_base_0);
			sleep(2);


//			check_eregs();
			++sync_retry;
		}

		if(time_sync_done_check(time_sync_base_0) == 0){
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "TSync: Failed");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			info( "init_hw_sync():TSync: Failed: retried: %d\n", sync_retry);
			return -1;
		}else{
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s", "TSync:Success");
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
			info( "init_hw_sync():TSync:Success retried: %d\n", sync_retry);
			return 0;
		}
	}else{
		info( "init_hw_sync(): Incoming call no sync just mock to punch fire wall...\n");
		set_sync_rst(time_sync_base_0);
		info( "Enable sync mock udp tx...\n");
		time_sync_tx_en(full_udp_stack_ip_base_0);
		usleep(1000);
		time_sync_mock_en(time_sync_base_0);
		return 0;
	}

//	return time_sync_check(time_sync_base_0) ? 0 : -1;//success==0
}


int deinit_hw_sync(){
	info( "deinit_hw_sync():Disable time sync...\n");
	set_sync_rst(time_sync_base_0);
	time_sync_tx_off(full_udp_stack_ip_base_0);
	time_sync_off(time_sync_base_0);


	oled_clear(zedboard_oled_params_0.base_address);
	sprintf(&menuBuf[0], "%s", "De-init HW");
	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
//	bridge_is_timesync_good();
	return 0;//success
}

int start_hw_streaming(){
	int i = 0;
//	nargs.sdelay = 2;//reduce mock sleep so that we increase the port chances
	if(disable_sync == 1){
		info( "Incoming call wait for sync, mock to punch fire wall...\n");
		info( "Enable sync mock udp tx...\n");
		set_sync_rst(time_sync_base_0);
		time_sync_tx_en(full_udp_stack_ip_base_0);
		usleep(1000);
		time_sync_mock_en(time_sync_base_0);
//		return 0;
	}


	info( "-----------Entering sync wait loop------------\n");
	while(((time_sync_done_check(time_sync_base_0)== 0) && (time_sync_responded_check(time_sync_base_0)== 0)) && (i < 40)){

		sleep(1);
		if(disable_sync == 0){
			info( "--------Waiting for sync done signal: counter = %d ---------\n", i);
		}else{
			info( "--------Waiting for sync packet to arrive: counter = %d ----\n", i);
		}

		//check_eregs();

		i++;
	}
	info( "-----------Sync must be good, now double checking------------\n");

//	nargs.sdelay = 10;
	if(time_sync_done_check(time_sync_base_0) > 0){
		info("*************************************SYNC GOOD**********************************");
		info( "-----------Sync done signal good------------\n");
	}else if(time_sync_responded_check(time_sync_base_0) > 0){
		info( "-----------Sync response sent: turn mocker off------------\n");
		time_sync_mock_off(time_sync_base_0);
		usleep(5000);
		time_sync_tx_off(full_udp_stack_ip_base_0);
	}else{
		info( "-----------SYNC FAILED TIMEOUT waiting: counter = %d------------\n", i);
	}
//	sleep(1);


	unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);

	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|0x02);
	buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
//		info( "Reg0: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//						  BYTE_TO_BINARY(buf>>24),BYTE_TO_BINARY(buf>>16),BYTE_TO_BINARY(buf>>8), BYTE_TO_BINARY(buf);



	info( "Enable Audio payload generation\n");
	set_stream_send_on(audio_to_eth_base_0);
	usleep(200);
	reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right

	info("*************************************STREAM STARTED**********************************");
	info( "start_hw_streaming():Stream tx started status was:0x%X\n>",buf);
	oled_clear(zedboard_oled_params_0.base_address);
	sprintf(&menuBuf[0], "%s", "Stream: ON");
	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

	set_media_channel_timeout_count(eth_to_audio_base_0, SAMPLE_RATE * 1000);//48000 is 1 second at 48kHz
	enable_media_channel_monitoring(eth_to_audio_base_0);

//	init_incall_timed_task_handler();// In the SIP UA layer

	return 0;
}

int stop_hw_streaming(){


	info( "Disable Audio payload generation \n");
	set_stream_send_off(audio_to_eth_base_0);

	info( "ADC audio FIFOs Reset\n");
	reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right

	info( "Disable time sync...\n");
	time_sync_tx_off(full_udp_stack_ip_base_0);
	info( "Reset time sync...\n");
	set_sync_rst(time_sync_base_0);

	unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);


  write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFD);
  bridge_reset_net_stack();
  oled_clear(zedboard_oled_params_0.base_address);
  sprintf(&menuBuf[0], "%s", "Stream: OFF");
  oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
  buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
  info("*************************************STREAM STOPPED**********************************");
  info( "stop_hw_streaming():Stream tx stopped status was:0x%X\n>",buf);

  disable_sync = 0;
//  disable_media_channel_monitoring(eth_to_audio_base_0);
//  deinit_incall_timed_task_handler(); in the SIP UA layer now
  signal(SIGALRM, SIG_IGN);          /* ignore this signal       */
	return 0;
}


void bridge_reinit(){
	bridge_exit ();
	 bridge_init ();
}


void bridge_version(){
	bridge_run_command("bver");
	bridge_run_command("cver");
	info( "SIP Layer version is : %s\n", SIP_LAYER_VERSION);
}


int init_hw_ctrl(){

	filter_coefficients coefficients;
	  unsigned int filter_coefficients[15] = { 0x00002CB6, 0x0000596C, 0x00002CB6, 0x8097A63A, 0x3F690C9D, \
	                                           0x074D9236, 0x00000000, 0xF8B26DCA, 0x9464B81B, 0x3164DB93, \
	                                           0x12BEC333, 0xDA82799A, 0x12BEC333, 0x00000000, 0x0AFB0CCC };

	  for (int i = 0; i < 15; i++) {
	    coefficients.coefficients[i] = filter_coefficients[i];
	  }

	  info( "Setting filter 0 coefficients..\n");
	  if (set_coefficients (filter_control_base_0, coefficients) != 0) {
		  error( "set_coefficients\n");
	  }

	  info( "Setting filter 0 coefficients..\n");
	  if (set_coefficients (filter_control_base_1, coefficients) != 0) {
		  error("set_coefficients\n");
	  }

	  info( "Updating params ...\n");
	  		params.vl_lpbk = 30;
	  		params.v_global = 12;
	  		globalVol = 12;
	  		params.vr_lpbk = 30;
	  		params.vl_net  = 30;
	  		params.vr_net  = 30;

	  info( "Setting default Chan 0 L volume to 30..\n");
		set_volume (volume_control_base_0, params.vl_lpbk*globalVol, CHANNEL_ID_L);
		info( "Setting default Chan 0 R volume to 30..\n");
		set_volume (volume_control_base_0, params.vr_lpbk*globalVol, CHANNEL_ID_R);
		info( "Setting default Chan 1 L volume to 30..\n");
		set_volume (volume_control_base_1, params.vl_net*globalVol, CHANNEL_ID_L);
		info( "Setting default Chan 1 R volume to 30..\n");
		set_volume (volume_control_base_1, params.vr_net*globalVol, CHANNEL_ID_R);



	info( "Disable time sync...\n");
//	set_sync_off(audio_to_eth_base_0);
	set_stream_send_off(audio_to_eth_base_0);



	info( "Disable tx ...\n");
	unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFD);


	bridge_reset_net_stack();

	printf("Enable dropped channel monitoring...\n");
    enable_media_channel_monitoring(eth_to_audio_base_0);

}




/**
 * =======================================================
 * ui_init initialize the user interface
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int bridge_init () {

	info( "Initializing Cantavi Teleporter HW layer!!!\n");

	if(hw_nodes_init() < 0){
		error("Failed to initialize hardware nodes: exiting!!\n");
			  exit(-1);
	}


	init_codec();
	init_gpios();
	int ret = set_hw_local_net();
	if(ret < 0){
		error("Failed to initialize hardware nodes: exiting!!\n");
			  exit(ret);
	}



//Not necessary any more SIP takes care of this
	//set_hw_dest_net("192.168.1.3", "1234");// ip, port, just defaults SIP should take care of this during establishing calls


//  	  info( "Set local address=%s "
//  			  "::\n dest address=%s "
//  			  "::\n gateway address=%s "
//  			  "::\n mask address=%s "
//  			  "::\n udp_port=%d "
//  			  "::\n sync_port=%d \n",local_ip, dest_ip, gateway_ip, mask_ip, dest_port, sync_port);

  	init_hw_ctrl();



  	oled_clear(zedboard_oled_params_0.base_address);
	sprintf(&menuBuf[0], "%s", "Ready...");
	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

	info( "HW layer Init done ...\n");
  return 0;
}


int bridge_get_playout_delay(){
	int tmp = get_playout_delay(eth_to_audio_base_0);
	info( "The current audio playout delay is:%d samples\n",(tmp));
	info( "The current audio playout delay is:%f ms\n",(tmp/SAMPLE_RATE));
	oled_clear(zedboard_oled_params_0.base_address);
	sprintf(&menuBuf[0], "%d samples", (tmp));
	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	sprintf(&menuBuf[0], "%d ms", (tmp/SAMPLE_RATE));
	oled_print_message(&menuBuf[0], 2, zedboard_oled_params_0.base_address);
	return tmp/SAMPLE_RATE;
}


void bridge_set_playout_delay(int delay){
	set_playout_delay(eth_to_audio_base_0, delay*SAMPLE_RATE);
//	set_playout_delay(eth_to_audio_base_0,tmp*SAMPLE_RATE);
	oled_clear(zedboard_oled_params_0.base_address);
	sprintf(&menuBuf[0], "%s:%5d", "POUDLY", (delay));
	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
}

void bridge_reset_rx_chain(){
	unsigned buf = read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID);
	 write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf|2);
	 sleep(1);
	write_eth_param(full_udp_stack_ip_base_0, ETH_CONTROL_ID, buf&0xFFFFFFFD);
	printf("Stream core reset status was:0x%X\n>",buf);

	reset_pkt_seq(eth_packet_sequencer_base_0);

printf("PLC Pkt seq Reset\n>");
///reset_pkt_time_enf(packet_time_enforcer_base_0);


//printf("Pkt timing unit reset\n>");
	  reset_adc_fifos(audio_to_eth_base_0);//LSB is left, MSB is Right
	  printf("ADC audio FIFOs Reset\n");
	  reset_dac_fifos(eth_to_audio_base_0);//LSB is left, MSB is Right
	  printf("DAC audio FIFOs Reset\n>");


	 oled_clear(zedboard_oled_params_0.base_address);
	sprintf(&menuBuf[0], "%s", "Full Stream Rst");
	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
	ui_draw();
}

void bridge_get_tc_vars(){
	unsigned long tmp, tmp1, tmp2, tmp3;
	//SET_STATUS("Enter payload length in 24 bit samples:\n");
	//UDP header is 8 bytes

	tmp =  get_rx_time_code(eth_to_audio_base_0);
	info( "The current audio rxtc is:%0.3f ms\n",(tmp/SAMPLE_RATE));
	tmp = get_rx_time_code_fout(eth_to_audio_base_0);
	info( "The current audio rxtcfout is:%0.3f ms\n",(tmp/SAMPLE_RATE));
	tmp1 =  get_rx_time_code_eff(eth_to_audio_base_0);
	info( "The current audio rxtceff is:%0.3f ms\n",(tmp1/SAMPLE_RATE));
	tmp2 = get_playout_delay(eth_to_audio_base_0);
	info( "The current audio playout delay is: %0.3f\n-----------------------------\n",(tmp2/SAMPLE_RATE));
	info( "The current audio sched playout time is: %0.3f\n",((tmp1+tmp2)/SAMPLE_RATE));
	tmp = get_sync_time(eth_to_audio_base_0);
	info( "The current audio sync time is:%0.3f ms\n",(tmp/SAMPLE_RATE));
	tmp = get_instant_playout_time(eth_to_audio_base_0);
	info( "The current audio playout time is:%0.3f ms\n",(tmp/SAMPLE_RATE));
	tmp = get_dac_ofifo_occ(eth_to_audio_base_0);
	info( "The current odd audio buf sample count is:%d samples\n",(tmp));
	tmp = get_dac_efifo_occ(eth_to_audio_base_0);
	info( "The current even audio buf sample count is:%d samples\n",(tmp));


	//			tmp =  get_rx_time_code_occ(eth_to_audio_base_0);
	//			info( "The current audio rxtc occ is:%d\n",(tmp));

	oled_clear(zedboard_oled_params_0.base_address);
	sprintf(&menuBuf[0], "tsyncvars");
	oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
}




int bridge_get_vol(){
	info("VOLUME STATUS: GLOBAL=%d, NETLEFT=%d, NETRIGHT=%d, LOCALLEFT=%d, LOCALRIGHT=%d",
		            				params.v_global, params.vl_net, params.vr_net, params.vl_lpbk, params.vr_lpbk);
	return params.v_global;
}

void bridge_adjust_vol(float mul){
				int gain = (int)mul;
	            params.v_global = gain;
	            globalVol = gain;

	            set_volume (volume_control_base_0, params.vl_lpbk*gain, CHANNEL_ID_L);
	            set_volume (volume_control_base_0, params.vr_lpbk*gain, CHANNEL_ID_R);

	            set_volume (volume_control_base_1, params.vl_net*gain, CHANNEL_ID_L);
	            set_volume (volume_control_base_1, params.vr_net*gain, CHANNEL_ID_R);
	            oled_clear(zedboard_oled_params_0.base_address);
	            sprintf(&menuBuf[0], "%s", "Vol: ADJ");

	            		info("VOLUME STATUS: GLOBAL=%d, NETLEFT=%d, NETRIGHT=%d, LOCALLEFT=%d, LOCALRIGHT=%d",
	            				params.v_global, params.vl_net, params.vr_net, params.vl_lpbk, params.vr_lpbk);

	            		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

}

void init_gpios(){
	info( "Initializing Cantavi Teleporter GPIOs!!!\n");
	exportfd = open("/sys/class/gpio/export", O_WRONLY);
	if (exportfd < 0)
	{
		error("Cannot open GPIO to export it\n");
		exit(1);
	}
	write(exportfd, "928", 4);
	write(exportfd, "929", 4);
	write(exportfd, "930", 4);
	write(exportfd, "931", 4);
	write(exportfd, "932", 4);
	write(exportfd, "933", 4);
	write(exportfd, "934", 4);
	write(exportfd, "935", 4);
	close(exportfd);
	info( "GPIO exported successfully\n");
	directionfd = open("/sys/class/gpio/gpio928/direction", O_RDWR);
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio929/direction", O_RDWR);
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio930/direction", O_RDWR);
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio931/direction", O_RDWR);
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio932/direction", O_RDWR);
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio933/direction", O_RDWR);
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio934/direction", O_RDWR);
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio935/direction", O_RDWR);
	write(directionfd, "out", 4);
	close(directionfd);
	info( "GPIO direction set as output successfully\n");
	GPIO_LED_0 = open("/sys/class/gpio/gpio928/value", O_RDWR);
	GPIO_LED_1 = open("/sys/class/gpio/gpio929/value", O_RDWR);
	GPIO_LED_2 = open("/sys/class/gpio/gpio930/value", O_RDWR);
	GPIO_LED_3 = open("/sys/class/gpio/gpio931/value", O_RDWR);
	GPIO_LED_4 = open("/sys/class/gpio/gpio932/value", O_RDWR);
	GPIO_LED_5 = open("/sys/class/gpio/gpio933/value", O_RDWR);
	GPIO_LED_6 = open("/sys/class/gpio/gpio934/value", O_RDWR);
	GPIO_LED_7 = open("/sys/class/gpio/gpio935/value", O_RDWR);
}

/**
 * =======================================================
 * ui_run starts the user interface
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int ui_run () {
	int r = 0;
	//--------------------------------------------------------------------------------



//  r = pthread_create(&axi_to_net_mq_reader_thread, NULL, axi_to_net_mq_reader, NULL);
//  	if (r != 0)
//  	{
//  		pjsua_perror(THIS_FILE,  "Error - pthread_create() audio_reader_thread return code: %d\n", r, -4);
//  		return -1;
//  	}
//
//r = pthread_create(&axi_to_net_mq_writer_thread, NULL, axi_to_net_mq_writer, NULL);
//	if (r != 0)
//	{
//		pjsua_perror(THIS_FILE,  "Error - pthread_create() network_reader_stream_thread return code: %d\n", r, -4);
//		return -1;
//	}
//
//	r = pthread_create(&net_to_axi_mq_reader_thread, NULL, net_to_axi_mq_reader, NULL);
//	if (r != 0)
//	{
//		pjsua_perror(THIS_FILE,  "Error - pthread_create() network_writer_stream_thread return code: %d\n", r, -4);
//		return -1;
//	}
//
//	r = pthread_create(&net_to_axi_mq_writer_thread, NULL, net_to_axi_mq_writer, NULL);
//	if (r != 0)
//	{
//		pjsua_perror(THIS_FILE,  "Error - pthread_create() audio_to_network_thread return code: %d\n", r, -4);
//		return -1;
//	}

	r= pthread_create (&ui_input_reader_thread, NULL, ui_input_reader, NULL);
	  if (r != 0) {
		  error("ui_init : pthread_create(&ui_input_reader_thread) code:%d",r);
	    return -1;
	  }
/*
  if (pthread_create (&ui_draw_thread, NULL, ui_draw, NULL) != 0) {
    pjsua_perror(THIS_FILE,  "ui_init : pthread_create(&ui_draw_thread)", -4);
    return -1;
  }

  if`dd (pthread_join(ui_draw_thread, NULL) != 0) {
    pjsua_perror(THIS_FILE,  "pthread_join(ui_draw_thread)", -4);
    return -1;
  }
*/
//  if (pthread_join(loopback_thread, NULL) != 0) {
//    pjsua_perror(THIS_FILE,  "pthread_join(loopback_thread)");
//    return -1;
//  }

//	if (pthread_join(net_to_axi_mq_writer_thread, NULL) != 0) {
//		perror ("pthread_join(audio_reader_thread)");
//		return -1;
//	  }
//
//	if (pthread_join(net_to_axi_mq_reader_thread, NULL) != 0) {
//		perror ("pthread_join(audio_to_network_thread)");
//		return -1;
//	  }
//
//
//  if (pthread_join(axi_to_net_mq_writer_thread, NULL) != 0) {
//    perror ("pthread_join(axi_to_net_mq_writer_thread)");
//    return -1;
//  }
//
//  if (pthread_join(axi_to_net_mq_reader_thread, NULL) != 0) {
//    perror ("pthread_join(axi_to_net_mq_reader_thread)");
//    return -1;
//  }

  if (pthread_join(ui_input_reader_thread, NULL) != 0) {
	  error("(pthread_join(ui_input_reader_thread)");
    return -1;
  }

//  if (pthread_join(pmod_thread, NULL) != 0) {
//	    perror ("(pthread_join(pmod_thread)");
//	    return -1;
//  }



  return 0;
}


void update_leds(){
	if (globalVol >= 16)
		write(GPIO_LED_0, "1", 2);
	else
		write(GPIO_LED_0, "0", 2);

	if (globalVol >= 14)
		write(GPIO_LED_1, "1", 2);
	else
		write(GPIO_LED_1, "0", 2);

	if (globalVol >= 12)
		write(GPIO_LED_2, "1", 2);
	else
		write(GPIO_LED_2, "0", 2);

	if (globalVol >= 10)
		write(GPIO_LED_3, "1", 2);
	else
		write(GPIO_LED_3, "0", 2);

	if (globalVol >= 8)
		write(GPIO_LED_4, "1", 2);
	else
		write(GPIO_LED_4, "0", 2);

	if (globalVol >= 6)
		write(GPIO_LED_5, "1", 2);
	else
		write(GPIO_LED_5, "0", 2);

	if (globalVol >= 4)
		write(GPIO_LED_6, "1", 2);
	else
		write(GPIO_LED_6, "0", 2);

	if (globalVol >= 2)
		write(GPIO_LED_7, "1", 2);
	else
		write(GPIO_LED_7, "0", 2);
}

//void *send_audio_function(void *arg)
//{
//	short int buf[512];
//	int fd;
//	int IRQEnable = 1;
//	int i;
//	write(axi_to_audio_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable);
//	info( "audio sample Interrupt Enabled\n");
//	if ((fd = open("/tmp/myfifo", O_RDONLY)) < 1)
//		info( "fifo read open error");
//	else
//		info( "FIFO READ open\n");
//
//	while (1)
//	{
//		read(fd, buf, 1024);
//		for (i = 0; i < 512; i++)//write the data and trigger an int for every write
//		{
//			read(axi_to_audio_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable);
//			IRQEnable = 1;
//			write(axi_to_audio_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable);
////			AXI_TO_AUDIO_REG_0 = (int)buf[i];
//			axi_to_audio_params_0.base_address = (int)buf[i];
//		}
//	}
//}

//void *pmod_function(void *arg)
//{
//	int position = 0;
//	int IRQEnable = 1;
//	int pmodData, i, j;
//	static int prevPmodData = A | B;
//	write(pmod_controller_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable);
//	info( " Pmod Interrupt Enabled\n");
//
//	while (1)
//	{
//		read(pmod_controller_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable);
////		pmodData = PMOD_REG_3;
//		pmodData = *((unsigned *)(pmod_controller_params_0.base_address + PMOD_INTERFACE_REG3_OFFSET);
//
//		if (pmodData & BUTTON){
////			menuSelect = 1;
//			oled_clear(zedboard_oled_params_0.base_address);
//
//			for (i = 0; i < 4; i++)
//			{
//				if (i == cursorPos){
//					menuBuf[0] = 45;
//				}
//				else{
//					menuBuf[0] = 0;//32;
//				}
//				sprintf(&menuBuf[1], "%s%3d", menuitem[menuPos + i], setting[menuPos + i]);
//				oled_print_message(&menuBuf[0], i, zedboard_oled_params_0.base_address);
//			}
//
//			menuSelect = 0;
//			oled_clear(zedboard_oled_params_0.base_address);
//			for (i = 0; i < 4; i++)
//			{
//				if (i == cursorPos)
//					menuBuf[0] = 45;
//				else
//					menuBuf[0] = 0;//32;
//				sprintf(&menuBuf[1], "%s%3d", menuitem[menuPos + i], setting[menuPos + i]);
//				oled_print_message(&menuBuf[0], i, zedboard_oled_params_0.base_address);
//			}
//
//
//			while (!menuSelect)
//			{
//				if (menuUp)
//				{
//					menuUp = 0;
//					if (setting[menuPos + cursorPos] < settingRange[menuPos + cursorPos])
//						setting[menuPos + cursorPos]++;
//
//					oled_clear(zedboard_oled_params_0.base_address);
//					for (i = 0; i < 4; i++)
//					{
//						if (i == cursorPos)
//							menuBuf[0] = 45;
//						else
//							menuBuf[0] = 0;//32;
//						sprintf(&menuBuf[1], "%s%3d", menuitem[menuPos + i], setting[menuPos + i]);
//						oled_print_message(&menuBuf[0], i, zedboard_oled_params_0.base_address);
//					}
//					//network
////					VOLUME_1_REG_0  = 32 * globalVol * setting[3];
////					VOLUME_1_REG_1  = 32 * globalVol * setting[2];
//					params.vl_net = setting[3];
//					params.vr_net = setting[2];
//					set_volume (volume_control_base_1, params.vl_net*globalVol, CHANNEL_ID_L);
//					set_volume (volume_control_base_1, params.vr_net*globalVol, CHANNEL_ID_R);
//
//
//
//					//FILTER_1_REG_17 = setting[9];
//					set_filter_type (filter_control_base_1, FILTER_HIGH_PASS, setting[9]);
//					params.filter_h_net = setting[9];
////					FILTER_1_REG_18 = setting[8];
//					set_filter_type (filter_control_base_1, FILTER_BAND_PASS, setting[8]);
//					params.filter_b_net = setting[8];
////					FILTER_1_REG_19 = setting[7];
//					set_filter_type (filter_control_base_1, FILTER_LOW_PASS, setting[7]);
//					params.filter_l_net = setting[7];
//
//					//line in
////					VOLUME_0_REG_0  = 32 * globalVol * setting[1];
////					VOLUME_0_REG_1  = 32 * globalVol * setting[0];
//					params.vl_lpbk = setting[1];
//					params.vr_lpbk = setting[0];
//					set_volume (volume_control_base_1, params.vl_lpbk*globalVol, CHANNEL_ID_L);
//					set_volume (volume_control_base_1, params.vr_lpbk*globalVol, CHANNEL_ID_R);
//
////					FILTER_0_REG_17 = setting[6];
//					set_filter_type (filter_control_base_0, FILTER_HIGH_PASS, setting[6]);
//					params.filter_h_lpbk = setting[6];
////					FILTER_0_REG_18 = setting[5];
//					set_filter_type (filter_control_base_0, FILTER_BAND_PASS, setting[5]);
//					params.filter_b_lpbk = setting[5];
////					FILTER_0_REG_19 = setting[4];
//					set_filter_type (filter_control_base_0, FILTER_LOW_PASS, setting[4]);
//					params.filter_l_lpbk = setting[4];
//				}
//				else if (menuDown)
//				{
//					menuDown = 0;
//					if (setting[menuPos + cursorPos] > 0){
//						setting[menuPos + cursorPos]--;
//					}
//					oled_clear(zedboard_oled_params_0.base_address);
//					for (i = 0; i < 4; i++)
//					{
//						if (i == cursorPos)
//							menuBuf[0] = 45;
//						else
//							menuBuf[0] = 0;//32;
//						sprintf(&menuBuf[1], "%s%3d", menuitem[menuPos + i], setting[menuPos + i]);
//						oled_print_message(&menuBuf[0], i, zedboard_oled_params_0.base_address);
//					}
//					//net
////					VOLUME_1_REG_0  = 32 * globalVol * setting[3];
////					VOLUME_1_REG_1  = 32 * globalVol * setting[2];
//					params.vl_net = setting[3];
//					params.vr_net = setting[2];
//					set_volume (volume_control_base_1, params.vl_net*globalVol, CHANNEL_ID_L);
//					set_volume (volume_control_base_1, params.vr_net*globalVol, CHANNEL_ID_R);
//					//FILTER_1_REG_17 = setting[9];
//					set_filter_type (filter_control_base_1, FILTER_HIGH_PASS, setting[9]);
//					params.filter_h_net = setting[9];
////					FILTER_1_REG_18 = setting[8];
//					set_filter_type (filter_control_base_1, FILTER_BAND_PASS, setting[8]);
//					params.filter_b_net = setting[8];
////					FILTER_1_REG_19 = setting[7];
//					set_filter_type (filter_control_base_1, FILTER_LOW_PASS, setting[7]);
//					params.filter_l_net = setting[7];
//
//					//line in
////					VOLUME_0_REG_0  = 32 * globalVol * setting[1];
////					VOLUME_0_REG_1  = 32 * globalVol * setting[0];
//					set_volume (volume_control_base_0, params.vl_lpbk*globalVol, CHANNEL_ID_L);
//					set_volume (volume_control_base_0, params.vr_lpbk*globalVol, CHANNEL_ID_R);
////					FILTER_0_REG_17 = setting[6];
//					set_filter_type (filter_control_base_0, FILTER_HIGH_PASS, setting[6]);
//					params.filter_h_lpbk = setting[6];
////					FILTER_0_REG_18 = setting[5];
//					set_filter_type (filter_control_base_0, FILTER_BAND_PASS, setting[5]);
//					params.filter_b_lpbk = setting[5];
////					FILTER_0_REG_19 = setting[4];
//					set_filter_type (filter_control_base_0, FILTER_LOW_PASS, setting[4]);
//					params.filter_l_lpbk = setting[4];
//				}
//			}
//			menuSelect = 0;
//			oled_clear(zedboard_oled_params_0.base_address);
//			for (i = 0; i < 4; i++)
//			{
//				if (i == cursorPos)
//					menuBuf[0] = 62;
//				else
//					menuBuf[0] = 0;//32;
//				sprintf(&menuBuf[1], "%s%3d", menuitem[menuPos + i], setting[menuPos + i]);
//				oled_print_message(&menuBuf[0], i, zedboard_oled_params_0.base_address);
//			}
//
//
//
//		}
//
//		if (pmodData & SWITCH){
////			volSwitch = 1;
//			if (menuUp)
//			{
//				menuUp = 0;
//				if (globalVol < 16){
//					globalVol++;
//				}
//				for (j = 0; j < 16; j++)
//				{
//					if (globalVol > j){
//						menuBuf[j] = 35;
//					}
//					else{
//						menuBuf[j] = 32;
//					}
//				}
//				oled_clear(zedboard_oled_params_0.base_address);
//				for (i = 0; i < 4; oled_print_message(&menuBuf[0], i++, zedboard_oled_params_0.base_address);
//
//			}
//			else if (menuDown)
//			{
//				menuDown = 0;
//				if (globalVol > 0){
//					globalVol--;
//				}
//
//				for (j = 0; j < 16; j++)
//				{
//					if (globalVol > j)
//						menuBuf[j] = 35;
//					else
//						menuBuf[j] = 32;
//				}
//				oled_clear(zedboard_oled_params_0.base_address);
//				for (i = 0; i < 4; oled_print_message(&menuBuf[0], i++, zedboard_oled_params_0.base_address);
//			}
//
//			params.v_global = globalVol;
//			params.v_global = globalVol;
//
//			set_volume (volume_control_base_0, params.vl_lpbk*globalVol, CHANNEL_ID_L);
//			set_volume (volume_control_base_0, params.vr_lpbk*globalVol, CHANNEL_ID_R);
//
//			set_volume (volume_control_base_1, params.vl_net*globalVol, CHANNEL_ID_L);
//			set_volume (volume_control_base_1, params.vr_net*globalVol, CHANNEL_ID_R);
//		}
//		else{
//			volSwitch = 0;
//		}
//
//		if (pmodData == 0 || pmodData == 4) //A|B
//		{
//			if (prevPmodData & A){
//				menuUp = 1;
//			}
//
//			if (prevPmodData & B){
//				menuDown = 1;
//			}
//		}
//		prevPmodData = pmodData;
//		IRQEnable = 1;
//		write(pmod_controller_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable);
//
//
//
//		update_leds();
//
//
//
//	}
//}

//void *recv_function(void *arg)
//{
//	short int buffer[512];
//	int fd_fifo;
//
//	if ((fd_fifo = open("/tmp/myfifo", O_WRONLY)) < 0)
//		info( "fifo write open error\n");
//	else
//		info( "fifo write open\n");
//
////	if (udp_client_setup("192.168.0.4", 12345)){
////		info( "Connection error\n");
////	}
////	else{
////		info( "Stream connected\n");
////	}
//
//	while (1) //get stream and send to axi_to_audio
//	{
//		udp_client_recv((unsigned int*)&buffer, 1024);
//		write(fd_fifo, buffer, 1024);
//	}
//}


void *button_function(void *arg)
{
	int exportfd, directionfd;
	int IRQEnable = 1;
	int button;
	exportfd = open("/sys/class/gpio/export", O_WRONLY);
	if (exportfd < 0)
	{
		info( "Cannot open GPIO to export it\n");
		exit(1);
	}
	write(exportfd, "992", 4);
	write(exportfd, "993", 4);
	write(exportfd, "994", 4);
	write(exportfd, "995", 4);
	write(exportfd, "948", 4);
	close(exportfd);
	info( "GPIO exported successfully\n");
	directionfd = open("/sys/class/gpio/gpio992/direction", O_RDWR);
	if (directionfd < 0)
	{
		error("Cannot open GPIO direction\n");
		exit(1);
	}
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio993/direction", O_RDWR);
	if (directionfd < 0)
	{
		error("Cannot open GPIO direction\n");
		exit(1);
	}
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio994/direction", O_RDWR);
	if (directionfd < 0)
	{
		error("Cannot open GPIO direction\n");
		exit(1);
	}
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio995/direction", O_RDWR);
	if (directionfd < 0)
	{
		error("Cannot open GPIO direction\n");
		exit(1);
	}
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio996/direction", O_RDWR);
	if (directionfd < 0)
	{
		error("Cannot open GPIO direction\n");
		exit(1);
	}
	write(directionfd, "out", 4);
	close(directionfd);
	info( "GPIO direction set as output successfully\n");
	GPIO_BTN_0 = open("/sys/class/gpio/gpio992/value", O_RDWR);
	if (GPIO_BTN_0 < 0)
	{
		error("Cannot open GPIO direction\n");
		exit(1);
	}
	GPIO_BTN_1 = open("/sys/class/gpio/gpio993/value", O_RDWR);
	if (GPIO_BTN_1 < 0)
	{
		error("Cannot open GPIO\n");
		exit(1);
	}
	GPIO_BTN_2 = open("/sys/class/gpio/gpio994/value", O_RDWR);
	if (GPIO_BTN_2 < 0)
	{
		error("Cannot open GPIO\n");
		exit(1);
	}
	GPIO_BTN_3 = open("/sys/class/gpio/gpio995/value", O_RDWR);
	if (GPIO_BTN_3 < 0)
	{
		error("Cannot open GPIO\n");
		exit(1);
	}
	GPIO_BTN_4 = open("/sys/class/gpio/gpio996/value", O_RDWR);
	if (GPIO_BTN_4 < 0)
	{
		error("Cannot open GPIO\n");
		exit(1);
	}

	int fd = open ("/dev/gpiochip0", O_RDWR);
	if (fd < 1) { error("/dev/gpiochip0 error\n"); }

//	while (1)
//	{
//		IRQEnable = 1;
//		write(fd, &IRQEnable, sizeof(IRQEnable);
//		read(fd, &IRQEnable, sizeof(IRQEnable);
//		info( "Got gpio btn interrupt\n");
//	}
}







/**
 * =======================================================
 * ui_exit will do clean up routines and
 * do safe termination the application
 * =======================================================
 */
void bridge_exit () {
  info( "Exiting from teleporter....\n");
  sleep (2);
  unmap_device (zedboard_oled_base_0);
//  unmap_device (axi_to_audio_base_0);
  unmap_device (eth_packet_sequencer_base_0);
//  unmap_device (packet_time_enforcer_base_0);
  unmap_device (full_udp_stack_ip_base_0);
  unmap_device (hyb_switch_ip_base_0);
  unmap_device (eth_to_audio_base_0);
  unmap_device (audio_to_eth_base_0);
  unmap_device (time_sync_base_0);

  unmap_device (adau1761_base_0);

  unmap_device (pmod_controller_base_0);
  unmap_device (filter_control_base_0);
  unmap_device (filter_control_base_1);
  unmap_device (volume_control_base_0);
  unmap_device (volume_control_base_1);

  signal(SIGALRM, SIG_IGN);          /* ignore this signal       */
}

float getVariance(float mean, int sumsq){
//	1. Define two numbers: sum, sumsq
//	2. Set both to zero to start
//	3. For each point from 1 to N:
//	sum <= sum + x;
//	sumsq <= sumsq + (x * x);
//
//	When done:
//	mean <= sum / N;    -- Here's the mean if you need it
//	var <= sumsq / N - (mean * mean);
//
//	Power of two divisions can of course be replaced by shifts, or if you want
//	some form of floating point you are adjusting the exponent and leaving the
//	mantissa alone. If you want the variance of a number stream relative to a
//	forced zero mean you can dispense with the calculation of the mean and just
//	take the sum of squares divided by N.

	return 0;
}



#define PORT     8080
#define MAXLINE 1024
// A normal C function that is executed as a thread
// when its name is specified in pthread_create()



void *mockThreadFun(void *vargs)
{

	int sockfd;
	    char buffer[MAXLINE];
	    char *packet =    (char []) {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
	    struct sockaddr_in     servaddr;

//	    struct arg_struct *args = (struct arg_struct *)vargs;
	    struct arg_struct *args = &nargs;

	    // Creating socket file descriptor
	    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
	    	error("socket creation failed");
//	        exit(EXIT_FAILURE);
	        return;
	    }

	    memset(&servaddr, 0, sizeof(servaddr));
		// Filling server information
		servaddr.sin_family = AF_INET;
		servaddr.sin_port = htons((int)(args->port));
		//	    servaddr.sin_addr.s_addr = args->ip;

	    if (inet_aton(args->ip , &servaddr.sin_addr) == 0)
	    	{
	    	error("Mock address issue inet_aton() failed for IP:%s @ port=%d\n",args->ip ,args->port);
//	    		exit(1);
	    		return;
	    	}



	    int n, len;
	    while(1)  {
			if(sendto(sockfd, (const char *)packet, strlen(packet),
				MSG_CONFIRM, (const struct sockaddr *) &servaddr,
					sizeof(servaddr)) != 0){
				info( "========================== Mock Socket error, try recreating. =========================\n");

				if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
					error("socket creation failed");
					        exit(-1);
					    }
			}else{
				info( "***************Mock message sent.************IP:%s @ port=%d \n",args->ip ,args->port);
			}
//			sleep(args->sdelay);
			sleep(4);

//			bridge_run_command("getmac");
			bridge_run_command("getamac1");
			sleep(1);
			bridge_run_command("getamac2");
//			bridge_run_command("getamac3");
//			bridge_run_command("getamac4");
//			bridge_run_command("getamac5");
			sleep(1);
			bridge_run_command("getdip");
			sleep(1);
			bridge_run_command("getport");
			sleep(1);
			bridge_run_command("getarps");
			sleep(1);
			bridge_run_command("geta2es");
			sleep(1);
			bridge_run_command("getomac");

//			n = recvfrom(sockfd, (char *)buffer, MAXLINE,
//						MSG_WAITALL, (struct sockaddr *) &servaddr,
//						&len);
//			buffer[n] = '\0';
//			info( "Server : %s\n", buffer);
//			sleep(2);
	    }
	    close(sockfd);
	    return 0;

    sleep(1);
    info( "Printing GeeksQuiz from Thread \n");
    return NULL;
}

int fire_up_mock_thread(char * dest_ip, int dest_port, pthread_t * thread_id)
{
//    pthread_t thread_id;

        nargs.port = dest_port;
        nargs.sdelay = 10;
        memcpy(nargs.ip, dest_ip, strlen(dest_ip));

    info( "Fire up firewall mock Thread:: Dest IP:%s :: Port :%d\n",dest_ip, dest_port);
//    pthread_create(thread_id, NULL, mockThreadFun, &nargs);
//    pj_thread_register("mockhandler", handler_desc, &sig_thread);
//    pthread_join(thread_id, NULL);
    info( "After Thread created\n");
//    exit(0);
}


unsigned lastTxPktsCount=0;
unsigned lastRxPktsCount=0, lastLattency=0;

unsigned lastRxPktsPerSecond= 0;
unsigned lastTxPktsPerSecond=0;

unsigned getLatency(){
	time_sync_en(time_sync_base_0);
	usleep(100);
	time_sync_tx_en(full_udp_stack_ip_base_0);
  printf("Enable time sync...\n");
  sleep(1);
  time_tms_off(time_sync_base_0);
  usleep(100);
  time_tms_en(time_sync_base_0);
  usleep(100);
  time_sync_tx_en(full_udp_stack_ip_base_0);
  printf("Measuring time delay...\n");
  sleep(3);
//  get_tms_delays(time_sync_base_0);
  return get_tms_delay_mean(time_sync_base_0);
}

//		      6'h23   : reg_data_out <= ps_rx_pkt_count;
//            6'h24   : reg_data_out <= cs_rx_pkt_count;
//
//            6'h25   : reg_data_out <= ps_tx_pkt_count;
//            6'h26   : reg_data_out <= cs_tx_pkt_count;

void coreDump(unsigned timeInterval){
//	"COREDUMP - Latency: 15ms | LTC: 1234 | RTC: 1234 | Stream: 0/1 | Packets-per-second: 5223 | DriftMS: 5ms | DriftCC: 543"
//	Latency: Measured in milliseconds, only show integers
//	Synced: 0 or 1 (for false or true)
//	Stream: 0 or 1 (for false or true)
//	Packets-per-second: Measured in number of packets, per second (should this be only sound packets, control packets, anything else?)
//	DriftMS: Drift in MS (does it make sense to have it lower?)
//	DriftCS: Integer (Drift clock cycles)
	if(monitor > 0){
		unsigned raw = getLatency();
		unsigned latency = raw > 40*96 ? lastLattency : raw;
		unsigned localTC = get_sync_time(eth_to_audio_base_0);
		unsigned remoteTC = get_rx_time_code(eth_to_audio_base_0);
		unsigned rxPktsCount = read_switch_reg(hyb_switch_ip_base_0, 0x24);// + read_switch_reg(hyb_switch_ip_base_0, 0x23);
		unsigned txPktsCount = read_switch_reg(hyb_switch_ip_base_0, 0x26);// + read_switch_reg(hyb_switch_ip_base_0, 0x25);
		unsigned streamStatus = ((get_a2e_state(audio_to_eth_base_0)&0x00000100) && (read_eth_param (full_udp_stack_ip_base_0, ETH_CONTROL_REG_ID) & 0x00000002)) ? 1 : 0;

		unsigned rxPktsPerSecond = ((rxPktsCount - lastRxPktsCount)/timeInterval) > 8000 ? lastRxPktsPerSecond : ((rxPktsCount - lastRxPktsCount)/timeInterval);
		unsigned txPktsPerSecond = ((txPktsCount - lastTxPktsCount)/timeInterval)  > 8000 ? lastTxPktsPerSecond : ((txPktsCount - lastTxPktsCount)/timeInterval);
	    int timeDiff = localTC - remoteTC;

		info("COREDUMP - Latency: %0.02f ms | LTC: %d | RTC: %d | StreamStatus: %d | RX Packets-per-second: %d | TX Packets-per-second: %d | DDiffMS: %0.02f ms | DDiffCC: %d",
				latency/SAMPLE_RATE, localTC, remoteTC, streamStatus, rxPktsPerSecond, txPktsPerSecond, timeDiff/SAMPLE_RATE, timeDiff);

		lastRxPktsCount= rxPktsCount;
		lastTxPktsCount= txPktsCount;

		lastRxPktsPerSecond= rxPktsPerSecond;
		lastTxPktsPerSecond= txPktsPerSecond;

		lastLattency = latency;
	}
}
#define LOGFILE_TPX "/tmp/time_tpx.log"
#define LOGFILE "/tmp/time_bp.log"
FILE *logfd = NULL;
FILE *logfd_tpx = NULL;

unsigned long long last_ms = 0;
unsigned long long total_ms = 0;

unsigned long long last_tpx_ms = 0;
unsigned long long total_tpx_ms = 0;

void open_log_file(){
	if(logfd == NULL){
		logfd = fopen (LOGFILE, "w");
	}else{
		fprintf( stderr, "Error opening logd_bp file..\n");
	}

	if(logfd_tpx == NULL){
		logfd_tpx = fopen (LOGFILE_TPX, "w");
	}else{
		fprintf( stderr, "Error opening logd_tpx file..\n");
	}
}


void close_log_file(){
	if(logfd != NULL){
		fclose (logfd);
	}else{
		fprintf( stderr, "Error closing logd_bp file..\n");
	}

	if(logfd_tpx != NULL){
			fclose (logfd_tpx);
		}else{
			fprintf( stderr, "Error opening logd_tpx file..\n");
		}
}
void write_log_point(char * desc){
	struct timeval tv;
	gettimeofday(&tv, NULL);
	unsigned long long current_time = ((tv.tv_sec) * 1000) + ((tv.tv_usec) / 1000) ;
	//strftime(date, sizeof(date) / sizeof(*date), "%Y-%m-%dT%H:%M:%S", gmtime(&tv.tv_sec));
	//printf("[%s.%03dZ] ", date, tv.tv_usec / 1000);

		/* Write to log file */
	if(last_ms > 0){
		total_ms = total_ms + (current_time - last_ms);
		fprintf( stderr, "TS LOG: ct=[%lld] :: pr=[%lld] :: tot=[%lld] :: %s\n", current_time, current_time - last_ms, total_ms, desc);
		fprintf (logfd, "ct=[%lld] :: pr=[%lld] :: tot=[%lld] :: %s\n", current_time, current_time - last_ms, total_ms, desc);
		last_ms = current_time;
	}else{
		total_ms = total_ms + last_ms;
		fprintf( stderr, "TS LOG: ct=[%lld] :: pr=[%lld] :: tot=[%lld] :: %s\n", current_time, last_ms, total_ms, desc);
		fprintf (logfd, "ct=[%lld] :: pr=[%lld] :: tot=[%lld] :: %s\n", current_time, last_ms, total_ms, desc);
		last_ms = current_time;
	}

	fflush(logfd);
	fsync(fileno(logfd));


}
void write_log_tpx(char * desc){
	//2022-11-09T12:00:09.807Z
	char dtime[32];
	char msec[4];

	memset(dtime, 0, sizeof(dtime));
	memset(msec, 0, sizeof(msec));

	char *lstart = strstr(desc, "log_tpx "); //pointer to the first character found 'C' in the string saux
	unsigned int slen = strlen("log_tpx ");
	char *tstart = lstart + slen;
	char *tend = strstr(desc, "Z ");
	char *send = strstr(desc, ".");
	//log_tpx 2022-11-09T13:41:06.701Z Hendrix-oldversion-0001 INFO [tpx.ipc:96] - Setting default value {:what :fx.input1.gate/switch, :value true}

//	char *msg = strstr(desc, "INFO [");
	char *msg = tend + 2;

	 memcpy(msec, send+1, 3);
	 memcpy(dtime, tstart, send - tstart);


	 fprintf( stderr, "DT::%s MS::%s \n",dtime,msec);

	 unsigned int mil = atoi(msec);

 //--------------to milliseconds---------------------------
 struct tm tm;
 time_t t;


// if (strptime("6 Dec 2001 12:33:45", "%d %b %Y %H:%M:%S", &tm) == NULL)
     /* Handle error */;
     //2022-11-09T12:00:09
 if (strptime(dtime, "%Y-%m-%dT%H:%M:%S", &tm) == NULL){
	 fprintf( stderr, "Time strptime conversion failed :: %s...\n", dtime);
 }else{

// fprintf( stderr, "year: %d; month: %d; day: %d;\n",
//         tm.tm_year, tm.tm_mon, tm.tm_mday);
// fprintf( stderr, "hour: %d; minute: %d; second: %d\n",
//         tm.tm_hour, tm.tm_min, tm.tm_sec);
// fprintf( stderr, "week day: %d; year day: %d\n", tm.tm_wday, tm.tm_yday);

	 fprintf( stderr, "Time strptime conversion success...\n");
	 tm.tm_isdst = -1;      /* Not set by strptime(); tells mktime()
							   to determine whether daylight saving time
							   is in effect */
	 t = mktime(&tm);
	 if (t == -1){
		 /* Handle error */;
		 fprintf( stderr, "Time mktime conversion failed...\n");
	 }else{
	 fprintf( stderr, "seconds since the Epoch: %ld\n", (long) t);

 //-------------------------------------------------------------------

// struct timeval tv;
// 	gettimeofday(&tv, NULL);
 	unsigned long long current_time = (t*1000) + mil ;
 	//strftime(date, sizeof(date) / sizeof(*date), "%Y-%m-%dT%H:%M:%S", gmtime(&tv.tv_sec));
 	//printf("[%s.%03dZ] ", date, tv.tv_usec / 1000);

 		/* Write to log file */
 	if(last_tpx_ms > 0){
// 		fprintf( stderr, "TIME VERIFY: last_tot=[%lld]\n", total_tpx_ms);
 		total_tpx_ms = total_tpx_ms + (current_time - last_tpx_ms);
 		fprintf( stderr, "TPX LOG: ct=[%lld] :: pr=[%lld] :: tot=[%lld] :: %s\n", current_time, current_time - last_tpx_ms, total_tpx_ms, msg);
 		fprintf (logfd_tpx, "ct=[%lld] :: pr=[%lld] :: tot=[%lld] :: %s\n", current_time, current_time - last_tpx_ms, total_tpx_ms, msg);
 		last_tpx_ms = current_time;
 		// 		fprintf( stderr,"%lld, %s\n", current_time, msg);
 		// 		fprintf (logfd_tpx, "%lld, %s\n", current_time, msg);
 	}else{
 		total_tpx_ms = total_tpx_ms + last_tpx_ms;
 		fprintf( stderr, "TPX LOG: ct=[%lld] :: pr=[%lld] :: tot=[%lld] :: %s\n", current_time, last_tpx_ms, total_tpx_ms, msg);
 		fprintf (logfd_tpx, "ct=[%lld] :: pr=[%lld] :: tot=[%lld] :: %s\n", current_time, last_tpx_ms, total_tpx_ms, msg);
 		last_tpx_ms = current_time;
// 		fprintf( stderr,"%lld, %s\n", current_time, msg);
// 		fprintf (logfd_tpx, "%lld, %s\n", current_time, msg);
 	}

 	fflush(logfd_tpx);
 	fsync(fileno(logfd_tpx));
 }
 }
}


