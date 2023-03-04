


#include <iostream>
// #include <sstream>

#include <fstream>

#include <string>
#include <string.h>

#include <errno.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


// #include <stringhelper.h>

using namespace std;

int HandleConnect(const string& message, string& response);

int main(int argc, char* argv[])
{
    int ret = 0;
    cout << "------connect-----------" << endl;

    return ret;
}


int HandleConnect(const string& message, string& response)
{
    int ret = 0;

    char* envVar = getenv("CONFIG");
    if (!envVar)
    {
        ret = -1;
        return ret;
    }

    string Conf(envVar);

    ifstream confFile;
    confFile.open(Conf.c_str(), ios::in | ios::binary);
    if (!confFile.is_open())
    {
        ret = -1;
        return ret;
    }

    string s, ip, hostName;
    int port, custTimeOut;
    custTimeOut = 28;

    while (getline(confFile, s))
    {
        if (s.find("CustHostName") != string::npos)
        {
            hostName = s.substr(s.find("=") + 1);
            hostName.erase(0, hostName.find_first_not_of(" "));
            hostName.erase(hostName.find_last_not_of(" ") + 1);
        }

        if (s.find("CustHostPort") != string::npos)
        {
            s = s.substr(s.find("=") + 1);
            s.erase(0, s.find_first_not_of(" "));
            s.erase(s.find_last_not_of(" ") + 1);
            port = atoi(s.c_str());
        }

        if (s.find("CustTimeOut") != string::npos)
        {
            s = s.substr(s.find("=") + 1);
            s.erase(0, s.find_first_not_of(" "));
            s.erase(s.find_last_not_of(" ") + 1);
            custTimeOut = atoi(s.c_str());
        }
    }

    confFile.close();

    if (hostName.empty())
    {
        ret = -1;
        return ret;
    }

    struct hostent* hptr = gethostbyname(hostName.c_str());

    if (hptr == NULL || hptr->h_addr == NULL)
    {
        char msg[200];
        memset(msg, 0, sizeof(msg));
        sprintf(msg, "Unknow HostName: %s", hostName.c_str());

        ret = -1;
        return ret;
    }

    ip = inet_ntoa(*(struct in_addr*)hptr->h_addr_list[0]);

    if (ip.empty())
    {
        char msg[200];
        memset(msg, 0, sizeof(msg));
        sprintf(msg, "IP Empty HostName: %s", hostName.c_str());

        ret = -1;
        return ret;
    }

    int socketfd;
    if ((socketfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        ret = -1;
        return ret;
    }

    struct sockaddr_in servAddr;
    memset(&servAddr, 0, sizeof(servAddr));
    servAddr.sin_family = AF_INET;
    servAddr.sin_port = htons(port);

    if (inet_pton(AF_INET, ip.c_str(), &servAddr.sin_addr) <= 0)
    {
        ret = -1;
        return ret;
    }

    if (connect(socketfd, (struct sockaddr*)&servAddr, sizeof(servAddr)) < 0)
    {
        close(socketfd);
        ret = -1;
        return ret;
    }

    struct timeval timeOut = { custTimeOut, 0 }; //28
    if (setsockopt(socketfd, SOL_SOCKET, SO_SNDTIMEO, &timeOut, sizeof(timeOut)) == -1 || setsockopt(socketfd, SOL_SOCKET, SO_RCVTIMEO, &timeOut, sizeof(timeOut)) == -1)
    {
        close(socketfd);
        ret = -1;
        return ret;
    }

    if (send(socketfd, message.c_str(), message.size(), 0) < 0)
    {
        close(socketfd);
        ret = -1;
        return ret;
    }

    char revBuffer[1024 * 10];
    memset(revBuffer, 0x00, sizeof(revBuffer));
    int revLen = recv(socketfd, revBuffer, sizeof(revBuffer), 0);
    if (revLen < 0)
    {
        close(socketfd);
        ret = -1;
        return ret;
    }

    close(socketfd);

    response.clear();
    response.append(revBuffer);

    return ret;
}


