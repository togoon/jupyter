#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <signal.h>
#include <iostream>

using namespace std;

int initDaemon();

int main(int argc, char* argv[])
{
    int ret = 0;

    cout << "----sleep----" << endl;

    sleep(15);

    cout << "----initDaemon----" << endl;

    initDaemon();

    cout << "----return main----" << endl;

    return ret;
}

int initDaemon()
{
    int ret = 0;

    umask(0);
    pid_t pid = fork();

    cout << "----pid----" << pid << endl;

    if (pid < 0)
    {
        ret = -1;
        return ret;
    }
    else if (pid > 0)
    {
        _exit(0);
    }
    setsid();
    signal(SIGCHLD, SIG_IGN);
    if (chdir(".") < 0)
    {
        ret = -1;
        return ret;
    }

    cout << "----signal----" << endl;
    return ret;
}




