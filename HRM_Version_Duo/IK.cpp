#include "IK.h"


IK::IK(std::string Solver, bool Optimization, Arm &arm, Vector3d Target)
:solv(Solver), opt(Optimization), Manipulator(arm), TargetPos(Target)
{
	try
	{
		if (!(solv == JacPseudoInv) && !(solv == CCD) && !(solv == sFABRIK))
		{
			throw myex;
		}
	}
	catch ( Exceptions& exc )
	{
		std::cout << "puff" << std::endl;
	}
}


IK::~IK()
{
}

VectorXd IK::IKSolve()
{
	VectorXd NewAngles(Number_Joints);
	NewAngles.setZero();
	if (solv == JacPseudoInv)
	{
		if (opt == false)
		{
			std::cout << "Entered in JacPseudoInv" << std::endl;
			Jac_PseudoInv Jac(Manipulator, TargetPos);
			NewAngles = Jac.JacPseudoInvSolver();
		}
		else
		{
		}
	}
	else if (solv == CCD)
	{
		if (opt == false)
		{
			std::cout << "Entered in CCD" << std::endl;
			Inv_CCD CCD(Manipulator, TargetPos);
			NewAngles = CCD.CCDSolver();
		}
		else
		{

		}
	}
	else if (solv == sFABRIK)
	{
		if (opt == false)
		{
			std::cout << "Entered in FABRIK" << std::endl;
			FABRIK fabrik(Manipulator, TargetPos);
			NewAngles = fabrik.FABRIKSolver();
		}
		else
		{

		}
		
	}
	return NewAngles;
}
