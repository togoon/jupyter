#include <bits/stdc++.h>

using namespace std;

int main(int argc, char const* argv[])
{
    cout << "<bits/stdc++.h> :" << __cplusplus << endl;

    const char* str = "names";


    cout << "sizeof(str): " << sizeof(str) << endl;
    cout << "strlen(\"" << str << "\"): " << strlen(str) << endl;

    char strArr[18]; //= { 0 }
    memset(strArr, 0x00, sizeof(strArr));
    cout << "sizeof(strArr): " << sizeof(strArr) << " :--" << strArr << "--" << endl;

    int* p1 = nullptr;
    cout << "--" << *p1 << "--" << p1 << "--" << endl;

    return 0;
}