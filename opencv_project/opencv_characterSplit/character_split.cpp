/**************************************************************************
File:         character_split.h
Author:       Song Xiaofeng
Date:         2016-12-08
**************************************************************************/

#include "character_split.h"

#define AREA_THRESHOLD 200

void spt::CharacterSplit(const cv::Mat& bin, const cv::Mat& src) {

	vector<vector<Point> > contours; //存放检测到的轮廓
	vector<Vec4i> hierarchy; //存放图像的拓扑信息
	  
	//寻找图像轮廓，并将检测到的轮廓存入contours，相关拓扑信息存入hierarchy
	findContours(bin, contours, hierarchy, RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);

	//在原图像中画出轮廓， 结果存入contoursImg
	Mat dst = src.clone();
	vector<Mat> vecResult;
	for (int i = 0; i < contours.size(); ++i)
	{
		Rect rect = boundingRect(Mat(contours[i]));
		if (rect.width * rect.height < AREA_THRESHOLD) {
			continue;
		}
		rectangle(dst, rect.tl(), rect.br(), Scalar(255, 0, 0));
		Mat tmp = src(rect);
		vecResult.push_back(tmp);
	}
	imshow("contoursImg", dst);

	//将分割出来的字符图像规范到24*32的大小,并写出图像
	int i = 0;
	for (vector<Mat>::iterator it = vecResult.begin(); it != vecResult.end(); ++it, ++i) {
		resize(*it, *it, Size(24, 32));
		char buf[4];
		itoa(i, buf, 10);
		string path = string("images/10/") + buf + ".jpg";
		imwrite(path, *it);
	}
}