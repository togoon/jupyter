
# 1. recovery zip  aliyunpan

```shell
sudo curl -fsSL http://file.tickstep.com/apt/pgp | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/tickstep-packages-archive-keyring.gpg > /dev/null && echo "deb [signed-by=/etc/apt/trusted.gpg.d/tickstep-packages-archive-keyring.gpg arch=amd64,arm64] http://file.tickstep.com/apt aliyunpan main" | sudo tee /etc/apt/sources.list.d/tickstep-aliyunpan.list > /dev/null && sudo apt-get update && sudo apt-get install -y aliyunpan

cd /workspaces
https://github.com/tickstep/aliyunpan#apt%E5%AE%89%E8%A3%85
wget https://github.com/tickstep/aliyunpan/releases/download/v0.2.5/aliyunpan-v0.2.5-linux-amd64.zip
unzip /workspaces/aliyunpan-v0.2.5-linux-amd64.zip 
mv /workspaces/aliyunpan-v0.2.5-linux-amd64  /workspaces/aliyunpan # ./aliyunpan
rm -rf aliyunpan-v0.2.5-linux-amd64.zip 
#mv /workspaces/jupyter/tmp/aliyunpan/ /workspaces/
sudo ln -s /workspaces/aliyunpan/aliyunpan /usr/bin/aliyunpan
whereis aliyunpan


aliyunpan login -QrCode # help
cd /workspaces
zip -r jupyter_`date -d '+8 hour' '+%Y%m%d'`.zip jupyter -x='jupyter/.git/*'  #
aliyunpan u /workspaces/jupyter_`date -d '+8 hour' '+%Y%m%d'`.zip /backup/jupyter/ --ow
rm -rf /workspaces/jupyter_`date -d '+8 hour' '+%Y%m%d'`.zip

aliyunpan d /backup/jupyter/jupyter_`date -d '+8 hour' '+%Y%m%d'`.zip --saveto /workspaces/ --ow
unzip /workspaces/backup/jupyter/jupyter_`date -d '+8 hour' '+%Y%m%d'`.zip
# cd /workspaces/backup/jupyter/jupyter_`date -d '+8 hour' '+%Y%m%d'`
# sudo mv * .[^.]*  /workspaces/jupyter/
# cd /workspaces/
# sudo chmod 777 -R jupyter/  # 权限 批量 递归
# rm -rf /workspaces/backup/

# sudo mv /workspaces/jupyter/tmp/jupyter-main.zip /workspaces/
# sudo -d /workspaces/ unzip jupyter-main.zip # 指定解压目录
# cd /workspaces/jupyter-main/
# sudo mv * .[^.]*  jupyter/
# cd ..
# rm -rf /workspaces/jupyter-main
# mv /workspaces/jupyter-main.zip /workspaces/jupyter/tmp/

# bigdata
mkdir bigdata
sudo chmod +777 bigdata
/workspaces/backup/bigdata/
aliyunpan u bigdata/ /backup/
aliyunpan u /workspaces/jupyter/tmp/uk5m_2021df.pkl /backup/bigdata/
# hq.db
# uk5m_2021df.pkl
aliyunpan d /backup/bigdata/uk5m_2021df.pkl --saveto /workspaces/  # /workspaces/backup/bigdata/uk5m_2021df.pkl
```

# 2. apt-get pip 

```shell
sudo apt-get update | sudo apt-get upgrade  # 更新源update 更新软件upgrade 
# rsync -av root@8.219.68.31:/root/tmp/codespaces/jupyter --exclude .git/ /workspaces/
pip install --upgrade pip
python3 -m pip install -r /workspaces/jupyter/settings/requirements.txt  #  settings/requirements.txt
cp /workspaces/jupyter/settings/.vimrc ~/

```

# 3. sysv-rc-conf crontab

```shell
sudo vim /etc/apt/sources.list
    deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse
sudo apt-get update | sudo apt-get upgrade  # 更新源update 更新软件upgrade
sudo apt-get install sysv-rc-conf # 0停机 1单用户/维护 2~5多用户 6重启 s开机 
sudo apt install cron 

sudo sysv-rc-conf --list cron # 2~5 6 s  sudo sysv-rc-conf
sudo service cron start	# start  stop reload restart status

sudo vi /etc/rsyslog.d/50-default.conf # cron.*前的#删掉
sudo service rsyslog restart
sudo service cron restart
tail -f /var/log/cron.log # cron日志

crontab -e   # ①分钟(0-59) | ②小时(0-23) | ③号(1-31) | ④月(1-12) | ⑤星期几 (0-6 星期天0)
*/5 * * * * sh /workspaces/jupyter/settings/gitTimer.sh 
*/60  * * * * /usr/local/bin/aliyunpan token update -mode 2

sed -i '$a sudo service cron start' /home/codespace/.bashrc # 每次启动终端时, 启动cron
sed -i '$a export ALIYUNPAN_CONFIG_DIR=/workspaces/jupyter/settings/aliyunpan/config' /home/codespace/.bashrc # 

cp -rf /home/codespace/.bashrc /workspaces/jupyter/settings/.bashrc 
# cp -rf /workspaces/jupyter/settings/.bashrc /home/codespace/ # sudo service cron start

# sudo service cron start

# ubuntu
*/5 * * * * sh /home/at/test/jupyter/settings/ubuntu/gitTimer.sh 

sed -i '$a export ALIYUNPAN_CONFIG_DIR=/home/at/test/jupyter/settings/aliyunpan/config' ~/.bashrc # 

# sed -i '$a echo 314159 | sudo service cron start' ~/.bashrc # 每次启动终端时, 启动cron
sed -i '$a sudo -S service cron start << EOF' ~/.bashrc # 每次启动终端时, 启动cron
sed -i '$a 314159' ~/.bashrc # 
sed -i '$a EOF' ~/.bashrc # 

cp -rf ~/.bashrc /home/at/test/jupyter/settings/ubuntu/.bashrc 

```

# 4. ssh git  

```shell
# Settings>Developer settings>Personal access tokens>Generate new token
# >note name>expiration期限>权限repo>Generate token 

# 119, 120, 123, 124, 125, 126, 163, 
# 129 pop3 IRUPLCZQGPAVDHHM
# 130 pop3 TZXWPSJKDLZVJAX
# 163 pop3 SKXXQYSWXTQWQBMV
# 119 pop3 NTDWUAQCOVBZXPOE

# 119 atob('Z2hwX0N0RFRMZFhjd3FpNmJUakhCb21VM0c2UUZHWVVFTjA2QmlEQQ==')
# 120 atob('Z2hwX1pVak5ERmg0Sll3SkVITXV3d3U2TE1lakZVUGszeDNmMEthag==')
# 121 atob('Z2hwXzlpWmRsTnRtbDA5ZzVtNmplNUs3aXdlV21nTG5lQjFaMDlJUA==')
# 122 atob('Z2hwX1dvSGpoRFhBM2w4Zldtd3RmcUlIaXNqVE9rT3drUTNzclhiVA==')
# 123 atob('Z2hwX09ZVmxZRm5OYzJjQ3EwWWFrVWQxcHg3YUJHS214SjE1dVVqZA==') # btoa('token...ghp_')
# 124 atob('Z2hwX0p5NGZhMWNkdjZVcWk1dGJVRXM4ZnIzbDVTcElZVTFHcU1oOA==') 
# 125 atob('Z2hwX2tJNzZ3Umo4SkpobWs0VzI2NldGSTd0MDJIYlhsbjNuRGh6WA==')
# 244 atob('Z2hwX08yaVNnaWpoNDJMZ25OWkdmOWRqUUFvSlRDN0VSdTRTSDJvUg==') # jupyter244564485



# git remote add origin https://username:password@github.com/ation122/jupyter.git
git remote set-url origin https://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@github.com/ation124/jupyter.git 

#git config --global credential.helper store 
git config --local user.email "ation123@126.com" # global local 244564485@qq.com
git config --local user.name "ation123@126.com" # 119 120 121 122 123 124 125 126 
# git config --global credential.helper 'cache --timeout=3600000'

# echo `date -d '+8 hour' '+%Y-%m-%d %H:%M:%S'` >> /workspaces/jupyter/tmp/test.log 2>&1 
# git add .   
# git commit -m "`date -d '+8 hour' '+%Y-%m-%d %H:%M:%S'`"  
# sudo git pull --rebase origin main  # master > main
# sudo git push -u origin main   >> /workspaces/jupyter/tmp/test.log 2>&1 


# mkdir /home/codespace/.vscode-remote/data/User/globalStorage/cweijan.vscode-myssql-client2
# cp /workspaces/jupyter/settings/SQlServerClient_config.json  /home/codespace/.vscode-remote/data/User/globalStorage/cweijan.vscode-myssql-client2/config.json

# ssh id_rsa.pub    # /home/codespace/.ssh/id_rsa
# ssh-keygen
# ssh-copy-id -i /home/codespace/.ssh/id_rsa.pub root@47.241.99.13
# #/root/.shh/authorized_keys (...= codespace@codespaces-db7098)
# ssh -l root 47.241.99.13
# ssh-copy-id -i /home/codespace/.ssh/id_rsa.pub root@8.219.68.31
# ssh -l root 8.219.68.31


```


# 5. settings  

+ vscode Extension (.vscode/extensions.json) @recommended 
- restart
* settings/SQlServerClient_config.json
+ settings/git_config


# 6. mysql 8.0.31  

```shell
# 卸载mysql8
service mysql stop # 关闭MySQL服务
sudo apt remove --purge mysql-* # 卸载mysql
sudo apt autoremove # 卸载依赖
dpkg --list | grep mysql # 清理残余文件
dpkg -l |grep ^rc|awk '{print $2}' |sudo xargs dpkg -P # 清空mysql的配置文件
sudo rm -rf /etc/mysql
sudo rm -rf /var/lib/mysql
sudo apt-get update # 更新软件源，安装或卸载软件

sudo apt update # 更新系统 软件包索引或包列表 
# cat /etc/apt/sources.list
sudo apt list --upgradable # 列出需要升级的软件包
sudo apt upgrade # 升级所有过时的软件包并应用安全补丁
sudo apt install mysql-server mysql-common # APT自动安装MySQL8的服务端和客户端

sudo service mysql status
sudo service mysql start # stop
mysql -uroot -p # root帐号登陆 
quit exit

sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'reaL2022';
# GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'; # 授权 root 用户的所有权限并设置远程访问
# Grant all privileges on test.* to 'test'@'%';     # 如果账号为“test”时，使用该命令
# GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'WITH GRANT OPTION;   # old 授权
# GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'reaL2022' WITH GRANT OPTION; # old 赋予任何主机访问权限
flush privileges;
exit

sudo mysql_secure_installation # 设置MySQL安全选项
Remove anonymous : Y
Disallow root login remotely : N
Remove test database : N
Reload privilege tables : Y 


mysql -uroot -p # 无密码root帐号登陆 -h 180.76.XXX.XX  127.0.0.1
use mysql;
select host, user, authentication_string, plugin from user; # 查看MySQL远程访问权限配置
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'; # 授权 root 用户的所有权限并设置远程访问
# update user set host='%' where user='root';  # 远程登录
flush privileges;
quit

# config.json
"mysql": {
    "host": "127.0.0.1",
    "jdbcport": 3306,
    "xdevport": 33060,
    "db": "FIL_testfil",
    "usr": "root",
    "password": "reaL2022"
},

# sudo dpkg -i 名字
# mysql-community-client-plugins_8.0.28-1ubuntu20.04_amd64.deb
# libmysqlcppconn8-2_8.0.28-1ubuntu20.04_amd64.deb
# libmysqlcppconn9_8.0.28-1ubuntu20.04_amd64.deb
# libmysqlcppconn-dev_8.0.28-1ubuntu20.04_amd64.deb


# 迁移MySQL8数据
sudo service mysql stop
sudo mkdir /data # 创建data文件夹
sudo rsync -a /var/lib/mysql /data/ # 复制文件 
sudo chmod 777 /data/ # 权限
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
	datadir = /data/mysql
sudo vim /etc/apparmor.d/usr.sbin.mysqld
	# Allow data dir access
	  /data/mysql/ r,
	  /data/mysql/** rwk,
sudo vim /etc/apparmor.d/abstractions/mysql # 修改控制文件
	/data/mysql{,d}/mysql{,d}.sock rw,

service apparmor restart # systemctl restart apparmor # 重新启动apparmor
service mysql start # systemctl start mysql # 启动MySQL

# 远程root用户访问 
# 修改或添加root用户的远程连接Host
use mysql;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your-pass-word';
update mysql.user set host='%' where user='root';
flush privileges;

# 开启访问权限 取消IP限制 修改bind-address属性，或者直接注释掉该属性
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf 
	bind-address            = * 

# error
/etc/mysql/my.cnf
[client]
port            = 3306
socket          = /var/run/mysqld/mysqld.

# mysql8.0 开启日志记录
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf # 配置文件
#在 [mysqld]下加上两句:
general_log_file= /var/log/mysql/mysql.log
general_log = 1

sudo service mysql restart # 重启服务
sudo tail -f /var/log/mysql/mysql.log # 查看日志

```

# mysql 
```shell

# 安装 mysql
sudo apt update  # sudo apt upgrade
sudo apt-get install mysql-server mysql-common
sudo apt install mysql-server
mysql --version # 版本 mysql  Ver 8.0.31-0ubuntu0.20.04.1 for Linux on x86_64 ((Ubuntu))
sudo /etc/init.d/mysql start # 启动 MySQL 服务器 restart stop start 
sudo mysql_secure_installation # 启动安全脚本提示符

# root
sudo mysqld_safe --skip-grant-tables & # 安全模式启动
mysql -uroot -p # 无密码root帐号登陆
use mysql;
flush privileges; # 刷新系统权限表命令
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'fil2022'; # ok手动update修改密码
flush privileges;
quit
mysql -u root -p fil2022 # 重新使用密码登录
#service mysqld start # 正常重新启动
ps -ef | grep mysql # 查看进程
netstat -lantup | grep 3306 # 查看端口号 lsof -i:3306

sudo mysql
SHOW DATABASES;
CREATE DATABASE database_name;

sudo /etc/init.d/mysql start # 启动 MySQL 服务器 restart stop start status 
skip-grant-tables=1
sudo usermod -d /var/lib/mysql/ mysql

/etc/init.d/mysql status # 查看mysql 的运行状态

sudo apt-get install mysql-server mysql-common
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf # 免密登录 [mysqld] 插入
skip-grant-tables

ls /var/lib/mysql/mysql.sock
sudo ls /var/run/mysqld/mysqld.sock
lsof -i:3306

mysql -h localhost -uroot -p # ERROR 2002 (HY000) (13)
mysql -h 127.0.0.1 -uroot -p # ERROR 2003 (HY000) (111)
mysql -h localhost -u root -p

select version();  # 查看版本

# 启动mysql
sudo /etc/init.d/mysql start
sudo start mysql
sudo service mysql start

# 停止mysql
sudo /etc/init.d/mysql stop
sudo stop mysql
sudo service mysql stop

systemctl restart mysql.service # 重启服务

# rpm安装
service mysqld start  #启动mysql
service mysqld stop  #关闭mysql

# 二进制和源码安装
/etc/init.d/mysqld start    #启动mysql
/etc/init.d/mysqld stop      #关闭mysql   或者是/usr/bin/mysqladmin -u root -p shutdown
/etc/init.d/mysqld restart   #重启mysql

#调试检查
mysqld --no-defaults --console  --log-error-verbosity=3 --user mysql --gtid_mode=on 
 
# 卸载mysql 
sudo apt-get remove mysql-server
sudo apt-get autoremove mysql-server
sudo apt-get remove mysql-common
sudo rm /var/lib/mysql/ -R
sudo rm /etc/mysql/ -R
sudo apt-get autoremove mysql* --purge
sudo apt-get remove apparmor
sudo apt-get update

dpkg --list|grep mysql # 查看Mysql的依赖项
sudo apt-get autoremove --purge mysql-server # 卸载 删除工作目录
sudo apt-get remove mysql-common # 删除mysql的软件包

# docker mysql 8.0.28

    host = "127.0.0.1",   #47.241.99.13
    port = 3300,
    user = "root",
    password = "fil2022",

docker ps # 当前正在运行的容器
docker exec -it (mysql的名字,或id) bash # 进入mysql容器
mysql -u root  -p # 登录mysql,输入账号密码登录 (abcd)



SELECT selfid, symbol, side, type, clientorderid, price, quantity, status, from_unixtime(floor(createtime / 1000)) as orderdatetime from FIL_testfil.orders where selfid >= 500

select id, mainID, subID, strategyID, symbol, tradeid, clientorderid, price, quantity, commission, commissionasset, tradetime, from_unixtime(floor(tradetime / 1000)) as tradedatetime, tradetype, handletime, gatetype from Trace_testtrace.trades where strategyID = 2

select id, mainID, subID, strategyID, symbol, price, quantity, from_unixtime(floor(tradetime / 1000)) as tradedatetime, tradetype from Trace_testtrace.trades where strategyID = 2

SELECT * FROM orders order by id DESC LIMIT 50;

select id, mainID, subID, strategyID, symbol, price, quantity, from_unixtime(floor(tradetime / 1000)) as tradedatetime, tradetype from Trace_testtrace.trades where strategyID = 2

SELECT id, type, `interval`,mainID, isSub, subID, threshold, value, from_unixtime(floor(time )) as datetime from FIL_risk3.riskwarnlog  where id >= 15000  order by id DESC

SELECT selfid, symbol, side, type, clientorderid, price, quantity, status, from_unixtime(floor(createtime / 1000)) as orderdatetime from FIL_risk3.orders where selfid >= 1



-- 设置mysql分隔符为//，也就意味着，当遇到下一个//时，整体执行SQL语句
DELIMITER //

DROP PROCEDURE if EXISTS 'ordersinsert';    # 如果存在ordersinsert存储过程则删除 drop procedure if exists sum1
CREATE procedure ordersinsert() # 创建无参存储过程，名称为ordersinsert
BEGIN
  DECLARE i INT;  # 申明变量
  SET i = 7;  # 变量赋值 , declare i int default 1;
  WHILE i<26 DO # 结束循环的条件: 当i大于5时跳出while循环
    INSERT INTO orders VALUES(i+1,1,2,1,"7F1675671289203I0L1",BTCUSDT,3281296899,"0.01","22000","0",LIMIT,BUY,NEW,BOTH,1675671288831+i+1,1675671288831+i+1,1,i+1,0,0,GTC);  # 往orders表添加数据
    SET i = i+1;    # 循环一次,i加1 
  END WHILE;  # 结束while循环
  SELECT * FROM orders; # 查看orders表数据
END 
//  # 结束定义语句
DELIMITER ;
CALL ordersinsert();    # 调用存储过程







```


# Codespace Env Init

1. ssh

```bash
ssh-keygen
ssh-copy-id -i /home/codespace/.ssh/id_rsa.pub root@47.241.99.13
#/root/.shh/authorized_keys (...= codespace@codespaces-db7098)
ssh -l root 47.241.99.13
ssh-copy-id -i /home/codespace/.ssh/id_rsa.pub root@8.219.68.31
ssh -l root 8.219.68.31
/home/codespace/.ssh/id_rsa

cd /root/FIL/strategy/flask/worth && . setEnv.sh
sudo sh -c "sync && echo 3 > /proc/sys/vm/drop_caches" 
netstat -lantup | grep 3306 # 查看port端口号 lsof -i:3306
ln v2/FIL_lib v2/sr_min/FIL_lib # 硬链接 复制/同源  -s 软/符号链接/快捷方式

#worth curve
cd /root/binance/crypto/strategy/worth/bak # 8.219.68.31 
. worthStart.sh 
cd /root/FIL/strategy/flask/worth # 47.241.99.13
. reportStart.sh

# download    scp -r  src  dest
scp root@47.241.99.13:/root/FIL/strategy/flask/worth_20220916A.tar.gz   /mnt/e/mi
scp -r root@8.219.68.31:/root/binancefuture/crypto/strategy  prod/8.219.68.31/binancefuture/
scp -r root@8.219.68.31:/root/binance/crypto/strategy  prod/8.219.68.31/binance/
scp -r root@47.241.99.13:/root/FIL/strategy  prod/47.241.99.13/

tar -zcvf worth_20220916A.tar.gz  worth  # 归档+打包c
tar -zxvf FileName.tar  # 解包x
zip -r myfile.zip test/ # 压缩 zip -r text.zip text -x='text/music/*' -x='text/txt1.txt' # 排除 music文件夹 与 txt1.txt 以外所有文件
unzip  myfile.zip       # 解压
ps aux | grep vscode | grep -v grep | awk '{print $2}'| xargs kill -9  # kill vscode
export PS1="\[\e[1;36m\]\u\[\e[1;30m\]@\[\e[0;37m\]\W\[\e[1;32m\]\\$\[\e[0m\]"
pkill -kill -t pts/0 # 强制踢出用户 
fuser FIL # 查看文件被占用进程 text file busy

python3 -m http.server 5555  # website 
flask run -p 5000 -h 0.0.0.0
/usr/bin/python3 /usr/local/bin/flask run
nohup python3 -u main.py -n logic -s 8808 -c 29096 -X BTCUSDT -p 30m -w 40 -I 50 -d 120 -T 0.55 -t 1000000  >> log.txt 2>&1  &

curl http://127.0.0.1:5000/worth
curl http://localhost:5000/worthpt
curl -v -X GET "https://httpbin.org/get" -H "accept: application/json"
curl -v -X POST "https://httpbin.org/post" -H "accept: application/json"
curl -X PATCH "http://httpbin.org/patch" -H "accept: application/json"
curl -X DELETE "http://httpbin.org/delete" -H "accept: application/json"
curl -X PUT "http://httpbin.org/put" -H "accept: application/json"
curl ifconfig.me # 查询IP
wget -qO- https://bin.equinox.io/amd64.tgz | tar zxvf -  

du -ach *  # 查看目录大小 du -sh ,  df -lh # 磁盘空间  
ls -lR| grep "^-" | wc -l # 统计当前目录下文件("^-")的个数(包括子目录R), 目录("^d")
find -iname "*.log" | wc -l # log文件的数量 # ll |grep "^-" |wc -l 
find . -type f -iname "*.txt" | xargs grep -inr "clearance" | grep -v grep 
# 使用()将运算式分隔, exp1 -and exp2 -a与; -not|!非 expr ; exp1 -or exp2 -o或; exp1, exp2 ; 
# -mount,-xdev 同一个文件系统 ; -ipath p,-path p 路径p ; -name name, -iname name文件名称   
# -newer abc !def 更新时间比abc新比def旧 ; -anewer abc 访问时间比abc新 ; cnewer file
# -type d目录 c字型 b区块 p具名贮列Fifo f一般 l符号连接 s套接字socket -pid n # 
# -size -n|n|+n  # -n内/小于 +n外/超过 n:本身 ; c字节/w字2字节/b块512字节/k千/M兆/G吉 
# -ctime -n|n|+n 创建天 -mtime修改天 -amin 读取分钟 ; -ok操提示 ; 
# -mindepth n 从第n级目录开始搜索; -maxdepth n 表示至多搜索到第n-1级子目录; -print 打印输出为预设 expression;  
find . -path ./test -prune -o -path ./opt -prune -o -type f # 查找当前目录下所有普通文件, 排除test/opt目录 ; -prune 仅当前目录(不包含子目录)
find . -path ./tomcat -prune -o -name "*.txt" # 单目录排除 查找txt文件，但是想要排除掉tomcat目录
find ./ \( -path "./tomcat" -o -path "./java" \) -prune -o -name "*.txt"  # 多目录排除 排除掉tomcat目录和java目录
find /home/tyrone -iname "*.txt" -exec grep -l "hello world" {} \; | xargs grep -i "mailx"
# find . > tmpfile | wc -l tmpfile # 文件数量太多
find ./ -empty -type f -print -delete  # 查找空文件并删除 ; 
find ./ -perm 664 # 查找权限为644的文件或目录 # /u+w,g+w  /u=w,g=w  -u=r ; -user lzj 所有者为lzj ; -group gname 组名为gname ; -nouser 用户ID不存在; -nogroup 组ID不存在 ; -executable \! -readable  查找有执行没可读权限 
find . -ctime +1  -exec mv {} old/ ;  # -exec rm -fv {} \; # | xargs rm -rf
find . -maxdepth 1 -mtime +1  -iname "*.log"| xargs -I '{}' mv {} old/ # 移动当前目录下1日前log文件至old/下 # ! -name "." -type d -prune  # 仅当前目录(不包含子目录)
find . -type f -size +1M  -print0 | xargs -0 du -h | sod -10  # 查看1m文件 
find /workspaces/jupyter/prod/ -type f -size +1M  -print0 | xargs  -0  rm  # 删除超过 1m 文件
find /workspaces/jupyter/prod/ . -iname *log* | xargs rm -rf # 删除log文件/目录 csv jpg
find /workspaces/jupyter/prod/ -regex '.*\.log\|.*\.csv\|.*\.jpg' | xargs rm -rf # 删除prod下 log文件/目录 csv jpg
rm -rf .git/ 
#update
scp .vimrc root@47.241.99.13:/root/

uname -a # 系统版本 lscpu , free -m , lsblk -p , cat /proc/version, lsb_release -a , lshw
sed -n '6,7p' a.txt # 查看文件a.txt的第6、7行  # sed -n '6p;260,400p;' a.txt  #  输出第6行 和 260到400行
cat a.txt | head -n 200 | tail -n +50 # 查看文件a.txt，显示第50行到第200行  或 cat a.txt | tail -n +50 | head -n 150

#win cmd vscode  
ssh-keygen  # cmd命令行中输入ssh-keygen，回车三次
C:/Users/Administrator/.ssh/id_rsa
C:/Users/Administrator/.ssh/id_rsa.pub
chmod 600 id_rsa
chmod 600 /mnt/c/Users/Administrator/.ssh/id_rsa
ssh-copy-id -i /mnt/c/Users/Administrator/.ssh/id_rsa.pub root@8.219.68.31
ssh-copy-id -i /mnt/c/Users/Administrator/.ssh/id_rsa.pub root@47.241.99.13
chmod 700 ~/.ssh
vim ~/.ssh/authorized_keys 
chmod 600 ~/.ssh/authorized_keys 

#win激活备份
# 正版通行证 gatherosstate.exe  生成 GenuineTicket.xml, 激活前放入GenuineTicket文件夹下
# C:\ProgramData\Microsoft\Windows\ClipSVC\GenuineTicket\ 重启联网自动激活, 或在系统属性立即激活

#chmod 600 id_rsa
#chmod 600 /mnt/c/Users/Administrator/.ssh/id_rsa
#win id_rsa>属性>安全 仅保留Administrator用户, 删除其他用户/权限

# https://raw.hellogithub.com/hosts
# ipconfig /flushdns

#ubuntu  
ssh-copy-id -i /mnt/c/Users/Administrator/.ssh/id_rsa.pub root@47.241.99.13
ssh-copy-id -i /mnt/c/Users/Administrator/.ssh/id_rsa.pub root@8.219.68.31
ssh-copy-id -i /mnt/c/Users/at/.ssh/id_rsa.pub root@8.219.68.31

#dest src target
chmod 700 ~/.ssh
vim ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

#vscode C:/Users/Administrator/.ssh/config
Host <别名>
HostName <主机名或ip>
User <用户名>
Port <端口>
IdentifyFile <本地私钥文件><~/.ssh/authorized_keys>

Host 8.219.68.31
  HostName 8.219.68.31
  User root
  IdentityFile "C:/Users/Administrator/.ssh/id_rsa"

Host 47.241.99.13
  HostName 47.241.99.13
  User root
  IdentityFile "C:/Users/Administrator/.ssh/id_rsa"

```


2. pip

```bash
pip install --upgrade pip
pip install pandas numpy matplotlib seaborn scipy tqdm  pymysql sqlalchemy  
 flask pandas_datareader torch pymssql EMD-signal websocket-client ccxt statsmodels  
 requests_toolbelt scikit-learn sshtunnel  pycryptodome  werkzeug  ipywidgets aligo
 jwt gevent pyts sympy mplfinance akshare yfinance tushare pyecharts --upgrade

# pip install tensorflow imbox  pydrive  backtrader twilio yagmail keyring  schedule   baostock pytdx  --upgrade
# talib FactorAnalyzer

wget -qO- http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz | tar -xzvf - 
cd ta-lib
sudo ./configure --prefix=/usr
sudo make
sudo make install
pip install Ta-Lib  --upgrade --force-reinstall

sudo apt-get update
sudo apt install python3-pip
sudo apt remove python3-pip
python3 -m pip3 install --upgrade --force-reinstall pip -i http: //mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com 
# https://pypi.tuna.tsinghua.edu.cn/simple # 清华源
# https://pypi.douban.com/simple # 豆瓣源
# http://mirrors.aliyun.com/pypi/simple/ # 阿里云
# https://pypi.mirrors.ustc.edu.cn/simple/ # 中科大
# http://pypi.hustunique.com/ # 华中理工 
# http://pypi.sdutlinux.org/ # 山东理工  
# Linux .pip/pip.conf # Win pip/pip.ini

!pip list | grep pandas 
pip show -f SomePackage
pip search SomePackage
pip uninstall pyts

pip freeze > requirements.txt
pip download -d packages -r requirements.txt  --trusted-host mirrors.cloud.aliyuncs.com
pip install *.whl
python3 -m pip install -r requirements.txt


```

3. `git`

```bash
#git版本更新流程  clone> pull> push 
sudo add-apt-repository ppa:git-core/ppa # 添加PPA仓库到系统中
sudo apt-get update # 更新同步信息
sudo apt install git  # 更新git版本

ssh-keygen -t rsa -C 'ation126@126.com' -f /root/.ssh/github_id_rsa
# 复制/root/.ssh/github_id_rsa.pub内容, 
# 粘贴到github->setting->Add SHH Key->Add new->入titile->key框

vim /root/.ssh/config
# github
Host github.com
HostName github.com
User ation126
PreferredAuthentications publickey
IdentityFile /root/.ssh/github_id_rsa

ssh-agent bash
ssh-add /root/.ssh/github_id_rsa
ssh -T git@github.com

# ubuntu github vim ~/.ssh/config  # git配置多个ssh_key
Host github.com
HostName github.com
User ation119
IdentityFile ~/.ssh/rsa

Host ation120.github.com
HostName github.com
User ation120
IdentityFile ~/.ssh/id_rsa_120

Host ation123.github.com
HostName github.com
User ation123
IdentityFile ~/.ssh/id_rsa_123


# Host github.com           # git clone git@github.com:ation119/jupyter.git
# Host ation120.github.com  # git clone git@ation120.github.com:ation120/jupyter.git

git clone git@github.com:ation119/jupyter.git
git clone git@ation120.github.com:ation120/jupyter.git

git clone git@github.com:ation126/ation126.github.io.git
cd ${curDir}/page/ation126.github.io
#git config --global credential.helper store
git config --local user.email "ation126@126.com" # global local 
git config --local user.name "ation126@126.com" # ation126
#git config --local user.password "pwd"

# git remote set-url origin https://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@github.com/ation122/jupyter.git 

echo `date -d '+8 hour' '+%Y-%m-%d %H:%M:%S'` >> /workspaces/jupyter/tmp/test.log 2>&1 
git add .   
git commit -m "`date -d '+8 hour' '+%Y-%m-%d %H:%M:%S'`"  
sudo git pull --rebase origin main  # master > main
sudo git push -u origin main   >> /workspaces/jupyter/tmp/test.log 2>&1 


# create a new repository on the command line
echo "# Algo start" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M master
git remote add origin  https://github.com/ation119/jupyter.git # https://github.com/ation126/Algo.git  
git push -u origin master

# push an existing repository from the command line. Static Resource > wget Raw  
git remote add origin https://github.com/ation126/Algo.git
git branch -M master

# 删除git文件历史记录
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')"

git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch *(路径)/**(文件名).*' --prune-empty --tag-name-filter cat -- --all # 历史记录缓存中删除
git rm --cached folder -r # 删除文件夹
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch sound/Music_*.mp3' --prune-empty --tag-name-filter cat -- --all

rm -rf .git/refs/original/ # 删除历史文件备份
git reflog expire --expire=now --all # 放弃历史找回
git gc --aggressive --prune=now  # 清空悬空对象
git status # 即将提交
git push origin master --force --tags --all # 强制覆盖更新远端仓库
git remote prune origin # 让远程仓库变小


# 清除git历史记录, 登录管理员账户
# git checkout --orphan new
# git push
# 设置默认分支为new
# 删除原来的main分支
# new重命名为main
# git clone

```

4. crontab

```shell
sudo vim /etc/apt/sources.list
    deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse
sudo apt-get update
sudo apt-get install sysv-rc-conf # 0停机 1单用户/维护 2~5多用户 6重启 s开机 
sudo apt install cron 

sudo sysv-rc-conf --list cron 
sudo service cron start	# start  stop reload restart status

crontab -e   # ①分钟(0-59) | ②小时(0-23) | ③号(1-31) | ④月(1-12) | ⑤星期几 (0-6 星期天0)
* 7,11,14,17,20,23 * * * sudo /bin/bash -c "sync && echo 3 > /proc/sys/vm/drop_caches"

11 0,12 * * * /usr/bin/python3 /root/FIL_test/trace/worth/worth.py >> /root/FIL_test/trace/worth/worth.log
11 0,12 * * * /usr/bin/python3 /root/FIL/strategy/worth/worth2.py >> /root/FIL/strategy/worth/worth.log
35 6,23 * * * /root/similarity/similarityStart.sh
32 7,0 * * * /root/similarity/similarityStop.sh
#35 6,23 * * * /root/FIL/strategy/similarity/similarityStart.sh
#32 7,0 * * * /root/FIL/strategy/similarity/similarityStop.sh
* 7,15,23 * * * sync; echo 1 > /proc/sys/vm/drop_caches
#*/5 * * * * COLUMNS=9999 /usr/bin/top -c -d 30  -n 2 -b  | sed 's/  *$//' >> /root/FIL/strategy/multiple/top.log

0 0,7 * * * /root/binancefuture/crypto/strategy/similarity/similarityStart.sh
*/5 * * * * sh /workspaces/jupyter/settings/gitTimer.sh 

```

5. install lua5.4.4

中断 <kbd>Ctrl</kbd>+<kbd>C</kbd> 　换行`<br>`　空格全角`　&thinsp; &nbsp; &ensp; &emsp;`

    wget http://www.lua.org/ftp/lua-5.4.4.tar.gz
    sudo mkdir /usr/local/lua
    sudo tar -zxvf lua-5.4.4.tar.gz -C /usr/local/lua/
    cd /usr/local/lua/lua-5.4.4/
    sudo make linux test
    sudo make install

6. wechat

```
    AgentId:1000002 , Secret:lbjGCu1aNPJafrahotkvOrqrL-m7NfYehPisHMnthro
    企业简称:弓长投资, 企业ID:ww9ca2ccd8f391f581
    https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=ww9ca2ccd8f391f581&corpsecret=lbjGCu1aNPJafrahotkvOrqrL-m7NfYehPisHMnthro
    {"errcode":0,"errmsg":"ok","access_token":"UlLSpm5RUmstQX5Jj7qohbdEB2KE6dPSWyp_30UrAfQOovCZbvJp1zl1fJOXIAudzar5cu3A7dnqXiFr4DBqrYV5-c2dxzkGqQ-KNirJ3jUoqdjAYqdDajp60XiYC6hj2-GBFAqDnIuKQC2tRnZfM3PE1-EulZnEahnMcTd0o8P20MIMCqwNS3s9E4mXgcjIhYQowYO2Hx_T5HNNTXoHnw","expires_in":7200}
    token:'CZPj1Ew2UhnMDqz9msaqiXShICfDqZ9p35bcS0D3gXLlxwELCO9U7ODCQPBCJpBxlN2z5SKS1HgKv53N9cLGLR4zEh1omnGrAIDgmrjvXpc42t_hJMV6CiQ6nm5bmJ2kUx5JxiufyfBswmwcaPiymC6z8HnHC4w8yT0kHC3Ikalzyy71XJZscnpkv2pYDj_Mcnb5X1UwL5B7qzMdmJcbeQ'
    https://work.weixin.qq.com/wework_admin/material/getOpenMsgBuf?type=image&  media_id=2ogNvJn_5j-bu5Bpv3FeVKd1Ut6ytNDAMUE27s8IFpWElebuw3gG7g2pxmA4KLjy_&file_name=image.jpg
```

7. codespaces rsync 126,120:Sq6 ; 119,121,122,123,124,125,127,128,129,130,131,163 :Pai@6 ;

```shell  
# ssh id_rsa.pub
ssh-keygen
ssh-copy-id -i /home/codespace/.ssh/id_rsa.pub root@47.241.99.13
# /root/.shh/authorized_keys (...= codespace@codespaces-db7098)
ssh -l root 47.241.99.13 # Etlink@yar  fil2022 
ssh-copy-id -i /home/codespace/.ssh/id_rsa.pub root@8.219.68.31
ssh -l root 8.219.68.31  # hwr@20220924 reaL2022

# rsync -av scr dest 
rsync -av /root/FIL/fil root@8.219.68.31:/root/binancefuture/crypto/
rsync -av /root/FIL/uat root@8.219.68.31:/root/binancefuture/crypto/

rsync -av /root/FIL/fil/FIL root@8.219.68.31:/root/binancefuture/crypto/fil/
rsync -av config.json risk.json killFIL.sh startFIL.sh root@8.219.68.31:/root/binancefuture/crypto/fil/
rsync -av /root/FIL/v5/similarity root@8.219.68.31:/root/binancefuture/crypto/strategy/

rsync -av /root/binancefuture/crypto/logs/screenlog_Fil_bash_0.log root@47.241.99.13:/root/FIL/logs/screenlog_Fil_bash_1_20230221B.log

scp root@47.241.99.13:/root/FIL/fil/FIL ./
scp root@8.219.68.31:/root/binance/crypto/strategy/worth/templates/worth.html ./

# synchronize    
rsync -av root@8.219.68.31:/root/binancefuture/crypto/strategy  /workspaces/jupyter/prod/8.219.68.31/binancefuture/
rsync -av root@8.219.68.31:/root/binance/crypto/strategy  /workspaces/jupyter/prod/8.219.68.31/binance/
rsync -av root@8.219.68.31:/home/admin/send_email_similarity  /workspaces/jupyter/prod/8.219.68.31/
rsync -av root@47.241.99.13:/root/FIL/strategy --exclude flask/worth/page/.git/ /workspaces/jupyter/prod/47.241.99.13/
rsync -av root@47.241.99.13:/root/FIL/uat  /workspaces/jupyter/prod/47.241.99.13/

find /workspaces/jupyter/prod/ -type f -size +1M  -print0 | xargs  -0  rm  # 删除超过 1m 文件
find /workspaces/jupyter/prod/ -path /workspaces/jupyter/prod/47.241.99.13/strategy/logic -prune -o -regex '.*\.log\|.*\.csv\|.*\.jpg\|.*log.*\.txt' -print | xargs rm -rf # 删除prod下 log文件/目录 csv jpg 排除logic目录
find /workspaces/jupyter/prod/47.241.99.13/uat/ -regex '.*\.log\|.*\.csv\|.*\.jpg\|.*\.pkl\|.*\.db\|.*\.ipynb' -print | xargs rm -rf

# archive
ssh -l root 8.219.68.31
cd /root/tmp/codespaces
rm -rf jupyter/
rsync -av /workspaces/jupyter --exclude .git/ root@8.219.68.31:/root/tmp/codespaces
du -sh # 144M

# recovery
sudo apt-get update
rsync -av root@8.219.68.31:/root/tmp/codespaces/jupyter --exclude .git/ /workspaces/
pip install --upgrade pip
python3 -m pip install -r settings/requirements.txt
cp /workspaces/jupyter/.vimrc ~/
sudo apt-get update

# gh codespace
conda install gh --channel conda-forge
conda update  gh --channel conda-forge
gh auth login
gh auth refresh -h github.com -s codespace
gh cs ssh -c ation121-special-space-potato-qrv45jpv7gj3xpvp
gh codespace stop -c ation121-special-space-potato-qrv45jpv7gj3xpvp
gh codespace cp -r remote:/workspaces/jupyter/ /Users/AT/tmp
```

8. win ngrok

```shell  
# win OpenSSH服务器
#win设置>应用>可选功能>添加功能>Openssh服务器/客户端>安装
#win服务services.msc sshd>OpenSSH SSH Server / OpenSSH Authentication Agent 自动启动
sc config sshd start= auto
net start sshd
net stop sshd
netstat -an | findstr ":22"

# win设置>更新和安全>安全中心>防火墙和网络保护>高级安全>入站规则22端口TCP特定本地 
ssh localhost # 查看本地ssh服务

# 客户端生成密钥 ssh-keygen
# 管理员:   C:\ProgramData\ssh  echo id_rsa.pub 的内容 >> administrators_authorized_keys
# 普通用户: C:\Users\用户名\.ssh echo id_rsa.pub 的内容 >> authorized_keys

# 修改sshd_config启用密钥登录, 服务端 C:\ProgramData\ssh\sshd_config
PubkeyAuthentication yes
PasswordAuthentication yes

scp ~/Desktop/sshd_config 用户名@地址

# ssh 客户端: 添加~/.ssh/config文件 心跳机制
ServerAliveInterval 60
ServerAliveCountMax 10

# sshd 服务端修改配置文件/etc/ssh/sshd_config 心跳机制
ServerAliveInterval 60
ServerAliveCountMax 10

# ngrok 反向代理    
cd tmp   # ation126  https://dashboard.ngrok.com/get-started/setup  
wget -qO- https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz | tar zxvf -  
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz   
tar -zxvf ngrok-v3-stable-linux-amd64.tgz   
ngrok config add-authtoken 2DA1ur90IFUef5dFJq9gCo0Su0W_7gdHQpB9r2XVc1MFsk3e9  
ngrok http 80  
curl -s i996.me | bash -s 79962914  

# SakuraLauncher.exe
www.natfrp.com
https://openid.13a.com/user
ation126 
NyatID 794123
ation126@126.com
# 访问密钥 5tgezl864rdq1lfuzwi1m8fyu4e7nuai

cat /home/codespace/.ssh/id_rsa.pub
ssh at@jp-tyo-ntt-1.natfrp.cloud -p 63437

#  i996.me  https/tcp/h2/h3/http/websocket/ssh/ftp/smtp
curl -s i996.me | bash -s 79962914      # Mac/Linux
curl -s v2.i996.me | bash -s 79962914   # Mac/Linux
curl -s win.i996.me/79962914 | cmd      # Windows自带终端
curl -s i996.me | bash -s 79962914      # Windows wsl/linux
curl -s v2.i996.me | bash -s 79962914   # Windows wsl/linux
curl -s v2.i996.me | bash -s 79962914   # Windows git-bash

```  

9. apt-get  sources.list

```shell  
sudo su     # root exit su ation121
sudo apt-get update | sudo apt-get upgrade  # 更新源
sudo apt install python3-pip # 安装
sudo apt remove python3-pip # 卸载  可能删除不完全
sudo add-apt-repository ppa:git-core/ppa
sudo apt install git
sudo apt-get install sysv-rc-conf
sudo apt install cron 
sudo apt-get install ttf-mscorefonts-installer 

sudo apt-get install ubuntu-desktop  # 例如：安装desktop软件，注意软件名称一定是正确的
sudo apt-cache search desktop # 例如：查询桌面desktop,如果出来内容太多 可以在desktop前加ubuntu-
sudo apt-get remove   # 卸载  可能删除不完全，用下面的删除命令，才会彻底删掉
sudo apt-get purge    # 删除  彻底删除
sudo apt-get update   # 更新
sudo apt-get upgrade  # 升级
sudo dpkg -l | grep ubuntu-desktop  # 例如：查询已经安装的桌面软件，|grep是过滤，因为我们可能记不全软件的名字
sudo reboot   # 重启


sources.list
/etc/apt/sources.list
/etc/apt/sources.list.d
sudo cp sources.list sources.list.bak
sudo mv sources.list.custom sources.list

sudo sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list  # 官方源换阿里云源
sudo sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list # 清华源
sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list # 中科大源
sudo sed -i 's/mirrors.aliyun.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list # 阿里云换清华源

sudo apt-get update
sudo apt-get upgrade

deb URI section1 section2
deb http://us.archive.ubuntu.com/ubuntu/ trusty universe
apt-get install
dpkg -i xxx.deb
sudo apt-get update 

# tsinghua 
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse
 
#aliyun
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
 
 
#中科大源
deb https://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu focal stable
# deb-src [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu focal stable

```  

10. anaconda

```shell 
wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
bash Anaconda3-2021.05-Linux-x86_64.sh

wget --continue https//repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh

scp /mnt/c/users/at/downloads/Anaconda3-2022.10-Linux-x86_64.sh  /home/at/pkg/
bash anaconda3.sh

sudo vim ~/.bashrc
export PATH=[your path to anaconda]/anaconda3/bin:$PATH
export PATH=/home/at/anaconda3/bin:$PATH
source ~/.bashrc

echo 'export PATH="/home/fjyy/anaconda3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

conda create --name pytorch python=3.9 # 创建python环境
conda create -n tensorflow python=3  # 建立一个名为tensorflow的虚拟环境
conda activate pytorch # 进入自创建环境 
conda activate tensorflow  # 激活虚拟环境
conda deactivate #退出虚拟环境
conda info --envs
conda upgrade --all  # 工具包升级
conda remove -n tensorflow --all   # 删除虚拟环境
conda list   # 查看安装的包 查看环境内容
conda install urllib3  # 安装包
conda install scrapy==1.3  #安装指定版本的包
conda install -n tensorflow scrapy #在tensorflow环境安装scrapy包
conda remove urllib3 # 删除包
conda env list # 查看当前存在的虚拟环境
conda create -n tensor222 --clone tensorflow # conda环境克隆  
conda create -n BBB --clone ~/path # 跨计算机克隆
conda env export > environment.yaml   # 共享环境 保存为yaml文件
conda env create -f environment.yaml # 只能安装原来环境中用conda install等命令直接安装的包，不包括pip安装的包。
pip freeze > requirements.txt   # 把pip安装的导出到requirements.txt
pip install -r requirements.txt

conda install pandas numpy matplotlib seaborn scipy tqdm pymysql sqlalchemy flask pymssql  websocket-client statsmodels scikit-learn sshtunnel  pycryptodome werkzeug ipywidgets gevent sympy    

conda install xeus-cling -c conda-forg  # 在jupyter中配置c++内核 jupyter notebook c++
jupyter kernelspec list # 

python3 -m pip install EMD-signal akshare pandas_datareader torch requests_toolbelt mplfinance pyts pyecharts ccxt tushare aligo yfinance jwt   --upgrade




```  

11. aliyunpan upload download help

```shell 
aliyunpan  
login -RefreshToken=485d87d2f8404cca8fba1fa8d96246ee   # login -QrCode
# u /workspaces/jupyter/ /backup/`date -d '+8 hour' '+%Y%m%d'`/ -exn "^.git$"  # 

cd /workspaces
zip -r jupyter_`date -d '+8 hour' '+%Y%m%d'`.zip jupyter -x='jupyter/.git/*'  # unzip jupyter_`date -d '+8 hour' '+%Y%m%d'`.zip  # '+%Y-%m-%d %H:%M:%S'
aliyunpan u /workspaces/jupyter_`date -d '+8 hour' '+%Y%m%d'`.zip /backup/`date -d '+8 hour' '+%Y%m%d'`/
aliyunpan d /backup/`date -d '+8 hour' '+%Y%m%d'`/jupyter_`date -d '+8 hour' '+%Y%m%d'`.zip --saveto /workspaces/


# aliyunpan https://github.com/tickstep/aliyunpan#%E5%9F%BA%E6%9C%AC%E4%BD%BF%E7%94%A8
sudo curl -fsSL http://file.tickstep.com/apt/pgp | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/tickstep-packages-archive-keyring.gpg > /dev/null && echo "deb [signed-by=/etc/apt/trusted.gpg.d/tickstep-packages-archive-keyring.gpg arch=amd64,arm64] http://file.tickstep.com/apt aliyunpan main" | sudo tee /etc/apt/sources.list.d/tickstep-aliyunpan.list > /dev/null && sudo apt-get update && sudo apt-get install -y aliyunpan

wget https://github.com/tickstep/aliyunpan/releases/download/v0.2.3/aliyunpan-v0.2.3-linux-amd64.zip
unzip aliyunpan-v0.2.3-linux-amd64.zip
cd aliyunpan-v0.2.3-linux-amd64
./aliyunpan


help  
export ALIYUNPAN_CONFIG_DIR=/workspaces/jupyter/settings/aliyunpan/config # 配置文件路径  
login -RefreshToken=485d87d2f8404cca8fba1fa8d96246ee  
login -QrCode # 二维码登录   
loglist , who , su <uid> , logout , quota 配额, locate 直链, rapidupload 秒传, share l cancel mc 分享,      
aliyunpan token update -mode 2
drive <driveId>  切换网盘
ls cd pwd rm mkdir pwd mv rename export import sync   

download|d <网盘文件或目录的路径1> <文件或目录2> <文件或目录3> ...
  --ow            overwrite, 覆盖已存在的文件
  --status        输出所有线程的工作状态
  --save          将下载的文件直接保存到当前工作目录
  --saveto value  将下载的文件直接保存到指定的目录
  -x              为文件加上执行权限, (windows系统无效)
  -p value        指定下载线程数 (default: 0)
  -l value        指定同时进行下载文件的数量 (default: 0)
  --retry value   下载失败最大重试次数 (default: 3)
  --nocheck       下载文件完成后不校验文件
  --exn value     指定排除的文件夹或者文件的名称，只支持正则表达式。支持排除多个名称，每一个名称就是一个exn参数, -exn "^@eadir$", 
d Settings/tv.txt
d /backup/20221206/ /workspaces/jupyter/ -exn "^.git$"

aliyunpan upload|u <本地文件/目录的路径1> <文件/目录2> <文件/目录3> ... <目标目录>
u /workspaces/jupyter/tmp/t1.py /Settings/
u /workspaces/jupyter/ /backup/20221206/ -exn "^.git$"

aliyunpan config set -savedir <savedir> # 自定义保存的目录
aliyunpan config set -savedir /workspaces/jupyter/tmp

./aliyunpan sync start -ldir "/tickstep/Documents/设计文档" -pdir "/备份盘/我的文档" -mode "upload"
# upload(备份本地文件到云盘),download(备份云盘文件到本地),sync(双向同步备份)

# jupyter sync
aliyunpan sync start -dp 1 -up 10 -ldir "/workspaces/jupyter/" -pdir "/backup/jupyter" -mode "upload"

nohup /workspaces/jupyter/settings/aliyunpan/sync.sh >/dev/null 2>&1 &

```  

