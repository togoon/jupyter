
基本的数据库操作命令：
mysql -u root -p  --连接
mysql -uroot -proot -- 连接数据库
update user set password=password('123456')where user='root';  -- 修改密码
flush privileges;  -- 刷新权限
show databases; -- 显示所有数据库
use school; -- 选择school数据库
show tables; -- 显示数据库中所有的表
describe student; -- 显示表mysql数据库中student表的列信息
create database book; -- 创建数据库book
use book; -- 选择book数据库

exit; -- 退出Mysql
? 命令关键词 : 寻求帮助
-- 表示单行注释
/*
SQL的多行注释
*/


CREATE DATABASE westos; 创建数据库；
create database if not exists westos;
DROP DATABASE westos;  删除数据库；
drop database if exists westos;
SHOW DATABASES;  查看数据集；
DESC table; 查看表的结构
-- tab键上面，如果你的表名或字段名是一个特殊字符，就需要带 ``
USE book;  使用数据库；


CREATE TABLE `user`( 
    `id` INT(10) NOT NULL COMMENT '学员ID', 
    `name` VARCHAR(100) NOT NULL COMMENT '学员姓名', 
    `age` INT(3) NOT NULL COMMENT '学员年龄', 
    PRIMARY KEY (`id`)
) ENGINE=INNODB CHARSET=utf8 COLLATE=utf8_general_ci;


-- 目标 : 创建一个school数据库
-- 创建学生表(列,字段)
-- 学号int 登录密码varchar(20) 姓名,性别varchar(2),出生日期(datatime),家庭住址,email

-- 创建表之前, 一定要先选择数据库
USE school;

CREATE TABLE IF NOT EXISTS `student` (
    `id` int(4) NOT NULL AUTO_INCREMENT COMMENT '学号',
    `name` varchar(30) NOT NULL DEFAULT '匿名' COMMENT '姓名',
    `pwd` varchar(20) NOT NULL DEFAULT '123456' COMMENT '密码',
    `sex` varchar(2) NOT NULL DEFAULT '男' COMMENT '性别',
    `birthday` datetime DEFAULT NULL COMMENT '出生日期',
    `address` varchar(100) DEFAULT NULL COMMENT '地址',
    `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 查看数据库的定义
SHOW CREATE DATABASE school;

-- 查看数据表的定义
SHOW CREATE TABLE student;

-- 显示表结构
DESC student;  -- 设置严格检查模式(不能容错了)SET sql_mode='STRICT_TRANS_TABLES';


CREATE TABLE 表名(
   -- 省略的代码
   -- Mysql注释
   -- 1. # 单行注释
   -- 2. /*...*/ 多行注释
)ENGINE = MyISAM (or InnoDB)

-- 查看mysql所支持的引擎类型 (表类型)
SHOW ENGINES;



USE school;

CREATE TABLE `teacher`( 
    `id` INT(10) NOT NULL COMMENT '教师ID', 
    `name` VARCHAR(100) NOT NULL COMMENT '教师姓名', 
    `age` INT(3) NOT NULL COMMENT '教师年龄', 
    PRIMARY KEY (`id`)
) ENGINE=INNOBASE CHARSET=utf8 COLLATE=utf8_general_ci;

-- 修改表名 :`ALTER TABLE 旧表名 RENAME AS 新表名；`
ALTER TABLE teacher RENAME AS teacher1;

-- 添加字段 : `ALTER TABLE 表名 ADD 字段名 列属性[属性]；`
ALTER TABLE teacher1 ADD age INT(12);

-- 修改字段 : `ALTER TABLE 表名 MODIFY 字段名 列类型[属性]；`
ALTER TABLE teacher1 MODIFY age VARCHAR(12);	-- 修改约束
ALTER TABLE teacher1 CHANGE age age1 INT(12);    -- 字段重命名
最终结论: change用来字段重命名，不能修改字段类型和约束;
		modify不用来字段重命名，只能修改字段类型和约;

-- 删除字段 :  `ALTER TABLE 表名 DROP 字段名；`
ALTER TABLE teacher1 DROP age1;


-- MySQL中的三中循环 while 、 loop 、repeat  求  1-n 的和

DELIMITER $$
 DROP PROCEDURE IF EXISTS test_mysql_while_loop$$
 CREATE PROCEDURE test_mysql_while_loop()
 BEGIN
 DECLARE x INT;
 DECLARE str VARCHAR(255);
 SET x = 1;
 SET str = '';
 WHILE x <= 5 DO
 SET str = CONCAT(str,x,',');
 SET x = x + 1;
 END WHILE;
 SELECT str;
 END$$
DELIMITER ;



DELIMITER //  
CREATE PROCEDURE proc4()  
begin 
declare var int;  
set var=0;  
while var<6 do  
insert into t values(var);  
set var=var+1;  
end while;  
end;  
//  
DELIMITER ;


delimiter $$
drop procedure if exists wk;
create procedure wk(in i int,in m int)
begin
  while i < m DO
    select i as " ";
    set i = i +1000;
  end while;
end $$
delimiter ;
call wk(800000,801000);



-- 第一种 while 循环
-- 求 1-n 的和
/*  while循环语法：
while 条件 DO
            循环体;
end while;
*/
-- 实例：
create procedure sum1(a int)
begin
    declare sum int default 0;  -- default 是指定该变量的默认值
    declare i int default 1;
while i<=a DO -- 循环开始
    set sum=sum+i;
    set i=i+1;
end while; -- 循环结束
select sum;  -- 输出结果
end
-- 执行存储过程
call sum1(100);
-- 删除存储过程
drop procedure if exists sum1

-- 第二种 loop 循环
/*loop 循环语法：
loop_name:loop
        if 条件 THEN -- 满足条件时离开循环
                leave loop_name;  -- 和 break 差不多都是结束训话
        end if；
end loop;
*/

-- 实例：
create procedure sum2(a int)
begin
        declare sum int default 0;
        declare i int default 1;
        loop_name:loop -- 循环开始
            if i>a then
                leave loop_name;  -- 判断条件成立则结束循环  好比java中的 boeak
            end if;
            set sum=sum+i;
            set i=i+1;
        end loop;  -- 循环结束
        select sum; -- 输出结果
end
-- 执行存储过程
call sum2(100);
-- 删除存储过程
drop procedure if exists  sum2


-- 第三种 repeat 循环
/*repeat 循环语法
repeat
    循环体
until 条件 end repeat;
*/


-- 实例；
create procedure sum3(a int)
begin
        declare sum int default 0;
        declare i int default 1;
        repeat -- 循环开始
            set sum=sum+i;
            set i=i+1;
        until i>a end repeat; -- 循环结束
        select sum; -- 输出结果
end

-- 执行存储过程
call sum3(100);
-- 删除存储过程
drop procedure if exists sum3

可用反引号（`）为标识符（库名、表名、字段名、索引、别名）包裹，以避免与关键字重名！中文也可以作为标识符！
每个库目录存在一个保存当前数据库的选项文件db.opt。
注释：
单行注释： # 注释内容
多行注释 ：/* 注释内容 */
单行注释： -- 注释内容 (标准SQL注释风格，要求双破折号后加一空格符（空格、TAB、换行等）)
模式通配符：
_ ： 任意单个字符
% ： 任意多个字符，甚至包括零字符
单引号需要进行转义  \' '
CMD命令行内的语句结束符可以为 ";", "\G", "\g"，仅影响显示结果。其他地方还是用分号结束。delimiter 可修改当前对话的语句结束符。
SQL对大小写不敏感 （关键字）
清除已有语句：\c

直接创建数据库 
create database db1;
进入库
use db1;
查看当前mysql使用的字符集(产生乱码原因）
show variables like 'character%';



-- 创建外键的方式一 : 创建子表同时创建外键
-- 最后一句不加逗号
-- 年级表 (id\年级名称)
CREATE TABLE `grade` (
`gradeid` INT(10) NOT NULL AUTO_INCREMENT COMMENT '年级ID',
`gradename` VARCHAR(50) NOT NULL COMMENT '年级名称',
PRIMARY KEY (`gradeid`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- 学生信息表 (学号,姓名,性别,年级,手机,地址,出生日期,邮箱,身份证号)
-- 学生表的gradeid字段 要去引用年级表的gradeid
-- 定义外键key
-- 给这个外键添加约束 (执行引用)  references引用
CREATE TABLE `student2` (
`studentno` INT(4) NOT NULL COMMENT '学号',
`studentname` VARCHAR(20) NOT NULL DEFAULT '匿名' COMMENT '姓名',
`sex` TINYINT(1) DEFAULT '1' COMMENT '性别',
`gradeid` INT(10) DEFAULT NULL COMMENT '年级',
`phoneNum` VARCHAR(50) NOT NULL COMMENT '手机',
`address` VARCHAR(255) DEFAULT NULL COMMENT '地址',
`borndate` DATETIME DEFAULT NULL COMMENT '生日',
`email` VARCHAR(50) DEFAULT NULL COMMENT '邮箱',
`idCard` VARCHAR(18) DEFAULT NULL COMMENT '身份证号',
PRIMARY KEY (`studentno`),
KEY `FK_gradeid` (`gradeid`),
CONSTRAINT `FK_gradeid` FOREIGN KEY (`gradeid`) REFERENCES `grade` (`gradeid`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;


-- 创建外键方式二 : 创建子表完毕后,修改子表添加外键
CREATE TABLE `student` (
`id` INT(4) NOT NULL COMMENT '学号',
`name` VARCHAR(20) NOT NULL DEFAULT '匿名' COMMENT '姓名',
`sex` TINYINT(1) DEFAULT '1' COMMENT '性别',
`gradeid` INT(10) DEFAULT NULL COMMENT '年级',
`phoneNum` VARCHAR(50) NOT NULL COMMENT '手机',
`address` VARCHAR(255) DEFAULT NULL COMMENT '地址',
`borndate` DATETIME DEFAULT NULL COMMENT '生日',
`email` VARCHAR(50) DEFAULT NULL COMMENT '邮箱',
`idCard` VARCHAR(18) DEFAULT NULL COMMENT '身份证号',
PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

ALTER TABLE `student`
ADD CONSTRAINT `FK_gradeid` FOREIGN KEY (`gradeid`) REFERENCES `grade` (`gradeid`);


-- 删除外键
ALTER TABLE student DROP FOREIGN KEY FK_gradeid;
-- 发现执行完上面的,索引还在,所以还要删除索引
-- 注:这个索引是建立外键的时候默认生成的
ALTER TABLE student DROP INDEX FK_gradeid;


-- 插入语句（添加）
-- 语法 : INSERT INTO 表名[(字段1,字段2,字段3,...)] VALUES('值1','值2','值3')
INSERT INTO grade(gradename) VALUES ('大一');

-- 主键自增,那能否省略呢?
INSERT INTO grade VALUES ('大二');

-- 查询:INSERT INTO grade VALUE ('大二')
-- 错误代码：1136 Column count doesn`t match value count at row 1

-- 一次插入多条数据
INSERT INTO grade(gradename) VALUES ('大三'),('大四');

-- 结论:'字段1,字段2...'该部分可省略 , 但添加的值务必与表结构,数据列,顺序相对应,且数量一致.



CREATE TABLE `student` (
  `id` INT(4) NOT NULL AUTO_INCREMENT COMMENT '学号',
  `name` VARCHAR(20) NOT NULL DEFAULT '匿名' COMMENT '姓名',
  `sex` VARCHAR(10) DEFAULT '1' COMMENT '性别',
  `gradeid` INT(10) DEFAULT NULL COMMENT '年级',
  `phoneNum` VARCHAR(50) DEFAULT NULL COMMENT '手机',
  `address` VARCHAR(255) DEFAULT NULL COMMENT '地址',
  `borndate` DATETIME DEFAULT NULL COMMENT '生日',
  `email` VARCHAR(50) DEFAULT NULL COMMENT '邮箱',
  `idCard` VARCHAR(18) DEFAULT NULL COMMENT '身份证号',
  PRIMARY KEY (`id`),
  KEY `FK_gradeid2` (`gradeid`)
) ENGINE=INNODB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

INSERT INTO `student`(`name`) VALUES ('张三');

INSERT INTO `student`(`name`,`address`,`sex`) VALUES ('张三','admin','男');

INSERT INTO `student`(`name`,`address`,`sex`) 
VALUES ('李四','pppppp','女'),('王五','tttttt','男');


-- 修改年级名字，带了简介
UPDATE grade SET gradename = '高中' WHERE gradeid = 1;

-- 不指定条件情况下，会改动所有的表
UPDATE `grade` SET `gradename`='果汁';

-- 修改多个属性
UPDATE `student` SET `name`='admin',`email`='2943357596@qq.com' WHERE id = 2;


where条件子句，可以简单理解为 : 有条件地从表中筛选数据。

运算符	含义	范例	结果
=	等于	5=6	false
< > 或 !=	不等于	5!=6	true
>	大于	5>6	false
<	小于	5<6	true
>=	大于等于	5>=6	false
<=	小于等于	5<=6	true
BETWEEN	在某个范围之间	BETWEEN 5 AND 10	-
AND	并且	5>1 AND 1>2	false
OR	或	5>1 OR 1>2	true


UPDATE `student` SET `name` = '高中' WHERE `id` <= 3;

-- 删除最后一个数据
DELETE FROM grade WHERE gradeid = 5;

-- 清空年级表
TRUNCATE grade;

-- 创建一个测试表
CREATE TABLE `test` (
`id` INT(4) NOT NULL AUTO_INCREMENT,
`coll` VARCHAR(20) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- 插入几个测试数据
INSERT INTO test(coll) VALUES('row1'),('row2'),('row3');

-- 删除表数据(不带where条件的delete)
DELETE FROM test; -- 不会影响自增
-- 结论:如不指定Where则删除该表的所有列数据,自增当前值依然从原来基础上进行,会记录日志.

-- 删除表数据(truncate)
TRUNCATE TABLE test; -- 自增会归零
-- 结论:truncate删除数据,自增当前值会恢复到初始值重新开始;不会记录日志.

-- 同样使用DELETE清空不同引擎的数据库表数据.重启数据库服务后
-- InnoDB : 自增列从初始值重新开始 (因为是存储在内存中,断电即失)
-- MyISAM : 自增列依然从上一个自增数据基础上开始 (存在文件中,不会丢失)


SELECT [ALL | DISTINCT]
{* | table.* | [table.field1[as alias1][,table.field2[as alias2]][,...]]}
FROM table_name [as table_alias]
  [left | right | inner join table_name2]  -- 联合查询
  [WHERE ...]  -- 指定结果需满足的条件
  [GROUP BY ...]  -- 指定结果按照哪几个字段来分组
  [HAVING]  -- 过滤分组的记录必须满足的次要条件
  [ORDER BY ...]  -- 指定查询记录按一个或多个条件排序
  [LIMIT {[offset,]row_count | row_countOFFSET offset}];
   -- 指定查询的记录从哪条至哪条
   -- 注意：[]括号代表可选的，{}括号代表必选的
   
-- 上述顺序很重要
select 去重 要查询的字段 from 表 （注意：表和字段可以取别名）
xxx jion 要连接的表 on 等值判断
where (具体的值，子查询语句)
Group by (通过哪个字段来分组)
Having (过滤分组后的信息，条件和where是一样的，位置不同)
Order by .. (通过哪个字段来排序) [升序/降序]
Limit startindex,pagesize

业务层面：
查询，跨表，跨数据库。。。
   
   
注意 : [ ] 括号代表可选的 , { }括号代表必选得。


-- 查询表中所有的数据列结果 , 采用 **" \* "** 符号; 但是效率低，不推荐 .

-- 查询所有学生信息
SELECT * FROM student; -- 可记为查询语法

-- 查询指定列(学号 , 姓名)
SELECT studentno,studentname FROM student;

-- 这里是为列取别名(当然as关键词可以省略)
SELECT studentno AS 学号,studentname AS 姓名 FROM student;

-- 使用as也可以为表取别名
SELECT studentno AS 学号,studentname AS 姓名 FROM student AS s;

-- 使用as,为查询结果取一个新名字
-- CONCAT()函数拼接字符串
SELECT CONCAT('姓名:',studentname) AS 新姓名 FROM student;


-- 查看哪些同学参加了考试(学号) 去除重复项
SELECT * FROM result; -- 查看考试成绩
SELECT studentno FROM result; -- 查看哪些同学参加了考试
SELECT DISTINCT studentno FROM result; -- 了解:DISTINCT 去除重复项 , (默认是ALL)
select distinct studentno from result; -- 去除重复项


-- selcet查询中可以使用表达式
SELECT VERSION(); -- 查询版本号
SELECT 100*3-1 AS 计算结果; -- 表达式
SELECT @@auto_increment_increment; -- 查询自增步长

-- 学员考试成绩集体提分一分查看
SELECT studentno,StudentResult+1 AS '提分后' FROM result;


where条件语句
作用：用于检索数据表中 符合条件 的记录。

搜索条件可由一个或多个逻辑表达式组成 , 结果为布尔值，一般为真或假。

逻辑运算符：尽量使用英文符号。

操作符名称	语法	描述
AND 或 &&	a and b 或 a && b	逻辑与，同时为真结果才为真
OR 或 ||	a orb 或 a || b	逻辑或，只要一个为真，则结果为真
NOT 或 !	not a 或 !a	逻辑非，若操作数为假，则结果为真


-- =============where===============
SELECT studentno,studentResult FROM result;

-- 查询考试成绩在95-100之间的
SELECT studentno,studentresult
FROM result
WHERE studentresult>=95 AND studentresult<=100;

-- AND也可以写成 &&
SELECT studentno,studentresult
FROM result 
WHERE studentresult>=95 AND studentresult<=100;

-- 模糊查询(对应的词:精确查询)
SELECT studentno,studentresult
FROM result WHERE studentresult BETWEEN 95 AND 100;

-- 除了1000号同学,要其他同学的成绩
SELECT studentno,studentresult
FROM result WHERE studentno!=1000;

-- 使用NOT
SELECT studentno,studentresult
FROM result WHERE NOT studentno=1000;


-- ===================LIKE==========================
-- 查询姓刘的同学的学号及姓名
-- like结合使用的通配符 : % (代表0到任意个字符) _ (一个字符)
SELECT studentno,studentname FROM student
WHERE studentname LIKE '刘%';

-- 查询姓刘的同学,后面只有一个字的
SELECT studentno,studentname FROM student
WHERE studentname LIKE '刘_';

-- 查询姓刘的同学,后面只有两个字的
SELECT studentno,studentname FROM student
WHERE studentname LIKE '刘__';

-- 查询姓名中含有 梅 字的
SELECT studentno,studentname FROM student
WHERE studentname LIKE '%梅%';

-- 查询姓名中含有特殊字符的需要使用转义符号 '\'
-- 自定义转义符关键字: ESCAPE ':'

-- =====================IN========================
-- 查询学号为1000,1001,1002的学生姓名
SELECT studentno,studentname FROM student
WHERE studentno IN (1000,1001,1002);

-- 查询地址在北京,南京,河南洛阳的学生
SELECT studentno,studentname,address FROM student
WHERE address IN ('北京','南京','河南洛阳');

-- ====================NULL 空=========================
-- 查询出生日期没有填写的同学
-- 不能直接写=NULL , 这是代表错误的 , 用 is null
SELECT studentname FROM student
WHERE BornDate IS NULL;

-- 查询出生日期填写的同学
SELECT studentname FROM student
WHERE BornDate IS NOT NULL;

-- 查询没有写家庭住址的同学(空字符串不等于null)
SELECT studentname FROM student
WHERE Address='' OR Address IS NULL;


-- 查询参加了考试的同学信息(学号,学生姓名,科目编号,分数)
SELECT * FROM student;
SELECT * FROM result;

/*思路:
(1):分析需求,确定查询的列来源于两个类,student result,连接查询
(2):确定使用哪种连接查询?7种(内连接)
明确交叉点（这两个表中那个数据是相同的）
判断的条件：学生表中的 studentNo=成绩表 studentNo
*/
SELECT studentno,studentname,subjectno,StudentResult
FROM student s
INNER JOIN result r
ON r.studentno = s.studentno;（数据报错,原因列值指向不明确）

SELECT s.studentno,studentname,subjectno,StudentResult
FROM student s
INNER JOIN result r
ON r.studentno = s.studentno;

-- 右连接(也可实现)
SELECT s.studentno,studentname,subjectno,StudentResult
FROM student s
RIGHT JOIN result r
ON r.studentno = s.studentno;

-- 等值连接
SELECT s.studentno,studentname,subjectno,StudentResult
FROM student s , result r
WHERE r.studentno = s.studentno;

-- 左连接 (查询了所有同学,不考试的也会查出来)
SELECT s.studentno,studentname,subjectno,StudentResult
FROM student s
LEFT JOIN result r
ON r.studentno = s.studentno;

-- 查询缺考的同学(左连接应用场景)
SELECT s.studentno,studentname,subjectno,StudentResult
FROM student s
LEFT JOIN result r
ON r.studentno = s.studentno
WHERE StudentResult IS NULL;

-- 我要查询哪些数据select
-- 从那几个表中查FROM表XXX Join连接的表on 交叉条件
-- 假设存在一-种多张表查询，慢慢来，先查询两张表然后再慢慢增加。
-- 思考题:查询参加了考试的同学信息(学号,学生姓名,科目名,分数)
SELECT s.studentno,studentname,subjectname,StudentResult
FROM student s
INNER JOIN result r
ON r.studentno = s.studentno
INNER JOIN `subject` sub
ON sub.subjectno = r.subjectno;

-- from a left join b  以a表为基准
-- from a right join b  以b标为基准


/*
需求:从一个包含栏目ID , 栏目名称和父栏目ID的表中
    查询父栏目名称和其他子栏目名称
*/

-- 创建一个表
CREATE TABLE `category` (
`categoryid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主题id',
`pid` INT(10) NOT NULL COMMENT '父id',
`categoryName` VARCHAR(50) NOT NULL COMMENT '主题名字',
PRIMARY KEY (`categoryid`)
) ENGINE=INNODB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- 插入数据
INSERT INTO `category` (`categoryid`, `pid`, `categoryName`)
VALUES('2','1','信息技术'),
('3','1','软件开发'),
('4','3','数据库'),
('5','1','美术设计'),
('6','3','web开发'),
('7','5','ps技术'),
('8','2','办公信息');

-- 编写SQL语句,将栏目的父子关系呈现出来 (父栏目名称,子栏目名称)
-- 核心思想:把一张表看成两张一模一样的表,然后将这两张表连接查询(自连接)
SELECT a.`categoryName` AS '父栏目',b.`categoryName` AS '子栏目'
FROM `category` AS a,`category` AS b
WHERE a.`categoryid` = b.`pid`;

-- 思考题:查询参加了考试的同学信息(学号,学生姓名,科目名,分数)
SELECT s.studentno,studentname,subjectname,StudentResult
FROM student s
INNER JOIN result r
ON r.studentno = s.studentno
INNER JOIN `subject` sub
ON sub.subjectno = r.subjectno;

-- 查询学员及所属的年级(学号,学生姓名,年级名)
SELECT studentno AS 学号,studentname AS 学生姓名,gradename AS 年级名称
FROM student s
INNER JOIN grade g
ON s.`GradeId` = g.`GradeID`;

-- 查询科目及所属的年级(科目名称,年级名称)
SELECT subjectname AS 科目名称,gradename AS 年级名称
FROM SUBJECT sub
INNER JOIN grade g
ON sub.gradeid = g.gradeid;

-- 查询 数据库结构-1 的所有考试结果(学号 学生姓名 科目名称 成绩)
SELECT s.studentno,studentname,subjectname,StudentResult
FROM student s
INNER JOIN result r
ON r.studentno = s.studentno
INNER JOIN `subject` sub
ON r.subjectno = sub.subjectno
WHERE subjectname='数据库结构-1';

-- 分页 limit 和排序 order by
-- 排序：升序 ASC ， 降序 DESC

-- 查询 数据库结构-1 的所有考试结果(学号 学生姓名 科目名称 成绩)
-- 按成绩降序排序
SELECT s.studentno,studentname,subjectname,StudentResult
FROM student s
INNER JOIN result r
ON r.studentno = s.studentno
INNER JOIN `subject` sub
ON r.subjectno = sub.subjectno
WHERE subjectname='数据库结构-1'
ORDER BY StudentResult DESC;

-- 如果成绩一样，按其他规则排列，比如学号的升序与降序。
SELECT s.studentno,studentname,subjectname,StudentResult
FROM student s
INNER JOIN result r
ON r.studentno = s.studentno
INNER JOIN `subject` sub
ON r.subjectno = sub.subjectno
WHERE subjectname='数据库结构-1'
ORDER BY StudentResult DESC, studentno DESC;


-- 需求：查询 数据库结构-1 的所有考试结果（学号 学生 科目名称 成绩),成绩
-- 每页显示5条数据
SELECT s.studentno,studentname,subjectname,StudentResult
FROM student s
INNER JOIN result r
ON r.studentno = s.studentno
INNER JOIN `subject` sub
ON r.subjectno = sub.subjectno
WHERE subjectname='数据库结构-1'
ORDER BY StudentResult DESC , studentno
LIMIT 0,5;

-- 查询 JAVA第一学年 课程成绩前10名并且分数大于80的学生信息(学号,姓名,课程名,分数)
SELECT s.studentno,studentname,subjectname,StudentResult
FROM student s
INNER JOIN result r
ON r.studentno = s.studentno
INNER JOIN `subject` sub
ON r.subjectno = sub.subjectno
WHERE studentresult>80 AND subjectname='JAVA第一学年'
ORDER BY StudentResult DESC
LIMIT 0,10;
6.子查询和嵌套查询


-- 查询 数据库结构-1 的所有考试结果(学号,科目编号,成绩),并且成绩降序排列
-- 方法一:使用连接查询
SELECT studentno,r.subjectno,StudentResult
FROM result r
INNER JOIN `subject` sub
ON r.`SubjectNo`=sub.`SubjectNo`
WHERE subjectname = '数据库结构-1'
ORDER BY studentresult DESC;

-- 方法二:使用子查询(执行顺序:由里及外)
SELECT studentno,subjectno,StudentResult
FROM result
WHERE subjectno=(
   SELECT subjectno FROM `subject`
   WHERE subjectname = '数据库结构-1'
)
ORDER BY studentresult DESC;

-- 查询课程为 高等数学-2 且分数不小于80分的学生的学号和姓名
-- 方法一:使用连接查询
SELECT s.studentno,studentname
FROM student s
INNER JOIN result r
ON s.`StudentNo` = r.`StudentNo`
INNER JOIN `subject` sub
ON sub.`SubjectNo` = r.`SubjectNo`
WHERE subjectname = '高等数学-2' AND StudentResult>=80;

-- 方法二:使用连接查询+子查询
-- 分数不小于80分的学生的学号和姓名
SELECT r.studentno,studentname FROM student s
INNER JOIN result r ON s.`StudentNo`=r.`StudentNo`
WHERE StudentResult>=80;

-- 在上面SQL基础上,添加需求:课程为 高等数学-2
SELECT r.studentno,studentname FROM student s
INNER JOIN result r ON s.`StudentNo`=r.`StudentNo`
WHERE StudentResult>=80 AND subjectno=(
   SELECT subjectno FROM `subject`
   WHERE subjectname = '高等数学-2'
);

-- 方法三:使用子查询
-- 分步写简单sql语句,然后将其嵌套起来
SELECT studentno,studentname FROM student WHERE studentno IN(
   SELECT studentno FROM result WHERE StudentResult>=80 AND subjectno=(
       SELECT subjectno FROM `subject` WHERE subjectname = '高等数学-2'
  )
);

/*
题目:
   查 C语言-1 的前5名学生的成绩信息(学号,姓名,分数)
   使用子查询,查询郭靖同学所在的年级名称
*/

-- 需求：查询C语言-1的前5名学生的成绩信息：学号、姓名、分数
-- 方式一：连接查询
SELECT s.studentno,studentname,studentresult
FROM student AS s
INNER JOIN result AS r
ON s.StudentNo=r.StudentNo
INNER JOIN `subject` AS su
ON r.SubjectNo=su.subjectno
WHERE subjectname='C语言-1'
ORDER BY studentresult DESC
LIMIT 0,5;

-- 方式二：连接查询和子查询并用
SELECT s.studentno,studentname,studentresult
FROM student AS s
INNER JOIN result AS r
ON s.StudentNo=r.StudentNo
WHERE subjectno=
(SELECT subjectno FROM `subject` WHERE subjectname='C语言-1')
ORDER BY studentresult DESC
LIMIT 0,5;

-- 使用子查询：查询郭靖同学所在的年级名称
SELECT gradename FROM grade 
WHERE gradeid=
(SELECT gradeid FROM student WHERE studentname='郭靖');


-- 查询不同课程的平均分,最高分,最低分
 -- 前提:根据不同的课程进行分组
 
 SELECT subjectname,AVG(studentresult) AS 平均分,MAX(StudentResult) AS 最高分,MIN(StudentResult) AS 最低分
 FROM result AS r
 INNER JOIN `subject` AS s
 ON r.subjectno = s.subjectno
 GROUP BY r.subjectno
 HAVING 平均分>80;
 
 /*
 where写在group by前面.
 要是放在分组后面的筛选
 要使用HAVING..
 因为having是从前面筛选的字段再筛选，而where是从数据表中的>字段直接进行的筛选的
 */
 
 
 常用函数
数据函数
SELECT ABS(-8);	-- 绝对值函数
SELECT CEILING(9.4); -- 向上取整/
SELECT FLOOR(9.4);   -- 向下取整
SELECT RAND();  -- 随机数,返回一个0-1之间的随机数
SELECT SIGN(0); -- 符号函数: 负数返回-1,正数返回1,0返回0
字符串函数
SELECT CHAR_LENGTH('Java坚持就能成功'); -- 返回字符串包含的字符数
SELECT CONCAT('我','改','程序');  -- 合并字符串,参数可以有多个
SELECT INSERT('我在编程hello world',1,2,'为了咸鱼');  -- 替换字符串,从某个位置开始替换某个长度
SELECT LOWER('subeiLY'); -- 小写
SELECT UPPER('unremittingly'); -- 大写
SELECT LEFT('hello,world',5);   -- 从左边截取
SELECT RIGHT('hello,world',5);  -- 从右边截取
SELECT REPLACE('Java坚持就能成功','咸鱼','努力');  -- 替换字符串
SELECT SUBSTR('Java坚持就能成功',4,6); -- 截取字符串,开始和长度
SELECT REVERSE('Java坚持就能成功'); -- 反转
 
-- 查询姓郭的同学,改成邹
SELECT REPLACE(studentname,'郭','邹') AS 新名字
FROM student WHERE studentname LIKE '郭%';
日期和时间函数
 SELECT CURRENT_DATE();   -- 获取当前日期
 SELECT CURDATE();   -- 获取当前日期
 SELECT NOW();   -- 获取当前日期和时间
 SELECT LOCALTIME();   -- 获取当前日期和时间
 SELECT SYSDATE();   -- 获取当前日期和时间
 
 -- 获取年月日,时分秒
 SELECT YEAR(NOW());
 SELECT MONTH(NOW());
 SELECT DAY(NOW());
 SELECT HOUR(NOW());
 SELECT MINUTE(NOW());
 SELECT SECOND(NOW());
系统信息函数
 SELECT VERSION();  -- 版本
 SELECT USER();     -- 用户 
2.聚合函数及分组过滤
函数名称	描述
COUNT()	返回满足Select条件的记录总和数，如 select count(*) 【不建议使用 *，效率低】
SUM()	返回数字字段或表达式列作统计，返回一列的总和。
AVG()	通常为数值字段或表达列作统计，返回一列的平均值
MAX()	可以为数值字段，字符字段或表达式列作统计，返回最大的值。
MIN()	可以为数值字段，字符字段或表达式列作统计，返回最小的值。
从含义上讲，count(1) 与 count(*) 都表示对全部数据行的查询。

count(字段) 会统计该字段在表中出现的次数，忽略字段为null 的情况。即不统计字段为null 的记录。
count(*) 包括了所有的列，相当于行数，在统计结果的时候，包含字段为null 的记录；
count(1) 用1代表代码行，在统计结果的时候，包含字段为null 的记录 。
很多人认为count(1)执行的效率会比count(* )高，原因是count( * )会存在全表扫描，而count(1)可以针对一个字段进行查询。其实不然，count(1)和count(*)都会对全表进行扫描，统计所有记录的条数，包括那些为null的记录，因此，它们的效率可以说是相差无几。而count(字段)则与前两者不同，它会统计该字段不为null的记录条数。

两者之间的对比：
1）在表没有主键时，count(1)比count(*)快；
2）有主键时，主键作为计算条件，count(主键)效率最高；
3）若表格只有一个字段，则count(*)效率较高。
 -- 聚合函数
 -- COUNT:非空的
 SELECT COUNT(studentname) FROM student; -- count(指定列),会忽略所有的null值
 SELECT COUNT(*) FROM student;  -- count(*)，不会忽略null值
 SELECT COUNT(1) FROM student;  -- count(1) 推荐不会忽略忽略所有的null值，本质 计算行数
 
 SELECT SUM(StudentResult) AS 总和 FROM result;
 SELECT AVG(StudentResult) AS 平均分 FROM result;
 SELECT MAX(StudentResult) AS 最高分 FROM result;
 SELECT MIN(StudentResult) AS 最低分 FROM result;
 
-- 查询不同课程的平均分，最高分，最低分，平均分大于80分
-- 核心:(根据不同的课程分组)
SELECT subjectname,AVG(studentresult) AS 平均分,MAX(StudentResult) AS 最高分,MIN(StudentResult) AS 最低分
FROM result AS r
INNER JOIN `subject` AS s
ON r.subjectno = s.subjectno
GROUP BY r.subjectno
HAVING 平均分>80;
 
 /*
 where写在group by前面.
 要是放在分组后面的筛选
 要使用HAVING..
 因为having是从前面筛选的字段再筛选，而where是从数据表中的>字段直接进行的筛选的
 */
3.数据库级别的MD5 加密（扩展）
一、什么是MD5？

主要增强算法复杂度和不可逆性。
MD5不可逆，具体的值的md5是一样的；
MD5破解网站的原理，背后有一个字典，MD5加密后的值，加密的前值。
二、实现数据加密

新建一个表 testmd5：
CREATE TABLE `testmd5` (
`id` INT(4) NOT NULL,
`name` VARCHAR(20) NOT NULL,
`pwd` VARCHAR(50) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;
插入一些数据：
-- 明文密码
INSERT INTO testmd5 VALUES(1,'subei','123456'),(2,'wahaha','456789');
如果我们要对pwd这一列数据进行加密，语法是：
-- 加密
update testmd5 set pwd = md5(pwd) where id=1;
update testmd5 set pwd = md5(pwd); -- 加密全部的密码
如果单独对某个用户(如wahaha)的密码加密：
INSERT INTO testmd5 VALUES(3,'admin','123456');

UPDATE testmd5 SET pwd = MD5(pwd) WHERE NAME='admin';
插入新的数据自动加密
-- 一般是在插入数据的时候进行加密（推荐）
INSERT INTO testmd5 VALUES(4,'party',md5('123456'));
查询登录用户信息（md5对比使用，查看用户输入加密后的密码进行比对）
SELECT * FROM testmd5 WHERE `name`='subei' AND pwd=MD5('123456');

-- ==========事务==========
下面步骤是固定的流程：
-- MySQL默认开启事务自动提交的
SET autocommit = 0;   -- 关闭
SET autocommit = 1;   -- 开启(默认的)

-- 手动处理事务

-- 事务开启
START TRANSACTION;  -- 标记一个事务的开始,从这个之后
					-- 的sql都在同一个事务内

INSERT XX
INSERT XX

-- 提交:持久化（成功！）
COMMIT;

-- 回滚:数据回到本次事务的初始状态（回到原来的样子，失败！）  
ROLLBACK;

-- 事务结束
SET autocommit =1;  -- 开始自动提交

-- 了解 保存点
SAVEPOINT 保存点名称; -- 设置一个事务保存点
ROLLBACK TO SAVEPOINT 保存点名称; -- 回滚到保存点
RELEASE SAVEPOINT 保存点名称; -- 删除保存点
测试

/*
题目：
	A在线买一款价格为500元商品,网上银行转账.
	A的银行卡余额为2000,然后给商家B支付500.
	商家B一开始的银行卡余额为10000
	
	创建数据库shop和创建表account并插入2条数据
*/
-- 创建shop数据库
CREATE DATABASE `shop`CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `shop`;

CREATE TABLE `account` (
`id` INT(11) NOT NULL AUTO_INCREMENT,
`name` VARCHAR(32) NOT NULL,
`money` DECIMAL(9,2) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO account (`name`,`money`)
VALUES('A',2000.00),('B',10000.00);

-- 模拟转账：事务
SET autocommit = 0; -- 关闭自动提交
START TRANSACTION;  -- 开始一个事务（一组事务）

UPDATE account SET money=money-500 WHERE `name`='A'; -- A减500
UPDATE account SET money=money+500 WHERE `name`='B'; -- B加500

COMMIT; -- 提交事务，持久化了！！！
# rollback; -- 回滚
SET autocommit = 1; -- 恢复自动提交


#方法一：创建表时创建索引
  　　CREATE TABLE 表名 (
               字段名1 数据类型 [完整性约束条件…],
               字段名2 数据类型 [完整性约束条件…],
               [UNIQUE | FULLTEXT | SPATIAL ]   INDEX | KEY
               [索引名] (字段名[(长度)] [ASC |DESC])
               );

#方法二：CREATE在已存在的表上创建索引
       CREATE [UNIQUE | FULLTEXT | SPATIAL ] INDEX 索引名
                    ON 表名 (字段名[(长度)] [ASC |DESC]) ;

#方法三：ALTER TABLE在已存在的表上创建索引
       ALTER TABLE 表名 ADD [UNIQUE | FULLTEXT | SPATIAL ] INDEX
                            索引名 (字段名[(长度)] [ASC |DESC]) ;
                           
                           
#删除索引：DROP INDEX 索引名 ON 表名字;
#删除主键索引: ALTER TABLE 表名 DROP PRIMARY KEY;
-- 索引的使用
-- 1.在创建表时给字段增加索引
-- 2.创建完毕后，增加索引

-- 显示表中所有的索引信息
SHOW INDEX FROM student;

-- 增加全文索引
ALTER TABLE `school`.`student` ADD FULLTEXT INDEX `studentname` (`studentname`);

-- EXPLAIN : 分析SQL语句执行性能
EXPLAIN SELECT * FROM student;  -- 非全文索引

EXPLAIN SELECT * FROM student WHERE MATCH(`studentname`) AGAINST('张');

测试索引
建表app_user：
CREATE TABLE `app_user` (
`id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
`name` VARCHAR(50) DEFAULT'' COMMENT'用户昵称',
`email` VARCHAR(50) NOT NULL COMMENT'用户邮箱',
`phone` VARCHAR(20) DEFAULT'' COMMENT'手机号',
`gender` TINYINT(4) UNSIGNED DEFAULT '0'COMMENT '性别（0：男;1:女）',
`password` VARCHAR(100) NOT NULL COMMENT '密码',
`age` TINYINT(4) DEFAULT'0'  COMMENT '年龄',
`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
`update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COMMENT = 'app用户表';
批量插入数据：100w
-- 插入百万条数据
DROP FUNCTION IF EXISTS mock_data;

DELIMITER $$ -- 写函数之前必须写，标志

CREATE FUNCTION mock_data()
RETURNS INT
BEGIN
    DECLARE num INT DEFAULT 1000000;
    DECLARE i INT DEFAULT 0;
    WHILE i < num DO
	-- 插入语句
	INSERT INTO app_user(`name`, `email`, `phone`, `gender`, `password`, `age`)
	VALUES(CONCAT('用户', i), '24736743@qq.com', CONCAT('18', FLOOR(RAND()*(999999999-100000000)+100000000)),FLOOR(RAND()*2),UUID(), FLOOR(RAND()*100));
	SET i = i + 1;
    END WHILE;
    RETURN i;
END;

SELECT mock_data();
索引效率测试

无索引
SELECT * FROM app_user WHERE NAME = '用户9999'; -- 查看耗时
SELECT * FROM app_user WHERE NAME = '用户9999';
SELECT * FROM app_user WHERE NAME = '用户9999';

EXPLAIN SELECT * FROM app_user WHERE NAME = '用户9999';
创建索引
-- id_表名_字段名
-- CREATE INDEX 索引名 ON 表(字段)
CREATE INDEX id_app_user_name ON app_user(`name`);
测试普通索引
SELECT * FROM app_user WHERE NAME = '用户9999';  -- 0.001sec
SELECT * FROM app_user WHERE NAME = '用户9999'; 
EXPLAIN SELECT * FROM app_user WHERE NAME = '用户9999'; 


SQL命令操作

用户表：mysql.user
本质：对这张表进行增删改查。
-- 刷新权限
FLUSH PRIVILEGES;

-- 增加用户 
CREATE USER subei IDENTIFIED BY '123456';

CREATE USER 用户名 IDENTIFIED BY [PASSWORD] 密码(字符串)
  - 必须拥有mysql数据库的全局CREATE USER权限，或拥有INSERT权限。
  - 只能创建用户，不能赋予权限。
  - 用户名，注意引号：如 'user_name'@'192.168.1.1'
  - 密码也需引号，纯数字密码也要加引号
  - 要在纯文本中指定密码，需忽略PASSWORD关键词。要把密码指定为由PASSWORD()函数返回的混编值，需包含关键字PASSWORD

-- 重命名用户 
RENAME USER subei TO subei2;
RENAME USER old_user TO new_user;

-- 设置密码
SET PASSWORD = PASSWORD('admin');
SET PASSWORD = PASSWORD('密码');    -- 为当前用户设置密码
SET PASSWORD FOR 用户名 = PASSWORD('密码');    -- 为指定用户设置密码

-- 删除用户 
DROP USER subei2;
DROP USER 用户名;

-- 分配权限/添加用户（重要）
GRANT all privileges ON *.* TO subei2;
GRANT 权限列表 ON 表名 TO 用户名 [IDENTIFIED BY [PASSWORD] 'password']
  - all privileges 表示所有权限
  - *.* 表示所有库的所有表
  - 库名.表名 表示某库下面的某表  

-- 查看权限   
SHOW GRANTS FOR root@localhost;
SHOW GRANTS FOR 用户名
SHOW GRANTS FOR kaungshen2 -- 查看指定用户的权限
   -- 查看当前用户权限
  SHOW GRANTS; 或 SHOW GRANTS FOR CURRENT_USER; 或 SHOW GRANTS FOR CURRENT_USER();

-- 撤消权限
REVOKE 权限列表 ON 表名 FROM 用户名
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 用户名    -- 撤销所有权限
权限解释

-- 权限列表
ALL [PRIVILEGES]    -- 设置除GRANT OPTION之外的所有简单权限
ALTER    -- 允许使用ALTER TABLE
ALTER ROUTINE    -- 更改或取消已存储的子程序
CREATE    -- 允许使用CREATE TABLE
CREATE ROUTINE    -- 创建已存储的子程序
CREATE TEMPORARY TABLES        -- 允许使用CREATE TEMPORARY TABLE
CREATE USER        -- 允许使用CREATE USER, DROP USER, RENAME USER和REVOKE ALL PRIVILEGES。
CREATE VIEW        -- 允许使用CREATE VIEW
DELETE    -- 允许使用DELETE
DROP    -- 允许使用DROP TABLE
EXECUTE        -- 允许用户运行已存储的子程序
FILE    -- 允许使用SELECT...INTO OUTFILE和LOAD DATA INFILE
INDEX     -- 允许使用CREATE INDEX和DROP INDEX
INSERT    -- 允许使用INSERT
LOCK TABLES        -- 允许对您拥有SELECT权限的表使用LOCK TABLES
PROCESS     -- 允许使用SHOW FULL PROCESSLIST
REFERENCES    -- 未被实施
RELOAD    -- 允许使用FLUSH
REPLICATION CLIENT    -- 允许用户询问从属服务器或主服务器的地址
REPLICATION SLAVE    -- 用于复制型从属服务器（从主服务器中读取二进制日志事件）
SELECT    -- 允许使用SELECT
SHOW DATABASES    -- 显示所有数据库
SHOW VIEW    -- 允许使用SHOW CREATE VIEW
SHUTDOWN    -- 允许使用mysqladmin shutdown
SUPER    -- 允许使用CHANGE MASTER, KILL, PURGE MASTER LOGS和SET GLOBAL语句，mysqladmin debug命令；允许您连接（一次），即使已达到max_connections。
UPDATE    -- 允许使用UPDATE
USAGE    -- “无权限”的同义词
GRANT OPTION    -- 允许授予权限


-- 表维护

-- 分析和存储表的关键字分布
ANALYZE [LOCAL | NO_WRITE_TO_BINLOG] TABLE 表名 ...
-- 检查一个或多个表是否有错误
CHECK TABLE tbl_name [, tbl_name] ... [option] ...
option = {QUICK | FAST | MEDIUM | EXTENDED | CHANGED}
-- 整理数据文件的碎片
OPTIMIZE [LOCAL | NO_WRITE_TO_BINLOG] TABLE tbl_name [, tbl_name] ...


-- 导出
1. 导出一张表 
-- mysqldump -uroot -proot school student >D:/a.sql
　　mysqldump -h 主机 -u用户名 -p密码 库名 表名 > 文件名(D:/a.sql)
2. 导出多张表 
-- mysqldump -uroot -proot school student result >D:/b.sql
　　mysqldump -h 主机 -u用户名 -p密码 库名 表1 表2 表3 > 文件名(D:/b.sql)
3. 导出所有表 
-- mysqldump -uroot -proot school >D:/c.sql
　　mysqldump -h 主机 -u用户名 -p密码 库名 > 文件名(D:/c.sql)
4. 导出一个库 
-- mysqldump -uroot -proot -B school >D:/d.sql
　　mysqldump -h 主机 -u用户名 -p密码 -B 库名 > 文件名(D:/d.sql)

可以-w携带备份条件

-- 导入
1. 在登录mysql的情况下：
-- source D:/a.sql
　　source 备份文件 
2. 在不登录的情况下:
　　mysql -u用户名 -p密码 库名 < 备份文件




常见数据类型

<1>整数型类型 大小 范围（有符号） 范围（无符号unsigned） 用途 
TINYINT 1 字节 (-128，127) (0，255) 小整数值 
SMALLINT 2 字节 (-32768，32767) (0，65535) 大整数值 
MEDIUMINT 3 字节 (-8388608，8388607) (0，16777215) 大整数值 
INT(常用) 4 字节 (-2147483648，2147483647) (0，4294967295) 大整数值 
BIGINT 8 字节 （） (0，2的64次方减1) 极大整数值 
<2>浮点型 
FLOAT(m,d） 4 字节 单精度浮点型 
备注：m代表总个数，d代表小数位个数 
DOUBLE(m,d） 8 字节 双精度浮点型 
备注：m代表总个数，d代表小数位个数 
<3>定点型 DECIMAL(常用) (m,d）  依赖于M和D的值 
备注：m代表总个数，d代表小数位个数 
<4>字符串类型 类型 大小 用途 CHAR 0-255字节 定长字符串 
VARCHAR(常用)  0-65535字节 变长字符串 
TINYTEXT 0-255字节 短文本字符串 
TEXT 0-65535字节 长文本数据
 MEDIUMTEXT 0-16777215字节 中等长度文本数据 
LONGTEXT 0-4294967295字节 极大文本数据
 char的优缺点：存取速度比varchar更快，但是比varchar更占用空间
 <5>时间型 数据类型 字节数 格式 备注 
 date 3 yyyy-MM-dd 存储日期值 
 time 3 HH:mm:ss 存储时分秒 
 year 1 yyyy 存储年 
 datetime(常用) 8 yyyy-MM-dd HH:mm:ss 存储日期+时间 
 timestamp 4 yyyy-MM-dd HH:mm:ss 存储日期+时间，可作时间戳


创建表

CREATE TABLE 表名 (
字段名1 字段类型1 约束条件1 说明1, 
字段名2 字段类型2 约束条件2 说明2, 
字段名3 字段类型3 约束条件3 说明3 
 );
 约束条件有：
 comment ----说明解释 
 not null ----不为空 
 default ----默认值 
 unsigned ----无符号（即正数） 
 auto_increment ----自增 
 zerofill ----自动填充
 unique key ----唯一值
 例：创建sql:
  create table student (
 id int(11) zerofill auto_increment not null comment '学生学号', 
 name varchar(20) default null comment '学生姓名', 
 birthday datetime default null comment '生日',
   unique key (id) )engine=innodb charset=utf8;;
   注意，varchar一定要定义大小，否则会创建失败。
   查看数据库中的所有表：show tables；
   普通的插入表数据：
   insert into 表名（字段名） values（字段对应值）;
   例：insert into student (name,id) values ('ch',1);
   一次性插入多个数据
   insert into 表名 (字段名) values (对应值1),(对应值2),(对应值3);
   简单查询数据：
   select （字段名) from (表名）;
   update 表名 set 字段名1=值1 where 字段名=值;
   乱码问题解决：
   临时：set names gbk;
 永久：修改配置文件my.cnf(my.ini)里边的
 [client] default-character-set=gbk 作用于外部的显示 [mysqld]           
 character_set_server=gbk 作用于内部，会作用于创建库表时默认字符集
 
模糊查询：
select 字段名 from 表明 where 字段名 like '林%';
limit限制查询
作用：对查询结果起到限制条数的作用
语法：limit n，m n:代表起始条数值，不写默认为0；m代表：取出的条数
适用场合：数据量过多时，可以起到限制作用
例： select * from 表名 limit 4,5;
 
 



关于MySQL的30条优化技巧，超实用
1.应尽量避免在 where 子句中使用!=或<>操作符，否则引擎将放弃使用索引而进行全表扫描。
2. 对查询进行优化，应尽量避免全表扫描，首先应考虑在 where 及 order by 涉及的列上建立索引。
3. 应尽量避免在 where 子句中对字段进行 null 值判断，否则将导致引擎放弃使用索引而进行全表扫描。如：select id from t where num is null可以在num上设置默认值0，确保表中num列没有null值，然后这样查询：select id from t where num=0
4. 尽量避免在 where 子句中使用 or 来连接条件，否则将导致引擎放弃使用索引而进行全表扫描。如：select id from t where num=10 or num=20可以这样查询：select id from t where num=10union all select id from t where num=20
5. 下面的查询也将导致全表扫描：(不能前置百分号)select id from t where name like ‘%c%’下面走索引select id from t where name like ‘c%’若要提高效率，可以考虑全文检索。
6. in 和 not in 也要慎用，否则会导致全表扫描。如：select id from t where num in(1,2,3)对于连续的数值，能用 between 就不要用 in 了：select id from t where num between 1 and 3
7. 如果在 where 子句中使用参数，也会导致全表扫描。因为SQL只有在运行时才会解析局部变量，但优化程序不能将访问计划的选择推迟到运行时;它必须在编译时进行选择。然而，如果在编译时建立访问计划，变量的值还是未知的，因而无法作为索引选择的输入项。如下面语句将进行全表扫描：select id from t where num=@num可以改为强制查询使用索引：select id from t with(index(索引名)) where num=@num
8. 应尽量避免在 where 子句中对字段进行表达式操作，这将导致引擎放弃使用索引而进行全表扫描。如：select id from t where num/2=100应改为：select id from t where num=100*2
9. 应尽量避免在where子句中对字段进行函数操作，这将导致引擎放弃使用索引而进行全表扫描。如：select id from t where substring(name,1,3)=’abc’ –name以abc开头的id
　select id from t where datediff(day,createdate,’2005-11-30′)=0 –’2005-11-30′生成的id应改为:select id from t where name like ‘abc%’select id from t where createdate>=’2005-11-30′ and createdate<’2005-12-1′
10. 不要在 where 子句中的“=”左边进行函数.算术运算或其他表达式运算，否则系统将可能无法正确使用索引。
11. 在使用索引字段作为条件时，如果该索引是复合索引，那么必须使用到该索引中的第一个字段作为条件时才能保证系统使用该索引，否则该索引将不会被使 用，并且应尽可能的让字段顺序与索引顺序相一致。
12. 不要写一些没有意义的查询，如需要生成一个空表结构：select col1,col2 into #t from t where 1=0这类代码不会返回任何结果集，但是会消耗系统资源的，应改成这样：create table #t(…)
13. 很多时候用exists代替in是一个好的选择：select num from a where num in(select num from b)用下面的语句替换：select num from a where exists(select 1 from b where num=a.num)
14. 并不是所有索引对查询都有效，SQL是根据表中数据来进行查询优化的，当索引列有大量数据重复时，SQL查询可能不会去利用索引，如一表中有字段 sex，male.female几乎各一半，那么即使在sex上建了索引也对查询效率起不了作用。
15. 索引并不是越多越好，索引固然可以提高相应的 select 的效率，但同时也降低了 insert 及 update 的效率，因为 insert 或 update 时有可能会重建索引，所以怎样建索引需要慎重考虑，视具体情况而定。一个表的索引数较好不要超过6个，若太多则应考虑一些不常使用到的列上建的索引是否有 必要。
16. 应尽可能的避免更新 clustered 索引数据列，因为 clustered 索引数据列的顺序就是表记录的物理存储顺序，一旦该列值改变将导致整个表记录的顺序的调整，会耗费相当大的资源。若应用系统需要频繁更新 clustered 索引数据列，那么需要考虑是否应将该索引建为 clustered 索引。
17. 尽量使用数字型字段，若只含数值信息的字段尽量不要设计为字符型，这会降低查询和连接的性能，并会增加存储开销。这是因为引擎在处理查询和连接时会 逐个比较字符串中每一个字符，而对于数字型而言只需要比较一次就够了。
18. 尽可能的使用 varchar/nvarchar 代替 char/nchar ，因为首先变长字段存储空间小，可以节省存储空间，其次对于查询来说，在一个相对较小的字段内搜索效率显然要高些。
19. 任何地方都不要使用 select * from t ，用具体的字段列表代替“*”，不要返回用不到的任何字段。
20. 尽量使用表变量来代替临时表。如果表变量包含大量数据，请注意索引非常有限(只有主键索引)。
21. 避免频繁创建和删除临时表，以减少系统表资源的消耗。
22. 临时表并不是不可使用，适当地使用它们可以使某些例程更有效，例如，当需要重复引用大型表或常用表中的某个数据集时。但是，对于一次性事件，较好使 用导出表。
23. 在新建临时表时，如果一次性插入数据量很大，那么可以使用 select into 代替 create table，避免造成大量 log ，以提高速度;如果数据量不大，为了缓和系统表的资源，应先create table，然后insert。
24. 如果使用到了临时表，在存储过程的最后务必将所有的临时表显式删除，先 truncate table ，然后 drop table ，这样可以避免系统表的较长时间锁定。
25. 尽量避免使用游标，因为游标的效率较差，如果游标操作的数据超过1万行，那么就应该考虑改写。
26. 使用基于游标的方法或临时表方法之前，应先寻找基于集的解决方案来解决问题，基于集的方法通常更有效。
27. 与临时表一样，游标并不是不可使用。对小型数据集使用 FAST_FORWARD 游标通常要优于其他逐行处理方法，尤其是在必须引用几个表才能获得所需的数据时。在结果集中包括“合计”的例程通常要比使用游标执行的速度快。如果开发时 间允许，基于游标的方法和基于集的方法都可以尝试一下，看哪一种方法的效果更好。
28. 在所有的存储过程和触发器的开始处设置 SET NOCOUNT ON ，在结束时设置 SET NOCOUNT OFF 。无需在执行存储过程和触发器的每个语句后向客户端发送 DONEINPROC 消息。
29. 尽量避免向客户端返回大数据量，若数据量过大，应该考虑相应需求是否合理。
30. 尽量避免大事务操作，提高系统并发能力。


Mysql 高级技巧

1 . Order by子句
select * from 表名 order by 列1 asc|desc,列2 asc|desc,...

将行数据按照列1进行排序，如果某些行列1的值相同，则按照列2排序，以此类推，默认值从小到大排列，升序为asc,降序为desc.

主键冲突
a. 更新
insert into 表名字[字段列表(一定要包含主键)] values (字段值列表) on duplicate key update 字段 = 新值；
b. 替换
replace into 表名 [字段列表（包含主键）] values(字段列表值);
（如果 表没有此记录，这插入，如果已经存在，则更新）

c . 忽略
INSERT IGNORE INTO 表名[字段列表（包含主键）] VALUES(字段列表值);
（如果 表没有此记录，这插入，如果已经存在，则更新）

3.蠕虫复制
表结构复制：
create table [if not exists] 新表名 like 数据库.表名字(如果是同一个数据库，数据库.可以省略)；
数据复制：
insert into 表名字[字段列表] select 字段列表* from 数据表名;

去重
distinct：去重，查出来后的结果，将重复的给去除掉(所有字段都相同)
如果主键自增长，就不能使用所有列去重了，要使用部分列的形式去去重。
select distinct age from student;
5.子查询
select * from (select * from 表名字) as 别名(别名不能省)
子查询可以用在 当作数据源、where子句、字段列表中

group by
基本语法：group by 字段名 [asc|desc];
单字段分组
多字段分组 : 先根据一个字段进行分组，然后对分组后的结果再次按照其他字段进行分组
group_concat(字段名) : 可以对分组的结果中的某个字段进行字符串连接
7.Having子句
here是针对磁盘数据进行判断，进入到内存之后，会进行分组操作，分组结果就要使用having子句进行处理，having能做where能做的几乎所有事情，但是where却不能做having能做的事情

Limit子句
语法：limit 起始位置， 长度;(起始位置从0开始)


mysql 快速入门
一、数据库基本概念
数据库：信息存储的仓库，包括一系列的关系措施！
表:一个数据库中可以有若干张表(形式上你可以看出我们日常生活中建立的表)
字段:表里面的信息会分若干个栏目来存，这些栏目呢，我们在数据库技术中叫"字段",栏目里面存的具体信息叫"字段值"
记录：一条信息我们叫一条记录
一个数据库管理系统中可以建立若干个数据库，每个数据库中又可以建立若干张表,每张表中可以有若干条记录。
二、MySQL支持的数据类型
数值类型、日期类型、字符串类型
三、(My)SQL使用入门
2.SQL分类
1)DDL(Data Definition Languages)语句
数据定义语句，通过这类语言可以对数据库进行创建删除更改
2)DML(Data Manipulation Language)语句
数据操纵语句，用于添加、删除、更新和查询数据库记录并检查数据完整性
3)DCL(Data Control Language)语句
数据控制语句，通过此类语句可以对数据库的相关权限进行设置
3.DDL语句
对数据库内部的对象进行创建、删除、修改等操作的语言,DDL语句更多的是由数据库管理员(DBA)使用，开发人员一般很少使用
登录mysql之后就可以使用sql语句对数据库进行各种操作啦！
show databases;查看数据库列表
1)创建数据库
1>create database 数据库名;
2>选择要操作的数据库：USE 数据库; 对于要操作的数据库我们需要使用use来选择一下！
3>查看数据库中所有的数据表show tables;
2)删除数据库
drop database 数据库名称;
3)创建表(在哪个数据库里面创建表需要先使用use选择到那个要操作的数据库)
1>创建表
create table 表名(
字段1名 字段1类型 列的约束条件,
字段2名 字段2类型 列的约束条件,
...
)
2>创建完表之后可以查看表的定义
desc 表名;
3>查看创建表的SQL语句
show create table 表名 \G
\G选项使得记录能够按照字段竖向排列，以便更好地显示内容较长的记录，\G后面无需再加分号
4)删除表
drop table 表名;
5)修改表
1>修改表的字段类型
alter table 表名 modify [column] 字段定义 [first|after 字段名];
2>增加表字段
alter table 表名 add [column] 字段定义 [first|after 字段名];
3>删除表字段
alter table 表名 drop [column] 字段名;
4>字段改名
alter table 表名 change [column] 旧的字段名 字段定义 [first|after 字段名];
注：change与modify都可以修改表的定义，不同的是change后面需要接两次列名，不方便，但是优点是change可以修改字段名称
5>修改字段排列排序
前面介绍的字段增加和修改语法(add/change/modify)中，都有一个可选项first|after 字段名,这个选择可以用来修改
字段在表中的位置新增的字段默认是加载在表中最后位置，而change/modify 默认都不会改变字段的位置
alter table t1 modify id2 tinyint first;
alter table t1 modify id2 tinyint after id1;
注意：change/first|after 字段名 这些关键字都是属于MySQL在标准SQL上的扩展，在其他的数据库上不一定适用
6)更改表名
alter table 表名 rename [to] 新的表名;
4.DML语句
查询 select * from 表名;
1)插入记录
1>插入记录
insert into 表名(字段1,字段2,字段3,...,字段n) values(值1,值2,值3,...,值n);
也可以不用指定字段名，但是values后面的顺序应该和字段的排序一致
insert into 表名(字段1,字段2,字段3,...,字段n)
values
(值1,值2,值3,...,值n),
(值1,值2,值3,...,值n),
(值1,值2,值3,...,值n)
;
2)更新记录
1>更新一个表
update 表名 set 字段1=值1,字段2=值2,...字段n=值n [where 条件];
2>更新多个表中数据
update 表1,表2,...表n set 表1.字段1=表达式1,表n.字段n=表达式n [where 条件];
注：多表更新更多的用在根据一个表的字段来动态的更新另外一个表的字段
简单实例：
update t1,t2 set t1.age=2000,t2.age=3000 where t1.id=1 and t2.id=1;
3)删除记录
1>删除单表中的数据
delete from 表名 [where 条件];
2>删除多个表中的数据
delete 表1,表2,...表n from 表1,表2,...表n [where 条件];
不管是单表还是多表，不加where条件将会把表中的所有记录删除，所以操作时一定要小心。
4)查询记录
select 字段名|* from 表名;
1>查询不重复的记录
SELECT distinct field1,field2 FROM 表名;
只要field1,field2任何一个字段有不同就会被选择！
一般使用distinct,只筛选一个字段!
2>条件查询
注：条件字段比较符号：
=,,>=,<=,!=等比较运算符
多个条件之间可以使用or and等
where 后面接条件
select * from 表名 where 条件
3>排序和限制
排序:
asc:由低到高，也是默认值
select * from employee order by salary asc;
desc:由高到底
select * from employee order by salary desc;
多个字段排序
select * from employee order by salary desc,id desc;
限制:
在语句的最后面 加上limit 数字1,数字2 来进行查询数量的限制。
limit 数字1,数字2 数字1代表从第几条记录开启取(是从0开始的)，数字2代表取几条！
4>聚合
①sum求和
select sum(字段名) from 表名;
②count记录总数
select count(*|字段名) from 表名;
③max最大值
select max(字段名) from 表名;
④min最小值
select min(字段名) from 表名;
⑤GROUP BY分类聚合
select department,sum(salary) from employee group by department;
⑥WITH ROLLUP分类聚合后的结果进行再汇总
select sum(salary) from employee group by department with rollup;
⑦HAVING
注意：having和where的区别在于，having是对聚合后的结果进行条件过滤，而where是在聚合前就对记录进行过滤
，应该尽可能的对记录进行先过滤！
select sum(salary) from employee group by department having sum(salary)>1000;
在一起使用：select sum(id),max(id),min(id),count(*) from a1;
5>表连接
需求：显示多个表中的字段的时候即可使用表连接
连接分类
内连接：选取两张表中相互匹配的记录
也可以这么写 跟SQL的一样  select * from 表名 a inner join 表名 b on a.字段=b.字段;
外连接：不仅仅选取两张相互匹配的记录，并且会选出其他不匹配的记录
举例：
内连接：select 表.字段,.... from 表1名,表2名,... where [匹配的条件比如 表1.字段=表2.字段];
select 语句可以给字段起别名!直接写在需要查询显示的字段的后面就ok
给表起别名
外连接
1)左连接
概念：包含左边表中的所有记录(包括右表中没有和它匹配的记录)
select ename,deptname from emp left join dept on emp.deptno=dept.deptno;
2)右连接
概念：包含右边表中的所有记录(包括左表中没有和它匹配的记录)
左连接和右连接是可以相互转换的！
6>子查询
需求：一个查询需要另外一个查询的结果参与的时候
用于子查询的关键字:
in
语法：select * from employee where id in(select eid from employee_late);
in 在..里面
注意点 in后面的子语句必须只返回一个字段
若查询结果唯一(只有一条)可以使用=代替in
not in
与in相反
exists
语法：select语句 where exists(select 语句);
exists：后面那个子语句有没有查询出记录来，如果查询出记录来返回true,否则就是false
并且查询出来的记录的具体的值是NULL也是没有关系,也是返回true.
not exits
与exists相反
1)select * from emp where deptno in(select deptno from dept);
2)若查询结果唯一可以使用=代替in
select * from emp where deptno=(select deptno from dept limit 1);
7>记录联合
我们常常会碰到需要将两个表或者多个表的数据按照一定的查询条件查询出来后，将结果合并到一起显示这是就需要用到记录联合
多个select 语句用
UNION或者UNION ALL隔开即可实现
区别： 前者 会将多个查询结果合并后并且进行去除重复后返回
后者 则直接合并并不去除重复
联合的条件：查询的列个数要相等



-- 创建一个school数据库
CREATE DATABASE IF NOT EXISTS `school`;

USE `school`; -- 创建学生表
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`(
    `studentno` INT(4) NOT NULL COMMENT '学号',
    `loginpwd` VARCHAR(20) DEFAULT NULL,
    `studentname` VARCHAR(20) DEFAULT NULL COMMENT '学生姓名',
    `sex` TINYINT(1) DEFAULT NULL COMMENT '性别，0或1',
    `gradeid` INT(11) DEFAULT NULL COMMENT '年级编号',
    `phone` VARCHAR(50) NOT NULL COMMENT '联系电话，允许为空',
    `address` VARCHAR(255) NOT NULL COMMENT '地址，允许为空',
    `borndate` DATETIME DEFAULT NULL COMMENT '出生时间',
    `email` VARCHAR (50) NOT NULL COMMENT '邮箱账号允许为空',
    `identitycard` VARCHAR(18) DEFAULT NULL COMMENT '身份证号',
    PRIMARY KEY (`studentno`),
    UNIQUE KEY `identitycard`(`identitycard`),
    KEY `email` (`email`)
)ENGINE=MYISAM DEFAULT CHARSET=utf8;

-- 创建年级表
DROP TABLE IF EXISTS `grade`;
CREATE TABLE `grade`(
	`gradeid` INT(11) NOT NULL AUTO_INCREMENT COMMENT '年级编号',
  `gradename` VARCHAR(50) NOT NULL COMMENT '年级名称',
    PRIMARY KEY (`gradeid`)
) ENGINE=INNODB AUTO_INCREMENT = 6 DEFAULT CHARSET = utf8;

-- 创建科目表
DROP TABLE IF EXISTS `subject`;
CREATE TABLE `subject`(
	`subjectno`INT(11) NOT NULL AUTO_INCREMENT COMMENT '课程编号',
    `subjectname` VARCHAR(50) DEFAULT NULL COMMENT '课程名称',
    `classhour` INT(4) DEFAULT NULL COMMENT '学时',
    `gradeid` INT(4) DEFAULT NULL COMMENT '年级编号',
    PRIMARY KEY (`subjectno`)
)ENGINE = INNODB AUTO_INCREMENT = 19 DEFAULT CHARSET = utf8;

-- 创建成绩表
DROP TABLE IF EXISTS `result`;
CREATE TABLE `result`(
	`studentno` INT(4) NOT NULL COMMENT '学号',
    `subjectno` INT(4) NOT NULL COMMENT '课程编号',
    `examdate` DATETIME NOT NULL COMMENT '考试日期',
    `studentresult` INT (4) NOT NULL COMMENT '考试成绩',
    KEY `subjectno` (`subjectno`)
)ENGINE = INNODB DEFAULT CHARSET = utf8;

-- 插入学生数据
insert into `student` (`studentno`,`loginpwd`,`studentname`,`sex`,`gradeid`,`phone`,`address`,`borndate`,`email`,`identitycard`)
values
(1000,'111111','郭靖',1,1,'13500000001','北京海淀区中关村大街1号','1986-12-11 00:00:00','test1@bdqn.cn','450323198612111234'),
(1001,'123456','李文才',1,2,'13500000002','河南洛阳','1981-12-31 00:00:00','test1@bdqn.cn','450323198112311234'),
(1002,'111111','李斯文',1,1,'13500000003','天津市和平区','1986-11-30 00:00:00','test1@bdqn.cn','450323198611301234'),
(1003,'123456','武松',1,3,'13500000004','上海卢湾区','1986-12-31 00:00:00','test1@bdqn.cn','450323198612314234'),
(1004,'123456','张三',1,4,'13500000005','北京市通州','1989-12-31 00:00:00','test1@bdqn.cn','450323198612311244'),
(1005,'123456','张秋丽 ',2,1,'13500000006','广西桂林市灵川','1986-12-31 00:00:00','test1@bdqn.cn','450323198612311214'),
(1006,'123456','肖梅',2,4,'13500000007','地址不详','1986-12-31 00:00:00','test1@bdqn.cn','450323198612311134'),
(1007,'111111','欧阳峻峰',1,1,'13500000008','北京东城区','1986-12-31 00:00:00','test1@bdqn.cn','450323198612311133'),
(1008,'111111','梅超风',1,1,'13500000009','河南洛阳','1986-12-31 00:00:00','test1@bdqn.cn','450323198612311221'),
(1009,'123456','刘毅',1,2,'13500000011','安徽','1986-12-31 00:00:00','test1@bdqn.cn','450323198612311231'),
(1010,'111111','大凡',1,1,'13500000012','河南洛阳','1986-12-31 00:00:00','test1@bdqn.cn','450323198612311044'),
(1011,'111111','奥丹斯',1,1,'13500000013','北京海淀区中关村大街*号','1984-12-31 00:00:00','test1@bdqn.cn','450323198412311234'),
(1012,'123456','多伦',2,3,'13500000014','广西南宁中央大街','1986-12-31 00:00:00','test1@bdqn.cn','450323198612311334'),
(1013,'123456','李梅',2,1,'13500000015','上海卢湾区','1986-12-31 00:00:00','test1@bdqn.cn','450323198612311534'),
(1014,'123456','张得',2,4,'13500000016','北京海淀区中关村大街*号','1986-12-31 00:00:00','test1@bdqn.cn','450323198612311264'),
(1015,'123456','李东方',1,4,'13500000017','广西桂林市灵川','1976-12-31 00:00:00','test1@bdqn.cn','450323197612311234'),
(1016,'111111','刘奋斗',1,1,'13500000018','上海卢湾区','1986-12-31 00:00:00','test1@bdqn.cn','450323198612311251'),
(1017,'123456','可可',2,3,'13500000019','北京长安街1号','1981-09-10 00:00:00','test1@bdqn.cn','450323198109108311'),
(10066,'','Tom',1,1,'13500000000','','0000-00-00 00:00:00','email@22.com','33123123123123123');

-- 插入成绩数据
insert into `result`(`studentno`,`subjectno`,`examdate`,`studentresult`)
values
(1000,1,'2013-11-11 16:00:00',85),
(1000,2,'2012-11-10 10:00:00',75),
(1000,3,'2011-12-19 10:00:00',76),
(1000,4,'2010-11-18 11:00:00',93),
(1000,5,'2013-11-11 14:00:00',97),
(1000,6,'2012-09-13 15:00:00',87),
(1000,7,'2011-10-16 16:00:00',79),
(1000,8,'2010-11-11 16:00:00',74),
(1000,9,'2013-11-21 10:00:00',69),
(1000,10,'2012-11-11 12:00:00',78),
(1000,11,'2011-11-11 14:00:00',66),
(1000,12,'2010-11-11 15:00:00',82),
(1000,13,'2013-11-11 14:00:00',94),
(1000,14,'2012-11-11 15:00:00',98),
(1000,15,'2011-12-11 10:00:00',70),
(1000,16,'2010-09-11 10:00:00',74),
(1001,1,'2013-11-11 16:00:00',76),
(1001,2,'2012-11-10 10:00:00',93),
(1001,3,'2011-12-19 10:00:00',65),
(1001,4,'2010-11-18 11:00:00',71),
(1001,5,'2013-11-11 14:00:00',98),
(1001,6,'2012-09-13 15:00:00',74),
(1001,7,'2011-10-16 16:00:00',85),
(1001,8,'2010-11-11 16:00:00',69),
(1001,9,'2013-11-21 10:00:00',63),
(1001,10,'2012-11-11 12:00:00',70),
(1001,11,'2011-11-11 14:00:00',62),
(1001,12,'2010-11-11 15:00:00',90),
(1001,13,'2013-11-11 14:00:00',97),
(1001,14,'2012-11-11 15:00:00',89),
(1001,15,'2011-12-11 10:00:00',72),
(1001,16,'2010-09-11 10:00:00',90),
(1002,1,'2013-11-11 16:00:00',61),
(1002,2,'2012-11-10 10:00:00',80),
(1002,3,'2011-12-19 10:00:00',89),
(1002,4,'2010-11-18 11:00:00',88),
(1002,5,'2013-11-11 14:00:00',82),
(1002,6,'2012-09-13 15:00:00',91),
(1002,7,'2011-10-16 16:00:00',63),
(1002,8,'2010-11-11 16:00:00',84),
(1002,9,'2013-11-21 10:00:00',60),
(1002,10,'2012-11-11 12:00:00',71),
(1002,11,'2011-11-11 14:00:00',93),
(1002,12,'2010-11-11 15:00:00',96),
(1002,13,'2013-11-11 14:00:00',83),
(1002,14,'2012-11-11 15:00:00',69),
(1002,15,'2011-12-11 10:00:00',89),
(1002,16,'2010-09-11 10:00:00',83),
(1003,1,'2013-11-11 16:00:00',91),
(1003,2,'2012-11-10 10:00:00',75),
(1003,3,'2011-12-19 10:00:00',65),
(1003,4,'2010-11-18 11:00:00',63),
(1003,5,'2013-11-11 14:00:00',90),
(1003,6,'2012-09-13 15:00:00',96),
(1003,7,'2011-10-16 16:00:00',97),
(1003,8,'2010-11-11 16:00:00',77),
(1003,9,'2013-11-21 10:00:00',62),
(1003,10,'2012-11-11 12:00:00',81),
(1003,11,'2011-11-11 14:00:00',76),
(1003,12,'2010-11-11 15:00:00',61),
(1003,13,'2013-11-11 14:00:00',93),
(1003,14,'2012-11-11 15:00:00',79),
(1003,15,'2011-12-11 10:00:00',78),
(1003,16,'2010-09-11 10:00:00',96),
(1004,1,'2013-11-11 16:00:00',84),
(1004,2,'2012-11-10 10:00:00',79),
(1004,3,'2011-12-19 10:00:00',76),
(1004,4,'2010-11-18 11:00:00',78),
(1004,5,'2013-11-11 14:00:00',81),
(1004,6,'2012-09-13 15:00:00',90),
(1004,7,'2011-10-16 16:00:00',63),
(1004,8,'2010-11-11 16:00:00',89),
(1004,9,'2013-11-21 10:00:00',67),
(1004,10,'2012-11-11 12:00:00',100),
(1004,11,'2011-11-11 14:00:00',94),
(1004,12,'2010-11-11 15:00:00',65),
(1004,13,'2013-11-11 14:00:00',86),
(1004,14,'2012-11-11 15:00:00',77),
(1004,15,'2011-12-11 10:00:00',82),
(1004,16,'2010-09-11 10:00:00',87),
(1005,1,'2013-11-11 16:00:00',82),
(1005,2,'2012-11-10 10:00:00',92),
(1005,3,'2011-12-19 10:00:00',80),
(1005,4,'2010-11-18 11:00:00',92),
(1005,5,'2013-11-11 14:00:00',97),
(1005,6,'2012-09-13 15:00:00',72),
(1005,7,'2011-10-16 16:00:00',84),
(1005,8,'2010-11-11 16:00:00',79),
(1005,9,'2013-11-21 10:00:00',76),
(1005,10,'2012-11-11 12:00:00',87),
(1005,11,'2011-11-11 14:00:00',65),
(1005,12,'2010-11-11 15:00:00',67),
(1005,13,'2013-11-11 14:00:00',63),
(1005,14,'2012-11-11 15:00:00',64),
(1005,15,'2011-12-11 10:00:00',99),
(1005,16,'2010-09-11 10:00:00',97),
(1006,1,'2013-11-11 16:00:00',82),
(1006,2,'2012-11-10 10:00:00',73),
(1006,3,'2011-12-19 10:00:00',79),
(1006,4,'2010-11-18 11:00:00',63),
(1006,5,'2013-11-11 14:00:00',97),
(1006,6,'2012-09-13 15:00:00',83),
(1006,7,'2011-10-16 16:00:00',78),
(1006,8,'2010-11-11 16:00:00',88),
(1006,9,'2013-11-21 10:00:00',89),
(1006,10,'2012-11-11 12:00:00',82),
(1006,11,'2011-11-11 14:00:00',70),
(1006,12,'2010-11-11 15:00:00',69),
(1006,13,'2013-11-11 14:00:00',64),
(1006,14,'2012-11-11 15:00:00',80),
(1006,15,'2011-12-11 10:00:00',90),
(1006,16,'2010-09-11 10:00:00',85),
(1007,1,'2013-11-11 16:00:00',87),
(1007,2,'2012-11-10 10:00:00',63),
(1007,3,'2011-12-19 10:00:00',70),
(1007,4,'2010-11-18 11:00:00',74),
(1007,5,'2013-11-11 14:00:00',79),
(1007,6,'2012-09-13 15:00:00',83),
(1007,7,'2011-10-16 16:00:00',86),
(1007,8,'2010-11-11 16:00:00',76),
(1007,9,'2013-11-21 10:00:00',65),
(1007,10,'2012-11-11 12:00:00',87),
(1007,11,'2011-11-11 14:00:00',69),
(1007,12,'2010-11-11 15:00:00',69),
(1007,13,'2013-11-11 14:00:00',90),
(1007,14,'2012-11-11 15:00:00',84),
(1007,15,'2011-12-11 10:00:00',95),
(1007,16,'2010-09-11 10:00:00',92),
(1008,1,'2013-11-11 16:00:00',96),
(1008,2,'2012-11-10 10:00:00',62),
(1008,3,'2011-12-19 10:00:00',97),
(1008,4,'2010-11-18 11:00:00',84),
(1008,5,'2013-11-11 14:00:00',86),
(1008,6,'2012-09-13 15:00:00',72),
(1008,7,'2011-10-16 16:00:00',67),
(1008,8,'2010-11-11 16:00:00',83),
(1008,9,'2013-11-21 10:00:00',86),
(1008,10,'2012-11-11 12:00:00',60),
(1008,11,'2011-11-11 14:00:00',61),
(1008,12,'2010-11-11 15:00:00',68),
(1008,13,'2013-11-11 14:00:00',99),
(1008,14,'2012-11-11 15:00:00',77),
(1008,15,'2011-12-11 10:00:00',73),
(1008,16,'2010-09-11 10:00:00',78),
(1009,1,'2013-11-11 16:00:00',67),
(1009,2,'2012-11-10 10:00:00',70),
(1009,3,'2011-12-19 10:00:00',75),
(1009,4,'2010-11-18 11:00:00',92),
(1009,5,'2013-11-11 14:00:00',76),
(1009,6,'2012-09-13 15:00:00',90),
(1009,7,'2011-10-16 16:00:00',62),
(1009,8,'2010-11-11 16:00:00',68),
(1009,9,'2013-11-21 10:00:00',70),
(1009,10,'2012-11-11 12:00:00',83),
(1009,11,'2011-11-11 14:00:00',88),
(1009,12,'2010-11-11 15:00:00',65),
(1009,13,'2013-11-11 14:00:00',91),
(1009,14,'2012-11-11 15:00:00',99),
(1009,15,'2011-12-11 10:00:00',65),
(1009,16,'2010-09-11 10:00:00',83),
(1010,1,'2013-11-11 16:00:00',83),
(1010,2,'2012-11-10 10:00:00',87),
(1010,3,'2011-12-19 10:00:00',89),
(1010,4,'2010-11-18 11:00:00',99),
(1010,5,'2013-11-11 14:00:00',91),
(1010,6,'2012-09-13 15:00:00',96),
(1010,7,'2011-10-16 16:00:00',72),
(1010,8,'2010-11-11 16:00:00',72),
(1010,9,'2013-11-21 10:00:00',98),
(1010,10,'2012-11-11 12:00:00',73),
(1010,11,'2011-11-11 14:00:00',68),
(1010,12,'2010-11-11 15:00:00',62),
(1010,13,'2013-11-11 14:00:00',67),
(1010,14,'2012-11-11 15:00:00',69),
(1010,15,'2011-12-11 10:00:00',71),
(1010,16,'2010-09-11 10:00:00',66),
(1011,1,'2013-11-11 16:00:00',62),
(1011,2,'2012-11-10 10:00:00',72),
(1011,3,'2011-12-19 10:00:00',96),
(1011,4,'2010-11-18 11:00:00',64),
(1011,5,'2013-11-11 14:00:00',89),
(1011,6,'2012-09-13 15:00:00',91),
(1011,7,'2011-10-16 16:00:00',95),
(1011,8,'2010-11-11 16:00:00',96),
(1011,9,'2013-11-21 10:00:00',89),
(1011,10,'2012-11-11 12:00:00',73),
(1011,11,'2011-11-11 14:00:00',82),
(1011,12,'2010-11-11 15:00:00',98),
(1011,13,'2013-11-11 14:00:00',66),
(1011,14,'2012-11-11 15:00:00',69),
(1011,15,'2011-12-11 10:00:00',91),
(1011,16,'2010-09-11 10:00:00',69),
(1012,1,'2013-11-11 16:00:00',86),
(1012,2,'2012-11-10 10:00:00',66),
(1012,3,'2011-12-19 10:00:00',97),
(1012,4,'2010-11-18 11:00:00',69),
(1012,5,'2013-11-11 14:00:00',70),
(1012,6,'2012-09-13 15:00:00',74),
(1012,7,'2011-10-16 16:00:00',91),
(1012,8,'2010-11-11 16:00:00',97),
(1012,9,'2013-11-21 10:00:00',84),
(1012,10,'2012-11-11 12:00:00',82),
(1012,11,'2011-11-11 14:00:00',90),
(1012,12,'2010-11-11 15:00:00',91),
(1012,13,'2013-11-11 14:00:00',91),
(1012,14,'2012-11-11 15:00:00',97),
(1012,15,'2011-12-11 10:00:00',85),
(1012,16,'2010-09-11 10:00:00',90),
(1013,1,'2013-11-11 16:00:00',73),
(1013,2,'2012-11-10 10:00:00',69),
(1013,3,'2011-12-19 10:00:00',91),
(1013,4,'2010-11-18 11:00:00',72),
(1013,5,'2013-11-11 14:00:00',76),
(1013,6,'2012-09-13 15:00:00',87),
(1013,7,'2011-10-16 16:00:00',61),
(1013,8,'2010-11-11 16:00:00',77),
(1013,9,'2013-11-21 10:00:00',83),
(1013,10,'2012-11-11 12:00:00',99),
(1013,11,'2011-11-11 14:00:00',91),
(1013,12,'2010-11-11 15:00:00',84),
(1013,13,'2013-11-11 14:00:00',98),
(1013,14,'2012-11-11 15:00:00',74),
(1013,15,'2011-12-11 10:00:00',92),
(1013,16,'2010-09-11 10:00:00',90),
(1014,1,'2013-11-11 16:00:00',64),
(1014,2,'2012-11-10 10:00:00',81),
(1014,3,'2011-12-19 10:00:00',79),
(1014,4,'2010-11-18 11:00:00',74),
(1014,5,'2013-11-11 14:00:00',65),
(1014,6,'2012-09-13 15:00:00',88),
(1014,7,'2011-10-16 16:00:00',86),
(1014,8,'2010-11-11 16:00:00',77),
(1014,9,'2013-11-21 10:00:00',86),
(1014,10,'2012-11-11 12:00:00',85),
(1014,11,'2011-11-11 14:00:00',86),
(1014,12,'2010-11-11 15:00:00',75),
(1014,13,'2013-11-11 14:00:00',89),
(1014,14,'2012-11-11 15:00:00',79),
(1014,15,'2011-12-11 10:00:00',73),
(1014,16,'2010-09-11 10:00:00',68),
(1015,1,'2013-11-11 16:00:00',99),
(1015,2,'2012-11-10 10:00:00',60),
(1015,3,'2011-12-19 10:00:00',60),
(1015,4,'2010-11-18 11:00:00',75),
(1015,5,'2013-11-11 14:00:00',78),
(1015,6,'2012-09-13 15:00:00',78),
(1015,7,'2011-10-16 16:00:00',84),
(1015,8,'2010-11-11 16:00:00',95),
(1015,9,'2013-11-21 10:00:00',93),
(1015,10,'2012-11-11 12:00:00',79),
(1015,11,'2011-11-11 14:00:00',74),
(1015,12,'2010-11-11 15:00:00',65),
(1015,13,'2013-11-11 14:00:00',63),
(1015,14,'2012-11-11 15:00:00',74),
(1015,15,'2011-12-11 10:00:00',67),
(1015,16,'2010-09-11 10:00:00',65),
(1016,1,'2013-11-11 16:00:00',97),
(1016,2,'2012-11-10 10:00:00',90),
(1016,3,'2011-12-19 10:00:00',77),
(1016,4,'2010-11-18 11:00:00',75),
(1016,5,'2013-11-11 14:00:00',75),
(1016,6,'2012-09-13 15:00:00',97),
(1016,7,'2011-10-16 16:00:00',96),
(1016,8,'2010-11-11 16:00:00',92),
(1016,9,'2013-11-21 10:00:00',62),
(1016,10,'2012-11-11 12:00:00',83),
(1016,11,'2011-11-11 14:00:00',98),
(1016,12,'2010-11-11 15:00:00',94),
(1016,13,'2013-11-11 14:00:00',62),
(1016,14,'2012-11-11 15:00:00',97),
(1016,15,'2011-12-11 10:00:00',76),
(1016,16,'2010-09-11 10:00:00',82),
(1017,1,'2013-11-11 16:00:00',100),
(1017,2,'2012-11-10 10:00:00',88),
(1017,3,'2011-12-19 10:00:00',86),
(1017,4,'2010-11-18 11:00:00',73),
(1017,5,'2013-11-11 14:00:00',96),
(1017,6,'2012-09-13 15:00:00',64),
(1017,7,'2011-10-16 16:00:00',81),
(1017,8,'2010-11-11 16:00:00',66),
(1017,9,'2013-11-21 10:00:00',76),
(1017,10,'2012-11-11 12:00:00',95),
(1017,11,'2011-11-11 14:00:00',73),
(1017,12,'2010-11-11 15:00:00',82),
(1017,13,'2013-11-11 14:00:00',85),
(1017,14,'2012-11-11 15:00:00',68),
(1017,15,'2011-12-11 10:00:00',99),
(1017,16,'2010-09-11 10:00:00',76);

-- 插入年级数据
insert into `grade` (`gradeid`,`gradename`) 
values(1,'大一'),(2,'大二'),(3,'大三'),
(4,'大四'),(5,'预科班');

-- 插入科目数据
insert into `subject`(`subjectno`,`subjectname`,`classhour`,`gradeid`)values
(1,'高等数学-1',110,1),
(2,'高等数学-2',110,2),
(3,'高等数学-3',100,3),
(4,'高等数学-4',130,4),
(5,'C语言-1',110,1),
(6,'C语言-2',110,2),
(7,'C语言-3',100,3),
(8,'C语言-4',130,4),
(9,'JAVA第一学年',110,1),
(10,'JAVA第二学年',110,2),
(11,'JAVA第三学年',100,3),
(12,'JAVA第四学年',130,4),
(13,'数据库结构-1',110,1),
(14,'数据库结构-2',110,2),
(15,'数据库结构-3',100,3),
(16,'数据库结构-4',130,4),
(17,'C#基础',130,1);






-- MySql 5.7关键字和保留字-附表
ACCESSIBLE (R)	ACCOUNT[a]	ACTION  ADD (R)	AFTER	AGAINST  AGGREGATE	ALGORITHM	ALL (R)  ALTER (R)	ALWAYS[b]	ANALYSE  ANALYZE (R)	AND (R)	ANY  AS (R)	ASC (R)	ASCII  ASENSITIVE (R)	AT	AUTOEXTEND_SIZE  AUTO_INCREMENT	AVG	AVG_ROW_LENGTH  BACKUP	BEFORE (R)	BEGIN  BETWEEN (R)	BIGINT (R)	BINARY (R)  BINLOG	BIT	BLOB (R)  BLOCK	BOOL	BOOLEAN  BOTH (R)	BTREE	BY (R)  BYTE	
CACHE	CALL (R)  CASCADE (R)	CASCADED	CASE (R)  CATALOG_NAME	CHAIN	CHANGE (R)  CHANGED	CHANNEL[c]	CHAR (R)  CHARACTER (R)	CHARSET	CHECK (R)  CHECKSUM	CIPHER	CLASS_ORIGIN  CLIENT	CLOSE	COALESCE  CODE	COLLATE (R)	COLLATION  COLUMN (R)	COLUMNS	COLUMN_FORMAT  COLUMN_NAME	COMMENT	COMMIT  COMMITTED	COMPACT	COMPLETION  COMPRESSED	COMPRESSION[d]	CONCURRENT  CONDITION (R)	CONNECTION	CONSISTENT  CONSTRAINT (R)	CONSTRAINT_CATALOG	CONSTRAINT_NAME  CONSTRAINT_SCHEMA	CONTAINS	CONTEXT  CONTINUE (R)	CONVERT (R)	CPU  CREATE (R)	CROSS (R)	CUBE  CURRENT	CURRENT_DATE (R)	CURRENT_TIME (R)  CURRENT_TIMESTAMP (R)	CURRENT_USER (R)	CURSOR (R)  CURSOR_NAME	DATA	
DATABASE (R)  DATABASES (R)	DATAFILE	DATE  DATETIME	DAY	DAY_HOUR (R)  DAY_MICROSECOND (R)	DAY_MINUTE (R)	DAY_SECOND (R)  DEALLOCATE	DEC (R)	DECIMAL (R)  DECLARE (R)	DEFAULT (R)	DEFAULT_AUTH  DEFINER	DELAYED (R)	DELAY_KEY_WRITE  DELETE (R)	DESC (R)	DESCRIBE (R)  DES_KEY_FILE	DETERMINISTIC (R)	DIAGNOSTICS  DIRECTORY	DISABLE	DISCARD  DISK	DISTINCT (R)	DISTINCTROW (R)  DIV (R)	DO	DOUBLE (R)  DROP (R)	DUAL (R)	DUMPFILE  DUPLICATE	DYNAMIC	
EACH (R)  ELSE (R)	ELSEIF (R)	ENABLE  ENCLOSED (R)	ENCRYPTION[e]	END  ENDS	ENGINE	ENGINES  ENUM	ERROR	ERRORS  ESCAPE	ESCAPED (R)	EVENT  EVENTS	EVERY	EXCHANGE  EXECUTE	EXISTS (R)	EXIT (R)  EXPANSION	EXPIRE	EXPLAIN (R)  EXPORT	EXTENDED	EXTENT_SIZE  FALSE (R)	FAST	FAULTS  FETCH (R)	FIELDS	FILE  FILE_BLOCK_SIZE[f]	FILTER[g]	FIRST  FIXED	FLOAT (R)	FLOAT4 (R)  FLOAT8 (R)	FLUSH	FOLLOWS[h]  FOR (R)	FORCE (R)	FOREIGN (R)  FORMAT	FOUND	FROM (R)  FULL	FULLTEXT (R)	FUNCTION  
GENERAL	GENERATED[i] (R)	GEOMETRY  GEOMETRYCOLLECTION	GET (R)	GET_FORMAT  GLOBAL	GRANT (R)	GRANTS  GROUP (R)	GROUP_REPLICATION[j]	HANDLER  HASH	HAVING (R)	HELP  HIGH_PRIORITY (R)	HOST	HOSTS  HOUR	HOUR_MICROSECOND (R)	HOUR_MINUTE (R)  HOUR_SECOND (R)	
IDENTIFIED	IF (R)  IGNORE (R)	IGNORE_SERVER_IDS	IMPORT  IN (R)	INDEX (R)	INDEXES  INFILE (R)	INITIAL_SIZE	INNER (R)  INOUT (R)	INSENSITIVE (R)	INSERT (R)  INSERT_METHOD	INSTALL	INSTANCE[k]  INT (R)	INT1 (R)	INT2 (R)  INT3 (R)	INT4 (R)	INT8 (R)  INTEGER (R)	INTERVAL (R)	INTO (R)  INVOKER	IO	IO_AFTER_GTIDS (R)  IO_BEFORE_GTIDS (R)	IO_THREAD	IPC  IS (R)	ISOLATION	ISSUER  ITERATE (R)	
JOIN (R)	JSON[l]  KEY (R)	KEYS (R)	KEY_BLOCK_SIZE  KILL (R)	LANGUAGE	LAST  LEADING (R)	LEAVE (R)	LEAVES  LEFT (R)	LESS	LEVEL  LIKE (R)	LIMIT (R)	LINEAR (R)  LINES (R)	LINESTRING	LIST  LOAD (R)	LOCAL	LOCALTIME (R)  LOCALTIMESTAMP (R)	LOCK (R)	LOCKS  LOGFILE	LOGS	LONG (R)  LONGBLOB (R)	LONGTEXT (R)	LOOP (R)  LOW_PRIORITY (R)	
MASTER	MASTER_AUTO_POSITION  MASTER_BIND (R)	MASTER_CONNECT_RETRY	MASTER_DELAY  MASTER_HEARTBEAT_PERIOD	MASTER_HOST	MASTER_LOG_FILE  MASTER_LOG_POS	MASTER_PASSWORD	MASTER_PORT  MASTER_RETRY_COUNT	MASTER_SERVER_ID	MASTER_SSL  MASTER_SSL_CA	MASTER_SSL_CAPATH	MASTER_SSL_CERT  MASTER_SSL_CIPHER	MASTER_SSL_CRL	MASTER_SSL_CRLPATH  MASTER_SSL_KEY	MASTER_SSL_VERIFY_SERVER_CERT (R)	MASTER_TLS_VERSION[m]  MASTER_USER	
MATCH (R)	MAXVALUE (R)  MAX_CONNECTIONS_PER_HOUR	MAX_QUERIES_PER_HOUR	MAX_ROWS  MAX_SIZE	MAX_STATEMENT_TIME[n]	MAX_UPDATES_PER_HOUR  MAX_USER_CONNECTIONS	MEDIUM	MEDIUMBLOB (R)  MEDIUMINT (R)	MEDIUMTEXT (R)	MEMORY  MERGE	MESSAGE_TEXT	MICROSECOND  MIDDLEINT (R)	MIGRATE	MINUTE  MINUTE_MICROSECOND (R)	MINUTE_SECOND (R)	MIN_ROWS  MOD (R)	MODE	MODIFIES (R)  MODIFY	MONTH	MULTILINESTRING  MULTIPOINT	MULTIPOLYGON	MUTEX  MYSQL_ERRNO	
NAME	NAMES  NATIONAL	NATURAL (R)	NCHAR  NDB	NDBCLUSTER	NEVER[o]  NEW	NEXT	NO  NODEGROUP	NONBLOCKING[p]	NONE  NOT (R)	NO_WAIT	NO_WRITE_TO_BINLOG (R)  NULL (R)	NUMBER	NUMERIC (R)  NVARCHAR	OFFSET	OLD_PASSWORD[q]  ON (R)	ONE	ONLY  OPEN	OPTIMIZE (R)	OPTIMIZER_COSTS[r] (R)  OPTION (R)	OPTIONALLY (R)	OPTIONS  OR (R)	ORDER (R)	OUT (R)  OUTER (R)	OUTFILE (R)	OWNER  
PACK_KEYS	PAGE	PARSER  PARSE_GCOL_EXPR[s]	PARTIAL	PARTITION (R)  PARTITIONING	PARTITIONS	PASSWORD  PHASE	PLUGIN	PLUGINS  PLUGIN_DIR	POINT	POLYGON  PORT	PRECEDES[t]	PRECISION (R)  PREPARE	PRESERVE	PREV  PRIMARY (R)	PRIVILEGES	PROCEDURE (R)  PROCESSLIST	PROFILE	PROFILES  PROXY	PURGE (R)	QUARTER  QUERY	QUICK	
RANGE (R)  READ (R)	READS (R)	READ_ONLY  READ_WRITE (R)	REAL (R)	REBUILD  RECOVER	REDOFILE	REDO_BUFFER_SIZE  REDUNDANT	REFERENCES (R)	REGEXP (R)  RELAY	RELAYLOG	RELAY_LOG_FILE  RELAY_LOG_POS	RELAY_THREAD	RELEASE (R)  RELOAD	REMOVE	RENAME (R)  REORGANIZE	REPAIR	REPEAT (R)  REPEATABLE	REPLACE (R)	REPLICATE_DO_DB[u]  REPLICATE_DO_TABLE[v]	REPLICATE_IGNORE_DB[w]	REPLICATE_IGNORE_TABLE[x]  REPLICATE_REWRITE_DB[y]	REPLICATE_WILD_DO_TABLE[z]	REPLICATE_WILD_IGNORE_TABLE[aa]  REPLICATION	REQUIRE (R)	RESET  RESIGNAL (R)	RESTORE	RESTRICT (R)  RESUME	RETURN (R)	RETURNED_SQLSTATE  RETURNS	REVERSE	REVOKE (R)  RIGHT (R)	RLIKE (R)	ROLLBACK  ROLLUP	ROTATE[ab]	ROUTINE  ROW	ROWS	ROW_COUNT  ROW_FORMAT	RTREE	
SAVEPOINT  SCHEDULE	SCHEMA (R)	SCHEMAS (R)  SCHEMA_NAME	SECOND	SECOND_MICROSECOND (R)  SECURITY	SELECT (R)	SENSITIVE (R)  SEPARATOR (R)	SERIAL	SERIALIZABLE  SERVER	SESSION	SET (R)  SHARE	SHOW (R)	SHUTDOWN  SIGNAL (R)	SIGNED	SIMPLE  SLAVE	SLOW	SMALLINT (R)  SNAPSHOT	SOCKET	SOME  SONAME	SOUNDS	SOURCE  SPATIAL (R)	SPECIFIC (R)	SQL (R)  SQLEXCEPTION (R)	SQLSTATE (R)	SQLWARNING (R)  SQL_AFTER_GTIDS	SQL_AFTER_MTS_GAPS	SQL_BEFORE_GTIDS  SQL_BIG_RESULT (R)
SQL_BUFFER_RESULT	SQL_CACHE  SQL_CALC_FOUND_ROWS (R)	SQL_NO_CACHE	SQL_SMALL_RESULT (R)  SQL_THREAD	SQL_TSI_DAY	SQL_TSI_HOUR  SQL_TSI_MINUTE	SQL_TSI_MONTH	SQL_TSI_QUARTER  SQL_TSI_SECOND	SQL_TSI_WEEK	SQL_TSI_YEAR  SSL (R)	STACKED	START  STARTING (R)	STARTS	STATS_AUTO_RECALC  STATS_PERSISTENT	STATS_SAMPLE_PAGES	STATUS  STOP	STORAGE	STORED[ac] (R)  STRAIGHT_JOIN (R)	STRING	SUBCLASS_ORIGIN  SUBJECT	SUBPARTITION	SUBPARTITIONS  SUPER	SUSPEND	SWAPS  SWITCHES	
TABLE (R)	TABLES  TABLESPACE	TABLE_CHECKSUM	TABLE_NAME  TEMPORARY	TEMPTABLE	TERMINATED (R)  TEXT	THAN	THEN (R)  TIME	TIMESTAMP	TIMESTAMPADD  TIMESTAMPDIFF	TINYBLOB (R)	TINYINT (R)  TINYTEXT (R)	TO (R)	TRAILING (R)  TRANSACTION	TRIGGER (R)	TRIGGERS  TRUE (R)	TRUNCATE	TYPE  TYPES	
UNCOMMITTED	UNDEFINED  UNDO (R)	UNDOFILE	UNDO_BUFFER_SIZE  UNICODE	UNINSTALL	UNION (R)  UNIQUE (R)	UNKNOWN	UNLOCK (R)  UNSIGNED (R)	UNTIL	UPDATE (R)  UPGRADE	USAGE (R)	USE (R)  USER	USER_RESOURCES	USE_FRM  USING (R)	UTC_DATE (R)	UTC_TIME (R)  UTC_TIMESTAMP (R)	
VALIDATION[ad]	VALUE  VALUES (R)	VARBINARY (R)	VARCHAR (R)  VARCHARACTER (R)	VARIABLES	VARYING (R)  VIEW	VIRTUAL[ae] (R)	WAIT  WARNINGS	WEEK	WEIGHT_STRING  WHEN (R)	WHERE (R)	WHILE (R)  WITH (R)	WITHOUT[af]	WORK  WRAPPER	WRITE (R)	X509  XA	XID[ag]	XML  XOR (R)	YEAR	YEAR_MONTH (R)  ZEROFILL (R)	 	 

