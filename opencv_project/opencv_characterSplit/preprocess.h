/**************************************************************************
File:         preprocess.h
Author:       Song Xiaofeng
Date:         2016-12-07
**************************************************************************/

#pragma once

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

namespace pre {
	//预处理
	void PreProcess(const cv::Mat& src, cv::Mat& dst);
	//调幅傅里叶变换-残余谱方法
	void MaftSrMethod(const cv::Mat& src, cv::Mat& dst);
	//基于傅里叶变换的旋转文本校正
	void RotationTextCorrection(const cv::Mat& src, cv::Mat& dst);
}
