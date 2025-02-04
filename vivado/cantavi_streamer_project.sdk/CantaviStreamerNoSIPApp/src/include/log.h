/*
 * log.h
 *
 *  Created on: Nov 21, 2022
 *      Author: thanx
 */

#ifndef SRC_INCLUDE_LOG_H_
#define SRC_INCLUDE_LOG_H_
#include <stdio.h>
//#define debug(x...) do{ printf("DEBUG::"); printf(x); printf("\n");}while(0)
//#define info(x...) do{ printf("INFO::"); printf(x); printf("\n");}while(0)
//#define warn(x...) do{ printf("WARN::"); printf(x); printf("\n");}while(0)
//#define error(x...) do{ printf("ERROR::"); printf(x); printf("\n");}while(0)
//#define err(x...) do{ printf("ERROR::"); printf(x); printf("\n");}while(0)

//#define error(x...) do{ fprintf (stderr, "ERROR::"); fprintf (stderr, x); fprintf (stderr, "\n");}while(0)
//#define err(x...) do{ fprintf (stderr, "ERROR::"); fprintf (stderr, x); fprintf (stderr, "\n");}while(0)


#define debug(x...) do{ fprintf( stderr,"DEBUG::"); fprintf( stderr,x); fprintf( stderr,"\n");}while(0)
#define info(x...) do{ fprintf( stderr,"INFO::"); fprintf( stderr,x); fprintf( stderr,"\n");}while(0)
#define warn(x...) do{ fprintf( stderr,"WARN::"); fprintf( stderr,x); fprintf( stderr,"\n");}while(0)
#define error(x...) do{ fprintf( stderr,"ERROR::"); fprintf( stderr,x); fprintf( stderr,"\n");}while(0)
#define err(x...) do{ fprintf( stderr,"ERROR::"); fprintf( stderr,x); fprintf( stderr,"\n");}while(0)

#define sig_tpx(x...) do{ fprintf( stdout, x); fprintf( stdout, "\n");}while(0)


#endif /* SRC_INCLUDE_LOG_H_ */
