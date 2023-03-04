分类参考
文件状态测试
-b filename	当filename 存在并且是块文件时返回真(返回0)
-c filename	当filename 存在并且是字符文件时返回真
-d pathname	当pathname 存在并且是一个目录时返回真
-e pathname	当由pathname 指定的文件或目录存在时返回真
-f filename	当filename 存在并且是正规文件时返回真
-g pathname	当由pathname 指定的文件或目录存在并且设置了SGID 位时返回真
-h filename	当filename 存在并且是符号链接文件时返回真 (或 -L filename)
-k pathname	当由pathname 指定的文件或目录存在并且设置了"粘滞"位时返回真
-p filename	当filename 存在并且是命名管道时返回真
-r pathname	当由pathname 指定的文件或目录存在并且可读时返回真
-s filename	当filename 存在并且文件大小大于0 时返回真
-S filename	当filename 存在并且是socket 时返回真
-t fd	当fd 是与终端设备相关联的文件描述符时返回真
-u pathname	当由pathname 指定的文件或目录存在并且设置了SUID 位时返回真
-w pathname	当由pathname 指定的文件或目录存在并且可写时返回真
-x pathname	当由pathname 指定的文件或目录存在并且可执行时返回真
-O pathname	当由pathname 存在并且被当前进程的有效用户id 的用户拥有时返回真(字母O 大写)
-G pathname	当由pathname 存在并且属于当前进程的有效用户id 的用户的用户组时返回真
file1 -nt file2	file1 比file2 新时返回真
file1 -ot file2	file1 比file2 旧时返回真
f1 -ef f2	files f1 and f2 are hard links to the same file
举例: if [ -b /dev/hda ] ;then echo "yes" ;else echo "no";fi // 将打印 yes

test -c /dev/hda ; echo $? // 将打印 1 表示test 命令的返回值为1，/dev/hda 不是字符设备

[ -w /etc/passwd ]; echo $? // 查看对当前用户而言，passwd 文件是否可写

测试时逻辑操作符
-a	逻辑与，操作符两边均为真，结果为真，否则为假。
-o	逻辑或，操作符两边一边为真，结果为真，否则为假。
!	逻辑否，条件为假，结果为真。
举例: [ -w result.txt -a -w score.txt ] ;echo $? // 测试两个文件是否均可写

常见字符串测试
-z string	字符串string 为空串(长度为0)时返回真
-n string	字符串string 为非空串时返回真
str1 = str2	字符串str1 和字符串str2 相等时返回真
str1 == str2	同 =
str1 != str2	字符串str1 和字符串str2 不相等时返回真
str1 < str2	按字典顺序排序，字符串str1 在字符串str2 之前
str1 > str2	按字典顺序排序，字符串str1 在字符串str2 之后
举例: name="zqf"; [ $name = "zqf" ];echo $? // 打印 0 表示变量name 的值和字符串"zqf"相等

常见数值测试
int1 -eq int2	如果int1 等于int2，则返回真
int1 -ne int2	如果int1 不等于int2，则返回真
int1 -lt int2	如果int1 小于int2，则返回真
int1 -le int2	如果int1 小于等于int2，则返回真
int1 -gt int2	如果int1 大于int2，则返回真
int1 -ge int2	如果int1 大于等于int2，则返回真
在 (()) 中的测试：

<	小于(在双括号里使用)	(("$a" < "$b"))
<=	小于等于 (在双括号里使用)	(("$a" <= "$b"))
>	大于 (在双括号里使用)	(("$a" > "$b"))
>=	大于等于(在双括号里使用)	(("$a" >= "$b"))
举例: x=1 ; [ $x -eq 1 ] ; echo $? // 将打印 0 表示变量x 的值等于数字1 x=a ; [ $x -eq "1" ] // shell 打印错误信息 [: a: integer expression expected

test ， [] , [[]]
因为 shell 和我们通常编程语言不同，更多的情况是和它交互，总是调用别人。 所以有些本属于程序语言本身的概念在 shell 中会难以理解。"基本功" 不好， 更容易 "犯困" 了，我就是一个 :-) 。

以 bash 为例 (其他兼容 shell 差不多)：

test 和 [ 是 bash 的内部命令，GNU/linux 系统的 coreutils 软件包通 常也带 /usr/bin/test 和 /usr/bin/[ 命令。如果我们不用绝对路径指 明，通常我们用的都是 bash 自带的命令。
[[ 是 bash 程序语言的关键字！
$ ls -l /usr/bin/[ /usr/bin/test
-rwxr-xr-x 1 root root 37400  9月 18 15:25 /usr/bin/[
-rwxr-xr-x 1 root root 33920  9月 18 15:25 /usr/bin/test
$ type [ [[ test
[ is a shell builtin
[[ is a shell keyword
test is a shell builtin
绝大多数情况下，这个三个功能通用。但是命令和关键字总是有区别的。命令和 关键字的差别有多大呢？

如果是命令，它就和参数组合为一体被 shell 解释，那样比如 ">" "<" 就被 shell 解释为重定向符号了。关键字却不这样。

在 [[ 中使用 && 和 ||
[ 中使用 -a 和 -o 表示逻辑与和逻辑或。

[[ 中可以使用通配符
arch=i486
[[ $arch = i*86 ]] && echo "arch is x86!"
[[ 中匹配字符串或通配符，不需要引号
    [[ $arch_com = i386 || $ARCH = i*86 ]] &&
    cat >> $TFS_REPO <<EOF
[tfs-i386]
name=GTES11.3 prelim1
baseurl=${BASEURL}i386/
enabled=1
EOF