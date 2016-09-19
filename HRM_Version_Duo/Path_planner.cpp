#include "Path_planner.h"


Path_planner::Path_planner(std::string IKSolver, std::string PPSolver, bool Optimization, Arm &arm, Vector3d Target, bool Obstacles)
:IKsolv(IKSolver), PPsolv(PPSolver), opt(Optimization), Manipulator(arm), TargetPos(Target), obs(Obstacles)
{
	try
	{
		if (!(IKsolv == JacPseudoInv) && !(IKsolv == CCD) && !(IKsolv == sFABRIK) && !(PPsolv == ppRRT) && !(PPsolv == ppRRT_star))
		{
			throw myex;
		}
	}
	catch (Exceptions& exc)
	{
		std::cout << "puff" << std::endl;
	}
}


Path_planner::~Path_planner()
{
}

VectorXd Path_planner::PathPlanningSolve()
{
	VectorXd newangles(Number_Joints);
	newangles.setZero();
	if (PPsolv == ppRRT)
	{
		if (IKsolv == JacPseudoInv)
		{
			if (opt == false)
			{
				while (!goalReached)
				{
					/*RRT test(new_point, goal);
					test.RRT_solver();
					path = test.RRT_solution();
					for (std::vector<Node>::const_iterator i = path.begin(); i != path.end(); ++i)
					{
						std::cout << "entered here" << std::endl;
						Vector3d aux;
						aux = i->pos_return() - goal;
						std::cout << "aux is" << std::endl << aux << std::endl;
						std::cout << "aux norm is" << std::endl << aux.norm() << std::endl;
						if (aux.norm() < dist_to_goal.norm())
						{
							std::cout << "aux norm is less than dist to goal norm" << std::endl;
							new_point = i->pos_return();
							if (new_point(0) < 0.01 || new_point(1) < 0.01 || new_point(2) < 0.01)
							{
								continue;
							}
							std::cout << "new point is" << std::endl << new_point << std::endl;
							angles = JACOBIAN_METHOD(angles, new_point);
							dist_to_goal = goal - new_point;
						}
						if (dist_to_goal.norm() < 0.65)
						{
							angles = JACOBIAN_METHOD(angles, goal);
							goal_reached = true;
							break;
						}
					}*/
				}
			}
			else
			{
			}
		}
		else if (IKsolv == CCD)
		{
			if (opt == false)
			{

			}
			else
			{
			}
		}
		else if (IKsolv == sFABRIK)
		{
			if (opt == false)
			{

			}
			else
			{

			}
		}
	}
	else if (PPsolv == ppRRT_star)
	{
		if (IKsolv == JacPseudoInv)
		{
			if (opt == false)
			{

			}
			else
			{
			}
		}
		else if (IKsolv == CCD)
		{
			if (opt == false)
			{

			}
			else
			{
			}
		}
		else if (IKsolv == sFABRIK)
		{
			if (opt == false)
			{

			}
			else
			{

			}
		}
	}
	return newangles;
}
