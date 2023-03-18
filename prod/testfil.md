
# 母/子账户设置 默认
杠杆x2, 单向持仓仓位模式，单币种保证金资产模式，全仓保证金模式，BTCUSDT

# 测试全杠杆
FIL系统V5.2风控/账户版, 测试环境（99.13）, 关闭全部风控, 测试全杠杆, BTCUSDT:

## 测试场景一( 子账户预扣千分之1费用)：
母账户kline: 15000usdt, x2, 可用：30000 ；
子账户testkline1：7500usdt, x2, 可用：15000 ；
子账户testkline2：7500usdt, x2, 可用：15000 ；

下单前行情：最新价20809.10 , 标记价格20809.2
市价单委托数量：0.72 (= 15000*0.999/20809.2)
子账户testkline1: 委托数量0.72, 成功（实际发生手续费5.9935USDT）
子账户testkline2: 委托数量0.72, 失败/被拒绝
母账户仓位：0.72

## 测试场景二( 子账户预扣千分之3费用)：
母账户risk: 15000usdt, x2, 可用：30000 ；
子账户testrisk1：7500usdt, x2, 可用：15000 ；
子账户testrisk2：7500usdt, x2, 可用：15000 ；

下单前行情：最新价20844.4 , 标记价格20844.4
市价单委托数量：0.717 (= 15000*0.997/20844.4)
子账户testrisk1: 委托数量0.717, 成功（实际发生手续费5.977USDT）
子账户testrisk2: 委托数量0.717, 成功（实际发生手续费5.977USDT）
母账户仓位：1.434

结论：FIL系统V5.2风控/账户版, 支持全杠杆委托（预扣千分之3费用）
后面再做个平仓, 然后看下子账号上的可用加总还等不等于母帐号可用+资金费


# 测试 查漏补缺 订单 
## 测试场景一( 子账户预扣千分之3费用)：error 
母账户 risk2: 15000usdt, x2, 可用：30000 ；
子账户 subrisk1 ：testrisk1 : 15000usdt, x2, 可用：30000 , -3e-3/-0.003
下单前行情：最新价 22886.226192 , 标记价格 22886.22619208 , 2023-01-31 17:51:44 , 
子账户subrisk1: 市价委托数量1.306, 	 buy 成功 22891.50（实际发生手续费 11.95851960 USDT）
母账户仓位：1.306 

平仓:							sell 成功 22884.90（实际发生手续费 11.95507176 USDT）

母账户 14967.46680865 = 15000 -11.9585196(开仓buy手续费) 		-11.95507176(平仓sell手续费) -8.6196(已实现盈亏)
子账户 14979.42532824 = 15000 {-11.9585196(开仓buy手续费)err} 	-11.95507176(平仓sell手续费) -8.6196(已实现盈亏)

## 测试场景二：error 
母账户 14967.47 , 客户/网页端 挂限价单 19950 * 1.499 , buy , 
最新价 23987.6 ， buy可开 0.001 ， sell可开1.247 
子账户 14979.42532824 , 
023-02-02 11:53:04,632:ERROR:testrisk1:main_risk1.py:431:handleOrderRejected:1115216: handleOrderRejected: data=OrderType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'clientorderid': '3F1675309984490I0L1', 'symbol': 'BTCUSDT', 'gatewayorderid': 0, 'quantity': '1.25', 'price': '0', 'stopprice': '0', 'ordertype': '', 'side': 'BUY', 'status': '', 'positionside': 'BOTH', 'createtime': 1675309984337, 'updatetime': 1675309984337, 'tradetype': 'usdt', 'selfid': 3, 'filltrades': [], 'gatetype':'binance', 'handletime': 0}

# 杠杆率风控测试 LeverageLimit

选项一：母账号列表
设置值：阈值
控制级别列表：预警，禁止
支持操作：增加、删除、修改
比较对象：杠杠率
应用于该母账号下所有子账账号和母账号新开仓，母子账号独立计算，任何一个大于阈值触发。
举例：母账号a下有a1….an子账号，若a1大于阈值，则触发a1开仓风控，若a大于阈值，则所有子账号触发开仓风控。

规则：杠杆率 > 阈值，触发
杠杆率 = （挂单价值 +多头价值 +空头价值）/资产净值；
资产净值 = 可用资金 +保证金冻结；

场景1：实时监控：按照1分钟k线频率监控母子杠杆率，取 标记价格markprice 计算/监控；触发后，则发出警告

场景2：预委托时：（预委托价值 + 挂单价值 +多头价值 +空头价值）/资产净值；触发后，则禁止新开/增仓；不限制头寸减少订单/反向单（下单量不超过当前持仓数量）；
反向数量超过当前持仓数量，杠杆率：（反向预委托合约价值 - 当前合约持仓合约价值 + 挂单价值 + 其他合约多头价值 +其他合约空头价值）/资产净值 > 阈值，触发；

预委托时杠杆率：公式（资产净值 = 调整后可用资金 +保证金冻结），根据合约持仓数量和方向，调整后可用资金：
i.持仓数量0：可用资金 - 预委托价值
Ii. 持仓数量非0：预委托与持仓同向：可用资金 - 预委托价值
预委托与持仓反向：可用资金 - （持仓价值 - 预委托价值）

预委托价值/挂单价值计算：
预委托价值 = 预委托数量 * 价格 ；（根据各自的委托/订单类型，获取不同价格）
限价单：使用委托价格price；
市价单：使用标记价格 markprice
止盈止损单：触发价格 stopPrice
跟踪止损单：激发价格 activationPrice

## 母账户杠杆率测试  "IsMain":true, "threshold": "0.5", "toForbid": true ,

	"LeverageLimit": [{
		"AccountID": [1],
		"threshold": "0.5",
		"toWarn": true,
		"toForbid": true,
		"IsMain":true,
		"enable":true
	},
	{
		"AccountID": [2],
		"threshold": "0.5",
		"toWarn": true,
		"toForbid": true,
		"IsMain":false,
		"enable":false
	}],

母账户 14967.46680865
子账户 14979.42532824 x2
下单前行情：最新价 23823.984372 , 标记价格 23823.98437239 ( 2023-02-02 20:00:23 )
子账户subrisk1: 市价委托数量1.253, 	 buy 成功 23802.20（实际发生手续费 11.92966264 USDT）
母账户仓位：1.253 , 母账户杠杆率 0.99 > 阈值threshold 0.5
11.90625660 USDT


## 杠杆率风控 LeverageLimit （阈值threshold 0.5，"toForbid": true,）
场景一：
母账户 可用余额 14967.46680865
子账户 14979.42532824 ，x2
下单前行情：最新价 23823.984372 , 标记价格 23823.98437239 ( 2023-02-02 20:00:23 )
子账户subrisk1: 市价委托数量1.253, 	 buy 成功 23802.20（实际发生手续费 11.92966264 USDT）
母账户仓位：1.253 , 母账户杠杆率 0.99 > 阈值threshold 0.5 ，触发（风控表riskwarnlog有记录），

期望 ：委托发出前，也需要计算/触发，即该笔委托成交后有可能会触发杠杆率规则，根据设置，禁止发出该笔委托

场景二：
母账户已触发 杠杆率风控 LeverageLimit 时：
策略减仓/平仓（与持仓反方向委托），也被禁用，回报handleRiskLimit

期望 ：减仓/平仓， 可以降低杠杆率，应该允许委托


当前委托有可能一起被触发多条风控，触发forbid后，不再计算后续风控是否会被触发；

2023-02-02 20:14:31,336:ERROR:testrisk1:main_risk1.py:488:handleRiskLimit:1118195: handleRiskLimit: data=OrderType{'sysID': SystemID{'mainID': '', 'subID': '', 'strate    gyID': ''}, 'clientorderid': '', 'symbol': 'BTCUSDT', 'gatewayorderid': 0, 'quantity': '1.253', 'price': '0', 'stopprice': '0', 'ordertype': '', 'side': 'SELL', 'statu    s': '', 'positionside': 'BOTH', 'createtime': 1675340071074, 'updatetime': 1675340071074, 'tradetype': 'usdt', 'selfid': 32607, 'filltrades': [], 'gatetype': 'binance'    , 'handletime': 0}


# 持仓限制风控测试 PositionLimit

选项一：账号列表
选项二：合约列表
选项三：数量，价值 列表
设置值：阈值
控制级别列表：预警，禁止
支持操作：增加、删除、修改
比较对象：根据选项二确定
应用于该母账号下所有子账账号和母账号新开仓，母子账号独立计算，任何一个大于阈值触发。
举例：母账号a下有a1….an子账号，若a1大于阈值，则触发a1开仓风控，若a大于阈值，则所有子账号触发开仓风控。

规则（单一品种，单向持仓）：以合约的数量为例，价值类似：
abs（预委托数量，同向挂单数量，持仓数量的代数和）> 阈值，触发

触发后取消预委托，返回订单失败信息；

场景示例（持仓数量限制，持仓价值限制类似）：
当前持仓 +300,  持仓限制阈值1000：
场景1 ： 同向挂单+ 200，增仓/同向 +600，触发（abs(+600+200+300) >1000，触发）
场景2 ： 同向挂单- 200，反向量 -1200，触发（abs(-1200-200+300)>1000，触发）

	"PositionLimit": [{
		"AccountID": [1],
		"tradetype": "usdt",
		"symbols": [{
			"symbol": "BTCUSDT",
			"threshold": "0.5"
		}],
		"toWarn": true,
		"toForbid": true,
		"IsMain":true,
		"enable":true
	},{
		"AccountID": [2],
		"tradetype": "usdt",
		"symbols": [{
			"symbol": "BTCUSDT",
			"threshold": "0.3"
		}],
		"toWarn": true,
		"toForbid": true,
		"IsMain":false,
		"enable":true
	}],


## 母账户持仓限制测试  "IsMain":true, "threshold": "0.5",
子账户限价委托：buy , 'quantity': '0.6', 'price': '22000',
母账户委托数量 0.6 > 阈值threshold 0.5 ，触发（风控表riskwarnlog有记录）

2023-02-03 12:55:45,286:ERROR:testrisk1:main_risk1.py:488:handleRiskLimit:1123640: handleRiskLimit: data=OrderType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'clientorderid': '', 'symbol': 'BTCUSDT', 'gatewayorderid': 0, 'quantity': '0.6', 'price': '22000', 'stopprice': '0', 'ordertype': '', 'side': 'BUY', 'status': '', 'positionside': 'BOTH', 'createtime': 1675400145136, 'updatetime': 1675400145136, 'tradetype': 'usdt', 'selfid': 32607, 'filltrades': [], 'gatetype': 'binance', 'handletime': 0}


## 子账户持仓限制测试  "IsMain":false, "threshold": "0.3", "toForbid": true
子账户限价委托：buy , 'quantity': '0.4', 'price': '22000',
子账户委托数量 0.4 > 阈值threshold 0.3 ，触发（风控表riskwarnlog有记录）

2023-02-03 11:25:02,012:ERROR:testrisk1:main_risk1.py:488:handleRiskLimit:1122991: handleRiskLimit: data=OrderType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'clientorderid': '', 'symbol': 'BTCUSDT', 'gatewayorderid': 0, 'quantity': '0.4', 'price': '22000', 'stopprice': '0', 'ordertype': '', 'side': 'BUY', 'stat    us': '', 'positionside': 'BOTH', 'createtime': 1675394701869, 'updatetime': 1675394701869, 'tradetype': 'usdt', 'selfid': 32607, 'filltrades': [], 'gatetype': 'binance', 'handletime': 0}



# 强平监控 亏损额 LossLimit

选项一：账号列表
选项二：账户监控类别（母账号，子账户）
设置值：阈值
控制级别列表：是否强平
支持操作：增加、删除、修改
比较对象：持仓合约亏损额（绝对值比较）
应用于该母账号下所有子账账号，子账号独立计算，大于则触发子账号下所有策略停止，根据控制级别确定是否触发强平。

按照1分钟k线频率监控，取markprice标记价格计算

	"LossLimit": [{
		"AccountID": [1],
		"threshold": "-100",
		"toWarn": true,
		"toForbid": true,
		"toCloseAll": true,
		"IsMain":true,
		"enable":true
	},{
		"AccountID": [2],
		"threshold": "-50",
		"toWarn": true,
		"toForbid": true,
		"toCloseAll": true,
		"IsMain":false,
		"enable":true
	}],


52607 [2023-02-02 21:33:27.643] [info] [HttpStrategy::handleOrderNew] order clientorderid:6F1675344807353I0L1
52608 [2023-02-02 21:33:27.643] [debug] [HttpStrategy::pushMessage] post_body:{"method":"OrderNew","message":{"clientorderid":"6F1675344807353I0L1","symbol":"BTCUSDT","gat      ewayorderid":3280279416,"quantity":"1.253","price":"0","stopprice":"0","type":"MARKET","side":"SELL","status":"NEW","positionside":"BOTH","createtime":1675344807130,      "updatetime":1675344807130,"tradetype":1,"fixtype":0,"selfid":6,"filltrades":[],"gatetype":0,"orderforce":""}}
52609 [2023-02-02 21:33:27.643] [debug] [HttpStrategy::doWork] message queue`s size:0


# 强平监控 单位净值 WorthLimit

选项一：账号列表
选项二：账户监控类别（母账号，子账户）
设置值：阈值
控制级别列表：是否强平
支持操作：增加、删除、修改
比较对象：单位净值
应用于该母账号下所有子账账号，子账号独立计算，大于则触发子账号下所有策略停止，根据控制级别确定是否触发强平。

按照1分钟k线频率监控，取markprice标记价格计算

单位净值 = 余额 / （期初额+中间转入额-中间转出额） 
公式中的余额 为 资产净值 = 可用资金 +保证金冻结

实际强平监控 ：相同的账户 2.3与2.4 设置其中一个即可。

	"WorthLimit": [{
		"AccountID": [1],
		"threshold": "0.7",
		"toWarn": true,
		"toForbid": true,
		"toCloseAll": true,
		"IsMain":true,
		"enable":true
	},{
		"AccountID": [2],
		"threshold": "0.8",
		"toWarn": true,
		"toForbid": true,
		"toCloseAll": true,
		"IsMain":false,
		"enable":true
	}]

强平监控 单位净值风控测试：
## 测试场景一( 母账户 ：空仓 "IsMain":true, "threshold": "0.7", error 

母账户 余额(=资产净值 = 可用资金 +保证金冻结) =  14885.11578941 + 0
母账户 单位净值 = 余额 / (期初额+中间转入额-中间转出额) = 14885.1158/(15000 +0 +0) = 0.9923 未小于 0.7 , 未触发

风控表 riskwarnlog记录 ：type=8(单位净值风控), 计算值value 1.987867 , 触发，错误如下：
1. 母账户：计算值value：1.987867 错误；
2. 子账户：计算值value：1.987867 错误；子账户计算过程涉及的中间值和结果应该与母账户不同(可参考问题17:子账户余额时，少算了开仓手续费)；
3. 强平监控/单位净值风控, 判断的方向是：低于阈值，则触发； 即当母/子账户计算值小于设置净单位值阈值(0.7/0.8)，则触发；



2023-02-04 11:32:48,470:ERROR:testrisk1:main_risk1.py:488:handleRiskLimit:1130203: handleRiskLimit: data=OrderType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'clientorderid': '', 'symbol': 'BTCUSDT', 'gatewayorderid': 0, 'quantity': '1.272', 'price': '0', 'stopprice': '0', 'ordertype': '', 'side': 'BUY', 'stat     us': '', 'positionside': 'BOTH', 'createtime': 1675481568080, 'updatetime': 1675481568080, 'tradetype': 'usdt', 'selfid': 32607, 'filltrades': [], 'gatetype': 'binance', 'handletime': 0}






# 合约交易量化规则测试 

（币安交易所，U本位合约，单一币种合约，计算周期每10分钟循环），触发后新开/增仓，可延迟至下个计算周期发出报单请求；
不限制头寸减少订单/反向单（下单量不超过当前持仓数量）：（在单向持仓中：增仓是指订单与该品种持仓方向相同，下同）


## UFRLimit 未成交率风控 UFRLimit 未成交率UFR >= 阈值 , 触发, 阈值参考 0.99-0.02

未成交率UFR：未成交的订单数占所有订单数量的百分比；
UFR = 1 - (前10分钟内已下单并执行的订单数量 / 前 10分钟内下单总数量) 
规则前置条件：10分钟内的所有订单计数 >= 10000/(1.2^（N-1)) ，
N：10 分钟循环内未成交订单的U合约品种数或币种数(下同)；
备注：前置条件满足后，才计算UFR 规则；

	"UFRnum":20,

	"UFRLimit": [{
		"gatetype": "binance",
		"threshold": "0.1",
		"toWarn": true,
		"toForbid": true,
		"enable":true
	}],

场景一：10分钟委托22笔 限价单 buy, 21000， 0.001，第23笔触发UFRLimit风控 "isUFRLimit":true
规则前置条件：10分钟内的所有订单计数 23 >= 20  # 10000/(1.2^（N-1)) ，24？

场景：测试未成交率风控UFRLimit后，设置: UFRLimit: "enable":false , 更新风控配置后(热加载)：
委托仍触发风控（handleRiskLimit）， 且风控表日志riskwarnlog 未记录（即 不清楚触发哪条风控）



## GTCLimit GTC取消率GCR >= 阈值 , 触发, 阈值参考 0.99-0.02

GTC 取消率GCR：10分钟内无效的取消订单占10分钟内所有 GTC 订单的百分比，无效的取消订单是指下单不到 2 秒就被取消的订单；
GCR = 10分钟内无效的取消订单计数 / 10分钟内GTC 订单计数
规则前置条件：10分钟内的 GTC 订单计数 >=5000/（1.2^（N-1））；
备注：前置条件满足后，才计算GCR 规则；

订单有效方法：
GTC：订单到成交为止, 一直有效
IOC：订单中无法立即成交（吃单）的部分就撤销
FOK：订单无法全部立即成交就撤销

	"GTCnum":10,

	"GTCLimit": [{
		"gatetype": "binance",
		"threshold": "0.1",
		"toWarn": true,
		"toForbid": true,
		"enable":true
	}],

场景一：10分钟委托22笔 限价单 buy, 19900， 0.001，第13笔触发小单率DR风控 "isGTCLimit":true
规则前置条件：10分钟内的所有订单计数 12 >= 10  # 10000/(1.2^（N-1)) 


## DRLimit 小单率DR >= 阈值, 触发, 阈值参考 0.9-0.1

小单率DR：小单计数占所有订单计数的百分比；小单指的是价值低于阀值的订单，阀值会依不同币种而有差异 （目前为 50 USDT/美元）
DR = 小单计数 / 订单计数
规则前置条件：10分钟内的所有订单计数 >= 10000/（1.2^（N-1））
备注：前置条件满足后，才计算DR 规则；

	"DRnum":10,

	"DRLimit": [{
		"gatetype": "binance",
		"threshold": "0.2",
		"minAmount": "50",
		"toWarn": true,
		"toForbid": true,
		"enable":true
	}],

场景一：10分钟委托22笔 限价单 buy, 19900， 0.001，第13笔触发小单率DR风控 "isDRLimit":true
规则前置条件：10分钟内的所有订单计数 12 >= 10  # 10000/(1.2^（N-1)) 



# 测试 资金费率 fundingRate
## 测试场景一 
母账户 fee1: 15000usdt, x2, 可用：30000 ；
子账户 subfee1 ：testfee1 : 10000usdt, x2, 可用：20000 , -3e-3/-0.003
子账户 subfee2 ：testfee2 : 5000usdt, x2, 可用：10000 , -3e-3/-0.003

下单前行情：最新价 22886.226192 , 标记价格 22886.22619208 , 2023-01-31 17:51:44 , 
子账户subrisk1: 市价委托数量1.306, 	 buy 成功 22891.50（实际发生手续费 11.95851960 USDT）
母账户仓位：1.306 







#########################################

# 测试指令 

cd /root/FIL/fil && nohup ./FIL run -c ./config.json -r ./risk.json -k ./key.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 &

curl -X POST -d '{"method":"hello","params":["testrisk1","risk1","subrisk1","127.0.0.1",39291]}' http://127.0.0.1:8889/strategy


nohup python3 -u main_risk1.py -n testrisk1 -s 8889 -c 39291 -X BTCUSDT -p 3m -w 40 -d 3 -T 0.5 -t 15000  >> log_risk1.log 2>&1 &

ps aux | grep 8889 | grep similarity | grep 39293 | grep -v grep | awk '{print $2}'| xargs kill -9


nohup curl -X POST -d '{"method":"cancelSubTimer","params":["testrisk1",60000]}' http://127.0.0.1:8889/strategy & 
curl -X POST -d '{"method":"cancelSubTimer","params":["testorder1",60000]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"cancelSubTimer","params":["testorder2",60000]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"deleteAllOrder","params":["testrisk1" ]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"closeAllPosition","params":["testrisk1" ]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"closeAllPosition","params":["similarity4" ]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryRiskConfig","params":[]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"updateRiskConfig","params":["/root/FIL/fil/risk.json"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryCurrentRiskResult","params":["testrisk1"]}' http://127.0.0.1:8889/strategy

{
	"keys": [{
		"id": 1,
		"type": "binance",
		"pubkey": "38c8df06299e955d57e9df4a520bb5589459d457f6ccf5fcced23f1033f151ce",
		"prikey": "a1cde020fb28435944bcddb03280e783b58d5764a952f122ea4653b6f2a8383e",
		"tradetype": "usdt",
		"desc": "risk21-testnet21"
	}]
}

# 1. 启动主程 risk3
cd /root/FIL/fil && nohup ./FIL run -c ./config.json -r ./kline.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 & 

cd /root/FIL/fil && nohup ./FIL run -c ./config.json -r ./risk.json -k ./key.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 & 

# 2. 创建主账户 其中1,0,1 表示 keyid, gatewaytype中的binance, tradetype中的usdt合约类型
#1,0,1 "testrisk1",   testnet23_risk1 , 15000 "risk1", "subrisk1", "127.0.0.1",39291 
#2,0,1 "similarity1", testnet22_kline1, 15000 "kline1","subkline1","127.0.0.1",39293
#3,0,1 "similarity2", testnet24_kline2, 15000 "kline2","subkline2","127.0.0.1",39294
#4,0,1 "similarity3", testnet25_kline3, 15000 "kline3","subkline3","127.0.0.1",39295
#5,0,1 "similarity4", testnet26_kline4, 15000 "kline4","subkline4","127.0.0.1",39296
#6,0,1 "testorder1", "testnet27_order1",10000 "order1","suborder1","127.0.0.1",39297 
#6,0,1 "testorder2", "testnet27_order1",5000  "order1","suborder2","127.0.0.1",39298 
#7,0,1 "testfee1", 	"testnet28_fee1",	10000 "fee1",	"subfee1",	"127.0.0.1",39290 
#7,0,1 "testfee2", 	"testnet28_fee1",	5000  "fee1",	"subfee2",	"127.0.0.1",39289

#8,0,1 "testtrade1", 15000 "trade1","subtrade1","127.0.0.1",39197 

curl -X POST -d '{"method":"insertAppkey","params":[1,0,1,"598e0636f68883477483b545ba086231e1be63458248e196c7b837820a6e498b","a633ce2b580dd5b1c578247340dbae619e566a0217d79b5ab6008b40de0365fd","testnet23_risk1"]}' http://127.0.0.1:8889/strategy
{"method":"insertAppkey","success":true,"message":""}

curl -X POST -d '{"method":"insertAppkey","params":[2,0,1,"4975e5ea27e6497db930f6773ac70dd12f05f76753b227125b60715c779ec9d8","cff76bf806526224454411d7a31e773b6517ae6bcdcd76fdefcd4e37817a9991","testnet22_kline1"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[3,0,1,"c8e4db02d4339972299ff5423b0b580d87d558d40d8262e12a2a45efd6a8a271","ee0a42f9459676021f50ce301b7cc93b7101a92e40224b40555bff1aa45625e2","testnet24_kline2"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[4,0,1,"76632e802c8da3c40aec0f15b29af406e7584a2d273e46cf72603a5e6a265d75","16662ef22fddede042bcf7be2f4297d1b451da7443dded5e11732f84a4487337","testnet25_kline3"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[5,0,1,"968532305fa5c74686a3c8980ed560783afd13cc07f6a27763df1fbb6e997428","9579a4afaa29514fc37e76779f1506879e535ae3d4e5a410aec0bdfa4103dfdd","testnet26_kline4"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[6,0,1,"deeec9c07260e1a0f61f76e69ee43c431a95716ff60178b24472ab707409030a","a36f9f4c78ff5a5d4f2599ed9e3e31f4297271021ba908857cf3269be8711188","testnet27_order1"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertAppkey","params":[7,0,1,"7dc31abfddc161ee6437cee02c0e955295c3fe16bc0505a0c808feab500e394f","7e763fef7d6eeee9a8d683fb5d9711464b9a996ebae0fef10b26c66c8be2c3b2","testnet28_1"]}' http://127.0.0.1:8889/strategy


#risk1 1,0,1 testnet23_risk1 15000  创建/绑定母账户 createMainAccount 名称 交易所类型 Keyid 
curl -X POST -d '{"method":"createMainAccount","params":["risk1",0,1]}' http://127.0.0.1:8889/strategy
{"method":"createMainAccount","success":true,"message":""}

#kline1 2,0,1 testnet22_kline1 15000  创建/绑定母账户 createMainAccount 名称 交易所类型 Keyid 
curl -X POST -d '{"method":"createMainAccount","params":["kline1",0,2]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"createMainAccount","params":["kline2",0,3]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"createMainAccount","params":["kline3",0,4]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"createMainAccount","params":["kline4",0,5]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"createMainAccount","params":["order1",0,6]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"createMainAccount","params":["fee1",0,7]}' http://127.0.0.1:8889/strategy

# 查询币安U本位账户 queryBinanceUsdtAccount
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["risk1"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"15000","totalUnrealizedProfit":"0","totalMarginBalance":"15000","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"15000","totalCrossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","assets":[{"asset":"USDT","walletBalance":"15000","unrealizedProfit":"0","marginBalance":"15000","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"15000","crossUnPnl":"0","availableBalance":"15000","maxWithdrawAmount":"15000","marginAvailable":true,"updateTime":1675925437979}],"positions":[]}]}

{"method":"queryBinanceUsdtAccount","result":[{"feeTier":0,"canTrade":true,"canDeposit":true,"canWithdraw":true,"updateTime":0,"totalInitialMargin":"0","totalMaintMargin":"0","totalWalletBalance":"14996.83506032","totalUnrealizedProfit":"0","totalMarginBalance":"14996.83506032","totalPositionInitialMargin":"0","totalOpenOrderInitialMargin":"0","totalCrossWalletBalance":"14996.83506032","totalCrossUnPnl":"0","availableBalance":"14996.83506032","maxWithdrawAmount":"14996.83506032","assets":[{"asset":"USDT","walletBalance":"14996.83506032","unrealizedProfit":"0","marginBalance":"14996.83506032","maintMargin":"0","initialMargin":"0","positionInitialMargin":"0","openOrderInitialMargin":"0","crossWalletBalance":"14996.83506032","crossUnPnl":"0","availableBalance":"14996.83506032","maxWithdrawAmount":"14996.83506032","marginAvailable":true,"updateTime":1676091706546}],"positions":[]}]}

curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["kline1"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["kline2"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["kline3"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["kline4"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["order1"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["fee1"]}' http://127.0.0.1:8889/strategy

# 查询币安U本位账户风险 queryBinanceUsdtRisk 
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["risk1","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtRisk","result":[{"risks":[{"symbol":"BTCUSDT","positionAmt":"0","entryPrice":"0","markPrice":"22855.5","unRealizedProfit":"0","liquidationPrice":"0","leverage":"2","maxNotionalValue":"300000000","marginType":"cross","isolatedMargin":"0","isAutoAddMargin":"false","positionSide":"BOTH","notional":"0","isolatedWallet":"0","updateTime":0}]}]}

curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline1","BTCUSDT"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline2","BTCUSDT"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline3","BTCUSDT"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline4","BTCUSDT"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["order1","BTCUSDT"]}' http://127.0.0.1:8889/strategy


# 修改币安U本位杠杆大小 20x 2x
curl -X POST -d '{"method":"changeBinanceUsdtLeverage","params":["kline1","BTCUSDT",2]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"changeBinanceUsdtLeverage","params":["kline4","BTCUSDT",2]}' http://127.0.0.1:8889/strategy


# 查询币安U本位仓位模式 queryBinanceUsdtPositionSide  true 为双向持仓  false 为单向持仓
curl -X POST -d '{"method":"queryBinanceUsdtPositionSide","params":["risk1"]}' http://127.0.0.1:8889/strategy
{"method":"queryBinanceUsdtPositionSide","result":[{"dualSidePosition":false}]}

curl -X POST -d '{"method":"queryBinanceUsdtPositionSide","params":["kline1"]}' http://127.0.0.1:8889/strategy

# 修改币安U本位仓位模式   true为双向持仓  false为单向持仓
curl -X POST -d '{"method":"chansubtest1geBinanceUsdtPositionSide","params":["risk1","false"]}' http://127.0.0.1:8889/strategy


# 查询主账户(需要重启主程 订阅账户) queryMainAccount null
curl -X POST -d '{"method":"queryMainAccount","params":["risk1"]}' http://127.0.0.1:8889/strategy
{"method":"queryMainAccount","result":[{"name":"risk2","id":1,"createtime":1675133809815,"updatetime":1675133809815,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"type":0,"tradetype":1,"keyid":1}]}

curl -X POST -d '{"method":"queryMainAccount","params":["kline4"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryMainAccount","params":["order1"]}' http://127.0.0.1:8889/strategy


# 3. 创建子账户 createSubAccount 
#risk1,0,1 risk1-testnet21 15000  subrisk1 7500
curl -X POST -d '{"method":"createSubAccount","params":["subrisk1",1,"15000.0"]}' http://127.0.0.1:8889/strategy
{"method":"createSubAccount","success":true,"message":""}

curl -X POST -d '{"method":"createSubAccount","params":["subkline1",2,"15000.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["subkline2",3,"15000.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["subkline3",4,"15000.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["subkline4",5,"15000.0"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"createSubAccount","params":["suborder1",6,"10000.0"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"createSubAccount","params":["suborder2",6,"5000.0"]}' http://127.0.0.1:8889/strategy


# 查询子账户 querySubAccount null
curl -X POST -d '{"method":"querySubAccount","params":["subrisk1"]}' http://127.0.0.1:8889/strategy
{"method":"querySubAccount","result":[{"name":"subrisk1","id":2,"createtime":1675134174706,"updatetime":1675134174706,"cantrade":true,"canwithdraw":true,"candeposit":true,"cashAccount":{"balance":[]},"uContractAccount":{"total":"0","totalmargin":"0","totalunreal":"0","contractAsset":[],"position":[]},"tCoutractAccount":{"contractAsset":[],"position":[]},"mainAccountID":1,"initusdt":"15000"}]}

curl -X POST -d '{"method":"querySubAccount","params":["subkline1"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"querySubAccount","params":["subkline2"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"querySubAccount","params":["subkline3"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"querySubAccount","params":["subkline4"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"querySubAccount","params":["suborder1"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"querySubAccount","params":["suborder2"]}' http://127.0.0.1:8889/strategy


# 4. 创建策略 hello  关闭 close
#risk1 subrisk1 testrisk1 39291 15000 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"hello","params":["testrisk1","risk1","subrisk1","127.0.0.1",39291]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testrisk1\" , \"time\":1676011242784, \"id\":1}"}

#2,0,1 "testkline1", testnet22_kline1, 15000 "kline1","subkline1","127.0.0.1",39293 similarity
curl -X POST -d '{"method":"hello","params":["similarity","kline1","subkline1","127.0.0.1",39293]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"similarity\" , \"time\":1676135925634, \"id\":4}"}

curl -X POST -d '{"method":"hello","params":["similarity2","kline2","subkline2","127.0.0.1",39294]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"similarity2\" , \"time\":1676344178123, \"id\":5}"}

curl -X POST -d '{"method":"hello","params":["similarity3","kline3","subkline3","127.0.0.1",39295]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"similarity3\" , \"time\":1676652148972, \"id\":6}"}

curl -X POST -d '{"method":"hello","params":["similarity4","kline4","subkline4","127.0.0.1",39296]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"similarity4\" , \"time\":1676967280715, \"id\":7}"}

curl -X POST -d '{"method":"hello","params":["testorder1","order1","suborder1","127.0.0.1",39297]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testorder1\" , \"time\":1677086235086, \"id\":8}"}
curl -X POST -d '{"method":"hello","params":["testorder2","order1","suborder2","127.0.0.1",39298]}' http://127.0.0.1:8889/strategy
{"method":"hello","success":true,"message":"{\"name\":\"testorder2\" , \"time\":1677086274421, \"id\":9}"}

curl -X POST -d '{"method":"close","params":["similarity"]}' http://127.0.0.1:8889/strategy
{"method":"close","success":true,"message":"sync exec. "}

# 查询策略信息 queryStrategyInfo
curl -X POST -d '{"method":"queryStrategyInfo","params":["testrisk1"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testrisk1","time":1675134335084,"mainID":1,"subID":2,"strategyID":1,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["similarity"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"similarity","time":1676135925634,"mainID":2,"subID":3,"strategyID":4,"major_version":0,"minor_version":0,"state":0,"closetime":1676135952432}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["similarity2"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryStrategyInfo","params":["similarity3"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"similarity3","time":1676652148972,"mainID":4,"subID":5,"strategyID":6,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["similarity4"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"similarity4","time":1676967280715,"mainID":5,"subID":6,"strategyID":7,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}

curl -X POST -d '{"method":"queryStrategyInfo","params":["testorder1"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testorder1","time":1677086235086,"mainID":6,"subID":9,"strategyID":8,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}
curl -X POST -d '{"method":"queryStrategyInfo","params":["testorder2"]}' http://127.0.0.1:8889/strategy
{"method":"queryStrategyInfo","result":[{"name":"testorder2","time":1677086274421,"mainID":6,"subID":10,"strategyID":9,"major_version":0,"minor_version":0,"state":0,"closetime":0}]}



# 5. 划转 accountTransfer (需要重启主程 订阅账户) 

#交易所U本位合约资产到子账户u本位/8为该划转类型的值 , 子账户u本位到策略16
#策略到子账户17 , 子账户到母账户9

#risk1  subrisk1  testrisk1  39291 15000 "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"accountTransfer","params":["risk1","subrisk1","testrisk1","USDT","15000",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["risk1","subrisk1","testrisk1","USDT","15000",16]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"accountTransfer","params":["kline1","subkline1","similarity","USDT","15000",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["kline1","subkline1","similarity","USDT","15000",16]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"accountTransfer","params":["kline2","subkline2","similarity2","USDT","15000",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["kline2","subkline2","similarity2","USDT","15000",16]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"accountTransfer","params":["kline3","subkline3","similarity3","USDT","15000",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["kline3","subkline3","similarity3","USDT","15000",16]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"accountTransfer","params":["kline4","subkline4","similarity4","USDT","15000",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["kline4","subkline4","similarity4","USDT","15000",16]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"accountTransfer","params":["order1","suborder1","testorder1","USDT","10000",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["order1","suborder1","testorder1","USDT","10000",16]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"accountTransfer","params":["order1","suborder2","testorder2","USDT","5000",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["order1","suborder2","testorder2","USDT","5000",16]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"accountTransfer","params":["order1","suborder2","testorder2","USDT","1000",17]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["order1","suborder2","testorder2","USDT","1000",9]}' http://127.0.0.1:8889/strategy


#交易所U本位合约资产到子账户u本位/8为该划转类型的值 , 子账户u本位到策略16
#合约资产到子账户u本位/8为该划转类型的值 , 子账户u本位到策略16
#策略到子账户17 , 子账户到母账户9


# 6. 资金和仓位的人工调整 fixUTrade 

curl -X POST -d '{"method":"queryBinanceUsdtRisk","params":["kline1","BTCUSDT"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["similarity", "BTCUSDT", -1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["similarity", "BTCUSDT", 1]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{ "method":"fixUTrade", "params":[ "kline1", "subkline1", "similarity", {"symbol":"BTCUSDT", "quantity":"1.349", "commission":"0", "price":"23710", "commissionasset":"USDT", "positionside":"LONG", "orderside":"SELL" } ] }' http://127.0.0.1:8889/strategy


curl -X POST -d '{"method":"queryBinanceUsdtAccount","params":["kline1"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryTradeContractAssets","params":["similarity","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{ "method":"fixUTrade", "params":[ "kline1", "subkline1", "similarity", {"symbol":"BTCUSDT", "quantity":"0", "commission":"165.10564795", "price":"0", "commissionasset":"USDT", "positionside":"LONG", "orderside":"SELL" } ] }' http://127.0.0.1:8889/strategy

#策略到子账户17 , 子账户到母账户9
curl -X POST -d '{"method":"accountTransfer","params":["kline1","subkline1","similarity","USDT","165.105647",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["kline1","subkline1","similarity","USDT","165.105647",16]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryTradeContractAssets","params":["similarity","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"accountTransfer","params":["kline1","subkline1","similarity","USDT","15000",8]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"accountTransfer","params":["kline1","subkline1","similarity","USDT","15000",16]}' http://127.0.0.1:8889/strategy



# 查询合约资产 queryContractAssets 
# risk1 subrisk1 testrisk1 39291 15000  "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"queryContractAssets","params":["testrisk1","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"15000","total":"15000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"0","shortfree":"0","type":1}]}

curl -X POST -d '{"method":"queryContractAssets","params":["similarity","USDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryContractAssets","result":[{"asset":"USDT","free":"15000","total":"15000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"0","shortfree":"0","type":1}]}




# 查询市价单合约资产 queryTradeContractAssets 
# risk1 subrisk1 testrisk1 39291 15000   "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"queryTradeContractAssets","params":["testrisk1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"30000","total":"15000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"30000","shortfree":"30000","type":1}]}

{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"29993.67012064","total":"14996.83506032","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"29993.67012064","shortfree":"29993.67012064","type":1}]}

curl -X POST -d '{"method":"queryTradeContractAssets","params":["similarity","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"30000","total":"15000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"30000","shortfree":"30000","type":1}]}

curl -X POST -d '{"method":"queryTradeContractAssets","params":["similarity2","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[]}
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"-4945.8443402082","total":"14988.12717672","margin":"32302.0784468241","unreal":"-2620.0202468241","lock":"0","syslock":"0","longfree":"27356.2341066159","shortfree":"-4945.8443402082","type":1}]}

curl -X POST -d '{"method":"queryTradeContractAssets","params":["similarity3","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"30000","total":"15000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"30000","shortfree":"30000","type":1}]}

curl -X POST -d '{"method":"queryTradeContractAssets","params":["similarity4","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"300000","total":"15000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"300000","shortfree":"300000","type":1}]}

curl -X POST -d '{"method":"queryTradeContractAssets","params":["testorder1","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"20000","total":"10000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"20000","shortfree":"20000","type":1}]}

curl -X POST -d '{"method":"queryTradeContractAssets","params":["testorder2","USDT","BTCUSDT"]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"10000","total":"5000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"10000","shortfree":"10000","type":1}]}


# 查询限价单合约资产 queryLimitTradeContractAssets
# risk1 subrisk1 testrisk1 39291 15000   "mainID":1,"subID":2,"strategyID":1,
curl -X POST -d '{"method":"queryLimitTradeContractAssets","params":["testrisk1","USDT","BTCUSDT","10000"]}' http://127.0.0.1:8889/strategy
{"method":"queryLimitTradeContractAssets","result":[{"asset":"USDT","free":"30000","total":"15000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"18443.206889197599701397337825","shortfree":"30000","type":1}]}

# 查询仓位v3 queryPositions  仓位方向 long1 short-1 : long值从0(v2)改为1(v3) , short值从1(v2)改为-1(v3)
curl -X POST -d '{"method":"queryPositions","params":["testrisk1", "BTCUSDT", -1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["testrisk1", "BTCUSDT", 1]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryPositions","params":["similarity", "BTCUSDT", -1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["similarity", "BTCUSDT", 1]}' http://127.0.0.1:8889/strategy
{"method":"queryTradeContractAssets","result":[{"asset":"USDT","free":"30000","total":"15000","margin":"0","unreal":"0","lock":"0","syslock":"0","longfree":"30000","shortfree":"30000","type":1}]}

curl -X POST -d '{"method":"queryPositions","params":["similarity2", "BTCUSDT", -1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["similarity2", "BTCUSDT", 1]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryPositions","params":["similarity3", "BTCUSDT", -1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["similarity3", "BTCUSDT", 1]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryPositions","params":["similarity4", "BTCUSDT", -1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["similarity4", "BTCUSDT", 1]}' http://127.0.0.1:8889/strategy


curl -X POST -d '{"method":"queryPositions","params":["testorder1", "BTCUSDT", -1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["testorder1", "BTCUSDT", 1]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"queryPositions","params":["testorder2", "BTCUSDT", -1]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryPositions","params":["testorder2", "BTCUSDT", 1]}' http://127.0.0.1:8889/strategy





# 查询风控配置 queryRiskConfig  
curl -X POST -d '{"method":"queryRiskConfig","params":[]}' http://127.0.0.1:8889/strategy
{"method":"queryRiskConfig","result":[{"RiskInterval":60,"OrderTimePeriod":600,"Orderweight":1,"Requestweight":1,"UFRnum":10000,"GTCnum":5000,"DRnum":10000,"UFRLimit":{"gatetype":0,"threshold":"0.2","toWarn":true,"toForbid":true,"enable":false},"GTCLimit":{"gatetype":0,"threshold":"0.1","toWarn":true,"toForbid":true,"enable":false},"DRLimit":{"gatetype":0,"minAmount":"50","threshold":"0.2","toWarn":true,"toForbid":true,"enable":false},"LeverageLimit":[{"accountID":1,"threshold":"0.5","isMain":true,"toWarn":true,"toForbid":true,"enable":false},{"accountID":2,"threshold":"0.5","isMain":true,"toWarn":true,"toForbid":true,"enable":false}],"PositionLimit":[{"accountID":1418301008,"tradetype":1,"symbol":"BTCUSDT","threshold":"0.2","isMain":true,"toWarn":true,"toForbid":true,"enable":false},{"accountID":1,"tradetype":1,"symbol":"BTCUSDT","threshold":"0.2","isMain":true,"toWarn":true,"toForbid":true,"enable":false}],"LossLimit":[{"accountID":1,"threshold":"-50","isMain":true,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":false},{"accountID":2,"threshold":"-50","isMain":true,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":true}],"WorthLimit":[{"accountID":1,"threshold":"1.1","isMain":true,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":false},{"accountID":2,"threshold":"1.1","isMain":true,"toWarn":true,"toForbid":true,"toCloseAll":true,"enable":false}]}]}


# 触发更新风控配置 updateRiskConfig 
curl -X POST -d '{"method":"updateRiskConfig","params":["/root/FIL/fil/risk.json"]}' http://127.0.0.1:8889/strategy
{"method":"updateRiskConfig","result":"(1,sync update runing.)"}

# 查询风控当前计算状态 queryCurrentRiskResult 定时风控
curl -X POST -d '{"method":"queryCurrentRiskResult","params":["testrisk1"]}' http://127.0.0.1:8889/strategy
{"method":"queryCurrentRiskResult","result":[{"Main":{"mainID":1,"updatetime":1675344927,"isIPLimit":false,"isAccountLimit":false,"isUFRLimit":false,"isGTCLimit":false,"isDRLimit":false,"isLeverageLimit":true,"isPositionLimit":false,"isLossLimit":false,"isWorthLimit":false},"Sub":{"subID":2,"updatetime":1675344807,"isIPLimit":false,"isAccountLimit":false,"isUFRLimit":false,"isGTCLimit":false,"isDRLimit":false,"isLeverageLimit":false,"isPositionLimit":false,"isLossLimit":true,"isWorthLimit":false}}]}

curl -X POST -d '{"method":"queryCurrentRiskResult","params":["similarity"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryCurrentRiskResult","params":["testorder1"]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"queryCurrentRiskResult","params":["testorder2"]}' http://127.0.0.1:8889/strategy

# 取消订阅定时器 cancelSubTimer 
curl -X POST -d '{"method":"cancelSubTimer","params":["testrisk1",60000]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"cancelSubTimer","params":["testorder1",60000]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"cancelSubTimer","params":["testorder2",60000]}' http://127.0.0.1:8889/strategy

# 全部撤单 deleteAllOrder 
curl -X POST -d '{"method":"deleteAllOrder","params":["testrisk1" ]}' http://127.0.0.1:8889/strategy

# 全部平仓 closeAllPosition 
curl -X POST -d '{"method":"closeAllPosition","params":["testrisk1" ]}' http://127.0.0.1:8889/strategy

# 市价委托 insertMarketUOrder
curl -X POST -d '{"method":"insertMarketUOrder","params":["testrisk1",0, {"symbol":"BTCUSDT","quantity":"0.001","side":"SELL"}, 2]}' http://127.0.0.1:8889/strategy
curl -X POST -d '{"method":"insertMarketUOrder","params":["testorder1",0, {"symbol":"BTCUSDT","quantity":"0.001","side":"SELL"}, 2]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"insertMarketUOrder","params":["test-strategy", 0, {"symbol":"OPUSDT","quantity":"100","side":"SELL"},1]}' http://127.0.0.1:8889/strategy


#########################################

接口更新：
updateRiskConfig 触发更新风控配置
curl -X POST -d '{"method":"updateRiskConfig","params":["/home/chain/program/FIL/build/risk.json","USDT","BTCUSD"]}' http://127.0.0.1:8889/strategy

queryRiskConfig 查询风控配置
curl -X POST -d '{"method":"queryRiskConfig","params":[]}' http://127.0.0.1:8889/strategy

queryCurrentRiskResult 查询风控当前计算状态
curl -X POST -d '{"method":"queryCurrentRiskResult","params":["testkline1"]}' http://127.0.0.1:8889/strategy

启动方式更新参考：
./programs/FILmain/FIL run -c ./config.json -k ./key.json
./programs/FILmain/FIL run -c ./config.json -k ./key.json -r ./risk.json
./programs/FILmain/FIL run -c ./config.json -r ./risk.json

功能更新：
1.添加风控模块
2.修复部分bug


配置更新：
添加风控配置risk.json

risk.json 字段解释：
风控计算周期（单位s）       RiskInterval :60
风控计算的订单时间（10min） OrderTimePeriod :600
风控计算的订单权重（1）     Orderweight :1
风控计算的请求权重（1）     Requestweight :1
风控的UFR常量（10000）     UFRnum :10000
风控的GTC常量（5000）      GTCnum :5000
风控的DR常量（10000）      DRnum  :10000

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


#########################################

pylib更新v5：
添加风控RiskLimit的推送及其handleRiskLimit处理函数

功能更新：
1.添加风控的RiskLimit的策略推送
2.添加appkey的加解密, appkey入库, 及其接口

接口更新：

insertAppkey 添加appkey
curl -X POST -d '{"method":"insertAppkey","params":[1,0,1,"pubkey","prikey","key desc"]}' http://127.0.0.1:8889/strategy

其中1,0,1 表示 keyid, gatewaytype中的binance, tradetype中的usdt合约类型

updateAppkey 更新appkey
curl -X POST -d '{"method":"updateAppkey","params":[1,0,1,"pubkey","prikey","key desc"]}' http://127.0.0.1:8889/strategy

queryAppkeys 查询appkey
curl -X POST -d '{"method":"queryAppkeys","params":[]}' http://127.0.0.1:8889/strategy


#########################################

kline独立行情 接口说明说明v6：

1.策略告知后台推送端口 hello （参考pyclient库相关函数）
curl -X POST -d '{"method":"hello","params":["testrisk1","risk1","subrisk1","127.0.0.1",39291]}' http://127.0.0.1:8886/strategy

2.kline订阅  subKline （参考pyclient库相关函数）
3.kline取消订阅 cancelSubKline 
4.修改推送端口 changepush 
curl -X POST -d '{"method":"changepush","params":["testrisk1","127.0.0.1",9091]}' http://127.0.0.1:8886/strategy

5.查询策略所有kline订阅 queryStrategySubKlines
curl -X POST -d '{"method":"queryStrategySubKlines","params":["testrisk1"]}' http://127.0.0.1:8886/strategy

6.检查单个symbol的kline error
curl -X POST -d '{"method":"checkAllKlines","params":["BTCUSDT"]}' http://127.0.0.1:8886/strategy
{"method":"checkAllKlines","error":{"code":32605,"message":"Wrong params length [1 != 0]"}}

7.检查所有的kline
curl -X POST -d '{"method":"checkAllKlines","params":[]}' http://127.0.0.1:8886/strategy
{"method":"checkAllKlines","error":{"code":32605,"message":"Wrong params length [1 != 0]"}}

独立行情更新到了 /root/FIL/kline/  目录

配置文件中的  
mysql是原系统数据库，
mysqlkline是独立行情数据库的配置。  
binanceSymbols是需要初始化的交易对。
checkinterval是检查行情数据的间隔（单位s），
checkperiod是检查的周期（单位s）

启动方式  /Kline run -c ./kline.json

cd /root/FIL/kline
nohup ./Kline run -c ./kline.json  >> /root/FIL/logs/screenlog_Kline_bash_0.log 2>&1 & 

ps aux | grep Kline | grep kline | grep -v grep | awk '{print $2}'| xargs kill -9 



#########################################

更新内容：20230206 v5.4
1.risk配置更新修复
2.开仓手续费修复 v
3.减仓的杠杆率风控修复
4.风控的净值计算修改
5.私钥加解密换库（合并的上次版本更新）v
sudo apt-get install libcrypto++-dev libcrypto++-doc libcrypto++-utils

待定：
1.定时器推送问题还未查看

更新内容：20230208A v5.5
1.UFR问题
2.key.json问题
待定：
1.boost::variant 问题，我本地测试多次未复现，看有没有必定触发的测试方式


更新内容：20230221A v5.6
1.修复漏单的bug
2.修复风控净值的杠杆计算问题
3.修复风控配置的账户id类型问题
4.优化了平仓接口的余额检查
5.优化了母账户创建的自动订阅 v
6.修复了一个不常用接口的参数bug


本次更新：20230228A v5.7
1.添加母账户划转限定
2.修复风控的自动平仓的超单
说明：
alter table mainaccount add closelock INT not null default 0;
alter table subaccount add closelock INT not null default 0;
账户表添加字段
配置文件config添加closelockcheck_interval  平仓锁定检查间隔，单位s
新版本已更新到服务器目录，本次需要执行数据库字段更新指令后重启

alter table FIL_risk3.mainaccount add closelock INT not null default 0;
-- alter table FIL_risk3.subaccount add closelock INT not null default 0;
commit;


功能新增：20230301A v5.8

添加接口：
fixUTrade 人工U合约成交，用于资金和仓位的人工调整
curl -X POST -d 
'{
    "method":"fixUTrade",
    "params":[
        "mainname-binance",
        "subaccount-binance",
        "test-strategy",
        {"symbol":"BTCUSDT",
        "quantity":"0.002",
        "commission":"0",
        "price":"25019",
        "commissionasset":"USDT",
        "positionside":"LONG",
        "orderside":"SELL"
        }
    ]
}' http://127.0.0.1:8889/strategy


接口说明：

策略人工调整：
1.手续费 commission 用于资金调整.  (commission为正是减资金，为负是加资金)
2.成交数量 quantity 用于仓位调整
3.新开仓和反向开仓price需要填真实值，其他情况price可以不填或填0

子账户人工调整：
1.test-strategy处的策略名置为空字符串""
2.手续费 commission 用于资金调整.  (commission为正是减资金，为负是加资金)

curl -X POST -d '{ "method":"fixUTrade", "params":[ "mainname-binance", "subaccount-binance", "test-strategy", {"symbol":"BTCUSDT", "quantity":"0.002", "commission":"0", "price":"25019", "commissionasset":"USDT", "positionside":"LONG", "orderside":"SELL" } ] }' http://127.0.0.1:8889/strategy


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

日志：
成交推送日志 fuserdata order update  
订阅错误 fuserdata account update 
查漏补推日志 onNewUOrderTrade called.
下单日志 OrderAlgoriyhmManager::insertMarketUOrder

find . -type f -iname "*.log" | xargs grep -inr "onNewUOrderTrade called" | grep -v grep 
find . -type f -iname "*.log" | xargs grep -inr "fuserdata" | grep -v grep 


功能新增：20230316A v5.9

1.pyclient的独立行情改造，用上面的代码库，用法见示例
2.子账户的资金费率计算功能已添加，后台主程已更新在服务器目录，下次重启启用

资金变动日志为数据库的 profitlog表
type类型
    ProfitType_inout = 0,         出入金
    ProfitType_trade,             交易
    ProfitType_commission,        手续费
    ProfitType_fundingrate,       资金费
    ProfitType_fixtrade,          人工校准

python示例：
cli = FILClient(MyFILHandler("test-strategy"),"http://127.0.0.1:8889/strategy",60,"127.0.0.1",9091,"http://127.0.0.1:8886/strategy") #8889为主程 8886为独立行情(最后的字符串可以不填)
cli.start()
cli.hello("mainname-binance", "subaccount-binance","127.0.0.1",9091) #通知主程
cli.hello2("mainname-binance", "subaccount-binance","127.0.0.1",9091) #通知独立行情
cli.subKline("binance", "usdt", "ETHUSDT", "1m")


