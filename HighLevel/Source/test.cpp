#include"Arm.h"
#include"UDP_comm.h"
#include"IK.h"

std::double_t DEG_TO_RAD(std::double_t ANGLE)
{
	return(ANGLE * 3.14 / 180.0);
}

VectorXd ACTUAL_ANG_PARSER(std::double_t PosJ[SIZE_OF_ARRAY])
{
	VectorXd ACTUAL_ANG(Number_Joints);
	int pos = 3;
	for (int i = 0; i < Number_Joints; i++)
	{
		ACTUAL_ANG(i) = PosJ[pos];
		ACTUAL_ANG(i) = DEG_TO_RAD(ACTUAL_ANG(i));
		if (ACTUAL_ANG(i) > 3.13)
		{
			ACTUAL_ANG(i) = 0.0;
		}
		pos = pos + 4;
	}
	return ACTUAL_ANG;
}

int main()
{
	std::double_t PosJ[SIZE_OF_ARRAY] = { 0 };
	//std::double_t *PosJ;
	double ANGLES_TO_SEND[Number_Joints] = { 0 };
	UDP_comm Communication;
	auto comm = Communication.initialize_comm();
	VectorXd aux(Number_Joints);
	aux << aux.setZero();

	while (1)
	{
		Communication.recv_init_config(comm, PosJ);

		VectorXd angs;
		angs = ACTUAL_ANG_PARSER(PosJ);
		Vector3d base;
		base.setZero();
		base(2) = 4.5;
		Arm HRM(base);
		HRM.UpdateArmFK(angs);
		Vector3d T;
		T(0) = 1.0;
		T(1) = 1.0;
		T(2) = 1.5;
		std::string solver;
		solver = "CCD";
		IK invkine(solver, false, HRM, T);
		VectorXd sendAngles(Number_Joints);
		sendAngles.setZero();
		sendAngles = invkine.IKSolve();
		std::cout << "angles to send" << std::endl << sendAngles << std::endl;
		
		for (int x = 0; x < Number_Joints; x++)
		{
			/*if (x < 6 )
			{
			ANGLES_TO_SEND[x] = -(3.14) / 18;
			}
			else
			{
			ANGLES_TO_SEND[x] = 0;
			}*/
			ANGLES_TO_SEND[x] = 3.14/6;
			//ANGLES_TO_SEND[x] = (3.14) / 6;
		}

		while (1)
		{
		}
		/*---DATA SENT TO SIMULATOR -------------*/
		/*-----------------------------------------------------------------*/
		std::string data_tosend = Communication.new_data_packet(ANGLES_TO_SEND);
		char *packet_tosend = &data_tosend[0u];
		Communication.data_send(std::get<0>(comm), std::get<1>(comm), packet_tosend, std::get<3>(comm), std::get<4>(comm));
	}
}