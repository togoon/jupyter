#include "block_queue.h"
#include <iostream>
#include <unistd.h>
using namespace std;

block_queue<int> g_queue(100);
void *p(void *args) {
    sleep(1);
    int data = 0;
    for (int i = 0; i < 100; i++) {
        g_queue.push(data++);
    }
    return NULL;
}

void *c(void *args) {
    while (true) {
        int t = 0;
        if (!g_queue.pop(t, 1000)) {
            cout << "timeout" << endl;
            continue;
        } else {
            cout << t << endl;
        }
        g_queue.pop(t);
        cout << "block=" << t << endl;
    }

    return NULL;
}

int main() {
    pthread_t id;
    pthread_create(&id, NULL, p, NULL);
    //pthread_create(&id, NULL, p, NULL);
    //pthread_create(&id, NULL, c, NULL);
    pthread_create(&id, NULL, c, NULL);
    for (;;)
        sleep(1);
    return 0;
}
