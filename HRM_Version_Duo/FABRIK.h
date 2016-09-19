#pragma once
#include"Includes.h"
#include"Arm.h"
class FABRIK
{
public:
	FABRIK(Arm &arm, Vector3d Target);
	~FABRIK();
	bool target_reachability();
	MatrixXd FABRIK_forward_reach();
	MatrixXd FABRIK_backward_reach();
	//VectorXd FABRIK_joint_angle_calc(MatrixXd init_pos_mat, MatrixXd desired_pos_mat, VectorXd curr_angles);
	VectorXd FABRIKSolver();

private:
	Arm Manipulator;
	Vector3d TargetPos;
};

