#pragma once
#include"Includes.h"
#include"Arm.h"
class Jac_PseudoInv
{
public:
	Jac_PseudoInv(Arm &arm, Vector3d Target);
	~Jac_PseudoInv();
	void Jac_PseudoInv::angle_normalize(VectorXd &AnglesToNorm);
	Vector3d dX();
	VectorXd dTheta(VectorXd current_angles, VectorXd prev_angles);
	VectorXd CalcJacobianIndex(VectorXd end_effect_pos, VectorXd joint_pos, int link);
	MatrixXd CalcJacobianMat();
	std::double_t InverseError(MatrixXd J, MatrixXd J_inv, VectorXd DIF_END_EFFECT_POS);
	VectorXd CalcJacobianAngles(MatrixXd jacobian_inv, VectorXd dX, VectorXd angles, std::double_t dist);
	VectorXd JacPseudoInvSolver();

private:
	Arm Manipulator;
	Vector3d TargetPos;
	const int MAXITER = 100000;
	const std::double_t InversionError = 0.001;
	const std::double_t ErrorThreshold = 0.001;
};

