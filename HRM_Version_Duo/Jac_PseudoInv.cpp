#include "Jac_PseudoInv.h"

//:Manipulator(arm), TargetPos(Target)
Jac_PseudoInv::Jac_PseudoInv(Arm &arm, Vector3d Target)
:Manipulator(arm), TargetPos(Target)
{

}


Jac_PseudoInv::~Jac_PseudoInv()
{
}

template<typename _Matrix_Type_>
_Matrix_Type_ pseudoInverse(const _Matrix_Type_ &a, double epsilon = std::numeric_limits<double>::epsilon())
{
	JacobiSVD< _Matrix_Type_ > svd(a, ComputeThinU | ComputeThinV);
	double tolerance = epsilon * max(a.cols(), a.rows()) *svd.singularValues().array().abs()(0);
	return svd.matrixV() *  (svd.singularValues().array().abs() > tolerance).select(svd.singularValues().array().inverse(), 0).matrix().asDiagonal() * svd.matrixU().adjoint();
}

void Jac_PseudoInv::angle_normalize(VectorXd &AnglesToNorm)
{
	std::double_t norm_angle = 0.0;
	for (int i = 0; i < Number_Joints; i++)
	{
		AnglesToNorm(i) = atan2(sin(AnglesToNorm(i)), cos(AnglesToNorm(i)));
	}
}

Vector3d Jac_PseudoInv::dX()
{
	Vector3d dx(3);
	dx = TargetPos - Manipulator.RecSegmentPos(Number_Joints);
	return dx;
}

VectorXd Jac_PseudoInv::dTheta(VectorXd current_angles, VectorXd prev_angles)
{
	VectorXd dif_theta(Number_Joints);
	dif_theta = current_angles - prev_angles;

	return dif_theta;
}

VectorXd Jac_PseudoInv::CalcJacobianIndex(VectorXd end_effect_pos, VectorXd joint_pos, int link)
{
	Vector3d cross_result(3);
	cross_result << cross_result.setZero();
	Vector3d z_rot(3), y_rot(3);
	z_rot << z_rot.setZero();
	y_rot << y_rot.setZero();
	z_rot(2) = 1;
	y_rot(1) = 1;
	if (0 == link % 2)
	{
		Vector3d vec_sub(3);
		vec_sub = end_effect_pos - joint_pos;
		cross_result = z_rot.cross(vec_sub);
	}
	else
	{
		Vector3d vec_sub(3);
		vec_sub = end_effect_pos - joint_pos;
		cross_result = y_rot.cross(vec_sub);
	}
	return cross_result;
}
MatrixXd Jac_PseudoInv::CalcJacobianMat()
{
	MatrixXd J(3, Number_Joints);
	for (int i = 0; i < Number_Joints; i++)
	{
		J.col(i) = CalcJacobianIndex(Manipulator.RecSegmentPos(Number_Joints), Manipulator.RecSegmentPos(i), i);
	}
	return J;
}

std::double_t Jac_PseudoInv::InverseError(MatrixXd J, MatrixXd J_inv, VectorXd DIF_END_EFFECT_POS)
{
	Matrix3d I;
	I = Matrix3d::Identity();
	I.setIdentity();
	Vector3d error;
	std::double_t MATRIX_ERROR;
	error = (I - (J*J_inv))*DIF_END_EFFECT_POS;
	MATRIX_ERROR = error.norm();
	return MATRIX_ERROR;
}

VectorXd Jac_PseudoInv::CalcJacobianAngles(MatrixXd jacobian_inv, VectorXd dX, VectorXd angles, std::double_t dist)
{
	VectorXd new_angles_to_send(Number_Joints);

	VectorXd GAIN = ((jacobian_inv*dX)*0.1);
	//std::cout << "GAIN IS" << std::endl << GAIN << std::endl;
	new_angles_to_send = (angles + GAIN);

	//std::cout << "NEW ANGLES:" << std::endl << NEW_ANGLES << std::endl;
	//std::cout << "BEFORE RETURN" << std::endl << NEW_ANGLES << std::endl;
	return new_angles_to_send;
}

VectorXd Jac_PseudoInv::JacPseudoInvSolver()
{
	VectorXd angles_to_send(Number_Joints), previous_angles(Number_Joints);
	VectorXd end_effect_pos_error(3);
	MatrixXd pos_dif(3, Number_Joints);
	VectorXd ang_dif(Number_Joints);
	MatrixXd jacobian_mat(3, Number_Joints);
	MatrixXd jacobian_inv_mat(Number_Joints, 3);
	std::double_t pseudo_inv_error = 0.0;

	VectorXd delta_end_effect(3);
	int link = 0;
	Arm prevManipulatorState = Manipulator;
	std::cout << "going to solve" << std::endl;
	for (int count = 0; count < MAXITER; count++)
	{
		
		delta_end_effect = Manipulator.RecSegmentPos(Number_Joints) - prevManipulatorState.RecSegmentPos(Number_Joints);
		end_effect_pos_error = dX();
		if (end_effect_pos_error.norm() < ErrorThreshold)
		{
			std::cout << "finished though" << std::endl;
			angle_normalize(angles_to_send);
			std::cout << "Manipulator JAC angles" << std::endl << Manipulator.RecvArmAngles() << std::endl;
			std::cout << "anglestosend" << std::endl << angles_to_send << std::endl;
			
			break;
		}
		ang_dif = dTheta(angles_to_send, previous_angles);
		jacobian_mat = CalcJacobianMat();
		jacobian_inv_mat = pseudoInverse(jacobian_mat);
		pseudo_inv_error = InverseError(jacobian_mat, jacobian_inv_mat, end_effect_pos_error);

		VectorXd error_pseudo(3);
		error_pseudo << error_pseudo.setZero();
		error_pseudo = end_effect_pos_error;
		VectorXd aux(3);
		aux = end_effect_pos_error;
		while (pseudo_inv_error > InversionError)
		{
			pseudo_inv_error = InverseError(jacobian_mat, jacobian_inv_mat, error_pseudo);
			error_pseudo = error_pseudo / 2;
			end_effect_pos_error = error_pseudo;
		}


		previous_angles = angles_to_send;
		angles_to_send = CalcJacobianAngles(jacobian_inv_mat, end_effect_pos_error, angles_to_send, aux.norm());		
		angle_normalize(angles_to_send);

		prevManipulatorState = Manipulator;
		Manipulator.UpdateArmFK(angles_to_send);
		//std::cout << "Manipulator JAC angles" << std::endl << Manipulator.RecvArmAngles() << std::endl;
		//std::cout << "anglestosend" << std::endl << angles_to_send << std::endl;
	}
	return Manipulator.RecvArmAngles();
}
