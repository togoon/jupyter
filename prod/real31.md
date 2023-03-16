
# 正式环境 

服务器：8.219.68.31
root，hwr@20220924  reaL2022
ssh -l root 8.219.68.31
ping 8.219.68.31


# 1. 启动主程 FILv5.8
. /root/binance/crypto/fil/startFIL.sh  # killFIL.sh
/root/binance/crypto/logs/screenlog_Fil_bash_0.log

nohup ./realFIL run -c ./config.json -r ./risk.json >> /root/binance/crypto/logs/screenlog_Fil_bash_0.log 2>&1 &

# 2. 创建主账户 其中1,0,1 表示 keyid, gatewaytype中的binance, tradetype中的usdt合约类型
#1,0,1 "similarity", 1_pre1_200 , 200, "pre1", "subpre1", "127.0.0.1",32001

#2,0,1 "similarity_big", 2_main1_190000, 190000 "main1","main1","127.0.0.1",31002

curl -X POST -d '{"method":"insertAppkey","params":[1,0,1,"T6qUmdYPmqwfHOo3ttCJilZMYyxkdaDGROhJ8fZhgmGgTEagXsnXLsXeCUW7LdXG","oDJzCvyN9BDfyIgUc2dibgYeadxQxH9afu4peYuIyfa4sOFOwLQ57Rqui9N95gzJ","1_pre1_200"]}' http://127.0.0.1:18889/strategy
{"method":"insertAppkey","success":true,"message":""}

# risk1 1,0,1 testnet31_risk1 15000  创建/绑定母账户 createMainAccount 名称 交易所类型 Keyid 
curl -X POST -d '{"method":"createMainAccount","params":["pre1",0,1]}' http://127.0.0.1:18889/strategy
{"method":"createMainAccount","success":true,"message":""}

# 查询币安U本位账户 queryBinanceUsdtAccount
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["pre1"]}' http://127.0.0.1:18889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"1050.74805009","totalUnrealizedProfit":"0","totalMarginBalance":"1050.74805009","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"1050.74805009","totalCrossUnPnl":"0","availableBalance":"1050.74805009","maxWithdrawAmount":"1050.74805009","assets":[{"asset":"USDT","walletBalance":"1050.74805009","unrealizedProfit":"0","marginBalance":"1050.74805009","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"1050.74805009","crossUnPnl":"0","availableBalance":"1050.74805009","maxWithdrawAmount":"1050.74805009","marginAvailable":true,"updateTime":1677841788619}],"positions":[]}]}

{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"1049.78068141","totalUnrealizedProfit":"0","totalMarginBalance":"1049.78068141","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"1049.78068141","totalCrossUnPnl":"0","availableBalance":"1049.78068141","maxWithdrawAmount":"1049.78068141","assets":[{"asset":"USDT","walletBalance":"1049.78068141","unrealizedProfit":"0","marginBalance":"1049.78068141","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"1049.78068141","crossUnPnl":"0","availableBalance":"1049.78068141","maxWithdrawAmount":"1049.78068141","marginAvailable":true,"updateTime":1677945604332}],"positions":[]}]}

# 查询币安U本位账户风险 queryBinanceUsdtRisk 
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["pre1","BTCUSDT"]}' http://127.0.0.1:18889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"22377.4","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":1677841788619}]}]}

# 3. 创建子账户 createSubAccount 
# similarity,0,1  1_pre1_200, 1050.74805009,  subpre1 200
curl -X POST -d '{"method":"createSubAccount","params":["subpre1",1,"200.0"]}' http://127.0.0.1:18889/strategy 
{"method":"createSubAccount","success":true,"message":""}

# 4. 创建策略 hello  关闭 close
# pre1 subpre1 similarity 32001 200 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"hello","params":["similarity","pre1","subpre1","127.0.0.1",32001]}' http://127.0.0.1:18889/strategy 
{"method":"hello","success":true,"message":"{\"name\":\"similarity\" , \"time\":1677855332443, \"id\":1}"}

# 查询策略信息 queryStrategyInfo
curl -X POST -d '{"method":"queryStrategyInfo","params":["similarity"]}' http://127.0.0.1:18889/strategy 
{"method":"queryStrategyInfo","result":[{"name":"similarity","time":1677855332443,"mainID":1,"subID":2,"strategyID":1,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

# 启动策略

. /root/binance/crypto/v5/similarity/startSimilarity.sh  # killSimilarity.sh

nohup python3 -u main.py -n similarity -s 18889 -c 32001 -X BTCUSDT -p 10m -w 42 -d 84 -t 200 -r 0.5 >> log.txt 2>&1  &

ps aux | grep 18889 | grep similarity | grep 32001 | grep -v grep | awk '{print $2}'| xargs kill -9




# 5. 划转 accountTransfer 入金/出金

#交易所U本位合约资产到子账户u本位/8为该划转类型的值 , 子账户u本位到策略16
#策略到子账户17 , 子账户到母账户9

# pre1 subpre1 similarity 32001 200 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"accountTransfer","params":["pre1","subpre1","similarity","USDT","200",8]}' http://127.0.0.1:18889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["pre1","subpre1","similarity","USDT","200",16]}' http://127.0.0.1:18889/strategy
{"method":"accountTransfer","success":true,"message":""}

# 查询市价单合约资产 queryTradeContractAssets 
# pre1 subpre1 similarity 32001 200 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"queryTradeContractAssets","params":["similarity","USDT","BTCUSDT"]}' http://127.0.0.1:18889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"2000","total":"200","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"2000","shortfree":"2000","type":1}]}

# 查询限价单合约资产 queryLimitTradeContractAssets
# pre1 subpre1 similarity 32001 200 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["similarity","USDT","BTCUSDT","20000"]}' http://127.0.0.1:18889/strategy
{"method":"queryLimitTradeContractAssets","result":[{"asset":"USDT","free":"2000","total":"200","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"2000","shortfree":"1651.567403526076904385052209","type":1}]}

# 查询仓位v3 queryPositions  仓位方向 long1 short-1 
#long值(0, v2)改为(1, v3) , short值(1, v2)改为(-1, v3)

curl -X POST -d '{"method":"queryPositions","params":["similarity", "BTCUSDT", -1]}' http://127.0.0.1:18889/strategy
curl -X POST -d '{"method":"queryPositions","params":["similarity", "BTCUSDT", 1]}' http://127.0.0.1:18889/strategy
{"method":"queryPositions","result":[]} 


# 6. 资金和仓位的人工调整 fixUTrade   
# commission为正是减资金, 为负是加资金; 新开仓和反向开仓price需要填真实值,其他填0
# pre1 subpre1 similarity 32001 200 "mainID":1,"subID":2,"strategyID":1,

curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["pre1","BTCUSDT"]}' http://127.0.0.1:18889/strategy
curl -X POST -d '{"method":"queryPositions","params":["similarity", "BTCUSDT", -1]}' http://127.0.0.1:18889/strategy
curl -X POST -d '{"method":"queryPositions","params":["similarity", "BTCUSDT", 1]}' http://127.0.0.1:18889/strategy

# 仓位划转 成交数量quantity仓位调整
curl -X POST -d '{ "method":"fixUTrade", "params":[ "kline1", "subkline1", "similarity", {"symbol":"BTCUSDT", "quantity":"1.349", "commission":"0", "price":"23710", "commissionasset":"USDT", "positionside":"LONG", "orderside":"SELL" } ] }' http://127.0.0.1:18889/strategy

curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["pre1"]}' http://127.0.0.1:18889/strategy
curl -X POST -d '{"method":"queryTradeContractAssets","params":["similarity","USDT","BTCUSDT"]}' http://127.0.0.1:18889/strategy

# 仓位划转 手续费commission资金调整, 为正是减资金, 为负是加资金
curl -X POST -d '{ "method":"fixUTrade", "params":[ "pre1", "subpre1", "similarity", {"symbol":"BTCUSDT", "quantity":"0", "commission":"165.10564795", "price":"0", "commissionasset":"USDT", "positionside":"LONG", "orderside":"SELL" } ] }' http://127.0.0.1:18889/strategy


# 7 查询风控配置 queryRiskConfig  
curl -X POST -d '{"method":"queryRiskConfig","params":[]}' http://127.0.0.1:18889/strategy
{"method":"queryRiskConfig","result":[{"RiskInterval":60,"OrderTimePeriod":600,"Orderweight":1,"Requestweight":1,"UFRnum":9000,"GTCnum":4000,"DRnum":9000,"UFRLimit":{"gatetype":0,"threshold":"0.8","toWarn":true,"toForbid":true,"enable":false},"GTCLimit":{"gatetype":0,"threshold":"0.8","toWarn":true,"toForbid":true,"enable":false},"DRLimit":{"gatetype":0,"minAmount":"50","threshold":"0.8","toWarn":true,"toForbid":true,"enable":false},"LeverageLimit":[{"accountID":1,"threshold":"0.95","isMain":true,"toWarn":true,"toForbid":true,"enable":false},{"accountID":2,"threshold":"0.95","isMain":false,"toWarn":true,"toForbid":true,"enable":false}],"PositionLimit":[{"accountID":1,"tradetype":1,"symbol":"BTCUSDT","threshold":"0.95","isMain":true,"toWarn":true,"toForbid":true,"enable":false},{"accountID":2,"tradetype":1,"symbol":"BTCUSDT","threshold":"0.9","isMain":false,"toWarn":true,"toForbid":true,"enable":false}],"LossLimit":[{"accountID":1,"threshold":"-100","isMain":true,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":false},{"accountID":2,"threshold":"-50","isMain":false,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":false}],"WorthLimit":[{"accountID":1,"threshold":"0.8","isMain":true,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":false},{"accountID":2,"threshold":"0.8","isMain":false,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":false}]}]}

# 触发更新风控配置 updateRiskConfig 
curl -X POST -d '{"method":"updateRiskConfig","params":["/root/binance/crypto/fil/risk.json"]}' http://127.0.0.1:18889/strategy
{"method":"updateRiskConfig","result":"(1,sync update runing.)"}

# 查询风控当前计算状态 queryCurrentRiskResult
curl -X POST -d '{"method":"queryCurrentRiskResult","params":["similarity"]}' http://127.0.0.1:18889/strategy
{"method":"queryCurrentRiskResult","result":[{"Main":{"mainID":1,"updatetime":1677858434,"isIPLimit":false,"isAccountLimit":false,"isUFRLimit":false,"isGTCLimit":false,"isDRLimit":false,"isLeverageLimit":false,"isPositionLimit":false,"isLossLimit":false,"isWorthLimit":false},"Sub":{"subID":2,"updatetime":1677858434,"isIPLimit":false,"isAccountLimit":false,"isUFRLimit":false,"isGTCLimit":false,"isDRLimit":false,"isLeverageLimit":false,"isPositionLimit":false,"isLossLimit":false,"isWorthLimit":false}}]}


# 8 取消订阅定时器 cancelSubTimer 
curl -X POST -d '{"method":"cancelSubTimer","params":["similarity", 60000]}' http://127.0.0.1:18889/strategy

# 全部撤单 deleteAllOrder 
curl -X POST -d '{"method":"deleteAllOrder","params":["similarity" ]}' http://127.0.0.1:18889/strategy

# 全部平仓 closeAllPosition 
curl -X POST -d '{"method":"closeAllPosition","params":["similarity" ]}' http://127.0.0.1:18889/strategy

# 市价委托 insertMarketUOrder
curl -X POST -d '{"method":"insertMarketUOrder","params":["similarity",0, {"symbol":"BTCUSDT","quantity":"0.001","side":"SELL"}, 2]}' http://127.0.0.1:8889/strategy



zip -r realFIL_`date -d '+8 hour' '+%Y%m%d'`.zip fil -x='fil/bak/*'  #
tar -zcvf realFIL_20230304A.tar.gz  fil  # realFIL_20230304A.tar.gz
scp root@8.219.68.31:/root/binance/crypto/realFIL_20230304A.tar.gz ./

tar -zcvf v5_20230304A.tar.gz  v5  # v5_20230304A.tar.gz
scp root@8.219.68.31:/root/binance/crypto/v5_20230304A.tar.gz ./

# config.json

```json
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
        "jdbcport": 3306,
        "xdevport": 33060,
        "db": "risk_real",
        "usr": "root",
        "password": "reaL2022"
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
    "bitmex": {
        "restfulurl": "https://www.bitmex.com/api/v1",
        "wssurl": "wss://ws.bitmex.com/realtime",
        "timeout": 10000
    },
    "fil_host": "0.0.0.0",
    "fil_port": 18889,
    "trace_host": "0.0.0.0",
    "trace_port": 18888,
    "histest_host": "0.0.0.0",
    "histest_port": 18887,
    "clean_interval": 86400,
    "order_clean_interval": 2592000,
    "accountcheck_interval":180,
    "closelockcheck_interval":10,
    "worth_interval": 300,
    "exchangeinfo_interval": 86400,
    "feepercent": "0.001",
    "mainAccountReserve": "100",
    "initExchangeinfo":0
}


```



