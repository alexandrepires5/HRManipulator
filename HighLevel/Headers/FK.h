#pragma once
#include"Includes.h"

class FK
{
public:
	FK();
	~FK();
	void hmat_calc(VectorXd curr_angles, int link);
	Matrix3d hmat_rot_parser();
	Vector3d hmat_pos_parser();

private:
	Matrix4d hmat;
};

