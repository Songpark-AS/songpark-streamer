/**
 * =====================================================================================
 *
 *       Filename:  stream_control.h
 *
 *    Description:  audio stream control functions and macros
 *
 *         Author:  Thanx
 *   Organization:  Cantavi
 *
 *
 * =====================================================================================
 */

#ifndef STREAM_CONTROL_H
#define STREAM_CONTROL_H

#include "reg_io.h"

/**
 * =======================================================
 * read_stream reads 4 bytes unsigned data
 * from the specified channel
 * @param   : stream_base  : base address of the stream
 * @param   : channel      : channel ID
 * @return  : returns 4 bytes unsigned data
 * =======================================================
 */
unsigned read_stream (void *stream_base, CHANNEL_ID channel);

/**
 * =======================================================
 * write_stream writes 4 bytes unsigned data
 * to the spicified channel
 * @param  stream_base  : base address of the stream
 * @param  channel      : channel ID
 * @param  data         : 4 bytes unsigned data
 * @return  : returns 0 upon success
 *            -1 otherwise
 * =======================================================
 */
int write_stream (void *stream_base, CHANNEL_ID channel, unsigned data);


/**
 * =======================================================
 * read_fifo_staus reads 4 bytes unsigned data
 * from the specified channel
 * @param   : stream_base  : base address of the stream
 * @param   : fifo      : fifo ID
 * @return  : returns 4 bytes unsigned data
 * =======================================================
 */
unsigned read_fifo_status (void *stream_base, FIFO_ID fifo);




void reset_fifos(void *stream_base, FIFO_ID fifo, unsigned data);

#endif //STREAM_CONTROL
