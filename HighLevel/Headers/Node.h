#pragma once
#include"Includes.h"
class Node
{
public:
	Node();
	Vector3d pos_return() const { return pos; }
	std::double_t cost_return() const { return cost; }
	Vector3d parent_loc_return() const { return parent_loc; }
	void pos_insert(Vector3d p) { pos = p; }
	void parent_insert(Vector3d parent) {
		parent_loc = parent;
	}
	void cost_insert(std::double_t c) { cost = c; }
private:
	Vector3d pos;
	std::double_t cost;
	Vector3d parent_loc;
};

