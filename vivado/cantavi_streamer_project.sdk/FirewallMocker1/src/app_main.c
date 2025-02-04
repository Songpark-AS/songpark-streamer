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

struct arg_struct {
    int port;
    int sdelay;
    char ip[16];

};




struct arg_struct nargs;

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
	        perror("socket creation failed");
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
	    		fprintf(stderr, "Mock address issue inet_aton() failed for IP:%s @ port=%d\n",args->ip ,args->port);
//	    		exit(1);
	    		return;
	    	}



	    int n, len;
	    while(1)  {
			if(sendto(sockfd, (const char *)packet, strlen(packet),
				MSG_CONFIRM, (const struct sockaddr *) &servaddr,
					sizeof(servaddr)) == -1){
				printf("========================== Mock Socket error, try recreating. =========================\n");

				if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
					        perror("socket creation failed");
					        exit(-1);
					    }
			}else{
				printf("***************Mock message sent.************IP:%s @ port=%d\n",args->ip ,args->port);
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
//			printf("Server : %s\n", buffer);
//			sleep(2);
	    }
	    close(sockfd);
	    return 0;

    sleep(1);
    printf("Printing GeeksQuiz from Thread \n");
    return NULL;
}

int fire_up_mock_thread(char * dest_ip, int dest_port, pthread_t * thread_id)
{
//    pthread_t thread_id;

        nargs.port = dest_port;
        nargs.sdelay = 10;
        memcpy(nargs.ip, dest_ip, strlen(dest_ip));

    printf("Fire up firewall mock Thread:: Dest IP:%s :: Port :%d\n",dest_ip, dest_port);
    pthread_create(thread_id, NULL, mockThreadFun, &nargs);
//    pthread_join(thread_id, NULL);
    printf("After Thread created\n");
//    exit(0);
}

int main (int argc, char *argv[]) {

	int ret = 0;
    char ipAddress[4];
	memset(macAddress,0,7);
	printf ("Initializing Cantavi Streamer!!!\n");

	if (argc < 2){
		printf ("Error Initializing Cantavi Streamer arguments too few!!!\n");
		return EXIT_FAILURE;
	}
	printf("Got %d arguments.....\n", argc);
//	ret = ui_init (argc, argv);


	if(argc == 3){
	sprintf(dest_ip, "%s",argv[1]);
	  dest_port = atoi(argv[2]);
	  sync_port = atoi(argv[3]);
		write_switch_param(hyb_switch_ip_base_0, PORT1_ID, dest_port);
	    write_switch_param(hyb_switch_ip_base_0, PORT2_ID, sync_port);
	}

	if (ret != 0) {
		fprintf (stderr, "ui_init failed\n");
		return EXIT_FAILURE;
	}




	printf ("Runnin Cantavi Streamer UI\n");
	ret = ui_run ();

	if (ret != 0) {
		fprintf (stderr, "ui_run failed\n");
		return EXIT_FAILURE;
	}

	ui_exit();

	return EXIT_SUCCESS;

}
