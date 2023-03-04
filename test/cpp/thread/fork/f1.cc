
#include "f1.h"

int main() {
    pid_t pid = fork();

    if (pid == -1) {
        printf("fork error\n");
    } else if (pid == 0) {
        printf("我是子进程, 我的进程ID是 %d\n", getpid());
        printf("我的父进程ID是 %d\n", getppid());
    } else {
        printf("我是父进程, 我的进程ID是%d\n", getpid());
    }
    sleep(100);
    return 0;
}