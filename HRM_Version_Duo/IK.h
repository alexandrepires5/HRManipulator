#pragma once
#include"Includes.h"
#include"Arm.h"
#include"Exceptions.h"
#include"Solvers.h"
class IK
{
public:
	IK(std::string Solver, bool Optimization, Arm &arm, Vector3d Target);
	~IK();
	VectorXd IKSolve();
private:
	std::string solv;
	bool opt;
	Arm Manipulator;
	Vector3d TargetPos;
	Exceptions myex;
	std::string JacPseudoInv = "JacPseudoInv";
	std::string CCD = "CCD";
	std::string sFABRIK = "FABRIK";
};

