#include "Arm.h"


Arm::Arm(Vector3d InitPos)
:Base(InitPos)
{
	//initilization 
}


Arm::~Arm()
{
}

void Arm::SetSegmentPos(int i, Vector3d jpos)
{
	Seg[i].setJointPos(jpos);
}
void Arm::SetSegmentRot(int i, const Quaternion<std::double_t> &lrot)
{
	Seg[i].setLinkRot(lrot);
}

void Arm::SetJointAngles(int i, std::double_t JointAngle)
{
	Seg[i].setJointAngle(JointAngle);	
}
Vector3d Arm::RecSegmentPos(int i)
{
	return Seg[i].RecJointPos();
}
Quaternion<std::double_t> Arm::RecSegmentRot(int i)
{
	return Seg[i].RecLinkRot();
}

void Arm::UpdateArmFK(VectorXd angles)
{
	for (int i = 0; i < (Number_Joints+1); i++)
	{
		ArmFK.hmat_calc(angles, i);
		SetSegmentPos(i, Base + ArmFK.hmat_pos_parser());
		Quaternion<std::double_t> aux;
		aux = ArmFK.hmat_rot_parser();
		SetSegmentRot(i, aux);
		if (Number_Joints > i)
		{
			SetJointAngles(i, angles(i));
		}
	}
}

void Arm::UpdateArmFK(int i, const Quaternion<std::double_t> &lrot)
{
	Matrix4d auxhmat, Tm;
	Matrix3d rotmat, auxrotmat;
	Vector3d pos;
	auxhmat.setZero();
	rotmat.setZero();
	auxrotmat.setZero();
	for (int j = 0; j < (Number_Joints + 1); j++) //goes through every joint
	{
		if (j == i) //if we reach the desired joint to change, update it from there
		{
			rotmat = lrot.toRotationMatrix();
			SetSegmentRot(i, lrot);
			Tm.block<3, 3>(0, 0) = rotmat;
			if (0 == i)
			{
				Tm(0, 3) = 0.0;
				Tm(1, 3) = 0.0;
				Tm(2, 3) = 0.0;
				Tm.row(3).setZero();
				Tm(3, 3) = 1;
			}
			else
			{
				Tm(0, 3) = 0.0;
				Tm(1, 3) = 0.0;
				Tm(2, 3) = -0.35;
				Tm.row(3).setZero();
				Tm(3, 3) = 1;
			}			
		}
		else if (j > i)
		{
			auxrotmat = RecSegmentRot(j).toRotationMatrix();
			rotmat = rotmat*auxrotmat;
			auxhmat.block<3, 3>(0, 0) = rotmat;
			if (j < Number_Joints + 1)
			{
				auxhmat(0, 3) = 0.0;
				auxhmat(1, 3) = 0.0;
				auxhmat(2, 3) = -0.35;
				auxhmat.row(3).setZero();
				auxhmat(3, 3) = 1;
				Quaternion<std::double_t> auxq;
				auxq = rotmat;
				SetSegmentRot(j, auxq);
			}
			else
			{
				auxhmat(0, 3) = 0.0;
				auxhmat(1, 3) = 0.0;
				auxhmat(2, 3) = -0.35/2;
				auxhmat.row(3).setZero();
				auxhmat(3, 3) = 1;
			}
			
			Tm = Tm*auxhmat;
			pos(0) = Tm(0, 3);
			pos(1) = Tm(1, 3);
			pos(2) = Tm(2, 3);
			SetSegmentPos(j, pos + RecSegmentPos(i));

			
		}
		else
		{
			//do nothing
		}
	}
}

VectorXd Arm::RecvArmAngles()
{
	VectorXd retAngles(Number_Joints);
	for (int j = 0; j < Number_Joints; j++)
	{
		retAngles(j) = Seg[j].RecvJointAngle();
	}
	return retAngles;
}