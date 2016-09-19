#include "Node.h"


Node::Node()
{
	pos << pos.setZero();
	cost = 0.0;
	parent_loc << parent_loc.setZero();
}