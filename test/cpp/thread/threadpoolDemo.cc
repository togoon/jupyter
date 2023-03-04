#include <iostream>
#include "threadpool.h"

using namespace std;
// using namespace finastra;

int print1()
{
    int ret = 0;

    cout << "1111111" << endl;

    return ret;
}

int print(int n)
{
    int ret = 0;

    cout << "2222222" << endl;

    return ret;
}

class xx
{
public:
    static int print(int ss)
    {
        int ret = 0;

        cout << "ss:" << ss << endl;

        return ret;
    }
};

int main(int argc, char* argv[])
{
    threadpool p(10);
    p.commit(print1);

    std::future<int> f = p.commit(print, 200);

    cout << "s----------" << f.get() << endl;

    xx x;
    p.commit(xx::print, 30);

    return 0;
}

