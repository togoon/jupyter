
------------------------------

tail -f log.txt
临时解决方法：

# 查看 inotify 的相关配置
$ sysctl fs.inotify
fs.inotify.max_queued_events = 16384
fs.inotify.max_user_instances = 128
fs.inotify.max_user_watches = 8192
# 临时修改配置（重启后会恢复）
$ sudo sysctl -w fs.inotify.max_user_watches=100000
永久解决方法：

$ sudo echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf
# 重载配置文件，使之马上生效
$ sudo sysctl -p


----端口--------------------------

netstat -aon | findstr :4049
tasklist | findstr "进程ID"


netstat -ntulp |grep 端口号
netstat -anp|grep 端口号

lsof -i:{端口号} # lsof -i:8080 查看8080端口占用

ip addr show eth0

Win+R打开运行，输入命令"ie4uinit -show"回车进行图标缓存清理

unicode字符js: escape("新品") ; unescape("%u65B0%u54C1")
URL编码js: encodeURI("新品"); decodeURI("%E6%96%B0%E5%93%81")


------------------------------

用管理员方式打开PowerShell:

查看转发了哪些端口
netsh interface portproxy show all

删除转发规则
netsh interface portproxy delete v4tov4 listenaddress=10.10.0.69 listenport=80

netsh interface portproxy delete v4tov4 listenaddress=* listenport=5050
netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=5050

新增转发规则 win10/防火墙/外网 5050 wsl2 5000 
netsh interface portproxy add v4tov4 listenport=5050 connectaddress=localhost connectport=5000 listenaddress=0.0.0.0 protocol=tcp


新服务器：8.219.68.31
root，hwr@20220924


47.241.99.13
root
Etlink@yar

ssh -l root 47.241.99.13 

ssh-keygen  #ssh pwd
ssh-copy-id -i ~/.ssh/id_rsa.pub remote@192.168.1.2

ssh-copy-id -i /home/codespace/.ssh/id_rsa.pub root@47.241.99.13
/home/codespace/.ssh/id_rsa

scp source destination
scp log1.txt root@47.241.99.13:/root/similarity/
scp main.py  root@47.241.99.13:/root/similarity/

scp lucas@192.168.110.128:/home/lucas/world.txt   C:\Users\zbh\Desktop\
scp root@47.241.99.13:/root/FIL/strategy/flask/worth_20220916A.tar.gz   /mnt/e/milu

scp .\trace.db  \\wsl$\Ubuntu-20.04\home\at\test\py\flask
//wsl$\Ubuntu-20.04/home/at/ipynb/QL/Data/stock1.db
scp /mnt/c/milu/docx/strategy/trace/trace_20220807A.db /home/at/test/worth/trace.db

scp /mnt/c/milu/favicon.ico /home/at/test/py/flask/static/
scp /mnt/c/Users/AT/Downloads/ngrok-v3-stable-linux-arm64.tgz  /home/at/pkg/ngrok/


目录 scp -r worth /mnt/c/milu/docx/strategy/

tar -zcvf strateg63_20220715.tar.gz stratge.py pubsub.py files libs file
打包: tar -zcvf worth_20220916A.tar.gz  worth
解包: tar -zxvf FileName.tar

查询ip：curl ifconfig.me

#强制踢出用户 pkill -kill -t pts/0

ps aux | grep vscode | grep -v grep | awk '{print $2}'| xargs kill -9
find . -type f -name "*.txt" | xargs grep -inr "clearance" | grep -v grep
sync; echo 1 > /proc/sys/vm/drop_caches 

cd /root/FIL/strategy/similarity && . setEnv.sh

find . -type f -size +800M   # 搜索当前目录下，超过800M大小的文件
find . -type f -size +800M  -print0 | xargs -0 ls -l   # 文件的信息（例如，文件名称,大小、文件属性）    
| xargs -0 du -h | sort -nr | head -10 # 显示查找出来文件的具体大小 r倒序 # 排序 # 前10

find /home/raven -name abc.txt | xargs rm -rf  # 删除/home/raven下，包括子目录里所有名为abc.txt的文件
find /home/raven -name abc.txt -exec rm -fv {} \;

du -sh  # 查看目录大小
find . -type f -size +1M  -print0 | xargs -0 du -h | sort -nr | head -10  #查看1m文件
find . -type f -size +1M  -print0 | xargs  -0  rm  # 删除超过 1m 文件
find . -name *log* | xargs rm -rf # 删除log文件/目录

find logs -type f -mtime +5 -exec rm { } \;


----输出重定向--------------------------


 >log 2>&1 #输出(含错误)到日志 同 # &>log # >&log
 1 > /dev/null 2>&1 # 标准错误/输出重定向到空设备文件，不输出(含错误)

nohup 不挂断 SIGHUP (屏蔽关闭ssh客户端) ;   & 后台 SIGINT (屏蔽 ctrl+c)

一行代码直接启动服务器curl -k https://gitee.com/py4u/lite-server/raw/master/web.sh -o web.sh && bash web.sh

python3 -m http.server 5000

flask run -p 5000 -h 0.0.0.0
/usr/bin/python3 /usr/local/bin/flask run


curl http://127.0.0.1:5000/worth
curl http://localhost:5000/worthpt
curl -v -X GET "https://httpbin.org/get" -H "accept: application/json"
curl -v -X POST "https://httpbin.org/post" -H "accept: application/json"
curl -X PATCH "http://httpbin.org/patch" -H "accept: application/json"
curl -X DELETE "http://httpbin.org/delete" -H "accept: application/json"
curl -X PUT "http://httpbin.org/put" -H "accept: application/json"



安装lua5.4.4
wget http://www.lua.org/ftp/lua-5.4.4.tar.gz
sudo mkdir /usr/local/lua 
sudo tar -zxvf lua-5.4.4.tar.gz -C /usr/local/lua/
cd /usr/local/lua/lua-5.4.4/
sudo make linux test
sudo make install


#git init  
git clone git@github.com:ation126/ation126.github.io.git
ssh-keygen -t rsa -C 'ation126@126.com' -f /root/.ssh/github_id_rsa
#赋值/root/.ssh/github_id_rsa.pub，内容github中，进入setting，点击左侧Add SHH Key，选择Add new，随便输入一个titile，将刚刚复制的key粘贴到key中

#ssh-agent bash
# ssh-add /root/.ssh/github_id_rsa
#ssh -T git@github.com

cd ${curDir}/page
#git config --local user.email "ation126@126.com"
#git config --local user.name "ation126"
#git config --global credential.helper store
#git config --local user.password "pwd"

#git remote add origin git@github.com:ation126/ation126.github.io.git #删除远程仓库

git add .
git commit -m "worth_`date '+%Y%m%d'`"
git pull --rebase origin master
git push -u origin master

/root/FIL/strategy/flask/worth/page/ation126.github.io/bak/worth.html

touch config  vim config
# github
Host github.com
HostName github.com
User ation126
PreferredAuthentications publickey
IdentityFile ~/.ssh/github_id_rsa


----fil-V3.1------


配置交易所密钥  在key.json配置

创建主账户
  //curl -X POST -d '{"method":"createMainAccount","params":["mainaccount",3,0]}' http://127.0.0.1:8889/strategy

  
创建子账户
  curl -X POST -d '{"method":"createSubAccount","params":["subaccount",1,"1000000.0"]}' http://127.0.0.1:8889/strategy
  
创建策略
  curl -X POST -d '{"method":"hello","params":["test-strategy","mainaccount","subaccount","127.0.0.1",9090]}' http://127.0.0.1:8889/strategy

划转交易所U本位合约资产到子账户u本位    8为该划转类型的值
  curl -X POST -d '{"method":"accountTransfer","params":["mainaccount","subaccount","test-strategy","USDT","1000.0",8]}' http://127.0.0.1:8889/strategy

划转子账户u本位合约资产到策略u本位      16为该划转类型的值
  curl -X POST -d '{"method":"accountTransfer","params":["mainaccount","subaccount","test-strategy","USDT","1000.0",16]}' http://127.0.0.1:8889/strategy

下单接口不变


查询主账户
curl -X POST -d '{"method":"queryMainAccount","params":["mainaccount"]}' http://127.0.0.1:8889/strategy
查询策略信息
curl -X POST -d '{"method":"queryStrategyInfo","params":["similarity"]}' http://127.0.0.1:8889/strategy
查询合约资产
curl -X POST -d '{"method":"queryContractAssets","params":["testStrategy","USDT"]}' http://127.0.0.1:8889/strategy
查询仓位   仓位方向 long值从0改为1  short值从1改为-1
curl -X POST -d '{"method":"queryPositions","params":["testStrategy","ETHUSDT",-1]}' http://127.0.0.1:8889/strategy


############
./FIL run -c ./config.json -k ./key.json

1. 启动主程
cd /root/FIL/fil && nohup ./FIL run -c ./config.json -k ./key.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 &
cd /root/FIL/fil && nohup ./FIL.bak run -c ./config.json -k ./key.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 &



2. 创建主账户
curl -X POST -d '{"method":"createMainAccount","params":["trade",0,1]}' http://127.0.0.1:8889/strategy



3. 创建子账户
curl -X POST -d '{"method":"createSubAccount","params":["subtrade1",1,"10000.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["subtrade2",1,"3000.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["subtrade3",1,"2000.0"]}' http://127.0.0.1:8889/strategy

4. 创建策略
# trade subtrade1 testtrade1 id:1 39090 
curl -X POST -d '{"method":"hello","params":["testtrade1","trade","subtrade1","127.0.0.1",39090]}' http://127.0.0.1:8889/strategy

{"method":"hello","success":true,"message":"{\"name\":\"testtrade1\" , \"time\":1667872387081, \"id\":1}"}

nohup python3 -u main.py -n testtrade1 -s 8889 -c 39090 -X BTCUSDT -p 10m -w 40 -d 2 -T 0.5 -t 1000 >> log.txt 2>&1 &


# trade subtrade2 testtactic2 id:2 39290 
curl -X POST -d '{"method":"hello","params":["testtactic2","trade","subtrade2","127.0.0.1",39290]}' http://127.0.0.1:8889/strategy

# trade subtrade3 testkline3 id:3  39390
curl -X POST -d '{"method":"hello","params":["testkline3","trade","subtrade3","127.0.0.1",39390]}' http://127.0.0.1:8889/strategy

nohup python3 -u main_kline.py -n testkline3 -s 8889 -c 39390 -X BTCUSDT -p 10m -w 40 -d 3 -T 0.5 -t 1000 >> log_kline.txt 2>&1 &


5. 划转交易所U本位合约资产到 子账户u本位    8为该划转类型的值

# trade subtrade1 3000 testtrade1 
curl -X POST -d '{"method":"accountTransfer","params":["trade","subtrade1","testtrade1","USDT","3000.0",8]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# trade subtrade1 testtrade1 1000
划转子账户u本位合约资产到 策略u本位      16为该划转类型的值
curl -X POST -d '{"method":"accountTransfer","params":["trade","subtrade1","testtrade1","USDT","1000.0",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# trade subtrade2 3000 testtactic2 1000 
curl -X POST -d '{"method":"accountTransfer","params":["trade","subtrade2","testtactic2","USDT","3000.0",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["trade","subtrade2","testtactic2","USDT","1000.0",16]}' http://127.0.0.1:8889/strategy


# trade subtrade3 2000 testkline3 1000
curl -X POST -d '{"method":"accountTransfer","params":["trade","subtrade3","testkline3","USDT","2000.0",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["trade","subtrade3","testkline3","USDT","1000.0",16]}' http://127.0.0.1:8889/strategy


查询币安U本位账户
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["trade"]}' http://127.0.0.1:8889/strategy

{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"1902.31833327","totalMaintMargin":"15.21854666","totalWalletBalance":"14614.57417048","totalUnrealizedProfit":"-164.57300483","totalMarginBalance":"14450.00116565","totalPositionInitialMargin":"1902.31833327","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"14614.57417048","totalCrossUnPnl":"-164.57300483","availableBalance":"12547.68283238","maxWithdrawAmount":"12547.68283238","assets":[{"asset":"USDT","walletBalance":"14614.57417048","unrealizedProfit":"-164.57300483","marginBalance":"14450.00116565","maintMargin":"15.21854666","initialMargin":"1902.31833327","positionInitialMargin":"1902.31833327","openOrderInitialMargin":"0","crossWalletBalance":"14614.57417048","crossUnPnl":"-164.57300483","availableBalance":"12547.68283238","maxWithdrawAmount":"12547.68283238","marginAvailable":true,"updateTime":1669031651405}],"positions":[{"symbol":"BTCUSDT","initialMargin":"1902.31833327","maintMargin":"15.21854666","unrealizedProfit":"-164.57300483","positionInitialMargin":"1902.31833327","openOrderInitialMargin":"0","leverage":"2","entryPrice":"16747.72013242","maxNotional":"300000000","bidNotional":"0","askNotional":"0","positionSide":"BOTH","positionAmt":"0.237","isolated":false,"updateTime":1669031651405}]}]}

查询币安U本位账户风险
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["trade","BTCUSDT"]}' http://127.0.0.1:8889/strategy

{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0.237","entryPrice":"16747.72013242","markPrice":"16067.09213386","unRealizedProfit":"-161.30883565","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"3807.90083572","isolatedWallet":"0","updateTime":1669031651405}]}]}



查询主账户
curl -X POST -d '{"method":"queryMainAccount","params":["trade"]}' http://127.0.0.1:8889/strategy

{"method":"queryMainAccount","result":[{"name":"trade","id":1,"createtime":1667792797979,"updatetime":1667792797979,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"type":0,"tradetype":1,"keyid":1}]}

查询策略信息
curl -X POST -d '{"method":"queryStrategyInfo","params":["testtrade1"]}' http://127.0.0.1:8889/strategy

{"method":"queryStrategyInfo","result":[{"name":"testtrade1","time":1667872387081,"mainID":1,"subID":2,"strategyID":1,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

查询合约资产
curl -X POST -d '{"method":"queryContractAssets","params":["testtrade1","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"1000","total":"1000","margin":"0","unreal":"0","lock":"0","longfree":"0","shortfree":"0","type":1}]}


查询仓位   仓位方向 long值从0改为1  short值从1改为-1

curl -X POST -d '{"method":"queryPositions","params":["testtrade1","BTCUSDT",1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["testtrade1","BTCUSDT",-1]}' http://127.0.0.1:8889/strategy



# nohup python3 -u main.py -n testtrade1 -s 8889 -c 39090 -X BTCUSDT -p 3m -w 40 -d 2 -T 0.5 -t 1000 >> log.txt 2>&1 &
# python3 -u main.py -n testtrade1 -s 8889 -c 39090 -X BTCUSDT -p 5m -w 40 -d 2 -T 0.5 -t 1000 


----fil-V3.2------

查询币安U本位账户
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["mainaccount"]}' http://127.0.0.1:8889/strategy
查询币安U本位账户风险
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["mainaccount","BTCUSDT"]}' http://127.0.0.1:8889/strategy

查询币安U本位仓位模式
curl -X POST -d '{"method":"queryBinanceUsdtPositionSide","params":["mainaccount"]}' http://127.0.0.1:8889/strategy
修改币安U本位仓位模式   true为双向持仓  false为单向持仓
curl -X POST -d '{"method":"changeBinanceUsdtPositionSide","params":["mainaccount","false"]}' http://127.0.0.1:8889/strategy

修改币安U本位杠杆大小
curl -X POST -d '{"method":"changeBinanceUsdtLeverage","params":["mainaccount","BTCUSDT",10]}' http://127.0.0.1:8889/strategy

查询市价单合约资产
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testStrategy","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
查询限价单合约资产
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testStrategy","USDT","BTCUSDT","17000"]}' http://127.0.0.1:8889/strategy


下单接口修改：
u本位市价单 insertMarketUOrder  
尾部添加一个参数 positionside   

u本位市价单 insertLimitUOrder  
尾部添加一个参数 positionside 

数据类型 positionside   1:LONG  -1:SHORT  2:NONE
# 单向持仓填 NONE
双向持仓配合订单side填写
开多：BUY LONG
开空：SELL SHORT
平多：SELL LONG
平空：BUY SHORT

功能更新：
1.系统下单资金校验
2.母账户成交校验
3.修复py的positionside的bug
4.修复其他bug

配置更新：
config文件更新账户校验间隔频率设置，默认180s
"accountcheck_interval":180,



接口更新v4：
updateRiskConfig 触发更新风控配置
curl -X POST -d '{"method":"updateRiskConfig","params":["/home/chain/program/FIL/build/risk.json"","USDT","BTCUSD"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"updateRiskConfig","params":["/home/chain/program/FIL/build/risk.json"]}' http://127.0.0.1:8889/strategy

queryRiskConfig 查询风控配置
curl -X POST -d '{"method":"queryRiskConfig","params":[]}' http://127.0.0.1:8889/strategy

queryCurrentRiskResult 查询风控当前计算状态
curl -X POST -d '{"method":"queryCurrentRiskResult","params":["strategy-name"]}' http://127.0.0.1:8889/strategy

启动方式更新参考：
./programs/FILmain/FIL run -c ./config.json -k ./key.json

功能更新：
1.添加风控模块
2.修复部分bug


配置更新：
添加风控配置risk.json

risk.json 字段解释：
风控计算周期（单位s）       RiskInterval
风控计算的订单时间（10min） OrderTimePeriod
风控计算的订单权重（1）     Orderweight
风控计算的请求权重（1）     Requestweight
风控的UFR常量（10000）      UFRnum
风控的GTC常量（5000）       GTCnum
风控的DR常量（10000）       DRnum

权重          threshold
告警          toWarn
下单禁止      toForbid
使能          enable
清仓          toCloseAll  

新增风控类型：
RiskType_Order_FlowLimit = 0,
RiskType_Order_UFR  = 1,     //UFRLimit 未成交率UFR >= 阈值 , 触发, 阈值参考 0.99-0.02
RiskType_Order_GCR  = 2,     //GTCLimit GTC取消率GCR >= 阈值 , 触发, 阈值参考 0.99-0.02
RiskType_Order_IFER = 3,     IOC和FOK到期率IFER >= 阈值, 触发, 阈值参考 0.99-0.02
RiskType_Order_DR   = 4,     //DRLimit  小单率DR >= 阈值, 触发, 阈值参考 0.9-0.1

RiskType_Account_Leverage = 5,  //LeverageLimit
RiskType_Account_Position = 6,  //PositionLimit
RiskType_Account_Loss     = 7,  //LossLimit
RiskType_Account_Worth    = 8,  //WorthLimit


后台输出日志模块 RiskCalcWorker::calc
计算值value  阈值threshold

数据库风控日志 riskwarnlog


pylib更新v5：
添加风控RiskLimit的推送及其handleRiskLimit处理函数

功能更新：
1.添加风控的RiskLimit的策略推送
2.添加appkey的加解密，appkey入库，及其接口

接口更新：

insertAppkey 添加appkey
curl -X POST -d '{"method":"insertAppkey","params":[1,0,1,"pubkey","prikey","key desc"]}' http://127.0.0.1:8889/strategy

其中1,0,1 表示 keyid, gatewaytype中的binance, tradetype中的usdt合约类型

updateAppkey 更新appkey
curl -X POST -d '{"method":"updateAppkey","params":[1,0,1,"pubkey","prikey","key desc"]}' http://127.0.0.1:8889/strategy

queryAppkeys 查询appkey
curl -X POST -d '{"method":"queryAppkeys","params":[]}' http://127.0.0.1:8889/strategy




2022-11-22 15:22:38,221:INFO:testtrade1:main_trade.py:370:handleTimer:52461: handleTimer: data=TimeridType{'timerid': 9}

2022-11-22 15:22:38,362:INFO:testtrade1:main_trade.py:170:queryContractAssets:52461: queryContractAssets: assets=ContractAssetReturn{'result': [ContractAsset{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'asset': 'USDT', 'free': '982.5294984', 'total': '998.6137984', 'margin': '15.73398204463', 'unreal': '-0.35031795537', 'type': 'AssetType_ucontract', 'lock': '0', 'longfree': '0', 'shortfree': '0'}]}

queryPositions: self.symbol='BTCUSDT', positions=PositionsReturn{'result': [PositionType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'symbol': 'BTCUSDT', 'positionAmount': '0.001', 'enterprice': '16084.3', 'countrevence': '0', 'unrealprofit': '-0.35031795537', 'marginmodel': 0, 'isolatedmargin': '0', 'positionside': 'long', 'markprice': '15733.98204463', 'status': 'none', 'closeprice': '0', 'closeamount': '0', 'opentime': 0, 'closetime': 0, 'type': 'AssetType_ucontract'}]}

2022-11-22 15:22:38,830:INFO:testtrade1:main_trade.py:393:handleTimer:52461: self.client.insertMarketUOrder(gateway, self.symbol, float(qtyStr), side, self.flagDict['positionside']) = InsertOrderReturn{'result': 'success', 'clientorderid': '411F1669101758717I0L1'}
2022-11-22 15:22:38,844:INFO:testtrade1:main_trade.py:164:insertFactor:52461: curDateTime:11221522, name:testtrade1, symbol:BTCUSDT, tradeDate:, closeTime:, close:, sign:1, total:982.5294984, count:10,  side:  
127.0.0.1 - - [22/Nov/2022 15:22:38] "POST / HTTP/1.1" 200 -
2022-11-22 15:22:38,857:INFO:testtrade1:main_trade.py:331:handleOrderNew:52461: handleOrderNew: data=OrderType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'clientorderid': '411F1669101758717I0L1', 'symbol': 'BTCUSDT', 'gatewayorderid': 3254717253, 'quantity': '0.001', 'price': '0', 'stopprice': '0', 'ordertype': '', 'side': 'SELL', 'status': '', 'positionside': 'BOTH', 'createtime': 1669101758490, 'updatetime': 1669101758490, 'tradetype': 'usdt', 'selfid': 411, 'filltrades': [], 'gatetype': 'binance', 'handletime': 0}



----fil-V5.1--test--subrisk1--risk--15000--20230113---


1. 启动主程

cd /root/FIL/fil && nohup ./FIL run -c ./config.json -r ./risk.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 & 
ps aux | grep FIL | grep risk | grep -v grep | awk '{print $2}'| xargs kill -9


curl -X POST -d '{"method":"hello","params":["testrisk1","risk","subrisk1","127.0.0.1",39191]}' http://127.0.0.1:8889/strategy

2. 创建主账户
insertAppkey 添加appkey
curl -X POST -d '{"method":"insertAppkey","params":[1,0,1,"pubkey","prikey","key desc"]}' http://127.0.0.1:8889/strategy

# testnet11  15000 
curl -X POST -d '{"method":"insertAppkey","params":[1,0,1,"8fe7623f5b17d916e19a2d04e8d6e7a65761daf678c1a90120fb69055a28f748","1770a8f54c937fa86c8d5c2155250f558531fdd6482c189e9881f8596b454662","testnet11"]}' http://127.0.0.1:8889/strategy
{"method":"insertAppkey","success":true,"message":""}

其中1,0,1 表示 keyid, gatewaytype中的binance, tradetype中的usdt合约类型

updateAppkey 更新appkey
curl -X POST -d '{"method":"updateAppkey","params":[1,0,1,"pubkey","prikey","key desc"]}' http://127.0.0.1:8889/strategy


queryAppkeys 查询appkey
curl -X POST -d '{"method":"queryAppkeys","params":[]}' http://127.0.0.1:8889/strategy
{"method":"queryAppkeys","result":[{"id":1,"type":0,"tradetype":1,"pubkey":"55db4162bc206da02f9e7333e6f80810cc2ebd383f44f9990d9168b4e1e8dcd45236eaaa6c156007230942055706845a4d2f446887914c78bbcee96bc3c03893","prikey":"5c8a1365eb2a38f32e9f7b37b5a7581e9f7cbc3d3843fb9c5d9c3eb7b4b988d75f34efaa6e1062072009135707078d0e46271a3bd7904974b8cdef6691c13a99","desc":"testnet11"}]}


# risk,0,1 testnet11 15000
curl -X POST -d '{"method":"createMainAccount","params":["risk",0,1]}' http://127.0.0.1:8889/strategy
{"method":"createMainAccount","success":true,"message":""}

查询币安U本位账户
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["risk"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1673583382911}],"positions":[]}]}

{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1673583382911}],"positions":[]}]}


查询币安U本位账户风险
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["risk","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"18822.1","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}

查询币安U本位仓位模式  true 为双向持仓  false 为单向持仓
curl -X POST -d '{"method":"queryBinanceUsdtPositionSide","params":["risk"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtPositionSide","result":[{"dualSidePosition":false}]}

查询主账户
curl -X POST -d '{"method":"queryMainAccount","params":["risk"]}' http://127.0.0.1:8889/strategy
{"method":"queryMainAccount","result":[{"name":"risk","id":1,"createtime":1673598876986,"updatetime":1673598876986,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"type":0,"tradetype":1,"keyid":1}]}


3. 创建子账户 
# risk,0,1 testnet11 15000, subrisk1 7500
curl -X POST -d '{"method":"createSubAccount","params":["subrisk1",1,"7500.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}

# risk,0,1 testnet11 15000, subrisk2 7500
curl -X POST -d '{"method":"createSubAccount","params":["subrisk2",1,"7500.0"]}' http://127.0.0.1:8889/strategy

查询子账户
curl -X POST -d '{"method":"querySubAccount","params":["subrisk1"]}' http://127.0.0.1:8889/strategy 
{"method":"querySubAccount","result":[{"name":"subrisk1","id":2,"createtime":1673599277484,"updatetime":1673599277484,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":1,"initusdt":"7500"}]}

curl -X POST -d '{"method":"querySubAccount","params":["subrisk2"]}' http://127.0.0.1:8889/strategy 
{"method":"querySubAccount","result":[{"name":"subrisk2","id":3,"createtime":1673675284146,"updatetime":1673675284146,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":1,"initusdt":"7500"}]}


4. 创建策略

# risk subrisk1 testrisk1 39191
curl -X POST -d '{"method":"hello","params":["testrisk1","risk","subrisk1","127.0.0.1",39191]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testrisk1\" , \"time\":1673600395446, \"id\":1}"}

# nohup python3 -u main_risk1.py -n testrisk1 -s 8889 -c 39191 -X BTCUSDT -p 3m -w 40 -d 2 -T 0.5 -t 5000 >> log_risk1.log 2>&1 &

查询策略信息
curl -X POST -d '{"method":"queryStrategyInfo","params":["testrisk1"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testrisk1","time":1673600395446,"mainID":1,"subID":2,"strategyID":1,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}
{"method":"queryStrategyInfo","result":[{"name":"testrisk1","time":1673675393921,"mainID":1,"subID":2,"strategyID":1,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"hello","params":["testrisk2","risk","subrisk2","127.0.0.1",39192]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testrisk2\" , \"time\":1673875215258, \"id\":2}"}


5. 划转交易所U本位合约资产到 子账户u本位    8为该划转类型的值
# risk subrisk1 testrisk1 39191 7500  
curl -X POST -d '{"method":"accountTransfer","params":["risk","subrisk1","testrisk1","USDT","7500",8]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# risk subrisk1 testrisk1 39191 7500  
划转子账户u本位合约资产到 策略u本位      16为该划转类型的值
curl -X POST -d '{"method":"accountTransfer","params":["risk","subrisk1","testrisk1","USDT","7500",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

查询合约资产
curl -X POST -d '{"method":"queryContractAssets","params":["testrisk1","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"7500","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"0","shortfree":"0","type":1}]}

查询市价单合约资产
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testrisk1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"15000","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"15000","shortfree":"15000","type":1}]}

查询限价单合约资产
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testrisk1","USDT","BTCUSDT","17000"]}' http://127.0.0.1:8889/strategy
{"method":"queryLimitTradeContractAssets","result":[{"asset":"USDT","free":"15000","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"15000","shortfree":"10787.246249720256770791231162","type":1}]}

查询币安查询限价单
curl -X POST -d '{"method":"queryLimitOrder","params":["testrisk1",1657814400000,0,5]}' http://127.0.0.1:8889/strategy

取消订阅定时器
curl -X POST -d '{"method":"cancelSubTimer","params":["testrisk1",60000]}' http://127.0.0.1:8889/strategy


curl -X POST -d '{"method":"accountTransfer","params":["risk","subrisk2","testrisk2","USDT","7500",8]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}
curl -X POST -d '{"method":"accountTransfer","params":["risk","subrisk2","testrisk2","USDT","7500",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

curl -X POST -d '{"method":"queryTradeContractAssets","params":["testrisk2","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"15000","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"15000","shortfree":"15000","type":1}]}


----fil-V5.1--test--subkline1--kline--15000--20230113---








----fil-V3.5--test--subtest1--testorder1--39091--10000--

2. 创建主账户
curl -X POST -d '{"method":"createMainAccount","params":["test",0,2]}' http://127.0.0.1:8889/strategy

查询币安U本位账户
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["kline"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1670129376088}],"positions":[]}]}

curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["test"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1669195646132}],"positions":[]}]}

查询币安U本位账户风险
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["test","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"0","unRealizedProfit":"0","liquidationPrice":"0","leverage":"20","maxNotionalValue":"1000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}

{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0.603","entryPrice":"16523.31304052","markPrice":"17021.22883106","unRealizedProfit":"300.24322169","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"10263.80098512","isolatedWallet":"0","updateTime":1670131310786}]}]}

查询币安U本位仓位模式  true 为双向持仓  false 为单向持仓
curl -X POST -d '{"method":"queryBinanceUsdtPositionSide","params":["test"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtPositionSide","result":[{"dualSidePosition":false}]}

修改币安U本位仓位模式   true为双向持仓  false为单向持仓
curl -X POST -d '{"method":"chansubtest1geBinanceUsdtPositionSide","params":["test","false"]}' http://127.0.0.1:8889/strategy

修改币安U本位杠杆大小 20x 2x
curl -X POST -d '{"method":"changeBinanceUsdtLeverage","params":["test","BTCUSDT",2]}' http://127.0.0.1:8889/strategy
{"method":"changeBinanceUsdtLeverage","success":true,"message":"{\"leverage\":2, \"maxNotionalValue\":300000000,\"symbol\":BTCUSDT}"}

查询市价单合约资产
curl -X POST -d '{"method":"queryTradeContractAssets","params":["subtest1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy

查询限价单合约资产
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["subtest1","USDT","BTCUSDT","17000"]}' http://127.0.0.1:8889/strategy


3. 创建子账户   
name subtest1 ,	accountid 5 , mainAccountID 2 , 1w
curl -X POST -d '{"method":"createSubAccount","params":["subtest1",2,"10000.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}

name subtest2 , accountid 6 , mainAccountID 2 , 5K
curl -X POST -d '{"method":"createSubAccount","params":["subtest2",2,"5000.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}


4. 创建策略
# test subtest1 testorder1 id:2-5-4 39091 
curl -X POST -d '{"method":"hello","params":["testorder1","test","subtest1","127.0.0.1",39091]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testorder1\" , \"time\":1669255389793, \"id\":4}"}

运行策略
nohup python3 -u main_trade.py -n testorder1 -s 8889 -c 39091 -X BTCUSDT -p 3m -w 40 -d 2 -T 0.5 -t 10000 >> log_order.log 2>&1 &


curl -X POST -d '{"method":"hello","params":["testkline6","test","subtest2","127.0.0.1",39092]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testkline6\" , \"time\":1669277836462, \"id\":5}"}

# nohup python3 -u main_kline.py -n testkline6 -s 8889 -c 39092 -X BTCUSDT -p 10m -w 40 -d 2 -T 0.5 -t 5000 >> log_kline6.log 2>&1 &


5. 划转交易所U本位合约资产到 子账户u本位    8为该划转类型的值
# test subtest1 3000 testorder1 
curl -X POST -d '{"method":"accountTransfer","params":["test","subtest1","testorder1","USDT","10000.0",8]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

curl -X POST -d '{"method":"accountTransfer","params":["test","subtest2","testkline6","USDT","5000.0",8]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# test subtest1 testorder1 1000
划转子账户u本位合约资产到 策略u本位      16为该划转类型的值
curl -X POST -d '{"method":"accountTransfer","params":["test","subtest1","testorder1","USDT","10000.0",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

curl -X POST -d '{"method":"accountTransfer","params":["test","subtest2","testkline6","USDT","5000.0",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

查询币安查询限价单
curl -X POST -d '{"method":"queryLimitOrder","params":["testorder1",1657814400000,0,5]}' http://127.0.0.1:8889/strategy
{"method":"queryLimitOrder","result":[{"clientorderid":"467F1670148405434I0L4","symbol":"BTCUSDT","gatewayorderid":3258773512,"quantity":"0.001","price":"16000","stopprice":"0","type":"LIMIT","side":"BUY","status":"NEW","positionside":"BOTH","createtime":1670148403450,"updatetime":1670148403450,"tradetype":1,"fixtype":0,"selfid":467,"filltrades":[],"gatetype":0,"orderforce":"GTC"},{"clientorderid":"472F1670232541495I0L4","symbol":"BTCUSDT","gatewayorderid":3258981856,"quantity":"0.001","price":"26000","stopprice":"0","type":"LIMIT","side":"SELL","status":"NEW","positionside":"BOTH","createtime":1670232539073,"updatetime":1670232539073,"tradetype":1,"fixtype":0,"selfid":472,"filltrades":[],"gatetype":0,"orderforce":"GTC"},{"clientorderid":"474F1670232810769I0L4","symbol":"BTCUSDT","gatewayorderid":3258982867,"quantity":"0.001","price":"26000","stopprice":"0","type":"LIMIT","side":"SELL","status":"NEW","positionside":"BOTH","createtime":1670232808737,"updatetime":1670232808737,"tradetype":1,"fixtype":0,"selfid":474,"filltrades":[],"gatetype":0,"orderforce":"GTC"},{"clientorderid":"492F1670730762416I0L4","symbol":"BTCUSDT","gatewayorderid":3261712680,"quantity":"0.001","price":"26000","stopprice":"0","type":"LIMIT","side":"SELL","status":"NEW","positionside":"BOTH","createtime":1670730760405,"updatetime":1670730760405,"tradetype":1,"fixtype":0,"selfid":492,"filltrades":[],"gatetype":0,"orderforce":"GTC"},{"clientorderid":"502F1670833019454I0L4","symbol":"BTCUSDT","gatewayorderid":3262249282,"quantity":"0.001","price":"26000","stopprice":"0","type":"LIMIT","side":"SELL","status":"NEW","positionside":"BOTH","createtime":1670833017384,"updatetime":1670833017384,"tradetype":1,"fixtype":0,"selfid":502,"filltrades":[],"gatetype":0,"orderforce":"GTC"}]}

查询策略信息
curl -X POST -d '{"method":"queryStrategyInfo","params":["testorder1"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testorder1","time":1669255389793,"mainID":2,"subID":5,"strategyID":4,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["testkline6"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testkline6","time":1669277836462,"mainID":2,"subID":6,"strategyID":5,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

查询合约资产
curl -X POST -d '{"method":"queryContractAssets","params":["testorder1","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"9966.5739204","total":"9999.9814704","margin":"33.13965109978","unreal":"-0.26789890022","lock":"0","longfree":"0","shortfree":"0","type":1}]}
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"-298.68127138247","total":"9999.9814704","margin":"34.16058300094","unreal":"0.75303300094","lock":"0","syslock":"10265.25519178247","longfree":"0","shortfree":"0","type":1}]}

curl -X POST -d '{"method":"queryContractAssets","params":["testkline6","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"5000","total":"5000","margin":"0","unreal":"0","lock":"0","longfree":"0","shortfree":"0","type":1}]}


查询仓位   仓位方向 long值从0改为1  short值从1改为-1

curl -X POST -d '{"method":"queryPositions","params":["testorder1","BTCUSDT",1]}' http://127.0.0.1:8889/strategy
{"method":"queryPositions","result":[{"symbol":"BTCUSDT","positionAmount":"0.002","enterprice":"16703.775","countrevence":"-0.01185","unrealprofit":"0.24984862588","marginmodel":0,"isolatedmargin":"0","positionside":1,"markprice":"16828.69931294","type":1}]}

{"method":"queryPositions","result":[{"symbol":"BTCUSDT","positionAmount":"0.002","enterprice":"16703.775","countrevence":"-0.01185","unrealprofit":"0.92251859096","marginmodel":0,"isolatedmargin":"0","positionside":1,"markprice":"17165.03429548","type":1}]}

{"method":"queryPositions","result":[{"symbol":"BTCUSDT","positionAmount":"0.003","enterprice":"16825.7833333333333316","countrevence":"-0.01185","unrealprofit":"0.5625377306300000052","marginmodel":0,"isolatedmargin":"0","positionside":1,"markprice":"17013.29591021","type":1}]}

curl -X POST -d '{"method":"queryPositions","params":["testorder1","BTCUSDT",-1]}' http://127.0.0.1:8889/strategy
{"method":"queryPositions","result":[]}


查询市价单合约资产 queryTradeContractAssets
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testorder1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"9705.50889916239","total":"9999.9814704","margin":"34.14623305278","unreal":"0.73868305278","lock":"0","syslock":"10261.04649163761","longfree":"9705.50889916239","shortfree":"9739.65513221517","type":1}]}


查询限价单合约资产
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testorder1","USDT","BTCUSDT","20000"]}' http://127.0.0.1:8889/strategy


取消订阅定时器
curl -X POST -d '{"method":"cancelSubTimer","params":["testorder1",60000]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"cancelSubTimer","params":["testkline7",60000]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"cancelSubTimer","params":["testkline8",60000]}' http://127.0.0.1:8889/strategy


----fil-V3.7--kline--subkline1--testkline7--10000--39094--


curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["kline"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1670129376088}],"positions":[]}]}

curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"17015.11426414","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}

curl -X POST -d '{"method":"createMainAccount","params":["kline",0,3]}' http://127.0.0.1:8889/strategy
{"method":"createMainAccount","success":true,"message":""}

curl -X POST -d '{"method":"createSubAccount","params":["subkline1",3,"10000.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}


curl -X POST -d '{"method":"hello","params":["testkline1","kline","subkline1","127.0.0.1",39094]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testkline1\" , \"time\":1670262525046, \"id\":6}"}

testkline1 6  39093 

curl -X POST -d '{"method":"hello","params":["testkline7","kline","subkline1","127.0.0.1",39094]}' http://127.0.0.1:8889/strategy 
testkline7 7  39094 
{"method":"hello","success":true,"message":"{\"name\":\"testkline7\" , \"time\":1671441894524, \"id\":7}"}

curl -X POST -d '{"method":"accountTransfer","params":["kline","subkline1","testkline7","USDT","10000",8]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":false,"message":"mainaccount's free not enough. free:0"}


curl -X POST -d '{"method":"accountTransfer","params":["kline","subkline1","testkline7","USDT","10000",16]}' http://127.0.0.1:8889/strategy


curl -X POST -d '{"method":"queryTradeContractAssets","params":["testkline7","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeCo
ntractAssets","result":[{"asset":"USDT","free":"20000","total":"10000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"20000","shortfree":"20000","type":1}]}

curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testkline7","USDT","BTCUSDT","20000"]}' http://127.0.0.1:8889/strategy
{"method":"queryLimitTradeContractAssets","result":[{"asset":"USDT","free":"20000","total":"10000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"14652.851090795279256957251354","shortfree":"20000","type":1}]}

查询合约资产 
curl -X POST -d '{"method":"queryContractAssets","params":["testkline7","USDT"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryStrategyInfo","params":["testkline7"]}' http://127.0.0.1:8889/strategy

查询币安U本位账户风险 
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"0","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}

查询币安查询限价单 
curl -X POST -d '{"method":"queryLimitOrder","params":["testkline7",1657814400000,0,5]}' http://127.0.0.1:8889/strategy



----fil-V3.7--kline--subkline2--testkline8--39095--5000--

curl -X POST -d '{"method":"createMainAccount","params":["kline",0,1]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"createSubAccount","params":["subkline2",3,"5000.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}


curl -X POST -d '{"method":"hello","params":["testkline8","kline","subkline2","127.0.0.1",39095]}' http://127.0.0.1:8889/strategy 
{"method":"hello","success":true,"message":"{\"name\":\"testkline8\" , \"time\":1673429906629, \"id\":8}"}

testkline8 8  39095 

curl -X POST -d '{"method":"accountTransfer","params":["kline","subkline2","testkline8","USDT","5000",8]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

curl -X POST -d '{"method":"accountTransfer","params":["kline","subkline2","testkline8","USDT","5000",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

curl -X POST -d '{"method":"queryTradeContractAssets","params":["testkline8","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"2000","total":"1000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"2000","shortfree":"2000","type":1}]}

{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"-10871.12","total":"5000","margin":"0","unreal":"0","lock":"10435.56","syslock":"10435.56","longfree":"-10871.12","shortfree":"-435.56","type":1}]}

curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testkline8","USDT","BTCUSDT","20000"]}' http://127.0.0.1:8889/strategy

查询合约资产 
curl -X POST -d '{"method":"queryContractAssets","params":["testkline8","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":{"method":"queryContractAssets","result":[{"asset":"USDT","free":"5000","total":"5000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"0","shortfree":"0","type":1}]}

{"method":"queryContractAssets","result":[{"asset":"USDT","free":"-15881.47","total":"5000","margin":"0","unreal":"0","lock":"10440.735","syslock":"10440.735","longfree":"0","shortfree":"0","type":1}]}



curl -X POST -d '{"method":"queryStrategyInfo","params":["testkline8"]}' http://127.0.0.1:8889/strategy

查询币安U本位账户风险 
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline","BTCUSDT"]}' http://127.0.0.1:8889/strategy

查询币安查询限价单 
curl -X POST -d '{"method":"queryLimitOrder","params":["testkline8",1657814400000,0,5]}' http://127.0.0.1:8889/strategy






----fil-V3.5--real----


1. 启动主程
# cd /root/FIL/fil && nohup ./FIL run -c ./config.json -k ./key2.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 & 

cd /root/binancefuture/crypto/fil && nohup ./FIL run -c ./config.json -k ./key.json >> ../logs/screenlog_Fil_bash_0.log 2>&1 & 

cd /root/binancefuture/crypto/fil && nohup ./FIL_1129 run -c ./config.json -k ./key.json >> ../logs/screenlog_Fil_bash_0.log 2>&1 & 


curl -X POST -d '{"method":"hello","params":["testorder1","test","subtest1","127.0.0.1",39091]}' http://127.0.0.1:8889/strategy


2. 创建主账户 母账户
curl -X POST -d '{"method":"createMainAccount","params":["kline",0,1]}' http://127.0.0.1:8889/strategy
{"method":"createMainAccount","success":true,"message":""}

查询主账户
curl -X POST -d '{"method":"queryMainAccount","params":["kline"]}' http://127.0.0.1:8889/strategy 
{"method":"queryMainAccount","result":[{"name":"kline","id":1,"createtime":1673616996654,"updatetime":1673616996654,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"type":0,"tradetype":1,"keyid":1}]}

查询币安U本位账户 
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["kline"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"0","totalCrossUnPnl":"0","availableBalance":"0","maxWithdrawAmount":"0","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"0","crossUnPnl":"0","availableBalance":"0","maxWithdrawAmount":"0","marginAvailable":true,"updateTime":1672741455774}],"positions":[]}]}

查询币安U本位账户风险 母账户
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"0","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}

查询币安U本位仓位模式  true为双向持仓  false为单向持仓  母账户
curl -X POST -d '{"method":"queryBinanceUsdtPositionSide","params":["kline"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtPositionSide","result":[{"dualSidePosition":false}]}

创建子账户   
curl -X POST -d '{"method":"createSubAccount","params":["subkline7",1,"7500.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}
curl -X POST -d '{"method":"createSubAccount","params":["subkline8",1,"7500.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}

查询子账户
curl -X POST -d '{"method":"querySubAccount","params":["subkline7"]}' http://127.0.0.1:8889/strategy 
{"method":"querySubAccount","result":[{"name":"subkline7","id":2,"createtime":1673618767792,"updatetime":1673618767792,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":1,"initusdt":"7500"}]}

curl -X POST -d '{"method":"hello","params":["testkline7","kline","subkline7","127.0.0.1",39094]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testkline7\" , \"time\":1673618812306, \"id\":1}"}
curl -X POST -d '{"method":"hello","params":["testkline8","kline","subkline8","127.0.0.1",39095]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testkline8\" , \"time\":1673618837678, \"id\":2}"}


查询策略信息
curl -X POST -d '{"method":"queryStrategyInfo","params":["testkline7"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testkline7","time":1673618812306,"mainID":1,"subID":2,"strategyID":1,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"accountTransfer","params":["kline","subkline7","testkline7","USDT","500.0",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["kline","subkline7","testkline7","USDT","7500.0",16]}' http://127.0.0.1:8889/strategy





查询市价单合约资产 
curl -X POST -d '{"method":"queryTradeContractAssets","params":["subtest1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy

查询限价单合约资产
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["subtest1","USDT","BTCUSDT","17000"]}' http://127.0.0.1:8889/strategy



2. 创建主账户 母账户
创建主账户 母账户
curl -X POST -d '{"method":"createMainAccount","params":["test",0,1]}' http://127.0.0.1:8889/strategy
{"method":"createMainAccount","success":true,"message":""}

查询币安U本位账户 
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["test"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1670129376088}],"positions":[]}]}

查询币安U本位账户风险 母账户
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["test","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"17251.31592057","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}

查询币安U本位仓位模式  true为双向持仓  false为单向持仓  母账户
curl -X POST -d '{"method":"queryBinanceUsdtPositionSide","params":["test"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtPositionSide","result":[{"dualSidePosition":false}]}

修改币安U本位仓位模式   true为双向持仓  false为单向持仓 母账户
curl -X POST -d '{"method":"changeBinanceUsdtPositionSide","params":["test","false"]}' http://127.0.0.1:8889/strategy

修改币安U本位杠杆大小 20x 2x 母账户
curl -X POST -d '{"method":"changeBinanceUsdtLeverage","params":["test","BTCUSDT",2]}' http://127.0.0.1:8889/strategy
{"method":"changeBinanceUsdtLeverage","success":true,"message":"{\"leverage\":2, \"maxNotionalValue\":300000000,\"symbol\":BTCUSDT}"}

查询市价单合约资产 
curl -X POST -d '{"method":"queryTradeContractAssets","params":["subtest1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy

查询限价单合约资产
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["subtest1","USDT","BTCUSDT","17000"]}' http://127.0.0.1:8889/strategy


3. 创建子账户   
name subtest1 ,	accountid 2 , mainAccountID 1 , 1w
curl -X POST -d '{"method":"createSubAccount","params":["subtest1",1,"10000.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}
{"method":"createSubAccount","success":false,"message":"main account not found."}


name subtest2 , accountid 3 , mainAccountID 1 , 5K
curl -X POST -d '{"method":"createSubAccount","params":["subtest2",1,"5000.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}


4. 创建策略
# test subtest1 testorder1 id:1-2-1 39091 
curl -X POST -d '{"method":"hello","params":["testorder1","test","subtest1","127.0.0.1",39091]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testorder1\" , \"time\":1670246108844, \"id\":1}"}

运行策略
nohup python3 -u main_trade.py -n testorder1 -s 8889 -c 39091 -X BTCUSDT -p 3m -w 40 -d 2 -T 0.5 -t 10000 >> log_order.log 2>&1 &


curl -X POST -d '{"method":"hello","params":["testkline6","test","subtest2","127.0.0.1",39092]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testkline6\" , \"time\":1669277836462, \"id\":5}"}

# nohup python3 -u main_kline.py -n testkline6 -s 8889 -c 39092 -X BTCUSDT -p 10m -w 40 -d 2 -T 0.5 -t 5000 >> log_kline6.log 2>&1 &



5. 划转交易所U本位合约资产到 子账户u本位    8为该划转类型的值 FIL_1121
# test subtest1 3000 testorder1 
curl -X POST -d '{"method":"accountTransfer","params":["test","subtest1","testorder1","USDT","10000.0",8]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

curl -X POST -d '{"method":"accountTransfer","params":["test","subtest2","testkline6","USDT","5000.0",8]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# test subtest1 testorder1 1000
划转子账户u本位合约资产到 策略u本位      16为该划转类型的值
curl -X POST -d '{"method":"accountTransfer","params":["test","subtest1","testorder1","USDT","10000.0",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

curl -X POST -d '{"method":"accountTransfer","params":["test","subtest2","testkline6","USDT","5000.0",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}


查询策略信息
curl -X POST -d '{"method":"queryStrategyInfo","params":["testorder1"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testorder1","time":1670246108844,"mainID":1,"subID":2,"strategyID":1,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["testkline6"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testkline6","time":1669277836462,"mainID":2,"subID":6,"strategyID":5,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

查询合约资产
curl -X POST -d '{"method":"queryContractAssets","params":["testorder1","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"9966.5739204","total":"9999.9814704","margin":"33.13965109978","unreal":"-0.26789890022","lock":"0","longfree":"0","shortfree":"0","type":1}]}
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"-298.68127138247","total":"9999.9814704","margin":"34.16058300094","unreal":"0.75303300094","lock":"0","syslock":"10265.25519178247","longfree":"0","shortfree":"0","type":1}]}

curl -X POST -d '{"method":"queryContractAssets","params":["testkline6","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"5000","total":"5000","margin":"0","unreal":"0","lock":"0","longfree":"0","shortfree":"0","type":1}]}


查询仓位   仓位方向 long值从0改为1  short值从1改为-1

curl -X POST -d '{"method":"queryPositions","params":["testorder1","BTCUSDT",1]}' http://127.0.0.1:8889/strategy
{"method":"queryPositions","result":[{"symbol":"BTCUSDT","positionAmount":"0.002","enterprice":"16703.775","countrevence":"-0.01185","unrealprofit":"0.24984862588","marginmodel":0,"isolatedmargin":"0","positionside":1,"markprice":"16828.69931294","type":1}]}

{"method":"queryPositions","result":[{"symbol":"BTCUSDT","positionAmount":"0.002","enterprice":"16703.775","countrevence":"-0.01185","unrealprofit":"0.92251859096","marginmodel":0,"isolatedmargin":"0","positionside":1,"markprice":"17165.03429548","type":1}]}

{"method":"queryPositions","result":[{"symbol":"BTCUSDT","positionAmount":"0.003","enterprice":"16825.7833333333333316","countrevence":"-0.01185","unrealprofit":"0.5625377306300000052","marginmodel":0,"isolatedmargin":"0","positionside":1,"markprice":"17013.29591021","type":1}]}

curl -X POST -d '{"method":"queryPositions","params":["testorder1","BTCUSDT",-1]}' http://127.0.0.1:8889/strategy
{"method":"queryPositions","result":[]}


查询市价单合约资产 queryTradeContractAssets
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testorder1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"9705.50889916239","total":"9999.9814704","margin":"34.14623305278","unreal":"0.73868305278","lock":"0","syslock":"10261.04649163761","longfree":"9705.50889916239","shortfree":"9739.65513221517","type":1}]}

queryTradeContractAssets: assets=ContractAssetReturn{'result': [ContractAsset{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'asset': 'USDT', 'free': '9302.586576873524859998273995', 'total': '10000.837958025156442282481248', 'margin': '83.6538317968', 'unreal': '-0.93184914455802458420725341450724', 'lock': '279.84550926045', 'syslock': '10334.65814897498', 'longfree': '9516.239787055894859998273995', 'shortfree': '9452.432707748404859998273995', 'type': 'AssetType_ucontract'}]}


查询限价单合约资产
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testorder1","USDT","BTCUSDT","20000"]}' http://127.0.0.1:8889/strategy



----Trace-V2------

ps aux | grep python3 | grep 8808 | grep -v grep | awk '{print $2}'| xargs kill -9
kill -9 xxxxx

启动/重启Trace
cd /root/FIL/trace &&  nohup ./Trace run -c ./config.json  >> /root/FIL/logs/screenlog_Trace2_bash_0.log  2>&1  &



curl -X POST -d '{"method":"hello","params":["testStrategy","testMain","testSub","127.0.0.1",29090]}' http://127.0.0.1:8808/strategy
curl -X POST -d '{"method":"hello","params":["pyemd2","testMain","testSub","127.0.0.1",29091]}' http://127.0.0.1:8808/strategy



1.创建主账户
curl -X POST -d '{"method":"createMainAccount","params":["multiaccount",3,0]}' http://127.0.0.1:8808/strategy

2.充值
curl -X POST -d '{"method":"recharge","params":["multiaccount","USDT","10000000.0"]}' http://127.0.0.1:8808/strategy

3.创建子账户
curl -X POST -d '{"method":"createSubAccount","params":["submulti1",3,"1000000.0"]}' http://127.0.0.1:8808/strategy
curl -X POST -d '{"method":"createSubAccount","params":["submain",2,"10000000.0"]}' http://127.0.0.1:8808/strategy

testMain 2 , 	  submain   16  ,  3kw, 
multiaccount 3  , submulti1 11  ,  testmulti1  7  19001

4.创建策略
curl -X POST -d '{"method":"hello","params":["testmulti1","multiaccount","submulti1","127.0.0.1",19001]}' http://127.0.0.1:8808/strategy

5.策略划转现货至U本位合约
curl -X POST -d '{"method":"accountTransfer","params":["multiaccount","submulti1","testmulti1","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy

6. 客户端启动策略
python3 main.py -n testmulti1 -s 8808 -c 19001 -X BTCUSDT  -t 1000000
nohup python3 main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1 &

7. 查询策略持仓 多0 空1
curl -X POST -d '{"method":"queryPositions","params":["testmulti1","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

8. 查询策略合约价值
curl -X POST -d '{"method":"queryContractAssets","params":["testmulti1","USDT"]}' http://127.0.0.1:8808/strategy

9... 

----testmulti11-------------------------

multiaccount 3  , submulti2 12  ,  testmulti11  17  19011

curl -X POST -d '{"method":"hello","params":["testmulti11","multiaccount","submulti2","127.0.0.1",19011]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryPositions","params":["testmulti11","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["testmulti11","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 



----testmulti12-------------------------

multiaccount 3  , submulti2 12  ,  testmulti12  18  19012

curl -X POST -d '{"method":"hello","params":["testmulti12","multiaccount","submulti2","127.0.0.1",19012]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryPositions","params":["testmulti12","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["testmulti12","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 


curl -X POST -d '{"method":"queryContractAssets","params":["testmulti12","USDT"]}' http://127.0.0.1:8808/strategy

----testmulti20-------------------------

multiaccount 3  , submulti2 12  ,  testmulti20  26  19020

curl -X POST -d '{"method":"hello","params":["testmulti20","multiaccount","submulti2","127.0.0.1",19020]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryPositions","params":["testmulti20","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["testmulti20","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 


----testmulti19-------------------------

multiaccount 3  , submulti2 12  ,  testmulti19  25  19019 ,  BATUSDT   JASMYUSDT

curl -X POST -d '{"method":"hello","params":["testmulti19","multiaccount","submulti2","127.0.0.1",19019]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryPositions","params":["testmulti19","BATUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["testmulti19","BATUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["testmulti19","USDT"]}' http://127.0.0.1:8808/strategy

nohup python3 testTrade.py -n testmulti19 -s 8808 -c 19019 -X BATUSDT -p 5m -w 84 -d 42 -t 1000000  >> log.txt 2>&1 &


----testStrategy---similarity-------

testMain 2  , testSub 4  ,  testStrategy  2  29090

curl -X POST -d '{"method":"hello","params":["testStrategy","testMain","testSub","127.0.0.1",29090]}' http://127.0.0.1:8808/strategy


curl -X POST -d '{"method":"queryPositions","params":["testStrategy","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["testStrategy","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["testStrategy","USDT"]}' http://127.0.0.1:8808/strategy

. similarityStart.sh

----pyemd2-------------------------

testMain 2  , testSub 4  ,  pyemd2  2  29091

curl -X POST -d '{"method":"hello","params":["pyemd2","testMain","testSub","127.0.0.1",29091]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryPositions","params":["pyemd2","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["pyemd2","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["pyemd2","USDT"]}' http://127.0.0.1:8808/strategy

. pyemdStart.sh

----modifiedmom-------------------------

testMain 2  , submain  16  ,  modifiedmom  2  ~ 59 , 1M,  29093

curl -X POST -d '{"method":"hello","params":["modifiedmom","testMain","submain","127.0.0.1",29093]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryPositions","params":["modifiedmom","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["modifiedmom","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["modifiedmom","USDT"]}' http://127.0.0.1:8808/strategy


curl -X POST -d '{"method":"accountTransfer","params":["testMain","submain","modifiedmom","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy


nohup python3 -u main.py -n modifiedmom -s 8808 -c 29093 -X BTCUSDT -p 10m -w 71 -d 3 -T 0 -t 1000000  >> log.txt 2>&1  &

. modifiedmomStart.sh

----factorcheck-------------------------

testMain 2  , submain  16  30M,  factorcheck  2  ~ 59 , 1M,  29094

curl -X POST -d '{"method":"queryPositions","params":["factorcheck","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["factorcheck","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["factorcheck","USDT"]}' http://127.0.0.1:8808/strategy



curl -X POST -d '{"method":"hello","params":["factorcheck","testMain","submain","127.0.0.1",29094]}' http://127.0.0.1:8808/strategy

	curl -X POST -d '{"method":"close","params":["factorcheck"]}' http://127.0.0.1:8808/strategy

	curl -X POST -d '{"method":"queryStrategyInfo","params":["factorcheck"]}' http://127.0.0.1:8808/strategy


curl -X POST -d '{"method":"accountTransfer","params":["testMain","submain","factorcheck","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy


nohup python3 -u main.py -n factorcheck -s 8808 -c 29094 -X BTCUSDT -p 5m -w 40 -I 50 -d 2 -T 0.6 -t 1000000  >> log.txt 2>&1  &


----factorcheck2-------------------------

testMain 2  , submain  16  30M,  factorcheck2  2  ~ 59 , 1M,  29095

curl -X POST -d '{"method":"queryPositions","params":["factorcheck2","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["factorcheck2","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["factorcheck2","USDT"]}' http://127.0.0.1:8808/strategy



curl -X POST -d '{"method":"hello","params":["factorcheck2","testMain","submain","127.0.0.1",29095]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"accountTransfer","params":["testMain","submain","factorcheck2","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy


nohup python3 -u main.py -n factorcheck2 -s 8808 -c 29095 -X BTCUSDT -p 5m -w 40 -I 50 -d 2 -T 0.6 -t 1000000  >> log.txt 2>&1  &

. factorcheckStart.sh



----logic-------------------------

testMain 2  , submain  16  30M,  logic  2  ~ 59 , 1M,  29096



curl -X POST -d '{"method":"hello","params":["logic","testMain","submain","127.0.0.1",29096]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"accountTransfer","params":["testMain","submain","logic","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy


curl -X POST -d '{"method":"queryPositions","params":["logic","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["logic","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["logic","USDT"]}' http://127.0.0.1:8808/strategy


curl -X POST -d '{"method":"closeAllPosition","params":["logic"]}' http://127.0.0.1:8808/strategy 


nohup python3 -u main.py -n logic -s 8808 -c 29096 -X BTCUSDT -p 30m -w 40 -I 50 -d 120 -T 0.55 -t 1000000  >> log.txt 2>&1  &

. logicStart.sh

PositionSide_LONG	Long  0    1
PositionSide_SHORT	Short 1   -1


----s_rsrs-------------------------

testMain 2  , submain  16  30M,  s_rsrs  2  ~ 59 , 1M,  29097


curl -X POST -d '{"method":"hello","params":["s_rsrs","testMain","submain","127.0.0.1",29097]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"accountTransfer","params":["testMain","submain","s_rsrs","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryPositions","params":["s_rsrs","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["s_rsrs","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["s_rsrs","USDT"]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"closeAllPosition","params":["s_rsrs"]}' http://127.0.0.1:8808/strategy 

nohup python3 -u main.py -n s_rsrs -s 8808 -c 29097 -X BTCUSDT -p 4h -w 40 -I 50 -d 120 -T 0.55 -t 1000000  >> log.txt 2>&1  &

. s_rsrsStart.sh


----amihud-------------------------

testMain 2  , submain  16  30M,  amihud  66 , 2  ~ 59 , 1M,  29098


curl -X POST -d '{"method":"hello","params":["amihud","testMain","submain","127.0.0.1",29098]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"accountTransfer","params":["testMain","submain","amihud","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryPositions","params":["amihud","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["amihud","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["amihud","USDT"]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"closeAllPosition","params":["amihud"]}' http://127.0.0.1:8808/strategy 

# nohup python3 -u main.py -n amihud -s 8808 -c 29098 -X BTCUSDT -p 5m -w 144 -I 25 -d 20 -T 0.8 -H 2.5 -t 1000000 >> log.txt 2>&1 & 

. amihudStart.sh


----sr_min-------------------------

testMain 2  , submain  16  30M,  sr_min  67 , 2  ~ 59 , 1M,  29099


curl -X POST -d '{"method":"hello","params":["sr_min","testMain","submain","127.0.0.1",29099]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"accountTransfer","params":["testMain","submain","sr_min","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryPositions","params":["sr_min","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["sr_min","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["sr_min","USDT"]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"closeAllPosition","params":["sr_min"]}' http://127.0.0.1:8808/strategy 

# nohup python3 -u main.py -n sr_min -s 8808 -c 29099 -X BTCUSDT -p 5m -w 192 -I 10 -d 20 -T 0.88 -H 4.0 -t 1000000 >> log.txt 2>&1 &

. sr_minStart.sh


----percentile_regression_step2-------------------------

testMain 2  , submain  16  30M,  percentile_regression_step2  67 , 2  ~ 59 , 1M,  29100


curl -X POST -d '{"method":"hello","params":["percentile_regression_step2","testMain","submain","127.0.0.1",29100]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"accountTransfer","params":["testMain","submain","percentile_regression_step2","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryPositions","params":["percentile_regression_step2","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 
curl -X POST -d '{"method":"queryPositions","params":["percentile_regression_step2","BTCUSDT",1]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryContractAssets","params":["percentile_regression_step2","USDT"]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"closeAllPosition","params":["percentile_regression_step2"]}' http://127.0.0.1:8808/strategy 


# nohup python3 -u main.py -n percentile_regression_step2 -s 8808 -c 29100 -X BTCUSDT -p 30m -w 140 -I 20 -T 10 -t 1000000  >> log.txt 2>&1  &

. pRegressionStepStart.sh



------


ngrok config add-authtoken 2DA1ur90IFUef5dFJq9gCo0Su0W_7gdHQpB9r2XVc1MFsk3e9
ngrok http 80

------

import requests
res = requests.get('https://myip.ipip.net', timeout=5).text
print(res)


------



from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Welcome to My Watchlist!'

app.run(host='0.0.0.0', port = 5000)


----top--------------------------


top -c -d 30  -n 2 -b 

01:06:48    当前时间
up 1:22    系统运行时间，格式为时:分
1 user    当前登录用户数
load average: 0.06, 0.60, 0.48    系统负载，即任务队列的平均长度。三个数值分别为 1分钟、5分钟、15分钟前到现在的平均值。


total 进程总数
running 正在运行的进程数
sleeping 睡眠的进程数
stopped 停止的进程数
zombie 僵尸进程数
Cpu(s): 
0.3% us 用户空间占用CPU百分比
1.0% sy 内核空间占用CPU百分比
0.0% ni 用户进程空间内改变过优先级的进程占用CPU百分比
98.7% id 空闲CPU百分比
0.0% wa 等待输入输出的CPU时间百分比
0.0%hi：硬件CPU中断占用百分比
0.0%si：软中断占用百分比
0.0%st：虚拟机占用百分比


Mem:
191272k total    物理内存总量
173656k used    使用的物理内存总量
17616k free    空闲内存总量
22052k buffers    用作内核缓存的内存量
Swap: 
192772k total    交换区总量
0k used    使用的交换区总量
192772k free    空闲交换区总量
123988k cached    缓冲的交换区总量,内存中的内容被换出到交换区，而后又被换入到内存，但使用过的交换区尚未被覆盖，该数值即为这些内容已存在于内存中的交换区的大小,相应的内存再次被换出时可不必再对交换区写入。


列名    含义
PID     进程id
PPID    父进程id
RUSER   Real user name
UID     进程所有者的用户id
USER    进程所有者的用户名
GROUP   进程所有者的组名
TTY     启动进程的终端名。不是从终端启动的进程则显示为 ?
PR      优先级
NI      nice值。负值表示高优先级，正值表示低优先级
P       最后使用的CPU，仅在多CPU环境下有意义
%CPU    上次更新到现在的CPU时间占用百分比
TIME    进程使用的CPU时间总计，单位秒
TIME+   进程使用的CPU时间总计，单位1/100秒
%MEM    进程使用的物理内存百分比
VIRT    进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES
SWAP    进程使用的虚拟内存中，被换出的大小，单位kb。
RES     进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA
CODE    可执行代码占用的物理内存大小，单位kb
DATA    可执行代码以外的部分(数据段+栈)占用的物理内存大小，单位kb
SHR     共享内存大小，单位kb
nFLT    页面错误次数
nDRT    最后一次写入到现在，被修改过的页面数。
S       进程状态(D=不可中断的睡眠状态,I-空闲,R=运行,S=睡眠,T=跟踪/停止,Z-退出=僵尸进程,X-退出=即将销毁)
COMMAND 命令名/命令行
WCHAN   若该进程在睡眠，则显示睡眠中的系统函数名
Flags   任务标志，参考 sched.h


----ps--------------------------
ps aux 
ps -elf


USER          进程所有者的用户名
PID           进程号
START         进程激活时间
%CPU          进程自最近一次刷新以来所占用的CPU时间和总时间的百分比
%MEM          进程使用内存的百分比
VSZ           进程使用的虚拟内存大小，以K为单位
RSS           驻留空间的大小。显示当前常驻内存的程序的K字节数。
TTY           进程相关的终端
STAT          进程状态，包括下面的状态： 
                     D    不可中断     Uninterruptible sleep (usually IO)
                     R    正在运行，或在队列中的进程
                     S    处于休眠状态
                     T    停止或被追踪
                     Z    僵尸进程
                     W    进入内存交换（从内核2.6开始无效）
                     X    死掉的进程
                     <    高优先级
                     N    低优先级
                     L    有些页被锁进内存
                     s    包含子进程
                     \+   位于后台的进程组；
                     l    多线程，克隆线程

TIME          进程使用的总CPU时间
COMMAND       被执行的命令行
NI            进程的优先级值，较小的数字意味着占用较少的CPU时间
PRI           进程优先级。
PPID          父进程ID
WCHAN         进程等待的内核事件名


----grep--------------------------

grep -inr XXX
grep -v grep 

grep [-abcEFGhHilLnqrsvVwxy][-A<显示列数>][-B<显示列数>][-C<显示列数>][-d<进行动作>][-e<范本样式>][-f<范本文件>][--help][范本样式][文件或目录...]

# 文本过滤工具,用于查找文件里符合条件的字符串

grep -i "hello world" -rl /home/tyrone | xargs grep -i "mailx"

grep -E "hello world|mailx" -r /home/tyrone

find /home/tyrone -name "*.txt" -exec grep -l "hello world" {} \; | xargs grep -i "mailx"


-a 或 --text : 不要忽略二进制的数据。
-A<显示行数> 或 --after-context=<显示行数> : 除了显示符合范本样式的那一列之外，并显示该行之后的内容。
-b 或 --byte-offset : 在显示符合样式的那一行之前，标示出该行第一个字符的编号。
-B<显示行数> 或 --before-context=<显示行数> : 除了显示符合样式的那一行之外，并显示该行之前的内容。
-c 或 --count : 计算符合样式的列数。
-C<显示行数> 或 --context=<显示行数>或-<显示行数> : 除了显示符合样式的那一行之外，并显示该行之前后的内容。
-d <动作> 或 --directories=<动作> : 当指定要查找的是目录而非文件时，必须使用这项参数，否则grep指令将回报信息并停止动作。
-e<范本样式> 或 --regexp=<范本样式> : 指定字符串做为查找文件内容的样式。
-E 或 --extended-regexp : 将样式为延伸的正则表达式来使用。
-f<规则文件> 或 --file=<规则文件> : 指定规则文件，其内容含有一个或多个规则样式，让grep查找符合规则条件的文件内容，格式为每行一个规则样式。
-F 或 --fixed-regexp : 将样式视为固定字符串的列表。
-G 或 --basic-regexp : 将样式视为普通的表示法来使用。
-h 或 --no-filename : 在显示符合样式的那一行之前，不标示该行所属的文件名称。
-H 或 --with-filename : 在显示符合样式的那一行之前，表示该行所属的文件名称。
-i 或 --ignore-case : 忽略字符大小写的差别。
-l 或 --file-with-matches : 列出文件内容符合指定的样式的文件名称。
-L 或 --files-without-match : 列出文件内容不符合指定的样式的文件名称。
-n 或 --line-number : 在显示符合样式的那一行之前，标示出该行的列数编号。
-o 或 --only-matching : 只显示匹配PATTERN 部分。
-q 或 --quiet或--silent : 不显示任何信息。
-r 或 --recursive : 此参数的效果和指定"-d recurse"参数相同。
-s 或 --no-messages : 不显示错误信息。
-v 或 --invert-match : 显示不包含匹配文本的所有行。
-V 或 --version : 显示版本信息。
-w 或 --word-regexp : 只显示全字符合的列。
-x --line-regexp : 只显示全列符合的列。
-y : 此参数的效果和指定"-i"参数相同。


----awk--------------------------


awk [选项参数] 'script' var=value file(s) 或 awk [选项参数] -f scriptfile var=value file(s)
# 文本分析工具

-F fs or --field-separator fs  #  指定输入文件折分隔符，fs是一个字符串或者是一个正则表达式，如-F:。
-v var=value or --asign var=value  #  赋值一个用户定义变量。
-f scripfile or --file scriptfile  # 从脚本文件中读取awk命令。
-mf nnn and -mr nnn  #  对nnn值设置内在限制，-mf选项限制分配给nnn的最大块数目 ；-mr选项限制记录的最大数目。这两个功能是Bell实验室版awk的扩展功能，在标准awk中不适用。
-W compact or --compat, -W traditional or --traditional  # 在兼容模式下运行awk。 所以gawk的行为和标准的awk完全一样，所有的awk扩展都被忽略。
-W copyleft or --copyleft, -W copyright or --copyright  #  打印简短的版权信息。
-W help or --help, -W usage or --usage  # 打印全部awk选项和每个选项的简短说明。
-W lint or --lint # 打印不能向传统unix平台移植的结构的警告。
-W lint-old or --lint-old  # 打印关于不能向传统unix平台移植的结构的警告。
-W posix  #  打开兼容模式。但有以下限制，不识别：/x、函数关键字、func、换码序列以及当fs是一个空格时， 将新行作为一个域分隔符；操作符**和**=不能代替^和^=；fflush无效。
-W re-interval or --re-inerval  # 允许间隔正则表达式的使用，参考(grep中的Posix字符类)，如括号表达式[[:alpha:]]。
-W source program-text or --source program-text # 使用program-text作为源代码，可与-f命令混用。
-W version or --version # 打印bug报告信息的版本。



----sed--------------------------

sed [-hnV][-e<script>][-f<script文件>][文本文件]
# 利用脚本来处理文本文件

-e<script>或--expression=<script> 以选项中指定的script来处理输入的文本文件。
-f<script文件>或--file=<script文件> 以选项中指定的script文件来处理输入的文本文件。
-i直接修改文件内容（危险操作）
-h或--help 显示帮助。
-n或--quiet或--silent 仅显示script处理后的结果。
-V或--version 显示版本信息。

a ：新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)～
c ：取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
d ：删除，因为是删除啊，所以 d 后面通常不接任何咚咚；
i ：插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
p ：打印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行～
s ：取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g 就是啦！


sed -in  's/青/蜀/g' text.txt  


#！/bin/bash

# echo $1

# 全角转半角 双字节字符转单字节 full2half
sed -i 's/：/:/g' $1
sed -i 's/；/;/g' $1
sed -i 's/！/!/g' $1
sed -i 's/。/. /g' $1
sed -i 's/，/, /g' $1
sed -i 's/、/, /g' $1
sed -i 's/？/?/g' $1
sed -i 's/％/%/g' $1
sed -i 's/（/(/g' $1
sed -i 's/）/)/g' $1
sed -i 's/《/</g' $1
sed -i 's/》/>/g' $1
sed -i 's/【/[/g' $1
sed -i 's/】/]/g' $1
sed -i 's/　/ /g' $1
sed -i "s/“/'/g" $1
sed -i "s/”/'/g" $1

# 删除 行尾空格 制表符
sed -i 's/[ \t]*$//g'

# 删除 行首空格 sed -i 's/^[ \t]*//g'

# 多个空行合并单个空行
sed -rni 'h;n;:a;H;n;$!ba;g;s/(\n){2,}/\n\n/g;p' input







------------------------------

# FILE *fopen(const char *filename, const char *mode)

mode 有下列几种形态字符串:
r 以只读方式打开文件, 该文件必须存在。
r+ 以可读写方式打开文件, 该文件必须存在。
rb+ 读写打开一个二进制文件, 允许读数据。
rw+ 读写打开一个文本文件, 允许读和写。
w 打开只写文件, 若文件存在则文件长度清为0, 即该文件内容会消失。若文件不存在则建立该文件。
w+ 打开可读写文件, 若文件存在则文件长度清为零, 即该文件内容会消失。若文件不存在则建立该文件。
a 以附加的方式打开只写文件。若文件不存在, 则会建立该文件, 如果文件存在, 写入的数据会被加到文件尾, 即文件原先的内容会被保留。（EOF符保留）
a+ 以附加方式打开可读写的文件。若文件不存在, 则会建立该文件, 如果文件存在, 写入的数据会被加到文件尾后, 即文件原先的内容会被保留。 （原来的EOF符不保留）
wb 只写打开或新建一个二进制文件；只允许写数据。
wb+ 读写打开或建立一个二进制文件, 允许读和写。
ab+ 读写打开一个二进制文件, 允许读或在文件末追加数据。
at+ 打开一个叫string的文件, a表示append,就是说写入处理的时候是接着原来文件已有内容写入, 不是从头写入覆盖掉, t表示打开文件的类型是文本文件, +号表示对文件既可以读也可以写。
上述的形态字符串都可以再加一个b字符, 如rb、w+b或ab+等组合, 加入b 字符用来告诉函数库以二进制模式打开文件。如果不加b, 表示默认加了t, 即rt,wt,其中t表示以文本模式打开文件。由fopen()所建立的新文件会具有S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH(0666)权限, 此文件权限也会参考umask 值。

有些C编译系统可能不完全提供所有这些功能, 有的C版本不用"r+","w+","a+",而用"rw","wr","ar"等, 读者注意所用系统的规定。

二进制和文本模式的区别

1.在windows系统中, 文本模式下, 文件以"\r\n"代表换行。若以文本模式打开文件, 并用fputs等函数写入换行符"\n"时, 函数会自动在"\n"前面加上"\r"。即实际写入文件的是"\r\n" 。

2.在类Unix/Linux系统中文本模式下, 文件以"\n"代表换行。所以Linux系统中在文本模式和二进制模式下并无区别。




------------------------------

char          buf[sTEXT50_LEN], custId[sTEXT50_LEN];

x86_64-linux-gnu/crt1.o: In function `_start’
编译链接动态库时需要加-shared。
同时记录多个.a和.so链接成.so, .a的编译需要增加-fPIC。

出现以上错误是因为你改变了 gcc 或者是 arm-gcc-xxx的 sysroot, gcc -v 看一下, 把默认sysroot下面的库拷贝到你指定的sysroot即可。


------------------------------


convertdb –U trainer –P trainerpwd –F metadata.sql.applychanges

convertdb –F metadata.sql.changes
convertdb –F metadata.sql.applychanges

genmeta 


sGetListItem( varlist, index) 

		sENTITY *Entity;
		Entity = sGetEntityByName('ENV'); 
		sEntityFree( Entity, (void *) &Env, sYES ); 

	sENV *env; 
	sENTITY *entity = sGetEntityByName('ENV'); 
	if ( sEntityCreate( entity, (void **)&env ) != sSUCCESS ) 
	{ //error handling } 

			typedef struct sNEW_TRADE_struct 
		  { 
			sENV	*	Env; 
			sASSET	*	Asset; 
		  } sNEW_TRADE; 


		sAsset *	asset;
		sEntityCreate( Entity, (void **)&asset);

sFUNCPTR func;, 
func = sEntityGetSummitFunction( Entity, sXXX_INTERFACE, sXXX_INTERFACE_YYYY );
   
if ( func == NULL )
{	
	sLogMessage("Error in determining Summit function", sSERIOUS, 00 );
	return( sERROR );
}
   
if( (mCAST_METHOD_XXX_YYYY func)( parameter list.. ) != sSUCCESS ) 
{
	return ( sERROR );
}



------------------------------


一、限制VM的内存使用

按下Windows + R 键, 输入 %UserProfile% 并运行进入用户文件夹
新建文件 .wslconfig , 然后使用记事本编辑
填入以下内容并保存, memory为wsl2分配的内存上限, 可根据自身电脑配置设置
[wsl2]
memory=2GB  # Limits VM memory in WSL 2GB, also can be set to other values
swap=0
localhostForwarding=true
processors=2 # Makes the WSL 2 VM use two virtual processors, also can be set to other values
设置该文件并重新启动WSL后, 不管vmmem内存使用情况如何, 仍然会消耗掉限额的内存, 但至少它不会再继续增长了, 也可以设置为其他值, 如512MB、1GB等, 即可以将其控制在某个范围之内。

二、关掉WL2 VM

在不使用WSL2时, 在PowerShell执行wsl --shutdown, 从而关掉WL2 VM。


------------------------------

wechat

AgentId:1000002 , Secret:lbjGCu1aNPJafrahotkvOrqrL-m7NfYehPisHMnthro
企业简称:弓长投资, 企业ID:ww9ca2ccd8f391f581
https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=ww9ca2ccd8f391f581&corpsecret=lbjGCu1aNPJafrahotkvOrqrL-m7NfYehPisHMnthro
{"errcode":0,"errmsg":"ok","access_token":"NqmX71UzW7_MJ77XSCupisZurvUAUcjT8DeodRFYmGm5u4Z2QN5uirRyfr84MAZGJXFJ2IIJY_Mr_9QUVIiU2JlhizHAgAyj-pD0PwiSVZOpvRnvvvchaVefcSSgh98EzRFKKlaKrc2Bo_wdSBDcWXDeYv4dNl5CylSDkjLrCQJl5Wbftt0AWFtDC6unF9_0HM03mL4aPo-MzvkAfultVg","expires_in":7200}

token:'CZPj1Ew2UhnMDqz9msaqiXShICfDqZ9p35bcS0D3gXLlxwELCO9U7ODCQPBCJpBxlN2z5SKS1HgKv53N9cLGLR4zEh1omnGrAIDgmrjvXpc42t_hJMV6CiQ6nm5bmJ2kUx5JxiufyfBswmwcaPiymC6z8HnHC4w8yT0kHC3Ikalzyy71XJZscnpkv2pYDj_Mcnb5X1UwL5B7qzMdmJcbeQ'
https://work.weixin.qq.com/wework_admin/material/getOpenMsgBuf?type=image&media_id=2ogNvJn_5j-bu5Bpv3FeVKd1Ut6ytNDAMUE27s8IFpWElebuw3gG7g2pxmA4KLjy_&file_name=image.jpg





------------------------------

# Raw Package
import numpy as np
import pandas as pd
#Data Source
import yfinance as yf
#Data viz
import plotly.graph_objs as go

#Importing market data
data = yf.download(tickers='BTC-USD',period = '8d', interval = '90m')

#Adding Moving average calculated field
data['MA5'] = data['Close'].rolling(5).mean()
data['MA20'] = data['Close'].rolling(20).mean()

#declare figure
fig = go.Figure()

#Candlestick
fig.add_trace(go.Candlestick(x=data.index,
                open=data['Open'],
                high=data['High'],
                low=data['Low'],
                close=data['Close'], name = 'market data'))

#Add Moving average on the graph
fig.add_trace(go.Scatter(x=data.index, y= data['MA20'],line=dict(color='blue', width=1.5), name = 'Long Term MA'))
fig.add_trace(go.Scatter(x=data.index, y= data['MA5'],line=dict(color='orange', width=1.5), name = 'Short Term MA'))

#Updating X axis and graph
# X-Axes
fig.update_xaxes(
    rangeslider_visible=True,
    rangeselector=dict(
        buttons=list([
            dict(count=3, label="3d", step="days", stepmode="backward"),
            dict(count=5, label="5d", step="days", stepmode="backward"),
            dict(count=7, label="WTD", step="days", stepmode="todate"),
            dict(step="all")
        ])
    )
)

#Show
fig.show()


----魔术命令--------------------------



%quickref thon 快速参考
%magic    显示magic command详细文档
%debug   从最新的异常跟踪的底部进入交互式调试器
%hist       打印命令输入历史
%pdb  在发生异常后自动进入调试器
%paste执行剪贴板中的Python代码
%cpaste 打开一个特殊的提示符以便手工粘贴待执行的代码
%reset   删除interactive空间中的全部变量/名称
%run    执行一个python脚本
%page  分页显示一个对象
%time   报告statement执行的时间
%timeit  多次执行statement以计算平均执行时间, 用于执行时间非常小的代码。
%who、%who_is、%whos  显示Interactive命名空间的中定义的变量, 信息级别/冗余度可变
%xdel      删除变量, 并尝试清楚其在IPython中的对象上的一切引用

%alias %alias_magic %autocall %automagic %autosave %bookmark %cat %cd %clear %colors %config %connect_info %cp %debug %dhist %dirs %doctest_mode %ed %edit %env %gui %hist %history %killbgscripts %ldir %less %lf %lk %ll %load %load_ext %loadpy %logoff %logon %logstart %logstate %logstop %ls %lsmagic %lx %macro %magic %man %matplotlib %mkdir %more %mv %notebook %page %pastebin %pdb %pdef %pdoc %pfile %pinfo %pinfo2 %popd %pprint %precision %profile %prun %psearch %psource %pushd %pwd %pycat %pylab %qtconsole %quickref %recall %rehashx %reload_ext %rep %rerun %reset %reset_selective %rm %rmdir %run %save %sc %set_env %store %sx %system %tb %time %timeit %unalias %unload_ext %who %who_ls %whos %xdel %xmode Available cell magics:%%! %%HTML %%SVG %%bash %%capture %%debug %%file %%html %%javascript %%js %%latex %%perl %%prun %%pypy %%python %%python2 %%python3 %%ruby %%script %%sh %%svg %%sx %%system %%time %%timeit %%writefile

%env OMP_NUM_THREADS=4env: OMP_NUM_THREADS=4 作者：深度之眼官方账号 https://www.bilibili.com/read/cv12138653/ 出处：bilibili
%run ./two-histograms.ipynb 
%load ./hello_world.py 
%store data  在notebook之间传递变 
%store -r data  在一个新的notebook中 
%who strone three two 
%%writefile pythoncode.py 
%pycat pythoncode.py 
%prun some_useless_slow_function() 显示程序在每个函数中花费的时间 
%pdb进行调试 

!ls *.csv 
!pip install numpy 
!pip list | grep pandas 


通过%quickref 或%magic命令可以查看所有的命令.
常用魔术命令:
%timeit
多次执行一条语句, 并返回平均时间, 
%%timeit
多次执行多条语句, 并返回平均时间, 
%time
返回执行一条语句的时间, 
%%time
返回执行多条语句的时间, 
%reset
删除当前空间的全部变量
%run *.py
在IPython中执行Python脚本
魔术命令+(?)显示指引文档
如:%time?

%magic 显示magic command详细文档
常用命令
命令	作用
？	说明
%lsmagic	显示全部
%matplotlib inline	图片嵌入窗口, 而不单独显示（默认）
%timeit, ％timeit	单行代码执行计时
%%timeit	多行计时
%prun	每个函数消耗时间
%%writefile	创建一个py文件, 内容为cell里
%run	运行一个py文件
%pwd	查找当前目录
%cd	更改当前目录
%cp	复制文件
%who	列出所有变量, +类型可过滤
%whos	查看当前变量,类型, 信息
%who_Is	环境中的变量列表
%reset	清除变量
%del	清除某一个变量
%load	加载一个文件里面的内容
％load_ext autoreload
%autoreload 2	导入的外部块, 自动更改
%system	快速检查当前目录和类似的东西
%automagic	是否带%, off(0)/on(1)
%debug	调试
%html	语言
%quickref	显示快速参考
%magic	显示魔术命令的帮助
%dhist	打印历史访问目录
%hist	同history, 历史
%pdb	控制pdb交互式调试器的自动调用
%page	分页器打印
%xdel	删除, 清除一切引用
系统
%alias	定义别名
!+系统命令	 
%bookmark	管理IPython的书签系统
%cd	更改当前工作目录
%pwd	返回当前工作路径
%pushd	 
%popd	 
%dirs	返回当前目录堆栈
%env	设置环境变量(无需重启)
日志
%logstart	开始
%logon	重新开始logging
%logoff	临时停止logging
%logstate	 
%debug
Debug操作	功能
(h)elp	帮助
§rint	打印变量
§retty§rint	打印变量, 链表, 字典
(n)ext line	执行当前行, 进入下一行
(u)p/(d)own	函数调用栈像上/下
(s)tep	单步进入函数
c(ont(inue))	恢复程序执行
®eturn	计算预计执行时间
b(reak)n	文件第n行设置一个断点

%load_ext autoreload
%autoreload 2


----量化指标--------------------------


量化交易策略大致分为以下三大类：
趋势交易
趋势交易适合一些主观交易高手。主要是利用技术指标进行交易，比如：利用MACD、KDJ等等，通过这些指标来构建模型进行交易。适合金融专业出身的，对金融市场非常熟悉，比如：基金经理、交易员等。
主要策略：期货CTA策略
期货CTA策略：即属于另类投资的范畴，主要采用趋势跟随为主。 主要有：海龟策略、凯特那通道、布林轨等。

市场中性策略
通过发现alpha因子赚取额外收益，收益更稳定，容量更大，风险更低。
Alpha：投资组合的超额收益，体现管理者的能力。
Beta：市场风险，最初主要指股票市场的系统性风险或收益。
换句话说，跑赢大盘的就叫Alpha，跟着大盘起伏就叫Beta。
适合计算机专业出身，擅长编程、机器学习、数据挖掘（量化分析）等。
主要策略：alpha策略、统计套利
alpha策略包括：量化选股、量化择时、Alpha对冲
统计套利：当两个具有相关性的不同合约之间的价差偏离其合理区间时，可以通过在期货市场同时买入低估值合约和卖出高估值合约，在价差回归后进行反向平仓的方式来进行跨期套利的交易。

高频交易
在极短的时间内进行，频繁的买进卖出完成大量的交易，对于硬件和算法都有极高的要求。 适合精通数学算法，及硬件编程，或者计算机较为底层的编程技能（主要开发语言是C/C++），适合基金级别的公司来操作，个人难度系数?比较高。
总结
如果你做股票，那么涉及市场中性策略（alpha策略）比较多，涉及趋势交易比较少；如果你做期货，主要涉及趋势交易策略（CTA策略、统计套利），市场中性策略（alpha策略）涉及量比较小。



量化交易报告指标详解

​​　　在量化交易中，人们往往有很多交易思路，根据这些交易思路开发出不同的交易策略，而衡量一个策略的好坏，需要综合考虑策略的收益率、风险性等各种因素。下面挑选了一些常用的量化交易报告指标为大家一一介绍。
​
Alpha（阿尔法）
​　　投资中面临着系统性风险（即Beta）和非系统性风险（即Alpha），Alpha是投资者获得与市场波动无关的回报。比如投资者获得了15%的回报，其基准获得了10%的回报，那么Alpha或者价值增值的部分就是5%。
​
Beta（贝塔）
​　　表示投资的系统性风险，反映了策略对大盘变化的敏感性。例如一个策略的Beta为1.5，则大盘涨1%的时候，策略可能涨1.5%，反之亦然；如果一个策略的Beta为-1.5，说明大盘涨1%的时候，策略可能跌1.5%，反之亦然。
​
Sharpe（夏普比率）
​　　夏普比率是一个可以同时对收益与风险加以综合考虑的指标，代表投资人每多承担一分风险，可以拿到几分超额报酬；若为正值，代表投资组合报酬率高过波动风险；若为负值，代表投资组合操作风险大于报酬率。这样一来，每个投资组合都可以计算夏普比率，即投资回报与多冒风险的比例，这个比例越高，投资组合越佳。
​
　　夏普比率的计算非常简单，用投资组合净值增长率的平均值减无风险利率再除以基金净值增长率的标准差就可以得到投资组合的夏普比率。它反映了单位风险基金净值增长率超过无风险收益率的程度。
​
胜率和盈亏比
​　　胜率，顾名思义是获胜的概率，做10次交易，赚钱6次，胜率就是60%。而盈亏比则是在多次交易以后，用赚钱的平均点数除以亏损的平均点数得到的比率，如果每笔盈利交易平均为15%，每笔亏损交易平均为5%，那么盈亏比就是3。也就是说，平均赚3块钱就要付出1块钱的亏损，这反映出投资交易盈利所冒的风险。
​
　　盈亏比跟胜率相互制衡，盈亏比越高，相应的胜率就会越低，反之亦然。决定了一个投资者在一个较长周期里能否盈利的关键是：胜率*盈亏比。一般来说，高风险交易更看重盈亏比，一两次获胜就可以奠定盈利的基础，而低风险交易更看重胜率，由于每次交易的盈利和亏损都有限，盈利从一次次获胜中累积起来。
​
年化收益率
​　　年化收益率是把当前收益率（日收益率、周收益率、月收益率）换算成年收益率来计算的，是一种理论收益率，并不是真正的已取得的收益率。因为年化收益率是变动的，所以年收益率不一定和年化收益率相同。
​
最大回撤
​　　最大回撤就是从一个高点到一个低点最大的下跌幅度，用来描述我们的策略可能出现的最糟糕的情况，衡量了最极端可能的亏损。回撤和风险成正比，回撤越大，风险越大，回撤越小，风险越小。例如一个策略的最大回撤是50%，那么你使用这个策略之前就要掂量掂量，自己是否能经受得起50%的下跌。 


----交易风控规则--------------------------



交易风控规则：
黑/白(灰)名单：不允许/仅限于
单笔交易限制：最大/小委托金额
持仓限制：持仓品种, 持仓最大金额, 持仓周期
时间限制：在规定周期内禁止交易

合规部分：报单频率, 报撤比, 


风控中心模块是所有策略进行下单的风险控制的核心模块。该模块会对所有策略下单进行风险管控。风险管控主要包括两种, 一种是依据交易所的下单管控规则, 限制系统平台下所有的下单频率, 具体主要指全局ip下单请求限制, 单账户下单请求限制, 查询请求权重限制, 自成交检查, 重复撤单检查等等。第二种为系统平台制定的风险管控, 防止策略程序因为bug或参数不正确的原因导致异常下单, 造成巨额损失。具体主要是单笔下单量, 单笔下单金额, 单账户的持仓量。

20220510新增 风控指标（以下仅为, 全部风控指标后续会有单独附件列明）
1.合规部分: 报单频率(ip）, 报撤比, 自成交检查, 重复撤单,  
2.白名单授权（母账户500, 子账号100/部分）, 单笔下单量, 单笔下单金额

截止 2022/5/24
币安所有交易币种：374
币币+合约(合计：1656)

币币交易(合计：1438)：
BUSD ：261
USDT ：339
BNB ：138
BTC ：310
ALTS ：114
FIAT(All) ：260
ETF ：16

合约市场(合计：218)
U本位合约：159
币本位合约：59


维持担保资产率 = 调整系数 / 对应倍数（此数据仅供对比参考, 不作为强平依据）


风控部分（事中）： 
合规部分(母账户)
指标	指标触发值	触发条件	计算周期	禁用时间
未成交率UFR	＞0.999	委托单数量≥300	每10分钟	5分钟
过期率IFER	＞0.99	FOK及IOC委托单数量≥150	每10分钟	5分钟
撤单率GCR	＞0.99	GTC委托单数量≥150	每10分钟	5分钟
24小时禁用次数	>10		每10分钟	24小时


风控部分（事中）： 

合规部分(母账户/报单)：
未成交率UFR： (触发条件: 若10分钟内委托单≥300,UFR>0.999 )
撤单率GCR： (触发条件: 若10分钟内FOK/IOC委托单≥150,IFER>0.99 )
过期率IFER： (触发条件: 若10分钟内委托单≥300,UFR>0.99 )
流量控制/IP全局请求频率：


交易白名单（母账户500, 子账号100/部分, 当前币安:可交易币种374, 币币1438+合约218=合计1656 ）：

报单：
重复委托：(策略/系统异常导致重复报单)
自成交控制：(0禁止)

仓位：
母账户仓位比率：
子账户仓位比率：

持仓：
母账户单品种的持仓数量/金额：
子账户单品种的持仓数量/金额：



------------------------------




20220525新增 风控指标

风控部分（事中）： 设置开关参数(启用/禁用), 阈值N/N1/N2 ...（参数可配置）

[合规部分(母账户/报单): N,N1,N2]
N1分钟内委托单未成交率UFR>N： (触发条件: 若N1(10)分钟内委托单≥N2(300),UFR>N (N参考值0.999), 未成交率=1-成交总量/委托总量)
N1分钟内委托单撤单率GCR>N： (触发条件: 若N1(10)分钟内委托单≥N2(150),GCR>N (N参考值0.99), 撤单率=无效撤单总笔数/GTC委托单总笔数, 无效撤单：委托单类型(timeInForce)为GTC, 委托单状态为已取消(CANCELED), 成交数量为0, 且撤单时间与下单时间间隔小于等于2.5秒的委托单 )

[流量控制/IP全局请求频率:（按交易所统计/设置）]
每分钟的请求权重[请求权重是什么概念？]次数>N：（触发条件N上限值: 1200次）
订单每10秒钟限定次数>N：（触发条件N上限值: 50次）
24小时的订单数量限定次数>N：（触发条件N上限值: 160,000次）

子账户每分钟的行情请求次数>N：（触发条件N上限值: 1200次/子账户数）
子账户订单每10秒钟限定次数>N：（触发条件N上限值: 50次/子账户数）

交易白名单：(交易代码对在母/子白名单表中, 代码池 )

[报单]
重复委托>N：(策略/系统异常导致重复报单,2秒内连续委托单相同交易对/价格/数量/成交额/方向)
自成交控制=N：(默认不允许, 0)

[仓位：触发后不新开仓, 可平仓]
母账户杠杆率>N：(仓位名义价值/净资产, 净资产=可用资金+保证金占用, 可设置两档阈值：N1警告, N2强平)
子账户杠杆率>N：(可设置两档阈值：超过N1系统警告, 超过N2则触发强平)
子账户亏损限额>N：超过限额N触发强平
子账户单币种净敞口限额>N：（同一个本位的期货, 现货和永续合约美元价值之和的绝对值）
子账户净敞口限额>N：（子账户所有期货, 现货和永续美元价值之和的绝对值）

[持仓：触发后不新开仓, 可平仓]
母账户单品种的持仓数量>N：（按品种设置）/
母账户单品种的持仓金额>N：（按品种设置）
子账户单品种的持仓数量>N：（按品种设置）/
子账户单品种的持仓金额>N：（按品种设置）

[场景/案例1]
量控制/IP全局请求频率,每分钟的请求权重次数>N：
当N设置为1180时, 当前1分钟内累计请求权重次数1181次>阈值N (1180)次, 则禁用/放弃该请求。[老王再看下这部分交易所一般控制的频率是按分钟统计的吗？]

[场景/案例2]
某子账户BTCUSDT永续的持仓数量>N：当N设置为0.50500时, 当前某子账户BTCUSDT永续的持仓数量0.51499><N (5000.50),如账户新开多仓 进行新开空仓, 则禁用/放弃该委托(新开仓), 如账户新开空仓（或称之为平仓）则, 平仓不限制。

[场景/案例3]
某子账户杠杆率>N1(警告)：当N1设置为8时, 当前监控到某子账户杠杆率9>N1 (8) , 发出警告/记录日志, 并通知该子账户进行处理(追加/自行平仓)。
某子账户杠杆率>N2(强平)：当N2设置为10时, 当前监控到某子账户杠杆率10.1>N2 (10) , 对该子账户进行强平处理(参考4.2.5)。



------------------------------



名称/id：xxxxxx(唯一)
类别：母账户, 子账户, 策略, 交易代码, 系统, 交易所, 指令
列表：母账户名列表, 子账户名列表, 策略代码列表, 交易代码列表, 系统名称, 交易所名列表, 指令名列表
条件：表达式（逻辑）
操作：允许, 警告, 禁止, 强平, 撤单, 
状态：启用/禁用
备注：规则备注

逻辑表达式：
符号: >, >=, <, <=, ==, !=, in (包含), +, -, *, /, ^, &&, ||, (, ), !(非)
(符号两端：纯数字为阈值, 字母组合为字段名)

要素/字段：(字段名暂定, 以实际开发为主)

[母/子账户]持仓总量, 空仓持仓合约价值, 多头合约价值, 单位净值, 资产净值, 可用资金, 保证金占用, 合约代码（交易代码）
[母/子账户的单品种]持仓总量, 持仓合约价值

[母/子账户]代码池（可以自定义N个）
[系统]未成交率, 撤单率, 请求频率,  
[交易要素简化一下：这里重复的比较多, 比如整理成下面这个样子, 你再补充一下。
持仓总量
空仓持仓合约价值
多头合约价值
单位净值
资产净值
可用资金
合约代码（交易代码）
代码池（可以自定义N个）
保证金占用

比如子账号杠杠率控制, 那么可以设置：类别, 子账号；条件 （多头价值+空头价值）/资产净值 > N(阈值）；操作：禁止
状态：启用；]
[系统/子账户]每分钟请求次数, 每秒订单处理次数, 
[母/子账户]重复委托, 自成交控制, 
[母/子账户]杠杆率, 杠杆率阈值, 持仓数量阈值, 持仓价值阈值
[子账户]亏损额, 单币种净敞口额, 净敞口额, 

[订单 委托请求]交易代码, 委托数量, 委托价格, 委托金额, 委托方向, 完成度, 成交数量, 成交数量, 成交金额
[母/子账户仓位]合约, 持仓数量, 持仓方向, 平均开仓价, 累计实现损益, 标记价格, 强平价格, 保证金比率, 保证金, 未实现赢亏, 
[资产 现货/资金]币种, 总额, 可用资产, 下单锁定, BTC估值, 
[资产 合约]资产, 资产名称, 余额, 未实现赢亏, 保证金余额, 可用下单余额, 
[保证金]保证金比率, 维持保证金, 保证金余额, 
[行情]交易代码, 最新价, 最高价, 最低价, 成交量, 涨跌幅, 振幅, 24h涨幅, 24最高价, 24最低价, 24h成交量, 24成交额, 
[指令 母/子账户] 每秒报单次数, 每秒撤单次数, 每秒查询资产次数, 每秒查询仓位次数, 每秒查询委托次数, 每秒查询成交次数


----交易规则----币安--U本位--BTCUSDT--VETUSDT--

合约					BTCUSDT 永续
最小下单数量			0.001 BTC
最小价格波动			0.10 USDT
限价买单价格上限比例	5 %
限价卖单价格下限比例	5 %
市价单单笔最大数量		120 BTC
最大挂单数量			200
最小名义价值			5 USDT
价差保护阈值			5 %
强平清算费				1.50 %


合约					VETUSDT 永续
最小下单数量			1 VET
最小价格波动			0.000010 USDT
限价买单价格上限比例	5 %
限价卖单价格下限比例	5 %
市价单单笔最大数量		2500000 VET
最大挂单数量			200
最小名义价值			5 USDT
价差保护阈值			5 %
强平清算费				1.00 %

合约					BATUSDT 永续
最小下单数量			0.1 BAT
最小价格波动			0.0001 USDT
限价买单价格上限比例	10 %
限价卖单价格下限比例	10 %
市价单单笔最大数量		600000 BAT
最大挂单数量			200
最小名义价值			5 USDT
价差保护阈值			5 %
强平清算费				1.00 %



----枚举--------------------------

枚举定义
交易对类型:

FUTURE 期货

合约类型 (contractType):
PERPETUAL 永续合约
CURRENT_MONTH 当月交割合约
NEXT_MONTH 次月交割合约
CURRENT_QUARTER 当季交割合约
NEXT_QUARTER 次季交割合约
PERPETUAL_DELIVERING 交割结算中合约

合约状态 (contractStatus, status):
PENDING_TRADING 待上市
TRADING 交易中
PRE_DELIVERING 预交割
DELIVERING 交割中
DELIVERED 已交割
PRE_SETTLE 预结算
SETTLING 结算中
CLOSE 已下架

订单状态 (status):
NEW 新建订单
PARTIALLY_FILLED 部分成交
FILLED 全部成交
CANCELED 已撤销
REJECTED 订单被拒绝
EXPIRED 订单过期(根据timeInForce参数规则)

订单种类 (orderTypes, type):
LIMIT 限价单
MARKET 市价单
STOP 止损限价单
STOP_MARKET 止损市价单
TAKE_PROFIT 止盈限价单
TAKE_PROFIT_MARKET 止盈市价单
TRAILING_STOP_MARKET 跟踪止损单

订单方向 (side):
BUY 买入
SELL 卖出

持仓方向:
BOTH 单一持仓方向
LONG 多头(双向持仓下)
SHORT 空头(双向持仓下)

有效方式 (timeInForce):
GTC - Good Till Cancel 成交为止
IOC - Immediate or Cancel 无法立即成交(吃单)的部分就撤销
FOK - Fill or Kill 无法全部立即成交就撤销
GTX - Good Till Crossing 无法成为挂单方就撤销

条件价格触发类型 (workingType)
MARK_PRICE
CONTRACT_PRICE

响应类型 (newOrderRespType)
ACK
RESULT

K线间隔:

m -> 分钟; h -> 小时; d -> 天; w -> 周; M -> 月

1m
3m
5m
15m
30m
1h
2h
4h
6h
8h
12h
1d
3d
1w
1M

限制种类 (rateLimitType)

REQUESTS_WEIGHT 单位时间请求权重之和上限

ORDERS 单位时间下单(撤单)次数上限

限制间隔

MINUTE




----策略继承Handler类--------------------------

策略继承Handler类, 按需重写处理推送的函数
handleOrderNew：处理新订单
订单结构：
clientorderid   # 系统订单ID
symbol          # 交易对
gatewayorderid  # 交易所订单ID
quantity        # 数量
price           # 委托价
stopprice       # 触发价
ordertype       # 订单类型
side            # 订单方向
status          # 状态
positionside    # 持仓方向
createtime      # 订单时间
updatetime      # 更新时间
tradetype       # 交易类型
selfid          # 订单ID
filltrades      # 订单匹配的交易
handleOrderFilled：处理订单完成
同上
handleOrderCanceled：处理订单取消
同上
handleOrderRejected：处理订单拒绝
同上
handleOrderCancelRejected：处理订单取消拒绝
同上
handleOrderExpired：处理订单被撤销
同上
handleTimer：处理定时器
定时器结构：
定时器id
handleKline：处理k线推送
k线结构：
gatewaytype # 交易所
tradetype # 交易类型
symbol # 交易对
interval # k线间隔
opentime # 开盘时间
closetime # 收盘时间
openprice # 开盘价
closeprice # 收盘价
highprice # 最高价
lowprice # 最低价
volume # 成交量
number # 成交笔数
totalamount # 成交额
activevolume # 主动买入成交量
activeamount # 主动买入成交额
使用Handler初始化FILclient, 并完成初始的订阅和启动
start：启动
subOrderReport：订阅订单推送
参数：交易所（"simulator"）和keyid, 模拟盘keyid填0即可
返回：成功或失败
cancelSubOrderReport：取消订阅订单推送
同上
subKline：订阅k线推送
参数：交易所（"simulator"）, 交易类型（"usdt"）, 交易对, k线间隔
返回：成功或失败
k线间隔限定：
"1m", # 1分钟
    "3m", # 3分钟
    "5m", # 5分钟
    "15m", # 15分钟
    "30m", # 30分钟
    "1h", # 1小时
    "2h", # 2小时
    "4h", # 4小时
    "6h", # 6小时
    "8h", # 8小时
    "12h", # 12小时
    "1d", # 1天
    "3d", # 3天
    "1w", # 1周
    "1M", # 1月
cancelSubKline：取消订阅K线推送
同上
subTimer：订阅定时器
参数：毫秒数
返回：计时器id

使用Handler中的client, 可以主动调用量化系统接口
uklines：查询U本位K线
参数：交易所, 交易对, 间隔, 数量限制, 开始时间, 结束时间
返回：result为k线数组
queryUOrder：通过订单id查询U本位订单
参数：订单id
返回：result为完整订单信息
insertMarketUOrder：下单U本位市价单
参数：交易所, keyid（模拟填0）, 交易对, 数量, 方向（buy或sell）
返回：订单id
insert_factor：记录因子
参数：记录值, 时间, 因子序号（可选1, 2, 3）
返回：成功或失败
queryPositions：查询当前仓位
参数：交易对
返回：仓位结构
仓位结构：
result数组（1个或0个）：
单个仓位结构：
symbol         # 交易对
positionAmount # 持仓数量
enterprice     # 平均开仓价
countrevence   # 累计实现损益
unrealprofit   # 持仓未实现盈亏
positionside   # 持仓方向
markprice     # 标记价格




------------------------------

2.	Similarity.py
a)	截取前面半天的k线, 去寻找历史上N天前走势最相似的一天, 如果那天的后半天是上涨的, 那么做多, 如果是下跌的, 则做空, 当天日终平仓。




//////////////////////////////

1. 监控所有的交易代码？ 还指定代码？




----cli.uklines--------------------------

cli.uklines('binance', symbol=symbol, interval=interval, limit=k_line_number+1)
这个返回的是一个KlinesReturn 类型
df = pd.DataFrame([{'open_time': rs.opentime, 'close_price': rs.closeprice} for rs in data.result])
可以通过这种方式转换为一个dataframe,字段值按照自己的需要处理


KlinesReturn {
	'result': [KlineType {
			'gatewaytype': 0,
			'tradetype': 1,
			'symbol': 'BTCUSDT',
			'interval': 3,
			'opentime': 1652792400000,
			'closetime': 1652793299999,
			'openprice': '30576.1',
			'closeprice': '30489.9',
			'highprice': '30592',
			'lowprice': '30466.6',
			'volume': '2385.877',
			'number': 29482,
			'totalamount': '72817571.034',
			'activevolume': '898.954',
			'activeamount': '27437574.8941'
		}, KlineType {
			'gatewaytype': 0,
			'tradetype': 1,




------------------------------

访问Rest接口

https://fapi.binance.com/fapi/v1/depth?symbol=BTCUSDT&limit=1000

{"lastUpdateId":1566348424187,"E":1654130792413,"T":1654130792404,"bids":[["29636.10","5.624"],["29635.60","0.272"],["29635.50","0.040"],["29635.40","0.704"],["29634.90","0.001"],["29634.60","0.017"],["29634.50","0.014"],["29634.40","0.001"],["29634.00","0.065"],["29633.90","0.248"],["29633.80","0.474"],["29633.70","0.640"],["29633.60","4.378"],["29633.50","0.533"],["29633.30","0.273"],["29633.20","0.928"],["29633.10","1.923"],["29633.00","0.255"],["29632.90","0.311"],["29632.80","1.123"],["29632.50","0.001"],["29632.30","0.003"],["29632.20","0.121"],["29632.10","1.166"],["29632.00","4.634"],["29631.90","0.056"],["29548.70","1.828"],["29548.60","0.204"],["29548.50","0.001"],["29548.30","0.003"],["29548.20","0.032"],["29548.10","1.655"],["29817.50","1.940"],["29817.80","0.202"],["29818.00","0.002"],["29818.10","0.196"],["29818.20","0.002"],["29818.30","0.005"],["29818.40","16.626"]]}


------------------------------





2022-05-29 17:00:00,546 - my - DEBUG - handleKline: data=KlineType{'gatewaytype': 3, 'tradetype': 0, 'symbol': 'MKRUSDT', 'interval': 5, 'opentime': 1653811860000, 'closetime': 1653814799999, 'openprice': '1197.9', 'closeprice': '1197.4', 'highprice': '1210', 'lowprice': '1195.2', 'volume': '707.649', 'number': 4361, 'totalamount': '850897.4109', 'activevolume': '300.401', 'activeamount': '361461.3636'}


curl -X POST -d '{"method":"hello",params:["SOLUSDT_AXSUSDT","16483487768000","0.001",8081,9091]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"hello","params":["SOLUSDT_AXSUSDT","16483487768000","0.001",8081^M,9091]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"hello","params":["SOLUSDT_AXSUSDT","16483487768000","0.001",8081,9091]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"hello","params":["SOLUSDT_AXSUSDT","0.001",8081,9091]}' http://127.0.0.1:8888/strategy
curl -X POST  -d '{"method":"hello","params":["SOLUSDT_AXSUSDT","0.001",8081,9091]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"hello","params":["test_name",1644805468000,"0.001",8080,9090]}' http://127.0.0.1:8888/strategy
curl -X POST  -d '{"method":"hello","params":["${x}_${y}",0.001,$sp,$cp]}' http://127.0.0.1:8888/strategy
curl -X POST  -d '{"method":"hello","params":["testa",0.001,8000,9000]}' http://127.0.0.1:8888/strategy
curl -X POST  -d '{"method":"hello","params":["testa","0.001",8000,9000]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",1651564000000,1651565016000,100]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651565016000,100]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651569016000,100]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579016000,100]7' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579016000,100]' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651569016000,100]7' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579016000,100]' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579016000,100]' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579016000,100]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,165157901601651560000000,1651570000000,100]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUS560000000,1651570000000,100]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["SOLUSDT_AXSUSDT",0,165157901601651560000000,1651570000000,100]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["SOLUSDT_AXSUSDT",165157901601651560000000,1651570000000,100]}' http://127.0.0.1:
curl -X POST -d '{"method":"queryWorth","params":["SOLUSDT_AXSUSDT",165157901601651560000000,1651570000000,100]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["SOLUSDT_AXSUSDT",1651560000000,1651570000000,100]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579165000,100]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryFactor1","params":["IOSTUSDT_ICXUSDT",0,1652268960001]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryFactor1","params":["IOSTUSDT_ICXUSDT",0,0]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryFactor1","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryFactor3","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryFactor1","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strateg2
curl -X POST -d '{"method":"queryFactor2","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/stratege
curl -X POST -d '{"method":"queryFactor2","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryFactor2","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryFactor1","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryFactor2","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryFactor3","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy




----K线stream--------------------------

K线stream逐秒推送所请求的K线种类(最新一根K线)的更新。推送间隔250毫秒(如有刷新)

订阅Kline需要提供间隔参数, 最短为分钟线, 最长为月线。支持以下间隔:

m -> 分钟; h -> 小时; d -> 天; w -> 周; M -> 月

1m
3m
5m
15m
30m
1h
2h
4h
6h
8h
12h
1d
3d
1w
1M
Stream Name:
<symbol>@kline_<interval>

Update Speed: 250ms

{
  "e": "kline",     // 事件类型
  "E": 123456789,   // 事件时间
  "s": "BNBUSDT",    // 交易对
  "k": {
    "t": 123400000, // 这根K线的起始时间
    "T": 123460000, // 这根K线的结束时间
    "s": "BNBUSDT",  // 交易对
    "i": "1m",      // K线间隔
    "f": 100,       // 这根K线期间第一笔成交ID
    "L": 200,       // 这根K线期间末一笔成交ID
    "o": "0.0010",  // 这根K线期间第一笔成交价
    "c": "0.0020",  // 这根K线期间末一笔成交价
    "h": "0.0025",  // 这根K线期间最高成交价
    "l": "0.0015",  // 这根K线期间最低成交价
    "v": "1000",    // 这根K线期间成交量
    "n": 100,       // 这根K线期间成交笔数
    "x": false,     // 这根K线是否完结(是否已经开始下一根K线)
    "q": "1.0000",  // 这根K线期间成交额
    "V": "500",     // 主动买入的成交量
    "Q": "0.500",   // 主动买入的成交额
    "B": "123456"   // 忽略此参数
  }
}


wss://fstream.binance.com/ws/btcusdt_perpetual@continuousKline_5m

服务端响应  2022-06-27 19:09:15
{
    "e": "continuous_kline",
    "E": 1656328156263,
    "ps": "BTCUSDT",
    "ct": "PERPETUAL",
    "k": {
        "t": 1656327900000,
        "T": 1656328199999,
        "i": "5m",
        "f": 1658113927316,
        "L": 1658122668402,
        "o": "21393.50",
        "c": "21389.10",
        "h": "21399.10",
        "l": "21370.10",
        "v": "1661.857",
        "n": 15274,
        "x": false,
        "q": "35535402.27700",
        "V": "804.086",
        "Q": "17194801.62180",
        "B": "0"
    }
}

服务端响应  2022-06-27 19:09:59
{
    "e": "continuous_kline",
    "E": 1656328200103,
    "ps": "BTCUSDT",
    "ct": "PERPETUAL",
    "k": {
        "t": 1656327900000,
        "T": 1656328199999,
        "i": "5m",
        "f": 1658113927316,
        "L": 1658124264762,
        "o": "21393.50",
        "c": "21395.80",
        "h": "21414.80",
        "l": "21370.10",
        "v": "1899.676",
        "n": 17790,
        "x": true,
        "q": "40624772.63320",
        "V": "965.671",
        "Q": "20652626.71340",
        "B": "0"
    }
}


----apiKey--secretKey--------------------------


get exchangeInfo vapi 欧式期权
https://vapi.binance.com/vapi/v1/exchangeInfo
https://eapi.binance.com/eapi/v1/exchangeInfo

get exchangeInfo api 现货
http://www.binance.com/api/v3/exchangeInfo

get exchangeInfo fapi U本位
www.binance.com/fapi/v1/exchangeInfo

get exchangeInfo dapi 币本位
www.binance.com/dapi/v1/exchangeInfo

get continuousKlines
http://www.binance.com/fapi/v1/continuousKlines?pair=BTCUSDT&contractType=PERPETUAL&interval=1m&limit=50
http://testnet.binancefuture.com/fapi/v1/continuousKlines?pair=BTCUSDT&contractType=PERPETUAL&interval=1m&limit=50

post listenKey
https://fapi.binance.com/fapi/v1/listenKey

# #ation126@hotmail.com
api_key    = "fcc2838327a124367acd634323b93b1fb53d6fc66e84d679169a78adcaf1bf3e"  # 密钥
secret_key = "4f58b518cecdfe9c574cd2aa9cbbea429796673d6226424bdda1f0155cd78876"  # 私钥

# #binance@snapmail.cc Test2022
# api_key     = "d7188e86617bec4e95daa012fbaabf4a84ce1b12992019b7125df19eb536ad42"  # 密钥
# secret_key  = "cb68c9cf4303fc4cd11da655df3a978d41fcbf3b1e927f6e6d49ef41388a6749"  # 私钥


# testnet1@snapmail.cc  Test2022 15,000  *68.31-real-bintest-1
# api_key    = "056624748cc8a9a8c813908172c3e76e8cbd54a8c6d39f5f43fdfead0cae866f"  # 密钥 API 密钥
# secret_key = "b721938f7817a449f7869ac4f49b2f25c6fb5a89809a5319528824f8e75e9cd2"  # 私钥 API 私钥

# testnet2@snapmail.cc  Test2022 15,000  *99.13-test-bintest-2
# api_key    = "b183605895cec96614b1f5cfd455458c7a5c74a01f28d2a33ecda09de84eb0a4"  # 密钥 pubkey
# secret_key = "936fdaa1df30fba4cb8551439487beb56b4728d67c82a8e2b730a8b54ef361dd"  # 私钥 prikey

# testnet3@snapmail.cc  Test2022 15,000  *99.13-test-bintest-3
# api_key    = "067d5cc151564fa0f0c89f81d1ee735aa84299ac1cf5c57c430844745954d2cf"  # 密钥 pubkey
# secret_key = "e590c6caeaa7ce53a41a8c81bdf33992d1057ecf9b5cb30474a83afe51bdbaa8"  # 私钥 prikey

# testnet4@snapmail.cc  Test2022  1,000  *99.13-test-bintest-4
# api_key    = "ab07d48c01650f26c5fecd86c6d22b6b17a2425dd1307267d8615e1402f368db"  # 密钥 API 密钥
# secret_key = "fef0312fe7cbe517c7ad25b77ce26ac9bf54932eb3a1f1242999ba211d882f3a"  # 私钥 API 私钥

# #oCAuFzSgAumY Real2022
# api_key     = "T6qUmdYPmqwfHOo3ttCJilZMYyxkdaDGROhJ8fZhgmGgTEagXsnXLsXeCUW7LdXG"  # 密钥
# secret_key  = "oDJzCvyN9BDfyIgUc2dibgYeadxQxH9afu4peYuIyfa4sOFOwLQ57Rqui9N95gzJ"  # 私钥

"pubkey": "deaa3d08f18e39ecfb35afd97c4e3b4ada48141ee9f4d1879550412ca23b0c56",
"prikey": "fad8feea046b775abb1a12877c868a7bac1526b1637044796b562f8dc73d1ffa",



# testnet11@snapmail.cc  Test2022 15,000  *99.13-risk-risk1-
# api_key    = "8fe7623f5b17d916e19a2d04e8d6e7a65761daf678c1a90120fb69055a28f748"  # 密钥 pubkey
# secret_key = "1770a8f54c937fa86c8d5c2155250f558531fdd6482c189e9881f8596b454662"  # 私钥 prikey

# testnet12@snapmail.cc  Test2022 15,000  *99.13-kline-kline1-
# api_key    = "9dcb00b5339f33c7138188322b6c5f45d74f5b081d6fa50d5ed97df7bb420432"  # 密钥 pubkey
# secret_key = "0887a29bca1961376dfe50d2efd51989698f982668c568d3dfa0408966a2ed7a"  # 私钥 prikey

# testnet13@snapmail.cc  Test2022 15,000  *99.13-risk-order1-
# api_key    = "d1322cbc05610f354531eac6727a6475977c83f713ebe0cb3635fd3c6a2b49ca"  # 密钥 pubkey
# secret_key = "4edf2bf70514120039fed291435cc65f77961fc164d26e72037799532d774c5e"  # 私钥 prikey

# testnet14@snapmail.cc  Test2022 15,000  *99.13-risk-trade1-
# api_key    = "875e36221bb0ebdd847ea4ab64f56114eeae56daf1fcb29116c7ee41d0794394"  # 密钥 pubkey
# secret_key = "a06b6e839a42b527733fafa051e5c1acd240419dac3801079c6d0c5ddfd5b025"  # 私钥 prikey

# testnet15@snapmail.cc  Test2022 15,000  *99.13-risk-risk5-
# api_key    = "6433dff9990704302ede50ca608edfd27b22866cacf69f800fe8eaca5c241811"  # 密钥 pubkey
# secret_key = "d2b2bdf0485ab4fb20d9aab7ae7754b993264d26859bcf541eba4289769956e0"  # 私钥 prikey

# testnet16@snapmail.cc  Test2022 15,000  *99.13-risk-risk6-
# api_key    = "2d176ba955cff6ae618159186753761e2a1e2ec705f818e1d8bd68a7c46343c6"  # 密钥 pubkey
# secret_key = "69327db724b70c99d9e0e9eafa1f34110a44f1a583a384e7beb379697e2d1ea2"  # 私钥 prikey

# testnet17@snapmail.cc  Test2022 15,000  *99.13-risk-risk7-
# api_key    = "465b350908c7850354dd1df47e4a32ec989d928c8e8aa1d15d20f03f4e691b53"  # 密钥 pubkey
# secret_key = "63aba318d49f4a6bb5286226ee8705495eeb5213d308d7d05dc8265a12ce2109"  # 私钥 prikey


# testnet21@snapmail.cc  Test2022 15,000  *99.13-risk2-risk21-
# api_key    = "38c8df06299e955d57e9df4a520bb5589459d457f6ccf5fcced23f1033f151ce"  # 密钥 pubkey
# secret_key = "a1cde020fb28435944bcddb03280e783b58d5764a952f122ea4653b6f2a8383e"  # 私钥 prikey


# testnet22@snapmail.cc  Test2022 15,000  *99.13-order2-order21-
# api_key    = "4975e5ea27e6497db930f6773ac70dd12f05f76753b227125b60715c779ec9d8"  # 密钥 pubkey
# secret_key = "cff76bf806526224454411d7a31e773b6517ae6bcdcd76fdefcd4e37817a9991"  # 私钥 prikey


# testnet23@snapmail.cc  Test2022 15,000  *99.13-risk3-kline1-
# api_key    = "598e0636f68883477483b545ba086231e1be63458248e196c7b837820a6e498b"  # 密钥 pubkey
# secret_key = "a633ce2b580dd5b1c578247340dbae619e566a0217d79b5ab6008b40de0365fd"  # 私钥 prikey


# testnet24@snapmail.cc  Test2022 15,000  *99.13-risk3-kline2-
# api_key    = "c8e4db02d4339972299ff5423b0b580d87d558d40d8262e12a2a45efd6a8a271"  # 密钥 pubkey
# secret_key = "ee0a42f9459676021f50ce301b7cc93b7101a92e40224b40555bff1aa45625e2"  # 私钥 prikey


# testnet25@snapmail.cc  Test2022 15,000  *99.13-risk3-kline3-
# api_key    = "76632e802c8da3c40aec0f15b29af406e7584a2d273e46cf72603a5e6a265d75"  # 密钥 pubkey
# secret_key = "16662ef22fddede042bcf7be2f4297d1b451da7443dded5e11732f84a4487337"  # 私钥 prikey


# testnet26@snapmail.cc  Test2022 15,000  *99.13-risk3-kline4-
# api_key    = "968532305fa5c74686a3c8980ed560783afd13cc07f6a27763df1fbb6e997428"  # 密钥 pubkey
# secret_key = "9579a4afaa29514fc37e76779f1506879e535ae3d4e5a410aec0bdfa4103dfdd"  # 私钥 prikey


# testnet27@snapmail.cc  Test2022 15,000  *99.13-risk3-order1-
# api_key    = "deeec9c07260e1a0f61f76e69ee43c431a95716ff60178b24472ab707409030a"  # 密钥 pubkey
# secret_key = "a36f9f4c78ff5a5d4f2599ed9e3e31f4297271021ba908857cf3269be8711188"  # 私钥 prikey

# testnet28@snapmail.cc  Test2022 15,000  *99.13-risk3-fee1-subfee1-testfee1-
# api_key    = "7dc31abfddc161ee6437cee02c0e955295c3fe16bc0505a0c808feab500e394f"  # 密钥 pubkey
# secret_key = "7e763fef7d6eeee9a8d683fb5d9711464b9a996ebae0fef10b26c66c8be2c3b2"  # 私钥 prikey


# testnet31@snapmail.cc  Test2022 15,000  *68.31-testrisk1-testnet31_risk1-
# api_key    = "f9529730010f598de9b0d4a9b0fe156b5541aba60f979f0e5c8902a6f830892f"  # 密钥 pubkey
# secret_key = "dd53d75eaca841596ecb86429e1f1f2d62a433de1d7ab819d69636943803191e"  # 私钥 prikey

# testnet32@snapmail.cc  Test2022 15,000  *68.31-testrisk1-testnet32_kline1-
# api_key    = "0f9cba70f810787ad4d3cd6c49c8f97f14fca5f53bcd59a487e38c8eeed36a7b"  # 密钥 pubkey
# secret_key = "49371d0e73eb89eef8d30c4a49b8d826d446b7d4aba75f652f2404cac165ee6d"  # 私钥 prikey




POST listenKey
https://testnet.binancefuture.com/fapi/v1/listenKey
X-MBX-APIKEY  fcc2838327a124367acd634323b93b1fb53d6fc66e84d679169a78adcaf1bf3e


账户信息订阅/推送
wss://stream.binancefuture.com/ws/fJtls56vIgVO1rtVtQp1yXVNRc25yD9Rn6WgpW354pf6FjIFbE5r6WCR9lTYho4F



------------------------------


wss://fstream.binance.com/stream?streams=btcusdt@depth

wss://fstream.binance.com/ws/btcusdt@markPrice@1s

wss://stream.binancefuture.com/ws/btcusdt@markPrice@1s



import os
import time

ts = f'{int(time.time())+12 }999'
# print( f'{ts}' ) 

cmd = f' echo -n "recvWindow=5000&timestamp={ts}" | openssl dgst -sha256 -hmac "4f58b518cecdfe9c574cd2aa9cbbea429796673d6226424bdda1f0155cd78876" '
# print( cmd ) 

# echo -n "recvWindow=5000&timestamp=1661168970999" | openssl dgst -sha256 -hmac "4f58b518cecdfe9c574cd2aa9cbbea429796673d6226424bdda1f0155cd78876"

# curl -H "X-MBX-APIKEY: dbefbc809e3e83c283a984c3a1459732ea7db1360ca80c5c2c8867408d28cc83" -X POST 'https://fapi.binance.com/fapi/v1/order?symbol=BTCUSDT&side=BUY&type=LIMIT&quantity=1&price=9000&timeInForce=GTC&recvWindow=5000&timestamp=1591702613943&signature= 3c661234138461fcc7a7d8746c6558c9842d4e10870d2ecbedf7777cad694af9'

# ret = os.system( f' echo -n "recvWindow=5000&timestamp={int(time.time())-10 }999" | openssl dgst -sha256 -hmac "4f58b518cecdfe9c574cd2aa9cbbea429796673d6226424bdda1f0155cd78876" ' )

stdin = os.popen(cmd).read()
print(f'{stdin}')
sign = stdin[9:-1]
# print(f'{sign}')

cmd2 = f'curl -H "X-MBX-APIKEY: fcc2838327a124367acd634323b93b1fb53d6fc66e84d679169a78adcaf1bf3e" -XGET "http://testnet.binancefuture.com/fapi/v2/balance?recvWindow=5000&timestamp={ts}&signature={sign}" '
print(f'{cmd2}')

ret = os.popen(cmd2).read()
print(f'{ret}')


------------------------------

#K线数据
响应:

[
  [
    1499040000000,      // 开盘时间  2017-7-3 8:0:0
    "0.01634790",       // 开盘价
    "0.80000000",       // 最高价
    "0.01575800",       // 最低价
    "0.01577100",       // 收盘价(当前K线未结束的即为最新价)
    "148976.11427815",  // 成交量
    1499644799999,      // 收盘时间 2017-7-10 7:59:59     
    "2434.19055334",    // 成交额
    308,                // 成交笔数
    "1756.87402397",    // 主动买入成交量
    "28.46694368",      // 主动买入成交额
    "17928899.62484339" // 请忽略该参数
  ]
]
GET /fapi/v1/klines

每根K线的开盘时间可视为唯一ID

权重: 取决于请求中的LIMIT参数

LIMIT参数	权重
[1,100)	1
[100, 500)	2
[500, 1000]	5
> 1000	10
参数:

名称	类型	是否必需	描述
symbol	STRING	YES	交易对
interval	ENUM	YES	时间间隔
startTime	LONG	NO	起始时间
endTime	LONG	NO	结束时间
limit	INT	NO	默认值:500 最大值:1500.
缺省返回最近的数据

------------------------------

#连续合约K线数据
响应:

[
  [
    1607444700000,      // 开盘时间  opentime
    "18879.99",         // 开盘价  openprice
    "18900.00",         // 最高价 highprice
    "18878.98",         // 最低价  lowprice 
    "18896.13",         // 收盘价(当前K线未结束的即为最新价) closeprice
    "492.363",          // 成交量  volume
    1607444759999,      // 收盘时间  closetime
    "9302145.66080",    // 成交额  totalamount
    1874,               // 成交笔数  number
    "385.983",          // 主动买入成交量  activevolume
    "7292402.33267",    // 主动买入成交额  activeamount 
    "0"                 // 请忽略该参数   p12
  ]
]

	'gatewaytype': 0,
	'tradetype': 1,
	'symbol': 'BTCUSDT',
	'interval': 3,
		'opentime': 1654145100000,  1654145100   20220602124500 
		'closetime': 1654145999999, 1654145999   20220602125959 
		'openprice': '29792.6',
		'closeprice': '29789.4',
		'highprice': '29800',
		'lowprice': '29782',
		'volume': '270.876',
		'number': 4610,
		'totalamount': '8069541.7193',
		'activevolume': '109.782',
		'activeamount': '3270500.6415'


#IP 代理

GET /fapi/v1/continuousKlines 每根K线的开盘时间可视为唯一ID

www.binance.com/fapi/v1/continuousKlines?pair=BTCUSDT&contractType=PERPETUAL&interval=1m&limit=50


pair = "BTCUSDT"
param = {'pair':pair,'contractType':'PERPETUAL','interval':'1m','startTime':'1655417700000','endTime':'1655418600999','limit':'50'}
response = requests.get("http://www.binance.com/fapi/v1/continuousKlines", params=param,headers={'Connection':'close'} )
# response = requests.get("http://www.binance.com/fapi/v1/ping",headers={'Connection':'close'} )
# response = requests.get("http://www.baidu.com",headers={'Connection':'close'} )
data = json.loads(response.text)

print(f'{response = }')
print(f'{data = }')


权重: 取决于请求中的LIMIT参数

LIMIT参数	权重
[1,100)	1
[100, 500)	2
[500, 1000]	5
> 1000	10
参数:

名称	类型	是否必需	描述
pair	STRING	YES	标的交易对
contractType	ENUM	YES	合约类型
interval	ENUM	YES	时间间隔
startTime	LONG	NO	起始时间
endTime	LONG	NO	结束时间
limit	INT	NO	默认值:500 最大值:1500
缺省返回最近的数据

合约类型:

PERPETUAL 永续合约
CURRENT_MONTH 当月交割合约
NEXT_MONTH 次月交割合约
CURRENT_QUARTER 当季交割合约
NEXT_QUARTER 次季交割合约


----深度信息--------------------------

深度信息
响应:

{
  "lastUpdateId": 1027024,
  "E": 1589436922972,   // 消息时间
  "T": 1589436922959,   // 撮合引擎时间
  "bids": [             // 买单
    [
      "4.00000000",     // 价格
      "431.00000000"    // 数量
    ]
  ],
  "asks": [             // 卖单
    [
      "4.00000200",     // 价格
      "12.00000000"     // 数量
    ]
  ]
}
GET /fapi/v1/depth

权重:

limit	权重
5, 10, 20, 50	2
100	5
500	10
1000	20
参数:

名称	类型	是否必需	描述
symbol	STRING	YES	交易对
limit	INT	NO	默认 500; 可选值:[5, 10, 20, 50, 100, 500, 1000]

### 深度信息
GET {{fapi}}/depth?symbol=btcusdt&limit=20



----标记价格K线数据--------------------------

#标记价格K线数据
响应:

[
  [
    1591256400000,          //  开盘时间  opentime
    "9653.69440000",        //  开盘价  openprice
    "9653.69640000",        //  最高价 highprice
    "9651.38600000",        //  最低价  lowprice 
    "9651.55200000",        //  收盘价(当前K线未结束的即为最新价) closeprice
    "0  ",                  //  请忽略	--成交量  volume
    1591256459999,          //  收盘时间  closetime
    "0",                    //  请忽略	--成交额  totalamount
    60,                     //  构成记录数		成交笔数  number
    "0",                    //  请忽略	--主动买入成交量  activevolume
    "0",                    //  请忽略	--主动买入成交额  activeamount 
    "0"                     //  请忽略该参数   p12
  ]
]



GET /fapi/v1/markPriceKlines 每根K线的开盘时间可视为唯一ID

权重: 取决于请求中的LIMIT参数

LIMIT参数	权重
[1,100)	1
[100, 500)	2
[500, 1000]	5
> 1000	10
参数:

名称	类型	是否必需	描述
symbol	STRING	YES	交易对
interval	ENUM	YES	时间间隔
startTime	LONG	NO	起始时间
endTime	LONG	NO	结束时间
limit	INT	NO	默认值:500 最大值:1500
缺省返回最近的数据


------------------------------

highamp={'BTCUSDT': 0.457, 'ETHUSDT': 0.632, 'BTCBUSD': 0.45, 'BELUSDT': 1.234, 'SOLUSDT': 1.398, 'ADAUSDT': 1.037, 'ETHBUSD': 0.655, 'GMTUSDT': 1.549, 'BNBUSDT': 0.521, 'WAVESUSDT': 1.139, 'BLZUSDT': 1.603, 'RSRUSDT': 1.443, 'EOSUSDT': 0.65, 'FILUSDT': 0.601, 'BCHUSDT': 0.984, 'ARPAUSDT': 1.629, 'ENSUSDT': 0.972, 'ALGOUSDT': 0.856, 'KNCUSDT': 1.234, 'LRCUSDT': 1.267, 'MASKUSDT': 1.251, 'COTIUSDT': 1.351, 'DYDXUSDT': 0.881, 'TRXUSDT': 0.983, 'FLMUSDT': 0.838, 'FTMUSDT': 1.288, '1000SHIBUSDT': 0.484, 'AXSUSDT': 1.11, 'LINAUSDT': 1.22, 'LITUSDT': 0.709, 'TRBUSDT': 1.391, 'XRPUSDT': 0.669, 'THETAUSDT': 1.429, 'MTLUSDT': 1.443, 'ADABUSD': 1.018, 'C98USDT': 1.372, 'LTCUSDT': 0.779, 'AVAXUSDT': 1.066, 'UNFIUSDT': 1.794, 'ALICEUSDT': 1.564, 'LINKUSDT': 1.018, 'ATAUSDT': 1.022, 'ETCUSDT': 0.656, 'MATICUSDT': 0.8, 'SANDUSDT': 1.071, 'NEARUSDT': 1.216, 'CTSIUSDT': 1.037, 'BAKEUSDT': 0.983, 'XTZUSDT': 0.949, 'EGLDUSDT': 1.061, 'GALUSDT': 1.049, 'CRVUSDT': 0.745, 'BNBBUSD': 0.536, 'OPUSDT': 2.086, 'ATOMUSDT': 1.07, 'MANAUSDT': 1.265, 'DOTUSDT': 0.762, 'APEUSDT': 1.532, 'OCEANUSDT': 1.289, 'DOGEUSDT': 0.63, '1000LUNCBUSD': 0.343, 'RUNEUSDT': 0.64, 'ZILUSDT': 0.888, 'PEOPLEUSDT': 1.255, 'SOLBUSD': 1.433, 'LUNA2BUSD': 0.966, 'AAVEUSDT': 0.967, 'OGNUSDT': 2.972, 'GALAUSDT': 1.563}


----获取交易规则和交易对--------------------------


### 获取交易规则和交易对 U本位
@fapi = http://www.binance.com/fapi/v1
GET {{fapi}}/exchangeInfo


Symbol	Min. Trade Amount	Min. Order Price / Min. Price Movement	Limit Order Price Cap / Floor Ratio	Max. Market Order / Limit Order Amount	Max. Number of Open Orders	Price Protection Threshold	Liquidation Clearance Fee	Min. Notional Value	Market Order Price Cap/Floor Ratio
合约	最小下单数量	最小下单价格/最小价格波动	限价订单价格上限/下限比例	市价单/限价单单笔最大数量	最大挂单数量	价差保护阈值	强平清算费	最小名义价值	市价单价格上限/下限比例
									
BTCUSDT Perpetual	0.001 BTC	556.80 /0.10 USDT	5% / 5%	120 /1000 BTC	200	0.05	0.0175	5 USDT	0.05

{
    "exchangeFilters": [],
    "rateLimits": [ // API访问的限制
        {
            "interval": "MINUTE", // 按照分钟计算
            "intervalNum": 1, // 按照1分钟计算
            "limit": 2400, // 上限次数
            "rateLimitType": "REQUEST_WEIGHT" // 按照访问权重来计算
        },
        {
            "interval": "MINUTE",
            "intervalNum": 1,
            "limit": 1200,
            "rateLimitType": "ORDERS" // 按照订单数量来计算
        }
    ],
    "serverTime": 1565613908500, // 请忽略。如果需要获取当前系统时间，请查询接口 “GET /fapi/v1/time”
    "assets": [ // 资产信息
        {
            "asset": "BUSD",
            "marginAvailable": true, // 是否可用作保证金
            "autoAssetExchange": 0 // 保证金资产自动兑换阈值
        },
        {
            "asset": "USDT",
            "marginAvailable": true, // 是否可用作保证金
            "autoAssetExchange": 0 // 保证金资产自动兑换阈值
        },
        {
            "asset": "BNB",
            "marginAvailable": false, // 是否可用作保证金
            "autoAssetExchange": null // 保证金资产自动兑换阈值
        }
    ],
    "symbols": [ // 交易对信息
        {
            "symbol": "BLZUSDT",  // 交易对
            "pair": "BLZUSDT",  // 标的交易对
            "contractType": "PERPETUAL",    // 合约类型
            "deliveryDate": 4133404800000,  // 交割日期
            "onboardDate": 1598252400000,     // 上线日期
            "status": "TRADING",  // 交易对状态
            "maintMarginPercent": "2.5000",  // 请忽略
            "requiredMarginPercent": "5.0000", // 请忽略
            "baseAsset": "BLZ",  // 标的资产
            "quoteAsset": "USDT", // 报价资产
            "marginAsset": "USDT", // 保证金资产
            "pricePrecision": 5,  // 价格小数点位数(仅作为系统精度使用，注意同tickSize 区分）
            "quantityPrecision": 0,  // 数量小数点位数(仅作为系统精度使用，注意同stepSize 区分）
            "baseAssetPrecision": 8,  // 标的资产精度
            "quotePrecision": 8,  // 报价资产精度
            "underlyingType": "COIN",
            "underlyingSubType": ["STORAGE"],
            "settlePlan": 0,
            "triggerProtect": "0.15", // 开启"priceProtect"的条件订单的触发阈值
            "filters": [
                {
                    "filterType": "PRICE_FILTER", // 价格限制
                    "maxPrice": "300", // 价格上限, 最大价格
                    "minPrice": "0.0001", // 价格下限, 最小价格
                    "tickSize": "0.0001" // 订单最小价格间隔
                },
                {
                    "filterType": "LOT_SIZE", // 数量限制
                    "maxQty": "10000000", // 数量上限, 最大数量
                    "minQty": "1", // 数量下限, 最小数量
                    "stepSize": "1" // 订单最小数量间隔
                },
                {
                    "filterType": "MARKET_LOT_SIZE", // 市价订单数量限制
                    "maxQty": "590119", // 数量上限, 最大数量
                    "minQty": "1", // 数量下限, 最小数量
                    "stepSize": "1" // 允许的步进值
                },
                {
                    "filterType": "MAX_NUM_ORDERS", // 最多订单数限制
                    "limit": 200
                },
                {
                    "filterType": "MAX_NUM_ALGO_ORDERS", // 最多条件订单数限制
                    "limit": 100
                },
                {
                    "filterType": "MIN_NOTIONAL",  // 最小名义价值
                    "notional": "1", 
                },
                {
                    "filterType": "PERCENT_PRICE", // 价格比限制
                    "multiplierUp": "1.1500", // 价格上限百分比
                    "multiplierDown": "0.8500", // 价格下限百分比
                    "multiplierDecimal": 4
                }
            ],
            "OrderType": [ // 订单类型
                "LIMIT",  // 限价单
                "MARKET",  // 市价单
                "STOP", // 止损单
                "STOP_MARKET", // 止损市价单
                "TAKE_PROFIT", // 止盈单
                "TAKE_PROFIT_MARKET", // 止盈暑市价单
                "TRAILING_STOP_MARKET" // 跟踪止损市价单
            ],
            "timeInForce": [ // 有效方式
                "GTC", // 成交为止, 一直有效
                "IOC", // 无法立即成交(吃单)的部分就撤销
                "FOK", // 无法全部立即成交就撤销
                "GTX" // 无法成为挂单方就撤销
            ],
            "liquidationFee": "0.010000",   // 强平费率
            "marketTakeBound": "0.30",  // 市价吃单(相对于标记价格)允许可造成的最大价格偏离比例
        }
    ],
    "timezone": "UTC" // 服务器所用的时间区域
}


  "symbols": [
    {
      "symbol": "BTCUSDT",
      "pair": "BTCUSDT",
      "contractType": "PERPETUAL",
      "deliveryDate": 4133404800000,
      "onboardDate": 1569398400000,
      "status": "TRADING",
      "maintMarginPercent": "2.5000",
      "requiredMarginPercent": "5.0000",
      "baseAsset": "BTC",
      "quoteAsset": "USDT",
      "marginAsset": "USDT",
      "pricePrecision": 2,
      "quantityPrecision": 3,
      "baseAssetPrecision": 8,
      "quotePrecision": 8,
      "underlyingType": "COIN",
      "underlyingSubType": [
        "PoW"
      ],
      "settlePlan": 0,
      "triggerProtect": "0.0500",
      "liquidationFee": "0.017500",
      "marketTakeBound": "0.05",
      "filters": [
        {
          "minPrice": "556.80",
          "maxPrice": "4529764",
          "filterType": "PRICE_FILTER",
          "tickSize": "0.10"
        },
        {
          "stepSize": "0.001",
          "filterType": "LOT_SIZE",
          "maxQty": "1000",
          "minQty": "0.001"
        },
        {
          "stepSize": "0.001",
          "filterType": "MARKET_LOT_SIZE",
          "maxQty": "120",
          "minQty": "0.001"
        },
        {
          "limit": 200,
          "filterType": "MAX_NUM_ORDERS"
        },
        {
          "limit": 10,
          "filterType": "MAX_NUM_ALGO_ORDERS"
        },
        {
          "notional": "5",
          "filterType": "MIN_NOTIONAL"
        },
        {
          "multiplierDown": "0.9500",
          "multiplierUp": "1.0500",
          "multiplierDecimal": "4",
          "filterType": "PERCENT_PRICE"
        }

----binancefuture--------------------------

    "symbols": [{
            "symbol": "BTCUSDT",
            "pair": "BTCUSDT",
            "contractType": "PERPETUAL",
            "deliveryDate": 4133404802000,
            "onboardDate": 1569398400000,
            "status": "TRADING",
            "maintMarginPercent": "2.5000",
            "requiredMarginPercent": "5.0000",
            "baseAsset": "BTC",
            "quoteAsset": "USDT",
            "marginAsset": "USDT",
            "pricePrecision": 2,
            "quantityPrecision": 3,
            "baseAssetPrecision": 8,
            "quotePrecision": 8,
            "underlyingType": "COIN",
            "underlyingSubType": [],
            "settlePlan": 0,
            "triggerProtect": "0.0500",
            "liquidationFee": "0.020000",
            "marketTakeBound": "0.30",
            "filters": [{
                    "minPrice": "191.90",
                    "maxPrice": "595006.40",
                    "filterType": "PRICE_FILTER",
                    "tickSize": "0.10"
                }, {
                    "stepSize": "0.001",
                    "filterType": "LOT_SIZE",
                    "maxQty": "1000",
                    "minQty": "0.001"
                }, {
                    "stepSize": "0.001",
                    "filterType": "MARKET_LOT_SIZE",
                    "maxQty": "1000",
                    "minQty": "0.001"
                }, {
                    "limit": 200,
                    "filterType": "MAX_NUM_ORDERS"
                }, {
                    "limit": 10,
                    "filterType": "MAX_NUM_ALGO_ORDERS"
                }, {
                    "notional": "10",
                    "filterType": "MIN_NOTIONAL"
                }, {
                    "multiplierDown": "0.5454",
                    "multiplierUp": "1.1000",
                    "multiplierDecimal": "4",
                    "filterType": "PERCENT_PRICE"
                }
            ],
            "orderTypes": ["LIMIT", "MARKET", "STOP", "STOP_MARKET", "TAKE_PROFIT", "TAKE_PROFIT_MARKET", "TRAILING_STOP_MARKET"],
            "timeInForce": ["GTC", "IOC", "FOK", "GTX"]
        }, {

------------------------------

simi  18080 19090
curl -X POST -d '{"method":"hello","params":["simi","0.001",18080,19090]}' http://127.0.0.1:8888/strategy

{"success":true,"message":"{\"name\":\"simi\" , \"time\":1654137561338, \"id\":55}"}

curl -X POST -d '{"method":"recharge","params":["simi","USDT","10000"]}' http://127.0.0.1:8888/strategy

{"success":true,"message":""}

python3 main.py -n simi -s 18080 -c 19090 -X BTCUSDT  -t 1000




seconds_time = int(time.mktime(time.strptime(parts[0], '%Y%m%d %H%M%S')))

int(time.mktime(time.strptime('20220601 164500', '%Y%m%d %H%M%S')))
1654073100

1499827319559

import time
seconds = 1555840541.92
timeArray = time.localtime(seconds)
otherStyleTime = time.strftime("%Y-%m-%d %H:%M:%S", timeArray)

time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(1555840541) )

'2019-04-21 17:55:41'


60 * 24 = 1440 * 10

import time 

time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(1555840541) )



time.strftime("%Y%m%d %H%M%S", time.localtime(1654151579999/10^3) )

print(time.strftime("%Y%m%d" ) )

print( time.strftime("%Y%m%d", time.localtime(time.time()-60*60*24*10 ) )  )

print( int(time.mktime(time.strptime(time.strftime("%Y%m%d", time.localtime(time.time()-60*60*24*10 ) ), '%Y%m%d')))  )

print( time.strftime("%Y%m%d %H%M%S", time.localtime(1653321600 ) )  )

-------------------------------------------

print(time.time() )
print(time.time()-60*60*24*10)
print(60*60*24*10)
print(int(time.mktime(time.strptime(time.strftime("%Y%m%d", time.localtime(time.time()-60*60*24*10 ) ), '%Y%m%d'))) )
print( time.time() - int(time.mktime(time.strptime(time.strftime("%Y%m%d", time.localtime(time.time()-60*60*24*10 ) ), '%Y%m%d')))  )

print( math.ceil( (time.time() - int(time.mktime(time.strptime(time.strftime("%Y%m%d", time.localtime(time.time()-60*60*24*10 ) ), '%Y%m%d'))) )/60 ) )

-------------------------------------------


cli.uklines('binance', symbol=symbol, interval=interval, limit=k_line_number+1)

df = pd.DataFrame([{'open_time': rs.opentime, 
		'close_price': rs.closeprice} for rs in data.result])



		'gatewaytype': 0,
		'tradetype': 1,
		'symbol': 'BTCUSDT',
		'interval': 3,
		'opentime': 1654145100000,  1654145100   20220602124500 
		'closetime': 1654145999999, 1654145999   20220602125959 
		'openprice': '29792.6',
		'closeprice': '29789.4',
		'highprice': '29800',
		'lowprice': '29782',
		'volume': '270.876',
		'number': 4610,
		'totalamount': '8069541.7193',
		'activevolume': '109.782',
		'activeamount': '3270500.6415'
		
		
		
		
		

------------------------------



------------------------------

curl -X POST -d '{"method":"queryWorth","params":["similarity",0,0,10]}' http://127.0.0.1:8888/strategy
{
	"result": [{
			"cashworth": "98999.0044339514",
			"usdtcontractworth": "1008.15840480116",
			"tokencontractworth": "0",
			"time": 1655163930371,
			"keyid": 0,
			"strategyID": 5
		}, {
			"cashworth": "98999.0044339514",
			"usdtcontractworth": "1015.48117896154",
			"tokencontractworth": "0",
			"time": 1655163625943,
			"keyid": 0,
			"strategyID": 5
		}, {
			"cashworth": "98999.0044339514",
			"usdtcontractworth": "1015.30842760832",
			"tokencontractworth": "0",
			"time": 1655163322436,
			"keyid": 0,
			"strategyID": 5
		}, {
			"cashworth": "98999.0044339514",
			"usdtcontractworth": "1020.01257984213",
			"tokencontractworth": "0",
			"time": 1655163018622,
			"keyid": 0,
			"strategyID": 5
		}, {
			"cashworth": "98999.0044339514",
			"usdtcontractworth": "1009.69179386777",
			"tokencontractworth": "0",
			"time": 1655162715321,
			"keyid": 0,
			"strategyID": 5
		}, {
			"cashworth": "98999.0044339514",
			"usdtcontractworth": "1011.0621230375",
			"tokencontractworth": "0",
			"time": 1655162411101,
			"keyid": 0,
			"strategyID": 5
		}, {
			"cashworth": "98999.0044339514",
			"usdtcontractworth": "1014.86104589871",
			"tokencontractworth": "0",
			"time": 1655162107749,
			"keyid": 0,
			"strategyID": 5
		}, {
			"cashworth": "98999.0044339514",
			"usdtcontractworth": "1011.46803214061",
			"tokencontractworth": "0",
			"time": 1655161804492,
			"keyid": 0,
			"strategyID": 5
		}, {
			"cashworth": "98999.0044339514",
			"usdtcontractworth": "1009.04070871774",
			"tokencontractworth": "0",
			"time": 1655161500711,
			"keyid": 0,
			"strategyID": 5
		}, {
			"cashworth": "100000",
			"usdtcontractworth": "0",
			"tokencontractworth": "0",
			"time": 1655161195565,
			"keyid": 0,
			"strategyID": 5
		}
	]
}

curl -X POST -d '{"method":"queryAllBalances","params":["similarity"]}' http://127.0.0.1:8888/strategy
{
	"result": [{
			"asset": "USDT",
			"free": "98999.0044339514",
			"locked": "0",
			"strategyID": 5
		}
	]
}

curl -X POST -d '{"method":"queryAllPositions","params":["similarity"]}' http://127.0.0.1:8888/strategy
{
	"result": [{
			"symbol": "BTCUSDT",
			"positionAmount": "0.0442952187740855",
			"enterprice": "22575.7",
			"countrevence": "0",
			"unrealprofit": "5.95661340639091077481637",
			"marginmodel": 0,
			"isolatedmargin": "0",
			"positionside": 1,
			"markprice": "22441.22468706",
			"strategyID": 5
		}
	]
}

{
    "result": [{
            "symbol": "BTCUSDT",
            "positionAmount": "0.466766243465273",
            "enterprice": "21424.1",
            "countrevence": "0",
            "unrealprofit": "-304.8450336071697963",
            "marginmodel": 0,
            "isolatedmargin": "0",
            "positionside": 0,
            "markprice": "20771",
            "strategyID": 5
        }, {
            "symbol": "ETHUSDT",
            "positionAmount": "8.32279113123377",
            "enterprice": "1201.53",
            "countrevence": "0",
            "unrealprofit": "-110.6308488414674671244175",
            "marginmodel": 0,
            "isolatedmargin": "0",
            "positionside": 0,
            "markprice": "1188.23748225",
            "strategyID": 5
        }
    ]
}

curl -X POST -d '{"method":"queryAllPositions","params":["similarity"]}' http://127.0.0.1:8888/strategy

{
    "result": [{
            "symbol": "BTCUSDT",
            "positionAmount": "0.466766243465273",
            "enterprice": "21424.1",
            "countrevence": "0",
            "unrealprofit": "-530.4798356982827645",
            "marginmodel": 0,
            "isolatedmargin": "0",
            "positionside": 0,
            "markprice": "20287.6",
            "strategyID": 5
        }, {
            "symbol": "ETHUSDT",
            "positionAmount": "8.71368571478364",
            "enterprice": "1147.42",
            "countrevence": "0",
            "unrealprofit": "8.1797631620222729469672",
            "marginmodel": 0,
            "isolatedmargin": "0",
            "positionside": 1,
            "markprice": "1146.48127402",
            "strategyID": 5
        }
    ]
}

curl -X POST -d '{"method":"queryTrade","params":["similarity",0,0,5]}' http://127.0.0.1:8888/strategy
{
    "result": [{
            "symbol": "BTCUSDT",
            "tradeid": 1655568000709,
            "clientorderid": "45751F1655568000616I0L5",
            "price": "18946.7",
            "quantity": "0.0479501116549214",
            "commission": "0.908496380492299",
            "commissionasset": "USDT",
            "tradetime": 1655568000709,
            "tradetype": 1,
            "strategyID": 5
        }, {
            "symbol": "BTCUSDT",
            "tradeid": 1655506800757,
            "clientorderid": "45750F1655506800517I0L5",
            "price": "20439.8",
            "quantity": "0.489196104042227",
            "commission": "9.99907052740232",
            "commissionasset": "USDT",
            "tradetime": 1655506800757,
            "tradetype": 1,
            "strategyID": 5
        }, {
            "symbol": "BTCUSDT",
            "tradeid": 1655334005844,
            "clientorderid": "45749F1655334005756I0L5",
            "price": "22476.3",
            "quantity": "0.441245992387306",
            "commission": "9.91757729869481",
            "commissionasset": "USDT",
            "tradetime": 1655334005844,
            "tradetype": 1,
            "strategyID": 5
        }, {
            "symbol": "BTCUSDT",
            "tradeid": 1655308805168,
            "clientorderid": "45748F1655308805071I0L5",
            "price": "21408.9",
            "quantity": "0.46337914608491",
            "commission": "9.92043780061723",
            "commissionasset": "USDT",
            "tradetime": 1655308805168,
            "tradetype": 1,
            "strategyID": 5
        }, {
            "symbol": "BTCUSDT",
            "tradeid": 1655247604421,
            "clientorderid": "41598F1655247603996I0L5",
            "price": "21577.7",
            "quantity": "0.46337914608491",
            "commission": "9.99865620047635",
            "commissionasset": "USDT",
            "tradetime": 1655247604421,
            "tradetype": 1,
            "strategyID": 5
        }
    ]
}



2022-06-15 00:00:04,849:INFO:similarity:main.py:95:handleKline:383103: ukdf.iloc[-5:,:]=      tradeDate openTime closeTime    closeSec     open    close
12235  20220614   231000    231959  1655219999  22586.5  22461.3
12236  20220614   232000    232959  1655220599  22461.3  22462.1
12237  20220614   233000    233959  1655221199  22462.1  22469.8
12238  20220614   234000    234959  1655221799  22469.9  22662.3
12239  20220614   235000    235959  1655222399  22662.3  22672.6

2022-06-15 00:00:04,849:INFO:similarity:main.py:96:handleKline:383103: self.flagDict={'side': 'sell', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': True, 'isCloseBuy': False, 'isCloseSell': False, 'isOpen': True, 'isClose': False, 'isTrig': True, 'isCorr': False}

closeSell: symbol='BTCUSDT', positions=
PositionsType{'result': [PositionType{'symbol': 'BTCUSDT', 'positionAmount': '0.0442952187740855', 'enterprice': '22575.7', 'countrevence': '0', 'unrealprofit': '-4.38079713675705595', 'marginmodel': 0, 'isolatedmargin': '0', 'positionside': 'short', 'markprice': '22674.6'}]}

positions.result[0].positionAmount,

2022-06-15 00:00:05,077:INFO:similarity:main.py:214:closeSell:383103: self.flagDict={'side': 'buy', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': False, 'isCloseBuy': True, 'isCloseSell': True, 'isOpen': False, 'isClose': True, 'isTrig': False, 'isCorr': False}

2022-06-15 00:00:05,078:INFO:similarity:main.py:215:closeSell:383103: self.client.insertMarketUOrder("simulator", 0, BTCUSDT, 0.0442952187740855, "buy")

127.0.0.1 - - [15/Jun/2022 00:00:05] "POST / HTTP/1.1" 200 -

2022-06-15 00:00:05,105:INFO:similarity:main.py:252:handleOrderNew:383103: handleOrderNew: data=OrderType{'clientorderid': '33976F1655222404978I0L5', 'symbol': 'BTCUSDT', 'gatewayorderid': 0, 'quantity': '0.0442952187740855', 'price': '22672.8', 'stopprice': '0', 'ordertype': '', 'side': 'BUY', 'status': 'FILLED', 'positionside': '', 'createtime': 0, 'updatetime': 0, 'tradetype': 'usdt', 'selfid': 33976, 'filltrades': [TradeType{'symbol': 'BTCUSDT', 'tradeid': 1655222405066, 'clientorderid': '33976F1655222404978I0L5', 'price': '22672.8', 'quantity': '0.0442952187740855', 'commission': '1.00429663622108574530612342036481', 'commissionasset': 'USDT', 'tradetime': 1655222405066, 'tradetype': 'usdt'}]}

127.0.0.1 - - [15/Jun/2022 00:00:05] "POST / HTTP/1.1" 200 -

2022-06-15 00:00:05,137:INFO:similarity:main.py:255:handleOrderFilled:383103: handleOrderFilled: data=
OrderType{'clientorderid': '33976F1655222404978I0L5', 'symbol': 'BTCUSDT', 'gatewayorderid': 0, 'quantity': '0.0442952187740855', 'price': '22672.8', 'stopprice': '0', 'ordertype': '', 'side': 'BUY', 'status': 'FILLED', 'positionside': '', 'createtime': 0, 'updatetime': 0, 'tradetype': 'usdt', 'selfid': 33976, 'filltrades': [TradeType{'symbol': 'BTCUSDT', 'tradeid': 1655222405066, 'clientorderid': '33976F1655222404978I0L5', 'price': '22672.8', 'quantity': '0.0442952187740855', 'commission': '1.00429663622108574530612342036481', 'commissionasset': 'USDT', 'tradetime': 1655222405066, 'tradetype': 'usdt'}]}

data.filltrades[0].quantity   price commission


127.0.0.1 - - [15/Jun/2022 00:10:04] "POST / HTTP/1.1" 200 -

--handleKline--:  self.name='similarity', self.symbol='BTCUSDT', interval='10m', intervalSec=600, self.count=143 

self.closeSec=1655222999, self.tradeDate='20220615', self.openTime='000000', self.closeTime='000959', self.symbol='BTCUSDT', self.open='22672.6', self.close='22593.4'
2022-06-15 00:10:04,869:INFO:similarity:main.py:94:handleKline:383103: self.closeSec=1655222999, self.tradeDate='20220615', self.openTime='000000', self.closeTime='000959',self.symbol='BTCUSDT',self.open='22672.6', self.close='22593.4'




------------------------------



------------------------------


2.	Similarity.py
a)	截取前面半天的k线, 去寻找历史上N天前走势最相似的一天, 如果那天的后半天是上涨的, 那么做多, 如果是下跌的, 则做空, 当天日终平仓。


curl -X POST -d '{"method":"hello","params":["simi","0.001",18080,19090]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"recharge","params":["simi","USDT","1000000"]}' http://127.0.0.1:8888/strategy


python3 main.py -n simi -s 18080 -c 19090 -X BTCUSDT  -t 1000



simi  18080 19090
curl -X POST -d '{"method":"hello","params":["simi","0.001",18080,19090]}' http://127.0.0.1:8888/strategy

{"success":true,"message":"{\"name\":\"simi\" , \"time\":1654137561338, \"id\":55}"}

curl -X POST -d '{"method":"recharge","params":["simi","USDT","10000"]}' http://127.0.0.1:8888/strategy

{"success":true,"message":""}

python3 main.py -n simi -s 18080 -c 19090 -X BTCUSDT -p 3m -t 1000
curl -X POST -d '{"method":"hello","params":["simi","0.001",18080,19090]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"recharge","params":["simi","USDT","10000"]}' http://127.0.0.1:8888/strategy

python3 main.py -n simil -s 18081 -c 19091 -X BTCUSDT -p 5m -t 10000
python3 main.py -n simila -s 18082 -c 19092 -X BTCUSDT -p 15m -t 10000

simil  18081 19091  , 100000 :10000 , 90895
curl -X POST -d '{"method":"hello","params":["simil","0.001",18081,19091]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"recharge","params":["simila","USDT","100000"]}' http://127.0.0.1:8888/strategy
nohup python3 main.py -n simil -s 18081 -c 19091 -X BTCUSDT -p 15m -t 10000 &


curl -X POST -d '{"method":"queryWorth","params":["similarity",0,0,10]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryAllBalances","params":["similarity"]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryAllPositions","params":["similarity"]}' http://127.0.0.1:8888/strategy




curl -X POST -d '{"method":"hello","params":["simi","0.001",18080,19090]}' http://127.0.0.1:8888/strategy
#curl -X POST -d '{"method":"recharge","params":["simi","USDT","10000"]}' http://127.0.0.1:8888/strategy
python3 main.py -n simi -s 18080 -c 19090 -X BTCUSDT -p 3m -t 1000

curl -X POST -d '{"method":"hello","params":["simil","0.001",18081,19091]}' http://127.0.0.1:8888/strategy
#curl -X POST -d '{"method":"recharge","params":["simil","USDT","100000"]}' http://127.0.0.1:8888/strategy
nohup python3 main.py -n simil -s 18081 -c 19091 -X BTCUSDT -p 5m -t 10000 &

curl -X POST -d '{"method":"hello","params":["simil","0.001",18081,19091]}' http://127.0.0.1:8888/strategy
#curl -X POST -d '{"method":"recharge","params":["simil","USDT","100000"]}' http://127.0.0.1:8888/strategy
nohup python3 main.py -n simil -s 18081 -c 19091 -X BTCUSDT -p 10m -w 42 -d 84 -t 10000  &

curl -X POST -d '{"method":"hello","params":["simila","0.001",18082,19092]}' http://127.0.0.1:8888/strategy
#curl -X POST -d '{"method":"recharge","params":["simila","USDT","100000"]}' http://127.0.0.1:8888/strategy
nohup python3 main.py -n simila -s 18082 -c 19092 -X BTCUSDT -p 15m -t 10000  > simila15.out 2>&1 &
nohup python3 main.py -n simila -s 18082 -c 19092 -X BTCUSDT -p 15m -t 10000  &

curl -X POST -d '{"method":"hello","params":["similar","0.001",18083,19093]}' http://127.0.0.1:8888/strategy
#curl -X POST -d '{"method":"recharge","params":["similar","USDT","100000"]}' http://127.0.0.1:8888/strategy
nohup python3 main.py -n similar -s 18083 -c 19093 -X BTCUSDT -p 1m -t 10000 > similar.out 2>&1 &


curl -X POST -d '{"method":"hello","params":["similarity","0.001",18010,19010]}' http://127.0.0.1:8888/strategy
#curl -X POST -d '{"method":"recharge","params":["similarity","USDT","100000"]}' http://127.0.0.1:8888/strategy
nohup python3 main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1 &


curl -X POST -d '{"method":"queryWorth","params":["similarity",0,0,1]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryAllBalances","params":["similarity"]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryAllPositions","params":["similarity"]}' http://127.0.0.1:8888/strategy




------------------------------


------------------------------

python中if、for、with等语句中变量的作用域


一般情况下在python中, 类似于if、for、with之类操作内的变量都是可以循环或者判断语句外部访问的：
之前一直觉得if、for语句外面就不能用了, coding的时候也没有太在意这回事。。。今天看到别人的程序with语句外面突然有个没定义的变量, 才知道。。。

for i in range(4):
    print('i={}'.format(i))
print(i)
'''
--output--
i=0
i=1
i=2
i=3
3
'''
for循环完了之后, 变量i还是能直接访问的, 是最后一个值, 有的时候会疏忽, 切记切记。

a = 1
if a>0:
    b = 2
    print('b={}'.format(b))
print(b)
'''
--output--
b=2
2
'''
with语句也是一样的, 在内部定义的在外部可以访问的。

with open('./a.txt','a') as f:
    i = 3
print(i)  
'''
--output--
3
'''


----SQL--------------------------

--select sid from info where name in ('Panel_mom', 'Pyemd2', 'similarity')
--select id, cashworth, usdtcontractworth, tokencontractworth, time, keyid, sid, datetime(time/1000, 'unixepoch', 'localtime') as dt from worth where sid = 5 and time in ( select max(time) from worth where sid=5)
--select * from worth where sid = 5 and time in ( select min(time) from worth where sid=5)
--select count(*) from trades where sid = 5
--created in (SELECT max(created) FROM table
--select datetime(1627951014000/1000, 'unixepoch', 'localtime') from dual
--SELECT date('now') as dt
--SELECT datetime(1092941466, 'unixepoch'), datetime(1092941466, 'unixepoch', 'localtime') 
--DELETE FROM Websites WHERE name='Facebook' AND country='USA'
--UPDATE Websites SET alexa='5000', country='USA' WHERE name='菜鸟教程'
--INSERT INTO Websites (name, url, alexa, country) VALUES ('百度','https://www.baidu.com/','4','CN')
--DELETE FROM balance WHERE asset='BNB' ;
SELECT id, symbol, positionside, positionAmount, opentime, enterprice, closetime, closeprice, sid, datetime(opentime / 1000, 'unixepoch', 'localtime') AS dt FROM position WHERE sid = 6 and closeprice = 0 ORDER BY opentime ;
SELECT id, symbol, price, quantity, tradetime, sid, datetime(tradetime / 1000, 'unixepoch', 'localtime') AS dt FROM trades WHERE sid = 6 ORDER BY tradetime ;
SELECT id, cashworth, usdtcontractworth, tokencontractworth, time, sid, datetime(time / 1000, 'unixepoch', 'localtime') AS dt FROM worth WHERE sid = 6 ORDER BY time ; --DESC 


获取所有表属性，语句如下：

select table_name tableName, 
   engine, 
   table_comment tableComment, 
   table_collation tableCollation, 
   create_time createTime 
from information_schema.tables
where table_schema = (select database())
order by create_time desc

获取表结构，语句如下：

select column_name columnName, 
   data_type dataType, 
   column_comment columnComment, 
   column_key columnKey, 
   extra ,
   is_nullable as isNullable,
   column_type as columnType 
from information_schema.columns
where table_name = 't_sys_personnel' 
   and table_schema = (select database()) 
order by ordinal_position;
 


	
	

----mysql-----Trace_testtrace---


conn = pymysql.connect(
    host = "127.0.0.1",   #47.241.99.13
    port = 3300,
    user = "root",
    password = "fil2022",
    db = "Trace_testtrace",
    #charset = 'utf8',
    cursorclass = pymysql.cursors.DictCursor)

#mysql 时间戳转日期 from_unixtime

SELECT symbol, tradeid, price, quantity,commission , from_unixtime(floor(tradetime/1000)) as tradedate from trades where strategyID = 57

SELECT
	selfid,
	symbol,
	side,
	type,
	clientorderid,
	price,
	quantity,
	status,
	from_unixtime(floor(createtime / 1000)) as orderdate
from orders
where selfid >= 245


	
获取表结构:	
	
SELECT
    TABLE_SCHEMA AS '库名',
    TABLE_NAME AS '表名',
    COLUMN_NAME AS '列名',
    ORDINAL_POSITION AS '列的排列顺序',
    COLUMN_DEFAULT AS '默认值',
    IS_NULLABLE AS '是否为空',
    DATA_TYPE AS '数据类型',
    CHARACTER_MAXIMUM_LENGTH AS '字符最大长度',
    NUMERIC_PRECISION AS '数值精度(最大位数)',
    NUMERIC_SCALE AS '小数精度',
    COLUMN_TYPE AS '列类型',
    COLUMN_KEY 'KEY',
    EXTRA AS '额外说明',
    COLUMN_COMMENT AS '注释'
FROM
    information_schema.`COLUMNS`
WHERE
    TABLE_SCHEMA = 'Trace_testtrace'
ORDER BY
    TABLE_NAME,
    ORDINAL_POSITION;





库名 |表名 |列名 |列的排列顺序|默认值|是否为空|数据类型 |字符最大长度|数值精度(最大位数)|小数精度|列类型 |KEY|额外说明 |注释|
---------------+----------------+-------------------+------+---+----+-------+------+----------+----+------------+---+--------------+--+
Trace_testtrace|balance |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|balance |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|balance |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|balance |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|balance |asset | 5| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|balance |free | 6| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|balance |locked | 7| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|balance |type | 8| |NO |int | | 10| 0|int | | | |
Trace_testtrace|contractAsset |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|contractAsset |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|contractAsset |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|contractAsset |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|contractAsset |asset | 5| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|contractAsset |free | 6| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|contractAsset |total | 7| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|contractAsset |margin | 8| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|contractAsset |unreal | 9| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|contractAsset |type | 10| |NO |int | | 10| 0|int | | | |
Trace_testtrace|exchangeinfo |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|exchangeinfo |symbol | 2| |YES |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|exchangeinfo |pair | 3| |YES |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|exchangeinfo |contractType | 4| |YES |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|exchangeinfo |deliveryDate | 5| |YES |bigint | | 19| 0|bigint | | | |
Trace_testtrace|exchangeinfo |onboardDate | 6| |YES |bigint | | 19| 0|bigint | | | |
Trace_testtrace|exchangeinfo |status | 7| |YES |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|exchangeinfo |baseAsset | 8| |YES |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|exchangeinfo |quoteAsset | 9| |YES |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|exchangeinfo |marginAsset | 10| |YES |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|exchangeinfo |maxPrice | 11| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |minPrice | 12| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |tickSize | 13| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |maxMarketQty | 14| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |minMarketQty | 15| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |marketStepSize | 16| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |maxLimitQty | 17| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |minLimitQty | 18| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |limitStepSize | 19| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |maxNumOrders | 20| |YES |bigint | | 19| 0|bigint | | | |
Trace_testtrace|exchangeinfo |maxNumAlgoOrders | 21| |YES |bigint | | 19| 0|bigint | | | |
Trace_testtrace|exchangeinfo |minNotional | 22| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |multiplierDown | 23| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|exchangeinfo |multiplierUp | 24| |YES |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|factor |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|factor |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|factor |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|factor |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|factor |factorID | 5| |NO |int | | 10| 0|int | | | |
Trace_testtrace|factor |time | 6| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|factor |factor | 7| |NO |text | 65535| | |text | | | |
Trace_testtrace|fundscorrecct |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|fundscorrecct |mainAccountID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|fundscorrecct |subAccountID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|fundscorrecct |asset | 4| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|fundscorrecct |amount | 5| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|fundscorrecct |time | 6| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|fundsrate |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|fundsrate |mainAccountID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|fundsrate |subAccountID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|fundsrate |asset | 4| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|fundsrate |amount | 5| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|fundsrate |time | 6| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|ids |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|ids |strategyID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|ids |orderSelfID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|ids |appkeyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|ids |timerID | 5| |NO |int | | 10| 0|int | | | |
Trace_testtrace|ids |accountID | 6| |NO |int | | 10| 0|int | | | |
Trace_testtrace|ids |subaccountID | 7| |NO |int | | 10| 0|int | | | |
Trace_testtrace|ids |histaskID | 8| |NO |int | | 10| 0|int | | | |
Trace_testtrace|info |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|info |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|info |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|info |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|info |time | 5| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|info |name | 6| |NO |varchar| 32| | |varchar(32) | | | |
Trace_testtrace|info |major_version | 7| |NO |int | | 10| 0|int | | | |
Trace_testtrace|info |minor_version | 8| |NO |int | | 10| 0|int | | | |
Trace_testtrace|info |state | 9| |NO |int | | 10| 0|int | | | |
Trace_testtrace|info |closetime | 10| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|mainaccount |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|mainaccount |name | 2| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|mainaccount |accountid | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|mainaccount |createtime | 4| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|mainaccount |updatetime | 5| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|mainaccount |gatetype | 6| |NO |int | | 10| 0|int | | | |
Trace_testtrace|mainaccount |keyid | 7| |NO |int | | 10| 0|int | | | |
Trace_testtrace|mainaccount |cantrade | 8| |NO |int | | 10| 0|int | | | |
Trace_testtrace|mainaccount |canwithdraw | 9| |NO |int | | 10| 0|int | | | |
Trace_testtrace|mainaccount |candeposit | 10| |NO |int | | 10| 0|int | | | |
Trace_testtrace|orderchecked |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|orderchecked |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|orderchecked |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|orderchecked |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|orderchecked |symbol | 5| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|orderchecked |originOrder | 6| |YES |text | 65535| | |text | | | |
Trace_testtrace|orderchecked |checkedOrder | 7| |YES |text | 65535| | |text | | | |
Trace_testtrace|orderchecked |time | 8| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|orders |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|orders |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|orders |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|orders |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|orders |clientorderid | 5| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|orders |symbol | 6| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|orders |gatewayorderid | 7| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|orders |quantity | 8| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|orders |price | 9| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|orders |stopprice | 10| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|orders |type | 11| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|orders |side | 12| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|orders |status | 13| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|orders |positionside | 14| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|orders |createtime | 15| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|orders |updatetime | 16| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|orders |tradetype | 17| |NO |int | | 10| 0|int | | | |
Trace_testtrace|orders |selfid | 18| |NO |int | | 10| 0|int | | | |
Trace_testtrace|orders |fixtype | 19| |NO |int | | 10| 0|int | | | |
Trace_testtrace|orders |gatetype | 20| |NO |int | | 10| 0|int | | | |
Trace_testtrace|position |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|position |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|position |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|position |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|position |symbol | 5| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|position |positionAmount | 6| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|position |enterprice | 7| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|position |countrevence | 8| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|position |unrealprofit | 9| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|position |marginmodel | 10| |NO |int | | 10| 0|int | | | |
Trace_testtrace|position |isolatedmargin | 11| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|position |positionside | 12| |NO |int | | 10| 0|int | | | |
Trace_testtrace|position |markprice | 13| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|position |status | 14| |NO |int | | 10| 0|int | | | |
Trace_testtrace|position |closeprice | 15| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|position |closeamount | 16| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|position |opentime | 17| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|position |closetime | 18| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|position |type | 19| |NO |int | | 10| 0|int | | | |
Trace_testtrace|rechargelog |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|rechargelog |mainname | 2| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|rechargelog |asset | 3| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|rechargelog |amount | 4| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|rechargelog |time | 5| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|runsnap |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|runsnap |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|runsnap |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|runsnap |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|runsnap |time | 5| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|runsnap |body | 6| |NO |text | 65535| | |text | | | |
Trace_testtrace|sharpeRatio |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|sharpeRatio |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|sharpeRatio |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|sharpeRatio |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|sharpeRatio |time | 5| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|sharpeRatio |sharpeRatioValue | 6| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|strategyEvaluate|mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|strategyEvaluate|subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|strategyEvaluate|strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|strategyEvaluate|time | 5| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyEvaluate|annualizedReturn | 6| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|totalProfit | 7| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|totalFee | 8| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|netProfits | 9| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|maxProfits | 10| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|totalAverageProfit | 11| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|averageProfit | 12| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|averageLoss | 13| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|oneMaxProfit | 14| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|oneMaxLoss | 15| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|absoluteReturnRate | 16| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|profitCount | 17| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyEvaluate|lossCount | 18| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyEvaluate|totalProfitAmount | 19| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|totalLossAmount | 20| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|winRate | 21| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|maxContinuousWinNum| 22| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyEvaluate|totalTradeTime | 23| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyEvaluate|totalOpenNum | 24| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyEvaluate|totalCloseNum | 25| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyEvaluate|totalTradeNum | 26| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyEvaluate|maxDrawdown | 27| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyEvaluate|startDrawdownTime | 28| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyEvaluate|endDrawdownTime | 29| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyEvaluate|duringDrwadownTime | 30| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyProfit |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|strategyProfit |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|strategyProfit |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|strategyProfit |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|strategyProfit |time | 5| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|strategyProfit |clientorderid | 6| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|strategyProfit |profitAsset | 7| |YES |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|strategyProfit |profit | 8| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|subaccount |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|subaccount |name | 2| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|subaccount |accountid | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|subaccount |mainAccountID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|subaccount |createtime | 5| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|subaccount |updatetime | 6| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|subaccount |initusdt | 7| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|subaccount |cantrade | 8| |NO |int | | 10| 0|int | | | |
Trace_testtrace|subaccount |canwithdraw | 9| |NO |int | | 10| 0|int | | | |
Trace_testtrace|subaccount |candeposit | 10| |NO |int | | 10| 0|int | | | |
Trace_testtrace|trades |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|trades |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|trades |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|trades |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|trades |symbol | 5| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|trades |tradeid | 6| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|trades |clientorderid | 7| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|trades |price | 8| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|trades |quantity | 9| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|trades |commission | 10| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|trades |commissionasset | 11| |NO |varchar| 25| | |varchar(25) | | | |
Trace_testtrace|trades |tradetime | 12| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|trades |tradetype | 13| |NO |int | | 10| 0|int | | | |
Trace_testtrace|trades |handletime | 14| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|trades |gatetype | 15| |NO |int | | 10| 0|int | | | |
Trace_testtrace|transferlog |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|transferlog |mainname | 2| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|transferlog |subname | 3| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|transferlog |strategyname | 4| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|transferlog |asset | 5| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|transferlog |amount | 6| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|transferlog |type | 7| |NO |int | | 10| 0|int | | | |
Trace_testtrace|transferlog |time | 8| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|worth |id | 1| |NO |int | | 10| 0|int |PRI|auto_increment| |
Trace_testtrace|worth |mainID | 2| |NO |int | | 10| 0|int | | | |
Trace_testtrace|worth |subID | 3| |NO |int | | 10| 0|int | | | |
Trace_testtrace|worth |strategyID | 4| |NO |int | | 10| 0|int | | | |
Trace_testtrace|worth |cashworth | 5| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|worth |usdtcontractworth | 6| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|worth |tokencontractworth | 7| |NO |varchar| 100| | |varchar(100)| | | |
Trace_testtrace|worth |time | 8| |NO |bigint | | 19| 0|bigint | | | |
Trace_testtrace|worth |keyid | 9| |NO |int | | 10| 0|int | | | |

	


------------------------------


export PS1="\[\e[1;36m\]\u\[\e[1;30m\]@\[\e[0;37m\]\W\[\e[1;32m\]\\$\[\e[0m\]"
root@similarity# setEnv.sh

11 0,12 * * * /usr/bin/python3 /root/FIL_test/trace/worth/worth.py >> /root/FIL_test/trace/worth/worth.log

*/5 * * * *  /usr/bin/python3 /root/FIL_test/trace/worth/worth.py >> /root/FIL_test/trace/worth/worth.log

COLUMNS=9999 top -b -c -n 1 | sed 's/  *$//' >>/var/log/toplog/top.log




print(__file__)  # D:\BaiduNetdiskDownload\pythonProject\456\123\123.py
print(os.path.realpath(__file__))  # D:\BaiduNetdiskDownload\pythonProject\456\123\123.py
print(os.path.abspath(__file__))  # D:\BaiduNetdiskDownload\pythonProject\456\123\123.py
print(os.path.dirname(__file__))  # D:\BaiduNetdiskDownload\pythonProject\456\123

print(os.getcwd())  # 输出当前工作目录
print(os.path.abspath(''))   # 当前项目目录的绝对路径部分
print(os.path.abspath(r".."))  # 当前项目目录上一级的绝对路径，如果要往上两级，可以用r"..\.."，以此类推
print(os.path.realpath(""))
print(os.path.dirname(os.path.realpath(""))) # 从输出结果推得：dirname也有上一级目录的作用



　　全路径文件：__file__
　　文件名：   os.path.basename(__file__)   sys._getframe().f_code.co_filename
　　函数名:    __name__   sys._getframe().f_code.co_name
　　行号：     sys._getframe().f_lineno
	类名:		self.__class__.__name__   type(x).__name__
	
f'{os.path.basename(__file__)}:{sys._getframe().f_code.co_name}:{sys._getframe().f_lineno}'
test.py:handleKline:83:

释放缓存内存中的页面缓存、dentries和索引节点
$ sync; echo 3 > /proc/sys/vm/drop_caches
释放 dentries和inode
$ sync; echo 2 > /proc/sys/vm/drop_caches
** 释放页面缓存 **
#$ sync; echo 1 > /proc/sys/vm/drop_caches 

使用Cron定期刷新缓存
在crontab中使用以下操作以按常规间隔自动刷新缓存。
在系统上使用' crontab -e '命令编辑cron。
$ crontab -l
0 * * *  * sync; echo 3 > /proc/sys/vm/drop_caches
上述cron将每小时执行一次, 并刷新系统上的内存缓存。

sync
echo 3 > /proc/sys/vm/drop_caches

sudo sh -c "sync && echo 3 > /proc/sys/vm/drop_caches"

* 7,11,14,17,20,23 * * * sudo sh -c "sync && echo 3 > /proc/sys/vm/drop_caches"



apt update
apt list --upgradable
apt -y upgrade
apt remove golang

sudo apt-get install sysv-rc-conf
sudo apt install cron

sysv-rc-conf --list cron
sudo service cron start	# start  stop reload restart

sudo service cron start	# 开启服务
sudo service cron stop	# 关闭服务
sudo service cron reload	# 重新载入配置
sudo service cron restart # 重启服务

* 7,11,14,17,20,23 * * * sudo sh -c "sync && echo 3 > /proc/sys/vm/drop_caches"

crontab -e
@reboot /home/start.sh #开机后启动
@reboot sleep 300 && /home/start.sh  开机后延时启动
@reboot nohup python /project_path/cron/expire.py >> /project_path/logs/expire.log 2>&1 &
@reboot sleep 60; /home/test.sh 
@reboot (sleep 60; sh /home/test.sh) 

@reboot      Run once, at startup.
@yearly      Run once a year, "0 0 1 1 *".
@annually    (same as @yearly)
@monthly     Run once a month, "0 0 1 * *".
@weekly      Run once a week, "0 0 * * 0".
@daily       Run once a day, "0 0 * * *".
@midnight    (same as @daily)
@hourly      Run once an hour, "0 * * * *".

①分钟(0-59) | ②小时(0-23) | ③号(1-31) | ④月(1-12) | ⑤星期几 (0-6 星期天0)
绝对路径形式，如: /usr/local/bin/docker

每分钟定时执行一次	* * * * *
每小时定时执行一次	0 * * * *
每天定时执行一次	0 0 * * *
每周定时执行一次	0 0 * * 0
每月定时执行一次	0 0 1 * *
每月最后一天定时执行一次	0 0 L * *
每年定时执行一次	0 0 1 1 *

每五分钟执行  */5 * * * *
每10分钟执行  */10  * * * * command
crontab时间格式范例
    1-3表示123
    1-9/2表示13579

* * * * * /bin/ls  # 每一分钟执行一次 /bin/ls
0 6-12/3 * 12 * /usr/bin/backup # 在 12 月内, 每天的早上 6 点到 12 点，每隔 3 个小时 0 分钟执行一次 
0 17 * * 1-5 mail -s "hi" alex@domain.name < /tmp/maildata # 周一到周五每天下午 5:00 寄一封信给 alex@domain.name
20 0-23/2 * * * echo "haha" # 每月每天的午夜 0 点 20 分, 2 点 20 分, 4 点 20 分....执行 echo "haha"：

0 */2 * * * /sbin/service httpd restart   # 每两个小时重启一次apache 
50 7 * * * /sbin/service sshd start   # 每天7：50开启ssh服务 
50 22 * * * /sbin/service sshd stop   # 每天22：50关闭ssh服务 
0 0 1,15 * * fsck /home  #  每月1号和15号检查/home 磁盘 
1 * * * * /home/bruce/backup   # 每小时的第一分执行 /home/bruce/backup这个文件 
00 03 * * 1-5 find /home "*.xxx" -mtime +4 -exec rm {} \;   # 每周一至周五3点钟，在目录/home中，查找文件名为*.xxx的文件，并删除4天前的文件。
30 6 */10 * * ls   # 每月的1、11、21、31日是的6：30执行一次ls命令
20 03 * * * . /etc/profile;/bin/sh /var/www/runoob/test.sh > /dev/null 2>&1  # 


*-星号运算符表示所有允许的值。如果“分钟”字段中有星号，则表示该任务将每分钟执行一次。
--连字符运算符允许您指定一个值范围。如果您1-5在“星期几”字段中设置，则该任务将在每个工作日（从星期一到星期五）运行。该范围是包括在内的，这意味着该范围内包括第一个和最后一个值。
,-逗号运算符使您可以定义重复值列表。例如，如果您1,3,5在“小时”字段中，则任务将在凌晨1点，凌晨3点和凌晨5点运行。该列表可以包含单个值和范围，1-5,7,8,10-15
/-斜杠运算符使您可以指定可与范围结合使用的步长值。例如，如果您1-10/2在Minutes字段中，则意味着将每2分钟在1-10范围内执行一次操作，与指定相同1,3,5,7,9。除了值的范围外，还可以使用星号运算符。要指定每20分钟运行一次的作业，可以使用“ * / 20”。

------------------------------

crontab -e

11 0,12 * * * /usr/bin/python3 /root/FIL_test/trace/worth/worth.py >> /root/FIL_test/trace/worth/worth.log
11 0,12 * * * /usr/bin/python3 /root/FIL/strategy/worth/worth2.py >> /root/FIL/strategy/worth/worth.log
35 6,23 * * * /root/similarity/similarityStart.sh
32 7,0 * * * /root/similarity/similarityStop.sh
#35 6,23 * * * /root/FIL/strategy/similarity/similarityStart.sh
#32 7,0 * * * /root/FIL/strategy/similarity/similarityStop.sh
* 7,15,23 * * * sync; echo 1 > /proc/sys/vm/drop_caches
#*/5 * * * * COLUMNS=9999 /usr/bin/top -c -d 30  -n 2 -b  | sed 's/  *$//' >> /root/FIL/strategy/multiple/top.log


0 0,7 * * * /root/binancefuture/crypto/strategy/similarity//similarityStart.sh
*/5 * * * * /root/binancefuture/crypto/strategy/worth/update.sh >> /root/binancefuture/crypto/strategy/worth/log.txt

------------------------------

`date "+%Y-%m-%d %H:%M:%S"`
`date "+%Y%m%d"`

export PS1="\[\e[1;36m\]\u\[\e[1;30m\]@\[\e[0;37m\]\W\[\e[1;32m\]\\$\[\e[0m\]"

#$ python3 /root/FIL_test/trace/worth/worth.py
awk -F, 'NR==1{printf "\n%-15s %-14s %-17s %-10ss %-10s %-10s %-10s\n",$1,$3,$5,$6,$7,$8,$9}; NR>1 {printf "%-11s %-10s %-12s %-12s %-7d %-8d %-8d\n",$1,$3,$5,$6,$7,$8,$9}' /root/FIL_test/trace/worth/worth_`date "+%Y%m%d"`.csv



#!/bin/bash
cd /root/similarity

nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1  &
ps aux | grep simi | grep -v grep | awk '{print $2}'| xargs kill -9



& 表示任务在后台执行
&&表示前一条命令执行成功时，才执行后一条命令
| 表示管道，上一条命令的输出，作为下一条命令参数
|| 表示上一条命令执行失败后，才执行下一条命令
; 各命令的执行给果，不会影响其它命令的执行


----sysv-rc-conf--------------------------

第1步：安装
sudo apt-get install sysv-rc-conf

sudo vim  /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse
apt-get update

sudo apt-get install sysv-rc-conf
sysv-rc-conf --list xxxx
alias chkconfig=sysv-rc-conf
chkconfig --list

update-rc.d –f cron defaults
sysv-rc-conf --list cron


第2步：放置服务
把需要自启动的脚本放置的 /etc/init.d 目录下

第3步：使用
方法一：命令行设置
sudo sysv-rc-conf xxxx on

方法二：图像界面设置
sudo sysv-rc-conf


查看服务情况
sysv-rc-conf
sudo sysv-rc-conf

启动服务有以下两种方式
update-rc.d service_name defaults
sysv-rc-conf --level 345 service_name on

查看某个服务启动级别
sysv-rc-conf --list server_name
如：
sysv-rc-conf --list nginx




Linux 使用 ln -s 建立软连接启动
即： 在 /etc/rc.d/rc*.d 目录中建立 /etc/init.d/ 服务的软链接

gcc -g hello.c -o hello

在/etc/init.d目录下添加脚本test

#!/bin/bash
 
start()
{
    echo "------------------test----------------"
    cd /home/xxx/test/
    ./hello
}
 
case $1 in
    start):
    start
    ;;
    stop):
    echo "-----------------stop------------------"
    ;;
esac
 
exit 0


设置权限
chmod 755 /etc/init.d/test

建立软连接
在相关运行级别创建启动软连接，例如，开机自启的话，在/etc/rc2.d/中创建启动服务脚本的软连接(命名S开头)
ln -s /etc/init.d/test /etc/rc2.d/S20test

在/etc/rc0.d/创建停止服务软连接：
ln -s /etc/init.d/test /etc/rc0.d/K20test

重启
reboot


----Linux 系统启动步骤--------------------------

Linux 系统主要启动步骤
1. 读取 MBR 的信息,启动 Boot Manager
    Windows 使用 NTLDR 作为 Boot Manager,如果您的系统中安装多个版本的 Windows,您就需要在 NTLDR 中选择您要进入的系统。
    Linux 通常使用功能强大,配置灵活的 GRUB 作为 Boot Manager。
2. 加载系统内核,启动 init 进程
    init 进程是 Linux 的根进程,所有的系统进程都是它的子进程。
3. init 进程读取 /etc/inittab 文件中的信息,并进入预设的运行级别，按顺序运行该运行级别对应文件夹下的脚本。脚本通常以 start 参数启动,并指向一个系统中的程序。
    通常情况下, /etc/rcS.d/ 目录下的启动脚本首先被执行,然后是/etc/rcN.d/ 目录。例如您设定的运行级别为 3,那么它对应的启动目录为 /etc/rc3.d/ 。
4. 根据 /etc/rcS.d/ 文件夹中对应的脚本启动 Xwindow 服务器 xorg
    Xwindow 为 Linux 下的图形用户界面系统。（/etc/rcS.d/S02x11-common）
5. 启动登录管理器,等待用户登录
    Ubuntu 系统默认使用 GDM 作为登录管理器,您在登录管理器界面中输入用户名和密码后,便可以登录系统。(可以在 /etc/rc3.d/文件夹中找到一个名为 S03lightdm 的链接)

Ubuntu运行级别
Linux 系统任何时候都运行在一个指定的运行级上，并且不同的运行级的程序和服务都不同，所要完成的工作和要达到的目的都不同，系统可以在这些运行级之间进行切换，以完成不同的工作。
运行级别（Runlevel）指的是Unix或者Linux等类Unix操作系统下不同的运行模式。
运行级别通常分为7等，分别是从0到6，但如果必要的话也可以更多。
例如在大多数linux操作系统下一共有如下6个典型的运行级别：

0 停机，所有进程终止，关闭系统
1 单用户,单用户模式，用于维护系统，只有极少数的进程运行，init 是所有进程的祖先，他的进程号始终为1，所以发送TERM信号给init会终止所有的用户进程，守护进程。shutdown就是使用这种机制。, Does not configure network interfaces, start daemons, or allow non-root logins ,
2 多用户，无网络连接 Does not configure network interfaces or start daemons
3 多用户，启动网络连接 Starts the system normally.
4 用户自定义
5 多用户带图形界面
6 重启，重新启动机器

runlevel

ls /etc/rc*
对于以K开头的文件，系统将终止对应的服务；
对于以S开头的文件，系统将启动对应的服务；

切换运行级别
例如切换运行级别为3
init 3
关闭计算机
init 0  所有进程终止，关闭系统
重启计算机
init 6   重新启动计算机

----关机与重启--------------------------

关机与重启
虽然Linux关机的方式很多，但其具体的步骤与过程是不尽相同的。
1.使用shutdown命令关机
shutdown参数：
shutdown -t 在改变其他runlevel之前，告诉init多久以后关机。
shutdown - r 重启计算机 restart。
shutdown- k 并不是真正的关机，只是送警告信号给每位登陆者（login）
shutdown-h 关机后关闭电源，可以指定关机时间。
例如
shutdown-h now 立即关机
shutdown -time 设定关机时间
例如
sudo shutdown -h 16：00
重新启动
sudo shutdown -r now
要取消即将进行的关机，只要输入下面的命令：
 shutdown -c 
使用halt命令关闭系统
halt -n 在关机之前不做将记忆体材料协会硬盘的动作
halt -w 并不会真的关机，只是把记录写到/var/log/wtmp文档里
halt -d不把记录写到/var/log/wtmp文档里
halt -i 在关机之前。先关闭所有网络接口
halt -p该选项文默认选项，当关机时，调用（poweroff）的动作
halt 通知硬件来停止所有的 CPU 功能，但是仍然保持通电。你可以用它使系统处于低层维护状态。
注意在有些情况会它会完全关闭系统。下面是 halt 命令示例：
halt --reboot ### 重启机器
poweroff
poweroff 会发送一个 ACPI 信号来通知系统关机。
reboot
reboot 命令
reboot 通知系统重启。
init
init 是所有进程的祖先，他的进程号始终为1，所以发送TERM信号给init会终止所有的用户进程，守护进程。shutdown就是使用这种机制。
多用户，多任务的操作系统在其关闭时系统所要进行的处理操作与单用户，单任务的操作系统有很大的差别，后台运行者许多进程，非正常关机(直接断电)对Linux操作系统损害非常大。


----常见的系统服务信息--------------------------

常见的系统服务信息
acpi-support 高级电源管理支持
acpid acpi 守护程序.这两个用于电源管理,非常重要
alsa 声音子系统
alsa-utils
anacron cron 的子系统,将系统关闭期间的计划任务,在下一次系统运行时执行。
apmd acpi 的扩展
atd 类似于 cron 的任务调度系统。建议关闭
binfmt-support 核心支持其他二进制的文件格式。建议开启
bluez-utiles 蓝牙设备支持
bootlogd 启动日志。开启它
cron 任务调度系统,建议开启
cupsys 打印机子系统。
dbus 消息总线系统(message bus system)。非常重要
dns-clean 使用拨号连接时,清除 dns 信息。
evms 企业卷管理系统(Enterprise Volumn Management system)
fetchmail 邮件用户代理守护进程,用于收取邮件
gdm gnome 登录和桌面管理器。
gdomap
gpm 终端中的鼠标支持。
halt 别动它。
hdparm 调整硬盘的脚本,配置文件为 /etc/hdparm.conf。
hibernate 系统休眠
hotkey-setup 笔记本功能键支持。支持类型包括: HP, Acer, ASUS, Sony,Dell, 和 IBM。
hotplug and hotplug-net 即插即用支持,比较复杂,建议不要动它。
hplip HP 打印机和图形子系统
ifrename 网络接口重命名脚本。如果您有十块网卡,您应该开启它
inetd 在文件 /etc/inetd.conf 中,注释掉所有你不需要的服务。如果该文件不包含任何服务,那关闭它是很安全的。
klogd 重要。
linux-restricted-modules-common 受限模块支持。
/lib/linux-restricted-modules/ 文件夹中的模块为受限模块。例如某些驱动程序,如果您没有使用受限模块,就不需要开启它。
lvm 逻辑卷管理系统支持。
makedev 创建设备文件,非常重要。
mdamd 磁盘阵列
module-init-tools 从/etc/modules 加载扩展模块,建议开启。
networking 网络支持。按 /etc/network/interfaces 文件预设激活网络,非常重要。
ntpdate 时间同步服务,建议关闭。
pcmcia pcmcia 设备支持。
powernowd 移动 CPU 节能支持
ppp and ppp-dns 拨号连接
readahead 预加载库文件。
reboot 别动它。
resolvconf 自动配置 DNS
rmnologin 清除 nologin
rsync rsync 守护程序
sendsigs 在重启和关机期间发送信号
single 激活单用户模式
ssh ssh 守护程序。建议开启
stop-bootlogd 在 2,3,4,5 运行级别中停止 bootlogd 服务
sudo 检查 sudo 状态。重要
sysklogd 系统日志
udev & udev-mab 用户空间 dev 文件系统(userspace dev filesystem)。重要
umountfs 卸载文件系统
urandom 随机数生成器
usplash 开机画面支持
vbesave 显卡 BIOS 配置工具。保存显卡的状态
xorg-common 设置 X 服务 ICE socket。
adjtimex 调整核心时钟的工具
dirmngr 证书列表管理工具,和 gnupg 一起工作。
hwtools irqs 优化工具
libpam-devperm 系统崩溃之后,用于修理设备文件许可的守护程序。
lm-sensors 板载传感器支持
mdadm-raid 磁盘陈列管理器
screen-cleanup 清除开机屏幕的脚本
xinetd 管理其他守护进程的一个 inetd 超级守护程序


----config.json--------------------------

{
    "risk": {
        "count": 100,
        "upAmount": 200,
        "downAmount": 100,
        "upPrice": 200,
        "downPrice": 100
    },
    "influx": {
        "host": "127.0.0.1",
        "httpport": 8086,
        "udpport": 8089,
        "db": "testfil",
        "usr": "test",
        "password": "test",
        "precision": "ms"
    },
    "mysql": {
        "host": "127.0.0.1",
        "jdbcport": 3300,
        "xdevport": 33000,
        "db": "testtrace",
        "usr": "root",
        "password": "fil2022"
    },
    "binance": {
        "host": "api.binance.com",
        "port": "443",
        "timeout": 10000,
        "wshost": "stream.binance.com",
        "wsport": "9443",
        "uhost": "fapi.binance.com",
        "uport": "443",
        "utimeout": 10000,
        "uwshost": "fstream.binance.com",
        "uwsport": "443",
        "thost": "dapi.binance.com",
        "tport": "443",
        "ttimeout": 10000,
        "twshost": "dstream.binance.com",
        "twsport": "443"
    },
    "fil_host": "0.0.0.0",
    "fil_port": 8809,
    "trace_host": "0.0.0.0",
    "trace_port": 8808,
    "histest_host": "0.0.0.0",
    "histest_port": 8807,
    "clean_interval": 86400,
    "order_clean_interval": 2592000,
    "worth_interval": 300,
    "exchangeinfo_interval": 86400,
    "feepercent": "0.001",
    "mainAccountReserve": "100",
    "initExchangeinfo": 0
}

#启动
./Trace run -c ./config.json

cd /root/FIL/trace &&  nohup ./Trace run -c ./config.json  >> /root/FIL/logs/screenlog_Trace2_bash_0.log  2>&1  &

-- 启动mysql服务
mysqld_safe --defaults-file=/etc/my.cnf --user=mysql &
	

 --关闭mysql服务
mysqladmin -uroot -p -S /var/lib/mysql/mysql.sock shutdown



------------------------------


#创建主账户
  curl -X POST -d '{"method":"createMainAccount","params":["mainaccount",3,0]}' http://127.0.0.1:8808/strategy
充值
  curl -X POST -d '{"method":"recharge","params":["mainaccount","USDT","8000000.0"]}' http://127.0.0.1:8808/strategy
创建子账户
  curl -X POST -d '{"method":"createSubAccount","params":["subaccount",1,"1000000.0"]}' http://127.0.0.1:8808/strategy
创建策略
  curl -X POST -d '{"method":"hello","params":["test-strategy","mainaccount","subaccount","127.0.0.1",9090]}' http://127.0.0.1:8808/strategy
策略划转现货至U本位合约
  curl -X POST -d '{"method":"accountTransfer","params":["mainaccount","subaccount","test-strategy","USDT","500000.0",0]}' http://127.0.0.1:8808/strategy


Trace run -c ./config.json


./FIL_test/trace/config.json
./FIL_test/test/config.json
./FIL/trace/config.json

#在 /root/FIL/logs下  8808  testStrategy1


curl -X POST -d '{"method":"createMainAccount","params":["testMain",3,0]}' http://127.0.0.1:8808/strategy
{"success":true,"message":""}

curl -X POST -d '{"method":"recharge","params":["testMain","USDT","10000000.0"]}' http://127.0.0.1:8808/strategy

$ curl -X POST -d '{"method":"updateAccountKeyid","params":[0,11]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"createSubAccount","params":["testSub",2,"2000000.0"]}' http://127.0.0.1:8808/strategy
{"success":true,"message":""}


curl -X POST -d '{"method":"hello","params":["testStrategy","testMain","testSub","127.0.0.1",29090]}' http://127.0.0.1:8808/strategy
curl -X POST -d '{"method":"hello","params":["pyemd2","testMain","testSub","127.0.0.1",29091]}' http://127.0.0.1:8808/strategy


	curl -X POST -d '{"method":"close","params":["testStrategy"]}' http://127.0.0.1:8808/strategy

	curl -X POST -d '{"method":"queryStrategyInfo","params":["testStrategy"]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"accountTransfer","params":["testMain","testSub","testStrategy","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy
curl -X POST -d '{"method":"accountTransfer","params":["testMain","testSub","pyemd2","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy

curl -X POST -d '{"method":"queryMainAccount","params":["testMain"]}' http://127.0.0.1:8808/strategy
{"result":[{"name":"testMain","id":2,"createtime":1657867544284,"updatetime":1657867544284,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[{"asset":"USDT","free":"10000000","locked":"0"}]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"type":3,"keyid":0}]}

curl -X POST -d '{"method":"querySubAccount","params":["testSub"]}' http://127.0.0.1:8808/strategy
{"result":[{"name":"testSub1","id":3,"createtime":1657873853122,"updatetime":1657873853122,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":1,"initusdt":"2000000"}]}


curl -X POST -d '{"method":"queryRecharge","params":["testMain",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[{"mainname":"testMain","asset":"USDT","amount":"10000000","time":1657867635749}]}
curl -X POST -d '{"method":"queryRecharge","params":["mainaccount",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[{"mainname":"mainaccount","asset":"USDT","amount":"8000000","time":1657854071396}]}


nohup python3 -u main.py -n testStrategy -s 8808 -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &

nohup python3 -u main.py -n pyemd2 -s 8808 -c 29091 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &
curl -X POST -d '{"method":"queryContractAssets","params":["pyemd2","USDT"]}' http://127.0.0.1:8808/strategy
{"result":[{"asset":"USDT","free":"7.6412","total":"1000000","margin":"1040574.67169586553","unreal":"40582.31289586553","type":1}]}

python3 main.py -n testStrategy -s 28280 -c 29290 -X BTCUSDT  -t 1000000
curl -X POST -d '{"method":"queryContractAssets","params":["testStrategy","USDT"]}' http://127.0.0.1:8808/strategy
curl -X POST -d '{"method":"queryPositions","params":["testStrategy","BTCUSDT",0]}' http://127.0.0.1:8808/strategy 

curl -X POST -d '{"method":"queryStrategySubKlines","params":["testStrategy"]}' http://127.0.0.1:8808/strategy
{"result":[{"mainID":2,"subID":4,"strategyID":2,"symbol":"BTCUSDT","gatetype":3,"tradetype":1,"interval":15,"lastclosetime":0}]}

curl -X POST -d '{"method":"queryStrategySubTicks","params":["testStrategy"]}' http://127.0.0.1:8808/strategy
{"result":[]}

curl -X POST -d '{"method":"queryTrade","params":["testStrategy",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[{"symbol":"BTCUSDT","tradeid":1658185201219,"clientorderid":"21F1658185201112I0L2","price":"21782.7","quantity":"45.907","commission":"999.9784089","commissionasset":"USDT","tradetime":1658185201219,"tradetype":1,"handletime":1658185201219,"gatetype":3}]}

curl -X POST -d '{"method":"queryWorth","params":["testStrategy",1657814400000,0,5]}' http://127.0.0.1:8808/strategy
{"result":[{"cashworth":"0","usdtcontractworth":"1000000","tokencontractworth":"0","time":1657881600156,"keyid":0},{"cashworth":"0","usdtcontractworth":"1000000","tokencontractworth":"0","time":1657881600380,"keyid":0},{"cashworth":"0","usdtcontractworth":"1000000","tokencontractworth":"0","time":1657881600558,"keyid":0},{"cashworth":"0","usdtcontractworth":"1000000","tokencontractworth":"0","time":1657881600767,"keyid":0},{"cashworth":"0","usdtcontractworth":"1000000","tokencontractworth":"0","time":1657881600962,"keyid":0}]}


curl -X POST -d '{"method":"queryBalances","params":["testStrategy","USDT"]}' http://127.0.0.1:8808/strategy
{"result":[]}



curl -X POST -d '{"method":"queryContractAssets","params":["testStrategy","USDT"]}' http://127.0.0.1:8808/strategy
{"result":[{"asset":"USDT","free":"7917.5951","total":"1000000","margin":"996030.4069","unreal":"-3948.002","type":1}]}
{"result":[{"asset":"USDT","free":"87560.9691462","total":"1087553.4246462","margin":"1001974.8373431825","unreal":"1982.3818431825","type":1}]}
{"result":[{"asset":"USDT","free":"87560.9691462","total":"1087553.4246462","margin":"979855.5689854893","unreal":"-20136.8865145107","type":1}]}

curl -X POST -d '{"method":"queryMarketOrder","params":["testStrategy",1657814400000,0,5 ]}' http://127.0.0.1:8808/strategy
{"result":[{"clientorderid":"21F1658185201112I0L2","symbol":"BTCUSDT","gatewayorderid":1658185201262014,"quantity":"45.907","price":"21782.7","stopprice":"0","type":"MARKET","side":"BUY","status":"FILLED","positionside":"LONG","createtime":1658185201102,"updatetime":1658185201219,"tradetype":1,"fixtype":0,"selfid":21,"filltrades":[],"gatetype":3},{"clientorderid":"23F1658246400434I0L2","symbol":"BTCUSDT","gatewayorderid":1658246400568033,"quantity":"45.907","price":"23117.4","stopprice":"0","type":"MARKET","side":"SELL","status":"FILLED","positionside":"SHORT","createtime":1658246400426,"updatetime":1658246400529,"tradetype":1,"fixtype":0,"selfid":23,"filltrades":[],"gatetype":3},{"clientorderid":"24F1658271600779I0L2","symbol":"BTCUSDT","gatewayorderid":1658271600900668,"quantity":"42.58","price":"23487.1","stopprice":"0","type":"MARKET","side":"BUY","status":"FILLED","positionside":"LONG","createtime":1658271600769,"updatetime":1658271600869,"tradetype":1,"fixtype":0,"selfid":24,"filltrades":[],"gatetype":3},{"clientorderid":"25F1658332800419I0L2","symbol":"BTCUSDT","gatewayorderid":1658332800566079,"quantity":"42.58","price":"24153.4","stopprice":"0","type":"MARKET","side":"SELL","status":"FILLED","positionside":"SHORT","createtime":1658332800405,"updatetime":1658332800524,"tradetype":1,"fixtype":0,"selfid":25,"filltrades":[],"gatetype":3},{"clientorderid":"26F1658358000832I0L2","symbol":"BTCUSDT","gatewayorderid":1658358000973044,"quantity":"42.915","price":"23301.7","stopprice":"0","type":"MARKET","side":"BUY","status":"FILLED","positionside":"LONG","createtime":1658358000826,"updatetime":1658358000926,"tradetype":1,"fixtype":0,"selfid":26,"filltrades":[],"gatetype":3}]}



curl -X POST -d '{"method":"queryLimitOrder","params":["testStrategy",1657814400000,0,5 ]}' http://127.0.0.1:8808/strategy
{"result":[]}





curl -X POST -d '{"method":"queryPositions","params":["testStrategy","BTCUSDT",0]}' http://127.0.0.1:8808/strategy
{"result":[{"symbol":"BTCUSDT","positionAmount":"45.907","enterprice":"21782.7","countrevence":"0","unrealprofit":"-5595.45607984774","marginmodel":0,"isolatedmargin":"0","positionside":0,"markprice":"21660.81322718","type":1}]}
curl -X POST -d '{"method":"queryPositions","params":["testStrategy","BTCUSDT",1]}' http://127.0.0.1:8808/strategy
{"result":[]}

curl -X POST -d '{"method":"queryHistoryPositions","params":["testStrategy","BTCUSDT",1657814400000,0,5]}' http://127.0.0.1:8808/strategy
{"result":[]}


curl -X POST -d '{"method":"queryStrategyEvaluate","params":["testStrategy",1657814400000,0,5]}' http://127.0.0.1:8808/strategy
{"result":[]}

curl -X POST -d '{"method":"queryMainAccount","params":["testMain"]}' http://127.0.0.1:8808/strategy
{"result":[{"name":"testMain","id":2,"createtime":1657867544284,"updatetime":1657867544284,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[{"asset":"USDT","free":"10000000","locked":"0"}]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[{"asset":"USDT","free":"0","total":"1000000","margin":"0","unreal":"0"},{"asset":"USDT","free":"0","total":"983970.6141714001067968052","margin":"0","unreal":"0"}],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"type":3,"keyid":0}]}

curl -X POST -d '{"method":"querySubAccount","params":["testSub"]}' http://127.0.0.1:8808/strategy
{"result":[{"name":"testSub","id":4,"createtime":1657879209438,"updatetime":1657879209438,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":2,"initusdt":"2000000"}]}

curl -X POST -d '{"method":"queryRecharge","params":["testMain",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[{"mainname":"testMain","asset":"USDT","amount":"10000000","time":1657867635749}]}

curl -X POST -d '{"method":"queryAccountTrans","params":["testMain","testSub","testStrategy",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[{"mainname":"testMain","subname":"testSub","strategyname":"testStrategy","asset":"USDT","amount":"1000000","type":0,"time":1657881550811}]}

curl -X POST -d '{"method":"queryFundscorrect","params":["testMain","testSub",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[]}

curl -X POST -d '{"method":"queryFundsrate","params":["testMain","testSub",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["testStrategy"]}' http://127.0.0.1:8808/strategy
{"result":[{"name":"testStrategy","time":1657881523372,"mainID":2,"subID":4,"strategyID":2,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryFactor","params":["testStrategy",2,1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[]}

curl -X POST -d '{"method":"queryStrategyRunSnap","params":["testStrategy",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[]}


curl -X POST -d '{"method":"querySharpeRatio","params":["testStrategy",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[{"mainID":0,"subID":0,"strategyID":0,"time":1657867768063,"value":"0"},{"mainID":0,"subID":0,"strategyID":0,"time":1657954168063,"value":"0"},{"mainID":0,"subID":0,"strategyID":0,"time":1658040568063,"value":"0"},{"mainID":0,"subID":0,"strategyID":0,"time":1658126968063,"value":"0"}]}


curl -X POST -d '{"method":"queryPrice","params":["ETHBTC"]}' http://127.0.0.1:8808/strategy
{"result":"0.070423"}

curl -X POST -d '{"method":"queryUPrice","params":["BTCUSDT"]}' http://127.0.0.1:8808/strategy
{"result":"21706.445036"}

curl -X POST -d '{"method":"queryTPrice","params":["BTCUSD_PERP"]}' http://127.0.0.1:8808/strategy
{"result":"21781.300000"}

curl -X POST -d '{"method":"klines","params":[0,"ETHBTC",0,5,165838700999,1658387399999]}' http://127.0.0.1:8808/strategy
{"result":[{"gatewaytype":0,"tradetype":0,"symbol":"ETHBTC","interval":0,"opentime":1500004800000,"closetime":1500004859999,"openprice":"0.08","closeprice":"0.08","highprice":"0.08","lowprice":"0.08","volume":"0.043","number":1,"totalamount":"0.00344","activevolume":"0","activeamount":"0","handletime":1658237302102,"fixtype":0},{"gatewaytype":0,"tradetype":0,"symbol":"ETHBTC","interval":0,"opentime":1500004860000,"closetime":1500004919999,"openprice":"0.08","closeprice":"0.08","highprice":"0.08","lowprice":"0.08","volume":"0","number":0,"totalamount":"0","activevolume":"0","activeamount":"0","handletime":1658237302102,"fixtype":0},{"gatewaytype":0,"tradetype":0,"symbol":"ETHBTC","interval":0,"opentime":1500004920000,"closetime":1500004979999,"openprice":"0.08","closeprice":"0.08","highprice":"0.08","lowprice":"0.08","volume":"0.306","number":2,"totalamount":"0.02448","activevolume":"0","activeamount":"0","handletime":1658237302102,"fixtype":0},{"gatewaytype":0,"tradetype":0,"symbol":"ETHBTC","interval":0,"opentime":1500004980000,"closetime":1500005039999,"openprice":"0.08","closeprice":"0.08","highprice":"0.08","lowprice":"0.08","volume":"0.212","number":1,"totalamount":"0.01696","activevolume":"0","activeamount":"0","handletime":1658237302102,"fixtype":0},{"gatewaytype":0,"tradetype":0,"symbol":"ETHBTC","interval":0,"opentime":1500005040000,"closetime":1500005099999,"openprice":"0.08","closeprice":"0.08","highprice":"0.08","lowprice":"0.08","volume":"0.165","number":2,"totalamount":"0.0132","activevolume":"0","activeamount":"0","handletime":1658237302102,"fixtype":0}]}

curl -X POST -d '{"method":"uklines","params":[0,"BTCUSDT",0,3,165838700999,1658387399999]}' http://127.0.0.1:8808/strategy
{"result":[{"gatewaytype":0,"tradetype":1,"symbol":"BTCUSDT","interval":0,"opentime":1567965420000,"closetime":1567965479999,"openprice":"10000","closeprice":"10000","highprice":"10000","lowprice":"10000","volume":"0.001","number":1,"totalamount":"10","activevolume":"0","activeamount":"0","handletime":1658237364048,"fixtype":0},{"gatewaytype":0,"tradetype":1,"symbol":"BTCUSDT","interval":0,"opentime":1567965480000,"closetime":1567965539999,"openprice":"10000","closeprice":"10000","highprice":"10000","lowprice":"10000","volume":"0","number":0,"totalamount":"0","activevolume":"0","activeamount":"0","handletime":1658237364048,"fixtype":0},{"gatewaytype":0,"tradetype":1,"symbol":"BTCUSDT","interval":0,"opentime":1567965540000,"closetime":1567965599999,"openprice":"10000","closeprice":"10000","highprice":"10000","lowprice":"10000","volume":"0.001","number":1,"totalamount":"10","activevolume":"0.001","activeamount":"10","handletime":1658237364048,"fixtype":0}]}

curl -X POST -d '{"method":"tklines","params":[0,"BTCUSD_PERP",0,3,0,0]}' http://127.0.0.1:8808/strategy
{"result":[{"gatewaytype":0,"tradetype":2,"symbol":"BTCUSD_PERP","interval":0,"opentime":1658238480000,"closetime":1658238539999,"openprice":"22067.8","closeprice":"22094.7","highprice":"22110","lowprice":"22064.2","volume":"47794","number":1321,"totalamount":"216.37137514","activevolume":"22691","activeamount":"102.73290121","handletime":1658238615558,"fixtype":0},{"gatewaytype":0,"tradetype":2,"symbol":"BTCUSD_PERP","interval":0,"opentime":1658238540000,"closetime":1658238599999,"openprice":"22094.8","closeprice":"22072","highprice":"22104.5","lowprice":"22059","volume":"37043","number":1025,"totalamount":"167.72253809","activevolume":"16186","activeamount":"73.28577936","handletime":1658238615558,"fixtype":0},{"gatewaytype":0,"tradetype":2,"symbol":"BTCUSD_PERP","interval":0,"opentime":1658238600000,"closetime":1658238659999,"openprice":"22072.8","closeprice":"22080.7","highprice":"22081.9","lowprice":"22071.3","volume":"8200","number":231,"totalamount":"37.14351385","activevolume":"4756","activeamount":"21.54360291","handletime":1658238615558,"fixtype":0}]}

cli.uklines('binance', symbol='BTCUSDT' , interval='5m' , limit=998 , Sec*1000+999=1658088000999 , end= 1658387399999  )



curl -X POST -d '{"method":"queryPositions","params":["testStrategy", "BTCUSDT", 0]}' http://127.0.0.1:8808/strategy
{"result":[{"symbol":"BTCUSDT","positionAmount":"45.907","enterprice":"21782.7","countrevence":"0","unrealprofit":"16053.6779","marginmodel":0,"isolatedmargin":"0","positionside":0,"markprice":"22132.4","type":1}]}


curl -X POST -d '{"method":"queryPrice","params":["ETHBTC"]}' http://127.0.0.1:8808/strategy





------------------------------



curl -X POST -d '{"method":"createSubAccount","params":["testTrade",2,"1000000.0"]}' http://127.0.0.1:8808/strategy
{"success":true,"message":""}

curl -X POST -d '{"method":"hello","params":["testTrade","testMain","testTrade","127.0.0.1",29290]}' http://127.0.0.1:8808/strategy
{"success":true,"message":"{\"name\":\"testTrade\" , \"time\":1658022017087, \"id\":3}"}

curl -X POST -d '{"method":"accountTransfer","params":["testMain","testTrade","testTrade","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy
{"success":true,"message":""}

curl -X POST -d '{"method":"querySubAccount","params":["testTrade"]}' http://127.0.0.1:8808/strategy
{"result":[{"name":"testTrade","id":5,"createtime":1658021992447,"updatetime":1658021992447,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":2,"initusdt":"1000000"}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["testTrade"]}' http://127.0.0.1:8808/strategy
{"result":[{"name":"testTrade","time":1658022017087,"mainID":2,"subID":5,"strategyID":3,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryContractAssets","params":["testTrade","USDT"]}' http://127.0.0.1:8808/strategy
{"result":[{"asset":"USDT","free":"1000000","total":"1000000","margin":"0","unreal":"0","type":1}]}
{"result":[{"asset":"USDT","free":"-109383.7170351775843839948","total":"983970.6141714001067968052","margin":"1038662.4726889888590279","unreal":"54691.8585175888321529","type":1}]}

curl -X POST -d '{"method":"queryStrategySubKlines","params":["testTrade"]}' http://127.0.0.1:8808/strategy
{"result":[{"mainID":2,"subID":5,"strategyID":3,"symbol":"BTCUSDT","gatetype":3,"tradetype":1,"interval":15,"lastclosetime":0}]}

curl -X POST -d '{"method":"queryStrategySubTicks","params":["testTrade"]}' http://127.0.0.1:8808/strategy
{"result":[]} 


curl -X POST -d '{"method":"queryTrade","params":["testTrade",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[{"symbol":"BTCUSDT","tradeid":1658070000522,"clientorderid":"1F1658070000423I0L3","price":"21194","quantity":"47.18316504671133","commission":"999.99999999999992802","commissionasset":"USDT","tradetime":1658070000522,"tradetype":1,"handletime":1658070000522,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658070600601,"clientorderid":"2F1658070600501I0L3","price":"21220.7","quantity":"47.18316504671133","commission":"1001.259790506747120531","commissionasset":"USDT","tradetime":1658070600601,"tradetype":1,"handletime":1658070600601,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658071200496,"clientorderid":"3F1658071200399I0L3","price":"21224.7","quantity":"47.12643254257905","commission":"1000.244392786477562535","commissionasset":"USDT","tradetime":1658071200496,"tradetype":1,"handletime":1658071200496,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658071800636,"clientorderid":"4F1658071800528I0L3","price":"21242.8","quantity":"47.12643254257905","commission":"1001.09738121549824334","commissionasset":"USDT","tradetime":1658071800636,"tradetype":1,"handletime":1658071800636,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658072400510,"clientorderid":"5F1658072400407I0L3","price":"21187.2","quantity":"47.12300091121074","commission":"998.404444906004190528","commissionasset":"USDT","tradetime":1658072400510,"tradetype":1,"handletime":1658072400510,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658073000633,"clientorderid":"6F1658073000522I0L3","price":"21139.4","quantity":"47.12300091121074","commission":"996.151965462448317156","commissionasset":"USDT","tradetime":1658073000633,"tradetype":1,"handletime":1658073000633,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658074800729,"clientorderid":"8F1658074800414I0L3","price":"21008.9","quantity":"47.32099598652328","commission":"994.162072581268937192","commissionasset":"USDT","tradetime":1658074800729,"tradetype":1,"handletime":1658074800729,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658075400635,"clientorderid":"9F1658075400525I0L3","price":"21059.9","quantity":"47.32099598652328","commission":"996.575443376581624472","commissionasset":"USDT","tradetime":1658075400635,"tradetype":1,"handletime":1658075400635,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658076000523,"clientorderid":"10F1658076000422I0L3","price":"21132.2","quantity":"47.15561443802657","commission":"996.501875427265082554","commissionasset":"USDT","tradetime":1658076000523,"tradetype":1,"handletime":1658076000523,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658076600615,"clientorderid":"11F1658076600505I0L3","price":"21133.6","quantity":"47.15561443802657","commission":"996.567893287478319752","commissionasset":"USDT","tradetime":1658076600615,"tradetype":1,"handletime":1658076600615,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658079000507,"clientorderid":"13F1658079000405I0L3","price":"21257.5","quantity":"46.831001909698756","commission":"995.51002309542130567","commissionasset":"USDT","tradetime":1658079000507,"tradetype":1,"handletime":1658079000507,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658079600848,"clientorderid":"14F1658079600500I0L3","price":"21160.8","quantity":"46.831001909698756","commission":"990.9814652107534359648","commissionasset":"USDT","tradetime":1658079600848,"tradetype":1,"handletime":1658079600848,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658080200530,"clientorderid":"15F1658080200431I0L3","price":"21116.5","quantity":"47.30742201110314","commission":"998.96717689745945581","commissionasset":"USDT","tradetime":1658080200530,"tradetype":1,"handletime":1658080200530,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658080801036,"clientorderid":"16F1658080800723I0L3","price":"20908.7","quantity":"47.30742201110314","commission":"989.136694603552223318","commissionasset":"USDT","tradetime":1658080801036,"tradetype":1,"handletime":1658080801036,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658081400505,"clientorderid":"17F1658081400408I0L3","price":"20909","quantity":"47.26305678036681","commission":"988.22325422068963029","commissionasset":"USDT","tradetime":1658081400505,"tradetype":1,"handletime":1658081400505,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658082000602,"clientorderid":"18F1658082000505I0L3","price":"20978.1","quantity":"47.26305678036681","commission":"991.489131444212976861","commissionasset":"USDT","tradetime":1658082000602,"tradetype":1,"handletime":1658082000602,"gatetype":3},{"symbol":"BTCUSDT","tradeid":1658082600528,"clientorderid":"19F1658082600423I0L3","price":"20977","quantity":"46.907117994536875","commission":"983.970614171400026875","commissionasset":"USDT","tradetime":1658082600528,"tradetype":1,"handletime":1658082600528,"gatetype":3}]}


curl -X POST -d '{"method":"queryWorth","params":["testTrade",1657814400000,0,5]}' http://127.0.0.1:8808/strategy
{"result":[{"cashworth":"0","usdtcontractworth":"1000000","tokencontractworth":"0","time":1658022300154,"keyid":0},{"cashworth":"0","usdtcontractworth":"1000000","tokencontractworth":"0","time":1658022300355,"keyid":0},{"cashworth":"0","usdtcontractworth":"1000000","tokencontractworth":"0","time":1658022300555,"keyid":0},{"cashworth":"0","usdtcontractworth":"1000000","tokencontractworth":"0","time":1658022300754,"keyid":0},{"cashworth":"0","usdtcontractworth":"1000000","tokencontractworth":"0","time":1658022300954,"keyid":0}]}

curl -X POST -d '{"method":"queryBalances","params":["testTrade","USDT"]}' http://127.0.0.1:8808/strategy
{"result":[]}

curl -X POST -d '{"method":"queryContractAssets","params":["testTrade","USDT"]}' http://127.0.0.1:8808/strategy
{"result":[{"asset":"USDT","free":"-60801.0063445186174531948","total":"983970.6141714001067968052","margin":"1014371.1173436593755625","unreal":"30400.5031722593486875","type":1}]}

curl -X POST -d '{"method":"queryPositions","params":["testTrade","BTCUSDT",0]}' http://127.0.0.1:8808/strategy
{"result":[{"symbol":"BTCUSDT","positionAmount":"46.907117994536875","enterprice":"20977","countrevence":"0","unrealprofit":"35619.4785590715439433","marginmodel":0,"isolatedmargin":"0","positionside":0,"markprice":"21736.36190672","type":1}]}


curl -X POST -d '{"method":"queryHistoryPositions","params":["testTrade","BTCUSDT",1657814400000,0,5]}' http://127.0.0.1:8808/strategy
{"result":[{"symbol":"BTCUSDT","positionAmount":"0","enterprice":"21194","countrevence":"1259.790506747192511","unrealprofit":"0","marginmodel":0,"isolatedmargin":"0","positionside":0,"markprice":"0","type":1},{"symbol":"BTCUSDT","positionAmount":"0","enterprice":"21224.7","countrevence":"-852.988429020680805","unrealprofit":"0","marginmodel":0,"isolatedmargin":"0","positionside":1,"markprice":"0","type":1},{"symbol":"BTCUSDT","positionAmount":"0","enterprice":"21187.2","countrevence":"-2252.479443555873372","unrealprofit":"0","marginmodel":0,"isolatedmargin":"0","positionside":0,"markprice":"0","type":1},{"symbol":"BTCUSDT","positionAmount":"0","enterprice":"21008.9","countrevence":"2413.37079531268728","unrealprofit":"0","marginmodel":0,"isolatedmargin":"0","positionside":0,"markprice":"0","type":1},{"symbol":"BTCUSDT","positionAmount":"0","enterprice":"21132.2","countrevence":"-66.017860213237198","unrealprofit":"0","marginmodel":0,"isolatedmargin":"0","positionside":1,"markprice":"0","type":1}]}

curl -X POST -d '{"method":"queryStrategyEvaluate","params":["testTrade",1657814400000,0,5]}' http://127.0.0.1:8808/strategy
{"result":[]}

curl -X POST -d '{"method":"queryFactor","params":["testTrade",3,1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[]}

curl -X POST -d '{"method":"queryStrategyRunSnap","params":["testTrade",1657814400000,0,100]}' http://127.0.0.1:8808/strategy
{"result":[]}

curl -X POST -d '{"method":"queryPositions","params":["testTrade", "BTCUSDT", 0]}' http://127.0.0.1:8808/strategy
{"result":[{"symbol":"BTCUSDT","positionAmount":"46.907117994536875","enterprice":"20977","countrevence":"0","unrealprofit":"54813.4688253326157016","marginmodel":0,"isolatedmargin":"0","positionside":0,"markprice":"22145.5533277","type":1}]}


curl -X POST -d '{"method":"queryPositions","params":["testmulti20", "VETUSDT", 0]}' http://127.0.0.1:8808/strategy



------------------------------



2022-07-22 15:20:00,479:INFO:my:testTrade.py:155:openBuy:1847530: self.client.insertMarketUOrder("simulator", BTCUSDT, 43.21614555197822, "buy")
 91 2022-07-22 15:20:00,479:INFO:my:testTrade.py:160:openBuy:1847530: self.flagDict={'side': 'buy', 'posBuy': 0, 'posSell': 0, 'isNewDay': False, 'isOpenBuy': True, 'isOpenSell': False, 'isCloseBuy': False, 'isCloseSell': False, 'isOpen': True, 'isClose': False, 'isTrig': False, 'isCorr': False}
 92 2022-07-22 15:20:00,660:INFO:my:testTrade.py:113:handleOrderNew:1847530: new: OrderType

{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'clientorderid': '29F1658474400478I0L3', 'symbol': 'BTCUSDT', 'gatewayorderid': 1658474400637418, 'quantity': '43.21614555197822', 'price': '23139.6', 'stopprice': '0', 'ordertype': '', 'side': 'BUY', 'status': 'FILLED', 'positionside': 'LONG', 'createtime': 1658474400470, 'updatetime': 1658474400585, 'tradetype': 'usdt', 'selfid': 29, 'filltrades': [TradeType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'symbol': 'BTCUSDT', 'tradeid': 1658474400585, 'clientorderid': '29F1658474400478I0L3', 'price': '23139.6', 'quantity': '43.21614555197822', 'commission': '1000.004321614555219512', 'commissionasset': 'USDT', 'tradetime': 1658474400585, 'tradetype': 'usdt', 'gatetype': 'simulator', 'handletime': 1658474400585}], 'gatetype': 'simulator', 'handletime': 0}

93 2022-07-22 15:20:00,694:INFO:my:testTrade.py:116:handleOrderFilled:1847530: filled: OrderType

{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'clientorderid': '29F1658474400478I0L3', 'symbol': 'BTCUSDT', 'gatewayorderid': 1658474400637418, 'quantity': '43.21614555197822', 'price': '23139.6', 'stopprice': '0', 'ordertype': '', 'side': 'BUY', 'status': 'FILLED', 'positionside': 'LONG', 'createtime': 1658474400470, 'updatetime': 1658474400585, 'tradetype': 'usdt', 'selfid': 29, 'filltrades': [TradeType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'symbol': 'BTCUSDT', 'tradeid': 1658474400585, 'clientorderid': '29F1658474400478I0L3', 'price': '23139.6', 'quantity': '43.21614555197822', 'commission': '1000.004321614555219512', 'commissionasset': 'USDT', 'tradetime': 1658474400585, 'tradetype': 'usdt', 'gatetype': 'simulator', 'handletime': 1658474400585}], 'gatetype': 'simulator', 'handletime': 0}



137 2022-07-22 22:20:00,368:INFO:my:testTrade.py:65:handleKline:1849205: self.name='testTrade', self.symbol='BTCUSDT', self.tradeDate='20220722', self.openTime='221000', self.closeTime='221959', self.open='23352.4', self.close='23503.3', self.closeSec=1658499599, self.count=2
138 2022-07-22 22:20:00,525:INFO:my:testTrade.py:105:handleKline:1849205: closePosition count: 2139 2022-07-22 22:20:00,703:INFO:my:testTrade.py:117:handleOrderNew:1849205: new: OrderType

{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'clientorderid': '30F1658499600524I0L3', 'symbol': 'BTCUSDT', 'gatewayorderid': 1658499600670119, 'quantity': '43.21614555197822', 'price': '23504.9', 'stopprice': '0', 'ordertype': '', 'side': 'SELL', 'status': 'FILLED', 'positionside': 'SHORT', 'createtime': 1658499600518, 'updatetime': 1658499600618, 'tradetype': 'usdt', 'selfid': 30, 'filltrades': [TradeType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'symbol': 'BTCUSDT', 'tradeid': 1658499600618, 'clientorderid': '30F1658499600524I0L3', 'price': '23504.9', 'quantity': '43.21614555197822', 'commission': '1015.791179584692863278', 'commissionasset': 'USDT', 'tradetime': 1658499600618, 'tradetype': 'usdt', 'gatetype': 'simulator', 'handletime': 1658499600618}], 'gatetype': 'simulator', 'handletime': 0}

140 2022-07-22 22:20:00,710:INFO:my:testTrade.py:120:handleOrderFilled:1849205: filled: OrderType

{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'clientorderid': '30F1658499600524I0L3', 'symbol': 'BTCUSDT', 'gatewayorderid': 1658499600670119, 'quantity': '43.21614555197822', 'price': '23504.9', 'stopprice': '0', 'ordertype': '', 'side': 'SELL', 'status': 'FILLED', 'positionside': 'SHORT', 'createtime': 1658499600518, 'updatetime': 1658499600618, 'tradetype': 'usdt', 'selfid': 30, 'filltrades': [TradeType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'symbol': 'BTCUSDT', 'tradeid': 1658499600618, 'clientorderid': '30F1658499600524I0L3', 'price': '23504.9', 'quantity': '43.21614555197822', 'commission': '1015.791179584692863278', 'commissionasset': 'USDT', 'tradetime': 1658499600618, 'tradetype': 'usdt', 'gatetype': 'simulator', 'handletime': 1658499600618}], 'gatetype': 'simulator', 'handletime': 0}





}, {
	"clientorderid": "26F1658358000832I0L2", // 用户自定义的订单号
	"createtime": 1658358000826,
	"filltrades": [],
	"fixtype": 0,
	"gatetype": 3
	"gatewayorderid": 1658358000973044,
	"positionside": "LONG",  // 持仓方向
	"price": "23301.7",      // 委托价格
	"quantity": "42.915",    // 原始委托数量
	"selfid": 26,
	"side": "BUY",           // 买卖方向
	"status": "FILLED",      // 订单状态 NEW     
	"stopprice": "0",        // 触发价
	"symbol": "BTCUSDT",     // 交易对
	"tradetype": 1,     
	"type": "MARKET",       // 订单类型
	"updatetime": 1658358000926, #2022-07-21 07:00:00.926000
}


----Trace V1--------

启动/重启Trace
cd /root/FIL_test/trace &&  nohup ./Trace  >> /root/FIL_test/trace/screenlog_0.log 2>&1  &


curl -X POST -d '{"method":"hello","params":["similarity","0.001",18010,19010]}' http://127.0.0.1:8888/strategy
#curl -X POST -d '{"method":"recharge","params":["similarity","USDT","100000"]}' http://127.0.0.1:8888/strategy
nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1  &


curl -X POST -d '{"method":"queryWorth","params":["similarity",0,0,1]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryAllBalances","params":["similarity"]}' http://127.0.0.1:8888/strategy
curl -X POST -d '{"method":"queryAllPositions","params":["similarity"]}' http://127.0.0.1:8888/strategy

curl -X POST -d '{"method":"hello","params":["simi","0.001",18080,19090]}' http://127.0.0.1:8888/strategy
nohup python3 -u test.py -n simi -s 18080 -c 19090 -X BTCUSDT -p 10m -w 42 -d 84 -t 10000 >>test.txt 2>&1   &

nohup python3 pubsub.py -N Pyemd2 -y BTCUSDT -Q 150 -s 8401 -c 9401 >>err12.log 2>&1
python3 Panel_mom.py -N Panel_mon2 -Q 10000 -i 15m -w 20 -n 30 -o 15 -f symbols_ba.csv -p 8382 -c 9392


nohup python3 -u testTrade.py -n testmulti20 -s 8808 -c 19020 -X VETUSDT -p 5m  -t 1000000  >> /root/FIL/strategy/multiple/log20.txt 2>&1  &


nohup python3 -u main.py -n testmulti10 -s 8808 -c 19010 -X LINKUSDT -p 10m -w 60 -d 84 -t 1000000  >> /root/FIL/strategy/multiple/log10.txt 2>&1  &


1m 3m 5m 15m 30m 1h 2h 4h 6h 8h 12h 1d 3d 1w 1M

"BTCUSDT", "ETHUSDT", "BCHUSDT", "XRPUSDT", "EOSUSDT", "LTCUSDT", "TRXUSDT", "ETCUSDT", "LINKUSDT", "XLMUSDT", "ADAUSDT",  "XMRUSDT", "DASHUSDT", "ZECUSDT", "XTZUSDT", "BNBUSDT", "ATOMUSDT", "ONTUSDT", "IOTAUSDT", "BATUSDT", "VETUSDT", "NEOUSDT",

nohup python3 -u  -m flask run >>log.txt 2>&1  &

curl -X POST -d '{"method":"queryTrade","params":["similarity",0,0,1]}' http://127.0.0.1:8888/strategy


curl -H "Content-Type: application/json" -X POST -d '{"user_id": "123", "coin":100, "success":1, "msg":"OK!" }' "http://192.168.0.1:8001/test"


linux:
curl -d '{"login":"emma","pass":"123"}' -H 'Content-Type: application/json' http://127.0.0.1:5000 
curl -X POST -F 'image=@/home/user/Pictures/wallpaper.jpg' http://example.com/upload

win:
curl -X POST  -H "Content-Type: application/json" -d "{\"p1\":\"xyz\",\"p2\":\"xyz\"}" http://127.0.0.1:5000 
curl   -H "Content-Type: application/json" -d "{\"p1\":\"xyz\",\"p2\":\"xyz\"}" http://127.0.0.1:5000 
  
  

----df-----------------------

rt_df['balance']  = pd.to_numeric(rt_df['balance'] , errors='coerce', downcast='float')
ukdf['open'] = ukdf['open'].astype(float)

df['a'].round(decimals=2) # 小数位数，四舍五入
df['a'].map(lamdba x:('%.2f')%x) # object格式
df['a'].map(lamdba x:format(x,'.2%')) # 百分数 
df['a'].map(lamdba x:format(x,',')) # 千分位分隔符

rt_df['updateDate'] = pd.to_datetime(rt_df['updateTime'], unit="ms", origin="1970-01-01 08:00:00")
rt_df['queryTime'] = pd.to_datetime(int(time.time()), unit='s', origin="1970-01-01 08:00:00")

df = pd.DataFrame(np.arange(40).reshape(10,4),index=pd.date_range('2022-01-01',periods=10),columns=list('ABCD'))
df = pd.DataFrame(np.random.randn(8,4), columns=['A','B','C','D'])
df = pd.DataFrame(np.array([i for i in range(1,41)]).reshape(10,4), columns=['A','B','C','D'])

list(my_series) # 将 Pandas Series转换为列表
dict(my_series) # 将 Pandas Series转换为字典
numpy_array = my_series.values # 将 Pandas Series转换为Numpy 数组

df[ df["D"] > 1000 ].index.tolist()[-1] = 47
df.iloc[-1].index.tolist() = ['A', 'B', 'C', 'D', 'index', 'idx']

#a.iloc[-1, a.columns.get_loc('a')] = 77
df_panel.drop(df_panel[df_panel.tradeDate == '20220802'].index, inplace=True)
df_panel = pd.concat([df_panel,panel], ignore_index=True)
df_panel.iloc[-1, df_panel.columns.get_loc('thd')] = df_panel.iloc[-1, df_panel.columns.get_loc('emd')] - df_panel['emd'].rolling(window=histDays-40).mean()[-1:].values[0]
df.set_value('C', 'x', 10)

df.values：获取所有数据
df.values[i]：获取第i行数据
df.values[i][j]：获取第i行j列数据

df.iloc[[0],[1]].values[0][0] #取第1行，第2列的值
df['stock'].values[0]

df1['年龄'][0] #链表 不能更新  df1['年龄']['a']
df1.iloc[0, 1]   df1.loc['a', '年龄']
df1.iloc[:3]  # 前3行数据
df1.loc[:3]  # row_index = 3 那一行
df.loc[df.index[-1],'stock'] # 列stock 最后一行
df.loc[len(df)] = ['乔巴', 3]  # 添加一行数据
df.iloc[-1, df.columns.get_loc('close')] = self.close  # 有效更新 值
ukdf['close'].iloc[-1] = self.close  # 链表 不能更新 值 

#df.loc[df['gender']=='m','name']  #条件读取
df.loc[df['gender']=='M',['name','age']]

df.loc[df['AAA'] == 101] = (1,1,1,'h') #行赋值
df.loc[df['AAA'] == 101] = df1.to_numpy()

Worth_df = totalWorthdf2[['dateTime' , 'totalworth' , 'time' ]] # 选取列

条件选取
df[df.a>0]：选择a列中元素>0的所有行
df[(df.a>0) & (df.b<0)]：选择a列中元素>0同时b列中元素<0的所有行
df[列list] [df.a>0]：在a列中元素>0的所有行中，抽取‘列list’指定列的数据
df[列list] [(df.a>0) & (df.b<0)]：关系同上

data1=df[~df['标题'].str.contains('摘要')]
df[ df['通信名称'].isin(['联通','移动','小灵通','电信'])]
df[ df['通信名称'].str.contains('联通|移动|小灵通|电信')]

survived_sex = text['Survived'].groupby(text['Sex']).sum() # 统计男女的存活人数
text.groupby('Sex').agg({'Fare': 'mean', 'Pclass': 'count'}).rename(columns= {'are': 'mean_fare', 'Pclass': 'count_pclass'}) # 通过agg()函数来同时计算。并且可以使用rename函数修改列名
text.groupby(['Pclass','Age'])['Fare'].mean().head() # 统计在不同等级的票中的不同年龄的船票花费的平均值
text.groupby(['Pclass','Age'])['Fare'].mean().head() # 统计在不同等级的票中的不同年龄的船票花费的平均值
survived_age[survived_age.values==survived_age.max()] # 找出最大值的年龄段


df_panel = ukdf.groupby('tradeDate').apply(pymed,wid)
# print(f'{df_panel.iloc[:5,:]} \n')
# print(f'{df_panel.iloc[-5:,:]} \n')

df_panel.reset_index(inplace=True)
df_panel['thd'] = df_panel['emd'] - df_panel['emd'].rolling(window=histDays-40).mean()
# df_panel.dropna(how='any', inplace=True)
# df_panel.reset_index(inplace=True)
df_panel['pct_adj'] = np.where((df_panel['thd']>0) & (df_panel['pct_pre']>0),df_panel['pct'],0)
# std_ = np.std(df_panel['pct_adj'])*np.sqrt(365.0)
# df_panel['pct_adj'] = (1+df_panel['pct_adj']).cumprod() -1
# re_ = df_panel['pct_adj'].iloc[-1]**(365.0/df_panel.shape[0])


conn = sqlite3.connect('./worth1.db')   
df_bal = pd.read_sql(' select * from balance ', conn)  # 表 读库表 出库
rt_df.to_sql('balance', con=conn, if_exists='append', index=False) # 表 入库表
conn.close()

df_account0.to_pickle('%s/%s.pkl' % ('../pkl', "accountdf" ) )  # 表 存 pkl文件 
df_account0 = pd.read_pickle('%s/%s.pkl' % ('../pkl', "accountdf" ) ) # 表 读 pkl文件 

df_acc0.loc[len(df_acc0.index)] = ['bi_similarity_cb68', 'USDT', 2891.300537,  2980.668457]  # 表 末行追加

dfb = pd.concat([df_bal, df_bal0, df_balance0, df_acc0, df_account0, ],  ignore_index=True) # 表 合并  join='inner',  

dfb1 = dfb.iloc[:,0:12] # 表 截取 列0-11 左闭右开
dfb1['access'] = dfb1['access'].fillna('')  # 表 np.np 赋空字串''
dfb2 = dfb1[ ~dfb1['access'].str.contains('4f58')  ].sort_values(by="updateTime").drop_duplicates(subset=['updateTime'], keep='last', inplace=False, ignore_index=False) # 表 筛选 不包含 字符串'4f58' , 按列"updateTime" 排顺序, 列"updateTime"去重/保留最后1笔, 表更新 

dfb2['accountAlias'] = 'FzFzXqfWSgSgoC'
dfb2['access'] = 'similarity'  # name  access
dfb2.drop(['access'], axis=1, inplace=True) # 表 删除列 access
dfb2.columns = ['tradeDate', 'openTime', 'closeTime', 'closeSec', 'open', 'close'] # 表 重命名列

dfb2.sort_index(axis=1, ascending=True, inplace=True) # 表 按列名axis=1 排顺序ascending=True 表更新inplace=True
dfb2.reset_index(drop=True,inplace=True) # 表 重置索引 0++


#df 遍历 效率
DF['eee'] = DF['aaa'].values * DF['bbb'].values  #131us
DF['eee'] = DF['aaa'] * DF['bbb']  #263us
DF['eee'] = [ a*b for a,b in zip(DF['aaa'],DF['bbb']) ] #1.1ms
DF['eee'] = DF[['aaa','bbb']].apply(lambda x: x.aaa * x.bbb, axis=1) #90ms   frame=data.apply(lambda x:x*2)
DF['eee'] = DF.apply(lambda x: x.aaa * x.bbb, axis=1) #89ms

for index, row in df.iterrows(): # 342ms # 按行遍历，将DataFrame的每一行迭代为(index, Series)对，可以通过row[name]对元素进行访问。
	print(row['c1'], row['c2']) # 输出每一行 #index行索引

for row in df.itertuples():  # 按行遍历，将DataFrame的每一行迭代为元组，可以通过row[name]对元素进行访问，比iterrows()效率高。 
	print(getattr(row, 'c1'), getattr(row, 'c2')) # 输出每一行

for index, row in df.iteritems(): # 按列遍历，将DataFrame的每一列迭代为(列名, Series)对，可以通过row[index]对元素进行访问。
	print(row[0], row[1], row[2]) # 输出各列 #index列名

for i in range(len(DF)): 
	DF.iat[i,4] = DF.iat[i,0] * DF.iat[i,1] # 58ms
	DF.iloc[i,4] = DF.iloc[i,0] * DF.iloc[i,1]  # 2s


def add(x:int=3, y:int) -> int:
    return x + y


if 60 < grade < 90:
	print("passed")

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

with open('file.txt', 'w') as f:
	f.write('test')

str = ''.join(list)
'%s %s' % ('love', 'Python')

list = [i for i in range(5)]

odd = [i for i in list if i % 2 != 0]
# or
odd = filter(lambda x: x % 2 != 0, list)

num_squareL = [i**2 for i in numL]
odd_num_squareL = [i**2 for i in numL if i%2]

list(map(lambda x: x ** 2, [1, 2, 3, 4, 5]))

numS = set(numL)
num_squareS = {i**2 for i in numS}

[(i,i**2) for i in numL]
# [(-2, 4), (-1, 1), (0, 0), (1, 1), (2, 4)]
numDict = dict([(i,i**2) for i in numL])

numDict = {i:i**2 for i in numL if i>=0}
numDict = {i:i**2 for i in numDict.keys() - [1,2]} 
 
new_list = [x for x in old_list if x > 0]  # 筛选列表/字典中元素  使用列表推导/字典推导
new_dict = {key: value for key, value in old_dict.items() if value > 0}

my_dict = my_dict.setdefault(key, []).append(new_value) 

int2char = {1:'a', 2:'b'}
char2int = {char: ind for ind, char in int2char.items()}  #字典的键值转换

maxlen = len(max(text, key=len))  #获取长度最长的字符串长度

str_reverse = str[::-1] # 字符串取反
[start:end:span] # 遍历 [start,end)，a[start]到a[end-1]，间隔为span缺省1，span>0顺序遍历, span<0时逆着遍历。start缺省默认0，end缺省默认为长度。


list3 = list(set(list1).intersection(list2))  # 两个列表的并集
list3 = list(set(list1) & set(list2)) #X

list2 = list(set(list1)) # 利用集合去重

file_name = str(full_path).rsplit('/', 1)[-1].split('.')[0]  # 获取一条路径下文件名（不带扩展名）


"xxxx %s " % (value,)
"DAY %s 格式化字符串 %s " % (value1,value2)
# "xxxx {age} xxxx {name}".format(age=18, name="hangman")
"xxxx {1} xxx{0}".format(value1,value2)
"xxxx {} XXX {name} xxx {}".format(value2,value1,name="s4")
f'my name is {name:5.2f}, this year is {date:%Y},Next year, I\'m {age+1}'
f'{money:,}'  # 19,999,999,877
f'{money:+}'  # +19999999877
f'{name:^18}' # |      zings     |

a = b = c = 1
a, b, c = 1, 2, "runoob"  # 多变量赋值
x, y = y, x
result = 1 < n < 20
result = 1 > n <= 9

testList = [1,2,3]
x, y, z = testList

res = x if x > y else y
l = ['egg%s' % i for i in range(10)]
nums = [i for i in range(10)]
nums = [i**2 for i in range(10)]
nums = [i for i in range(10) if i > 3]
s = {i for i in range(10) if i > 3}
d = {i:i for i in range(10)}
d = {i:i for i in range(10) if i > 3}
x1 = 1000000  if 'b' not in char2int else char2int['b']

if m in [1,3,5,7]:
''.join(test)
dict (zip(t1,t2))

import json

data = {
    'name' : 'ACME',
    'shares' : 100,
    'price' : 542.23
}

json_str = json.dumps(data)

print(f'{data=} ,\n {json_str=}')
print(f'{type(data)=} ,\n {type(json_str)=}')

da = json.loads(json_str)
print(f'{type(json_str)=} ,\n {json_str=}')
print(f'{type(da)=} ,\n {da=}')


with open("demo2.json", encoding="utf-8") as f:
	data = json.load(f)
	# content = f.readlines() # 读行
	pritn(data)

with open("demo2.json", "w", encoding='utf-8') as f:
	# json.dump(dict_var, f) # 写为一行
	json.dump(dict_var, f,indent=2,sort_keys=True, ensure_ascii=False) # 写为多行



dict1 | dict2  #合并字典3.9
sorted([-5, -1, 2, 3, 4], key=lambda x: abs(x))  # 按备用键排序

nested_lists = [[1, 2], [3, 4, 5], [6]]
[item for inner_list in nested_lists for item in inner_list] # 展开列表中的列表

nums = [1, 2, 3, 4, 5] 
nums_squared = list(map(lambda n: n**2, nums)) # map函数 
[num for num in numbers if num > 3]  # 列表、集合和字典推导

import itertools 
list(itertools.accumulate([1, 2, 3, 4, 5]))  # 累计和


#Python 优化提速
1. 避免全局变量
2.1 避免模块和函数属性访问
from math import sqrt
sqrt = math.sqrt  # 赋值给局部变量
2.2 避免类内属性访问
将需要频繁访问的类内属性赋值给一个局部变量
3. 避免不必要的抽象
4.1 避免无意义的数据复制
4.2 交换值时不使用中间变量
4.3 字符串拼接用join而不是+
5. 利用if条件的短路特性
对于or语句，应该将值为True可能性比较高的变量写在or前，而and应该推后。
6.1 用for循环代替while循环
6.2 使用隐式for循环代替显式for循环
6.3 减少内层for循环的计算
7. 使用numba.jit  @numba.jit
8. 选择合适的内置数据结构
str, tuple, list(std::vector), set, dict
collections.deque。collections.deque是双端队列

#Pandas性能优化

1.数据读取的优化
 import pandas as pd
 #读取csv
 df = pd.read_csv('xxx.csv')
 Worth_df.to_csv('/workspaces/jupyter/tmp/similarity2_5min.csv')
 
 #pkl格式
 df.to_pickle('xxx.pkl') #格式另存
 df = pd.read_pickle('xxx.pkl') #读取


2.使用 agg 和 transform进行聚合操作时, 尽量使用Python的内置函数, 能够提高运行效率。

%%timeit
df.groupby("ProductCD")["TransactionAmt"].agg(sum) 
df.groupby("ProductCD")["TransactionAmt"].transform('mean')  #transform单列 apply多列

count（或size）	数量
nunique	不重复值数量
min	最小值
max	最大值
sum	求和
mean	均值
median	中位数
quantile(p)	p分位数, 仅在整数值下可取得准确值
var	方差
std	标准差
moment	n 阶中心矩（或 n 阶矩）
skew	样本偏度（无偏估计）
kurtosis	样本峰度（无偏估计）
cat	按sep做字符串连接操作
tolist	组合为 list

sizecount()group的统计
sem()均值的标准误
describe()统计信息描述
first()第一个group值
last()最后一个group值
nth()第n个group值 



3.对数据进行逐行操作时的优化: 采用isin筛选出各时段, 分段处理
peak_hours = df.index.hour.isin(range(17, 24))
df.loc[peak_hours, 'cost'] = df.loc[peak_hours, 'energy_kwh'] * 0.75

4. 使用numba

@nb.jit() # 用numba加速的求和函数
@nb.vectorize()  #矢量化（vectorize）。让普通函数变成ufunc
@nb.jit(nopython=True,fastmath=True)  # 牺牲一丢丢数学精度来提高速度
​@nb.jit(nopython=True,parallel=True)  # 自动进行并行计算
@nb.jit(nb.int64(nb.int32[:]))   # Numba的精度。nb.int64是说输出的数字为int64类型, nb.int32是说输入的数据类型为int32, 而[:]是说输入的是数组。


style
data.groupby(['姓名'])['金额'].agg(['mean','sum']).head(5).style.format('${0:,.2f}
 .format({'sum':'${0:,.0f}', '消费金额占比': '{:.2%}'}))                            
                             
format_dict = {'sum':'${0:,.0f}', '日期': '{:%Y-%m}', 'pct_of_total': '{:.2%}'}
(monthly_sales.style
              .format(format_dict)
              .highlight_max(color='#cd4f39')
              .highlight_min(color='lightgreen'))                             

     .style
     .background_gradient(cmap=cm))

monthly_sales.style
              .format(format_dict)
              .bar(color='#FFA07A', vmin=100_000, subset=['sum'], align='zero')
              .bar(color='lightgreen', vmin=0, subset=['pct_of_total'], align='zero')	 

迷你图 sparklines  字符串的形式展现一个迷你的数据特征图
from sparklines import sparklines
# 定义sparklines函数用于展现数据分布
def sparkline_str(x):
    bins = np.histogram(x)[0]
    sl = ''.join(sparklines(bins))
    return sl

# 定义groupby之后的列名
sparkline_str.__name__ = "分布图"

data.groupby('姓名')[['数量', '金额']].agg(['mean', sparkline_str])


json.dumps(data, separators=(',', ':'))
jsonify(data)




new_dataframe = dataframe.apply(lambda x: x + 10,  axis=1)
b = df.apply(lambda x:x.max()-x.min(), axis=1)
df['other_score']=df.nation.apply(lambda x:0 if x=='汉族' else 10)
df['interval']=df.date_to.apply(pd.to_datetime) - df.date_from.apply(pd.to_datetime)


df1 = pd.DataFrame()

df1 = pd.concat([df.head(5)],ignore_index=True)
df1 = pd.concat([df1,df.tail(5)],ignore_index=True)
print(f'{df1=}')

plt.savefig('D:\test.png')

df.to_pickle('foo.pkl')
pd.read_pickle('foo.pkl')


# pandas内存优化/压缩

def downcast(df):
    start_memory = df.memory_usage().sum() #返回一开始的使用内存
    for column in df.columns:              #循环所有列变量
        dtype_name = df[column].dtype.name #获取变量类型
        if dtype_name == 'object':
            pass                           #由于这里有姓名和船票，不方便直接转为分类变量
            #df[column] = df[column].astype('category') #像Embarked就可以转为分类变量压缩
        elif dtype_name == 'bool':                      #如果有布尔值可以转换为0,1压缩
            df[column] = df[column].astype('int8')
        elif dtype_name.startswith('int') or (df[column].round() == df[column]).all():
            df[column] = pd.to_numeric(df[column], downcast='integer')  #压缩整数列，这里年龄是浮点数也可以换成整数存储
        else:
            df[column] = pd.to_numeric(df[column], downcast='float')  #压缩浮点数
    end_memory = df.memory_usage().sum()  #返回压缩后的使用内存
    print('{:.1f}% compressed'.format(100 * (start_memory - end_memory) / start_memory))
    #返回压缩比
    return df
	
downcast(df)


# 各个数据类型的平均内存用量

for dtype in ['float','int','object']:
    selected_dtype = gl.select_dtypes(include=[dtype])
    mean_usage_b = selected_dtype.memory_usage(deep=True).mean()
    mean_usage_mb = mean_usage_b / 1024 ** 2
    print("Average memory usage for {} columns: {:03.2f} MB".format(dtype,mean_usage_mb))


gl_float = gl.select_dtypes(include=['float'])
converted_float = gl_float.apply(pd.to_numeric,downcast='float')

gl_int = gl.select_dtypes(include=['int'])
converted_int = gl_int.apply(pd.to_numeric,downcast='unsigned')

optimized_gl['date'] = pd.to_datetime(date,format='%Y%m%d')
print(mem_usage(optimized_gl))

dtypes = optimized_gl.drop('date',axis=1).dtypes
dtypes_col = dtypes.index
dtypes_type = [i.name for i in dtypes.values]
column_types = dict(zip(dtypes_col, dtypes_type))
read_and_optimized = pd.read_csv('game_logs.csv',dtype=column_types,parse_dates=['date'],infer_datetime_format=True)
print(mem_usage(read_and_optimized))

gl_obj = gl.select_dtypes(include=['object']).copy()
gl_obj.describe()
dow_cat.head().cat.codes
optimized_gl[converted_obj.columns] = converted_obj
mem_usage(optimized_gl)

for col in ['parks', 'playgrounds', 'sports', 'roading']:
    public[col] = public[col].astype('category')
	

# Pandas数据加速读取 优化内存 

from Reduce_fastload import reduce_fastload

train_df = pd.read_csv('../data/train.csv') # 耗时7s 600M
train_df.info(memory_usage='deep')

processl = reduce_fastload('../data/train.csv', use_HDF5=True) #优化数据内存，以HDF5格式存储预处理后的文件
processl.reduce_data() #优化内存 
process_datal = processl.reload_data()#读入优化处理的数据 # 耗时0.5s 174M

process2 = reduce_fastload('../data/train.csv', use_feather=True) #优化数据内存，以feather格式存储预处理后的文件
process2.reduce_data() #优化内存 
process_data2 = process2.reload_ata) #读入优化处理的数据  # 耗时0.07s 174M



# def getSimilarity(self, closeTime:str) -> pd.DataFrame:


#Python性能优化工具

每行代码的内存使用
pip install memory_profiler
@profile

python -m memory_profiler del3.py

每行代码的运行时间 @func_line_time
pip install line_profiler

from flask import Flask, jsonify
import time
from functools import wraps
from line_profiler import LineProfiler

查询接口中每行代码执行的时间 
def func_line_time(f):
    @wraps(f)
    def decorator(*args, **kwargs):
        func_return = f(*args, **kwargs)
        lp = LineProfiler()
        lp_wrap = lp(f)
        lp_wrap(*args, **kwargs) 
        lp.print_stats() 
        return func_return 
    return decorator

代码的运行时间
import timeit
result = timeit.timeit(my_func, number=5)

%%timeit


计时装饰器 @timeit
from functools import wraps
import time

def timeit(func):
    @wraps(func)
    def deco():
        start = time.time()
        res = func()
        end = time.time()
        delta = end - start
        print("Wall time ", delta)
        return res
    return deco

pyheat  图运行时间热力
pip install py-heat
pyheat <path_to_python_file> --out image_file.png


heartrate 可视化的监测
pip install --user heartrate

import heartrate
from heartrate import trace, files

heartrate.trace(browser=True)
trace(files=files.path_contains('my_app', 'my_library'))



###时间戳 日期 datetime###

from datetime import datetime, timedelta
import time

n1 = datetime.now()
print(n1.strftime("%Y%m%d %H:%M:%S %s %Z "))  # datetime.now().strftime("%Y%m%d")  20230110 04:05:01 1673323501
print(time.mktime(n1.timetuple())) # 1673323501.0

print(f"{28800 - datetime.utcnow().astimezone().utcoffset().total_seconds()}") #时差 28800.0

print(0, datetime.strptime(datetime.now().strftime("%Y%m%d"), "%Y%m%d").strftime("%Y%m%d %H:%M:%S %s %Z ")  ) # 0 20230110 00:00:00 1673308800 

print(int(datetime.strptime(datetime.now().strftime("%Y%m%d"), "%Y%m%d").strftime("%s")) ) # 1673308800

print(1, int(datetime.strptime("20220914", "%Y%m%d").strftime("%s")) ) # 1 1663113600
print(2, (datetime.strptime("20220914", "%Y%m%d") + timedelta(days=2) ).strftime("%s") )  # 2 1663286400
print(3,  ( datetime.fromtimestamp(1663113600)+ timedelta(days=3) ).strftime("%s")   ) #  3 1663372800

print(4, datetime.fromtimestamp(1663114199)) # 4 2022-09-14 00:09:59
print(5, datetime.fromtimestamp(1663113600)) #startSec=1663027200, endSec=1663113600,  # 5 2022-09-14 00:00:00

print(6, datetime.fromtimestamp(1656345600999//1000 +28800 )) # 6 2022-06-28 00:00:00
print(7, datetime.fromtimestamp(1664312400000//1000 +28800))   # 7 2022-09-28 05:00:00
print(8, datetime.fromtimestamp(1658975892471//1000))   # 8 2022-07-28 02:38:12
print(9, datetime.fromtimestamp(1667810456119//1000))   # 9 2022-11-07 08:40:56 

print(10, (datetime.now()- timedelta(days=10) ).strftime("%s000") )  # 10 1672459501000


print(11, f'{int(time.time()) + 5}999' ) 

print(f"{28800 - datetime.utcnow().astimezone().utcoffset().total_seconds()}") #时差

# rt_df['updateDate'] = pd.to_datetime(rt_df['updateTime'], unit="ms", origin="1970-01-01 08:00:00") 
# rt_df['queryTime'] = pd.to_datetime(int(time.time()), unit='s', origin="1970-01-01 08:00:00")

time.strftime("%Y-%m-%d %H:%M:%S",time.localtime(time.time()+28800)) # 8h = 28800s
current_time = (datetime.now() + timedelta(hours=8)).strftime('%Y-%m-%d %H:%M:%S')  #weeks days hours  minutes seconds 

startSec = int(datetime.strptime(datetime.now().strftime("%Y%m%d"), "%Y%m%d").strftime("%s"))  #时间戳
endSec = int( ( datetime.fromtimestamp(startSec)+ timedelta(days=histDays) ).strftime("%s") )  #时间戳

date_time = datetime.strptime('2019-09-12','%Y-%m-%d') 			#string格式转换成datetime格式
string = date_time.strftime('%Y-%m-%d') 						#datetime格式转换成String格式
time_stamp = time.mktime(date_time.timetuple()) 				#datetime转换为时间戳 %s
string = time.strftime('%Y-%m-%d',time.localtime(time_stamp)) 	#时间戳转换成string
now_dateTime = datetime.fromtimestamp(now_timestamp)			#时间戳转换成datetime

datetime.strptime(datetime.now().strftime("%Y%m%d"), "%Y%m%d").strftime("%Y%m%d %H:%M:%S %s") #20220914 00:00:00 1663113600

%a 本地的星期缩写
%A 本地的星期全称
%b 本地的月份缩写
%B 本地的月份全称
%c 本地的合适的日期和时间表示形式
%d 月份中的第几天，类型为decimal number（10进制数字），范围[01,31]
%f 微秒，类型为decimal number，范围[0,999999]，Python 2.6新增
%H 小时（24进制），类型为decimal number，范围[00,23]
%I 小时（12进制），类型为decimal number，范围[01,12]
%j 一年中的第几天，类型为decimal number，范围[001,366]
%m 月份，类型为decimal number，范围[01,12]
%M 分钟，类型为decimal number，范围[00,59]
%p 本地的上午或下午的表示（AM或PM），只当设置为%I（12进制）时才有效
%S 秒钟，类型为decimal number，范围[00,61]（60和61是为了处理闰秒）
%U 一年中的第几周（以星期日为一周的开始），类型为decimal number，范围[00,53]。在度过新年时，直到一周的全部7天都在该年中时，才计算为第0周。只当指定了年份才有效。
%w 星期，类型为decimal number，范围[0,6]，0为星期日
%W 一年中的第几周（以星期一为一周的开始），类型为decimal number，范围[00,53]。在度过新年时，直到一周的全部7天都在该年中时，才计算为第0周。只当指定了年份才有效。
%x 本地的合适的日期表示形式
%X 本地的合适的时间表示形式
%y 去掉世纪的年份数，类型为decimal number，范围[00,99]
%Y 带有世纪的年份数，类型为decimal number
%Z 时区名字（不存在时区时为空）
%% 代表转义的"%"字符
%s 时间戳 秒10位


------------------------------

#导入keyword 模块
import keyword
#显示所有关键字
keyword.kwlist

Python 关键字
False	None	True	and	as 		assert 	break	class	continue	def
del		elif	else 	except		finally	for		from	global		if		import
in		is		lambda	nonlocal	not	or	pass	raise	return		try		while	with	yield	 	 


#Python内置函数
abs()	all()		any()		basestring()	bin()			bool()			bytearray()		callable()	chr()		classmethod()
cmp()	compile() 	complex()	delattr()		dict()			dir()			divmod()		enumerate() eval()		execfile()
file()	filter()	float() 	format()		frozenset()		getattr()		globals()		hasattr()	hash()		help()
hex()	id()		input()		int() 			isinstance()	issubclass()	iter()			len()		list()		locals()
long()	map() 		max()		memoryview()	min()			next() 			object()		oct() 		open() 		ord()
pow()	print()		property()	range()	r		aw_input()		reduce()		reload()		repr()		reversed()	zip()
round() set()		setattr()	slice()			sorted()		staticmethod()	str()			sum()		super()		tuple()
type()	unichr()	unicode() 	vars()			xrange()		Zip()			__import__()	apply()		buffer()	coerce()


#类的专/私有方法 两个下划线开头，声明该方法为私有方法，只能在类的内部调用 ，不能在类的外部调用

__new__	创建类, 在 __init__ 之前创建对象
__init__	类的构造函数, 其功能是创建类对象时做初始化工作。
__del__ 	析构函数, 其功能是销毁对象时进行回收资源的操作
__add__	加法运算符 +, 当类对象 X 做例如 X+Y 或者 X+=Y 等操作, 内部会调用此方法。但如果类中对 __iadd__ 方法进行了重载, 则类对象 X 在做 X+=Y 类似操作时, 会优先选择调用 __iadd__ 方法。
__radd__	当类对象 X 做类似 Y+X 的运算时, 会调用此方法。
__iadd__	重载 += 运算符, 也就是说, 当类对象 X 做类似 X+=Y 的操作时, 会调用此方法。
__or__	'或'运算符 |, 如果没有重载 __ior__, 则在类似 X|Y、X|=Y 这样的语句中, '或'符号生效
__repr__, __str__	格式转换方法, 分别对应函数 repr(X)、str(X)
__call__	函数调用, 类似于 X(*args, **kwargs) 语句
__getattr__	点号运算, 用来获取类属性
__setattr__	属性赋值语句, 类似于 X.any=value
__delattr__	删除属性, 类似于 del X.any
__getattribute__	获取属性, 类似于 X.any
__getitem__	索引运算, 类似于 X[key], X[i:j]
__setitem__	索引赋值语句, 类似于 X[key], X[i:j]=sequence
__delitem__ 	索引和分片删除
__get__, __set__, __delete__	描述符属性, 类似于 X.attr, X.attr=value, del X.attr
__len__ 	计算长度, 类似于 len(X)
__lt__, __gt__, __le__, __ge__, __eq__, __ne__ 	比较, 分别对应于 <、>、<=、>=、=、!= 运算符。
__iter__, __next__	迭代环境下, 生成迭代器与取下一条, 类似于 I=iter(X) 和 next()
__contains__	成员关系测试, 类似于 item in X
__index__ 	整数值, 类似于 hex(X), bin(X), oct(X)
__enter__, __exit__	在对类对象执行类似 with obj as var 的操作之前, 会先调用 __enter__ 方法, 其结果会传给 var；在最终结束该操作之前, 会调用 __exit__ 方法（常用于做一些清理、扫尾的工作）


#pip3离线安装依赖库
pip3 freeze > requirements.txt
pip3 download -d packages -r requirements.txt  --trusted-host mirrors.cloud.aliyuncs.com
pip3 install *.whl


----判空存在--------------------------


# None,’’,0,[],{},() ,False都被判断为空值(not xxx等价)

None == None ," " == " " ,False == False都能返回判断True
type(NaN) # float
type(None) # NoneType
type("") # str

1、数值类型空值判断：
if not math.isnan(p['a']):

2、字符类型判断空值
if xxx
None,’’,0,[],{},() ,False都被判断为空值(not xxx等价 ; not () : True)

if xxx is None
需要区分None,  False, 空字符串"", 0, 空列表[], 空字典{}, 空元组() 等空值对象与None的区别时时可使用这种写法
如果比较相同的对象实例，is总是返回True 而 == 最终取决于 "eq()"
==只要相等，is表明要一样，同一个对象

if len(list_1) == 0:  #　如果此链表的长度为0则为空

if not a=='':
if a!='':
if len(a.strip())>0:  #去空格后
if a.strip():

if x is None
if not x：
if not x is None #（这句这样理解更清晰`if not (x is None)`）最好的写法 。


3、shaply判断
selectall = selectall[~selectall.conband.is_empty]



df.empty
pd.DataFrame(test) , 当进行count操作时，NaN和None都不计算在内，""则被计算在内；当进行sum等计算时，会对除NaN和None以外的值进行计算。
空值填充 fillna('*****')
test_1 = test.fillna(method='pad',limit = 1) # pad前行值/ffill前列值, backfill后行值/bfill后列值 替代/填充当前空值
test_2 = test.fillna(test['score'].mean())  # 统计量来替代

只有None 和NaN才被判断为空值
判断某一列中有空值存在，可以使用isnull().any() 或 df.isnull().any()
在Series或者DataFrame整体判断是否为空时，用isnull()
判断单个值是否为空时，要用np.isnan() , np.NaN != np.NaN
其他类型可以用type(x).__name__ == 'float'来判断是否为空值
当空值类型为None时，可以使用type(x) .__name__ == 'NoneType'来判断
可以用data[data.isnull().values==True]来筛选含有空值的行，但是如果某行有多个值是空值，则会重复次数出现，所以利用data[data.isnull().values==True].drop_duplicates()来去重：

为了将空值统一格式处理，可以在读取数据是限制一下，read_csv(na_values='NULL')将空值统一成NaN处理。

以属性名为变量的方式给一个对象添加属性
obj = SomeClass()
key = 'key_name'
val = 'key_value'
setattr(obj, key, val)
print(obj.key_name) 

hasattr(a,"name") # 检测是否存在属性 name True ，a 类 实例
callable(getattr(a,"fun1")) # 判断fun1是否函数，返回True
getattr(a,"fun1")() # 直接调用fun1函数


#判断变量是否存在

res1 = 'test1' in locals().keys()
res2 = 'test1' in dir()
res3 = 'test1' in vars().keys()


a = g_name if ('g_name' in dir() ) else 'similarity'

判断文件是否存在
import os
os.path.exists(test_file.txt)
True

判断文件夹是否存在
os.path.exists(no_exist_dir)
False

只检查文件
os.path.isfile("test-data")



全局变量
def magic_method(obj):
	return [name for name, val in globals().items() if val is obj]


import inspect
inspect.stack()[1][3]



#类的实例 变量 值
logger.info(f" { [i for i in dir(binan) if not i.startswith('_')] }") #变量方法列表
logger.info(f" { {k: v for k, v in binan.__dict__.items() if not k.startswith('__')} }")  #变量 值
	
获取所有子类

def get_subclasses(cls):
    return [subcls for subcls in cls.__subclasses__()]

获取类的所有方法
for var in dir(character):
    if var[:2] != '__':
        print '%s:' % var, getattr(character, var)


#获取模块中的类及类的属性方法信息
sys.modules模块
import sys
print(sys.modules[__name__])
print(sys.modules.values())
print(sys.modules.keys())
print(sys.modules.items())
示例
print(sys.modules.get("demo2"))

inspect模块
inspect.getmembers(object[, predicate])
inspect.ismodule(object)： 是否为模块
inspect.isclass(object)：是否为类
inspect.ismethod(object)：是否为方法（bound method written in python）
inspect.isfunction(object)：是否为函数(python function, including lambda expression)
inspect.isgeneratorfunction(object)：是否为python生成器函数
inspect.isgenerator(object):是否为生成器
inspect.istraceback(object)： 是否为traceback
inspect.isframe(object)：是否为frame
inspect.iscode(object)：是否为code
inspect.isbuiltin(object)：是否为built-in函数或built-in方法
inspect.isroutine(object)：是否为用户自定义或者built-in函数或方法
inspect.isabstract(object)：是否为抽象基类
inspect.ismethoddescriptor(object)：是否为方法标识符
inspect.isdatadescriptor(object)：是否为数字标识符，数字标识符有__get__ 和__set__属性； 通常也有__name__和__doc__属性
inspect.isgetsetdescriptor(object)：是否为getset descriptor
inspect.ismemberdescriptor(object)：是否为member descriptor
		
inspect.getdoc(object)： 获取object的documentation信息
inspect.getcomments(object)
inspect.getfile(object): 返回对象的文件名
inspect.getmodule(object)：返回object所属的模块名
inspect.getsourcefile(object)： 返回object的python源文件名；object不能使built-in的module, class, mothod
inspect.getsourcelines(object)：返回object的python源文件代码的内容，行号+代码行
inspect.getsource(object)：以string形式返回object的源代码
inspect.cleandoc(doc)：

    print(sys.modules.get("demo3"))
    class_list = []
    print(inspect.getmembers(sys.modules[__name__], inspect.isclass))
    print(inspect.getmembers(sys.modules.get("demo3"), inspect.isclass))
    for name, class_ in inspect.getmembers(sys.modules[__name__], inspect.isclass):
        class_list.append(class_)
        class_().run()
​
    print(class_list)


----装饰器--------------------------

# 计时器 耗时 函数运行所花费的时间
from functools import wraps
import time

def timer(func):

  @wraps(func)
  def wrapper(*args, **kwargs):
    start = time.perf_counter()

    # Call the actual function
    res = func(*args, **kwargs)

    duration = time.perf_counter() - start
    print(f'[{wrapper.__name__}] took {duration * 1000} ms')
    return res
  return wrapper
    
@timer
def isprime(number: int):
  """ Checks whether a number is a prime number """
  isprime = False
  for i in range(2, number):
    if ((number % i) == 0):
      isprime = True
      break
  return isprime

if __name__ == "__main__":
    isprime(number=155153)


#性能检查 : 内存使用情况等性能信息
from functools import wraps
import time,tracemalloc

def performance_check(func):
    """Measure performance of a function"""

    @wraps(func)
    def wrapper(*args, **kwargs):
      tracemalloc.start()
      start_time = time.perf_counter()
      res = func(*args, **kwargs)
      duration = time.perf_counter() - start_time
      current, peak = tracemalloc.get_traced_memory()
      tracemalloc.stop()

      print(f"\nFunction:             {func.__name__} ({func.__doc__})"
            f"\nMemory usage:         {current / 10**6:.6f} MB"
            f"\nPeak memory usage:    {peak / 10**6:.6f} MB"
            f"\nDuration:             {duration:.6f} sec"
            f"\n{'-'*40}"
      )
      return res
    return wrapper

@performance_check
def isprime(number: int):
  """ Checks whether a number is a prime number """
  isprime = False
  for i in range(2, number):
    if ((number % i) == 0):
      isprime = True
      break
  return isprime

if __name__ == "__main__":
    a = isprime(number=155153)
    print(a)


#中继器 : 执行几次，测试函数的性能
def repeater(iterations:int=1):
  """ Repeats the decorated function [iterations] times """
  def outer_wrapper(func):
    def wrapper(*args, **kwargs):
      res = None
      for i in range(iterations):
        res = func(*args, **kwargs)
      return res
    return wrapper
  return outer_wrapper
    
@repeater(iterations=2)
def sayhello():
  print("hello")


#提示你是否继续执行
def prompt_sure(prompt_text:str):
  """ Shows prompt asking you whether you want to continue. Exits on anything but y(es) """
  def outer_wrapper(func):
    def wrapper(*args, **kwargs):
      if (input(prompt_text).lower() != 'y'):
        return
      return func(*args, **kwargs)
    return wrapper
  return outer_wrapper

@prompt_sure('Sure? Press y to continue, press n to stop. ')
def sayhello():
  print("hi")

if __name__ == "__main__":
    sayhello()

# TryCatch 整个函数就可以免受异常的影响
def trycatch(func):
  """ Wraps the decorated function in a try-catch. If function fails print out the exception. """

  @wraps(func)
  def wrapper(*args, **kwargs):
    try:
      res = func(*args, **kwargs)
      return res
    except Exception as e:
      print(f"Exception in {func.__name__}: {e}")
  return wrapper

@trycatch
def trycatchExample(numA:float, numB:float):
  return numA / numB

if __name__ == "__main__":
    trycatchExample(9.3)
    trycatchExample(9,0)


------------------------------


print( time.strftime("%Y-%m-%d %H:%M:%S") ) #2022-07-03 10:55:25
print( int(time.mktime(time.strptime("2022-07-03 10:55:25", "%Y-%m-%d %H:%M:%S"))) ) #timeStamp 1656816925
print( time.time() )  # 1656817014.6468332
print( int(time.time()) )  #1656817055


------------------------------

环境	功能	说明
int	初始化	Initialization
DEV	开发	Development
test	测试	src dest target
SIT	系统集成测试(内测)	System Integrate Test
PET	性能评估测试(压测)	Performance Evaluation Test
UAT	用户验收测试	User Acceptance Test
PRE/PP	灰度环境 预发布	pre-release / Pre production
PRD/PROD	产品/正式/生产	Production
SIM	仿真	Simulation
ides	交互式演示与评估系统	Internet Demonstration and Evaluation System
qas	质量保证系统	Quality Assurance System


版本 Version	授权permission	语言language	开发阶段 stage
Preview预览版	Trial试用版	CN/SC/GBK简版	Alpha内测版α
Corporation&Enterprise企业版	Unregistered未注册版	CHT/TC/BIG5繁版	Beta公测版β
Standard标准版	Demo演示版	EN英版	Gamma熟测试版γ
Plus/Enhanced 增强版	Mini/Lite精简版	Multilanguage多语言版	RC最终版Release Candidate
Professional专业版	Full version完整版	UTF8版	SR修正更新版
Uprgade升级版	Free 自由版		Final正式版
Release发行版	Regged注册版	Build构建日期	RTM最终版Release To Manufactur
Premium超值版		SP升级包Service Pack	Rip核心版
Deluxe豪华版	GA 正式版 General Availability		OEM厂商版
Shareware共享版	Cardware共享版		RTL/FPP零售版Retail
Express特别版	RVL正式版		EVAL评估版



------------------------------

20220530
python3.8:
pip3 install numpy
pip3 install pandas
pip3 install matplotlib
pip3 install tensorflow

pip3 install pymysql
pip3 install cryptography

pip3 install sqlalchemy

requests

------------------------------





----CTP--------------------------

SimNow金融仿真交易平台，您的账号是：[185043]。15157186426，200w，登录密码是：[Pai@314159]
注册账号：151****6426
用户昵称：ation
investorId：185043
brokerId：9999
挂靠会员：SimNow
SimNow模拟，Appdi为simnow_client_test
SimNow，AuthCode为0000000000000000（16个0）


1、Init API：初始化；
2、Deinit API：反初始化；
3、Logon：登录交易账户；
4、Logoff：登出交易账户；
5、QueryData：查询各类交易数据； 
6、QueryHistoryData：查询各类历史数据；
7、SendOrder：委托下单；
8、CancelOrder：委托撤单；
9、GetQuote：获取五档报价；
10、Repay：融资融券账户直接还款；
11、GetExpireDate：查询 API 授权到期日期。


[config]
FrontAddr=tcp://127.0.0.1:41205
FrontMdAddr=tcp://127.0.0.1:41213
BrokerID=9999
UserID=00001
Password=123456
InvestorID=00001
UserProductInfo=aaa
AuthCode=G67YD00WMYKRKP1T
AppID=aaa


[config]
FrontAddr=tcp://180.168.146.187:10101
FrontMdAddr=tcp://180.168.146.187:10111
BrokerID=9999
UserID=185043
Password=Pai@314159
InvestorID=185043
UserProductInfo=test
AuthCode=0000000000000000
AppID=simnow_client_test



v6.3.15_20190220 20:39:53<RegisterSpi>
</RegisterSpi>
<SubscribePrivateTopic>
	nResumeType [2]
</SubscribePrivateTopic>
<SubscribePublicTopic>
	nResumeType [2]
</SubscribePublicTopic>
<RegisterFront>
	pszFrontAddress [tcp://127.0.0.1:41205]
</RegisterFront>
<Init>
</Init>



------------------------------


github网站打不开的解决方法
1.打开网站http://tool.chinaz.com/dns/ ，在A类型的查询中输入 github.com，找出最快的IP地址。

github网址查询：https://ipaddress.com/website/github.com
github域名查询：https://ipaddress.com/website/github.global.ssl.fastly.net
github静态资源ip：https://ipaddress.com/website/assets-cdn.github.com

2、打开hosts文件（C:\Windows\System32\drivers\etc）
3、然末尾放入一下两个 IP 地址：

# GitHub Start
140.82.114.4 github.com
199.232.69.194 github.global.ssl.fastly.net
# GitHub End

保存退出

3、在 CMD 命令行中执行下面语句 来刷新 DNS，重启浏览器之后就能进入Github 网址。
ipconfig/flushdns
然后直接访问


----sklearn--------------------------

# Sklearn库中的数据集  
一、Sklearn介绍  
scikit-learn是Python语言开发的机器学习库，一般简称为sklearn，目前算是通用机器学习算法库中实现得比较完善的库了。其完善之处不仅在于实现的算法多，还包括大量详尽的文档和示例。其文档写得通俗易懂，完全可以当成机器学习的教程来学习。

二、Sklearn数据集种类  
sklearn 的数据集有好多个种
自带的小数据集（packaged dataset）：sklearn.datasets.load_

鸢尾花数据集：load_iris()：用于分类任务的数据集 150 *4  http://scikit-learn.org/stable/auto_examples/datasets/plot_iris_dataset.html 
手写数字数据集：load_digits():用于分类任务或者降维任务的数据集 1797*64
乳腺癌数据集load_barest_cancer()：简单经典的用于二分类任务的数据集 569*30
糖尿病数据集：load_diabetes()：经典的用于回归认为的数据集，值得注意的是，这10个特征中的每个特征都已经被处理成0均值，方差归一化的特征值。 44 2 *10
波士顿房价数据集：load_boston()：经典的用于回归任务的数据集 506 *13
体能训练数据集：load_linnerud()：经典的用于多变量回归任务的数据集。 20*3
葡萄酒数据集：load_wine()：178*13
图像数据集（2个图像：中国和花朵）：load_sample_images() ：427*640*3

可在线下载的数据集（Downloaded Dataset）：sklearn.datasets.fetch_

fetch_olivetti_faces(data_home=None, shuffle=False, random_state=0,download_if_missing=True)：Olivetti 脸部图片数据集。

计算机生成的数据集（Generated Dataset）：sklearn.datasets.make_

make_blobs：聚类生成器, 多类单标签数据集，为每个类分配一个或多个正太分布的点集
n_samples:待生成的样本的总数
n_features:每个样本的特征数,默认为2
centers: 要生成的样本中心（类别）数，默认为3
cluster_std: 每个类别的方差，默认为1
shuffle: 打乱 (default=True)
data4,target4 = datasets.make_blobs(n_samples=1000,n_features=2,shuffle=True,random_state=2,centers=5,cluster_std=1.2) # shuffle是可以打乱
x, y = datasets.make_blobs(centers=2, random_state=1) # 制作块数据

make_classification：分类生成器, 多类单标签数据集，为每个类分配一个或多个正太分布的点集，提供了为数据添加噪声的方式，包括维度相关性，无效特征以及冗余特征等
n_features :特征个数= n_informative（） + n_redundant + n_repeated
n_informative：多信息特征的个数
n_redundant：冗余信息，informative特征的随机线性组合
n_repeated ：重复信息，随机提取n_informative和n_redundant 特征
n_classes：分类类别
n_clusters_per_class ：某一个类别是由几个cluster构成的
data3,target3 =  datasets.make_classification(n_samples=200,n_features=2,n_informative=2,n_redundant=0,n_repeated=0,n_clusters_per_class=1)
x, y = datasets.make_classification(n_informative=2, n_redundant=0, n_repeated=0, random_state=5) # 制作多分类数据集 | 简化版本为make_blobs

make_multilabel_classification 制作多目标分类
x, y = datasets.make_multilabel_classification(n_features=2, n_classes=4, n_labels=2)
_, axes = plt.subplots(2)
for idx, ax in enumerate(axes):
    ax.axis("off")
    ax.scatter(x[:, 0], x[:, 1], c=y[:, idx], s=50)
plt.scatter(x[:, 0], x[:, 1], c=y, s=50)
plt.show()

make_regression制作线性回归
x, y = datasets.make_regression(n_features=1, n_targets=1, noise=6)
plt.scatter(x, y)
plt.show()

make_gaussian_quantiles：将一个单高斯分布的点集划分为两个数量均等的点集，作为两类
make_hastie_10_2：产生一个相似的二元分类数据集，有10个维度

make_circle圆环图和make_moom月亮图产生二维二元分类数据集来测试某些算法的性能，可以为数据集添加噪声，可以为二元分类器产生一些球形判决界面的数据。
noise是指添加高斯噪音，factor是指内环与外环的接近成都，值越接近1，两环距离越近
data4,target4= make_circles(n_samples=100,shuffle=False,noise=0.2,random_state=56,factor=0.8)
fig,axes = plt.subplots(2,2)
x, y = datasets.make_circles(noise=0.05) # 制作双圆环数据
x, y = datasets.make_moons(noise=0.05) # 制作交互的半圆

产生同心圆型的二维二元分类 (标签为 0, 1) 数据集来测试某些算法的性能，可以为数据集添加噪声，可以为二元分类器产生一些球形判决界面的数据。
data, target = make_circles()


产生月牙形的二维二元分类 (标签为 0, 1) 数据集来测试某些算法的性能，可以为数据集添加噪声，可以为二元分类器产生一些球形判决界面的数据。
data, target = make_moons()


产生一个相似的二元分类数据集，有10个维度
data, target = make_hastie_10_2(n_samples=100)



svmlight/libsvm格式的数据集:sklearn.datasets.load_svmlight_file(…)

from sklearn.datasets importload_svmlight_file
x_train,y_train=load_svmlight_file("/path/to/train_dataset.txt","")#如果要加在多个数据的时候，可以用逗号隔开
svmlight/libsvm的每一行样本的存放格式：
: :…

data.org在线下载获取的数据集:sklearn.datasets.fetch_mldata(…)

from sklearn.datasets.mldata import fetch_mldata
import tempfile
test_data_home = tempfile.mkdtemp()
iris = fetch_mldata(‘iris’, data_home=test_data_home)
print(iris);print(iris.target.shape);
print(iris.data.shape)

三、Sklearn数据集  
1.有关数据集的工具类  
clearn_data_home 清空指定目录
get_data_home 获取sklearn数据根目录
load_files 加载类目数据
dump_svmlight_file 转化文件格式为svmlight/libsvm
load_svmlight_file 加载文件并进行格式转换
load_svmlight_files 加载文件并进行格式转换
2.有关文本分类聚类数据集  
fetch_20newsgroups 新闻文本分类数据集
fetch_20newsgroups_vectorized 新闻文本向量化数据集
fetch_rcv1 路透社英文新闻文本分类数据集
有关人脸识别的数据集
fetch_lfw_pairs 人脸数据集
fetch_lfw_people 人脸数据集
fetch_olivetti_faces 人脸数据集
3.有关图像的数据集  
load_sample_image 图像数据集
load_sample_images 图像数据集
load_digits 手写体数据集
4.有关医学的数据集  
load_breast_cancer 乳腺癌数据集
load_diabetes 糖尿病数据集
load_linnerud 体能训练数据集
5.其他数据集  
load_wine 葡萄酒数据集
load_iris 鸢尾花数据集
load_boston 波士顿房屋数据集
fetch_california_housing 加利福尼亚房屋数据集
fetch_kddcup99 入侵检测数据集
fetch_species_distribution 物种分布数据集
fetch_covtype 森林植被数据集
load_mldata mldata.org 在线下载的数据集





------------------------------



------------------------------



------------------------------




------------------------------




------------------------------




------------------------------

