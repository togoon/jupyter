MySQL 入门常用命令大全

1.mysql 命令简介
2.mysql 命令选项
3.SQL 的六种子语言
4.常用命令
4.1 准备篇
4.1.1 连接本地 MySQL
4.1.2 连接远程 MySQL
4.1.3 退出 MySQL
4.1.4 查看 MySQL 版本
4.2 DCL篇（数据控制篇）
4.2.1 新建用户
4.2.2 删除用户
4.2.3 用户授权
4.2.4 撤销用户权限
4.2.5 查看用户权限
4.2.6 修改用户密码
4.3 DDL 篇（数据定义篇）
4.3.1 创建数据库
4.3.2 删除数据库
4.3.3 查看所有数据库
4.3.4 查看当前数据库
4.3.5 连接数据库
4.3.6 创建数据表
4.3.7 查看 MySQL 支持的存储引擎和默认的存储引擎
4.3.8 删除数据表
4.3.9 查看当前数据库有哪些数据表
4.3.10 查看数据表结构
4.3.11 查看建表语句
4.3.12 重命名数据表
4.3.13 增加、删除和修改字段自增长
4.3.14 增加、删除和修改数据表的列
4.3.15 添加、删除和查看索引
4.3.16 创建临时表
4.3.17 创建内存表
4.3.18 修改数据表的存储引擎
4.3.19 查看数据库数据表存储位置
4.3.20 创建 merge 表
4.3.21 清空表内容
4.4 DQL 篇（数据查询篇）
4.4.1 查询记录
4.4.2 where 子句
4.4.3 group by 子句
4.4.4 where 与 having 子句的区别
4.4.5 order by 子句
4.4.6 limit 子句
4.4.7 distinct 用法
4.4.8 检查查询语句的执行效率
4.4.9 查看SQL执行时的警告
4.4.10 union的用法
4.4.11 join 的用法
4.4.13 查看数据表行数
4.5 DML篇（数据操作篇）
4.5.1 插入记录
4.5.2 删除记录
4.5.3 修改记录
4.5.4 备份还原数据
4.6 TCL 篇（事务控制篇）
事务的四大特性
查看是否自动提交事务
关闭和开启自动提交事务
事务执行的基本流程
设置事务的保存点
事务的隔离级别
4.7 CCL（游标控制语言）
4.7.1 定义游标
4.7.2 打开游标
4.7.3 根据游标提取数据
4.7.4 关闭游标
5.MySQL 常用函数
5.1 日期和时间函数
5.2 字符串函数
substr(...)
substring_index(...)
CONCAT()
CONCAT_WS()
GROUP_CONCAT()
5.3 数学函数
CONV()
5.4 聚合函数
COUNT()
5.5 其它函数
inet_aton(...) 与 inet_ntoa(...)
ISNULL()
6.常用功能
7.小结
附录
附录1：MySQL权限类型
参考文献

1.mysql 命令简介
mysql 命令是 MySQL 数据库的客户端应用程序，用于解释执行 SQL 语句。

2.mysql 命令选项
mysql 命令格式：

mysql [options] dbName
mysql 命令选项：

--help, -?
	显示 mysql 命令的帮助信息
-A, --no-auto-rehash
	不对数据表名与列名重新建立hash，因此禁用了数据表名和列名的自动补全功能，提高了use [dbname]命令的效率
-B, --batch
	不使用历史文件，禁用交互。mysql 命令交互过程会将用户的所有输入记录在一个隐藏文件 /root/.mysql_history。每次使用 quit 退出 mysql 交互模式时，会将交互过程中的所有命令操作一次性写入 /root/.mysql_history 这个隐藏文件中。下次一登录 mysql 时，可以使用键盘的向上键获取历史命令。类似于shell获取历史命令。-B 一般用于 Shell 脚本中执行 sql 语句，命令行模式下需要与 mysql 进行交互，故不使用
-N, --skip-column-names
	查询结果不输出列名
使用man mysql或mysql --help可查看更加详细的 mysql 命令选项说明。

常用命令选项：
（1）命令行交互模式下使用-A；
（2）Shell 脚本用于执行 sql 语句时使用-NBA。

3.SQL 的六种子语言
SQL（Structured Query Language）是结构化查询语言，也是一种高级的非过程化编程语言。SQL语句可用于增删查改数据以及管理关系型数据库，并不局限于数据查询。

关于SQL的组成部分，网上的资料也是众说纷纭，有些将SQL分为四个子语言，DQL纳入DML的一部分，也有些没有TCL，因为没有参考到较权威的资料，目前按照百度百科的说法，SQL主要由六个子语言组成，分别是 DDL、DQL、DML、DCL、TCL（TPL）和 CCL，下面将一一讲解。

（1）DCL（Data Control Language，数据控制语言）
用于对数据库，数据表的访问角色和权限的控制等。

GRANT - 授权 
REVOKE - 撤销授权 
DENY - 拒绝授权
（2）DDL（Data Definition Language，数据定义语言）
DDL用于定义数据库的三级结构，包括外模式、概念模式、内模式及其相互之间的映像，定义数据的完整性约束、安全控制等。使我们有能力创建、修改和删除表格。也可以定义索引和键，规定表之间的链接，以及施加表之间的约束。DDL不需要commit，主要操作有：

CREATE - 创建
ALTER - 修改
DROP - 删除
TRUNCATE - 截断
COMMENT - 注释
RENAME - 重命名
（3）DQL（Data Query Language，数据查询语言）
其语句，也称为“数据检索语句”，用以从表中获得数据，确定数据怎样在应用程序给出。保留字SELECT是DQL（也是所有SQL）用得最多的动词。常用的关键字有：

SELECT-从数据库表中获取数据 
FROM - 指定从哪个数据表或者子查询中查询
WHERE - 指定查询条件
GROUP BY - 结合合计函数，根据一个或多个列对结果集进行分组
HAVING - 对分组后的结果集进行筛选
ORDER BY - 对结果集进行排序
LIMIT - 对结果集进行top限制输出
UNION - 结果集纵向联合
JOIN - 结果集横向拼接
（4）DML（Data Manipulation Language，数据操作语言）

供用户对数据库中数据的操作，包括数据的增加、删除、更新，载入等操作。

UPDATE - 更新数据库表中的数据 
DELETE - 从数据库表中删除数据 
INSERT INTO - 向数据库表中插入数据
REPLACE INTO- 向数据库表中插入数据，如果存在先删除
LOAD - 载入数据
（5）TCL（Transaction Control Language，事务控制语言）
又名TPL（Transaction Process Language）事务处理语言，它能确保被DML语句影响的表的所有行及时得以更新。TPL语句包括：

START TRANSACTION 或 BEGIN - 开始事务
SAVEPOINT - 在事务中设置保存点，可以回滚到此处
ROLLBACK - 回滚 
COMMIT - 提交
SET TRANSACTION – 改变事务选项
（6）CCL（Cursor Control Language，游标控制语言）
游标（cursor）是DBMS为用户开设的一个数据缓冲区，存放SQL语句的执行结果。游标控制语言对游标的操作主要有：

DECLARE CURSOR - 申明游标
OPEN CURSOR - 打开游标
FETCH INTO - 取值
UPDATE WHERE CURRENT - 更新游标所在的值
CLOSE CURSOR - 关闭游标
下面将从上面的六个子语言来陈述 MySQL 的常用 SQL 语句和相关命令。

4.常用命令
本人使用 MySQL 版本是 5.1.61，下面所有命令均在本版本 MySQL 测试通过，如遇到问题，请留言探讨！

4.1 准备篇
4.1.1 连接本地 MySQL
首先打开shell命令终端或者命令行程序，键入命令mysql -u root -p，回车后提示输入密码。注意用户名和密码与命令选项之间的空格可有可无。

mysql -u[username] -p[password] -A #中括号中的变量需要替换指定值
如果刚安装好 MySQL，超级用户 root 没有密码，直接回车即可进入 MySQL，MYSQL 的提示符是： mysql>。mysql 命令结束使用分号；或者 \g。

命令选项 -A（–no-auto-rehash）的作用是禁止数据表自动补全。如果数据库数据表很多，当我们打开数据库时，即 use dbname时，需要对数据表进行预处理以满足自动补全的功能，将会很耗时。使用 -A 可禁止该操作。

4.1.2 连接远程 MySQL
假设远程主机的 IP 为：110.110.110.110，用户名为 root，密码为 abc123。则键入以下命令：

mysql -h110.110.110.110 -uroot -p123;
注意：

h 与 IP 地址、u 与 root之间可以不用加空格，p 也一样。
MySQL 服务端口默认是 3306，如果不是可使用 -P 或 ----port 指定。
4.1.3 退出 MySQL
mysql> exit;
#或
mysql> quit;
4.1.4 查看 MySQL 版本
mysql> select version();
#或者
mysql> status;
4.2 DCL篇（数据控制篇）
4.2.1 新建用户
#命令格式
mysql> create user [username]@[host] identified by [password];

#示例
mysql> create user lvlv@localhost identified by 'lvlv';
mysql> create user lvlv@192.168.1.1 identified by 'lvlv';
mysql> create user lvlv@"%" identified by 'lvlv';
mysql> CREATE USER lvlv@"%";
说明：
username – 你将创建的用户名；
host – 指定该用户在哪个主机上可以登陆，如果是本地用户可用localhost，如果想让该用户可以从任意远程主机登陆，可以使用通配符%。
password – 该用户的登陆密码，密码可以为空，如果为空则该用户可以不需要密码登陆MySQL服务器。

创建的用户用户信息存放于mysql.user数据表中。

4.2.2 删除用户
#命令格式
mysql> DROP USER [username]@[host];

#示例
mysql> DROP USER lvlv@localhost;
说明：删除用户时，主机名要与创建用户时使用的主机名称相同。

4.2.3 用户授权
#命令格式
mysql> GRANT [privileges] ON [databasename].[tablename] TO [username]@[host];

#示例
mysql> GRANT select ON *.* TO lvlv@'%';
mysql> GRANT ALL ON *.* TO lvlv@'%';

#最后不要忘了刷新权限
mysql> flush privileges;
说明：
（1）privileges – 是一个用逗号分隔的赋予MySQL用户的权限列表，如SELECT , INSERT , UPDATE 等（详细列表见该文末附录1）。如果要授予所有的权限则使用ALL；databasename – 数据库名，tablename-表名，如果要授予该用户对所有数据库和表的相应操作权限则可用*表示，如*.*。

（2）使用GRANT为用户授权时，如果指定的用户不存在，则会新建该用户并授权。设置允许用户远程访问MySQL服务器时，一般使用该命令，并指定密码。

#示例
mysql> GRANT select ON *.* TO lvlv@'%' identified by '123456';
4.2.4 撤销用户权限
#命令格式
mysql> REVOKE [privileges] ON [databasename].[tablename] FROM [username]@[host];

#示例
mysql> REVOKE SELECT ON *.* FROM lvlv@'%';
mysql> REVOKE ALL ON *.* FROM 'lvlv'@'%';
说明:
（1）privilege, databasename, tablename – 同授权部分。

（2）假如你在给用户'pig'@'%'授权的时候是这样的(或类似 的):GRANT SELECT ON test.user TO 'pig'@'%’, 则在使用 REVOKE SELECT ON *.* FROM ‘pig’@'%’;命令并不能撤销该用户对test数据库中user表的SELECT 操作。相反,如果授权使用的是GRANT SELECT ON *.* TO 'pig'@'%’;则REVOKE SELECT ON test.user FROM 'pig'@'%';命令也不能撤销该用户对test数据库中user表的select权限。

具体信息可以用命令SHOW GRANTS FOR 'pig'@'%'; 查看。

4.2.5 查看用户权限
方法一：可以从mysql.user表中查看所有用户的信息，包括用户的权限。

mysql>select * from mysql.user where user='username' \G
方法二：查看给用户的授权信息。

#命令格式
mysql> show grants for [username]@[host];

#示例
mysql> show grants for lvlv@localhost;
mysql> show grants for lvlv;
说明：不指定主机名称，默认为任意主机"%"。

4.2.6 修改用户密码
方法一：使用SQL语句。

#命令格式：
mysql> SET PASSWORD FOR [username]@[host]= PASSWORD([newpassword]);

#示例
mysql> set password for lvlv@localhost=password('123456');
如果是当前登录用户：

mysql> SET PASSWORD = PASSWORD("newpassword");
方法二：使用服务端工具mysqladmin来修改用户密码。

#命令格式
mysqladmin -u[username] -p[oldpassword] password [newpassword]

#示例
mysqladmin -ulvlv -p123456 password "123321"
4.3 DDL 篇（数据定义篇）
4.3.1 创建数据库
#命令格式
mysql> create database [databasename];

#示例
mysql> create database Student;
4.3.2 删除数据库
#命令格式
mysql> drop database [databasename];

#示例
mysql> drop database Student;
4.3.3 查看所有数据库
mysql> show databases;
4.3.4 查看当前数据库
mysql> select database();

#或者
mysql> status;
4.3.5 连接数据库
#命令格式
mysql> use [databasename]

#示例
mysql> use Student;
4.3.6 创建数据表
命令格式：

mysql> create table [表名] ( [字段名1] [类型1] [is null] [key] [default value] [extra] [comment],
...
)[engine] [charset];
说明： 上面的建表语句命令格式，除了表名，字段名和字段类型，其它都是可选参数，可有可无，根据实际情况来定。is null表示该字段是否允许为空，不指明，默认允许为NULL；key表示该字段是否是主键，外键，唯一键还是索引；default value表示该字段在未显示赋值时的默认值；extra表示其它的一些修饰，比如自增auto_increment；comment表示对该字段的说明注释；engine表示数据库存储引擎，MySQL支持的常用引擎有ISAM、MyISAM、Memory、InnoDB和BDB(BerkeleyDB)，不显示指明默认使用MyISAM；charset表示数据表数据存储编码格式，默认为latin1。

存储引擎是什么？ 其实就是如何实现存储数据，如何为存储的数据建立索引以及如何更新，查询数据等技术实现的方法。

主键（Primary Key）与唯一键（Unique Key）的区别：
（1）主键的一个或多个列必须为NOT NULL，而唯一键可以为NULL；
（2）一个表只能有一个主键，但可以有多个唯一键。

以学生表为例，演示数据表的创建。

学生表设计：

字段(Field)	类型(Type)	可空(Null)	键(Key)	其他(Extra)
学号（studentNo）	INT UNSIGNED	NOT NULL	PRI	auto_increment
姓名（name）	VARCHAR(12)	NOT NULL	N	
学院（school）	VARCHAR(12)	NOT NULL	N	
年级（grade）	VARCHAR(12)	NOT NULL	N	
专业（major）	VARCHAR(12)	NOT NULL	N	
性别（gender）	Boolean	NOT NULL	N	
爱好(hobby)	VARCHAR(128)	NULL	N	
建表语句：

create table if not exists student(
    studentNo int unsigned not null comment '学号' auto_increment,
    name varchar(12) not null comment '姓名',
    school varchar(12) not null comment '学院',
    grade varchar(12) not null comment '年级',
    major varchar(12) not null comment '专业',
    gender boolean not null comment '性别',
    hobby varchar(128) null comment '爱好',
    primary key(studentNo)
)engine=MyISAM default charset=utf8 auto_increment=20160001;
1观察上面的建表语句需要注意四点：
（1）可以使用if not exists来判断数据表是否存在，存在则创建，不存在则不创建，这样可以避免因重复创建表导致失败；
（2）设置主键时可以将primary key放在字段的后面来修饰，也可以另起一行单独来指定主键；
（3）not null表示字段不允许为空，不指明，默认允许为NULL，也可以显示指明NULL，表示允许为空；
（4）设置自增时，可以指定自增的起始值，MySQL默认是从1开始自增，比如QQ号是从10000开始的。

关于MySQL支持的数据类型，可参考MySQL 数据类型

4.3.7 查看 MySQL 支持的存储引擎和默认的存储引擎
#查看所支持的存储引擎
mysql> show engines;

#查看默认的存储引擎
mysql> show  variables  like '%storage_engine';
4.3.8 删除数据表
删除数据表的命令格式：

DROP TABLE [IF EXISTS] table_name1 [ ,table_name2, table_name3 ...]
示例：

#删除单个数据表。
drop table [tablename];

#数据表存在时才删除，不会产生 Warning。
drop table if exists [tablename];

#同时删除多个数据表。
drop table if exists [tablename0,tablename1,...];
4.3.9 查看当前数据库有哪些数据表
show tables; 	#不能使用limit子句

#模糊查找
show tables like "%<tb_name>%"

#指定数据库查看数据表
mysql>show tables from [databaseName]

#或者
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'DATABASE_TO SEARCH_HERE' AND TABLE_NAME LIKE "table_here%"  LIMIT 5;
14.3.10 查看数据表结构
desc [tablename];

#或
describe [tablename];
查看上面创建的student数据表的结构如下：

4.3.11 查看建表语句
show create table [tablename]
4.3.12 重命名数据表
rename table [tablename] to [newtablename];
4.3.13 增加、删除和修改字段自增长
（1）删除字段自增长

#命令格式
mysql>alter table [tablename] change [columnname] [columnname] [type];

#示例，取消studentNo的自增长
mysql>alter table student change studentNo studentNo int(10) unsigned;
说明：注意列名称要重复一次，即需要将列的名称写两次。

（2）增加字段自增长

#命令格式
mysql>alter table [tablename] modify [columnname] [type] auto_increment;

#或者与上面删除字段自增长相反
mysql>alter table [tablename] change [columnname] [columnname] [type] auto_increment;

#示例，添加studentNo自增长
mysql>alter table student modify studentNo int(10) unsigned auto_increment;
说明：添加自增长的列必须为NOT NULL及PRIMARY KEY（UNIQUE）属性。如果不是，需添加相应定义。

（3）修改自增长起始值

#命令格式
mysql> alter table [tablename] auto_increment=[value];

#示例，设置studentNo从10000开始自增
mysql> alter table [tablename] auto_increment=10000;
**注意：**设定的起始值value只能大于已有的auto_increment的整数值，小于的值无效。
show table status like 'table_name' 或者show create table [tablename]可以看到auto_increment这一列现有的起始值。

4.3.14 增加、删除和修改数据表的列
（1）增加列

#命令格式
mysql>alter table [tablename] add column [columnname] [columdefinition] [after columnname];

#示例1，为数据表student增加家乡hometown
mysql>alter table student add column hometown varchar(32) comment '家乡';

#示例2，在指定列后新增列，而非默认最后一列
mysql>alter table student add column hometown varchar(32) comment '家乡' after major;

#示例3，同时增加多个列
mysql>alter table student add hometown varchar(32) comment '家乡' after major,add hobby varchar(128) after hometown;
11（2）删除列

ALTER TABLE table_name DROP COLUMN column1, DROP COLUMN column2, ...;
如果您想删除表 orders 中的 quantity 和 price 列，则可以使用以下语句：

ALTER TABLE orders DROP COLUMN quantity, DROP COLUMN price;
（3）重命名列

alter table [tablename] change [columnname] [newcolumnname] [type];
（4）修改列属性

alter table [tablename] modify [columnname] [newdefinition];
如修改 home 类型为 varchar(64) 且不允许 NULL：

alter table student modify home varchar(64) not null;
4.3.15 添加、删除和查看索引
（1）添加索引

#命令格式
mysql> alter table [tablename] add index [indexname](字段名1,字段名2…);

#示例，为数据表student数据列studentNo添加索引
mysql> alter table student add index index_studentNo(studentNo);
#或者
mysql> alter table student add index(studentNo);
说明： 上面示例的第二种方法，如果不显示指明索引名称的话，默认以列名称作为索引的名称。添加索引是为了提高查询的速度。

（2）查看索引

mysql> show index from [tablename];
#命令格式
mysql> alter table [tablename] drop index [indexname];

#示例
mysql> alter table student drop index index_studentNo;
4.3.16 创建临时表
#命令格式
mysql> create temporary table [表名] ( [字段名1] [类型1] [is null] [key] [default value] [extra] [comment],...);

#示例
mysql> create temporary table pig(i int);
说明：
（1）创建临时表与创建普通表的语句基本是一致的，只是多了一个temporary关键；
（2）临时表的特点是：表结构和表数据都是存储到内存中的，生命周期是当前MySQL会话，会话结束后，临时表自动被drop；
（3）注意临时表与Memory表（内存表）的区别是：
（3.1）Memory表的表结构存储在磁盘，临时表的表结构存储在内存；
（3.2）show tables看不到临时表，看得到内存表；
（3.3）内存表的生命周期是服务端MySQL进程生命周期，MySQL重启或者关闭后内存表里的数据会丢失，但是表结构仍然存在，而临时表的生命周期是MySQL客户端会话。
（3.4）内存表支持唯一索引，临时表不支持唯一索引；
（3.5）在不同会话可以创建同名临时表，不能创建同名内存表。

4.3.17 创建内存表
与创建表的命令格式相同，只是显示的在后面指明存储引擎为MEMORY。

#命令格式
mysql> create table [表名] ( [字段名1] [类型1] [is null] [key] [default value] [extra] [comment],...)engine=memory;

#示例
mysql> create table pig(i int)engine=memory;
4.3.18 修改数据表的存储引擎
mysql> alter table [tablename] type|engine=[enginename];

#示例，将数据表test存储引擎设置为InnoDB
mysql> alter table test type=InnoDB;
#或者
mysql> alter table test engine=InnoDB;
4.3.19 查看数据库数据表存储位置
mysql> show global variables like "%datadir%";
4.3.20 创建 merge 表
MERGE存储引擎把一组MyISAM数据表当做一个逻辑单元来对待，让我们可以同时对他们进行增删查改。构成一个MERGE数据表结构的各成员MyISAM数据表结构（索引、引擎、列、字符集等）必须相同。

假设你有几个日志数据表，他们内容分别是这几年来每一年的日志记录项，他们的定义都是下面这样，YY代表年份：

CREATE TABLE log_YY  
(  
	dt  DATETIME NOT NULL,  
	info VARCHAR(100) NOT NULL,  
	INDEX (dt) 
) ENGINE = MyISAM;  
假设日志数据表的当前集合包括log_2015、log_2016、log_2017，而你可以创建一个如下所示的MERGE数据表把他们归拢为一个逻辑单元：

CREATE TABLE log_merge 
(
	dt DATETIME NOT NULL,
	info VARCHAR(100) NOT NULL,
    INDEX(dt)
) ENGINE = MERGE UNION=(log_2015,log_2016,log_2017) INSERT_METHOD=LAST;
（1）ENGINE选项的值必须是MERGE或MRG_MyISAM；
（2）UNION选项列出了将被收录在这个MERGE数据表离得各有关数据表。把这个MERGE表创建出来后，就可以像对待任何其他数据表那样查询它，只是每一次查询都将同时作用与构成它的每一个成员数据表 。下面这个查询可以让我们知道上述几个日志数据表的数据行的总数：

SELECT COUNT（*） FROM log_merge;  
（3）除了便于同时引用多个数据表而无需多条查询，MERGE数据表还提供了以下一些便MERGE数据表也支持DELETE 和UPDATE操作。INSERT操作比较麻烦，因为MySQL需要知道应该把新数据行插入到哪一个成员表里去。在MERGE数据表的定义里可以包括一个INSERT_METHOD选项，这个选项的可取值是NO、FIRST、LAST，他们的含义依次是INSERT操作是被禁止的、新数据行将被插入到现在UNION选项里列出的第一个数据表或最后一个数据表。
（4）对现有的merge表可以删除或新增包好的数据表，比如新增相同结构的数据表log_2018。

CREATE TABLE log_2009 LIKE log_2008;  
ALTER TABLE log_merge UNION=(log_2015, log_2016,log_2017,log_2018);
4.3.21 清空表内容
truncate [tablename];
truncate 与 delete 均可以删除表记录，区别主要有如下几点：
（1）truncate 属于 DDL，delete 属于 DML；
（2）truncate 用于删除表中的所有行，delete 可以使用 where 子句有选择地进行删除；
（3）delete 每次删除一行，并在事务日志中为所删除的每行记录一项。truncate 释放存储表数据所用的数据页来删除数据，并且只在事务日志中记录页的释放，所以truncate 比 delete 使用的系统和事务日志资源更少，效率更高；
（4）truncate 导致自动增加字段的初始值被重置，delete 没有影响，自增字段的值还是按照最后一次插入的基础上递增；
（5）对于由 FOREIGN KEY 约束引用的表，不能使用 truncate，而应使用不带 where 子句的 delete 语句。由于 truncate 不记录在日志中，所以它不能激活触发器。
（6）TRUNCATE TABLE 不能用于参与了索引视图的表。
（7）对用 TRUNCATE TABLE 删除数据的表上增加数据时，要使用UPDATE STATISTICS来维护索引信息。
（8）如果有 ROLLBACK 语句，DELETE 操作将被撤销，但 TRUNCATE 不会撤销。

请记住，当你不再需要该表时用 drop；当你仍要保留该表，但要删除所有记录时用 truncate；当你要删除部分记录时用 delete。

4.4 DQL 篇（数据查询篇）
4.4.1 查询记录
命令格式：

SELECT [列名称] FROM [表名称] where [条件]
说明： 一个完整的SELECT语句包含可选的几个子句。SELECT语句的定义如下：

<SELECT clause> [FROM clause] [WHERE clause] [GROUP BY clause] [HAVING clause] [ORDER BY clause] [LIMIT clause]
（1）SELECT 子句是必选的，其它子句如 FROM、WHERE、GROUP BY 子句等是可选的。
（2）一个 SELECT 语句中，子句的顺序是固定的。如 GROUP BY 子句不会位于 WHERE 子句前面。
（3） SELECT 语句执行顺序 ：

开始->FROM子句->WHERE子句->GROUP BY子句->HAVING子句->ORDER BY子句->SELECT子句->LIMIT子句->最终结果
每个子句执行后都会产生一个中间数据结果，即所谓的临时视图，供接下来的子句使用，如果不存在某个子句，就跳过。

MySQL 和标准 SQL 执行顺序基本是一样的。

4.4.2 where 子句
where 子句按所需条件从表中选取数据，如法如下：

SELECT 列名称 FROM 表名称 WHERE 列 运算符 值
下面的运算符可在 WHERE 子句中使用：

运算符	描述
=	等于
!= 或 <>	不等于
>	大于
<	小于
>=	大于等于
<=	小于等于
BETWEEN AND	在某个范围内
LIKE	搜索某种模式
AND	多个条件与
OR	多个条件或
（1）where in 的用法

in 在 where 子句中的用法主要有两种：

in 后面是子查询产生的记录集，注意，子查询结果数据列只能有一列且无需给子表添加别名。
select  *  from  table  where   uname  in(select  uname  from  user); 
in 后面是数据集合。
select * from  table  where   uname  in('aaa',bbb','ccc','ddd','eee',ffff''); 
注意：如果数据类型是字符串，一定要将字符串用单引号标注起来。

4.4.3 group by 子句
group by 子句中的数据列应该是 SELECT 列表中指定的每一列，除非这列是用于聚合函数，如 sum()、avg()、count()等。但是，如果 select 列表中指定的数据列，没有用于聚合函数也不在 group by 子句中，按理说会报错，但是 MySQL 会选择第一条显示在结果集中。

#选择发起加好友请求次数超过10次的QQ(uin)，被加方（to_uin）只会显示第一个
select uin,to_uin,count(*) as reqCnt from inner_raw_add_friend_20170514 group by uin having  reqCnt>10 limit 10;
4.4.4 where 与 having 子句的区别
（1）作用的对象不同。WHERE 子句作用于表和视图，HAVING 子句作用于组；

#选取QQ 3585076592和3585075773在20170514当天发出加好友请求次数且满足次数>1select uin,count(*) as reqCnt from inner_raw_add_friend_20170514 where uin=3585076592 or uin=3585075773 group by uin having  reqCnt>1结果：

（2）作用的阶段不同。WHERE 在分组和聚集计算之前选取输入行（因此，它控制哪些行进入聚集计算），而 HAVING 在分组和聚集之后选取分组。因此，WHERE 子句不能包含聚集函数，因为试图用聚集函数判断哪些行输入给聚集运算是没有意义的。 相反，HAVING 子句一般包含聚集函数。当然，也可以使用 HAVING 对结果集进行筛选，但不建议这样做，同样的条件可以更有效地用于 WHERE 阶段。

#查询指定QQ加好友请求信息（where作用于输入阶段的数据集）
select * from inner_raw_add_friend_20170514 where uin=3585078528;

#等同于having，作用于结果阶段的结果集
select * from inner_raw_add_friend_20170514 having uin=3585078528;
4.4.5 order by 子句
ORDER BY 语句用于根据指定的列对结果集进行排序。ORDER BY 语句默认按照升序对记录进行排序。如果希望按照降序对记录进行排序，可以使用 DESC（descend）关键字，升序关键字是 ASC（ascend），随机使用order by rand()。

#以QQ号码降序排序
select * from inner_raw_add_friend_20170514 order by uin desc;
4.4.6 limit 子句
语法格式如下：

LIMIT [<offset>,] <row_count> | <row_count> OFFSET <offset>
LIMIT 子句可以被用于强制 SELECT 语句返回指定的记录数。LIMIT 接受一个或两个数值参数。参数必须是一个整数常量。如果给定两个参数，有两种用法。

第一种：offset,row_count，第一个参数指定返回记录行的开始偏移量，第二个参数指定返回记录行的最大数目。初始记录行的偏移量是0。

第二种：[row_count] OFFSET [offset]，第一个参数row_count为返回记录行的最大数目，第二个参数offset为返回记录行的开始偏移量。

特殊用法：
（1）只给一个参数，表示返回记录行的TOP最大行数，起始偏移量默认为0；
（2）返回从起始偏移量开始，返回剩余所有的记录，可以使用一些值很大的第二个参数。如检索所有从第96行到最后一行:

SELECT * FROM tbl LIMIT 95,18446744073709551615;
注意，MySQL目前不支持使用-1表示返回从偏移量开始剩余的所有记录，即下面的写法是错误的：

SELECT * FROM tbl LIMIT 95,-4.4.7 distinct 用法
（1）在使用 MySQL 时，有时需要查询出某个字段不重复的记录。虽然 mysql提供有distinct这个关键字来过滤掉多余的重复记录只保留一条，但往往只用它来返回不重复记录的条数。

#选择每一个QQ发起加好友请求涉及到的不同的QQ数
select uin,count(distinct toUin) from addFriend group by uin;
（2）distinct 用于选择不同的记录，且只能放在所选列的开头，作用于紧随其后的所有列。

#查询 uin 和 toUin 不重复的加好友请求
select distinct uin,toUin from addFriend;

#示例数据表
uin      toUin
10000    1234510000    1212110001    1212110001    13131
#结果集
uin      toUin
10000    1234510000    1212110001    1212110001    131311111111如果想使 distinct 的功能作用于第二列的 toUin，使用 distinct 是无望了，因为 MySQL 语法尚不支持，可以使用 group by 取而代之。

select uin,toUin from addFriend where group by toUin;

#结果集
uin      toUin
10000    1234510000    1212110001    13131这个奇怪的技巧只能存在于 MySQL 中，因为标准的 SQL 语法规定非聚合函数中的列一定要存在于 group by 子句中。MySQL 规定，当非聚合函数中的列不存在于 group by 子句中，则选择每个分组的第一行。

（3）count distinct 统计符合条件的记录。

找了很长时间，有两种方法：

可以使用count(distinct case where 条件 then 字段 end)，具体参见 MySQL distinct count if conditions unique；
使用count(distinct xx,if(use_status=1,true,null))，参见 mysql count if distinct。
4.4.8 检查查询语句的执行效率
explain [select statement];

#或者
desc [select statement];
检查的结果类似于如下形式：

如果想以列的方式展示的话，在语句之后加上\G，结果展示类似于如下形式：

4.4.9 查看SQL执行时的警告
show warnings;
4.4.10 union的用法
union 的作用是将两次或多次查询结果纵向联合起来，使用过程需要注意以下几点：

（1）union 的使用条件

union 作用于只要两个结果集，不能直接作用于原表。结果集的列数相同就可以，即使字段类型不相同也可以使用。值得注意的是 union 后字段的名称以第一条 SQL 为准。

（2）union 与 union all 的区别

union用于合并两个或多个select语句的结果集，并消去联合后表中的重复行。union all则保留重复行。

（3）关于 union 的排序

有两张表，内容如下：

对两个结果集按照uin进行降序排序后再联合的结果如下：

可以发现，内层排序没有发生作用，那现在试试在外层排序。

可见外层排序发生了作用。那是不是内层排序就没有用了呢，其实换个角度想想内层先排序，如果外层又排序，明显内层排序显得多余，所以MySQL优化了SQL语句，不让内层排序起作用。要想内层排序起作用，必须要使内层排序的结果能影响最终的结果，如加上limit。

此外，union与join在使用时，有一个本质区别我们必须知道：union只能作用于select结果集，不能直接作用于数据表，join则恰恰相反，只能作用于数据表，不能直接作用于select结果集（可以将select结果集指定别名作为派生表）。

4.4.11 join 的用法
（1）select from 两个表与 inner join on 的区别。

实际测试一下可以看出区别，以 a 和 b 表为例：

select * from a;
+------+------+
| id   | col  |
+------+------+
|    1 |   11 |
|    2 |   12 |
+------+------+

select * from b;
+------+------+
| id   | col  |
+------+------+
|    2 |   22 |
|    3 |   23 |
+------+------+

select * from a,b;
+------+------+------+------+
| id   | col  | id   | col  |
+------+------+------+------+
|    1 |   11 |    2 |   22 |
|    2 |   12 |    2 |   22 |
|    1 |   11 |    3 |   23 |
|    2 |   12 |    3 |   23 |
+------+------+------+------+

select * from a inner join b on a.id=b.id;
+------+------+------+------+
| id   | col  | id   | col  |
+------+------+------+------+
|    2 |   12 |    2 |   22 |
+------+------+------+------+
11111111112222222222333从结果可以看出，select from 两个表的结果是两张表记录的笛卡尔乘积，inner join 则只拼接含有相同字段的记录。

4.4.13 查看数据表行数
主要有两种方法。

第一种：

select count(*) from tableName;
对于 MyISAM 数据表很快，建议使用，因为 MyISAM 数据表事先将行数缓存起来，可直接获取。InnoDB 数据表不建议使用，当数据表行数过大时，因需要扫描全表，查询较慢。

第二种：

select table_name,table_rows from information_schema.tables where TABLE_SCHEMA = 'DatabaseName' and table_name='TableName';  
第三种：

show table status like 'tableName';
第四种：

explain select count(*) from 'tableName';
注意：由于 InnoDB 数据表经常更新，未事先存储表行数，所以方法二、三、四对 InnoDB 数据表所获得的是一个估算的不精确结果。

4.5 DML篇（数据操作篇）
4.5.1 插入记录
（1）inset into 有三种形式。

insert into tablename(column1,column2,...) values(value1,value2,...);

insert into tablename select...

inse into tablename set column1=value1,column2=value2...

#示例
#插入一行
insert into student(name,school,grade,major,gender) values('lvlv0','software','first year','software engineering',0);

#如果插入值刚好与数据表的所有列一一对应，那么可以省略书写插入的指定列
insert into student values(10000,'lvlv0','software','first year','software engineering',0);

#插入多行
insert into student values('lvlv0','software','first year','software engineering',0),('lvlv1','software','first year','software engineering',0);

#使用select结果集进行插入
insert into tablename select * from temp;

#注意，temp数据表的定义要与tablename相同，不同的话，则需要指定需要插入的列，示例如下：
insert into tablename(col0,col1,col2) select col0,col1,col2 from temp;

#使用insert into set
insert into student name='lvlv0', school='software', grade='first year',major='software engineering',gender=111111111122222（3）使用replace into进行插入。如果发现表中已经有此行数据（根据主键或者唯一索引判断）则先删除此行数据，然后插入新的数据。 2. 否则，直接插入新数据

replace into tbl_name(col_name, ...) values(...)

replace into tbl_name(col_name, ...) select ...

replace into tbl_name set col_name=value, ...
注意：
（1）REPLACE语句会返回一个数，来指示受影响的行的数目。该数是被删除和被插入的行数的和。如果对于一个单行REPLACE该数为1，则一行被插入，同时没有行被删除。如果该数大于1，则在新行被插入前，有一个或多个旧行被删除。如果表包含多个唯一索引，并且新行包含了在不同的唯一索引的旧值，则有可能是一个单一行替换了多个旧行。
（2）频繁的REPLACE INTO 会造成新纪录的主键的值迅速增大。总有一天。达到最大值后就会因为数据太大溢出了。就没法再插入新纪录了。数据表满了，不是因为空间不够了，而是因为主键的值没法再增加了。
（3）如果因唯一索引导致旧行被删除，新纪录与老记录的主键值不同，所以其他表中所有与本表老数据主键id建立的关联全部会被破坏。

4.5.2 删除记录
#命令格式
mysql> delete from [tablename] where [condition];

#示例，删除学号为10000的学生记录
mysql> delete from student where from studentNo=1000;
4.5.3 修改记录
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE some_column = some_value;
如将学号为 10000 的学生性别改为女性。

UPDATE student SET gender=1 WHERE studentNo=1000;
这里只列出简单的增删改的 DML 操作，关于全面基础的 DM L教程可参考 W3School SQL教程。

4.5.4 备份还原数据
（1）导出数据库的所有数据表。

#命令格式
mysqldump -u 用户名 -p 数据库名 > 导出的文件名

#示例
mysqldump -u user_name -p123456 database_name > outfile_name.sql
（2）还原整个数据库。
在mysql客户端环境下，选择一个数据库之后，直接执行sql文件即可。

mysql> source file.sql;
（3）导出一个表到 sql 文件。

#命令格式
mysqldump -u 用户名 -p 数据库名 表名>导出的文件名

#示例
mysqldump -u user_name -p 123456 database_name table_name > outfile_name.sql
（4）导入 sql 文件。
方法同还原整个数据库。

（5）将数据表导出到csv文件。

#命令格式
SELECT * FROM [TABLE] INTO OUTFILE '[FILE]';
#或者  
SELECT * FROM [TABLE] INTO OUTFILE '[FILE]' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';  

#示例
select * from student into outfile "student.csv";
说明：

（a）如果不指明输出文件的输出目录，默认输出至数据库文件的存储目录。可使用命令find / -name student.csv来查看具体位置。

（b）如果使用指定csv文件输出目录的话，报如下错误：
ERROR 1 (HY000): Can't create/write to file (Errcode: 13)，错误的原因是所在目录没有写权限，给所在的目录增加写权限即可。

（6）导入 csv 文件。

#命令格式
LOAD DATA INFILE '[FILE]' INTO TABLE [TABLE];  
#或者  
LOAD DATA INFILE '[FILE]' INTO TABLE [TABLE] FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

#示例
load data infile '/root/dablelv/student.csv' into table student;
注意：

指定 csv 文件时使用绝对路径，否则 MySQL 默认从数据库存储的目录寻找；
在导入时，如果出现如下错误：
`ERROR 13 (HY000) at line 1: Can't get stat of '/fullpath/file.csv' (Errcode: 13)`
检查之后并非文件没有可读权限，请使用load data local infile。

加不加 local 的区别是：

（a）MySQL客户端与服务端在同一台主机时，加不加LOCAL是一样的，因为，因为默认从服务器端读取文件。
（b）MySQL客户端与服务端不在同一台主机时，即使用本MySQL客户端将本地数据导入远程MySQL，需要加LOCAL。

默认域分隔符为Tab，空格或其它分隔符需显示指定。
（7）导入excel文件。
同导入csv文件的方法一致。注意，导入文件时，都需要提前建立好与文件内各个段对应好的数据表，并且文件的路径需要使用引号括起来，双引号和单引号都可以。

（8）导出远程mysql select结果集到本地。
使用如下方法不可行，因为这个语句并不是在MySQL客户端，而是在MySQL的服务器上执行的，通常用于服务器管理员在服务器机器上进行数据备份使用，由于MySQL客户端账号并没有访问服务器机器本身的权限，所以这个SQL执行不会成功。即使有权限，select结果集会被导出到MySQL服务端，而非本地。

mysql -h10.10.10.10 -ucrazyant -p123456 -P3306 -e "select * into from tb_name where [conditions] into outfile '/tmp/file.txt'"
正确方法，使用重定向的方式，将select结果导出到本地。

mysql -h10.10.10.10 -ucrazyant -p123456 -P3306 -e "select * into from tb_name where [conditions]" > /tmp/file.txt
4.6 TCL 篇（事务控制篇）
说到事务控制，先说一下数据库的事务是什么以及 MySQL 中我们必知的知识点。

事务的四大特性
数据库事务(Database Transaction) ，是指对数据库的一系列操作组成的逻辑工作单元（unit）。

并非任意的对数据库的操作序列都是数据库事务。数据库事务拥有以下四个特性，习惯上被称之为ACID特性。

（1）原子性（Atomicity）

事务作为一个整体被执行，包含在其中的对数据库的操作要么全部被执行，要么都不执行。

（2）一致性（Consistency）

事务应确保数据库的状态从一个一致状态转变为另一个一致状态。一致状态的含义是数据库中的数据应满足完整性约束。

（3）隔离性（Isolation）

多个事务并发执行时，一个事务的执行不应影响其他事务的执行。

（4）持久性（Durability）

已被提交的事务对数据库的修改应该永久保存在数据库中。

MySQL中并非所有的数据库存储引擎都支持事务操作，比如 ISAM 和 MyISAM 就不支持。所以，使用事务处理的时候一定要确定所操作的表示是否支持事务处理，可以通过查看建表语句来查看有没有指定事务类型的存储引擎。当然，事务处理是为了保障表数据原子性、一致性、隔离性、持久性。这些都是要消耗系统资源的，要谨慎选择。

下面以数据库引擎 InnoDB 为例来演示命令行模式下事务的基本操作。

查看是否自动提交事务
MySQL默认操作模式就是autocommit自动提交模式。自动提交事务由会话变量autocommit来控制，该变量只对当前会话有效。

mysql> select @@global.autocommit;
mysql> show variables like '%autocommit%';
说明： 环境变量autocommit是用来控制一条SQL语句提交后是否自动执行，默认值是1，表示在mysql命令行模式下每条增删改语句在键入回车后，都会立即生效，而不需要手动commit。我们可以把它关闭，关闭之后就需要commit之后，SQL语句才会真正的生效。

关闭和开启自动提交事务
（1）关闭自动提交事务
MySQL默认是自动提交事务的，关闭自动提交事务主要有两种方法。一种是临时关闭，只对当前会话有效。第二种是永久关闭，对所有会话有效。

第一种：临时关闭。

#关闭当前会话的自动提交事务
mysql> set autocommit = 0;
这样之后，所有增删改语句，都必须使用commit之后，才能生效；

第二种：永久关闭。
通过修改配置文件my.cnf文件，通过vim编辑my.cnf文件，在[mysqld]（服务器选项下）添加：

autocommit=保存，然后重启mysql服务即可生效。

（2）开启自动提交事务
如果需要，可以开启自动提交模式。

mysql> set autocommit=1;
或者将上面配置文件中的新增的autocommit=0删除即可。

事务执行的基本流程
首先创建一个测试数据表，建表语句如下：

mysql> create table transactionTest(a int primary key)engine=InnoDB;
（1）开启一个事务

mysql> start  transaction；      

#或者
mysql> begin;
（2）执行一系列增删改语句

mysql> insert into transactionTest values(1);
（3）手动提交或者回滚
事务回滚：

mysql> rollback;
会滚后我们查看数据表中的数据时为：

mysql> select * from transactionTest;
Empty set (0.00 sec)
表中没有数据，回滚成功。

手动提交事务：

mysql> commit;
提交后，再rollback的话已经不能回滚了，数据已经插入到数据表了。这里需要注意的是，在当前会话中，我们还没有手动commit提交事务的时候，表中的数据已经被插入了，但对于其它会话，如果事务隔离级别是read commited，那么在commit之前，是查询不到新插入的记录的。

设置事务的保存点
#设置折返点
mysql> savepoit [pointname];

#回滚至折返点
mysql> rollback to savepoint [pointname];
发生在保存点之前的事务被提交，之后的被忽略。

事务的隔离级别
在数据库操作中，为了有效保证并发读取数据的正确性，提出了事务隔离级别。

数据库是要被广大客户所共享访问的，那么在数据库操作过程中很可能出现以下几种不确定情况。

（1）更新丢失（Update Lost）

两个事务都同时更新一行数据，一个事务对数据的更新把另一个事务对数据的更新覆盖了。这是因为系统没有执行任何的锁操作，因此并发事务并没有被隔离开来。

（2）脏读（Dirty Read）
一个事务读取到了另一个事务未提交的数据操作结果。这是相当危险的，因为很可能所有的操作都被回滚。

（3）不可重复读（Non-repeatable Read）
指的是同一事务中的多个select语句在读取数据时，前一个select和后一个select得到的结果不同。原因是第一次读取数据后，另外的事务对其做了修改，当再次读该数据时得到与前一次不同的值。

（4）幻读（Phantom Read）
MySQL高性能这样写道：所谓幻读，指的是当某个事务在读取某个范围内的记录时，另外一个事务又在该范围内插入了新的记录，当之前的事务再次读取该范围内的记录时，会产生幻行。

这里的幻行是什么意思呢？并不是说第二次读取的时候多出来了新的记录，这样就成了不可重复读。

那么是如何证明有第二次查询有幻行出现：通过在读事务中插入新纪录的数据，会发现报冲突错误，但是我查询的时候并没有这条数据记录。通过写操作来证明有一条幻行记录。

通过图片可以看出即使事务A两次查询操作结果一样，但当插入id=3的这行数据时报主键冲突，这个就是幻行。

为了解决上面的问题，于是就提出事务隔离。事务隔离的级别从低到高有四个级别分别是：

RU 级别：Read Uncommitted 读未提交。允许脏读、不可重复读、幻像
RC 级别：Read committed 读已提交。允许不可重复读、幻像，不允许脏读
RR 级别：Repeatable Read 可重复读。允许幻读，不允许脏读和不可重复读和脏读。InnoDB 默认级别
S 级别：Serializable 。不允许脏读、不可重复读、幻读
注意：MySQL InnoDB 的 RR 级别和其他数据库是有区别的，不会造成幻读。

RU 级别
所有事务都可以读取未提交事务的执行结果，也就是允许脏读。但不允许更新丢失。如果一个事务已经开始写数据，则另外一个事务则不允许同时进行写操作，但允许其他事务读该事务增删改的数据。该隔离级别可以通过“排他写锁”实现。

RC 级别
允许不可重复读取，但不允许脏读取。这可以通过“瞬间共享读锁”和“排他写锁”实现。读取数据的事务允许其他事务继续访问该行数据，但是未提交的写事务将会禁止其他事务访问该行。

RR 级别
禁止不可重复读取和脏读取。这可以通过“共享读锁”和“排他写锁”实现。读取数据的事务将会禁止写事务（但允许读事务），写事务则禁止任何其他事务。按照这种说法，是不会出现幻读的，MySQL的InnoDB的可重复读隔离级别和其他数据库的可重复读是有区别的，不会造成幻象读（phantom read）。

S 级别
提供严格的事务隔离。它要求事务序列化执行，事务只能一个接着一个地执行，不能并发执行。仅仅通过“行级锁”是无法实现事务序列化的，必须通过其他机制保证新插入的数据不会被刚执行查询操作的事务访问到。

隔离级别越高，越能保证数据的完整性和一致性，但是对并发性能的影响也越大。对于多数应用程序，可以优先考虑把数据库系统的隔离级别设为 RC 级别。它能够避免脏读取，而且具有较好的并发性能。尽管它会导致不可重复读、幻读和第二类丢失更新这些并发问题，在可能出现这类问题的个别场合，可以由应用程序采用悲观锁或乐观锁来控制。

（1）查看全局和当前会话的事务隔离级别。

#查看全局
mysql> SELECT @@global.tx_isolation; 

#查看当前会话
mysql> SELECT @@session.tx_isolation; 
mysql> SELECT @@tx_isolation;
mysql> show variables like 'tx_isolation';
（2）更改事务的隔离级别

SET [SESSION | GLOBAL] TRANSACTION ISOLATION LEVEL {READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE}

#默认更改当前会话事务隔离级别
mysql> set tx_isolation='read-committed';
**注意：**不显示指明 session 和 global，默认的行为是带 session，即设置当前会话的事务隔离级别。如果使用 GLOBAL 关键字，为之后的所有新连接设置事务隔离级别。需要 SUPER 权限来做这个。MySQL 的 InnoDB 默认的事务隔离等级是 RR。

4.7 CCL（游标控制语言）
游标（Cursor）是系统为用户开设的一个数据缓冲区，存放 SQL 语句的执行结果。每个游标区都有一个名字，用户可以用SQL语句逐一从游标中获取记录，并赋给主变量，交由主语言进一步处理。

游标的操作主要用于存储过程中用来书写过程化的 SQL，类似于Oracle的PL/SQL。使用 SQL 的一般遵循的步骤如下。
(1) 声明游标，把游标与 T-SQL 语句的结果集联系起来。
(2) 打开游标。
(3) 提取数据。
(4) 关闭游标。

4.7.1 定义游标
DECLARE cursor_name CURSOR FOR select_statement
这个语句声明一个游标。也可以在子程序中定义多个游标，一个块中的每一个游标必须命名唯一。

4.7.2 打开游标
OPEN cursor_name
这个语句打开先前声明的游标。

4.7.3 根据游标提取数据
FETCH cursor_name INTO var_name1,var_name2...
这个语句用指定的打开游标读取下一行（如果有下一行的话），并且推进游标指针至该行。

4.7.4 关闭游标
CLOSE cursor_name
这个语句关闭先前打开的游标，注意，用完后必须关闭

上面简单的介绍了游标的基本用法，下面给出一个实例，下面是一个存储过程，里面用到游标，逐条更新数据（批量更新数据）。

DELIMITER $  
CREATE PROCEDURE updateBatchRecord()
BEGIN
	DECLARE  no_more_record INT DEFAULT 0;
	DECLARE  pID BIGINT(20);
	DECLARE  pValue DECIMAL(15,5);
	DECLARE  cur_record CURSOR FOR   SELECT colA, colB from tableABC;  /*首先这里对游标进行定义*/
	DECLARE  CONTINUE HANDLER FOR NOT FOUND  SET  no_more_record = 1; /*这个是个条件处理,针对NOT FOUND的条件,当没有记录时赋值为1*/

	OPEN  cur_record; /*接着使用OPEN打开游标*/
	FETCH  cur_record INTO pID, pValue; /*把第一行数据写入变量中,游标也随之指向了记录的第一行*/

	WHILE no_more_record != 1 DO
		INSERT  INTO testTable(ID, Value) VALUES (pID, pValue);
		FETCH  cur_record INTO pID, pValue;
	END WHILE;
	CLOSE  cur_record;  /*用完后记得用CLOSE把资源释放掉*/
END$
DELIMITER ;
1111111111关于 MySQL 存储过程的简单介绍，见博文 MySQL存储过程。

5.MySQL 常用函数
5.1 日期和时间函数
（1）now() 返回当前日期时间。

select now();
+---------------------+
| now()               |
+---------------------+
| 2019-04-16 15:05:12 |
+---------------------+
（2）curdate() 返回当前日期。

select curdate();
+------------+
| curdate()  |
+------------+
| 2019-04-16 |
+------------+
（3）curtime() 返回当前时间。

select curtime();
+-----------+
| curtime() |
+-----------+
| 15:10:36  |
+-----------+
（4）时间选取函数。

set @dt = '2019-04-16 15:05:12.123456';

date(@dt)：返回日期，示例结果2019-04-1time(@dt)：返回时间，示例结果15:05:12.12345year(@dt)：返回年 ，示例结果201month(@dt)：返回月，示例结果day(@dt)：返回日，示例结果1hour(@dt)：返回时，示例结果1minute(@dt)：返回分，示例结果0second(@dt)：返回秒，示例结果1microsecond(@dt)：返回微秒，示例结果12345quarter(@dt)：返回季度，范围1到4。示例结果week(@dt)：返回周，范围0到52。示例结果1dayofyear(@dt) ：返回@dt在一年中的日数，范围在1到366。示例结果10dayofmonth(@dt) ：返回@dt的月份中日期，在1到31范围内。示例结果1monthname(@dt) ：返回@dt的月份名字。示例结果April
dayname(@dt) ：返回@dt的星期名字。示例结果Tuesday
11111111（5）Unix 时间戳与日期之间的转换。

Unix 时间戳转换为日期用函数： FROM_UNIXTIME()。

select FROM_UNIXTIME(1156219870);

日期转换为 Unix 时间戳用函数： UNIX_TIMESTAMP()。

Select UNIX_TIMESTAMP(’2006-11-04 12:23:00′);

5.2 字符串函数
substr(…)
主要用法有：

SUBSTR(str,pos)
SUBSTR(str FROM pos)
SUBSTR(str,pos,len)
SUBSTR(str FROM pos FOR len)

SUBSTR 是 SUBSTRING 的别称。参数 str 为原字符串；pos为下标，从1 开始，如果为负数表示从后往前；len 表示截取的字符数。

SELECT SUBSTRING('Quadratically',5);
-> 'ratically'

SELECT SUBSTRING('foobarbar' FROM 4);
-> 'barbar'

SELECT SUBSTRING('Quadratically',5,6);
-> 'ratica'

SELECT SUBSTRING('Sakila', -3);
-> 'ila'

SELECT SUBSTRING('Sakila', -5, 3);
-> 'aki'

SELECT SUBSTRING('Sakila' FROM -4 FOR 2);
-> 'ki'

substring_index(…)
按分隔符截取字符串前 N 个或者后 N 个子串。函数原型如下：

substring_index(str,delim,count)
substring_index(…) 返回字符串 str 按分隔符 delim 分隔的 count 个子串，对分隔符区分大小写。如果计数 count 为正，则返回从左到右 count 个子串。如果计数为负数，则返回从右边到左 count 个子串。

用法示例：

select substring_index('www.mysql.com', '.', 2);
-> 'www.mysql'

select substring_index('www.mysql.com', '.', -2);
 -> 'mysql.com'

CONCAT()
CONCAT() 用于连接字符串或表字段。

（1）连接字符串。

注意：concat 函数的任意参数为 NULL，则返回结果为 NULL。

select concat('My', 'S', 'QL');
-> 'MySQL'

select concat('My', NULL, 'QL');
-> NULL

select concat(14.3);
-> '14.3'

（2）连接数据表字段。

select concat(f_name, " ", l_name) as Name from employee where level>3 limit 1;

结果：

+---------------+ 
| Name          | 
+---------------+ 
| Monica Sehgal |

注意：这里用到 concat(…) 函数，用来把字符串串接起来。另外，我们还用到以前学到的 as 给结果列concat(f_name, " ", l_name)起了个别名。

CONCAT_WS()
concat(…) 函数无法为连接结果指定分隔符号，可以使用 concat_ws(…) 函数指定分隔符，ws 是 with separator 简写，函数原型为：

concat_ws(separator,field1,field2,...)

用法示例：

select concat_ws(',','First name','Second name','Last Name');
-> 'First name,Second name,Last Name'

select concat_ws(',',f_name,l_name) AS Name from employee where level>3;
-> 'Monica,Sehgal'

GROUP_CONCAT()
使用 GROUP BY 子句时，可使用 GROUP_CONCAT() 聚集函数将分组中的某个字段进行拼接。如果没有非空值，则返回 NULL。

完整的语法如下所示：

GROUP_CONCAT([DISTINCT] expr [,expr ...]
             [ORDER BY {unsigned_integer | col_name | expr}
                 [ASC | DESC] [,col_name ...]]
             [SEPARATOR str_val])

用法示例：

SELECT student_name, GROUP_CONCAT(test_score)
	FROM student
	GROUP BY student_name;

#或者
SELECT student_name, GROUP_CONCAT(DISTINCT test_score ORDER BY test_score DESC SEPARATOR ' ')
       FROM student
       GROUP BY student_name;

5.3 数学函数
CONV()
conv(…) 函数用于数值进制间的转化，如二进制与十进制之间的转换，十进制与十六进制转换等等。函数原型如下：

conv(N,from_base,to_base)

from_base 表示初始的进制, to_base 表示转化后的进制，进制必须处于 [2, 32] 之间，不然返回 NULL。

使用示例如下：

SELECT CONV('a',16,2); -> '1010'
SELECT CONV('6E',18,8); -> '172'
SELECT CONV(-17,10,-18); -> '-H'

注意：非数字的数值，比如十六进制的0xff，传入 conv(…) 函数时，以字符串的形传入：‘ff’。

5.4 聚合函数
COUNT()
COUNT() 函数用于统计指定条件的行数。主要有如下几种用法：

#返回表的总记录数
count(*)

#返回指定列的值的数目（NULL 不计入）
count(<column>)

#返回指定列的不同值的数目
count(distinct <column>)

#返回符合指定条件的记录数
count(if(<condition>,true,null))

#返回符合指定条件的记录数
count(if(<condition>,true,null))

#返回符合指定条件的记录中某列不同值的数目
count(distinct <column>,if(<condition>,true,null))
#或
count(distinct case where <condition> then <column> end)

尖括号中的内容表示实际使用时需要被替换为实际的值。

5.5 其它函数
inet_aton(…) 与 inet_ntoa(…)
inet_aton(…) 与 inet_ntoa(…) 函数用于点分十进制 IP 地址与无符号整型的互相转换。

函数原型：

#将ip地址转换成数字
inet_aton(ip)

#将数字转换成 IP 地址
inet_ntoa(num)

用法示例：

select inet_ntoa(3232236292);

select inet_aton('192.168.3.4');

ISNULL()
测试参数是否为 NULL。

6.常用功能
（1）显示当前日期。

#显示年月日
mysql> select current_date;
+--------------+
| current_date |
+--------------+
| 2019-04-16   |
+--------------+

（2）当计算器使用

select ((4*4)/2)+25; 

附录
附录1：MySQL权限类型
MySQL的权限可以分为三种类型：数据库、数据表和数据列的权限。从mysql.user表中可查看用户权限信息，查看命令：

mysql>select * from mysql.user where user='username' \G;
列出权限有：

Select_priv: 查看数据表；
Insert_priv: 插入数据表；
Update_priv: 更新数据表；
Delete_priv: 删除数据表记录；
Create_priv: 创建数据库和数据表；
Drop_priv: 删除数据库和数据表；
Reload_priv: 允许使用FLUSH； 
Shutdown_priv: 允许使用mysqladmin shutdown；
Process_priv: 允许使用SHOW FULL PROCESSLIST查看其他用户的进程；
File_priv: 允许使用SELECT… INTO OUTFILE and LOAD DATA INFILE；
Grant_priv: 允许使用grant为用户授权；
References_priv: 未来功能的占位符；现在没有作用；
Index_priv: 确定用户是否可以创建和删除表索引；
Alter_priv: 确定用户是否可以重命名和修改表结构；
Show_db_priv: 确定用户是否可以查看服务器上所有数据库的名字，包括用户拥有足够访问权限的数据库。可以考虑对所有用户禁用这个权限，除非有特别不可抗拒的原因；
Super_priv: 确定用户是否可以执行某些强大的管理功能，例如通过KILL命令删除用户进程，Allows use of CHANGE MASTER, KILL, PURGE MASTER LOGS, and SET GLOBAL SQL statements. Allows mysqladmin debug command. Allows one extra connection to be made if maximum connections are reached；
Create_tmp_table_priv: 创建临时表；
Lock_tables_priv: 可以使用LOCK TABLES命令阻止对表的访问修改；
Execute_priv: 执行存储过程。此权限只在MySQL5.0及更高版本中有意义。
Repl_slave_priv: 读取用于维护复制数据库环境的二进制日志文件。此用户位于主系统中，有利于主机和客户机之间的通信；
Repl_client_priv: 确定用户是否可以确定复制从服务器和主服务器的位置；
Create_view_priv: 创建视图。此权限只在MySQL5.0及更高版本中有意义；
Show_view_priv: 查看视图或了解视图如何执行。此权限只在MySQL5.0及更高版本中有意义。关于视图的更多信息；
Create_routine_priv: 更改或放弃存储过程和函数。此权限是在MySQL5.0中引入；
Alter_routine_priv: 修改或删除存储函数及函数。此权限是在MySQL5.0中引入的；
Create_user_priv: 执行CREATE USER命令，这个命令用于创建新的MySQL账户；
Event_priv: 确定用户能否创建、修改和删除事件。这个权限是MySQL 5.1.6新增；
Trigger_priv: 创建和删除触发器，这个权限是MySQL 5.1.6新增的；

MySQL特别的权限： 
ALL: 允许做任何事(和root一样)； 
USAGE: 只允许登录，其它什么也不允许做。