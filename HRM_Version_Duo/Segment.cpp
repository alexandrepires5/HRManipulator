#include "Segment.h"


Segment::Segment()
{
}


Segment::~Segment()
{
}

void Segment::setJointPos(Vector3d jpos)
{
	joint_pos = jpos;
}
void Segment::setLinkRot(const Quaternion<std::double_t> &lrot)
{
	link_rot = lrot;
}

void Segment::setJointAngle(std::double_t Angle)
{
	JointAngle = Angle;
}
Vector3d Segment::RecJointPos()
{
	return joint_pos;
}
Quaternion<std::double_t> Segment::RecLinkRot()
{
	return link_rot;
}

std::double_t Segment::RecvJointAngle()
{
	return JointAngle;
}