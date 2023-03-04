#include "cc5.h"

using namespace std;

#define NUM_THREADS 5

void *PrintHello(void *threadid) {

    int tid = *((int *)threadid);
    cout << "Hello Runoob! 线程 ID, " << tid << endl;
    pthread_exit(NULL);
}

int main() {
    pthread_t threads[NUM_THREADS];
    int indexes[NUM_THREADS]; // 用数组来保存i的值
    int rc;
    int i;
    for (i = 0; i < NUM_THREADS; i++) {
        cout << "main() : 创建线程, " << i << endl;
        indexes[i] = i;
        // 传入的时候必须强制转换为void* 类型，即无类型指针
        rc = pthread_create(&threads[i], NULL, PrintHello, (void *)&(indexes[i]));
        if (rc) {
            cout << "Error:无法创建线程: " << rc << endl;
            exit(-1);
        }
    }
    cout << "main  pthread_exit"
         << "" << endl;
    pthread_exit(NULL);
}