#pragma once
#include"Includes.h"
#include"Arm.h"
class Inv_CCD
{
public:
	Inv_CCD(Arm &arm, Vector3d Target);
	~Inv_CCD();
	std::double_t angleNormalize(std::double_t angle);
	std::double_t angleDynamicStep(std::double_t angle, std::double_t distance, int link);
	std::double_t angleRotCorrection(std::double_t angle, VectorXd cross_result, std::double_t corrected_angle, std::double_t distance, int link);
	VectorXd CCDSolver();

private:
	Arm Manipulator;
	Vector3d TargetPos;
};

