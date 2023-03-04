#include <iostream>
#include "timer.hpp"

void func1()
{
    std::cout << "trigger func1" << std::endl;
}

void func2(int x)
{
    std::cout << "trigger func2, x: " << x << std::endl;
}

int main(int argc, char *argv[])
{
    Timer timer;

    // execute task every timer interval
    std::cout << "--- start period timer ----" << std::endl;
    timer.start(1000, std::bind(func2, 3));
    std::this_thread::sleep_for(std::chrono::milliseconds(5000));
    timer.stop();
    std::cout << "--- stop period timer ----" << std::endl;

    // execute task once after delay
    std::cout << "--- start one shot timer ----" << std::endl;
    timer.startOnce(1000, func1);
    std::cout << "--- stop one shot timer ----" << std::endl;

    getchar();
    return 0;
}