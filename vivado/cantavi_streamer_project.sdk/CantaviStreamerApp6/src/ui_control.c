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

#include "include/ui_control.h"
#include "include/udpclient.h"
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

unsigned long total_bytes_send_to_net = 0;
unsigned long total_bytes_send_to_dma = 0;
unsigned long total_bytes_read_from_net=0;
unsigned long axi_to_net_mq_w_error_count =0;
unsigned long axi_to_net_mq_r_error_count =0;
unsigned long net_to_axi_mq_w_error_count =0;
unsigned long net_to_axi_mq_r_error_count =0;
unsigned long net_read_error_count =0;
unsigned long net_send_error_count =0;
unsigned long audio_to_axi_reg_w_error_count=0;
unsigned long axi_to_net_reg_w_error_count=0;

#define FIFO_SIZE 512
#define AXI_PKT_SIZE FIFO_SIZE/8
#define UDP_PKT_SIZE AXI_PKT_SIZE*4


char menuBuf[17] = {65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65};
int cursorPos = 0;
int menuPos = 0;
char menuitem[MENULENGTH][13] = {
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
	"Net Counts\0"
};
int setting[MENULENGTH] = {5, 5, 5, 5, 0, 0, 0, 0, 0, 0};
int settingRange[MENULENGTH] = {10, 10, 10, 10, 1, 1, 1, 1, 1, 1};

int menuUp = 0;
int menuDown = 0;
int menuSelect = 0;
int volSwitch = 0;
int globalVol = 8;
int sockfd;

//void *send_audio_function(void *arg);
void *pmod_function(void *arg);
void *recv_function(void *arg);
void *button_function(void *arg);

void *axi_to_net_mq_reader(void *arg);
void *axi_to_net_mq_writer (void* data);
void *net_to_axi_mq_reader (void *data);
void *net_to_axi_mq_writer (void *data);

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
		      perror ("axi_to_net send_audio_to_network : mq_receive(msgq_axi_to_net_r)\n");

		      axi_to_net_mq_r_error_count++;

		      sleep(1);
		}else
		{
			z = udp_client_send(buffer,n);
			if (z != -1) {
	//			sleep(2);
	//			printf("Pkt sent.\n");
				//return 0;
				total_bytes_send_to_net +=z;
			}
			else{
				fprintf (stderr, "Error:: udp_send => sleeping for 1s :: Code=%d\n",z);
				//		    		//exit(1);

				net_send_error_count++;
				sleep(1);
	//	        return 1;
			}
	//			    printf("Hello message sent.\n");
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
	  while (1) {
		  //printf ("Waiting for L data\n");
		  for (i =0; i<AXI_PKT_SIZE; i++){
				buffer[i] = read_stream (audio_to_axi_base_0, CHANNEL_ID_L);
//				if(tmpL != buffer[i])
//					tmpL = buffer[i];
//				else{
//					i--;
//					continue;
//				}
//				if (write_stream (axi_to_audio_base_0, CHANNEL_ID_L, buffer[0]) != 0) {
//				  fprintf (stderr, "loopback : write_stream(axi_to_audio_base_0, CHANNEL_ID_L) failed!!");
//				  return NULL;
//				}
				i++;
				//printf ("Waiting for R data\n");
				buffer[i] = read_stream (audio_to_axi_base_0, CHANNEL_ID_R);
				tmpR = buffer[i];
//				if (write_stream (axi_to_audio_base_0, CHANNEL_ID_R, buffer[1]) != 0) {
//				  fprintf (stderr, "loopback : write_stream(axi_to_audio_base_0, CHANNEL_ID_R) failed!!");
//				  return NULL;
//				}

		  }


	    //buffer[0] = l_buff;
	    if (mq_send(msgq_axi_to_net_w, (char *)buffer, sizeof(buffer) , 0) != 0) {
	          perror ("axi_to_net audio_axi_reader: mq_send");
	          axi_to_net_mq_w_error_count++;
	          sleep(1);
	        }


	  }

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
  while (1) {
	  n = mq_receive(msgq_net_to_axi_r, (char*)buffer, UDP_PKT_SIZE, 0);
    if (n == -1) {
      perror ("net_to_axi network_reader_stream : mq_receive(msgq_id_r)\n");

      net_to_axi_mq_r_error_count++;

      sleep(1);
    }else{

		for(i=0; i<n/4;i++){
			if (write_stream (axi_to_audio_base_0, CHANNEL_ID_L, buffer[i]) != 0) {
			  fprintf (stderr, "network_stream : write_stream(axi_to_audio_base_1, CHANNEL_ID_L)");

			  audio_to_axi_reg_w_error_count++;

			  sleep(1);
			}

			i++;

			if (write_stream (axi_to_audio_base_0, CHANNEL_ID_R, buffer[i]) != 0) {
			  fprintf (stderr, "network_stream : write_stream(axi_to_audio_base_1, CHANNEL_ID_R)");

			  audio_to_axi_reg_w_error_count++;
			  sleep(1);
			}
		}
    }

  }

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
      fprintf (stderr, "Error :: net_to_axi_mq_writer no udp pkt received\n");

	  net_read_error_count++;

      sleep(1);
    }else{
    	total_bytes_read_from_net += n;
		if (mq_send(msgq_net_to_axi_w, (char*)buffer, n, 0) != 0) {
		  perror ("Error :: net_to_axi network_writer_stream : mq_send");

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
  char c[8];
  unsigned int gain = 0;

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
    if(strcmp (c,"vgg") == 0) {
            SET_STATUS("Enter global gain\n");
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
            ui_draw();
      }else if(strcmp (c,"vll") == 0) {
        SET_STATUS("Enter gain\n");
        ui_draw();
        scanf ("%d",&gain);
        set_volume (volume_control_base_0, params.v_global*gain, CHANNEL_ID_L);
        params.vl_lpbk = gain;
        setting[1] = params.vl_lpbk;
        oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%3d", menuitem[0], setting[1]);
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

        ui_draw();
      }
      else if(strcmp (c,"vlr") == 0) {
        SET_STATUS("Enter gain\n");
        ui_draw();
        scanf ("%d",&gain);
        set_volume (volume_control_base_0, params.v_global*gain, CHANNEL_ID_R);
        params.vr_lpbk = gain;
        setting[0] = gain;

        oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%3d", menuitem[1], setting[0]);
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

        ui_draw();
      }
      else if(strcmp (c,"vnl") == 0) {
        SET_STATUS("Enter gain\n");
        ui_draw();
        scanf ("%d",&gain);
        set_volume (volume_control_base_1, params.v_global*gain, CHANNEL_ID_L);
        params.vl_net = gain;
        setting[3] = gain;

        oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%3d", menuitem[2], setting[3]);
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

        ui_draw();
      }
      else if(strcmp (c,"vnr") == 0) {
        SET_STATUS("Enter gain\n");
        ui_draw();
        scanf ("%d",&gain);
        set_volume (volume_control_base_1, params.v_global*gain, CHANNEL_ID_R);
        params.vr_net = gain;
        setting[2] = gain;
        oled_clear(zedboard_oled_params_0.base_address);
		sprintf(&menuBuf[0], "%s%3d", menuitem[3], setting[2]);
		oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);
        ui_draw();
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
      else if ( strcmp (c, "nstats") == 0){

			printf("total_bytes_send_to_dma count is::%d\n",total_bytes_send_to_dma);
			printf("total_bytes_send_to_net count is::%d\n",total_bytes_send_to_net);
			printf("total_bytes_read_from_net count is::%d\n",total_bytes_read_from_net);
			printf("audio_to_axi_reg_w_error count is::%d\n",audio_to_axi_reg_w_error_count);
//			printf("axi_to_net_reg_w_error count is::%d\n",axi_to_net_reg_w_error_count);
			printf("axi_to_net_mq_r_error count is::%d\n",axi_to_net_mq_r_error_count);
			printf("net_to_axi_mq_w_error count is::%d\n",net_to_axi_mq_w_error_count);
			printf("net_to_axi_mq_r_error count is::%d\n",net_to_axi_mq_r_error_count);
			printf("net_read_error count is::%d\n",net_read_error_count);
			printf("net_send_error count is::%d\n",net_send_error_count);
			oled_clear(zedboard_oled_params_0.base_address);
			sprintf(&menuBuf[0], "%s::%3d", menuitem[10], total_bytes_send_to_net);
			oled_print_message(&menuBuf[0], 1, zedboard_oled_params_0.base_address);

      }
      else if ( strcmp (c, "astatus") == 0){
    	  int buffer = read_fifo_status (audio_to_axi_base_0, ADC_FIFO_ID);
    	  if(buffer&0x04){
    	      	//LeftFIFOEmpty
    		  printf("ADC left audio fifo Empty :: val::0x%02X\n",buffer);
    	  }
    	  if(buffer&0x08){
    	      	//RightFIFOEmpty
    		  printf("ADC right audio fifo Empty :: val::0X%02X\n",buffer);
    	      }
    	  if(buffer&0x10){
    	      	//LeftFIFOFull
    		  printf("ADC left audio fifo Full :: val::0x%02X\n",buffer);
    	      }
    	  if(buffer&0x20){
    	      	//RightFIFOFull
    		  printf("ADC right audio fifo Full :: val::0x%02X\n",buffer);
    	      }
    	  if(buffer&0x3C == 0){
    		  printf("All ADC audio fifo Flags clear :: val::0X%02X\n",buffer);
    	  }
    	  printf("All ADC audio fifo Flags:: val::0X%02X\n",buffer);
      }
      else if ( strcmp (c, "dstatus") == 0){
    	  int buffer = read_fifo_status (axi_to_audio_base_0, DAC_FIFO_ID);
    	  if(buffer&0x04){
    	      	      	//LeftFIFOEmpty
			  printf("DAC left audio fifo Empty :: val::0x%02X\n",buffer);
		  }
		  if(buffer&0x08){
				//RightFIFOEmpty
			  printf("DAC right audio fifo Empty :: val::0x%02X\n",buffer);
			  }
		  if(buffer&0x10){
				//LeftFIFOFull
			  printf("DAC left audio fifo Full :: val::0x%02X\n",buffer);
			  }
		  if(buffer&0x20){
				//RightFIFOFull
			  printf("DAC right audio fifo Full :: val::0x%02X\n",buffer);
			  }
		  if(buffer&0x3C == 0){
			  printf("All DAC audio fifo Flags clear :: val::0x%02X\n",buffer);
		  }
		  printf("All DAC audio fifo Flags :: val::0x%02X\n",buffer);
      }
      else if ( strcmp (c, "areset") == 0){
    	  reset_fifos(audio_to_axi_base_0, ADC_FIFO_ID,0x03);//LSB is left, MSB is Right
    	  printf("ADC audio FIFOs Reset\n");
      }
      else if ( strcmp (c, "dreset") == 0){
    	  reset_fifos(axi_to_audio_base_0, DAC_FIFO_ID,0x03);//LSB is left, MSB is Right
    	  printf("DAC audio FIFOs Reset\n");
      }
      else if (strcmp (c, "help") == 0) {
        printf ("|==================+================================================|\n");
        printf ("|Command           |Description                                     |\n");
        printf ("|==================+================================================|\n");
        printf ("|vgg <gain value>  |volume gain for global level					 |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|vll <gain value>  |volume gain for left channel of loopback stream |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|vlr <gain value>  |volume gain for right channel of loopback stream|\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|vnl <gain value>  |volume gain for left channel of network stream  |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|vnr <gain value>  |volume gain for right channel of network stream |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    lfhe/lfhd     |High pass enable/Disable for loopback           |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    lfbe/lfbd     |Band pass enable/Disable for loopback           |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    lfle/lfld     |Low pass enable/Disable for loopback            |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    nfhe/nfhd     |High pass enable/Disable for network            |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    nfbe/nfbd     |Band pass enable/Disable for network            |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    nfle/nfld     |Low pass enable/Disable for network             |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    nstats        |Byte counts and error counts for the network    |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    astatus        |Hardware ADC audio FIFO Status                  |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    dstatus        |Hardware DAC audio FIFO Status                  |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    areset        |Hardware ADC audio FIFO Reset                   |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    dreset        |Hardware DAC audio FIFO Reset                   |\n");
        printf ("|------------------+------------------------------------------------|\n");
        printf ("|    exit     		|Exit the application				             |\n");
        printf ("|==================+================================================|\n");
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
		ui_exit ();
        SET_STATUS("Shutting down audio.\nClosing app\n");
        exit(0);
      }
      else {
        SET_STATUS("Invalid Command\n");
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
void ui_draw () {
    system ("clear");
    printf ("|============+============+============|\n");
    printf ("| Parameters +  Loopback  +   Network  |\n");
    printf ("|============+============+============|\n");
    printf ("|  Volume_G  +    %4d    +    %4d    |\n", params.v_global, params.v_global);
    printf ("|------------+------------+------------|\n");
    printf ("|  Volume_L  +    %4d    +    %4d    |\n", params.vl_lpbk, params.vl_net);
    printf ("|------------+------------+------------|\n");
    printf ("|  Volume_R  +    %4d    +    %4d    |\n", params.vr_lpbk, params.vr_net);
    printf ("|------------+------------+------------|\n");
    printf ("|  FILTER_B  +    %-4s    +    %-4s    |\n", (params.filter_b_lpbk ? "On":"Off"), (params.filter_b_net ? "On":"Off"));
    printf ("|------------+------------+------------|\n");
    printf ("|  FILTER_L  +    %-4s    +    %-4s    |\n",(params.filter_l_lpbk ? "On":"Off"), (params.filter_l_net ? "On":"Off"));
    printf ("|------------+------------+------------|\n");
    printf ("|  FILTER_H  +    %-4s    +    %-4s    |\n", (params.filter_h_lpbk ? "On":"Off"), (params.filter_h_net ? "On":"Off"));
    printf ("|============+============+============|\n");
    printf ("\n%s\n", params.status);
  return NULL;
}

/**
 * =======================================================
 * ui_init initialize the user interface
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int ui_init (int argc, char *argv[]) {

	zedboard_oled_params_0 = map_device (ZEDBOARDOLED_0);

  if (zedboard_oled_params_0.base_address == NULL) {
     perror ("ui_init : zedboard_oled_params_0");
     return -1;
  }else{
	  zedboard_oled_base_0 = zedboard_oled_params_0.base_address;
  }

  axi_to_audio_params_0 = map_device (AXI_TO_AUDIO_DEVICE_0);
  if (axi_to_audio_params_0.base_address == NULL) {
     perror ("ui_init : axi_to_audio_params_0");
     return -1;
  }else{
	  axi_to_audio_base_0 = axi_to_audio_params_0.base_address;
  }



  audio_to_axi_params_0 = map_device (AUDIO_TO_AXI_DEVICE_0);
    if (audio_to_axi_params_0.base_address == NULL) {
       perror ("ui_init : audio_to_axi_params_0");
       return -1;
    }else{
    	audio_to_axi_base_0 = audio_to_axi_params_0.base_address;
    }


  pmod_controller_params_0 = map_device(PMOD_CONTROLLER_0);
  if (pmod_controller_params_0.base_address == NULL) {
     perror ("ui_init : pmod_controller_params_0");
     return -1;
  }else{
	  pmod_controller_base_0 = pmod_controller_params_0.base_address;
  }

  filter_control_params_0 = map_device(FILTER_DEVICE_0);
  if (filter_control_params_0.base_address == NULL) {
     perror ("ui_init : filter_control_params_0");
     return -1;
  }else{
	  filter_control_base_0 = filter_control_params_0.base_address;
  }

  filter_control_params_1 = map_device(FILTER_DEVICE_1);
  if (filter_control_params_1.base_address == NULL) {
     perror ("ui_init : filter_control_params_1");
     return -1;
  }else{
	  filter_control_base_1 = filter_control_params_1.base_address;
  }

  volume_control_params_0 = map_device(VOLUME_DEVICE_0);
  if (volume_control_params_0.base_address == NULL) {
     perror ("ui_init : volume_control_params_0");
     return -1;
  }else{
	  volume_control_base_0 = volume_control_params_0.base_address;
  }

  volume_control_params_1 = map_device(VOLUME_DEVICE_1);
  if (volume_control_params_1.base_address == NULL) {
     perror ("ui_init : volume_control_params_1");
     return -1;
  }else{
	  volume_control_base_1 = volume_control_params_1.base_address;
  }
  //-------------------------------------------------------------------------------------
//
//  mkfifo("/tmp/myfifo", 0666);
//  mkfifo("/tmp/axififo", 0666);

  init_gpios();
  //-------------------------------------------------------------------------------------
  printf ("Setting up UDP Client on server ip_address=%s:: and port=%d\n",argv[1], atoi(argv[2]));
  sprintf(saddr.ip, argv[1]);
  saddr.port = atoi(argv[2]);
  printf ("Set UDP server address=%s:: and broadcast_port=%d\n",saddr.ip, saddr.port);

  sockfd = udp_client_setup( argv[1], atoi(argv[2]));
  if (sockfd < 1) {
    fprintf (stderr, "udp_client_setup failed exiting\n");
    return -1;
  }else{

	 printf("UDP Client connected\n");

  }

  //--------------------------------------------------------------------------------------
    attr_axi_to_net_w.mq_flags = 0;
    attr_axi_to_net_w.mq_maxmsg = 4*AXI_PKT_SIZE*2;
    attr_axi_to_net_w.mq_msgsize = 4*AXI_PKT_SIZE;
    attr_axi_to_net_w.mq_curmsgs = 0;
    printf ("Configuring axi_to_net memory write buffers \n");
    //msgq_id_w = mq_open(MSGQOBJ_NAME, O_RDWR | O_CREAT | O_EXCL, S_IRWXU | S_IRWXG, &attr_w);
    //EXIST pathname already exists and O_CREAT and O_EXCL were used." I don't use O_EXCL.
    msgq_axi_to_net_w = mq_open(A2N_MSGQOBJ_NAME, O_RDWR | O_CREAT , S_IRWXU | S_IRWXG, &attr_axi_to_net_w);
    if (msgq_axi_to_net_w == (mqd_t)-1) {
      perror("Error ui_init : mq_open(msq_axi_to_net_w)\n");
      return -1;
    }
    printf ("Configuring axi_to_net memory read buffers\n");
    msgq_axi_to_net_r = mq_open(A2N_MSGQOBJ_NAME, O_RDWR);
    if (msgq_axi_to_net_r == (mqd_t)-1) {
      perror("Error ui_init : mq_open(msq_axi_to_net_r)\n");
      return -1;
    }

    printf ("Configuring axi_to_net memory read buffers attributes\n");
    if (mq_getattr(msgq_axi_to_net_r, &attr_axi_to_net_r) != 0) {
      perror ("Error ui_init : mq_getattr(msg_axi_to_net_r)");
      return -1;
    }

    //-------------------------------------------------------------------------------------
    attr_net_to_axi_w.mq_flags = 0;
    attr_net_to_axi_w.mq_maxmsg = UDP_PKT_SIZE*4;
    attr_net_to_axi_w.mq_msgsize = UDP_PKT_SIZE;
    attr_net_to_axi_w.mq_curmsgs = 0;
    printf ("Configuring net_to_axi memory write buffers \n");
    //msgq_id_w = mq_open(MSGQOBJ_NAME, O_RDWR | O_CREAT | O_EXCL, S_IRWXU | S_IRWXG, &attr_w);
    //EXIST pathname already exists and O_CREAT and O_EXCL were used." I don't use O_EXCL.
    msgq_net_to_axi_w = mq_open(N2A_MSGQOBJ_NAME, O_RDWR | O_CREAT , S_IRWXU | S_IRWXG, &attr_net_to_axi_w);
    if (msgq_net_to_axi_w == (mqd_t)-1) {
      perror("Error ui_init : mq_open(msq_net_to_axi_w)\n");
      return -1;
    }
    printf ("Configuring net_to_axi memory read buffers\n");
    msgq_net_to_axi_r = mq_open(N2A_MSGQOBJ_NAME, O_RDWR);
    if (msgq_net_to_axi_r == (mqd_t)-1) {
      perror("Error ui_init : mq_open(msq_net_to_axi_r)\n");
      return -1;
    }

    printf ("Configuring net_to_axi memory read buffers attributes\n");
    if (mq_getattr(msgq_net_to_axi_r, &attr_net_to_axi_r) != 0) {
      perror ("Error ui_init : mq_getattr(msg_net_to_axi_r)");
      return -1;
    }
    //-------------------------------------------------------------------------------------

  filter_coefficients coefficients;
  unsigned int filter_coefficients[15] = { 0x00002CB6, 0x0000596C, 0x00002CB6, 0x8097A63A, 0x3F690C9D, \
                                           0x074D9236, 0x00000000, 0xF8B26DCA, 0x9464B81B, 0x3164DB93, \
                                           0x12BEC333, 0xDA82799A, 0x12BEC333, 0x00000000, 0x0AFB0CCC };

  for (int i = 0; i < 15; i++) {
    coefficients.coefficients[i] = filter_coefficients[i];
  }

  printf ("Setting filter 0 coefficients..\n");
  if (set_coefficients (filter_control_base_0, coefficients) != 0) {
    fprintf (stderr, "set_coefficients\n");
  }

  printf ("Setting filter 0 coefficients..\n");
  if (set_coefficients (filter_control_base_1, coefficients) != 0) {
    fprintf (stderr, "set_coefficients\n");
  }

  printf ("Setting default Chan 0 L volume to 30..\n");
	set_volume (volume_control_base_0, 30, CHANNEL_ID_L);
	printf ("Setting default Chan 0 R volume to 30..\n");
	set_volume (volume_control_base_0, 30, CHANNEL_ID_R);
	printf ("Setting default Chan 1 L volume to 30..\n");
	set_volume (volume_control_base_1, 30, CHANNEL_ID_L);
	printf ("Setting default Chan 1 R volume to 30..\n");
	set_volume (volume_control_base_1, 30, CHANNEL_ID_R);
	printf ("Updating params ...\n");
	params.vl_lpbk = 30;
	params.v_global = 4;
	globalVol = 4;
	params.vr_lpbk = 30;
	params.vl_net  = 30;
	params.vr_net  = 30;
	printf ("Init done....\n");
  return 0;
}


void init_gpios(){
	exportfd = open("/sys/class/gpio/export", O_WRONLY);
	if (exportfd < 0)
	{
		printf("Cannot open GPIO to export it\n");
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
	printf("GPIO exported successfully\n");
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
	printf("GPIO direction set as output successfully\n");
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
//  if (pthread_create (&loopback_thread, NULL, loopback, NULL) != 0) {
//    perror ("ui_init : pthread_create(&loopback_thread)");
//    return -1;
//  }

//  if (pthread_create (&network_reader_stream_thread, NULL, network_reader_stream, NULL) != 0) {
//    perror ("ui_init : pthread_create(&network_reader_stream_thread)");
//    return -1;
//  }
//
//  if (pthread_create (&network_writer_stream_thread, NULL, network_writer_stream, NULL) != 0) {
//    perror ("ui_init : pthread_create(&network_writer_stream_thread)");
//    return -1;
//  }




//  	r = pthread_create(&pmod_thread, NULL, pmod_function, NULL);
//	if (r !=0)
//	{
//		printf("ui_init : Error - pthread_create() return code: %d\n", r);
//		return -1;
//	}


  r = pthread_create(&axi_to_net_mq_reader_thread, NULL, axi_to_net_mq_reader, NULL);
  	if (r != 0)
  	{
  		printf("Error - pthread_create() audio_reader_thread return code: %d\n", r);
  		return -1;
  	}

r = pthread_create(&axi_to_net_mq_writer_thread, NULL, axi_to_net_mq_writer, NULL);
	if (r != 0)
	{
		printf("Error - pthread_create() network_reader_stream_thread return code: %d\n", r);
		return -1;
	}

	r = pthread_create(&net_to_axi_mq_reader_thread, NULL, net_to_axi_mq_reader, NULL);
	if (r != 0)
	{
		printf("Error - pthread_create() network_writer_stream_thread return code: %d\n", r);
		return -1;
	}

	r = pthread_create(&net_to_axi_mq_writer_thread, NULL, net_to_axi_mq_writer, NULL);
	if (r != 0)
	{
		printf("Error - pthread_create() audio_to_network_thread return code: %d\n", r);
		return -1;
	}

	r= pthread_create (&ui_input_reader_thread, NULL, ui_input_reader, NULL);
	  if (r != 0) {
	    printf ("ui_init : pthread_create(&ui_input_reader_thread) code:%d",r);
	    return -1;
	  }
/*
  if (pthread_create (&ui_draw_thread, NULL, ui_draw, NULL) != 0) {
    perror ("ui_init : pthread_create(&ui_draw_thread)");
    return -1;
  }

  if`dd (pthread_join(ui_draw_thread, NULL) != 0) {
    perror ("(pthread_join(ui_draw_thread");
    return -1;
  }
*/
//  if (pthread_join(loopback_thread, NULL) != 0) {
//    perror ("pthread_join(loopback_thread)");
//    return -1;
//  }

	if (pthread_join(net_to_axi_mq_writer_thread, NULL) != 0) {
		perror ("pthread_join(audio_reader_thread)");
		return -1;
	  }

	if (pthread_join(net_to_axi_mq_reader_thread, NULL) != 0) {
		perror ("pthread_join(audio_to_network_thread)");
		return -1;
	  }


  if (pthread_join(axi_to_net_mq_writer_thread, NULL) != 0) {
    perror ("pthread_join(axi_to_net_mq_writer_thread)");
    return -1;
  }

  if (pthread_join(axi_to_net_mq_reader_thread, NULL) != 0) {
    perror ("pthread_join(axi_to_net_mq_reader_thread)");
    return -1;
  }

  if (pthread_join(ui_input_reader_thread, NULL) != 0) {
    perror ("(pthread_join(ui_input_reader_thread)");
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
//	write(axi_to_audio_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable));
//	printf("audio sample Interrupt Enabled\n");
//	if ((fd = open("/tmp/myfifo", O_RDONLY)) < 1)
//		printf("fifo read open error");
//	else
//		printf("FIFO READ open\n");
//
//	while (1)
//	{
//		read(fd, buf, 1024);
//		for (i = 0; i < 512; i++)//write the data and trigger an int for every write
//		{
//			read(axi_to_audio_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable));
//			IRQEnable = 1;
//			write(axi_to_audio_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable));
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
//	write(pmod_controller_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable));
//	printf(" Pmod Interrupt Enabled\n");
//
//	while (1)
//	{
//		read(pmod_controller_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable));
////		pmodData = PMOD_REG_3;
//		pmodData = *((unsigned *)(pmod_controller_params_0.base_address + PMOD_INTERFACE_REG3_OFFSET));
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
//				for (i = 0; i < 4; oled_print_message(&menuBuf[0], i++, zedboard_oled_params_0.base_address));
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
//				for (i = 0; i < 4; oled_print_message(&menuBuf[0], i++, zedboard_oled_params_0.base_address));
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
//		write(pmod_controller_params_0.dev_fd, &IRQEnable, sizeof(IRQEnable));
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
//		printf("fifo write open error\n");
//	else
//		printf("fifo write open\n");
//
////	if (udp_client_setup("192.168.0.4", 12345)){
////		printf("Connection error\n");
////	}
////	else{
////		printf("Stream connected\n");
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
		printf("Cannot open GPIO to export it\n");
		exit(1);
	}
	write(exportfd, "992", 4);
	write(exportfd, "993", 4);
	write(exportfd, "994", 4);
	write(exportfd, "995", 4);
	write(exportfd, "996", 4);
	close(exportfd);
	printf("GPIO exported successfully\n");
	directionfd = open("/sys/class/gpio/gpio992/direction", O_RDWR);
	if (directionfd < 0)
	{
		printf("Cannot open GPIO direction it\n");
		exit(1);
	}
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio993/direction", O_RDWR);
	if (directionfd < 0)
	{
		printf("Cannot open GPIO direction it\n");
		exit(1);
	}
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio994/direction", O_RDWR);
	if (directionfd < 0)
	{
		printf("Cannot open GPIO direction it\n");
		exit(1);
	}
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio995/direction", O_RDWR);
	if (directionfd < 0)
	{
		printf("Cannot open GPIO direction it\n");
		exit(1);
	}
	write(directionfd, "out", 4);
	close(directionfd);
	directionfd = open("/sys/class/gpio/gpio996/direction", O_RDWR);
	if (directionfd < 0)
	{
		printf("Cannot open GPIO direction it\n");
		exit(1);
	}
	write(directionfd, "out", 4);
	close(directionfd);
	printf("GPIO direction set as output successfully\n");
	GPIO_BTN_0 = open("/sys/class/gpio/gpio992/value", O_RDWR);
	if (GPIO_BTN_0 < 0)
	{
		printf("Cannot open GPIO value\n");
		exit(1);
	}
	GPIO_BTN_1 = open("/sys/class/gpio/gpio993/value", O_RDWR);
	if (GPIO_BTN_1 < 0)
	{
		printf("Cannot open GPIO value\n");
		exit(1);
	}
	GPIO_BTN_2 = open("/sys/class/gpio/gpio994/value", O_RDWR);
	if (GPIO_BTN_2 < 0)
	{
		printf("Cannot open GPIO value\n");
		exit(1);
	}
	GPIO_BTN_3 = open("/sys/class/gpio/gpio995/value", O_RDWR);
	if (GPIO_BTN_3 < 0)
	{
		printf("Cannot open GPIO value\n");
		exit(1);
	}
	GPIO_BTN_4 = open("/sys/class/gpio/gpio996/value", O_RDWR);
	if (GPIO_BTN_4 < 0)
	{
		printf("Cannot open GPIO value\n");
		exit(1);
	}

	int fd = open ("/dev/gpiochip0", O_RDWR);
	if (fd < 1) { printf("/dev/gpiochip0 error\n"); }

	while (1)
	{
		IRQEnable = 1;
		write(fd, &IRQEnable, sizeof(IRQEnable));
		read(fd, &IRQEnable, sizeof(IRQEnable));
		printf("Got gpio btn interrupt\n");
	}
}

/**
 * =======================================================
 * ui_exit will do clean up routines and
 * do safe termination the application
 * =======================================================
 */
void ui_exit () {
  printf ("Exiting from Audio Mixer\n");
  sleep (2);
  unmap_device (zedboard_oled_base_0);
  unmap_device (axi_to_audio_base_0);
  unmap_device (audio_to_axi_base_0);
  unmap_device (pmod_controller_base_0);
  unmap_device (filter_control_base_0);
  unmap_device (filter_control_base_1);
  unmap_device (volume_control_base_0);
  unmap_device (volume_control_base_1);
}
