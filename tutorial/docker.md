
# Docker教程
事先说明, 本教程使用的是Mac版docker桌面版, 命令执行都是在Mac终端实现, 不管什么平台, 命令, 操作都是一样的

1.docker version   #查看docker的版本
2.docker info   #查看docker的详细信息
3.docker images   #查看本地所有镜像
4.docker images nginx   #查看本地与nginx的相关的镜像
5.docker ps -a   #查看当前所有容器的状态（包括没有运行的）
6.docker ps   #查看当前正在运行的容器的状态
7.docker stop vm1   #停止容器vm1(容器vm1存在,并运行)
8.docker start vm1   #启动容器vm1(容器vm1存在,但没有运行)
9.docker kill vm1   #强制干掉容器vm1(容器vm1存在,并运行)
10.docker attach vm1   #连接容器vm1(当容器vm1正在运行,要再次连接时,使用该命令)
11.docker diff vm1   #查看容器vm1的修改(A – Add;D – Delete;C – Change)
12.docker top vm1   #查看容器vm1的进程
13.docker stats vm1   #查看容器vm1的资源使用率
14.docker pause/unpause vm1   #暂停/恢复容器vm1(但是docker ps中显示仍在运行状态)
15.docker cp index.html vm1:/usr/share/nginx/html   #同docker container cp index.html vm1:/usr/share/nginx/html。拷贝index.html文件到nginx创建的容器vm1的默认发布目录(/usr/share/nginx/html)下。在"Linux下docker应用初体验之nginx，ubuntu，rhel7镜像的使用"文章中使用过。
16.docker logs vm1   #查看容器vm1的日志(即在容器vm1中的所有操作)
17.docker port vm1   #查看容器vm1的端口映射情况(容器vm1正在运行)
18.docker network ls   #列出当前有哪些网络类型
19.docker volume ls   #列出当前有哪些数据卷
20.docker build -t rhel7:apache .   #使用当前目录下Dockerfile文件创建镜像rhel7:apache
21.docker tag rhel7:nginx4 localhost:5000/rhel7:nginx4   #相当于将rhel7:nginx4镜像复制一份出来,名字为localhost:5000/rhel7:nginx4
22.docker login xin.org   #登录xin.org
23.docker logout xin.org  #退出xin.org
23.docker run -d --name vm1 ubuntu   #使用镜像ubuntu创建容器vm1,并运行。(-d表示后台运行容器,并返回容器ID)
24.docker run -it --name vm1 ubuntu   #使用镜像ubuntu创建容器vm1,并运行,并进入交互界面。
25.docker run -it --name vm1 rhel7 bash   #使用镜像rhel7创建容器vm1,并与其进行bash交互;(-i:以交互模式运行容器,通常与-t一起使用;-t:为容器重新分配一个伪输入终端)
26.docker run -d --name vm1 -v /tmp/docker:/usr/share/nginx/html nginx   #使用镜像nginx创建容器vm1,并运行,并将本地主机的/tmp/docker目录挂载到容器vm1内的/usr/share/nginx/html目录下。(即本地主机/tmp/docker目录下有什么内容,那容器vm1的/usr/share/nginx/html目录中就有什么内容)。在"Linux下docker应用初体验之nginx，ubuntu，rhel7镜像的使用"文章中使用过。
27.docker exec -it vm1 /bin/bash   #进入容器vm1的bash界面(此时容器vm1正在运行)
 28.docker run --rm busybox:v1   #用busybox:v1镜像创建容器,并运行,运行完成之后,立即删除
29.docker run -it --rm ubuntu   #用ubuntu镜像创建容器,并运行,运行完成之后,立即删除
30.docker commit vm1 ubuntu:v1   #将容器vm1打包生成ubuntu:v1镜像
31.docker inspect vm1   #查看容器vm1的详情
32.docker inspect nginx   #查看镜像vm1的详情
33.docker rmi nginx   #删除nginx镜像
34.docker rm vm1   #删除容器vm1
#当容器正在运行时,使用该命令回报错。应该先docker stop vm1停止vm1容器,再docker rm vm1删除容器vm1。当然,也可以使用docker rm -f vm1强制删除正在运行的容器vm1。
#即docker rm -f vm1相当于docker stop vm1 + docker rm vm1。
35.docker history nginx   #查看nginx镜像的历史
36.docker load -i ubuntu.tar   #导入ubuntu.tar,以添加镜像ubuntu
37.docker import vm1.tar image   #导入容器vm1.tar为镜像image
38.docker save ubuntu > ubuntu.tar   #导出镜像ubuntu
39.docker export vm1 > vm1.tar   #导出容器vm1
40.docker search  镜像名的一部分   #查找镜像（如:docker search nginx  #查找与nginx相关的镜像）
41.docker pull 镜像名  #拉取镜像
42.docker push 镜像名  #推送镜像
43.docker container ls   #同docker ps,查看正在运行的容器
44.docker container prune    #删除所有运行停止的容器
45.docker rm -f `docker ps -aq`   #删除所有容器(运行的和没运行的)
46.docker attach vm1 #进入已经创建好的容器
47.docker diff vm5 #使用docker diff命令查看容器vm5的修改信息
48.docker container prune  #清理停止状态的容器的可写层

安装软件bash-*可以解决docker命令补不全的问题
yum install bash-* -y  
退出bash的两种操作
Ctrl + d 退出并停止容器
Ctrl + p + q 退出并在后台运行容器；   

## Docker安装
镜像(image):
docker镜像就好比是一个模板, 就可以通过这个模板来创建容器服务, nginx镜像 ==>run ==> nginx01容器(提供服务器), 通过这个镜像就可以创建多个容器(最终服务运行或者项目运行就是在容器中的)
容器(Container):
Docker利用容器技术, 独立运行一个或一个组应用, 通过镜像来创建的. 
启动, 停止, 删除, 基本命令
目前就可以把这个容器理解为就是一个易简的Linux系统
仓库(repository):
仓库就是存放镜像的地方. 
仓库分为公有仓库和私有仓库
Docker Hub(默认是国外的)
阿里云, 华为云等都有容器服务器(配置镜像加速器)

## 安装并配置国内镜像
具体如何安装到官方下载即可, 我这里使用的是Mac 的桌面版
下载Docker
https://docs.docker.com/get-docker/
配置国内镜像
这里我以桌面版举例
查看当前 Docker 的 Registry 和 Registry Mirrors
192:~ kevin$ docker info | grep Registry
 Registry: https://index.docker.io/v1/
从上面的信息来看基本上就是 docker 的官方默认配置, 美国 docker 地址, 使用 nslookup 查询
192:~ kevin$ nslookup index.docker.io
Server:		192.168.1.1
Address:	192.168.1.1#53

Non-authoritative answer:
index.docker.io	canonical name = elb-io.us-east-1.aws.dckr.io.
elb-io.us-east-1.aws.dckr.io	canonical name = us-east-1-elbio-rm5bon1qaeo4-623296237.us-east-1.elb.amazonaws.com.
Name:	us-east-1-elbio-rm5bon1qaeo4-623296237.us-east-1.elb.amazonaws.com
Address: 34.204.125.5
Name:	us-east-1-elbio-rm5bon1qaeo4-623296237.us-east-1.elb.amazonaws.com
Address: 34.200.7.11
Name:	us-east-1-elbio-rm5bon1qaeo4-623296237.us-east-1.elb.amazonaws.com
Address: 34.192.114.9
Name:	us-east-1-elbio-rm5bon1qaeo4-623296237.us-east-1.elb.amazonaws.com
Address: 3.220.75.233
Name:	us-east-1-elbio-rm5bon1qaeo4-623296237.us-east-1.elb.amazonaws.com
Address: 52.6.170.51
Name:	us-east-1-elbio-rm5bon1qaeo4-623296237.us-east-1.elb.amazonaws.com
Address: 52.55.43.248
从 nslookup 返回可以看到 docker 使用的是 aws 的服务, 而从域名上也能看出来服务器则位于美国东部. 
配置 Registry Mirrors
配置路径:Preferences -> Docker Engine. 添加如下配置, 上面是 docker 官方国内源, 下方为中科大国内 docker 镜像源

"registry-mirrors": [
    "https://registry.docker-cn.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
点击 "Apply & Restart" 并等待重启完成
注:这里的 registry-mirrors 是一个集合, 也就是一个数组, 所以我们可以设置多个 registry-mirrors, Docker 会轮询并使用列表中的 registry-mirrors. 
验证配置
在终端执行如下命令, 可以看到 Registry Mirrors 已经生效
192:~ kevin$ docker info | grep -C 5 "Registry"
 ID: 33MU:ROG2:CH5V:SSE3:5PMU:5KXJ:C6PM:SAES:NDMH:PUV4:QGFR:JYO5
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 HTTP Proxy: gateway.docker.internal:3128
 HTTPS Proxy: gateway.docker.internal:3129
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8--
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Registry Mirrors:
  https://registry.docker-cn.com/
  https://docker.mirrors.ustc.edu.cn/
 Live Restore Enabled: false
附录
Docker Daemon 配置的官方文档如下, 可参考:
https://docs.docker.com/engine/reference/commandline/dockerd/
常用的几个国内源
Docker 官方中国仓库:https://registry.docker-cn.com
中科大 USTC: https://docker.mirrors.ustc.edu.cn
网易 163 镜像:http://hub-mirror.c.163.com

## Run流程和Docker原理
Run运行流程

底层原理
Docker是怎么工作的?
Docker是一个Client-Server结构的系统, Docker的守护进程运行在主机上, 通过Socket从客户端访问
DocketServer接受到Docker-Client的指令, 就会执行这个命令

Docker为什么比VM快?
1, Docker有着比虚拟机更少的抽象层
2, docker利用的是宿主机的内核, vm需要Guest OS

所以, 新加一个容器的时候, docker不需要像虚拟机一样重新加载一个操作系统内核, 避免引导, 虚拟机是加在Guest OS, 分钟级别;而docker是利用宿主机的操作系统, 省略了这个复杂的过程, 秒级. 

## Docker常用命令
### 帮助命令
docker version  #查看docker的版本信息
docker info  #显示docker的系统信息, 包括镜像和容器的数量
docker 命令 --help    #帮助命令
帮助文档地址:https://docs.docker.com/reference/

### 镜像命令
docker images 查看所有本地的主机上的镜像
192:~ kevin$ docker images
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
hello-world         latest    bf756fb1ae65   14 months ago   13.3kB
#解释
REPOSITORY      镜像的仓库源    
TAG       			镜像的标签
IMAGE ID       	镜像的ID
CREATED         镜像的创建时间
SIZE						镜像的大小
#可选项
  -a, --all             # 列出所有镜像
  -q, --quiet           # 只显示镜像的ID
docker search 搜索镜像
192:~ kevin$ docker search mysql
NAME                              DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
mysql                             MySQL is a widely used, open-source relation…   10560     [OK]       
mariadb                           MariaDB Server is a high performing open sou…   3942      [OK]  

#可选项,通过收藏来过滤--filter=STARS=3000		# 搜索出来的镜像是STARS大于3000的

192:~ kevin$ docker search mysql --filter=STARS=3000
NAME      DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
mysql     MySQL is a widely used, open-source relation…   10560     [OK]       
mariadb   MariaDB Server is a high performing open sou…   3942      [OK] 
docker pull 下载镜像
#下载镜像 docker pull 镜像名[:tag]
192:~ kevin$ docker pull mysqlUsing default tag: latest		# 如果不指定tag版本号, 默认就是下载最新版本
latest: Pulling from library/mysql
a076a628af6f: Pull complete 	# 分层瞎子啊, docker 镜像的核心  涉及到联合文件
f6c208f3f991: Pull complete 
88a9455a9165: Pull complete 
406c9b8427c6: Pull complete 
7c88599c0b25: Pull complete 
25b5c6debdaf: Pull complete 
43a5816f1617: Pull complete 
1a8c919e89bf: Pull complete 
9f3cf4bd1a07: Pull complete 
80539cea118d: Pull complete 
201b3cad54ce: Pull complete 
944ba37e1c06: Pull complete 
Digest: sha256:feada149cb8ff54eade1336da7c1d080c4a1c7ed82b5e320efb5beebed85ae8c		# 签名
Status: Downloaded newer image for mysql:latest
docker.io/library/mysql:latest	# 镜像的真实地址
#下面的两个命令是等价的
docker pull mysql
docker pull docker.io/library/mysql:latest
#指定版本下载	
192:~ kevin$ docker pull mysql:5.7
5.7: Pulling from library/mysql
a076a628af6f: Already exists 	# 这里就可以看出来, 上面下载的mysql的部分文件是公用的, 所以在这里就不需要再次下载了, 这里就
f6c208f3f991: Already exists 	# 是使用到了Linux的联合文件下载技术
88a9455a9165: Already exists 
406c9b8427c6: Already exists 
7c88599c0b25: Already exists 
25b5c6debdaf: Already exists 
43a5816f1617: Already exists 
1831ac1245f4: Pull complete 
37677b8c1f79: Pull complete 
27e4ac3b0f6e: Pull complete 
7227baa8c445: Pull complete 
Digest: sha256:b3d1eff023f698cd433695c9506171f0d08a8f92a0c8063c1a4d9db9a55808df
Status: Downloaded newer image for mysql:5.7
docker.io/library/mysql:5.7
#查看镜像信息
192:~ kevin$ docker images
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
mysql               5.7       a70d36bc331a   6 weeks ago     449MB
mysql               latest    c8562eaf9d81   6 weeks ago     546MB
hello-world         latest    bf756fb1ae65   14 months ago   13.3kB
注意:
指定版本下载, 其中的版本一定要是docker镜像中存在的版本, 可以到官网查看镜像的版本信息
https://hub.docker.com/search?q=&type=image
docker rmi 删除镜像
192:~ kevin$ docker rmi -f 镜像Id	# 删除指定的容器, 这里可以使用镜像Id, 也可以使用镜像名称
Untagged: mysql:5.7
Untagged: mysql@sha256:b3d1eff023f698cd433695c9506171f0d08a8f92a0c8063c1a4d9db9a55808df
Deleted: sha256:a70d36bc331a13d297f882d3d63137d24b804f29fa67158c40ad91d5050c39c5	# 这里只删除了一部分, 公共部分是
Deleted: sha256:50c77bf7bcddd1f1d97789d80ac2404eec22c860c104e858620d2a2e321f0ef7	# 没有删除的
Deleted: sha256:14244329b83dfc8982398ee4104a548385652d2bffb957798ff86a419013efd6
Deleted: sha256:6d990477f90af28473eb601a9bca22253f6381e053c5a8edda0a4f027e124a3c
Deleted: sha256:ee0449796df204071589162fc16f8d65586312a40c68d1ba156c93c56f5e5ce8

docker rmi -f 镜像Id 镜像Id 镜像Id	# 删除多个镜像

kevin$ docker rmi -f $(docker images -aq)		# 删除全部的镜像 $(docker images -aq)是查询所有的镜像id 然后递归删除
Untagged: mysql:latest
Untagged: mysql@sha256:feada149cb8ff54eade1336da7c1d080c4a1c7ed82b5e320efb5beebed85ae8c
Deleted: sha256:c8562eaf9d81c779cbfc318d6e01b8e6f86907f1d41233268a2ed83b2f34e748
Deleted: sha256:1b649b85960473808c6b812fc30c3f6a3ff1c0ffdcba5c9435daf01cf7d5373a
Deleted: sha256:19cc889447050c16c797fd209fa114ee219de23facb37c00d4137a4ed4aad922
Deleted: sha256:3c793c06a026d276cf56a6a6a75527026ed9eafa7a7d21a438f7d5ed2314148e
Deleted: sha256:1e1cd89a2bc183a7fea3dab0b543e9924278321ad0921c22cc088adbf3c2e77b
Deleted: sha256:83b2015dfd000588c7c947b2d89b3be7a8e5a3abc6ab562668c358033aa779ec
Deleted: sha256:d08533f1e2acc40ad561a46fc6a76b54c739e6b24f077c183c5709e0a6885312
Deleted: sha256:4f9d91a4728e833d1062fb65a792f06e22e425f63824f260c8b5a64b776ddc38
Deleted: sha256:20bf4c759d1b0d0e6286d2145453af4e0e1b7ba3d4efa3b8bce46817ad4109de
Deleted: sha256:a9371bbdf16ac95cc72555c6ad42f79b9f03a82d964fe89d52bdc5f335a5f42a
Deleted: sha256:5b02130e449d94f51e8ff6e5f7d24802246198749ed9eb064631e63833cd8f1d
Deleted: sha256:ab74465b38bc1acb16c23091df32c5b7033ed55783386cb57acae8efff9f4b37
Deleted: sha256:cb42413394c4059335228c137fe884ff3ab8946a014014309676c25e3ac86864

192:~ kevin$ docker images	# 镜像已全部删除
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
### 容器命令
说明:有了镜像才可以创建容器, 这里下载一个centos镜像来测试学习
192:~ kevin$ docker pull centosUsing default tag: latest
latest: Pulling from library/centos
7a0437f04f83: Pull complete 
Digest: sha256:5528e8b1b1719d34604c87e11dcd1c0a20bedf46e83b5632cdeac91b8c04efc1
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest
新建容器并启动
docker run [可选参数] image
#参数说明--name="Name"		# 容器名字	nginx01  nginx02   用于区分容器-d							# 以后台方式运行-it							# 使用交互方式运行, 进入容器查看内容 -P							# 指定容器的端口 8080 		8080:8081	容器的端口和本地主机端口映射起来
	-P ip:主机端口:容器端口			例:-P 127.0.0.1:8080:8080
	-P 主机端口:容器端口	(常用)	例:-P 8080:8081
	-P 容器端口			例:-P 8080
	容器端口	例:8080-p							# 随机指定端口
#测试, 以交互方式启动并进入容器
192:~ kevin$ docker run -it centos /bin/bash[root@0bc58b507f30 /]# ls			# 产看容器内的centos, 基础版本, 很多命令是不完善的   
															# 命令的用户名已经更改为了 0bc58b507f30(容器ID的前几位)
															# 镜像内部的文件和外部的文件没有半毛钱关系
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@0bc58b507f30 /]# exit		# 从容器中退回主机exit
192:~ kevin$ ls
Applications					Postman
Applications 2					Public
列出所有运行的容器
#docker ps	命令
			# 无参数, 列出当前正在运行的容器-a		# 列出当前正在运行的容器 + 带出历史运行过得容器-n=?	# 显示最近创建的容器  ?是个数 -q		# 只显示容器的编号

192:~ kevin$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
192:~ kevin$ docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS                          PORTS                NAMES
0bc58b507f30   centos         "/bin/bash"              3 minutes ago   Exited (0) About a minute ago                        relaxed_gagarin
b1b0a46d841d   35c43ace9216   "/docker-entrypoint.…"   4 hours ago     Exited (0) 4 hours ago                               trusting_shaw
退出容器
exit	# 直接容器停止并退出
Ctrl + P + Q	# 容器不停止退出

192:~ kevin$ docker run -it centos[root@69d577fb8a98 /]# exitexit
192:~ kevin$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
192:~ kevin$ docker run -it centos[root@312770d6b2e6 /]# 
192:~ kevin$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
312770d6b2e6   centos    "/bin/bash"   13 seconds ago   Up 13 seconds             lucid_gagarin
删除容器
docker rm 容器id		# 删除指定的容器, 不能删除正在运行的容器, 如果要强制删除 rm -f
docker rm -f $(docker ps -aq)		# 删除所有的容器
docker ps -a -q|xargs docker rm	 # 删除所有的容器
启动和停止容器
docker start 容器id			# 启动容器
docker restart 容器id		# 重启容器
docker stop 容器id			# 停止当前正在运行的容器
docker kill 容器id			# 强制停止当前容器
#测试
192:~ kevin$ docker run -it centos /bin/bash[root@98f514f9c797 /]# exitexit
192:~ kevin$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
192:~ kevin$ docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                        PORTS                NAMES
98f514f9c797   centos         "/bin/bash"              14 seconds ago   Exited (0) 10 seconds ago                          zen_curran
192:~ kevin$ docker start 98f514f9c797
98f514f9c797
192:~ kevin$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED              STATUS         PORTS     NAMES
98f514f9c797   centos    "/bin/bash"   About a minute ago   Up 3 seconds             zen_curran
192:~ kevin$ docker stop 98f514f9c797
98f514f9c797
192:~ kevin$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
### 常用其他命令
#命令 docker run 镜像名
MacBook-Pro-4:~ kevin$ docker run -d centos
58a576866517cccc73de36fba7320db8b74c2d497ac3d15af56e8021855cc4d7
#问题docker ps 发现 centos停止了
MacBook-Pro-4:~ kevin$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
#常见的坑  docker 容器使用后台运行, 就必须要有一个前台进程, docker认为没有应用程序了, 就会自动停止
### 查看日志命令
MacBook-Pro-4:~ kevin$ docker logs -f -t --tail 10 容器id   没有日志
#自己编写一段shell脚本"while true; do echo kevin;sleep 5;done"
#启动容器并执行shell脚本
MacBook-Pro-4:~ kevin$ docker run -d centos /bin/sh -c "while true;do echo kevin;sleep 5;done"
fa643e1c479fa79e8a9bb939fcdf4c2ed9c2e828abc86d7ce75b5bdb5b152cef
#查看正在运行的docker容器
MacBook-Pro-4:~ kevin$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
fa643e1c479f   centos    "/bin/sh -c 'while t…"   45 seconds ago   Up 44 seconds             great_keldysh
#查看日志的打印-f, --follow         # 跟踪日志的输出-t, --timestamps     # 显示日志的生产时间-f -t  或  -tf				# 显示日志的内容--tail num		# 要显示的最新的日志的条数
MacBook-Pro-4:~ kevin$ docker logs -f -t --tail 10 fa643e1c479f
2021-03-05T06:15:14.517430875Z kevin
2021-03-05T06:15:19.522640464Z kevin
### 查看容器中的进程信息 ps
#命令  docker top 容器id
MacBook-Pro-4:~ kevin$ docker top fa643e1c479f
UID                 PID                 PPID                C                   STIME               TTY                 
root                1952                1925                0                   06:14               ?                   
root                2083                1952                0                   06:22               ?      
查看镜像的元数据
#命令  docker inspect 容器id
MacBook-Pro-4:~ kevin$ docker inspect fa643e1c479f[
    {
        "Id": "fa643e1c479fa79e8a9bb939fcdf4c2ed9c2e828abc86d7ce75b5bdb5b152cef",	#容器完整id
        "Created": "2021-03-05T06:14:54.184272028Z",
        "Path": "/bin/sh",
        "Args": [				# 参数
            "-c",
            "while true;do echo kevin;sleep 5;done"
        ],
        "State": {		# 容器的状态
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 1952,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2021-03-05T06:14:54.494555021Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:300e315adb2f96afe5f0b2780b87f28ae95231fe3bdd1e16b9ba606307728f55",		# 镜像的秘钥
        "ResolvConfPath": "/var/lib/docker/containers/fa643e1c479fa79e8a9bb939fcdf4c2ed9c2e828abc86d7ce75b5bdb5b152cef/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/fa643e1c479fa79e8a9bb939fcdf4c2ed9c2e828abc86d7ce75b5bdb5b152cef/hostname",
        "HostsPath": "/var/lib/docker/containers/fa643e1c479fa79e8a9bb939fcdf4c2ed9c2e828abc86d7ce75b5bdb5b152cef/hosts",
        "LogPath": "/var/lib/docker/containers/fa643e1c479fa79e8a9bb939fcdf4c2ed9c2e828abc86d7ce75b5bdb5b152cef/fa643e1c479fa79e8a9bb939fcdf4c2ed9c2e828abc86d7ce75b5bdb5b152cef-json.log",
        "Name": "/great_keldysh",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "host",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/08b0e8b691f7bc526c4efecdc98ef5b5c07e5ad2a957985c9173b0e5c42af46a-init/diff:/var/lib/docker/overlay2/dd64b455512831cb4b11171ce1a02c265268911057c7555508efecd15ebefd2f/diff",
                "MergedDir": "/var/lib/docker/overlay2/08b0e8b691f7bc526c4efecdc98ef5b5c07e5ad2a957985c9173b0e5c42af46a/merged",
                "UpperDir": "/var/lib/docker/overlay2/08b0e8b691f7bc526c4efecdc98ef5b5c07e5ad2a957985c9173b0e5c42af46a/diff",
                "WorkDir": "/var/lib/docker/overlay2/08b0e8b691f7bc526c4efecdc98ef5b5c07e5ad2a957985c9173b0e5c42af46a/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "fa643e1c479f",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "/bin/sh",
                "-c",
                "while true;do echo kevin;sleep 5;done"
            ],
            "Image": "centos",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {
                "org.label-schema.build-date": "20201204",
                "org.label-schema.license": "GPLv2",
                "org.label-schema.name": "CentOS Base Image",
                "org.label-schema.schema-version": "1.0",
                "org.label-schema.vendor": "CentOS"
            }
        },
        "NetworkSettings": {		# 网络设置
            "Bridge": "",
            "SandboxID": "630b78f0a805282d51770a8bbe17c05621e33b6dee1466d2c42e64c5b8161544",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},
            "SandboxKey": "/var/run/docker/netns/630b78f0a805",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "306a4d4526680d9cfbc3e47ccb42a48b36a7ae3de5817a59a71a33723380bdbe",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.3",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:03",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "f30c55f149e8ce0144770cbfc10133589e9b344b5f064bdd04e9a0b4007c6df2",
                    "EndpointID": "306a4d4526680d9cfbc3e47ccb42a48b36a7ae3de5817a59a71a33723380bdbe",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:03",
                    "DriverOpts": null
                }
            }
        }
    }]
## 进入当前正在运行的容器
#通常容器都是后台方式运行的, 有时需要进入容器修改一些配置
#方式一:
docker exce -it 容器id bashShell
#测试
MacBook-Pro-4:~ kevin$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
fa643e1c479f   centos    "/bin/sh -c 'while t…"   16 minutes ago   Up 16 minutes             great_keldysh
d4d7173ff8a1   centos    "/bin/bash"              23 minutes ago   Up 23 minutes             hungry_kare
MacBook-Pro-4:~ kevin$ docker exec -it fa643e1c479f /bin/bash[root@fa643e1c479f /]# ls
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var[root@fa643e1c479f /]# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 06:14 ?        00:00:00 /bin/sh -c while true;do echo kevin;sleep 5;done
root       208     0  0 06:31 pts/0    00:00:00 /bin/bash
root       226     1  0 06:31 ?        00:00:00 /usr/bin/coreutils --coreutils-prog-shebang=sleep /usr/bin/sleep 5
root       227   208  0 06:31 pts/0    00:00:00 ps -ef
#方式二:
docker attach 容器id
#测试
MacBook-Pro-4:~ kevin$ docker attach d4d7173ff8a1[root@d4d7173ff8a1 /]# 
#区别# docker exec			# 进入容器后开启一个新的终端, 可以在里面操作(常用)# docker attach		# 进入容器正在执行的终端, 不会开启一个新的终端
从容器内拷贝文件到主机上
#命令  docker cp 容器id:容器内路径 目的主机的路径
#进入docker容器内部
MacBook-Pro-4:~ kevin$ docker attach d4d7173ff8a1[root@d4d7173ff8a1 /]# ls
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var[root@d4d7173ff8a1 /]# cd home[root@d4d7173ff8a1 home]# ls# 新建一个文件kevin.txt[root@d4d7173ff8a1 home]# touch kevin.txt[root@d4d7173ff8a1 home]# ls
kevin.txt[root@d4d7173ff8a1 home]# pwd/home[root@d4d7173ff8a1 home]# 
#将文件拷贝出来到主机上
MacBook-Pro-4:~ kevin$ docker cp d4d7173ff8a1:/home/kevin.txt /Users/kevin/Java/
MacBook-Pro-4:Java kevin$ ls
kevin.txt
MacBook-Pro-4:Java kevin$ pwd/Users/kevin/Java
#拷贝是一个手动的过程, 未来我们使用 -v 卷的技术, 可以实现自动同步  docker容器/home		主机/home  自动同步
按照教程一步步的走下来, 相信你会对docker有了一个初步的基础认知了, 后续会陆续更新教程的


