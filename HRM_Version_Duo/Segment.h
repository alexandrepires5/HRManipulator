#pragma once
#include"Includes.h"
class Segment
{
public:
	Segment();
	~Segment();
	void setJointPos(Vector3d jpos);
	void setLinkRot(const Quaternion<std::double_t> &lrot);
	void setJointAngle(std::double_t Angle);
	Vector3d RecJointPos();
	Quaternion<std::double_t> RecLinkRot();
	std::double_t RecvJointAngle();

private:
	Vector3d joint_pos;
	Quaternion<std::double_t> link_rot;
	std::double_t JointAngle;
};

