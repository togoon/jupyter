#include <iostream>
#include <string>
#include <cmath>

using namespace std;

int main()
{
    cout << endl << "e.g. 1: hello" << endl;
    cout << "Hello C++ World" << endl ;

    int number1;
    cout << endl << "e.g. 2: cin" << endl;
    cout << "please input int: " << endl;
    // cin >> number1;
    // cout << "number is " << number1 << endl;

    int number2 ,number3, number4;
    cout << endl << "e.g. 3: +" << endl;
    cout << "please input 2 int: " << endl;
    // cin >> number2 >> number3 ;
    // number4 = number2 + number3;
    // cout << number2  << "+" << number3 << "=" << number4 << endl;

    int myInt = 5;
    float myFloat = 4.99;
    double myDouble = 5.01;
    char myChar = 'E';
    bool myBool = true;
    string myString = "Hello";
    cout << endl << "e.g. 4: var 变量" << endl;
    cout << "int:" << myInt << '\n';
    cout << "float: " << myFloat << endl;
    cout << "double: " << myDouble << endl;
    cout << "char: " << myChar << endl;
    cout << "bool: " << myBool << endl;
    cout << "string: " << myString << endl;

    int divisor, dividend, quotient, remainder;
    cout << endl << "e.g. 5: 求商及余数" << endl;

    dividend = 13;
    divisor = 5;
    quotient = dividend / divisor;
    remainder = dividend % divisor;
    cout << "被除数 = " << dividend << ", 除数 = " << divisor << endl;
    cout << "商 = " << quotient << ", 余数 = " << remainder << endl;

    cout << endl << "e.g. 6: sizeof 查看变量占用空间大小" << endl;
    cout << "char: " << sizeof(char) << "字节" << endl;
    cout << "int: " << sizeof(int) << "字节" << endl;
    cout << "float: " << sizeof(float) << "字节" << endl;
    cout << "double: " << sizeof(double) << "字节" << endl;


    cout << endl << "e.g. 7: 交换两个变量" << endl;
    int a7 = 5, b7 = 10, temp7;
    cout << "交换前: "<< "a7 = " << a7 << ", b7 = " << b7 << endl;
    temp7 = a7;
    a7 = b7;
    b7 = temp7;
    cout << "交换后: "<< "a7 = " << a7 << ", b7 = " << b7 << endl; 

    int a6 = 5, b6 = 10;
    cout << "交换前: "<< "a6 = " << a6 << ", b6 = " << b6 << endl;
    a6 = a6 + b6;
    b6 = a6 - b6;
    a6 = a6 - b6;
    cout << "交换后: " << "a6 = " << a6 << ", b6 = " << b6 << endl;

    int a5 = 5, b5 = 10;
    cout << "交换前: "<< "a5 = " << a5 << ", b5 = " << b5 << endl;
    a5, b5 = b5 , a5;
    cout << "交换后 error : a5, b5 = b5 , a5; " << "a5 = " << a5 << ", b5 = " << b5 << endl;

    int n9 = 9;
    cout << endl << "e.g. 9: 判断:奇数? 偶数?" << endl;
    if(n9 % 2 == 0)
        cout << n9 << " 为偶数" << endl;
    else
        cout << n9 << " 为奇数" << endl;

    int n8 = 8;
    (n8 % 2 == 0) ? cout << n8 << " 为偶数" << endl : cout << n8 << " 为奇数" << endl;

    char c10 = 'U';
    bool isChar;
    int isLowercaseVowel, isUppercaseVowel;
    isChar = ((c10 >= 'a' && c10 <= 'z') || (c10 >= 'A' && c10 <= 'Z'));
    cout << endl << "e.g. 10: 判断元音Vowel/辅音Consonant" << endl;

    if(isChar)
    {
        isLowercaseVowel = (c10 == 'a' || c10 == 'e' || c10 == 'i' || c10 == 'o' || c10 == 'u');
        isUppercaseVowel = (c10 == 'A' || c10 == 'E' || c10 == 'I' || c10 == 'O' || c10 == 'U');

        if(isLowercaseVowel || isUppercaseVowel )
            cout << c10 << " 是元音" << endl;
        else
            cout << c10 << " 是辅音" << endl;   
    }
    else 
    {
        cout << c10 << "不是字母" << endl; 
    }

    float f11 = -11.11, f10 = 10.01, f9 = 9.99;
    cout << endl<< "e.g. 11: 判断元音Vowel/辅音Consonant" << endl;
    cout <<  "当前3个数: " << f11 <<  ", " << f10 <<  ", " << f9 << endl;
    if(f11 >= f10)
    {
        if(f11 >= f9)
            cout << "最大数为: " << f11 << endl;
        else 
            cout << "最大数为: " << f9 << endl;
    }
    else
    {
        if(f10 >= f9)
            cout << "最大数为: " << f10 << endl;
        else 
            cout << "最大数为: " << f9 << endl;
    }

    cout << endl << "e.g. 13:  求一元二次方程的根 ax^2+bx+c=0 " << endl;
    float a13=4, b13=5, c13=1, x13, x12, discriminant, realPart, imaginaryPart;
    discriminant = b13 * b13 - 4 * a13 * c13;

    if(discriminant > 0)
    {
        x13 = (-b13 + sqrt(discriminant)) / (2 * a13);
        x12 = (-b13 - sqrt(discriminant)) / (2 * a13);
        cout << "Roots are real and different." << endl;
        cout << "x13 = " << x13 << endl;
        cout << "x12 = " << x12 << endl;        
    }
    else if (discriminant == 0)
    {
        x13 = (-b13 + sqrt(discriminant)) / (2 * a13);
        cout << "实根相同: " << endl;
        cout << "x13 = x12 = " << x13 << endl;        
    }
    else
    {
        realPart = -b13/(2*a13);
        imaginaryPart =sqrt(-discriminant)/(2*a13);
        cout << "实根不同："  << endl;
        cout << "x13 = " << realPart << "+" << imaginaryPart << "i" << endl;
        cout << "x12 = " << realPart << "-" << imaginaryPart << "i" << endl;
    }

    cout << endl << "e.g. 14: 自然数之和 " << endl;
    int n14=10, sum14 = 0;
    for (int i = 1; i <= n14; ++i) {
        sum14 += i;
    }
    cout << "Sum = " << sum14  << endl;

    cout << endl << "e.g. 15: 判断闰年 " << endl;
    int year15 = 2024;
    if (year15 % 4 == 0)
    {
        if (year15 % 100 == 0)
        {
            if (year15 % 400 == 0)
                cout << year15 << " 是闰年" << endl;
            else
                cout << year15 << " 不是闰年" << endl;
        }
        else
            cout << year15 << " 是闰年" << endl;
    }
    else
        cout << year15 << " 不是闰年" << endl;


    cout << endl << "e.g. 16: 阶乘 " << endl;
    unsigned int n16 = 15;
    unsigned long long factorial16 = 1;
    for (int i = 1; i < n16;++i)
    {
        factorial16 *= i;
    }
    cout << n16 << " 的阶乘为: " << factorial16 << endl;

    cout << endl << "e.g. 17: 三角形* " << endl;
    int rows17 = 10, space17 ;
    for (int i = 1; i <= rows17; ++i)
    {
        for (int j = 1; j <= i; ++j)
        {
            cout << "* ";
        }
        cout << endl;
    }
    cout << endl;

    for (int i = rows17; i>= 1; --i)
    {
        for (int j = 1; j <= i; ++j)
        {
            cout << "* ";
        }
        cout << endl;
    }
    cout << endl;

    for(int i = 1, k = 0; i <= rows17; ++i, k = 0)
    {
        for(space17 = 1; space17 <= rows17-i; ++space17)
        {
            cout <<"  ";
        }

        while(k != 2*i-1)
        {
            cout << "* ";
            ++k;
        }
        cout << endl;
    }  
    cout << endl;

    for(int i = rows17; i >= 1; --i)
    {
        for(int space17 = 0; space17 < rows17-i; ++space17)
            cout << "  ";
        for(int j = i; j <= 2*i-1; ++j)
            cout << "* ";
        for(int j = 0; j < i-1; ++j)
            cout << "* ";
        cout << endl;
    }


    cout << endl << "e.g. 18: 两数最大公约数 " << endl;
    int n18 = 60 , n17 = 24, hcf;
    cout << "n18 = " << n18 << ", n17 = " << n17 << endl;
    while(n18 != n17)
    {
        if(n18 > n17)
            n18 -= n17;
        else
            n17 -= n18;

        cout << "n18 = " << n18 << ", n17 = " << n17 << endl;
    }
    cout << "HCF = " << n18 << endl;

    for (int i = 1; i <= n18; ++i)
    {
        if(n18 % i == 0 && n17 % i == 0)
            hcf = i;
    }
    cout << "hcf = " << hcf << endl;


    cout << endl << "e.g. 19: 两数最小公倍数 " << endl;
    int n20 = 35, n19 = 15;
    cout << "n20 = " << n20 << ", n19 = " << n19 << endl;

    int max = (n20 > n19) ? n20 : n19;

    do
    {
        if (max % n20 == 0 && max % n19 == 0)
        {
            cout << "LCM = " << max << endl;
            break;
        }
        else
            ++max;
    } while (true);

    hcf = n20;
    max = n19;

    while(hcf != max)
    {
        if(hcf > max)
            hcf -= max;
        else
            max -= hcf;
    }
    int lcm = (n20 * n19) / hcf;
    cout << "LCM = " << lcm << endl;

    cout << endl << "e.g. 20: 猴子吃桃: 每日半另1, 10日余1 " << endl;
    int x, y, n;

    for (x=1, n=0; n<10; y=(x+1)*2, x=y, n++)
        cout << "第"<< 10-n << "天共摘的桃子数量为: " << x << endl;

    return 0;

}
