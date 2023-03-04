
# 1, GDB 常用命令实战

GDB 基础知识:
GDB, 是 The GNU Project Debugger 的缩写, 是 Linux 下功能全面的调试工具. GDB 支持断点, 单步执行, 打印变量, 观察变量, 查看寄存器, 查看堆栈等调试手段. 在 Linux 环境软件开发中, GDB 是主要的调试工具, 用来调试 C 和 C++ 程序. 

在终端输入以下命令安装 GDB:
sudo apt-get install gdb


命令	 解释	 示例
file <文件名>	加载被调试的可执行程序文件. 	(gdb) file gdb-sample
	因为一般都在被调试程序所在目录下执行GDB, 因而文本名不需要带路径. 	
r	Run的简写, 运行被调试的程序. 	(gdb) r
	如果此前没有下过断点, 则执行完整个程序;如果有断点, 则程序暂停在第一个可用断点处. 	
c	Continue的简写, 继续执行被调试程序, 直至下一个断点或程序结束. 	(gdb) c
b <行号>	b: Breakpoint的简写, 设置断点. 两可以使用"行号""函数名称""执行地址"等方式指定断点位置. 	(gdb) b 8
b <函数名称>	其中在函数名称前面加"*"符号表示将断点设置在"由编译器生成的prolog代码处". 如果不了解汇编, 可以不予理会此用法. 	(gdb) b main
b *<函数名称>		(gdb) b *main
b *<代码地址>		(gdb) b *0x804835c
d [编号]		(gdb) d
s, n	s: 执行一行源程序代码, 如果此行代码中有函数调用, 则进入该函数;	(gdb) s
	n: 执行一行源程序代码, 此行代码中的函数调用也一并执行. 	(gdb) n
	s 相当于其它调试器中的"Step Into (单步跟踪进入)";	
	n 相当于其它调试器中的"Step Over (单步跟踪)". 	
	这两个命令必须在有源代码调试信息的情况下才可以使用(GCC编译时使用"-g"参数). 	
si, ni	 si命令类似于s命令, ni命令类似于n命令. 所不同的是, 这两个命令(si/ni)所针对的是汇编指令, 而s/n针对的是源代码. 	 (gdb) si
		(gdb) ni
p <变量名称> 	 Print的简写, 显示指定变量(临时变量或全局变量)的值. 	 (gdb) p i
		(gdb) p nGlobalVar
display ...	display, 设置程序中断后欲显示的数据及其格式. 	(gdb) display /i $pc
undisplay <编号>	例如, 如果希望每次程序中断后可以看到即将被执行的下一条汇编指令, 可以使用命令	(gdb) undisplay 1
	"display /i $pc"	
	其中 $pc 代表当前汇编指令, /i 表示以十六进行显示. 当需要关心汇编代码时, 此命令相当有用. 	
	undispaly, 取消先前的display设置, 编号从1开始递增. 	
i	Info的简写, 用于显示各类信息, 详情请查阅"help i".  	 (gdb) i r
q    	Quit的简写, 退出GDB调试环境.   	 (gdb) q
help [命令名称]	GDB帮助命令, 提供对GDB名种命令的解释说明. 	   (gdb) help display
	如果指定了"命令名称"参数, 则显示该命令的详细说明;如果没有指定参数, 则分类显示所有GDB命令, 供用户进一步浏览和查询. 	




## 1 GDB 的进入和退出
如果要调试程序, 需要在 gcc 编译可执行程序时加上 -g 参数, 首先我们编译 bugging.c 程序, 生成可执行文件:
gcc bugging.c -o bugging -g -m32
其中 -o 指定输出文件名, 实验楼的环境是 64 位的操作系统, 所以默认会编译为 64 位的程序, 添加 -m32 选项可以编译为 32 位. 

如果在你的环境里编译报错, 请安装 libc6-dev-i386 后再次编译:
sudo apt-get install libc6-dev-i386
输入 gdb bugging 进入 gdb 调试 bugging 程序的界面:
gdb bugging
在 gdb 命令行界面, 输入run 执行待调试程序:
(gdb) run
在 gdb 命令行界面, 输入quit 退出 gdb:
(gdb) quit
GDB 命令行界面使用技巧
命令补全:

任何时候都可以使用 TAB 进行补全, 如果只有一个待选选项则直接补全;否则会列出可选选项, 继续键入命令, 同时结合 TAB 即可快速输入命令. 

## 部分 gdb 常用命令一览表:

命令	简写形式	说明
list	l	查看源码
backtrace	bt, where	打印函数栈信息
next	n	执行下一行
step	s	一次执行一行, 遇到函数会进入
finish		运行到函数结束
continue	c	继续运行
break	b	设置断点
info breakpoints		显示断点信息
delete	d	删除断点
print	p	打印表达式的值
run	r	启动程序
until	u	执行到指定行
info	i	显示信息
help	h	帮助信息
查询用法:

在 gdb 命令行界面, 输入 help command 可以查看命令的用法, command 是你想要查询的命令. 
执行 Shell 命令:
在 gdb 命令行界面可以执行外部的 Shell 命令:
(gdb) !shell 命令
在这里插入图片描述

## 2 GDB 查看源码
我们重新进入 debugging 调试界面:

list 命令用来显示源文件中的代码. 

list 行号, 显示某一行附近的代码
list 2

list 文件名 : 行号, 显示某一个文件某一行附近的代码, 用于多个源文件的情况. 
list 函数名, 显示某个函数附近的代码:

list main
list 文件名 : 函数名, 显示某一个文件某个函数附近的代码, 用于多个源文件的情况. 

## 3 GDB 断点
设置断点
break 命令用来设置断点. 

break 行号, 断点设置在该行开始处, 注意:该行代码未被执行:
break 文件名 : 行号, 适用于有多个源文件的情况. 
break 函数名, 断点设置在该函数的开始处, 断点所在行未被执行:
break 文件名 : 函数名, 适用于有多个源文件的情况. 
查看断点信息
info breakpoints 命令用于显示当前断点信息. 
在这里插入图片描述
其中每一项的信息:

Num 列代表断点编号, 该编号可以作为 delete/enable/disable 等控制断点命令的参数
Type 列代表断点类型, 一般为 breakpoint
Disp 列代表断点被命中后, 该断点保留(keep), 删除(del)还是关闭(dis)
Enb 列代表该断点是 enable(y) 还是 disable(n)
Address 列代表该断点处虚拟内存的地址
What 列代表该断点在源文件中的信息
删除断点
delete 命令用于删除断点. 

delete Num, 删除指定断点, 断点编号可通过 info breakpoints 获得:
delete, 不带任何参数, 默认删除所有断点:
关闭和启用断点
disable 命令和 enable 命令分别用于关闭和启用断点:

disable 命令用于关闭断点, 有些断点可能暂时不需要但又不想删除, 便可以 disable 该断点. 
enable 命令用于启用断点. 

disable Num, 关闭指定断点, 断点编号可通过 info breakpoints 获得:
disable, 不带任何参数, 默认关闭所有断点. 
enable Num, 启用指定断点, 断点编号可通过 info breakpoints 获得. 
enable, 不带任何参数, 默认启用所有断点. 
disable 和 enable 命令影响的是 info breakpoints 的 Enb 列, 表示该断点是启用还是关闭

## 4 关于断点的其他知识

断点启用的更多方式
enable 命令还可以用来设置断点被执行的次数, 比如当断点设在循环中的时候, 某断点可能多次被命中. 
enable once Num, 断点 hit 一次之后关闭该断点
enable delete Num, 断点 hit 一次之后删除该断点
在这里插入图片描述
这两个命令影响的是 info breakpoints 的 Disp 列, 表示该断点被命中之后的行为. 
断点调试的一些命令
打印变量
调试的过程中需要观察变量或者表达式的值, 所以先介绍两个基本的显示变量值的命令:

info locals
打印当前断点处所在函数的所有局部变量的值, 不包括函数参数. 

print 变量或表达式
打印表达式的值, 可显示当前函数的变量的值, 全局变量的值等

print/FMT 可以控制打印的格式, 常见的有x(十六进制), t(二进制), c(显示为字符)等. 

启动程序
run 命令用于启动待调试程序, 并运行到断点处停下. 

run
不带任何参数, 启动待调试程序, 不传递参数. 

run 参数
有些程序需要跟参数, 直接带上参数列表即可, 会传递给 main 函数的 argc, argv 变量. 

单步命令
next, step, finish, continue, until 用于控制整个调试过程中, 程序执行的流程. 

next
next 单步执行, 函数调用当做一条指令, 不会进入被调用函数内部
next N, 表示单步执行N次

step
step 单步执行, 会进入到函数调用内部
step N, 表示单步执行N次

finish
执行程序到当前函数结束

continue
执行程序到下个断点

until
until N, 执行程序到源代码的某一行

断点小结
断点是调试最基本的方法之一. 主要是几个断点相关的命令. 

list
info breakpoints
break
delete
disable 和 enable
enable once 和 enable delete
next, step, finish, continue, until
info locals 和 print

## 5 GDB 单步调试

断点设置
本节将继续使用 bugging 程序, 首先确认已生成了 debug 的可执行文件. 在 main 函数处设置了一个断点, 用于进行后续的单步调试. 

gdb bugging
(gdb) break main
(gdb) info breakpoints
正式开始调试程序
bugging 程序简介:

bugging 示例程序是用来计算 1+2+3+…+100 的值的, 预期结果为高斯数 5050
程序运行的结果和我们预期的不一致, 仅仅从代码不易看出 bug 所在
接下来使用 gdb 单步调试该程序, 找到 bug 所在
调试 bugging:

info breakpoints 查看我们设置的断点:
run 运行程序, 程序在第一次运行到断点会停止, 等待下一条命令:
next 单步执行:
next:
step , 也是单步执行, 和 next 的区别还记得吗:
list 查看当前行附近的代码:
info locals 打印出所有的局部变量:
next :
info locals:
list foo 查看下 foo 函数的源码:
到这里已经基本定位程序 bug 所在了, sum 的值从进入循环体到执行一次循环结束都不对. bug 根源就是 sum 变量未初始化, 导致错误的累加. 我们修改 int sum = 0; 重新构建程序, 便可以得到预期结果. 

## 6 单步调试小结
主要是几个单步相关的命令:

list
print
info locals
run
next
step
finish
continue
until

## 7 GDB 函数栈
断点设置
本节将继续使用 bugging 程序, 首先确认之前有执行过以下命令在 main 函数处设置了一个断点, 用于进行后续的单步调试. 

gdb bugging
> (gdb) break foo
> (gdb) info breakpoints
在 foo 函数处设置了一个断点. 

函数与函数栈
进程在内存空间会拥有一块叫做 stack 的区域, 函数内部的局部变量, 函数之间调用时参数的传递和返回值等等都会用到栈这种数据结构. 

info proc mappings 可以查看待调试进程的内存分布情况

run
info proc mappings
在这里插入图片描述
从进程的地址空间分配情况可以看到, 有一块区域 [stack], 这就是该进程的 栈空间

backtrace 查看函数调用栈的情况
backtrace, where, info stack
这三个命令都可以查看函数的调用情况
backtrace full, where full, info stack full
这三个命令查看函数调用情况的同时, 打印所有局部变量的值
在这里插入图片描述
栈帧(stack frame)
#1 是 main 函数用到的栈空间, 这一部分可以称之为 main 函数的 stack frame
#0 是 foo 函数用到的栈空间, 同样可称之为 foo 函数的 stack frame, 0 代表当前执行停在 foo 函数内
可以得到函数调用关系为, main 调用 foo
info frame Num 查看某个函数栈帧的详细信息
通过回溯栈, 可以调试函数之间的调用关系, 局部变量值的变化等. 
函数调用过程中栈是怎么压入和弹出的?

## 8 函数栈小结
主要是几个栈相关的命令:

backtrace
backtrace full
info frame

# 2, 调试链表程序

## 2.1 编译运行程序
构建 test_linked_list 可执行程序
gcc -g -o test_linked_list linked_list.c test_linked_list.c
阅读源码, linked_list.h 和 linked_list.c 定义了线性数据结构链表, 并且定义了一些对链表相关的操作. test_linked_list.c 中的 main 函数对链表进行删除等测试. 

我们直接在终端命令行运行该程序:
./test_linked_list
程序运行发生了段错误, 由于没有任何输出信息, 不能定位 bug 所在. 如果不会调试的基本手段, 就需要修改代码, 加上很多 printf 语句, 重新构建程序, 尝试定位问题. 

## 2.2 使用 GDB 调试程序
调试的基本思路
使用 GDB 调试程序, 启动待调试程序, 先 run 一遍, 查看挂在哪里. 
在程序挂掉的地方设置断点, 单步调试, 找到 bug 所在. 
由于程序中有很多函数调用关系, 合理设置断点 结合 backtrace 快速定位问题. 
进行 debug
gdb test_linked_list
list main
run
backtrace
break core_dump_test
list core_dump_test
next 2
info locals
step
backtrace full
next 4
print p next
debug 的步骤也可以按照自己习惯的顺序来. 上述 debug 过程, 在第 8 步就应该开始注意了 h 的值为 0, 第 10 步, 第 12 步都表明局部变量 p 的值为 0, 最终 p->next 非法内存访问. 

