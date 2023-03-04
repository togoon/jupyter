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

DELETE FROM balance WHERE asset='BNB' AND country='USA'
SELECT * FROM balance LIMIT 100;
DELETE FROM balance WHERE asset='BNB' ;

SELECT selfid, symbol, side, type, clientorderid, price, quantity, status, from_unixtime(floor(createtime / 1000)) as orderdatetime from orders where selfid >= 500

select id, mainID, subID, strategyID, symbol, tradeid, clientorderid, price,quantity, commission, commissionasset, tradetime, from_unixtime(floor(tradetime / 1000)) as tradedatetime, tradetype, handletime, gatetype from trades where strategyID = 2

alter table contractAsset modify syslockamount VARCHAR(100);

ALTER TABLE FIL_testfil.contractAsset ADD syslockamount varchar(100) NULL;

ALTER TABLE FIL_testfil.contractAsset ADD syslockamount varchar(100) NOT NULL;

CREATE DATABASE `FIL_testfil` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

alter table orders add orderforce VARCHAR(100) not null default 'GTC';

ALTER TABLE FIL_testfil.orders ADD orderforce varchar(100) DEFAULT 'GTC' NOT NULL;

SELECT selfid, symbol, side, type, clientorderid, price, quantity, status, from_unixtime(floor(createtime / 1000)) as orderdatetime from orders where selfid >= 500


SELECT * FROM orders LIMIT 100;

SELECT selfid, symbol, side, type, clientorderid, price, quantity, status, from_unixtime(floor(createtime / 1000)) as orderdatetime from FIL_testfil.orders where selfid >= 500

select id, mainID, subID, strategyID, symbol, tradeid, clientorderid, price, quantity, commission, commissionasset, tradetime, from_unixtime(floor(tradetime / 1000)) as tradedatetime, tradetype, handletime, gatetype from Trace_testtrace.trades where strategyID = 2

select id, mainID, subID, strategyID, symbol, price, quantity, from_unixtime(floor(tradetime / 1000)) as tradedatetime, tradetype from Trace_testtrace.trades where strategyID = 2








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
