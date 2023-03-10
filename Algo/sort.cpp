#include <iostream>

using namespace std;


//直接插入排序
template <class T>
void InsertionSort(T Data[],int n)
{
    int p,i;
    for(p=1;p<n;p++)
    {
        T temp=Data[p];
        i=p-1;
        while(i>=0&&Data[i]>temp)
        {
            Data[i+1]=Data[i];
            i--;
        }
        Data[i+1]=temp;
    }
}



//折半插入排序
template <class T>
void BinaryInsertionSort(T Data[],int n)
{
    int left,mid,right,p;
    for(p=1;p<n;p++)
    {
        T temp=Data[p];
        left =0;
        right=n-1;
        while(left<=right)
        {
            mid=(left+right)/2;
            if(Data[mid]>temp)
                right=mid-1;
            else
                left=mid+1;
        }
        for(int i=p-1;i>=left;i--)
            Data[i+1]=Data[i];
        Data[left]=temp;
    }
}



//希尔排序
template <class T>
void ShellSort(T Data[],int n)
{
    int d=n/2;
    while(d>=1)
    {
        for(int k=0;k<d;k++)
        {
            for(int i=k+d;i<n;i+=d)
            {
                T temp=Data[i];
                int j=i-d;
                while(j>=k&&Data[j]>temp)
                {
                    Data[j+d]=Data[j];
                    j-=d;
                }
                Data[j+d]=temp;
            }
        }
        d=d/2;
    }
}



//冒泡排序
template <class T>
void BubbleSort(T data[],int n)
{
    int flag=0;
    for(int i=0;i<n;i++)
    {
        flag=0;
        for(int j=1;j<n-i;j++)
        {
            if(data[j]<data[j-1])
            {
                flag=1;
                T t=data[j];
                data[j]=data[j-1];
                data[j-1]=t;
            }
        }
        if(flag==0)
            return;
    }
}



//快速排序
template <class T>
int Partition(T data[],int left,int right)
{
    T pivot=data[left];
    while(left<right)
    {
        while(left<right&&data[right]>pivot)
            right--;
        data[left]=data[right];
        while(left<right&&data[right]<=pivot)
            left++;
        data[right]=data[left];
    }
    data[left]=pivot;
    return left;
}

template <class T>
void QuickSort(T data[],int left,int right)
{
    if(left<right)
    {
        int p=Partition(data,left,right);
        QuickSort(data,left,p-1);
        QuickSort(data,p+1,right);
    }

}



//选择排序
template <class T>
void SelectionSort(T data[],int n)
{
    for(int i=1;i<n;i++)
    {
        int k=i-1;
        for(int j=i;j<n;j++)
        {
            if(data[j]<data[k])
            {
                k=j;
            }
        }
        if(k!=i-1)
        {
            T t=data[k];
            data[k]=data[i-1];
            data[i-1]=t;
        }
    }
}




/*
template <class T>
void SiftDown(T data[],int i,int n)
{
    int l=2*i+1;
    int r=2*i+2;
    int min=i;
    if(l<n&&data[min]<data[l])
        min=l;
    if(r<n&&data[min]<data[r])
        min=r;
    if(min!=i)
    {
        T t=data[min];
        data[min]=data[i];
        data[i]=t;
        SiftDown(data,min,n);
    }
}

template <class T>
void BuildHeap(T data[],int n)
{
    int p=n/2-1;
    for(int i=p;i>=0;i--)
    {
        SiftDown(data,i,n);
    }
}

template <class T>
void HeapSort(T data[],int n)
{
    BuildHeap(data,n);
    for(int i=n-1;i>0;i--)
    {
        T t =data[0];
        data[0]=data[i];
        data[i]=t;
        SiftDown(data,0,i);
    }
}
*/



//堆排序
template <class T>
void SiftDown(int left, int n, T Data[])
{
	int i = left;
	int j = 2*i + 1;
	T temp = Data[i];
	while(j < n)
    {
		if((j < n - 1)&&(Data[j] < Data[j+1])) j++;
		if(temp < Data[j])
		{
			Data[i] = Data[j];
			i = j;
			j = 2*j + 1;
		}
		else break;
	}
	Data[i] = temp;
}

template <class T>
void BuildHeap(int n, T Data[])
{
	for (int i = n/2-1; i >= 0; i--)
		SiftDown(i, n, Data);
}

template <class T>
void Remove(T Data[], int n)
{
	SiftDown(0, n, Data);
}

template <class T>
void HeapSort(T Data[], int n)
{
	BuildHeap(n, Data);
	for(int i = n-1; i > 0; i--)
    {
		T t = Data[0];
		Data[0] = Data[i];
		Data[i] = t;
		Remove(Data, i);
	}
}




//归并排序
template <class T>
void Merge(T data[],int start,int mid,int end)
{
    int len1=mid-start+1;
    int len2=end-mid;
    int i,j,k;
    T* left=new T[len1];
    T* right=new T[len2];
    for(i=0;i<len1;i++)
    {
        left[i]=data[i+mid+1];
    }
    for(i=0;i<len2;i++)
    {
        right[i]=data[i+mid+1];
    }
    i=0,j=0;
    for(k=start;k<end;k++)
    {
        if(i==len1||j==len2)
            break;
        if(left[i]<=right[j])
            data[k]=left[i++];
        else
            data[k]=right[j++];
    }
    while(i<len1)
    {
        data[k++]=left[i++];
    }
    while(j<len2)
    {
        data[k++]=left[j++];
    }
    delete[] left;
    delete[] right;
}

template <class T>
void MergeSort(T data[],int start,int end)
{
    if(start<end)
    {
        int mid=(start+end)/2;
        MergeSort(data,start,mid);
        MergeSort(data,mid+1,end);
        Merge(data,start,mid,end);
    }
}


//基数排序
const int RADIX=10;
template <class T>
struct LinkNode
{
    T data;
    LinkNode* next;
};

template <class T>
struct TubNode
{
    LinkNode<T>* rear;
    LinkNode<T>* front;
};

template <class T>
TubNode <T>* Distribute(T data[],int n,int ith)
{
    TubNode<T>* tube = new TubNode<T>[RADIX];
    memset(tube,0,sizeof(TubNode<T>)*RADIX);
    LinkNode<T>* t;
    for(int i=0;i<n;i++)
    {
        T v=data[i];
        int j=ith-1;
        while(j--)
            v=v/RADIX;-
        v=v%RADIX;
        t=new LinkNode<T>;
        t->data=data[i];
        t->next=NULL;
        if(tube[v].front)
        {
            tube[v].rear->next=t;
            tube[v].rear=t;
        }
        else
        {
            tube[v].front=tube[v].rear=t;
        }
    }
    return tube;
}

template <class T>
void Collect(T data[],TubNode<T>*tube)
{
    LinkNode<T>*t,*p;
    int index=0;
    for(int i=0;i<RADIX;i++)
    {
        p=t=tube[i].front;
        while(t)
        {
            data[index++]=t->data;
            t=t->next;
            delete p;
            p=t;
        }
    }
    delete[] tube;
}

template <class T>
void RadixSort(T data[],int n,int keys)
{
    TubNode<T>* tube;
    for(int i=0;i<keys;i++)
    {
        tube=Distribute<T>(data,n,i+1);
        Collect<T>(data,tube);
    }
}



//计数排序
template <class T>
void CountingSort(T in_data[], T out_data[], int length,int k)
{
    T *temp = new T[k];
    for (int i = 0; i < k; i++)
    {
        temp[i] = 0;
    }
    for (int i = 0; i < length; i++)
    {
        temp[in_data[i]] += 1;
    }
    for (int i = 1; i < k; i++)
    {
        temp[i] = temp[i] + temp[i - 1];
    }
    for (int i = length - 1; i >= 0; i--)
    {
         out_data[temp[in_data[i]]-1] = in_data[i];
         temp[in_data[i]] -= 1;
    }
    delete[]temp;
}



//桶排序
template <class T>
void Bucket_sort(T data[], int n, int max)
{
    T *buckets;
    if (data==NULL || n<1 || max<1)
    {    
        return;
    }    
    if ((buckets=(T *)malloc(max*sizeof(T)))==NULL)
    {
        return;
    }
    memset(buckets, 0, max*sizeof(T));
    for (int i = 0; i < n; i++)
    { 
        buckets[data[i]]++; 
    }
    for (int i = 0, j = 0; i < max; i++) 
    {    
        while( (buckets[i]--) >0 )
        {    
            data[j++] = i;
        }
    }
    free(buckets);
}



int main()
{
    int a[10]={12,23,34,43,21,11,12,2,3,1};
    int b[10]={1,27,34,43,61,74,92,102,16,135};
    int c[10]={121,103,74,53,21,20,12,6,1};
    int n=10;
    HeapSort(a,n);
    for(int i=0;i<n;i++)
    {
        cout<<a[i]<<' ';
    }
    cout<<endl;
    //MergeSort(b,0,9);
    for(int i=0;i<n;i++)
    {
        cout<<b[i]<<' ';
    }
    cout<<endl;
    //RadixSort(c,9,3);
    for(int i=0;i<9;i++)
    {
        cout<<c[i]<<' ';
    }
    cout<<endl;
    return 0;
}
