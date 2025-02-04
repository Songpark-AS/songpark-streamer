/* $Id$ */
/* 
 * Copyright (C) 2008-2011 Teluu Inc. (http://www.teluu.com)
 * Copyright (C) 2003-2008 Benny Prijono <benny@prijono.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 */
#include "pjsua_app.h"

#define THIS_FILE	"main.c"


static pj_bool_t	    running = PJ_TRUE;
static pj_status_t	    receive_end_sig;
static pj_thread_t	    *sig_thread;
static pjsua_app_cfg_t	    cfg;

/* Called when CLI (re)started */
void on_app_started(pj_status_t status, const char *msg)
{
    pj_perror(3, THIS_FILE, status, (msg)?msg:"");
}

void on_app_stopped(pj_bool_t restart, int argc, char** argv)
{
    if (argv) {
	cfg.argc = argc;
	cfg.argv = argv;
    }

    running = restart;
}

#if defined(PJ_WIN32) && PJ_WIN32!=0
#include <windows.h>

static pj_thread_desc handler_desc;

static BOOL WINAPI CtrlHandler(DWORD fdwCtrlType)
{   
    switch (fdwCtrlType) 
    { 
        // Handle the CTRL+C signal. 
 
        case CTRL_C_EVENT: 
        case CTRL_CLOSE_EVENT: 
        case CTRL_BREAK_EVENT: 
        case CTRL_LOGOFF_EVENT: 
        case CTRL_SHUTDOWN_EVENT: 
	    pj_thread_register("ctrlhandler", handler_desc, &sig_thread);
	    PJ_LOG(3,(THIS_FILE, "Ctrl-C detected, quitting.."));
	    receive_end_sig = PJ_TRUE;
            pjsua_app_destroy();	    
	    ExitProcess(1);
            PJ_UNREACHED(return TRUE;)
 
        default: 
 
            return FALSE; 
    } 
}

static void setup_socket_signal()
{
}

static void setup_signal_handler(void)
{
    SetConsoleCtrlHandler(&CtrlHandler, TRUE);
}

#elif PJ_LINUX || PJ_DARWINOS

#include <execinfo.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
static void print_stack(int sig)
{
    void *array[16];
    size_t size;

    size = backtrace(array, 16);
    fprintf(stderr, "Error: signal %d:\n", sig);
    backtrace_symbols_fd(array, size, STDERR_FILENO);
    exit(1);
}

static void setup_socket_signal()
{
    signal(SIGPIPE, SIG_IGN);
}

static void setup_signal_handler(void)
{
    signal(SIGSEGV, &print_stack);
    signal(SIGABRT, &print_stack);
}

#else

#include <signal.h>

static void setup_socket_signal()
{
    signal(SIGPIPE, SIG_IGN);
}

static void setup_signal_handler(void) {}

#endif


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
	if(seconds_counter % 15 == 0){
		//Things that should happen every 15 seconds...
		if(get_media_channel_state(eth_to_audio_base_0) > 0){
			//
			printf("INFO::Media stream broken clear all calls!!!\n");
			pjsua_call_hangup_all();//will change to specific call in the parallelization
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
				printf("INFO::Time variables good....\n");
				sync_counter = 0;
			}else{
				printf("INFO::Sync attempt failed retry....\n");
				bridge_sync_cycle();
				if(seconds_counter % 305 == 0){
					sync_counter ++;
				}
			}
		}

		seconds_counter += 5;

}


int main_func(int argc, char *argv[])
{


    pj_status_t status = PJ_TRUE;

    pj_bzero(&cfg, sizeof(cfg));
    cfg.on_started = &on_app_started;
    cfg.on_stopped = &on_app_stopped;
    cfg.argc = argc;
    cfg.argv = argv;

//    REGISTER_THREAD();

    printf("Running tasks!!!\n");

    setup_signal_handler();
    setup_socket_signal();
//initialize the bridge
//   bridge_main (argc, argv);
    write_log_point("Bridge init...");
    bridge_init ();

    write_log_point("Done bridge init.");

    while (running) {
    	write_log_point("SIP Layer Init..");
		status = pjsua_app_init(&cfg);
		write_log_point("Done SIP Layer Init.");
		if (status == PJ_SUCCESS) {
			write_log_point("Run SIP layer thread.");
			status = pjsua_app_run(PJ_TRUE);
			write_log_point("SIP layer thread running time.");
		} else {
			running = PJ_FALSE;
		}

		if (!receive_end_sig) {
			pjsua_app_destroy();

			/* This is just in case */
			pjsua_app_destroy();
			write_log_point(".....App quit and clean up....");
		} else {
			write_log_point("App running responding to events.");
			pj_thread_join(sig_thread);
		}
    }

    write_log_point("Exiting bridge.");
    bridge_exit();//clean up the FPGA bridge nodes
    write_log_point("Cleaning up and exiting app.");
    close_log_file();
    return 0;
}

FILE *tty1;
FILE *tty2;

int main(int argc, char *argv[])
{
	open_log_file();
//	int serr = dup(fileno(stderr));
//	int sout = dup(fileno(stdout));

//	printf("The stderr fd== %d stdout fd==%d", fileno(stderr), fileno(stdout));

	write_log_point("Opening virtual com ports.");
	tty2 = freopen("/tmp/ttyBP", "w", stdout);

	if (tty2 == NULL) {
		PJ_LOG(1,(THIS_FILE,"Unable to open terminal for writting"));
		exit(1);
	}

	tcflush(tty2, TCIOFLUSH);

	tty1 = freopen("/tmp/ttyBP", "r", stdin);

	if (tty1 == NULL) {
		PJ_LOG(1,(THIS_FILE,"Unable to open terminal for reading"));
		exit(1);
	}
	tcflush(tty1, TCIOFLUSH);

	//restore the stderr output interface
//	dup2(serr,fileno(stderr));

    return pj_run_app(&main_func, argc, argv, 0);
}
