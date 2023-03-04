#include <cstdarg>
#include <iostream>

using namespace std;

int sumStr(int V, ...)
{
    return 0;
}

int sumInt(int V, ...)
{
    int RV = 0;
    int i = V;
    int step;
    va_list ap;
    va_start(ap, V);

    // while (i > 0)
    // {
    //     RV += va_arg(ap, int);
    //     i--;
    // }

    // vsprintf(V);

    while (0 != (step = va_arg(ap, int)))
    {
        RV += step;
    }

    return RV;

}

int main()
{
    int r1 = sumInt(2, 1, 2, 3, 0);
    cout << r1 << endl;

    // int r2 = sumInt(2, '1', '2', '3', '4');

    // cout << r2 << endl;
}




