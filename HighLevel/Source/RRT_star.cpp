#include "RRT_star.h"


RRT_star::RRT_star(Vector3d init_config, Vector3d goal_config)
:q_init(init_config), q_goal(goal_config)
{
	//initialize
}

void RRT_star::Random_Config()
{
	std::random_device rd;
	std::mt19937 mt(rd());
	std::uniform_int_distribution<int> distx(-3.5, 3.5);
	std::uniform_int_distribution<int> disty(-3.5, 3.5);
	std::uniform_int_distribution<int> distz(0.3, 7);

	q_rand(0) = (distx(mt) / 0.01) * 0.01;
	q_rand(1) = (disty(mt) / 0.01) * 0.01;
	q_rand(2) = (distz(mt) / 0.01) * 0.01;
	//std::cout << "q_rand is" << std::endl << q_rand << std::endl;
}
void RRT_star::Extend()
{
	q_new = tree[0];
	Nearest_Neighbour();
	if (true)
	{
		tree_add_vertex();
		tree_add_edge();
		if (q_goal == q_near)
			Reached = true;
	}

}
void RRT_star::tree_add_vertex()
{
	iter++;
	t.insert(t.begin() + iter, qnew);
}
void RRT_star::tree_add_edge()
{
	std::double_t dist_tree_new = 0.0;
	std::double_t dist_near_new = 0.0;
	Node p;
	int k = 0;
	for (std::vector<Node>::const_iterator i = t.begin(); i != t.end(); ++i)
	{
		//std::cout << "entered here" << std::endl;
		p = *i;
		dist_tree_new = (i->pos_return() - qnew.pos_return()).norm();
		dist_near_new = (qnear.pos_return() - qnew.pos_return()).norm();
		if ((qnew.parent_loc_return() != i->pos_return()) && (dist_tree_new < node_radius) && (qnew.cost_return() + dist_tree_new < p.cost_return()))
		{
			p.parent_insert(qnew.pos_return());
			p.cost_insert(qnew.cost_return() + dist_tree_new);
			t[k] = p;
		}
		k++;
	}
}

void RRT_star::ChooseParent()
{
	std::double_t dist_tree_new = 0.0;
	std::double_t dist_near_new = 0.0;
	for (std::vector<Node>::const_iterator i = t.begin(); i != t.end(); ++i)
	{
		dist_tree_new = (i->pos_return() - qnew.pos_return()).norm();
		dist_near_new = (qnear.pos_return() - qnew.pos_return()).norm();
		if (dist_tree_new < node_radius && ((i->cost_return() + dist_tree_new) < (qnear.cost_return() + dist_near_new)))
		{
			qnear = *i;
		}
	}
	qnew.cost_insert(qnear.cost_return() + dist_near_new);
	//std::cout << "cost qnew" << std::endl << qnew.cost_return() << std::endl;
	qnew.parent_insert(qnear.pos_return());
	//std::cout << "parent is now" << std::endl << qnew.parent_loc_return() << std::endl;
}
void RRT_star::Nearest_Neighbour()
{
	std::double_t dist_between_points1 = 0.0;
	std::double_t dist_between_points2 = 0.0;
	qnear.pos_insert(tree[0]);
	for (std::vector<Node>::const_iterator i = t.begin(); i != t.end(); ++i)
	{

		dist_between_points1 = (i->pos_return() - q_rand).norm();
		//std::cout << "dist1" << std::endl << dist_between_points1 << std::endl;
		//dist_between_points2 = (qnew.pos_return() - q_rand).norm();
		dist_between_points2 = (qnear.pos_return() - q_rand).norm();
		//std::cout << "dist2" << std::endl << dist_between_points2 << std::endl;
		if (dist_between_points1 < dist_between_points2)
		{
			//qnew.pos_insert(i->pos_return());
			//qnear.pos_insert(i->pos_return());
			qnear = *i;
			//std::cout << "q_new is now" << std::endl << qnew.pos_return() << std::endl;
		}
	}
	//qnear.pos_insert(qnew.pos_return());
	//std::cout << "q near" << std::endl << qnear.pos_return() << std::endl;
}
void RRT_star::New_Config()
{
	std::double_t aux;
	aux = 0.0;
	qnew.pos_insert(qnear.pos_return() - q_rand);
	aux = max_dist / qnew.pos_return().norm(); //scaler
	qnew.pos_insert(qnear.pos_return() + q_rand*aux);
	//std::cout << "new state is " << qnew.pos_return() << std::endl;
}
std::vector<Node> RRT_star::RRT_solution()
{
	return t;
}

bool RRT_star::Collision_Check(Obstacle &Obs)
{
	Vector3d center;
	std::double_t h;
	std::double_t r;
	center = Obs.center_return();
	//std::cout << "center of obs" << std::endl << center << std::endl;
	h = Obs.height_return();
	//std::cout << "h" << std::endl << h << std::endl;
	r = Obs.radius_return();
	//std::cout << "r" << std::endl << r << std::endl;
	q_new = qnew.pos_return();
	bool side_check = (((abs(q_new(0)) > abs((center(0) - r))) && (abs(q_new(1)) > abs((center(1) - r)))) &&
		(((abs(q_new(0)) < abs((center(0) + r))) && (abs(q_new(1)) < (abs(center(1) + r))))));
	//bool side_check = (((q_new(0) > abs(center(0) - r)) && (q_new(1) > (center(1) - r))) &&
	//(((q_new(0) < (center(0) + r)) && (q_new(1) < (center(1) + r)))));
	//std::cout << "side check" << std::endl << side_check << std::endl;
	bool height_check = (q_new(2) < (center(2) + h)) || (q_new(2) > (center(2) - h));
	//std::cout << "height check" << std::endl << height_check << std::endl;
	if (side_check && height_check)
	{
		//std::cout << "true collision" << std::endl;
		Collision = true;
		return Collision;
	}
	else
	{
		//std::cout << "false collision " << std::endl;
		Collision = false;
		return Collision;
	}

}
void RRT_star::RRT_solver()
{

	qinit.pos_insert(q_init);
	t.insert(t.begin(), qinit);
	tree.insert(tree.begin(), q_init); //appends to the tree the initial config
	q_new << q_new.setZero();
	qnew.pos_insert(q_new);
	qnew.cost_insert(0.0);
	qnew.parent_insert(q_new);
	Vector3d ob_c;
	std::double_t r, h;

	char b;
	ob_c(0) = 0.09;
	ob_c(1) = 0.09;
	ob_c(2) = 0.04;
	r = 0.04;
	h = 0.012;
	b = 's'; // s -> sphere r -> rectangle c -> cylindir/cone
	Obstacle Obs(ob_c, h, r, b);

	int c_detect = 0;
	for (int count = 0; count < max_vertex; count++)
	{
		//std::cout << "---------------------------" << std::endl;
		//std::cout << "num vertex" << std::endl << count << std::endl;
		//std::cout << "---------------------------" << std::endl;
		Random_Config();
		qnew.pos_insert(t[0].pos_return());
		Nearest_Neighbour();
		New_Config();
		ChooseParent();

		if (!Collision_Check(Obs))
		{
			tree_add_vertex();
			tree_add_edge();
		}
		else
		{
			c_detect++;
		}


	}

	//std::cout << "Current tree" << std::endl;
	/*std::cout << "tree" << std::endl;
	for (std::vector<Node>::const_iterator i = t.begin(); i != t.end(); ++i)
	{
	std::cout << " " << std::endl << i->pos_return() << std::endl;
	}*/
	/*std::cout << "cost" << std::endl;
	for (std::vector<Node>::const_iterator i = t.begin(); i != t.end(); ++i)
	{
	std::cout << "xyz:" << std::endl;
	std::cout << " " << std::endl << i->pos_return() << std::endl;
	//std::cout << " " << std::endl << i->cost_return() << std::endl;
	}
	std::cout << "number of collision points" << std::endl << c_detect << std::endl;
	*/
	std::cout << "path done" << std::endl;
}