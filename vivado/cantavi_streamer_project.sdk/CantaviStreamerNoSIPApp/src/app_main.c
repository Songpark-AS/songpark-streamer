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
#include "ui_control.h"
#include "adau1761_controller.h"
#include "log.h"
#include <unistd.h>
#include <signal.h>

//#define sig_tpx(x...) do{ fprintf( stdout, x); fprintf( stdout, "\n");}while(0)

//#define debug(x...) PJ_LOG(3,(THIS_FILE, x));
//#define info(x...) PJ_LOG(4,(THIS_FILE, x));
//#define warn(x...) PJ_LOG(2,(THIS_FILE, x));
//#define err(x...) PJ_LOG(1,(THIS_FILE, x));
//#define debug(x...) do{ printf("DEBUG::"); printf(x); printf("\n");}while(0)
//#define info(x...) do{ printf("INFO::"); printf(x); printf("\n");}while(0)
//#define warn(x...) do{ printf("WARN::"); printf(x); printf("\n");}while(0)
//#define err(x...) do{ printf("ERROR::"); printf(x); printf("\n");}while(0)

#include <signal.h>

static void setup_socket_signal()
{
    signal(SIGPIPE, SIG_IGN);
}

static void setup_signal_handler(void) {}

#define TIMED_EVENTS_STEP_INTERVAL		5
unsigned  seconds_counter = 0;
unsigned sync_counter = 0;
unsigned sync_fail_count = 0;
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
	info("Running timed tasks!!! :: loop_c=%d, rtry_c=%d, fix_c=%d \n",seconds_counter , sync_counter, fix_counter);
	if(seconds_counter % 15 == 0){
		//Things that should happen every 15 seconds...
		if(get_media_channel_state(eth_to_audio_base_0) > 0){
			//
			info("tpx_msg stream__broken \n");
			sig_tpx("{\"tpx_msg\":\"stream__broken\"}");
			info("Media stream broken clear all calls!!!\n");
			tpx_call_hangup_all();//will change to specific call in the parallelization
			stop_hw_streaming();
			signal(SIGALRM, SIG_IGN);          /* ignore this signal   */
		}else{
			alarm(TIMED_EVENTS_STEP_INTERVAL);
		}

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
				info("Time variables good....\n");
				sig_tpx("{\"tpx_msg\":\"sync__synced\"}");
				sync_counter = 0;
				sync_fail_count = 0;
			}else{
				info("In stream Sync attempt failed retry in 5 sec....\n");
//				info("tpx_msg sync__sync-failed rsync in 5\n");
				if(sync_fail_count > 20){
					sig_tpx("{\"tpx_msg\":\"sync__failed\", \"resync\":5}");
				}
				sync_fail_count ++;
				bridge_sync_cycle();
				if(seconds_counter % 305 == 0){
					sync_counter ++;
				}
			}
		}

		seconds_counter += 5;

}


FILE *tty1;
FILE *tty2;

int main(int argc, char *argv[])
{
	int ret = 0;
	open_log_file();
//	int serr = dup(fileno(stderr));
//	int sout = dup(fileno(stdout));

//	printf("The stderr fd== %d stdout fd==%d", fileno(stderr), fileno(stdout));

	write_log_point("Opening virtual com ports.");
	tty2 = freopen("/tmp/ttyBP", "w", stdout);

	if (tty2 == NULL) {
		error("Unable to open terminal for writting");
		exit(1);
	}

	tcflush(tty2, TCIOFLUSH);

	tty1 = freopen("/tmp/ttyBP", "r", stdin);

	if (tty1 == NULL) {
		error("Unable to open terminal for reading");
		exit(1);
	}
	tcflush(tty1, TCIOFLUSH);


	info("Initializing Cantavi Streamer!!!\n");

	sig_tpx("{\"tpx_msg\":\"bp__init\"}");

	info( "Got %d arguments.....\n", argc);
	setup_signal_handler();
	setup_socket_signal();
//initialize the bridge
//   bridge_main (argc, argv);
	write_log_point("Bridge init...");
	ret = bridge_init ();

	if (ret != 0) {
		err( "ui_init failed\n");
		return EXIT_FAILURE;
	}


	setup_signal_handler();


		info ("Running Cantavi Streamer CLI\n");
		ret = ui_run ();

		if (ret != 0) {
			fprintf (stderr, "ui_run failed\n");
			sig_tpx("{\"tpx_msg\":\"bp__error\", \"code\":\"cli_run\"}");
			sig_tpx("{\"tpx_msg\":\"bp__exit\"}");
			return EXIT_FAILURE;
		}

//		ui_exit();

	return EXIT_SUCCESS;

}




