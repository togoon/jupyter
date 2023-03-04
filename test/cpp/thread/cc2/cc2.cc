#include "cc2.h"

using namespace std;

struct foo {
    int a, b, c, d;
};

struct foo foo = {1, 2, 3, 4};

void printfoo(const char *s, const foo *fp) {
    printf("s is %s\n", s);
    printf("structure at 0x%x \n", (unsigned)fp);
    printf("foo.a=%d \n", fp->a);
    printf("foo.b=%d \n", fp->b);
    printf("foo.c=%d \n", fp->c);
    printf("foo.d=%d \n", fp->d);
}

void *thr_fn1(void *arg) {
    // struct foo foo = {1, 2, 3, 4};
    printfoo("thread 1:ID is %d", &foo);
    pthread_exit((void *)&foo);
}

void *thr_fn2(void *arg) {
    printfoo("thread 2:ID is %lu \n", pthread_self());
    pthread_exit((void *)0);
}

int main(void) {
    int err;
    pthread_t tid1, tid2;
    struct foo *fp;
    err = pthread_create(&tid1, NULL, thr_fn1, NULL);
    if (err != 0) {
        printf("create thread 1 is failed \n", strerror(err));
        exit(1);
    }
    err = pthread_join(tid1, (void **)&fp);
    if (err != 0)
        printf("can't join thread1 \n");
    sleep(1);

    err = pthread_create(&tid2, NULL, thr_fn2, NULL);
    if (err != 0) {
        printf("create thread 2 is failed \n");
        exit(1);
    }
    sleep(1);
    printfoo("parent: \n", fp);
    exit(0);
}
