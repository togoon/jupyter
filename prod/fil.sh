# 1. 启动主程
cd /root/FIL/fil && nohup ./FIL run -c ./config.json -r ./kline.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 & 

cd /root/FIL/fil && nohup ./FIL run -c ./config.json -r ./risk.json -k ./key.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 & 

# 2. 创建s主账户 其中1,0,1 表示 keyid, gatewaytype中的binance, tradetype中的usdt合约类型
# 1,0,1 "testrisk1",  15000 "risk", "subrisk1", "127.0.0.1",39191 
# 2,0,1 "testkline1", 15000 "kline","subkline1","127.0.0.1",39193
# 3,0,1 "testorder1", 15000 "order","suborder1","127.0.0.1",39195 
# 3,0,1 "testtrade1", 15000 "trade","subtrade1","127.0.0.1",39197 

curl -X POST -d '{"method":"insertAppkey","params":[1,0,1,"8fe7623f5b17d916e19a2d04e8d6e7a65761daf678c1a90120fb69055a28f748","1770a8f54c937fa86c8d5c2155250f558531fdd6482c189e9881f8596b454662","testnet11risk1"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[2,0,1,"9dcb00b5339f33c7138188322b6c5f45d74f5b081d6fa50d5ed97df7bb420432","0887a29bca1961376dfe50d2efd51989698f982668c568d3dfa0408966a2ed7a","testnet12kline1"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[3,0,1,"d1322cbc05610f354531eac6727a6475977c83f713ebe0cb3635fd3c6a2b49ca","4edf2bf70514120039fed291435cc65f77961fc164d26e72037799532d774c5e","testnet13order1"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[4,0,1,"875e36221bb0ebdd847ea4ab64f56114eeae56daf1fcb29116c7ee41d0794394","a06b6e839a42b527733fafa051e5c1acd240419dac3801079c6d0c5ddfd5b025","testnet14trade1"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[5,0,1,"6433dff9990704302ede50ca608edfd27b22866cacf69f800fe8eaca5c241811","d2b2bdf0485ab4fb20d9aab7ae7754b993264d26859bcf541eba4289769956e0","testnet15risk2"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[6,0,1,"2d176ba955cff6ae618159186753761e2a1e2ec705f818e1d8bd68a7c46343c6","69327db724b70c99d9e0e9eafa1f34110a44f1a583a384e7beb379697e2d1ea2","testnet16kline2"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[7,0,1,"465b350908c7850354dd1df47e4a32ec989d928c8e8aa1d15d20f03f4e691b53","63aba318d49f4a6bb5286226ee8705495eeb5213d308d7d05dc8265a12ce2109","testnet17order2"]}' http://127.0.0.1:8889/strategy


{"method":"insertAppkey","success":true,"message":""}

# 查询appkey
curl -X POST -d '{"method":"queryAppkeys","params":[]}' http://127.0.0.1:8889/strategy
{"method":"queryAppkeys","result":[{"id":1,"type":0,"tradetype":1,"pubkey":"55db4162bc206da02f9e7333e6f80810cc2ebd383f44f9990d9168b4e1e8dcd45236eaaa6c156007230942055706845a4d2f446887914c78bbcee96bc3c03893","prikey":"5c8a1365eb2a38f32e9f7b37b5a7581e9f7cbc3d3843fb9c5d9c3eb7b4b988d75f34efaa6e1062072009135707078d0e46271a3bd7904974b8cdef6691c13a99","desc":"testnet11"},
{"id":2,"type":0,"tradetype":1,"pubkey":"54d94737ba223cf329cf7b62b1f25a11982cbc683518fa9f5acb3ae1b1b989d70336e8fd3d16360925551752570a840f4a7a463386cc1a7aeccdef6195c33f99","prikey":"5d851c62eb2067a4799d733db4f00a119f7be23c3810ad9f0dcf68b7b5e685db5138e4fd314c3407220942010007d0581b79433a85984474b899ba61c0933bca","desc":"testnet12kline1"},
{"id":3,"type":0,"tradetype":1,"pubkey":"098c1767b8713ca52ac97435b2a70a139d2ab7686841aa9b5f9b3be3b2eb8ad75e36ebf83047600625024456530fd7094c29113fd7cc4f2eb8cee93191ce6fca","prikey":"59d84033b87038f12ac97330b3f309169a26e23c6912f09c5c9a39e1e7e988845036e5ad3912650022054506005a83594f2c153d8891497ebccbec64919439ce","desc":"testnet13order1"}]}

# kline,0,1 testnet11 15000   名称 交易所类型 Keyid

curl -X POST -d '{"method":"createMainAccount","params":["risk",0,1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createMainAccount","params":["kline",0,2]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createMainAccount","params":["order",0,3]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createMainAccount","params":["trade",0,4]}' http://127.0.0.1:8889/strategy

# 查询币安U本位账户

curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["risk"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1673583382911}],"positions":[]}]}

curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["kline"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1673584774233}],"positions":[]}]}

curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["order"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1673585153537}],"positions":[]}]}

curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["trade"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1673788103572}],"positions":[]}]}


# 查询币安U本位账户风险
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["risk","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"21265.11474085","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}

curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"21251.4","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}

curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["order","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"0","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}

curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["trade","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"0","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}


# 查询币安U本位仓位模式  true 为双向持仓  false 为单向持仓
curl -X POST -d '{"method":"queryBinanceUsdtPositionSide","params":["risk"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtPositionSide","result":[{"dualSidePosition":false}]}

curl -X POST -d '{"method":"queryBinanceUsdtPositionSide","params":["kline"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtPositionSide","result":[{"dualSidePosition":false}]}

curl -X POST -d '{"method":"queryBinanceUsdtPositionSide","params":["order"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtPositionSide","result":[{"dualSidePosition":false}]}

# 查询主账户
curl -X POST -d '{"method":"queryMainAccount","params":["risk"]}' http://127.0.0.1:8889/strategy
{"method":"queryMainAccount","result":[{"name":"risk","id":1,"createtime":1673674896582,"updatetime":1673674896582,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"type":0,"tradetype":1,"keyid":1}]}

curl -X POST -d '{"method":"queryMainAccount","params":["kline"]}' http://127.0.0.1:8889/strategy
{"method":"queryMainAccount","result":[{"name":"kline","id":2,"createtime":1673959615287,"updatetime":1673959615287,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"type":0,"tradetype":1,"keyid":2}]}

curl -X POST -d '{"method":"queryMainAccount","params":["order"]}' http://127.0.0.1:8889/strategy
{"method":"queryMainAccount","result":[{"name":"order","id":3,"createtime":1673959625982,"updatetime":1673959625982,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"type":0,"tradetype":1,"keyid":3}]}

curl -X POST -d '{"method":"queryMainAccount","params":["trade"]}' http://127.0.0.1:8889/strategy
{"method":"queryMainAccount","result":[{"name":"trade","id":4,"createtime":1674211580026,"updatetime":1674211580026,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"type":0,"tradetype":1,"keyid":4}]}



# 3. 创建子账户 
# kline,0,1 testnet11 15000, subkline1 7500
curl -X POST -d '{"method":"createSubAccount","params":["subrisk1",1,"7500.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["subrisk2",1,"7500.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["subkline1",2,"7500.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["subkline2",2,"7500.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["suborder1",3,"7500.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["suborder2",3,"7500.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["subtrade1",4,"1000.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}

# 查询子账户
curl -X POST -d '{"method":"querySubAccount","params":["subrisk1"]}' http://127.0.0.1:8889/strategy 
{"method":"querySubAccount","result":[{"name":"subrisk1","id":2,"createtime":1673675267960,"updatetime":1673675267960,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":1,"initusdt":"7500"}]}

curl -X POST -d '{"method":"querySubAccount","params":["subrisk2"]}' http://127.0.0.1:8889/strategy 
{"method":"querySubAccount","result":[{"name":"subrisk2","id":3,"createtime":1673675284146,"updatetime":1673675284146,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":1,"initusdt":"7500"}]}

curl -X POST -d '{"method":"querySubAccount","params":["subkline1"]}' http://127.0.0.1:8889/strategy 
{"method":"querySubAccount","result":[{"name":"subkline1","id":4,"createtime":1673962956806,"updatetime":1673962956806,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":2,"initusdt":"7500"}]}

curl -X POST -d '{"method":"querySubAccount","params":["subkline2"]}' http://127.0.0.1:8889/strategy 
{"method":"querySubAccount","result":[{"name":"subkline2","id":5,"createtime":1673962979819,"updatetime":1673962979819,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":2,"initusdt":"7500"}]}

curl -X POST -d '{"method":"querySubAccount","params":["suborder1"]}' http://127.0.0.1:8889/strategy
{"method":"querySubAccount","result":[{"name":"suborder1","id":6,"createtime":1673963021727,"updatetime":1673963021727,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":3,"initusdt":"7500"}]}

curl -X POST -d '{"method":"querySubAccount","params":["suborder2"]}' http://127.0.0.1:8889/strategy 
{"method":"querySubAccount","result":[{"name":"suborder2","id":7,"createtime":1673963037881,"updatetime":1673963037881,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":3,"initusdt":"7500"}]}



# 4. 创建策略

# risk subrisk1 testrisk1 39191 7500 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"hello","params":["testrisk1","risk","subrisk1","127.0.0.1",39191]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testrisk1\" , \"time\":1673675393921, \"id\":1}"}

# risk subrisk2 testrisk2 39192 7500 "mainID":1,"subID":3,"strategyID":2,
curl -X POST -d '{"method":"hello","params":["testrisk2","risk","subrisk2","127.0.0.1",39192]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testrisk2\" , \"time\":1673875215258, \"id\":2}"}

# kline subkline1 testkline1 39193 7500 "mainID":2,"subID":4,"strategyID":4,
curl -X POST -d '{"method":"hello","params":["testkline1","kline","subkline1","127.0.0.1",39193]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testkline1\" , \"time\":1673969471869, \"id\":4}"}

# kline subkline2 testkline2 39194 7500 "mainID":2,"subID":5,"strategyID":5,
curl -X POST -d '{"method":"hello","params":["testkline2","kline","subkline2","127.0.0.1",39194]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testkline2\" , \"time\":1673970756980, \"id\":5}"}

# order suborder1 testorder1 39195 7500 "mainID":3,"subID":6,"strategyID":6,
curl -X POST -d '{"method":"hello","params":["testorder1","order","suborder1","127.0.0.1",39195]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testorder1\" , \"time\":1674004396894, \"id\":6}"}

# order suborder2 testorder2 39196 7500 "mainID":3,"subID":7,"strategyID":7,
curl -X POST -d '{"method":"hello","params":["testorder2","order","suborder2","127.0.0.1",39196]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testorder2\" , \"time\":1674004416643, \"id\":7}"}

# 查询策略信息
curl -X POST -d '{"method":"queryStrategyInfo","params":["testrisk1"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testrisk1","time":1673675393921,"mainID":1,"subID":2,"strategyID":1,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["testrisk2"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testrisk2","time":1673875215258,"mainID":1,"subID":3,"strategyID":2,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["testkline1"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testkline1","time":1673969471869,"mainID":2,"subID":4,"strategyID":4,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["testkline2"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testkline2","time":1673970756980,"mainID":2,"subID":5,"strategyID":5,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["testorder1"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testorder1","time":1674004396894,"mainID":3,"subID":6,"strategyID":6,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["testorder2"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testorder2","time":1674004416643,"mainID":3,"subID":7,"strategyID":7,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}


# 5. 划转交易所U本位合约资产到 子账户u本位/8为该划转类型的值  策略u本位/16为该划转类型的值

# risk  subrisk1  testrisk1  39191 7500 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"accountTransfer","params":["risk","subrisk1","testrisk1","USDT","7500",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["risk","subrisk1","testrisk1","USDT","7500",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# risk  subrisk2  testrisk2  39192 7500 "mainID":1,"subID":3,"strategyID":2,
curl -X POST -d '{"method":"accountTransfer","params":["risk","subrisk2","testrisk2","USDT","7500",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["risk","subrisk2","testrisk2","USDT","7500",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# kline subkline1 testkline1 39193 7500 "mainID":2,"subID":4,"strategyID":4,
curl -X POST -d '{"method":"accountTransfer","params":["kline","subkline1","testkline1","USDT","7500",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["kline","subkline1","testkline1","USDT","7500",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# kline subkline2 testkline2 39194 7500 "mainID":2,"subID":5,"strategyID":5,
curl -X POST -d '{"method":"accountTransfer","params":["kline","subkline2","testkline2","USDT","7500",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["kline","subkline2","testkline2","USDT","7500",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# order suborder1 testorder1 39195 7500 "mainID":3,"subID":6,"strategyID":6,
curl -X POST -d '{"method":"accountTransfer","params":["order","suborder1","testorder1","USDT","7500",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["order","suborder1","testorder1","USDT","7500",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# order suborder2 testorder2 39196 7500 "mainID":3,"subID":7,"strategyID":7,
curl -X POST -d '{"method":"accountTransfer","params":["order","suborder2","testorder2","USDT","7500",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["order","suborder2","testorder2","USDT","7500",16]}' http://127.0.0.1:8889/strategy
{"method":"accountTransfer","success":true,"message":""}

# 查询合约资产

# risk  subrisk1  testrisk1  39191 7500 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"queryContractAssets","params":["testrisk1","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"7500","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"0","shortfree":"0","type":1}]}

# risk  subrisk2  testrisk2  39192 7500 "mainID":1,"subID":3,"strategyID":2,
curl -X POST -d '{"method":"queryContractAssets","params":["testrisk2","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"7500","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"0","shortfree":"0","type":1}]}

# kline subkline1 testkline1 39193 7500 "mainID":2,"subID":4,"strategyID":4,
curl -X POST -d '{"method":"queryContractAssets","params":["testkline1","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"7500","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"0","shortfree":"0","type":1}]}

# kline subkline2 testkline2 39194 7500 "mainID":2,"subID":5,"strategyID":5,
curl -X POST -d '{"method":"queryContractAssets","params":["testkline2","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"7500","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"0","shortfree":"0","type":1}]}

# order suborder1 testorder1 39195 7500 "mainID":3,"subID":6,"strategyID":6,
curl -X POST -d '{"method":"queryContractAssets","params":["testorder1","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"7500","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"0","shortfree":"0","type":1}]}

# order suborder2 testorder2 39196 7500 "mainID":3,"subID":7,"strategyID":7,
curl -X POST -d '{"method":"queryContractAssets","params":["testorder2","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"7500","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"0","shortfree":"0","type":1}]}


# 查询市价单合约资产

# risk  subrisk1  testrisk1  39191 7500 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testrisk1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"15000","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"15000","shortfree":"15000","type":1}]}
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"-30028.83837693933","total":"7500","margin":"0","unreal":"0","lock":"15009.61279231311","syslock":"30019.22558462622","longfree":"-30028.83837693933","shortfree":"-15019.22558462622","type":1}]}

# risk  subrisk2  testrisk2  39192 7500 "mainID":1,"subID":3,"strategyID":2,
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testrisk2","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"-30106.65257807739","total":"7500","margin":"0","unreal":"0","lock":"15035.53659070302","syslock":"30071.11598737437","longfree":"-30106.65257807739","shortfree":"-15071.11598737437","type":1}]}

# kline subkline1 testkline1 39193 7500 "mainID":2,"subID":4,"strategyID":4,
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testkline1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy

# kline subkline2 testkline2 39194 7500 "mainID":2,"subID":5,"strategyID":5,
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testkline2","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy

# order suborder1 testorder1 39195 7500 "mainID":3,"subID":6,"strategyID":6,
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testorder1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy

# order suborder1 testorder2 39196 7500 "mainID":3,"subID":7,"strategyID":7,
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testorder2","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy


# 查询限价单合约资产
# risk  subrisk1  testrisk1  39191 7500 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testrisk1","USDT","BTCUSDT","20000"]}' http://127.0.0.1:8889/strategy
{"method":"queryLimitTradeContractAssets","result":[{"asset":"USDT","free":"15000","total":"7500","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"15000","shortfree":"13439.419692898436297613746456","type":1}]}

# risk  subrisk2  testrisk2  39192 7500 "mainID":1,"subID":3,"strategyID":2,
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testrisk2","USDT","BTCUSDT","20000"]}' http://127.0.0.1:8889/strategy

# kline subkline1 testkline1 39193 7500 "mainID":2,"subID":4,"strategyID":4,
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testkline1","USDT","BTCUSDT","20000"]}' http://127.0.0.1:8889/strategy

# kline subkline2 testkline2 39194 7500 "mainID":2,"subID":5,"strategyID":5,
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testkline2","USDT","BTCUSDT","20000"]}' http://127.0.0.1:8889/strategy

# order suborder1 testorder1 39195 7500 "mainID":3,"subID":6,"strategyID":6,
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testorder1","USDT","BTCUSDT","20000"]}' http://127.0.0.1:8889/strategy

# order suborder1 testorder2 39196 7500 "mainID":3,"subID":7,"strategyID":7,
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testorder2","USDT","BTCUSDT","20000"]}' http://127.0.0.1:8889/strategy


# updateRiskConfig 触发更新风控配置
curl -X POST -d '{"method":"updateRiskConfig","params":["/home/chain/program/FIL/build/risk.json"","USDT","BTCUSD"]}' http://127.0.0.1:8889/strategy

# queryRiskConfig 查询风控配置
curl -X POST -d '{"method":"queryRiskConfig","params":[]}' http://127.0.0.1:8889/strategy
{"method":"queryRiskConfig","result":[{"RiskInterval":60,"OrderTimePeriod":600,"Orderweight":1,"Requestweight":1,"UFRnum":10000,"GTCnum":5000,"DRnum":10000,"UFRLimit":{"gatetype":0,"threshold":"0.2","toWarn":true,"toForbid":true,"enable":false},"GTCLimit":{"gatetype":0,"threshold":"0.1","toWarn":true,"toForbid":true,"enable":false},"DRLimit":{"gatetype":0,"minAmount":"50","threshold":"0.2","toWarn":true,"toForbid":true,"enable":false},"LeverageLimit":[{"accountID":1,"threshold":"0.5","isMain":true,"toWarn":true,"toForbid":true,"enable":false},{"accountID":2,"threshold":"0.5","isMain":true,"toWarn":true,"toForbid":true,"enable":false}],"PositionLimit":[{"accountID":3641630432,"tradetype":1,"symbol":"BTCUSDT","threshold":"0.2","isMain":true,"toWarn":true,"toForbid":true,"enable":false},{"accountID":1,"tradetype":1,"symbol":"BTCUSDT","threshold":"0.2","isMain":true,"toWarn":true,"toForbid":true,"enable":false}],"LossLimit":[{"accountID":1,"threshold":"-50","isMain":true,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":false},{"accountID":2,"threshold":"-50","isMain":true,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":true}],"WorthLimit":[{"accountID":1,"threshold":"1.1","isMain":true,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":false},{"accountID":2,"threshold":"1.1","isMain":true,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":false}]}]}

# queryCurrentRiskResult 查询风控当前计算状态
curl -X POST -d '{"method":"queryCurrentRiskResult","params":["testkline1"]}' http://127.0.0.1:8889/strategy
{"error":{"code":32601,"message":"Request is not object"}}


# 取消订阅定时器
curl -X POST -d '{"method":"cancelSubTimer","params":["testkline1",60000]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"cancelSubTimer","params":["testkline2",60000]}' http://127.0.0.1:8889/strategy

# 加密库
sudo apt-get install libcrypto++-dev libcrypto++-doc libcrypto++-utils

# risk  subrisk1  testrisk1  39191 7500 "mainID":1,"subID":2,"strategyID":1,

# risk  subrisk2  testrisk2  39192 7500 "mainID":1,"subID":3,"strategyID":2,

# kline subkline1 testkline1 39193 7500 "mainID":2,"subID":4,"strategyID":4,

# kline subkline2 testkline2 39194 7500 "mainID":2,"subID":5,"strategyID":5,

# order suborder1 testorder1 39195 7500 "mainID":3,"subID":6,"strategyID":6,

# order suborder1 testorder2 39196 7500 "mainID":3,"subID":7,"strategyID":7,



cli = FILClient(MyFILHandler("test-strategy"),"http://127.0.0.1:8889/strategy",60,"127.0.0.1",9091,"http://127.0.0.1:8886/strategy") #8889为主程 8886为独立行情(最后的字符串可以不填)
cli.start()
cli.hello("mainname-binance", "subaccount-binance","127.0.0.1",9091) #通知主程
cli.hello2("mainname-binance", "subaccount-binance","127.0.0.1",9091) #通知独立行情
cli.subKline("binance", "usdt", "ETHUSDT", "1m")



