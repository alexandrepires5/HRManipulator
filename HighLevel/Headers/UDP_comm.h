#pragma once
#include"Includes.h"
#pragma comment(lib,"ws2_32.lib") //Winsock Library



class UDP_comm
{
public:
	UDP_comm();
	~UDP_comm();
	//void data_receive(sockaddr_in si_other, int slen, char buf[BUFLEN], int recv_len, SOCKET s);
	std::tuple<sockaddr_in, int, char*, int, SOCKET> data_receive(sockaddr_in si_other, int slen, char buf[BUFLEN], int recv_len, SOCKET s);
	void data_send(sockaddr_in si_other, int slen, char buf[BUFLEN], int recv_len, SOCKET s);
	std::tuple<sockaddr_in, int, char*, int, SOCKET> initialize_comm();
	std::string data_parsing(std::string const& s);
	std::string data_erase(std::string const& s);
	std::string new_data_packet(double New_Joints_Pos[Number_Joints]);
	void recv_init_config(std::tuple<sockaddr_in, int, char*, int, SOCKET> &comm, std::double_t (&PosJ)[SIZE_OF_ARRAY]);
};

