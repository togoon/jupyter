#include <iostream>
#include <math.h>
#include <stdio.h>
#include <cstring>
#include <stdlib.h> //必须引用
using namespace std;

int main()
{
	int i;
	int temp;
	FILE *fp;						  //定义一个文件指针
	fp = fopen("ZeroCurve.txt", "w"); //以只写的方式打开文件，前面的参数是文件路径，后面的参数是表示只写
	if (fp == NULL)
	{ //文件不存在，则结束
		printf("文件不存在，结束");
		exit(0);
	}
	else
	{
		for (i = 2; i <= 30000; ++i)
		{
			int q = sqrt(i);
			temp = 0;
			for (int j = 2; j <= q; j++)
			{
				if (i % j == 0)
				{
					temp = 1;
					break;
				}
			}
			if (temp == 0)
			{
				fprintf(fp, "%d,", i); //将结果输出到文件中
									   //  printf("%d ",i);//将结果输出到控制台
			}
		}
	}

	printf("已输出到文件 ZeroCurve.txt，结束！\n");
	return 0;
}
