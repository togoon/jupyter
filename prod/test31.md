

# 1. 启动主程 risk3
cd /root/binancefuture/crypto/fil && nohup ./FIL run -c ./config.json -r ./risk.json -k ./key.json >> /root/binancefuture/crypto/logs/screenlog_Fil_bash_0.log 2>&1 &

curl -X POST -d '{"method":"hello","params":["testrisk1","risk1","subrisk1","127.0.0.1",31000]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"hello","params":["similarity","kline1","subkline1","127.0.0.1",31001]}' http://127.0.0.1:8889/strategy


nohup python3 -u main_risk1.py -n testrisk1 -s 8889 -c 31000 -X BTCUSDT -p 3m -w 40 -d 3 -T 0.5 -t 15000  >> log_risk1.log 2>&1 &

nohup python3 -u main.py -n similarity -s 8889 -c 31001 -X BTCUSDT -p 10m -w 42 -d 84 -t 15000  >> log.txt 2>&1  &

ps aux | grep 8889 | grep similarity | grep 31001 | grep -v grep | awk '{print $2}'| xargs kill -9


```json
    "mysql": {
        "host": "127.0.0.1",
        "jdbcport": 3306,
        "xdevport": 33060,
        "db": "testrisk1",
        "usr": "root",
        "password": "reaL2022"
    },
```

# 2. 创建主账户 其中1,0,1 表示 keyid, gatewaytype中的binance, tradetype中的usdt合约类型
#1,0,1 "testrisk1",   testnet31_risk1 , 15000 "risk1", "subrisk1", "127.0.0.1",31000 
#2,0,1 "similarity", testnet32_kline1, 15000 "kline1","subkline1","127.0.0.1",31001

curl -X POST -d '{"method":"insertAppkey","params":[1,0,1,"f9529730010f598de9b0d4a9b0fe156b5541aba60f979f0e5c8902a6f830892f","dd53d75eaca841596ecb86429e1f1f2d62a433de1d7ab819d69636943803191e","testnet31_risk1"]}' http://127.0.0.1:8889/strategy
{"method":"insertAppkey","success":true,"message":""}

curl -X POST -d '{"method":"insertAppkey","params":[2,0,1,"0f9cba70f810787ad4d3cd6c49c8f97f14fca5f53bcd59a487e38c8eeed36a7b","49371d0e73eb89eef8d30c4a49b8d826d446b7d4aba75f652f2404cac165ee6d","testnet32_kline1"]}' http://127.0.0.1:8889/strategy

# risk1 1,0,1 testnet31_risk1 15000  创建/绑定母账户 createMainAccount 名称 交易所类型 Keyid 
curl -X POST -d '{"method":"createMainAccount","params":["risk1",0,1]}' http://127.0.0.1:8889/strategy
{"method":"createMainAccount","success":true,"message":""}

# kline1 2,0,1 testnet32_kline1 15000  创建/绑定母账户 createMainAccount 名称 交易所类型 Keyid 
curl -X POST -d '{"method":"createMainAccount","params":["kline1",0,2]}' http://127.0.0.1:8889/strategy

# 查询币安U本位账户 queryBinanceUsdtAccount
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["risk1"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["kline1"]}' http://127.0.0.1:8889/strategy

# 查询币安U本位账户风险 queryBinanceUsdtRisk 
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["risk1","BTCUSDT"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline1","BTCUSDT"]}' http://127.0.0.1:8889/strategy

# 3. 创建子账户 createSubAccount 
# risk1,0,1 risk1-testnet21 15000  subrisk1 7500
curl -X POST -d '{"method":"createSubAccount","params":["subrisk1",1,"15000.0"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"createSubAccount","params":["subkline1",2,"15000.0"]}' http://127.0.0.1:8889/strategy

# 4. 创建策略 hello  关闭 close
# risk1 subrisk1 testrisk1 31000 15000 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"hello","params":["testrisk1","risk1","subrisk1","127.0.0.1",31000]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testrisk1\" , \"time\":1676784179459, \"id\":1}"}

curl -X POST -d '{"method":"hello","params":["similarity","kline1","subkline1","127.0.0.1",31001]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"similarity\" , \"time\":1676784188308, \"id\":2}"}

# 查询策略信息 queryStrategyInfo
curl -X POST -d '{"method":"queryStrategyInfo","params":["testrisk1"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryStrategyInfo","params":["similarity"]}' http://127.0.0.1:8889/strategy

# 5. 划转 accountTransfer (需要重启主程 订阅账户) 

#交易所U本位合约资产到子账户u本位/8为该划转类型的值 , 子账户u本位到策略16
#策略到子账户17 , 子账户到母账户9

# risk1  subrisk1  testrisk1  31000 15000 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"accountTransfer","params":["risk1","subrisk1","testrisk1","USDT","15000",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["risk1","subrisk1","testrisk1","USDT","15000",16]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"accountTransfer","params":["kline1","subkline1","similarity","USDT","15000",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["kline1","subkline1","similarity","USDT","15000",16]}' http://127.0.0.1:8889/strategy

# 查询市价单合约资产 queryTradeContractAssets 
# risk1 subrisk1 testrisk1 31000 15000   "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testrisk1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryTradeContractAssets","params":["similarity","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy

# 查询仓位v3 queryPositions  仓位方向 long1 short-1 
#long值(0, v2)改为(1, v3) , short值(1, v2)改为(-1, v3)

curl -X POST -d '{"method":"queryPositions","params":["similarity", "BTCUSDT", -1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["similarity", "BTCUSDT", 1]}' http://127.0.0.1:8889/strategy


# 查询风控配置 queryRiskConfig  
curl -X POST -d '{"method":"queryRiskConfig","params":[]}' http://127.0.0.1:8889/strategy


# 触发更新风控配置 updateRiskConfig 
curl -X POST -d '{"method":"updateRiskConfig","params":["/root/FIL/fil/risk.json"]}' http://127.0.0.1:8889/strategy
{"method":"updateRiskConfig","result":"(1,sync update runing.)"}

# 查询风控当前计算状态 queryCurrentRiskResult
curl -X POST -d '{"method":"queryCurrentRiskResult","params":["testrisk1"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryCurrentRiskResult","params":["similarity"]}' http://127.0.0.1:8889/strategy


# 取消订阅定时器 cancelSubTimer 
curl -X POST -d '{"method":"cancelSubTimer","params":["similarity",60000]}' http://127.0.0.1:8889/strategy

# 全部撤单 deleteAllOrder 
curl -X POST -d '{"method":"deleteAllOrder","params":["similarity" ]}' http://127.0.0.1:8889/strategy

# 全部平仓 closeAllPosition 
curl -X POST -d '{"method":"closeAllPosition","params":["similarity" ]}' http://127.0.0.1:8889/strategy



