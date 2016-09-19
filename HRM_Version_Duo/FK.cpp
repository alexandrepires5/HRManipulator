#include "FK.h"


FK::FK()
{
}


FK::~FK()
{
}

void FK::hmat_calc(VectorXd curr_angles, int i)
{
	MatrixXd jpos_mat(3, Number_Joints + 1);
	Matrix4d T_mat, Ty_mat, Tz_mat;

	std::double_t cosine_angle, sine_angle = 0;
	jpos_mat << jpos_mat.setZero();
	Ty_mat << Ty_mat.setZero();
	Tz_mat << Tz_mat.setZero();
	T_mat << T_mat.setZero();

		if (0 == i) /*first joint and rotates in z axis*/
		{
			cosine_angle = cos(curr_angles(i));
			sine_angle = sin(curr_angles(i));
			hmat << cosine_angle, -sine_angle, 0, 0,
				sine_angle, cosine_angle, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1;
			//jpos_aux_vector = T_mat*P_vector;
			//jpos_mat(0, i) = jpos_aux_vector(0);
			//jpos_mat(1, i) = jpos_aux_vector(1);
			//jpos_mat(2, i) = 4.5 + jpos_aux_vector(2); /*z base is at 4.5*/
		}
		else if (Number_Joints == i) /*end effector*/
		{
			Tz_mat << 1, 0, 0, 0, /*need to change the name...*/
				0, 1, 0, 0,
				0, 0, 1, -0.35 / 2,
				0, 0, 0, 1;
			hmat = hmat * Tz_mat;
			//jpos_aux_vector = T_mat * P_vector;
			//jpos_mat(0, i) = jpos_aux_vector(0);
			//jpos_mat(1, i) = jpos_aux_vector(1);
			//jpos_mat(2, i) = 4.5 + jpos_aux_vector(2);
		}
		else if (0 == i % 2) /*joint rotates in z axis*/
		{
			cosine_angle = cos(curr_angles(i));
			sine_angle = sin(curr_angles(i));
			Tz_mat << cosine_angle, -sine_angle, 0, 0,
				sine_angle, cosine_angle, 0, 0,
				0, 0, 1, -0.35,
				0, 0, 0, 1;
			hmat = hmat * Tz_mat;
			//jpos_aux_vector = T_mat * P_vector;
			//jpos_mat(0, i) = jpos_aux_vector(0);
			//jpos_mat(1, i) = jpos_aux_vector(1);
			//jpos_mat(2, i) = 4.5 + jpos_aux_vector(2);
		}
		else if (0 != i % 2) /*joint rotates in y axis*/
		{
			cosine_angle = cos(curr_angles(i));
			sine_angle = sin(curr_angles(i));
			Ty_mat << cosine_angle, 0, sine_angle, 0,
				0, 1, 0, 0,
				-sine_angle, 0, cosine_angle, -0.35,
				0, 0, 0, 1;
			hmat = hmat * Ty_mat;
			//jpos_aux_vector = T_mat * P_vector;
			//jpos_mat(0, i) = jpos_aux_vector(0);
			//jpos_mat(1, i) = jpos_aux_vector(1);
			//jpos_mat(2, i) = 4.5 + jpos_aux_vector(2);
		}
		else
		{
			std::cout << "Position matrix calculator went wrong" << std::endl;
		}
	
}

Matrix3d FK::hmat_rot_parser()
{
	Matrix3d rot_mat;
	rot_mat << rot_mat.setZero();
	for (int i = 0; i < 3; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			rot_mat(i, j) = hmat(i, j);
		}
	}
	return rot_mat;
}

Vector3d FK::hmat_pos_parser()
{
	Vector3d pos_vec;
	Vector4d P_vector;
	Vector4d jpos_aux_vector; /*is a 4 pos vector. it needs to become 3 pos later*/
	pos_vec << pos_vec.setZero();
	P_vector(0) = 0.0;
	P_vector(1) = 0.0;
	P_vector(2) = -0.35 / 2; //center of mass of link
	P_vector(3) = 1;
	
	jpos_aux_vector = hmat*P_vector;
	pos_vec(0) = jpos_aux_vector(0);
	pos_vec(1) = jpos_aux_vector(1);
	pos_vec(2) = jpos_aux_vector(2);

	return pos_vec;
}
