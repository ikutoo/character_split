/**************************************************************************
File:         main.h
Author:       Song Xiaofeng
Date:         2016-12-07
**************************************************************************/
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include "character_split.h"
#include "preprocess.h"

using namespace cv;
using namespace std;

bool bRotationCorrection = false;
bool bMaftSr = false;

int main(int argc, char** argv) {

	if ((argc % 2) != 1) {
		cerr << "param error!" << endl;
		exit(0);
	}
	string src = "";
	string dst = "";

	for (int i = 1; i < argc; i += 2) {
		char * s1 = argv[i];
		char * s2 = argv[i + 1];
		if (0 == strcmp(s1, "-s")) {
			src = s2;
		}
		else if (0 == strcmp(s1, "-d")) {
			dst = s2;
		}
		else if (0 == strcmp(s1, "-r")) {
			bRotationCorrection = (bool)atoi(s2);
		}
		else if (0 == strcmp(s1, "-f")) {
			bMaftSr = (bool)atoi(s2);
		}
	}

	//读取源图像
	Mat imgSrc = imread("src", 1);
	imshow("sourceImg", imgSrc);

	//将原图像进行预处理，得到处理后的灰度图像
	Mat imgGray;
	cvtColor(imgSrc, imgGray, CV_RGB2GRAY);
	imshow("grayImg", imgGray);

	if (bRotationCorrection) {
		//旋转文本校正
		pre::RotationTextCorrection(imgGray, imgGray);
		imshow("rotateImg", imgGray);
	}

	if (bMaftSr) {
		//调幅傅里叶变换
		pre::MaftSrMethod(imgGray, imgGray);
		imshow("grayImg1", imgGray);
	}

	////进行直方图均衡化
	//equalizeHist(imgGray, imgGray);
	//imshow("grayImg2", imgGray);

	////定义核
	//Mat element = getStructuringElement(MORPH_RECT, Size(15, 15));
	////进行形态学操作
	//morphologyEx(imgGray, imgGray, MORPH_OPEN, element);
	//imshow("grayImg3", imgGray);

	//将灰度图像二值化
	Mat imgBin;
	threshold(imgGray, imgBin, 50, 255, CV_THRESH_BINARY_INV);
	imshow("binImg", imgBin);

	//字符分割
	spt::CharacterSplit(imgBin, imgSrc);

	waitKey(0);
	return 0;
}

