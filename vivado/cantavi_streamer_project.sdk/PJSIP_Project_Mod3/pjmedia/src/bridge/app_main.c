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
#include "bridge/ui_control.h"
#include "bridge/adau1761_controller.h"
//#include "pj/log.h"
#include <unistd.h>
#include <signal.h>


//#define debug(x...) PJ_LOG(3,(THIS_FILE, x));
//#define info(x...) PJ_LOG(4,(THIS_FILE, x));
//#define warn(x...) PJ_LOG(2,(THIS_FILE, x));
//#define err(x...) PJ_LOG(1,(THIS_FILE, x));
#define debug(x...) do{ printf("DEBUG::"); printf(x); printf("\n");}while(0)
#define info(x...) do{ printf("INFO::"); printf(x); printf("\n");}while(0)
#define warn(x...) do{ printf("WARN::"); printf(x); printf("\n");}while(0)
#define err(x...) do{ printf("ERROR::"); printf(x); printf("\n");}while(0)

int bridge_main (int argc, char *argv[]) {

	int ret = 0;
	info("Initializing Cantavi Streamer!!!\n");


	if (argc < 2){
		//printf ("Error Initializing Cantavi Streamer arguments too few!!!\n");
		err("Error Initializing Cantavi Streamer arguments too few!!!\n");
		return EXIT_FAILURE;
	}
	info( "Got %d arguments.....\n", argc);
	ret = bridge_init ();

	if (ret != 0) {
		err( "ui_init failed\n");
		return EXIT_FAILURE;
	}





	printf ("Runnin Cantavi Streamer UI\n");
//	ret = ui_run (); // not any more, let the sip user agent tahe over.

//	if (ret != 0) {
//		fprintf (stderr, "ui_run failed\n");
//		return EXIT_FAILURE;
//	}
//
//	ui_exit();

	return EXIT_SUCCESS;

}




