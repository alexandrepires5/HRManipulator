#include "UDP_comm.h"


UDP_comm::UDP_comm()
{
}


UDP_comm::~UDP_comm()
{
}

//void data_receive(sockaddr_in si_other, int slen, char buf[BUFLEN], int recv_len, SOCKET s);
std::tuple<sockaddr_in, int, char*, int, SOCKET> UDP_comm::data_receive(sockaddr_in si_other, int slen, char buf[BUFLEN], int recv_len, SOCKET s)
{
	//try to receive some data, this is a blocking call
	if ((recv_len = recvfrom(s, buf, BUFLEN, 0, (struct sockaddr *) &si_other, &slen)) == SOCKET_ERROR)
	{
		//printf("recvfrom() failed with error code : %d", WSAGetLastError());
		//exit(EXIT_FAILURE);
		printf("Something went wrong...");
	}

	//print details of the client/peer and the data received
	printf("Received packet from %s:%d\n", inet_ntoa(si_other.sin_addr), ntohs(si_other.sin_port));
	printf("Data: %s\n", buf);
	printf("Data at pos 5: %c \n", buf[4]);

	return std::make_tuple(si_other, slen, buf, recv_len, s);
}
void UDP_comm::data_send(sockaddr_in si_other, int slen, char buf[BUFLEN], int recv_len, SOCKET s)
{
	//now reply the client
	if (sendto(s, buf, recv_len, 0, (struct sockaddr*) &si_other, slen) == SOCKET_ERROR)
	{
		printf("sendto() failed with error code : %d", WSAGetLastError());
		exit(EXIT_FAILURE);
	}
	else
	{
		printf("Data sent...\n");
	}
}
std::tuple<sockaddr_in, int, char*, int, SOCKET> UDP_comm::initialize_comm()
{
	SOCKET s;
	struct sockaddr_in server, si_other;
	int slen, recv_len;
	char buf[BUFLEN];
	WSADATA wsa;
	std::tuple<sockaddr_in, int, char*, int, SOCKET> comm;

	slen = sizeof(si_other);

	//Initialise winsock
	printf("\nInitialising Winsock...");
	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
	{
		printf("Failed. Error Code : %d", WSAGetLastError());
		exit(EXIT_FAILURE);
	}
	printf("Initialised.\n");

	//Create a socket
	if ((s = socket(AF_INET, SOCK_DGRAM, 0)) == INVALID_SOCKET)
	{
		printf("Could not create socket : %d", WSAGetLastError());
	}
	printf("Socket created.\n");

	//Prepare the sockaddr_in structure
	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(PORT);

	//Bind
	if (bind(s, (struct sockaddr *)&server, sizeof(server)) == SOCKET_ERROR)
	{
		printf("Bind failed with error code : %d", WSAGetLastError());
		exit(EXIT_FAILURE);
	}
	puts("Bind done");
	recv_len = 0;
	si_other = { 0 };

	return std::make_tuple(si_other, slen, buf, recv_len, s);
}

std::string UDP_comm::data_parsing(std::string const& s)
{
	std::string::size_type pos = s.find(',');
	if (pos != std::string::npos)
	{
		return s.substr(0, pos);
	}
	else
	{
		return s;
	}
}

std::string UDP_comm::data_erase(std::string const& s)
{
	std::string::size_type pos = s.find(',');
	std::string aux;
	if (pos != std::string::npos)
	{
		return s.substr((pos + 1), (BUFLEN - pos));
	}
	else
	{
		return s;
	}

}

std::string UDP_comm::new_data_packet(double New_Joints_Pos[Number_Joints])
{
	std::stringstream new_data;
	int i = 0;
	for (i = 0; i < Number_Joints; i++)
	{
		new_data << New_Joints_Pos[i] << ",";
	}
	new_data << ":";
	return new_data.str();
}

void UDP_comm::recv_init_config(std::tuple<sockaddr_in, int, char*, int, SOCKET> &comm, std::double_t (&PosJ)[SIZE_OF_ARRAY])
{
	//static double PosJ[SIZE_OF_ARRAY] = { 0 };
	int count = 0;
	char data[BUFLEN+100];
	memset(data, '\0', BUFLEN);
	printf("Waiting for data...");
	fflush(stdout);
	std::cout << "good" << std::endl;
	/*clear the buffer by filling null, it might have previously received data */
	memset(std::get<2>(comm), '\0', BUFLEN);

	/*-------RECEIVE DATA FROM SIMULATOR---*/
	/*------------------------------------------------------*/
	comm = data_receive(std::get<0>(comm), std::get<1>(comm), std::get<2>(comm), std::get<3>(comm), std::get<4>(comm));
	/*------------------------------------------------------*/
	
	/*------------------------------------------*/
	/*INIT VARIABLES GLOBAL VARIABLES*/
	/*------------------------------------------*/
	strcpy_s(data, std::get<2>(comm));
	std::cout << "good to" << std::endl;
	std::string auxstring;
	std::string remaining_values;
	for (int count = 0; count < SIZE_OF_ARRAY; count++)
	{
		if (0 == count)
		{
			auxstring = data_parsing(data);
			remaining_values = data_erase(data);
			PosJ[count] = stod(auxstring);
		}
		else
		{
			auxstring = data_parsing(remaining_values);
			remaining_values = data_erase(remaining_values);
			PosJ[count] = stod(auxstring);
		}
	}
	std::cout << "good to go buddy" << std::endl;
	//return PosJ;
}