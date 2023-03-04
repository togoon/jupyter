　  <br>

# crypto Test & Prod Env

　  <br>

| 环境 | 策略 | 说明/触发 | 指令/参数 | 备注 |
| :-----| :----: | :---- | :---- | ----: |
| Test | similarity | 开仓:第42根10minK线(7点左右),取N天内相关性最大(正>负)的一天，根据剩余区间的涨跌进行开多/空 ; <br>平仓：晚上23:59; 凌晨0点到7点 是调整的时间窗口; | nohup python3 -u test_strategy.py -n testStrategy -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1 & | - |
| Test | pyemd | a)利用信噪比(计算方法为emd算法)和前半天时间的涨跌幅来做多做空；<br> b)如果当前时间的信噪比高于过去N天的均值, 而且前半天也是上涨的,那么做多; 只做多, 收盘平仓 | nohup python3 -u main.py -n pyemd2 -s 8808 -c 29091 -X BTCUSDT -p 10m -w 108 -d 120 -t 1000000 >> log.txt 2>&1 & | - |
| Test | modifiedmom | 前半天5min k线里剔除涨幅最大的wid_根k线后,重新计算涨幅,当这个涨幅大于thd时做多,持有到当日结束平仓; | nohup python3 -u main.py -n modifiedmom -s 8808 -c 29093 -X BTCUSDT -p 10m -w 71 -d 3 -T 0 -t 1000000 >> log.txt 2>&1 & | - |
| Test | factorcheck | 开仓: factor > float(thd); <br>平仓: 不满足开仓条件后wid2 K线时平仓;  | nohup python3 -u main.py -n factorcheck -s 8808 -c 29094 -X BTCUSDT -p 5m -w 40 -I 50 -d 2 -T 0.6 -t 1000000 >> log.txt 2>&1 & | - |
| Test | logic | Data_cal计算特征值; 逻辑回归分析以及预测,当prob_1大于0,55时,则多空,直到prob_0大于0.55, 反向开多(line 175行); | nohup python3 -u main.py -n logic -s 8808 -c 29096 -X BTCUSDT -p 30m -w 40 -d 120 -T 0.55 -t 1000000 >> log.txt 2>&1 & | - |
| Test | s_rsrs | 信号/反手: signal:1 (zscore>thd); -1 (zscore<-thd);  | nohup python3 -u main.py -n s_rsrs -s 8808 -c 29097 -X BTCUSDT -p 4h -w 25 -I 90 -d 120 -T 0.6 -t 1000000 >> log.txt 2>&1 & | - |
| Test | amihud | 信号/反手: signal:1 (value > mean+thd2 • std); -1 (value < mean-thd2 • std); | nohup python3 -u main.py -n amihud -s 8808 -c 29098 -X BTCUSDT -p 5m -w 144 -I 25 -d 30 -T 0.8 -H 2.5 -t 1000000 >> log.txt 2>&1 & | - |
| Test | sr_min | 信号/反手: signal:1 (value > mean+thd2 • std); -1 (value < mean-thd2 • std); | nohup python3 -u main.py -n sr_min -s 8808 -c 29099 -X BTCUSDT -p 5m -w 192 -I 10 -d 20 -T 0.88 -H 4.0 -t 1000000 >> log.txt 2>&1 &  | - |
| - | - | - | - | - |
| Prod | similarity | 0 0,7 * * *  /root/binancefuture/crypto/strategy/ similarity/similarityStart.sh | nohup python3 -u main.py -n similarity -X BTCUSDT -p 10m -w 42 -d 84 -c binance >> log.txt 2>&1 & | - |
| - | - | - | - | - |

　  <br>

## synchronize

```shell  
rsync -av root@8.219.68.31:/root/binancefuture/crypto/strategy  /workspaces/jupyter/prod/8.219.68.31/binancefuture/
rsync -av root@8.219.68.31:/root/binance/crypto/strategy  /workspaces/jupyter/prod/8.219.68.31/binance/
rsync -av root@47.241.99.13:/root/FIL/strategy --exclude flask/worth/page/.git/ /workspaces/jupyter/prod/47.241.99.13/
rsync -av root@47.241.99.13:/root/FIL/uat --exclude /root/FIL/uat/bak/ /workspaces/jupyter/prod/47.241.99.13/

rsync -av root@47.241.99.13:/root/FIL/strategy/percentile_regression_step2 /home/at/test/jupyter/prod/47.241.99.13/strategy/

find /workspaces/jupyter/prod/ -type f -size +1M  -print0 | xargs  -0  rm  # 删除超过 1m 文件
find /workspaces/jupyter/prod/ . -name *log* | xargs rm -rf # 删除log文件/目录 csv jpg
find /workspaces/jupyter/prod/ -regex '.*\.log\|.*\.csv\|.*\.jpg' | xargs rm -rf # 删除prod下 log文件/目录 csv jpg
rm -rf .git/ 

```

　  <br>

## Test Env 47.241.99.13

　  <br>

### 2022.11.25

　  <br>

+ similarity
开仓:第42根10minK线(7点左右),取N天内相关性最大(正>负)的一天，根据剩余区间的涨跌进行开多/空 ; <br>平仓：晚上23:59; 凌晨0点到7点 是调整的时间窗口; 

- Pyemd.py
a)利用信噪比(计算方法为emd算法)和前半天时间的涨跌幅来做多做空；<br> b)如果当前时间的信噪比高于过去N天的均值, 而且前半天也是上涨的,那么做多; 只做多, 收盘平仓

* modified_mom
前半天5min k线里剔除涨幅最大的wid_根k线后,重新计算涨幅,当这个涨幅大于thd时做多,持有到当日结束平仓; 

+ logic
Data_cal是计算特征值; 逻辑回归分析以及预测,当prob_1大于0,55时,则多空,直到prob_0大于0.55, 反向开多(line 175行);

+ factorcheck
开仓: factor > float(thd); <br>平仓: 不满足开仓条件后wid2 K线时平仓; 

+ s_rsrs
信号/反手: signal:1 (zscore>thd); -1 (zscore<-thd); 

+ amihud
信号/反手: signal:1 (value>mean+thd2*std); -1 (value<mean-thd2*std);

　  <br>


## Prod Env 8.219.68.31

　  <br>

### 2022.11.25

　  <br>

+ similarity
开仓:第42根10minK线(7点左右),取N天内相关性最大(正>负)的一天，根据剩余区间的涨跌进行开多/空 ; <br>平仓：晚上23:59; 凌晨0点到7点 是调整的时间窗口; 

　  <br>


# Env

　  <br>

vim ../similarity/log.txt 
vim ../pyemd/log.txt 
vim ../s_rsrs/log.txt 
vim ../factorcheck/log.txt 
vim ../modifiedmom/log.txt 
vim ../logic/log.txt 
vim ../amihud/log.txt 

cd /root/FIL/strategy/flask/worth && . setEnv.sh && . reportStart.sh
cd /root/FIL/strategy/similarity && . setEnv.sh
cd /root/FIL/strategy/s_rsrs && . setEnv.sh
cd /root/FIL/uat && . setEnv.sh
scp /mnt/e/milu/py/v2/FIL_lib /home/at/py/modifiedmom/

cd /root/FIL/strategy/logic && . setEnv.sh
cd /root/FIL/strategy/amihud && . setEnv.sh

ps aux | grep python | grep 8889

ssh -l root 47.241.99.13 
Etlink@yar
ping 47.241.99.13
    port = 3300,
    user = "root",
    password = "fil2022",
    db = "Trace_testtrace",  FIL_testfil


sudo sh -c "sync && echo 3 > /proc/sys/vm/drop_caches"

scp root@47.241.99.13:/root/FIL/strategy/flask/worth_20220916A.tar.gz   /mnt/e/milu

curl ifconfig.me
scp t1.py root@20.212.217.218:/workspaces/jupyter/
scp t1.py myServer:/workspaces/jupyter/
scp root@47.241.99.13:/root/FIL/strategy/similarity/t1.py  /workspaces/jupyter/binance/

新服务器：8.219.68.31
root，hwr@20220924  reaL2022
ssh -l root 8.219.68.31
ping 8.219.68.31
cd /root/binancefuture/crypto/strategy/similarity/ && . setEnv.sh
cd /root/binancefuture/crypto/uat

cd /root/binance/crypto/strategy/similarity/ && . setEnv.sh
cd /root/binance/crypto/strategy/similarity/
cd /root/binance/crypto/strategy/worth/bak
. worthStart.sh
/root/tmp/codespaces

scp .vimrc root@8.219.68.31:/root/
scp main.py  root@8.219.68.31:/root/binancefuture/crypto/strategy/similarity/
scp setEnv.sh similarityStart.sh similarityStop.sh  root@8.219.68.31:/root/binancefuture/crypto/strategy/similarity/

scp /workspaces/jupyter/prod/47.241.99.13/strategy/flask/worth/appReport.py root@8.219.68.31:/root/binancefuture/crypto/strategy/worth
scp /workspaces/jupyter/prod/47.241.99.13/strategy/flask/worth/worthStart.sh root@8.219.68.31:/root/binancefuture/crypto/strategy/worth

ps aux | grep vscode | grep -v grep | awk '{print $2}'| xargs kill -9

pkill -kill -t pts/0

ps aux | grep python3 | grep 8808 | grep -v grep | awk '{print $2}'| xargs kill -9

rsync -av  /workspaces/jupyter/jupyter --exclude .git/  root@8.219.68.31:/root/tmp/codespaces
rsync -av  root@8.219.68.31:/root/tmp/codespaces/jupyter  --exclude .git/ /workspaces/

cd /root/tmp/codespaces/jupyter
ation126@126.com Sqrt141421 
ation120 Sqrt141421 

/workspaces/jupyter
ssh-keygen
/home/codespace/.ssh/id_rsa

/C:/Users/AT/AppData/Roaming/Code/User/settings.json
    "remote.SSH.remotePlatform": {
        "47.241.99.13": "linux",
        "8.219.68.31": "linux"
    },


vim similarityStart.sh
vim similarityStop.sh
crontab -e
0 0,7 * * * /root/binancefuture/crypto/strategy/similarity//similarityStart.sh
* 7,15,23 * * * sync; echo 1 > /proc/sys/vm/drop_caches

ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa.pub remote@192.168.1.2

ssh-copy-id -i /home/codespace/.ssh/id_rsa.pub root@47.241.99.13
/home/codespace/.ssh/id_rsa

ssh-keygen  # cmd命令行中输入ssh-keygen，回车三次
C:\Users\Administrator/.ssh/id_rsa
C:\Users\Administrator/.ssh/id_rsa.pub
chmod 600 id_rsa
chmod 600 /mnt/c/Users/Administrator/.ssh/id_rsa
ssh-copy-id -i /mnt/c/Users/Administrator/.ssh/id_rsa.pub root@47.241.99.13
ssh-copy-id -i /mnt/c/Users/Administrator/.ssh/id_rsa.pub root@8.219.68.31

chmod 700 ~/.ssh
vim ~/.ssh/authorized_keys 
chmod 600 ~/.ssh/authorized_keys 

Host 8.219.68.31
  HostName 8.219.68.31
  User root
  IdentityFile "C:/Users/Administrator/.ssh/id_rsa"

Host 47.241.99.13
  HostName 47.241.99.13
  User root
  IdentityFile "C:/Users/Administrator/.ssh/id_rsa"


　  <br>