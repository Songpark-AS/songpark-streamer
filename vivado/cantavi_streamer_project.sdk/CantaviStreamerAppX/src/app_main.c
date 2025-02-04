/*
 * =====================================================================================
 *
 *       Filename:  app_main.c
 *
 *    Description:  application initialization functions
 *
 *         Author:  Thanx
 *   Organization:  Cantavi
 *
 * =====================================================================================
 */

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include "include/ui_control.h"
#include "include/adau1761_controller.h"

#include <signal.h>

#define debug(x...) do{ printf("DEBUG::"); printf(x); printf("\n");}while(0)
#define info(x...) do{ printf("INFO::"); printf(x); printf("\n");}while(0)
#define warn(x...) do{ printf("WARN::"); printf(x); printf("\n");}while(0)
#define error(x...) do{ printf("ERROR::"); printf(x); printf("\n");}while(0)

static void setup_signal_handler(void) {}




#define TIMED_EVENTS_STEP_INTERVAL		5
unsigned  seconds_counter = 0;
unsigned sync_counter = 0;
unsigned fix_counter = 0;

void sigalrm_handler(int);
/**
 * Initialize all timed tasks that are controlled by the bridge
 *
 */
int  init_incall_timed_task_handler(void)
{
    signal(SIGALRM, sigalrm_handler);
    alarm(TIMED_EVENTS_STEP_INTERVAL);
//    while (1);
}

int  deinit_incall_timed_task_handler(void){
	signal(SIGALRM, SIG_IGN);          /* ignore this signal       */
}

void sigalrm_handler(int sig)
{
	printf("INFO::Running timed tasks!!! :: loop_c=%d, rtry_c=%d, fix_c=%d \n",seconds_counter , sync_counter, fix_counter);
//	enable_media_channel_monitoring(eth_to_audio_base_0);
	alarm(TIMED_EVENTS_STEP_INTERVAL);
	if(get_media_channel_state(eth_to_audio_base_0) > 0){
		//
		printf("INFO::Media stream broken clear all calls only on SIP version!!!\n");
//			pjsua_call_hangup_all();//will change to specific call in the parallelization
		//stop_hw_streaming();
		//signal(SIGALRM, SIG_IGN);          /* ignore this signal       */
//		alarm(TIMED_EVENTS_STEP_INTERVAL);
	}
//	else{
//		alarm(TIMED_EVENTS_STEP_INTERVAL);
//	}

	//	receive_dummy_data();
	if(seconds_counter % 15 == 0){
		//Things that should happen every 15 seconds...
//		if(get_media_channel_state(eth_to_audio_base_0) > 0){
//			//
//			printf("INFO::Media stream broken clear all calls!!!\n");
////			pjsua_call_hangup_all();//will change to specific call in the parallelization
//			stop_hw_streaming();
//			signal(SIGALRM, SIG_IGN);          /* ignore this signal       */
//		}else{
//			alarm(TIMED_EVENTS_STEP_INTERVAL);
//		}

		coreDump(15);
	}

	if(seconds_counter % 300 == 0){
		if(sync_counter > 2){
			sync_counter = 0;
			fix_counter ++;
			bridge_reset_net_stack();
		}

		bridge_sync_cycle();
		alarm(TIMED_EVENTS_STEP_INTERVAL);
	}
	else{
		alarm(TIMED_EVENTS_STEP_INTERVAL);

		if(time_sync_done_check(time_sync_base_0)){
			info( "Time variables good....\n");
			sync_counter = 0;
		}else{
			info( "Sync attempt failed retry....\n");
			bridge_sync_cycle();
			if(seconds_counter % 305 == 0){
				sync_counter ++;
			}
		}
	}

		seconds_counter += TIMED_EVENTS_STEP_INTERVAL;

}



int main (int argc, char *argv[]) {

	int ret = 0;
	printf ("Initializing Cantavi Streamer!!!\n");

	if (argc < 2){
		printf ("Error Initializing Cantavi Streamer arguments too few!!!\n");
		return EXIT_FAILURE;
	}
	printf("Got %d arguments.....\n", argc);
	ret = ui_init (argc, argv);

	if (ret != 0) {
		fprintf (stderr, "ui_init failed\n");
		return EXIT_FAILURE;
	}

	setup_signal_handler();


	printf ("Runnin Cantavi Streamer UI\n");
	ret = ui_run ();

	if (ret != 0) {
		fprintf (stderr, "ui_run failed\n");
		return EXIT_FAILURE;
	}

	ui_exit();

	return EXIT_SUCCESS;

}
