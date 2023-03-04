

#include <iomanip>
#include <iostream>
#include <sstream>
#include <stdlib.h>
#include <string>

using namespace std;

int Count(double d) {
    string s;
    stringstream ss;
    ss << setprecision(15) << d;
    // ss >> s;
    s = ss.str(); // 3.14159265358979

    cout << d << " \t s: " << s << endl;

    return s.size() - s.find('.') - 1;
}

int main() {
    double d = 12345.12345678900;


    // double ans = 94.3751;
    cout << fixed << setprecision(2) << d << endl;

    printf("d: %f \n", d);
    
    // char buf[50];
    // gcvt(d, 20, buf);

    // string str = buf;
    // cout << str << endl;

    // cin >> d;
    cout << Count(d) << endl;
    return 0;
}