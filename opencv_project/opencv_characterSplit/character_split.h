/**************************************************************************
File:         character_split.h
Author:       Song Xiaofeng
Date:         2016-12-08
**************************************************************************/

#pragma once

#include "opencv2/opencv.hpp"
using namespace std;
using namespace cv;

namespace spt {
	void CharacterSplit(const cv::Mat& bin, const cv::Mat& src);
}