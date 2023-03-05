
#include<stdio.h>
#include<stdlib.h>

#define MAX_ARRAY_DIM 8
typedef int ElemType;

typedef struct {
    ElemType *base; //存储数据
    int dim;
    int *bounds;    //存储每个维度的大小
    int *constants; //存储映射函数中的c_i
} Array;

int InitArray(Array *A,int dim)
{
//一旦建立数组，数组的维数以及各维的长度就确定下来了
    int i;
    int elemtotal=1;
    if(dim<1||dim>MAX_ARRAY_DIM)
        return -1;
    A->dim=dim;
    A->bounds=(int *)malloc(dim*sizeof(int));
    if(!A->bounds)
        exit(-1);
    for(i=0;i<dim;i++)
    {
        scanf("%d",&((A->bounds)[i]));
        if(A->bounds[i]<0)
            return -1;
        elemtotal*=A->bounds[i];
    }
    A->base=(ElemType *)malloc(elemtotal*sizeof(ElemType));
    if(!A->base)
        exit(-1);
    A->constants=(int *)malloc(dim*sizeof(int));
    if(!A->constants)
        exit(-1);
    (A->constants)[dim-1]=1;
    for (i=dim-2;i>=0;i--)
        A->constants[i]=A->bounds[i+1]*A->constants[i+1];
    return 1;
}

int DestoryArray(Array *A)
{
    if(!A->base)
        return -1;
    free(A->base);
    A->base=NULL;
    if(!A->bounds)
        return -1;
    free(A->bounds);
    A->bounds=NULL;
    if(!A->constants)
        return -1;
    free(A->constants);
    A->constants=NULL;
    return 1;
}

int Value(Array A,ElemType *e)
{
    int i,ind;
    int off=0;
    for(i=0;i<A.dim;i++)
    {
        scanf("%d",&ind);
        if(ind<0||ind>A.bounds[i])
            exit(-1);;
        off+=ind*A.constants[i];
    }
    *e=*(A.base+off);   //off是偏移量
    return 1;
}

int Assign(Array *A,ElemType e)
{
    int i,ind;
    int off=0;
    for(i=0;i<A->dim;i++)
    {
        scanf("%d",&ind);
        if(ind<0||ind>A->bounds[i])
            exit(-1);
        off+=ind*A->constants[i];
    }
    *(A->base+off)=e;  //这里指针相加，编译器会自动乘以指向元素的大小
    return 1;
}

int main()
{
    printf("1111");
    Array A;
    InitArray(&A,3);
    int e=3;
    Assign(&A,e);
    printf("%d",Value(A,&e));

    return 0;
}


