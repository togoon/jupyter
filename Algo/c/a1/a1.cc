#include <stdio.h>
#include <iostream>

#include <ctime>
#include <sys/time.h>
// #include <time.h>

#include <stdio.h>
#include <stdlib.h>

#include <string>
#include <map>
#include <vector>
#include <algorithm>

#include <chrono>

using namespace std;
using std::chrono::high_resolution_clock;
using std::chrono::milliseconds;

const string getTimeStamp();

template<class T, class...Args> T estimate(T(*pf)(Args...), Args...arg);
template<class T> void Swap(T& a, T& b);
bool DESC(int x, int y);

template<typename T> void CoutFor(T a);
template<typename T> void CoutFor(T a[], int len);


//冒泡排序：时间复杂度o(n^2) 
template<class T>
void bubbleSort1(T arr[], int len)
{
    bool swapFlag = false;
    for (int i = len - 1; i > 0; --i)
    {
        for (int j = 0; j < i; ++j)
        {
            if (arr[j] > arr[j + 1])
            {
                Swap(arr[j], arr[j + 1]);
                swapFlag = true;
            }
        }
        if (!swapFlag)
            break;
    }
}

void bubble_sort2(int arr[], int len)
{
    int i, j, temp;
    for (i = 0; i < len - 1; i++)
    {
        for (j = 0; j < len - 1 - i; j++)
        {
            if (arr[j] > arr[j + 1])
            {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

//冒泡排序
template<typename T>
vector<T> bubbleSort3(vector<T> vec) {

    vector<T> result;
    if (vec.empty()) {
        return result;
    }

    int loopCount = 0, swapCount = 0;
    bool swapFlag = false;
    result = vec;
    T temp;
    for (int i = 0; i < result.size() - 1; i++) {
        for (int j = 0; j < result.size() - i - 1; j++) {
            if (result[j + 1] < result[j]) {
                Swap(result[j], result[j + 1]);
                swapCount++;
                swapFlag = true;
            }
            loopCount++;
        }
        if (false == swapFlag)
            break;
    }

    cout << "循环总次数: " << loopCount << ", 交换总次数: " << swapCount << endl;
    return result;
}

//选择排序
template<typename T>
void selectSort1(vector<T>& vec)
{
    for (int i = 0; i < vec.size() - 1; i++)
    {
        int min = i;
        for (int j = i + 1; j < vec.size(); j++)
        {
            if (vec[j] < vec[min])
                min = j;
        }
        if (min != i)
            Swap(vec[i], vec[min]);
    }
}

void select_sort2(int arr[], int len)
{
    for (int i = 0; i < len - 1; i++)
    {
        int min = i;
        for (int j = i + 1; j < len; j++)
        {
            if (arr[j] < arr[min])
                min = j;
        }
        if (min != i)
            Swap(arr[i], arr[min]);
    }
}

//插入排序
void insert_sort1(int arr[], int len)
{

    for (int i = 1; i < len; i++)
    {

        int temp = arr[i];
        int j;

        CoutFor(arr, len);
        cout << "--i :" << i << "--arr[i] :" << arr[i] << "--temp :" << temp << endl;

        for (j = i - 1; j >= 0 && arr[j] > temp; j--)
        {
            arr[j + 1] = arr[j];

            cout << "--i :" << i << "--arr[i] :" << arr[i] << "--j :" << j << "--arr[j + 1] :" << arr[j] << "--" << arr[j + 1] << endl;
        }
        arr[j + 1] = temp;
    }
}

template<typename T>
void insertSort2(T arr[], int len)
{
    for (int i = 1; i < len;i++)
    {
        int key = arr[i];
        int j = i - 1;

        while (j >= 0 && key < arr[j])
        {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;
    }
}

//希尔排序
void shell_sort1(int arr[], int len)
{
    int gap, i, j;
    int temp;

    for (gap = len >> 1; gap > 0; gap >>= 1)
    {
        CoutFor(arr, len);

        for (i = gap; i < len; i++)
        {
            CoutFor(arr, len);
            cout << "--gap:" << gap << "--i:" << i << "--arr[" << i << "]:" << arr[i] << endl;

            temp = arr[i];
            for (j = i - gap; j >= 0 && arr[j] > temp; j -= gap)
            {
                CoutFor(arr, len);
                int jgap = arr[j + gap];
                arr[j + gap] = arr[j];

                cout << "--gap:" << gap << "--i:" << i << "--arr[" << i << "]:" << arr[i] << "--j:" << j << "--j+gap:" << j + gap << "--arr[" << j + gap << "]:" << arr[j] << "-->" << jgap << endl;
            }

            arr[j + gap] = temp;
        }
    }
}

template<typename T>
void shellSort1(T arr[], int len)
{
    int h = 1;
    while (h < len / 3)
        h = h * 3 + 1;
    while (h >= 1)
    {
        for (int i = h; i < len; i++)
        {
            for (int j = i; j >= h && arr[j] < arr[j - h]; j -= h)
                Swap(arr[j], arr[j - h]);
        }
        h = h / 3;
    }
}

//快速排序
typedef struct _Range
{
    int start, end;

} Range;

Range new_Range(int s, int e)
{
    Range r;
    r.start = s;
    r.end = e;
    return r;
}

//快速排序 迭代法
void quick_sort1(int arr[], int len)
{
    if (len <= 0)
        return;

    Range r[len];
    int p = 0;
    r[p++] = new_Range(0, len - 1);

    while (p)
    {
        Range range = r[--p];
        if (range.start >= range.end)
            continue;

        int mid = arr[(range.start + range.end) / 2];
        int left = range.start, right = range.end;

        do
        {
            while (arr[left] < mid) ++left;
            while (arr[right > mid]) --right;

            if (left <= right)
            {
                Swap(arr[left], arr[right]);
                left++;
                right--;
            }

        } while (left <= right);

        if (range.start < right)
            r[p++] = new_Range(range.start, right);

        if (range.end > left)
            r[p++] = new_Range(left, range.end);
    }
}

//快速排序 递归法
template<typename T>
void quickSortRecursive2(T arr[], int start, int end)
{
    if (start >= end)
        return;

    T mid = arr[end];
    int left = start, right = end - 1;

    cout << "--start:" << start << "--end:" << end << "--left:" << left << "--mid:" << mid << "--right:" << right << endl;

    while (left < right)
    {

        CoutFor(arr, end + 1);

        while (arr[left] < mid && left < right)
        {
            cout << "--left:" << left << "--mid:" << mid << "--right:" << right << "--larr[" << left << "]:" << arr[left] << endl;

            left++;
        }

        while (arr[right] >= mid && left < right)
        {
            cout << "--left:" << left << "--mid:" << mid << "--right:" << right << "--rarr[" << right << "]:" << arr[right] << endl;

            right--;
        }

        cout << "==left:" << left << "--mid:" << mid << "--right:" << right << "--l<arr[" << left << "]:" << arr[left] << "--r>arr[" << right << "]:" << arr[right] << endl;

        Swap(arr[left], arr[right]);
    }


    if (arr[left] >= arr[end])
        Swap(arr[left], arr[end]);
    else
        left++;

    cout << "++start:" << start << "--end:" << end << "--left:" << left << "--mid:" << mid << "--right:" << right << "--larr[" << left << "]:" << arr[left] << "--rarr[" << right << "]:" << arr[right] << "--earr[" << end << "]:" << arr[end] << endl;

    CoutFor(arr, end + 1);

    if (left)
    {
        cout << "if(left) quickSortRecursive2(arr," << start << "," << left - 1 << ")" << endl;
        quickSortRecursive2(arr, start, left - 1);
    }

    cout << "} quickSortRecursive2(arr," << left + 1 << "," << end << ")" << endl;
    quickSortRecursive2(arr, left + 1, end);
}

int Paritition1(int arr[], int low, int high)
{
    int pivot = arr[low];
    while (low < high)
    {
        while (low < high && arr[high] >= pivot)
        {
            --high;
        }
        arr[low] = arr[high];
        while (low < high && arr[low] <= pivot)
        {
            ++low;
        }
        arr[high] = arr[low];
    }
    arr[low] = pivot;
    return low;
}

void quickSort3(int arr[], int low, int high)
{
    if (low < high)
    {
        int pivot = Paritition1(arr, low, high);
        quickSort3(arr, low, pivot - 1);
        quickSort3(arr, pivot + 1, high);
    }
}

//堆排序
void max_heapify(int arr[], int start, int end)
{
    int dad = start;
    int son = dad * 2 + 1;

    cout << "--start:" << start << "--end:" << end << "--dad:" << dad << "--son:" << son << endl;

    while (son <= end)
    {
        CoutFor(arr, end);

        if (son + 1 <= end && arr[son] < arr[son + 1])
            son++;

        cout << "--dad:" << dad << "--son:" << son << "--darr[" << dad << "]:" << arr[dad] << "--sarr[" << son << "]:" << arr[son] << endl;

        if (arr[dad] > arr[son])
            return;
        else
        {
            Swap(arr[dad], arr[son]);
            dad = son;
            son = dad * 2 + 1;
        }
    }
}

void heap_sort1(int arr[], int len)
{
    int i;
    for (i = len / 2 - 1; i >= 0; i--)
    {
        CoutFor(arr, len);

        max_heapify(arr, i, len - 1);
    }

    for (i = len - 1; i > 0; i--)
    {
        CoutFor(arr, len);

        Swap(arr[0], arr[i]);
        max_heapify(arr, 0, i - 1);
    }
}

//归并排序 迭代法
void merge_sort1(int arr[], int len)
{
    int* a = arr;
    int* b = (int*)malloc(len * sizeof(int));

    for (int seg = 1; seg < len; seg += seg)
    {
        for (int start = 0; start < len; start += seg + seg)
        {
            int low = start;
            int mid = min(start + seg, len);
            int high = min(start + seg + seg, len);
            int k = low;
            int start1 = low;
            int end1 = mid;
            int start2 = mid;
            int end2 = high;

            while (start1 < end1 and start2 < end2)
            {
                b[k++] = a[start1] < a[start2] ? a[start1++] : a[start2++];
            }

            while (start1 < end1)
            {
                b[k++] = a[start1++];
            }

            while (start2 < end2)
            {
                b[k++] = a[start2++];
            }
        }

        int* temp = a;
        a = b;
        b = temp;
    }
    if (a != arr) {
        for (int i = 0; i < len; i++)
        {
            b[i] = a[i];
        }
    }
    free(b);
}

//归并排序 递归法
void merge_sort_recursive2(int arr[], int reg[], int start, int end)
{
    if (start >= end)
        return;

    int len = end - start, mid = (len >> 1) + start;
    int start1 = start, end1 = mid;
    int start2 = mid + 1, end2 = end;

    merge_sort_recursive2(arr, reg, start1, end1);
    merge_sort_recursive2(arr, reg, start2, end2);

    int k = start;

    while (start1 <= end1 && start2 <= end2)
    {
        reg[k++] = arr[start1] < arr[start2] ? arr[start1++] : arr[start2++];
    }

    while (start1 <= end1)
    {
        reg[k++] = arr[start1++];
    }

    while (start2 <= end2)
    {
        reg[k++] = arr[start2++];
    }

    for (k = start; k <= end; k++)
    {
        arr[k] = reg[k];
    }
}

template<typename T>
void mergeSort2(T arr[], int len)
{
    T* a = arr;
    T* b = new T[len];

    for (int seg = 1; seg < len; seg += seg) {
        for (int start = 0; start < len; start += seg + seg) {
            int low = start, mid = min(start + seg, len), high = min(start + seg + seg, len);
            int k = low;
            int start1 = low, end1 = mid;
            int start2 = mid, end2 = high;
            while (start1 < end1 && start2 < end2)
                b[k++] = a[start1] < a[start2] ? a[start1++] : a[start2++];
            while (start1 < end1)
                b[k++] = a[start1++];
            while (start2 < end2)
                b[k++] = a[start2++];
        }
        T* temp = a;
        a = b;
        b = temp;
    }
    if (a != arr) {
        for (int i = 0; i < len; i++)
            b[i] = a[i];
        b = a;
    }
    delete[] b;
}


int main(int argc, char* argv[])
{
    printf("Start: %s, C++: %ld\n", getTimeStamp().c_str(), __cplusplus);

    vector<int> vi1 = { 1,4,9,2,0,7,55,34,3,62,22,-3,13,45 };
    vector<string> vs1 = { "z", "d", "e", "h", "a", "p" };

    auto ri1 = estimate<vector<int>>(bubbleSort3, vi1);

    cout << "vi1: 冒泡bubbleSort1排序后: " << endl;
    CoutFor(ri1);


    /*     vector<int> vi;
        srand((int)time(NULL));
        for (int i = 0; i < 5e4; i++)
        {
            int n = rand() % 1000000;
            vi.push_back(n);
        }

        auto r1 = estimate<vector<int>>(bubbleSort_1, vi); */

    int vecLen = vi1.size();
    int arr[vecLen];
    for (int i = 0; i < vecLen; i++)
    {
        arr[i] = vi1[i];
    }
    int len = (int)sizeof(arr) / sizeof(*arr);

    cout << "arr: 排序前: " << endl;
    CoutFor(arr, len);


    mergeSort2(arr, len); //bubbleSort1 select_sort2 insert_sort1 insertSort2 shell_sort1 quick_sort1 heap_sort1 merge_sort1 mergeSort2

    // quickSortRecursive2(arr, 0, len - 1);

    // sort(arr, arr + len, DESC); //DESC 降序

    // int reg[len];
    // merge_sort_recursive2(arr, reg, 0, len - 1);

    cout << "arr: mergeSort2 排序后: " << endl;
    CoutFor(arr, len);

    // int n1 = 21;
    // int n2 = n1 >> 1;
    // cout << "n1 >> 1 :" << n2 << endl;




    return 0;
}

const string getTimeStamp()
{
    struct timeval curTime;
    gettimeofday(&curTime, NULL);

    struct tm nowTime;
    localtime_r(&curTime.tv_sec, &nowTime);
    char buffer[80] = { 0 };
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", &nowTime);

    char currentTime[84] = { 0 };
    snprintf(currentTime, sizeof(currentTime), "%s.%03d", buffer, (int)curTime.tv_usec / 1000);
    // printf("%s\n", currentTime);

    return currentTime;
}

template<class T, class...Args>
T estimate(T(*pf)(Args...), Args...arg)
{
    high_resolution_clock::time_point beginTime = high_resolution_clock::now();

    T ret = (*pf)(arg...);

    high_resolution_clock::time_point endTime = high_resolution_clock::now();

    milliseconds timeInterval = chrono::duration_cast<milliseconds>(endTime - beginTime);

    cout << "TimeCost: " << timeInterval.count() << "ms. " << endl;
    return ret;
}

template<class T>
void Swap(T& a, T& b)
{
    T temp = a;
    a = b;
    b = temp;
}

template<class T>
void CoutFor(T a)
{

    for (auto i : a)
    {
        cout << i << ",";
    }
    cout << endl;
}

template<typename T>
void CoutFor(T a[], int len)
{
    for (int i = 0; i < len; i++)
    {
        cout << a[i];

        if (i < len - 1)
            cout << ",";

        if (i % 5 == 4)
            cout << "\t";
    }
    cout << endl;
}

bool DESC(int x, int y)
{
    return x > y;
}

