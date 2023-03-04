

# C++标准库常用数据结构

string
vector
list
queue和priority_queue
set
map
stack


# 常见数据结构与算法整理总结
数据结构是以某种形式将数据组织在一起的集合, 它不仅存储数据, 还支持访问和处理数据的操作. 算法是为求解一个问题需要遵循的, 被清楚指定的简单指令的集合. 下面是自己整理的常用数据结构与算法相关内容, 如有错误, 欢迎指出. 
为了便于描述, 文中涉及到的代码部分都是用Java语言编写的, 其实Java本身对常见的几种数据结构, 线性表, 栈, 队列等都提供了较好的实现, 就是我们经常用到的Java集合框架, 有需要的可以阅读这篇文章. 
一, 线性表
  1.数组实现
  2.链表
二, 栈与队列
三, 树与二叉树
  1.树
  2.二叉树基本概念
  3.二叉查找树
  4.平衡二叉树
  5.红黑树
四, 图
五, 总结

## 一, 线性表
线性表是最常用且最简单的一种数据结构, 它是n个数据元素的有限序列. 
实现线性表的方式一般有两种, 一种是使用数组存储线性表的元素, 即用一组连续的存储单元依次存储线性表的数据元素. 另一种是使用链表存储线性表的元素, 即用一组任意的存储单元存储线性表的数据元素(存储单元可以是连续的, 也可以是不连续的). 
数组实现
数组是一种大小固定的数据结构, 对线性表的所有操作都可以通过数组来实现. 虽然数组一旦创建之后, 它的大小就无法改变了, 但是当数组不能再存储线性表中的新元素时, 我们可以创建一个新的大的数组来替换当前数组. 这样就可以使用数组实现动态的数据结构. 
代码1 创建一个更大的数组来替换当前数组
int[] oldArray = new int[10];
int[] newArray = new int[20];
for (int i = 0; i < oldArray.length; i++) {
    newArray[i] = oldArray[i];}
// 也可以使用System.arraycopy方法来实现数组间的复制     // System.arraycopy(oldArray, 0, newArray, 0, oldArray.length);

oldArray = newArray;

代码2 在数组位置index上添加元素e
//oldArray 表示当前存储元素的数组//size 表示当前元素个数public void add(int index, int e) {

    if (index > size || index < 0) {
        System.out.println("位置不合法...");
    }

    //如果数组已经满了 就扩容
    if (size >= oldArray.length) {
        // 扩容函数可参考代码1
    }

    for (int i = size - 1; i >= index; i--) {
        oldArray[i + 1] = oldArray[i];
    }

    //将数组elementData从位置index的所有元素往后移一位
    // System.arraycopy(oldArray, index, oldArray, index + 1,size - index);

    oldArray[index] = e;

    size++;}

上面简单写出了数组实现线性表的两个典型函数, 具体我们可以参考Java里面的ArrayList集合类的源码. 数组实现的线性表优点在于可以通过下标来访问或者修改元素, 比较高效, 主要缺点在于插入和删除的花费开销较大, 比如当在第一个位置前插入一个元素, 那么首先要把所有的元素往后移动一个位置. 为了提高在任意位置添加或者删除元素的效率, 可以采用链式结构来实现线性表. 
链表
链表是一种物理存储单元上非连续, 非顺序的存储结构, 数据元素的逻辑顺序是通过链表中的指针链接次序实现的. 链表由一系列节点组成, 这些节点不必在内存中相连. 每个节点由数据部分Data和链部分Next, Next指向下一个节点, 这样当添加或者删除时, 只需要改变相关节点的Next的指向, 效率很高. 

下面主要用代码来展示链表的一些基本操作, 需要注意的是, 这里主要是以单链表为例, 暂时不考虑双链表和循环链表. 
代码3 链表的节点
class Node<E> {

    E item;
    Node<E> next;

    //构造函数
    Node(E element) {
       this.item = element;
       this.next = null;
   }}

代码4 定义好节点后, 使用前一般是对头节点和尾节点进行初始化
//头节点和尾节点都为空 链表为空
Node<E> head = null;
Node<E> tail = null;

代码5 空链表创建一个新节点
//创建一个新的节点 并让head指向此节点
head = new Node("nodedata1");
//让尾节点也指向此节点
tail = head;

代码6 链表追加一个节点
//创建新节点 同时和最后一个节点连接起来
tail.next = new Node("node1data2");
//尾节点指向新的节点
tail = tail.next;

代码7 顺序遍历链表
Node<String> current = head;while (current != null) {
    System.out.println(current.item);
    current = current.next;}

代码8 倒序遍历链表
static void printListRev(Node<String> head) {//倒序遍历链表主要用了递归的思想
    if (head != null) {
        printListRev(head.next);
        System.out.println(head.item);
    }}

代码 单链表反转
//单链表反转 主要是逐一改变两个节点间的链接关系来完成static Node<String> revList(Node<String> head) {

    if (head == null) {
        return null;
    }

    Node<String> nodeResult = null;

    Node<String> nodePre = null;
    Node<String> current = head;

    while (current != null) {

        Node<String> nodeNext = current.next;

        if (nodeNext == null) {
            nodeResult = current;
        }

        current.next = nodePre;
        nodePre = current;
        current = nodeNext;
    }

    return nodeResult;}

上面的几段代码主要展示了链表的几个基本操作, 还有很多像获取指定元素, 移除元素等操作大家可以自己完成, 写这些代码的时候一定要理清节点之间关系, 这样才不容易出错. 
链表的实现还有其它的方式, 常见的有循环单链表, 双向链表, 循环双向链表.  循环单链表 主要是链表的最后一个节点指向第一个节点, 整体构成一个链环.  双向链表 主要是节点中包含两个指针部分, 一个指向前驱元, 一个指向后继元, JDK中LinkedList集合类的实现就是双向链表. ** 循环双向链表** 是最后一个节点指向第一个节点. 
## 二, 栈与队列
栈和队列也是比较常见的数据结构, 它们是比较特殊的线性表, 因为对于栈来说, 访问, 插入和删除元素只能在栈顶进行, 对于队列来说, 元素只能从队列尾插入, 从队列头访问和删除. 
栈
栈是限制插入和删除只能在一个位置上进行的表, 该位置是表的末端, 叫作栈顶, 对栈的基本操作有push(进栈)和pop(出栈), 前者相当于插入, 后者相当于删除最后一个元素. 栈有时又叫作LIFO(Last In First Out)表, 即后进先出. 

下面我们看一道经典题目, 加深对栈的理解. 

上图中的答案是C, 其中的原理可以好好想一想. 
因为栈也是一个表, 所以任何实现表的方法都能实现栈. 我们打开JDK中的类Stack的源码, 可以看到它就是继承类Vector的. 当然, Stack是Java2前的容器类, 现在我们可以使用LinkedList来进行栈的所有操作. 
队列
队列是一种特殊的线性表, 特殊之处在于它只允许在表的前端(front)进行删除操作, 而在表的后端(rear)进行插入操作, 和栈一样, 队列是一种操作受限制的线性表. 进行插入操作的端称为队尾, 进行删除操作的端称为队头. 

我们可以使用链表来实现队列, 下面代码简单展示了利用LinkedList来实现队列类. 
代码9 简单实现队列类
public class MyQueue<E> {

    private LinkedList<E> list = new LinkedList<>();

    // 入队
    public void enqueue(E e) {
        list.addLast(e);
    }

    // 出队
    public E dequeue() {
        return list.removeFirst();
    }}

普通的队列是一种先进先出的数据结构, 而优先队列中, 元素都被赋予优先级. 当访问元素的时候, 具有最高优先级的元素最先被删除. 优先队列在生活中的应用还是比较多的, 比如医院的急症室为病人赋予优先级, 具有最高优先级的病人最先得到治疗. 在Java集合框架中, 类PriorityQueue就是优先队列的实现类, 具体大家可以去阅读源码. 
## 三, 树与二叉树
树型结构是一类非常重要的非线性数据结构, 其中以树和二叉树最为常用. 在介绍二叉树之前, 我们先简单了解一下树的相关内容. 
树
** 树 是由n(n>=1)个有限节点组成一个具有层次关系的集合. 它具有以下特点:每个节点有零个或多个子节点;没有父节点的节点称为 根 节点;每一个非根节点有且只有一个 父节点 **;除了根节点外, 每个子节点可以分为多个不相交的子树. 

二叉树基本概念
定义
二叉树是每个节点最多有两棵子树的树结构. 通常子树被称作"左子树"和"右子树". 二叉树常被用于实现二叉查找树和二叉堆. 
相关性质
二叉树的每个结点至多只有2棵子树(不存在度大于2的结点), 二叉树的子树有左右之分, 次序不能颠倒. 
二叉树的第i层至多有2(i-1)个结点;深度为k的二叉树至多有2k-1个结点. 
一棵深度为k, 且有2^k-1个节点的二叉树称之为** 满二叉树 **;
深度为k, 有n个节点的二叉树, 当且仅当其每一个节点都与深度为k的满二叉树中, 序号为1至n的节点对应时, 称之为** 完全二叉树 **. 

三种遍历方法
在二叉树的一些应用中, 常常要求在树中查找具有某种特征的节点, 或者对树中全部节点进行某种处理, 这就涉及到二叉树的遍历. 二叉树主要是由3个基本单元组成, 根节点, 左子树和右子树. 如果限定先左后右, 那么根据这三个部分遍历的顺序不同, 可以分为先序遍历, 中序遍历和后续遍历三种. 
(1) 先序遍历 若二叉树为空, 则空操作, 否则先访问根节点, 再先序遍历左子树, 最后先序遍历右子树.  (2) 中序遍历 若二叉树为空, 则空操作, 否则先中序遍历左子树, 再访问根节点, 最后中序遍历右子树. (3) 后序遍历 若二叉树为空, 则空操作, 否则先后序遍历左子树访问根节点, 再后序遍历右子树, 最后访问根节点. 

树和二叉树的区别
(1) 二叉树每个节点最多有2个子节点, 树则无限制.  (2) 二叉树中节点的子树分为左子树和右子树, 即使某节点只有一棵子树, 也要指明该子树是左子树还是右子树, 即二叉树是有序的.  (3) 树决不能为空, 它至少有一个节点, 而一棵二叉树可以是空的. 
上面我们主要对二叉树的相关概念进行了介绍, 下面我们将从二叉查找树开始, 介绍二叉树的几种常见类型, 同时将之前的理论部分用代码实现出来. 
二叉查找树
定义
二叉查找树就是二叉排序树, 也叫二叉搜索树. 二叉查找树或者是一棵空树, 或者是具有下列性质的二叉树: (1) 若左子树不空, 则左子树上所有结点的值均小于它的根结点的值;(2) 若右子树不空, 则右子树上所有结点的值均大于它的根结点的值;(3) 左, 右子树也分别为二叉排序树;(4) 没有键值相等的结点. 

性能分析
对于二叉查找树来说, 当给定值相同但顺序不同时, 所构建的二叉查找树形态是不同的, 下面看一个例子. 

可以看到, 含有n个节点的二叉查找树的平均查找长度和树的形态有关. 最坏情况下, 当先后插入的关键字有序时, 构成的二叉查找树蜕变为单支树, 树的深度为n, 其平均查找长度(n+1)/2(和顺序查找相同), 最好的情况是二叉查找树的形态和折半查找的判定树相同, 其平均查找长度和log2(n)成正比. 平均情况下, 二叉查找树的平均查找长度和logn是等数量级的, 所以为了获得更好的性能, 通常在二叉查找树的构建过程需要进行"平衡化处理", 之后我们将介绍平衡二叉树和红黑树, 这些均可以使查找树的高度为O(log(n)). 
代码10 二叉树的节点
class TreeNode<E> {

    E element;
    TreeNode<E> left;
    TreeNode<E> right;

    public TreeNode(E e) {
        element = e;
    }}

二叉查找树的三种遍历都可以直接用递归的方法来实现:
代码12 先序遍历
protected void preorder(TreeNode<E> root) {

    if (root == null)
        return;

    System.out.println(root.element + " ");

    preorder(root.left);

    preorder(root.right);}

代码13 中序遍历
protected void inorder(TreeNode<E> root) {

    if (root == null)
        return;

    inorder(root.left);

    System.out.println(root.element + " ");

    inorder(root.right);}

代码14 后序遍历
protected void postorder(TreeNode<E> root) {

    if (root == null)
        return;

    postorder(root.left);

    postorder(root.right);

    System.out.println(root.element + " ");}

代码15 二叉查找树的简单实现
/**
 * @author JackalTsc
 */public class MyBinSearchTree<E extends Comparable<E>> {

    // 根
    private TreeNode<E> root;

    // 默认构造函数
    public MyBinSearchTree() {
    }

    // 二叉查找树的搜索
    public boolean search(E e) {

        TreeNode<E> current = root;

        while (current != null) {

            if (e.compareTo(current.element) < 0) {
                current = current.left;
            } else if (e.compareTo(current.element) > 0) {
                current = current.right;
            } else {
                return true;
            }
        }

        return false;
    }

    // 二叉查找树的插入
    public boolean insert(E e) {

        // 如果之前是空二叉树 插入的元素就作为根节点
        if (root == null) {
            root = createNewNode(e);
        } else {
            // 否则就从根节点开始遍历 直到找到合适的父节点
            TreeNode<E> parent = null;
            TreeNode<E> current = root;
            while (current != null) {
                if (e.compareTo(current.element) < 0) {
                    parent = current;
                    current = current.left;
                } else if (e.compareTo(current.element) > 0) {
                    parent = current;
                    current = current.right;
                } else {
                    return false;
                }
            }
            // 插入
            if (e.compareTo(parent.element) < 0) {
                parent.left = createNewNode(e);
            } else {
                parent.right = createNewNode(e);
            }
        }
        return true;
    }

    // 创建新的节点
    protected TreeNode<E> createNewNode(E e) {
        return new TreeNode(e);
    }
}
// 二叉树的节点class TreeNode<E extends Comparable<E>> {

    E element;
    TreeNode<E> left;
    TreeNode<E> right;

    public TreeNode(E e) {
        element = e;
    }}

上面的代码15主要展示了一个自己实现的简单的二叉查找树, 其中包括了几个常见的操作, 当然更多的操作还是需要大家自己去完成. 因为在二叉查找树中删除节点的操作比较复杂, 所以下面我详细介绍一下这里. 
二叉查找树中删除节点分析
要在二叉查找树中删除一个元素, 首先需要定位包含该元素的节点, 以及它的父节点. 假设current指向二叉查找树中包含该元素的节点, 而parent指向current节点的父节点, current节点可能是parent节点的左孩子, 也可能是右孩子. 这里需要考虑两种情况:
1.current节点没有左孩子, 那么只需要将patent节点和current节点的右孩子相连. 
2.current节点有一个左孩子, 假设rightMost指向包含current节点的左子树中最大元素的节点, 而parentOfRightMost指向rightMost节点的父节点. 那么先使用rightMost节点中的元素值替换current节点中的元素值, 将parentOfRightMost节点和rightMost节点的左孩子相连, 然后删除rightMost节点. 
    // 二叉搜索树删除节点
    public boolean delete(E e) {

        TreeNode<E> parent = null;
        TreeNode<E> current = root;

        // 找到要删除的节点的位置
        while (current != null) {
            if (e.compareTo(current.element) < 0) {
                parent = current;
                current = current.left;
            } else if (e.compareTo(current.element) > 0) {
                parent = current;
                current = current.right;
            } else {
                break;
            }
        }

        // 没找到要删除的节点
        if (current == null) {
            return false;
        }

        // 考虑第一种情况
        if (current.left == null) {
            if (parent == null) {
                root = current.right;
            } else {
                if (e.compareTo(parent.element) < 0) {
                    parent.left = current.right;
                } else {
                    parent.right = current.right;
                }
            }
        } else { // 考虑第二种情况
            TreeNode<E> parentOfRightMost = current;
            TreeNode<E> rightMost = current.left;
            // 找到左子树中最大的元素节点
            while (rightMost.right != null) {
                parentOfRightMost = rightMost;
                rightMost = rightMost.right;
            }

            // 替换
            current.element = rightMost.element;

            // parentOfRightMost和rightMost左孩子相连
            if (parentOfRightMost.right == rightMost) {
                parentOfRightMost.right = rightMost.left;
            } else {
                parentOfRightMost.left = rightMost.left;
            }
        }

        return true;
    }

平衡二叉树
平衡二叉树又称AVL树, 它或者是一棵空树, 或者是具有下列性质的二叉树:它的左子树和右子树都是平衡二叉树, 且左子树和右子树的深度之差的绝对值不超过1. 

AVL树是最先发明的自平衡二叉查找树算法. 在AVL中任何节点的两个儿子子树的高度最大差别为1, 所以它也被称为高度平衡树, n个结点的AVL树最大深度约1.44log2n. 查找, 插入和删除在平均和最坏情况下都是O(log n). 增加和删除可能需要通过一次或多次树旋转来重新平衡这个树. 
红黑树
红黑树是平衡二叉树的一种, 它保证在最坏情况下基本动态集合操作的事件复杂度为O(log n). 红黑树和平衡二叉树区别如下:(1) 红黑树放弃了追求完全平衡, 追求大致平衡, 在与平衡二叉树的时间复杂度相差不大的情况下, 保证每次插入最多只需要三次旋转就能达到平衡, 实现起来也更为简单. (2) 平衡二叉树追求绝对平衡, 条件比较苛刻, 实现起来比较麻烦, 每次插入新节点之后需要旋转的次数不能预知. 点击查看更多
## 四, 图
简介
图是一种较线性表和树更为复杂的数据结构, 在线性表中, 数据元素之间仅有线性关系, 在树形结构中, 数据元素之间有着明显的层次关系, 而在图形结构中, 节点之间的关系可以是任意的, 图中任意两个数据元素之间都可能相关. 图的应用相当广泛, 特别是近年来的迅速发展, 已经渗入到诸如语言学, 逻辑学, 物理, 化学, 电讯工程, 计算机科学以及数学的其他分支中. 
相关阅读
因为图这部分的内容还是比较多的, 这里就不详细介绍了, 有需要的可以自己搜索相关资料. 
(1) <百度百科对图的介绍>
(2) <数据结构之图(存储结构, 遍历)>
## 五, 总结
到这里, 关于常见的数据结构的整理就结束了, 断断续续大概花了两天时间写完, 在总结的过程中, 通过查阅相关资料, 结合书本内容, 收获还是很大的. 
本文在开源项目:https://github.com/Android-Alvin/Android-LearningNotes 中已收录, 里面包含不同方向的自学编程路线, 面试题集合/面经, 


# C++常用数据结构总结
前言
所有的容器归根到底都是内存空间的排列方式和在空间上施加各种各种不同的限制所得的. 空间排列方式只有线性和链式两种方式, 链式是通过记录每一个数据的地址来实现查找下一位数据的. 而每一个容器所具有的特性就决定了它所适用的情况, 总的来看容器常用的无非是增删改查操作, 下面将从适用场景, 常用操作来进行总结. 

STL	底层数据结构
vector	数组
list	双向链表
forward_list	单向链表
map	红黑树
multimap	红黑树
unordered_map	HASH表
unordered_multimap	HASH表
set	红黑树
multiset	红黑树
unordered_set	HASH表
unordered_multiset	HASH表
priority_queue	最小堆
deque	中央控制器和多个缓冲区
stack	deque
queue	deque


## String 字符串

头文件 : #include <string>

使用

    #include <iostream>
    #include <string>
    using namespace std;
     
    int main()
    {
    	string a = "abcdf";
    	int k = a.find('r');  //寻找r在字符串中第一次出现的位置, 从0开始, 不存在返回-1;
    	cout << k << endl;
    	a.substr(1,3);      //返回从字符的第一位开始, 往后3位的字符串;
    	a.substr(3);         //返回从字符的第三位开始的字符串;
    	
    	string b = a+"abc";//拼接两个字符串 
    	cout<<b<<endl;
    	return 0;
    }


## array数组
内存空间为连续的一段地址, 适用于提前已知所要存储的数据类型和数量, 进行大量的查, 改操作, 不适用于含有大量交换, 删除, 增加数据的操作, 该容器无法动态改变大小, 所以说提前已知存储数据类型和数量. 图片介绍了数组的初始化, 赋值, 遍历, 获取大小, 获取特定位置数据的方法. 

array用于size固定的数组, 与内置数组相比更加安全, 与vector相比有更高的性能
std::array<int, 8> arr1; //定义一个长度为8的数组
std::array<int, 3> arr2 = {1, 2, 3}; //初始化

## queue队列
该容器内存结构最好为链式结构, 最知名的特点是先进先出, 能动态调整大小, 适用于包含大量增, 删操作的情况, 但不适用于含有大量查找操作的数据. 图片介绍了队列初始化, 赋值, 弹出操作. 

## priority_queue 优先队列

优先队列本质上就是一个最大堆或者最小堆, 最大堆就是优先级最大的那个数在堆顶, 最小堆就是优先级最小的在堆顶, 这里的优先级指的是数值的大小, 也可以通过自己重载<号来重新定义比较方式

头文件 : #include < queue >
定义 : priority_queue < typename > q;
这里的typename可以是任意的数据型:int,double,string,char,还可以是自己写的结构体
使用:

    q.push(x)  //插入一个元素, 复杂度log(n)
    q.top()    //访问堆顶元素
    q.pop()    //把堆顶元素出队, 复杂度log(n)
    q.empty()  //若q为空, 返回true,否则返回false
    q.size()   //返回q长度

定义最大堆与最小堆

    priority_queue<int> q;    //默认的最大堆, 优先级最大的在队首
    //priority_queue< int,vector<int>,greater<int> >   //定义最小堆, 优先级小的在队首

使用结构体定义最大堆与最小堆

定义方式不变, 在结构体里重载<运算符

    struct Node{
    	int x,y;
    	bool operator <(const Node &n) const
    	{
    		return x<n.x;     //根据x的值来定义优先级, 最大堆
    		//return x>n.x;   //最小堆
    	}
    };
     
    priority_queue<Node> q;


## stack 栈
栈在内存上可为连续或者链式, 于队列相反的是它为先进后出, 适用于压栈出栈操作, 如可用于图的遍历, 递归函数的改写等, 图片介绍了栈的创始化, 压栈, 出栈等操作. 

栈这种数据结构的特点是先进后出

头文件 : #include < stack>
定义 : stack< typename> s, 这里的typename可以是任何一种的数据类型
使用

    stack<int> s;
    s.empty();//是否为空
    int top=s.top();//获取栈头数据
    stack.pop();//出栈
    stack.push(1);//入栈

queue的用法和栈是一样的, 唯一不同的是, 队列的先进先出


## list 链表
链表在内存结构上为链式结构, 也就决定它可以动态增加, 适用于包含大量增加, 删除的应用, 但不适用于包含大量查询的操作, 图片介绍了链表的创建, 添加数据, 删除数据, 获取数据等操作. 

## Map 字典/映射
map为关联式容器, 提供一对一服务, 每个关键字在容器中只能出现一次, 适用于一对一服务. 

Map, 我们一般称为字典或是映射, 它提供了一对一的映射关系
使用场景 : map用于查找问题中某个元素出现的次数, 比如问'a'这个元素在数组中出现了多少次. 这个只是最基本的应用场景, 由于可以有任意的键值对的对应, map的应用远不止于此
头文件 : #include < map >
定义 : map< typename,typename > ma , 这里的typename可以是任何一种的数据类型
使用
c++中map的初始值自动为0

    ma.clear();  //清除map中的所有元素
    ma[5]=1;     //让5对应的值设为1, 注意复杂度是log(n)
    ma[6]++;     //让6对应的值加1, log(n)
    ma.erase(6); //把6这个键从映射中删去,log(n)
    ma.find(6);   //查找6在map是否存在, 如果不存在返回ma.end();log(n)
    //map的遍历
    map<int,int> ma;
    map<int,int>::iterator it;
    for (it = ma.begin(); it != ma.end(); it++)
    {
    	cout << it->first << ' ' << it->second << '\n';    //迭代器是一个二元对
    }

今天想查一下c++ hashmap的使用方法, 搜出来的一些文章实在辣眼睛, 竟然很多都混淆了c++中map和hashmap的区别. 

首先, c++ 标准库的std::map内部是排序的, 内部使用的是红黑树实现, 不管是增加还是查找的时间复杂度 O ( l o g N ) O(logN) O(logN). 

而c++ 标准库的hashmap其实叫作std::unordered_map, 其增加和查询的时间复杂度才是 O ( 1 ) O(1) O(1). 它提供了类似map的方法. 在c++11下直接使用头文件#include <unordered_map> 就可以了, 如果不在c++11标准下, 也可以使用#include <tr1/unordered_map> 来支持hashmap.

当然有人可能会说其实c++有个叫作hash_map的库, 但那不是标准库, 引用一个stackoverflow的评论来告诉你如何取舍:

    @ShameelMohamed, 2017, i.e. 6 years after C++11 it should be hard to find an STL that doesn't provide unordered_map. Thus, there is no reason to consider the non-standard hash_map. – maxschlepzig Feb 13 '17 at 10:42


Map和Dictionary(字典)其实是一样东西. 只是在不同地方不同称呼. 
而哈希表和字典有些许不同. 

字典:

    找不到返回error
    不拆箱,装箱所以比hashtable快
    只有公共的静态成员都是线程安全的. 
    Dictionary 是一个泛型类型, 这意味着我们可以使用它与任何数据类型. 

哈希表:

    找不到返回null
    需要拆箱装箱所以比dictionary慢
    所有成员都是线程安全的
    不是一个泛型类型


主要的区别是, 哈希表使用多线程做, 可以多线程读取, 字典单线程读取

对比哈希表和STL map. 哈希表是怎么实现的?如果输入数据规模不大,  我们可以使用什么数据结构来代替哈希表. 

解答:
对比哈希表和STL map
在哈希表中, 实值得存储位置由其键值对应得哈希函数值决定. 因此, 存储在哈希表中得值是无序得. 在哈希表中插入和删除的时间复杂度都是o(1). 实现一个哈希表, 冲突处理时必须的. 

对于STL中的map, 键/值对在其中是根据键进行排序的. 它使用一根红黑树来保存数据, 因此插入和查找元素的时间复杂度都是o(nlongn). 

哈希表是怎么实现的:
1.首先需要一个好的哈希函数来确定哈希值是均匀分布的. 
2.其次需要一个好的冲突解决办法:链表发(表中元素比较密集的时候使用此方法), 探测法(表中元素比较稀疏的时候用)
3.动态增加或减少哈希表的大小. 

如果输入数据规模不大, 我们可以使用什么数据结构来代替哈希表. 
你可以使用STL map来代替哈希表, 尽管插入和查找元素的时间复杂度是O(logn),  但由于输入数据的规模不大, 因此这点时间差别可以忽略不计. 

## unordered_map
1.介绍
最近使用到一个c++的容器——unordered_map, 它是一个关联容器, 内部采用的是hash表结构, 拥有快速检索的功能. 
1.1 特性
1.关联性:通过key去检索value, 而不是通过绝对地址(和顺序容器不同)
2.无序性:使用hash表存储, 内部无序
3.Map : 每个值对应一个键值
4.键唯一性:不存在两个元素的键一样
5.动态内存管理:使用内存管理模型来动态管理所需要的内存空间
1.2 Hashtable和bucket
由于unordered_map内部采用的hashtable的数据结构存储, 所以, 每个特定的key会通过一些特定的哈希运算映射到一个特定的位置, 我们知道, hashtable是可能存在冲突的(多个key通过计算映射到同一个位置), 在同一个位置的元素会按顺序链在后面. 所以把这个位置称为一个bucket是十分形象的(像桶子一样, 可以装多个元素). 可以参考这篇介绍哈希表的文章

所以unordered_map内部其实是由很多哈希桶组成的, 每个哈希桶中可能没有元素, 也可能有多个元素. 
2. 模版
template < class Key,                                    // unordered_map::key_type
           class T,                                      // unordered_map::mapped_type
           class Hash = hash<Key>,                       // unordered_map::hasher
           class Pred = equal_to<Key>,                   // unordered_map::key_equal
           class Alloc = allocator< pair<const Key,T> >  // unordered_map::allocator_type
           > class unordered_map;
主要使用的也是模板的前2个参数<键, 值>(需要更多的介绍可以点击这里)
unordered_map<const Key, T> map;
2.1 迭代器
unordered_map的迭代器是一个指针, 指向这个元素, 通过迭代器来取得它的值. 
unordered_map<Key,T>::iterator it;
(*it).first;             // the key value (of type Key)
(*it).second;            // the mapped value (of type T)
(*it);                   // the "element value" (of type pair<const Key,T>) 
它的键值分别是迭代器的first和second属性. 
it->first;               // same as (*it).first   (the key value)it->second;              // same as (*it).second  (the mapped value) 
3. 功能函数
3.1 构造函数
unordered_map的构造方式有几种: 
- 构造空的容器 
- 复制构造 
- 范围构造 
- 用数组构造
3.1.2示例代码
// constructing unordered_maps#include <iostream>#include <string>#include <unordered_map>using namespace std;
typedef unordered_map<string,string> stringmap;

stringmap merge (stringmap a,stringmap b) {
  stringmap temp(a); temp.insert(b.begin(),b.end()); return temp;
}
int main ()
{
  stringmap first;                              // 空
  stringmap second ( {{"apple","red"},{"lemon","yellow"}} );       // 用数组初始
  stringmap third ( {{"orange","orange"},{"strawberry","red"}} );  // 用数组初始
  stringmap fourth (second);                    // 复制初始化
  stringmap fifth (merge(third,fourth));        // 移动初始化
  stringmap sixth (fifth.begin(),fifth.end());  // 范围初始化

  cout << "sixth contains:";
  for (auto& x: sixth) cout << " " << x.first << ":" << x.second;
  cout << endl;

  return 0;
}
输出结果:
sixth contains: apple:red lemon:yellow orange:orange strawberry:red
3.2 容量操作
3.2.1 size
size_type size() const noexcept;
返回unordered_map的大小
3.2.2 empty
bool empty() const noexcept;
- 为空返回true 
- 不为空返回false, 和用size() == 0判断一样. 
3.3 元素操作
3.3.1 find
iterator find ( const key_type& k );
查找key所在的元素.  
- 找到:返回元素的迭代器. 通过迭代器的second属性获取值 
- 没找到:返回unordered_map::end 
3.3.2 insert
插入有几种方式: 
- 复制插入(复制一个已有的pair的内容) 
- 数组插入(直接插入一个二维数组) 
- 范围插入(复制一个起始迭代器和终止迭代器中间的内容) 
- 数组访问模式插入(和数组的[]操作很相似)
具体的例子可以看后面示例代码. 
3.3.3 at
mapped_type& at ( const key_type& k );
查找key所对应的值 
- 如果存在:返回key对应的值, 可以直接修改, 和[]操作一样.  
- 如果不存在:抛出 out_of_range 异常.
mymap.at("Mars") = 3396; //mymap["Mars"] = 3396
3.3.4 erase
擦除元素也有几种方式:

通过位置(迭代器)

iterator erase ( const_iterator position );


通过key

size_type erase ( const key_type& k );


通过范围(两个迭代器)

iterator erase ( const_iterator first, const_iterator last );

3.3.5 clear
void clear() noexcept
清空unordered_map
3.3.6 swap
void swap ( unordered_map& ump );
交换两个unordered_map(注意, 不是交换特定元素, 是整个交换两个map中的所有元素)
3.3.7 示例代码
// unordered_map::insert
#include <iostream>
#include <string>
#include <unordered_map>
using namespace std;
void display(unordered_map<string,double> myrecipe,string str)
{
    cout << str << endl;
    for (auto& x: myrecipe)
        cout << x.first << ": " << x.second << endl;
    cout << endl;
}
int main ()
{
    unordered_map<string,double>
    myrecipe,
    mypantry = {{"milk",2.0},{"flour",1.5}};

    /****************插入*****************/
    pair<string,double> myshopping ("baking powder",0.3);
    myrecipe.insert (myshopping);                        // 复制插入
    myrecipe.insert (make_pair<string,double>("eggs",6.0)); // 移动插入
    myrecipe.insert (mypantry.begin(), mypantry.end());  // 范围插入
    myrecipe.insert ({{"sugar",0.8},{"salt",0.1}});    // 初始化数组插入(可以用二维一次插入多个元素, 也可以用一维插入一个元素)
    myrecipe["coffee"] = 10.0;  //数组形式插入

    display(myrecipe,"myrecipe contains:");

    /****************查找*****************/
    unordered_map<string,double>::const_iterator got = myrecipe.find ("coffee");

    if ( got == myrecipe.end() )
        cout << "not found";
    else
        cout << "found "<<got->first << " is " << got->second<<"\n\n";
    /****************修改*****************/
    myrecipe.at("coffee") = 9.0;
    myrecipe["milk"] = 3.0;
    display(myrecipe,"After modify myrecipe contains:");


    /****************擦除*****************/
    myrecipe.erase(myrecipe.begin());  //通过位置
    myrecipe.erase("milk");    //通过key
    display(myrecipe,"After erase myrecipe contains:");

    /****************交换*****************/
    myrecipe.swap(mypantry);
    display(myrecipe,"After swap with mypantry, myrecipe contains:");

    /****************清空*****************/
    myrecipe.clear();
    display(myrecipe,"After clear, myrecipe contains:");
    return 0;
}
输出结果:
myrecipe contains:
salt: 0.1
milk: 2
flour: 1.5
coffee: 10
eggs: 6
sugar: 0.8
baking powder: 0.3

found coffee is 10

After modify myrecipe contains:
salt: 0.1
milk: 3
flour: 1.5
coffee: 9
eggs: 6
sugar: 0.8
baking powder: 0.3

After erase myrecipe contains:
flour: 1.5
coffee: 9
eggs: 6
sugar: 0.8
baking powder: 0.3

After swap with mypantry, myrecipe contains:
flour: 1.5
milk: 2

After clear, myrecipe contains:
3.4 迭代器和bucket操作
3.4.1 begin
  iterator begin() noexcept;
  local_iterator begin ( size_type n );
begin() : 返回开始的迭代器(和你的输入顺序没关系, 因为它的无序的)
begin(int n) : 返回n号bucket的第一个迭代器
3.4.2 end
  iterator end() noexcept;
  local_iterator end( size_type n );
end(): 返回结束位置的迭代器
end(int n) : 返回n号bucket的最后一个迭代器
3.4.3 bucket
size_type bucket ( const key_type& k ) const;
返回通过哈希计算key所在的bucket(注意:这里仅仅做哈希计算确定bucket, 并不保证key一定存在bucket中!)
3.4.4 bucket_count
size_type bucket_count() const noexcept;
返回bucket的总数
3.4.5 bucket_size
size_type bucket_size ( size_type n ) const;
返回第i个bucket的大小(这个位置的桶子里有几个元素, 注意:函数不会判断n是否在count范围内)
3.4.6 示例代码
// unordered_map::bucket_count#include <iostream>#include <string>#include <unordered_map>using namespace std;
int main ()
{
    unordered_map<string,string> mymap =
    {
        {"house","maison"},
        {"apple","pomme"},
        {"tree","arbre"},
        {"book","livre"},
        {"door","porte"},
        {"grapefruit","pamplemousse"}
    };
    /************begin和end迭代器***************/
    cout << "mymap contains:";
    for ( auto it = mymap.begin(); it != mymap.end(); ++it )
        cout << " " << it->first << ":" << it->second;
    cout << endl;
    /************bucket操作***************/
     unsigned n = mymap.bucket_count();

    cout << "mymap has " << n << " buckets.\n";

    for (unsigned i=0; i<n; ++i)
    {
        cout << "bucket #" << i << "'s size:"<<mymap.bucket_size(i)<<" contains: ";
        for (auto it = mymap.begin(i); it!=mymap.end(i); ++it)
            cout << "[" << it->first << ":" << it->second << "] ";
        cout << "\n";
    }

    cout <<"\nkey:'apple' is in bucket #" << mymap.bucket("apple") <<endl;
    cout <<"\nkey:'computer' is in bucket #" << mymap.bucket("computer") <<endl;

    return 0;
}
输出结果:
mymap contains: door:porte grapefruit:pamplemousse tree:arbre apple:pomme book:livre house:maison
mymap has 7 buckets.
bucket #0's size:2 contains: [book:livre] [house:maison]
bucket #1's size:0 contains:
bucket #2's size:0 contains:
bucket #3's size:2 contains: [grapefruit:pamplemousse] [tree:arbre]
bucket #4's size:0 contains:
bucket #5's size:1 contains: [apple:pomme]
bucket #6's size:1 contains: [door:porte]

key:'apple' is in bucket #5

key:'computer' is in bucket #6
最后
unordered_map常用的功能函数介绍就这么多了, 还有一些比较不常用的功能的介绍, 可以参考这里
2, 无序map和有序map的对比
在c++11以前要使用unordered_map需要
     #include<tr1/unordered_map>//在unordered_map之前加上tr1库名,  
     using namespace std::tr1;//与此同时需要加上命名空间 

[查找元素是否存在] 
    若有unordered_map<int, int> mp;查找x是否在map中 
    方法1:  若存在  mp.find(x)!=mp.end() 
    方法2:  若存在  mp.count(x)!=0 

[插入数据] 
    map.insert(Map::value_type(1,"Raoul")); 
[遍历map] 
    unordered_map<key,T>::iterator it; 
    (*it).first;        //the key value 
    (*it).second   //the mapped value 
    for(unordered_map<key,T>::iterator iter=mp.begin();iter!=mp.end();iter++) 
          cout<<"key value is"<<iter->first<<" the mapped value is "<< iter->second; 

    也可以这样 
    for(auto& v : mp) 
        print v.first and v.second 
[与map的区别]
内部实现机理
map: map内部实现了一个红黑树, 该结构具有自动排序的功能, 因此map内部的所有元素都是有序的, 红黑树的每一个节点都代表着map的一个元素, 因此, 对于map进行的查找, 删除, 添加等一系列的操作都相当于是对红黑树进行这样的操作, 故红黑树的效率决定了map的效率. 
unordered_map: unordered_map内部实现了一个哈希表, 因此其元素的排列顺序是杂乱的, 无序的
优缺点以及适用处
map 
优点: 
有序性, 这是map结构最大的优点, 其元素的有序性在很多应用中都会简化很多的操作
红黑树, 内部实现一个红黑书使得map的很多操作在的时间复杂度下就可以实现, 因此效率非常的高
缺点: 
空间占用率高, 因为map内部实现了红黑树, 虽然提高了运行效率, 但是因为每一个节点都需要额外保存父节点, 孩子节点以及红/黑性质, 使得每一个节点都占用大量的空间
适用处, 对于那些有顺序要求的问题, 用map会更高效一些
unordered_map 
优点: 
因为内部实现了哈希表, 因此其查找速度非常的快
缺点: 
哈希表的建立比较耗费时间
适用处, 对于查找问题, unordered_map会更加高效一些, 因此遇到查找问题, 常会考虑一下用unordered_map


0 为什么需要hash_map
用过map吧?map提供一个很常用的功能, 那就是提供key-value的存储和查找功能. 例如, 我要记录一个人名和相应的存储, 而且随时增加, 要快速查找和修改:
岳不群－华山派掌门人, 人称君子剑
张三丰－武当掌门人, 太极拳创始人
东方不败－第一高手, 葵花宝典
...
这些信息如果保存下来并不复杂, 但是找起来比较麻烦. 例如我要找"张三丰"的信息, 最傻的方法就是取得所有的记录, 然后按照名字一个一个比较. 如果要速度快, 就需要把这些记录按照字母顺序排列, 然后按照二分法查找. 但是增加记录的时候同时需要保持记录有序, 因此需要插入排序. 考虑到效率, 这就需要用到二叉树. 讲下去会没完没了, 如果你使用STL 的map容器, 你可以非常方便的实现这个功能, 而不用关心其细节. 关于map的数据结构细节, 感兴趣的朋友可以参看学习STL map, STL set之数据结构基础. 看看map的实现:
#include <map>#include <string>using namespace std;
...
map<string, string> namemap;
//增加. . . 
namemap["岳不群"]="华山派掌门人, 人称君子剑";
namemap["张三丰"]="武当掌门人, 太极拳创始人";
namemap["东方不败"]="第一高手, 葵花宝典";
...
//查找. . if(namemap.find("岳不群") != namemap.end()){
        ...
}
不觉得用起来很easy吗?而且效率很高, 100万条记录, 最多也只要20次的string.compare的比较, 就能找到你要找的记录;200万条记录事, 也只要用21次的比较. 
速度永远都满足不了现实的需求. 如果有100万条记录, 我需要频繁进行搜索时, 20次比较也会成为瓶颈, 要是能降到一次或者两次比较是否有可能?而且当记录数到200万的时候也是一次或者两次的比较, 是否有可能?而且还需要和map一样的方便使用. 
答案是肯定的. 这时你需要has_map. 虽然hash_map目前并没有纳入C++ 标准模板库中, 但几乎每个版本的STL都提供了相应的实现. 而且应用十分广泛. 在正式使用hash_map之前, 先看看hash_map的原理. 
1 数据结构:hash_map原理
这是一节让你深入理解hash_map的介绍, 如果你只是想囫囵吞枣, 不想理解其原理, 你倒是可以略过这一节, 但我还是建议你看看, 多了解一些没有坏处. 
hash_map基于hash table(哈希表).  哈希表最大的优点, 就是把数据的存储和查找消耗的时间大大降低, 几乎可以看成是常数时间;而代价仅仅是消耗比较多的内存. 然而在当前可利用内存越来越多的情况下, 用空间换时间的做法是值得的. 另外, 编码比较容易也是它的特点之一. 
其基本原理是:使用一个下标范围比较大的数组来存储元素. 可以设计一个函数(哈希函数, 也叫做散列函数), 使得每个元素的关键字都与一个函数值(即数组下标, hash值)相对应, 于是用这个数组单元来存储这个元素;也可以简单的理解为, 按照关键字为每一个元素"分类", 然后将这个元素存储在相应"类"所对应的地方, 称为桶. 
但是, 不能够保证每个元素的关键字与函数值是一一对应的, 因此极有可能出现对于不同的元素, 却计算出了相同的函数值, 这样就产生了"冲突", 换句话说, 就是把不同的元素分在了相同的"类"之中.  总的来说, "直接定址"与"解决冲突"是哈希表的两大特点. 
hash_map, 首先分配一大片内存, 形成许多桶. 是利用hash函数, 对key进行映射到不同区域(桶)进行保存. 其插入过程是:
1.得到key
2.通过hash函数得到hash值
3.得到桶号(一般都为hash值对桶数求模)
4.存放key和value在桶内. 
其取值过程是:
1.得到key
2.通过hash函数得到hash值
3.得到桶号(一般都为hash值对桶数求模)
4.比较桶的内部元素是否与key相等, 若都不相等, 则没有找到. 
5.取出相等的记录的value. 
hash_map中直接地址用hash函数生成, 解决冲突, 用比较函数解决. 这里可以看出, 如果每个桶内部只有一个元素, 那么查找的时候只有一次比较. 当许多桶内没有值时, 许多查询就会更快了(指查不到的时候).
由此可见, 要实现哈希表, 和用户相关的是:hash函数和比较函数. 这两个参数刚好是我们在使用hash_map时需要指定的参数. 
2 hash_map 使用
2.1 一个简单实例
不要着急如何把"岳不群"用hash_map表示, 我们先看一个简单的例子:随机给你一个ID号和ID号相应的信息, ID号的范围是1～2的31次方. 如何快速保存查找. 
#include <hash_map>#include <string>using namespace std;int main(){
        hash_map<int, string> mymap;
        mymap[9527]="唐伯虎点秋香";
        mymap[1000000]="百万富翁的生活";
        mymap[10000]="白领的工资底线";
        ...
        if(mymap.find(10000) != mymap.end()){
                ...
        }
够简单, 和map使用方法一样. 这时你或许会问?hash函数和比较函数呢?不是要指定么?你说对了, 但是在你没有指定hash函数和比较函数的时候, 你会有一个缺省的函数, 看看hash_map的声明, 你会更加明白. 下面是SGI STL的声明:
template <class _Key, class _Tp, class _HashFcn = hash<_Key>,class _EqualKey = equal_to<_Key>,class _Alloc = __STL_DEFAULT_ALLOCATOR(_Tp) >class hash_map
{
        ...
}
也就是说, 在上例中, 有以下等同关系:
...
hash_map<int, string> mymap;//等同于:
hash_map<int, string, hash<int>, equal_to<int> > mymap;
Alloc我们就不要取关注太多了(希望深入了解Allocator的朋友可以参看标准库 STL :Allocator能做什么)
2.2 hash_map 的hash函数
hash< int>到底是什么样子?看看源码:
struct hash<int> {
        size_t operator()(int __x) const { return __x; }
};
原来是个函数对象. 在SGI STL中, 提供了以下hash函数:
struct hash<char*>struct hash<const char*>struct hash<char> struct hash<unsigned char> struct hash<signed char>struct hash<short>struct hash<unsigned short> struct hash<int> struct hash<unsigned int>struct hash<long> struct hash<unsigned long>
也就是说, 如果你的key使用的是以上类型中的一种, 你都可以使用缺省的hash函数. 当然你自己也可以定义自己的hash函数. 对于自定义变量, 你只能如此, 例如对于string, 就必须自定义hash函数. 例如:
struct str_hash{
        size_t operator()(const string& str) const
        {
                unsigned long __h = 0;
                for (size_t i = 0 ; i < str.size() ; i ++)
                __h = 5*__h + str[i];
                return size_t(__h);
        }
};//如果你希望利用系统定义的字符串hash函数, 你可以这样写:struct str_hash{
        size_t operator()(const string& str) const
        {
                return __stl_hash_string(str.c_str());
        }
};
在声明自己的哈希函数时要注意以下几点:
1.使用struct, 然后重载operator().
2.返回是size_t
3.参数是你要hash的key的类型. 
4.函数是const类型的. 
如果这些比较难记, 最简单的方法就是照猫画虎, 找一个函数改改就是了. 
现在可以对开头的"岳不群"进行哈希化了  . 直接替换成下面的声明即可:
map<string, string> namemap; //改为:
hash_map<string, string, str_hash> namemap;
其他用法都不用边. 当然不要忘了吧str_hash的声明以及头文件改为hash_map. 
你或许会问:比较函数呢?别着急, 这里就开始介绍hash_map中的比较函数. 
2.3 hash_map 的比较函数
在map中的比较函数, 需要提供less函数. 如果没有提供, 缺省的也是less< Key> . 在hash_map中, 要比较桶内的数据和key是否相等, 因此需要的是是否等于的函数:equal_to< Key> . 先看看equal_to的源码:
//本代码可以从SGI STL//先看看binary_function 函数声明, 其实只是定义一些类型而已. template <class _Arg1, class _Arg2, class _Result>struct binary_function {
        typedef _Arg1 first_argument_type;
        typedef _Arg2 second_argument_type;
        typedef _Result result_type;
};//看看equal_to的定义:template <class _Tp>struct equal_to : public binary_function<_Tp,_Tp,bool>
{
        bool operator()(const _Tp& __x, const _Tp& __y) const { return __x == __y; }
};
如果你使用一个自定义的数据类型, 如struct mystruct, 或者const char* 的字符串, 如何使用比较函数?使用比较函数, 有两种方法. 第一种是:重载==操作符, 利用equal_to;看看下面的例子:
struct mystruct{
        int iID;
        int  len;
        bool operator==(const mystruct & my) const{
                return (iID==my.iID) && (len==my.len) ;
        }
};
这样, 就可以使用equal_to< mystruct>作为比较函数了. 另一种方法就是使用函数对象. 自定义一个比较函数体:
struct compare_str{
        bool operator()(const char* p1, const char*p2) const{
                return strcmp(p1,p2)==0;
        }
};
有了compare_str, 就可以使用hash_map了. 
typedef hash_map<const char*, string, hash<const char*>, compare_str> StrIntMap;
StrIntMap namemap;
namemap["岳不群"]="华山派掌门人, 人称君子剑";
namemap["张三丰"]="武当掌门人, 太极拳创始人";
namemap["东方不败"]="第一高手, 葵花宝典";
2.4 hash_map 函数
hash_map的函数和map的函数差不多. 具体函数的参数和解释, 请参看:STL 编程手册:Hash_map, 这里主要介绍几个常用函数. 
1.hash_map(size_type n) 如果讲究效率, 这个参数是必须要设置的. n 主要用来设置hash_map 容器中hash桶的个数. 桶个数越多, hash函数发生冲突的概率就越小, 重新申请内存的概率就越小. n越大, 效率越高, 但是内存消耗也越大. 
2.const_iterator find(const key_type& k) const. 用查找, 输入为键值, 返回为迭代器. 
3.data_type& operator[](const key_type& k) . 这是我最常用的一个函数. 因为其特别方便, 可像使用数组一样使用. 不过需要注意的是, 当你使用[key ]操作符时, 如果容器中没有key元素, 这就相当于自动增加了一个key元素. 因此当你只是想知道容器中是否有key元素时, 你可以使用find. 如果你希望插入该元素时, 你可以直接使用[]操作符. 
4.insert 函数. 在容器中不包含key值时, insert函数和[]操作符的功能差不多. 但是当容器中元素越来越多, 每个桶中的元素会增加, 为了保证效率, hash_map会自动申请更大的内存, 以生成更多的桶. 因此在insert以后, 以前的iterator有可能是不可用的. 
5.erase 函数. 在insert的过程中, 当每个桶的元素太多时, hash_map可能会自动扩充容器的内存. 但在sgi stl中是erase并不自动回收内存. 因此你调用erase后, 其他元素的iterator还是可用的. 
 
3 相关hash容器
hash 容器除了hash_map之外, 还有hash_set, hash_multimap, has_multiset, 这些容器使用起来和set, multimap, multiset的区别与hash_map和map的区别一样, 我想不需要我一一细说了吧. 
4 其他
这里列几个常见问题, 应该对你理解和使用hash_map比较有帮助. 
4.1 hash_map和map的区别在哪里?
构造函数. hash_map需要hash函数, 等于函数;map只需要比较函数(小于函数).
存储结构. hash_map采用hash表存储, map一般采用红黑树(RB Tree)实现. 因此其memory数据结构是不一样的. 
4.2 什么时候需要用hash_map, 什么时候需要用map?
总体来说, hash_map 查找速度会比map快, 而且查找速度基本和数据数据量大小, 属于常数级别;而map的查找速度是log(n)级别. 并不一定常数就比log(n)小, hash还有hash函数的耗时, 明白了吧, 如果你考虑效率, 特别是在元素达到一定数量级时, 考虑考虑hash_map. 但若你对内存使用特别严格, 希望程序尽可能少消耗内存, 那么一定要小心, hash_map可能会让你陷入尴尬, 特别是当你的hash_map对象特别多时, 你就更无法控制了, 而且hash_map的构造速度较慢. 
现在知道如何选择了吗?权衡三个因素: 查找速度, 数据量, 内存使用. 
这里还有个关于hash_map和map的小故事, 看看:http://dev.csdn.net/Develop/article/14/14019.shtm
 
4.3 如何在hash_map中加入自己定义的类型?
你只要做两件事, 定义hash函数, 定义等于比较函数. 下面的代码是一个例子:
-bash-2.05b$ cat my.cpp#include <hash_map>#include <string>#include <iostream>
using namespace std;//define the classclass ClassA{
        public:
        ClassA(int a):c_a(a){}
        int getvalue()const { return c_a;}
        void setvalue(int a){c_a;}
        private:
        int c_a;
};
//1 define the hash functionstruct hash_A{
        size_t operator()(const class ClassA & A)const{
                //  return  hash<int>(classA.getvalue());
                return A.getvalue();
        }
};
//2 define the equal functionstruct equal_A{
        bool operator()(const class ClassA & a1, const class ClassA & a2)const{
                return  a1.getvalue() == a2.getvalue();
        }
};
int main()
{
        hash_map<ClassA, string, hash_A, equal_A> hmap;
        ClassA a1(12);
        hmap[a1]="I am 12";
        ClassA a2(198877);
        hmap[a2]="I am 198877";
        
        cout<<hmap[a1]<<endl;
        cout<<hmap[a2]<<endl;
        return 0;
}
-bash-2.05b$ make my
c++  -O -pipe -march=pentiumpro  my.cpp  -o my
-bash-2.05b$ ./my
I am 12
I am 198877
4.4如何用hash_map替换程序中已有的map容器?
这个很容易, 但需要你有良好的编程风格. 建议你尽量使用typedef来定义你的类型:
typedef map<Key, Value> KeyMap;
当你希望使用hash_map来替换的时候, 只需要修改:
typedef hash_map<Key, Value> KeyMap;
其他的基本不变. 当然, 你需要注意是否有Key类型的hash函数和比较函数. 
4.5为什么hash_map不是标准的?
具体为什么不是标准的, 我也不清楚, 有个解释说在STL加入标准C++之时, hash_map系列当时还没有完全实现, 以后应该会成为标准. 如果谁知道更合理的解释, 也希望告诉我. 但我想表达的是, 正是因为hash_map不是标准的, 所以许多平台上安装了g++编译器, 不一定有hash_map的实现. 我就遇到了这样的例子. 因此在使用这些非标准库的时候, 一定要事先测试. 另外, 如果考虑到平台移植, 还是少用为佳. 
 
 
常见问题:
 
本来想用hash_map实现大数量的快速查找, 后来发现效率并不快, 而且有些问题也很不解, 比如看如下代码:
C/C++ code 
   

    
#include <iostream>
#include <hash_map.h>
using namespace std;
int main(){
hash_map<int,string> hm(3); //初始化hash_map的桶的个数
hm.insert(make_pair(0,"hello"));
hm.insert(make_pair(1,"ok"));
hm.insert(make_pair(2,"bye"));
hm.insert(make_pair(3,"world"));
cout<<hm.size()<<endl;
cout<<hm.bucket_count()<<endl;
 return 0;
}

   


输出结果:
4
53
对这个结果很疑惑, 明明我定义了桶的个数, 为什么后面得到桶的个数为53?
hash_map默认对int类型的Key如何hash, hash函数是什么?
如何使得查找能更高效?可以用空间来换

各位大侠请教啊
 
这是我对hash的曾经的一点尝试, 仅供参考:
C/C++ code 
   

    #include <iostream>
#include <map>
#include <string>

#ifdef __GNUC__
#include <ext/hash_map>
#else
#include <hash_map>
#endif

#ifdef __GXX_EXPERIMENTAL_CXX0X__
#include <unordered_map>
#endif

namespace std
{
using namespace __gnu_cxx;
}

namespace __gnu_cxx
{
template<> struct hash< std::string >
{
    size_t operator()( const std::string& x ) const
    {
        return hash< const char* >()(x.c_str());
    }
};
}

int main()
{
    std::map<std::string, std::string> stdMap;
    stdMap["_GLIBCXX_STD"] = "std";
    stdMap["_GLIBCXX_BEGIN_NESTED_NAMESPACE"] = "+namespace";
    stdMap["_GLIBCXX_BEGIN_NAMESPACE"] = "+namespace";
    stdMap["_GLIBCXX_END_NESTED_NAMESPACE"] = "}";
    stdMap["_GLIBCXX_END_NAMESPACE"] = "}";
    stdMap["_GLIBCXX_END_NAMESPACE_TR1"] = "}";
    stdMap["_GLIBCXX_BEGIN_NAMESPACE_TR1"] = "-namespace tr1 {";
    stdMap["_GLIBCXX_STD2"] = "2std";
    stdMap["_GLIBCXX_BEGIN_NESTED_NAMESPACE2"] = "2+namespace";
    stdMap["_GLIBCXX_BEGIN_NAMESPACE2"] = "2+namespace";
    stdMap["_GLIBCXX_END_NESTED_NAMESPACE2"] = "2}";
    stdMap["_GLIBCXX_END_NAMESPACE2"] = "2}";
    stdMap["_GLIBCXX_END_NAMESPACE_TR12"] = "2}";
    stdMap["_GLIBCXX_BEGIN_NAMESPACE_TR12"] = "2-namespace tr1 {";
    stdMap["_XXGLIBCXX_END_NAMESPACE_TR12"] = "X2}";
    stdMap["_XXGLIBCXX_BEGIN_NAMESPACE_TR12"] = "X2-namespace tr1 {";

    std::hash_map<std::string, std::string> hashMap;
    hashMap["_GLIBCXX_STD"] = "std";
    hashMap["_GLIBCXX_BEGIN_NESTED_NAMESPACE"] = "+namespace";
    hashMap["_GLIBCXX_BEGIN_NAMESPACE"] = "+namespace";
    hashMap["_GLIBCXX_END_NESTED_NAMESPACE"] = "}";
    hashMap["_GLIBCXX_END_NAMESPACE"] = "}";
    hashMap["_GLIBCXX_END_NAMESPACE_TR1"] = "}";
    hashMap["_GLIBCXX_BEGIN_NAMESPACE_TR1"] = "-namespace tr1 {";
    hashMap["_GLIBCXX_STD2"] = "2std";
    hashMap["_GLIBCXX_BEGIN_NESTED_NAMESPACE2"] = "2+namespace";
    hashMap["_GLIBCXX_BEGIN_NAMESPACE2"] = "2+namespace";
    hashMap["_GLIBCXX_END_NESTED_NAMESPACE2"] = "2}";
    hashMap["_GLIBCXX_END_NAMESPACE2"] = "2}";
    hashMap["_GLIBCXX_END_NAMESPACE_TR12"] = "2}";
    hashMap["_GLIBCXX_BEGIN_NAMESPACE_TR12"] = "2-namespace tr1 {";
    hashMap["_XXGLIBCXX_END_NAMESPACE_TR12"] = "X2}";
    hashMap["_XXGLIBCXX_BEGIN_NAMESPACE_TR12"] = "X2-namespace tr1 {";

#ifdef __GXX_EXPERIMENTAL_CXX0X__
    std::unordered_map<std::string, std::string> unorderedMap;
    unorderedMap["_GLIBCXX_STD"] = "std";
    unorderedMap["_GLIBCXX_BEGIN_NESTED_NAMESPACE"] = "+namespace";
    unorderedMap["_GLIBCXX_BEGIN_NAMESPACE"] = "+namespace";
    unorderedMap["_GLIBCXX_END_NESTED_NAMESPACE"] = "}";
    unorderedMap["_GLIBCXX_END_NAMESPACE"] = "}";
    unorderedMap["_GLIBCXX_END_NAMESPACE_TR1"] = "}";
    unorderedMap["_GLIBCXX_BEGIN_NAMESPACE_TR1"] = "-namespace tr1 {";
    unorderedMap["_GLIBCXX_STD2"] = "2std";
    unorderedMap["_GLIBCXX_BEGIN_NESTED_NAMESPACE2"] = "2+namespace";
    unorderedMap["_GLIBCXX_BEGIN_NAMESPACE2"] = "2+namespace";
    unorderedMap["_GLIBCXX_END_NESTED_NAMESPACE2"] = "2}";
    unorderedMap["_GLIBCXX_END_NAMESPACE2"] = "2}";
    unorderedMap["_GLIBCXX_END_NAMESPACE_TR12"] = "2}";
    unorderedMap["_GLIBCXX_BEGIN_NAMESPACE_TR12"] = "2-namespace tr1 {";
    unorderedMap["_XXGLIBCXX_END_NAMESPACE_TR12"] = "X2}";
    unorderedMap["_XXGLIBCXX_BEGIN_NAMESPACE_TR12"] = "X2-namespace tr1 {";
#endif

    for (int i = 0; i < 5; ++i)
    {
        const clock_t t = clock();
        for (int j = 0; j < 1000000; ++j) stdMap.find("testfindkey");
        std::cout << "stdMap " << i + 1 << " : " << clock() - t << std::endl;
    }

    std::cout << "/n---------------/n" << std::endl;

    for (int i = 0; i < 5; ++i)
    {
        const clock_t t = clock();
        for (int j = 0; j < 1000000; ++j) hashMap.find("testfindkey");
        std::cout << "hashMap " << i + 1 << " : " << clock() - t << std::endl;
    }

#ifdef __GXX_EXPERIMENTAL_CXX0X__
    std::cout << "/n---------------/n" << std::endl;

    for (int i = 0; i < 5; ++i)
    {
        const clock_t t = clock();
        for (int j = 0; j < 1000000; ++j) unorderedMap.find("testfindkey");
        std::cout << "unorderedMap " << i + 1 << " : " << clock() - t << std::endl;
    }
#endif

    return 0;
}


    如果你使用的vc自带的hash函数, 那么它的定义中如下:

        
template<class _Kty, class _Pr = less>
class hash_compare1
{    // traits class for hash containers
public:
    //const static long lBucketSize = 0;
    enum
    {    // parameters for hash table
        bucket_size = 4,    // 0 < bucket_size
        min_buckets = 8     // min_buckets = 2 ^^ N, 0 < N
    };
. . .     

    
每次增长会2倍增加预分配内存, 你的hash_map是哪个版本的?
   
STL中map与hash_map容器的选择 
先看看alvin_lee 朋友做的解析, 我觉得还是很正确的, 从算法角度阐述了他们之间的问题!

实际上这个问题不光C++会遇到, 其他所有语言的标准容器的实现及选择上都是要考虑的. 做应用程序你可能觉得影响不大, 但是写算法或者核心代码就要小心了. 今天改进代码, 顺便又来温习基础功课了. 
 
  还记得Herb Sutter那极有味道的<C++对话系列>么, 在其中<产生真正的hash对象>这个故事里就讲了map的选择. 顺便回顾一下, 也讲一下我在实用中的理解. 
  选择map容器, 是为了更快的从关键字查找到相关的对象. 与使用list这样的线性表容器相比, 一可以简化查找的算法, 二可以使任意的关键字做索引, 并与目标对象配对, 优化查找算法. 在C++的STL中map是使用树来做查找算法, 这种算法差不多相当与list线性容器的折半查找的效率一样, 都是O (log2N), 而list就没有map这样易定制和操作了. 
  相比hash_map, hash_map使用hash表来排列配对, hash表是使用关键字来计算表位置. 当这个表的大小合适, 并且计算算法合适的情况下, hash表的算法复杂度为O(1)的, 但是这是理想的情况下的, 如果hash表的关键字计算与表位置存在冲突, 那么最坏的复杂度为O(n). 
  那么有了这样的认识, 我们应该怎么样选用算法呢?前两天看Python文章的时候, 不知道哪个小子说Python的map比c++的map快, 如何如何的. 但是他并不知道Python是默认使用的 hash_map, 而且这些语言特征本质上是使用c/c++写出来的, 问题在与算法和手段, 而不是在于语言本身的优劣, 你熟悉了各种算法, 各种语言的细节, 设计思想, 还能在这偏激的嚷嚷孰好孰坏(片面与偏激的看待事物只能表明愚昧与无知, 任何事物都有存在的价值, 包括技术). 显然C++的STL默认使用树结构来实现map, 是有考究的. 
  树查找, 在总查找效率上比不上hash表, 但是它很稳定, 它的算法复杂度不会出现波动. 在一次查找中, 你可以断定它最坏的情况下其复杂度不会超过O(log2N). 而hash表就不一样, 是O(1), 还是O(N), 或者在其之间, 你并不能把握. 假若你在开发一个供外部调用的接口, 其内部有关键字的查找, 但是这个接口调用并不频繁, 你是会希望其调用速度快, 但不稳定呢, 还是希望其调用时间平均, 且稳定呢. 反之假若你的程序需要查找一个关键字, 这个操作非常频繁, 你希望这些操作在总体上的时间较短, 那么hash表查询在总时间上会比其他要短, 平均操作时间也会短. 这里就需要权衡了. 
  这里总结一下, 选用map还是hash_map, 关键是看关键字查询操作次数, 以及你所需要保证的是查询总体时间还是单个查询的时间. 如果是要很多次操作, 要求其整体效率, 那么使用hash_map, 平均处理时间短. 如果是少数次的操作, 使用 hash_map可能造成不确定的O(N), 那么使用平均处理时间相对较慢, 单次处理时间恒定的map, 考虑整体稳定性应该要高于整体效率, 因为前提在操作次数较少. 如果在一次流程中, 使用hash_map的少数操作产生一个最坏情况O(N), 那么hash_map的优势也因此丧尽了. 

下面先看一段代码, 从Codeproject的 Jay Kint:

// familiar month example used 
// mandatory contrived example to show a simple point
// compiled using MinGW gcc 3.2.3 with gcc -c -o file.o 
// file.cpp
#include <string>
#include <ext/hash_map>
#include <iostream>
using namespace std;
// some STL implementations do not put hash_map in std
using namespace __gnu_cxx;
hash_map<const char*, int> days_in_month;
class MyClass {
   static int totalDaysInYear;
public:
   void add_days( int days ) { totalDaysInYear += days; }
   static void printTotalDaysInYear(void) 
   { 
       cout << "Total Days in a year are " 
           << totalDaysInYear << endl; 
   }
};
int MyClass::totalDaysInYear = 0;
int main(void)
{
   days_in_month["january"] = 31;
   days_in_month["february"] = 28;
   days_in_month["march"] = 31;
   days_in_month["april"] = 30;
   days_in_month["may"] = 31;
   days_in_month["june"] = 30;
   days_in_month["july"] = 31;
   days_in_month["august"] = 31;
   days_in_month["september"] = 30;
   days_in_month["october"] = 31;
   days_in_month["november"] = 30;
   days_in_month["december"] = 31;
   // ERROR: This line doesn't compile.
   accumulate( days_in_month.begin(), days_in_month.end(),
       mem_fun( &MyClass::add_days ));
   MyClass::printTotalDaysInYear();
   return 0;
}
 
当然上面的代码完全可以使用STL来实现:

引用
Standard C++ Solutions
The Standard C++ Library defines certain function adaptors, select1st, select2nd and compose1, that can be used to call a single parameter function with either the key or the data element of a pair associative container.
select1st and select2nd do pretty much what their respective names say they do. They return either the first or second parameter from a pair.
compose1 allows the use of functional composition, such that the return value of one function can be used as the argument to another. compose1(f,g) is the same as f(g(x)).
Using these function adaptors, we can use for_each to call our function.
hash_map my_map;
for_each( my_map.begin(), my_map.end(), 
         compose1( mem_fun( &MyType::do_something ), 
                   select2nd                    MyType>::value_type>()));
Certainly, this is much better than having to define helper functions for each pair, but it still seems a bit cumbersome, especially when compared with the clarity that a comparable for loop has.
for( hash_map::iterator i = 
        my_map.begin();
    i != my_map.end(), ++i ) {
    i->second.do_something();
}
Considering it was avoiding the for loop for clarity's sake that inspired the use of the STL algorithms in the first place, it doesn't help the case of algorithms vs. hand written loops that the for loop is more clear and concise.
with_data and with_key
with_data and with_key are function adaptors that strive for clarity while allowing the easy use of the STL algorithms with pair associative containers. They have been parameterized much the same way mem_fun has been. This is not exactly rocket science, but it is quickly easy to see that they are much cleaner than the standard function adaptor expansion using compose1 and select2nd.
Using with_data and with_key, any function can be called and will use the data_type or key_type as the function's argument respectively. This allows hash_map, map, and any other pair associative containers in the STL to be used easily with the standard algorithms. It is even possible to use it with other function adaptors, such as mem_fun.
hash_map my_vert_buffers;
void ReleaseBuffers(void)
{
   // release the vertex buffers created so far.
   std::for_each( my_vert_buffers.begin(), 
       my_vert_buffers.end(), 
       with_data( boost::mem_fn( 
           &IDirect3DVertexBuffer9::Release )));
}
Here boost::mem_fn is used instead of mem_fun since it recognizes the __stdcall methods used by COM, if the BOOST_MEM_FN_ENABLE_STDCALL macro is defined.
 
另外添加一些实战的例子:
连接是:
http://blog.sina.com.cn/u/4755b4ee010004hm
摘录如下:

引用
一直都用的STL的map,直到最近库里数据量急剧增大,听别的做检索的同学说到hash_map,一直都打算换回来,今天好好做了个实验测试了哈hash_map的功能,效果以及与map比较的性能.
     首先,要说的是这两种数据结构的都提供了KEY-VALUE的存储和查找的功能.但是实现是不一样的,map是用的红黑树,查询时间复杂度为log (n),而hash_map是用的哈希表.查询时间复杂度理论上可以是常数,但是消耗内存大,是一种以存储换时间的方法.
     就应用来说,map已经是STL标准库的东西,可是hash_map暂时还未进入标准库,但也是非常常用也非常重要的库.
     这次所做的测试是对于100W及的文件列表,去重的表现,即是对文件名string,做map!
用到的头文件:
 

#include <time.h>    //计算时间性能用
     #include <ext/hash_map>   //包含hash_map 的头文件
     #include <map>             //stl的map
     using namespace std;        //std 命名空间
     using namespace __gnu_cxx;    //而hash_map是在__gnu_cxx的命名空间里的
//测试3个环节:用map的效率,hash_map系统hash函数的效率及自写hash函数的效率.
    11 struct str_hash{      //自写hash函数
    12     size_t operator()(const string& str) const
    13     {
    14         unsigned long __h = 0;
    15         for (size_t i = 0 ; i < str.size() ; i ++)
    16         {
    17             __h = 107*__h + str[i];
    18         }
    19         return size_t(__h);
    20     }
    21 };
    23 //struct str_hash{    //自带的string hash函数
    24 //        size_t operator()(const string& str) const
    25 //      {
    26 //          return __stl_hash_string(str.c_str());
    27 //      }
    28 //};
    30 struct str_equal{      //string 判断相等函数
    31     bool operator()(const string& s1,const string& s2) const
    32     {
    33         return s1==s2;
    34     }
    35 };
//用的时候
    37 int main(void)
    38 {
    39     vector<string> filtered_list;
    40     hash_map<string,int,str_hash,str_equal> file_map;
    41     map<string,int> file2_map;
    42     ifstream in("/dev/shm/list");
    43     time_t now1 = time(NULL);
    44     struct tm * curtime;
    45     curtime = localtime ( &now1 );
    46     cout<<now1<<endl;
    47     char ctemp[20];
    48     strftime(ctemp, 20, "%Y-%m-%d %H:%M:%S" , curtime);
    49     cout<<ctemp<<endl;
    50     string temp;
    51     int i=0;
    52     if(!in)
    53     {
    54         cout<<"open failed!~"<<endl;
    55     }
    56     while(in>>temp)
    57     {
    58         string sub=temp.substr(0,65);
    59         if(file_map.find(sub)==file_map.end())
    60 //      if(file2_map.find(sub)==file2_map.end())
    61         {
    62             file_map[sub]=i;
    63 //          file2_map[sub]=i;
    64             filtered_list.push_back(temp);
    65             i++;
    66 //          cout<<sub<<endl;
    67         }
    68     }
    69     in.close();
    70     cout<<"the total unique file number is:"<<i<<endl;
    71     ofstream out("./file_list");
    72     if(!out)
    73     {
    74         cout<<"failed open"<<endl;
    75     }
    76     for(int j=0;j<filtered_list.size();j++)
    77     {
    78         out<<filtered_list[j]<<endl;
    79     }
    80     time_t now2=time(NULL);
    81     cout<<now2<<endl;
    82     curtime = localtime ( &now2 );
    83     strftime(ctemp, 20, "%Y-%m-%d %H:%M:%S" , curtime);
    84     cout<<now2-now1<<"\t"<<ctemp<<endl;
    85     return 0;
    86 }
 

引用
得出来的结论是:(文件list有106W,去重后有51W)
   1.map完成去重耗时34秒
   2.hash_map用系统自带的函数,耗时22秒
   3.hash_map用自己写的函数,耗时14秒
      测试结果充分说明了hash_map比map的优势,另外,不同的hash函数对性能的提升也是不同的,上述hash函数为一同学,测试N多数据后得出的经验函数.
可以预见,当数量级越大时越能体现出hash_map的优势来!~
 
当然最后作者的结论是错误的, hash_map的原理理解错误!从第一个朋友的回答就可以体会到这个问题!
最后对于C++Builder用户, 应该通过以下方法添加:
#include "stlport\hash_map"
才可以正确的使用hash_map
本文来自CSDN博客, 转载请标明出处:http://blog.csdn.net/skyremember/archive/2008/09/18/2941076.aspx

一个简单的例子
/*
 *用来测试STL hash_map 
 *简单例子2008.5.5
*/
#include  <cstdlib>
#include  <iostream>
#include  <string>
#include  <hash_map.h>/*因为hash_map暂不为CPP标准所以没办法写为<hash_map>*/
/*-------------------------------------------*/
using  std::cout;
using  std::endl;
using  std::string;
/*-------------------------------------------*/
/*函数类
 *作为hash_map的hash函数 
 *string没有默认的hash函数 
 */ 
class str_hash{
      public:
       size_t operator()(const string& str) const
        {
                unsigned long __h = 0;
                for (size_t i = 0 ; i < str.size() ; i ++)
                __h = 5*__h + str[i];
                return size_t(__h);
        }
};
/*-------------------------------------------*/
/*函数类 
 *作为hash_map的比较函数 )
 *(查找的时候不同的key往往可能对用到相同的hash值
*/ 
class str_compare
{
      public:
             bool operator()(const string& str1,const string& str2)const
             {return   str1==str2;}
};
/*-------------------------------------------*/
int 
main(int argc, char *argv[])
{  
    hash_map<string,string,str_hash,str_compare>  myhash;
    
    myhash["google"]="newplan";
   
    myhash["baidu"]="zhaoziming";
   
    if(myhash.find("google")!=myhash.end())
      cout<<myhash["google"]<<endl;
    
    system("PAUSE");
    
    return EXIT_SUCCESS;
}
/*-------------------------------------------*/

另一个简单例子
hash_map
代码实现:
#include
#include
#include
 
using namespace __gnu_cxx;
using namespace std;
 
struct str_hash{
    size_t operator()(const string& str) const {
        return __stl_hash_string(str.c_str());
    }
};
 
struct compare_str {
    bool operator()(const string& str1,const string& str2) const{
        return str1 == str2;
    }
};
 
int main()
{
    typedef hash_map namehash;
    namehash strhash;
    namehash::iterator it;
 
    //通过[]方式添加hash_map
    strhash["岳不群"]="华山派掌门人, 人称君子剑";
    strhash["张三丰"]="武当掌门人, 太极拳创始人";
    strhash["东方不败"]="第一高手, 葵花宝典";
 
    //通过pair方式插入hash_map
    strhash.insert(pair("IntPassion", "林元已于, 风而存在"));
    strhash.insert(make_pair("陈英俊", "玉树临风, 英俊潇洒"));
 
    //通过find方式查看hash_map的元素
    it = strhash.find("陈英俊");
    cout<<it->first<<" -> "<<it->second<<endl;
 
    //通过[]方式获取hash_map元素
    cout<<"IntPassion -> "<<strhash["IntPassion"]<<endl;
 
    cout<<"\n遍历输出hash_map:\n";
    for(namehash::iterator itb = strhash.begin(); itb!=strhash.end();itb++)
        cout<<itb->first<<" -> "<<itb->second<<endl;
 
    return 0;
}
 
从性能上来说, const char* 作为键要比string作为键要高;(后面的一篇文章会专门说明性能测试的结果)但是, 使用string作为键更安全. 使用const char*作为键的时候, 要切记const char*指向的位置总是长期有效的. (尤其不要把一个栈内的字符数组加到全局的hash_map中作为键)
 
在这里几点要非常的注意, 否则则会像我在编写该程序的时候, 很简单但是却一直编译错误. 
首先, 要注意的是包含的头文件. hash_map不是C++标准库的一部分, 但因其重要性很多库(如sgi stl, boost等)实现了hash_map, 包括g++编译器所带的头文件也包含了hash_map的实现代码(其实现为sgi stl的版本), 其在include/ext目录下, 该目录还包含了hash_set, rope等的实现. , hash_map定义在__gnu_cxx命名空间中, 故你必须在使用时限定名字空间__gnu_cxx::hash_map, 或者使用using关键字, 如下例:
#include
using namespace __gnu_cxx;
 
在windows 和 linux下引入hash_set, hash_map头文件
推荐使用方法:在源代码的前面写入一下代码:
// just for "#include " in linux
#if __GNUC__>2
#include
#include
#else
#include
#include
using namespace stdext;
#endif
其它解释和方法:
因为hash_map以前不属于标准库, 而是后来引入的. 所以在windows下需要使用stlport, 然后在setting中加入Additional library path. 在linux下使用gcc的时候, 引入, 使用的时候也说找不到hash_map, 而这种后来引入标准库的有两种可能:一种是它被放在了stdext名空间里, 那么就要使用using namespace stdext引入该名空间并#include ;另一种可能就是它被放在标准库的ext目录底下, 这时就仍旧需要使用属于std名空间, 这时你的源文件应当#include ;
 
其次, 这里就是hash_map和hash_set实现上的注意事项. 因为, 在hash_map中, 键类型的hash函数实现只是对于一些基本的类型, char*, nt, char并没有实现string, double
, float这些类型了, 所以要这对string类型必须实现hash函数(第三项于结构体或者自定义类型, 则必须还要实现比较函数(第四项). 说实话, 使用string类型作为键有更好的扩展性和应用性. 比使用char*更加的灵活和方便. 
       最后, 比较重要的一点. 上面实现的hash函数和比较函数都是const函数, 并且函数的参数也是const类型的, 如果少了其中一个都是无法编译通过的. 

第3个简单例子
//hash_map,map,都是将记录型的元素划分为键值和映照数据两个部分;
//不同的是:hash_map采用哈希表的结构而map采用红黑树的结构;
//hash_map键值比较次数少, 占用较多的空间, 遍历出来的元素是非排序的而map是排序的
#include<hash_map>
#include<iostream>
using namespace std;
int main(void)
{
 hash_map<const char*,float>hm;
 //元素的插入:pair<iterator,bool>insert<const value_type &v>
 //insert(inputiterator first,inputiterator last)
 hm["apple"]=1.0f;
 hm["pear"]=1.5f;
 hm["orange"]=2.0f;
 hm["banana"]=1.8f;
 //元素的访问可以用, 数组的方式也可以用迭代器的方式
 hash_map<const char*,float>::iterator i,iend,j;
 iend=hm.end();
 for(i=hm.begin();i!=iend;i++)
 {
  cout<<(*i).first<<"   "
   <<(*i).second<<endl;
 }
 cout<<"**************************************************"<<endl;
 //元素的删除erase(),clear()
 hm.erase("pear");
 for(i=hm.begin();i!=iend;i++)
 {
  cout<<(*i).first<<"   "
   <<(*i).second<<endl;
 }
 
 //元素的搜索
 j=hm.find("pear");
 i=hm.find("apple");
 cout<<"水果:"<<(*i).first<<"  "
  <<"价钱:"<<(*i).second<<endl;
 cout<<"**************************************************"<<endl;
 if(j!=hm.end())
 {
  cout<<"hash_map容器的个数"<<hm.size()<<endl;
 }
 else
 {
  cout<<"哈希表的表长:"<<hm.bucket_count()<<endl;
 }
 return 0;
}


一, 概念
散列技术是在记录的存储位置和他的关键字之间建立一个确定的对应关系f, 是的每个关键字key对应一个存储位置f(key). 查找时, 根据这个对应的关系找到给定值key的映射f(key), 若查找集合中存在这个记录, 则必定在f(key)的位置上. 我们把这种对应关系f成为散列函数, 又称为哈希(Hash)函数. 采用散列技术将记录存储在一块连续的存储空间中, 这块连续空间称为散列表或哈希表(Hash-Table). 
二, 散列表的构造方法
2.1 直接定址法
直接定址法使用下面的公式
f ( k e y ) = a × k e y + b , b 为 常 数 f(key) = a×key+b,b为常数 f(key)=a×key+b,b为常数
比如统计出生年份, 那么就可以使用 f ( k e y ) = k e y − 1990 f(key) = key-1990 f(key)=key−1990来计算散列地址. 

2.2 除留取余法
这种方法是最常用的散列函数构造方法, 对于表长为m的散列公式为
f ( k e y ) = k e y m o d    p ( p ≤ m ) f(key)=key \mod p (p \leq m) f(key)=keymodp(p≤m)

2.3 数字分析法
分析数字关键字在各位上的变化情况, 取比较随机的位作为散列地址这里使用一个手机号码作为例子, 手机号码是一个字符串, 一般的说, 后面4位是真正的用户号. 

2.4 折叠法
把关键词分割成位数相同的几个部分, 然后叠加. 

2.5 平方取中法

三, 冲突解决方法
常用处理冲突的思路:
换个位置: 开放地址法
同一位置的冲突对象组织在一起: 链地址法
3.1 开放地址法
一旦产生了冲突(该地址已有其它元素), 就按某种规则去寻找另一空地址.若发生了第 i 次冲突, 试探的下一个地址将增加 d i d_i di​,  基本公式是:
h i ( k e y ) = ( h ( k e y ) + d i ) m o d    T a b l e S i z e ( 1 ≤ i < T a b l e S i z e ) h_i(key) = (h(key)+d_i) \mod TableSize ( 1≤ i < TableSize ) hi​(key)=(h(key)+di​)modTableSize(1≤i<TableSize)
这里面 d i d_i di​ 决定了不同的解决冲突方案: **线性探测, 平方探测, 双散列. **下面依次介绍各中方法. 
3.1.1 线性探测法
线性探测法以增量序列 1 ,  2 ,  … … ,  ( T a b l e S i z e − 1 ) 1,  2,  ……, (TableSize -1) 1, 2, ……, (TableSize−1)循环试探下一个存储地址. 
[例1] 设关键词序列为 47 ,  7 ,  29 ,  11 ,  9 ,  84 ,  54 ,  20 ,  30 {47,  7,  29,  11,  9,  84,  54,  20,  30} 47, 7, 29, 11, 9, 84, 54, 20, 30,散列表表长 T a b l e S i z e = 11 TableSize =11 TableSize=11 (装填因子 α = 9 / 13 ≈ 0.69 α= 9/13 ≈ 0.69 α=9/13≈0.69),散列函数为: h ( k e y ) = k e y m o d    11 h(key) = key \mod 11 h(key)=keymod11.  用线性探测法处理冲突, 列出依次插入后的散列表, 并估算查找性能. 
[解] 初步的散列地址如下表所示. 
关键词 ( k e y ) (key) (key)	47	7	29	11	9	84	54	20	30
散列地址 h ( k e y ) h(key) h(key)	3	7	7	0	9	7	10	9	8
可以看出, 有多个关键词的散列地址发生了冲突, 具体见下表. 
关键词 ( k e y ) (key) (key)	47	7	29	11	9	84	54	20	30
散列地址 h ( k e y ) h(key) h(key)	3	7	7	0	9	7	10	9	8
冲突次数	0	0	1	0	0	3	1	3	6
具体的哈希表构建过程可以用下面的图表来表示

这里引出一下散列表的的查找性能分析, 散列表的查找性能, 一般有两种方法
成功平均查找长度(ASLs)
不成功平均查找长度 (ASLu)
对于上面一题的散列地址冲突次数为
散列地址 h ( k e y ) h(key) h(key)	0	1	2	3	4	5	6	7	8	9	10	11	12
关键词 ( k e y ) (key) (key)	11	30		47				7	29	9	84	54	20
冲突次数	0	6		0				0	1	0	3	1	3
ASLs: 查找表中关键词的平均查找比较次数(其冲突次数加1)
A S L s = ( 1 + 7 + 1 + 1 + 2 + 1 + 4 + 2 + 4 ) / 9 = 23 / 9 ≈ 2.56 ASLs = (1+7+1+1+2+1+4+2+4) / 9 = 23/9 ≈ 2.56 ASLs=(1+7+1+1+2+1+4+2+4)/9=23/9≈2.56
ASLu:不在散列表中的关键词的平均查找次数(不成功)
一般方法:将不在散列表中的关键词分若干类. 
如:根据H(key)值分类
A S L u = ( 3 + 2 + 1 + 2 + 1 + 1 + 1 + 9 + 8 + 7 + 6 ) / 11 = 41 / 11 ≈ 3.73 ASL u= (3+2+1+2+1+1+1+9+8+7+6) / 11 = 41/11 ≈ 3.73 ASLu=(3+2+1+2+1+1+1+9+8+7+6)/11=41/11≈3.73
参考代码
#include<iostream>#include <stdlib.h>using namespace std;

#define SUCCESS 1#define UNSUCCESS 0#define HASHSIZE 12#define NULLKEY -32768typedef bool Status ;typedef struct {
	int *elem;
	int count;}HashTable;
int m = 0;   //the length of HashTable

//Initialize  of HashTable
Status InitHashTable(HashTable* H){
	int i;
	m = HASHSIZE;
	H->count = m;
	H->elem = (int*)malloc(m*sizeof(int));
	for(i = 0;i < m; i++)
	{
		H->elem[i] = NULLKEY;
	}
	return true;}
//hash functionint Hash(int key){
	return key % m; }
//Insert the elem to the Hahtablevoid InsertHash(HashTable* H,int key){
	int addr = Hash(key);  //get the address of hash
	while(H->elem[addr] != NULLKEY)     //Conflict
		addr = (addr+1) % m;
	H->elem[addr] = key;}

//search the key
Status searchHash(HashTable H,int key,int *addr){
	*addr = Hash(key);
	while(H.elem[*addr] != key)
	{
		*addr = (*addr+1) % m;
		if(H.elem[*addr] == NULLKEY || *addr == Hash(key))
			//return the origin
			return UNSUCCESS;
	}
	return SUCCESS;}
int main(){
	return 0;}
3.1.2 平方探测法
平方探测法以增量序列 1 2 , − 1 2 , 2 2 , − 2 2 , . . . , q 2 1^2 ,-1^2 ,2^2 ,-2^2 ,...,q^2 12,−12,22,−22,...,q2, 且 q ≤ ⌊ T a b l e S i z e / 2 ⌋ q ≤ \lfloor TableSize/2 \rfloor q≤⌊TableSize/2⌋ 循环试探下一个存储地址. 还是使用[例1], 得到的冲突如下表
关键词 key	47	7	29	11	9	84	54	20	30
散列地址h(key)	3	7	7	0	9	7	10	9	8
冲突次数	0	0	1	0	0	2	0	3	3
A S L s = ( 1 + 1 + 2 + 1 + 1 + 3 + 1 + 4 + 4 ) / 9 = 18 / 9 = 2 ASLs =(1+1+2+1+1+3+1+4+4)/ 9 = 18/9 = 2 ASLs=(1+1+2+1+1+3+1+4+4)/9=18/9=2

参考代码
/*******************************************************************************
功    能:哈希表——平方探测法(+/- 1^2,2^2,3^2...)
创建时间: 2018-07-24
作    者:Elvan
修改时间:
作    者:
********************************************************************************/
#include <iostream>#include <string>#include <vector>#include <cmath>#include <malloc.h>using namespace std;
#define MAXTABLESIZE 10000 //允许开辟的最大散列表长度typedef int ElementType;typedef enum{
    Legitimate,
    Empty,
    Deleted} EntryType; //散列单元的状态类型
struct HashEntry{
    ElementType data; //存放的元素
    EntryType state;  //单元状态};
typedef struct HashEntry Cell;
struct TblNode{
    int tablesize; //表的最大长度
    Cell *cells;   //存放散列单元数据的数组};typedef struct TblNode *HashTable;
/*返回大于n且不超过MAXTABLESIZE的最小素数*/int NextPrime(int n){
    int p = (n % 2) ? n + 2 : n + 1; //从大于n的下一个奇数开始
    int i;
    while (p <= MAXTABLESIZE)
    {
        for (i = (int)sqrt(p); i > 2; i--)
        {
            if ((p % i) == 0)
                break;
        }
        if (i == 2)
            break; //说明是素数, 结束
        else
            p += 2;
    }
    return p;}
/*创建新的哈希表*/
HashTable CreateTable(int table_size){
    HashTable h = (HashTable)malloc(sizeof(TblNode));
    h->tablesize = NextPrime(table_size);
    h->cells = (Cell *)malloc(h->tablesize * sizeof(Cell));
    //初始化哈希表状态为空单元
    for (int i = 0; i < h->tablesize; i++)
    {
        h->cells[i].state = Empty;
    }
    return h;}
/*查找数据的初始位置*/int Hash(ElementType key, int n){
    return key % 11; //假设为11}
/*查找元素位置*/int Find(HashTable h, ElementType key){
    int current_pos, new_pos;
    int collision_num = 0; //记录冲突次数

    new_pos = current_pos = Hash(key, h->tablesize); //初始散列位置

    //当该位置元素为非空并且不是要找的元素的时候, 发生冲突
    while (h->cells[new_pos].state != Empty && h->cells[new_pos].data != key)
    {
        collision_num++;
        if (collision_num % 2) //处理奇数冲突
        {
            new_pos = current_pos + (collision_num + 1) * (collision_num + 1) / 4;
            if (new_pos >= h->tablesize)
                new_pos = new_pos % h->tablesize;
        }
        else //处理偶数冲突
        {
            new_pos = current_pos - (collision_num) * (collision_num) / 4;
            while (new_pos < 0)
                new_pos += h->tablesize; //调整到合适大小
        }
    }
    return new_pos;}

/*插入新的元素*/bool Insert(HashTable h,ElementType key){
    int pos = Find(h,key);  //先查找key是否存在
    if(h->cells[pos].state != Legitimate)
    {
        h->cells[pos].state = Legitimate;
        h->cells[pos].data = key;
        return true;
    }
    else
    {
        cout << "键值已存在!"<<endl;
        return false;
    }}

int main(int argc, char const *argv[]){
    int a[] = {47,7,29,11,9,84,54,20,30};
    int n = 9;
    HashTable h = CreateTable(n);
    for(int i = 0;i < n;i++)
    {
        Insert(h,a[i]);  //插入元素
    }
    for(int i = 0;i < h->tablesize;i++)
    {
        cout << h->cells[i].data << " ";  //打印哈希表元素
    }
    cout << endl;
    return 0;}

3.2 链地址法
链地址法就是将相应位置上冲突的所有关键词存储在同一个单链表中
[例2] 设关键字序列为 47 , 7 , 29 , 11 , 16 , 92 , 22 , 8 , 3 , 50 , 37 , 89 , 94 , 21 47, 7, 29, 11, 16, 92, 22, 8, 3, 50, 37, 89, 94, 21 47,7,29,11,16,92,22,8,3,50,37,89,94,21, 散列函数取为 h ( k e y ) = k e y m o d    11 h(key) = key \mod 11 h(key)=keymod11, 用分离链接法处理冲突. 

[解]表中有9个结点只需1次查找, 5个结点需要2次查找, 所以查找成功的平均查找次数为
A S L s = ( 9 + 5 ∗ 2 ) / 14 ≈ 1.36 ASLs=(9+5*2)/ 14 ≈ 1.36 ASLs=(9+5∗2)/14≈1.36
参考代码
/*******************************************************************************
功    能:哈希表——链表法(+/- 1^2,2^2,3^2...)
创建时间: 2018-07-24
作    者:Elvan
修改时间:
作    者:
********************************************************************************/
#include <iostream>#include <string>#include <vector>#include <cmath>#include <malloc.h>using namespace std;
#define MAXTABLESIZE 10000 //允许开辟的最大散列表长度#define KEYLENGTH 100      //关键字的最大长度
typedef int ElementType;struct LNode{
    ElementType data;
    LNode *next;};typedef LNode *PtrToNode;typedef PtrToNode LinkList;struct TblNode{
    int tablesize;  //表的最大长度
    LinkList heads; //存放散列单元数据的数组};typedef struct TblNode *HashTable;
/*返回大于n且不超过MAXTABLESIZE的最小素数*/int NextPrime(int n){
    int p = (n % 2) ? n + 2 : n + 1; //从大于n的下一个奇数开始
    int i;
    while (p <= MAXTABLESIZE)
    {
        for (i = (int)sqrt(p); i > 2; i--)
        {
            if ((p % i) == 0)
                break;
        }
        if (i == 2)
            break; //说明是素数, 结束
        else
            p += 2;
    }
    return p;}
/*创建新的哈希表*/
HashTable CreateTable(int table_size){
    HashTable h = (HashTable)malloc(sizeof(TblNode));
    h->tablesize = NextPrime(table_size);
    h->heads = (LinkList)malloc(h->tablesize * sizeof(LNode));
    //初始化表头结点
    for (int i = 0; i < h->tablesize; i++)
    {
        h->heads[i].next = NULL;
    }
    return h;}
/*查找数据的初始位置*/int Hash(ElementType key, int n){
    //这里只针对大小写
    return key % 11;}
/*查找元素位置*/
LinkList Find(HashTable h, ElementType key){
    int pos;

    pos = Hash(key, h->tablesize); //初始散列位置

    LinkList p = h->heads[pos].next; //从链表的第一个节点开始
    while (p && key != p->data)
    {
        p = p->next;
    }

    return p;}
/*插入新的元素*/bool Insert(HashTable h, ElementType key){
    LinkList p = Find(h, key); //先查找key是否存在
    if (!p)
    {
        //关键词未找到, 可以插入
        LinkList new_cell = (LinkList)malloc(sizeof(LNode));
        new_cell->data = key;
        int pos = Hash(key, h->tablesize);
        new_cell->next = h->heads[pos].next;
        h->heads[pos].next = new_cell;
        return true;
    }
    else
    {
        cout << "键值已存在!" << endl;
        return false;
    }}
/*销毁链表*/void DestroyTable(HashTable h){
    int i;
    LinkList p, tmp;
    //释放每个节点
    for (i = 0; i < h->tablesize; i++)
    {
        p = h->heads[i].next;
        while (p)
        {
            tmp = p->next;
            free(p);
            p = tmp;
        }
    }
    free(h->heads);
    free(h);}
int main(int argc, char const *argv[]){
    int a[] = {47, 7, 29,29, 11, 16, 92, 22, 8, 3, 50, 37, 89, 94, 21};
    int n = 15;
    HashTable h = CreateTable(n);
    for (int i = 0; i < n; i++)
    {
        Insert(h, a[i]); //插入元素
    }
    for (int i = 0; i < h->tablesize; i++)
    {
        LinkList p = h->heads[i].next;
        while (p)
        {
            cout << p->data << " "; //打印哈希表元素
            p = p->next;
        }
        cout << endl;
    }
    return 0;}


## set 集合
set集合最大的特点是里面的元素按序排列不重复, 图片演示集合初始化, 插入, 删除, 查找等操作. 
set也是一个特别有用的数据结构, 利用它的唯一性, 可以实现对整型数据去重和排序. 

使用场景 : set一般用于查找问题中的查找有无, 即给定一个元素判断这个元素是否存在于这个数组中. 还可以用来删除数组中特定的数
头文件 : #include < set >
定义 : set< typename > s //这里的typename可以是任何一种数据类型
使用

    s.insert(x); //插入一个元素, 复杂度为log(n) 
    s.erase(x);  //删除一个元素, 复杂度为log(n)   在遍历时删除的话, 先用一个变量存当前的值, 先让迭代器++, 再删除
    s.size();    //返回当前set中的大小 
    s.empty();   //判断set是否为空, 为空返回true 
    s.begin() ;  //返回set第一个元素的迭代器, 注意不是数值 
    s.end();     //返回set最后一个元素下一位置的迭代器 
    s.find(x);    //返回x在set中的迭代器, 若不存在则返回s.end()
    if(s.find(x)!=record.end())  //x存在与s中
    {}
    set<int> record(nums1.begin(),nums1.end());//使用vector创建set
    tmp.insert(make_pair(s[i],t[i])); //在set中插入键值对
     
    //遍历
    set<int>::iterator it;   //定义迭代器
    for(it=s.begin();it!=s.end();it++)
    {
    	cout << *it << " ";    //注意是迭代器, 需要加上*才可以输出值
    }



std::array<int, 10> arr{1, 3, 7, 3, 2, 6, 4, 4, 1, 5}; // 对arr进行去重并按照从小到大的顺序排序
std::set<int> arr_sort;
for(int i = 0; i < arr.size(); i++)
	arr_sort.insert(arr[i]);
// result: arr_sort = {1, 2, 3, 4, 5, 6, 7};

// 也支持和其他数据结构配合使用, 比如pair
std::set<std::pair<int, int>> set_pair;
set_pair.insert(std::pair<int, int>(1, 2));
set_pair.insert(std::pair<int, int>(1, 1)); // 它会会先按照first排序, 然后second, 同样也有去重的功能
for(std::set<std::pair<int, int>>::iterator iter=set_pair.begin(); iter!=set_pair.end(); iter++)
	std::cout << "set_pair=(" << iter->first << ", " << iter->second << ")\n";

## vector向量
vector向量和array不同, 它可以根据数据的大小而进行自动调整, 图片仅展示初始化, 插入, 删除等操作. 

vector是一个变长数组, 在平时的使用的会常常用到, 当我们常常需要在一个数组后频繁插入和删除一个元素时, 就可以考虑使用vector

头文件 : #include < vector >
定义 : vector< typename > vec; //typename可以是任意的数据结构

使用

    vector<int> vec(5);     //声明一个vector, 并为其赋予5的内存空间
    vector<int> vec(5,1);   //赋予5的内存空间, 并把初值都设为1;
    vec = vector<int>(5,1); //重新初始化vec的值;
    vec.size();             //返回vector的长度, 复杂度为O(1);
    vec.clear();            //清空vector的内容, 并将内存释放;
    vec.push_back(x);       //在vector后插入x, 插入和删除操作使用均摊复杂度来算, 复杂度为O(1), 使用时方便且复杂度低, 相当推荐;
    vec.pop_back();         //删除vector最后一个元素, 复杂度为O(1);
    vec.begin();            //返回vector的起始地址;
    vec.end();              //返回vector的终止地址;
    sort( vec.begin(),vec.end() );      //对vector排序;
    vec.erase( vec.begin() );           //删除vec的首地址的元素, 注意传入的一定要是一个地址, 复杂度O(n), 不建议使用
     
    //遍历
    for( int i = 0 ; i < vec.size() ; i++ )
    {
    	cout << a[i] << endl;
    }
    或者:
    vector<int>:: iterator it;
    for( it = vec.begin() ; it != vec.end() ; it++ )
    {
    	cout << *it << endl;
    }



std::vector<int> vec;
std::vector<int> vec(3); // 深度为3的整形数据
std::vector<int> vec(3, 1); // 深度为3的整形数据, 初始化为1
vec.size() // 获得vec中元素的个数, 也就是size(尺寸)
vec.push_back(2); // push 2到vec末尾中, 深度增加1
vec.resize(5) // 重新设置vec的size, 我一般是增加size, 此时原有数据是不改变的, 相比push_back()一个个的增加数据, 这样做的效率会高一些. 
vec.data() // 返回一个指向vec的pointer
vec.clear() //清空vec
// 而且std::vector非常灵活, 可以和各种数据结构搭配使用:
std::vector<std::array<int, 5>> //二位数据如果列数固定, 可以在里面使用array, 如果长度可调, 可继续使用vector. 个人意见是可以用array则用. 
std::vector<std::pair<int, std::string>> vec_pair; // 定义了一个int+string的键值对数组
vec_pair.push_back(std::pair<int, std::string>(1, "abc"));
std::cout << "vec_pair[0] = "( << vec_pair[0].first << ", " << vec_pair[0].second << ")\n"; 


总结
这些容器在http://www.cplusplus.com/网站都有详细的介绍, 看文档很容易学会它们, 毕竟都把实现过程都隐藏起来了, 只需要多加实践即可掌握这些容器的使用方法, 多练多操作. 





# C++数据结构和算法 面试
##  1, String原理及实现
       string类是由模板类basic_string<class _CharT,class _traits,class _alloc>实例化生成的一个类. basic_tring是由_String_base继承而来的. 
typedef basic_string<char> string
       而实际面试由于时间关系, 一般不会要求很详细的string的功能, 一般要求是实现构造函数, 拷贝构造函数, 赋值函数, 析构函数等部分, 因为string里面涉及动态内存管理, 默认的拷贝构造函数在运行只会进行浅复制, 这样会造成两个对象指向一块区域内存的对象. 如果一个对象被销毁, 会造成另外一个对象运行出错, 这时要进行深拷贝. 
#pragma once
#include<iostream>
class String
{
private:
	char*  data;   //字符串内容
	size_t length; //字符串长度

public:
	String(const char* str = nullptr);  //通用构造函数
	String(const String& str);          //拷贝构造函数
	~String();                          //析构函数

	String operator+(const String &str) const;  //重载+
	String& operator=(const String &str);       //重载=
	String& operator+=(const String &str);      //重载+=
	bool operator==(const String &str) const;   //重载==

        friend std::istream& operator>>(std::istream &is, String &str);//重载>>
	friend std::ostream& operator<<(std::ostream &os, String &str);//重载<<

	char& operator[](int n)const;               //重载[]

	size_t size() const;                        //获取长度
	const char* c_str() const;                  //获取C字符串
};
#include"String.h"

//通用构造函数
String::String(const char *str)
{
	if (!str)
	{
		length = 0;
		data = new char[1];  //一定要用new分配内存, 否则就变成了浅拷贝;
		*data = '\0';
	}
	else
	{
		length = strlen(str); //
		data = new char[length + 1];
		strcpy(data,str);
	}
}

//拷贝构造函数
String::String(const String& str)
{
	length = str.size();
	data = new char[length + 1];  //一定要用new,否则变成了浅拷贝
	strcpy(data,str.c_str());
}

//析构函数
String::~String()
{
	delete[]data;
	length = 0;
}

//重载+
String String::operator+(const String &str) const  
{
	String StringNew;
	StringNew.length = length + str.size();

	StringNew = new char[length + 1];
	strcpy(StringNew.data, data);
	strcat(StringNew.data, str.data);  //字符串拼接函数, 即将str内容复制到StringNew内容后面
	return StringNew;
}

//重载=
String& String::operator=(const String &str)       
{
	if (this == &str)
	{
		return *this;
	}

	delete []data;                 //释放内存
	length = str.length;
	data = new char[length + 1];
	strcpy(data,str.c_str());
	return *this;
}

//重载+=
String& String::operator+=(const String &str)      
{
	length += str.size();
	char *dataNew = new char[length + 1];
	strcpy(dataNew, data);
	delete[]data;
	strcat(dataNew, str.c_str());
	data = dataNew;
	return *this;
}

//重载==
bool String::operator==(const String &str) const   
{
	if (length != str.length)
	{
		return false;
	}
	return strcmp(data, str.data) ? false : true;
}

//重载[]
char& String::operator[](int n) const           //str[n]表示第n+1个元素   
{
	if (n >= length)
	{
		return data[length - 1]; //错误处理
	}
	else
	{
		return data[n];
	}
}

 //获取长度
size_t String::size() const                      
{
	return this->length;
}

//获取C字符串
const char* String::c_str() const                 
{
	return data;
}

//重载>>

std::istream& operator>>(std::istream &is, String &str)
{
	char tem[1000];
	is >> tem;
	str.length = strlen(tem);
	str.data = new char[str.length + 1];
	strcpy(str.data, tem);
	return is;
}

//重载<<
std::ostream& operator<<(std::ostream &os, String &str)
{
	os << str.c_str();
	return os;
}
       关于operator>>和operator<<运算符重载, 我们是设计成友元函数(非成员函数), 并没有设计成成员函数, 原因如下:对于一般的运算符重载都设计为类的成员函数, 而>>和<<却不这样设计, 因为作为一个成员函数, 其左侧操作数必须是隶属同一个类之下的对象, 如果设计成员函数, 输出为对象>>cout >> endl;(Essential C++)不符合习惯. 
一般情况下:
将双目运算符重载为友元函数, 这样就可以使用交换律, 比较方便
单目运算符一般重载为成员函数, 因为直接对类对象本身进行操作
运算符重载函数可以作为成员函数, 友元函数, 普通函数. 
普通函数:一般不用, 通过类的公共接口间接访问私有成员. 
成员函数:可通过this指针访问本类的成员, 可以少写一个参数, 但是表达式左边的第一个参数必须是类对象, 通过该类对象来调用成员函数. 
友元函数:左边一般不是对象. << >>运算符一般都要申明为友元重载函数
##  2, 链表的实现
2.1, 顺序链表
最简单的数据结构, 开辟一块连续的存储空间, 用数组实现
#pragma once
#ifndef SQLIST_H
#define SQLIST_H

#define MaxSize 50
typedef int DataType;

struct SqList  //顺序表相当于一个数组, 这个结构体就已经表示了整个顺序表
{
	DataType data[MaxSize];
	int length;  //表示顺序表实际长度
};//顺序表类型定义


void InitSqList(SqList * &L);

//释放顺序表
void DestroySqList(SqList * L);

//判断是否为空表
int isSqListEmpty(SqList * L);

//返回顺序表的实际长度
int SqListLength(SqList * L);

//获取顺序表中第i个元素值
DataType SqListGetElem(SqList * L, int i);

//在顺序表中查找元素e,并返回在顺序表哪个位置
int GetElemLocate(SqList * L, const DataType e);

//在第i个位置插入元素
int SqListInsert(SqList *&L, int i, DataType e);

//删除第i个位置元素,并返回该元素的值
DataType SqListElem(SqList* L, int i);

#endif
#include<iostream>
#include"SqList.h"
using namespace std;

//初始化顺序表
void InitSqList(SqList * &L)
{
	L = (SqList*)malloc(sizeof(SqList)); // 开辟内存
	L->length = 0;
}

//释放顺序表
void DestroySqList(SqList * L)
{
	if (L == NULL)
	{
		return;
	}
	free(L);
}

//判断是否为空表
int isSqListEmpty(SqList * L)
{
	if (L == NULL)
	{
		return 0;
	}
	return (L->length == 0);
}

//返回顺序表的实际长度
int SqListLength(SqList * L)
{
	if (L == NULL)
	{ 
		cout << "顺序表分配内存失败" << endl;
		return 0;
	}
	return L->length;
}

//获取顺序表中第i个元素值
DataType SqListGetElem(SqList * L,int i)
{
	if (L == NULL)
	{
		cout << "No Data in SqList" << endl;
		return 0;
	}
	return L->data[i - 1];
}

//在顺序表中查找元素e,并返回在顺序表哪个位置
int GetElemLocate(SqList * L, const DataType e)
{
	if( L == NULL)
	{
		cout << "Empty SqList" << endl;
		return 0;
	}
	int i = 0;
	while(i < L->length && L->data[i] != e)
	{
		i++;
	}
	if (i > L->length)
		return 0;
	return i + 1;
}

//在第i个位置插入元素
int SqListInsert(SqList *&L, int i, DataType e)
{
	if(L == NULL)
	{
		cout << "error" << endl;
		return 0;
	}
	if (i > L->length + 1 || i < 1)
	{
		cout << "error" << endl;
		return 0;
	}
	for (int j = L->length; j>=i - 1; j--) //将i之后的元素后移, 腾出空间
	{
		L->data[j] = L->data[j - 1];
	}
	L->data[i] = e;
	L->length++;
	return 1;
}

//删除第i个位置元素,并返回该元素的值
DataType SqListElem(SqList* L, int i)
{
	if (L == NULL)
	{
		cout << "error" << endl;
		return 0;
	}
	if (i < 0 || i > L->length)
	{
		cout << "error" << endl;
		return 0;
	}
	DataType e = L->data[i - 1];
	for (int j = i; j < L->length;j++)
	{
		L->data[j] = L->data[j + 1];
	}
	L->length--;
	return e;
}
2.2, 链式表
#pragma once
#ifndef LINKLIST_H
#define LINKLIST_H

typedef int DataType;


//单链表:单链表是一个节点一个节点构成, 
//先定义一个节点, 节点为一个结构体, 当这些节点连在一起, 
// 链表为指向头结点的结构体型指针, 即是LinkList型指针

typedef struct LNode  //定义的是节点的类型
{
	DataType data;
	struct LNode *next; //指向后继节点
}LinkList;


void InitLinkList(LinkList * &L);    //初始化链表
void DestroyLinkList(LinkList * L); //销毁单链表
int isEmptyLinkList(LinkList * L);  //判断链表是否为空
int LinkListLength(LinkList * L);   //求链表长度
void DisplayLinkList(LinkList * L); //输出链表元素
DataType LinkListGetElem(LinkList * L,int i);//获取第i个位置的元素值
int LinkListLocate(LinkList * L,DataType e);  //元素e在链表的位置
int LinkListInsert(LinkList * &L,int i,DataType e);//在第i处插入元素e
DataType LinkListDelete(LinkList * &L,int i); //删除链表第i处的元素
#endif
#include<iostream>
#include"LinkList.h"
using namespace std;

void InitLinkList(LinkList * &L)    //初始化链表
{
	L = (LinkList*)malloc(sizeof(LinkList)); //创建头结点
	L->next = NULL;
}

void DestroyLinkList(LinkList * L) //销毁单链表
{
	LinkList *p = L, *q = p->next;//创建辅助节点指针

	if(L == NULL)
	{
		return;
	}

	while (q != NULL) //销毁一个链表, 必须一个节点一个节点的销毁
	{
		free(p);
		p = q;
		q = p->next;
	}
	free(p);
}

int isEmptyLinkList(LinkList * L)  //判断链表是否为空
{
	return (L->next == NULL);// 1:空;0:非空
}

int LinkListLength(LinkList * L)  //求链表长度, 链表的长度必须一个节点一个节点的遍历
{
	LinkList *p = L;

	if (L == NULL)
	{
		return 0;
	}

	int i = 0;
	while (p->next != NULL)
	{
		i++;
		p = p->next;
	}
	return i;
}

void DisplayLinkList(LinkList * L)//输出链表元素
{
	LinkList * p = L->next; //此处一点要指向next,这样是第一个节点, 跳过了头结点

	while (p != NULL)
	{
		cout << p->data << " ";
		p = p->next;
	}
	cout << endl;
}

DataType LinkListGetElem(LinkList * L, int i)//获取第i个位置的元素值
{
	LinkList *p = L;

	if (L == NULL || i < 0)
	{
		return 0;
	}

	int j = 0;
	while (j < i  && p->next != NULL)
	{
		j++; p = p->next;
	}

	if (p == NULL)
	{
		return 0;
	}
	else
	{
		return p->data;
	}
}

int LinkListLocate(LinkList * L, DataType e)  //元素e在链表的位置
{
	LinkList *p = L;

	if (L == NULL)
	{
		return 0;
	}

	int j = 0;
	while (p->next != NULL && p->data == e)
	{
		j++;
	}
	return j+1;
}

int LinkListInsert(LinkList * &L, int i, DataType e)//在第i处插入元素e
{
	LinkList *p = L,*s;
	int j = 0;

	if (L == NULL )
	{
		return 0;
	}

	while (j < i-1 && p != NULL) //先将指针移到该处
	{
		j++;
		p = p->next;
	}

	s = (LinkList*)malloc(sizeof(LinkList)); //添加一个节点, 需开辟一个新的内存
	s->data = e;
	s->next = p->next;   //先将下一地址给新节点
	p->next = s;    //将原来的指针指向新节点
	return 1;
}

DataType LinkListDelete(LinkList * &L, int i) //删除链表第i处的元素
{
	LinkList *p = L,*q;  //p用来存储临时节点
	DataType e;          //用来存被删除点的元素
	
	int j = 0;
	while (j < i - 1 && p != NULL) //将p指向第i-1节点
	{
		j++;
		p = p->next;
	}
	
	if (p == NULL)
	{
		return 0;
	}
	else
	{
		q = p->next; //q指向第i个节点*p
		e = q->data; //
		p->next = q->next;//从链表中删除p节点, 即是p->next = p->next->next,将第i个节点信息提取出来
		free(q);  //释放p点内存
		return e;
	}
}
2.3, 双链表
#pragma once
#ifndef DLINKLIST_H
#define DLINKLIST_H

typedef int DataType;

typedef struct DLNode
{
	DataType Elem;
	DLNode *prior;
	DLNode *next;
}DLinkList;

void DLinkListInit(DLinkList *&L);//初始化双链表
void DLinkListDestroy(DLinkList * L); //双链表销毁
bool isDLinkListEmpty(DLinkList * L);//判断链表是否为空
int  DLinkListLength(DLinkList * L);  //求双链表的长度
void DLinkListDisplay(DLinkList * L); //输出双链表
DataType DLinkListGetElem(DLinkList * L, int i); //获取第i个位置的元素
bool DLinkListInsert(DLinkList * &L, int i, DataType e);//在第i个位置插入元素e
DataType DLinkListDelete(DLinkList * &L, int i);//删除第i个位置上的值, 并返回其值
#endif
#include<iostream>
#include"DLinkList.h"
using namespace std;


void DLinkListInit(DLinkList *&L)//初始化双链表
{
	L = (DLinkList *)malloc(sizeof(DLinkList)); //创建头结点
	L->prior = L->next = NULL;
}


void DLinkListDestroy(DLinkList * L) //双链表销毁
{
	if (L == NULL)
	{
		return;
	}
	DLinkList *p = L, *q = p->next;//定义两个节点, 第一个表示当前节点, 第二个表示第二个节点
	while (q != NULL)              //当第二个节点指向null, 说明p是最后一个节点, 如果不是, 则
	{                              //释放掉p, q就为第一个节点, 将q赋给p, p->给q, 这样迭代
		free(p);
		p = q;
		q = p->next;
	}
	free(p);
}


bool isDLinkListEmpty(DLinkList * L)//判断链表是否为空
{
	return L->next == NULL;
}


int  DLinkListLength(DLinkList * L)  //求双链表的长度
{
	DLinkList *p = L;

	if (L == NULL)
	{
		return 0;
	}

	int i = 0;
	while (p->next != NULL)
	{
		i++;
		p = p->next;
	}
	return i;
}

void DLinkListDisplay(DLinkList * L) //输出双链表
{
	DLinkList *p = L->next;  //跳过头结点, 指向第一个节点
	while (p != NULL)
	{
		cout << p->Elem << "  ";
		p = p->next;
	}
}

DataType DLinkListGetElem(DLinkList * L, int i) //获取第i个位置的元素
{
	DLinkList *p = L;//指向头结点

	if (L == NULL)
	{
		cout << "Function DLinkListGetElem" << "链表为空表" << endl;
		return 0;
	}

	int j = 0;
	while (p != NULL && j < i) //将指针指向第i个位置处
	{
		j++;
		p = p->next;
	}

	if (p == NULL)
	{
		return 0;
	}
	else
	{
		return p->Elem;
	}
}

bool DLinkListInsert(DLinkList * &L, int i, DataType e)//在第i个位置插入元素e
{
	int j = 0;
	DLinkList *p = L, *s;//其中s节点是表示插入的那个节点, 所以要给它开辟内存

	while (p != NULL && j < i - 1)  //插入节点前, 先找到第i-1个节点
	{
		j++;
		p = p->next;
	}

	if( p == NULL)
	{
		return 0;
	}
	else
	{
		s = (DLinkList *)malloc(sizeof(DLinkList));
		s->Elem = e;
		s->next = p->next;//插入点后继的指向
		if (p->next != NULL)
		{
			p->next->prior = s;  //插入点的后继的前驱指向
		}
		s->prior = p; //插入点前驱的前驱指向
		p->next = s; //插入点后前驱的后继指向
	}
}

DataType DLinkListDelete(DLinkList * &L, int i)//删除第i个位置上的值, 并返回其值
{
	DLinkList *p = L, *s;
	int j = 0;

	if (L == NULL)
	{
		cout << "Function DLinkListDelete" << "删除出错" << endl;
		return 0;
	}

	while (j < i - 1 && p != NULL)
	{
		j++;
		p = p->next;
	}

	if (p == NULL)
	{
		return 0;
	}
	else
	{
		s = p->next;
		if (s == NULL)
		{
			return 0;
		}
		DataType e = p->Elem;
		p->next = s->next;
		if (p->next != NULL)
		{
			p->next->prior = p;
		}
		free(s);
		return e;
	}
}
2.4, 循环链表
##  3, 队列
3.1, 顺序队列
#pragma once
#ifndef SQQUEUE_H
#define SQQUEUE_H

#define MaxSize 50
typedef int DataType;

typedef struct SQueue //创建一个结构体, 里面包含数组和队头和队尾
{
	DataType data[MaxSize]; 
	int front, rear; //front表示队头, rear表示队尾, 入队头不动尾动, 出队尾不动头动
}SqQueue;

void SqQueueInit(SqQueue *&Q);              //队列初始化
void SqQueueClear(SqQueue *$Q);             //清空队列
bool isSqQueueEmpty(SqQueue *Q);            //判断队列长度
int  SqQueueLength(SqQueue *Q);             //求队列的长度
void SqQueueDisplay(SqQueue *Q);            //输出队列
void EnSqQueue(SqQueue *& Q,DataType e);    //进队
DataType DeSqQueue(SqQueue *& Q);           //出队

#endif
#include<iostream>
#include"SqQueue.h"
using namespace std;

void SqQueueInit(SqQueue *&Q)   //队列初始化
{
	Q = (SqQueue *)malloc(sizeof(Q));
	Q->front = Q->rear = 0;
}

void SqQueueClear(SqQueue *&Q)  //清空队列
{
	free(Q); //对于顺序栈, 直接释放内存即可
}

bool isSqQueueEmpty(SqQueue *Q) //判断队列长度
{
	return (Q->front == Q->rear);
}

int  SqQueueLength(SqQueue *Q)  //求队列的长度
{
	return Q->rear - Q->front;  //此处有问题
}

void EnSqQueue(SqQueue *& Q,DataType e)    //进队
{
	if (Q == NULL)
	{
		cout << "分配内存失败!" << endl;
		return;
	}

	if (Q->rear >= MaxSize)  //入队前进行队满判断
	{
		cout << "The Queue is Full!" << endl;
		return;
	}

	Q->rear++;
	Q->data[Q->rear] = e;
}

DataType DeSqQueue(SqQueue *& Q)     //出栈
{
	if (Q == NULL)
	{
		return 0;
	}

	if (Q->front == Q->rear) //出队前进行空队判断
	{
		cout << "This is an Empty Queue!" << endl;
		return 0;
	}

	Q->front--;
	return Q->data[Q->front];
}

void SqQueueDisplay(SqQueue *Q)           //输出队列
{
	if (Q == NULL)
	{
		return;
	}

	if (Q->front == Q->rear)
	{
		return;
	}
	int i = Q->front + 1;
	while (i <= Q->rear)
	{
		cout << Q->data[i] << "  ";
		i++;
	}
}
3.2, 链式队列
#pragma once
#ifndef LINKQUEUE_H
#define LINKQUEUE_H

typedef int DataType;

/*
  队列的链式存储中, 由于需要指针分别指向
  队头和队尾, 因此造成了链队节点与数据节点不同
  链队节点:包含两个指向队头队尾的指针
  数据节点:一个指向下一个数据节点的指针和数据
*/


//定义数据节点结构体
typedef struct qnode
{
	DataType Elem;
	struct qnode *next;
}QDataNode;

//定义链队节点结构体
typedef struct 
{
	QDataNode *front;
	QDataNode *rear;
}LinkQueue;

void LinkQueueInit(LinkQueue *&LQ);           //初始化链队
void LinkQueueClear(LinkQueue *&LQ);          //清空链队
bool isLinkQueueEmpty(LinkQueue *LQ);         //判断链队是否为空
int LinkQueueLength(LinkQueue *LQ);           //求链队长度
bool EnLinkQueue(LinkQueue *&LQ,DataType e);  //进队
DataType DeLinkQueue(LinkQueue *&LQ);         //出队

#endif
#include<iostream>
#include"LinkQueue.h"
using namespace std;

void LinkQueueInit(LinkQueue *&LQ)   //初始化链队
{
	LQ = (LinkQueue*)malloc(sizeof(LQ));
	LQ->front = LQ->rear = NULL;
}

void LinkQueueClear(LinkQueue *&LQ)  //清空链队,清空队列第一步:销毁数据节点
                                    // 第二步:销毁链队节点
{
	QDataNode *p = LQ->front, *r;
	if (p != NULL)
	{
		r = p->next;
		while (r != NULL)
		{
			free(p);
			p = r;
			r = p->next;
		}
	}
	free(LQ);
}

bool isLinkQueueEmpty(LinkQueue *LQ) //判断链队是否为空
{
	return LQ->rear == NULL;  //1:非空;0:空
}

int LinkQueueLength(LinkQueue *LQ)  //求链队长度
{
	QDataNode *p = LQ->front;
	int i = 0;
	while (p != NULL)
	{
		i++;
		p = p->next;
	}
	return i;
}
bool EnLinkQueue(LinkQueue *&LQ, DataType e)      //进队
{
	QDataNode *p;

	if (LQ == NULL)
	{
		return 0;
	}

	p = (QDataNode*)malloc(sizeof(QDataNode));
	p->Elem = e;
	p->next = NULL; //尾插法

	if (LQ->front == NULL)//如果队列中还没有数据时
	{
		LQ->front = LQ->rear = p; //p为队头也为队尾
	}
	else
	{
		LQ->rear->next = p;
		LQ->rear = p;
	}
}
DataType DeLinkQueue(LinkQueue *&LQ)  //出队
{
	QDataNode *p;
	DataType e;
	if (LQ->rear == NULL)
	{
		cout << "This is an Empty queue!" << endl;
		return 0;
	}

	if (LQ->front == LQ->rear)
	{
		p = LQ->front;
		LQ->rear = LQ->front = NULL;
	}
	else
	{
		p = LQ->front;
		LQ->front = p->next;
		e = p->Elem;
	}
	free(p);
	return e;
}
##  4, 栈
4.1, 顺序栈
#pragma once
#ifndef SQSTACK_H
#define SQSTACK_H

#define MaxSize 50//根据实际情况设置大小
typedef int DataType;

//顺序栈也是一种特殊的顺序表, 创建一个
//结构体, 里面包含一个数组, 存储数据

//顺序栈其实是将数组进行结构体包装

typedef struct Stack
{
	DataType Elem[MaxSize];
	int top;        //栈指针
}SqStack;

void SqStackInit(SqStack *&S);  //初始化栈
void SqStackClear(SqStack *&S);   //清空栈
int  SqStackLength(SqStack *S);  //求栈的长度
bool isSqStackEmpty(SqStack *S); //判断栈是否为空
void SqStackDisplay(SqStack *S); //输出栈元素
bool SqStackPush(SqStack *&S, DataType e);//元素e进栈
DataType SqStackPop(SqStack *&S);//出栈一个元素
DataType SqStackGetPop(SqStack *S);//取栈顶元素
#endif
#include<iostream>
#include"SqStack.h"
using namespace std;

void SqStackInit(SqStack *&S)  //初始化栈
{
	S = (SqStack*)malloc(sizeof(SqStack)); //开辟内存,创建栈
	S->top = -1;                           
}

void SqStackClear(SqStack *&S)   //清空栈
{
	free(S);
}

int  SqStackLength(SqStack *S)  //求栈的长度
{
	return S->top + 1;
}

bool isSqStackEmpty(SqStack *S) //判断栈是否为空
{
	return (S->top == -1);
}

void SqStackDisplay(SqStack *S) //输出栈元素
{
	for (int i = S->top; i > -1; i--)
	{
		cout << S->Elem[i] << "  ";
	}
}

bool SqStackPush(SqStack *&S, DataType e)//元素e进栈
{
	if ( S->top == MaxSize - 1)
	{
		cout << "The Stack Full!" << endl; //满栈判断
		return 0;
	}
	S->top++;
	S->Elem[S->top] = e;
	return 1;
}

DataType SqStackPop(SqStack *&S)//出栈一个元素
{
	DataType e;

	if(S->top== -1)  //空栈判断
	{
		cout << "The Stack is Empty!" << endl;
		return 0;
	}

	e = S->Elem[S->top];//出栈元素存储
	S->top--;
	return e;
}

DataType SqStackGetPop(SqStack *S)//取栈顶元素
{
	if (S->top == -1) //空栈判断
	{
		cout << "The Stack is Empty" << endl;
		return 0;
	}

	return S->Elem[S->top];
}
4.2, 链式栈
#pragma once
#ifndef LINKSTACK_H
#define LINKSTACK_H

typedef int DataType;

typedef struct LinkNode  //链式栈的结点定义和链表的结点定义是一样的
{
	DataType Elem;                           //数据域
	struct LinkNode *next;                   //指针域
}LinkStack;

void LinkStackInit(LinkStack *& S);          //初始化列表
void LinkStackClear(LinkStack*&S);           //清空栈
int  LinkStackLength(LinkStack * S);         //求链表的长度
bool isLinkStackEmpty(LinkStack *S);         //判断链表是否为空
bool LinkStackPush(LinkStack *S, DataType e);//元素e进栈
DataType LinkStackPop(LinkStack *S);         //出栈
DataType LinkStackGetPop(LinkStack *S);      //输出栈顶元素
void LinkStackDisplay(LinkStack *S);         //从上到下输出栈所有元素
#endif
#include<iostream>
#include"LinkStack.h"
using namespace std;

void LinkStackInit(LinkStack *& S) //初始化列表
{
	S = (LinkStack *)malloc(sizeof(LinkStack)); //分配内存
	S->next = NULL;
}

void LinkStackClear(LinkStack*&S) //清空栈
{
	LinkStack *p = S,*q = S->next;

	if (S == NULL)
	{
		return;
	}

	while (p != NULL)  //注意:与书中有点不同, 定义两个节点, 一个当前节点, 一个下一个节点
	{
		free(p);
		p = q;
		q = p->next;
	}
}

int  LinkStackLength(LinkStack * S)//求链表的长度
{
	int i = 0;
	LinkStack *p = S->next; //跳过头结点
	while (p != NULL)
	{
		i++;
		p = p->next;
	}
	return i;
}

bool isLinkStackEmpty(LinkStack *S)//判断链表是否为空
{
	return S->next == NULL; //1:空;0:非空
}

bool LinkStackPush(LinkStack *S, DataType e)//元素e进栈
{
	LinkStack *p;
	p = (LinkStack*)malloc(sizeof(LinkStack)); //创建结点
	if (p == NULL)
	{
		return 0;
	}

	p->Elem = e;  //将元素赋值
	p->next = S->next; //将新建结点的p->next指向原来的栈顶元素
	S->next = p; //将现在栈的起始点指向新建结点

	return 1;
}

DataType LinkStackPop(LinkStack *S)//出栈
{
	LinkStack *p;
	DataType e;
	if (S->next == NULL)
	{
		cout << "The Stack is Empty!" << endl;
		return 0;
	}
	p = S->next; //跳过头结点
	e = p->Elem;
	S->next = p->next;
	return e;
}

DataType LinkStackGetPop(LinkStack *S)//输出栈顶元素
{
	if (S->next == NULL)
	{
		cout << "The Stack is Empty!" << endl;
		return 0;
	}
	return S->next->Elem;  //头结点
}

void LinkStackDisplay(LinkStack *S)//从上到下输出栈所有元素
{
	LinkStack *p = S->next;
	while(p != NULL)
	{
		cout << p->Elem << "  ";
		p = p->next;
	}
	cout << endl;
}
##  5, 二叉树
5.1, 二叉树的链式存储
#pragma once
#ifndef LINKBTREE_H
#define LINKBTREE_H

#define MaxSize 100      //树的深度
typedef char DataType;

typedef struct BTNode    //定义一个二叉树节点
{
	DataType Elem;
	BTNode *Lchild;
	BTNode *Rchild;
}LinkBTree;

void LinkBTreeCreate(LinkBTree *& BT, char *str);//有str创建二叉链
LinkBTree* LinkBTreeFindNode(LinkBTree * BT, DataType e); //返回e的指针
LinkBTree *LinkBTreeLchild(LinkBTree *p);//返回*p节点的左孩子节点指针
LinkBTree* LinkBTreeRight(LinkBTree *p);//返回*p节点的右孩子节点指针
int LinkBTreeDepth(LinkBTree *BT);//求二叉链的深度
void LinkBTreeDisplay(LinkBTree * BT);//以括号法输出二叉链
int LinkBTreeWidth(LinkBTree *BT);//求二叉链的宽度
int LinkBTreeNodes(LinkBTree * BT);//求节点个数
int LinkBTreeLeafNodes(LinkBTree *BT);//求二叉链的叶子节点个数

void LinkBTreeProOeder(LinkBTree *BT); //前序递归遍历
void LinkBTreeProOederRecursion(LinkBTree *BT);//前序非递归遍历
void LinkBTreeInOeder(LinkBTree *BT);//中序递归遍历
void LinkBTreeInOederRecursion(LinkBTree *BT);//中序非递归遍历
void LinkBTreePostOeder(LinkBTree *BT);//后序递归遍历
void LinkBTreePostOederRecursion(LinkBTree *BT);//后序非递归遍历

#endif
#include<iostream>
#include"LinkBTree.h"
using namespace std;

void LinkBTreeCreate(LinkBTree *& BT, char *str)//有str创建二叉链
{
	LinkBTree *St[MaxSize], *p = NULL;
	int top = -1, k, j = 0;

	char ch;
	BT = NULL;
	ch = str[j];

	while (ch != '\0')
	{
		switch (ch)
		{
		case '(':top++; St[top] = p; k = 1; break;//为左节点, top表示层数, k表示左右节点, 碰到一个'('二叉树加一层,碰到一个',', 变成右子树
		case ')':top--; break;
		case ',':k = 2; break; //为右节点
		default: p = (LinkBTree *)malloc(sizeof(LinkBTree));
			p->Elem = ch;
			p->Lchild = p->Rchild = NULL;
			if (BT == NULL)
			{
				BT = p;   //根节点
			}
			else
			{
				switch (k)
				{
				case 1:St[top]->Lchild = p; break;
				case 2:St[top]->Rchild = p; break;
				}
			}
		}
		j++;
		ch = str[j];
	}
}

LinkBTree *LinkBTreeFindNode(LinkBTree * BT, DataType e) //返回元素e的指针
{
	LinkBTree *p;

	if (BT == NULL)
	{
		return NULL;
	}
	else if (BT->Elem == e)
	{
		return BT;
	}
	else
	{
		p = LinkBTreeFindNode(BT->Lchild, e); //递归
		if (p != NULL)
		{
			return p;
		}
		else
		{
			return LinkBTreeFindNode(BT->Lchild, e);
		}
	}
}

LinkBTree *LinkBTreeLchild(LinkBTree *p)//返回*p节点的左孩子节点指针
{
	return p->Lchild;
}

LinkBTree *LinkBTreeRight(LinkBTree *p)//返回*p节点的右孩子节点指针{
{
	return p->Rchild;
}

int LinkBTreeDepth(LinkBTree *BT)//求二叉链的深度
{
	int LchildDep, RchildDep;
	if (BT == NULL)
	{
		return 0;
	}
	else
	{
		LchildDep = LinkBTreeDepth(BT->Lchild);
		RchildDep = LinkBTreeDepth(BT->Rchild);
	}
	return (LchildDep > RchildDep) ? (LchildDep + 1) : (RchildDep + 1);
}

void LinkBTreeDisplay(LinkBTree * BT)//以括号法输出二叉链
{
	if (BT != NULL)
	{
		cout << BT->Elem;
		if (BT->Lchild != NULL || BT->Rchild != NULL)
		{
			cout << '(';
			LinkBTreeDisplay(BT->Lchild);
			if (BT->Rchild != NULL)
			{
				cout << ',';
			}
			LinkBTreeDisplay(BT->Rchild);
			cout << ')';
			
		}
	}
}

int LinkBTreeWidth(LinkBTree *BT)//求二叉链的宽度
{
	return 0;
}

int LinkBTreeNodes(LinkBTree * BT)//求节点个数
{
	if (BT == NULL)
	{
		return 0;
	}
	else if (BT->Lchild == NULL && BT->Rchild == NULL)   //为叶子节点的情况
	{
		return 1;
	}
	else
	{
		return (LinkBTreeNodes(BT->Lchild) + LinkBTreeNodes(BT->Rchild) + 1);
	}
}

int LinkBTreeLeafNodes(LinkBTree *BT)//求二叉链的叶子节点个数
{
	if (BT == NULL)
	{
		return 0;
	}
	else if (BT->Lchild == NULL && BT->Rchild == NULL)  //为叶子节点的情况
	{
		return 1;
	}
	else
	{
		return (LinkBTreeLeafNodes(BT->Lchild) + LinkBTreeLeafNodes(BT->Rchild));
	}
}

void LinkBTreeProOeder(LinkBTree *BT) //前序非递归遍历
{
	LinkBTree *St[MaxSize], *p;
	int top = -1;
	if (BT != NULL)
	{
		top++;
		St[top] = BT;     //将第一层指向根节点

		while (top > -1)
		{
			p = St[top]; //第一层
			top--;       //退栈并访问该节点
			cout << p->Elem << " ";

			if (p->Rchild != NULL)
			{
				top++;
				St[top] = p->Rchild;
			}

			if (p->Lchild != NULL)
			{
				top++;
				St[top] = p->Lchild;
			}
		}
		cout << endl;
	}
}

void LinkBTreeProOederRecursion(LinkBTree *BT)//前序递归遍历
{
	if (BT != NULL)
	{
		cout << BT->Elem<<" ";
		LinkBTreeProOeder(BT->Lchild);
		LinkBTreeProOeder(BT->Rchild);
	}
}

void LinkBTreeInOeder(LinkBTree *BT)//中序非递归遍历
{
	LinkBTree *St[MaxSize], *p;
	int top = -1;
	if (BT != NULL)
	{
		p = BT;
		while (top > -1 || p != NULL)
		{
			while (p != NULL)
			{
				top++;
				St[top] = p;
				p = p->Lchild;
			}

			if (top> -1)
			{
				p = St[top];
				top--;
				cout << p->Elem <<" ";
				p = p->Rchild;
			}
		}
		cout << endl;
	}
}

void LinkBTreeInOederRecursion(LinkBTree *BT)//中序递归遍历
{
	if (BT != NULL)
	{
		LinkBTreeProOeder(BT->Lchild);
		cout << BT->Elem << " ";
		LinkBTreeProOeder(BT->Rchild);
	}
}

void LinkBTreePostOeder(LinkBTree *BT)//后序非递归遍历
{
	LinkBTree *St[MaxSize], *p;
	int top = -1,flag;
	if (BT != NULL)
	{
		do
		{
			while (BT != NULL)
			{
				top++;
				St[top] = BT;
				BT = BT->Lchild;
			}
			
			p = NULL;
			flag = 1;
			while (top != -1 && flag)
			{
				BT = St[top];
				if (BT->Rchild == p)
				{
					cout << BT->Elem << " ";
					top--;
					p = BT;
				}
				else
				{
					BT = BT->Lchild;
					flag = 0;
				}
			}
		} while (top != -1);
		
		cout << endl;
	}
}

void LinkBTreePostOederRecursion(LinkBTree *BT)//后序递归遍历
{
	if (BT != NULL)
	{
		LinkBTreeProOeder(BT->Lchild);
		LinkBTreeProOeder(BT->Rchild);
		cout << BT->Elem << " ";
	}
}
5.2, 哈夫曼树
        在许多应用上, 常常将树中的节点附上一个有着某种意义的数值, 称此数值为该节点的权, 从树根节点到该节点的路径长度与该节点权值之积称为带权路径长度. 树中所有叶子节点的带权路径长度之和称为该树的带权路径长度, 如下:
, 其中共有n个叶子节点的数目, Wi表示叶子节点i的权值, Li表示根节点到叶子节点的路径长度. 
       在n个带有权值结点构成的二叉树中, 带权路径长度WPL最小的二叉树称为哈夫曼树. 又称最优二叉树. 
哈夫曼树算法:
(1)根据给定的n个权值, 使对应节点构成n颗二叉树的森林T, 其中每颗二叉树中都只有一个带权值的Wi的根节点, 其左右节点均为空
(2)在森林中选取两颗根节点权值最小的子树分别作为左, 右子树构造一颗新二叉树, 且置新的二叉树的根节点的权值为其左, 右子树上根节点的权值之和. 
(3)在森林中, 用新得到的二叉树代替选取的两棵树
(4)重复(2)和(3), 直到T只含一棵树为止
定理:对于具有n个叶子节点的哈夫曼树, 共有2n-1个节点
代码如下:
#pragma once

typedef double Wi;  //假设权值为双精度

struct HTNode       //每一个节点的结构内容, 
{
	Wi weight;      //节点的权值
	HTNode *left;   //左子树
	HTNode *right;  //右子树
};

void PrintHuffman(HTNode * HuffmanTree);  //输出哈夫曼树
HTNode * CreateHuffman(Wi a[], int n);    //创建哈夫曼树
#include"Huffman.h"
#include<iostream>

/*
  哈夫曼算法:
  (1)根据给定的n个权值创建n个二叉树的森林, 其中n个二叉树的左右子树均为空
  (2)在森林中选择权值最小的两个为左右子树构造一颗新树, 根节点
       为权值最小的之和
  (3)在森林中, 用新的树代替选取的两棵树
  (4)重复(2)和(3)
  定理:n个叶子节点的哈夫曼树共有2n-1个节点
*/

/*
       a[]    I    存放的是叶子节点的权值
       n      I    叶子节点个数
  return      O    返回一棵哈夫曼树
*/
HTNode* CreateHuffman(Wi a[], int n)    //创建哈夫曼树
{
	int i, j;
	HTNode **Tree, *HuffmanTree; //根据n个权值声明n个二叉树的森林, 二级指针表示森林(二叉树的集合)
	Tree = (HTNode**)malloc(n * sizeof(HTNode));  //代表n个叶节点, 为n棵树分配内存空间
	HuffmanTree = (HTNode*)malloc(sizeof(HTNode));
	//实现第一步:创建n棵二叉树, 左右子树为空
	for (i = 0; i < n; i++) 
	{
		Tree[i] = (HTNode*)malloc(sizeof(HTNode));
		Tree[i]->weight = a[i];
		Tree[i]->left = Tree[i]->right = nullptr;
	}

	//第四步:重复第二和第三步
	for (i = 1; i < n; i++)   //z这里表示第i次排序
	{
		//第二步:假设权值最小的根节点二叉树下标为第一个和第二个
		//打擂台选择最小的两个根节点树
		int k1 = 0, k2 = 1;  		
		for (j = k2; j < n; j++) 
		{
			if (Tree[j] != NULL)
			{
				if (Tree[j]->weight < Tree[k1]->weight) //表示j比k1和k2的权值还小, 因此两个值都需要更新
				{
					k2 = k1;         
					k1 = j;
				}
				else if(Tree[j]->weight < Tree[k2]->weight) //k1 < j < k2, 需要更新k2即可
				{
					k2 = j;
				}
			}
		}

		//第三步:一次选择结束后, 将更新一颗树
		HuffmanTree = (HTNode*)malloc(sizeof(HTNode));              //每次一轮结束, 创建一个根节点
		HuffmanTree->weight = Tree[k1]->weight + Tree[k2]->weight;  //更新后的根节点权值为左右子树权值之和
		HuffmanTree->left = Tree[k1];  //最小值点为左子树
		HuffmanTree->right = Tree[k2]; //第二小点为右子树

		Tree[k1] = HuffmanTree;
		Tree[k2] = nullptr;
	}
	free(Tree);
	return HuffmanTree;
}

//先序遍历哈夫曼树
void PrintHuffman(HTNode * HuffmanTree)  //输出哈夫曼树
{
	if (HuffmanTree == nullptr)
	{
		return;
	}
	std::cout << HuffmanTree->weight;
	if (HuffmanTree->left != nullptr || HuffmanTree->right != nullptr)
	{
		std::cout << "(";
		PrintHuffman(HuffmanTree->left);
		if (HuffmanTree->right != nullptr)
		{
			std::cout << ",";
		}
		PrintHuffman(HuffmanTree->right);
		std::cout << ")";
	}
}
##  6, 查找算法
6.1, 线性表查找(顺序查找, 折半查找)
顺序查找
#include<iostream>
using namespace std;

#define Max 100

typedef int KeyType;
typedef char InfoType[10];
typedef struct
{
	KeyType key;  //表示位置
	InfoType data; //data是具有10个元素的char数组
}NodeType;

typedef NodeType SeqList[Max]; //SeqList是具有Max个元素的结构体数组

int SeqSearch(SeqList R, int n, KeyType k)
{
	int i = 0;

	while (i < n && R[i].key != k)
	{
		cout << R[i].key;//输出查找过的元素
		i++;
	}

	if (i >= n)
	{
		return -1;
	}
	else
	{
		cout << R[i].key << endl;
		return i;
	}
}


int main()
{
	SeqList R;
	int n = 10;
	KeyType k = 5;
	int a[] = { 3,6,8,4,5,6,7,2,3,10 },i;
	for (int i = 0; i < n; i++)
	{
		R[i].key = a[i];
	}
	cout << endl;
	if ((i = SeqSearch(R, n, k)) != -1)
		cout << "元素" << k << "的位置是" << i << endl;
	system("pause");
	return 0;
}
#include<iostream>
using namespace std;

#define Max 100
typedef int KeyType;
typedef char InfoType[10];

typedef struct
{
	KeyType key;
	InfoType data;
}NodeType;

typedef NodeType SeqList[Max];

int BinSeqList(SeqList R, int n, KeyType k)
{
	int low = 0, high = n - 1, mid, cout = 0;

	while (low <= high)
	{
		mid = (low + high) / 2;
		//cout << "第" << ++cout << "次查找:" << "在" << "[" << low << "," << high << "]" << "中查找到元素:" << R[mid].key << endl;

		if (R[mid].key == k)
		{
			return mid;
		}
		if (R[mid].key > k)
			high = mid - 1;
		else
			low = mid + 1;
	}
}

int main()
{
	SeqList R;
	KeyType k = 9;
	int a[] = { 1,2,3,4,5,6,7,8,9,10 },i,n = 10;
	for (i = 0; i < n; i++)
	{
		R[i].key = a[i];
	}
	cout << endl;
	if ((i = BinSeqList(R, n, k)) != -1)
	{
		cout << "元素" << k << "的位置是:" << i << endl;
	}
	system("pause");
	return 0;
}
6.2, 树表查找(二叉排序树, 平衡二叉树, B-树, B+树)
二叉排序树(B树)
#pragma once
#ifndef BSTREE_H
#define BSTREE_H

#define Max 100
typedef int KeyType;
typedef char InfoType[10];

typedef struct node
{
	KeyType key;    //关键字项
	InfoType data;  //其他数据项
	struct node *Lchild, *Rchild;
}BSTNode;


BSTNode *BSTreeCreat(KeyType A[], int n);         //由数组A(含有n个关键字)中的关键字创建一个二叉排序树
int BSTreeInsert(BSTNode *& BST, KeyType k); //在以*BST为根节点的二叉排序树中插入一个关键字为k的结点
int BSTreeDelete(BSTNode *& BST, KeyType k); //在bst中删除关键字为k的结点
void BSTreeDisplay(BSTNode * BST);            //以括号法输出二叉排序树
int BSTreeJudge(BSTNode * BST);              //判断BST是否为二叉排序树

#endif
#include<iostream>
#include"BSTree.h"

using namespace std;

BSTNode *BSTreeCreat(KeyType A[], int n)         //由数组A(含有n个关键字)中的关键字创建一个二叉排序树
{
	BSTNode *BST = NULL;
	int i = 0;
	while (i < n)
	{
		if(BSTreeInsert(BST,A[i]) == 1)
		{
			cout << "第" << i + 1 << "步, 插入" << A[i] << endl;
			BSTreeDisplay(BST);
			cout << endl;
			i++;
		}
	}
	return BST;
}

int BSTreeInsert(BSTNode *& BST, KeyType k) //在以*BST为根节点的二叉排序树中插入一个关键字为k的结点
{
	if (BST == NULL)
	{
		BST = (BSTNode *)malloc(sizeof(BSTNode));
		BST->key = k;
		BST->Lchild = BST->Rchild = NULL;
		return 1;
	}
	else if(k == BST->key)
	{
		return 0;
	}
	else if(k > BST->key)
	{
		return BSTreeInsert(BST->Rchild, k);
	}
	else
	{
		return BSTreeInsert(BST->Lchild, k);
	}
}

int BSTreeDelete(BSTNode *& BST, KeyType k) //在bst中删除关键字为k的结点
{
	if (BST == NULL)
	{
		return 0;
	}
	else
	{
		if (k < BST->key)
		{
			return BSTreeDelete(BST->Lchild, k);
		}
		else if (k>BST->key)
		{
			return BSTreeDelete(BST->Rchild, k);
		}
		else
		{
			Delete(BST)
		}
	}
}

void BSTreeDisplay(BSTNode * BST)            //以括号法输出二叉排序树
{
	if (BST != NULL)
	{
		cout << BST->key;
		if (BST->Lchild != NULL || BST->Rchild != NULL)
		{
			cout << '(';
			BSTreeDisplay(BST->Lchild);
			if (BST->Rchild != NULL)
			{
				cout << ',';
			}
			BSTreeDisplay(BST->Rchild);
			cout << ')';
		}
	}
}

KeyType predt = -32767;

int BSTreeJudge(BSTNode * BST)              //判断BST是否为二叉排序树
{
	int b1, b2;

	if (BST == NULL)
	{
		return 1;
	}
	else
	{
		b1 = BSTreeJudge(BST->Lchild);
		if (b1 == 0 || predt >= BST->key)
		{
			return 0;
		}
		predt = BST->key;
		b2 = BSTreeJudge(BST->Rchild);
		return b2;
	}
}

void Delete(BSTNode*& p)                   //删除二叉排序树*p节点
{
	BSTNode* q;

	if (p->Rchild == nullptr)             //当删除的节点没有右子树, 只有左子树时, 根据二叉树的特点, 
	{                                     //直接将左子树根节点放在被删节点的位置. 
		q = p;
		p = p->Lchild;
		free(p);
	}
	else if (p->Lchild == nullptr)       //当删除的结点没有左子树, 只有右子树时, 根据二叉树的特点, 
	{                                    //直接将右子树结点放在被删结点位置. 
		q = p;
		p = p->Rchild;
		free(p);
	}
	else
	{
		Delete1(p, p->Lchild);         //当被删除结点有左, 右子树时
	}


}

void Delete1(BSTNode* p, BSTNode* &r)      //当删除的二叉排序树*P节点有左右子树的删除过程
{
	BSTNode *q;
	if (p->Lchild != nullptr)
	{
		Delete1(p, p->Rchild);           //递归寻找最右下节点
	}                                    //找到了最右下节点*r
	else                                 //将*r的关键字赋值个*p
	{
		p->key = r->key;
		q = r;
		r = r->Lchild;
		free(q);
	}
}
平衡二叉树:若一棵二叉树中的每个节点的左右子树高度至多相差1, 则称此二叉树为平衡二叉树. 其中平衡因子的定义为:平衡二叉树中每个节点有一个平衡因子, 每个节点的平衡因子是该节点左子树高度减去右子树的高度, 若每个平衡因子的取值为0, -1,1则该树为平衡二叉树. 
B-树
用作外部查找的数据结构, 其中的数据存放在外存中, 是一种多路搜索树
1, 所有的叶子节点放在同一层, 并且不带信息
2, 树中每个节点至多有m棵子树
3, 若根节点不是终端节点, 则根节点至少有两棵子树
4, 除根节点外的非叶子节点至少有m/2棵子树
5, 每个节点至少存放m/2-1个至多m-1个关键字
6, 非叶子节点的关键字数=指向儿子指针的个数-1
7, 非叶子节点的关键字依次递增
8, 非叶子节点指针:P[1],P[2],...P[m];其中P[i]指向关键字小于K[1]的子树, P[i]指向关键字属于(K[i-1],K[i])的子树
6.3, 哈希表查找
        从根本上说, 一个哈希表包含一个数组, 通过特殊的索引值(键)来访问数组中的元素. 
        哈希表的主要思想是通过一个哈希函数, 在所有可能的键与槽位之间建立一张映射表. 哈希函数每次接收一个键将返回与键对应的哈希编码或者哈希值. 键的数据类型可能多种多样, 但哈希值只能是整型. 
       计算哈希值和在数组中进行索引都只消耗固定的时间, 因此哈希表的最大亮点在于它是一种运行时间在常量级的检索方法. 当哈希函数能够保证不同的键生成的哈希值互不相同时, 就说哈希值能直接寻址想要的结果. 
       散列表(Hash table, 也叫哈希表), 是根据关键码值(Key value)而直接进行访问的数据结构. 也就是说, 它通过把关键码值映射到表中一个位置来访问记录, 以加快查找的速度. 这个映射函数叫做散列函数, 存放记录的数组叫做散列表. 
       给定表M, 存在函数f(key), 对任意给定的关键字值key, 代入函数后若能得到包含该关键字的记录在表中的地址, 则称表M为哈希(Hash)表, 函数f(key)为哈希(Hash) 函数. 
散列函数能使对一个数据序列的访问过程更加迅速有效, 通过散列函数, 数据元素将被更快地定位. 
实际工作中需视不同的情况采用不同的哈希函数, 通常考虑的因素有:
· 计算哈希函数所需时间
· 关键字的长度
· 哈希表的大小
· 关键字的分布情况
· 记录的查找频率
1. 直接寻址法:取关键字或关键字的某个线性函数值为散列地址. 即H(key)=key或H(key) = a·key + b, 其中a和b为常数(这种散列函数叫做自身函数). 若其中H(key)中已经有值了, 就往下一个找, 直到H(key)中没有值了, 就放进去. 这种哈希函数计算简单, 并且不可能有冲突产生, 当关键字连续时, 可用直接寻址法;否则关键字的不连续将造成内存单元的大量浪费. 
2. 数字分析法:分析一组数据, 比如一组员工的出生年月日, 这时我们发现出生年月日的前几位数字大体相同, 这样的话, 出现冲突的几率就会很大, 但是我们发现年月日的后几位表示月份和具体日期的数字差别很大, 如果用后面的数字来构成散列地址, 则冲突的几率会明显降低. 因此数字分析法就是找出数字的规律, 尽可能利用这些数据来构造冲突几率较低的散列地址. 
3. 平方取中法:当无法确定关键字中哪几位分布较均匀时, 可以先求出关键字的平方值, 然后按需要取平方值的中间几位作为哈希地址. 这是因为:平方后中间几位和关键字中每一位都相关, 故不同关键字会以较高的概率产生不同的哈希地址. 
4, 除留取余法:用关键字k除以某个不大于哈希表长度m的数p, 将所得的余数作为哈希地址的方法. h(k) = k mod p, 其中p取不大于m的素数最佳
#pragma once
#define MaxSize 20  //此处表示哈希表长度m

#define NULLKEY -1  //表示该节点为空节点, 未存放数据
#define DELEKEY -2  //表示该节点数据被删除, 

typedef int Key;   //关键字类型

typedef struct
{
	Key key;  //关键字值
	int count;  //探查次数
}HashTable[MaxSize];

void HTInsert(HashTable HT,int &n,Key k,int p); //将关键字插入哈希表中
void HTCreate(HashTable HT, Key x[], int n, int m, int p); //创建哈希表
int  HTSearch(HashTable HT, int p, Key k);      //在哈希表中查找关键字
int  HTDelete(HashTable HT, int p, Key k, int &n); //删除哈希表中关键字k
void HTDisplay(HashTable HT,int n,int m);
#include"HT.h"
#include<iostream>

/*解决冲突用开地址的线性探查法*/
void HTInsert(HashTable HT, int &n, Key k, int p) //将关键字k插入哈希表中
{
	int i,addr;  //i:记录探查数;adddr:记录哈希表下标
	addr = k % p;
	if (HT[addr].key == NULLKEY || HT[addr].key == DELEKEY) //表示该出为空, 可以存储值
	{
		HT[addr].key = k;
		HT[addr].count = 1;
	}
	else  //表示存在哈希冲突
	{
		i = 1;
		do
		{
			addr = (addr + 1) % p;   //哈希冲突解决办法:开地址法中的线性探查法, 从当前冲突地址开始依次往后排查
			i++;
		} while (HT[addr].key != NULLKEY || HT[addr].key != DELEKEY);
	}
	n++;//表示插入一个元素后哈希表共存储的元素数量
}

/*
  HT      I/O     哈希表
  x[]      I      关键字数组
  n        I      关键字个数
  m        I      哈希表长度
  p        I      为小于m的数p, 取不大于m的素数最好
*/
void HTCreate(HashTable HT, Key x[], int n, int m, int p)//创建哈希表
{
	for (int i = 0; i < m; i++)  //创建一个空的哈希表
	{
		HT[i].key = NULLKEY;
		HT[i].count = 0;
	}

	int n1 = 0;
	for (int i = 0; i < n; i++)
	{
		HTInsert(HT, n1, x[i], p);
	}
}

int  HTSearch(HashTable HT, int p, Key k)      //在哈希表中查找关键字
{
	int addr; //用来保存关键字k在哈希表中的下标
	addr = k % p;

	while(HT[addr].key != NULLKEY || HT[addr].key != k)
	{
		addr = (addr + 1) % p;  //存在着哈希冲突
	}
	if (HT[addr].key == k)
		return addr;
	else
		return -1;
}

/*
  注:删除并非真正的删除, 而是标记
*/
int  HTDelete(HashTable HT, int p, Key k, int &n)//删除哈希表中关键字k
{
	int addr;
	addr = HTSearch(HT, p, k);
	if (addr != -1)
	{
		HT[addr].key = DELEKEY;
		n--;
		return 1;
	}
	else
	{
		return 0;
	}
}

void HTDisplay(HashTable HT, int n, int m)   //输出哈希表
{
	std::cout << "  下标:";
	for (int i = 0; i < m; i++)
	{
		std::cout<< i << "  ";
	}
	std::cout << std::endl;

	std::cout << " 关键字:";
	for (int i = 0; i < m; i++)
	{
		std::cout << HT[i].key << "  ";
	}
	std::cout << std::endl;

	std::cout << "探查次数:";
	for (int i = 0; i < m; i++)
	{
		std::cout << HT[i].key << "  ";
	}
	std::cout << std::endl;
}
##  7, 排序算法
7.1, 直接插入排序
//按递增顺序进行直接插入排序
/*
  假设待排序的元素存放在数组R[0...n-1]中, 排序过程中的某一时刻
  R被划分为两个子区间R[0..i-1]和R[i..n-1], 其中, 前一个子区间
  是已排好序的有序区间, 后一个则是未排序. 直接插入排序的一趟操
  作是将当前无序区间的开头元素R[i]插入到有序区间R[0..i-1]中适当
  的位置中, 使R[0..i]变成新的区间
*/
void InsertSort(RecType R[], int n)
{
	int i, j, k;
	RecType temp;

	for (i = 1; i < n; i++)
	{
		temp = R[i];  //
		j = i - 1;

		while (j>=0 && temp.key <R[j].key)  //如果无序区间值比有序区间小, 有序区间值往后挪
		{
			R[j + 1] = R[j];
			j--;
		}

		R[j + 1] = temp;
		cout << "i:" << i << " ";

		for (k = 0; k < n; k++)
		{
			cout << R[k].key << " ";
		}
		cout << endl;
	}
}
7.2, 折半插入排序
7.3, 希尔排序
//希尔排序
/* 
   先取定一个小于n的整数d1作为第一个增量, 
   把表的全部元素分成d1个组, 所有相互之间
   距离为d1的倍数的元素放在同一个组中, 在
   各组内进行直接插入排序;然后, 取第二个
   增量d2, 重复上述的分组过程和排序过程, 
   直至所取的增量dt=1, 即所有元素放在同一
   组中进行直接插入排序
*/
void ShellInsert(RecType R[], int n)
{
	int i, j, d,k;
	RecType temp;
	d = n / 2;
	while (d > 0)
	{
		for (i = d; i < n; i++)
		{
			j = i - d;
			while (j >= 0 && R[j].key < R[j+d].key)
			{
				temp = R[j];
				R[j] = R[j + d];
				R[j + d] = temp;
				j = j - d;
			}
		}

		cout << d<<"  ";
		for (k = 0; k < n; k++)
		{
			cout << R[k].key << " ";
		}
		cout << endl;
		d = d / 2; //减少增量
	}
}
7.4, 冒泡排序
/****************************************
* function          冒泡排序             *
* param     a[]     待排序的数组          *
* param     n       数组长度              *
* return            无                   *
* good time         O(n)                *
* avg time          O(n^2)              *
* bad time          O(n^2)              *
* space             O(1)                *
* stable            yes                 *
*****************************************/
void BubbleSort(int a[],int n)
{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            if (a[i] < a[j])
                swap(a[i], a[j]);
        }
    }
}
7.5, 快速排序
void Quick_Sort(int a[], int left, int right)
{
    if (left < right)
    {
        //1.随机取基准值, 然后交换到left那里
//      srand(GetTickCount());
//      int m = (rand() % (right - left)) + left;
        //2.取前中后的中值, 然后交换到left那里
//      int m = Mid(left, (left + right / 2), right);
//      swap(a[m], a[left]);
        int midIndex = Partition(a, left, right); //获取新的基准keyindex
        Quick_Sort(a, left, midIndex - 1);  //左半部分排序
        Quick_Sort(a, midIndex + 1, right); //右半部分排序
    }
}

void QuickSort(int a[], int n)
{
    Quick_Sort(a, 0, n - 1);
}
7.6, 直接选择排序
/****************************************
* function          选择排序法           *
* param     a[]     待排序的数组          *
* param     n       数组长度                *
* return            无                   *
* good time         O(n^2)              *
* avg time          O(n^2)              *
* bad time          O(n^2)              *
* space             O(1)                *
* stable            no                  *
*****************************************/
void SelectSort(int a[], int n)
{
    int min = 0;
    for (int i = 0; i < n; i++)
    {
        min = i;
        for (int j = i + 1; j < n; j++)
        {
            if (a[j] < a[min])
                min = j;
        }
        if (min != i)
            swap(a[min], a[i]);
    }
}
7.7, 堆排序
#include<iostream>
using namespace std;

#define Max 20
typedef int KeyType;
typedef struct
{
	KeyType key;
}RecType;

void HeapDisplay(RecType R[], int i, int n) //括号法输出堆
{
	if (i < n)
	{
		cout << R[i].key << " ";
	}

	if (2 * i <= n || 2 * i + 1 < n)
	{
		cout << "(";

		if (2 * i <= n)
		{
			HeapDisplay(R, 2 * i, n);
		}

		cout << ",";

		if (2 * i + 1 <= n)
		{
			HeapDisplay(R, 2 * i + 1, n);
		}

		cout << ")";
	}
}

void HeapSift(RecType R[], int low, int high) //调整堆
{
	int i = low, j = 2 * i; //R[j]是R[i]的左孩子

	RecType temp = R[i];

	while (j <= high)
	{
		if (j < high && R[j].key < R[j + 1].key)
		{
			j++;
		}

		if (temp.key < R[j].key)
		{
			R[i] = R[j];
			i = j;
			j = 2 * i;
		}
		else break;
	}
	R[i] = temp;
}


/* 堆排序:在排序过程中, 将R[1..n]
   看成是一颗顺序存储的完全二叉树, 
   利用完全二叉树中双亲节点和孩子节
   点之间的内在关系, 在当前无序区中
   选择关键字最小或最大的元素
*/
void HeapSort(RecType R[], int n)
{
	int i;
	RecType temp;
	for (i = n / 2; i >= 1; i--)
	{
		HeapSift(R, i, n);
	}
	cout << "初始堆为:";
	HeapDisplay(R,1,n);  //输出初始堆
	cout << endl;

	for (i = n; i >= 2; i--)
	{
		temp = R[1];
		R[1] = R[i];
		R[i] = temp;
		HeapSift(R, 1, i - 1); //刷选R[1]结点, 得到i-1个结点的堆
		cout << "筛选调整得到的堆:";
		HeapDisplay(R, 1, i - 1);
	}
}

int main()
{
	int i, k, n = 10;
	KeyType a[] = { 6,8,9,7,0,1,3,2,4,5 };

	RecType R[Max];
	for (i = 1; i <= n; i++)
	{
		R[i].key = a[i - 1];
	}
	cout << endl;
	cout << "  初始关键字:";
	for (k = 1; k <= n; k++)
	{
		cout << R[k].key << " ";
	}
	cout << endl;

	for (i = n / 2; i >= 1; i--)
	{
		HeapSift(R, i, n);
	}
	HeapSort(R, n);

	cout << "  最终结果:";
	for (k = 1; k <= n; k++)
	{
		cout << R[k].key << " ";
	}
	cout << endl;
	system("pause");
	return 0;
}
7.8, 归并排序
7.9, 基数排序
##  8, 图
8.1, 图的基本概念
       在图形结构中, 每一个元素可以有零个和多个前驱, 也可以有零个和多个后继, 也就是说, 元素之间的关系是任意的. 无论多么复杂的图都是由顶点和边构成. 
路径长度:指一条路径上经过的边的数目
连通:图中任意两点都连通, 则为连通图, 否则为非连通图
强连通:有向图中, 图中任意两点都连通, 则为强连通图
权:图中每一条边都可以附有一个数值, 这种与边相关的数值称为权
顶点的度:在无向图中, 某顶点具有的边数为该顶点的度. 在有向图中又分为入度和出度, 以顶点i为终点的入边的数目, 称为入度, 以顶点i为起点的出边的数目, 称为该顶点的出度, 二者之和为该顶点的度. 
图的存储结构:邻接矩阵
图的邻接矩阵的表示方式需要一个二维数组来表示. 
优点:直观, 容易理解, 容易判断出任意两个顶点是否有边, 容易计算各个顶点的度. 
缺点:如果是完全图时, 邻接矩阵是最好的方法, 但是对于稀疏矩阵, 由于它边较少, 但是顶点多, 这样就会造成空间浪费. 
图的存储结构:邻接表
邻接表是图的一种链式存储结构. 
8.2, 图的遍历
       深度优先遍历方法(DFS):从图中某个初始定点出发, 首先访问初始点, 然后选择一个与顶点相邻且没有被访问的顶点w为初始顶点, 在继续从顶点w出发进行深度优先遍历, 直到所有人顶点被访问. 显然该遍历过程是一个递归过程. (一次访问一个点)
        广度优先遍历方法(BFS):首先访问初始点v, 接着访问顶点v的所有未被访问过的所有邻接点v1,v2,v3,,,vt, 访问每一个顶点的所有未被访问过的邻接点, 依次类推. (一次访问所有邻接点)
8.3, 生成树和最小生成树
        现在假设有一个很实际的问题:我们要在n个城市中建立一个通信网络, 则连通这n个城市需要布置n-1一条通信线路, 这个时候我们需要考虑如何在成本最低的情况下建立这个通信网? 
       于是我们就可以引入连通图来解决我们遇到的问题, n个城市就是图上的n个顶点, 然后, 边表示两个城市的通信线路, 每条边上的权重就是我们搭建这条线路所需要的成本, 所以现在我们有n个顶点的连通网可以建立不同的生成树, 每一颗生成树都可以作为一个通信网, 当我们构造这个连通网所花的成本最小时, 搭建该连通网的生成树, 就称为最小生成树. 
普里姆(Prim)算法:
       首先就是从图中的一个起点a开始, 把a加入U集合, 然后, 寻找从与a有关联的边中, 权重最小的那条边并且该边的终点b在顶点集合:(V-U)中, 我们也把b加入到集合U中, 并且输出边(a, b)的信息, 这样我们的集合U就有:{a,b}, 然后, 我们寻找与a关联和b关联的边中, 权重最小的那条边并且该边的终点在集合:(V-U)中, 我们把c加入到集合U中, 并且输出对应的那条边的信息, 这样我们的集合U就有:{a,b,c}这三个元素了, 一次类推, 直到所有顶点都加入到了集合U. 该算法的核心是一次加入一个点, 然后添加该点边权值最小的那条, 直到所有点都添加进去. 
下面我们对下面这幅图求其最小生成树:

假设我们从顶点v1开始, 所以我们可以发现(v1,v3)边的权重最小, 所以第一个输出的边就是:v1—v3=1: 

然后, 我们要从v1和v3作为起点的边中寻找权重最小的边, 首先了(v1,v3)已经访问过了, 所以我们从其他边中寻找, 发现(v3,v6)这条边最小, 所以输出边就是:v3—-v6=4 

然后, 我们要从v1, v3, v6这三个点相关联的边中寻找一条权重最小的边, 我们可以发现边(v6,v4)权重最小, 所以输出边就是:v6—-v4=2. 

然后, 我们就从v1, v3, v6, v4这四个顶点相关联的边中寻找权重最小的边, 发现边(v3, v2)的权重最小, 所以输出边:v3—–v2=5 

然后, 我们就从v1, v3, v6, v4, v2这2五个顶点相关联的边中寻找权重最小的边, 发现边(v2, v5)的权重最小, 所以输出边:v2—–v5=3 

最后, 我们发现六个点都已经加入到集合U了, 我们的最小生成树建立完成. 
代码实现:
#include<iostream>
#include<string>
#define MAXSIZE 100

using namespace std;

struct M_g  //定义邻接矩阵
{
	string *Head;  //顶点表
	int  **arc;              //邻接矩阵可以看成边表
	int  N_v, N_e;           //记录顶点数和边数
};

//创建一个邻接矩阵表示图
void OnCreateM_g(M_g *&x)
{
	int i, j, k, w;
	cout << "输入顶点个数和边数" << endl;
	cin >> x->N_v >> x->N_e; //依次输入顶点数和边数
	cout << "顶点数为:" << x->N_v << ";" << "边数为:" << x->N_e << endl;

	for (int i = 0; i < x->N_v; i++)
	{
		cin >> x->Head[i];  //依次输入顶点
	}

	for (int i = 0; i < x->N_v; i++)  //给出每个顶点是否连接
	{
		for (int j = 0; j < x->N_v; j++)
		{
			x->arc[i][j] = INT_MAX;
		}
	}

	cout << "输入(Vi,Vj)的上标i, 下标j和权w" << endl;
	for (k = 0; k < x->N_e; k++)  //
	{
		cin >> i >> j >> w;
		x->arc[i][j] = w;
		x->arc[j][i] = x->arc[i][j]; //无向图是对称矩阵
	}
}

//打印图
void Print(M_g x)
{
	int i;
	for (i = 0; i < x.N_v; i++)
	{
		for (int j = 0; j < x.N_v; j++)
		{
			if (x.arc[i][j] == INT_MAX)
			{
				cout << "∞" << "  ";
			}
			else
			{
				cout << x.arc[i][j] << "  ";
			}
		}
		cout << endl;
	}
}


//记录边的信息, 这些边都是达到end的所有边中, 权重最小的那个
struct Assis_array
{
	int start; //边的起点
	int end;   //边的终点
	int weight;//边的权重
};


//Prim算法实现, 图的存储方式为邻接矩阵
void Prim(M_g *x, int begin)
{
	//创建一个保存到达某个顶点的各个边中权重最大的那个边的结构体数组
	Assis_array *edge = new Assis_array[x->N_v];

	int j;

	//edge初始化, 初始化时用顶点0到该点的边为权值最大边
	for (j = 0; j < x->N_v; j++)
	{
		if (j != begin - 1)
		{
			edge[j].start = begin - 1;
			edge[j].end = j;
			edge[j].weight = x->arc[begin - 1][j];
		}
	}

	//将起点的edge的权值设置为-1,表示已经加入到集合U了
	edge[begin - 1].weight = -1;

	//b访问剩下的顶点, 并依次加入到集合U
	for (j = 1; j < x->N_v; j++)
	{
		int min = INT_MAX;
		int k;
		int index;

		//寻找数组权重最小的那边条边
		for (k = 0; k < x->N_v; k++)
		{
			if (edge[k].weight != -1)
			{
				if (edge[k].weight < min)
				{
					min = edge[k].weight;
					index = k;
				}
			}
		}

		//将权重最小的那条边的终点也加入集合U
		edge[index].weight = -1;

		//输出对应的边的信息
		cout << edge[index].start
			<< "-----"
			<< edge[index].end
			<< "="
			<< x->arc[edge[index].start][edge[index].end] << endl;

		//更新我们的edge数组
		for (k = 0; k < x->N_v; k++)
		{
			if (x->arc[edge[index].end][k] < edge[k].weight)
			{
				edge[k].weight = x->arc[edge[index].end][k];
				edge[k].start  = edge[index].end;
				edge[k].end    = k;
			}
		}
	}
}


int main() {
	M_g *p;
	p = (M_g*)malloc(sizeof(M_g));
	OnCreateM_g(p);
	Prim(p,1);
	system("pause");
	return 0;

}
克鲁斯卡(Kruskal)算法:
(1)将图中的所有边都去掉. 
(2)将边按照权值从小到大的顺序添加到图中, 保证添加的过程中不会形成环
(3)重复以上一步策略直到连接所有顶点, 此时就生成了最小生成树. 这是一种贪心策略. 
模拟克鲁斯卡算法生成最小生成树的详细的过程:
首先完整的图如下图: 

然后, 我们需要从这些边中找出权重最小的那条边, 可以发现边(v1, v3)这条边的权重是最小的, 所以我们输出边:v1—-v3=1 

然后, 我们需要在剩余的边中, 再次寻找一条权重最小的边, 可以发现边(v4, v6)这条边的权重最小, 所以输出边:v4—v6=2 

然后, 我们再次从剩余边中寻找权重最小的边, 发现边(v2, v5)的权重最小, 所以可以输出边:v2—-v5=3,  

然后, 我们使用同样的方式找出了权重最小的边:(v3, v6), 所以我们输出边:v3—-v6=4 

好了, 现在我们还需要找出最后一条边就可以构造出一颗最小生成树, 但是这个时候我们有三个选择:(v1,V4), (v2, v3), (v3, v4),这三条边的权重都是5, 首先我们如果选(v1, v4)的话, 得到的图如下: 
 
我们发现, 这肯定是不符合我们算法要求的, 因为它出现了一个环, 所以我们再使用第二个(v2, v3)试试, 得到图形如下: 

我们发现, 这个图中没有环出现, 而且把所有的顶点都加入到了这颗树上了, 所以(v2, v3)就是我们所需要的边, 所以最后一个输出的边就是:v2—-v3=5, 最后, 我们的最小生成树完成. 
代码实现:
8.4, 最短路径
        最短路径:从一个顶点到另一个顶点可能存在多条路径, 每条路径上所经过的边数可能不同, 即路径长度不同, 把路径长度最短的那条路径叫做最短路径. 对于带权的图, 应该考虑路径上各边的权值, 通常把一条路径上所经过的边的权值之和定为该路径的长度或者带权路径长度. 
1, 从一个顶点到其余各个顶点的最短路径:狄克斯特拉(Dijkstra)算法
        Dijkstra算法是典型最短路径算法, 用于计算一个节点到其他节点的最短路径.  
        它的主要特点是以起始点为中心向外层层扩展(广度优先搜索思想(BFS)), 直到扩展到终点为止. 
基本思想
        通过Dijkstra计算图G中的最短路径时, 需要指定起点s(即从顶点s开始计算). 
        此外, 引进两个集合S和U. S的作用是记录已求出最短路径的顶点(以及相应的最短路径长度), 而U则是记录还未求出最短路径的顶点(以及该顶点到起点s的距离).  初始时, S中只有起点s;U中是除s之外的顶点, 并且U中顶点的路径是"起点s到该顶点的路径". 然后, 从U中找出路径最短的顶点, 并将其加入到S中;接着, 更新U中的顶点和顶点对应的路径.  然后, 再从U中找出路径最短的顶点, 并将其加入到S中;接着, 更新U中的顶点和顶点对应的路径. ... 重复该操作, 直到遍历完所有顶点. 
操作步骤
(1) 初始时, S只包含起点s;U包含除s外的其他顶点, 且U中顶点的距离为"起点s到该顶点的距离"[例如, U中顶点v的距离为(s,v)的长度, 然后s和v不相邻, 则v的距离为∞]. 
(2) 从U中选出"距离最短的顶点k", 并将顶点k加入到S中;同时, 从U中移除顶点k. 
(3) 更新U中各个顶点到起点s的距离. 之所以更新U中顶点的距离, 是由于上一步中确定了k是求出最短路径的顶点, 从而可以利用k来更新其它顶点的距离;例如, (s,v)的距离可能大于(s,k)+(k,v)的距离. 
(4) 重复步骤(2)和(3), 直到遍历完所有顶点. 
狄克斯特拉算法图解

以上图G4为例, 来对狄克斯特拉进行算法演示(以第4个顶点D为起点). 
初始状态:S是已计算出最短路径的顶点集合, U是未计算除最短路径的顶点的集合! 
第1步:将顶点D加入到S中.  此时, S={D(0)}, U={A(∞),B(∞),C(3),E(4),F(∞),G(∞)}.      注:C(3)表示C到起点D的距离是3. 
第2步:将顶点C加入到S中.  上一步操作之后, U中顶点C到起点D的距离最短;因此, 将C加入到S中, 同时更新U中顶点的距离. 以顶点F为例, 之前F到D的距离为∞;但是将C加入到S之后, F到D的距离为9=(F,C)+(C,D). 此时, S={D(0),C(3)}, U={A(∞),B(23),E(4),F(9),G(∞)}. 
第3步:将顶点E加入到S中. 上一步操作之后, U中顶点E到起点D的距离最短;因此, 将E加入到S中, 同时更新U中顶点的距离. 还是以顶点F为例, 之前F到D的距离为9;但是将E加入到S之后, F到D的距离为6=(F,E)+(E,D). 此时, S={D(0),C(3),E(4)}, U={A(∞),B(23),F(6),G(12)}. 
第4步:将顶点F加入到S中. 此时, S={D(0),C(3),E(4),F(6)}, U={A(22),B(13),G(12)}. 
第5步:将顶点G加入到S中. 此时, S={D(0),C(3),E(4),F(6),G(12)}, U={A(22),B(13)}. 
第6步:将顶点B加入到S中. 此时, S={D(0),C(3),E(4),F(6),G(12),B(13)}, U={A(22)}. 
第7步:将顶点A加入到S中. 此时, S={D(0),C(3),E(4),F(6),G(12),B(13),A(22)}. 
此时, 起点D到各个顶点的最短距离就计算出来了:A(22) B(13) C(3) D(0) E(4) F(6) G(12). 
代码实现:
#include<iostream>

using namespace std;


//用邻接矩阵来表示图
struct M_g
{
	char *vexs;    //顶点集合
	int  vexnum;   //顶点个数
	int  edgnum;   //边的条数
	int  **matrix; //邻接矩阵
};

//边的结构体
struct edge
{
	char start;  //边的起点
	char end;    //边的终点
	int  weight; //边的权重
};

//创建一个邻接矩阵表示图
void OnCreateM_g(M_g *&x)
{
	int i, j, k, w;
	cout << "输入顶点个数和边数" << endl;
	cin >>  x->vexnum >> x->edgnum; //依次输入顶点数和边数
	cout << "顶点数为:" << x->vexnum << ";" << "边数为:" << x->edgnum << endl;

	for (int i = 0; i < x->vexnum; i++)
	{
		cin >> x->vexs[i];  //依次输入顶点
	}

	for (int i = 0; i < x->vexnum; i++)  //给出每个顶点是否连接
	{
		for (int j = 0; j < x->vexnum; j++)
		{
			x->matrix[i][j] = INT_MAX;
		}
	}

	cout << "输入(Vi,Vj)的上标i, 下标j和权w" << endl;
	for (k = 0; k < x->edgnum; k++)  //
	{
		cin >> i >> j >> w;
		x->matrix[i][j] = w;
		x->matrix[j][i] = x->matrix[i][j]; //无向图是对称矩阵
	}
}

//打印图
void Print(M_g x)
{
	int i;
	for (i = 0; i < x.vexnum; i++)
	{
		for (int j = 0; j < x.vexnum; j++)
		{
			if (x.matrix[i][j] == INT_MAX)
			{
				cout << "∞" << "  ";
			}
			else
			{
				cout << x.matrix[i][j] << "  ";
			}
		}
		cout << endl;
	}
}

//Dijkstra算法
void Dijkstra(M_g *x, int StartNode)
{
	int *dist, int *prev;  //dist表示顶点StartNode到顶点i的最短路径长度, prev顶点StartNode到顶点i的最短路径的前一个节点
	int i, j, k;
	int min;
	int *flag;  //表示顶点StartNode到顶点i的最短路径是否成功获取

	//初始化
	for (int i = 0; i < x->vexnum; i++)
	{
		flag[i] = 0;
		prev[i] = StartNode;
		dist[i] = x->matrix[StartNode][i];
	}

	//对顶点StartNode自身初始化
	flag[StartNode] = 0;
	dist[StartNode] = 0;

	//遍历x->vecnum-1次, 每次找出一个顶点的最短路径
	for (int i = 1; i < x->vexnum; i++)
	{
		min = INT_MAX;
		for (int j = 0; j < x->vexnum; j++)
		{
			if (flag[j] == 0 && dist[j] < min)
			{
				min = dist[j];
				k = j;
			}
		}
		flag[k] = 1;//表示k已经是最短路径

		//更新未获取最短路径的顶点的最短路径和前驱顶点
		for (int  j = 0; j < x->vexnum; j++)
		{
			if (flag == 0)
			{
				if (x->matrix[k][j] <INT_MAX && dist[k] + x->matrix[k][j] <dist[j])
				{
					dist[j] = dist[k] + x->matrix[k][j];
					prev[j] = k;
				}
			}
		}
	}
}
##  9, 串的模式匹配
9.1, BF算法
        算法的基本思想:从主串的第1个字符起和模式串的第一个字符比较, 若相等, 则继续逐个比较后续字符, 否则从主串的第2字符起重新和模式串的字符比较. 依次类推, 直到模式串t中的每个字符依次和主串s中的一个连续的字符序列相等, 则匹配成功. 否则匹配不成功. 

#include<stdio.h>
//串的定长顺序存储表示
#define MAXSTRLEN 50  // // 用户可在50以内定义最大串长
typedef unsigned char SString[MAXSTRLEN + 1];//0号单元存放串的长度
 
//返回子串T在主串S中第pos个字符之后的位置. 若不存在, 则函数值为0. 其中, T非空, 1<=pos<=StrLength(S). 
int indexBF(SString S, SString T, int pos){
	int i = pos, j = 1;
	while(i <= S[0] && j <= T[0]){
		if(S[i] == T[j]){
			i++;
			j++;
		}else{
			i = i - j + 2;//i回到原位置是i - j + 1 ,所以i退到远位置的下一个位置是i - j + 1 + 1
			j = 1;
		}
	}
	if(j > T[0]){//如果j > len(T), 说明模式串T与S中某子串完全匹配
		return i - T[0];//因为i是已经自增过一次了, 所以是i-len(T)而不是i-len(T)+1
	}else
		return 0;
}
 
void init(SString &S, char str[]){
	int i = 0;
	while(str[i]!='\0'){
		S[i+1] = str[i];
		i++;
	}
	S[i+1] = '\0';
	S[0] = i;
}
 
void printStr(SString Str){
	for(int i = 1; i <= Str[0]; i++){
		printf("%c", Str[i]);
	}
	printf("\n");
}
void main(){
	SString S ;
	init(S, "ababcabcacbab");
	printStr(S);
 
	SString T;
	init(T, "abcac");
	printStr(T);
 
	int index = indexBF(S, T, 1);
	printf("index is %d\n", index);
}
9.2, KMP算法
         朴素算法会顺序遍历, 比较第一次的时候p[0]处失配, 然后向后移动继续匹配. 数据量大的时候这么做肯定是不可行的. 所以这里就会有KMP算法!在一次失配之后, KMP算法认为这里已经失配了, 就不能在比较一遍了, 而是将字符串P向前移动(已匹配长度-最大公共长度)位, 接着继续比较下一个位置. 这里已匹配长度好理解, 但是最大公共长度是什么呐?这里就出现了next数组, next数组:next[i]表示的是P[0-i]最大公共前后缀公共长度. 这里肯定又有人要问了, next数组这么奇葩的定义, 为什么就能算出来字符串需要向后平移几位才不会重复比较呐?

        上图中红星标记为例, 此时在p[4]处失配, 已匹配长度为4,而next[3]=2(也就是babaa中前后缀最大公共长度为0), 这时候向后平移已匹配长度-最大公共长度=2位,P[0]到达原来的P[2]的位置, 如果只平移一位,P[0]到达p[1]的位置这个位置没有匹配这次操作就是无用功所以浪费掉了时间. 已知前缀后缀中的最大公共长度, 下次位移的时候直接把前缀位移到后缀上面直接产生匹配, 这样直接从后缀的后一位开始比较就可以了. 这样将一下无意义的位移过滤掉剩去了不少的时间. 
void makeNext(const char P[],int next[])
{
    int q,k;
    int m=strlen(P);
    next[0]=0;
    for (q=1,k=0;q<m;++q)
    {
        while(k>0&&P[q]!=P[k])
            k = next[k-1];
        /*
        这里的while循环很不好理解!
        就是用一个循环来求出前后缀最大公共长度;
        首先比较P[q]和P[K]是否相等如果相等的话说明已经K的数值就是已匹配到的长的;
        如果不相等的话, 那么next[k-1]与P[q]的长度, 为什么呐?因为当前长度不合适
        了, 不能增长模板链, 就缩小看看next[k-1]
        的长度能够不能和P[q]匹配, 这么一直递归下去直到找到
        */
        if(P[q]==P[k])//如果当前位置也能匹配上, 那么长度可以+1
        {
            k++;
        }
        next[q]=k;
    }
}
int kmp(const char T[],const char P[],int next[])
{
    int n,m;
    int i,q;
    n = strlen(T);
    m = strlen(P);
    makeNext(P,next);
    for (i=0,q=0;i<n;++i)
    {
        while(q>0&&P[q]!= T[i])
            q = next[q-1];
        /*
        这里的循环就是位移之后P的前几个字符能个T模板匹配
        */
        if(P[q]==T[i])
        {
            q++;
        }
        if(q==m)//如果能匹配的长度刚好是T的长度那么就是找到了一个能匹配成功的位置
        {
            printf("Pattern occurs with shift:%d\n",(i-m+1));
        }
    }
}
##  10, 分治算法
##  11, 动态规划算法
##  12, 回溯法


#  C++常用数据结构的实现
##  KMP字符串匹配算法
有时候我们需要在一大段字符串中得到找到我们想要的位置, 这个时候KMP字符串匹配算法是一种比较好的选择. 
首先我们需要进行匹配字符串的预处理, 即我们要在一个字符串中找另外一个字符串, 我们需要预处理这个字符串. 主要是查看这个字符串上有没有"最长公共子序列". 最长公共子序列是是KMP算法的核心概念. 这决定了我们一位位向前移动匹配的时候, 如果遇到匹配失败的我们应该如何处理, 是整个匹配字符串向前挪动一位吗, 其实不是挪动一位, 只要我们可以知道最长公共子序列, 那么我们就可以直接在比较发现不匹配之后, 移动一个更大的距离, 而不是一格, 继续比较. 而我们所说的那个"更大的距离", 就是由"最长公共子序列"决定的, 我们需要知道, 在已经匹配到的子字符串两头最大的公共部分是多少, 下次比较的时候我们直接在匹配失败的时候把最大公共部分的前面那部分平移过来, 前面那一部分最长公共子序列的下一位开始比较. 
预处理还是很简单的:
//我们首先先进行预处理, 需要delete这个堆区数组
int *pre_handle_arr = pre_handle(patch_string);


//然后进行比较
int compare_continue = -1;

int patch_string_index = 0;
int goal_string_index = 0;

//退出这个循环主要是两种情况, 首先就是目标字符串走完了, 还有就是要匹配别人的小字符串走完了, 前者代表失败, 后者代表成功
while(patch_string_index < patch_string.length() && goal_string_index < goal_string.length()){

if(patch_string[patch_string_index] == goal_string[goal_string_index]){
compare_continue = pre_handle_arr[patch_string_index];
patch_string_index++;
goal_string_index++;
}else{
//如果没有匹配成功, 并且这个时候compare_continue是-1, 说明在已匹配子串中没有最大公共子序列
//那么我们直接匹配目标字符串的下一位
if(compare_continue == -1){
goal_string_index++;
patch_string_index = 0;
}else{
//如果在某一位匹配失败, 并且有公共子序列, 那么就利用公共子序列, 将公共子序列的前半部分向前挪到后半部分的位置
patch_string_index = compare_continue + 1;

compare_continue = pre_handle_arr[compare_continue];
// cout << patch_string_index << "," << compare_continue << endl;
}
}

// cout << patch_string_index << "," << goal_string_index << endl;
}
道理很简单, 除了第一位, 每一位的字符都要和tmp+1这个位置的字符比对一下. 如果相等, 那么就可以说明最大公共子字符串又扩充了一位. 
在逻辑上比较繁琐的就是进行字符串比较的那个过程, 有点绕:
//我们首先先进行预处理, 需要delete这个堆区数组
int *pre_handle_arr = pre_handle(patch_string);


//然后进行比较
int compare_continue = -1;

int patch_string_index = 0;
int goal_string_index = 0;

//退出这个循环主要是两种情况, 首先就是目标字符串走完了, 还有就是要匹配别人的小字符串走完了, 前者代表失败, 后者代表成功
while(patch_string_index < patch_string.length() && goal_string_index < goal_string.length()){

if(patch_string[patch_string_index] == goal_string[goal_string_index]){
compare_continue = pre_handle_arr[patch_string_index];
patch_string_index++;
goal_string_index++;
}else{
//如果没有匹配成功, 并且这个时候compare_continue是-1, 说明在已匹配子串中没有最大公共子序列
//那么我们直接匹配目标字符串的下一位
if(compare_continue == -1){
goal_string_index++;
patch_string_index = 1;
}else{
//如果在某一位匹配失败, 并且有公共子序列, 那么就利用公共子序列, 将公共子序列的前半部分向前挪到后半部分的位置
patch_string_index = compare_continue + 1;

compare_continue = pre_handle_arr[compare_continue];
//cout << patch_string_index << "," << compare_continue << endl;
}
}

// cout << patch_string_index << "," << goal_string_index << endl;
}
首先我们要注意循环的条件, 必须两个string都没有遍历完才可以进行循环, 两个之中有其中一个遍历完了就不可以循环了. 
我们主要使用patch_string_index和goal_string_index两个索引分别遍历匹配小字符串和目标字符串. 如果相等, 当然是这两个索引都会自增, 然后比较目标字符串和匹配小字符串的下一位. 如果发现不匹配了, 首先就要看看以匹配的子串里面有没有最大公共子字符串(使用compare_continue==-1). 如果没有, 那么直接使用匹配字符串的第0位去匹配, 目标字符串的下一位就好了(patch_string_index=0赋值, goal_string_index自增). 如果发现有最大公共子字符串那就让最大公共子字符串的后一位去匹配目标字符串的当前位置. 所以对于比较的结果, 一共是三类情况. 

##  环状队列
因为队列只能从尾部加入, 从顶部移出, 所以我们使用传统数组的方式会有问题, 因为随着头部内容的不断移出以及尾部的不断移进, 整个队列会逐渐往线性表的后部靠拢, 这样子在线性表的前半部分就会有很大的空间浪费. 如果要把已经贴近后半部分的内容挪到靠近线性表头部的位置, 这就需要大量的开销, 所以我们就需要换装队列. 
环状队列本质上还是线性表, 通过取模的操作获得环状的效果. 
环状队列比较什么时候满的时候我们, 除了可以维护一个存储了环状队列当前容量的变量之外还可以预留一个空位置. 为了统一我们的逻辑, 我们必须设定一套在所有的时期都适用的判定环状队列空或者满的办法. 我们设定头指针与尾指针重合代表空, 尾索引取模如果比头索引取模之后小1, 或者比头索引大maxsize-1那么就说明队列已经满了. rear永远指向没有值的下一个要插入的位置, 头索引永远指向下一个要推出的值, 除非队列是空的. 
这次实现中使用了模板类, 因为模板类不是类, 所以模板类是不能拆的, 应该放在一个头文件中, 要不就会报错. 此外我们就是要注意取模和边界条件. 这样子就可以了. 总体的实现还是比较简单的. 

##  走迷宫算法
走迷宫算法是一个对栈结构的非常不错的利用, 我们我们通过一个栈来获得我们已经走过的路径, 如果栈顶的节点在所有方向上都走不通, 那就进行弹栈操作. 在倒数第二个节点上进行各个方向的尝试. 任何曾经进过栈的节点都会被记录下来, 防止走重复的路. 
这里在编程里面碰到了一些问题, 比如在C++11中, 我们发现枚举和结构体实例化的时候我们不再需要在前面再加struct和enum这两个关键词. 直接当做一个类使用就好了. 
此外我们发现int a[][], 实际上a变量这个时候并不是一个二维指针, 而是一个数组对象, 所以说我们没有办法把他当做一个二维指针使用. 其实使用栈空间来申请二维数组, 获取其二维指针的方式并不是没有, 但是比较困难, 并且语法比较容易混淆, 所以我们使用new的方式产生线性数组, 以及指针数组来产生二维数组. 
在if和while条件上我也出现了不止一次的错误, 注意非(!)与或等运算符组合起来的关系. 
还要注意的是, 枚举是一种常量, 不能进行自增操作. 

##  中缀表达式转后缀表达式
这也是一个使用栈的经典案例, 我们使用栈来保存符号, 而变量字符会被直接输出. 符号一共有6种, 加, 减, 左右小括号, 乘除. 而这个"符号栈"的入栈和出栈规则如下:
符号是有优先级的, 正常情况下, 符号会一位一位进入栈中, 如果碰到了一个运算符, 不比栈顶运算符的优先级小, 那么这个运算符就要正常入栈. 
出栈的策略非常简单, 如果整个表达式走完了就把所有的符号弹出并且输出, 如果表达式没有走完, 但是有一个比栈顶运算符优先级小的运算符要入栈, 那就先要将栈中的所有元素推出. 
括号的处理也很重要, 一般情况下, 左括号我们直接入栈就好, 遇到右括号, 那么我们就需要我们将右括号与左括号之间的弹栈就好. 左括号了右括号不会出现在后缀表达式中. 

##  环装链表
环装链表. 环装链表主要就是链表的最后一个元素的next指针会指向链表的头部. 
首先是数据成员的设计, 在实践过程中发现, 环装链表最好不要使用first指针, 使用last指针才是比较正确的. 因为使用first指针的时候如果我们需要在链表的头部增加节点, 那么最后一个节点的next指针要指向新的头部. 那这就涉及到一个问题, 我们怎么自能让最后一个节点的指针指向新的头部, 如果我们只有first指针, 那么我们只能遍历整个链表, 然后去修改最后一个节点的next指针, 这样子开销很大. 
所以在环形链表中应该使用last指针, last指针指向链表的最后一个节点, 这样子无论从链表的头部开始尾部添加元素都会变得比较简单. 
另外我们发现在模板中, 我们不能为形参设定缺省值. 另外加在头部和尾部的节点也要在逻辑上单独处理. 
在删除节点的过程中, 我们对于最后一个节点的删除要尤其注意, 因为删除最后一个节点之后, 我们要重新定位last, 所以我们需要单独处理, 需要单独记录一下倒数第二个节点的指针, 以便让last指针定位. 
最后在说一下析构函数, 析构函数就是不断执行链表第一个元素的删除操作就好了. 

##  双向链表
当我们需要向头尾两个方向遍历的时候我们就需要双向链表了, 为了体现双向链表的优势, 我们打算实现goleft, goright, addleft, addright, deleteleft, deleteright, 这几个函数, 主要的工作就是让一个指针不断在链表中移动, 可以理解为是双向链表这个对象和迭代器的结合体. 
其实在实现链表的时候书上一直都建议使用空头部节点的设计, 这种方式有很多的好处, 可以统一逻辑, 减少边界条件的判断. 在双向链表的实现中我们也使用这种被推荐的设计. 此外我们依旧要实现一个换装双向链表. 
这里唯一要注意的问题就是这个空白的头结点的左右指针怎么指, 为了保证在遍历链表的过程中, 让左边最边上一个元素的在往左边走就是空白头结点, 而空白头结点再往左边走是右边第一个节点, 这样子循环起来. 我们需要精心设计空白头结点的通往左节点的指针和右节点的指针. 
有关于双向链表的初始化问题比较有一起, 比较精妙的设计是初始化一个空白的头结点, 然后让这个空白头结点的左右节点指针全部指向自己, 这样子做的好处就是可以统一所有的关于插入和删除节点的逻辑. 并且上文所说的头结点左右指针的"精心设计"也可以和一般节点的逻辑统一起来. 
意外因为头结点比较重要最好不要删除, 所以我们在删除的时候会弹出警告. 
这样子双向链表就完成了. 
##  树
###  二叉树
树是一种非常重要的数据结构, 二叉树更是重中之重. 我们可以知道. 使用数组来表示一个二叉树是一个非常容易的事情. 我们从数组的1号位置开始记录, 我们在1号位置存储的是树的根. 对于一个深度为k的数组来说, 我们最多可以容纳2^k-1个元素. 
我们使用数组对二叉树进行了实现, 对于i号元素来说, 他的左节点就在i*2处, 右节点在i*2+1处. 我们知道在此基础之上注意数组溢出的问题就可以了. 
子树的删除使用的是递归程序, 在删除子树的根节点之后我们知道再去删除子树的左右节点就可以了. 
二叉树的数组实现对于完全二叉树来说是一种比较简单合适的解法, 但是如果是不太完全的二叉树, 那么就会出现空间的浪费, 所以使用二叉树的链表表示更为合适. 
此外我们还进行了树的链表表示, 链表表示的难点就是析构的部分, 我觉得使用一种合理的遍历方式就可以进行析构. 
树的广度优先搜索
树的链表形式在析构的时候需要广度优先搜索, 广度优先搜索的最需要的就是队列这样一个结构, 我们首先将根节点放在队列中, 我们析构在队列头部的节点, 如果这个节点有子女, 那么子女也会全部加入在队列尾部. 通过不断析构头部元素, 当队列为空的时候就代表整个树的析构就完成的. 
二叉树的遍历
二叉树有三种常见的遍历方式, 分别是前序遍历, 中序遍历, 后序遍历. 具体的遍历方式和这个名字是一样的. 遍历的过程是一种递归算法, 三种遍历方式区别就是每一次递归子树根节点扫描的次序. 如果是前序遍历那扫描的顺序就是"打印根->递归左子树->递归右子树";如果是中序遍历, 那扫描的顺序就是"递归左子树->打印根节点->递归右子树";如果是后序遍历, 那么扫描的顺序就是"递归左子树->递归右子树->打印根节点". 这样子就完成了扫描. 
因为我们的二叉树一共提出了两种实现, 一种是链表方式, 一种是数组方式. 所以我们打算为这两种实现的类设定一个基类. 这个基类也是一个模板类, 所有函数和操作和我们的两种实现一样, 我们利用多态, 以及虚函数, 来保证他们的基类就是前序遍历, 中序遍历, 后序遍历的形参. 
这里稍微提一下C++语法的事情. 首先基类的析构函数必须是虚函数. 我们知道派生类的构造函数会默认调用基类的缺省构造函数, 派生类的析构函数也会调用基类的析构函数. 这种特性注定了我们基类的析构函数首先必须是虚函数, 并且不能是纯虚函数, 因为派生类的析构会用上. 
但是我们发现使用外部函数传入Tree类型形参的方式没法很好地进行递归操作. 因为一个是链表一个是数组, 逻辑没有办法统一. 
所以我们使用成员函数的方式对Tree进行遍历. 使用两套不一样的逻辑. 这里我们对数组二叉树的遍历进行实现. 
二叉树的非递归遍历
二叉树而非递归遍历可以节省更多内存占用, 我们可以通过使用一个栈来进行前, 中, 后序遍历. 
先说一下非递归的前序遍历, 我们的主要思路就是不断将子树的根节点放入栈中, 并打印根节点. 然后让遍历的指针往左子树不停走. 也就是根节点在入栈的时候就要打印, 然后当已经没有左节点可以再走的时候, 我们就可以进行弹栈操作了, 弹栈之后就去看右子树. 
然后是非递归的中序遍历, 我们还是先不断让根节点入栈, 然后不断向左节点移动. 中序遍历是在弹栈的时候进行打印. 弹栈之后看右子树. 
后序遍历是最麻烦的非递归遍历方式. 主要就是子树的根会最早进栈, 并且在子树的根的右子树还没有遍历的时候, 不会出栈, 出栈打印. 
面对栈的状态我们可以很清楚地知道, 前序遍历和中序遍历的栈中右子树节点对应的父节点是不会出现在栈中的, 二者的区别主要是栈中元素的打印时间不一样, 一个是在入栈, 一个是在出栈. 后序遍历栈中元素会多一些, 因为根节点和右子树的根节点全部都会出现在栈中. 
我们在链表二叉树中进行了非递归遍历的实现. 
首先是后序遍历, 这个遍历的我们需要有"几个注意", 因为是非递归的, 所以我们需要对整个的遍历顺序过程极为了解, 我们整体遍历的趋势应该是首先"一口气向左子树走到底", 在这过程中, 所有的根节点一直入栈, 直到"左不下去"了然后弹栈, 弹栈的时候要看看栈中的节点有没有有没有右子树, 如果有右子树, 要优先进入右子树的遍历, 也是在右子树中"一口气左到底", 然后不断入栈. 在非递归的后序遍历算法中, 入栈和出栈都是一种正反馈的过程, 只要入栈就会一口气让一串左子树入栈, 只要出栈, 除非碰到栈顶元素有右子树(右子树会入栈, 然后因为正反馈, 会让右子树的所有左子树全部入栈), 要不弹栈就不会停. 
在这个算法的实现中我们需要两个额外空间, 一个是栈, 一个是标记栈中节点的右子树有没有被遍历的数组. 
template<class T>
void LinkedBTree<T>::post_order() {
//我们进行后序遍历, 首先创建一个栈空间. 
//栈空间存放树的节点
now = root;
LinkedBItem<T> **stack = new LinkedBItem<T> *[100];
//索引从-1开始, 指向当前的栈顶
int stackIndex = -1;
//我们建立一个数组, 主要是为了查看栈中节点的有没有右子树需要遍历, 如果已经被遍历了, 那就可以安心弹栈, 如果没有被遍历
//那就只能只能再把右节点压栈. 压栈是一个"正反馈"的过程, 一旦出现了压栈, 那就会一压到底, 不断向左节点走, 直到不能再压
//一旦压到不能再压, 那就会进入弹栈程序, 弹栈主要做的就是检查当前节点的右子树. 
int *hasScanRight = new int[100];

//初始化数组
for (int i = 0; i < 100; ++i) {
hasScanRight[i] = 0;
}


//首先我们先让根节点入栈, 然后触发"入栈正反馈", 直到now是空指针为止
stack[++stackIndex] = root;

if (root->right != 0) {
hasScanRight[stackIndex] = 1;
}

while (stackIndex != -1) {
now = stack[stackIndex];

while (now->left != 0) {
stack[++stackIndex] = now->left;
//入栈之后查看右节点的情况, 然后修改那个查看右子树是不是已经被遍历的数组
if (stack[stackIndex]->right != 0) {
hasScanRight[stackIndex] = 1;
}

now = now->left;
}

//当完成"入栈正反馈"之后, 我们就可以弹栈过程, 弹栈的时候我们就可以看看是不是右子树有没有东西
while (stackIndex != -1 && hasScanRight[stackIndex] == 0) {
//如果右子树没有东西, 那就进入正常的弹栈过程, 弹栈也是一个正反馈过程如果, 如果一直右子树没有东西, 就可以一直弹
cout << stack[stackIndex]->element << " , ";
stackIndex--;
}

//从这个while中出来有两种情况, 一种就是发现右子树还在的, 一种就是stack已经空了
if (hasScanRight[stackIndex] == 1) {
//如果右子树有东西, 那么我们就要进行新一轮的压栈操作, 压栈的之后还要看看新入栈的节点有没有右子树
stack[stackIndex + 1] = stack[stackIndex]->right;

//右节点已经入栈, 修改hasScanRight数组
hasScanRight[stackIndex] = 0;
stackIndex++;

if (stack[stackIndex]->right != NULL) {
hasScanRight[stackIndex] = 1;
}
}
}

cout << endl;
//析构申请的资源
delete[]stack;

delete[]hasScanRight;
}
然后我们实现前序遍历和中序遍历, 这两种遍历方式的实现基本是一样的, 除了栈中元素打印的时间不一样. 前序遍历的主要工作就是在子树根节点入栈的时候打印树节点内容. 当已经没有左子树根节点可以入栈的时候, 我们进行出栈过程, 出栈过程也是一个正反馈的过程, 只有当当前节点有右子树的时候才会停止, 但是当前节点也会被弹出. 此时, 新发现的右子树会入栈并打印自身, 然后又是一系列的"正反馈入栈". 整个过程讲以stack全部弹出并且没有新的节点加入画上一个句号. 
template<class T>
void LinkedBTree<T>::pre_order() {
//前序遍历也需要一个树节点指针的栈区
LinkedBItem<T> **stack = new LinkedBItem<T> *[100];
//栈索引从-1开始
int stackIndex = -1;
now = root;
//然后我们让根节点进入栈
stack[++stackIndex] = root;
cout << stack[stackIndex]->element << " , ";
//然后开始前序遍历, 栈不为空, 遍历就继续
while (stackIndex != -1) {
//如果栈顶元素有左子树, 激活入栈正反馈
now = stack[stackIndex];
//如果栈顶元素没有左子树了那就不用再压栈了
while (now->left != 0) {
stack[++stackIndex] = now->left;
cout << stack[stackIndex]->element << " , ";
now = now->left;
}

//到这里, 栈顶元素就是没有左子树的二叉树节点了, 我们弹栈, 并且查看右子树, 如果要弹栈的元素有右子树, 那么在弹栈之后把右子树加入
//弹栈也是一个正反馈的过程, 直到弹空或者发现当前栈顶节点有右子树(此时当前节点也会被弹出)
while (stackIndex != -1) {
//如果发现当前节点有右子树, 那就停止弹栈, 但是当前节点也会弹出
if (stack[stackIndex]->right != 0) {
//进行最后一次弹栈
stackIndex--;
//然后将右子树加入栈中
stack[stackIndex + 1] = stack[stackIndex + 1]->right;
stackIndex++;
//入栈要打印
cout << stack[stackIndex]->element << " , ";
//结束循环, 回到外层循环顶部进行正反馈入栈, 入栈会激活新的入栈
break;
} else {
//当前节点没有右子树直接弹栈, 并且如果一直没有右子树, 那就一直弹, 也是正反馈
stackIndex--;
}
}
}
cout << endl;

//空间回收
delete[]stack;
}
中序遍历和前序遍历的代码基本上一致, 就是打印节点的时机不一样. 
template<class T>
void LinkedBTree<T>::in_order() {
//创造一个栈
LinkedBItem<T> **stack = new LinkedBItem<T> *[100];
//栈顶索引
int stackIndex = -1;

//根节点入栈
stack[++stackIndex] = root;

while (stackIndex != -1) {
now = stack[stackIndex];

//触发入栈正反馈
while (now->left != 0) {
stack[++stackIndex] = now->left;
now = now->left;
}

//现在栈顶节点已经没有左子树了
//我们可以出栈了
while (stackIndex != -1) {
//只要没有右子树出现, 那就一直执行出栈操作
//出现右子树, 弹出当前节点, 加入右子树根节点
if (stack[stackIndex]->right != 0) {
//打印当前节点
cout << stack[stackIndex]->element << " , ";
//将当前节点换成右子树根节点
stack[stackIndex] = stack[stackIndex]->right;
//退出循环, 并且进入外层循环的左子树入栈过程
break;
} else {
//没有右子树, 那就一直弹栈
cout << stack[stackIndex]->element << " , ";
stackIndex--;
}
}
}
cout << endl;
delete[]stack;
}
胜者树与败者树
当我们需要进行多路已排序的数组按照顺序合并的时候, 我们需要使用胜者树和败者树. 我觉得这两种树实际上性能一样, 只是败者树的我们把一个节点拿到之后, 新的节点会进入处在叶子节点的缓冲区, 新来的节点不用和兄弟节点比较来进行树的重构, 而是可以直接和父节点比较来进行重构. 我们每次和父节点比较就好了, 比如比父节点要优先, 那就继续像父节点的父节点比较, 如果不比父节点优先, 那就把这个值留在原地, 父节点代替他不断向上比较. 下面胜者树和败者树的结构. 

这个是胜者树的结构, 这个是一个完全树, 所以可以使用数组来进行表示. 我们在堆这个结构中用过这种结构. 败者树比胜者树多一个节点, 也就是数组表示的第0位. 

这个是败者树, 这个树的结构会比较奇怪, 非叶节点存的数两个子树中"胜者的败者". 这就使得我们进行树重构的时候我们只要进行和父节点的比较就好了. 重构的策略在上文已经提到. 
在树中我们可以看到两类节点, 一类是方块表示的缓冲区, 存的是每一个归并队列第一个值的方块节点, 还有就是记录着队列编号的圆形节点, 这个节点表示了是当前哪个队列的节点在这个树里面. 我们相信这是一种节省空间的方式. 
我们在败者树中设计两个数组, 一个是树的数组, 一个是缓冲区的数组, 两个数组的大小都和要归并的队列数量一样. 败者树的构造是基于胜者树去做的, 首先先使用buffer里面的值构造出胜者树, 然后我们将胜者树的根节点复制到根节点的父节点上面, 然后我们自上到下进行败者树改造, 从根节点开始, 将父节点两个子节点中和父节点不一样的节点复制到父节点上. 
缓冲区存的是真正的键值对. 非叶节点里面存的是键值对在缓冲区数组的索引号. 为了方便实现, 我们必须做一个东西来保证父节点可以被找到. 我们可以认为这个缓冲区是接在树的数组后面的, 这样子就好办很多. 我们可以实现一个向父节点或者向儿子节点移动的算法, 因为树的最后一层非叶节点指向的节点在另外一个数组中. 更简单地说, 我们可以认为这个非叶节点数组后面的索引就是一段连续数字, 比如说上面这个例子, 数组的值就是:[3, 1, 0, 2, 4]其实后面还隐藏了[0,1,2,3,4], 总共就是[3,1,0,2,4,0,1,2,3,4]. 所以说我们要做的就是当我们发现, 比如4的后继索引应该是8, 但是8明显已经超过了范围, 所以我们就让8-非叶节点数组大小就可以了, 这样子不用查就可以直接算出3, 所以说为什么我们申请数组的时候后面"隐藏"的东西我们没有放到数组里, 就是因为后面的值很规律, 使得这是我们可以算出来的. 
我们要记住一个非常精辟的操作:
int LostTree::getBufferIndex(int treeIndex) {

if (treeIndex <= mergeSize - 1) {
return indexLeaf[treeIndex];
} else {
//这是叶节点, 没有存在于非叶节点数组中, 这里推算
return treeIndex - mergeSize;
}
}
缓冲区和非叶节点在两个数组, 但是这个函数统一了逻辑, 我们可以找到任何叶节点, 包括非叶节点的缓冲区索引, 这个索引我们既可以取里面的key去做比较, 也可以单纯比较索引的值来看两个树节点对应的key是不是用一个. 
弹出旧的节点然后插入新的节点. 我们申请两个临时变量, 都是索引. 一个是Buffer索引, 一个是非叶索引. buffer索引指的是不断向上比较的key, 非叶索引指向的是被比较的非叶节点. buffer索引指向的key是不会出现的非叶节点中的. 如果我们发现要往上爬的节点优先级比被比较的节点低, 那么就把非叶索引给buffer索引, 让父节点继续向上走. 这个过程有点像毛毛虫在移动. 
在子节点没有祖先节点大. 那么我们就要把buffer索引放到放到树节点中, 然后把buffer索引指向树节点中存的以前的索引(所以我们需要使用一个变量把树节点中以前的索引存下来). 然后将被比较的树非叶节点索引向上移动. 
对于重构的边界条件的设定也要处以, 我们的重构在根节点处就要特殊处理, 根节点的父节点更要单独处理. 
ALV树
这也是一种平衡树的实践, 首先是一种2叉树, 和B+树的平衡方式不同的是, ALV树在每个节点上存储一个叫做"平衡因子"的变量来控制平衡. ALV树要求左子树和右子树的差不多高, 相差不能超过2. 而B树的所有子树是完全平衡的, 这就是不同. 
ALV树使用我们在红黑树中常见的旋转操作, 用来在插入和删除中平衡, 而B树和B+树的插入过程使用的是拆分操作, 删除过程用的是合并和旋转操作. 从这一点来看, ALV树会好实现很多. 毕竟只涉及旋转. 
当我们将一个节点插入到ALV树中的时候(插入的过程就是二叉查找树), 我们要不断检查父节点, 看看有没有出现不平衡的情况. 实际上我们也可以使用一个递归insert, 在insert之后解决不平衡的问题. 
一般是因为出现4中情况:
1.对A节点的左儿子的左子树执行一次插入操作
2.对A节点的左儿子的右子树执行一次插入操作
3.对A节点的右儿子的左子树执行一次插入操作
4.对A节点的右儿子的右子树执行一次插入操作
其中, 1, 4我们归成一类, 称作"左左"和"右右". 这类情况是比较好处理的, 我们对a做一次左旋或者右旋就好了. 右旋就是加大右侧的高度, 左旋就是加大左侧的高度. 然后我们随机应变就好了. 
另外, 2, 3又是一类, "左右"和"右左". 这个需要两次旋转, 对于"左右"来说, 需要在左子树上面执行一次左旋, 变成"左左", 然后按照"左左"来处理. 
值的一提的是, 虽然在前文给的链接中, 我们是不断检查插入位置为父节点一路往上, 看看有没有出现不平衡的, 但是实际上我认为出现不平衡的节点只有可能在爷爷节点和或者曾爷爷节点上, 这是我个人的意见. 但是为了以防万一, 还是一路向上进行检查吧. 
还有一点, 插入过程写成对子树的插入, 然后递归插入, 每个插入之后进行一次高度的检查, 会比较不错. 
ALV树的节点删除的思路和节点添加的思路差不多, 节点删除逻辑的前半部分和二叉查找树删除方式是一样的, 我们首先找到这个节点, 如果这个节点是叶子节点, 那就直接删除, 如果是有两个子树的节点, 那就用后继节点替换当前节点, 并且递归删除后继节点, 如果只有一个子树, 那就把这个子树拼接上来. 删除一个节点之后, 我们需要重新更新这个节点之上的所有的节点的height. 所以我们也使用一个递归来进行删除操作. 我们递归的子单元就是删除子树的特定元素. 
ALV树的实现主要是高度更新和重构的问题. 而ALV树的重构主要是要认清是LL型还是LR型, 还是RL与RR. 主要的逻辑实际上是比较简单的. 首先我们看哪两边的高度相差2, 这样子第一个字母就定下来了. 接下来我们去看第一个字母所代表的子树, 看看这个子树的左右高度哪一个高就可以定下第二个字母了. 

##  最小最大堆
最小最大堆是一种实现双端优先队列的数据结构, 他是一种二叉完全树, 也是一种堆结构. 网上关于这方面的资料很少, 在文库中有一个:最小最大堆
这是一种一层一层的数据结构, 根节点所在的是"最小层", 往下走依次是"最大层", "最小层". 在最大层的节点要保证在以他为根的子树中, 他是最大的;在最小层的节点要保证在以他为根的子树中, 他是最小的. 

大概是这样的一个结构. 
那我们如何判断是最小最大堆呢, 实际上这个是可以用log2算的. 我们可以给一个节点的索引不断除2来判断出某一个节点是在第几层的, 从而也就很好推断出到底是最大层还是最小层. 所以我们就用堆的索引进行log2运算, 偶数层就是最小层, 奇数层就是最大层. 
但是C++中的math库并没有log2的计算, 只有log10的计算, 我们使用换底公式就好了. log2 N = log10 N / log10 2. 
节点的添加
最小最大堆中节点的添加还是比较容易的. 因为堆是用数组实现的, 和普通的堆插入一样, 我们可以将先放在数组最后, 也就是15的左儿子的位置. 然后我们和父节点做一次比较, 如果比父节点大, 说明这个新加入的节点是不可能待在最小层中了, 我们只要和上面最大层的祖先比较就好了, 因为如果这个节点往堆上面爬, 一定有节点比他小, 所以不可能待在最小层了. 
反之, 如果比父节点小, 我们只要和上面最小层的祖先比较就好了. 
我们比较之后怎么处理?处理方法和普通堆的处理是一样的, 不断向上遍历, 把优先级高的节点换下来. 最小层就到根节点, 最大层就到根节点的子节点, 遍历完毕. 
我们为上面一个堆插入10, 来举一个生动形象的例子. 

10和15比我们发现只要和最小层比就好了, 然后不断向上比, 不断向上跳. 最后就换到根节点了. 
删除节点
节点删除情况上会复杂一下, 我们一般删除的是最大和最小节点. 我们以删除最小节点为例. 
我们是怎么处理的呢, 传统的删除方法就是把最后一个节点放到第一个, 然后自上而下递归重构. 但是最小最大树就不能这么做了. 
我们首先把根节点删除, 然后我们进行重构(对于最小值删除):
堆的最小节点没了, 那么次小节点肯定在最小节点的儿子和孙子节点上. 所以我们就把, 次小节点换到根节点上, 然后次小节点那里就空出来一个位置了, 这个位置是要填满的, 要怎么填就是一个问题了. 
我们首先把对数组的最后一个节点暂时拿出来, 用来填充到之后的空位中. 整个过程是这样的, 我们在空的根的子女和孙子女节点中找到这个子树的次小值, 这个值未必是真正次小的, 因为最后一个节点被拿出来了, 所以我们找到的这个次小值不见得是"真的次小值", 因为对数组最后一个节点可能比他还小, 这个时候我们把我们事先拿出的最后一个节点填到根节点上就好了. 
如果堆数组最后一个节点不比我们找到的"次小值"要小的话, 那么这又有几种情况, 如果这次小值是子树根节点的子女节点的话, 我们直接把次小值放到根节点上, 然后把堆数组最后一位放到次小值的节点原来的位置上. 
为了方便讨论, 我们把堆数组最后一位的节点叫做"补位节点". 如果我们找到的次小值是真的"次小值", 并且这个次小值是在子树根节点的孙子女节点上, 这个次小值上到根节点上, 但是这个补位节点不能盲目地放到次小值原来所在的位置, 我们知道这个时候次小值永远都是在最小层上的, 那么这个时候次小值的父节点一定在最大层上, 如果我们盲目地将补位节点放到次小值所在的子树中, 可能会发生补位节点比次小值的父节点要大的情况, 这就不满足最小最大堆的性质了, 所以我们这里分类讨论, 如果补位节点比父节点小, 那么我们直接在次小值节点上递归就好了. 如果补位节点比较大, 那就把补位节点和父节点换一下, 然后递归去填补次小值子树的空根, 总之只要次小值在根节点的孙子女辈, 那都是要递归的. 
我们举一个例子:

删除最小值, 75单独拿出来, 作为补位节点. 

然后找到次小值12, 75比80小, 所以不用替换补位节点. 然后在12原来的位置上进行递归, 找到次小值15, 15是12原本节点儿子节点, 15换到原本12的位置, 然后将补位节点进行补位就好了. 

我们对最小最大堆也进行了实现. 
这里我们要注意一个要警惕的问题, 那就是如果空着的节点下面没有子树了怎么办, 这个是很常见的情况, 方式就是我们直接把补位节点放到根节点上就好了. 这个是一个前文没有讲到的情况, 那就是"如果没有次小节点怎么办". 

##  双端堆
双端堆是又一种双端优先队列的实现, 实现方式的难度简单很多. 双端堆是一种根节点没有值的堆结构. 

也就是在堆数组的表现中, 我们的1索引的值是空的. 并且节点之间存在一种对应关系, 对于一个最小堆中的节点来说, 这个节点的"对应节点"就是最大堆中同样位置的节点. 比如最小堆中的节点15对应的节点就是20. 当另一个堆中对应元素的位置为空的时候, 那么对应节点就是那个空位置的父节点. 也就是说19对应的是25. 
双端堆的插入
双端堆的插入是比较简单的, 我们一般插在整个双端堆的最后一个位置, 也就是放在20边上. 然后我们和对应节点进行比较, 正常来说双端堆的最大部分的值一定是大于最小堆部分对应位置的值, 所以我们要进行适当的交换, 让最大堆中对应位置的值小于最小堆. 然后我们让新加入的值在堆中进行上升重构操作就好了. 
双端堆的删除
双端堆的删除稍微复杂一些, 我们要么删除最大值, 要么删除最小值, 删除之后还是涉及堆的重构, 我们删除根节点之后, 我们的根节点到叶节点中的与兄弟相比比较小的节点依次上升最后会在叶节点中空出一个位置, 然后我们将双端堆数组中最后一个元素的值补到这个空的叶节点上. 

##  插入排序
插入排序的思路就像我们按顺序整理一套扑克牌一样. 我们以从小到大排序为例, 我们从第一位开始将一个牌从当前位置抽出, 然后让这张牌与之前的牌作比较. 比这张牌大的牌都依次往前移一位, 直到之前的牌比抽出的牌小. 这样子就会空出来一个位置, 将抽出的牌放到这个位置就好了. 插入排序的特点就是我们抽出的牌的前面的牌都是已经排好序的. 我们要做的实际上就是不断让一个新的值插入到一个已经排好序的序列中. 
伪代码:
//插入排序, 我们假设为从小到大排序
//形参是输入和数组的长度
insert_sort(A[],len)
for i <- 0 to len
do 
//首先我们获取当前位置的元素
tmp <- A[i]
//这里激活一个嵌套循环, 让获取的元素和之前的元素做比较
for j <- i to 0
do
if A[j] >= tmp
then
A[j+1] = A[j]
else
A[j] = tmp
break;
这个是一个时间复杂度为n^2的算法. 

##  选择排序
选择排序是一种看起来更笨拙的排序方式, 时间复杂度也是n^2. 他的总体原理是一开始遍历整个数组, 将最小的放在数组的第一个位置. 然后遍历数组的剩下部分, 将最小的放在数组的第二个位置, 直到最后所有的元素都各得其所. 

##  合并(归并)排序
合并排序算法思路
这是一种比较快的排序算法, 时间复杂度达到了nlogn. 他的思路就是将整个要排序的集合不断拆分, 然后再两两合并, 在合并的过程中进行排序操作. 归并排序是一个递归算法, 要合并的两个子列都是已经经过合并排好序的. 所以这个算法的核心就是对已经排好序的两个数组进行合并, 合并之后依旧是排好序的数组
数组合并伪代码:
//输入为两个数组和两个数组的大小, 从小到大的排序
merge(A[],B[],m,n){
i <- 0
j <- 0
q <- 0
result[m+n]
while i < m && j < n
do
if A[i] > B[j]
then
result[q] = B[j]
j++
q++
else
result[q] = A[i]
i++
q++
//两个数组中有其中一个数组还会剩余元素, 我们将其拷到要返回的目标数组中
for i1 <- i to m
do
result[q] = A[i1]
q++

for j1 <- j to n
do
result[q] = A[j1]
q++
}
以上就是归并排序的核心部分, 但是实际上外部还需要一个函数来进行驱动
//归并排序, 形参为要排序的乱序数组
merge_sort(A[],len){
//将数组进行拆分
mid = len/2
A1[mid]
A2[len-mid-1]
for i <- 0 to mid
do
A1[i] = A[i]
for j <- 0 to len-mid-1
do 
A2[j] = A[mid+1+j]
merge_sort(A1[] , mid)
merge_sort(A2[] , len-mid-1)
A[] = merge(A1[] , A2[] , mid , len-mid-1)
}
改造归并排序求逆序对个数
这个是一个到腾讯的笔试中出的一个考题, 可以通过修改归并排序来获得一个数组中逆序对的个数. 我们的主要的思路如下, 依旧是一个递归的思路, 但是我们需要在递归的过程中加入一个计数的步骤. 
假设A[]数组, 前后分为A1[m]和A2[n]两个部分. A1中的元素我们在逻辑上不需要特殊处理, 然后A2中的元素我们在进行合并的时候要特殊处理. 比如, A2中的第x个元素合并完之后就在A中的y位置. 这个时候我们就知道这个元素对应的逆序就是, m-(y-x). y-x算出的是A1中比这个元素小的元素, 而m-(y-x)就是A1中比这个元素大的元素, 所以这样子就可以算出与这个元素相关的逆序数. 通过不断的遍历和向上递归, 整个数组的逆序数就算出来了. 

##  冒泡排序
这是一种乍一看和插入排序很像的排序方式, 但是实际上有着本质上的不同. 我们以从小到大排列为例, 我们首先要注意冒泡的方向. 将从小到大排列中我们可以从右边开始, 将小的元素向左冒泡, 也可以从左边开始将打的元素向右冒泡. 每一轮冒泡都可以讲当前子列最大或者最小值挪到数组的两端. 
//冒泡即是将打的值从左侧
bubble_sort(A[] , len)
//冒泡的轮数
for i <- 0 to len
do
//每一轮要冒泡的元素
for j <- 0 to len - i -1
do
if(A[j]>A[j+1])
tmp = A[j+1]
A[j+1] = A[j]
A[j] = tmp

##  霍纳规则的多项式运算
这个就是秦九昭算法, 将多项式的计算变成了一个每一步都逻辑相同的递归. 对于多项式来说我们不断提出前n项共有的X来进行化简. 直到最后在每一个都可以进行ax+b的递归. 
堆排序
堆排序是一种精妙的设计. 堆是一种完全二叉树, 他除了最后一层的每一层都是满的, 最后一层也优先放满树的左边. 这样子就可以造成一个非常好的效果就是, 如果我们使用二叉树的数组表示来表示这个堆, 那么这个数组的有内容的前半部分是完全满的, 对于已经占用的空间来说, 完全没有任何空间浪费. 堆有一个很不错的性质就是在表达堆的数组中, 假设一共占用了n个位置, 那么n/2+1开始都是这个堆的叶子节点. 
最大堆与最小堆是我们用来分别进行从大到小与从小到大排序的工具. 以最大堆为例, 一个节点的值永远比他的两个儿子节点要打, 堆的根节点以及堆中所有子树的根节点的值都是在他那个子树里最大的. 这里就涉及一个堆结构的保持问题, 如果我们在一个子树的根部换上一个比儿子节点小的值, 那么我们就需要进行堆的递归重构. 重构的过程就是让这个子树的根节点和他的两个儿子相比较(这两个儿子都是所在的子树都是一个最大堆), 如果根节点不是这两个儿子中最大的, 那么就和这两个儿子中值比较大的那个儿子交换. 然后继续递归那个值发生交换的子树最大堆. 直到已经没有值可以交换为止, 这样子堆就完成了重构, 并保持了原有的性质. 
对于一个杂乱无章的数组来说, 堆排序分为两个部分, 一个是堆的构造, 一个是堆排序. 堆是一个自下而上构造的过程, 我们从数组的中间位置开始向前进行子堆重构, 直到整个堆的所有内容都进行了, 整个堆形成了最大堆, 这个时候根节点就是最大值, 我们将根节点和数组中的最后一个有效值进行交换, 再让数组剩下的部分再进行一次堆重构. 然后不断把数组剩下的部分进行整个堆的重构, 这样子最后就可以得到一个排好序的数组. 下面是伪代码. 
//这里是子堆重构的函数
//输入参数第一个是堆的数组表示, n是要重构的子堆的根节点. 而这个根节点的两个儿子都是各自最大堆的根节点
//这个函数有一个假设, 就是这个根节点的两个左右子树都是已经构造好的子堆
childRebuild(A[],n)
//我们首先要看的就是A[]与左右子节点的比较, 选出一个最大值和子树的根做交换
//之后的这几个if就是在比较三个值之间的最大值
//首先和左节点做比较
if A[n] > A[n*2]
then
large <- n
else
large <- n*2

if A[large] < A[n*2 +1]
then
large <- n*2 +1

//选完之后我们就可以进行交换操作了, 如果不需要交换, 重构结束
if large != n
then
tmp <- A[large]
A[large] <- A[n]
A[n] <- tmp
//继续在子堆上递归
childRebuild(A[],large)
使用这个函数也可以进行堆合并的操作. 主要的操作就是使用一个叶子节点来放在两个堆的根上. 然后执行一次从跟开始的堆重构工作. 
我们通过这个根节点的两个儿子都是各自最大堆的根节点的特殊子堆的重构函数, 我们通过自下而上的推构造方式进行无序数组的堆构造. 
//输入是无序数组和这个数组的长度, 我们要把这个数组的内容构造成堆
heap_build(A[] , len)
//我们堆的最低一层非叶子节点开始往回遍历数组, 重构
for j <- len/2 downto 1
do
//因为这个函数有个假设, 子树必须是一个堆, 所以这个乱序数组的重构就是从下到上的
childRebuild(A[] , j)
这样子我们就完成了堆的构造工作. 下面我们就可以进行堆排序了. 为了节省空间, 我们就把排好序的部分放在这个堆数组中, 也就是放在堆数组的最后一个. 通过让每一次从堆中选出的最大值和整个数组的最后一个值交换就好, 然后我们对堆的剩下部分不断进行重构, 最后就可以得到一个排好序的序列了
//利用之前两个函数, 进行堆排序核心算法
//输入为要排序的数组和数组的长度len, 数组的第一位是空白的, 我们这个len是数组不空白的部分
heap_sort(A[] , len)

//乱序的时候进行大规模重构
heap_build(A[],len)

//每一次我们选出来一个值, 所以重构的过程需要反复len-1次
for j <- 1 to len-1
do
//让最大值和数组最后一位交换(节省空间), 然后重构
//交换
tmp <- A[1]
A[1] <- A[len - 1]
A[len-1] <- tmp
//我们将堆的有效长度-1, 让下次只重构剩下的部分
len--;
//因为左右子树都是最小堆, 所以只要进行根节点的重构就好
childRebuild(A[],1) 
//我们就这样通过最大堆来构成了一个从小到大排列的序列
其实我们也可以修改交换的位置来用最小堆实现这个过程. 

##  最大优先队列
这是一种与与堆排序有着异曲同工的. 我们知道在堆排序中, 节点在堆中只有可能下降, 这个过程叫做堆下降. 在最大(最小)优先队列中, 算法的核心在于"堆上升". 在最大优先队列中, 在堆中的一个元素的优先级只有可能突然上升, 这个元素就有可能出现堆上升的操作. 
此外我们还可以基于堆上升的操作完整最大优先队列的插入操作. 只要就是将一个元素插入在堆数组的尾部, 并且对这个元素执行堆上升操作. 从而维持堆的性质. 
而在堆的根部的元素就是优先级最高的. 我们有时候需要取出最大值. 最大值取出之后我们还需要进行堆的重构, 重构的过程和堆排序很像, 我们把数组最后的值放到根节点处, 然后进行重构. 重构就是使用之前的递归"堆下降"工作. 
现在我们实现一下最大优先队列. 使用伪代码. 
//导出最大优先队列的最优先元素, 也就是A[1], 然后我们就要使用重构堆, 重构的方法就是把数组最后一个节点放在根节点处, 然后重构. 这个是最大优先队列功能的核心. 导出的永远都是优先级最高的节点. 
//导出优先级最高的节点
extra_max(A[],len)
tmp = A[1]
print tmp
A[1] = A[len]
childRebuild(A[],1)
节点上升函数, 可以应对某一个节点优先级增大的情况. 并且是在堆中加入节点的重要部分. 
//实现节点上升的函数
//三个形参, 第一个是堆的数组表现, 我们对A的要求就是A已经要是一个符合最大堆规范的对, 第二个要修改的这个堆中的节点在数组中的位置, 第三个是要将这个节点修改成的值, 这个值只能变大不能变小, 这个是最大优先队列的一个原则. 
increasing_key(A[],i,key)
//首先看看输入值是不是合法, 对应堆节点的值是不是变大了
if(A[i] > key)
then
//输入值没有变大, 输入违法
return;

A[i] <- key
//然后我们进行递归的堆上升操作, 让新改变的节点向上浮
while i > 1 && A[parent(i)] < A[i]
do
//我们执行交换操作
tmp <- A[i]
A[i] <- A[parent(i)]
A[parent(i)] <- tmp
i <- parent(i)
然后就是节点添加的函数, 我们将节点放在最后, 然后对这个节点进行堆上升操作. 
insert_item(A[],newEle)
A[++len] <- newEle
increasing_key(A[],len,newEle)
我们可以使用堆的插入操作来进行堆的构建, 实际上我认为对于堆的插入操作, 我们唯一可以做的就是把一个一个新的值放在堆数组的最后一位, 然后采用"堆上升"操作对堆进行重构. 
除了二叉堆, 我们还有D叉堆, 这种堆结构在每个节点都有更多的节点, 但是堆的高度会变小. 这种变化, 会对"堆下降"操作带来负担, 但是堆上升操作会快很多. 
我们这里总结一下堆, 我们发现我们的重构过程容易搞混. 这里我们要先说说从根部开始的重构, 我们在之前叙述的时候, 我们常说"堆上升, 堆下降". 堆上升是我觉得是一种"调整", 堆下降是一种"重构". 比如堆下降过程, 他保证的是下降节点的左右子树也同样是堆, 这个过程是在乱序数组推构建(自下而上的堆下降重构), 以及堆排序的时候叶节点换到跟节点的重构工作;而堆上升是在堆插入和堆中某一个节点的优先级变大, 也会进行节点的堆上升工作. 

##  快速排序
快速排序是一种最佳的排序算法. 虽然最坏运行情况很差 , 但是平均排序性能很好. 并且因为使用的是就近的空间, 所以并不需要额外的空间. 相比之下, 虽然归并排序也有不错的性能表现, 但是因为归并排序需要额外的空间需要, 所以快速排序是一种更好地选择. 
快速排序的特点就是想起来很简单, 但是实现起来就有不同的效果. 他的核心在于"桩"这个概念, 在每一个子列处理完之后, 我们要达到一个效果, (假设是从小到大排列), 我们要做的就是让比桩大的值都放在桩的右边, 比桩小的值都放在桩的左边. 然后将桩左边和右边的值分别递归, 进行子列的处理. 直到子列的大小只有1, 递归停止. 因为桩一般情况下都在两头, 最后桩的位置又非常重要, 我们要在最后将在数列中部符合要求的值和在头尾的桩进行交换, 而什么叫"符合要求"我们要根据"桩"在头部开始尾部, 以及这个队列最终是要从小到大还是从大到小排列有关. 
整个算法的设计如下. 除了指向我们需要快排的子列的首指针和尾指针, 我们还需要两个指针, 一个指针指向我们正在扫描的数组元素(初始化的时候指向0位置), 还有一个指针(如果是从小到大排列)大值与小值的边界(一开始放在子列(前边界索引-1)的位置). 
template<class T>
void part_quick_sort(T *inputArr, int start, int end);

template<class T>
void quick_sort(T *inputArr, int len) {
//这个是一个递归的算法
part_quick_sort(inputArr, 0, len - 1);
}

//这个部分是要递归的函数, 
template<class T>
void part_quick_sort(T *inputArr, int start, int end) {
//判定递归停止
if (start >= end ) {
//递归停止
return;
}

//我们需要初始化两个指针, 一个指针从头开始扫描
int i = start - 1;
//这个变量是桩, 桩在数组的最后
int pile = inputArr[end];
int tmp = 0;
for (int j = start; j <= end; ++j) {
//j这个索引从子列的头部开始扫描, 如果发现桩比数组小, 那么就让j当前指向的元素和i+1所在的元素交换, 并且i向前移动
//对于i这个索引来说, 我们要保证i是比桩小的, i+1是比桩大的. 
//我们要把比桩小的往前扔
if (inputArr[j] <= pile) {
tmp = inputArr[j];
inputArr[j] = inputArr[i + 1];
inputArr[i + 1] = tmp;
i++;
}
}
//等循环结束之后, i所在的位置就是桩经过换到中间之后的位置. 现在我们拆分数组, 进行递归
part_quick_sort(inputArr, 0, i - 1);
part_quick_sort(inputArr, i + 1, end);
}
因为快速排序拥有比较好的平均性能, 所以我们必须为快速排序加入一些随机化的因素来体现其平均性能的优势. 所以我们的"桩"(在算法导论中叫做"主元元素")是随机选取的, 我么通过摇一个随机数在要处理的子列中选出一个随机的元素和尾部的元素做一次交换, 然后再用尾部的元素做桩, 以此达到了加入随机因素的结果. 

##  非比较排序
我们之前用的全部都是基于比较的排序, 现在我们可以看到一些不基于比较的排序. 对于基于比较的排序, 我们可以使用树状图的方式来判定这种排序的时间复杂度. 非比较排序就不适合这种方式了. 
总得来说非比较排序的时间复杂度甚至还要更小. 
##  计数排序
计数排序是一种用空间换时间的典型案例. 计数排序的主要思路就是我们将一个数列中比每一个数小或者相等的数的数目记录下来. 比如说, 在我们需要排列的数组中有一个数是5, 然后在这个数组中我们发现比5小的数有3个, 那么我们就要记录:"比5小的数有3个", 体现在编程中, 就是我们在一个临时数组的第5个位置记录一个数字"3". 然后我们最后直接在输出数组的第4个位置填一个5就可以了, 因为5比三个数字大嘛. 
然后这又有新的问题, 那就是如果有很多个相同的数字怎么办. 比如我们发现"5"一共有多个, 那么我们会在向输出数组添加一个5的时候, 在计数的临时数组中我们就要把5对应的值-1. 
我们怎么输出?在整理完临时的计数数组的时候, 我们要依照输入数组的内容查询临时数组, 并且将查到的内容进行输出数组的构建, 直到输入数组被完全遍历. 
总之, 计数排序我们一共涉及3个数组, 输入, 输出, 临时计数. 下面我们进行C++语言的实现. 
这里先提及一个实现问题, 就是指针的引用问题, 为了保证我们的指针的指向在函数之内可以进行真正意义上的改变. 指针的引用要注意"*"与"&"的顺序:
1.func(int *&p)
在编程中我们还遇到一个问题, 就是栈区数组变量与指针变量实际上是不一样的. 我们要注意区分. 如果是要传数组的引用, 那就是:
1.func(int &p[数组大小])
我们可以看到指针是指针, 数组变量是数组变量, 虽然他们有一定的一致性, 并且数组变量还可以赋给指针. 使得新的指针就是一个指向栈区的指针. 但是数组变量是不可以改变的. 数组变量不可以改变用其他数组变量来赋值, 也不可以进行引用传参. 根据网上的说法, 数组变量并不是真正意义上的变量, 所以在内存上实际上没有这个数组变量的空间, 在程序运行的时候作为立即数存在, 也就没有修改和引用的说法. 
所以说数据变量的存在和指针之间很容易产生混淆和误解, 对于数组, 我们尽可能使用new+指针指向的方式来声明. 数组变量的局限性比较大. 
这里我们好好讲讲数组变量和指针. 他们有很大的相似, 也有不少的区别, 首先数组变量是可以赋值给指针的, 但是指针是不可以赋值给数组变量的, 换句话说, 数组变量是一种常量, 是不能被赋值的. 
我们看一下数组和指针在函数形参下的表现:
1.void PrintValues(const int ia[10])
首先我们看如果数组是形参的话, 我们要用这样的形式, 并且这里声明了大小, 实际上这里, 这个数组的形参实际上会被编译器改造为一个指针, 所以实际上和形参是const int* a没有区别, 那个中括号中的10是没啥用的. 此外, 我们还可以利用数组可以给指针赋值的特性, 使用指针来为数组传参. 
1.void PrintValues(const int *ia,int size)
此外我们可以传数组的引用. 这时候的那个2是有明确意义的, 不能省略的. 
1.void PrintValues( int (&ia)[2])
C++ 基础知识一 ——通过引用传递数组
计数排序中我们还需要注意一点, 就是输入数组和输出数组的大小和索引我们要注意, 输入数组是从0索引开始使用的, 输出数组也是这样, 但是临时数组在计数的时候是从1开始算的, 也就是计数为1的算到输出数组的0索引里面. 
void count_sort(int* &inputArr, int len) {
//首先我们设定一个临时数组, 这个临时数组的大小和输入数组中所有元素的最大值有关系
//我们遍历输入数组, 然后我们找出最大值
int large = -1;
for (int i = 0; i < len; ++i) {
if (large < inputArr[i]) {
large = inputArr[i];
}
}
//然后根据这个最大值创造一个数组, 这里我们要注意这个数组的大小
//我们要让输入数组的最大值与临时数组的最大索引保持一致
int *temp_count = new int[large + 1];
//这个计数数组的初始化
for (int j = 0; j <= large; ++j) {
temp_count[j] = 0;
}
//然后我们进行计数
for (int k = 0; k < len; ++k) {
temp_count[inputArr[k]]++;
}

// for (int j = 0; j <= large ; ++j) {
// cout << temp_count[j] << " , ";
// }
// cout << endl;
//然后我们进一步处理临时计数数组, 让数组第n位记录输入数组中小于等于n的元素个数
//处理方法就是不断从临时数组的第一位开始不断让相邻的两个数相加
for (int l = 1; l <= large; ++l) {
temp_count[l] = temp_count[l] + temp_count[l - 1];
}

// for (int j = 0; j <= large ; ++j) {
// cout << temp_count[j] << " , ";
// }
// cout << endl;

//建立输出数组
int *output = new int[len];

//然后我们遍历输入数组, 为输入数组的每一个元素在输出数组中找到一个新的位置
for (int m = 0; m < len; ++m) {
//通过查看临时计数数组, 给输入元素找在输出元素的位置
output[temp_count[inputArr[m]]-1] = inputArr[m];
//因为可能有重复元素, 所以我们要在排序之后将计数值-1
temp_count[inputArr[m]]--;
}
delete inputArr;
inputArr = output;
}
计数排序的主要的应用场景是在排序的数比较密集的, 不太密集的话会造成空间的浪费. 

##  基数排序
这也是一种非比较排序, 基数排序和小学生做数字比较大小思路很像. 就是一位一位一位比. 
基数排序是一种从最小位到最大位不断比较的排序, 这个和我们自然的认识可不一样, 我们对于每一位的排序必须是稳定排序, 也就是说我们在进行高位的排序的时候如果高位一样, 就一定要保证低位的顺序. 
稳定排序与不稳定排序
首先, 排序算法的稳定性大家应该都知道, 通俗地讲就是能保证排序前2个相等的数其在序列的前后位置顺序和排序后它们两个的前后位置顺序相同. 在简单形式化一下, 如果Ai = Aj, Ai原来在位置前, 排序后Ai还是要在Aj位置前. 
其次, 说一下稳定性的好处. 排序算法如果是稳定的, 那么从一个键上排序, 然后再从另一个键上排序, 第一个键排序的结果可以为第二个键排序所用. 基数排序就是这样, 先按低位排序, 逐次按高位排序, 低位相同的元素其顺序再高位也相同时是不会改变的. 另外, 如果排序算法稳定, 对基于比较的排序算法而言, 元素交换的次数可能会少一些. 
下面是这个算法的伪代码:
//下面进行整数的计数排序从低位到高位进行排序, 对不同位数进行稳定排序
radix_sort(A[] , len)
//我们进行循环, 两层循环, 一层是遍历数组, 一层是遍历数字的每一位, 从低到高
//首先进行位数的遍历
for i
do
//经过改造的插入排序, 每次都对其中一位进行插入排序
insert_sort(A , len , i)

##  桶排序
这个是一个感觉有点像哈希的排序, 只是排序的时候我们要保证要进行排列的数组的每一位在进行处理之后, 产生的新的数字不改变其在数列中的排序. 产生的这个数字就是桶的编号, 而桶就是一个链表结构, 在链表中的元素就是经过桶分类的数列元素, 在插入桶的过程中, 他依然经过了排序. 使得在链表中的元素也是按照某种方式排列的. 并且在高位的桶中的每一个元素也"大于"在低位桶中的每一个元素. 
桶排序在元素分布均匀的数列排序中表现出色, 时间复杂度为n. 
顺序统计量的选择问题
顺序统计量就是数列中第n大的数, 这个数可以是最大值, 也可以是最小值, 也可以是中位数, 顺序统计量的选择我们可以排序之后直接选, 也可以使用一些时间复杂度为n的算法. 
找出最大值和最小值
我们找到最大值和最小值的算法其实就是我们常用的算法. 总体的思路就是设定一个变量就是min活着max, 然后遍历输入数组, 数组中的每一个元素都要和min活着max比较, 最后的效果就是让max或者min存着已比较元素中最大或者最小的那个元素. 
get_min(A[] , len)
for j <- 0 upto len
do
if(min -> A[j])
then
min <- A[j]
这个的时间复杂度是n. 一共进行了n次比较
如果我们需要同时找到最大值和最小值, 那就是2n吗, 实际上有一种只需要3n/2次比较就可以了. 
get_min_and_max(A[] , len)
for j <- 0 upto len j <- j+2
do
if A[j] > A[j+1]
then
if max < A[j]
then
max <- A[j]

if min > A[j+1]
then
min <- A[j+1]
else
if max < A[j+1]
then
max <- A[j+1]
if min > A[j]
then
min <- A[j]
我们在算法导论中还发现一个问题, 在题目中有一个问题:"我们如何才能找到一个数列中的最小或者第二小的值", 其实最诡异的就是题目还要求进行n+lgn-2次比较. 
我们发现使用树状比较可以创造出满足要求的东西, 我们举一个例子. 

我们使用的方式主要是树状比较排序. 对于数的每一层, 我们两两分组进行比较, 直到只剩下一个根节点, 这个就是最大值, 一共需要n-1次排序. 因为每一层的内容我们需要使用一个数组进行保留. 然后我我们做的就是将和最小元素比较过的元素单独拿出来进行一个次比较, 找出这些元素中的最小值, 比较次数为lgn-1次. 
随机选择排序—找出第n小的元素
这个是一个比找最大值和最小值都要复杂的算法, 整体的思路复用了快速排序算法的内容. 我们知道快速排序的平均时间复杂度非常小, 所以我们要在当中加入随机化因素. 
现在说说随机选择排序的算法思路. 这个东西与快速排序有异曲同工之妙, 或者说他就是一个进行了一半的快速排序, 是一个会提前结束的"快速排序". 我么知道进行快速排序的一次递归之后, 整个数组会被分成3个部分. 一个是桩变量, 一个是小于桩变量的数组, 一个是大于桩变量的数组. 因为小于桩变量的数组和大于桩变量的数组大小我们都是知道的. 假设桩在数组中第i个位置, 我们可以证明, 桩是第i+1小的数. 假设我们要找的是第j小的数, 如果j==i+1, 那么就说明桩变量就是我们想要的. 如果我们发现j\i+1, 那么我们就要在大于桩变量的数组中找第j-i-1小的元素. 所以说这个也是一个递归函数, 而且与快速排序不同的是, 这个是单侧, 并且会提前停止的递归. 递归的条件只有一个, 那就是我们找到的桩在快速排序之后的索引, 如果这个索引的大小+1和我们要找的第j小的这个j相等, 那么就意味着我们找到的第j小的元素, 并且递归结束. 下面我们实际实现以下这个算法. 
//第一个形参的输入数组, 第二个形参为参与随机选择的数组的起始位置, 第三个为参与随机选择的数组结束位置
//第四个为我们要找的是当前范围第rank小的元素
//我们借助快速排序从小到大排序
template<class T>
T random_select_fun(T *inputArr, int start, int end, int rank) {
//我们确定一个递归结束条件, 这个if应该永远不会进入的
if (start > end) {
cout << "发生了错误" << endl;
return NULL;
}


//我们首先加入随机过程, 随机制定start和end之间的数为桩
//首先我们摇一个种子
srand(time(0));
//找出一个桩
int stake = rand() % (end - start + 1) + start;
int tmp = inputArr[end];
inputArr[end] = inputArr[stake];
inputArr[stake] = tmp;
stake = end;

//桩的数值大小
int stackNum = inputArr[stake];

//然后进行类似于快速排序的工作, 声明两个索引, 一个是放在数组的第一位一个是放在-1位
//数组的扫描索引
int j;
//比桩变量小的数组的最大索引, i+1就是桩, i+2就是比桩大的第一个数
int i = start - 1;

for (int j = start; j <= end; ++j) {
//遍历我们要进行扫描和处理的数组
if (inputArr[j] <= stackNum) {
//发现有比桩小的数组, 我们就把他们放到start和i(包括i)之间, 主要是使用交换的方式
//因为桩还没有换过来, 所以i+1就是比桩大的部分. 
i++;
tmp = inputArr[i];
inputArr[i] = inputArr[j];
inputArr[j] = tmp;
}
}

//最后i就是桩所在的位置
//我们看看这个桩是不是我们需要的
//这里要注意, 我们虽然发现桩是i, 但是实际上i索引所对应的排位应该是i-start+1
if (rank == i - start + 1) {
return inputArr[i];
}

//如果我们要的数的排序比i+1要小, 那么就要进行桩左部数组的递归
if (rank < i - start + 1) {
return random_select_fun(inputArr, start, i - 1, rank);
}

//如果我们要的数的排序比i+1要打, 那么就要进行右部的递归
//我们首先要知道比i小的数在这个部分一共有多少个, 也就是在i左面有多少个数, 我们让i和start重合, 取一个特殊值就知道有i-start个. 
//所以rank要减去一个i还要减去i左边的数rank - (i - start) - 1
if (rank > i - start + 1) {
//这里递归调用的形参要好好注意
return random_select_fun(inputArr, i + 1, end, rank - (i - start) - 1);
}
}


template<class T>
T random_select(T *inputArr, int len, int rank) {
return random_select_fun(inputArr, 0, len - 1, rank);
}
实现的难点就是关于桩在当前范围的数组中的排序的计算, 要考虑随机选择的起始位置, 以及递归调用的时候rank这个形参的计算. 当+1-1算不清的时候我们可以适当取取特值. 
这个算法我们也可以找出最差时间复杂度可以达到n的方法, 主要就是在于桩的选取. 我们在上面是采用随机的方法找桩, 现在我们采用这样一种方式:
将数据5个分为一组, 最后不足5个的单独分为一组
我们对每一组进行插入排序, 获得其中位数
将所有的中位数再次进行插入排序, 再获取中位数
将此中位数为桩进行快速排序的一次迭代. 
判断桩的位置和我们需要元素的排序之间的关系, 选取左子数组或者右子数组进行递归. 
多叉树的实现与表示
我们实现过二叉树, 当时的实现有两种问题, 一种就是我们没有办法向父节点回溯, 还有一个问题就是没有办法接受任意个数的儿子. 所以我们我们同辈之前使用链表连接起来, 并且提供一个可以指向父节点的指针. 我们的节点结构和二叉树的节点结构非常像, 但是我们还是要进行一些修成和扩充, 但是总体的思路就是:父指针指向父节点, 右指针指向儿子节点, 左指针指向兄弟节点. 所以我们可以看到实际上任何多叉树都可以变成一个二叉树. 
这个类的实现首先我们需要注意的就是关于那个"儿子链表"的处理, 我们要处理好插入和删除节点的位置问题, 要走适当的距离. 并且链表还有边界问题. 

##  二叉查找树
二叉查找树是一种可以用来查找的二叉树. 我们可以在二叉查找树的一个节点中放一个值, 也可以放一个键值对(然后我们主要进行键的查找). 二叉查找树的主要的性质就是左子树的(所有值)大小要小于他的父节点, 而右子树(所有值)的大小要大于他的父节点. 整个查找的过程最坏的时间复杂度和树的高度是一样的. 我们可以使用中序遍历可以将二叉查找树中的内容可以按照顺序输出出来. 
二叉查找树首先的一些操作就是查找, 前趋, 以及后继节点的访问, 以及最大值最小值的访问. 查找的过程是很简单的, 我们使用一个指针, 从根节点开始遍历, 如果我们要找的元素比子树的根大, 那指针就往右子树方向走, 如果我们要找的元素比子树的根小, 那就往左子树走, 直到找到我们需要的节点就好了. 
子树极大值和极小值的查找也是比较简单的, 极大值我们就一路一直往右子树走, 直到不能再走了为止, 极小值我们就一路一直往左子树走. 
任意节点的前趋和后继节点是比较需要想想的, 对于一个从小到大排序的序列来说, 我们某一个节点的后继节点实际上就是只比这个节点大一个次序的节点. 总共有两种情况, 一种是当这个节点有右子树的时候, 那么后继节点就是此节点右子树的最左节点, 也就是右子树的最小值, 但是有一个比较特殊的情况, 那就是如果这个节点没有右子树怎么办, 那么这个时候就要在父节点下文章了, 我们需要不断寻找当前节点的祖先节点, 使用父指针一直往回走, 直到我们找到第一个祖先节点是某一个节点的左子树, 那么这个"某一个节点"就是后继节点, 也是中序遍历的下一个元素. 前继元素和后继元素的方式类似, 但是就是稍微"反过来一下就好". 我们首先关注左子树, 也就是去找左子树的最大节点, 或者说最右节点, 如果没有左子树怎么办, 我们使用的方法还是不断往当前节点的祖先节点遍历, 直到我们发现一个祖先节点是某一个节点的右子树根节点, 那么这个"某一个节点"就是我们所说前驱结点. 
很难记?其实我们只要记住一个例子, 画一画就好, 例子一共三层. 
8
4 12
2 6 10 14
1 3 5 7 9 11 13 15
我们只要知道最底层是一个奇数列, 就好了. 然后往上一直取中位数就好了. 
为什么我们那么在意后继节点查找呢, 因为这个在元素删除的时候要用到. 下面我们说一下元素的增加与删除. 二叉查找树的增加前半部分的搜索一样, 新的节点添加在树的叶子节点. 
那删除怎么办, 对于二叉搜索树的, 我们的删除过程还是比较简单的, 其实主要矛盾就是在子树的处理, 我们在删除的同时怎么维护整个整个树还保持原来性质, 首先如果我们删除的节点没有子树, 那就直接删掉就好了. 如果有一个子树, 那就把连接子树的那个指针给父节点就好了, 如果有两个子树, 我们要做的就是把这个节点的后继节点(右子树的最左叶子节点)替换过来, 用后继节点替换当前节点的位置. 
我们现在实现一个二叉查找树. 我们复用链表二叉树的代码, 但是为树节点加上一个父指针, 这个父指针是为了方便寻找父节点而设计的. 另外, 为了展示出树真正的查找方式, 实际上我们在二叉搜索树中存的都是键值对, 我们是通过键的值来进行数的构造, 但是最终的结果当然是获取值. 不过我们在这里加以简化, 我们没有键值对的结构, 只有"键", 为了实现搜索算法, 我们写一段函数来查看某一个树节点是不是存在. 
这里我们有两个算法是需要拐拐弯的, 一个是删除树节点, 还有一个是查找树节点的后继节点. 这两个都要依据子树的情况进行分配讨论. 
在删除节点有一个有意思的现象, 就是如果删除的节点有两个子树, 那么会用后继节点换上来, 但是实际上想一想, 也可以使用前驱结点换上来. 
在之前版本的实现中我们可以发现, 实际上我们对根节点的删除处理得很不好, 因为根节点的指针实际上我们是需要重定位的. 如果我们删除一个根节点, 并且这个根节点的只有一个子树, 那么根节点对象会被直接析构, root指针就需要重新定义了. 

##  红黑树
查找树的算法思路的细节很多, 算法的核心在于分类讨论. 
我们知道, 我们实现的二叉查找树有有严重的问题, 那就是如果树左右很不平衡, 可能就会导致树的高度不必要地大, 最后导致时间复杂度过于复杂. 
红黑树是一种可以保证基本平衡的树, 在红黑树中, 根节点和叶节点是黑的, 黑的节点的子节点可以是任何颜色的节点, 红节点的儿子必须全是黑节点. 因为每一个子树的每一条到叶节点的路径黑节点数量是一致的, 我们通过这样的设计就可以保证最长的深度和最小深度之间的差距不超过一倍. 
算法导论对于这个深度的控制进行了详细的数学证明. 其实我们对于最长深度和最小深度之间的差距为一倍可以有一个感性认识. 对于一个节点来时, 他的深度最小的时候就是子树全是黑节点的时候, 深度最大的时候黑节点和红节点相互交替的时候. 
为了保证优异的边界判断, 我们为红黑树设置NIL叶节点, 这个叶节点的值是空的, 所有没有指向的指针(根节点的父指针, "真"叶节点的左右子指针). 最后产生一个结构. 

红黑树的旋转
我们保证在树的修改之后红黑树的性质的不变形. 我们需要引入旋转操作. 旋转操作就是在不影响二叉查找树的前提下, 我们可以进行数的深度的平衡. 

注意x与y的子树在旋转之后的位置, 旋转的两个节点的子树的左右相对位置是没有变化的. 

就像是这样. 我们可以看到旋转之后19, 22, 20那条线的深度变小的, 11, 9这条线的深度变大了. 总体的平衡性就好很多. 并且不影响查找树的构成, 中序遍历的结果还是一样的. 并且旋转也有一个很好的地方, 就是旋转也不会改变红黑树的其中一个性质:从任意子树根节点到叶子节点的黑高度相同. 也就是说旋转不会对黑高度有影响. 
红黑树的重构
红黑树最难的就是插入和删除的过程, 这个过程是比较难的. 首先就是插入过程, 这个过程和基本的树的插入是一个样的, 但是要注意几点:首先是染成红色, 然后就是, 没有内容的左右指针要指向NIL节点. 
在插入数据的过程中会有两种情况被破坏, 一个是根节点需要是黑色, 因为我们插入的元素都会被染成红色, 这个很好解决, 空树插入的时候注意一下就好了. 还有一个会被破坏的条件就是红红节点不能相连会被破坏, 在红黑树中, 黑黑可以相连, 黑红可以相连, 但是红红是不可以相连的. 
我们一共要处理6中情况, 其中可以分为两组, 使用一张只有我能看懂的图来描述这个过程. 

对于插入之后性质保持额过程主要分为这么几个层次. 首先我们的主要矛盾就是插入的新节点和其父节点直接都是红色的矛盾. 关于根节点在重构过程中变为红色的问题我们直接修改根节点的颜色即可. 并且我们可以知道出现矛盾的新加入的叶子节点的爷爷节点肯定是黑色的, 父亲节点一定是红色. 
红黑树的重构是一种从叶子节点到根节点方向的重构. 在重构的过程中有三个比较关键的情况都要考虑. 主要的处理思路分为三步:看叔叔节点的颜色, 看新加入节点的位置, 看新加入节点的父节点的位置. 
首先就是新节点的叔叔节点是黑的还是红的, 如果新节点的叔叔节点的颜色是红色, 那么我们只要重新定制父辈和爷爷节点的颜色. 将它们的颜色翻转, 然后将指向新加入节点的"关键元素指针"指向爷爷节点就好. 

处理完这种情况之后我们还需要不断进行向上的重构. 
这里提到了关键元素指针, 这个指针一开始是指向新加入节点的, 我们的主要矛盾就是这个指针指向的元素的父元素是不是红色的问题, 如果是黑色, 问题就直接解决了, 整个红黑树就不需要重构了, 父元素是红色, 那就要进行重构操作. 这里还有一个问题, 就是当有两个节点都是红色, 我们要让"关键节点指针"必须指向子节点, 这个问题会在下面出现, 我们需要重新修改一下"关键节点指针"的位置. 
这里还有一个问题如果我们发现没有爷爷节点或者关键元素指针指向了根节点怎么办, 处理很简单, 这两种情况都是根节点是红色的情况, 我们只要把根节点变成黑色的就好了. 
然后就是叔叔节点也是黑色节点的情况, 这里我们单单改色是不够的, 要先进行旋转, 旋转的方式和关键节点和父节点的位置有关, 第一步就是"将关键节点和父节点放在同一侧", 方式就是将关键节点和其其父节点放在爷爷节点的同一层, 并且重新定位指针. 

这里的这个z就是关键节点我们和他的父节点做一次左旋转, 然后重新定位一下"关键节点指针". 当然, 如果父节点的右边的话, 我们就做右旋转就好了. 
当整理到同侧之后, 我们就让父节点和爷爷节点做适当的旋转让子孙三代平衡起来. 然后我们改了颜色, 让关键节点的父节点的变为黑色, 爷爷节点变为红色. 如果不变色, 黑深度就会不平衡. 

这里我们的重构就会完成, 因为我们发现关键节点的父节点已经是黑色了. 重构完成. 
所以说实际上我们需要处理三种情况(包含对称的还需要更多), 然后使用一个循环, 直到父节点变为黑色, 或者到达根节点. 
这就是插入重构的所有过程. 接下来是删除操作, 我们需要进行删除, 并且为了保留已有性质而进行树的重构操作. 总的来说, 红黑树节点的删除操作比插入操作更加复杂一些. 
在红黑树的删除操作中, 我们的主要矛盾就是黑节点删除, 因为红节点的删除不会引起红黑树任何性质的变化, 主要是黑色的问题, 因为删除了黑色之后, 首先可能会破坏根节点是黑色的条件, 此外我们还可能破坏两个红节点不能连续的条件, 因为一个黑节点很可能在两个红节点之间, 删除了黑节点就意味着红节点之间出现了相连的现象, 除此之外对于黑色节点的删除还可能导致每个节点的黑深度不再相同. 
这里算法导论引入了一种"节点双重颜色"的设定, 一下子加大了算法理解的难度, 这里我们主要看的是链接经典算法研究系列:五, 红黑树算法的实现与剖析的剖析. 
红黑树的节点删除代码也分为节点删除和树重构两个部分, 在算法导论中给出的代码不好理解, 下面是我在网上找的一个实现:
RB-DELETE(T, z){//T为树对象, z为要删除的树节点的指针
if left[z] = nil[T] or right[z] = nil[T] {
//这步处理的是当我们要删除的节点的左右子树都是空的时候
y = z;
} else{
//如果都不是空的, 那么y就是z的后继节点
y = z的后继节点;
}
if left[y] != nil[T]{
//如果y的左节点不是空的, 那x就是y的左节点
x = left[y];
}else{
//如果y的左节点是空的, 那么x就是y的右节点, 这个x有可能是空节点
x = right[y];
}
//这里我们可以确定的是y是一定要删除的节点, y指向z的时候要被删除, 指向z的后继节点的时候要被删除
//而x指向的是y存在的左右子树, 或者y不存在左右子树的时候的空节点
//这个时候我们将x的父节点指向y的父节点, 这样子造成的效果就是将要删除的y的子节点和y的父节点就连接上了
//这是删除y的前兆
p[x] = p[y];
if p[y] == nil[T] {
//如果p是根节点, 那么我们重新定义根节点
root[T] = x

}else{
//如果要删除的角色不是根节点, 那么我们就让删除节点的父节点的子节点指针重连
//而具体与哪一个指针连接我们需要进行一个判断
if(y == p[y].left){
p[y].left = x;
}else{
p[y].right = x;
}
}
if(y != z){
//这里说明y是z的后继节点, 我们删除y是没有用的, 我们还要把后继节点放到z的位置上去
key[z] = key[y];
}
if (color[y] == black) {
//如果被删除的元素是黑色, 我们就面临红黑树的重构, 因为黑节点的删除可能会导致红黑树:
//1, 根节点颜色是黑色
//2, 黑深度不统一
//3, 红节点不能相连
//这三个条件被破坏
//这里进行重构
RB-DELETE-FIXUP(T, x)
}
}
我们可以看到这个过程和二叉查找树是基本一样的, 主要是重构的问题, 真正被删除的节点可能就是调用者要删除的节点, 也有可能是调用者要删除节点的后继节点. 如果被真正删除的节点是黑色的, 那就会激发一个红黑树的重构. 
下面我们看看节点的重构代码. 
//修复节点的删除
//我们这里的x是比较有门道的, x是什么?因为我们的y始终指向的是被删除的节点, 而这个被删除节点的子节点小于等于一个, 所以x要不就是被删除节点y的唯一子节点, 或者NIL哨兵. 
RB-DELETE-FIXUP(T, x){
//重构是一个自下而上的循环过程, x会不断上移, 当x移到根节点或者当x节点的颜色变为红色的时候重构就会结束
//那x一开始会不会是红色的呢, 如果一开始就是红色, 我们只要把被删除黑节点y的这个红色子节点换成红色就好了. 
//这样子就保证了y的祖先节点的黑高度平衡
while x != root[T] and color[x] == BLACK{
//下文所述的逻辑
}
color[x] = BLACK;
}
这里一共分为四种情况, 都是x节点的黑色的情况, 所有的矛盾都是发生在x的兄弟节点和兄弟节点的子节点之间. 这样就诞生了很多种可能, 首先就是兄弟节点是红色, 除此之外就是兄弟节点是黑色, 面对黑色的情况我们就要看看儿子节点, 根据排列组合, 左右儿子节点莫非红红, 黑红, 黑黑, 红黑, 这么四种组合, 实际上右节点为红色的组合是可以组合的, 所以实际上在兄弟节点是黑色的情况实际上有三种情况, 算上兄弟节点的是黑色的情况实际上就是四种情况. 
这里我们处理一下这四种情况, 这四种方法没有什么重构的理由, 更像是一种需要死记硬背的设计. 首先卡 第一种:

这里x节点就是重构的核心, 因为x的原父节点被删除了, 现在x这一侧的黑高度比另外一侧小一, 我们这么进行一次转换, 就把第一种情况转换为另外三种情况了, 三另外三种情况中, x这一侧的黑高度会加一, 从而就可以保证平衡了. 这里就是将x的父节点和兄弟节点进行颜色的互换(父节点的原始颜色必须是黑色), 然后在兄弟节点和父节点之间进行一次旋转, 旋转方向与X所在子树的方向一致. 
下面是第二种情况, 就是兄弟黑, 并且兄弟的子女全是黑的情况:

这里我们直接改变兄弟节点的颜色就好, 这样子B之下的高度就是平衡的了(因为少了一个黑节点), 所以我们把B之下黑高度平衡搞定了, 现在主要矛盾又变成B节点一侧的高度不平衡. 所以我们将B看成新的x节点. 如果B是红的, 实际上把B改成黑的就可以一下子解决平衡问题, B之下的平衡解决了, B与其他子树的平衡也会解决, 如果B是黑色的, 那么B一侧的平衡问题就重新变为1, 2, 3, 4类, 通过考虑兄弟节点的情况进行进一步重构. 
这里我们可以看到整个重构过程的主要矛盾就是"黑高度平衡"的矛盾. 我们处理的问题从来都是X所在子树比另外一侧的黑高度少一的问题. 解决这类问题就是在x与父节点位置的节点直接做文章, 要么通过直接修改X的颜色, 要么在X与父节点之间加一个黑节点进来. 
然后就是第三种情况, 第三种情况主要就是为了产生第四种情况而设计的, 主要就是把兄弟节点的红黑子树编程右侧是红子树的情况. 实际上这里我们举的例子是x在左侧的情况, 在实际的实现中, 实际上这个例子体现为, 在x的兄弟节点中, 与x同侧的是红色, 与x异侧的是黑色. 我们要把他转化为异侧是红色. 主要方法就是让同侧节点和兄弟节点互换颜色, 然后向x的异侧旋转. 也就是我们需要把红节点旋到外侧. 

我们可以看到这里没有改变任何红黑树现有的状态, 但是这个转换的贡献就是他将新的第三种情况转换为第四种情况. 

这里父节点有一个红色子节点在x的对侧. 我们让x的父节点和兄弟节点进行颜色的交换, 然后进行一次和x节点所在子树方向一致的旋转. 
通过这几次旋转, 我们不难看出, 在节点删除的问题上, 都是让要旋转的两个节点交换颜色并且根绝子节点与父节点的位置关系进行旋转. 图中我们举的都是x在左子树的例子, 在实际情况中还有右子树的例子, 和左子树的情况是对称的. 
红黑树是现在我们所见过的树中最复杂的结构, 因为重构的情况实在是过于复杂. 这个结构在实际的测试中考察的可能性很低, 因为实现的时间会很长, 但是我们要牢记红黑树的优势, 以便在合适的时候进行调用. 
在金远平著的数据结构一书中, 没有对红黑树的介绍, 但是有一种非常平衡的树:AVL树. 这个树在算法导论的课后题中有详细介绍, 我们会进行详尽的实现和讨论. 

##  B树
红黑树拥有非常复杂的结构和实现, 但是依旧没有办法做到绝对的平衡. B树是一种绝对平衡的多叉树. 他的实现相对红黑树来说更有规律, 在节点的删除和添加上也没有很奇怪的实现. 总的来说是一种性能较好, 并且实现也很有逻辑可寻的数. 
B树的设计很简单. B树有一个概念, 叫做阶. 一个阶为m的节点非叶非根的节点一红有不多于m个不少于2/m个子树, 也就是说key的数量不能少于m/2-1. B树的节点除了有一串n个指向子树的指针之外, 还有n-1个key值来索引. 低a个子树的所有key值都在a-1和a号键值之间. 其实这就是一个查找树, 只是节点元素不固定的多叉查找树而已. 
B树节点添加
B树的节点添加key实际上要注意的就是节点的拆分, 我们知道阶为n的节点有n-1个key, 如果key超过n-1个就要将这个节点拆为两个节点. 
拆的方法很简单, 我们从中间进行划分, 假设节点key值索引的最大值为n, 中间key的索引为n/2. 这个key值是要进入父节点中了. 然后我们看看父节点, 放到哪?这个和要拆分的根节点在父节点长出的位置有关系. 比如放在a与a+1两个key值之间, 之前只有这个子节点, 假设要新加入的key值为b. 拆完的两个节点一个是x, 一个是y, 那么a与b之间的指针指向x, b与a+1之间的指针要指向y. 我们从尾部向前使用类似于插入排序的操作. 主要比b大的key值向后挪一位, 然后插入, 我们记录一下插入的位置X. 然后我们的指针也是要插入的, 指针数组我们从最后到X+1的指针都往后挪. 然后我们说一说子节点拆分的事情, 原来的节点不用着急析构, 我们只保留原来的节点前n/2-1个key值, 前n/2个指针. 然后我们把n/2+1之后的key值, 以及n/2+1之后的指针值放到另外一个节点中. 那么两个节点中有多少个key呢, 其实我们用头尾两个key的索引值相减+1就可以. 我们在拆分的时候我们要注意的就是两个数组索引号是斜着对齐的, 拆分的时候要注意两个数组的边界. 以及拆分的子节点在父节点中如何指向的问题. 
上面说的是怎么拆的, 现在说一说我们要怎么拆. 主要的方式就是"提前拆", 提前拆可以保证不需要回溯父节点. 因为子节点的拆分需要父节点的重新定位, 所以我们要做的就是我们扫描在父节点的时候就把该拆的子节点拆了. 那拆什么呢, 拆我们添加的查找路径上的节点. 我们要往这个子节点的方向走, 那么我们就先看看能不能拆, 如果这个节点已经满了, 那就拆, 拆完之后我们再找拆完的一个子节点. 这种方式有什么好处呢, 就是我们在添加的时候直接添加就好, 不需要不断向父节点方向修改. 
另外添加的过程我们要注意根节点, 这个是一个比较特殊的节点, 因为他的分裂会产生一个只有一个节点的新根, 这个是需要特出处理的. 
这个就是B树节点的添加过程. 
添加前:

添加后:

这里就展示了K与N出现M的时候向上拆分的. 但是实际上因为算法导论的没有父节点的实现中, 是不需要向上的递归重构的, 索引M的插入出现这种情景是不应该的, 应该是当遍历到G节点的时候就发现往下走会超, 所以提前分裂, 将HKNQ分为H和NQ, K上升到父节点中, 然后在插入M的时候我们就会把M插到NQ所在的叶子节点中. 
B树节点的删除
删除key值的过程比较麻烦, 但是也没有红黑树麻烦(笑). 删除的过程还是很容易的, 主要分几种情况一种是叶节点的删除, 这种删除直接删就可以了, 因为我们在向下遍历B树的路径上会让key值个数在2/m-1的节点提前扩容, 扩容的方式有好几种, 一种是向兄弟节点拿, 兄弟节点也拿不出来的, 那就将这个key和两个兄弟合并一下, key会下降下来和两个节点合并. 这种提前准备的过程也是"先看看我们要走的子节点需不需要扩容"的逻辑. 
主要注意"向兄弟要"和"与父节点的元素合并"两个过程, 向兄弟要我们可以向做兄弟要, 也可以向右兄弟要. 当左右兄弟有要不起的时候, 我们只能从左右挑一个兄弟和自己合并. 
怎么往左右要节点呢, 要的方法当然是我们向左边要最大的节点LMAX, 向右边要最小的节点RMIN, 我们假设夹在这两个节点之间的key为KEY, 其实就是把LMAX放到KEY上, 然后再把KEY放到需要key的最右边就好, 当然外侧子节点的指针也会换过去. 
这里我们再说一下删除的问题. 在删之前我们总是要找到这个key吧, 我们找这个key的过程首先是要保证一路向下, 去找, 找的过程中提前做好平衡工作, 即防止有一个节点存的内容个数下下边界上, 这个和那个添加节点之前提前分裂的逻辑是一样啊. 
找到之后如果是叶节点, 我们直接删除就好了, 如果我们发现我们要删除的东西在非叶节点上我们又要做一些处理. B树是一种特殊的查找树, 我们删除的时候实际上是用我们要删除的key是在前趋和后继所在的叶子节点上. 如果当前key左叶子的子树个数多于m/2个, 那么我们就去递归删除前趋, 然后将前趋换到当前节点上来, 如果左边子树节点比较小, 但是右边节点的大小够, 那就去删除和替换后继节点. 如果左右大小都不够, 那就进行一次合并, 然后再递归删除合并节点上的key. 实际上如果代码处理的好, 是可以一次扫描的. 
我们的删除函数也如是设计, 首先删除的过程就是一个找节点的过程, 找到之后如果是非页节点就递归删除后继或前趋key, 然后换过来, 也有可能是合并之后的原地递归. 我们查找的过程也要提前看看要去的节点规模, 然后进行平衡操作. 这个函数我们设计为递归函数, 递归函数以扫描到叶节点结束. 
B树的实现
这次我们在节点中需要实现一个在堆区的指针数组. 这个数组的声明要格外注意, 注意"*"的位置, 也不要加任何的括号:
1.childArr = new BTreeItem<T>*[Treerank];
B树的实现思路并不难, 但是很麻烦, 有很多的数组插入操作, 实际上我们可以单独提炼为一个函数, 这样就可以大大减少代码量. 另外分裂, 合并, 节点的旋转这三个是比较重要的操作, 最后就是删除和增加了. 删除要的向下查找的过程中以及添加的时候向下遍历的过程也要进行预先处理, 控制路径山节点的内容数量. 
此外对于非叶节点的删除我们在找不到前趋和后继的替换节点的时候我们也要进行合并. 
B+树
B+树是一种对于B树的改进. 实现起来也会很不一样, 首先就是他的节点子树的数量和节点key数量是一样的. 索引为a的子树中的所有值大小在key[a]到key[a+1]的左开右闭区间. B+树的重构过程是要插入之后再统一进行的, 特别是删除的时候. 
B+树的删除
下面说一下B+树的删除, 因为我们删完之后如果删的是某一个(或者非叶节点)叶节点的最大值的话, 那么我们要用这个节点的次大值来替换掉父节点的当前子树key[a+1]的值了. 因为删除全是叶节点的删除, 主要分为这么几种情况. 
我们以这个树为例:

正常删除:
我们删除91, 这个删除直接作用于叶节点, 不会破坏B+树的任何性质. 

需要重构的删除:
索引重构, 这个是比B树多的一种重构方式, 因为B+树的的所有非叶节点都是索引, 并且所有的做一年都要在叶子节点的最右边出现. 我们看到12, 44, 59, 72, 97就是非叶节点元素的所有可能. 
所以我们想一个问题, 如果删了97或者72怎么办, 这就需要重构非叶节点索引, 如果一个节点的最大key被删除或者因为key的插入导致最大key被其他的key覆盖, 这种我们都要进行向上的索引循环重构. 
我们删除一下97或者添加一个100, 这都涉及索引重构. 
删除97:

除了一般的索引重构, 还有在B树中就有的因为删除之后单节点里面的key太少导致的左右旋转重构和合并, B+树在这方面的实现更加简单, B书中我们是先把父节点的东西放到子节点, 然后把兄弟节点的东西交给父节点, 但是B+树的过程就没有那么难. 
比如我想在一开始的树上面删除51, 这样会使一个节点只有59了, 我们要怎么做?逻辑还是一样的, 向兄弟节点直接要就好, 然后改一下父节点的索引. 


不管怎么挪, 我们都要在父节点中将两个子树夹着的这个key改成左边节点最大值的索引. 因为这个改动不会影响父节点以上的B+树性质, 也完全不需要索引重构, 完全没有向上递归的事情. 
当然如果从左右节点要不到key的情况下, 那就只能进行合并了. 还是一开始那棵树, 我们删除59:

这就只能合并, 合并的方法很简单, 左右随便找一个合并就好了, 首先, 夹在两个节点之间的父节点key会消失, 然后两个节点合并并且向上循环重构父索引. 

这里有一个比较综合的情况, 如果父索引因为少了一个key也导致重构怎么办. 这里就涉及子树的处理, 非叶节点合并, 我们子树数组也合并在一起就好了. 如果是从左右两边要key, 那就把key对应的子树指针也挪过来就好了. 索引的重构是循环向上的, 但是节点key值个数的重构如果涉及合并就需要向上递归重构了. 
这就是节点删除的所有过程. 
B+树的添加
添加简单很多, 我觉得很有可能在机试中考. 正常的添加我就不再赘述了, 如果不涉及重构就加在叶节点上就好了. 
和删除一样, 我们还是先进行索引重构, 然后进行节点key重构, 我们在下面的B+树种加入100



这幅图就是索引重构完的结果. 这个过程用一个循环算法就好. 
然后就是节点重构. 

当前节点拆分, m/2索引所在的key复制到父节点中, 并且重新调整父节点的子节点指针就好. m/2我们给左边. 
非叶节点的拆分也很好办, 子树指针也是按照m/2拆分, 然后m/2给左边的方式就好了. 
我们发现B+树的实现其实更加简单一些. 多了一个索引重构的概念. 也可能是可以使用父指针向回走的缘故, 所以逻辑上比B树简单太多了. 
然后我们拆分还有一个问题要注意, 因为B+树的叶节点之间是相连的, 所以我们在做叶节点的拆分的时候, 我们要让左面的节点有一个指针指向右节点. 

##  图
图是一种比树更加宽泛的数据结构. 可以是有向图, 也可以是无向图. 其中, 无向图我们可以理解为每条边都是双向的有向图. 
图的表示有两种方式, 一个是使用"邻接表", 还有一种方式是使用"邻接矩阵". 邻接表是一种特别像哈希表的结构. 

最左边是一个线性表, 索引是一条边的起点的编号, 后面接的是一个链表, 这个链表里面就是线性表中节点的所有终点. 比如在索引为1的位置后面的链表接的是2和5, 那么这就说明图中有1->2和1->5两个边. 
还有一种方式是更为简单的邻接矩阵, 矩阵的纵索引是边的起点, 横索引是边的终点. 

这个就是上面那个邻接表对应的邻接矩阵. 
这两种实现进行其他的改造都非常合适, 比如我们可以在链表中加入一个新的字段来获得带权边的表示, 也可以在矩阵中使用一个整数而不是1来表达一个带权图. 
广度优先遍历
广度优先遍历的特点就是, 与遍历的根节点距离为k+1的节点被遍历之前, 所有与遍历根节点距离为k的节点全部都会被遍历. 也就是说先遍历所有离遍历根节点近的被遍历, 然后再遍历所有离根节点远的. 
广度优先遍历和我们之前使用的按层遍历异曲同工, 我们为所有的节点标记三种颜色, 并且输出除了遍历的结果之外, 还有每个节点与遍历的根之间的距离, 每个节点在遍历之后形成的树的父节点. 这两个内容. 每个节点与根之间的距离是用来记录最短距离的, 而我们对于父节点的记录可以找出最短路径. 
就如上文所说, 找出两个节点之间的最短路径是广度优先遍历的一个主要应用. 
广度优先遍历将节点分成三种颜色, 一种是黑色的节点, 一种是灰色的节点, 一种是白色的节点. 一开始所有的节点都是白色的. 没有被便利到的节点是白色的, 黑色的节点是已经被遍历的节点, 而灰色的节点是白色和黑色节点之间的分界. 是与白色节点还在接壤状态的节点. 
广度优先遍历使用一个队列作为实现的中间数据结构, 在队列中的所有节点都是灰色的节点, 都是还有子节点没有被遍历到的节点, 当一个灰色节点从队列中弹出就意味着与这个节点指向的白色节点变成灰色节点并且进入队列. 当队列中已经没有元素之后, 整个的广度优先遍历就结束了. 
我们在实现的过程中还使用了现成的容器类来完成队列的工作. 那就是deque, 这是一个模板类. C++ STL学习之三:容器deque深入学习
我们主要要记住几个函数, 一个是push_XXX, 这个函数一个在队列的头部和尾部插入元素, 还有一个是pop_XXX, 这个函数可以在队列的尾部和头部弹出元素, 但是不能将弹出的元素作为返回值返回, 所以我们还需要使用front和back两个函数来返回队列头部和尾部的值. 
广度优先遍历还是比较简单的, 但是要在实现中遇到节点的弹栈和出栈都要时刻注意修改父节点记录, 颜色记录, 与搜索根之间的距离, 三个数组. 
深度优先遍历
深度优先遍历我们是以深度为优先级的遍历方式, 他的方式和我们之前的那个"迷宫算法"很像, 都是使用一个栈结构来存储历史路径, 走不下去了, 就往回走一个, 然后看看还有没有路可以往下走. 整个深度优先遍历的停止条件就是这个栈变空了. 
为了简化代码实现, 实际上我们可以不用执着于使用栈结构, 而是使用递归算法, 考虑到栈结构的使用需要保存好多中间变量, 所以想想还是算了吧. 
深度优先遍历保留了存储每个节点在深度优先节点森林中的父节点(深度优先遍历一般不是从单一节点开始的, 而是从多个节点都开始的, 也就是说深度优先遍历, 实际上一定会遍历到图中的所有节点), 也保留了每个节点的父节点, 以及每个节点"入栈"与"弹栈"的时间戳数组, "时间"是一个全局变量, 只要有有节点"变色"就会自增, 并且进行记录, 只是在递归算法中, 栈被隐藏起来了, 所以我们只能通过"变色"来判断了. 我们会记录两个时间戳, 一个是节点从白到灰, 一个是节点从灰到黑. 
什么时候记录时间戳, 我们有一个驱动函数, 还有一个递归函数, 我们在驱动函数里面不进行任何的其他操作, 只去做一些初始化. 时间戳的修改, 颜色的修改, 我们会统一在递归函数中进行, 当递归到某一个节点, 我们才会进行这些数组的修改. 而父节点的设定我们会在调用递归函数的时候进行设置. 
此外还有记录节点颜色的临时数组. 这个和广度优先搜索是一样的. 
深度优先遍历有一个性质叫做括号定理. 深度优先遍历最后得到的东西是一个深度优先森林, 除非是树的根, 要嘛每一个节点都会有祖先节点, 之所以被称作括号定理, 就是两个节点的出栈以及入栈时间戳要不就是完全不相交, 要么就是相互包含. 如果相互包含, 那么这两个节点一定有祖先和后继的关系. 
拓扑排序
拓扑排序就是将一个有向图无环图之间的所有节点进行一个线性排序. 也就是排成一条线, 然后所有的箭头都会向一个方向指. 这个图一般表达了一些事件的先后逻辑顺序, 也就是事件A要发生之前必须要发生事件B的关系. 下面是一个在算法导论中的例子:

上面这个图表达了穿衣服必须的先后次序. 而后面的那个排成一条线的是一个人实际穿衣服的顺序. 处理的方式也是比较简单的, 我们进行深度优先遍历, 将节点按出栈时间戳倒序排列. 就形成了一个拓扑排序. 
强连通分支
强连通分支的寻找是对拓扑排序和深度优先搜索的一种应用. 强连通分支是是图的一个子集, 他满足一个非常重要的性质, 那就是在强连通分支的节点, 两两都是相互可达的, 也就是A可以走到B, 也可以从B走到A. 
强连通分支是简化图的有力工具. 因为强连通分支的所有点都是两两可达的, 所以我们可以把一个强连通分支简化为一个点, 这样子可以进行图的化简. 
强连通分支还需要用到图的转置, 所谓图的转置就是将图的所有边反向. 整个算法一开始就是进行一次深度优先搜索, 得出图中所有节点的拓扑排序, 然后我们对图进行转置, 在新的转置图中我们按照拓扑排序是顺序对所有的所有的节点发动深度优先搜索, 在每一次栈为空的时候(也就是递归重新回到驱动函数的时候), 所形成的一个个深度优先森林的树就是强连通分支. 
最小生成树
最小生成树是在带权图中找一个代价最小的树. 而最小生成树需要在无向连通图生成. 算法导论在这方面的描述就是玄学, 最小生成树的诞生主要有两个算法. 一个是克鲁斯卡尔(Kruskal)算法, 一个是Prim. 
克鲁斯卡尔算法的思想是比较简单的. 我们将各边按照权值的大小进行排序, 然后不断遍历图, 找到权值最小, 但是不和已有的选出来的边形成环就好. 

这个是一个很重要的例子. 整个过程是比较简单的, 我们不断寻找新的权值最小的边, 如果这个边和我们已经调出来边构成了环, 那就忽略这条边, 继续向下找. 
这个算法的实现还是比较简单的, 我们将边都拿出来, 然后使用一定的算法进行排序. 然后我们不断找出权值最小的边, 将边的两个点进行标记, 代表说这个边已经在树中的. 当新的节点需要加入的时候, 我们看看这个新的边的两个顶点是不是已经在树中, 如果已经在树中, 那就跳过这个边, 看看下一个代价比较小的边. 
Prim也是一种寻找最小生成树的策略, 和克鲁斯卡尔算法不一样的地方是, Prim算法关注的是点, 是我们从任意节点作为根来进行最小生成树的构建. 我们看树中已有节点接壤的那些边, 权值最小, 并且不与已有树构成环的边加入树, 最后当所有节点都加入树的时候我们的算法就结束了. 


这个就是Prim算法的过程, 我们将对Kruskal算法进行一下实现. 
整个的实现过程还是比较简单的, 主要就是分为两步, 一个是边的排序, 然后按照从小到大的顺序进行边的选择, 防止与已有的边构成环路. 
单源最短路径问题
实际上我们在广度优先搜索中就提到了最短路径问题, 但是在广度优先搜索中, 我们每一个边实际上都是权值为"1"的边. 我们这里讲的单源最短路径问题就是解决权值大于1的时候我们应该怎么办. 
对于单源最短路径, 我们需要了解一个叫做"松弛(RELAX)"的操作, 这个操作的目的就是找一个新的路径, 降低两个点之间的权值. 最短路径的查找过程就是一个不断"松弛"的过程, 在松弛之后, 点于点之间的权值就会变小, 最后最短路径就会浮现出来. 

在单源最短路径的寻找过程中我们需要两个数组, 一个是"前驱结点数组", 一个是"源节点代价估计数组". 前趋节点数组一般用来存对应编号节点的前趋节点, 后者用来存储当前我们对节点到源节点之间距离的估计. 
松弛技术的算法, 是就是当我们找到其他的节点的源节点距离估计和其他节点到当前节点的距离只和比当前节点的距离估计要小的话, 那就修改当前节点的距离估计. 

我们的整个算法就是进行整个图的RELAX操作. 我们一个图中的每一个边都要进行一次RELAX处理, 我们这种处理要进行很多轮, 要进行的轮数和点的数量-1相等. 因为我们知道单源最短路径组成的树最多有节点数量-1个边, 而因为我们每进行一轮所有边的RELAX操作至少可以找到一个单源最短路径的树的一条边. 这就是我们进行RELAX轮数设置的原则. 
对于单源最短路径问题的处理方法实际上很简单, 我们使用一个gif就可以一眼望穿. 

这个算法的思路主要来源于这个文章:最短路径—Dijkstra算法和Floyd算法
这里给出他的实现. 
//这个代表最大的Int值, 在初始化中使用, 代表不连通的两个点, 也代表一开始"最短路径"的初始值
const int MAXINT = 32767;
//点的数量
const int MAXNUM = 10;
//和某个源节点最短路径的长度
int dist[MAXNUM];
//最短路径构成的树的某个节点的前趋节点
int prev[MAXNUM];
//邻接矩阵, 记录了两个点之间的距离
int A[MAXUNM][MAXNUM];

//形参是起始节点的编号
void Dijkstra(int v0) {
//S是一个数组, 已经找到最短路径的节点就会加入到这个数组中, 代表这个节点的单源最短路径已经找到了
bool S[MAXNUM];

int n = MAXNUM;

//这个循环是用来初始化的
for (int i = 1; i <= n; ++i) {
//将dist进行初始化, 让直接与源节点v0相邻的节点的路径长度记录一下
dist[i] = A[v0][i];
//一开始所有的节点都没有确定和源节点的最短路径, 所以全部初始化为false
S[i] = false; // 初始都未用过该点
//如果某一个节点和初始节点不直接相连, 就把他的前趋节点初始化为-1, 代表它没有前驱结点
if (dist[i] == MAXINT) {
prev[i] = -1;
} else {
//与初始节点直接向量的前趋节点就是初始节点
prev[i] = v0;
}
}

//初始节点的初始化
dist[v0] = 0;
S[v0] = true;

//到这里除了源节点有很多点还没有加入S, 也就是说现在除了源节点之外其他节点都没有找到和源节点之间的最短路径. 所以我们开始从与源节点距离最短的点开始寻找最短路径. 
for (int i = 2; i <= n; i++) {
int mindist = MAXINT;
int u = v0; // 找出当前未使用的点j的dist[j]最小值
//这个循环要求找到S集合的邻接节点中和源节点距离最近的节点
for (int j = 1; j <= n; ++j) {
if ((!S[j]) && dist[j] < mindist) {
u = j; // u保存当前邻接点中距离最小的点的号码
mindist = dist[j];
}
}

//这个节点和源节点之间的距离就是最近的, 并且是可以确定的
S[u] = true;

//因为新的节点加入了S集合, 所以S集合的邻接节点的集合就变大了. 所以我们需要更新一下dist, 将新的邻接节点的dist更新一下. 
//这里遍历所有的节点
for (int j = 1; j <= n; j++){
//如果节点是新的邻接节点并且和新加入S集合的U节点是直接相连的, 那么这个节点的与源节点的距离可以算出来. 
if ((!S[j]) && A[u][j] < MAXINT) {
//因为这个邻接节点可能是S集合其他的节点的邻接节点, 所以dist可能之前已经找出来了, 我们看看通过这个新加入的S集合的节点, 能不能找到一个与源节点相连的最短路径. 
//这个if语句就是进行一个RELAX操作
if (dist[u] + A[u][j] < dist[j]) //在通过新加入的u点路径找到离v0点更短的路径
{
dist[j] = dist[u] + A[u][j]; //更新dist
prev[j] = u; //记录前驱顶点
}
}
}
}
}
我们简述一下这个gif的过程, 红色, 代表这个节点和源节点之间的最短路径已经找到了. 一开始红色肯定是源节点1, 当1确定下来之后, 和红节点相邻的节点的与源节点之间的距离就可以暂时算出来, 这些和红节点相邻的节点叫做"邻接节点", 邻接节点和源节点之间的最短路径可以走两条路, 一条是通过与红色的节点相连找到通往临界点的最短路径, 一种是通过与其他的邻接节点相连找到通往源节点的最短路径. 我们要确定一点, 那就是一个邻接节点不可能通过与非邻接非红节点相连找到与源节点相通的最短路径. 
这个算法的核心思想就是不断从邻接节点中找到与源节点距离最短的节点(这种节点只能通过与红节点相连找到最短路径, 所以这种节点是可以直接加入红节点的)加入红节点, 然后对与这个新加入红节点相连的节点进行一波RELAX操作, 更新他们的最短距离, 然后反复进行这个过程, 直到所有的节点都已经加入S集合, 那么所有节点的单源最短路径就找到了. 
在这个实现当中我们也发现了网上这个博主提供的方案的巧妙之处, 最外层的for循环直接解决了不可达点的问题for (int i = 2; i <= n; i++) {, 也就是说, 即便在图中出现了源节点的不可达点, 也可以在一定的循环次数之后停止单源最短路径的寻找. 
传递闭包
传递闭包有个看起来很厉害的名字, 但是实际上是一个很简单的道理. 传递闭包是一个矩阵, 当一个有向图的一个点可以通过有向图的边到达另外一个点的时候, 那么传递闭包矩阵的对应的[i,j]位置就是1. 
传递闭包的算法是非常简单的, 这里主要要注意的就是位运算的应用. 我们遍历所有的节点, 并且看看这个节点是不是其他节点的中心节点. 
warshall(A[1...n,1...n]
r(0)<-A;
for(k=1;k<=n;k++)
for(i=1;i<=n;i++)
for(j=1;j<=n;j++)
r(k)[i,j]=r(k-1)[i,j] or(r(k-1)[i,k] and r(k-1)[k,j]);
return r(n);
这个很"暴力"的算法名称叫做warshall, 代码的重点就是第6行, 先看or后面的东西, r(k-1)[i,k] and r(k-1)[k,j], 这个代表了当a和b相连, b和c相连, 那么a和c相连. 而且or的代码说明如果两个点已经被证明相连了, 那么我们就直接认定为相连. 
这个算法的难度非常的低, 我们就不再具体进行实现了. 

我们在实现中遇到的一些问题
在模板类中进行运算符重载
我们之前尝试在模板类中进行运算符的重载, 主要是在为一个模板类重新实现cout打印. 但是老是出错, 这是为什么, 因为我们重载的这个运算符是一个友元函数. 也就是说在模板类中不能声明一个带着类型变量T的友元函数, 因为编译器会不知道这个T是个什么数据类型, 从而报错. 我们声明在class上面的上面的那个template对友元函数是不起作用的, 因为friend函数并不是这个类的函数. 
那么现在问题来了, 因为对于cout<<打印这种"<<"左边的类型完全不可能是当前this指针指向的数据类型. 所以将运算符的重载放到成员函数中是不可能的. 所以我们直接在class声明之外, 将运算符的重载作为普通的模板函数声明就好, 像这样:
template<class T>
class MinMaxLeapItem {
friend class MinMaxLeap<T>;

public:
//我们重载一下打印的运算符
// friend ostream &operator<<(ostream& out, const MinMaxLeapItem<T>& minMaxLeapItem);

//构造函数
MinMaxLeapItem(int key, T value);

int getKey() const;

T getValue() const;

private:
int key;
T value;
};

template<class T>
ostream &operator<<(ostream &out,const MinMaxLeapItem<T>* &minMaxLeapItem) {
out << "进入" << endl;
out << minMaxLeapItem->getKey() << " , " << minMaxLeapItem->getValue();
//递归返回, 方便级联调用
//并且因为cout并没有实现良好的拷贝构造函数, 所以我们必须返回引用
return out;
};
因为没有了友元函数, 所以我们的运算符模板函数不能直接调用类的私有数据成员, 我们需要get函数. 
引用传参, 拷贝传参与const
时刻要记住, C++的const数据类型我们理解为是单独的, 也就是说const与const int是两种数据类型, 他在必要的时候, int这种普通类型是可以转化为const int这种常量类型的, 但是反之就不可以了. 
下面我们看一个很有意思的例子. 
template<class T>
ostream &operator<<(ostream &out,const MinMaxLeapItem<T>* minMaxLeapItem) {
out << "进入" << endl;
out << minMaxLeapItem->getKey() << " , " << minMaxLeapItem->getValue();
//递归返回, 方便级联调用
//并且因为cout并没有实现良好的拷贝构造函数, 所以我们必须返回引用
return out;
};
对于这样的一个函数, 我们cout后面可以接一个MinMaxLeapItem<T>类型的常量以及非常量的指针, 因为因为我们是拷贝传值, 所以就好像我们把一个int类型的数据赋值给一个const int类型的数据一样. 所以我们cout<<后面不管接的是不是常量都是没有事的. 那么如果我换一下. 
template<class T>
ostream &operator<<(ostream &out,const MinMaxLeapItem<T>* &minMaxLeapItem) {
out << "进入" << endl;
out << minMaxLeapItem->getKey() << " , " << minMaxLeapItem->getValue();
//递归返回, 方便级联调用
//并且因为cout并没有实现良好的拷贝构造函数, 所以我们必须返回引用
return out;
};
好的现在我变成了常量的指针的引用呢. 这就不一样了, 如果我cout<<后面是一个const类型的指针, 那是没事的. 如果cout<<后面不是一个常量的指针, 那么我们只能打印出一个地址, 没有掉起来重载函数. 难道不会强制类型转换吗?实际上应该是会的, 但是因为cout后面跟非常量指针引用的这个模式已经有默认实现了, 所以编译器就不会调用我们重载的那个实现. 
所以还是不要用引用这个东西了. 
友元关系之间的继承
友元之间是不能继承的, A是B的友元, B是C的友元, 那么A并不会是C的友元, 并不能调用C的私有数据成员. 我们需要在B和C中都声明友元的情况. 
函数的缺省形参
函数的有时候声明和实现是分开的, 我们只需要在函数声明阶段为函数最后几个形参上面加入缺省形参, 但是在函数的实现那个部分就不用再重复声明缺省形参了. 
运算符的重载
我们有时候会在类的成员函数中进行运算符的重载, 就像这样:
bool operator==(const KruskalEdge otherEage) {
if (this->u == otherEage.u && this->v == otherEage.v) {
return true;
}
if (this->u == otherEage.v && this->v == otherEage.u) {
return true;
}

return false;
}
这种重载方式比较简洁, 但是我们要注意的是如果我们使用这个类的指针是不能调用这个重载的, 也就是说上面这个"=="的左边不能是一个类的指针的. 我们必须是用一个真正对象和==进行拼接才能调用这个重载运算符函数. 


#  排序算法稳定性和复杂度分析

1.排序算法的稳定性分析
若待排序的序列中, 存在多个具有相同关键字的记录, 经过排序, 这些记录的相对次序保持不变, 则称该算法是稳定的;若经排序后, 记录的相对次序发生了改变, 则称该算法是不稳定的. 

(1)冒泡排序
冒泡排序就是把小的元素往前调或者把大的元素往后调. 比较是相邻的两个元素比较, 交换也发生在这两个元素之间. 所以, 如果两个元素相等, 我想你是不会再无聊地把他们俩交换一下的;如果两个相等的元素没有相邻, 那么即使通过前面的两两交换把两个相邻起来, 这时候也不会交换, 所以相同元素的前后顺序并没有改变, 所以冒泡排序是一种稳定排序算法. 

(2)选择排序
选择排序是给每个位置选择当前元素最小的, 比如给第一个位置选择最小的, 在剩余元素里面给第二个元素选择第二小的, 依次类推, 直到第n-1个元素, 第n个元素不用选择了, 因为只剩下它一个最大的元素了. 那么, 在一趟选择, 如果当前元素比一个元素小, 而该小的元素又出现在一个和当前元素相等的元素后面, 那么交换后稳定性就被破坏了. 比较拗口, 举个例子, 序列5 8 5 2 9, 我们知道第一遍选择第1个元素5会和2交换, 那么原序列中2个5的相对前后顺序就被破坏了, 所以选择排序不是一个稳定的排序算法.  

(3)插入排序
插入排序是在一个已经有序的小序列的基础上, 一次插入一个元素. 当然, 刚开始这个有序的小序列只有1个元素, 就是第一个元素. 比较是从有序序列的末尾开始, 也就是想要插入的元素和已经有序的最大者开始比起, 如果比它大则直接插入在其后面, 否则一直往前找直到找到它该插入的位置. 如果碰见一个和插入元素相等的, 那么插入元素把想插入的元素放在相等元素的后面. 所以, 相等元素的前后顺序没有改变, 从原无序序列出去的顺序就是排好序后的顺序, 所以插入排序是稳定的. 

(4)快速排序
快速排序有两个方向, 左边的i下标一直往右走, 当a[i] <=a[center_index], 其中center_index是中枢元素的数组下标, 一般取为数组第0个元素. 而右边的j下标一直往左走, 当a[j] > a[center_index]. 如果i和j都走不动了, i <= j,交换a[i]和a[j],重复上面的过程, 直到i>j. 交换a[j]和a[center_index], 完成一趟快速排序. 在中枢元素和a[j]交换的时候, 很有可能把前面的元素的稳定性打乱, 比如序列为5 3 3 4 3 8 9 10 11, 现在中枢元素5和3(第5个元素, 下标从1开始计)交换就会把元素3的稳定性打乱, 所以快速排序是一个不稳定的排序算法, 不稳定发生在中枢元素和a[j]交换的时刻. 
(5)归并排序
归并排序是把序列递归地分成短序列, 递归出口是短序列只有1个元素(认为直接有序)或者2个序列(1次比较和交换),然后把各个有序的段序列合并成一个有序的长序列, 不断合并直到原序列全部排好序. 可以发现, 在1个或2个元素时, 1个元素不会交换, 2个元素如果大小相等也没有人故意交换, 这不会破坏稳定性. 那么, 在短的有序序列合并的过程中, 稳定是是否受到破坏?没有, 合并过程中我们可以保证如果两个当前元素相等时, 我们把处在前面的序列的元素保存在结果序列的前面, 这样就保证了稳定性. 所以, 归并排序也是稳定的排序算法. 

(6)基数排序
基数排序是按照低位先排序, 然后收集;再按照高位排序, 然后再收集;依次类推, 直到最高位. 有时候有些属性是有优先级顺序的, 先按低优先级排序, 再按高优先级排序, 最后的次序就是高优先级高的在前, 高优先级相同的低优先级高的在前. 基数排序基于分别排序, 分别收集, 所以其是稳定的排序算法.  

(7)希尔排序(shell)
希尔排序是按照不同步长对元素进行插入排序, 当刚开始元素很无序的时候, 步长最大, 所以插入排序的元素个数很少, 速度很快;当元素基本有序了, 步长很小, 插入排序对于有序的序列效率很高. 所以, 希尔排序的时间复杂度会比o(n^2)好一些. 由于多次插入排序, 我们知道一次插入排序是稳定的, 不会改变相同元素的相对顺序, 但在不同的插入排序过程中, 相同的元素可能在各自的插入排序中移动, 最后其稳定性就会被打乱, 所以shell排序是不稳定的. 

(8)堆排序
我们知道堆的结构是节点i的孩子为2*i和2*i+1节点, 大顶堆要求父节点大于等于其2个子节点, 小顶堆要求父节点小于等于其2个子节点. 在一个长为n的序列, 堆排序的过程是从第n/2开始和其子节点共3个值选择最大(大顶堆)或者最小(小顶堆),这3个元素之间的选择当然不会破坏稳定性. 但当为n/2-1, n/2-2,...1这些个父节点选择元素时, 就会破坏稳定性. 有可能第n/2个父节点交换把后面一个元素交换过去了, 而第n/2-1个父节点把后面一个相同的元素没有交换, 那么这2个相同的元素之间的稳定性就被破坏了. 所以, 堆排序不是稳定的排序算法.

个人总结超级简记
平均时间复杂度为0(nlogn)的我们简记为"卖身契"MSQ
M = Merge 归并排序
S = ShellStack 希尔排序 堆排序
Q = Quick 快速排序

稳定性我们简记为 "伯明翰"Birm
B = Bubble 冒泡排序
I = Insertion插入排序
R = Radix 基数排序
M = Merge 归并排序  


#  空间复杂度

##  一, 空间复杂度介绍
程序的空间复杂性(space complexity)是指运行完一个程序所需要的内存大小
对一个程序的空间复杂性感兴趣的主要原因如下:
①如果程序将要运行在一个多用户计算机系统中, 可能需要指明分配给该程序所需的内存大小
②对任何一个计算机系统, 都想要知道是否有足够可用的内存来运行该程序
③一个问题可能有若干个内存需求各不相同的解决方案. 比如, 对于你的计算机来说, 某 个C + +编译器仅需要1 M B的空间, 而另一个C + +编译器可能需要4 M B的空间. 如果你的计算机 中内存少于4 M B, 你只能选择1 M B的编译器. 如果较小编译器的性能比得上较大的编译器, 即 使用户的计算机中有额外的内存, 也宁愿使用较小的编译器
④可以利用空间复杂性来估算一个程序所能解决的问题的最大规模. 例如, 有一个电路模 拟程序, 用它模拟一个有 c个元件, w个连线的电路需要 2 8 0 K + 1 0 *(c+w)字节的内存. 如果 可利用的内存总量为6 4 0 K字节, 那么最大可以模拟c+w≤3 6 K的电路
空间复杂度的组成
①指令空间(instruction space):指令空间是指用来存储经过编译之后的程序指令所需的空间
②数据空间(data space):数据空间是指用来存储所有常量和所有变量值所需的空间. 数据空间由两个部分构成: 
常量和简单变量所需要的空间
动态数组和动态类实例等动态对象所需要的空间
③环境栈空间(environment stack space):环境栈用来保存暂停的函数和方法在恢复运行所需要的信息 
例如, 如果函数foo调用了函数goo, 那么至少必须保存在函数goo结束时foo将要继续执行的指令的地址

##  二, 指令空间
程序所需要的指令空间的数量取决于如下因素: 
①把程序编译成机器代码的编译器
②编译时实际采用的编译器选项
③目标计算机
①把程序编译成机器代码的编译器
在决定最终代码需要多少空间的时候, 编译器是一个最重要的因素
例如下图给出了用来计算表达式a+b+b*c+(a+b-c)/(a+b)+4的三段可能的代码, 它们所需要的空间不一样. 每一个代码都由相应的编译器产生

即使采用相同的编译器, 所产生程序代码的大小也可能不一样. 例如, 一个编译器可能为用户提供优化选项, 如代码优化以及执行时间优化等. 比如, 在上图中, 在非优化模式下,  编译器可以产生b所示的代码. 在优化模式下, 编译器可以利用知识a+b+b*c=b*c+(a+b)来产生图中c中更短, 更高效的代码. 不过, 使用优化模式通常会增加程序编译所需要的时间
从上图的例子中可以看到, 一个程序还可能需要其他额外的空间, 即诸如临时变量t1,t2,...,t6所占用的空间
③目标计算机
目标计算机的配置也会影响编译后的代码大小
例如, 如果计算机具有浮点处理硬件, 那么每个浮点操作可以转换成一条机器指令. 如果没有安装浮点处理硬件, 就需要生成代码来模拟浮点操作

##  三, 数据空间
对各种数据类型, C++语言并没有指定它们的空间大小, 只是大多数C++编译器有相应的空间分配
如下图所示, 定义了32位计算机下的各种变量和常量所占用的空间(一个整形数据空间的大小与一个字的空间大小一样)

一个结构变量的空间大小是每个结构成员所需的空间大小之和. 类似的, 一个数组的空间大小是数组的长度乘以一个数组元素的空间代大小

##  四, 环境栈空间
在开始性能分析时, 分析员通常会忽略环境栈所需要的空间, 因为他们不理解函数(尤其是递归函数)是如何被调用的以及在函数调用结束时会发生什么. 每当一个函数被调用时, 下面的数据将被保存在环境栈中: 
①返回地址
②正在调用的函数的所有局部变量的值以及形式参数的值(仅对递归函数而言)
例如
以下面的递归函数为例, 每当它被调用时, 不管调用来自函数外部还是内部, a和n的当前值以及调用结束时程序的断口地址都被存储在环境栈中

值得注意的是: 
有些编译器, 不论对递归函数还是非递归函数, 在函数调用时, 都会保留局部变量的值和形参的值
而有些编译器则仅为递归函数保存上述内容. 所以实际使用的编译器将影响环境栈所需要的空间
##  五, 实例特征
程序要处理的问题实例都有一些特性. 一 般来说, 这些特征包含决定程序空间大小的因素(如, 输入和输出的数量或相关数的大小). 例如, 对于一个对n个元素进行排序的程序, 可以确定该程序所需要的空间为 n 的函数;对于 一个累加两个n×n 矩阵的程序, 可以使用n 作为其实例特征;而对于累加两个 m×n 矩阵的程序, 可以使用m和n作为实例特征
实例特性与影响程序空间复杂度的关系: 
相对来说, 指令空间的大小受实例特性的影响不大. 常量及简单变量所需要的数据空间也与实例特性没有多大关系, 除非相关数的大小对于所选定的数据类型来说实在太大, 这时, 要么改变数据类型, 要么使用多精度算法重写该程序, 然后再对新程序进行分析
一些动态分配空间也可以不依赖实例特性. 环境栈的大小一般不依赖实例特性, 除非正在使用递归函数. 在使用递归函数时, 实例特征通常(但不总是)会影响环境栈的大小
函数的递归空间:递归函数所需要的栈空间通常称之为递归栈空间( recursion stack space). 该空间主要依赖于局部变量及形式参数所需要的空间. 除此以外, 该空间还依赖于递归的深度(即嵌套递归调用的最大层次)和编译器. 如下的rSum()的嵌套递归调用一直进行到n=0, 嵌套调用的层次关系如下图所示, 最大的递归深度是n+1. 智能编译器可以把尾递归转换为迭代, 从而减少, 甚至排除递归栈空间
//返回数组所有元素的和
template<typename T>
T rSum(T a[], int n)
{
    if (n > 0)
        return rSum(a, n - 1) + a[n - 1];
    return 0;
}

##  六, 空间复杂度的计算方式
可以把一个程序所需要的空间分成两部分: 
固定部分:它独立于实例的特征. 一般来说, 这一部分包含指令空间(即代码空间), 简单变量及定长复合变量所占用空间, 常量所占用空间等等. 
可变部分:它由以下部分构成:复合变量所需的空间(这些变量的大小依赖于所解决的 具体问题), 动态分配的空间(这种空间一般都依赖于实例的特征), 以及递归栈所需的空间 (该空间也依赖于实例的特征)
空间复杂度的公式
任意程序P所需要的空间可以用下面的计算公式表示 
其中c 是一个常量, 表示固定部分所需要的空间. Sp表示可变部分所需要的空间

要精确的分析还应当包括在编译期间所产生的临时变量所需要的空间(如文本的第一张图片所示), 这种空间是与编译器直接相关的, 除依赖于递归函数外, 它还依赖于实例的特征. 以后讨论时将忽略这种空间
在分析程序的空间复杂性时, 我们将把注意力集中在估算 Sp(实例特征)上. 对于任意给定的问题, 首先需要确定实例的特征以便于估算空间需求. 实例特征的选择是一个很具体的问题, 我们将求助于介绍各种可能性的实际例子. 一般来说, 我们的选择仅限于程序输入和输出的规模. 有时我们也会对数据项之间的关系进行复杂的估算

## 七, 演示案例

下面的程序. 在计算Sp之前, 必须选择实例特性. 假定我们用a, b, c值的大小作为实例特性. 因为a, b, c是整型, 所以每一个都占用4字节. 另外, 需要的空间是指令空间. 因为数据空间和指令空间都不受a, b, c值的大小所影响, 所以Sabc(实例特性)=0
int abc(int a, int b, int c)
{
    return a + b * c;
}


