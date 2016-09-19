#pragma once
#include"Includes.h"
#include"Node.h"
#include"Obstacle.h"
class RRT_star
{
public:
	RRT_star(Vector3d q_init, Vector3d q_goal);
	void Random_Config();
	void Extend();
	void tree_add_vertex();
	void tree_add_edge();
	void Nearest_Neighbour();
	void New_Config();
	std::vector<Node> RRT_solution();
	void RRT_solver();
	bool Collision_Check(Obstacle &Obs);
	void ChooseParent();
private:
	std::vector<VectorXd> tree;
	std::vector<Node> t;
	std::vector<Node> path_solution;
	//std::vector<std::double_t> tree_cost;
	Vector3d q_init;
	Vector3d q_rand;
	Vector3d q_new;
	Vector3d q_near;
	Vector3d q_goal;
	bool Reached = false;
	bool Advanced = false;
	bool Trapped = false;
	bool Collision = true;
	int iter = 0;
	std::double_t cost;
	std::double_t node_radius = 0.15; //0.7 before
	const int max_vertex = 100;
	const std::double_t max_dist = 0.05; //0.35 before
	Node qnew, qinit, qnear;
};


