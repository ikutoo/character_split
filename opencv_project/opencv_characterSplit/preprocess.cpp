/**************************************************************************
File:         preprocess.h
Author:       Song Xiaofeng
Date:         2016-12-07
**************************************************************************/

#include "preprocess.h"
using namespace cv;
using namespace std;
#define GRAY_THRESH 150
#define HOUGH_VOTE 100

void pre::PreProcess(const cv::Mat& src, cv::Mat& dst) {
	cv::cvtColor(src, dst, CV_BGR2GRAY);
	//cv::imshow("灰度图像", dst);
	//cv::GaussianBlur(dst, dst, cv::Size(5, 5), 0.0);
	//cv::imshow("高斯平滑图像", dst);

}

void pre::MaftSrMethod(const cv::Mat& src, cv::Mat& dst) {
	Mat planes[] = { Mat_<float>(src), Mat::zeros(src.size(), CV_32F) };
	Mat complexI;
	merge(planes, 2, complexI);
	dft(complexI, complexI);

							
	Mat mag, pha, mag_mean;
	Mat Re, Im;
	split(complexI, planes); 
	Re = planes[0]; 
	Im = planes[1]; 
	magnitude(Re, Im, mag); 
	phase(Re, Im, pha); 

	float *pre, *pim, *pm, *pp;

	for (int i = 0; i < mag.rows; i++)
	{
		pm = mag.ptr<float>(i);
		for (int j = 0; j < mag.cols; j++)
		{
			*pm = log(*pm);
			pm++;
		}
	}
	blur(mag, mag_mean, Size(5, 5)); 
	mag = mag - mag_mean; 
						 
	for (int i = 0; i < mag.rows; i++)
	{
		pre = Re.ptr<float>(i);
		pim = Im.ptr<float>(i);
		pm = mag.ptr<float>(i);
		pp = pha.ptr<float>(i);
		for (int j = 0; j < mag.cols; j++)
		{
			*pm = exp(*pm);
			*pre = *pm * cos(*pp);
			*pim = *pm * sin(*pp);
			pre++;
			pim++;
			pm++;
			pp++;
		}
	}
	Mat planes1[] = { Mat_<float>(Re),Mat_<float>(Im) };

	merge(planes1, 2, complexI); 
	idft(complexI, complexI, DFT_SCALE); 
	split(complexI, planes);
	Re = planes[0];
	Im = planes[1];
	magnitude(Re, Im, mag); 
	for (int i = 0; i < mag.rows; i++)
	{
		pm = mag.ptr<float>(i);
		for (int j = 0; j < mag.cols; j++)
		{
			*pm = (*pm) * (*pm);
			pm++;
		}
	}
	GaussianBlur(mag, mag, Size(7, 7), 2.5, 2.5);
	Mat invDFT;
	normalize(mag, invDFT, 0, 255, NORM_MINMAX); 
	invDFT.convertTo(dst, CV_8U);
}


void pre::RotationTextCorrection(const cv::Mat& src, cv::Mat& dst) {
	Mat srcImg = src;
	if (srcImg.empty())
		return;

	Point center(srcImg.cols / 2, srcImg.rows / 2);


	Mat padded;
	int opWidth = getOptimalDFTSize(srcImg.rows);
	int opHeight = getOptimalDFTSize(srcImg.cols);
	copyMakeBorder(srcImg, padded, 0, opWidth - srcImg.rows, 0, opHeight - srcImg.cols, BORDER_CONSTANT, Scalar::all(0));

	Mat planes[] = { Mat_<float>(padded), Mat::zeros(padded.size(), CV_32F) };
	Mat comImg;

	merge(planes, 2, comImg);

	dft(comImg, comImg);

	split(comImg, planes);
	magnitude(planes[0], planes[1], planes[0]);

	Mat magMat = planes[0];
	magMat += Scalar::all(1);
	log(magMat, magMat);

	magMat = magMat(Rect(0, 0, magMat.cols & -2, magMat.rows & -2));

	int cx = magMat.cols / 2;
	int cy = magMat.rows / 2;

	Mat q0(magMat, Rect(0, 0, cx, cy));
	Mat q1(magMat, Rect(0, cy, cx, cy));
	Mat q2(magMat, Rect(cx, cy, cx, cy));
	Mat q3(magMat, Rect(cx, 0, cx, cy));

	Mat tmp;
	q0.copyTo(tmp);
	q2.copyTo(q0);
	tmp.copyTo(q2);

	q1.copyTo(tmp);
	q3.copyTo(q1);
	tmp.copyTo(q3);

	normalize(magMat, magMat, 0, 1, CV_MINMAX);
	Mat magImg(magMat.size(), CV_8UC1);
	magMat.convertTo(magImg, CV_8UC1, 255, 0);

	threshold(magImg, magImg, GRAY_THRESH, 255, CV_THRESH_BINARY);

	vector<Vec2f> lines;
	float pi180 = (float)CV_PI / 180;
	Mat linImg(magImg.size(), CV_8UC3);
	HoughLines(magImg, lines, 1, pi180, HOUGH_VOTE, 0, 0);
	int numLines = lines.size();
	for (int l = 0; l < numLines; l++)
	{
		float rho = lines[l][0], theta = lines[l][1];
		Point pt1, pt2;
		double a = cos(theta), b = sin(theta);
		double x0 = a*rho, y0 = b*rho;
		pt1.x = cvRound(x0 + 1000 * (-b));
		pt1.y = cvRound(y0 + 1000 * (a));
		pt2.x = cvRound(x0 - 1000 * (-b));
		pt2.y = cvRound(y0 - 1000 * (a));
		line(linImg, pt1, pt2, Scalar(255, 0, 0), 3, 8, 0);
	}

	float angel = 0;
	float piThresh = (float)CV_PI / 90;
	float pi2 = CV_PI / 2;
	for (int l = 0; l < numLines; l++)
	{
		float theta = lines[l][1];
		if (abs(theta) < piThresh || abs(theta - pi2) < piThresh)
			continue;
		else {
			angel = theta;
			break;
		}
	}

	angel = angel < pi2 ? angel : angel - CV_PI;
	if (angel != pi2) {
		float angelT = srcImg.rows*tan(angel) / srcImg.cols;
		angel = atan(angelT);
	}
	float angelD = angel * 180 / (float)CV_PI;

	Mat rotMat = getRotationMatrix2D(center, angelD, 1.0);
	dst = Mat::ones(srcImg.size(), CV_8UC3);
	warpAffine(srcImg, dst, rotMat, srcImg.size(), 1, 0, Scalar(255, 255, 255));
}