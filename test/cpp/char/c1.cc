
#include <iostream>
#include <stdio.h>
#include <string>

#include <string.h>
// #include <cstring>

using namespace std;

int main() {

    char a[100] = "abcdefg";

    printf("查找字符 strchr : %s \n", strchr(a, 'f'));
    printf("查找字符 strchr : %ld \n", strchr(a, 'f') - a);

    printf("查找子串 strstr : %s \n", strstr(a, "defg"));
    printf("查找子串 strstr : %s \n", strstr(a, "123"));
    printf("查找子串 strstr : %ld \n", strstr(a, "defg") - a);

    char a1[100] = "ABCD";
    char b[100] = "ABAB";
    char c[100] = "ABcd";
    char d[100] = "ABCD";
    printf("比较 strcmp: %d\n", strcmp(a1, b)); //"ABCD"与"ABAB"比较C比A大，所以返回1
    printf("比较 strcmp: %d\n", strcmp(a1, c)); //"ABCD"与"ABcd"比较C比c小，所以返回-1
    printf("比较 strcmp: %d\n", strcmp(a1, d)); //两者完全相同所以返回0

    printf("长度 strlen: %lu\n", strlen(a1)); //求字符串str的长度，不包括'\0'

    // printf("颠倒字符串 %s\n", strrev(a)); //strrev strsep
    // cout << strrev(a) << endl;

    char e[100] = "1234";
    printf("连接 strcat: %s\n", strcat(a, e)); //将“1234”连接到"abcd"后面

    printf("复制 strcpy: %s\n", strcpy(a, b)); //将"1234"复制到"abcdefghi"中

    // printf("小写 strlwr: %s\n", strlwr(a));
    // printf("大写 strupr: %s\n",strupr(a));

    //strnicmp 函数名中同时出现'n'和'i'：表示对字符串前n个字符，进行忽略大小写的处理

    return 0;
}