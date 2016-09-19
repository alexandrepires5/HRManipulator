#include<stdio.h>
#include<stdlib.h>
#include<winsock2.h>
#include<string.h>
#include<tuple>

#include<iostream>
#include<string>
#include<cstdlib>
#include<algorithm>
#include<cmath>
#include<sstream>
#include<random>
#include<vector>
#include<Eigen/Dense>
#include<Eigen/Core>
#include<Eigen/SVD>

#define BUFLEN 8192  //Max length of buffer
#define PORT 9909   //The port on which to listen for incoming data
#define Number_Joints 12
#define SIZE_OF_ARRAY Number_Joints*4


using namespace Eigen;