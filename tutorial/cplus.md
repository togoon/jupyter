

# 区别

## 'a'字符 和 "a"字符串 的区别
c++中，双引号中间的数据视作字符串，单引号中间的数据视作字符。
"a"表示的是两个连续的字符：'a'和0，占用两个字节，char str[20]={ "a" };相当于写char str[20]={ 'a',0 };双引号表示提供的是字符串
'a'仅表示小写字母a这个字符，只占1个字节。与上边比较，少了字符串结尾的0，单引号表示写出的是单个字符


## const 常量
左定值，右定向，const修饰不变量
在编程中要尽可能多的使用const，这样可以获得编译器的帮助，以便写出健壮性的代码。

int a = 10;
int const* p = &a;   //左定值, 常量const指针*, 指针指向内容*p不能变 , 同const int* p = &a , 如const位于*的左侧，则const就是用来修饰指针所指向的变量，即指针指向为常量；
*p = 20;   //error  不可以通过修改所指向的变量的值
int b =20;
p = &b;     //right  指针可以指向别的变量

int* const p = &a;   //右定向, 指针*常量const,  指针本身p不能变, 如果const位于*的右侧，const就是修饰指针本身，即指针本身是常量。
*p = 20;     //right 可以修改所指向变量的值
int b = 10;
p = &b;      //error 不可以指向别的变量

int const * const p5 = &a;//指针前有指针后也有 指针和指针所指数据都不能修改

用const修饰函数参数，传递过来的参数在函数内不可以改变。
void StringCopy(char* strDest, const char* strSource);
void func (const int& n)
{
     n = 10;        // 编译错误 
}
实参中，指针会指向一段内存地址，调用函数之后，函数会产生一个临时指针变量，这个变量的地址与实参的地址不一样，但是这两个指针指向的内存是同一块。形参加上const 修饰之后，保护了这一块内存地址不被修改，如果刻意修改这一块内存，编译器会报错。


# C++关键技术总结

## 第一章 从C到C++ 
### 1,   利用常量 
C语言中利用define预定义符定义符号常量, C++中利用const关键字定义常量, 其好处是定义的常量具有数据类型.  
### 2,   内联函数 
对于一些函数体代码不大, 但又被频繁调用的函数, 利用内联函数可以提高效率. 但是内联函数的代价是需要占用更多的空间, 如果程序在10个不同的地 方调用了同一个内联函数, 则程序将包含该函数的10个代码的拷贝. 所以内联函数的实际是用空间来换时间——空间开销增大了, 时间开销减少了.  
在函数的定义处加上inline关键字说明函数为内联函数, 但只是向编译器发出内联的请求, 编译器在编译的时候未必会把该函数编译为内联函数. 内联函数和带参数的宏的区别:内联函数是通过传递参数实现的, 而不是通过简单的文本替换来实现的.  
注意: 
(1)内联函数通常不能包括复杂结构的控制语句:如switch, while, 复杂语句嵌套, 否则, 系统将作为普通函数处理.  
(2)递归函数不能作为内联函数.  
(3)内联函数适合只有1～5行的小函数 
(4)在类结构中, 在类体中定义的成员函数都是内联函数.  
### 3,   函数重载 
带有默认参数的函数重载常引起二义性. 如以下三个函数: 
int fun(int m, int n, int j=5) 
int fun(int m, int n=3, int j=5) 
int fun(int m=1, int n=3, int j=5) 
在调用fun(1, 3, 5)时, 系统将产生二义性, 因为都严格匹配上面的三个函数, 所以编译器不知道要调用哪一个.  
### 4,   函数模板 
函数模板是通用的函数描述, 它们使用通用类型来定义函数, 其中的通用类型可以是具体的类型(如int或double)替换. 通过将类型作为参数传递给模板, 可使编译器生成该类型的函数.  
template <typename T> void Swap(T &a, T &b) 
{ 
 T tmp; 
 tmp = a; 
 a = b; 
 b = tmp; 
} 
int main() 
{  int a = 10, b = 20; 
 float x = 3.14f, y = 8.71f; 
 cout << "Before swap:" << endl; 
 cout << a << " " << b << endl; 
 cout << x << " " << y << endl; 
 Swap(a, b); 
 Swap(x, y); 
 cout << "After swap:" << endl; 
 cout << a << " " << b << endl; 
 cout << x << " " << y << endl; 
 return 0; 
} 
其中AnyType一般为了简化, 就定义为T.  
### 5,   指针 
(1)const和指针的组合情况 
指向常量的指针 const int *p 或者 int const *p 
常指针 int *const p 
指向常量的常指针 const int *const p 
(2)一定用配对的使用new和delete, 否则会发生内存泄漏问题. 在执行完delete之后, 要把指针的值赋为NULL, 以避免产生野指针.  
### 6,   引用 
引用就是为某个变量起了个别名, 对别名的操作就等同于对目标变量的操作. 引用本身不是变量, 它是某个变量的别名, 其本身不占用存储空间. 定义引用的时候必须指出目标对象.  
### 7,   名称空间 
名称空间的意义主要在于解决名字冲突问题.  
namespace namespace_name 
{ 
    //各种名称(包括类型名, 变量名和函数名) 
} 

## 第二章 类和对象 
### 1,   类和对象的定义 
类是具有相同属性和操作的一组对象的集合. 类的实例就是对象. 将一个对象赋值给另一个对象时, 所有的数据成员都会逐个复制.  
### 2,   友员 
在C++中, 友员主要有两种类型:友员类和友员函数 
(1)友员类 
一个类A如果是类B的友员类, 则要在类B中要声明friend class A. 这样A就是成为了B的友员类, 则类A中的所有成员函数都可以访问类B中保护或者私有成员.  
友员关系具备单向, 不交换, 不传递的特性.  
单方向:若A类为B类的友员类, 并不意味着B也具有友员类A 
不传递:若A类是B类的友员类, B类是C类的友员类, 并不意味着A可以直接存取C中的保护或私有变量.  
(2)友员函数 
友员函数不是当前类的成员函数, 是独立于当前类的外部函数, 它可以访问当前类的私有数据成员和公有数据成员.  
### 3,   类的静态数据 
(1)静态数据成员 
静态数据成员属于类, 而不像普通数据成员一样属于某一个对象, 因此要利用"类名::"访问静态的数据成员. 静态数据成员不能在类中初始化, 一般在 main()函数之前初始化, 如果不初始化, 默认初始化为0. 静态数据成员具有全局变量的一些特性, 建议把静态数据成员说明为私有的.  
(2)静态成员函数 
静态成员函数利用"类名::"作为它的限定词. 由于静态成员函数不属于某个对象, 因此一般用静态成员函数访问静态数据成员或者全局变量. 一般而言, 静态成员函数不访问类中的非静态数据成员. 若确实有需要, 静态成员函数只能通过对象名访问该对象的非静态成员.  
### 4,   this指针 
this指针总是指向当前对象. 通过"this->成员名"或者"(*this).成员名"来表示当前对象中的某个成员.  
### 5,   构造函数 
构造函数的特性: 
(1)构造函数的名字必须和类名一致 
(2)构造函数可以带参数, 但是不能有返回值 
(3)定义对象时, 编译系统自动调用构造函数 
(4)构造函数不能像其它成员函数那样被显示地调用, 它是在定义对象的同时被调用.  
(5)构造函数可以有多个, 如果没有定义构造函数, 系统会提供一个默认的构造函数, (6)它只负责创建对象, 不做任何的初始化操作.  
  
拷贝构造函数:通过已存在的对象创建一个新对象.  
类名 (const 类名 &ob) 
{  //拷贝构造函数体 
} 
如果没有编写自定义的拷贝构造函数, C++会自动将一个已存在的对象复制给新对象, 这种按成员逐一复制的过程由默认的拷贝构造函数自动完成.  
拷贝构造函数和缺省的拷贝构造函数区别在于:拷贝构造函数用自定义的拷贝构造函数所给出的算法初始化新对象的数据成员, 也就是说已知对象和新对象有区别. 而采用缺省的拷贝构造函数初始化对象, 则新对象和已知对象一致.  
在C++程序中, 如果使用默认构造函数创建两个对象, 则这两个对象指向同一个资源, 这中拷贝称之为浅拷贝, 若使用自定义的拷贝构造函数创建两个对象, 则这两个对象指向不同的资源, 这种拷贝称为深拷贝.  
以下是一个深拷贝的一个例子: 
#include <iostream>  
using namespace std; 
  
class student 
{ 
public: 
       student(char *sn) 
       { 
              cout << "constructing " << sn << endl; 
              sname = new char(strlen(sn) + 1); 
              if (sname != NULL) 
                     strcpy(sname, sn); 
       } 
       student(student &s) 
       { 
              cout << "copy" << endl; 
              sname = new char(strlen(s.sname) + 1); 
              if (sname != NULL) 
                     strcpy(sname, s.sname); 
       } 
       ~student() 
       { 
              cout << "destructing " << sname << endl; 
              delete[] sname; 
              sname = NULL; 
       } 
protected: 
       char *sname; 
}; 
  
int main() 
{ 
       student p1("wang"); 
       student p2(p1); 
       return 0; 
} 
在VC下编译能通过, 但是在运行时出错了. 但是在linux环境下, g++编译和运行都正确. 我估计在VC下都当成浅拷贝了.  

###  6,   析构函数 
一个类只能有一个析构函数, 没有参数, 没有返回值, 用户可以自己定义析构函数, 也可以使用编译系统生成的默认析构函数.  
析构调用过程是构造顺序的逆过程. 最先构造的对象, 最后析构.  
由于析构函数不能带参数, 故一个类中只能有一个析构函数. 一般来说, 如果一个类中定义了虚函数, 析构函数也应定义为虚析构函数, 其主要用来完成对象消亡之前做一些清理工作, 比如释放内存等.  
一般情况下类的析构函数作用是:释放内存资源, 而此析构函数不能被调用的话会造成内存泄漏. 此时将析构函数定义为虚函数就特别重要.  
7,   成员初始化列表及初始化 
在进行含有对象成员的类对象的初始化时间, 首先按照类定义对象成员的顺序来分别调用各自的对象成员所对用的构造函数, 然后再执行该类自己定义的构造函数.  
### 8,   继承 
     子类继承父类之后, 如果修改了父类的方法, 在调用父类的方法的时候, 要使用(子类的对象).父类名::(方法名)来调用.  
#include <iostream> 
using namespace std; 
  
class Base 
{ 
public: 
       void fun() 
       { 
              cout << "In Base" << endl; 
       } 
}; 
  
class Pai: public Base 
{ 
public: 
       void fun() 
       { 
              cout << "In Pai" << endl; 
       } 
}; 
int main() 
{   
       Pai  a; 
       a.Base::fun(); 
       a.fun(); 
       return 0; 
} 

## 第三章 多态 

### 1, 虚函数 
C++支持两种类型的多态性, 一种是编译时多态, 一种是运行时多态.  
(1)编译时的多态性:也称静态多态, 是通过函数的重载来实现的, 到底执行哪一个重载版本在编译时就知道了.  
(2)运行时的多态性:也称动态多态, 是直到系统运行时, 才根据实际情况决定实现何种操作. C++中, 运行时的多态性通过虚函数机制来实现.  
    编译时的多态性具有运行速度快的特点, 而运行时的多态性则带来了高度灵活和抽象的特点, 也就是说, 到底运行哪个函数版本, 需要在运行时通过找出发送消息的对象来确定, 编译器在编译时采用的是动态联编的手段.  
  
动态联编的一个例子: 
#include <iostream> 
using namespace std; 
  
class Shape 
{ 
public: 
       virtual void Area() 
       { 
              cout << "这是基类形状类的求面积函数" << endl; 
       } 
}; 
  
class Rectangle: public Shape 
{ 
public: 
       void Area() 
       { 
              cout << "这是派生类矩形的求面积函数" << endl; 
       } 
}; 
  
int main() 
{ 
       Shape sh1, *pShape; 
       Rectangle rect1; 
       pShape = &sh1;  //指针pShape指向Shape对象sh1 
       pShape->Area(); 
       pShape = &rect1; //指针pShape指向Rectangle对象rect1 
       pShape->Area(); 
       return 0; 
} 
  
### 2, 纯虚函数 
纯虚函数的一般格式为: 
Virtual 返回类型 函数名(参数表)=0 
(1)  定义纯虚函数时, 没有实现部分, 不能产生对象, 不能被直接调用 
(2) "=0"本质上是将指向函数体的指针定义为NULL, 纯虚函数仅起提供一个与派生类相一致的接口作用, 用于派生类中具有相同名字的函数的存放处.  
(3)  在派生类中必须有重新定义的纯虚函数的函数体, 即使再次声明该函数为纯虚函数.  
  
### 3, 抽象类 
如果一个类中, 至少有一个纯虚函数, 那么称该类为抽象类. 抽象类不能实例化, 它只是将许多相关的类组织起来, 提供一个公共的基类, 而那些被它组织在一起的具体的类由它派生出来.  
#include <iostream> 
using namespace std; 
  
class CMenu               //抽象类 
{ 
public: 
       virtual void func() = 0;   //纯虚函数 
}; 
  
class CFormMenu1: public CMenu 
{ 
public: 
       void func() 
       { 
              cout << "你选择的是——新建文件菜单" << endl; 
       } 
}; 
  
class CFormMenu2: public CMenu 
{ 
public: 
       void func() 
       { 
              cout << "你选择的是——打开文件菜单" << endl; 
       } 
}; 
  
class CFormMenu3: public CMenu 
{ 
public: 
       void func() 
       { 
              cout << "你选择的是——保存文件菜单" << endl; 
       } 
}; 
  
int main() 
{ 
       int choice; 
       CMenu *f[3];        //定义一个基类的指针数组 
       f[0] = new CFormMenu1; 
       f[1] = new CFormMenu2; 
       f[2] = new CFormMenu3; 
       do 
       { 
              cout << "1: 新建文件.." << endl; 
              cout << "2: 打开文件.." << endl; 
              cout << "3: 保存文件.." << endl; 
              cout << "0: 退出程序.." << endl; 
              cin >> choice; 
              if (choice >=1 && choice <=3) 
f[choice - 1]->func(); 
       }while(choice != 0); 
       return 0; 
} 

## 第四章 类模板和重载 

### 1, 类模板 
    类模板只是模板的定义, 不是一个实在的类, 类模板是对象的抽象, 代表一种类型的类, 这些类具有相同的功能, 但是数据成员类型及成员函数返回类型和形参类型不同.  
    实例化类模板是将一个通用的类模板生成一个具体的类, 因此说, 模板类是类模板的实例, 代表一个具体的类. 模板类可以定义类对象, 而类模板不能定义对象, 因此说模板类才是实实在在的类.  
#include <iostream> 
using namespace std; 
  
template <typename T> 
class CDemo 
{ 
       public: 
              CDemo(T t1, T t2, T t3); 
              T Min(); 
              T Max(); 
       private: 
              T x, y, z; 
}; 
  
template <typename T> //在类外定义的成员函数, 需要加上这条, 来指明它是类模板的成员 
CDemo<T>::CDemo(T t1, T t2, T t3): x(t1), y(t2), z(t3) 
{ 
       return ; 
} 
  
template <typename T> 
T CDemo<T>::Min() 
{ 
       T min = x; 
       if (y < min)   min = y; 
       if (z < min)    min = z; 
       return min; 
} 
  
template <typename T> 
T CDemo<T>::Max() 
{ 
       T max = x; 
       if (y > max)    max = y; 
       if (z > max)    max = z; 
       return max; 
} 
  
int main() 
{ 
       CDemo<int> example(1, 2, 3); 
       cout << example.Max() << endl; 
       cout << example.Min() << endl; 
       return 0; 
} 
  
### 2, 运算符重载 
    C++中大部分的运算符可以重载, 但是如下表所示的运算符不能重载.  
运算符 运算符名称 禁止重载的理由 
?: 三目条件运算符 C++中没有定义三目运算符的语法 
. 成员操作符 为保证成员操作符对成员访问的安全性 
:: 作用域操作符 该操作符右操作数不是表达式 
sizeof 类型长度操作符 该操作符的操作数为类型名, 不是表达式 
  
    运算符的重载形式有两种:重载为类的成员函数和重载为类的友员函数. 这两种形式都可以访问类的私有成员. 成员函数是用this指针隐式地访问类对象的某个参数, 友员函数的调用必须明确列出该参数.  
当运算符函数是一个成员函数时, 最左边的操作数(或者只有最左边的操作数)必须是运算符类的一个类对象(或者是该对象的引用). 如果左边的操作数 必须是不同类的对象, 或者是一个内部类型的对象, 该运算符函数必须作为一个非成员函数(通常是友员函数)来实现. 选择友员函数重载运算符的另一个原因是使 运算符具有可交换性. 例如:给定正确的重载运算符定义, 运算符左边的参数可以是其它数据成员的对象.  
特别需要注意的是:当运算符重载为类的成员函数时, 函数的参数个数比原来的操作数的个数要少一个("++",  "——"除外);当重载为类的友员函数时, 参数个数和原来的操作数的个数相同.  
  
### 3, 异常处理 
#include <iostream> 
using namespace std; 
  
class Base 
{ 
public: 
       void show() 
       { 
              cout << "Base object" << endl; 
       } 
}; 
  
class Derived: public Base 
{ 
public: 
       void show() 
       { 
              cout << "Derived object" << endl; 
       } 
}; 
  
int main() 
{ 
       int no; 
       cout << "Input a integer please" << endl; 
       if (cin >> no) 
       { 
              try 
              { 
                     if (no % 2 == 0) 
                            throw Base();  //抛出基类对象 
                     else 
                            throw Derived(); //抛出派生类对象 
              } 
              catch(Derived d) 
              { 
                     cout << "Exception:"; 
                     d.show(); 
              } 
              catch(Base b) 
              { 
                     cout << "Exception:"; 
                     b.show(); 
              } 
       } 
       return 0; 
} 


# C++11/14新特性

## 左值右值
C++( 包括 C) 中所有的表达式和变量要么是左值, 要么是右值. 通俗的左值的定义就是非临时对象, 那些可以在多条语句中使用的对象. 所有的变量都满足这个定义, 在多条代码中都可以使用, 都是左值. 右值是指临时的对象, 它们只在当前的语句中有效. IBM 右值引用与转移语义
有一种甄别表达式是否左值的方法, 是检查能否获得该表达式的地址;如果可以取得, 基本上可以断定是左值表达式;如果不能取得则通常是右值. 

## 右值引用类型
我们可以理解右值为临时对象, 像有些函数返回的对象是临时对象, 该句执行完毕就会释放临时对象空间, 因此留下右值的引用在以前并没有用. 
C++11 是提出了右值引用, 可以延长临时对象的生存周期, 其创建方法为type && vb = xx;对应的左值引用的生命符号为&. 
#include <iostream>
#include <string>
 
int main()
{
    std::string s1 = "Test";
//  std::string&& r1 = s1;           // 错误:不能绑定到左值
 
    const std::string& r2 = s1 + s1; // okay:到 const 的左值引用延长生存期
//  r2 += "Test";                    // 错误:不能通过到 const 的引用修改
 
    std::string&& r3 = s1 + s1;      // okay:右值引用延长生存期
    r3 += "Test";                    // okay:能通过到非 const 的引用修改
    std::cout << r3 << '\n';
}
更重要的是, 当函数同时具有右值引用和左值引用的重载时, 右值引用重载绑定到右值(包含纯右值和亡值), 而左值引用重载绑定到左值:
#include <iostream>
#include <utility>
 
void f(int& x) {
    std::cout << "lvalue reference overload f(" << x << ")\n";
}
 
void f(const int& x) {
    std::cout << "lvalue reference to const overload f(" << x << ")\n";
}
 
void f(int&& x) {
    std::cout << "rvalue reference overload f(" << x << ")\n";
}
 
int main() {
    int i = 1;
    const int ci = 2;
    f(i);  // 调用 f(int&)
    f(ci); // 调用 f(const int&)
    f(3);  // 调用 f(int&&)
           // 若不提供 f(int&&) 重载则会调用 f(const int&)
    f(std::move(i)); // 调用 f(int&&)
 
    // 右值引用变量在用于表达式时是左值
    int&& x = 1;
    f(x);            // calls f(int& x)
    f(std::move(x)); // calls f(int&& x)
}

## 移动语义(Move Sementics)与精准传递(Perfect Forwarding)
移动语义是通过盗取将亡值的变量内存空间, 首先确保该部分空间之后不会使用, 然后将该空间占为己有, 看起来像是一个拷贝操作. 
移动语义位于头文件#include<algorithm>, 函数名为std::move. 
#include <iostream>
#include <vector>
#include <list>
#include <iterator>
#include <thread>
#include <chrono>
 
void f(int n)
{
    std::this_thread::sleep_for(std::chrono::seconds(n));
    std::cout << "thread " << n << " ended" << '\n';
}
 
int main() 
{
    std::vector<std::thread> v;
    v.emplace_back(f, 1);
    v.emplace_back(f, 2);
    v.emplace_back(f, 3);
    std::list<std::thread> l;
    // copy() 无法编译, 因为 std::thread 不可复制
 
    std::move(v.begin(), v.end(), std::back_inserter(l)); 
    for (auto& t : l) t.join();
}

## 自动类型推导
auto和decltype 关键词是新增的关键词, 我们知道C++是强类型语言, 但使用这两个关键词, 可以不用手写完整类型, 而是让编译器自行推导真实类型. 
auto用法非常简单, 示例如下:
#include <iostream>
#include <utility>
 
template<class T, class U>
auto add(T t, U u) { return t + u; } // 返回类型是 operator+(T, U) 的类型
 
// 在其所调用的函数返回引用的情况下
// 函数调用的完美转发必须用 decltype(auto)
template<class F, class... Args>
decltype(auto) PerfectForward(F fun, Args&&... args) 
{ 
    return fun(std::forward<Args>(args)...); 
}
 
template<auto n> // C++17 auto 形参声明
auto f() -> std::pair<decltype(n), decltype(n)> // auto 不能从花括号初始化器列表推导
{
    return {n, n};
}
 
int main()
{
    auto a = 1 + 2;            // a 的类型是 int
    auto b = add(1, 1.2);      // b 的类型是 double
    static_assert(std::is_same_v<decltype(a), int>);
    static_assert(std::is_same_v<decltype(b), double>);
 
    auto c0 = a;             // c0 的类型是 int, 保有 a 的副本
    decltype(auto) c1 = a;   // c1 的类型是 int, 保有 a 的副本
    decltype(auto) c2 = (a); // c2 的类型是 int&, 为 a 的别名
    std::cout << "a, before modification through c2 = " << a << '\n';
    ++c2;
    std::cout << "a, after modification through c2 = " << a << '\n';
 
    auto [v, w] = f<0>(); // 结构化绑定声明
 
    auto d = {1, 2}; // OK:d 的类型是 std::initializer_list<int>
    auto n = {5};    // OK:n 的类型是 std::initializer_list<int>
//  auto e{1, 2};    // C++17 起错误, 之前为 std::initializer_list<int>
    auto m{5};       // OK:C++17 起 m 的类型为 int, 之前为 initializer_list<int>
//  decltype(auto) z = { 1, 2 } // 错误:{1, 2} 不是表达式
 
    // auto 常用于无名类型, 例如 lambda 表达式的类型
    auto lambda = [](int x) { return x + 3; };
 
//  auto int x; // 于 C++98 合法, C++11 起错误
//  auto x;     // 于 C 合法, 于 C++ 错误
}
decltype 的用处则是检查实体的声明类型, 或者表达式的类型和值的类型. 用法如下:decltype(实体/表达式). 可以使用另一个的实体的类型来定义新的变量. 
#include <iostream>
 
struct A { double x; };
const A* a;
 
decltype(a->x) y;       // y 的类型是 double(其声明类型)
decltype((a->x)) z = y; // z 的类型是 const double&(左值表达式)
 
template<typename T, typename U>
auto add(T t, U u) -> decltype(t + u) // 返回类型依赖于模板形参
{                                     // C++14 开始可以推导返回类型
    return t+u;
}
 
int main() 
{
    int i = 33;
    decltype(i) j = i * 2;
 
    std::cout << "i = " << i << ", "
              << "j = " << j << '\n';
 
    auto f = [](int a, int b) -> int
    {
        return a * b;
    };
 
    decltype(f) g = f; // lambda 的类型是独有且无名的
    i = f(2, 2);
    j = g(3, 3);
 
    std::cout << "i = " << i << ", "
              << "j = " << j << '\n';
}

## 函数返回值后置
可以通过这种写法, 将函数的返回值申明放在函数声明的最后;auto function_name( 形参 ) (属性, 如 override等) (异常说明, 可选) -> 返回值类型. 
老实说, 这种写法让我觉得自己写的不是C++, 估计大部分情况我不回去使用这个特性吧. . . 
// 返回指向 f0 的指针的函数
auto fp11() -> void(*)(const std::string&)
{
    return f0;
}

## 强制类型转换
C++11起已经不建议使用C语言样式的强制类型转换, 推荐使用static_cast, const_cast, reinterpret_cast, dynamic_cast等方法的类型转换. 
关键词	说明
static_cast (常用)	用于良性转换, 一般不会导致意外发生, 风险很低. 
const_cast	用于 const 与非 const, volatile 与非 volatile 之间的转换. 
reinterpret_cast	高度危险的转换, 这种转换仅仅是对二进制位的重新解释, 不会借助已有的转换规则对数据进行调整, 但是可以实现最灵活的 C++ 类型转换. 
dynamic_cast	借助 RTTI, 用于类型安全的向下转型(Downcasting). 
C++四种类型转换运算符:static_cast, dynamic_cast, const_cast和reinterpret_cast

## 智能指针
参见C++ 智能指针
## 一些新的关键词用法
### nullptr
据说通常C++头文件中NULL都是定义为#define NULL 0, 因此本质上NULL的类型是int, 使用NULL来表示空指针是非常不合适的行为, 于是C++11重新定义了一个不是int类型且适用于空指针的关键词. 
关键词 nullptr 代表指针字面量. 它是 std::nullptr_t 类型的纯右值. 存在从 nullptr 到任何指针类型及任何成员指针类型的隐式转换. 同样的转换对于任何空指针常量也存在, 空指针常量包括 std::nullptr_t 的值, 以及宏 NULL. nullptr, 指针字面量
特殊成员函数
1.默认构造函数
2.复制构造函数
3.移动构造函数 (C++11 起)
4.复制赋值运算符
5.移动赋值运算符 (C++11 起)
6.析构函数
### default
我们知道default本身是switch语句的关键词, C++11中又扩展了新的用法, 可以用来告诉编译器生成默认的成员函数(默认构造函数等). 
特殊成员函数以及比较运算符 (C++20 起)是仅有能被预置的函数, 即使用 = default 替代函数体进行定义(细节见其相应页面)
例如:默认构造函数可以使用 类名 ( ) = default ; (C++11 起) 方式声明, 然后可以不用在 *.cpp文件中写函数体实现, 这个函数会使用编译器默认生成. 
### delete 弃置函数
delete的新用法–弃置函数, 相比于让对象中的构造函数为私有, 现在有了删除该函数的方法. 
如果取代函数体而使用特殊语法 = delete ;, 则该函数被定义为弃置的(deleted). 任何弃置函数的使用都是非良构的(程序无法编译). 这包含调用, 包括显式(以函数调用运算符)及隐式(对弃置的重载运算符, 特殊成员函数, 分配函数等的调用), 构成指向弃置函数的指针或成员指针, 甚或是在不求值表达式中使用弃置函数. 但是, 允许隐式 ODR 式使用 刚好被弃置的非纯虚成员函数. 
struct sometype
{
    void* operator new(std::size_t) = delete;
    void* operator new[](std::size_t) = delete;
};
sometype* p = new sometype; // 错误:尝试调用弃置的 sometype::operator new
### override
这个关键词翻译为改写, 当指定一个虚函数覆盖另一个虚函数时使用, Effective Modern C++一书中建议在该情况时一定加上该关键词, 这样可以让编译器帮助我们检查我们是否正确定义了覆盖的函数(如果不正确定义则会编译报错). 
这部分代码将不会正确编译, 因为加了 override 后, 编译器会为我们寻找继承的基类中对应的虚函数, 而这里就可以发现我们函数声明上的一些错误. 而如果不加override, 这里会成功编译, 但绝对不是我们想要的编译结果. 
/*
 * Key idea:
 *
 *   The below code won't compile, but, when written this way, compilers will
 *   kvetch about all the overriding-related problems.
 */

class Base {
public:
  virtual void mf1() const;
  virtual void mf2(int x);
  virtual void mf3() &;
  void mf4() const;
};

// Uncomment this, compile and see the compiler errors.
//class Derived: public Base {
//public:
//  virtual void mf1() override;
//  virtual void mf2(unsigned int x) override;
//  virtual void mf3() && override;
//  void mf4() const override;
//};
可以只有override修饰的函数声明正确才能够成功编译. 
/*
 * Key idea:
 *
 *   This the code-example that uses override and is correct.
 */

class Base {
public:
  virtual void mf1() const;
  virtual void mf2(int x);
  virtual void mf3() &;
  virtual void mf4() const;
};

class Derived: public Base {
public:
  virtual void mf1() const override;
  virtual void mf2(int x) override;
  virtual void mf3() & override;
  void mf4() const override;         // adding "virtual" is OK,
};                                   // but not necessary
### final
声明某一个虚函数不得被覆盖. 
### ( ), { }初始化
有更多的方法初始化一个对象, 比如花括号初始化列表实例如下:
/*
 * Key idea:
 *
 *   The treatment of braced initializers is the only way in which auto type
 *   deduction and template type deduction differ.
 */

#include <initializer_list>

template<typename T>  // template with parameter
void f(T param) {}    // declaration equivalent to
                      // x's declaration

template<typename T>
void f2(std::initializer_list<T> initList) {}

int main()
{
  {
    int x1 = 27;
    int x2(27);
    int x3 = {27};
    int x4{27};
  }

  {
    auto x1 = 27;    // type is int, value is 27
    auto x2(27);     // ditto
    auto x3 = {27};  // type is std::initializer_list<int>,
                     // value is {27}
    auto x4{27};     // ditto

    //auto x5 = {1, 2, 3.0};  // error! can't deduce T for
    //                        // std::initializer_list<T>
  }

  {
    auto x = { 11, 23, 9 };  // x's type is
                             // std::initializer_list<int>

    //f({ 11, 23, 9 });        // error! can't deduce type for T

    f2({ 11, 23, 9 });        // T deduced as int, and initList's
                              // type is std::initializer_list<int>
  }
}
### using 别名
除了 typedef关键词, 还可以使用using关键词创建别名, Effective Modern C++一书更推荐使用别名声明. 
/*
 * Key Idea:
 *
 *   Using alias declarations is easier to read than function pointers.
 */

#include <string>

// FP is a synonym for a pointer to a function taking an int and
// a const std::string& and returning nothing
typedef void (*FP)(int, const std::string&);    // typedef

// same meaning as above
using FP = void (*)(int, const std::string&);   // alias
                                                // declaration

### 限定作用域的 枚举类型
通过在枚举类型定义中加一个关键词, 可以限制枚举类型的作用域. enum test-> enum class test;
/*
 * Key Idea:
 *
 *   In C++11, the names of scoped enums do not belong to the scope containing
 *   the enum.
 */

enum class Color { black, white, red };  // black, white, red
                                         // are scoped to Color

auto white = false;              // fine, no other
                                 // "white" in scope

//Color c1 = white;                 // error! no enumerator named
                                 // "white" is in this scope

Color c2 = Color::white;          // fine

auto c3 = Color::white;           // also fine (and in accord
                                 // with Item4's advice)
### 基于范围的for循环
C++也可以像python语言那样使用基于范围的for循环了, 是一个进步吧, 集各家之所长. 
基于范围的for循环语法是for(范围声明:范围表达式). 其中, 范围声明:一个具名变量的声明, 其类型是由 范围表达式 所表示的序列的元素的类型, 或该类型的引用, 通常用 auto 说明符进行自动类型推导;范围表达式:任何可以表示一个合适的序列(数组, 或定义了 begin 和 end 成员函数或自由函数的对象, 见下文)的表达式, 或一个花括号初始化器列表, 基本上std中几个常见容器, 如:vector, list等都是支持基于范围的for循环的. 
#include <iostream>
#include <vector>
 
int main() {
    std::vector<int> v = {0, 1, 2, 3, 4, 5};
 
    for (const int& i : v) // 以 const 引用访问
        std::cout << i << ' ';
    std::cout << '\n';
 
    for (auto i : v) // 以值访问, i 的类型是 int
        std::cout << i << ' ';
    std::cout << '\n';
 
    for (auto& i : v) // 以引用访问, i 的类型是 int&
        std::cout << i << ' ';
    std::cout << '\n';
 
    for (int n : {0, 1, 2, 3, 4, 5}) // 初始化器可以是花括号初始化器列表
        std::cout << n << ' ';
    std::cout << '\n';
 
    int a[] = {0, 1, 2, 3, 4, 5};
    for (int n : a) // 初始化器可以是数组
        std::cout << n << ' ';
    std::cout << '\n';
 
    for (int n : a)  
        std::cout << 1 << ' '; // 不必使用循环变量
    std::cout << '\n';
 
}

### lambda 表达式
lambda 表达式即是无名函数, 很像java中的临时函数(集各家之所长, 比各家难用……)
lambda的语法如下:
[ 俘获 ] <模板形参>(可选)(C++20) ( 形参 ) 说明符(可选) 异常说明 attr -> ret requires(可选)(C++20) { 函数体 }	
[ 俘获 ] ( 形参 ) -> ret { 函数体 }	
[ 俘获 ] ( 形参 ) { 函数体 }	
[ 俘获 ] { 函数体 }	
lambda 表达式细节更多, 有可能单独写一个博客进行解释说明, 如果大家有兴趣的话, 可以先看看zh.cppreference.com这篇说明. 



# 低延迟

低延迟系统的 11 个最佳实践
英文原文:11 Best Practices for Low Latency Systems
自从Google发布额外的一个500ms延迟将减少20%的流量以及亚马逊发现额外的100ms延迟会使销售量下降1%已经8年了. 此后, 开发者们一直奋战在延迟曲线的底部, 甚至前端开发者们都在压缩JavaScript, CSS以及HTML来争取分毫时间. 以下是各种低延迟系统设计时需牢记在心的最佳实践的一个概览. 大多数这些建议考虑的是逻辑上极端, 可以权衡使用. (感谢在Quora上问这个问题的匿名用户, 这让我把我的想法写了下来). 
选择正确的语言
脚本语言不要使用, 尽管它们越来越快, 当你处理关键事务像拿掉进程的最后几毫秒时间时, 你处理不掉解释型语言的开销. 此外, 你会想要一个强有力的记忆模型来进行无锁编程, 所以你应该看Java, Scala, C++11或Go. 
把一切放在内存里
I/O会是延迟主因, 所以确保你的所有数据在内存中. 这通常意味着管理内存中的数据结构以及维护现有记录, 这样你在重启机器或进程后能够重建之前的状态. 维持记录的选择包括Bitcask, Krati, LevelDB和BDB-JE. 或者你也可以本地运行一个像redis或MongoDB(memory >> data)这样的内存型数据库. 但需要注意的是, 在它们后台同步数据到硬盘crash时你仍旧可能丢失一些数据. 
确保数据和处理程序的位置
网络跳数比磁盘寻道要快, 但即使这样通过网络也会增加很多开销. 理想情况下, 数据应当完全在主机的内存中. 像AWS云中几乎提供了1/4TB的内存, 物理服务器提供多个TB现在也很常见. 如果你需要运行在多个主机上, 你应当确保数据和请求被适当的划分, 使得在服务请求时所有必要的数据都在本地. 
保持系统未充分使用
低延迟总是需要有资源来处理新的请求. 不要试图运行到你的软硬件资源的极限. 总要有一些峰值储备用于突发情况. 
保证内容切换最小化
内容切换是你正在运行的计算工作超过你拥有的资源的一个信号. 你需要限制你的线程数使之与你系统的内核数相匹配, 确保每个线程与它的主线程相关联. 
确保读操作的连续性
各种形式的存储, 无沦是轮转式的, 还是基于闪存的或内存的, 顺序使用的时候, 它们的性能都会好一些. 当进行内存的连续读操作时, 你将会触发RAM级和CPU缓存级的预读处理. 如果预读操作顺利的完成, 那么下一步所需的数据在使用前都已在L1级的缓存中. 促进这一处理的简便方法是:大量的使用原始数据类型的或结构体数组. 不惜一切代价避免使用基于链表或者对象数组的随动指针. 
批量处理写入操作
这个听起来有背常理, 但是你可以通过批量处理写操作获得明显的性能提升. 然而, 总有一些错觉:这就意味着在写入操作前系统需要等待任意的时间. 相反地, 线程在做输入/输出操作时会紧凑地循环. 每次写操作都会在上一次操作完成后对到达的数据批量的处理. 这种机制确保了系统快速的响应和良好的适应性. 
优化缓存
在各个位置的优化中, 内存的快速访问成了瓶颈. 把线程与它们的主线性相关联有助于降低CPU缓存污染;连续性输入/输出处理, 同样有利于缓存中的预加载. 除此之外, 你可以使用基本数据类型来降低内存的占用量, 这样就可以有更多的数据加载到高速缓存中. 另外你可参阅高速缓存参数无关算法, 它通过递归的分解数据直到数据与缓存大小匹配, 然后进行所需的处理. 
尽可能多的使用非阻塞模式
使用非阻塞模式并使用不受约束的数据结构和算法. 每次你在使用锁时都要深入到栈的操作系统层去处理锁, 这是件令人头痛的事. 通常如果你知道自己正在做什么, 你得理解JVM, C++或者Go的内存模型才可以去应付锁的相关处理. 
尽可能多的使用异步
任何处理特别是不需要创建响应输入/输出处理应当在关键路径之外处理. 
尽可能多的并行处理
任何处理特别是可以并行操作的输入/输出处理应当并行的处理. 例如你的高可用性策略包括把在磁盘中写入事务日志和把事务发送到二级服务器, 这些动作都查可以并行处理的. 

在金融衍生品市场中, 做市商( Market Maker )肩负着为期权期货产品报价( Quoting )的义务. "低延迟"对于这类公司而言至关重要, 如果你的速度比别人快, 同样的报价就可以优先成交, 错误报价可以快速撤回, 还可以抓市场上的错误定价进行套利. 显然, 人工下单肯定不可行, 而且面对种类繁多的产品, 人工报价容很易出现失误, 所以我们需要开发交易系统来实现"低延迟". 
如今, 大部分衍生品交易系统都是用 C++实现, 这固然与 C++的一些优良特性密不可分, 当然也有历史方面的原因. 金融衍生品大约发展成熟于 20 世纪 80 年代, 当时世界上主流的编程语言有 C, C++, Fortran 等. 现在 C++主要的竞争对手 Java 和 C#都还没有出现. 而 C 和 Fortran 并不太适合写大型程序, 所以, C++在衍生品交易领域就成了主流的选择. 
我们再来了解一下 C++的历史. 它发明于 20 世纪 80 年代, 大约经历了三个发展阶段. 第一阶段因为跟 C 有很好的兼容性, 效率与 C 接近, 而且还面向对象, 在工业界中占据了相当大的份额. 第二阶段由于标准模板库( STL )和 Boost 的出现, 泛型程序设计占据了越来越多的比重. 同一时期由于 Java,C#等的兴起, 抢走了 C++的部分市场. 第三阶段至今, 模板元编程以及新特性的加入使得 C++重新焕发活力, 同时也变得更为复杂. 
C++相比于虚拟机语言 Java 和 C#, 它直接把源程序编译为机器码, 同时可以在编译及链接期间进行优化, 以获得性能的提升. 相比于动态语言 Python 和 Lua, 它减少了运行时的动态类型检测. 因为 C++没有垃圾回收(GarbageCollection)机制, 所以不用担心延迟的不确定性. 又因为它能直接编译成机器码, 可以做底层优化, 例如使用内部函数和嵌入汇编语言. 
此外, C++做并行计算也相对比较容易, 比如可以直接用 CUDA. 但是 C++也存在诸多问题, 比如编译链接速度慢且容易出错, 缺乏其他语言常见功能的支持, 开发效率低等等. 但是 C++也一直在发展, 相信越来越多的问题会得到解决. 所以, 如果你想开发高性能的服务器程序, 那么 C++是一个很好的选择. 
但是, 低延迟与 C++并不能划等号. 有些公司用经过优化的 JVM, 用稍显小众的 Ocaml, Haskell, Erlang 等语言实现交易系统, 也有不输 C++的性能. 与整体系统架构设计相比, 编程语言的影响并没有那么大. 交易公司也会租用交易所的机位, 用光纤直连, 以及把不需要经常变动的部分用硬件实现等等来降低延迟
综上所言, C++在交易系统中的广泛运用既有历史原因, 也跟自身的特性密不可分. 随着信息技术的发展, C++也将在金融交易市场中扮演着日益重要的角色. 

要控制和降低延迟, 首先要能准确测量延迟, 因此需要比较准的钟, 每个机房配几个带GPS和/或原子钟primary standard的NTP服务器是少不了的. 而且就算用了NTP, 同一机房两台机器的时间也会有毫秒级的差异, 计算延迟的时候, 两台机器的时间戳不能直接相减, 因为不在同一时钟域. 解决办法是设法补偿这个时差. 另外, 不仅要测量平均延迟, 更重要的是要测量并控制长尾延迟, 即99百分位数或99.9百分位数的延迟, 就算是sell side, 系统偶尔慢一下被speculator利用了也是要亏钱的. 
普通的C++服务程序, 内部延迟(从进程收到消息到进程发出消息)做到几百微秒(即亚毫秒级)是不需要特殊的努力的. 没什么忌讳, 该怎么写就怎么写, 不犯低级错误就行. 我很纳闷国内流传的写 C++ 服务程序时的那些"讲究"是怎么来的(而且还不是 latency critical 的服务程序). 如果瓶颈在CPU, 那么最有效的优化方式是"强度消减", 即不在于怎么做得快, 而在于怎么做得少. 哪些可以不用做, 哪些可以不提前做, 哪些做一次就可以缓存起来用一阵子, 这些都是值得考虑的. 
网络延迟分传输延迟和惯性延迟, 通常局域网内以后者为主, 广域网以前者为主. 前者是传送1字节消息的基本延迟, 大致跟距离成正比, 千兆局域网单程是近百微秒, 伦敦到纽约是几十毫秒. 这个延迟受物理定律限制, 优化办法是买更好的网络设备和租更短的线路(或者想办法把光速调大, 据说 Jeff Dean 干过). 惯性延迟跟消息大小成正比, 跟网络带宽成反比, 千兆网TCP有效带宽按115MB/s估算, 那么发送1150字节的消息从第1个字节离开本机网卡到第1150个字节离开本机网卡至少需要 10us, 这是无法降低的, 因此必要的话可以减小消息长度. 举例来说, 要发10k的消息, 先花20us CPU时间, 压缩到3k, 接收端再花10us解压缩, 一共"60us+传输延迟", 这比直接发送10k消息花"100us+传输延迟"要快一点点. (广域网是否也适用这个办法取决于带宽和延迟的大小, 不难估算的. )
延迟和吞吐量是矛盾的, 通常吞吐量上去了延迟也会跟着飚上去, 因此控制负载是控制延迟的重要手段. 延迟跟吞吐量的关系通常是个U型曲线, 吞吐量接近0的时候延迟反而比较高, 因为系统比较"冷";吞吐量上去一些, 平均延迟会降到正常水平, 这时系统是"温"的;吞吐量再上去一些, 延迟缓慢上升, 系统是"热"的;吞吐量过了某个临界点, 延迟开始飙升, 系统是"烫"的, 还可能"冒烟". 因此要做的是把吞吐量控制在"温"和"热"的范围, 不要"烫", 也不要太冷. 系统启动之后要"预热". 
延迟和资源使用率是矛盾的, 做高吞吐的服务程序, 恨不得把CPU和IO都跑满, 资源都用完. 而低延迟的服务程序的资源占用率通常低得可怜, 让人认为闲着没干什么事, 可以再"加码", 要抵住这种压力. 就算系统到了前面说的"发烫"的程度, 其资源使用率也远没有到 100%. 实际上平时资源使用率低是为了准备应付突发请求, 请求或消息一来就可以立刻得到处理, 尽量少排队, "排队"就意味着等待, 等待就意味着长延迟. 消除等待是最直接有效的降低延迟的办法, 靠的就是富裕的容量. 有时候队列的长度也可以作为系统的性能指标, 而不仅仅是CPU使用率和网络带宽使用率. 另外, 队列也可能是隐式的, 比如操作系统和网络设备的网络输入输出 buffer 也算是队列. 
延迟和可靠传输也是矛盾的, TCP做到可靠传输的办法是超时重传, 一旦发生重传, 几百毫秒的延迟就搭进去了, 因此保持网络随时畅通, 避免拥塞也是控制延迟的必要手段. 要注意不要让batch job抢serving job的带宽, 比方说把服务器上的日志文件拷到备份存储, 这件事不要在繁忙交易时段做. QoS也是办法;或者布两套网, 每台机器两个网口, 两个IP. 
最后, 设法保证关键服务进程的资源充裕, 避免侵占(主要是CPU和网络带宽). 比如把服务器的日志文件拷到别的机器会占用网络带宽, 一个办法是慢速拷贝, 写个程序, 故意降低拷贝速度, 每50毫秒拷贝50kB, 这样用时间换带宽. 还可以先压缩再拷贝, 比如gzip压缩100MB的服务器日志文件需要1秒, 在生产服务器上会短期占满1个core的CPU资源, 可能造成延迟波动. 可以考虑写个慢速压缩的程序, 每100毫秒压缩100kB, 花一分半钟压缩完100MB数据, 分散了CPU资源使用, 减少对延迟的影响. 千万不要为了加快压缩速度, 采用多线程并发的办法, 这就喧宾夺主了. 


## Linux 下C++开发

本文目的是针对将熟悉C/C++语法, 如何在Linux下进行的C/C++开发的入门指南. Linux下的开发和在Windows下的开发类似, 主要区别点在于操作系统不同, 开发工具, 开发API, 编译调试方法不一样, 故主要将针对这些不同点进行阐述, 使在Windows开发的程序员能够入门Linux下C++ 开发的行列中. 
###  一 涉及技术以及开发工具
1, 工具
1.1 Linux环境
首先, 你得有一台Linux机器, 目前的开发环境是10.88.115.114, 机器需要安装g++/gcc编译器环境, 文本编辑器, 如vim等, 一般安装操作系统会安装好, 如果系统没有需要自行安装. 
输入g++ -v 查看本机是否安装g++环境
安装方式有两种, YUM安装和源代码安装方式. 推荐使用YUM安装方式. 
Yum安装可以自动解决库依赖问题, 所以推荐使用. YUM安装g++:
yum list gcc-c++
yum install gcc-c++.i686
自动安装即可. 
另外开发过程中, 需要调试, 故Linux机器也需要安装gdb调试工具. 
Gdb安装方式类似:
yum install gdb
1.2 Windows工具
Linux下的开发一般不是直接在Linux下进行开发, 当然如何愿意也是可以的, 可以直接使用VIM进行开发. 但是需要很长的时间熟练使用VIM的快捷键, 对于入门开发来说过于困难, 故直接在Windows下开发者居多. 在Windows下开发Linux下应用主要使用的工具如下:
(1)Xshell, 用于连接Linux主机, 可以使用free for school版本, 百度一下安装即可
最后可以配置成如下简洁界面, 让人感觉轻松大气. 
Alt+Ctrl+F组合键可以弹出文件传输界面, 开发和升级的时候, 在Linux和Windows之间进行文件传输. 如图所示. 
(2)Code::Blocks
在Windows下将源代码从linux下拉来后, 需要在本地进行开发. 可以直接使用文本编辑器开发, 但是缺少关键字高亮, 函数跳转等功能, 开发起来比较困难. 故需要使用到IDE工具. 下面介绍3款工具. 
第一款, Code::Blocks, 这一款比较推荐, 在Windows和Linux下都有版本. 新建工程, File->New->Project,将代码加入工程后即可进行开发, 可以关键字高亮, 函数跳转, 函数引用列表等功能. 主要缺点是开发好的代码需要上传到Linux开发机器上进行编译调试. 
第二款, Source Insight
Source Insight使用较广, 使用方式和Code::Blocks基本一致, 只是快捷键不一致. 缺点同样是需要把文件上传后编译开发. 
第三款, Eclipse+RSE插件
Eclipse安装Remote System Explorer插件后, 可以直接连上linux的机器, 对机器上的代码进行直接编辑开发, 此种开发的模式优点是不需要对代码文件上传, 缺点是对函数跳转, 查找等功能很欠缺, 基本上相当于文件编辑模式. 
上面三种IDE都可以进行Linux下C++的开发, 但是编译链接调试依然是在Linux环境下进行. 所以可以根据各自的优缺点进行选择. 
1.3 Linux下技术
Linux下开发的基本技能要求如下:
熟悉Linux下基本命令:
cp /rm/ find/cd/ll/mkdir 等等
熟悉Makefile文件编写
开源库搜索与安装yum
调试工具gdb的使用
Linux API
下面将详细讲解这些技术的使用. 
###  二 Demo开发及发布
至此, Linux下环境的开发工具齐全了, 下面开始从头开始搭建工程. 
(1)创建工程
登录开发机器115.114, 新建目录Demo,进入该目录:
cd /home/
mkdir Demo
cd Demo
(2)新建文件
新建3个文件
分别输入如下内容
1. print.h
#include<stdio.h>
void printHello();
2. print.c
#include"print.h"
void printHello(){
printf("Hello, world\n");
}
3. main.c
#include "print.h"
int main(void){
printHello();
return 0;
}
(3)创建MakeFile文件
helloworld:main.o print.o
g++ -o helloworld main.o print.o
g++ -c main.c
print.o:print.cprint.h
g++ -c print.c
clean: rmhelloworld main.o print.o
其中makefile的撰写是基于规则的, 当然这个规则也是很简单的, 就是:
target (生成的对象): prerequisites(生成对象的依赖条件)
command  //任意的shell 命令                                        
如helloworld:main.o print.o
g++ -o helloworld main.o print.o
需要生成可执行文件helloworld, 则需要依赖main.o print.o 文件, 即使用g++ -o helloword main.o print.o生成helloword, 
其中-o 生成的可执行文件名称, main.o print.o是已经生成好的两个文件对象. 
接下来, 
main.o:main.cprint.h
g++ -c main.c
即main.o的生成由main.c和 print.h编译得来, 即执行g++ -c main.c命令生成. 以此类推. 当然如果在项目源文件和头文件都比较多的情况下, 采用该种编写方式会比较繁琐且容易出错, 故可以使用Makefile中的一些函数进行自动编译. 可参考Makefile的相关教程. 
其中clean的命令是删除文件helloworld main.o print.o, 写好此文件后, make clean 可以实现将生成的文件删除从而可以再次进行编译. 
(4)编译执行
发好了源文件以及MakeFile文件后, 接下来可以进行编译运行. 在当前目录先执行make命令;
可以看到Makefile中的命令都已经执行, 查看当前目录ls;
可以看到生成了可执行文件helloworld和中间过程文件main.o,print.o. 
输入命令./helloworld后可以看到界面打印出了hello world字样. 
###  三 调试测试开发
程序开发必定需要进行调试开发. 在Linux下开发调试主要依靠GDB工具. 
首先, 编译的时候需要在编译命令中加入-g选项, 这样保证调试的时候可以打印出源代码. 
添加-g,修改Makefile文件之后, 重新编译make ,可以看到编译命令中多出了-g. 
进入调试模式, gdb helloworld
gdb的命令很多, gdb把之分成许多个种类. help命令只是例出gdb的命令种类, 如果要看种类中的命令, 可以使用help <class> 命令, 如:help breakpoints, 查看设置断点的所有命令. 也可以直接help <command>来查看命令的帮助. 
l+函数名称可以查看函数源码
设置断点, 输入命令
b 3
则再文件main的第三行设置了断点. 
如果需要设置其他文件中的函数断点, 可以如图设置, 即文件名加函数名称, 或者函数行数即可
Info break 命令即可查看当前设置的所有断点. 
输入命令r, 调试运行程序开始. 程序卡在第一个断点的位置上. 此时输入命令 s, 即可进入该函数里面进行调试, 输入命令l即可查看当前函数的源代码;
输入命令n可以进行单步执行;
输入 p+变量名 可以打印当前变量的值;
输入命令q退出调试;
Gdb 命令丰富多彩, 目前介绍的只是最基本的命令, 但是针对一般的调试已经足够, 需要用户自己不断的学习发掘才能最大限度的使用gdb的好处.   
四, 高阶Demo开发
接下来介绍一个进阶版开发教程. 主要从头开始搭建一个包含一些功能模块的项目. 本Demo主要包括日志打印, 配置文件读取, UDP端口监听, 开启线程等功能. 
(1)新建工程目录
mkdir HighDemo
然后创建cpp,.h文件
其中base64主要用来进行base64编码解码, comm_codec主要用来通用的解析XML, 格式转换等函数集合, config主要用来加载配置文件config.xml, LogClinet主要用来打印日志文件, strtok_r主要用来字符串切割, 其中NetFrame是包含main方法的主线程文件. 创建完了CPP和头文件之后, 将创建Makefile文件. 
(2)Makefile文件编写
进阶版的Makefile, 先从两个函数可以讲起. 函数Wildcard和函数patsubst. 
"$(wildcard *.cpp)"来获取工作目录下的所有的.cpp文件列表
以使用"$(patsubst %.cpp,%.o,$(wildcard *.cpp))", 首先使用"wildcard"函数获取工作目录下的.cpp文件列表;之后将列表中所有文件名的后缀.c替换为.o. 这样我们就可以得到在当前目录可生成的.o文件列表. 
三个变量分别是$@, $^, $<代表的意义分别是:
$@--目标文件, 
$^--所有的依赖文件, 
$<--第一个依赖文件. 
所以本项目的Makefile文件写成如下
TARGET=NetFrame
CC=g++
INCLUDES+=-I./include   -I/usr/local/src/oracle/10g/rdbms/public-I/usr/include/libxml2 -I/usr/local/ssl/include -I/usr/local/include
LIB=-lstdc++-lpthread -lrt -L/usr/local/src/oracle/10g/lib -lclntsh   -L/usr/lib64 -lxml2-L/usr/local/ssl/lib -lcrypto
OBJS:=$(patsubst %.cpp,%.o,$(wildcard *.cpp))
$(TARGET):${OBJS}
$(CC) $^ $(LIB)  -o $@
.cpp.o:
$(CC) $(FLAGS) $(INCLUDES)  -o $@ -c $<
clean:
rm-rf $(TARGET)
rm-f $(OBJS)
输入命令
make
则生成可执行文件NetFrame
INCLUDES和LIB主要是使用到的库头文件和动态库或者静态库文件的路径, 包含进来即可. 如果使用了新的开源库, 则需要安装以及查找对应的库路径添加进来. 
如需要使用libcurl库, 则yum search curl
找到curl-devel.x86_64, 再yum install curl-devel.x86_64 安装即可
之后如果你不确定动态库被安装到哪里去了, 可以输入如下命令:
find / -name libcurl*, 如图
(3)Main文件编写
编写NetFrame.cpp文件. 
首先导入相关头文件, 其中<>表示引用的是编译器的类库路径里面的头文件" "引用的是你程序目录的相对路径中的头文件, 设置一下常量(最好放在头文件里). 
之后定义Main函数, 调用各个模块的函数接口实现对应的功能, 如调用日志函数打印日志, 调用配置文件解析配置, 获取配置文件中的参数功能. 
另外开启一条线程, 进行UDP的监听操作, 开启的端口和IP从配置文件中读取. 
该线程实现的功能也很简单, 用户发送指定格式的UDP包, 系统收到报文后, 解析报文内容进行返回数据或者重新加载配置文件等等. 
输入命令./NerFrame命令启动进程. 
另开一个窗口, 输入测试数据
echo "task=reload&msg=pleasereload"|nc -u 127.0.0.1 9999
可以看到返回了msg里面的内容
服务端重新加载了配置文件. 
至此, 高阶版Linux下C/C++开发指南介绍完毕, 从头开始实践可以把一个熟悉C/C++语法的程序员带入Linux的世界中. 
另外, 由于是在Linux下开发, 所以需要熟悉Linux的系统函数, 这些系统函数是在程序中大量使用到, 如open,close,recvfrom等等, 推荐一本书<UNIX操作系统设计>, 可以学习很多操作系统的API, 对于程序开发有很大的帮助. 另外如果对Linux内核有兴趣的可以学习<深入理解Linux内核>

## Linux c++ gdb常用调试
进程调试
自己写的代码, 直接gdb r/bt就可以了. 
正在运行的进程, 先ps ax找到进程id. 然后gdb进入之后attach 进程id. stop/continue暂停和继续进程. 
core了, 有core文件, 就直接gdb core文件. 
线程调试
https://stackoverflow.com/questions/7698209/tracing-pthreads-in-linux
strace works for threads as well. Use strace -f to strace all threads.
To strace only a particular thread, you first have to find its tid (thread id). Threads have thread id's that's really a pid (process id)
Once you know the pid of the thread, use strace -p the_pid to strace that thread.
用strace也是可以跟踪线程的, 先找到线程id. 
1 ls proc/进程id/task/
然后就可以用
1 strace -p 线程id
也可以用gdb. attch之后, info threads;thread thread_no: 进入线程xx, 通常紧接而来的是 bt/f 命令;
http://blog.51cto.com/huangfu3342/1609574
内存泄漏
可以用valgrind
今天还学到一招, 可以用pmap -p pid查看内存镜像. 然后把内存dump出来. dump内存操作如下:
gdb -p pid, 先用gdb挂到运行的进程3. 
再执行gdb的dump命令, dump binary memory 导出文件名 导出内存起始地址 导出内存结束地址. 
再根据dump出的内存内容反推是哪里出了问题. 
性能分析
用perf加火焰图. 
https://www.cnblogs.com/linyx/p/10031195.html

## Linux core 文件
1. core文件的简单介绍
在一个程序崩溃时, 它一般会在指定目录下生成一个core文件. core文件仅仅是一个内存映象(同时加上调试信息), 主要是用来调试的. 
2. 开启或关闭core文件的生成
用以下命令来阻止系统生成core文件:
ulimit -c 0
下面的命令可以检查生成core文件的选项是否打开:
ulimit -a
该命令将显示所有的用户定制, 其中选项-a代表"all". 
也可以修改系统文件来调整core选项
在/etc/profile通常会有这样一句话来禁止产生core文件, 通常这种设置是合理的:
# No core files by default
ulimit -S -c 0 > /dev/null 2>&1
但是在开发过程中有时为了调试问题, 还是需要在特定的用户环境下打开core文件产生的设置
在用户的~/.bash_profile里加上ulimit -c unlimited来让特定的用户可以产生core文件
如果ulimit -c 0 则也是禁止产生core文件, 而ulimit -c 1024则限制产生的core文件的大小不能超过1024kb
3. 设置Core Dump的核心转储文件目录和命名规则
/proc/sys/kernel/core_uses_pid可以控制产生的core文件的文件名中是否添加pid作为扩展, 如果添加则文件内容为1, 否则为0
/proc/sys/kernel/core_pattern可以设置格式化的core文件保存位置或文件名, 比如原来文件内容是core-%e
可以这样修改:
echo "/corefile/core-%e-%p-%t" > /proc/sys/kernel/core_pattern
将会控制所产生的core文件会存放到/corefile目录下, 产生的文件名为core-命令名-pid-时间戳
以下是参数列表:
%p - insert pid into filename 添加pid
%u - insert current uid into filename 添加当前uid
%g - insert current gid into filename 添加当前gid
%s - insert signal that caused the coredump into the filename 添加导致产生core的信号
%t - insert UNIX time that the coredump occurred into filename 添加core文件生成时的unix时间
%h - insert hostname where the coredump happened into filename 添加主机名
%e - insert coredumping executable name into filename 添加命令名
4. 使用core文件
在core文件所在目录下键入:
gdb -c core
它会启动GNU的调试器, 来调试core文件, 并且会显示生成此core文件的程序名, 中止此程序的信号等等
如果你已经知道是由什么程序生成此core文件的, 比如MyServer崩溃了生成core.12345, 那么用此指令调试:
gdb -c core MyServer
以下怎么办就该去学习gdb的使用了
5. 一个小方法来测试产生core文件
直接输入指令:
kill -s SIGSEGV $$
6. 为何有时程序Down了, 却没生成 Core文件. 
Linux下, 有一些设置, 标明了resources available to the shell and to processes.  可以使用
#ulimit -a 来看这些设置.  (ulimit是bash built-in Command)
-a     All current limits are reported
-c     The maximum size of core files created
-d     The maximum size of a process鈥檚 data segment
-e     The maximum scheduling priority ("nice")
-f     The maximum size of files written by the shell and its children
-i     The maximum number of pending signals
-l     The maximum size that may be locked into memory
-m     The maximum resident set size (has no effect on Linux)
-n     The maximum number of open file descriptors (most systems do not allow this value to be set)
-p     The pipe size in 512-byte blocks (this may not be set)
-q     The maximum number of bytes in POSIX message queues
-r     The maximum real-time scheduling priority
-s     The maximum stack size
-t     The maximum amount of cpu time in seconds
-u     The maximum number of processes available to a single user
-v     The maximum amount of virtual memory available to the shell
-x     The maximum number of file locks
从这里可以看出, 如果 -c是显示:core file size          (blocks, -c)
如果这个值为0, 则无法生成core文件. 所以可以使用:
#ulimit -c 1024 或者 #ulimit -c unlimited 来使能 core文件. 
如果程序出错时生成Core 文件, 则会显示Segmentation fault (core dumped). 
7. Core Dump的核心转储文件目录和命名规则:
/proc/sys/kernel/core_uses_pid可以控制产生的core文件的文件名中是否添加pid作为扩展, 如果添加则文件内容为1, 否则为0


# c++多进程编程
进程:进程是一个正在执行的程序, 是向CPU申请资源的, 进程之间数据相互独立, 一个进程至少有一个线程. 
线程:线程是进程中的单一的顺序控制流程也可以叫做最小控制单元, 线程是进程中执行单元, 开启一个线程比开启一个进程更加节省资源. 
多线程:多线程是多任务处理的一种特殊形式, 多任务处理允许让电脑同时运行两个或两个以上的程序. 一般情况下, 两种类型的多任务处理:基于进程和基于线程. 
多线程程序包含可以同时运行的两个或多个部分. 这样的程序中的每个部分称为一个线程, 每个线程定义了一个单独的执行路径. 
基于进程的多任务处理是程序的并发执行. 
基于线程的多任务处理是同一程序的片段的并发执行. 
线程
## 线程的优点
1, 创建一个新线程的代价要比创建一个新进程小得多
2, 与进程之间的切换相比, 线程之间的切换需要操作系统做的工作要少很多
3, 线程占用的资源要比进程少很多
4, 能充分利用多处理器的可并行数量
5, 在等待慢速I/O操作结束的同时, 程序可执行其他的计算任务
6, 计算密集型应用, 为了能在多处理器系统上运行, 将计算分解到多个线程中实现
7, I/O密集型应用, 为了提高性能, 将I/O操作重叠. 线程可以同时等待不同的I/O操作. 
## 线程的缺点
性能损失
一个很少被外部事件阻塞的计算密集型线程往往无法与共它线程共享同一个处理器. 如果计算密集型线程的数量比可用的处理器多, 那么可能会有较大的性能损失, 这里的性能损失指的是增加了额外的同步和调度开销, 而可用的资源不变. 
健壮性降低
编写多线程需要更全面更深入的考虑, 在一个多线程程序里, 因时间分配上的细微偏差或者因共享了不该共享的变量而造成不良影响的可能性是很大的, 换句话说线程之间是缺乏保护的. 
缺乏访问控制
进程是访问控制的基本粒度, 在一个线程中调用某些OS函数会对整个进程造成影响. 
编程难度提高
编写与调试一个多线程程序比单线程程序困难得多. 
## 创建线程
#include <pthread.h>
pthread_create (thread, attr, start_routine, arg) 
参数	描述
thread	指向线程标识符指针
attr	一个不透明的属性对象, 可以被用来设置线程属性. 您可以指定线程属性对象, 也可以使用默认值 NULL
start_routine	线程运行函数起始地址, 一旦线程被创建就会执行
arg	运行函数的参数. 它必须通过把引用作为指针强制转换为 void 类型进行传递. 如果没有传递参数, 则使用 NULL
创建线程成功时, 函数返回 0, 若返回值不为 0 则说明创建线程失败. 
## 终止线程
#include <pthread.h>
pthread_exit (status) 
在这里, pthread_exit 用于显式地退出一个线程. 通常情况下, pthread_exit() 函数是在线程完成工作后无需继续存在时被调用. 
如果 main() 是在它所创建的线程之前结束, 并通过 pthread_exit() 退出, 那么其他线程将继续执行. 否则, 它们将在 main() 结束时自动被终止. 
程序示例
#include <iostream>
// 必须的头文件
#include <pthread.h>
using namespace std; 
#define NUM_THREADS 5 
// 线程的运行函数
void* say_hello(void* args)
{
    cout << "Hello Runoob!" << endl;
    return 0;
}
int main()
{
    // 定义线程的 id 变量, 多个变量使用数组
    pthread_t tids[NUM_THREADS];
    for(int i = 0; i < NUM_THREADS; ++i)
    {
        //参数依次是:创建的线程id, 线程参数, 调用的函数, 传入的函数参数
        int ret = pthread_create(&tids[i], NULL, say_hello, NULL);
        if (ret != 0)
        {
           cout << "pthread_create error: error_code=" << ret << endl;
        }
    }
    //等各个线程退出后, 进程才结束, 否则进程强制结束了, 线程可能还没反应过来;
    pthread_exit(NULL);
}
g++ test.cpp -lpthread -o test        #linux编译指令
#include <iostream>
#include <cstdlib>
#include <pthread.h>
using namespace std; 
#define NUM_THREADS     5
void *PrintHello(void *threadid)
{  
   // 对传入的参数进行强制类型转换, 由无类型指针变为整形数指针, 然后再读取
   int tid = *((int*)threadid);
   cout << "Hello Runoob! 线程 ID, " << tid << endl;
   pthread_exit(NULL);
}
int main ()
{
   pthread_t threads[NUM_THREADS];
   int indexes[NUM_THREADS];// 用数组来保存i的值
   int rc;
   int i;
   for( i=0; i < NUM_THREADS; i++ ){      
      cout << "main() : 创建线程, " << i << endl;
      indexes[i] = i; //先保存i的值
      // 传入的时候必须强制转换为void* 类型, 即无类型指针        
      rc = pthread_create(&threads[i], NULL, 
                          PrintHello, (void *)&(indexes[i]));
      if (rc){
         cout << "Error:无法创建线程," << rc << endl;
         exit(-1);
      }
   }
   pthread_exit(NULL);
}
main() : 创建线程, 0
main() : 创建线程, 1
main() : 创建线程, 2
main() : 创建线程, 3
main() : 创建线程, Hello Runoob! 线程 ID, 0
4
Hello Runoob! 线程 ID, Hello Runoob! 线程 ID, 3
Hello Runoob! 线程 ID, 1
Hello Runoob! 线程 ID, 4
2
## 连接和分离线程
pthread_join (threadid, status) 
pthread_detach (threadid) 
pthread_join() 子程序阻碍调用程序, 直到指定的 threadid 线程终止为止. 当创建一个线程时, 它的某个属性会定义它是否是可连接的(joinable)或可分离的(detached). 只有创建时定义为可连接的线程才可以被连接. 如果线程创建时被定义为可分离的, 则它永远也不能被连接. 
#include <iostream>
#include <cstdlib>
#include <pthread.h>
#include <unistd.h>
 
using namespace std;
 
#define NUM_THREADS     5
 
void *wait(void *t)
{
   int i;
   long tid;
 
   tid = (long)t;
 
   sleep(1);
   cout << "Sleeping in thread " << endl;
   cout << "Thread with id : " << tid << "  ...exiting " << endl;
   pthread_exit(NULL);
}
 
int main ()
{
   int rc;
   int i;
   pthread_t threads[NUM_THREADS];
   pthread_attr_t attr;
   void *status;
   // 初始化并设置线程为可连接的(joinable)
   pthread_attr_init(&attr);
   pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
   for( i=0; i < NUM_THREADS; i++ ){
      cout << "main() : creating thread, " << i << endl;
      rc = pthread_create(&threads[i], NULL, wait, (void *)&i );
      if (rc){
         cout << "Error:unable to create thread," << rc << endl;
         exit(-1);
      }
   } 
   // 删除属性, 并等待其他线程
   pthread_attr_destroy(&attr);
   for( i=0; i < NUM_THREADS; i++ ){
      rc = pthread_join(threads[i], &status);
      if (rc){
         cout << "Error:unable to join," << rc << endl;
         exit(-1);
      }
      cout << "Main: completed thread id :" << i ;
      cout << "  exiting with status :" << status << endl;
   } 
   cout << "Main: program exiting." << endl;
   pthread_exit(NULL);
}
## 进程的三种基本状态
(1) 就绪状态:进程已获得除CPU外的所有必要资源, 只等待CPU时的状态. 一个系统会将多个处于就绪状态的进程排成一个就绪队列. 
(2) 执行状态:进程已获CPU, 正在执行. 单处理机系统中, 处于执行状态的进程只一个;多处理机系统中, 有多个处于执行状态的进程. 
(3) 阻塞状态:正在执行的进程由于某种原因而暂时无法继续执行, 便放弃处理机而处于暂停状态, 即进程执行受阻. (这种状态又称等待状态或封锁状态)
## 进程的操作
创建进程有两种方式, 一是由操作系统创建;二是由父进程创建. 操作系统创建的进程, 它们之间是平等的, 一般不存在资源继承关系. 而由父进程创建的进程(子进程), 它们和父进程存在隶属关系. 子进程又可以创建进程, 形成一个进程家族. 
fork()函数调用后有2个返回值, 调用一次, 返回两次. 成功调用fork函数后, 当前进程实际上已经分裂为两个进程, 一个是原来的父进程, 另一个是刚刚创建的子进程. fork()函数的2个返回值, 一个是父进程调用fork函数后的返回值, 该返回值是刚刚创建的子进程的ID;另一个是子进程中fork函数的返回值, 该返回值是0. 这样可以用返回值来区分父, 子进程. 
进程的编程示例
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <iostream>
#include <string>
using namespace std;
main()
{
    pid_t pid;
    char *msg;
    int k;
    pid=fork();
    switch(pid){
        //子进程执行部分
		case 0:
            msg="Child process is running.\n";
            k=3;
            break;
        case -1:
            perror("Process creation failed.\n");
            break;
        //父进程执行部分
		default:
            msg="Parent process is running.\n";
            k=5;
            break;
    }
	//父子进程共同执行部分
    while(k>0){
        puts(msg);
        sleep(1);
        k--;
    }
}
Parent process is running.
Child process is running.
Parent process is running.
Child process is running.
Parent process is running.
Child process is running.
Parent process is running.
Parent process is running.
注意事项
父子进程终止的先后顺序不同会产生不同的结果. 
在子进程退出前父进程先退出, 则系统会让init进程接管子进程. 
当子进程先于父进程终止, 而父进程又没有调用wait函数等待子进程结束, 子进程进入僵尸状态, 并且会一直保持下去除非系统重启. 子进程处于僵尸状态时, 内核只保存该进程的一些必要信息以备父进程所需. 此时子进程始终占用着资源, 同时也减少了系统可以创建的最大进程数. 如果子进程先于父进程终止, 且父进程调用了wait或waitpid函数, 则父进程会等待子进程结束. 
在Linux下, 可以简单地将SIGCHLD信号的操作设为SIG_IGN, 这样当子进程结束时就不会称为僵尸进程. 


## 线程教程
创建一个线程:CreateThread()
1.函数声明
//返回值:一个HANDLE类型的值, 表示线程的句柄, 可用于等待线程等函数
HANDLE CreateThread(
  LPSECURITY_ATTRIBUTES   lpThreadAttributes, // 不重要, 一般设置为NULL
  SIZE_T                  dwStackSize,        // 堆栈大小, 不重要, 一般设置为0, 表示使用默认堆栈大小
  LPTHREAD_START_ROUTINE  lpStartAddress,     // 函数指针, 传入函数名或指针即可
  __drv_aliasesMem LPVOID lpParameter,        // 参数指针, 供函数使用
  DWORD                   dwCreationFlags,    // 不重要, 一般设置为0
  LPDWORD                 lpThreadId          // 指针, 用于保存线程的id, 一般设置为NULL);]
1.使用方法
// 声明线程函数的模板:
DWORD WINAPI threadname(LPVOID lpParamter) // 函数名字可随意{
	/*
	这里填入你的代码
	*/
	return 0L;}
// 根据声明的函数创造一个线程// 若函数没有参数, 传入函数名字即可, 其它参数参考下方示例
 HANDLE hThread = CreateThread(NULL, 0, threadname, NULL, 0, NULL);
1.使用实例
记得等待线程结束!不然函数(不一定是主函数哦, 而是CreatThread所处的函数)结束退出后, 会释放资源, 导致未结束的线程产生各种奇怪的错误!
#include<iostream>#include<windows.h>
using namespace std;
// 编写了一个我的线程函数
DWORD WINAPI MyThread(LPVOID lpParamter){
	cout << "fuck the multithread !\n";
	return 0L;}
int main (){
	// 创造线程
	CreateThread(NULL, 0, MyThread, NULL, 0, NULL);
	// 记得等待线程结束
	system("PAUSE");
	return 0;}
运行结果:
fuck the multithread !
创建一个带参线程:lpParameter参数
1.关于void指针
lpParamter 跟 void指针使用方法类似, void指针可以指向任何数据, 所以我们可以把任何类形指针的值赋给void指针(但不能把void指针的值直接赋给其它类型的指针!)
下方是int 与 void 指针相互转换的例子. 
int a = 0;int *intp = &a;// int指针 转 void指针void * voidp = intp; // 合法!不会报错
// void指针 转 int指针
intp = voidp; // 不合法! void* 指针不能直接赋值给 int*指针, 会报错!
intp = (int *)voidp// 合法!利用强制类型转换, 告诉编译器, voidp指针指向的是int数据. 
1.直接实例
我假设需要传入一个整形参数, 在声明函数时, 只需要多一行需要这样的操作:
DWORD WINAPI MyThread(LPVOID lpParamter){
	// 把lpParamter当成void指针就完事儿了
	int *a = (int *)lpParamter;
	cout << "I have " << a[0] << " dolors!\n";
	return 0L;}
而创造函数时候, 传入一个整形指针就行了
int main (){
	int a = 0;
	int *p = &a;
	// 创造线程, 注意我把p指针作为参数传入了, 它也就成为了上方函数的lpParamter
	CreateThread(NULL, 0, MyThread, p, 0, NULL);
	// 记得等待线程结束
	system("PAUSE");
	return 0;}
运行结果:
I have 0 dolors!
至于传入更多的参数, 可以自己设计一个struct或者class数据结构, 并传入其指针就行了, 或者也可以传入数组. 
至于返回值, 也可以利用传入的指针来接收. 
等待指定线程结束:WaitForSingleObject()
这个特别简单, 此函数就两个参数, 第一个参数是创建线程时可得到的返回值(HANDLE)也就是句柄, 第二个参数不用关心, 传入INFINITE就行了. 
使用实例:
HANDLE hThread = CreateThread(NULL, 0, thread1, NULL, 0, NULL);// 利用得到的句柄等待线程结束WaitForSingleObject(hThread, INFINITE);
有了这个函数, 再也不用Sleep或者While(1)啦. 
多线程资源加锁:CreateMutex()
1.创建多个线程
动动脑子都能想到, 直接利用循环或多次调用GreatThread函数不就行了么对吧
代码实例
DWORD WINAPI MyThread(LPVOID lpParamter){
	// 把lpParamter当成void指针就完事儿了
	int *a = (int *)lpParamter;
	cout << "I have " << a[0] << " dolors!" << endl;
	return 0L;}
int main(){
	int a[10];

	for (int i = 0; i < 10; i++)
	{
		a[i] = i;
		HANDLE hThread = CreateThread(NULL, 0, MyThread, a + i, 0, NULL);
	}
	system("PAUSE");
	return 0;}
但是, 直接运行程序, 你会发现输出结果特别诡异!顺序完全乱掉了, 换行也乱掉了. 
I have I have I have 8I have 7I have 5I have 1I have 3 dolors!4 dolors!
2 dolors! dolors!
 dolors!
 dolors!
 dolors!
I have 6I have  dolors!


9 dolors!
I have 0 dolors!
动动脑子也能知道, 线程几乎是同时运行的, 谁想输出就输出了, 管你是不是刚输出到了一半. 
所以我们就加锁, 使 "输出" 这个资源, 只能在一个时间内被单个线程使用
1.为资源加锁
创建方法:
// 声明一个句柄
HANDLE cout_mutex;// 创建一个锁
cout_mutex = CreateMutex(NULL, FALSE, NULL);
使用方法:
// 等待其它线程释放锁, 并获取锁的使用权WaitForSingleObject(cout_mutex, INFINITE);
// 获取锁之后, 只要没有解锁, 其它线程就会阻塞在WaitForSingleObject()语句. 
做一些工作(使用需要互斥的资源等)
// 解锁!ReleaseMutex(cout_mutex);
使用实例:
HANDLE cout_mutex;

DWORD WINAPI MyThread(LPVOID lpParamter){
	// 把lpParamter当成void指针就完事儿了
	int *a = (int *)lpParamter;
	WaitForSingleObject(cout_mutex, INFINITE);
	cout << "I have " << a[0] << " dolors!" << endl;
	ReleaseMutex(cout_mutex);
	return 0L;}
int main(){
	int a[10];
	cout_mutex = CreateMutex(NULL, FALSE, NULL);
	for (int i = 0; i < 10; i++)
	{
		a[i] = i;
		HANDLE hThread = CreateThread(NULL, 0, MyThread, a + i, 0, NULL);
	}
	system("PAUSE");
	return 0;}
运行结果:
可以看出输出正常了. 
I have 0 dolors!
I have 1 dolors!
I have 7 dolors!
I have 5 dolors!
I have 4 dolors!
I have 6 dolors!
I have 3 dolors!
I have 9 dolors!
I have 2 dolors!
指定线程运行核心:SetThreadAffinityMask()
现在的cpu一般都是多核的了(任务管理器->性能 -> CPU 即可看到信息), 所以有时候需指定线程到某个核心, 可以更主动的对cpu资源进行分配. 
1.函数声明
DWORD_PTR SetThreadAffinityMask(HANDLE hThread, DWORD_PTR dwThreadAffinityMask);
1.使用方法:
第一个参数是线程的句柄(HANDLE), 第二个参数用来指定CPU核心
比如, 你要指定进程到第0个CPU上, 则mask=0×01
第1个CPU:mask=0×02
第2个CPU:mask=0×04 (注意不是0×03)
第3个CPU:mask=0×08
以此类推. 
如果要指定多个CPU:
比如第0, 1个:mask=0×03
第1, 2个:mask=0×06
以此类推. 
如果CPU个数不足, 则会进行取模操作. 比如一共4个CPU, 则mask=0×0010则和0×01一样
(此段文字转自其它博客, 但找不到源链接, 就不贴出来了)
1.代码实例:
// 绑定到第三个核心
HANDLE hThread = CreateThread(NULL, 0, MyThread, a + i, 0, NULL);SetThreadAffinityMask(hThread, 0x08);
## 汇总
线程函数
DWORD WINAPI threadname(LPVOID lpParamter) // 函数名字可随意{
	int *a = (int *)lpParamter;
	return 0L;}
创建线程
HANDLE hThread = CreateThread(NULL, 0, threadname, NULL, 0, NULL);
等待线程
WaitForSingleObject(hThread , INFINITE);
互斥量
HANDLE cout_mutex;
cout_mutex = CreateMutex(NULL, FALSE, NULL);
WaitForSingleObject(cout_mutex, INFINITE);ReleaseMutex(cout_mutex);

## 创建子进程
windows下想要创建一个子进程不如linux的fork函数来得方便, 通过CreateProcess函数创建一个新的进程, 函数的定义如下
BOOL CreateProcess(
 LPCTSTR lpApplicationName, // 应用程序名称
 LPTSTR lpCommandLine, // 命令行字符串
 LPSECURITY_ATTRIBUTES lpProcessAttributes, // 进程的安全属性
 LPSECURITY_ATTRIBUTES lpThreadAttributes, // 线程的安全属性
 BOOL bInheritHandles, // 是否继承父进程的属性
 DWORD dwCreationFlags, // 创建标志
 LPVOID lpEnvironment, // 指向新的环境块的指针
 LPCTSTR lpCurrentDirectory, // 指向当前目录名的指针
 LPSTARTUPINFO lpStartupInfo, // 传递给新进程的信息
 LPPROCESS_INFORMATION lpProcessInformation // 新进程返回的信息
);
下面写一个创建进程和简单的控制示例, 首先创建一个小程序, 作为子进程的实体
#include<iostream>
#include<Windows.h>

using namespace std;

int main(int argc, char *argv[])
{
	cout << "args_num: " << argc << endl;
	for(int i = 0;i < argc;i ++){
		cout << "arg " << i << " = " << argv[i] << endl;
	}
	return 0;
}
主要是打印进程的传入参数列表, 下面是创建子进程的代码, 运行后可以看到, 子进程也能获取到传入参数了.  
#include<iostream>
#include<Windows.h>

using namespace std;

int main()
{
	char cWindowsDirectory[MAX_PATH];

	//LPTSTR 与 wchar_t* 等价(Unicode环境下)
	LPTSTR cWinDir = new TCHAR[MAX_PATH];
	GetCurrentDirectory(MAX_PATH, cWinDir);

	LPTSTR sConLin = wcscat(cWinDir , L"\\..\\Debug\\another.exe a b c d");

	STARTUPINFO si;
	PROCESS_INFORMATION pi;

	ZeroMemory(&si, sizeof(si));
	ZeroMemory(&pi, sizeof(pi));

	//创建一个新进程
	if(CreateProcess(
		NULL,	//	指向一个NULL结尾的, 用来指定可执行模块的宽字节字符串
		sConLin, //	命令行字符串
		NULL, //	指向一个SECURITY_ATTRIBUTES结构体, 这个结构体决定是否返回的句柄可以被子进程继承. 
		NULL, //	如果lpProcessAttributes参数为空(NULL), 那么句柄不能被继承. <同上>
		false,//	指示新进程是否从调用进程处继承了句柄.  
		0,	//	指定附加的, 用来控制优先类和进程的创建的标
			//	CREATE_NEW_CONSOLE	新控制台打开子进程
			//	CREATE_SUSPENDED	子进程创建后挂起, 直到调用ResumeThread函数
		NULL, //	指向一个新进程的环境块. 如果此参数为空, 新进程使用调用进程的环境
		NULL, //	指定子进程的工作路径
		&si, //	决定新进程的主窗体如何显示的STARTUPINFO结构体
		&pi	 //	接收新进程的识别信息的PROCESS_INFORMATION结构体
		))
	{
		cout << "create process success" << endl;

		//下面两行关闭句柄, 解除本进程和新进程的关系, 不然有可能不小心调用TerminateProcess函数关掉子进程
//		CloseHandle(pi.hProcess);
//		CloseHandle(pi.hThread);
	}
	else{
		cerr << "failed to create process" << endl;
	}

	Sleep(100);

	//终止子进程
	TerminateProcess(pi.hProcess, 300);

	//终止本进程, 状态码
	ExitProcess(1001);

	return 0;
}
CreateProcess的参数虽然多而且麻烦, 其实大部分设置为NULL即可, 右边这个链接里面有多进程编程相关的函数介绍:http://blog.csdn.net/bxhj3014/article/details/2082255

### 主进程:
#include<iostream>
#include<windows.h>
int main(int argc, char*argv[])
{
    STARTUPINFO si = { sizeof(STARTUPINFO) };//在产生子进程时, 子进程的窗口相关信息
    PROCESS_INFORMATION pi;                  //子进程的ID/线程相关信息
    DWORD returnCode;//用于保存子程进的返回值;

    wchar_t commandLine1[] = L"subapp.exe -l";  //测试命令行参数一
    wchar_t commandLine2[] = L"subapp.exe";     //测试命令行参数二

    BOOL bRet = CreateProcess(              //调用失败, 返回0;调用成功返回非0;
        NULL,                               //一般都是空;(另一种批处理情况:此参数指定"cmd.exe",下一个命令行参数 "/c otherBatFile")
        commandLine1,                       //命令行参数         
        NULL,                               //_In_opt_    LPSECURITY_ATTRIBUTES lpProcessAttributes,
        NULL,                               //_In_opt_    LPSECURITY_ATTRIBUTES lpThreadAttributes,
        FALSE,                              //_In_        BOOL                  bInheritHandles,
        CREATE_NEW_CONSOLE,                 //新的进程使用新的窗口. 
        NULL,                               //_In_opt_    LPVOID                lpEnvironment,
        NULL,                               //_In_opt_    LPCTSTR               lpCurrentDirectory,
        &si,                                //_In_        LPSTARTUPINFO         lpStartupInfo,
        &pi);                               //_Out_       LPPROCESS_INFORMATION lpProcessInformation

    if (bRet)
    {
        std::cout << "process is running..." << std::endl;
        //等待子进程结束
        WaitForSingleObject(pi.hProcess, -1);
        std::cout << "process is finished"  << std::endl;
        //获取子进程的返回值
        GetExitCodeProcess(pi.hProcess, &returnCode);
        std::cout << "process return code:" << returnCode << std::endl;
    }
    else
    {
        std::cout << "Create Process error!"<<std::endl;
        return 0;
    }

    getchar();
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
    return 0;
}
### 子进程
#include<iostream>

int main(int argc,char* argv[])
{
    std::cout << "this is subApp message" << std::endl;

    if (argc>= 2)
    {
        std::cout << "work... pass,the return code will be 0" << std::endl;
        getchar();
        return 0;
    }
    else
    {
        std::cout << "work... failed,the return code will be 1" << std::endl;
        getchar();
        return 1;
    }
}

## linux下的C\C++多进程多线程编程实例
### 1, 多进程编程
#include <stdlib.h> 
#include <sys/types.h> 
#include <unistd.h> 
  
int main() 
{ 
  pid_t child_pid; 
  
  /* 创建一个子进程 */ 
  child_pid = fork(); 
  if(child_pid == 0) 
  { 
    printf("child pid\n"); 
    exit(0); 
  } 
  else
  { 
    printf("father pid\n"); 
    sleep(60); 
  } 
    
  return 0; 
} 
###  2, 多线程编程
#include <stdio.h> 
#include <pthread.h> 
  
struct char_print_params 
{ 
  char character; 
  int count; 
}; 
  
void *char_print(void *parameters) 
{ 
  struct char_print_params *p = (struct char_print_params *)parameters; 
  int i; 
  
  for(i = 0; i < p->count; i++) 
  { 
    fputc(p->character,stderr); 
  } 
  
  return NULL; 
} 
  
int main() 
{ 
  pthread_t thread1_id; 
  pthread_t thread2_id; 
  struct char_print_params thread1_args; 
  struct char_print_params thread2_args; 
  
  thread1_args.character = 'x'; 
  thread1_args.count = 3000; 
  pthread_create(&thread1_id, NULL, &char_print, &thread1_args); 
  
  thread2_args.character = 'o'; 
  thread2_args.count = 2000; 
  pthread_create(&thread2_id, NULL, &char_print, &thread2_args); 
  
  pthread_join(thread1_id, NULL); 
  pthread_join(thread2_id, NULL); 
  
  return 0; 
} 
###  3, 线程同步与互斥
1), 互斥
pthread_mutex_t mutex; 
pthread_mutex_init(&mutex, NULL); 
  
/*也可以用下面的方式初始化*/
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; 
  
pthread_mutex_lock(&mutex); 
/* 互斥  */
  
thread_flag = value; 
  
pthread_mutex_unlock(&mutex); 
2), 条件变量
int thread_flag = 0; 
pthread_mutex_t mutex; 
pthread_cond_t thread_flag_cv;\ 
  
void init_flag() 
{ 
  pthread_mutex_init(&mutex, NULL); 
  pthread_cond_init(&thread_flag_cv, NULL); 
  thread_flag = 0; 
} 
  
void *thread_function(void *thread_flag) 
{ 
  while(1) 
  { 
    pthread_mutex_lock(&mutex); 
    while(thread_flag != 0 ) 
    { 
      pthread_cond_wait(&thread_flag_cv, &mutex); 
    } 
    pthread_mutex_unlock(&mutex); 
  
    do_work(); 
  } 
  
  return NULL; 
} 
  
void set_thread_flag(int flag_value) 
{ 
  pthread_mutex_lock(&mutex); 
  thread_flag = flag_value; 
  
  pthread_cond_signal(&thread_flag_cv); 
  pthread_mutex_unlock(&mutex); 
} 



# C、C++各个版本新特性 2020

## 1、C语言版本更迭
年份        C标准        通用名     别名        标准编译选项        GNU扩展选项
1972        Birth C      -          -        -        -
1978        K&R C        -        -        -        -
1989-1990        X3.159-1989, ISO/IEC 9899:1990        C89        C90, ANSI C, ISO C        -ansi, -std=c90, -std=iso9899:1990        -std=gnu90
1995        ISO/IEC 9899/AMD1:1995        AMD1        C94, C95        -std=iso9899:199409        -
1999        ISO/IEC 9899:1999        C99        -        -std=c99, -std=iso9899:1999        -std=gnu99
2011        ISO/IEC 9899:2011        C11        -        -std=c11, -std=iso9899:2011        -std=gnu11
2018        ISO/IEC 9899:2018        C18        -        -std=c18, -std=iso9899:2018        -std=gnu18
C++版本更迭
年份        C++标准        通用名        别名        标准编译选项        GNU扩展选项
1978        C with Classes        -        -        -        -
1998        ISO/IEC 14882:1998        C++98        -        -std=c++98        -std=gnu++98
2003        ISO/IEC 14882:2003        C++03        -        -std=c++03        -std=gnu++03
2011        ISO/IEC 14882:2011        C++11        C++0x        std=c++11, std=c++0x        std=gnu++11, std=gnu++0x
2014        ISO/IEC 14882:2014        C++14        C++1y        std=c++14, std=c++1y        std=gnu++14, std=gnu++1y
2017        ISO/IEC 14882:2017        C++17        C++1z        std=c++17, std=c++1z        std=gnu++17, std=gnu++1z
2020        to be determined        C++20        C++2a        -std=c++2a        std=gnu++2a

## 2、C++各版本新特性

### C++ 11
auto关键字
decltype关键字
nullptr字面值
constexpr关键字
for（declaration ： expression）
Lambda表达式
initializer_list
标准库bind函数
智能指针shared_ptr,unique_ptr
右值引用&&
STL容器std::array，std::forward_list，std::unordered_map，std::unordered_set

### C++ 14
拓展了lambda表达式，更加泛型：支持auto
拓展了类型推导至任意函数：C11只支持lambda返回类型的auto
弃用关键字 [[deprecated]]

### C++ 17
拓展了constexpr至switch if等：C++11的constexpr函数只能包含一个表达式
typename 嵌套
inline 内联变量
模板参数推导
元组类 std::tuple：std::pair实现两个元素的组合，它实现多个
类模板
std::variant
表示一个类型安全的联合体。
引用包装器 std::reference_wrapper
变长参数模板
结构化绑定（函数多值返回时用{}合成struct）
非类型模板参数可传入类的静态成员
在if和switch中可进行初始化
初始化（如struct）对象时，可用花括号进行对其成员进行赋值
简化多层命名空间的写法
lambda表达式可捕获*this的值，但this及其成员为只读
十六进制的单精度浮点数
继承与改写构造函数
using B1::B1;//表示继承B1的构造函数
当模板参数为非类型时，可用auto自动推导类型
判断有没有包含某文件__has_include
[[fallthrough]]用于switch语句块内，表示会执行下一个case或default
[[nodiscard]]表示函数的返回值没有被接收，在编译时会出现警告。
[[maybe_unused]]即便没使用也不警告

### C++ 20
concept用于声明具有特定约束条件的模板类型
// 声明一个数值类型的concept
template
范围库（Ranges Library）
协程（Coroutines）
模块（modules）



