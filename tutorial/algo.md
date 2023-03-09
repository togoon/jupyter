# 数据结构 & 算法


## 常用数据结构
栈(Stack):栈是一种特殊的线性表, 它只能在一个表的一个固定端进行数据结点的插入和删除操作.   
队列(Queue):队列和栈类似, 也是一种特殊的线性表. 和栈不同的是, 队列只允许在表的一端进行插入操作, 而在另一端进行删除操作.   
数组(Array):数组是一种聚合数据类型, 它是将具有相同类型的若干变量有序地组织在一起的集合.   
链表(Linked List):链表是一种数据元素按照链式存储结构进行存储的数据结构, 这种存储结构具有在物理上存在非连续的特点.   
树(Tree):树是典型的非线性结构, 它是包括, 2 个结点的有穷集合 K.   
图(Graph):图是另一种非线性数据结构. 在图结构中, 数据结点一般称为顶点, 而边是顶点的有序偶对.   
堆(Heap):堆是一种特殊的树形数据结构, 一般讨论的堆都是二叉堆.   
散列表(Hash table):散列表源自于散列函数(Hash function), 其思想是如果在结构中存在关键字和T相等的记录, 那么必定在F(T)的存储位置可以找到该记录, 这样就可以不用进行比较操作而直接取得所查记录.   

### C++标准库常用数据结构
string
vector
list
queue
priority_queue
set
map
stack


## 常用算法
数据结构研究的内容:就是如何按一定的逻辑结构, 把数据组织起来, 并选择适当的存储表示方法把逻辑结构组织好的数据存储到计算机的存储器里. 算法研究的目的是为了更有效的处理数据, 提高数据运算效率. 数据的运算是定义在数据的逻辑结构上, 但运算的具体实现要在存储结构上进行. 一般有以下几种常用运算:

检索:检索就是在数据结构里查找满足一定条件的节点. 一般是给定一个某字段的值, 找具有该字段值的节点.   
插入:往数据结构中增加新的节点.   
删除:把指定的结点从数据结构中去掉.   
更新:改变指定节点的一个或多个字段的值.   
排序:把节点按某种指定的顺序重新排列. 例如递增或递减.   

排序算法可以分为内部排序和外部排序, 内部排序是数据记录在内存中进行排序, 而外部排序是因排序的数据很大, 一次不能容纳全部的排序记录, 在排序过程中需要访问外存. 常见的内部排序算法有:插入排序, 希尔排序, 选择排序, 冒泡排序, 归并排序, 快速排序, 堆排序, 基数排序等. 用一张图概括:  
[![内部排序](https://www.runoob.com/wp-content/uploads/2019/03/sort.png)](https://www.runoob.com/wp-content/uploads/2019/03/sort.png)

[![内部排序](https://www.runoob.com/wp-content/uploads/2019/03/0B319B38-B70E-4118-B897-74EFA7E368F9.png)](https://www.runoob.com/wp-content/uploads/2019/03/0B319B38-B70E-4118-B897-74EFA7E368F9.png)

## 稳定性
稳定的排序算法:冒泡排序, 插入排序, 归并排序和基数排序.   
不是稳定的排序算法:选择排序, 快速排序, 希尔排序, 堆排序.   

## 时间复杂度
平方阶 O(n²) 排序 各类简单排序:直接插入, 直接选择和冒泡排序.   
线性对数阶 O(nlog2n) 排序 快速排序, 堆排序和归并排序;  
O(n1+§) 排序, § 是介于 0 和 1 之间的常数.  希尔排序  
线性阶 O(n))排序 基数排序, 此外还有桶, 箱排序.   

n:数据规模  
k:"桶"的个数  
In-place:占用常数内存, 不占用额外内存  
Out-place:占用额外内存  
稳定性:排序后 2 个相等键值的顺序和排序之前它们的顺序相同  


### 时间频度T(n)
一个算法执行所耗费的时间, 从理论上是不能算出来的, 必须上机运行测试才能知道. 但我们不可能也没有必要对每个算法都上机测试, 只需知道哪个算法花费的时间多, 哪个算法花费的时间少就可以了. 并且一个算法花费的时间与算法中语句的执行次数成正比例, 哪个算法中语句执行次数多, 它花费时间就多. 一个算法中的语句执行次数称为语句频度或时间频度. 记为T(n). 

### 时间复杂度O(n)
一般情况下, 算法中基本操作重复执行的次数是问题规模n的某个函数, 用T(n)表示, 若有某个辅助函数f(n),使得当n趋近于无穷大时, T(n)/f(n)的极限值为不等于零的常数, 则称f(n)是T(n)的同数量级函数. 记作T(n)=O(f(n)),称O(f(n)) 为算法的渐进时间复杂度, 简称时间复杂度. 
在T(n)=4n²-2n+2中, 就有f(n)=n², 使得T(n)/f(n)的极限值为4, 那么O(f(n)), 也就是时间复杂度为O(n²)
对于不是只有常数的时间复杂度忽略时间频度的系数, 低次项常数

         排序算法  数据对象/稳定性  平均时间     最佳        最差时间	 稳定性	  空间复杂度	备注
比较-交换 冒泡排序	数组v            O(n²)	                (n²)	   稳定v	O(1)	n较小时好
比较-交换 快速排序	数组x            O(nlogn)               O(n²)	   不稳定x	O(logn)	n较大时好
比较-选择 选择排序	数组x 链表v      O(n²)	                O(n²)	   不稳定x	 O(1)	n较小时好
比较-选择 堆排序	数组x            O(nlogn)               O(nlogn)    不稳定x	 O(1)	n较大时好
比较-插入 插入排序	数组v 链表v      O(n²)	                O(n²)	    稳定v	 O(1)	大部分已有序时好
比较-插入 希尔排序	数组x            O(nlogn)               O(ns)(1<s<2)不稳定x	 O(1)	s是所选分组
比较类--  归并排序	数组v 链表v      O(nlogn)               O(nlogn)	稳定v	 O(1)	n较大时好

非比较类- 计数排序	数组v 链表v      O(n+k)	                O(n+k)	    稳定v	 O(k)	
非比较类- 桶排序	数组v 链表v      O(n+k)	                O(n²)	    稳定v	 O(n+k)	
非比较类- 基数排序	数组v 链表v      O(n*k)	                O(n*k)	    稳定v	 O(n+k)	二维数组(桶) 一维数组(桶中首元素的位置)

        交换排序	               O(n²)	                O(n²)	  不稳定	O(1)	n较小时好


稳定：如果原本序列中a在b前面且a=b，排序后a仍在b前面，顺序不变；
不稳定：如果原本序列中a在b前面且a=b，排序后a可能在b后面，顺序可能发生改变；
内排序：所有排序操作均在内存中完成；
外排序：由于数据量太大，将其放入磁盘中，排序过程中需要磁盘与内存之间的数据传输；
时间复杂度：一个排序算法在执行过程中所耗费的时间量级的度量；
空间复杂度：一个排序算法在运行过程中临时占用存储空间大小的度量；


对于只有常数的时间复杂度, 将常数看为1

### 常数阶 O(1)
int i = 1;
i++;

无论代码执行了多少行, 只要没有循环等复杂的结构, 时间复杂度都是O(1)

### 对数阶O(log²n)
while(i<n) {
    i = i*2;
}

此处i并不是依次递增到n, 而是每次都以倍数增长. 假设循环了x次后i大于n. 则2x = n, x=log2n

### 线性阶O(n)
for(int i = 0; i<n; i++) {
    i++;
}

这其中, 循环体中的代码会执行n+1次, 时间复杂度为O(n)

### 线性对数阶O(nlog²n)
for(int i = 0; i<n; i++) {
    j = 1;
    while(j<n) {
        j = j*2;
    }
} 

此处外部为一个循环, 循环了n次. 内部也是一个循环, 但内部f循环的时间复杂度是log2n
所以总体的时间复杂度为线性对数阶O(nlog²n)

### 平方阶O(n²)
for(int i = 0; i<n; i++) {
    for(int j = 0; j<n; j++) {
        //循环体
    }
}
  
### 立方阶O(n3)
for(int i = 0; i<n; i++) {
    for(int j = 0; j<n; j++) {
        for(int k = 0; k<n; k++) {
            //循环体
        }
    }
}
  
可以看出平方阶, 立方阶的复杂度主要是否循环嵌套了几层来决定的




# 经典排序算法

## 1 冒泡排序 Bubble Sort 
冒泡排序(Bubble Sort)也是一种简单直观的排序算法. 它重复地走访过要排序的数列, 一次比较两个元素, 如果他们的顺序(如从大到小, 首字母从A到Z)错误就把他们交换过来. 走访数列的工作是重复地进行直到没有再需要交换, 也就是说该数列已经排序完成. 这个算法的名字由来是因为越小的元素会经由交换慢慢"浮"到数列的顶端. 
作为最简单的排序算法之一, 冒泡排序给我的感觉就像 Abandon 在单词书里出现的感觉一样, 每次都在第一页第一位, 所以最熟悉. 冒泡排序还有一种优化算法, 就是立一个 flag, 当在一趟序列遍历中元素没有发生交换, 则证明该序列已经有序. 但这种改进对于提升性能来
说并没有什么太大作用. 
1. 算法步骤
比较相邻的元素. 如果第一个比第二个大, 就交换他们两个. 
对每一对相邻元素作同样的工作, 从开始第一对到结尾的最后一对. 这步做完后, 最后的元素会是最大的数. 
针对所有的元素重复以上的步骤, 除了最后一个. 
持续每次对越来越少的元素重复上面的步骤, 直到没有任何一对数字需要比较. 
2. 动图演示  
[![冒泡排序 Bubble Sort](https://www.runoob.com/wp-content/uploads/2019/03/bubbleSort.gif)](https://www.runoob.com/wp-content/uploads/2019/03/bubbleSort.gif)  
[![冒泡排序 Bubble Sort](https://www.runoob.com/wp-content/uploads/2018/09/Bubble_sort_animation.gif)](https://www.runoob.com/wp-content/uploads/2018/09/Bubble_sort_animation.gif)  
[![冒泡排序 Bubble Sort](https://www.runoob.com/wp-content/uploads/2015/09/1240)](https://www.runoob.com/wp-content/uploads/2015/09/1240)  

3. 什么时候最快
当输入的数据已经是正序时(都已经是正序了, 我还要你冒泡排序有何用啊). 
4. 什么时候最慢
当输入的数据是反序时(写一个 for 循环反序输出数据不就行了, 干嘛要用你冒泡排序呢, 我是闲的吗). 

JavaScript 代码实现
```JavaScript
function bubbleSort(arr) {
    var len = arr.length;
    for (var i = 0; i < len - 1; i++) {
        for (var j = 0; j < len - 1 - i; j++) {
            if (arr[j] > arr[j+1]) {        // 相邻元素两两对比
                var temp = arr[j+1];        // 元素交换
                arr[j+1] = arr[j];
                arr[j] = temp;
            }
        }
    }
    return arr;
}
```

Python 代码实现
```python
def bubbleSort(arr):
    for i in range(1, len(arr)):
        for j in range(0, len(arr)-i):
            if arr[j] > arr[j+1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
    return arr
```

Go 代码实现
```go
func bubbleSort(arr []int) []int {
        length := len(arr)
        for i := 0; i < length; i++ {
                for j := 0; j < length-1-i; j++ {
                        if arr[j] > arr[j+1] {
                                arr[j], arr[j+1] = arr[j+1], arr[j]
                        }
                }
        }
        return arr
}
```

Java 代码实现
```java
public class BubbleSort implements IArraySort {
    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝, 不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);
        for (int i = 1; i < arr.length; i++) {
            // 设定一个标记, 若为true, 则表示此次循环没有进行交换, 也就是待排序列已经有序, 排序已经完成. 
            boolean flag = true;
            for (int j = 0; j < arr.length - i; j++) {
                if (arr[j] > arr[j + 1]) {
                    int tmp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = tmp;
                    flag = false;
                }
            }
            if (flag) {
                break;
            }
        }
        return arr;
    }
}

// 优化:
// 针对问题:
// 数据的顺序排好之后, 冒泡算法仍然会继续进行下一轮的比较, 直到arr.length-1次, 后面的比较没有意义的. 
// 方案:
// 设置标志位flag, 如果发生了交换flag设置为true;如果没有交换就设置为false. 
// 这样当一轮比较结束后如果flag仍为false, 即:这一轮没有发生交换, 说明数据的顺序已经排好, 没有必要继续进行下去. 

public static void BubbleSort1(int [] arr){

   int temp;//临时变量
   boolean flag;//是否交换的标志
   for(int i=0; i<arr.length-1; i++){   //表示趟数, 一共 arr.length-1 次

       // 每次遍历标志位都要先置为false, 才能判断后面的元素是否发生了交换
       flag = false;
       
       for(int j=arr.length-1; j>i; j--){ //选出该趟排序的最大值往后移动

           if(arr[j] < arr[j-1]){
               temp = arr[j];
               arr[j] = arr[j-1];
               arr[j-1] = temp;
               flag = true;    //只要有发生了交换, flag就置为true
           }
       }
       // 判断标志位是否为false, 如果为false, 说明后面的元素已经有序, 就直接return
       if(!flag) break;
   }
}
```

PHP 代码实现
```php
function bubbleSort($arr)
{
    $len = count($arr);
    for ($i = 0; $i < $len - 1; $i++) {
        for ($j = 0; $j < $len - 1 - $i; $j++) {
            if ($arr[$j] > $arr[$j+1]) {
                $tmp = $arr[$j];
                $arr[$j] = $arr[$j+1];
                $arr[$j+1] = $tmp;
            }
        }
    }
    return $arr;
}
```

C 语言
```c
#include <stdio.h>
void bubble_sort(int arr[], int len) {
    int i, j, temp;
    for (i = 0; i < len - 1; i++)
        for (j = 0; j < len - 1 - i; j++)
            if (arr[j] > arr[j + 1]) {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
}
int main() {
    int arr[] = { 22, 34, 3, 32, 82, 55, 89, 50, 37, 5, 64, 35, 9, 70 };
    int len = (int) sizeof(arr) / sizeof(*arr);
    bubble_sort(arr, len);
    int i;
    for (i = 0; i < len; i++)
        printf("%d ", arr[i]);
    return 0;
}
```

C++ 语言
```c++
#include <iostream>
using namespace std;
template<typename T> //整数或浮点数皆可使用,若要使用类(class)或结构体(struct)时必须重载大于(>)运算符
void bubble_sort(T arr[], int len) {
        int i, j;
        for (i = 0; i < len - 1; i++)
                for (j = 0; j < len - 1 - i; j++)
                        if (arr[j] > arr[j + 1])
                                swap(arr[j], arr[j + 1]);
}
int main() {
        int arr[] = { 61, 17, 29, 22, 34, 60, 72, 21, 50, 1, 62 };
        int len = (int) sizeof(arr) / sizeof(*arr);
        bubble_sort(arr, len);
        for (int i = 0; i < len; i++)
                cout << arr[i] << ' ';
        cout << endl;
        float arrf[] = { 17.5, 19.1, 0.6, 1.9, 10.5, 12.4, 3.8, 19.7, 1.5, 25.4, 28.6, 4.4, 23.8, 5.4 };
        len = (float) sizeof(arrf) / sizeof(*arrf);
        bubble_sort(arrf, len);
        for (int i = 0; i < len; i++)
                cout << arrf[i] << ' '<<endl;
        return 0;
}
```

C#
```c#
static void BubbleSort(int[] intArray) {
    int temp = 0;
    bool swapped;
    for (int i = 0; i < intArray.Length; i++)
    {
        swapped = false;
        for (int j = 0; j < intArray.Length - 1 - i; j++)
            if (intArray[j] > intArray[j + 1])
            {
                temp = intArray[j];
                intArray[j] = intArray[j + 1];
                intArray[j + 1] = temp;
                if (!swapped)
                    swapped = true;
            }
        if (!swapped)
            return;
    }
}
```

Ruby
```ruby
class Array
  def bubble_sort!
    for i in 0...(size - 1)
      for j in 0...(size - i - 1)
        self[j], self[j + 1] = self[j + 1], self[j] if self[j] > self[j + 1]
      end
    end
    self
  end
end
puts [22, 34, 3, 32, 82, 55, 89, 50, 37, 5, 64, 35, 9, 70].bubble_sort!
```

Swift
```swift
import Foundation
func bubbleSort (arr: inout [Int]) {
    for i in 0..<arr.count - 1 {
        for j in 0..<arr.count - 1 - i {
            if arr[j] > arr[j+1] {
                arr.swapAt(j, j+1)
            }
        }
    }
}
// 测试调用
func testSort () {
    // 生成随机数数组进行排序操作
    var list:[Int] = []
    for _ in 0...99 {
        list.append(Int(arc4random_uniform(100)))
    }
    print("\(list)")
    bubbleSort(arr:&list)
    print("\(list)")
}
```

## 2 选择排序 Selection Sort 

选择排序(Selection sort)是一种简单直观的排序算法, 无论什么数据进去都是 O(n²) 的时间复杂度. 所以用到它的时候, 数据规模越小越好. 唯一的好处可能就是不占用额外的内存空间了吧. 
1. 算法步骤/工作原理
首先在未排序序列中找到最小(大)元素, 存放到排序序列的起始位置. 
再从剩余未排序元素中继续寻找最小(大)元素, 然后放到已排序序列的末尾. 
重复第二步, 直到所有元素均排序完毕. 
2. 动图演示  
[![选择排序](https://www.runoob.com/wp-content/uploads/2019/03/selectionSort.gif)](https://www.runoob.com/wp-content/uploads/2019/03/selectionSort.gif)
[![选择排序Selection sort](https://www.runoob.com/wp-content/uploads/2018/09/Selection_sort_animation.gif )](https://www.runoob.com/wp-content/uploads/2018/09/Selection_sort_animation.gif)  
[![选择排序Selection sort](https://www.runoob.com/wp-content/uploads/2018/09/Selection-Sort-Animation.gif )](https://www.runoob.com/wp-content/uploads/2018/09/Selection-Sort-Animation.gif)  
[![选择排序Selection sort](https://www.runoob.com/wp-content/uploads/2015/09/12401)](https://www.runoob.com/wp-content/uploads/2015/09/12401)  

3. 代码实现

JavaScript 代码实现
```JavaScript
function selectionSort(arr) {
    var len = arr.length;
    var minIndex, temp;
    for (var i = 0; i < len - 1; i++) {
        minIndex = i;
        for (var j = i + 1; j < len; j++) {
            if (arr[j] < arr[minIndex]) {     // 寻找最小的数
                minIndex = j;                 // 将最小数的索引保存
            }
        }
        temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;
    }
    return arr;
}
```

Python 代码实现
```Python
def selectionSort(arr):
    for i in range(len(arr) - 1):
        # 记录最小数的索引
        minIndex = i
        for j in range(i + 1, len(arr)):
            if arr[j] < arr[minIndex]:
                minIndex = j
        # i 不是最小数时, 将 i 和最小数进行交换
        if i != minIndex:
            arr[i], arr[minIndex] = arr[minIndex], arr[i]
    return arr
```

Go 代码实现
```Go
func selectionSort(arr []int) []int {
        length := len(arr)
        for i := 0; i < length-1; i++ {
                min := i
                for j := i + 1; j < length; j++ {
                        if arr[min] > arr[j] {
                                min = j
                        }
                }
                arr[i], arr[min] = arr[min], arr[i]
        }
        return arr
}
```

Java 代码实现
```Java
public class SelectionSort implements IArraySort {
    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);
        // 总共要经过 N-1 轮比较
        for (int i = 0; i < arr.length - 1; i++) {
            int min = i;
            // 每轮需要比较的次数 N-i
            for (int j = i + 1; j < arr.length; j++) {
                if (arr[j] < arr[min]) {
                    // 记录目前能找到的最小值元素的下标
                    min = j;
                }
            }
            // 将找到的最小值和i位置所在的值进行交换
            if (i != min) {
                int tmp = arr[i];
                arr[i] = arr[min];
                arr[min] = tmp;
            }
        }
        return arr;
    }
}

public static void select_sort(int array[],int lenth){
   for(int i=0;i<lenth-1;i++){

       int minIndex = i;
       for(int j=i+1;j<lenth;j++){
          if(array[j]<array[minIndex]){
              minIndex = j;
          }
       }
       if(minIndex != i){
           int temp = array[i];
           array[i] = array[minIndex];
           array[minIndex] = temp;
       }
   }
}

```

PHP 代码实现
```PHP
function selectionSort($arr)
{
    $len = count($arr);
    for ($i = 0; $i < $len - 1; $i++) {
        $minIndex = $i;
        for ($j = $i + 1; $j < $len; $j++) {
            if ($arr[$j] < $arr[$minIndex]) {
                $minIndex = $j;
            }
        }
        $temp = $arr[$i];
        $arr[$i] = $arr[$minIndex];
        $arr[$minIndex] = $temp;
    }
    return $arr;
}
```

C 语言
```C
void swap(int *a,int *b) //交換兩個變數
{
    int temp = *a;
    *a = *b;
    *b = temp;
}
void selection_sort1(int arr[], int len)
{
    int i,j;
        for (i = 0 ; i < len - 1 ; i++)
    {
                int min = i;
                for (j = i + 1; j < len; j++)     //走訪未排序的元素
                        if (arr[j] < arr[min])    //找到目前最小值
                                min = j;    //紀錄最小值
                swap(&arr[min], &arr[i]);    //做交換
        }
}

/////////////////////////

void selection_sort(int a[], int len) 
{
    int i,j,temp;
    for (i = 0 ; i < len - 1 ; i++) 
    {
        int min = i;                  // 记录最小值, 第一个元素默认最小
        for (j = i + 1; j < len; j++)     // 访问未排序的元素
        {
            if (a[j] < a[min])    // 找到目前最小值
            {
                min = j;    // 记录最小值
            }
        }
        if(min != i)
        {
            temp=a[min];  // 交换两个变量
            a[min]=a[i];
            a[i]=temp;
        }
        /* swap(&a[min], &a[i]);  */   // 使用自定义函数交換
    }
}
/*
void swap(int *a,int *b) // 交换两个变量
{
    int temp = *a;
    *a = *b;
    *b = temp;
}
*/
```

C++
```C++
template<typename T> //整數或浮點數皆可使用, 若要使用物件(class)時必須設定大於(>)的運算子功能
void selection_sort(std::vector<T>& arr) {
        for (int i = 0; i < arr.size() - 1; i++) {
                int min = i;
                for (int j = i + 1; j < arr.size(); j++)
                        if (arr[j] < arr[min])
                                min = j;
                std::swap(arr[i], arr[min]);
        }
}
```

C#
```C#
static void selection_sort<T>(T[] arr) where T : System.IComparable<T>{//整數或浮點數皆可使用
        int i, j, min, len = arr.Length;
        T temp;
        for (i = 0; i < len - 1; i++) {
                min = i;
                for (j = i + 1; j < len; j++)
                        if (arr[min].CompareTo(arr[j]) > 0)
                                min = j;
                temp = arr[min];
                arr[min] = arr[i];
                arr[i] = temp;
        }
}
```

Swift
```Swift
import Foundation
/// 选择排序
///
/// - Parameter list: 需要排序的数组
func selectionSort(_ list: inout [Int]) -> Void {
    for j in 0..<list.count - 1 {
        var minIndex = j
        for i in j..<list.count {
            if list[minIndex] > list[i] {
                minIndex = i
            }
        }
        list.swapAt(j, minIndex)
    }
}
```

## 3 插入排序 Insertion Sort 

插入排序(Insertion Sort)的代码实现虽然没有冒泡排序和选择排序那么简单粗暴, 但它的原理应该是最容易理解的了, 因为只要打过扑克牌的人都应该能够秒懂. 插入排序是一种最简单直观的排序算法, 它的工作原理是通过构建有序序列, 对于未排序数据, 在已排序序列中从后向前扫描, 找到相应位置并插入. 
插入排序在实现上, 通常采用in-place排序(即只需用到 {\displaystyle O(1)} {\displaystyle O(1)}的额外空间的排序), 因而在从后向前扫描过程中, 需要反复把已排序元素逐步向后挪位, 为最新元素提供插入空间.   
插入排序和冒泡排序一样, 也有一种优化算法, 叫做拆半插入. 
1. 算法步骤
将第一待排序序列第一个元素看做一个有序序列, 把第二个元素到最后一个元素当成是未排序序列. 
从头到尾依次扫描未排序序列, 将扫描到的每个元素插入有序序列的适当位置. (如果待插入的元素与有序序列中的某个元素相等, 则将待插入元素插入到相等元素的后面. )
2. 动图演示  
[![插入排序](https://www.runoob.com/wp-content/uploads/2019/03/insertionSort.gif)](https://www.runoob.com/wp-content/uploads/2019/03/insertionSort.gif)
[![插入排序 Insertion Sort](https://www.runoob.com/wp-content/uploads/2018/09/Insertion_sort_animation.gif )](https://www.runoob.com/wp-content/uploads/2018/09/Insertion_sort_animation.gif)  
[![插入排序 Insertion Sort](https://www.runoob.com/wp-content/uploads/2015/09/33403 )](https://www.runoob.com/wp-content/uploads/2015/09/33403)  

3. 代码实现

JavaScript
```JavaScript
function insertionSort(arr) {
    var len = arr.length;
    var preIndex, current;
    for (var i = 1; i < len; i++) {
        preIndex = i - 1;
        current = arr[i];
        while(preIndex >= 0 && arr[preIndex] > current) {
            arr[preIndex+1] = arr[preIndex];
            preIndex--;
        }
        arr[preIndex+1] = current;
    }
    return arr;
}
```

Python
```Python
def insertionSort(arr):
    for i in range(len(arr)):
        preIndex = i-1
        current = arr[i]
        while preIndex >= 0 and arr[preIndex] > current:
            arr[preIndex+1] = arr[preIndex]
            preIndex-=1
        arr[preIndex+1] = current
    return arr
```

Go
```Go
func insertionSort(arr []int) []int {
        for i := range arr {
                preIndex := i - 1
                current := arr[i]
                for preIndex >= 0 && arr[preIndex] > current {
                        arr[preIndex+1] = arr[preIndex]
                        preIndex -= 1
                }
                arr[preIndex+1] = current
        }
        return arr
}
```

Java
```Java
public class InsertSort implements IArraySort {
    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝, 不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);
        // 从下标为1的元素开始选择合适的位置插入, 因为下标为0的只有一个元素, 默认是有序的
        for (int i = 1; i < arr.length; i++) {
            // 记录要插入的数据
            int tmp = arr[i];
            // 从已经排序的序列最右边的开始比较, 找到比其小的数
            int j = i;
            while (j > 0 && tmp < arr[j - 1]) {
                arr[j] = arr[j - 1];
                j--;
            }
            // 存在比其小的数, 插入
            if (j != i) {
                arr[j] = tmp;
            }
        }
        return arr;
    }
}

public static void  insert_sort(int array[],int lenth){

   int temp;

   for(int i=0;i<lenth-1;i++){
       for(int j=i+1;j>0;j--){
           if(array[j] < array[j-1]){
               temp = array[j-1];
               array[j-1] = array[j];
               array[j] = temp;
           }else{         //不需要交换
               break;
           }
       }
   }
}

```

PHP
```PHP
function insertionSort($arr)
{
    $len = count($arr);
    for ($i = 1; $i < $len; $i++) {
        $preIndex = $i - 1;
        $current = $arr[$i];
        while($preIndex >= 0 && $arr[$preIndex] > $current) {
            $arr[$preIndex+1] = $arr[$preIndex];
            $preIndex--;
        }
        $arr[$preIndex+1] = $current;
    }
    return $arr;
}
```

C
```C
void insertion_sort1(int arr[], int len){
        int i,j,key;
        for (i=1;i<len;i++){
                key = arr[i];
                j=i-1;
                while((j>=0) && (arr[j]>key)) {
                    arr[j+1] = arr[j];
                    j--;
                }
                arr[j+1] = key;
        }
}

//////////////////////////

void insertion_sort(int arr[], int len){
    int i,j,temp;
    for (i=1;i<len;i++){
            temp = arr[i];
            for (j=i;j>0 && arr[j-1]>temp;j--)
               arr[j] = arr[j-1];
            arr[j] = temp;
    }
}
```

C++
```C++
void insertion_sort(int arr[],int len){
        for(int i=1;i<len;i++){
                int key=arr[i];
                int j=i-1;
                while((j>=0) && (key<arr[j])){
                        arr[j+1]=arr[j];
                        j--;
                }
                arr[j+1]=key;
        }
}
```

C#
```C#
public static void InsertSort(int[] array)
{
    for(int i = 1;i < array.length;i++)
    {
        int temp = array[i];
        for(int j = i - 1;j >= 0;j--)
        {
            if(array[j] > temp)
            {
                array[j + 1] = array[j];
                array[j] = temp;
            }
            else
                break;
        }
    }
}
```

Swift
```Swift
for i in 1..<arr.endIndex {
    let temp = arr[i]
    for j in (0..<i).reversed() {
        if arr[j] > temp {
            arr.swapAt(j, j+1)
        }
    }
}
```

## 4 希尔排序 Shell Sort

希尔排序(Shell Sort), 也称递减增量排序算法, 是插入排序的一种更高效的改进版本. 但希尔排序是非稳定排序算法. 
希尔排序是基于插入排序的以下两点性质而提出改进方法的:
插入排序在对几乎已经排好序的数据操作时, 效率高, 即可以达到线性排序的效率;
但插入排序一般来说是低效的, 因为插入排序每次只能将数据移动一位;
希尔排序的基本思想是:先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序, 待整个序列中的记录"基本有序"时, 再对全体记录进行依次直接插入排序. 

1. 算法步骤
选择一个增量序列 t1, t2, ……, tk, 其中 ti > tj, tk = 1;
按增量序列个数 k, 对序列进行 k 趟排序;
每趟排序, 根据对应的增量 ti, 将待排序列分割成若干长度为 m 的子序列, 分别对各子表进行直接插入排序. 仅增量因子为 1 时, 整个序列作为一个表来处理, 表长度即为整个序列的长度. 
2. 动图演示  
[![希尔排序](https://www.runoob.com/wp-content/uploads/2019/03/Sorting_shellsort_anim.gif)](https://www.runoob.com/wp-content/uploads/2019/03/Sorting_shellsort_anim.gif)

前言:  
数据序列1: 13-17-20-42-28 利用插入排序, 13-17-20-28-42. Number of swap:1;
数据序列2: 13-17-20-42-14 利用插入排序, 13-14-17-20-42. Number of swap:3;
如果数据序列基本有序, 使用插入排序会更加高效.   

基本思想:  
在要排序的一组数中, 根据某一增量分为若干子序列, 并对子序列分别进行插入排序. 
然后逐渐将增量减小,并重复上述过程. 直至增量为1,此时数据序列基本有序,最后进行插入排序.   

[![希尔排序](https://www.runoob.com/wp-content/uploads/2015/09/44404)](https://www.runoob.com/wp-content/uploads/2015/09/44404)


3 代码实现

JavaScript
```JavaScript
function shellSort(arr) {
    var len = arr.length,
        temp,
        gap = 1;
    while(gap < len/3) {          //动态定义间隔序列
        gap =gap*3+1;
    }
    for (gap; gap > 0; gap = Math.floor(gap/3)) {
        for (var i = gap; i < len; i++) {
            temp = arr[i];
            for (var j = i-gap; j >= 0 && arr[j] > temp; j-=gap) {
                arr[j+gap] = arr[j];
            }
            arr[j+gap] = temp;
        }
    }
    return arr;
}
```

Python
```Python
def shellSort(arr):
    import math
    gap=1
    while(gap < len(arr)/3):
        gap = gap*3+1
    while gap > 0:
        for i in range(gap,len(arr)):
            temp = arr[i]
            j = i-gap
            while j >=0 and arr[j] > temp:
                arr[j+gap]=arr[j]
                j-=gap
            arr[j+gap] = temp
        gap = math.floor(gap/3)
    return arr
```

Go
```Go
func shellSort(arr []int) []int {
        length := len(arr)
        gap := 1
        for gap < length/3 {
                gap = gap*3 + 1
        }
        for gap > 0 {
                for i := gap; i < length; i++ {
                        temp := arr[i]
                        j := i - gap
                        for j >= 0 && arr[j] > temp {
                                arr[j+gap] = arr[j]
                                j -= gap
                        }
                        arr[j+gap] = temp
                }
                gap = gap / 3
        }
        return arr
}
```

Java
```Java
public static void shellSort(int[] arr) {
    int length = arr.length;
    int temp;
    for (int step = length / 2; step >= 1; step /= 2) {
        for (int i = step; i < length; i++) {
            temp = arr[i];
            int j = i - step;
            while (j >= 0 && arr[j] > temp) {
                arr[j + step] = arr[j];
                j -= step;
            }
            arr[j + step] = temp;
        }
    }
}

public static void shell_sort(int array[],int lenth){

   int temp = 0;
   int incre = lenth;

   while(true){
       incre = incre/2;

       for(int k = 0;k<incre;k++){    //根据增量分为若干子序列

           for(int i=k+incre;i<lenth;i+=incre){

               for(int j=i;j>k;j-=incre){
                   if(array[j]<array[j-incre]){
                       temp = array[j-incre];
                       array[j-incre] = array[j];
                       array[j] = temp;
                   }else{
                       break;
                   }
               }
           }
       }

       if(incre == 1){
           break;
       }
   }
}

```

PHP
```PHP
function shellSort($arr)
{
    $len = count($arr);
    $temp = 0;
    $gap = 1;
    while($gap < $len / 3) {
        $gap = $gap * 3 + 1;
    }
    for ($gap; $gap > 0; $gap = floor($gap / 3)) {
        for ($i = $gap; $i < $len; $i++) {
            $temp = $arr[$i];
            for ($j = $i - $gap; $j >= 0 && $arr[$j] > $temp; $j -= $gap) {
                $arr[$j+$gap] = $arr[$j];
            }
            $arr[$j+$gap] = $temp;
        }
    }
    return $arr;
}
```

C
```C
void shell_sort(int arr[], int len) {
    int gap, i, j;
    int temp;
    for (gap = len >> 1; gap > 0; gap = gap >> 1)
        for (i = gap; i < len; i++) {
            temp = arr[i];
            for (j = i - gap; j >= 0 && arr[j] > temp; j -= gap)
                arr[j + gap] = arr[j];
            arr[j + gap] = temp;
        }
}
```


C++
```C++
template<typename T>
void shell_sort(T array[], int length) {
    int h = 1;
    while (h < length / 3) {
        h = 3 * h + 1;
    }
    while (h >= 1) {
        for (int i = h; i < length; i++) {
            for (int j = i; j >= h && array[j] < array[j - h]; j -= h) {
                std::swap(array[j], array[j - h]);
            }
        }
        h = h / 3;
    }
}
```

## 5 归并排序 Merge Sort 分治

归并排序(Merge sort)是建立在归并操作上的一种有效的排序算法. 该算法是采用分治法(Divide and Conquer)的一个非常典型的应用. 
把数据分为两段, 从两段中逐个选最小的元素移入新数据段的末尾. 
可从上到下或从下到上进行.   
作为一种典型的分而治之思想的算法应用, 归并排序的实现由两种方法:
自上而下的递归(所有递归的方法都可以用迭代重写, 所以就有了第 2 种方法);
自下而上的迭代;
在<数据结构与算法 JavaScript 描述>中, 作者给出了自下而上的迭代方法. 但是对于递归法, 作者却认为:
However, it is not possible to do so in JavaScript, as the recursion goes too deep for the language to handle.
然而, 在 JavaScript 中这种方式不太可行, 因为这个算法的递归深度对它来讲太深了. 
说实话, 我不太理解这句话. 意思是 JavaScript 编译器内存太小, 递归太深容易造成内存溢出吗?还望有大神能够指教. 
和选择排序一样, 归并排序的性能不受输入数据的影响, 但表现比选择排序好的多, 因为始终都是 O(nlogn) 的时间复杂度. 代价是需要额外的内存空间. 
1. 算法步骤
申请空间, 使其大小为两个已经排序序列之和, 该空间用来存放合并后的序列;
设定两个指针, 最初位置分别为两个已经排序序列的起始位置;
比较两个指针所指向的元素, 选择相对小的元素放入到合并空间, 并移动指针到下一位置;
重复步骤 3 直到某一指针达到序列尾;
将另一序列剩下的所有元素直接复制到合并序列尾. 
2. 动图演示  
[![归并排序](https://www.runoob.com/wp-content/uploads/2019/03/mergeSort.gif)](https://www.runoob.com/wp-content/uploads/2019/03/mergeSort.gif)
[![归并排序 merge Sort](https://www.runoob.com/wp-content/uploads/2018/09/Merge_sort_animation2.gif)](https://www.runoob.com/wp-content/uploads/2018/09/Merge_sort_animation2.gif)  
[![归并排序 merge Sort](https://www.runoob.com/wp-content/uploads/2018/09/Merge-sort-example-300px.gif)](https://www.runoob.com/wp-content/uploads/2018/09/Merge-sort-example-300px.gif)  
[![归并排序 merge Sort](https://www.runoob.com/wp-content/uploads/2015/09/55505)](https://www.runoob.com/wp-content/uploads/2015/09/55505)  


3. 代码实现

JavaScript
```JavaScript
function mergeSort(arr) {  // 采用自上而下的递归方法
    var len = arr.length;
    if(len < 2) {
        return arr;
    }
    var middle = Math.floor(len / 2),
        left = arr.slice(0, middle),
        right = arr.slice(middle);
    return merge(mergeSort(left), mergeSort(right));
}
function merge(left, right)
{
    var result = [];
    while (left.length && right.length) {
        if (left[0] <= right[0]) {
            result.push(left.shift());
        } else {
            result.push(right.shift());
        }
    }
    while (left.length)
        result.push(left.shift());
    while (right.length)
        result.push(right.shift());
    return result;
}
```

Python
```Python
def mergeSort(arr):
    import math
    if(len(arr)<2):
        return arr
    middle = math.floor(len(arr)/2)
    left, right = arr[0:middle], arr[middle:]
    return merge(mergeSort(left), mergeSort(right))
def merge(left,right):
    result = []
    while left and right:
        if left[0] <= right[0]:
            result.append(left.pop(0))
        else:
            result.append(right.pop(0));
    while left:
        result.append(left.pop(0))
    while right:
        result.append(right.pop(0));
    return result
```

Go
```Go
func mergeSort(arr []int) []int {
        length := len(arr)
        if length < 2 {
                return arr
        }
        middle := length / 2
        left := arr[0:middle]
        right := arr[middle:]
        return merge(mergeSort(left), mergeSort(right))
}
func merge(left []int, right []int) []int {
        var result []int
        for len(left) != 0 && len(right) != 0 {
                if left[0] <= right[0] {
                        result = append(result, left[0])
                        left = left[1:]
                } else {
                        result = append(result, right[0])
                        right = right[1:]
                }
        }
        for len(left) != 0 {
                result = append(result, left[0])
                left = left[1:]
        }
        for len(right) != 0 {
                result = append(result, right[0])
                right = right[1:]
        }
        return result
}
```

Java
```Java
public class MergeSort implements IArraySort {
    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝, 不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);
        if (arr.length < 2) {
            return arr;
        }
        int middle = (int) Math.floor(arr.length / 2);
        int[] left = Arrays.copyOfRange(arr, 0, middle);
        int[] right = Arrays.copyOfRange(arr, middle, arr.length);
        return merge(sort(left), sort(right));
    }
    protected int[] merge(int[] left, int[] right) {
        int[] result = new int[left.length + right.length];
        int i = 0;
        while (left.length > 0 && right.length > 0) {
            if (left[0] <= right[0]) {
                result[i++] = left[0];
                left = Arrays.copyOfRange(left, 1, left.length);
            } else {
                result[i++] = right[0];
                right = Arrays.copyOfRange(right, 1, right.length);
            }
        }
        while (left.length > 0) {
            result[i++] = left[0];
            left = Arrays.copyOfRange(left, 1, left.length);
        }
        while (right.length > 0) {
            result[i++] = right[0];
            right = Arrays.copyOfRange(right, 1, right.length);
        }
        return result;
    }
}

////////////////

public static void merge_sort(int a[],int first,int last,int temp[]){

  if(first < last){
      int middle = (first + last)/2;
      merge_sort(a,first,middle,temp);//左半部分排好序
      merge_sort(a,middle+1,last,temp);//右半部分排好序
      mergeArray(a,first,middle,last,temp); //合并左右部分
  }
}

//合并 :将两个序列a[first-middle],a[middle+1-end]合并
public static void mergeArray(int a[],int first,int middle,int end,int temp[]){    
  int i = first;
  int m = middle;
  int j = middle+1;
  int n = end;
  int k = 0;
  while(i<=m && j<=n){
      if(a[i] <= a[j]){
          temp[k] = a[i];
          k++;
          i++;
      }else{
          temp[k] = a[j];
          k++;
          j++;
      }
  }    
  while(i<=m){
      temp[k] = a[i];
      k++;
      i++;
  }    
  while(j<=n){
      temp[k] = a[j];
      k++;
      j++;
  }

  for(int ii=0;ii<k;ii++){
      a[first + ii] = temp[ii];
  }
}

```

PHP
```PHP
function mergeSort($arr)
{
    $len = count($arr);
    if ($len < 2) {
        return $arr;
    }
    $middle = floor($len / 2);
    $left = array_slice($arr, 0, $middle);
    $right = array_slice($arr, $middle);
    return merge(mergeSort($left), mergeSort($right));
}
function merge($left, $right)
{
    $result = [];
    while (count($left) > 0 && count($right) > 0) {
        if ($left[0] <= $right[0]) {
            $result[] = array_shift($left);
        } else {
            $result[] = array_shift($right);
        }
    }
    while (count($left))
        $result[] = array_shift($left);
    while (count($right))
        $result[] = array_shift($right);
    return $result;
}
```

C
```C
int min(int x, int y) {
    return x < y ? x : y;
}
void merge_sort(int arr[], int len) {
    int *a = arr;
    int *b = (int *) malloc(len * sizeof(int));
    int seg, start;
    for (seg = 1; seg < len; seg += seg) {
        for (start = 0; start < len; start += seg * 2) {
            int low = start, mid = min(start + seg, len), high = min(start + seg * 2, len);
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
        int *temp = a;
        a = b;
        b = temp;
    }
    if (a != arr) {
        int i;
        for (i = 0; i < len; i++)
            b[i] = a[i];
        b = a;
    }
    free(b);
}

// 递归版:

void merge_sort_recursive(int arr[], int reg[], int start, int end) {
    if (start >= end)
        return;
    int len = end - start, mid = (len >> 1) + start;
    int start1 = start, end1 = mid;
    int start2 = mid + 1, end2 = end;
    merge_sort_recursive(arr, reg, start1, end1);
    merge_sort_recursive(arr, reg, start2, end2);
    int k = start;
    while (start1 <= end1 && start2 <= end2)
        reg[k++] = arr[start1] < arr[start2] ? arr[start1++] : arr[start2++];
    while (start1 <= end1)
        reg[k++] = arr[start1++];
    while (start2 <= end2)
        reg[k++] = arr[start2++];
    for (k = start; k <= end; k++)
        arr[k] = reg[k];
}
void merge_sort(int arr[], const int len) {
    int reg[len];
    merge_sort_recursive(arr, reg, 0, len - 1);
}
```

C++
```C++
// 迭代版:
template<typename T> // 整數或浮點數皆可使用,若要使用物件(class)時必須設定"小於"(<)的運算子功能
void merge_sort(T arr[], int len) {
    T *a = arr;
    T *b = new T[len];
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
        T *temp = a;
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

## 递归版:
void Merge(vector<int> &Array, int front, int mid, int end) {
    // preconditions:
    // Array[front...mid] is sorted
    // Array[mid+1 ... end] is sorted
    // Copy Array[front ... mid] to LeftSubArray
    // Copy Array[mid+1 ... end] to RightSubArray
    vector<int> LeftSubArray(Array.begin() + front, Array.begin() + mid + 1);
    vector<int> RightSubArray(Array.begin() + mid + 1, Array.begin() + end + 1);
    int idxLeft = 0, idxRight = 0;
    LeftSubArray.insert(LeftSubArray.end(), numeric_limits<int>::max());
    RightSubArray.insert(RightSubArray.end(), numeric_limits<int>::max());
    // Pick min of LeftSubArray[idxLeft] and RightSubArray[idxRight], and put into Array[i]
    for (int i = front; i <= end; i++) {
        if (LeftSubArray[idxLeft] < RightSubArray[idxRight]) {
            Array[i] = LeftSubArray[idxLeft];
            idxLeft++;
        } else {
            Array[i] = RightSubArray[idxRight];
            idxRight++;
        }
    }
}
void MergeSort(vector<int> &Array, int front, int end) {
    if (front >= end)
        return;
    int mid = (front + end) / 2;
    MergeSort(Array, front, mid);
    MergeSort(Array, mid + 1, end);
    Merge(Array, front, mid, end);
}
```

C#
```C#
public static List<int> sort(List<int> lst) {
    if (lst.Count <= 1)
        return lst;
    int mid = lst.Count / 2;
    List<int> left = new List<int>();  // 定义左侧List
    List<int> right = new List<int>(); // 定义右侧List
    // 以下兩個循環把 lst 分為左右兩個 List
    for (int i = 0; i < mid; i++)
        left.Add(lst[i]);
    for (int j = mid; j < lst.Count; j++)
        right.Add(lst[j]);
    left = sort(left);
    right = sort(right);
    return merge(left, right);
}
/// <summary>
/// 合併兩個已經排好序的List
/// </summary>
/// <param name="left">左側List</param>
/// <param name="right">右側List</param>
/// <returns></returns>
static List<int> merge(List<int> left, List<int> right) {
    List<int> temp = new List<int>();
    while (left.Count > 0 && right.Count > 0) {
        if (left[0] <= right[0]) {
            temp.Add(left[0]);
            left.RemoveAt(0);
        } else {
            temp.Add(right[0]);
            right.RemoveAt(0);
        }
    }
    if (left.Count > 0) {
        for (int i = 0; i < left.Count; i++)
            temp.Add(left[i]);
    }
    if (right.Count > 0) {
        for (int i = 0; i < right.Count; i++)
            temp.Add(right[i]);
    }
    return temp;
}
```

Ruby
```Ruby
def merge list
  return list if list.size < 2
  pivot = list.size / 2
  # Merge
  lambda { |left, right|
    final = []
    until left.empty? or right.empty?
      final << if left.first < right.first; left.shift else right.shift end
    end
    final + left + right
  }.call merge(list[0...pivot]), merge(list[pivot..-1])
end
```

## 6 快速排序 Quick Sort(分治)
快速排序(Quicksort)是由东尼·霍尔所发展的一种排序算法. 在平均状况下, 排序 n 个项目要 Ο(nlogn) 次比较. 在最坏状况下则需要 Ο(n2) 次比较, 但这种状况并不常见. 事实上, 快速排序通常明显比其他 Ο(nlogn) 算法更快, 因为它的内部循环(inner loop)可以在大部分的架构上很有效率地被实现出来.   
快速排序使用分治法(Divide and conquer)策略来把一个串行(list)分为两个子串行(sub-lists).   
快速排序又是一种分而治之思想在排序算法上的典型应用. 本质上来看, 快速排序应该算是在冒泡排序基础上的递归分治法.   
快速排序的名字起的是简单粗暴, 因为一听到这个名字你就知道它存在的意义, 就是快, 而且效率高!它是处理大数据最快的排序算法之一了. 虽然 Worst Case 的时间复杂度达到了 O(n²), 但是人家就是优秀, 在大多数情况下都比平均时间复杂度为 O(n logn) 的排序算法表现要更好, 可是这是为什么呢, 我也不知道. 好在我的强迫症又犯了, 查了 N 多资料终于在<算法艺术与信息学竞赛>上找到了满意的答案:  
快速排序的最坏运行情况是 O(n²), 比如说顺序数列的快排. 但它的平摊期望时间是 O(nlogn), 且 O(nlogn) 记号中隐含的常数因子很小, 比复杂度稳定等于 O(nlogn) 的归并排序要小很多. 所以, 对绝大多数顺序性较弱的随机数列而言, 快速排序总是优于归并排序.   
1. 算法步骤
从数列中挑出一个元素, 称为 "基准"(pivot);  
将小于基准的元素放在基准之前, 大于基准的元素放在基准之后, 再分别对小数区与大数区进行排序.   
重新排序数列, 所有元素比基准值小的摆放在基准前面, 所有元素比基准值大的摆在基准的后面(相同的数可以到任一边). 在这个分区退出之后, 该基准就处于数列的中间位置. 这个称为分区(partition)操作;
递归地(recursive)把小于基准值元素的子数列和大于基准值元素的子数列排序;
递归的最底部情形, 是数列的大小是零或一, 也就是永远都已经被排序好了. 虽然一直递归下去, 但是这个算法总会退出, 因为在每次的迭代(iteration)中, 它至少会把一个元素摆到它最后的位置去.   

基本思想:(分治)

先从数列中取出一个数作为key值;
将比这个数小的数全部放在它的左边, 大于或等于它的数全部放在它的右边;
对左右两个小数列重复第二步, 直至各区间只有1个数. 
辅助理解:挖坑填数

初始时 i = 0; j = 9; key=72
由于已经将a[0]中的数保存到key中, 可以理解成在数组a[0]上挖了个坑, 可以将其它数据填充到这来. 
从j开始向前找一个比key小的数. 当j=8, 符合条件, a[0] = a[8] ; i++ ; 将a[8]挖出再填到上一个坑a[0]中. 
这样一个坑a[0]就被搞定了, 但又形成了一个新坑a[8], 这怎么办了?简单, 再找数字来填a[8]这个坑. 
这次从i开始向后找一个大于key的数, 当i=3, 符合条件, a[8] = a[3] ; j-- ; 将a[3]挖出再填到上一个坑中. 
数组:72 - 6 - 57 - 88 - 60 - 42 - 83 - 73 - 48 - 85
 0   1   2    3    4    5    6    7    8    9
此时 i = 3; j = 7; key=72
再重复上面的步骤, 先从后向前找, 再从前向后找. 
从j开始向前找, 当j=5, 符合条件, 将a[5]挖出填到上一个坑中, a[3] = a[5]; i++;
从i开始向后找, 当i=5时, 由于i==j退出. 
此时, i = j = 5, 而a[5]刚好又是上次挖的坑, 因此将key填入a[5]. 
数组:48 - 6 - 57 - 88 - 60 - 42 - 83 - 73 - 88 - 85
 0   1   2    3    4    5    6    7    8    9
可以看出a[5]前面的数字都小于它, a[5]后面的数字都大于它. 因此再对a[0…4]和a[6…9]这二个子区间重复上述步骤就可以了. 
<数组:48 - 6 - 57 - 42 - 60 - 72 - 83 - 73 - 88 - 85
 0   1   2    3    4    5    6    7    8    9

2. 动图演示  
[![快速排序](https://www.runoob.com/wp-content/uploads/2019/03/quickSort.gif)](https://www.runoob.com/wp-content/uploads/2019/03/quickSort.gif)
[![快速排序 quick Sort](https://www.runoob.com/wp-content/uploads/2018/09/Sorting_quicksort_anim.gif)](https://www.runoob.com/wp-content/uploads/2018/09/Sorting_quicksort_anim.gif)  


JavaScript
```JavaScript
function quickSort(arr, left, right) {
    var len = arr.length,
        partitionIndex,
        left = typeof left != 'number' ? 0 : left,
        right = typeof right != 'number' ? len - 1 : right;
    if (left < right) {
        partitionIndex = partition(arr, left, right);
        quickSort(arr, left, partitionIndex-1);
        quickSort(arr, partitionIndex+1, right);
    }
    return arr;
}
function partition(arr, left ,right) {     // 分区操作
    var pivot = left,                      // 设定基准值(pivot)
        index = pivot + 1;
    for (var i = index; i <= right; i++) {
        if (arr[i] < arr[pivot]) {
            swap(arr, i, index);
            index++;
        }        
    }
    swap(arr, pivot, index - 1);
    return index-1;
}
function swap(arr, i, j) {
    var temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}
function partition2(arr, low, high) {
  let pivot = arr[low];
  while (low < high) {
    while (low < high && arr[high] > pivot) {
      --high;
    }
    arr[low] = arr[high];
    while (low < high && arr[low] <= pivot) {
      ++low;
    }
    arr[high] = arr[low];
  }
  arr[low] = pivot;
  return low;
}
function quickSort2(arr, low, high) {
  if (low < high) {
    let pivot = partition2(arr, low, high);
    quickSort2(arr, low, pivot - 1);
    quickSort2(arr, pivot + 1, high);
  }
  return arr;
}
```

Python
```Python
def quickSort(arr, left=None, right=None):
    left = 0 if not isinstance(left,(int, float)) else left
    right = len(arr)-1 if not isinstance(right,(int, float)) else right
    if left < right:
        partitionIndex = partition(arr, left, right)
        quickSort(arr, left, partitionIndex-1)
        quickSort(arr, partitionIndex+1, right)
    return arr
def partition(arr, left, right):
    pivot = left
    index = pivot+1
    i = index
    while  i <= right:
        if arr[i] < arr[pivot]:
            swap(arr, i, index)
            index+=1
        i+=1
    swap(arr,pivot,index-1)
    return index-1
def swap(arr, i, j):
    arr[i], arr[j] = arr[j], arr[i]
```

Go
```Go
func quickSort(arr []int) []int {
        return _quickSort(arr, 0, len(arr)-1)
}
func _quickSort(arr []int, left, right int) []int {
        if left < right {
                partitionIndex := partition(arr, left, right)
                _quickSort(arr, left, partitionIndex-1)
                _quickSort(arr, partitionIndex+1, right)
        }
        return arr
}
func partition(arr []int, left, right int) int {
        pivot := left
        index := pivot + 1
        for i := index; i <= right; i++ {
                if arr[i] < arr[pivot] {
                        swap(arr, i, index)
                        index += 1
                }
        }
        swap(arr, pivot, index-1)
        return index - 1
}
func swap(arr []int, i, j int) {
        arr[i], arr[j] = arr[j], arr[i]
}
```

C++
```C++
//严蔚敏<数据结构>标准分割函数
 int Paritition1(int A[], int low, int high) {
   int pivot = A[low];
   while (low < high) {
     while (low < high && A[high] >= pivot) {
       --high;
     }
     A[low] = A[high];
     while (low < high && A[low] <= pivot) {
       ++low;
     }
     A[high] = A[low];
   }
   A[low] = pivot;
   return low;
 }
 void QuickSort(int A[], int low, int high) //快排母函数
 {
   if (low < high) {
     int pivot = Paritition1(A, low, high);
     QuickSort(A, low, pivot - 1);
     QuickSort(A, pivot + 1, high);
   }
 }
```

Java
```Java
public class QuickSort implements IArraySort {
    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝, 不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);
        return quickSort(arr, 0, arr.length - 1);
    }
    private int[] quickSort(int[] arr, int left, int right) {
        if (left < right) {
            int partitionIndex = partition(arr, left, right);
            quickSort(arr, left, partitionIndex - 1);
            quickSort(arr, partitionIndex + 1, right);
        }
        return arr;
    }
    private int partition(int[] arr, int left, int right) {
        // 设定基准值(pivot)
        int pivot = left;
        int index = pivot + 1;
        for (int i = index; i <= right; i++) {
            if (arr[i] < arr[pivot]) {
                swap(arr, i, index);
                index++;
            }
        }
        swap(arr, pivot, index - 1);
        return index - 1;
    }
    private void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}


public static void quickSort(int a[],int l,int r){
     if(l>=r)
       return;

     int i = l; int j = r; int key = a[l];//选择第一个数为key

     while(i<j){

         while(i<j && a[j]>=key)//从右向左找第一个小于key的值
             j--;
         if(i<j){
             a[i] = a[j];
             i++;
         }

         while(i<j && a[i]<key)//从左向右找第一个大于key的值
             i++;

         if(i<j){
             a[j] = a[i];
             j--;
         }
     }
     //i == j
     a[i] = key;
     quickSort(a, l, i-1);//递归调用
     quickSort(a, i+1, r);//递归调用
 }
key值的选取可以有多种形式, 例如中间数或者随机

```

PHP
```PHP
function quickSort($arr)
{
    if (count($arr) <= 1)
        return $arr;
    $middle = $arr[0];
    $leftArray = array();
    $rightArray = array();
    for ($i = 1; $i < count($arr); $i++) {
        if ($arr[$i] > $middle)
            $rightArray[] = $arr[$i];
        else
            $leftArray[] = $arr[$i];
    }
    $leftArray = quickSort($leftArray);
    $leftArray[] = $middle;
    $rightArray = quickSort($rightArray);
    return array_merge($leftArray, $rightArray);
}
```

C
```C
typedef struct _Range {
    int start, end;
} Range;
Range new_Range(int s, int e) {
    Range r;
    r.start = s;
    r.end = e;
    return r;
}
void swap(int *x, int *y) {
    int t = *x;
    *x = *y;
    *y = t;
}
void quick_sort(int arr[], const int len) {
    if (len <= 0)
        return; // 避免len等於負值時引發段錯誤(Segment Fault)
    // r[]模擬列表,p為數量,r[p++]為push,r[--p]為pop且取得元素
    Range r[len];
    int p = 0;
    r[p++] = new_Range(0, len - 1);
    while (p) {
        Range range = r[--p];
        if (range.start >= range.end)
            continue;
        int mid = arr[(range.start + range.end) / 2]; // 選取中間點為基準點
        int left = range.start, right = range.end;
        do {
            while (arr[left] < mid) ++left;   // 檢測基準點左側是否符合要求
            while (arr[right] > mid) --right; //檢測基準點右側是否符合要求
            if (left <= right) {
                swap(&arr[left], &arr[right]);
                left++;
                right--;               // 移動指針以繼續
            }
        } while (left <= right);
        if (range.start < right) r[p++] = new_Range(range.start, right);
        if (range.end > left) r[p++] = new_Range(left, range.end);
    }
}

// 递归法

void swap(int *x, int *y) {
    int t = *x;
    *x = *y;
    *y = t;
}
void quick_sort_recursive(int arr[], int start, int end) {
    if (start >= end)
        return;
    int mid = arr[end];
    int left = start, right = end - 1;
    while (left < right) {
        while (arr[left] < mid && left < right)
            left++;
        while (arr[right] >= mid && left < right)
            right--;
        swap(&arr[left], &arr[right]);
    }
    if (arr[left] >= arr[end])
        swap(&arr[left], &arr[end]);
    else
        left++;
    if (left)
        quick_sort_recursive(arr, start, left - 1);
    quick_sort_recursive(arr, left + 1, end);
}
void quick_sort(int arr[], int len) {
    quick_sort_recursive(arr, 0, len - 1);
}
```

C++
sort(a,a + n);// 排序a[0]-a[n-1]的所有数.

```C++
// 迭代法
struct Range {
    int start, end;
    Range(int s = 0, int e = 0) {
        start = s, end = e;
    }
};
template <typename T> // 整數或浮點數皆可使用,若要使用物件(class)時必須設定"小於"(<), "大於"(>), "不小於"(>=)的運算子功能
void quick_sort(T arr[], const int len) {
    if (len <= 0)
        return; // 避免len等於負值時宣告堆疊陣列當機
    // r[]模擬堆疊,p為數量,r[p++]為push,r[--p]為pop且取得元素
    Range r[len];
    int p = 0;
    r[p++] = Range(0, len - 1);
    while (p) {
        Range range = r[--p];
        if (range.start >= range.end)
            continue;
        T mid = arr[range.end];
        int left = range.start, right = range.end - 1;
        while (left < right) {
            while (arr[left] < mid && left < right) left++;
            while (arr[right] >= mid && left < right) right--;
            std::swap(arr[left], arr[right]);
        }
        if (arr[left] >= arr[range.end])
            std::swap(arr[left], arr[range.end]);
        else
            left++;
        r[p++] = Range(range.start, left - 1);
        r[p++] = Range(left + 1, range.end);
    }
}

// 递归法

template <typename T>
void quick_sort_recursive(T arr[], int start, int end) {
    if (start >= end)
        return;
    T mid = arr[end];
    int left = start, right = end - 1;
    while (left < right) { //在整个范围内搜寻比枢纽元值小或大的元素, 然后将左侧元素与右侧元素交换
        while (arr[left] < mid && left < right) //试图在左侧找到一个比枢纽元更大的元素
            left++;
        while (arr[right] >= mid && left < right) //试图在右侧找到一个比枢纽元更小的元素
            right--;
        std::swap(arr[left], arr[right]); //交换元素
    }
    if (arr[left] >= arr[end])
        std::swap(arr[left], arr[end]);
    else
        left++;
    quick_sort_recursive(arr, start, left - 1);
    quick_sort_recursive(arr, left + 1, end);
}
template <typename T> //整數或浮點數皆可使用,若要使用物件(class)時必須設定"小於"(<), "大於"(>), "不小於"(>=)的運算子功能
void quick_sort(T arr[], int len) {
    quick_sort_recursive(arr, 0, len - 1);
}
```


## 7 堆排序 Heap Sort

堆排序(Heapsort)是指利用堆这种数据结构所设计的一种排序算法. 堆积是一个近似完全二叉树的结构, 并同时满足堆积的性质:即子结点的键值或索引总是小于(或者大于)它的父节点.   
堆排序可以说是一种利用堆的概念来排序的选择排序. 分为两种方法:   
大顶堆:每个节点的值都大于或等于其子节点的值, 在堆排序算法中用于升序排列;  
小顶堆:每个节点的值都小于或等于其子节点的值, 在堆排序算法中用于降序排列;  
堆排序的平均时间复杂度为 Ο(nlogn). 
1. 算法步骤
创建一个堆 H[0……n-1];
把堆首(最大值)和堆尾互换;
把堆的尺寸缩小 1, 并调用 shift_down(0), 目的是把新的数组顶端数据调整到相应位置;
重复步骤 2, 直到堆的尺寸为 1. 
2. 动图演示  
[![堆排序](https://www.runoob.com/wp-content/uploads/2019/03/heapSort.gif)](https://www.runoob.com/wp-content/uploads/2019/03/heapSort.gif)
[![堆排序](https://www.runoob.com/wp-content/uploads/2019/03/Sorting_heapsort_anim.gif)](https://www.runoob.com/wp-content/uploads/2019/03/Sorting_heapsort_anim.gif)
[![堆排序算法](https://www.runoob.com/wp-content/uploads/2014/08/10dalunce-7232.gif)](https://www.runoob.com/wp-content/uploads/2014/08/10dalunce-7232.gif)
[![堆排序算法](https://www.runoob.com/wp-content/uploads/2015/09/66606)](https://www.runoob.com/wp-content/uploads/2015/09/66606)
[![堆排序算法](https://www.runoob.com/wp-content/uploads/2015/09/77707)](https://www.runoob.com/wp-content/uploads/2015/09/77707)


3. 代码实现

JavaScript
```JavaScript
var len;    // 因为声明的多个函数都需要数据长度, 所以把len设置成为全局变量
function buildMaxHeap(arr) {   // 建立大顶堆
    len = arr.length;
    for (var i = Math.floor(len/2); i >= 0; i--) {
        heapify(arr, i);
    }
}
function heapify(arr, i) {     // 堆调整
    var left = 2 * i + 1,
        right = 2 * i + 2,
        largest = i;
    if (left < len && arr[left] > arr[largest]) {
        largest = left;
    }
    if (right < len && arr[right] > arr[largest]) {
        largest = right;
    }
    if (largest != i) {
        swap(arr, i, largest);
        heapify(arr, largest);
    }
}
function swap(arr, i, j) {
    var temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}
function heapSort(arr) {
    buildMaxHeap(arr);
    for (var i = arr.length-1; i > 0; i--) {
        swap(arr, 0, i);
        len--;
        heapify(arr, 0);
    }
    return arr;
}
```

Python
```Python
def buildMaxHeap(arr):
    import math
    for i in range(math.floor(len(arr)/2),-1,-1):
        heapify(arr,i)
def heapify(arr, i):
    left = 2*i+1
    right = 2*i+2
    largest = i
    if left < arrLen and arr[left] > arr[largest]:
        largest = left
    if right < arrLen and arr[right] > arr[largest]:
        largest = right
    if largest != i:
        swap(arr, i, largest)
        heapify(arr, largest)
def swap(arr, i, j):
    arr[i], arr[j] = arr[j], arr[i]
def heapSort(arr):
    global arrLen
    arrLen = len(arr)
    buildMaxHeap(arr)
    for i in range(len(arr)-1,0,-1):
        swap(arr,0,i)
        arrLen -=1
        heapify(arr, 0)
    return arr
```

Go
```Go
func heapSort(arr []int) []int {
        arrLen := len(arr)
        buildMaxHeap(arr, arrLen)
        for i := arrLen - 1; i >= 0; i-- {
                swap(arr, 0, i)
                arrLen -= 1
                heapify(arr, 0, arrLen)
        }
        return arr
}
func buildMaxHeap(arr []int, arrLen int) {
        for i := arrLen / 2; i >= 0; i-- {
                heapify(arr, i, arrLen)
        }
}
func heapify(arr []int, i, arrLen int) {
        left := 2*i + 1
        right := 2*i + 2
        largest := i
        if left < arrLen && arr[left] > arr[largest] {
                largest = left
        }
        if right < arrLen && arr[right] > arr[largest] {
                largest = right
        }
        if largest != i {
                swap(arr, i, largest)
                heapify(arr, largest, arrLen)
        }
}
func swap(arr []int, i, j int) {
        arr[i], arr[j] = arr[j], arr[i]
}
```

Java
```Java
public class HeapSort implements IArraySort {
    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝, 不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);
        int len = arr.length;
        buildMaxHeap(arr, len);
        for (int i = len - 1; i > 0; i--) {
            swap(arr, 0, i);
            len--;
            heapify(arr, 0, len);
        }
        return arr;
    }
    private void buildMaxHeap(int[] arr, int len) {
        for (int i = (int) Math.floor(len / 2); i >= 0; i--) {
            heapify(arr, i, len);
        }
    }
    private void heapify(int[] arr, int i, int len) {
        int left = 2 * i + 1;
        int right = 2 * i + 2;
        int largest = i;
        if (left < len && arr[left] > arr[largest]) {
            largest = left;
        }
        if (right < len && arr[right] > arr[largest]) {
            largest = right;
        }
        if (largest != i) {
            swap(arr, i, largest);
            heapify(arr, largest, len);
        }
    }
    private void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}

//////////////////////////

public static void MakeMinHeap(int a[], int n){
 for(int i=(n-1)/2 ; i>=0 ; i--){
     MinHeapFixdown(a,i,n);
 }
}
//从i节点开始调整,n为节点总数 从0开始计算 i节点的子节点为 2*i+1, 2*i+2  
public static void MinHeapFixdown(int a[],int i,int n){

   int j = 2*i+1; //子节点
   int temp = 0;

   while(j<n){
       //在左右子节点中寻找最小的
       if(j+1<n && a[j+1]<a[j]){  
           j++;
       }

       if(a[i] <= a[j])
           break;

       //较大节点下移
       temp = a[i];
       a[i] = a[j];
       a[j] = temp;

       i = j;
       j = 2*i+1;
   }
}

public static void MinHeap_Sort(int a[],int n){
  int temp = 0;
  MakeMinHeap(a,n);

  for(int i=n-1;i>0;i--){
      temp = a[0];
      a[0] = a[i];
      a[i] = temp;
      MinHeapFixdown(a,0,i);
  }    
}

```

PHP
```PHP
function buildMaxHeap(&$arr)
{
    global $len;
    for ($i = floor($len/2); $i >= 0; $i--) {
        heapify($arr, $i);
    }
}
function heapify(&$arr, $i)
{
    global $len;
    $left = 2 * $i + 1;
    $right = 2 * $i + 2;
    $largest = $i;
    if ($left < $len && $arr[$left] > $arr[$largest]) {
        $largest = $left;
    }
    if ($right < $len && $arr[$right] > $arr[$largest]) {
        $largest = $right;
    }
    if ($largest != $i) {
        swap($arr, $i, $largest);
        heapify($arr, $largest);
    }
}
function swap(&$arr, $i, $j)
{
    $temp = $arr[$i];
    $arr[$i] = $arr[$j];
    $arr[$j] = $temp;
}
function heapSort($arr) {
    global $len;
    $len = count($arr);
    buildMaxHeap($arr);
    for ($i = count($arr) - 1; $i > 0; $i--) {
        swap($arr, 0, $i);
        $len--;
        heapify($arr, 0);
    }
    return $arr;
}
```

C
```C
#include <stdio.h>
#include <stdlib.h>
void swap(int *a, int *b) {
    int temp = *b;
    *b = *a;
    *a = temp;
}
void max_heapify(int arr[], int start, int end) {
    // 建立父節點指標和子節點指標
    int dad = start;
    int son = dad * 2 + 1;
    while (son <= end) { // 若子節點指標在範圍內才做比較
        if (son + 1 <= end && arr[son] < arr[son + 1]) // 先比較兩個子節點大小, 選擇最大的
            son++;
        if (arr[dad] > arr[son]) //如果父節點大於子節點代表調整完畢, 直接跳出函數
            return;
        else { // 否則交換父子內容再繼續子節點和孫節點比較
            swap(&arr[dad], &arr[son]);
            dad = son;
            son = dad * 2 + 1;
        }
    }
}
void heap_sort(int arr[], int len) {
    int i;
    // 初始化, i從最後一個父節點開始調整
    for (i = len / 2 - 1; i >= 0; i--)
        max_heapify(arr, i, len - 1);
    // 先將第一個元素和已排好元素前一位做交換, 再重新調整, 直到排序完畢
    for (i = len - 1; i > 0; i--) {
        swap(&arr[0], &arr[i]);
        max_heapify(arr, 0, i - 1);
    }
}
int main() {
    int arr[] = { 3, 5, 3, 0, 8, 6, 1, 5, 8, 6, 2, 4, 9, 4, 7, 0, 1, 8, 9, 7, 3, 1, 2, 5, 9, 7, 4, 0, 2, 6 };
    int len = (int) sizeof(arr) / sizeof(*arr);
    heap_sort(arr, len);
    int i;
    for (i = 0; i < len; i++)
        printf("%d ", arr[i]);
    printf("\n");
    return 0;
}
```

C++
```C++
#include <iostream>
#include <algorithm>
using namespace std;
void max_heapify(int arr[], int start, int end) {
    // 建立父節點指標和子節點指標
    int dad = start;
    int son = dad * 2 + 1;
    while (son <= end) { // 若子節點指標在範圍內才做比較
        if (son + 1 <= end && arr[son] < arr[son + 1]) // 先比較兩個子節點大小, 選擇最大的
            son++;
        if (arr[dad] > arr[son]) // 如果父節點大於子節點代表調整完畢, 直接跳出函數
            return;
        else { // 否則交換父子內容再繼續子節點和孫節點比較
            swap(arr[dad], arr[son]);
            dad = son;
            son = dad * 2 + 1;
        }
    }
}
void heap_sort(int arr[], int len) {
    // 初始化, i從最後一個父節點開始調整
    for (int i = len / 2 - 1; i >= 0; i--)
        max_heapify(arr, i, len - 1);
    // 先將第一個元素和已经排好的元素前一位做交換, 再從新調整(刚调整的元素之前的元素), 直到排序完畢
    for (int i = len - 1; i > 0; i--) {
        swap(arr[0], arr[i]);
        max_heapify(arr, 0, i - 1);
    }
}
int main() {
    int arr[] = { 3, 5, 3, 0, 8, 6, 1, 5, 8, 6, 2, 4, 9, 4, 7, 0, 1, 8, 9, 7, 3, 1, 2, 5, 9, 7, 4, 0, 2, 6 };
    int len = (int) sizeof(arr) / sizeof(*arr);
    heap_sort(arr, len);
    for (int i = 0; i < len; i++)
        cout << arr[i] << ' ';
    cout << endl;
    return 0;
}
```

8 计数排序

计数排序的核心在于将输入的数据值转化为键存储在额外开辟的数组空间中. 作为一种线性时间复杂度的排序, 计数排序要求输入的数据必须是有确定范围的整数. 
1. 计数排序的特征
当输入的元素是 n 个 0 到 k 之间的整数时, 它的运行时间是 Θ(n + k). 计数排序不是比较排序, 排序的速度快于任何比较排序算法. 
由于用来计数的数组C的长度取决于待排序数组中数据的范围(等于待排序数组的最大值与最小值的差加上1), 这使得计数排序对于数据范围很大的数组, 需要大量时间和内存. 例如:计数排序是用来排序0到100之间的数字的最好的算法, 但是它不适合按字母顺序排序人名. 但是, 计数排序可以用在基数排序中的算法来排序数据范围很大的数组. 
通俗地理解, 例如有 10 个年龄不同的人, 统计出有 8 个人的年龄比 A 小, 那 A 的年龄就排在第 9 位,用这个方法可以得到其他每个人的位置,也就排好了序. 当然, 年龄有重复时需要特殊处理(保证稳定性), 这就是为什么最后要反向填充目标数组, 以及将每个数字的统计减去 1 的原因. 
 算法的步骤如下:
(1)找出待排序的数组中最大和最小的元素
(2)统计数组中每个值为i的元素出现的次数, 存入数组C的第i项
(3)对所有的计数累加(从C中的第一个元素开始, 每一项和前一项相加)
(4)反向填充目标数组:将每个元素i放在新数组的第C(i)项, 每放一个元素就将C(i)减去1
2. 动图演示  
[![计数排序](https://www.runoob.com/wp-content/uploads/2019/03/countingSort.gif)](https://www.runoob.com/wp-content/uploads/2019/03/countingSort.gif)

3. 代码实现

JavaScript
```JavaScript
function countingSort(arr, maxValue) {
    var bucket = new Array(maxValue+1),
        sortedIndex = 0;
        arrLen = arr.length,
        bucketLen = maxValue + 1;
    for (var i = 0; i < arrLen; i++) {
        if (!bucket[arr[i]]) {
            bucket[arr[i]] = 0;
        }
        bucket[arr[i]]++;
    }
    for (var j = 0; j < bucketLen; j++) {
        while(bucket[j] > 0) {
            arr[sortedIndex++] = j;
            bucket[j]--;
        }
    }
    return arr;
}
```

Python
```Python
def countingSort(arr, maxValue):
    bucketLen = maxValue+1
    bucket = [0]*bucketLen
    sortedIndex =0
    arrLen = len(arr)
    for i in range(arrLen):
        if not bucket[arr[i]]:
            bucket[arr[i]]=0
        bucket[arr[i]]+=1
    for j in range(bucketLen):
        while bucket[j]>0:
            arr[sortedIndex] = j
            sortedIndex+=1
            bucket[j]-=1
    return arr
```

Go
```Go
func countingSort(arr []int, maxValue int) []int {
        bucketLen := maxValue + 1
        bucket := make([]int, bucketLen) // 初始为0的数组
        sortedIndex := 0
        length := len(arr)
        for i := 0; i < length; i++ {
                bucket[arr[i]] += 1
        }
        for j := 0; j < bucketLen; j++ {
                for bucket[j] > 0 {
                        arr[sortedIndex] = j
                        sortedIndex += 1
                        bucket[j] -= 1
                }
        }
        return arr
}
```

Java
```Java
public class CountingSort implements IArraySort {
    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝, 不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);
        int maxValue = getMaxValue(arr);
        return countingSort(arr, maxValue);
    }
    private int[] countingSort(int[] arr, int maxValue) {
        int bucketLen = maxValue + 1;
        int[] bucket = new int[bucketLen];
        for (int value : arr) {
            bucket[value]++;
        }
        int sortedIndex = 0;
        for (int j = 0; j < bucketLen; j++) {
            while (bucket[j] > 0) {
                arr[sortedIndex++] = j;
                bucket[j]--;
            }
        }
        return arr;
    }
    private int getMaxValue(int[] arr) {
        int maxValue = arr[0];
        for (int value : arr) {
            if (maxValue < value) {
                maxValue = value;
            }
        }
        return maxValue;
    }
}
```

PHP
```PHP
function countingSort($arr, $maxValue = null)
{
    if ($maxValue === null) {
        $maxValue = max($arr);
    }
    for ($m = 0; $m < $maxValue + 1; $m++) {
        $bucket[] = null;
    }
    $arrLen = count($arr);
    for ($i = 0; $i < $arrLen; $i++) {
        if (!array_key_exists($arr[$i], $bucket)) {
            $bucket[$arr[$i]] = 0;
        }
        $bucket[$arr[$i]]++;
    }
    $sortedIndex = 0;
    foreach ($bucket as $key => $len) {
        if($len !== null){
            for($j = 0; $j < $len; $j++){
                $arr[$sortedIndex++] = $key;
            }
        }
    }
    return $arr;
}
```

C
```C
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
void print_arr(int *arr, int n) {
        int i;
        printf("%d", arr[0]);
        for (i = 1; i < n; i++)
                printf(" %d", arr[i]);
        printf("\n");
}
void counting_sort(int *ini_arr, int *sorted_arr, int n) {
        int *count_arr = (int *) malloc(sizeof(int) * 100);
        int i, j, k;
        for (k = 0; k < 100; k++)
                count_arr[k] = 0;
        for (i = 0; i < n; i++)
                count_arr[ini_arr[i]]++;
        for (k = 1; k < 100; k++)
                count_arr[k] += count_arr[k - 1];
        for (j = n; j > 0; j--)
                sorted_arr[--count_arr[ini_arr[j - 1]]] = ini_arr[j - 1];
        free(count_arr);
}
int main(int argc, char **argv) {
        int n = 10;
        int i;
        int *arr = (int *) malloc(sizeof(int) * n);
        int *sorted_arr = (int *) malloc(sizeof(int) * n);
        srand(time(0));
        for (i = 0; i < n; i++)
                arr[i] = rand() % 100;
        printf("ini_array: ");
        print_arr(arr, n);
        counting_sort(arr, sorted_arr, n);
        printf("sorted_array: ");
        print_arr(sorted_arr, n);
        free(arr);
        free(sorted_arr);
        return 0;
}
```


## 9 桶排序 Bin Sort

桶排序bucket Sort是计数排序的升级版. 它利用了函数的映射关系, 高效与否的关键就在于这个映射函数的确定. 为了使桶排序更加高效, 我们需要做到这两点:
在额外空间充足的情况下, 尽量增大桶的数量
使用的映射函数能够将输入的 N 个数据均匀的分配到 K 个桶中
同时, 对于桶中元素的排序, 选择何种比较排序算法对于性能的影响至关重要. 

BinSort
基本思想:
BinSort想法非常简单, 首先创建数组A[MaxValue];然后将每个数放到相应的位置上(例如17放在下标17的数组位置);最后遍历数组, 即为排序后的结果.   
[![桶排序](https://www.runoob.com/wp-content/uploads/2015/09/88808)](https://www.runoob.com/wp-content/uploads/2015/09/88808)  
BinSort
问题: 当序列中存在较大值时, BinSort 的排序方法会浪费大量的空间开销. 

1. 什么时候最快
当输入的数据可以均匀的分配到每一个桶中. 
2. 什么时候最慢
当输入的数据被分配到了同一个桶中. 

3. 示意图  
元素分布在桶中:  

[![桶排序](https://www.runoob.com/wp-content/uploads/2019/03/Bucket_sort_1.svg_.png)](https://www.runoob.com/wp-content/uploads/2019/03/Bucket_sort_1.svg_.png)

然后, 元素在每个桶中排序:  

[![桶排序](https://www.runoob.com/wp-content/uploads/2019/03/Bucket_sort_2.svg_.png)](https://www.runoob.com/wp-content/uploads/2019/03/Bucket_sort_2.svg_.png)

4. 代码实现

JavaScript
```JavaScript
function bucketSort(arr, bucketSize) {
    if (arr.length === 0) {
      return arr;
    }
    var i;
    var minValue = arr[0];
    var maxValue = arr[0];
    for (i = 1; i < arr.length; i++) {
      if (arr[i] < minValue) {
          minValue = arr[i];                // 输入数据的最小值
      } else if (arr[i] > maxValue) {
          maxValue = arr[i];                // 输入数据的最大值
      }
    }
    //桶的初始化
    var DEFAULT_BUCKET_SIZE = 5;            // 设置桶的默认数量为5
    bucketSize = bucketSize || DEFAULT_BUCKET_SIZE;
    var bucketCount = Math.floor((maxValue - minValue) / bucketSize) + 1;  
    var buckets = new Array(bucketCount);
    for (i = 0; i < buckets.length; i++) {
        buckets[i] = [];
    }
    //利用映射函数将数据分配到各个桶中
    for (i = 0; i < arr.length; i++) {
        buckets[Math.floor((arr[i] - minValue) / bucketSize)].push(arr[i]);
    }
    arr.length = 0;
    for (i = 0; i < buckets.length; i++) {
        insertionSort(buckets[i]);                      // 对每个桶进行排序, 这里使用了插入排序
        for (var j = 0; j < buckets[i].length; j++) {
            arr.push(buckets[i][j]);                      
        }
    }
    return arr;
}
```

Java
```Java
public class BucketSort implements IArraySort {
    private static final InsertSort insertSort = new InsertSort();
    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝, 不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);
        return bucketSort(arr, 5);
    }
    private int[] bucketSort(int[] arr, int bucketSize) throws Exception {
        if (arr.length == 0) {
            return arr;
        }
        int minValue = arr[0];
        int maxValue = arr[0];
        for (int value : arr) {
            if (value < minValue) {
                minValue = value;
            } else if (value > maxValue) {
                maxValue = value;
            }
        }
        int bucketCount = (int) Math.floor((maxValue - minValue) / bucketSize) + 1;
        int[][] buckets = new int[bucketCount][0];
        // 利用映射函数将数据分配到各个桶中
        for (int i = 0; i < arr.length; i++) {
            int index = (int) Math.floor((arr[i] - minValue) / bucketSize);
            buckets[index] = arrAppend(buckets[index], arr[i]);
        }
        int arrIndex = 0;
        for (int[] bucket : buckets) {
            if (bucket.length <= 0) {
                continue;
            }
            // 对每个桶进行排序, 这里使用了插入排序
            bucket = insertSort.sort(bucket);
            for (int value : bucket) {
                arr[arrIndex++] = value;
            }
        }
        return arr;
    }
    /**
     * 自动扩容, 并保存数据
     *
     * @param arr
     * @param value
     */
    private int[] arrAppend(int[] arr, int value) {
        arr = Arrays.copyOf(arr, arr.length + 1);
        arr[arr.length - 1] = value;
        return arr;
    }
}
```

PHP
```PHP
function bucketSort($arr, $bucketSize = 5)
{
    if (count($arr) === 0) {
      return $arr;
    }
    $minValue = $arr[0];
    $maxValue = $arr[0];
    for ($i = 1; $i < count($arr); $i++) {
      if ($arr[$i] < $minValue) {
          $minValue = $arr[$i];
      } else if ($arr[$i] > $maxValue) {
          $maxValue = $arr[$i];
      }
    }
    $bucketCount = floor(($maxValue - $minValue) / $bucketSize) + 1;
    $buckets = array();
    for ($i = 0; $i < $bucketCount; $i++) {
        $buckets[$i] = [];
    }
    for ($i = 0; $i < count($arr); $i++) {
        $buckets[floor(($arr[$i] - $minValue) / $bucketSize)][] = $arr[$i];
    }
    $arr = array();
    for ($i = 0; $i < count($buckets); $i++) {
        $bucketTmp = $buckets[$i];
        sort($bucketTmp);
        for ($j = 0; $j < count($bucketTmp); $j++) {
            $arr[] = $bucketTmp[$j];
        }
    }
    return $arr;
}
```

C++
```C++
#include<iterator>
#include<iostream>
#include<vector>
using namespace std;
const int BUCKET_NUM = 10;
struct ListNode{
        explicit ListNode(int i=0):mData(i),mNext(NULL){}
        ListNode* mNext;
        int mData;
};
ListNode* insert(ListNode* head,int val){
        ListNode dummyNode;
        ListNode *newNode = new ListNode(val);
        ListNode *pre,*curr;
        dummyNode.mNext = head;
        pre = &dummyNode;
        curr = head;
        while(NULL!=curr && curr->mData<=val){
                pre = curr;
                curr = curr->mNext;
        }
        newNode->mNext = curr;
        pre->mNext = newNode;
        return dummyNode.mNext;
}
ListNode* Merge(ListNode *head1,ListNode *head2){
        ListNode dummyNode;
        ListNode *dummy = &dummyNode;
        while(NULL!=head1 && NULL!=head2){
                if(head1->mData <= head2->mData){
                        dummy->mNext = head1;
                        head1 = head1->mNext;
                }else{
                        dummy->mNext = head2;
                        head2 = head2->mNext;
                }
                dummy = dummy->mNext;
        }
        if(NULL!=head1) dummy->mNext = head1;
        if(NULL!=head2) dummy->mNext = head2;
        return dummyNode.mNext;
}
void BucketSort(int n,int arr[]){
        vector<ListNode*> buckets(BUCKET_NUM,(ListNode*)(0));
        for(int i=0;i<n;++i){
                int index = arr[i]/BUCKET_NUM;
                ListNode *head = buckets.at(index);
                buckets.at(index) = insert(head,arr[i]);
        }
        ListNode *head = buckets.at(0);
        for(int i=1;i<BUCKET_NUM;++i){
                head = Merge(head,buckets.at(i));
        }
        for(int i=0;i<n;++i){
                arr[i] = head->mData;
                head = head->mNext;
        }
}
```


## 10 基数排序 Radix Sort

基数排序(Radix Sort)是一种非比较型整数排序算法, 其原理是将整数按位数切割成不同的数字, 然后按每个位数分别比较. 由于整数也可以表达字符串(比如名字或日期)和特定格式的浮点数, 所以基数排序也不是只能使用于整数. 
1. 基数排序 vs 计数排序 vs 桶排序
基数排序有两种方法:
这三种排序算法都利用了桶的概念, 但对桶的使用方法上有明显差异:
基数排序:根据键值的每位数字来分配桶;
计数排序:每个桶只存储单一键值;
桶排序:每个桶存储一定范围的数值;
2. LSD 基数排序动图演示

[![基数排序](https://www.runoob.com/wp-content/uploads/2019/03/radixSort.gif)](https://www.runoob.com/wp-content/uploads/2019/03/radixSort.gif)
[![基数排序](https://www.runoob.com/wp-content/uploads/2015/09/99909)](https://www.runoob.com/wp-content/uploads/2015/09/99909)

3. 代码实现
JavaScript
```JavaScript
//LSD Radix Sort
var counter = [];
function radixSort(arr, maxDigit) {
    var mod = 10;
    var dev = 1;
    for (var i = 0; i < maxDigit; i++, dev *= 10, mod *= 10) {
        for(var j = 0; j < arr.length; j++) {
            var bucket = parseInt((arr[j] % mod) / dev);
            if(counter[bucket]==null) {
                counter[bucket] = [];
            }
            counter[bucket].push(arr[j]);
        }
        var pos = 0;
        for(var j = 0; j < counter.length; j++) {
            var value = null;
            if(counter[j]!=null) {
                while ((value = counter[j].shift()) != null) {
                      arr[pos++] = value;
                }
          }
        }
    }
    return arr;
}
```

Java
```Java
/**
 * 基数排序
 * 考虑负数的情况还可以参考: https://code.i-harness.com/zh-CN/q/e98fa9
 */
public class RadixSort implements IArraySort {
    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝, 不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);
        int maxDigit = getMaxDigit(arr);
        return radixSort(arr, maxDigit);
    }
    /**
     * 获取最高位数
     */
    private int getMaxDigit(int[] arr) {
        int maxValue = getMaxValue(arr);
        return getNumLenght(maxValue);
    }
    private int getMaxValue(int[] arr) {
        int maxValue = arr[0];
        for (int value : arr) {
            if (maxValue < value) {
                maxValue = value;
            }
        }
        return maxValue;
    }
    protected int getNumLenght(long num) {
        if (num == 0) {
            return 1;
        }
        int lenght = 0;
        for (long temp = num; temp != 0; temp /= 10) {
            lenght++;
        }
        return lenght;
    }
    private int[] radixSort(int[] arr, int maxDigit) {
        int mod = 10;
        int dev = 1;
        for (int i = 0; i < maxDigit; i++, dev *= 10, mod *= 10) {
            // 考虑负数的情况, 这里扩展一倍队列数, 其中 [0-9]对应负数, [10-19]对应正数 (bucket + 10)
            int[][] counter = new int[mod * 2][0];
            for (int j = 0; j < arr.length; j++) {
                int bucket = ((arr[j] % mod) / dev) + mod;
                counter[bucket] = arrayAppend(counter[bucket], arr[j]);
            }
            int pos = 0;
            for (int[] bucket : counter) {
                for (int value : bucket) {
                    arr[pos++] = value;
                }
            }
        }
        return arr;
    }
    /**
     * 自动扩容, 并保存数据
     *
     * @param arr
     * @param value
     */
    private int[] arrayAppend(int[] arr, int value) {
        arr = Arrays.copyOf(arr, arr.length + 1);
        arr[arr.length - 1] = value;
        return arr;
    }
}

/////////////////////////////

public static void RadixSort(int A[],int temp[],int n,int k,int r,int cnt[]){

   //A:原数组
   //temp:临时数组
   //n:序列的数字个数
   //k:最大的位数2
   //r:基数10
   //cnt:存储bin[i]的个数

   for(int i=0 , rtok=1; i<k ; i++ ,rtok = rtok*r){

       //初始化
       for(int j=0;j<r;j++){
           cnt[j] = 0;
       }
       //计算每个箱子的数字个数
       for(int j=0;j<n;j++){
           cnt[(A[j]/rtok)%r]++;
       }
       //cnt[j]的个数修改为前j个箱子一共有几个数字
       for(int j=1;j<r;j++){
           cnt[j] = cnt[j-1] + cnt[j];
       }
       for(int j = n-1;j>=0;j--){      //重点理解
           cnt[(A[j]/rtok)%r]--;
           temp[cnt[(A[j]/rtok)%r]] = A[j];
       }
       for(int j=0;j<n;j++){
           A[j] = temp[j];
       }
   }
}

```

PHP
```PHP
function radixSort($arr, $maxDigit = null)
{
    if ($maxDigit === null) {
        $maxDigit = max($arr);
    }
    $counter = [];
    for ($i = 0; $i < $maxDigit; $i++) {
        for ($j = 0; $j < count($arr); $j++) {
            preg_match_all('/\d/', (string) $arr[$j], $matches);
            $numArr = $matches[0];
            $lenTmp = count($numArr);
            $bucket = array_key_exists($lenTmp - $i - 1, $numArr)
                ? intval($numArr[$lenTmp - $i - 1])
                : 0;
            if (!array_key_exists($bucket, $counter)) {
                $counter[$bucket] = [];
            }
            $counter[$bucket][] = $arr[$j];
        }
        $pos = 0;
        for ($j = 0; $j < count($counter); $j++) {
            $value = null;
            if ($counter[$j] !== null) {
                while (($value = array_shift($counter[$j])) !== null) {
                    $arr[$pos++] = $value;
                }
          }
        }
    }
    return $arr;
}
```

C++
```C++
int maxbit(int data[], int n) //辅助函数, 求数据的最大位数
{
    int maxData = data[0];              ///< 最大数
    /// 先求出最大数, 再求其位数, 这样有原先依次每个数判断其位数, 稍微优化点. 
    for (int i = 1; i < n; ++i)
    {
        if (maxData < data[i])
            maxData = data[i];
    }
    int d = 1;
    int p = 10;
    while (maxData >= p)
    {
        //p *= 10; // Maybe overflow
        maxData /= 10;
        ++d;
    }
    return d;
/*    int d = 1; //保存最大的位数
    int p = 10;
    for(int i = 0; i < n; ++i)
    {
        while(data[i] >= p)
        {
            p *= 10;
            ++d;
        }
    }
    return d;*/
}
void radixsort(int data[], int n) //基数排序
{
    int d = maxbit(data, n);
    int *tmp = new int[n];
    int *count = new int[10]; //计数器
    int i, j, k;
    int radix = 1;
    for(i = 1; i <= d; i++) //进行d次排序
    {
        for(j = 0; j < 10; j++)
            count[j] = 0; //每次分配前清空计数器
        for(j = 0; j < n; j++)
        {
            k = (data[j] / radix) % 10; //统计每个桶中的记录数
            count[k]++;
        }
        for(j = 1; j < 10; j++)
            count[j] = count[j - 1] + count[j]; //将tmp中的位置依次分配给每个桶
        for(j = n - 1; j >= 0; j--) //将所有桶中记录依次收集到tmp中
        {
            k = (data[j] / radix) % 10;
            tmp[count[k] - 1] = data[j];
            count[k]--;
        }
        for(j = 0; j < n; j++) //将临时数组的内容复制到data中
            data[j] = tmp[j];
        radix = radix * 10;
    }
    delete []tmp;
    delete []count;
}
```

C
```C
#include<stdio.h>
#define MAX 20
//#define SHOWPASS
#define BASE 10
void print(int *a, int n) {
  int i;
  for (i = 0; i < n; i++) {
    printf("%d\t", a[i]);
  }
}
void radixsort(int *a, int n) {
  int i, b[MAX], m = a[0], exp = 1;
  for (i = 1; i < n; i++) {
    if (a[i] > m) {
      m = a[i];
    }
  }
  while (m / exp > 0) {
    int bucket[BASE] = { 0 };
    for (i = 0; i < n; i++) {
      bucket[(a[i] / exp) % BASE]++;
    }
    for (i = 1; i < BASE; i++) {
      bucket[i] += bucket[i - 1];
    }
    for (i = n - 1; i >= 0; i--) {
      b[--bucket[(a[i] / exp) % BASE]] = a[i];
    }
    for (i = 0; i < n; i++) {
      a[i] = b[i];
    }
    exp *= BASE;
#ifdef SHOWPASS
    printf("\nPASS   : ");
    print(a, n);
#endif
  }
}
int main() {
  int arr[MAX];
  int i, n;
  printf("Enter total elements (n <= %d) : ", MAX);
  scanf("%d", &n);
  n = n < MAX ? n : MAX;
  printf("Enter %d Elements : ", n);
  for (i = 0; i < n; i++) {
    scanf("%d", &arr[i]);
  }
  printf("\nARRAY  : ");
  print(&arr[0], n);
  radixsort(&arr[0], n);
  printf("\nSORTED : ");
  print(&arr[0], n);
  printf("\n");
  return 0;
}
```

Lua
```Lua
-- 获取表中位数
local maxBit = function (tt)
    local weight = 10;      -- 十進制
    local bit = 1;
    for k, v in pairs(tt) do
        while v >= weight do
            weight = weight * 10;
            bit = bit + 1;  
        end
    end
    return bit;
end
-- 基数排序
local radixSort = function (tt)
    local maxbit = maxBit(tt);
    local bucket = {};
    local temp = {};
    local radix = 1;
    for i = 1, maxbit do
        for j = 1, 10 do
            bucket[j] = 0;      --- 清空桶
        end
        for k, v in pairs(tt) do
            local remainder = math.floor((v / radix)) % 10 + 1;    
            bucket[remainder] = bucket[remainder] + 1;      -- 每個桶數量自動增加1
        end
        for j = 2, 10 do
            bucket[j] = bucket[j - 1] + bucket[j];  -- 每个桶的数量 = 以前桶数量和 + 自个数量
        end
        -- 按照桶的位置, 排序--这个是桶式排序, 必须使用倒序, 因为排序方法是从小到大, 顺序下来, 会出现大的在小的上面清空. 
        for k = #tt, 1, -1 do
            local remainder = math.floor((tt[k] / radix)) % 10 + 1;
            temp[bucket[remainder]] = tt[k];
            bucket[remainder] = bucket[remainder] - 1;
        end
        for k, v in pairs(temp) do
            tt[k] = v;
        end
        radix = radix * 10;
    end
end;
```


## 二分查找算法
二分查找算法是一种在有序数组中查找某一特定元素的搜索算法. 搜素过程从数组的中间元素开始, 如果中间元素正好是要查找的元素, 则搜 素过程结束;如果某一特定元素大于或者小于中间元素, 则在数组大于或小于中间元素的那一半中查找, 而且跟开始一样从中间元素开始比较. 如果在某一步骤数组 为空, 则代表找不到. 这种搜索算法每一次比较都使搜索范围缩小一半. 折半搜索每次把搜索区域减少一半, 时间复杂度为Ο(logn) . 

## BFPRT(线性查找算法)
BFPRT算法解决的问题十分经典, 即从某n个元素的序列中选出第k大(第k小)的元素, 通过巧妙的分 析, BFPRT可以保证在最坏情况下仍为线性时间复杂度. 该算法的思想与快速排序思想相似, 当然, 为使得算法在最坏情况下, 依然能达到o(n)的时间复杂 度, 五位算法作者做了精妙的处理.   
算法步骤:
1. 将n个元素每5个一组, 分成n/5(上界)组. 
2. 取出每一组的中位数, 任意排序方法, 比如插入排序. 
3. 递归的调用selection算法查找上一步中所有中位数的中位数, 设为x, 偶数个中位数的情况下设定为选取中间小的一个. 
4. 用x来分割数组, 设小于等于x的个数为k, 大于x的个数即为n-k. 
5. 若i==k, 返回x;若i<k, 在小于x的元素中递归查找第i小的元素;若i>k, 在大于x的元素中递归查找第i-k小的元素. 
终止条件:n=1时, 返回的即是i小元素. 

## DFS(深度优先搜索)
深度优先搜索算法(Depth-First-Search), 是搜索算法的一种. 它沿着树的深度遍历树的节点, 尽可能深的搜索树的分 支. 当节点v的所有边都己被探寻过, 搜索将回溯到发现节点v的那条边的起始节点. 这一过程一直进行到已发现从源节点可达的所有节点为止. 如果还存在未被发 现的节点, 则选择其中一个作为源节点并重复以上过程, 整个进程反复进行直到所有节点都被访问为止. DFS属于盲目搜索.   
深度优先搜索是图论中的经典算法, 利用深度优先搜索算法可以产生目标图的相应拓扑排序表, 利用拓扑排序表可以方便的解决很多相关的图论问题, 如最大路径问题等等. 一般用堆数据结构来辅助实现DFS算法.   
深度优先遍历图算法步骤:
1. 访问顶点v;
2. 依次从v的未被访问的邻接点出发, 对图进行深度优先遍历;直至图中和v有路径相通的顶点都被访问;
3. 若此时图中尚有顶点未被访问, 则从一个未被访问的顶点出发, 重新进行深度优先遍历, 直到图中所有顶点均被访问过为止.   
上述描述可能比较抽象, 举个实例:  
DFS 在访问图中某一起始顶点 v 后, 由 v 出发, 访问它的任一邻接顶点 w1;再从 w1 出发, 访问与 w1邻 接但还没有访问过的顶点 w2;然后再从 w2 出发, 进行类似的访问, … 如此进行下去, 直至到达所有的邻接顶点都被访问过的顶点 u 为止.   
接着, 退回一步, 退到前一次刚访问过的顶点, 看是否还有其它没有被访问的邻接顶点. 如果有, 则访问此顶点, 之后再从此顶点出发, 进行与前述类似的访问;如果没有, 就再退回一步进行搜索. 重复上述过程, 直到连通图中所有顶点都被访问过为止. 

## BFS(广度优先搜索)
广度优先搜索算法(Breadth-First-Search), 是一种图形搜索算法. 简单的说, BFS是从根节点开始, 沿着树(图)的宽度遍历树(图)的节点. 如果所有节点均被访问, 则算法中止. BFS同样属于盲目搜索. 一般用队列数据结构来辅助实现BFS算法. 
算法步骤:
1. 首先将根节点放入队列中. 
2. 从队列中取出第一个节点, 并检验它是否为目标. 
如果找到目标, 则结束搜寻并回传结果. 
否则将它所有尚未检验过的直接子节点加入队列中. 
3. 若队列为空, 表示整张图都检查过了——亦即图中没有欲搜寻的目标. 结束搜寻并回传"找不到目标". 
4. 重复步骤2.   
[![BFS(广度优先搜索)](https://www.runoob.com/wp-content/uploads/2014/08/10dalunce-7234.gif)](https://www.runoob.com/wp-content/uploads/2014/08/10dalunce-7234.gif)

## Dijkstra算法
戴克斯特拉算法(Dijkstra's algorithm)是由荷兰计算机科学家艾兹赫尔·戴克斯特拉提出. 迪科斯彻算法使用了广度优先搜索解决非负权有向图的单源最短路径问题, 算法最终得到一个最短路径树. 该算法常用于路由算法或者作为其他图算法的一个子模块.   
该算法的输入包含了一个有权重的有向图 G, 以及G中的一个来源顶点 S. 我们以 V 表示 G 中所有顶点的集合. 每一个图中的边, 都是两个顶点所形成的有序元素对. (u, v) 表示从顶点 u 到 v 有路径相连. 我们以 E 表示G中所有边的集合, 而边的权重则由权重函数 w: E → [0, ∞] 定义. 因此, w(u, v) 就是从顶点 u 到顶点 v 的非负权重(weight). 边的权重可以想像成两个顶点之间的距离. 任两点间路径的权重, 就是该路径上所有边的权重总和. 已知有 V 中有顶点 s 及 t, Dijkstra 算法可以找到 s 到 t的最低权重路径(例如, 最短路径). 这个算法也可以在一个图中, 找到从一个顶点 s 到任何其他顶点的最短路径. 对于不含负权的有向图, Dijkstra算法是目前已知的最快的单源最短路径算法.   
算法步骤:
1. 初始时令 S={V0},T={其余顶点}, T中顶点对应的距离值
若存在<v0,vi>, d(V0,Vi)为<v0,vi>弧上的权值
若不存在<v0,vi>, d(V0,Vi)为∞
2. 从T中选取一个其距离值为最小的顶点W且不在S中, 加入S
3. 对其余T中顶点的距离值进行修改:若加进W作中间顶点, 从V0到Vi的距离值缩短, 则修改此距离值
重复上述步骤2, 3, 直到S中包含所有顶点, 即W=Vi为止  
[![Dijkstra算法](https://www.runoob.com/wp-content/uploads/2014/08/10dalunce-7235.gif)](https://www.runoob.com/wp-content/uploads/2014/08/10dalunce-7235.gif)

## 动态规划算法
动态规划(Dynamic programming)是一种在数学, 计算机科学和经济学中使用的, 通过把原问题分解为相对简单的子问题的方式求解复杂问题的方法.  动态规划常常适用于有重叠子问题和最优子结构性质的问题, 动态规划方法所耗时间往往远少于朴素解法.   
动态规划背后的基本思想非常简单. 大致上, 若要解一个给定问题, 我们需要解其不同部分(即子问题), 再合并子问题的解以得出原问题的解.  通常许多 子问题非常相似, 为此动态规划法试图仅仅解决每个子问题一次, 从而减少计算量: 一旦某个给定子问题的解已经算出, 则将其记忆化存储, 以便下次需要同一个 子问题解之时直接查表.  这种做法在重复子问题的数目关于输入的规模呈指数增长时特别有用.   
关于动态规划最经典的问题当属背包问题. 
算法步骤:
1. 最优子结构性质. 如果问题的最优解所包含的子问题的解也是最优的, 我们就称该问题具有最优子结构性质(即满足最优化原理). 最优子结构性质为动态规划算法解决问题提供了重要线索. 
2. 子问题重叠性质. 子问题重叠性质是指在用递归算法自顶向下对问题进行求解时, 每次产生的子问题并不总是新问题, 有些子问题会被重复计算多次.  动态规划算法正是利用了这种子问题的重叠性质, 对每一个子问题只计算一次, 然后将其计算结果保存在一个表格中, 当再次需要计算已经计算过的子问题时, 只是 在表格中简单地查看一下结果, 从而获得较高的效率. 

## 朴素贝叶斯分类算法
朴素贝叶斯分类算法是一种基于贝叶斯定理的简单概率分类算法. 贝叶斯分类的基础是概率推理, 就是在各种条件的存在不确定, 仅知其出现概率的情况下,  如何完成推理和决策任务. 概率推理是与确定性推理相对应的. 而朴素贝叶斯分类器是基于独立假设的, 即假设样本每个特征与其他特征都不相关.   
朴素贝叶斯分类器依靠精确的自然概率模型, 在有监督学习的样本集中能获取得非常好的分类效果. 在许多实际应用中, 朴素贝叶斯模型参数估计使用最大似然估计方法, 换言之朴素贝叶斯模型能工作并没有用到贝叶斯概率或者任何贝叶斯模型. 



