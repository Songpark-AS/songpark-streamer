/* $Id$ */
/* 
 * Copyright (C) 2016 Teluu Inc. (http://www.teluu.com)
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
#include <pj/assert.h>
#include <pj/errno.h>
#include <pj/math.h>
#include <pj/os.h>
#include <pj/compat/socket.h>

#include <ppltasks.h>
#include <string>

#define THIS_FILE	"sock_uwp.cpp"

#include "sock_uwp.h"

 /*
 * Address families conversion.
 * The values here are indexed based on pj_addr_family.
 */
const pj_uint16_t PJ_AF_UNSPEC	= AF_UNSPEC;
const pj_uint16_t PJ_AF_UNIX	= AF_UNIX;
const pj_uint16_t PJ_AF_INET	= AF_INET;
const pj_uint16_t PJ_AF_INET6	= AF_INET6;
#ifdef AF_PACKET
const pj_uint16_t PJ_AF_PACKET	= AF_PACKET;
#else
const pj_uint16_t PJ_AF_PACKET	= 0xFFFF;
#endif
#ifdef AF_IRDA
const pj_uint16_t PJ_AF_IRDA	= AF_IRDA;
#else
const pj_uint16_t PJ_AF_IRDA	= 0xFFFF;
#endif

/*
* Socket types conversion.
* The values here are indexed based on pj_sock_type
*/
const pj_uint16_t PJ_SOCK_STREAM= SOCK_STREAM;
const pj_uint16_t PJ_SOCK_DGRAM	= SOCK_DGRAM;
const pj_uint16_t PJ_SOCK_DGRAM_SIG	= SOCK_DGRAM;
const pj_uint16_t PJ_SOCK_DGRAM_MED	= SOCK_DGRAM+1;
const pj_uint16_t PJ_SOCK_RAW	= SOCK_RAW;
const pj_uint16_t PJ_SOCK_RDM	= SOCK_RDM;

/*
* Socket level values.
*/
const pj_uint16_t PJ_SOL_SOCKET	= SOL_SOCKET;
#ifdef SOL_IP
const pj_uint16_t PJ_SOL_IP	= SOL_IP;
#elif (defined(PJ_WIN32) && PJ_WIN32) || (defined(PJ_WIN64) && PJ_WIN64) 
const pj_uint16_t PJ_SOL_IP	= IPPROTO_IP;
#else
const pj_uint16_t PJ_SOL_IP	= 0;
#endif /* SOL_IP */

#if defined(SOL_TCP)
const pj_uint16_t PJ_SOL_TCP	= SOL_TCP;
#elif defined(IPPROTO_TCP)
const pj_uint16_t PJ_SOL_TCP	= IPPROTO_TCP;
#elif (defined(PJ_WIN32) && PJ_WIN32) || (defined(PJ_WIN64) && PJ_WIN64)
const pj_uint16_t PJ_SOL_TCP	= IPPROTO_TCP;
#else
const pj_uint16_t PJ_SOL_TCP	= 6;
#endif /* SOL_TCP */

#ifdef SOL_UDP
const pj_uint16_t PJ_SOL_UDP	= SOL_UDP;
#elif defined(IPPROTO_UDP)
const pj_uint16_t PJ_SOL_UDP	= IPPROTO_UDP;
#elif (defined(PJ_WIN32) && PJ_WIN32) || (defined(PJ_WIN64) && PJ_WIN64)
const pj_uint16_t PJ_SOL_UDP	= IPPROTO_UDP;
#else
const pj_uint16_t PJ_SOL_UDP	= 17;
#endif /* SOL_UDP */

#ifdef SOL_IPV6
const pj_uint16_t PJ_SOL_IPV6	= SOL_IPV6;
#elif (defined(PJ_WIN32) && PJ_WIN32) || (defined(PJ_WIN64) && PJ_WIN64)
#   if defined(IPPROTO_IPV6) || (_WIN32_WINNT >= 0x0501)
const pj_uint16_t PJ_SOL_IPV6	= IPPROTO_IPV6;
#   else
const pj_uint16_t PJ_SOL_IPV6	= 41;
#   endif
#else
const pj_uint16_t PJ_SOL_IPV6	= 41;
#endif /* SOL_IPV6 */

/* IP_TOS */
#ifdef IP_TOS
const pj_uint16_t PJ_IP_TOS	= IP_TOS;
#else
const pj_uint16_t PJ_IP_TOS	= 1;
#endif


/* TOS settings (declared in netinet/ip.h) */
#ifdef IPTOS_LOWDELAY
const pj_uint16_t PJ_IPTOS_LOWDELAY	= IPTOS_LOWDELAY;
#else
const pj_uint16_t PJ_IPTOS_LOWDELAY	= 0x10;
#endif
#ifdef IPTOS_THROUGHPUT
const pj_uint16_t PJ_IPTOS_THROUGHPUT	= IPTOS_THROUGHPUT;
#else
const pj_uint16_t PJ_IPTOS_THROUGHPUT	= 0x08;
#endif
#ifdef IPTOS_RELIABILITY
const pj_uint16_t PJ_IPTOS_RELIABILITY	= IPTOS_RELIABILITY;
#else
const pj_uint16_t PJ_IPTOS_RELIABILITY	= 0x04;
#endif
#ifdef IPTOS_MINCOST
const pj_uint16_t PJ_IPTOS_MINCOST	= IPTOS_MINCOST;
#else
const pj_uint16_t PJ_IPTOS_MINCOST	= 0x02;
#endif


/* optname values. */
const pj_uint16_t PJ_SO_TYPE    = SO_TYPE;
const pj_uint16_t PJ_SO_RCVBUF  = SO_RCVBUF;
const pj_uint16_t PJ_SO_SNDBUF  = SO_SNDBUF;
const pj_uint16_t PJ_TCP_NODELAY= TCP_NODELAY;
const pj_uint16_t PJ_SO_REUSEADDR= SO_REUSEADDR;
#ifdef SO_NOSIGPIPE
const pj_uint16_t PJ_SO_NOSIGPIPE = SO_NOSIGPIPE;
#else
const pj_uint16_t PJ_SO_NOSIGPIPE = 0xFFFF;
#endif
#if defined(SO_PRIORITY)
const pj_uint16_t PJ_SO_PRIORITY = SO_PRIORITY;
#else
/* This is from Linux, YMMV */
const pj_uint16_t PJ_SO_PRIORITY = 12;
#endif

/* Multicasting is not supported e.g. in PocketPC 2003 SDK */
#ifdef IP_MULTICAST_IF
const pj_uint16_t PJ_IP_MULTICAST_IF    = IP_MULTICAST_IF;
const pj_uint16_t PJ_IP_MULTICAST_TTL   = IP_MULTICAST_TTL;
const pj_uint16_t PJ_IP_MULTICAST_LOOP  = IP_MULTICAST_LOOP;
const pj_uint16_t PJ_IP_ADD_MEMBERSHIP  = IP_ADD_MEMBERSHIP;
const pj_uint16_t PJ_IP_DROP_MEMBERSHIP = IP_DROP_MEMBERSHIP;
#else
const pj_uint16_t PJ_IP_MULTICAST_IF    = 0xFFFF;
const pj_uint16_t PJ_IP_MULTICAST_TTL   = 0xFFFF;
const pj_uint16_t PJ_IP_MULTICAST_LOOP  = 0xFFFF;
const pj_uint16_t PJ_IP_ADD_MEMBERSHIP  = 0xFFFF;
const pj_uint16_t PJ_IP_DROP_MEMBERSHIP = 0xFFFF;
#endif

/* recv() and send() flags */
const int PJ_MSG_OOB		= MSG_OOB;
const int PJ_MSG_PEEK		= MSG_PEEK;
const int PJ_MSG_DONTROUTE	= MSG_DONTROUTE;



using namespace Platform;
using namespace Windows::Foundation;
using namespace Windows::Networking;
using namespace Windows::Networking::Sockets;
using namespace Windows::Storage::Streams;


ref class PjUwpSocketDatagramRecvHelper sealed
{
internal:
    PjUwpSocketDatagramRecvHelper(PjUwpSocket* uwp_sock_) :
	uwp_sock(uwp_sock_), avail_data_len(0), recv_args(nullptr)
    {
	recv_wait = CreateEventEx(nullptr, nullptr, 0, EVENT_ALL_ACCESS);
	event_token = uwp_sock->datagram_sock->MessageReceived += 
	    ref new TypedEventHandler<DatagramSocket^, 
				      DatagramSocketMessageReceivedEventArgs^>
		    (this, &PjUwpSocketDatagramRecvHelper::OnMessageReceived);
    }

    void OnMessageReceived(DatagramSocket ^sender,
			   DatagramSocketMessageReceivedEventArgs ^args)
    {
	try {
	    if (uwp_sock->sock_state >= SOCKSTATE_DISCONNECTED)
		return;

	    recv_args = args;
	    avail_data_len = args->GetDataReader()->UnconsumedBufferLength;

	    if (uwp_sock->cb.on_read) {
		(*uwp_sock->cb.on_read)(uwp_sock, avail_data_len);
	    }

	    WaitForSingleObjectEx(recv_wait, INFINITE, false);
	} catch (...) {}
    }

    pj_status_t ReadDataIfAvailable(void *buf, pj_ssize_t *len,
				    pj_sockaddr_t *from)
    {
	if (avail_data_len <= 0)
	    return PJ_ENOTFOUND;

	if (*len < avail_data_len)
	    return PJ_ETOOSMALL;

	// Read data
	auto reader = recv_args->GetDataReader();
	auto buffer = reader->ReadBuffer(avail_data_len);
	unsigned char *p;
	GetRawBufferFromIBuffer(buffer, &p);
	pj_memcpy((void*) buf, p, avail_data_len);
	*len = avail_data_len;

	// Get source address
	wstr_addr_to_sockaddr(recv_args->RemoteAddress->CanonicalName->Data(),
			      recv_args->RemotePort->Data(), from);

	// finally
	avail_data_len = 0;
	SetEvent(recv_wait);

	return PJ_SUCCESS;
    }

private:

    ~PjUwpSocketDatagramRecvHelper()
    {
	if (uwp_sock->datagram_sock)
	    uwp_sock->datagram_sock->MessageReceived -= event_token;

	SetEvent(recv_wait);
	CloseHandle(recv_wait);
    }

    PjUwpSocket* uwp_sock;
    DatagramSocketMessageReceivedEventArgs^ recv_args;
    EventRegistrationToken event_token;
    HANDLE recv_wait;
    int avail_data_len;
};


ref class PjUwpSocketListenerHelper sealed
{
internal:
    PjUwpSocketListenerHelper(PjUwpSocket* uwp_sock_) :
	uwp_sock(uwp_sock_), conn_args(nullptr)
    {
	conn_wait = CreateEventEx(nullptr, nullptr, 0, EVENT_ALL_ACCESS);
	event_token = uwp_sock->listener_sock->ConnectionReceived +=
	    ref new TypedEventHandler<StreamSocketListener^, StreamSocketListenerConnectionReceivedEventArgs^>
	    (this, &PjUwpSocketListenerHelper::OnConnectionReceived);
    }

    void OnConnectionReceived(StreamSocketListener ^sender,
	StreamSocketListenerConnectionReceivedEventArgs ^args)
    {
	try {
	    conn_args = args;

	    if (uwp_sock->cb.on_accept) {
		(*uwp_sock->cb.on_accept)(uwp_sock);
	    }

	    WaitForSingleObjectEx(conn_wait, INFINITE, false);
	} catch (Exception^ e) {}
    }

    pj_status_t GetAcceptedSocket(StreamSocket^& stream_sock)
    {
	if (conn_args == nullptr)
	    return PJ_ENOTFOUND;

	stream_sock = conn_args->Socket;

	// finally
	conn_args = nullptr;
	SetEvent(conn_wait);

	return PJ_SUCCESS;
    }

private:

    ~PjUwpSocketListenerHelper()
    {
	if (uwp_sock->listener_sock)
	    uwp_sock->listener_sock->ConnectionReceived -= event_token;

	SetEvent(conn_wait);
	CloseHandle(conn_wait);
    }

    PjUwpSocket* uwp_sock;
    StreamSocketListenerConnectionReceivedEventArgs^ conn_args;
    EventRegistrationToken event_token;
    HANDLE conn_wait;
};


PjUwpSocket::PjUwpSocket(int af_, int type_, int proto_) :
    af(af_), type(type_), proto(proto_),
    sock_type(SOCKTYPE_UNKNOWN),
    sock_state(SOCKSTATE_NULL),
    is_blocking(PJ_TRUE),
    has_pending_bind(PJ_FALSE),
    has_pending_send(PJ_FALSE),
    has_pending_recv(PJ_FALSE)
{
    pj_sockaddr_init(pj_AF_INET(), &local_addr, NULL, 0);
    pj_sockaddr_init(pj_AF_INET(), &remote_addr, NULL, 0);
}

PjUwpSocket::~PjUwpSocket()
{
    DeinitSocket();
}

PjUwpSocket* PjUwpSocket::CreateAcceptSocket(Windows::Networking::Sockets::StreamSocket^ stream_sock_)
{
    PjUwpSocket *new_sock = new PjUwpSocket(pj_AF_INET(), pj_SOCK_STREAM(), 0);
    new_sock->stream_sock = stream_sock_;
    new_sock->sock_type = SOCKTYPE_STREAM;
    new_sock->sock_state = SOCKSTATE_CONNECTED;
    new_sock->socket_reader = ref new DataReader(new_sock->stream_sock->InputStream);
    new_sock->socket_writer = ref new DataWriter(new_sock->stream_sock->OutputStream);
    new_sock->socket_reader->InputStreamOptions = InputStreamOptions::Partial;
    new_sock->send_buffer = ref new Buffer(SEND_BUFFER_SIZE);
    new_sock->is_blocking = is_blocking;

    // Update local & remote address
    wstr_addr_to_sockaddr(stream_sock_->Information->RemoteAddress->CanonicalName->Data(),
			  stream_sock_->Information->RemotePort->Data(),
			  &new_sock->remote_addr);
    wstr_addr_to_sockaddr(stream_sock_->Information->LocalAddress->CanonicalName->Data(),
			  stream_sock_->Information->LocalPort->Data(),
			  &new_sock->local_addr);

    return new_sock;
}


pj_status_t PjUwpSocket::InitSocket(enum PjUwpSocketType sock_type_)
{
    PJ_ASSERT_RETURN(sock_type_ > SOCKTYPE_UNKNOWN, PJ_EINVAL);

    sock_type = sock_type_;
    if (sock_type == SOCKTYPE_LISTENER) {
	listener_sock = ref new StreamSocketListener();
    } else if (sock_type == SOCKTYPE_STREAM) {
	stream_sock = ref new StreamSocket();
    } else if (sock_type == SOCKTYPE_DATAGRAM) {
	datagram_sock = ref new DatagramSocket();
    } else {
	pj_assert(!"Invalid socket type");
	return PJ_EINVAL;
    }

    if (sock_type == SOCKTYPE_DATAGRAM || sock_type == SOCKTYPE_STREAM) {
	send_buffer = ref new Buffer(SEND_BUFFER_SIZE);
    }

    sock_state = SOCKSTATE_INITIALIZED;

    return PJ_SUCCESS;
}


void PjUwpSocket::DeinitSocket()
{
    if (stream_sock) {
	concurrency::create_task(stream_sock->CancelIOAsync()).wait();
    }
    if (datagram_sock && has_pending_send) {
	concurrency::create_task(datagram_sock->CancelIOAsync()).wait();
    }
    if (listener_sock) {
	concurrency::create_task(listener_sock->CancelIOAsync()).wait();
    }
    while (has_pending_recv) pj_thread_sleep(10);

    stream_sock = nullptr;
    datagram_sock = nullptr;
    dgram_recv_helper = nullptr;
    listener_sock = nullptr;
    listener_helper = nullptr;
    socket_writer = nullptr;
    socket_reader = nullptr;
    sock_state = SOCKSTATE_NULL;
}

pj_status_t PjUwpSocket::Bind(const pj_sockaddr_t *addr)
{
    /* Not initialized yet, socket type is perhaps TCP, just not decided yet
     * whether it is a stream or a listener.
     */
    if (sock_state < SOCKSTATE_INITIALIZED) {
	pj_sockaddr_cp(&local_addr, addr);
	has_pending_bind = PJ_TRUE;
	return PJ_SUCCESS;
    }
    
    PJ_ASSERT_RETURN(sock_state == SOCKSTATE_INITIALIZED, PJ_EINVALIDOP);
    if (sock_type != SOCKTYPE_DATAGRAM && sock_type != SOCKTYPE_LISTENER)
	return PJ_EINVALIDOP;

    if (has_pending_bind) {
	has_pending_bind = PJ_FALSE;
	if (!addr)
	    addr = &local_addr;
    }

    /* If no bound address is set, just return */
    if (!pj_sockaddr_has_addr(addr) && !pj_sockaddr_get_port(addr))
	return PJ_SUCCESS;

    if (addr != &local_addr)
	pj_sockaddr_cp(&local_addr, addr);

    HRESULT err = 0;
    concurrency::create_task([this, addr, &err]() {
	HostName ^host;
	int port;

	sockaddr_to_hostname_port(addr, host, &port);
	if (pj_sockaddr_has_addr(addr)) {
	    if (sock_type == SOCKTYPE_DATAGRAM)
		return datagram_sock->BindEndpointAsync(host, port.ToString());
	    else
		return listener_sock->BindEndpointAsync(host, port.ToString());
	} else /* if (pj_sockaddr_get_port(addr) != 0) */ {
	    if (sock_type == SOCKTYPE_DATAGRAM)
		return datagram_sock->BindServiceNameAsync(port.ToString());
	    else
		return listener_sock->BindServiceNameAsync(port.ToString());
	}
    }).then([this, &err](concurrency::task<void> t)
    {
	try {
	    if (!err)
		t.get();
	} catch (Exception^ e) {
	    err = e->HResult;
	}
    }).get();

    return (err? PJ_RETURN_OS_ERROR(err) : PJ_SUCCESS);
}


pj_status_t PjUwpSocket::SendImp(const void *buf, pj_ssize_t *len)
{
    if (has_pending_send)
	return PJ_RETURN_OS_ERROR(PJ_BLOCKING_ERROR_VAL);

    if (*len > (pj_ssize_t)send_buffer->Capacity)
	return PJ_ETOOBIG;

    CopyToIBuffer((unsigned char*)buf, *len, send_buffer);
    send_buffer->Length = *len;
    socket_writer->WriteBuffer(send_buffer);

    /* Blocking version */
    if (is_blocking) {
	pj_status_t status = PJ_SUCCESS;
	concurrency::cancellation_token_source cts;
	auto cts_token = cts.get_token();
	auto t = concurrency::create_task(socket_writer->StoreAsync(),
					  cts_token);
	*len = cancel_after_timeout(t, cts, (unsigned int)WRITE_TIMEOUT).
	    then([cts_token, &status](concurrency::task<unsigned int> t_)
	{
	    int sent = 0;
	    try {
		if (cts_token.is_canceled())
		    status = PJ_ETIMEDOUT;
		else
		    sent = t_.get();
	    } catch (Exception^ e) {
		status = PJ_RETURN_OS_ERROR(e->HResult);
	    }
	    return sent;
	}).get();

	return status;
    } 

    /* Non-blocking version */
    has_pending_send = PJ_TRUE;
    concurrency::create_task(socket_writer->StoreAsync()).
	then([this](concurrency::task<unsigned int> t_)
    {
	try {
	    unsigned int l = t_.get();
	    has_pending_send = PJ_FALSE;

	    // invoke callback
	    if (cb.on_write) {
		(*cb.on_write)(this, l);
	    }
	} catch (...) {
	    has_pending_send = PJ_FALSE;
	    sock_state = SOCKSTATE_ERROR;
	    DeinitSocket();

	    // invoke callback
	    if (cb.on_write) {
		(*cb.on_write)(this, -PJ_EUNKNOWN);
	    }
	}
    });

    return PJ_SUCCESS;
}


pj_status_t PjUwpSocket::Send(const void *buf, pj_ssize_t *len)
{
    if ((sock_type!=SOCKTYPE_STREAM && sock_type!=SOCKTYPE_DATAGRAM) ||
	(sock_state!=SOCKSTATE_CONNECTED))
    {
	return PJ_EINVALIDOP;
    }

    /* Sending for SOCKTYPE_DATAGRAM is implemented in pj_sock_sendto() */
    if (sock_type == SOCKTYPE_DATAGRAM) {
	return SendTo(buf, len, &remote_addr);
    }

    return SendImp(buf, len);
}


pj_status_t PjUwpSocket::SendTo(const void *buf, pj_ssize_t *len,
				const pj_sockaddr_t *to)
{
    if (sock_type != SOCKTYPE_DATAGRAM || sock_state < SOCKSTATE_INITIALIZED
	|| sock_state >= SOCKSTATE_DISCONNECTED)
    {
	return PJ_EINVALIDOP;
    }

    if (has_pending_send)
	return PJ_RETURN_OS_ERROR(PJ_BLOCKING_ERROR_VAL);

    if (*len > (pj_ssize_t)send_buffer->Capacity)
	return PJ_ETOOBIG;

    HostName ^hostname;
    int port;
    sockaddr_to_hostname_port(to, hostname, &port);

    concurrency::cancellation_token_source cts;
    auto cts_token = cts.get_token();
    auto t = concurrency::create_task(datagram_sock->GetOutputStreamAsync(
				      hostname, port.ToString()), cts_token);
    pj_status_t status = PJ_SUCCESS;

    cancel_after_timeout(t, cts, (unsigned int)WRITE_TIMEOUT).
	then([this, cts_token, &status](concurrency::task<IOutputStream^> t_)
    {
	try {
	    if (cts_token.is_canceled()) {
		status = PJ_ETIMEDOUT;
	    } else {
		IOutputStream^ outstream = t_.get();
		socket_writer = ref new DataWriter(outstream);
	    }
	} catch (Exception^ e) {
	    status = PJ_RETURN_OS_ERROR(e->HResult);
	}
    }).get();

    if (status != PJ_SUCCESS)
	return status;

    status = SendImp(buf, len);
    if ((status == PJ_SUCCESS || status == PJ_EPENDING) &&
	sock_state < SOCKSTATE_CONNECTED)
    {
	sock_state = SOCKSTATE_CONNECTED;
    }

    return status;
}


int PjUwpSocket::ConsumeReadBuffer(void *buf, int max_len)
{
    if (socket_reader->UnconsumedBufferLength == 0)
	return 0;

    int read_len = PJ_MIN((int)socket_reader->UnconsumedBufferLength,max_len);
    IBuffer^ buffer = socket_reader->ReadBuffer(read_len);
    read_len = buffer->Length;
    CopyFromIBuffer((unsigned char*)buf, read_len, buffer);
    return read_len;
}


pj_status_t PjUwpSocket::Recv(void *buf, pj_ssize_t *len)
{
    /* Only for TCP, at least for now! */
    if (sock_type == SOCKTYPE_DATAGRAM)
	return PJ_ENOTSUP;

    if (sock_type != SOCKTYPE_STREAM || sock_state != SOCKSTATE_CONNECTED)
	return PJ_EINVALIDOP;

    if (has_pending_recv)
	return PJ_RETURN_OS_ERROR(PJ_BLOCKING_ERROR_VAL);

    /* First check if there is already some data in the read buffer */
    if (buf) {
	int avail_len = ConsumeReadBuffer(buf, *len);
	if (avail_len > 0) {
	    *len = avail_len;
	    return PJ_SUCCESS;
	}
    }

    /* Blocking version */
    if (is_blocking) {
	pj_status_t status = PJ_SUCCESS;
	concurrency::cancellation_token_source cts;
	auto cts_token = cts.get_token();
	auto t = concurrency::create_task(socket_reader->LoadAsync(*len),
					  cts_token);
	*len = cancel_after_timeout(t, cts, READ_TIMEOUT)
	    .then([this, len, buf, cts_token, &status]
				    (concurrency::task<unsigned int> t_)
	{
	    try {
		if (cts_token.is_canceled()) {
		    status = PJ_ETIMEDOUT;
		    return 0;
		}
		t_.get();
	    } catch (Exception^) {
		status = PJ_ETIMEDOUT;
		return 0;
	    }

	    *len = ConsumeReadBuffer(buf, *len);
	    return (int)*len;
	}).get();

	return status;
    }

    /* Non-blocking version */

    concurrency::cancellation_token_source cts;
    auto cts_token = cts.get_token();

    has_pending_recv = PJ_TRUE;
    concurrency::create_task(socket_reader->LoadAsync(*len), cts_token)
	.then([this, cts_token](concurrency::task<unsigned int> t_)
    {
	try {
	    if (cts_token.is_canceled()) {
		has_pending_recv = PJ_FALSE;

		// invoke callback
		if (cb.on_read) {
		    (*cb.on_read)(this, -PJ_EUNKNOWN);
		}
		return;
	    }

	    t_.get();
	    has_pending_recv = PJ_FALSE;

	    // invoke callback
	    int read_len = socket_reader->UnconsumedBufferLength;
	    if (read_len > 0 && cb.on_read) {
		(*cb.on_read)(this, read_len);
	    }
	} catch (...) {
	    has_pending_recv = PJ_FALSE;

	    // invoke callback
	    if (cb.on_read) {
		(*cb.on_read)(this, -PJ_EUNKNOWN);
	    }
	}
    });

    return PJ_RETURN_OS_ERROR(PJ_BLOCKING_ERROR_VAL);
}


pj_status_t PjUwpSocket::RecvFrom(void *buf, pj_ssize_t *len,
				  pj_sockaddr_t *from)
{
    if (sock_type != SOCKTYPE_DATAGRAM || sock_state < SOCKSTATE_INITIALIZED
	|| sock_state >= SOCKSTATE_DISCONNECTED)
    {
	return PJ_EINVALIDOP;
    }

    /* Start receive, if not yet */
    if (dgram_recv_helper == nullptr) {
	dgram_recv_helper = ref new PjUwpSocketDatagramRecvHelper(this);
    }

    /* Try to read any available data first */
    if (buf || is_blocking) {
	pj_status_t status;
	status = dgram_recv_helper->ReadDataIfAvailable(buf, len, from);
	if (status != PJ_ENOTFOUND)
	    return status;
    }

    /* Blocking version */
    if (is_blocking) {
	int max_loop = 0;
	pj_status_t status = PJ_ENOTFOUND;
	while (status == PJ_ENOTFOUND && sock_state <= SOCKSTATE_CONNECTED)
	{
	    status = dgram_recv_helper->ReadDataIfAvailable(buf, len, from);
	    if (status != PJ_SUCCESS)
		pj_thread_sleep(100);

	    if (++max_loop > 10)
		return PJ_ETIMEDOUT;
	}
	return status;
    }

    /* For non-blocking version, just return PJ_EPENDING */
    return PJ_RETURN_OS_ERROR(PJ_BLOCKING_ERROR_VAL);
}


pj_status_t PjUwpSocket::Connect(const pj_sockaddr_t *addr)
{
    pj_status_t status;

    PJ_ASSERT_RETURN((sock_type == SOCKTYPE_UNKNOWN && sock_state == SOCKSTATE_NULL) ||
		     (sock_type == SOCKTYPE_DATAGRAM && sock_state == SOCKSTATE_INITIALIZED),
		     PJ_EINVALIDOP);

    if (sock_type == SOCKTYPE_UNKNOWN) {
	InitSocket(SOCKTYPE_STREAM);
	// No need to check pending bind, no bind for TCP client socket
    }

    pj_sockaddr_cp(&remote_addr, addr);

    auto t = concurrency::create_task([this, addr]()
    {
	HostName ^hostname;
	int port;
	sockaddr_to_hostname_port(&remote_addr, hostname, &port);
	if (sock_type == SOCKTYPE_STREAM)
	    return stream_sock->ConnectAsync(hostname, port.ToString(),
				      SocketProtectionLevel::PlainSocket);
	else
	    return datagram_sock->ConnectAsync(hostname, port.ToString());
    }).then([=](concurrency::task<void> t_)
    {
	try {
	    t_.get();

	    sock_state = SOCKSTATE_CONNECTED;

	    // Update local & remote address
	    HostName^ local_address;
	    String^ local_port;

	    if (sock_type == SOCKTYPE_STREAM) {
		local_address = stream_sock->Information->LocalAddress;
		local_port = stream_sock->Information->LocalPort;

		socket_reader = ref new DataReader(stream_sock->InputStream);
		socket_writer = ref new DataWriter(stream_sock->OutputStream);
		socket_reader->InputStreamOptions = InputStreamOptions::Partial;
	    } else {
		local_address = datagram_sock->Information->LocalAddress;
		local_port = datagram_sock->Information->LocalPort;
	    }
	    if (local_address && local_port) {
		wstr_addr_to_sockaddr(local_address->CanonicalName->Data(),
		    local_port->Data(),
		    &local_addr);
	    }

	    if (!is_blocking && cb.on_connect) {
		(*cb.on_connect)(this, PJ_SUCCESS);
	    }
	    return (pj_status_t)PJ_SUCCESS;

	} catch (Exception^ ex) {

	    SocketErrorStatus status = SocketError::GetStatus(ex->HResult);

	    switch (status)
	    {
	    case SocketErrorStatus::UnreachableHost:
		break;
	    case SocketErrorStatus::ConnectionTimedOut:
		break;
	    case SocketErrorStatus::ConnectionRefused:
		break;
	    default:
		break;
	    }

	    if (!is_blocking && cb.on_connect) {
		(*cb.on_connect)(this, PJ_EUNKNOWN);
	    }

	    return (pj_status_t)PJ_EUNKNOWN;
	}
    });

    if (!is_blocking)
	return PJ_RETURN_OS_ERROR(PJ_BLOCKING_CONNECT_ERROR_VAL);

    try {
	status = t.get();
    } catch (Exception^) {
	return PJ_EUNKNOWN;
    }
    return status;
}

pj_status_t PjUwpSocket::Listen()
{
    PJ_ASSERT_RETURN((sock_type == SOCKTYPE_UNKNOWN) ||
		     (sock_type == SOCKTYPE_LISTENER &&
		      sock_state == SOCKSTATE_INITIALIZED),
		     PJ_EINVALIDOP);

    if (sock_type == SOCKTYPE_UNKNOWN)
	InitSocket(SOCKTYPE_LISTENER);

    if (has_pending_bind)
	Bind();

    /* Start listen */
    if (listener_helper == nullptr) {
	listener_helper = ref new PjUwpSocketListenerHelper(this);
    }

    return PJ_SUCCESS;
}

pj_status_t PjUwpSocket::Accept(PjUwpSocket **new_sock)
{
    if (sock_type != SOCKTYPE_LISTENER || sock_state != SOCKSTATE_INITIALIZED)
	return PJ_EINVALIDOP;

    StreamSocket^ accepted_sock;
    pj_status_t status = listener_helper->GetAcceptedSocket(accepted_sock);
    if (status == PJ_ENOTFOUND)
	return PJ_RETURN_OS_ERROR(PJ_BLOCKING_ERROR_VAL);

    if (status != PJ_SUCCESS)
	return status;

    *new_sock = CreateAcceptSocket(accepted_sock);
    return PJ_SUCCESS;
}


/////////////////////////////////////////////////////////////////////////////
//
// PJLIB's sock.h implementation
//

/*
 * Convert 16-bit value from network byte order to host byte order.
 */
PJ_DEF(pj_uint16_t) pj_ntohs(pj_uint16_t netshort)
{
    return ntohs(netshort);
}

/*
 * Convert 16-bit value from host byte order to network byte order.
 */
PJ_DEF(pj_uint16_t) pj_htons(pj_uint16_t hostshort)
{
    return htons(hostshort);
}

/*
 * Convert 32-bit value from network byte order to host byte order.
 */
PJ_DEF(pj_uint32_t) pj_ntohl(pj_uint32_t netlong)
{
    return ntohl(netlong);
}

/*
 * Convert 32-bit value from host byte order to network byte order.
 */
PJ_DEF(pj_uint32_t) pj_htonl(pj_uint32_t hostlong)
{
    return htonl(hostlong);
}

/*
 * Convert an Internet host address given in network byte order
 * to string in standard numbers and dots notation.
 */
PJ_DEF(char*) pj_inet_ntoa(pj_in_addr inaddr)
{
    return inet_ntoa(*(struct in_addr*)&inaddr);
}

/*
 * This function converts the Internet host address cp from the standard
 * numbers-and-dots notation into binary data and stores it in the structure
 * that inp points to. 
 */
PJ_DEF(int) pj_inet_aton(const pj_str_t *cp, pj_in_addr *inp)
{
    char tempaddr[PJ_INET_ADDRSTRLEN];

    /* Initialize output with PJ_INADDR_NONE.
    * Some apps relies on this instead of the return value
    * (and anyway the return value is quite confusing!)
    */
    inp->s_addr = PJ_INADDR_NONE;

    /* Caution:
    *	this function might be called with cp->slen >= 16
    *  (i.e. when called with hostname to check if it's an IP addr).
    */
    PJ_ASSERT_RETURN(cp && cp->slen && inp, 0);
    if (cp->slen >= PJ_INET_ADDRSTRLEN) {
	return 0;
    }

    pj_memcpy(tempaddr, cp->ptr, cp->slen);
    tempaddr[cp->slen] = '\0';

#if defined(PJ_SOCK_HAS_INET_ATON) && PJ_SOCK_HAS_INET_ATON != 0
    return inet_aton(tempaddr, (struct in_addr*)inp);
#else
    inp->s_addr = inet_addr(tempaddr);
    return inp->s_addr == PJ_INADDR_NONE ? 0 : 1;
#endif
}

/*
 * Convert text to IPv4/IPv6 address.
 */
PJ_DEF(pj_status_t) pj_inet_pton(int af, const pj_str_t *src, void *dst)
{
    char tempaddr[PJ_INET6_ADDRSTRLEN];

    PJ_ASSERT_RETURN(af == PJ_AF_INET || af == PJ_AF_INET6, PJ_EAFNOTSUP);
    PJ_ASSERT_RETURN(src && src->slen && dst, PJ_EINVAL);

    /* Initialize output with PJ_IN_ADDR_NONE for IPv4 (to be
    * compatible with pj_inet_aton()
    */
    if (af == PJ_AF_INET) {
	((pj_in_addr*)dst)->s_addr = PJ_INADDR_NONE;
    }

    /* Caution:
    *	this function might be called with cp->slen >= 46
    *  (i.e. when called with hostname to check if it's an IP addr).
    */
    if (src->slen >= PJ_INET6_ADDRSTRLEN) {
	return PJ_ENAMETOOLONG;
    }

    pj_memcpy(tempaddr, src->ptr, src->slen);
    tempaddr[src->slen] = '\0';

#if defined(PJ_SOCK_HAS_INET_PTON) && PJ_SOCK_HAS_INET_PTON != 0
    /*
    * Implementation using inet_pton()
    */
    if (inet_pton(af, tempaddr, dst) != 1) {
	pj_status_t status = pj_get_netos_error();
	if (status == PJ_SUCCESS)
	    status = PJ_EUNKNOWN;

	return status;
    }

    return PJ_SUCCESS;

#elif defined(PJ_WIN32) || defined(PJ_WIN64) || defined(PJ_WIN32_WINCE)
    /*
    * Implementation on Windows, using WSAStringToAddress().
    * Should also work on Unicode systems.
    */
    {
	PJ_DECL_UNICODE_TEMP_BUF(wtempaddr, PJ_INET6_ADDRSTRLEN)
	    pj_sockaddr sock_addr;
	int addr_len = sizeof(sock_addr);
	int rc;

	sock_addr.addr.sa_family = (pj_uint16_t)af;
	rc = WSAStringToAddress(
	    PJ_STRING_TO_NATIVE(tempaddr, wtempaddr, sizeof(wtempaddr)),
	    af, NULL, (LPSOCKADDR)&sock_addr, &addr_len);
	if (rc != 0) {
	    /* If you get rc 130022 Invalid argument (WSAEINVAL) with IPv6,
	    * check that you have IPv6 enabled (install it in the network
	    * adapter).
	    */
	    pj_status_t status = pj_get_netos_error();
	    if (status == PJ_SUCCESS)
		status = PJ_EUNKNOWN;

	    return status;
	}

	if (sock_addr.addr.sa_family == PJ_AF_INET) {
	    pj_memcpy(dst, &sock_addr.ipv4.sin_addr, 4);
	    return PJ_SUCCESS;
	}
	else if (sock_addr.addr.sa_family == PJ_AF_INET6) {
	    pj_memcpy(dst, &sock_addr.ipv6.sin6_addr, 16);
	    return PJ_SUCCESS;
	}
	else {
	    pj_assert(!"Shouldn't happen");
	    return PJ_EBUG;
	}
    }
#elif !defined(PJ_HAS_IPV6) || PJ_HAS_IPV6==0
    /* IPv6 support is disabled, just return error without raising assertion */
    return PJ_EIPV6NOTSUP;
#else
    pj_assert(!"Not supported");
    return PJ_EIPV6NOTSUP;
#endif
}

/*
 * Convert IPv4/IPv6 address to text.
 */
PJ_DEF(pj_status_t) pj_inet_ntop(int af, const void *src,
				 char *dst, int size)

{
    PJ_ASSERT_RETURN(src && dst && size, PJ_EINVAL);
    PJ_ASSERT_RETURN(af == PJ_AF_INET || af == PJ_AF_INET6, PJ_EAFNOTSUP);

    *dst = '\0';

#if defined(PJ_SOCK_HAS_INET_NTOP) && PJ_SOCK_HAS_INET_NTOP != 0
    /*
    * Implementation using inet_ntop()
    */
    if (inet_ntop(af, src, dst, size) == NULL) {
	pj_status_t status = pj_get_netos_error();
	if (status == PJ_SUCCESS)
	    status = PJ_EUNKNOWN;

	return status;
    }

    return PJ_SUCCESS;

#elif defined(PJ_WIN32) || defined(PJ_WIN64) || defined(PJ_WIN32_WINCE)
    /*
    * Implementation on Windows, using WSAAddressToString().
    * Should also work on Unicode systems.
    */
    {
	PJ_DECL_UNICODE_TEMP_BUF(wtempaddr, PJ_INET6_ADDRSTRLEN)
	    pj_sockaddr sock_addr;
	DWORD addr_len, addr_str_len;
	int rc;

	pj_bzero(&sock_addr, sizeof(sock_addr));
	sock_addr.addr.sa_family = (pj_uint16_t)af;
	if (af == PJ_AF_INET) {
	    if (size < PJ_INET_ADDRSTRLEN)
		return PJ_ETOOSMALL;
	    pj_memcpy(&sock_addr.ipv4.sin_addr, src, 4);
	    addr_len = sizeof(pj_sockaddr_in);
	    addr_str_len = PJ_INET_ADDRSTRLEN;
	}
	else if (af == PJ_AF_INET6) {
	    if (size < PJ_INET6_ADDRSTRLEN)
		return PJ_ETOOSMALL;
	    pj_memcpy(&sock_addr.ipv6.sin6_addr, src, 16);
	    addr_len = sizeof(pj_sockaddr_in6);
	    addr_str_len = PJ_INET6_ADDRSTRLEN;
	}
	else {
	    pj_assert(!"Unsupported address family");
	    return PJ_EAFNOTSUP;
	}

#if PJ_NATIVE_STRING_IS_UNICODE
	rc = WSAAddressToString((LPSOCKADDR)&sock_addr, addr_len,
	    NULL, wtempaddr, &addr_str_len);
	if (rc == 0) {
	    pj_unicode_to_ansi(wtempaddr, wcslen(wtempaddr), dst, size);
	}
#else
	rc = WSAAddressToString((LPSOCKADDR)&sock_addr, addr_len,
	    NULL, dst, &addr_str_len);
#endif

	if (rc != 0) {
	    pj_status_t status = pj_get_netos_error();
	    if (status == PJ_SUCCESS)
		status = PJ_EUNKNOWN;

	    return status;
	}

	return PJ_SUCCESS;
    }

#elif !defined(PJ_HAS_IPV6) || PJ_HAS_IPV6==0
    /* IPv6 support is disabled, just return error without raising assertion */
    return PJ_EIPV6NOTSUP;
#else
    pj_assert(!"Not supported");
    return PJ_EIPV6NOTSUP;
#endif
}

/*
 * Get hostname.
 */
PJ_DEF(const pj_str_t*) pj_gethostname(void)
{
    static char buf[PJ_MAX_HOSTNAME];
    static pj_str_t hostname;

    PJ_CHECK_STACK();

    if (hostname.ptr == NULL) {
	hostname.ptr = buf;
	if (gethostname(buf, sizeof(buf)) != 0) {
	    hostname.ptr[0] = '\0';
	    hostname.slen = 0;
	}
	else {
	    hostname.slen = strlen(buf);
	}
    }
    return &hostname;
}

/*
 * Create new socket/endpoint for communication and returns a descriptor.
 */
PJ_DEF(pj_status_t) pj_sock_socket(int af, 
				   int type, 
				   int proto,
				   pj_sock_t *p_sock)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(p_sock!=NULL, PJ_EINVAL);

    PjUwpSocket *s = new PjUwpSocket(af, type, proto);
    
    /* Init UDP socket here */
    if (type == pj_SOCK_DGRAM_MED() || type == pj_SOCK_DGRAM_SIG()) {
	s->InitSocket(SOCKTYPE_DATAGRAM);
    }

    *p_sock = (pj_sock_t)s;
    return PJ_SUCCESS;
}


/*
 * Bind socket.
 */
PJ_DEF(pj_status_t) pj_sock_bind( pj_sock_t sock, 
				  const pj_sockaddr_t *addr,
				  int len)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sock, PJ_EINVAL);
    PJ_ASSERT_RETURN(addr && len>=(int)sizeof(pj_sockaddr_in), PJ_EINVAL);
    PjUwpSocket *s = (PjUwpSocket*)sock;
    return s->Bind(addr);
}


/*
 * Bind socket.
 */
PJ_DEF(pj_status_t) pj_sock_bind_in( pj_sock_t sock, 
				     pj_uint32_t addr32,
				     pj_uint16_t port)
{
    pj_sockaddr_in addr;

    PJ_CHECK_STACK();

    pj_bzero(&addr, sizeof(addr));
    addr.sin_family = PJ_AF_INET;
    addr.sin_addr.s_addr = pj_htonl(addr32);
    addr.sin_port = pj_htons(port);

    return pj_sock_bind(sock, &addr, sizeof(pj_sockaddr_in));
}


/*
 * Close socket.
 */
PJ_DEF(pj_status_t) pj_sock_close(pj_sock_t sock)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sock, PJ_EINVAL);

    if (sock == PJ_INVALID_SOCKET)
	return PJ_SUCCESS;

    PjUwpSocket *s = (PjUwpSocket*)sock;
    delete s;

    return PJ_SUCCESS;
}

/*
 * Get remote's name.
 */
PJ_DEF(pj_status_t) pj_sock_getpeername( pj_sock_t sock,
					 pj_sockaddr_t *addr,
					 int *namelen)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sock && addr && namelen && 
		     *namelen>=(int)sizeof(pj_sockaddr_in), PJ_EINVAL);

    PjUwpSocket *s = (PjUwpSocket*)sock;
    pj_sockaddr_cp(addr, s->GetRemoteAddr());
    *namelen = pj_sockaddr_get_len(addr);

    return PJ_SUCCESS;
}

/*
 * Get socket name.
 */
PJ_DEF(pj_status_t) pj_sock_getsockname( pj_sock_t sock,
					 pj_sockaddr_t *addr,
					 int *namelen)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sock && addr && namelen && 
		     *namelen>=(int)sizeof(pj_sockaddr_in), PJ_EINVAL);

    PjUwpSocket *s = (PjUwpSocket*)sock;
    pj_sockaddr_cp(addr, s->GetLocalAddr());
    *namelen = pj_sockaddr_get_len(addr);

    return PJ_SUCCESS;
}


/*
 * Send data
 */
PJ_DEF(pj_status_t) pj_sock_send(pj_sock_t sock,
				 const void *buf,
				 pj_ssize_t *len,
				 unsigned flags)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sock && buf && len, PJ_EINVAL);
    PJ_UNUSED_ARG(flags);

    PjUwpSocket *s = (PjUwpSocket*)sock;
    return s->Send(buf, len);
}


/*
 * Send data.
 */
PJ_DEF(pj_status_t) pj_sock_sendto(pj_sock_t sock,
				   const void *buf,
				   pj_ssize_t *len,
				   unsigned flags,
				   const pj_sockaddr_t *to,
				   int tolen)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sock && buf && len, PJ_EINVAL);
    PJ_UNUSED_ARG(flags);
    PJ_UNUSED_ARG(tolen);
    
    PjUwpSocket *s = (PjUwpSocket*)sock;
    return s->SendTo(buf, len, to);
}


/*
 * Receive data.
 */
PJ_DEF(pj_status_t) pj_sock_recv(pj_sock_t sock,
				 void *buf,
				 pj_ssize_t *len,
				 unsigned flags)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sock && len && *len > 0, PJ_EINVAL);
    
    PJ_UNUSED_ARG(flags);

    PjUwpSocket *s = (PjUwpSocket*)sock;
    return s->Recv(buf, len);
}

/*
 * Receive data.
 */
PJ_DEF(pj_status_t) pj_sock_recvfrom(pj_sock_t sock,
				     void *buf,
				     pj_ssize_t *len,
				     unsigned flags,
				     pj_sockaddr_t *from,
				     int *fromlen)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sock && buf && len && from && fromlen, PJ_EINVAL);
    PJ_ASSERT_RETURN(*len > 0, PJ_EINVAL);
    PJ_ASSERT_RETURN(*fromlen >= (int)sizeof(pj_sockaddr_in), PJ_EINVAL);

    PJ_UNUSED_ARG(flags);

    PjUwpSocket *s = (PjUwpSocket*)sock;
    pj_status_t status = s->RecvFrom(buf, len, from);
    if (status == PJ_SUCCESS)
	*fromlen = pj_sockaddr_get_len(from);
    return status;
}

/*
 * Get socket option.
 */
PJ_DEF(pj_status_t) pj_sock_getsockopt( pj_sock_t sock,
					pj_uint16_t level,
					pj_uint16_t optname,
					void *optval,
					int *optlen)
{
    // Not supported for now.
    PJ_UNUSED_ARG(sock);
    PJ_UNUSED_ARG(level);
    PJ_UNUSED_ARG(optname);
    PJ_UNUSED_ARG(optval);
    PJ_UNUSED_ARG(optlen);
    return PJ_ENOTSUP;
}


/*
 * Set socket option.
 */
PJ_DEF(pj_status_t) pj_sock_setsockopt( pj_sock_t sock,
					pj_uint16_t level,
					pj_uint16_t optname,
					const void *optval,
					int optlen)
{
    // Not supported for now.
    PJ_UNUSED_ARG(sock);
    PJ_UNUSED_ARG(level);
    PJ_UNUSED_ARG(optname);
    PJ_UNUSED_ARG(optval);
    PJ_UNUSED_ARG(optlen);
    return PJ_ENOTSUP;
}


/*
* Set socket option.
*/
PJ_DEF(pj_status_t) pj_sock_setsockopt_params( pj_sock_t sockfd,
    const pj_sockopt_params *params)
{
    unsigned int i = 0;
    pj_status_t retval = PJ_SUCCESS;
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(params, PJ_EINVAL);

    for (;i<params->cnt && i<PJ_MAX_SOCKOPT_PARAMS;++i) {
	pj_status_t status = pj_sock_setsockopt(sockfd, 
				    (pj_uint16_t)params->options[i].level,
				    (pj_uint16_t)params->options[i].optname,
				    params->options[i].optval, 
				    params->options[i].optlen);
	if (status != PJ_SUCCESS) {
	    retval = status;
	    PJ_PERROR(4,(THIS_FILE, status,
			 "Warning: error applying sock opt %d",
			 params->options[i].optname));
	}
    }

    return retval;
}


/*
 * Connect socket.
 */
PJ_DEF(pj_status_t) pj_sock_connect( pj_sock_t sock,
				     const pj_sockaddr_t *addr,
				     int namelen)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sock && addr, PJ_EINVAL);
    PJ_UNUSED_ARG(namelen);

    PjUwpSocket *s = (PjUwpSocket*)sock;
    return s->Connect(addr);
}


/*
 * Shutdown socket.
 */
#if PJ_HAS_TCP
PJ_DEF(pj_status_t) pj_sock_shutdown( pj_sock_t sock,
				      int how)
{
    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sock, PJ_EINVAL);
    PJ_UNUSED_ARG(how);

    return pj_sock_close(sock);
}

/*
 * Start listening to incoming connections.
 */
PJ_DEF(pj_status_t) pj_sock_listen( pj_sock_t sock,
				    int backlog)
{
    PJ_CHECK_STACK();
    PJ_UNUSED_ARG(backlog);
    PJ_ASSERT_RETURN(sock, PJ_EINVAL);

    PjUwpSocket *s = (PjUwpSocket*)sock;
    return s->Listen();
}

/*
 * Accept incoming connections
 */
PJ_DEF(pj_status_t) pj_sock_accept( pj_sock_t serverfd,
				    pj_sock_t *newsock,
				    pj_sockaddr_t *addr,
				    int *addrlen)
{
    pj_status_t status;

    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(serverfd && newsock, PJ_EINVAL);

    PjUwpSocket *s = (PjUwpSocket*)serverfd;
    PjUwpSocket *new_uwp_sock;

    status = s->Accept(&new_uwp_sock);
    if (status != PJ_SUCCESS)
	return status;
    if (newsock == NULL)
	return PJ_ENOTFOUND;

    *newsock = (pj_sock_t)new_uwp_sock;

    if (addr)
	pj_sockaddr_cp(addr, new_uwp_sock->GetRemoteAddr());

    if (addrlen)
	*addrlen = pj_sockaddr_get_len(addr);

    return PJ_SUCCESS;
}
#endif	/* PJ_HAS_TCP */
