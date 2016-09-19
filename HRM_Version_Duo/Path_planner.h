#pragma once
#include"Includes.h"
#include"Arm.h"
#include"IK.h"
#include"RRT.h"
#include"RRT_star.h"
#include"Obstacle.h"
class Path_planner
{
public:
	Path_planner(std::string IKSolver, std::string PPSolver, bool Optimization, Arm &arm, Vector3d Target, bool Obstacles);
	~Path_planner();
	VectorXd Path_planner::PathPlanningSolve();
private:
	std::string IKsolv, PPsolv;
	bool opt, obs;
	bool goalReached = false;
	Arm Manipulator;
	Vector3d TargetPos;
	Exceptions myex;
	std::string JacPseudoInv = "JacPseudoInv";
	std::string CCD = "CCD";
	std::string sFABRIK = "FABRIK";
	std::string ppRRT = "RRT";
	std::string ppRRT_star = "RRTStar";

};

