
#include <ctime>
// #include <cstdio>
#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>

#include <sys/time.h>
#include <time.h>

int main()
{
    time_t nowtime;
    struct tm* p;
    time(&nowtime);
    p = localtime(&nowtime);
    // printf("%04d-%02d-%02d %02d:%02d:%02d\n",p->tm_year+1900,p->tm_mon+1,p->tm_mday,p->tm_hour,p->tm_min,p->tm_sec);

    char cuTime[20] = { 0 };
    snprintf(cuTime, sizeof(cuTime), "%04d-%02d-%02d %02d:%02d:%02d", p->tm_year + 1900, p->tm_mon + 1, p->tm_mday, p->tm_hour, p->tm_min, p->tm_sec);
    printf("%s\n", cuTime);

    /////////////////////////////////////////

    struct timeval curTime;
    gettimeofday(&curTime, NULL);

    struct tm nowTime;
    localtime_r(&curTime.tv_sec, &nowTime);
    char buffer[80] = { 0 };
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", &nowTime);

    char currentTime[84] = { 0 };
    snprintf(currentTime, sizeof(currentTime), "%s.%03d", buffer, (int)curTime.tv_usec / 1000);

    printf("%s\n", currentTime);

    return 0;
}