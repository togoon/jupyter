
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/epoll.h>
#include <arpa/inet.h>
#include <errno.h>
#include <string>
#include <mutex>

#include <time.h>
#include <thread>
#include <chrono>
#include <ctype.h>

#include <string.h>
#include <iomanip>
#include <cstdio>
#include <cstdarg>
#include <iostream>

#include <stdlib.h>
#include <unistd.h>

using namespace std;

int connect()
{
    int ret = 0;

    int port = 8888;
    int time_out = 30;

    extern int nErrno;
    struct sockaddr_in serveraddr;
    memset(&serveraddr, 0x00, sizeof(serveraddr));
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons(port);

    int reuse0 = 1;
    struct timeval timeout = { 60,0 };
    int serverfd = socket(AF_INET, SOCK_STREAM, 0);
    setsockopt(serverfd, SOL_SOCKET, SO_REUSEADDR, (char*)&reuse0, sizeof(reuse0));
    setsockopt(serverfd, SOL_SOCKET, SO_SNDTIMEO, (const char*)&timeout, sizeof(timeout));
    setsockopt(serverfd, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout, sizeof(timeout));

    if (0 != bind(serverfd, (sockaddr*)&serveraddr, sizeof(serveraddr)))
    {
        ret = -1;
        return ret;
    }

    listen(serverfd, 1024);

    ////////////////////

    struct sockaddr_in clientaddr;
    socklen_t clientlen;
    int clientfd = accept(serverfd, (sockaddr*)&clientaddr, &clientlen);
    if (clientfd < 0)
    {
        //continue;
    }
    char* client_ip = inet_ntoa(clientaddr.sin_addr);

    ////////////////////

    string request, response;
    struct timespec startTime, endTime;
    clock_gettime(CLOCK_MONOTONIC, &startTime);
    char szBuff[512] = { 0 };
    int nLen = 0;
    int msgLen = 0;

    if (recv(clientfd, szBuff, 6, 0))   //xml length 6
    {
        close(clientfd);
        ret = -1;
    }

    if (strcmp(szBuff, "STOP") == 0)
    {
        close(clientfd);
        ret = -1;
        return ret;
    }

    if (strlen(szBuff) == 0)
    {
        close(clientfd);
        ret = -1;
        return ret;
    }

    msgLen = atoi(szBuff);
    if (msgLen <= 0)
    {
        while ((nLen = recv(clientfd, szBuff, sizeof(szBuff) - 1, MSG_DONTWAIT)) > 0)
        {
            request += szBuff;
        }
        response = "Message Format Error: message length is mandatory.";
    }
    else
    {
        memset(szBuff, 0x00, sizeof(szBuff));
        while ((nLen = recv(clientfd, szBuff, sizeof(szBuff) - 1, 0)) >= 0)
        {
            request += szBuff;
            memset(szBuff, 0x00, sizeof(szBuff));
            if (request.length() >= msgLen)  //+6
                break;
        }

        if (request.length() != msgLen)
        {
            char szTemp[128] = { 0 };
            sprintf(szTemp, "Message Length Error, [%d]-[%d]", msgLen, (int)request.length());
            response = szTemp;
        }
        else
        {
            // hangleMessage(requeset, response);
        }
    }

    char szLenBuff[7] = { 0 };
    sprintf(szLenBuff, "%06d", (int)response.length());
    response.insert(0, szLenBuff);

    nLen = send(clientfd, response.c_str(), response.length(), MSG_DONTWAIT);
    clock_gettime(CLOCK_MONOTONIC, &endTime);
    double costTime = (double)((endTime.tv_sec - startTime.tv_sec) + (endTime.tv_nsec - startTime.tv_nsec) / 10e9);

    if (nLen < 0)
    {
        close(clientfd);
        ret = -1;
        return ret;
    }

    if (recv(clientfd, szBuff, sizeof(szBuff) - 1, 0) <= 0)
        close(clientfd);


    return ret;
}

int main(int argc, char* arg[])
{
    int ret = 0;




    return ret;
}
