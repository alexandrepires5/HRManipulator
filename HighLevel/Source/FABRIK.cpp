#include "FABRIK.h"


FABRIK::FABRIK(Arm &arm, Vector3d Target)
:Manipulator(arm), TargetPos(Target)
{
}


FABRIK::~FABRIK()
{
}

bool FABRIK::target_reachability()
{
	std::double_t link_len = 0.35;
	std::double_t sum = 0.0;
	for (int i = 0; i < Number_Joints; i++)
	{
		sum = sum + link_len;
	}

	Vector3d dist = (Manipulator.RecSegmentPos(0) - TargetPos);
	if (dist.norm() < sum)
	{
		return true;
	}
	return false; //target can't be reached
}

//FABRIK stage 1 of algorithm: start from end effector position and run until base.
MatrixXd FABRIK::FABRIK_forward_reach()
{
	MatrixXd forward_joint_pos(3, Number_Joints + 1);
	forward_joint_pos.col(Number_Joints) = TargetPos;
	for (int j = Number_Joints - 1; j >= 0; j--) //starts from n-1, n being the end effector position
	{
		Vector3d dist_between_joint = Manipulator.RecSegmentPos(j) - forward_joint_pos.col(j + 1);
		std::double_t scale = 0.35 / dist_between_joint.norm();
		forward_joint_pos.col(j) = (1 - scale)*forward_joint_pos.col(j + 1) + scale*Manipulator.RecSegmentPos(j);
	}
	return forward_joint_pos;
}
//FABRIK stage 2 of algorithm: start from joint base and run until end effector.
MatrixXd FABRIK::FABRIK_backward_reach()
{
	MatrixXd backward_joint_pos(3, Number_Joints + 1);
	backward_joint_pos.col(0) = Manipulator.RecSegmentPos(0);
	for (int i = 0; i < Number_Joints; i++)
	{
		Vector3d dist_between_joint = Manipulator.RecSegmentPos(i + 1) - backward_joint_pos.col(i);
		std::double_t scale = 0.35 / dist_between_joint.norm();
		backward_joint_pos.col(i + 1) = (1 - scale)*backward_joint_pos.col(i) + scale*Manipulator.RecSegmentPos(i + 1);
	}
	return backward_joint_pos;
}


/*VectorXd FABRIK_joint_angle_calc(MatrixXd init_pos_mat, MatrixXd desired_pos_mat, VectorXd curr_angles)
{
	VectorXd new_angles(Number_Joints);
	MatrixXd updated_pos_mat(3, Number_Joints + 1);
	updated_pos_mat = init_pos_mat;
	new_angles = curr_angles;
	for (int i = 0; i < Number_Joints; i++)
	{
		Vector3d init_vec, des_vec;
		//calculate vectors between current and previous joint
		init_vec = updated_pos_mat.col(i + 1) - updated_pos_mat.col(i);
		std::cout << "updated pos mat" << std::endl << updated_pos_mat << std::endl;
		des_vec = desired_pos_mat.col(i + 1) - desired_pos_mat.col(i);
		//normalize vectors
		init_vec.normalize();
		des_vec.normalize();
		//dot product between vectors
		std::double_t dot_prod = init_vec.dot(des_vec);
		Vector3d cross = init_vec.cross(des_vec);
		cross.normalize();
		new_angles(i) = acos(dot_prod);
		//updated_pos_mat = calc_DH_matrix(new_angles);
	}
	return new_angles;
}
*/

VectorXd FABRIK::FABRIKSolver()
{
	VectorXd New_angles(Number_Joints);
	Vector3d base, end_effector, joint_pos;
	MatrixXd calc_pos_mat(3, Number_Joints + 1);
	MatrixXd f_joint_pos(3, Number_Joints + 1), b_joint_pos(3, Number_Joints + 1);
	const std::double_t TOLERANCE = 0.01;
	const int max_iter = 1000;
	int iter = 0;
	//New_angles = initial_angs;
	Vector3d dX;
	if (target_reachability())
	{
		Vector3d dist_to_target = Manipulator.RecSegmentPos(Number_Joints) - TargetPos;
		dX = dist_to_target;
		//b_joint_pos = calc_pos_mat;
		while ((dist_to_target.norm() > TOLERANCE) && max_iter > iter)
		{
			std::cout << "dist to target is" << std::endl << dist_to_target.norm() << std::endl;
			//forward reaching 
			f_joint_pos = FABRIK_forward_reach();
			std::cout << "forward reach joint pos" << std::endl << f_joint_pos << std::endl;
			//backwards reaching
			b_joint_pos = FABRIK_backward_reach();
			std::cout << "backwards reach joint pos" << std::endl << b_joint_pos << std::endl;
			//update values

			Manipulator.RecSegmentPos(Number_Joints) = b_joint_pos.col(Number_Joints);
			std::cout << "end effector now" << std::endl << end_effector << std::endl;
			dist_to_target = Manipulator.RecSegmentPos(Number_Joints) - TargetPos;
			iter++;
		}
		//MatrixXd jac = calc_jacobian_mat(b_joint_pos, target_pos);
		//MatrixXd inv_jac = pseudoInverse(jac);
		//std::cout << "inv jac" << std::endl << inv_jac << std::endl;
		//New_angles = inv_jac*dX;
		/*New_angles = FABRIK_joint_angle_calc(calc_pos_mat, b_joint_pos, New_angles);
		for (int i = 0; i < Number_Joints; i++)
		{
		New_angles(i) = quadrant_check(i, New_angles(i), target_pos);
		}*/
		//b_joint_pos = calc_DH_matrix(New_angles);
		//std::cout << "final pos mat " << std::endl << calc_DH_matrix(New_angles) << std::endl;
		std::cout << "new angles are now" << std::endl << New_angles << std::endl;
	}
	else
	{
		std::cout << "can't reach target" << std::endl;
	}
	return New_angles;

}
