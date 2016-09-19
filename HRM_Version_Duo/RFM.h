#pragma once
#include"Includes.h"
#include"Arm.h"
class RFM
{
public:
	RFM(Arm &arm, Vector3d Target);
	~RFM();
	void BackBoneCreation();
	void RFMSolver();
private:
	Arm Manipulator;
	Vector3d TargetPos;
};

