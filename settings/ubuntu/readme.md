
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

# 244564485
cd ~/.ssh/
ssh-keygen -t rsa -f ~/.ssh/id_rsa_244 -C "244564485@qq.com"  # ↵ ↵ ↵ 


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

Host 244564485.github.com
HostName github.com
User 244564485
IdentityFile ~/.ssh/id_rsa_244


ssh -T git@ation120.github.com
ssh -T git@244564485.github.com

# Host github.com           # git clone git@github.com:ation119/jupyter.git
# Host ation120.github.com  # git clone git@ation120.github.com:ation120/jupyter.git

cd ~/test
git clone git@github.com:ation119/jupyter.git
git clone git@ation120.github.com:ation120/jupyter.git
git clone git@244564485.github.com:244564485/jupyter.git

cd jupyter/
git config --local user.email "ation123@126.com"
git config --local user.name "ation3"

git config --local user.email "244564485@qq.com"
git config --local user.name "244564485"

# .git/config
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        url = git@244564485.github.com:244564485/jupyter.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
        remote = origin
        merge = refs/heads/main
[user]
        email = 244564485@qq.com
        name = 244564485

```

4. git sync 244  

```
# 244564485
cd ~/.ssh/
ssh-keygen -t rsa -f ~/.ssh/id_rsa_244 -C "244564485@qq.com"  # ↵ ↵ ↵ 

vim ~/.ssh/config  # git配置多个ssh_key
... ...
Host 244564485.github.com
HostName github.com
User 244564485
IdentityFile ~/.ssh/id_rsa_244

ssh -T git@244564485.github.com

cd ~/test
git clone git@244564485.github.com:244564485/jupyter.git

git config --local user.email "244564485@qq.com"
git config --local user.name "244564485"

# .git/config
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        url = git@244564485.github.com:244564485/jupyter.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
        remote = origin
        merge = refs/heads/main
[user]
        email = 244564485@qq.com
        name = 244564485

# .gtiTimer.sh
git add .
git commit -m "`date -d '+8 hour' '+%Y%m%d %H:%M:%S'`"  
git pull --rebase origin main
git push -u origin main

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


## .condarc
channels:
  - defaults
    - conda-forge
show_channel_urls: true
channel_alias: http://mirrors.tuna.tsinghua.edu.cn/anaconda
default_channels:
  - http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
  - http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  channel_priority: flexible


## ~/.pip/pip.conf # pip.ini python库 pip源 python
[global]
trusted-host =  mirrors.aliyun.com
index-url = https://mirrors.aliyun.com/pypi/simple

pip install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com 安装包

http://mirrors.aliyun.com/pypi/simple/ # 阿里云
https://pypi.mirrors.ustc.edu.cn/simple/ # 中国科技大学
http://pypi.douban.com/simple/ # 豆瓣
https://pypi.tuna.tsinghua.edu.cn/simple/ # 清华大学

https://pypi.python.org/simple/ # Python官方 
http://pypi.v2ex.com/simple/ # v2ex  
http://pypi.mirrors.opencas.cn/simple/ # 中国科学院 
http://pypi.hustunique.com/ # 华中理工大学
http://pypi.sdutlinux.org/ # 山东理工大学

pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
python3 -m pip install -r ~/test/jupyter/settings/requirements.txt 

pip install pandas numpy matplotlib seaborn scipy tqdm  pymysql sqlalchemy  flask pandas_datareader  pymssql EMD-signal websocket-client ccxt statsmodels requests_toolbelt sshtunnel  pycryptodome  werkzeug  ipywidgets aligo jwt gevent pyts sympy mplfinance akshare yfinance tushare pyecharts scikit-learn torch jupyter-c-kernel -i https://pypi.mirrors.ustc.edu.cn/simple/ --trusted-host pypi.mirrors.ustc.edu.cn  --upgrade

pip freeze > requirements.txt   # 把pip安装的导出到requirements.txt
pip install -r requirements.txt


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

20、Anaconda3 Miniconda3 python

sudo apt-get remove --auto-remove python3.8 #卸载python3.8
sudo apt-get purge python3.8

wget --continue https//repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh  # 下载 conda3
wget --continue https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

wget -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2022.10-Linux-x86_64.sh 
wget -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
wget -c https://mirrors.bfsu.edu.cn/anaconda/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh
scp /mnt/c/users/at/downloads/Anaconda3-2022.10-Linux-x86_64.sh  /home/at/pkg/

bash Anaconda3-2021.05-Linux-x86_64.sh

conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda
conda config --set show_channel_urls yes

conda update conda
conda create -n cling
conda activate cling
conda install jupyter notebook
conda install xeus-cling -c conda-forge
conda list
conda clean -i
conda env create -f clang.yml
conda env create -f /home/at/test/jupyter/settings/ubuntu/clang.yml
pip install jupyter-c-kernel

pip install -i https://pypi.mirrors.ustc.edu.cn/simple/ --trusted-host pypi.mirrors.ustc.edu.cn  jupyter-c-kernel --upgrade
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple # http://mirrors.aliyun.com/pypi/simple
python3 -m pip install -r ~/test/jupyter/settings/requirements.txt 

pip install pandas numpy matplotlib seaborn scipy tqdm  pymysql sqlalchemy  flask pandas_datareader  pymssql EMD-signal websocket-client ccxt statsmodels requests_toolbelt sshtunnel  pycryptodome  werkzeug  ipywidgets aligo jwt gevent pyts sympy mplfinance akshare yfinance tushare pyecharts scikit-learn torch jupyter-c-kernel -i https://pypi.mirrors.ustc.edu.cn/simple/ --trusted-host pypi.mirrors.ustc.edu.cn  --upgrade

sudo vim ~/.bashrc
export PATH=[your path to anaconda]/anaconda3/bin:$PATH
export PATH=/home/at/anaconda3/bin:$PATH
#echo 'export PATH="/home/at/anaconda3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

conda create --name pytorch python=3.9 # 创建python环境
conda create -n tensorflow python=3  # 建立一个名为tensorflow的虚拟环境
conda create -n tensor222 --clone tensorflow # conda环境克隆  
conda create -n BBB --clone ~/path # 跨计算机克隆
conda env create -f environment.yaml # 只能安装原来环境中用conda install等命令直接安装的包，不包括pip安装的包
conda activate pytorch # 进入自创建环境 
conda activate tensorflow  # 激活虚拟环境
conda deactivate #退出虚拟环境
conda info --envs
conda upgrade --all  # 工具包升级
conda remove -n tensorflow --all   # 删除虚拟环境
conda remove urllib3 # 删除包
conda list   # 查看安装的包 查看环境内容
conda install urllib3  # 安装包
conda install scrapy==1.3  #安装指定版本的包
conda install -n tensorflow scrapy #在tensorflow环境安装scrapy包

conda env list # 查看当前存在的虚拟环境

conda env export > environment.yaml   # 共享环境 保存为yaml文件


conda install pandas numpy matplotlib seaborn scipy tqdm pymysql sqlalchemy flask pymssql  websocket-client statsmodels scikit-learn sshtunnel  pycryptodome werkzeug ipywidgets gevent sympy    

conda config --set channel_alias https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
conda config --show
conda update -n base conda # 更新conda
conda update -all
conda config --add channels conda-forge # 修改频道 
conda config --set channel_priority flexible
conda config --set auto_activate_base False  #关闭自动激活环境
conda install xeus-cling -c conda-forg  # 在jupyter中配置c++内核 jupyter notebook c++
jupyter kernelspec list # 
conda install anaconda-clean

conda create --name clang python=3.9.13 openssl=1.1.1q pip=22.2.2 ca-certificates=2022 setuptools=63.4.1 sqlite=3.39.3  --offline
conda activate clang
conda install jupyter notebook
conda install -c conda-forge xeus-cling
jupyter kernelspec list

pip install pandas numpy matplotlib seaborn scipy tqdm  pymysql sqlalchemy  flask pandas_datareader  pymssql EMD-signal websocket-client ccxt statsmodels   requests_toolbelt sshtunnel  pycryptodome  werkzeug  ipywidgets aligo jwt gevent pyts sympy mplfinance akshare yfinance tushare pyecharts scikit-learn torch jupyter-c-kernel -i https://pypi.mirrors.ustc.edu.cn/simple/ --trusted-host pypi.mirrors.ustc.edu.cn  --upgrade
jupyter notebook
conda env export > xxxxx.yml：导出
conda install conda-pack

conda pack -n clang -o clang.tar.gz  # 在源机器上打包 
conda pack -p /explicit/path/to/clang # clang.tar.gz
mkdir -p clang
tar -xzf clang.tar.gz -C clang  # 在目标机器上操作
./clang/bin/python
source clang/bin/activate # adds `clang/bin` to your path
conda-unpack
ipython --version
source clang/bin/deactivate



