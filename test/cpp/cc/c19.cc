#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

string BothTrim(const string &src, const string &toTrim)
{

    if (src == "" || src.find(toTrim) == string::npos)
    {
        return string(src);
    }

    size_t from = src.find_first_not_of(toTrim);
    if (from == string::npos)
    {
        return "";
    }

    size_t to = src.find_last_not_of(toTrim);

    return src.substr(from, to - from + 1);
}

int main()
{
    string a = "\'abcdwerfafd1231\'";
    string b = "\"\'";

    cout << "a: " << a << " b: " << b << endl;

    string c = BothTrim(a, b);

    cout << "c: " << c << endl;

    return 0;
}
