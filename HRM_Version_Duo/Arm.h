#pragma once
#include"Segment.h"
#include"FK.h"
class Arm
{
public:
	Arm(Vector3d InitPos);
	~Arm();
	void SetSegmentPos(int i, Vector3d jpos);
	void SetSegmentRot(int i, const Quaternion<std::double_t> &lrot);
	void SetJointAngles(int i, std::double_t JointAngle);
	Vector3d RecSegmentPos(int i);
	Quaternion<std::double_t> RecSegmentRot(int i);
	void UpdateArmFK(VectorXd angles);
	void UpdateArmFK(int i, const Quaternion<std::double_t> &lrot);
	VectorXd RecvArmAngles();
private:
	Segment Seg[Number_Joints+1];
	Vector3d Base;
	FK ArmFK;
};

