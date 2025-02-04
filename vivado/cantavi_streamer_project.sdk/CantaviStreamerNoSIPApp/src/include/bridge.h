/*
 * bridge.h
 *
 *  Created on: Jun 1, 2021
 *      Author: thanx
 */

#ifndef PJMEDIA_INCLUDE_BRIDGE_BRIDGE_H_
#define PJMEDIA_INCLUDE_BRIDGE_BRIDGE_H_

#include "bridge/ui_control.h"
#include "bridge/adau1761_controller.h"
#include "bridge/reg_io.h"
#include "bridge/volume_control.h"
#include "bridge/stream_control.h"
#include "bridge/filter_control.h"

#include "bridge/udpclient.h"
#include "bridge/network.h"



int bridge_main (int argc, char *argv[]);



#endif /* PJMEDIA_INCLUDE_BRIDGE_BRIDGE_H_ */
