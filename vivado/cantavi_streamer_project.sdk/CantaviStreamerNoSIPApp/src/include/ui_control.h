/*
 * =====================================================================================
 *
 *       Filename:  ui_control.h
 *
 *    Description:  User interface functions
 *
 *         Author:  Thanx
 *   Organization:  Cantavi
 *
 * =====================================================================================
 */

#ifndef UI_CONTROL_H
#define UI_CONTROL_H
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <termios.h>
#include <string.h>
#include <mqueue.h>
#include "network.h"
#include "reg_io.h"
#include "stream_control.h"
#include "filter_control.h"
#include "volume_control.h"
#include "udpclient.h"
//#include "pj/log.h"
//#include "pj/os.h"
#define SIP_LAYER_VERSION		"0.3"


//static pj_thread_desc desc;
//static pj_thread_t * thread;

//#define REGISTER_THREAD() do{\
//	thread = pj_thread_this(); \
//if(!pj_thread_is_registered()) {\
//pj_thread_register(NULL,desc,&thread);\
//}} while(0)


#define N2A_MSGQOBJ_NAME    "/net_to_axi_stream" // name of the fifo
#define A2N_MSGQOBJ_NAME    "/axi_to_net_stream" // name of the fifo

/**
 * =======================================================
 * Macro to set the status of the current command
 * @param   : status_msg  : status message
 * @return  : none
 * =======================================================
 */
#define SET_STATUS(status_msg) sprintf(params.status, status_msg)



/**
 * =======================================================
 * Device base address pointers
 * =======================================================
 */
extern void *zedboard_oled_base_0;
extern void *pmod_controller_base_0;
extern void *filter_control_base_0;
extern void *filter_control_base_1;
extern void *volume_control_base_0;
extern void *volume_control_base_1;
extern void *eth_to_audio_base_0;
extern void *audio_to_eth_base_0;
extern void *hyb_switch_ip_base_0;
extern void *full_udp_stack_ip_base_0;
extern void *eth_packet_sequencer_base_0;
extern void *packet_time_enforcer_base_0;
extern void *adau1761_base_0;
extern void *time_sync_base_0;


extern dev_param zedboard_oled_params_0;
extern dev_param pmod_controller_params_0;
extern dev_param filter_control_params_0;
extern dev_param filter_control_params_1;
extern dev_param volume_control_params_0;
extern dev_param volume_control_params_1;

extern dev_param eth_to_audio_params_0;
extern dev_param audio_to_eth_params_0;
extern dev_param eth_packet_sequencer_params_0;
extern dev_param hyb_switch_ip_params_0;
extern dev_param full_udp_stack_ip_params_0;
extern dev_param packet_time_enforcer_params_0;
extern dev_param adau1761_params_0;
extern dev_param time_sync_params_0;



extern int exportfd, directionfd;



#define MENULENGTH 29
#define A 1
#define B 2
#define SWITCH 4
#define BUTTON 8

extern int GPIO_BTN_0;
extern int GPIO_BTN_1;
extern int GPIO_BTN_2;
extern int GPIO_BTN_3;
extern int GPIO_BTN_4;

extern int GPIO_LED_0;
extern int GPIO_LED_1;
extern int GPIO_LED_2;
extern int GPIO_LED_3;
extern int GPIO_LED_4;
extern int GPIO_LED_5;
extern int GPIO_LED_6;
extern int GPIO_LED_7;

extern pthread_t axi_to_net_mq_reader_thread;
extern pthread_t axi_to_net_mq_writer_thread; // thread to write network audio data to fifo
extern pthread_t net_to_axi_mq_reader_thread; // thread to write fifo audio data to axi audio
extern pthread_t net_to_axi_mq_writer_thread;
//extern pthread_t loopback_thread; // thread to loop back audio in to out through axi
extern pthread_t ui_input_reader_thread; //main ui input reading thread
extern pthread_t ui_draw_thread; // ui draw thread




extern pthread_t pmod_thread;
//extern pthread_t recv_thread;
extern pthread_t button_thread;

typedef struct _server_addr {
	char ip[64];
	int port;
}server_addr;

/**
 * =======================================================
 * structure to hold ui parameters
 * =======================================================
 */
typedef struct _ui_parameters {
	int v_global;
    int vl_lpbk;
    int vl_net;
    int vr_lpbk;
    int vr_net;
    char filter_b_lpbk;
    char filter_b_net;
    char filter_l_lpbk;
    char filter_l_net;
    char filter_h_lpbk;
    char filter_h_net;
    char status[64];
}ui_parameters;

extern ui_parameters params; //shared structure variable to ui_parameters structure

extern server_addr saddr;




extern int quit_flag; // flag to control the threads

extern mqd_t msgq_axi_to_net_r; // reader fifo descripter
extern mqd_t msgq_axi_to_net_w; // writer fifo descripter
extern struct mq_attr attr_axi_to_net_r; // reader fifo attributes
extern struct mq_attr attr_axi_to_net_w; // writer fifo attributes



extern mqd_t msgq_net_to_axi_r; // reader fifo descripter
extern mqd_t msgq_net_to_axi_w; // writer fifo descripter
extern struct mq_attr attr_net_to_axi_r; // reader fifo attributes
extern struct mq_attr attr_net_to_axi_w; // writer fifo attributes

/**
 * =======================================================
 * read_raw function reads raw input from standard input
 * @return  : returns the charecter read from stdin
 * =======================================================
 */
int read_raw();

/**
 * =======================================================
 * reads audio data from axi and writes it into axi
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */
void *loopback (void *data);

/**
 * =======================================================
 * reads audio data from network and writes it into axi
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */
void *network_reader_stream (void *data);

/**
 * =======================================================
 * reads audio data from network and writes it into axi
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */
void *network_writer_stream (void *data);

/**
 * =======================================================
 * read and parse user input
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */
void *ui_input_reader (void *data);

/**
 * =======================================================
 * draw the user interface
 * @param   : data  : thread specific data
 * @return  : returns NULL
 * =======================================================
 */
 void ui_draw ();

/**
 * =======================================================
 * bridge_init initialize the hardware bridge
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */

//int bridge_init (int argc, char *argv[]);
int bridge_init ();


int  init_incall_timed_task_handler(void);
int  deinit_incall_timed_task_handler(void);

/**
 * =======================================================
 * init_hw_ctrl initialize the hardware controls
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int init_hw_ctrl();
/**
 * =======================================================
 * init_hwnodes initialize the hardware device nodes
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int hw_nodes_init();
/**
 * =======================================================
 * set_hw_local_net initialize the local network parameters on the FPGA
 * MAC, GW, MASK, IP
 * These are collected from the linux network stack (this may change in future)
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int set_hw_local_net();
int set_mac_ip_net();
//These come from the SIP stack
/**
 * =======================================================
 * bridge_set_hw_dest_net initialize the dest network parameters on the FPGA
 * DestIP and DestPort
 * These are provided by the SIP stack
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */

int bridge_set_hw_dest_net(char * dest_ip, int dest_port);
void bridge_reset_net_stack();
void bridge_set_contact_ip(char * buf, char * type);
void bridge_update_media_port(char * buf, char * type);
void bridge_run_command(char * cmd);
void bridge_set_dest_ip(char * ip);
//void bridge_set_dest_ip();
int set_call_params();
void bridge_set_dest_port(int port);
void bridge_set_sync_port(int port);
int bit_ip2str(struct sockaddr_in * addr, char * ip_str);
int str2bit_ip(struct sockaddr_in * addr, char * ip_str);
int fire_up_mock_thread(char * dest_ip, int dest_port, pthread_t * thread_id);
void bridge_update_public_ip(char * via_addr_buf);
int bridge_sync_cycle();
void reset_call_params();
void tpx_call_hangup_all();
int check_sync();
void ui_vol_draw ();

/**
 * =======================================================
 * init_hw_sync initialize the hardware sync between the two devices
 * This function must be called after call media channel establishment
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int init_hw_sync();
/**
 * =======================================================
 * deinit_hw_sync initialize the hardware sync between the two devices
 * This function must be called after a fail in init_hw_sync()
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int deinit_hw_sync();
/**
 * =======================================================
 * start_hw_stream start streaming in hardware
 * This function must be called after call media channel and sync establishment
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int start_hw_streaming();
int stop_hw_streaming();

void coreDump(unsigned timeInterval);
int bridge_get_playout_delay();
void bridge_set_playout_delay(int delay);
void bridge_reset_rx_chain();
void bridge_get_tc_vars();
void bridge_adjust_vol(float mul);
int bridge_get_vol();

void bridge_reinit();

void bridge_version();

int bridge_is_timesync_responded();
int bridge_is_timesync_done();
int bridge_is_timesync_good();

void open_log_file();
void close_log_file();
void write_log_point(char * desc);
void write_log_tpx(char * desc);

void init_gpios();



/**
 * =======================================================
 * ui_run starts the user interface
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int ui_run ();

/**
 * =======================================================
 * ui_exit will do clean up routines and
 * do safe termination the application
 * =======================================================
 */
void bridge_exit ();
#endif //UI_CONTROL_H
