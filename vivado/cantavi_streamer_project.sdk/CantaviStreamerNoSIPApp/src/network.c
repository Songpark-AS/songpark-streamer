/*
 * network.c
 *
 *  Created on: Mar 13, 2021
 *      Author: thanx
 */


#include "network.h"
#include "ui_control.h"
#include "log.h"
#include <errno.h>


//#define debug(x...) printf(x);printf("\n");
//#define info(x...) printf(x);printf("\n");
//#define warn(x...) printf(x);printf("\n");
//#define err(x...) printf(x);printf("\n");

//#define debug(x...) PJ_LOG(3,(THIS_FILE, x));
//#define info(x...) info( x));
//#define warn(x...) PJ_LOG(2,(THIS_FILE, x));
////#define err(x...) pjsua_perror(THIS_FILE, (x), -7);
//#define err(x...) PJ_LOG(1,(THIS_FILE, x));

//#define debug(x...) do{ printf("DEBUG::"); printf(x); printf("\n");}while(0)
//#define info(x...) do{ printf("INFO::"); printf(x); printf("\n");}while(0)
//#define warn(x...) do{ printf("WARN::"); printf(x); printf("\n");}while(0)
//#define err(x...) do{ printf("ERROR::"); printf(x); printf("\n");}while(0)


/*
Function : extractIpAddress
Arguments :
1) sourceString - String pointer that contains ip address
2) ipAddress - Target variable short type array pointer that will store ip address octets
*/
void extractIpAddress(unsigned char *sourceString,unsigned char *ipAddress)
{
    unsigned short len=0;
    unsigned char  oct[4]={0},cnt=0,cnt1=0,i,buf[5];

    len=strlen(sourceString);
    for(i=0;i<len;i++)
    {
        if(sourceString[i]!='.'){
            buf[cnt++] =sourceString[i];
        }
        if(sourceString[i]=='.' || i==len-1){
            buf[cnt]='\0';
            cnt=0;
            oct[cnt1++]=atoi(buf);
        }
    }
    ipAddress[0]=oct[0];
    ipAddress[1]=oct[1];
    ipAddress[2]=oct[2];
    ipAddress[3]=oct[3];
}

char * print_ip(unsigned int ip, unsigned char * bytes)
{
//    unsigned char bytes[4];
    bytes[0] = ip & 0xFF;
    bytes[1] = (ip >> 8) & 0xFF;
    bytes[2] = (ip >> 16) & 0xFF;
    bytes[3] = (ip >> 24) & 0xFF;
    bytes[4] = 0;
    info("%d.%d.%d.%d\n", bytes[3], bytes[2], bytes[1], bytes[0]);
    sprintf(bytes, "%d.%d.%d.%d\0", bytes[3], bytes[2], bytes[1], bytes[0]);
    return bytes;
}


char * print_mac(unsigned long ip, unsigned char * bytes)
{

    bytes[0] = ip & 0xFF;
    bytes[1] = (ip >> 8) & 0xFF;
    bytes[2] = (ip >> 16) & 0xFF;
    bytes[3] = (ip >> 24) & 0xFF;
    bytes[4] = (ip >> 32) & 0xFF;
    bytes[5] = (ip >> 40) & 0xFF;
    bytes[6] = 0;
    info("%d.%d.%d.%d\n", bytes[5], bytes[4], bytes[3], bytes[2], bytes[1], bytes[0]);
    return bytes;
}


/*
Function : extractIpAddress
Arguments :
1) sourceString - String pointer that contains ip address
2) macAddress - Target variable short type array pointer that will store ip address octets
*/
void extractMacAddress(unsigned char *sourceString,unsigned char *macAddress)
{
    unsigned short len=0;
    unsigned char  oct[6]={0},cnt=0,cnt1=0,i,buf[5];

    len=strlen(sourceString);
    for(i=0;i<len;i++)
    {
        if(sourceString[i]!='.'){
            buf[cnt++] =sourceString[i];
        }
        if(sourceString[i]=='.' || i==len-1){
            buf[cnt]='\0';
            cnt=0;
            //oct[cnt1++]=atoi(buf);
            oct[cnt1++]=(unsigned char)strtol(buf, NULL, 16);
        }
    }
    macAddress[0]=oct[0];
    macAddress[1]=oct[1];
    macAddress[2]=oct[2];
    macAddress[3]=oct[3];
    macAddress[4]=oct[4];
    macAddress[5]=oct[5];
}


void extractColonMacAddress(unsigned char *sourceString,unsigned char *macAddress)
{
    unsigned short len=0;
    unsigned char  oct[6]={0},cnt=0,cnt1=0,i,buf[5];

    len=strlen(sourceString);
    for(i=0;i<len;i++)
    {
        if(sourceString[i]!=':'){
            buf[cnt++] =sourceString[i];
        }
        if(sourceString[i]==':' || i==len-1){
            buf[cnt]='\0';
            cnt=0;
            //oct[cnt1++]=atoi(buf);
            oct[cnt1++]=(unsigned char)strtol(buf, NULL, 16);
        }
    }
    macAddress[0]=oct[0];
    macAddress[1]=oct[1];
    macAddress[2]=oct[2];
    macAddress[3]=oct[3];
    macAddress[4]=oct[4];
    macAddress[5]=oct[5];
}




int readNlSock(int sockFd, char *bufPtr, int seqNum, int pId)
{
    struct nlmsghdr *nlHdr;
    int readLen = 0, msgLen = 0;

 do {
    /* Recieve response from the kernel */
        if ((readLen = recv(sockFd, bufPtr, BUFSIZE - msgLen, 0)) < 0) {
        	err("SOCK READ Error: ");
            return -1;
        }

        nlHdr = (struct nlmsghdr *) bufPtr;

    /* Check if the header is valid */
        if ((NLMSG_OK(nlHdr, readLen) == 0)
            || (nlHdr->nlmsg_type == NLMSG_ERROR)) {
        	err("Error in recieved packet");
            return -1;
        }

    /* Check if the its the last message */
        if (nlHdr->nlmsg_type == NLMSG_DONE) {
            break;
        } else {
    /* Else move the pointer to buffer appropriately */
            bufPtr += readLen;
            msgLen += readLen;
        }

    /* Check if its a multi part message */
        if ((nlHdr->nlmsg_flags & NLM_F_MULTI) == 0) {
           /* return if its not */
            break;
        }
    } while ((nlHdr->nlmsg_seq != seqNum) || (nlHdr->nlmsg_pid != pId));
    return msgLen;
}
/* For printing the routes. */
void printRoute(struct route_info *rtInfo)
{
    char tempBuf[512];

/* Print Destination address */
    if (rtInfo->dstAddr.s_addr != 0)
        strcpy(tempBuf,  inet_ntoa(rtInfo->dstAddr));
    else
        sprintf(tempBuf, "*.*.*.*\t");
    info( "%s\t", tempBuf);

/* Print Gateway address */
    if (rtInfo->gateWay.s_addr != 0)
        strcpy(tempBuf, (char *) inet_ntoa(rtInfo->gateWay));
    else
        sprintf(tempBuf, "*.*.*.*\t");
    info( "%s\t", tempBuf);

    /* Print Interface Name*/
    info( "%s\t", rtInfo->ifName);

    /* Print Source address */
    if (rtInfo->srcAddr.s_addr != 0)
        strcpy(tempBuf, inet_ntoa(rtInfo->srcAddr));
    else
        sprintf(tempBuf, "*.*.*.*\t");
    info( "%s\n", tempBuf);
}

void printGateway(char *gateway)
{
	info("GW: %s\n", gateway);
}
/* For parsing the route info returned */
void parseRoutes(char *gateway, struct nlmsghdr *nlHdr, struct route_info *rtInfo)
{
    struct rtmsg *rtMsg;
    struct rtattr *rtAttr;
    int rtLen;

    rtMsg = (struct rtmsg *) NLMSG_DATA(nlHdr);

/* If the route is not for AF_INET or does not belong to main routing table
then return. */
    if ((rtMsg->rtm_family != AF_INET) || (rtMsg->rtm_table != RT_TABLE_MAIN))
        return;

/* get the rtattr field */
    rtAttr = (struct rtattr *) RTM_RTA(rtMsg);
    rtLen = RTM_PAYLOAD(nlHdr);
    for (; RTA_OK(rtAttr, rtLen); rtAttr = RTA_NEXT(rtAttr, rtLen)) {
        switch (rtAttr->rta_type) {
        case RTA_OIF:
            if_indextoname(*(int *) RTA_DATA(rtAttr), rtInfo->ifName);
            break;
        case RTA_GATEWAY:
            rtInfo->gateWay.s_addr= *(u_int *) RTA_DATA(rtAttr);
            break;
        case RTA_PREFSRC:
            rtInfo->srcAddr.s_addr= *(u_int *) RTA_DATA(rtAttr);
            break;
        case RTA_DST:
            rtInfo->dstAddr .s_addr= *(u_int *) RTA_DATA(rtAttr);
            break;
        }
    }
    //printf("%s\n", inet_ntoa(rtInfo->dstAddr));

    if (rtInfo->dstAddr.s_addr == 0)
        sprintf(gateway, (char *) inet_ntoa(rtInfo->gateWay));
    //printRoute(rtInfo);

    return;
}


int getGateway(char *gateway)
{
    struct nlmsghdr *nlMsg;
    struct rtmsg *rtMsg;
    struct route_info *rtInfo;
    char msgBuf[BUFSIZE];

    int sock, len, msgSeq = 0;

/* Create Socket */
    if ((sock = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_ROUTE)) < 0){
    	err("Socket Creation: ");
    	return -1;
    }

    memset(msgBuf, 0, BUFSIZE);

/* point the header and the msg structure pointers into the buffer */
    nlMsg = (struct nlmsghdr *) msgBuf;
    rtMsg = (struct rtmsg *) NLMSG_DATA(nlMsg);

/* Fill in the nlmsg header*/
    nlMsg->nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg));  // Length of message.
    nlMsg->nlmsg_type = RTM_GETROUTE;   // Get the routes from kernel routing table .

    nlMsg->nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST;    // The message is a request for dump.
    nlMsg->nlmsg_seq = msgSeq++;    // Sequence of the message packet.
    nlMsg->nlmsg_pid = getpid();    // PID of process sending the request.

/* Send the request */
    if (send(sock, nlMsg, nlMsg->nlmsg_len, 0) < 0) {
    	err("Write To Socket Failed...\n");
        return -1;
    }

/* Read the response */
    if ((len = readNlSock(sock, msgBuf, msgSeq, getpid())) < 0) {
    	err("Read From Socket Failed...\n");
    return -1;
    }
/* Parse and print the response */
    rtInfo = (struct route_info *) malloc(sizeof(struct route_info));
//fprintf(stdout, "Destination\tGateway\tInterface\tSource\n");
    for (; NLMSG_OK(nlMsg, len); nlMsg = NLMSG_NEXT(nlMsg, len)) {
        memset(rtInfo, 0, sizeof(struct route_info));
        parseRoutes(gateway, nlMsg, rtInfo);
    }
    free(rtInfo);
    close(sock);

    printGateway(gateway);
    return 0;
}

int getLocalIP(char * ip)
{
 int fd;
 struct ifreq ifr;

 fd = socket(AF_INET, SOCK_DGRAM, 0);

 /* I want to get an IPv4 IP address */
 ifr.ifr_addr.sa_family = AF_INET;

 /* I want IP address attached to "eth1" */
 strncpy(ifr.ifr_name, "eth1", IFNAMSIZ-1);

 ioctl(fd, SIOCGIFADDR, &ifr);

 close(fd);

 /* display result */
 sprintf(ip, "%s\0", inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr));
 info("LOCAL_IP::%s\n", ip);

 return 0;
}


int getNetMask(char * ip)
{
 int fd;
 struct ifreq ifr;

 fd = socket(AF_INET, SOCK_DGRAM, 0);

 /* I want to get an IPv4 IP address */
 ifr.ifr_addr.sa_family = AF_INET;

 /* I want IP address attached to "eth1" */
 strncpy(ifr.ifr_name, "eth1", IFNAMSIZ-1);

 ioctl(fd, SIOCGIFNETMASK, &ifr);

 close(fd);

 /* display result */
 sprintf(ip, "%s\0", inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr));
 info("Netmask::%s\n", ip);

 return 0;
}


int getMacAddress(char * mac_address)
{
    struct ifreq ifr;
    struct ifconf ifc;
    char buf[1024];
    int success = 0;

    int sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_IP);
    if (sock == -1) { /* handle error*/ };

    ifc.ifc_len = sizeof(buf);
    ifc.ifc_buf = buf;
    if (ioctl(sock, SIOCGIFCONF, &ifc) == -1) {
    	/* handle error */
    	return -1;
    }

    struct ifreq* it = ifc.ifc_req;
    const struct ifreq* const end = it + (ifc.ifc_len / sizeof(struct ifreq));

    for (; it != end; ++it) {
        strcpy(ifr.ifr_name, it->ifr_name);
        if (ioctl(sock, SIOCGIFFLAGS, &ifr) == 0) {
            if (! (ifr.ifr_flags & IFF_LOOPBACK)) { // don't count loopback
                if (ioctl(sock, SIOCGIFHWADDR, &ifr) == 0) {
                    success = 1;
                    break;
                }
            }
        }
        else { /* handle error */ }
    }

//    unsigned char mac_address[6];

    if (success) {
    	memcpy(mac_address, ifr.ifr_hwaddr.sa_data, 6);
    	return 0;
    }else{
    	info("Failed to get local MAC address exiting...");
    	exit(-1);
    	return -1;
    }
}




/*
 * Converts struct sockaddr with an IPv4 address to network byte order uin32_t.
 * Returns 0 on success.
 */
int int_ip4(struct sockaddr *addr, uint32_t *ip)
{
    if (addr->sa_family == AF_INET) {
        struct sockaddr_in *i = (struct sockaddr_in *) addr;
        *ip = i->sin_addr.s_addr;
        return 0;
    } else {
        err("Not AF_INET");
        return 1;
    }
}

/*
 * Formats sockaddr containing IPv4 address as human readable string.
 * Returns 0 on success.
 */
int format_ip4(struct sockaddr *addr, char *out)
{
    if (addr->sa_family == AF_INET) {
        struct sockaddr_in *i = (struct sockaddr_in *) addr;
        const char *ip = inet_ntoa(i->sin_addr);
        if (!ip) {
            return -2;
        } else {
            strcpy(out, ip);
            return 0;
        }
    } else {
        return -1;
    }
}

/*
 * Writes interface IPv4 address as network byte order to ip.
 * Returns 0 on success.
 */
int get_if_ip4(int fd, const char *ifname, uint32_t *ip) {
    int err = -1;
    struct ifreq ifr;
    memset(&ifr, 0, sizeof(struct ifreq));
    if (strlen(ifname) > (IFNAMSIZ - 1)) {
        err("Too long interface name");
        goto out;
    }

    strcpy(ifr.ifr_name, ifname);
    if (ioctl(fd, SIOCGIFADDR, &ifr) == -1) {
        err("SIOCGIFADDR");
        goto out;
    }

    if (int_ip4(&ifr.ifr_addr, ip)) {
        goto out;
    }
    err = 0;
out:
    return err;
}

/*
 * Sends an ARP who-has request to dst_ip
 * on interface ifindex, using source mac src_mac and source ip src_ip.
 */
int send_arp(int fd, int ifindex, const unsigned char *src_mac, uint32_t src_ip, uint32_t dst_ip)
{
    int err = -1;
    unsigned char buffer[BUF_SIZE];
    memset(buffer, 0, sizeof(buffer));

    struct sockaddr_ll socket_address;
    socket_address.sll_family = AF_PACKET;
    socket_address.sll_protocol = htons(ETH_P_ARP);
    socket_address.sll_ifindex = ifindex;
    socket_address.sll_hatype = htons(ARPHRD_ETHER);
    socket_address.sll_pkttype = (PACKET_BROADCAST);
    socket_address.sll_halen = MAC_LENGTH;
    socket_address.sll_addr[6] = 0x00;
    socket_address.sll_addr[7] = 0x00;

    struct ethhdr *send_req = (struct ethhdr *) buffer;
    struct arp_header *arp_req = (struct arp_header *) (buffer + ETH2_HEADER_LEN);
    int index;
    ssize_t ret, length = 0;

    //Broadcast
    memset(send_req->h_dest, 0xff, MAC_LENGTH);

    //Target MAC zero
    memset(arp_req->target_mac, 0x00, MAC_LENGTH);

    //Set source mac to our MAC address
    memcpy(send_req->h_source, src_mac, MAC_LENGTH);
    memcpy(arp_req->sender_mac, src_mac, MAC_LENGTH);
    memcpy(socket_address.sll_addr, src_mac, MAC_LENGTH);

    /* Setting protocol of the packet */
    send_req->h_proto = htons(ETH_P_ARP);

    /* Creating ARP request */
    arp_req->hardware_type = htons(HW_TYPE);
    arp_req->protocol_type = htons(ETH_P_IP);
    arp_req->hardware_len = MAC_LENGTH;
    arp_req->protocol_len = IPV4_LENGTH;
    arp_req->opcode = htons(ARP_REQUEST);

    debug("Copy IP address to arp_req");
    memcpy(arp_req->sender_ip, &src_ip, sizeof(uint32_t));
    memcpy(arp_req->target_ip, &dst_ip, sizeof(uint32_t));

    ret = sendto(fd, buffer, 42, 0, (struct sockaddr *) &socket_address, sizeof(socket_address));
    if (ret == -1) {
        err("sendto():");
        goto out;
    }
    err = 0;
out:
    return err;
}

/*
 * Gets interface information by name:
 * IPv4
 * MAC
 * ifindex
 */
int get_if_info(const char *ifname, uint32_t *ip, char *mac, int *ifindex)
{
    debug("get_if_info for %s", ifname);
    int err = -1;
    struct ifreq ifr;
    int sd = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ARP));
    if (sd <= 0) {
        perror("socket()");
        goto out;
    }
    if (strlen(ifname) > (IFNAMSIZ - 1)) {
    	debug("Too long interface name, MAX=%i\n", IFNAMSIZ - 1);
        goto out;
    }

    strcpy(ifr.ifr_name, ifname);

    //Get interface index using name
    if (ioctl(sd, SIOCGIFINDEX, &ifr) == -1) {
        err("SIOCGIFINDEX");
        goto out;
    }
    *ifindex = ifr.ifr_ifindex;
    info("interface index is %d\n", *ifindex);

    //Get MAC address of the interface
    if (ioctl(sd, SIOCGIFHWADDR, &ifr) == -1) {
        err("SIOCGIFINDEX");
        goto out;
    }

    //Copy mac address to output
    memcpy(mac, ifr.ifr_hwaddr.sa_data, MAC_LENGTH);

    if (get_if_ip4(sd, ifname, ip)) {
        goto out;
    }
    debug("get_if_info OK");

    err = 0;
out:
    if (sd > 0) {
        debug("Clean up temporary socket");
        close(sd);
    }
    return err;
}

/*
 * Creates a raw socket that listens for ARP traffic on specific ifindex.
 * Writes out the socket's FD.
 * Return 0 on success.
 */
int bind_arp(int ifindex, int *fd)
{
    debug("bind_arp: ifindex=%i", ifindex);
    int ret = -1;

    // Submit request for a raw socket descriptor.
    *fd = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ARP));
    if (*fd < 1) {
        err("socket()");
        goto out;
    }

    debug("Binding to ifindex %i", ifindex);
    struct sockaddr_ll sll;
    memset(&sll, 0, sizeof(struct sockaddr_ll));
    sll.sll_family = AF_PACKET;
    sll.sll_ifindex = ifindex;
    if (bind(*fd, (struct sockaddr*) &sll, sizeof(struct sockaddr_ll)) < 0) {
        perror("bind");
        goto out;
    }

    ret = 0;
out:
    if (ret && *fd > 0) {
        debug("Cleanup socket");
        close(*fd);
    }
    return ret;
}

/*
 * Reads a single ARP reply from fd.
 * Return 0 on success.
 */
int read_arp(int fd, ETH_PARAM_ID id)
{
	unsigned char ip[128]={0};
	  unsigned char ipAddress[4];
	  unsigned char macAddress[6];
    debug("read_arp");
    int ret = -1;
    unsigned char buffer[BUF_SIZE];
    ssize_t length = recvfrom(fd, buffer, BUF_SIZE, 0, NULL, NULL);
    int index;
    if (length == -1) {
        err("recvfrom()");
        goto out;
    }
    struct ethhdr *rcv_resp = (struct ethhdr *) buffer;
    struct arp_header *arp_resp = (struct arp_header *) (buffer + ETH2_HEADER_LEN);
    if (ntohs(rcv_resp->h_proto) != PROTO_ARP) {
        debug("Not an ARP packet");
        goto out;
    }
    if (ntohs(arp_resp->opcode) != ARP_REPLY) {
        debug("Not an ARP reply");
        goto out;
    }
    debug("received ARP len=%ld", length);
    struct in_addr sender_a;
    memset(&sender_a, 0, sizeof(struct in_addr));
    memcpy(&sender_a.s_addr, arp_resp->sender_ip, sizeof(uint32_t));
    debug("Sender IP: %s", inet_ntoa(sender_a));

    debug("Sender MAC: %02X:%02X:%02X:%02X:%02X:%02X",
          arp_resp->sender_mac[0],
          arp_resp->sender_mac[1],
          arp_resp->sender_mac[2],
          arp_resp->sender_mac[3],
          arp_resp->sender_mac[4],
          arp_resp->sender_mac[5]);



	info("\nARP response Address: %03d. %03d. %03d. %03d\n",arp_resp->sender_ip[0],arp_resp->sender_ip[1],arp_resp->sender_ip[2],arp_resp->sender_ip[3]);
	write_eth_param(full_udp_stack_ip_base_0, id, (arp_resp->sender_ip[0]<<24)|(arp_resp->sender_ip[1]<<16)|(arp_resp->sender_ip[2]<<8)|(arp_resp->sender_ip[3]));


	info("\nARP response Mac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",arp_resp->sender_mac[0],arp_resp->sender_mac[1],arp_resp->sender_mac[2],arp_resp->sender_mac[3],arp_resp->sender_mac[4],arp_resp->sender_mac[5]);
	//write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, ((arp_resp->sender_mac[0]<<40)|(arp_resp->sender_mac[1]<<32)|arp_resp->sender_mac[2]<<24)|(arp_resp->sender_mac[3]<<16)|(arp_resp->sender_mac[4]<<8)|(arp_resp->sender_mac[5]));
	write_eth_mac(full_udp_stack_ip_base_0, id, &arp_resp->sender_mac[0]);



    ret = 0;

out:
    return ret;
}

/*
 *
 * Sample code that sends an ARP who-has request on
 * interface <ifname> to IPv4 address <ip>.
 * Returns 0 on success.
 */
int run_arping(const char *ifname, const char *ip, ETH_PARAM_ID id) {
    int ret = -1;
    info("Running ARP for Destination IP:%s on IFNAME:%d ...", ip, ifname);
    uint32_t dst = inet_addr(ip);
    if (dst == 0 || dst == 0xffffffff) {
        err("Invalid source IP\n");
        return ret;
    }

    int src;
    int ifindex;
    char mac[MAC_LENGTH];
    if (get_if_info(ifname, &src, mac, &ifindex)) {
        err("get_if_info failed, interface %s not found or no IP set?", ifname);
        goto out;
    }
    int arp_fd;
    if (bind_arp(ifindex, &arp_fd)) {
        err("Failed to bind_arp()");
        goto out;
    }

    if (send_arp(arp_fd, ifindex, mac, src, dst)) {
        err("Failed to send_arp");
        goto out;
    }
    info("Enter arp data read wait loop....");
    while(1) {
        int r = read_arp(arp_fd, id);
        if (r == 0) {
            info("Got reply, break out");
            break;
        }

        if (send_arp(arp_fd, ifindex, mac, src, dst)) {
                err("Failed to send_arp");
                goto out;
            }
    }

    ret = 0;
out:
    if (arp_fd) {
        close(arp_fd);
        arp_fd = 0;
    }
    return ret;
}


int run_arping_by_addr(const char *ifname, uint32_t dst, ETH_PARAM_ID id) {
    int ret = -1;
//    info("Running ARP for Destination IP:%s on IFNAME:%d ...", ip, ifname);
//    uint32_t dst = inet_addr(ip);
    if (dst == 0 || dst == 0xffffffff) {
        err("Invalid source IP\n");
        return ret;
    }

    int src;
    int ifindex;
    char mac[MAC_LENGTH];
    if (get_if_info(ifname, &src, mac, &ifindex)) {
        err("get_if_info failed, interface %s not found or no IP set?", ifname);
        goto out;
    }
    int arp_fd;
    if (bind_arp(ifindex, &arp_fd)) {
        err("Failed to bind_arp()");
        goto out;
    }

    if (send_arp(arp_fd, ifindex, mac, src, dst)) {
        err("Failed to send_arp");
        goto out;
    }
    info("Enter arp data read wait loop....");
    while(1) {
        int r = read_arp(arp_fd, id);
        if (r == 0) {
            info("Got reply, break out");
            break;
        }

        if (send_arp(arp_fd, ifindex, mac, src, dst)) {
                err("Failed to send_arp");
                goto out;
            }
    }

    ret = 0;
out:
    if (arp_fd) {
        close(arp_fd);
        arp_fd = 0;
    }
    return ret;
}


int stohi(char *ip){
	char c;
	c = *ip;
	unsigned int integer;
	int val;
	int i,j=0;
	for (j=0;j<4;j++) {
		if (!isdigit(c)){  //first char is 0
			return (0);
		}
		val=0;
		for (i=0;i<3;i++) {
			if (isdigit(c)) {
				val = (val * 10) + (c - '0');
				c = *++ip;
			} else
				break;
		}
		if(val<0 || val>255){
			return (0);
		}
		if (c == '.') {
			integer=(integer<<8) | val;
			c = *++ip;
		}
		else if(j==3 && c == '\0'){
			integer=(integer<<8) | val;
			break;
		}

	}
	if(c != '\0'){
		return (0);
	}
	return (htonl(integer));
}


//int check_ip_net(char * ip, char * gateway_ip){
//
//
//	    // In the list I have: 104.40.0.0./24
//	    int cidr = 24;
//	    uint32_t ipaddr_from_pkt = stohi(ip);//1747488105;     // pkt coming from 104.40.141.105
//	    uint32_t ipaddr_from_list = stohi(gateway_ip);//1747451904;    // 104.40.0.0
//	    int mask = (-1) << (32 - cidr);
//
//	    if ((ipaddr_from_pkt & mask) == ipaddr_from_list){
//	        err("Local IP address!!!\n");
//	        return 1;
//	    }
//	    else{
//	    	err ("Public IP address\n");
//	    	return 0;
//	    }
//
//
//}

int check_ip_net(char * ip, char * gateway_ip){


	    // In the list I have: 104.40.0.0./24
		char mask_ip[64];

	    int cidr = 24;
	    uint32_t ipaddr_from_pkt = stohi(ip);//1747488105;     // pkt coming from 104.40.141.105
	    uint32_t ipaddr_from_list = stohi(gateway_ip);//1747451904;    // 104.40.0.0
	    getNetMask(mask_ip);
	    uint32_t mask = stohi(mask_ip);
	    int mask_old = (-1) << (32 - cidr);

	    info("Checking if IP Address is Local:: IP_str==%s , IP_int==0x%X , GW_str==%s , GW_int==0x%X , MASK==0x%X , MASK_OLD==0x%X", ip,  ipaddr_from_pkt, gateway_ip, ipaddr_from_list, mask, mask_old);

	    if ((ipaddr_from_pkt & mask) == (ipaddr_from_list  & mask)){
	        err("Local IP address!!!\n");
	        return 1;
	    }
	    else{
	    	err ("Public IP address\n");
	    	return 0;
	    }


}

int check_mac_sanity(char * mac){
	return (mac[0] == mac[1] == mac[2] == mac[3] == mac[4]==mac[5]==0) ? 0 : 1;
}

int check_ip_sanity(char * ip){


	    // In the list I have: 104.40.0.0./24
		char mask_ip[64];

	    int cidr = 24;
	    uint32_t ipaddr_from_pkt = stohi(ip);//1747488105;     // pkt coming from 104.40.141.105
//	    uint32_t ipaddr_from_list = stohi(gateway_ip);//1747451904;    // 104.40.0.0
	    getNetMask(mask_ip);
	    uint32_t mask = stohi(mask_ip);
	    int mask_old = (-1) << (32 - cidr);

	    info("Checking if IP Address is Local:: IP_str==%s , IP_int==0x%X, MASK==0x%X ", ip,  ipaddr_from_pkt, mask);

	    if ((ipaddr_from_pkt  & mask) > 0){
	        info("IP address passed!!!\n");
	        return 1;
	    }
	    else{
	    	err ("IP address: %s : failed!!!\n", ip);
	    	return 0;
	    }


}


//int do_arp_cmdline(int argc, const char **argv) {
//    int ret = -1;
//    if (argc != 3) {
//        printf("Usage: %s <INTERFACE> <DEST_IP>\n", argv[0]);
//        return 1;
//    }
//    const char *ifname = argv[1];
//    const char *ip = argv[2];
//    return test_arping(ifname, ip);
//}


/**
 * /proc/net/arp looks like this:
 *
 * IP address       HW type     Flags       HW address            Mask     Device
 * 192.168.12.31    0x1         0x2         00:09:6b:00:02:03     *        eth0
 * 192.168.12.70    0x1         0x2         00:01:02:38:4c:85     *        eth0
 */


/**
 * Macros to turn a numeric macro into a string literal.  See
 * https://gcc.gnu.org/onlinedocs/cpp/Stringification.html
 */
#define xstr(s) str(s)
#define str(s) #s

#define ARP_CACHE       "/proc/net/arp"
#define ARP_STRING_LEN  1023
#define ARP_BUFFER_LEN  (ARP_STRING_LEN + 1)

/* Format for fscanf() to read the 1st, 4th, and 6th space-delimited fields */
#define ARP_LINE_FORMAT "%" xstr(ARP_STRING_LEN) "s %*s %*s " \
                        "%" xstr(ARP_STRING_LEN) "s %*s " \
                        "%" xstr(ARP_STRING_LEN) "s"

int update_arp_table(char * ip, char * gateway_ip)
{
	char ipAddress[4];
	char gipAddress[4];
	char macAddress[6];



	info("\nRead ARP entries in kernel table: for ip: %s gw:%s\n", ip, gateway_ip);


    FILE *arpCache = fopen(ARP_CACHE, "r");
    if (!arpCache)
    {
        err("Arp Cache: Failed to open file \"" ARP_CACHE "\"");
        return 1;
    }

    /* Ignore the first line, which contains the header */
    char header[ARP_BUFFER_LEN];
    if (!fgets(header, sizeof(header), arpCache))
    {
        return 1;
    }

    char ipAddr[ARP_BUFFER_LEN], hwAddr[ARP_BUFFER_LEN], device[ARP_BUFFER_LEN];
    int count = 0;
    while (3 == fscanf(arpCache, ARP_LINE_FORMAT, ipAddr, hwAddr, device))
    {


    	extractIpAddress(gateway_ip,&gipAddress[0]);
    	extractColonMacAddress(hwAddr,&macAddress[0]);
    	if(strcmp(gateway_ip, ipAddr) == 0){
    		extractIpAddress(ip,&ipAddress[0]);
			info("\nARP gw entry GIP Address: %03d. %03d. %03d. %03d\n",gipAddress[0],gipAddress[1],gipAddress[2],gipAddress[3]);
			write_eth_param(full_udp_stack_ip_base_0, ARP1_ID, (gipAddress[0]<<24)|(gipAddress[1]<<16)|(gipAddress[2]<<8)|(gipAddress[3]));
			write_eth_param(full_udp_stack_ip_base_0, ARP2_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));


			info("\nARP entry IP Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);			//write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, ((macAddress[0]<<40)|(macAddress[1]<<32)|macAddress[2]<<24)|(macAddress[3]<<16)|(macAddress[4]<<8)|(macAddress[5]));
			write_eth_mac(full_udp_stack_ip_base_0, ARP1_ID, &macAddress[0]);
			write_eth_mac(full_udp_stack_ip_base_0, ARP2_ID, &macAddress[0]);

			info("%03d: GW Mac Address of [%s] on [%s] is \"%s\"\n",
								0, ipAddr, device, hwAddr);
			info("%03d: ARP Mac Address of [%s] on [%s] is \"%s\"\n",
											1, ip, device, hwAddr);
    	}else{
			//info("\nARP entry Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
			write_eth_param(full_udp_stack_ip_base_0, ARP3_ID+count, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));


			//info("\nARP entry Mac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
			//write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, ((macAddress[0]<<40)|(macAddress[1]<<32)|macAddress[2]<<24)|(macAddress[3]<<16)|(macAddress[4]<<8)|(macAddress[5]));
			write_eth_mac(full_udp_stack_ip_base_0, ARP3_ID+count, &macAddress[0]);

			info("%03d: Mac Address of [%s] on [%s] is \"%s\"\n",
								++count, ipAddr, device, hwAddr);
    	}

    	if (count >= 3){
    		break;
    	}


    }
    fclose(arpCache);
    return 0;
}


int update_arp_table_by_addr(char * ip, char * gateway_ip)
{
	char ipAddress[4];
	char gipAddress[4];
	char macAddress[6];

	info("\nRead ARP entries in kernel table: for pi: %s gw:%s\n", ip, gateway_ip);


    FILE *arpCache = fopen(ARP_CACHE, "r");
    if (!arpCache)
    {
        err("Arp Cache: Failed to open file \"" ARP_CACHE "\"");
        return 1;
    }

    /* Ignore the first line, which contains the header */
    char header[ARP_BUFFER_LEN];
    if (!fgets(header, sizeof(header), arpCache))
    {
        return 1;
    }

    char ipAddr[ARP_BUFFER_LEN], hwAddr[ARP_BUFFER_LEN], device[ARP_BUFFER_LEN];
    int count = 0;
    while (3 == fscanf(arpCache, ARP_LINE_FORMAT, ipAddr, hwAddr, device))
    {


    	extractIpAddress(gateway_ip,&gipAddress[0]);
    	extractColonMacAddress(hwAddr,&macAddress[0]);
    	if(strcmp(gateway_ip, ipAddr) == 0){
    		extractIpAddress(ip,&ipAddress[0]);
			info("\nARP gw entry GIP Address: %03d. %03d. %03d. %03d\n",gipAddress[0],gipAddress[1],gipAddress[2],gipAddress[3]);
			write_eth_param(full_udp_stack_ip_base_0, ARP1_ID, (gipAddress[0]<<24)|(gipAddress[1]<<16)|(gipAddress[2]<<8)|(gipAddress[3]));
			write_eth_param(full_udp_stack_ip_base_0, ARP2_ID, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));


			info("\nARP entry IP Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);			//write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, ((macAddress[0]<<40)|(macAddress[1]<<32)|macAddress[2]<<24)|(macAddress[3]<<16)|(macAddress[4]<<8)|(macAddress[5]));
			write_eth_mac(full_udp_stack_ip_base_0, ARP1_ID, &macAddress[0]);
			write_eth_mac(full_udp_stack_ip_base_0, ARP2_ID, &macAddress[0]);

			info("%03d: GW Mac Address of [%s] on [%s] is \"%s\"\n",
								0, ipAddr, device, hwAddr);
			info("%03d: ARP Mac Address of [%s] on [%s] is \"%s\"\n",
											1, ip, device, hwAddr);
    	}else{
			//info("\nARP entry Address: %03d. %03d. %03d. %03d\n",ipAddress[0],ipAddress[1],ipAddress[2],ipAddress[3]);
			write_eth_param(full_udp_stack_ip_base_0, ARP3_ID+count, (ipAddress[0]<<24)|(ipAddress[1]<<16)|(ipAddress[2]<<8)|(ipAddress[3]));


			//info("\nARP entry Mac Address: %02x. %02x. %02x. %02x. %02x. %02x\n",macAddress[0],macAddress[1],macAddress[2],macAddress[3],macAddress[4],macAddress[5]);
			//write_eth_mac(full_udp_stack_ip_base_0, MAC_ID, ((macAddress[0]<<40)|(macAddress[1]<<32)|macAddress[2]<<24)|(macAddress[3]<<16)|(macAddress[4]<<8)|(macAddress[5]));
			write_eth_mac(full_udp_stack_ip_base_0, ARP3_ID+count, &macAddress[0]);

			info("%03d: Mac Address of [%s] on [%s] is \"%s\"\n",
								++count, ipAddr, device, hwAddr);
    	}

    	if (count >= 3){
    		break;
    	}


    }
    fclose(arpCache);
    return 0;
}


int getPublicIP(char * public_ip){


	char ipAddr[48];
	int i = 0;

	    FILE *fd;
	    char ch;

	    info("------------------------FETCH MY PUBLIC ADDRESS WORK AROUND----------------\n");
//	    sleep(1);
//	    p = popen("ver","r");   /* DOS */
	/*  p = popen("uname","r"); /* Unix */
	    fd = popen("curl -sS ifconfig.me", "r");
	    if( fd == NULL)
	    {
	        err("Unable to open address fetching process");
	        return(-1);
	    }
	    memset(ipAddr, 0, sizeof(ipAddr));
//	    while(( (ch=fgetc(fd)) != EOF) && (i < sizeof(ipAddr))){
//	        putchar(ch);
//	        ipAddr[i] = ch;
//	        i++;
//	    }

//	    do{
//	    	ch=fgetc(fd);
//	    	ipAddr[i] = ch;
//	        i++;
//	    }while((ch != EOF) && (ch != NULL) && (i < sizeof(ipAddr)));

	    fgets(ipAddr, sizeof(ipAddr), fd);

//	    int day, year;
//	       char weekday[20], month[20], dtm[100];

//	       strcpy( dtm, "Saturday March 25 1989" );
//	       sscanf( dtm, "%s %s %d  %d", weekday, month, &day, &year );

	    info("===========Address returned:: %s========\n", ipAddr);

	    sscanf( ipAddr, "%d.%d.%d.%d\0", &public_ip[0], &public_ip[1], &public_ip[2], &public_ip[3] );


	     info("PULIC_IP::%s\n", ipAddr);

//	    while(( (ch=fgetc(fd)) != EOF)){};
	    pclose(fd);

	    return(0);


}


char *mac_ntoa(unsigned char *ptr){
    static char address[30];

    sprintf(address, "%02X:%02X:%02X:%02X:%02X:%02X",
        ptr[0], ptr[1], ptr[2], ptr[3], ptr[4], ptr[5]);

    return(address);
} /* End of mac_ntoa */

int mac_aton(char *addr, unsigned char *ptr){
    int i, v[6];
    if((i = sscanf(addr, "%x:%x:%x:%x:%x:%x", &v[0], &v[1], &v[2], &v[3],
            &v[4], &v[5])) !=6){

        err("arp: invalid Ethernet address '%s'\n", addr);
        return(1);
    } /* End of If*/

    for(i = 0; i < 6; i++){
        ptr[i] = v[i];
    } /* End of For */

    return(0);
}

int add_arp_entry(int flags, char *host, char * mac){
//    if(argc < 3 || argc > 4){
//        fprintf(stderr,"usage: %s <ip_addr> <hw_addr> [temp|pub|perm|trail]\n",
//            argv[0]);
//        fprintf(stderr, "default: temp.\n");
//        exit(-1);
//    } /* End of If */

    int s;
//    char *host = argv[1];

    struct arpreq req;
    struct hostent *hp;
    struct sockaddr_in *sin;

    bzero((caddr_t)&req, sizeof(req)); /* caddr_t is not really needed. */

    sin = (struct sockaddr_in *)&req.arp_pa;
    sin->sin_family = AF_INET;
    sin->sin_addr.s_addr = inet_addr(host);

    if(sin->sin_addr.s_addr ==-1){
        if(!(hp = gethostbyname(host))){
            fprintf(stderr, "arp: %s ", host);
            herror((char *)NULL);
            return(-1);
        } /* End of If */
        bcopy((char *)hp->h_addr,
            (char *)&sin->sin_addr, sizeof(sin->sin_addr));
    } /* End of If */

    if(mac_aton(mac, req.arp_ha.sa_data)){ /* If address is valid... */
        return(-1);
    }

//    argc -=2;
//    argv +=2;

//    flags = ATF_PERM | ATF_COM;
//USe stork here
//    while(argc-- > 0){
//        if(!(strncmp(str_flag, "temp", 4))){
//            flags &= ~ATF_PERM;
//        } else if(!(strncmp(str_flag, "pub", 3))){
//            flags |= ATF_PUBL;
//        } else if(!(strncmp(str_flag, "trail", 5))){
//            flags |= ATF_USETRAILERS;
//        } else if(!(strncmp(str_flag, "dontpub", 7))){ /* Not working yet */
//            flags |= ATF_DONTPUB;
//        } else if(!(strncmp(str_flag, "perm", 4))){
//            flags = ATF_PERM;
//        } else {
//            flags &= ~ATF_PERM;
//        } /* End of Else*/
//    argv++;
//    }/* End of While */

    req.arp_flags = flags; /* Finally, asign the flags to the structure */
    strcpy(req.arp_dev, "eth0"); /* Asign the device.  */

    if((s = socket(AF_INET, SOCK_DGRAM, 0)) < 0){
        err("socket() failed.");
        exit(-1);
    } /* End of If */

    if(ioctl(s, SIOCSARP, (caddr_t)&req) <0){ /* caddr_t not really needed. */
        err(host);
        exit(-1);
    } /* End of If */

    info("ARP cache entry successfully added.\n");
    close(s);
    return(0);
}


int check_port(int port){
	struct sockaddr_in sin;
	int sock;

	sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if(sock == -1){
	  return -1;
	}

	sin.sin_port = htons(port);
	sin.sin_addr.s_addr = 0;
	sin.sin_addr.s_addr = INADDR_ANY;
	sin.sin_family = AF_INET;

	if (bind(sock, (struct sockaddr *)&sin, sizeof(struct sockaddr_in)) == -1) {
		close(sock);
		  if (errno == EADDRINUSE){
			  info("tmx_msg session__port-in-use \n");
			  return -1;
		  }

	}
	close(sock);
	return 0;

}

