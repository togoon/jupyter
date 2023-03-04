#include "cc6.h"
using namespace std;

struct taskdata {
    int x;
    float y;
    string z;
};

void *task1(void *data) {

    cout << "task1 beginning ..." << endl;

    taskdata *t = (taskdata *)data;

    t->x += 25;
    t->y -= 4.5;
    t->z = "Goodbye";

    return (data);
}

void *task2(void *data) {

    cout << "task22 beginning ..." << endl;

    taskdata *t = (taskdata *)data;

    t->x -= 10;
    t->y += 1.5;
    t->z = "World";

    pthread_exit(data);
}

int main(int argc, char *argv[]) {
    pthread_t threadID;
    taskdata t = {10, 10.0, "Hello"};

    void *status;
    cout << "main beginning: before " << t.x << " " << t.y << " " << t.z << endl;

    //by return()
    pthread_create(&threadID, NULL, task1, (void *)&t);
    // pthread_join(threadID, &status);
    // taskdata *ts = (taskdata *)status;
    // cout << "after task1 " << ts->x << " " << ts->y << " " << ts->z << endl;

    //by pthread_exit()
    pthread_create(&threadID, NULL, task2, (void *)&t);
    // pthread_join(threadID, &status);
    // ts = (taskdata *)status;
    // cout << "after task2 " << ts->x << " " << ts->y << " " << ts->z << endl;

    cout << "main end!" << endl;

    pthread_exit(NULL);
}