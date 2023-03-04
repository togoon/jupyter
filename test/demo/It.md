
------------------------------

# FILE *fopen(const char *filename, const char *mode)

mode 有下列几种形态字符串:
r 以只读方式打开文件，该文件必须存在。
r+ 以可读写方式打开文件，该文件必须存在。
rb+ 读写打开一个二进制文件，允许读数据。
rw+ 读写打开一个文本文件，允许读和写。
w 打开只写文件，若文件存在则文件长度清为0，即该文件内容会消失。若文件不存在则建立该文件。
w+ 打开可读写文件，若文件存在则文件长度清为零，即该文件内容会消失。若文件不存在则建立该文件。
a 以附加的方式打开只写文件。若文件不存在，则会建立该文件，如果文件存在，写入的数据会被加到文件尾，即文件原先的内容会被保留。（EOF符保留）
a+ 以附加方式打开可读写的文件。若文件不存在，则会建立该文件，如果文件存在，写入的数据会被加到文件尾后，即文件原先的内容会被保留。 （原来的EOF符不保留）
wb 只写打开或新建一个二进制文件；只允许写数据。
wb+ 读写打开或建立一个二进制文件，允许读和写。
ab+ 读写打开一个二进制文件，允许读或在文件末追加数据。
at+ 打开一个叫string的文件，a表示append,就是说写入处理的时候是接着原来文件已有内容写入，不是从头写入覆盖掉，t表示打开文件的类型是文本文件，+号表示对文件既可以读也可以写。
上述的形态字符串都可以再加一个b字符，如rb、w+b或ab+等组合，加入b 字符用来告诉函数库以二进制模式打开文件。如果不加b，表示默认加了t，即rt,wt,其中t表示以文本模式打开文件。由fopen()所建立的新文件会具有S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH(0666)权限，此文件权限也会参考umask 值。

有些C编译系统可能不完全提供所有这些功能，有的C版本不用"r+","w+","a+",而用"rw","wr","ar"等，读者注意所用系统的规定。

二进制和文本模式的区别

1.在windows系统中，文本模式下，文件以"\r\n"代表换行。若以文本模式打开文件，并用fputs等函数写入换行符"\n"时，函数会自动在"\n"前面加上"\r"。即实际写入文件的是"\r\n" 。

2.在类Unix/Linux系统中文本模式下，文件以"\n"代表换行。所以Linux系统中在文本模式和二进制模式下并无区别。




------------------------------

char          buf[sTEXT50_LEN], custId[sTEXT50_LEN];

x86_64-linux-gnu/crt1.o: In function `_start’
编译链接动态库时需要加-shared。
同时记录多个.a和.so链接成.so，.a的编译需要增加-fPIC。

出现以上错误是因为你改变了 gcc 或者是 arm-gcc-xxx的 sysroot，gcc -v 看一下，把默认sysroot下面的库拷贝到你指定的sysroot即可。


------------------------------
convertdb –U trainer –P trainerpwd –F metadata.sql.applychanges

convertdb –F metadata.sql.changes
convertdb –F metadata.sql.applychanges

genmeta 


sGetListItem( varlist, index) 

		sENTITY *Entity;
		Entity = sGetEntityByName(“ENV”); 
		sEntityFree( Entity, (void *) &Env, sYES ); 

	sENV *env; 
	sENTITY *entity = sGetEntityByName(“ENV”); 
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




------------------------------



交易风控规则：
黑/白(灰)名单：不允许/仅限于
单笔交易限制：最大/小委托金额
持仓限制：持仓品种，持仓最大金额，持仓周期
时间限制：在规定周期内禁止交易

合规部分：报单频率，报撤比，


风控中心模块是所有策略进行下单的风险控制的核心模块。该模块会对所有策略下单进行风险管控。风险管控主要包括两种，一种是依据交易所的下单管控规则，限制系统平台下所有的下单频率，具体主要指全局ip下单请求限制，单账户下单请求限制，查询请求权重限制，自成交检查，重复撤单检查等等。第二种为系统平台制定的风险管控，防止策略程序因为bug或参数不正确的原因导致异常下单，造成巨额损失。具体主要是单笔下单量，单笔下单金额，单账户的持仓量。

20220510新增 风控指标（以下仅为，全部风控指标后续会有单独附件列明）
1.合规部分: 报单频率(ip），报撤比，自成交检查，重复撤单， 
2.白名单授权（母账户500，子账号100/部分）, 单笔下单量，单笔下单金额

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


维持担保资产率 = 调整系数 / 对应倍数（此数据仅供对比参考，不作为强平依据）


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


交易白名单（母账户500，子账号100/部分，当前币安:可交易币种374，币币1438+合约218=合计1656 ）：

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

风控部分（事中）： 设置开关参数(启用/禁用)，阈值N/N1/N2 ...（参数可配置）

[合规部分(母账户/报单): N,N1,N2]
N1分钟内委托单未成交率UFR>N： (触发条件: 若N1(10)分钟内委托单≥N2(300),UFR>N (N参考值0.999)，未成交率=1-成交总量/委托总量)
N1分钟内委托单撤单率GCR>N： (触发条件: 若N1(10)分钟内委托单≥N2(150),GCR>N (N参考值0.99)，撤单率=无效撤单总笔数/GTC委托单总笔数，无效撤单：委托单类型(timeInForce)为GTC，委托单状态为已取消(CANCELED)，成交数量为0，且撤单时间与下单时间间隔小于等于2.5秒的委托单 )

[流量控制/IP全局请求频率:（按交易所统计/设置）]
每分钟的请求权重[请求权重是什么概念？]次数>N：（触发条件N上限值: 1200次）
订单每10秒钟限定次数>N：（触发条件N上限值: 50次）
24小时的订单数量限定次数>N：（触发条件N上限值: 160,000次）

子账户每分钟的行情请求次数>N：（触发条件N上限值: 1200次/子账户数）
子账户订单每10秒钟限定次数>N：（触发条件N上限值: 50次/子账户数）

交易白名单：(交易代码对在母/子白名单表中, 代码池 )

[报单]
重复委托>N：(策略/系统异常导致重复报单,2秒内连续委托单相同交易对/价格/数量/成交额/方向)
自成交控制=N：(默认不允许，0)

[仓位：触发后不新开仓，可平仓]
母账户杠杆率>N：(仓位名义价值/净资产，净资产=可用资金+保证金占用，可设置两档阈值：N1警告，N2强平)
子账户杠杆率>N：(可设置两档阈值：超过N1系统警告，超过N2则触发强平)
子账户亏损限额>N：超过限额N触发强平
子账户单币种净敞口限额>N：（同一个本位的期货，现货和永续合约美元价值之和的绝对值）
子账户净敞口限额>N：（子账户所有期货，现货和永续美元价值之和的绝对值）

[持仓：触发后不新开仓，可平仓]
母账户单品种的持仓数量>N：（按品种设置）/
母账户单品种的持仓金额>N：（按品种设置）
子账户单品种的持仓数量>N：（按品种设置）/
子账户单品种的持仓金额>N：（按品种设置）

[场景/案例1]
量控制/IP全局请求频率,每分钟的请求权重次数>N：
当N设置为1180时，当前1分钟内累计请求权重次数1181次>阈值N (1180)次，则禁用/放弃该请求。[老王再看下这部分交易所一般控制的频率是按分钟统计的吗？]

[场景/案例2]
某子账户BTCUSDT永续的持仓数量>N：当N设置为0.50500时，当前某子账户BTCUSDT永续的持仓数量0.51499><N (5000.50),如账户新开多仓 进行新开空仓，则禁用/放弃该委托(新开仓)，如账户新开空仓（或称之为平仓）则，平仓不限制。

[场景/案例3]
某子账户杠杆率>N1(警告)：当N1设置为8时，当前监控到某子账户杠杆率9>N1 (8) ，发出警告/记录日志，并通知该子账户进行处理(追加/自行平仓)。
某子账户杠杆率>N2(强平)：当N2设置为10时，当前监控到某子账户杠杆率10.1>N2 (10) ，对该子账户进行强平处理(参考4.2.5)。



------------------------------



名称/id：xxxxxx(唯一)
类别：母账户，子账户，策略，交易代码，系统，交易所，指令
列表：母账户名列表，子账户名列表，策略代码列表，交易代码列表，系统名称，交易所名列表，指令名列表
条件：表达式（逻辑）
操作：允许，警告，禁止，强平，撤单，
状态：启用/禁用
备注：规则备注

逻辑表达式：
符号: >, >=, <, <=, ==, !=, in (包含), +, -, *, /, ^, &&, ||, (, ), !(非)
(符号两端：纯数字为阈值，字母组合为字段名)

要素/字段：(字段名暂定，以实际开发为主)

[母/子账户]持仓总量，空仓持仓合约价值，多头合约价值，单位净值，资产净值，可用资金，保证金占用，合约代码（交易代码）
[母/子账户的单品种]持仓总量，持仓合约价值

[母/子账户]代码池（可以自定义N个）
[系统]未成交率，撤单率，请求频率， 
[交易要素简化一下：这里重复的比较多，比如整理成下面这个样子，你再补充一下。
持仓总量
空仓持仓合约价值
多头合约价值
单位净值
资产净值
可用资金
合约代码（交易代码）
代码池（可以自定义N个）
保证金占用

比如子账号杠杠率控制，那么可以设置：类别，子账号；条件 （多头价值+空头价值）/资产净值 > N(阈值）；操作：禁止
状态：启用；]
[系统/子账户]每分钟请求次数，每秒订单处理次数，
[母/子账户]重复委托，自成交控制，
[母/子账户]杠杆率，杠杆率阈值, 持仓数量阈值, 持仓价值阈值
[子账户]亏损额，单币种净敞口额，净敞口额，

[订单 委托请求]交易代码, 委托数量, 委托价格，委托金额，委托方向，完成度，成交数量，成交数量，成交金额
[母/子账户仓位]合约，持仓数量, 持仓方向, 平均开仓价, 累计实现损益, 标记价格, 强平价格，保证金比率，保证金，未实现赢亏，
[资产 现货/资金]币种，总额，可用资产，下单锁定，BTC估值，
[资产 合约]资产，资产名称，余额，未实现赢亏，保证金余额，可用下单余额，
[保证金]保证金比率，维持保证金，保证金余额，
[行情]交易代码，最新价，最高价，最低价，成交量，涨跌幅，振幅，24h涨幅，24最高价，24最低价，24h成交量，24成交额，
[指令 母/子账户] 每秒报单次数，每秒撤单次数，每秒查询资产次数，每秒查询仓位次数，每秒查询委托次数，每秒查询成交次数



------------------------------


策略继承Handler类，按需重写处理推送的函数
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
使用Handler初始化FILclient，并完成初始的订阅和启动
start：启动
subOrderReport：订阅订单推送
参数：交易所（"simulator"）和keyid，模拟盘keyid填0即可
返回：成功或失败
cancelSubOrderReport：取消订阅订单推送
同上
subKline：订阅k线推送
参数：交易所（"simulator"），交易类型（"usdt"），交易对，k线间隔
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

使用Handler中的client，可以主动调用量化系统接口
uklines：查询U本位K线
参数：交易所，交易对，间隔，数量限制，开始时间，结束时间
返回：result为k线数组
queryUOrder：通过订单id查询U本位订单
参数：订单id
返回：result为完整订单信息
insertMarketUOrder：下单U本位市价单
参数：交易所，keyid（模拟填0），交易对，数量，方向（buy或sell）
返回：订单id
insert_factor：记录因子
参数：记录值，时间，因子序号（可选1，2，3）
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
a)	截取前面半天的k线，去寻找历史上N天前走势最相似的一天，如果那天的后半天是上涨的，那么做多，如果是下跌的，则做空，当天日终平仓。




//////////////////////////////

1. 监控所有的交易代码？ 还指定代码？




47.241.99.13
root
Etlink@yar


------------------------------

2022-05-29 17:00:00,546 - my - DEBUG - handleKline: data=KlineType{'gatewaytype': 3, 'tradetype': 0, 'symbol': 'MKRUSDT', 'interval': 5, 'opentime': 1653811860000, 'closetime': 1653814799999, 'openprice': '1197.9', 'closeprice': '1197.4', 'highprice': '1210', 'lowprice': '1195.2', 'volume': '707.649', 'number': 4361, 'totalamount': '850897.4109', 'activevolume': '300.401', 'activeamount': '361461.3636'}


 1026  curl -X POST -d '{"method":"hello",params:["SOLUSDT_AXSUSDT","16483487768000","0.001",8081,9091]}' http://127.0.0.1:8888/strategy
 1030  curl -X POST -d '{"method":"hello","params":["SOLUSDT_AXSUSDT","16483487768000","0.001",8081^M,9091]}' http://127.0.0.1:8888/strategy
 1031  curl -X POST -d '{"method":"hello","params":["SOLUSDT_AXSUSDT","16483487768000","0.001",8081,9091]}' http://127.0.0.1:8888/strategy
 1035  curl -X POST -d '{"method":"hello","params":["SOLUSDT_AXSUSDT","0.001",8081,9091]}' http://127.0.0.1:8888/strategy
 1115  curl -X POST  -d '{"method":"hello","params":["SOLUSDT_AXSUSDT","0.001",8081,9091]}' http://127.0.0.1:8888/strategy
 1155  curl -X POST -d '{"method":"hello","params":["test_name",1644805468000,"0.001",8080,9090]}' http://127.0.0.1:8888/strategy
 1167  curl -X POST  -d '{"method":"hello","params":["${x}_${y}",0.001,$sp,$cp]}' http://127.0.0.1:8888/strategy
 1168  curl -X POST  -d '{"method":"hello","params":["testa",0.001,8000,9000]}' http://127.0.0.1:8888/strategy
 1169  curl -X POST  -d '{"method":"hello","params":["testa","0.001",8000,9000]}' http://127.0.0.1:8888/strategy
 1384  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",1651564000000,1651565016000,100]}' http://127.0.0.1:8888/strategy
 1385  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651565016000,100]}' http://127.0.0.1:8888/strategy
 1546  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651569016000,100]}' http://127.0.0.1:8888/strategy
 1547  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579016000,100]7' http://127.0.0.1:8888/strategy
 1548  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579016000,100]' http://127.0.0.1:8888/strategy
 1549  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651569016000,100]7' http://127.0.0.1:8888/strategy
 1550  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579016000,100]' http://127.0.0.1:8888/strategy
 1552  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579016000,100]' http://127.0.0.1:8888/strategy
 1553  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579016000,100]}' http://127.0.0.1:8888/strategy
 1554  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,165157901601651560000000,1651570000000,100]}' http://127.0.0.1:8888/strategy
 1556  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUS560000000,1651570000000,100]}' http://127.0.0.1:8888/strategy
 1558  curl -X POST -d '{"method":"queryWorth","params":["SOLUSDT_AXSUSDT",0,165157901601651560000000,1651570000000,100]}' http://127.0.0.1:8888/strategy
 1559  curl -X POST -d '{"method":"queryWorth","params":["SOLUSDT_AXSUSDT",165157901601651560000000,1651570000000,100]}' http://127.0.0.1:
 1560  curl -X POST -d '{"method":"queryWorth","params":["SOLUSDT_AXSUSDT",165157901601651560000000,1651570000000,100]}' http://127.0.0.1:8888/strategy
 1561  curl -X POST -d '{"method":"queryWorth","params":["SOLUSDT_AXSUSDT",1651560000000,1651570000000,100]}' http://127.0.0.1:8888/strategy
 1623  curl -X POST -d '{"method":"queryWorth","params":["AXSUSDT_SOLUSDT",0,1651579165000,100]}' http://127.0.0.1:8888/strategy
 1797  curl -X POST -d '{"method":"queryFactor1","params":["IOSTUSDT_ICXUSDT",0,1652268960001]}' http://127.0.0.1:8888/strategy
 1798  curl -X POST -d '{"method":"queryFactor1","params":["IOSTUSDT_ICXUSDT",0,0]}' http://127.0.0.1:8888/strategy
 1800  curl -X POST -d '{"method":"queryFactor1","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
 1801  curl -X POST -d '{"method":"queryFactor3","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
 1802  curl -X POST -d '{"method":"queryFactor1","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strateg2
 1803  curl -X POST -d '{"method":"queryFactor2","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/stratege
 1804  curl -X POST -d '{"method":"queryFactor2","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
 1806  curl -X POST -d '{"method":"queryFactor2","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
 1866  curl -X POST -d '{"method":"queryFactor1","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
 1867  curl -X POST -d '{"method":"queryFactor2","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy
 1868  curl -X POST -d '{"method":"queryFactor3","params":["SOLUSDT_AXSUSDT",0,0]}' http://127.0.0.1:8888/strategy




------------------------------

K线stream逐秒推送所请求的K线种类(最新一根K线)的更新。推送间隔250毫秒(如有刷新)

订阅Kline需要提供间隔参数，最短为分钟线，最长为月线。支持以下间隔:

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



------------------------------

获取交易规则和交易对
响应:

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

GET /fapi/v1/exchangeInfo

获取交易规则和交易对

权重: 1

参数: NONE


------------------------------

K线数据
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

连续合约K线数据
响应:

[
  [
    1607444700000,      // 开盘时间
    "18879.99",         // 开盘价
    "18900.00",         // 最高价
    "18878.98",         // 最低价
    "18896.13",         // 收盘价(当前K线未结束的即为最新价)
    "492.363",          // 成交量
    1607444759999,      // 收盘时间
    "9302145.66080",    // 成交额
    1874,               // 成交笔数
    "385.983",          // 主动买入成交量
    "7292402.33267",    // 主动买入成交额
    "0"                 // 请忽略该参数
  ]
]
GET /fapi/v1/continuousKlines 每根K线的开盘时间可视为唯一ID

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

------------------------------



------------------------------


