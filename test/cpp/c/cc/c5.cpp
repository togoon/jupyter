#include <iostream>
using namespace std;
int main()
{

    system("chcp 65001");
    cout << "你好1世界!" << endl;

    setlocale(LC_ALL, "");  // 宽字节输出中文
    wcout << L"你好2世界!" << endl;

    return 0;
}