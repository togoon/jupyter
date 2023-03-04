
# ubuntu 2004

## init

1. change software library source  
    `sudo cp sources.list /etc/apt/sources.list`  

2. install  

```shell
sudo apt update
sudo apt install zip
sudo apt install build-essential # 编译软件包 g++ --version
sudo apt install build-essential gdb # gdb --version
sudo apt install openjdk-17-jre-headless # java --version
sudo apt install openjdk-17-jdk-headless # javac --version

# sudo apt install ntpdate

sudo curl -fsSL http://file.tickstep.com/apt/pgp | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/tickstep-packages-archive-keyring.gpg > /dev/null && echo "deb [signed-by=/etc/apt/trusted.gpg.d/tickstep-packages-archive-keyring.gpg arch=amd64,arm64] http://file.tickstep.com/apt aliyunpan main" | sudo tee /etc/apt/sources.list.d/tickstep-aliyunpan.list > /dev/null && sudo apt-get update && sudo apt-get install -y aliyunpan

wget https://github.com/tickstep/aliyunpan/releases/download/v0.2.6/aliyunpan-v0.2.6-linux-amd64.zip
unzip aliyunpan-v0.2.6-linux-amd64.zip
cd aliyunpan-v0.2.6-linux-amd64
./aliyunpan

sudo ln -s /home/at/bin/aliyunpan/aliyunpan /usr/bin/aliyunpan

aliyunpan login -QrCode # help
cd /home/at # cd .. 
zip -r jupyter_`date -d '+0 hour' '+%Y%m%d'`.zip jupyter -x='jupyter/.git/*'  #
aliyunpan u /home/at/jupyter_`date -d '+0 hour' '+%Y%m%d'`.zip /backup/jupyter/ --ow
aliyunpan u jupyter_`date -d '+0 hour' '+%Y%m%d'`.zip /backup/jupyter/ --ow

aliyunpan d /backup/jupyter/jupyter_`date -d '+0 hour' '+%Y%m%d'`.zip  --ow --saveto /home/at/
unzip /home/at/backup/jupyter/jupyter_`date -d '+0 hour' '+%Y%m%d'`.zip

rm -rf /home/at/jupyter_*.zip # rm -rf jupyter_*.zip


# 服务器时间同步
# 在开机的时候，使用ntpdate强制同步时间/跳跃，在其他时候使用ntpd服务来同步时间。

ntpdate time.nist.gov
time.nist.gov
time.nuri.net
0.asia.pool.ntp.org
1.asia.pool.ntp.org
2.asia.pool.ntp.org
3.asia.pool.ntp.org


```

3. settings 

```
crontab -e   # ①分钟(0-59) | ②小时(0-23) | ③号(1-31) | ④月(1-12) | ⑤星期几 (0-6 星期天0)
*/5 * * * * sh /home/at/test/jupyter/settings/ubuntu/gitTimer.sh 
*/60  * * * * /usr/local/bin/aliyunpan token update -mode 2
* */8 * * * ntpdate time.nist.gov

sed -i '$a export ALIYUNPAN_CONFIG_DIR=/home/at/test/jupyter/settings/aliyunpan/config' ~/.bashrc # 
# sed -i '$a echo 314159 | sudo service cron start' ~/.bashrc # 每次启动终端时, 启动cron
sed -i '$a sudo -S service cron start << EOF' ~/.bashrc # 每次启动终端时, 启动cron
sed -i '$a 314159' ~/.bashrc # 
sed -i '$a EOF' ~/.bashrc # 


# 119
ssh-keygen # ↵ ↵ ↵  
/home/at/.ssh/id_rsa.pub
https://github.com/settings/keys

ssh -T git@github.com

git clone git@github.com:ation119/jupyter.git
cd jupyter/
git config --local user.email "ation119@126.com"
git config --local user.name "ation119@126.com"

git add .
git commit -m "`date -d '+8 hour' '+%Y%m%d %H:%M:%S'`"  
git pull --rebase origin main
git push -u origin main


# 120
cd ~/.ssh/
ssh-keygen -t rsa -f ~/.ssh/id_rsa_120 -C "ation120@126.com"  # ↵ ↵ ↵ 

vim ~/.ssh/config  # git配置多个ssh_key
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



ssh -T git@ation120.github.com

# Host github.com           # git clone git@github.com:ation119/jupyter.git
# Host ation120.github.com  # git clone git@ation120.github.com:ation120/jupyter.git

git clone git@github.com:ation119/jupyter.git
git clone git@ation120.github.com:ation120/jupyter.git

cd jupyter/
git config --local user.email "ation123@126.com"
git config --local user.name "ation3"



```

# https://notebooks.edge.devcloud.intel.com/user/u184108/lab  # -d '+16 hour'
cd /home/u184108
mkdir bin
wget https://github.com/tickstep/aliyunpan/releases/download/v0.2.5/aliyunpan-v0.2.5-linux-amd64.zip
unzip aliyunpan-v0.2.5-linux-amd64.zip
mv aliyunpan-v0.2.5-linux-amd64 aliyunpan
aliyunpan/aliyunpan d /backup/jupyter/jupyter_20230126.zip --ow --saveto /home/u184108
unzip backup/jupyter/jupyter_20230126.zip

mkdir test
rsync -av root@47.241.99.13:/root/FIL/strategy/flask/worth/bak/worth_20230125.html /home/u184108/test


## ubuntu 国内镜像源 sources.list  


阿里源     https://developer.aliyun.com/mirror/  
清华源     https://mirrors.tuna.tsinghua.edu.cn/  
中科大源 http://mirrors.ustc.edu.cn/  
网易源     http://mirrors.163.com/  


1.备份原始源文件source.list
打开终端，执行命令：sudo  cp   /etc/apt/sources.list   /etc/apt/sources.list.bak

2.修改源文件sources.list
（1）终端执行命令：sudo  chmod  777  /etc/apt/sources.list   更改文件权限使其可编辑；
（2）执行命令：       sudo  gedit   /etc/apt/sources.list             打开文件进行编辑；
（3）删除原来的文件内容，根据系统版本复制下面的任意一个到其中并保存（常用的是阿里源和清华源，推荐阿里源）；

阿里源：

ubuntu 16

deb http://mirrors.aliyun.com/ubuntu/ xenial main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main
deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe

unbuntu 18

deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
ubuntu 20

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

3.更新源
sudo apt update。  
更新软件列表，换源完成。update 是同步 /etc/apt/sources.list 和 /etc/apt/sources.list.d 中列出的源的索引，这样才能获取到最新的软件包。
sudo  apt-get   install  -f
复损坏的软件包，尝试卸载出错的包，重新安装正确版本的  
更新软件  sudo apt-get upgrade。  
upgrade 是升级已安装的所有软件包，升级之后的版本就是本地索引里的，因此，在执行 upgrade 之前一定要执行 update, 这样才能是最新的。



## Ubuntu20.04 设置开机自启  

1. 查看系统中的自动启动脚本  
ls /lib/systemd/system  
可以看到有 rc-local.service 这个文件  

2. 修改 rc-local.service 文件的权限  
sudo chmod 777 /lib/systemd/system/rc-local.service

3. 修改 rc-local.service 文件  

```
#  SPDX-License-Identifier: LGPL-2.1+
#
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

# This unit gets pulled automatically into multi-user.target by
# systemd-rc-local-generator if /etc/rc.local is executable.
[Unit]
Description=/etc/rc.local Compatibility
Documentation=man:systemd-rc-local-generator(8)
ConditionFileIsExecutable=/etc/rc.local
After=network.target

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
RemainAfterExit=yes
GuessMainPID=no
```

增加以下内容：  
[Install]
WantedBy=multi-user.target
Alias=rc-local.service

保存，退出。

4. 修改 /etc/rc.local 文件  
查看系统中有无 /etc/rc.local 这个文件，没有则自己创建一个。
写入以下内容（清空文件中原有所有内容）：
#!/bin/sh
echo "看到这行字，说明添加自启动脚本成功。" > /usr/local/test.log
exit 0

赋予权限  
sudo chmod +x /etc/rc.local

5. 创建软链接  
ln -s /lib/systemd/system/rc-local.service /etc/systemd/system/  

6. 重启Ubuntu后，去 /usr/local 下看看有没有生成test.log这个文件以及这个文件的内容。
cat /usr/local/test.log

7. 其他说明  
如果在 /etc/rc.local 中添加的是 ./test.sh 这种类型的，要在末尾加上&，不然重启ubuntu的时候会卡在启动界面进不去系统。



# Ubuntu必备开发工具安装

1、安装gcc/g++/gdb/make 等基本编程工具
$sudo apt-get install build-essential

2、安装常见开发工具
$sudo apt-get install autoconf automake fakeroot kernel-package linux-headers-[kernel version]-amd64

3、安装常见开发文档
$sudo apt-get install binutils-doc cpp-doc gcc-doc make-doc diffutils-doc autoconf-doc m4-doc

4、安装系统调用和C/C++库文档
$sudo apt-get install manpages-dev manpages-posix-dev linux-doc glibc-doc libstdc++6-4.6-doc

5、安装调试器
$sudo apt-get install gdb gdb-doc cgdb

6、安装deb 包制作维护工具及文档
$sudo apt-get install dh-make devscripts fakeroot lintian pbuilder cowdancer debian-policy developers-reference

7、安装版本控制器
$sudo apt-get install cvs subversion subversion-tools git git-doc

8、安装QT
$sudo apt-get install libqt4-dev libqt4-opengl-dev qt4-dev-tools qt4-designer qt4-doc qt4-demos

9、安装boost
$sudo apt-get install libboost1.42-all-dev libboost1.42-doc

10、安装JAVA
$sudo apt-get install openjdk-6-jdk openjdk-6-doc openjdk-6-demo  

11、安装Python
$sudo apt-get install python-dev python-doc python-examples  

12、安装Ada
$sudo apt-get install gnat gnat-doc gnat-gps gnat-gps-doc
ln -s /usr/share/gps/icons/32px/gps_32.png /usr/share/icons/hicolor/32x32/apps/gnat-gps.png  
ln -s /usr/share/gps/icons/48px/gps_48.png /usr/share/icons/hicolor/48x48/apps/gnat-gps.png  
update-icon-caches /usr/share/icons/hicolor/  

cat > /usr/share/applications/gnat-gps.desktop << EOF  
[Desktop Entry]  
Name=GNAT-GPS  
Exec=gnat-gps  
Terminal=false  
Type=Application  
Icon=gnat-gps  
Categories=Development  
EOF

13、安装数据库
$sudo apt-get install sqlite3 libsqlite3-dev sqlite3-doc  
vi ~/.sqliterc 

#{  
PRAGMA foreign_keys = ON;  
#}  

14、安装代码格式化
$sudo apt-get install indent indent-doc xmlindent  

15、安装文档工具
$sudo apt-get install doxygen doxygen-gui doxygen-doc source-highlight graphviz graphviz-doc

16、安装IDE
$sudo apt-get install qtcreator qtcreator-doc

    # http://www.codeblocks.org/  
    dpkg -i codeblocks_10.05-1_amd64.deb \  
        libcodeblocks0_10.05-1_amd64.deb \  
        codeblocks-common_10.05-1_all.deb \  
        codeblocks-contrib_10.05-1_amd64.deb \  
        codeblocks-contrib-common_10.05-1_all.deb \  
        libwxsmithlib0_10.05-1_amd64.deb \  
        codeblocks-doc-en_10.05-1_all.deb  
    aptitude markauto libcodeblocks0 codeblocks-common codeblocks-contrib-common libwxsmithlib0  

17、安装建模工具

# http://argouml.tigris.org/  
tar xf ArgoUML-0.32.2.tar.gz -C /opt  
ln -s /opt/argouml-0.32.2/argouml.sh /usr/local/bin/argouml  
ln -s /opt/argouml-0.32.2/icon/argouml2.svg /usr/share/icons/hicolor/scalable/apps/argouml2.svg  
update-icon-caches /usr/share/icons/hicolor/  
cat > /usr/share/applications/argouml.desktop << EOF  
[Desktop Entry]  
Name=ArgoUML  
Exec=/opt/argouml-0.32.2/argouml.sh  
Terminal=false  
Type=Application  
Icon=argouml2  
Categories=Development  
EOF  

18、安装xorg
$sudo apt-get install xorg-dev

19、安装 rust 编译器等环境
cargo,    rustup,    toolchains/stable-x86_64-unknown-linux-gnu

export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
sudo curl https://sh.rustup.rs -sSf | sh
# rm -rf /home/at/bin/anaconda3/bin/curl

echo "export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static" >> ~/.bashrc
echo "export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup" >> ~/.profile
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source ~/.profile
source "$HOME/.cargo/env" # . "$HOME/.cargo/env" # 注意 rustc 添加环境变量，source .cargo/env

配置 环境变量 ,直接修改/etc/bash.bashrc,在末尾添加，
    #rust 永久有效
    export CARGO_HOME="~/.cargo/"
    export RUSTBINPATH="~/.cargo/bin"
    export RUST="~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu"
    export RUST_SRC_PATH="$RUST/lib/rustlib/src/rust/src"
    export PATH=$PATH:$RUSTBINPATH
检测 
    cargo -V # Rust的包管理器
    #rustup -V # 
    rustc --version  # Rust语言的编译器

    