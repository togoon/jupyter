#include <iostream>
#include "math.h"
using namespace std;



void ThreeDigits() {

	int i, j, k;
	int sum = 0 ;
	for(i=1; i<5; i++) {
		for(j=1; j<5; j++) {
			for(k=1; k<5; k++) {
				if(i!=k&&i!=j&&j!=k) {
					sum++ ;
					printf("%d,%d,%d\n",i,j,k);
				}
			}
		}
	}

	printf("有1,2,3,4个数字,能组成%d组互不相同且无重复数字的三位数\n",sum);
}

void BonusAssign() {
	long int i;
	int bonus1,bonus2,bonus4,bonus6,bonus10,bonus;
	printf("当月利润 : ",bonus);
	scanf("%ld",&i);
	bonus1=100000*0.1;
	bonus2=bonus1+100000*0.75;
	bonus4=bonus2+200000*0.5;
	bonus6=bonus4+200000*0.3;
	bonus10=bonus6+400000*0.15;
	if(i<=100000)  bonus=i*0.1;
	else if(i<=200000)  bonus=bonus1+(i-100000)*0.075;
	else if(i<=400000)  bonus=bonus2+(i-200000)*0.05;
	else if(i<=600000)  bonus=bonus4+(i-400000)*0.03;
	else if(i<=1000000)  bonus=bonus6+(i-600000)*0.015;
	else  bonus=bonus10+(i-1000000)*0.01;

	printf("应发奖金 : %d",bonus);
}

void FullSquare() {
	long int i,x,y,z;
	for (i=1; i<100000; i++) {
		x=sqrt(i+100);   /*x为加上100后开方后的结果*/
		y=sqrt(i+268);   /*y为再加上168后开方后的结果*/
		if(x*x==i+100&&y*y==i+268) /*如果一个数的平方根的平方等于该数,这说明此数是完全平方数*/
			printf("完全平方数 : %ld\n",i);
	}
}

void Days() { 
	int day,month,year,sum,leap; 
	printf("\nplease input year,month,day : \n"); 
	scanf("%d,%d,%d",&year,&month,&day); 
	switch(month) {  /*先计算某月以前月份的总天数*/ 
		case 1:sum=0;    break; 
		case 2:sum=31;   break; 
		case 3:sum=59;   break; 
		case 4:sum=90;   break; 
		case 5:sum=120;  break; 
		case 6:sum=151;  break; 
		case 7:sum=181;  break; 
		case 8:sum=212;  break; 
		case 9:sum=243;  break; 
		case 10:sum=273; break; 
		case 11:sum=304; break; 
		case 12:sum=334; break; 
		default:printf("data error ! "); break; 
	} 
	sum=sum+day;  /*再加上某天的天数*/ 
	if(year%400==0||(year%4==0&&year%100!=0))/*判断是不是闰年*/ 
		leap=1; 
	else 
		leap=0; 
	if(leap==1&&month>2)/*如果是闰年且月份大于2,总天数应该加一天*/ 
		sum++; 
	printf("It is the %dth day.",sum);
} 


void BigNum()  { 
	int x,y,z,t; 
	printf("\nplease input x,y,z : \n"); 	
	scanf("%d%d%d",&x,&y,&z); 
	if (x>y) 
		{t=x;x=y;y=t;} /*交换x,y的值*/ 
	if(x>z) 
		{t=z;z=x;x=t;}/*交换x,z的值*/ 
	if(y>z) 
		{t=y;y=z;z=t;}/*交换z,y的值*/ 
	printf("small to big: %d %d %d\n",x,y,z); 
} 

void ShapeC() { 
	printf("Hello C-world!\n"); 
	printf(" ****\n"); 
	printf(" *\n"); 
	printf(" * \n"); 
	printf(" ****\n"); 
} 

void ShapeA() 
{ 
	char a=176,b=219; 
	printf("%c%c%c%c%c\n",b,a,a,a,b); 
	printf("%c%c%c%c%c\n",a,b,a,b,a); 
	printf("%c%c%c%c%c\n",a,a,b,a,a); 
	printf("%c%c%c%c%c\n",a,b,a,b,a); 
	printf("%c%c%c%c%c\n",b,a,a,a,b);
} 

void MultiFormula() { 
	int i,j,result; 
	printf("\n"); 
	for (i=1;i<10;i++) { 	
		for(j=1;j<10;j++) { 
			result=i*j; 
	 		printf("%d*%d=%-3d",i,j,result);/*-3d表示左对齐,占3位*/ 
		} 
	printf("\n");/*每一行后换行*/ 
	} 
} 

void ChessBoard() { 
	int i,j; 
	for(i=0;i<8;i++)  { 
		for(j=0;j<8;j++) 
			if((i+j)%2==0) 
				printf("%c%c",219,219); 
			else 
				printf(" "); 
			printf("\n"); 
	} 
} 

void SmilingFace() { 
	int i,j; 
	printf("\1\1\n");/*输出两个笑脸*/ 
	for(i=1;i<11;i++) { 
		for(j=1;j<=i;j++) 
			printf("%c%c",219,219); 
		printf("\n"); 
	} 
}  

void Puffina() { 
	long f1,f2; 
	int i; 
	f1=f2=1; 
	for(i=1;i<=20;i++) 	{ 
		printf("%12ld %12ld",f1,f2); 
		if(i%2==0) printf("\n");/*控制输出,每行四个*/ 
		f1=f1+f2; /*前两个月加起来赋值给第三个月*/ 
		f2=f1+f2; /*前两个月加起来赋值给第三个月*/ 
	} 
} 





int main() {
//	ThreeDigits();    //有1,2,3,4个数字,能组成多少个互不相同且无重复数字的三位数?都是多少
//	BonusAssign();    //企业发放的奖金根据利润提成
//	FullSquare();     //一个整数,它加上100后是一个完全平方数,再加上168又是一个完全平方数
//	Days();           //输入某年某月某日,判断这一天是这一年的第几天
//	BigNum();         //输入三个整数x,y,z,请把这三个数由小到大输出
//	ShapeC() ;        //用*号输出字母C的图案
//	ShapeA() ;        //输出特殊图案	
//	MultiFormula() ;   //9*9口诀	
//	ChessBoard() ;     //国际象棋棋盘
//	SmilingFace() ;     //笑脸
	Puffina() ;        //波菲那数列数列1,1,2,3,5,8,13,21	
			
}





