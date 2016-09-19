#include "Inv_CCD.h"


Inv_CCD::Inv_CCD(Arm &arm, Vector3d Target)
:Manipulator(arm), TargetPos(Target)
{
	//initialization
}


Inv_CCD::~Inv_CCD()
{
}

std::double_t Inv_CCD::angleNormalize(std::double_t angle)
{
	std::double_t norm_angle = 0.0;
	norm_angle = atan2(sin(angle), cos(angle));
	return norm_angle;
}
std::double_t Inv_CCD::angleDynamicStep(std::double_t angle, std::double_t distance, int link)
{
	std::double_t dynamic_step;
	angle = angleNormalize(angle);
	dynamic_step = (angle*distance*link) / 12.0; //9.0 before
	return dynamic_step;
}

std::double_t Inv_CCD::angleRotCorrection(std::double_t angle, VectorXd cross_result, std::double_t corrected_angle, std::double_t distance, int link)
{
	if (0 == link)
	{
		if (cross_result(2) > 0)
		{
			angle = angleDynamicStep(angle, distance, link + 1);
			corrected_angle = corrected_angle - angle;
			std::cout << ">0 " << std::endl << corrected_angle << std::endl;
		}
		else
		{
			angle = angleDynamicStep(angle, distance, link + 1);
			corrected_angle = corrected_angle + angle;
			std::cout << "<0 " << std::endl << corrected_angle << std::endl;
		}
	}
	else if (0 == link % 2)
	{
		if (cross_result(2) > 0)
		{
			angle = angleDynamicStep(angle, distance, link + 1);
			corrected_angle = corrected_angle - angle;
			std::cout << ">0 " << std::endl << corrected_angle << std::endl;
		}
		else
		{
			angle = angleDynamicStep(angle, distance, link + 1);
			corrected_angle = corrected_angle + angle;
			std::cout << "<0 " << std::endl << corrected_angle << std::endl;
		}
	}
	else
	{
		if (cross_result(1) > 0)
		{
			angle = angleDynamicStep(angle, distance, link + 1);
			corrected_angle = corrected_angle - angle;
			std::cout << ">0 " << std::endl << corrected_angle << std::endl;
		}
		else
		{
			angle = angleDynamicStep(angle, distance, link + 1);
			corrected_angle = corrected_angle + angle;
			std::cout << "<0 " << std::endl << corrected_angle << std::endl;
		}
	}
	corrected_angle = angleNormalize(corrected_angle);
	return corrected_angle;
}

VectorXd Inv_CCD::CCDSolver()
{
	const int max_iter_ccd = 10000;
	const std::double_t max_cost = 30.0;
	Vector3d ROOT_POS, CUR_END, END_POS;
	VectorXd ANGLE_VEC(Number_Joints);
	Quaternion<std::double_t> q_res, q_link, q_fin;
	

	int link = 11; //starting from joint previous to end effector
	int j = 0;

	Vector3d end_effect_dist;
	for (int i = 0; i < max_iter_ccd; i++)
	{
		
		std::cout << "iteration number" << std::endl << i << std::endl;
		std::double_t aux_angle = 0.0;
		std::cout << "--------------------------------" << std::endl;
		std::cout << "Number of joint:" << std::endl << link << std::endl;
		CUR_END = Manipulator.RecSegmentPos(Number_Joints); //end effector			
		ROOT_POS = Manipulator.RecSegmentPos(link);
		Vector3d CUR_VEC = CUR_END - ROOT_POS;
		Vector3d TARGET_VEC = TargetPos - ROOT_POS;
		CUR_VEC.normalize();
		TARGET_VEC.normalize();
		end_effect_dist = TargetPos - CUR_END;
		std::cout << "end effect error" << std::endl << end_effect_dist.norm() << std::endl;
		if (end_effect_dist.norm() < 0.01)
		{
			break;
		}

		std::double_t cosangle = TARGET_VEC.dot(CUR_VEC);


		if (cosangle < 0.99999)
		{
			Vector3d cross_result = TARGET_VEC.cross(CUR_VEC);
			cross_result.normalize();
			std::double_t TURN_ANGLE = acos(cosangle);
			//insert dynamic step here!!!!!!!!
			//---------------------------------------------------------------------------
			//TURN_ANGLE = ANGLE_VEC(link) + angleDynamicStep(TURN_ANGLE, end_effect_dist.norm(), link);
			TURN_ANGLE = angleRotCorrection(TURN_ANGLE, cross_result, ANGLE_VEC(link), end_effect_dist.norm(), link);
			std::cout << "Turn angle now" << std::endl << TURN_ANGLE << std::endl;
			//----------------------------------------------------------------------------
			//q_res = AngleAxis<std::double_t>(TURN_ANGLE, cross_result);
			//q_fin = Manipulator.RecSegmentRot(link)*q_res;

			ANGLE_VEC(link) = TURN_ANGLE;
			//ANGLE_VEC(link) = q_fin.angularDistance(Manipulator.RecSegmentRot(link));
			//std::cout << "end effect dist norm" << std::endl << end_effect_dist.norm() << std::endl;
			//Manipulator.UpdateArmFK(link, q_fin);
			//std::cout << "calc pos mat after 1 joints iter: " << std::endl << calc_pos_mat << std::endl;
			Manipulator.UpdateArmFK(ANGLE_VEC);
		}

		std::cout << "----------------------------------------------" << std::endl;
		if (link > 0)//excluding end effector
		{
			link = link--;
		}
		else
		{
			//std::cout << "new angles" << std::endl << ANGLE_VEC << std::endl;
			link = 11;
		}


	}
	return ANGLE_VEC;

}