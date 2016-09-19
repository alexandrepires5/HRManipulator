#pragma once
#include"Includes.h"
class Obstacle
{
public:
	Obstacle(Vector3d obs_center, std::double_t height, std::double_t radius, char Type);
	Vector3d center_return() { return obs_center; }
	std::double_t height_return() { return height; }
	std::double_t radius_return() { return radius; }
private:
	Vector3d obs_center;
	std::double_t height;
	std::double_t radius;
	char Type;
};

