#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#define PORT 8888
#define RT_ERR (-1)
#define RT_OK 0
#define SERVERIP "192.168.0.200"
#define LISTEN_QUEUE 10
#define BUFFER_SIZE 1024

int main(int argc, char *argv[]) {
    int listenfd, connsockfd, fd;
    char readbuf[BUFFER_SIZE];
    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    if (listenfd < 0) {
        fprintf(stderr, "socket function failed.\n");
        exit(RT_ERR);
    }

    struct sockaddr_in serveraddr, clientaddr;
    bzero(&serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_port = htons(PORT);
    serveraddr.sin_addr.s_addr = inet_addr(SERVERIP);

    unsigned int client_len = sizeof(struct sockaddr_in);
    if (bind(listenfd, (struct sockaddr *)&serveraddr, sizeof(struct sockaddr_in)) < 0) {
        fprintf(stderr, "bind function failed.\n");
        close(listenfd);
        exit(RT_ERR);
    }

    if (listen(listenfd, LISTEN_QUEUE) < 0) {
        fprintf(stderr, "listen function failed.\n");
        close(listenfd);
        exit(RT_ERR);
    }
    fprintf(stdout, "The server IP is %s, listen on port: %d\n", inet_ntoa(serveraddr.sin_addr), ntohs(serveraddr.sin_port));

    fd_set readfdset, writefdset, currentset;
    FD_ZERO(&readfdset);
    FD_SET(listenfd, &readfdset);
    while (1) {
        currentset = readfdset;
        bzero(readbuf, sizeof(readbuf));
        if (!(select(FD_SETSIZE, &currentset, NULL, NULL, NULL) > 0)) {
            fprintf(stderr, "select function failed.\n");
            close(listenfd);
            exit(RT_ERR);
        }
        for (fd = 0; fd < FD_SETSIZE; fd++) {
            if (FD_ISSET(fd, &currentset)) {
                fprintf(stdout, "fd is %d, listenfd is %d\n", fd, listenfd);
                if (fd == listenfd) {
                    if ((connsockfd = accept(listenfd, (struct sockaddr *)&clientaddr, &client_len)) < 0) {
                        fprintf(stderr, "accept function failed.\n");
                        exit(RT_ERR);
                    }
                    FD_SET(connsockfd, &readfdset);
                    fprintf(stdout, "It is a new session from IP:%s port:%d\n", inet_ntoa(clientaddr.sin_addr), ntohs(clientaddr.sin_port));
                } else {
                    if (recv(fd, readbuf, BUFFER_SIZE, 0) > 0) {
                        fprintf(stdout, "recv message: %s\n", readbuf);
                    } else {
                        close(fd);
                        FD_CLR(fd, &readfdset);
                        fprintf(stdout, "client socket %d close\n", fd);
                    }
                }
            }
        }
    }
    close(listenfd);
    return 0;
}