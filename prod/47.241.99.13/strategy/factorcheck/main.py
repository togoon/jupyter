import time
import getopt
import sys
import math
import datetime
# from matplotlib.pyplot import xlabel
# from PyEMD import EMD, Visualisation

# from numpy import corrcoef

import pandas as pd
import numpy as np

from FIL_lib.my_logger import make_logger, logging
from FIL_lib.client import FILClient, Handler
from FIL_lib.core_types import *



# =============== 配置策略参数

gateway ="simulator"
name = "factorcheck"
symbol = "BTCUSDT"
interval = "5m" #period #1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h, 8h, 12h, 1d, 3d, 1w, 1M
intervalCoef = {'m':60, 'h':60*60, 'd': 60*60*24, 'w':60*60*24*7, 'M':60*60*24*30}
intervalSec = int(interval[0:-1]) * intervalCoef[interval[-1] ]
tradeType = "usdt"

total = 1000 #
totalAdjRate = -1e-3
histDays = 2  # 30 10 84 120 60 
limit = 998 # 1500  499 998
wid = 40  #  42  108  83
thd = 0.6  # 阈值0
wid2 = 50
divisor = 6
remainder = 5



ukdf = pd.DataFrame()
df_panel = pd.DataFrame()

version = '2.0.6'

print('\n--init--: ', f'{version=}, {gateway=}, {name=}, {symbol=}, {interval=}, {intervalCoef=}, {intervalSec=}, {tradeType=}, {total=}, {histDays=}, {wid=},{limit=}', '\n')

# ===============

curDate = time.strftime("%Y%m%d")
# logger = make_logger(name, log_level=logging.DEBUG, log_file= name + "_"+ str(curDate)+".log")
logger = ''


class StrategyHandler(Handler):
    def __init__(self, name, symbol, total):
        # super().__init__(name)
        self.name = name
        self.total = total
        self.symbol = symbol

        self.flagDict = {'side':"", 'posBuy':0, 'posSell':0,'isNewDay':False, 'isOpenBuy':False, 'isOpenSell':False, 'isCloseBuy':False, 'isCloseSell':False, 'isOpen':False, 'isClose':False,'isTrig':False }

        self.count = 1
        self.curDate = ''
        self.tradeDate = self.openTime = self.closeTime = self.closeSec = self.openSec = self.open = self.close = ''
        self.factor = ''
        self.factorCnt = 0

    def handleKline(self, data:KlineType):
        # logger.debug(f"handleKline: data={data}")

        global ukdf
        global intervalSec
        global interval
        global version
        global curDate
        global logger
        global wid
        global wid2
        global histDays
        global df_panel
        global thd
        global divisor
        global remainder

        if data.symbol != self.symbol:
            return

        self.tradeDate = time.strftime("%Y%m%d", time.localtime(data.closetime/1000) )
        self.openTime = time.strftime("%H%M%S", time.localtime(data.opentime/1000) )
        self.closeTime = time.strftime("%H%M%S", time.localtime(data.closetime/1000) )
        self.closeSec = data.closetime//1000
        self.open = float(data.openprice)
        self.close = float(data.closeprice)
        self.high = float(data.highprice)
        self.low = float(data.lowprice)

        self.openSec = data.opentime//1000

        print('\n--handleKline--: ', f'{version=}, {self.name=}, {self.symbol=}, {interval=}, {intervalSec=}, {wid=}, {wid2=}, {thd=}, {self.factorCnt=}, {self.factor=}, {self.count=}', '\n')
        print(f'{self.closeSec=}, {self.tradeDate=}, {self.openTime=}, {self.closeTime=}, {self.symbol=}, {self.open=}, {self.close=}, {self.high=}, {self.low=} ' )

        self.count = self.count +1
        if self.curDate != self.tradeDate:
            self.curDate = self.tradeDate
            self.flagDict['isNewDay'] = True

            # self.factorCnt = 0

            self.CleanOverukdf(self.closeSec)

            # curDate = time.strftime("%Y%m%d")
            # logger = make_logger(name, log_level=logging.DEBUG, log_file= name +"_" + str(curDate)+".log")

        if len(ukdf) != 0 and self.closeSec == int(ukdf.closeSec.iloc[-1]):
            ukdf.iloc[-1, ukdf.columns.get_loc('close')] = self.close

        if len(ukdf) != 0 and self.closeSec >= int(ukdf.closeSec.iloc[-1]) + intervalSec and self.openSec < int(ukdf.closeSec.iloc[-1]) + 60:            

            closePct = round(self.close/ukdf['close'].iloc[-1] -1 , 6)
            ukdf.loc[len(ukdf.index)] = [self.tradeDate,self.openTime,self.closeTime,self.closeSec,self.open,self.close,self.high,self.low,closePct,len(ukdf.index),len(ukdf.index)% 6 ]
            # ukdf.reset_index(drop=True,inplace=True)

            logger.info(f'{self.closeSec=}, {self.tradeDate=}, {self.openTime=}, {self.closeTime=},{self.symbol=},{self.open=}, {self.close=}, {self.high=}, {self.low=}   ' )
            logger.info(f"ukdf.iloc[-5:,:] :\n{ukdf.iloc[-5:,:]}" )
            logger.info(f"{self.flagDict=}")

            if ukdf['idx'].iloc[-1] == remainder: #5

                df_panel = ukdf[ukdf['idx']== remainder ].copy() #5
                df_panel.dropna(how='any',inplace=True)
                df_panel.reset_index(drop=True,inplace=True)

                # wid_, thd, threshold, direction_ = 40, 50, 0.6, 1
                part1 = (df_panel['high'].rolling(window=wid, min_periods=wid).max() - df_panel['close']) / \
                        (df_panel['high'].rolling(window=wid, min_periods=wid).max() - df_panel['low'].rolling(window=wid, min_periods=wid).min())

                df_panel['factor'] = part1.ewm(adjust=False, alpha=float(1) / wid, min_periods=0, ignore_na=False).mean()
                df_panel['factor'] = df_panel['factor'].astype(float)
                df_panel.dropna(how='any', inplace=True)
                df_panel.reset_index(drop=True, inplace=True)

                logger.info(f'df_panel.iloc[-5:,:] :\n{df_panel.iloc[-5:,:]}')

                self.factor = float(df_panel['factor'].iloc[-1])
                self.factorCnt = self.factorCnt + 1

                if  self.factor > float(thd) :  #0.6

                    self.factorCnt = 0

                    if self.flagDict['isOpen'] == False:  
                        self.queryContractAssets()
                        self.openBuy(self.close)

                    #     self.openSell(self.close)

                    if self.flagDict['isOpen']:
                        self.flagDict['isTrig'] = True
                        self.flagDict['isClose'] = False
                        self.insertFactor()

                elif  self.flagDict['isOpen'] and (self.factorCnt == wid2 -1 or (df_panel[df_panel['factor'] > float(thd) ].index.tolist() and (len(df_panel.index)-1 - df_panel[df_panel['factor'] > float(thd) ].index.tolist()[-1] == wid2 -1) ) ): # or int(self.closeTime) >= 235559 

                    self.factorCnt = 0

                    if self.flagDict['isOpen']:
                        self.flagDict['isOpen'] = False
                        self.flagDict['isClose'] = True
                        self.flagDict['isTrig'] = False

                        if self.flagDict['isOpenBuy']:
                            self.flagDict['isOpenBuy'] = False
                            self.flagDict['isCloseBuy'] = True
                            self.closeBuy()
                            self.insertFactor()

                        elif self.flagDict['isOpenSell']:
                            self.flagDict['isOpenSell'] = False
                            self.flagDict['isCloseSell'] = True
                            self.closeSell()
                            self.insertFactor()  
                        
                        else:
                            # self.clearance()
                            self.client.closeAllPosition()
                            self.insertFactor()

            # elif int(self.closeTime) >= 235559:
                # self.clearance()
                # #self.client.closeAllPosition()
                # self.insertFactor()

    def insertFactor(self):
        curDateTime = int(time.strftime("%m%d%H%M")) #"%Y%m%d%H%M%S" %y%m%d%H%M

        self.client.insertFactor(curDateTime, f"name:{self.name}, symbol:{self.symbol}, tradeDate:{self.tradeDate}, closeTime:{self.closeTime}, close:{self.close}, total:{self.total}, factor:{self.factor}, factorCnt:{self.factorCnt}, side:{self.flagDict['side']} " )

        logger.info(f"curDateTime:{curDateTime}, name:{self.name}, symbol:{self.symbol}, tradeDate:{self.tradeDate}, closeTime:{self.closeTime}, close:{self.close}, total:{self.total}, factor:{self.factor}, factorCnt:{self.factorCnt}, side:{self.flagDict['side']} " )

    def queryContractAssets(self):

        global tradeType
        assets = self.client.queryContractAssets(tradeType)
        logger.info(f"queryContractAssets: {assets=}")

        if assets.result:
            for item in assets.result:
                if item.asset.upper() == tradeType.upper() and float(item.free) > 0:
                    self.total = float(item.free)
                else:
                    self.total = 0

    def queryPositions(self):

        positions = self.client.queryPositions(self.symbol)
        print((f"queryPositions: {self.symbol=}, {positions=}"))
        if positions.result:
            for posi in positions.result:
                self.flagDict['isOpen'] = True


    def openBuy(self, close):
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenBuy'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "buy"

        quantity = float(self.total*(1 + totalAdjRate) )/float(close)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        ret = self.client.insertMarketUOrder("simulator", self.symbol, float(qtyStr), "buy")

        logger.info(f"{self.flagDict=}")
        logger.info(f'ret = self.client.insertMarketUOrder("simulator", "{self.symbol}", {qtyStr}, "buy"), {ret=}')

    def openSell(self, close):
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenSell'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "sell"

        quantity = float(self.total*(1 + totalAdjRate) )/float(close)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        ret = self.client.insertMarketUOrder("simulator",  self.symbol, float(qtyStr), "sell")

        logger.info(f'ret = self.client.insertMarketUOrder("simulator", "{self.symbol}", {qtyStr}, "sell"), {ret=}')

    def closeBuy(self):
        self.flagDict['isOpen'] = False
        self.flagDict['isClose'] = True
        self.flagDict['isOpenBuy'] = False
        self.flagDict['isCloseBuy'] = True
        self.flagDict['side'] = "sell"

        positions = self.client.queryPositions(self.symbol, 'long')
        print((f"closeBuy: {self.symbol=}, {positions=}"))
        if positions.result:

            for posi in positions.result:

                side = "buy" if posi.positionside == 'short' else "sell"

                ret = self.client.insertMarketUOrder("simulator",  posi.symbol, posi.positionAmount, side)

                logger.info(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder("simulator",  {posi.symbol}, {posi.positionAmount}, {side} ), {ret=}')

    def closeSell(self):
        self.flagDict['isOpen'] = False
        self.flagDict['isClose'] = True
        self.flagDict['isOpenSell'] = False
        self.flagDict['isCloseBuy'] = True
        self.flagDict['side'] = "buy"

        positions = self.client.queryPositions(self.symbol, 'short')
        print((f"closeSell: {self.symbol=}, {positions=}"))
        if positions.result:

            for posi in positions.result:

                side = "buy" if posi.positionside == 'short' else "sell"

                ret = self.client.insertMarketUOrder("simulator",  posi.symbol, posi.positionAmount, side)

                logger.info(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder("simulator",  {posi.symbol}, {posi.positionAmount}, {side} ), {ret=}')

    def clearance(self):

        self.flagDict['isOpen'] = False
        self.flagDict['isClose'] = True

        positions = self.client.queryPositions(self.symbol)
        print((f"clearance: {self.symbol=}, {positions=}"))
        if positions.result:

            for posi in positions.result:

                side = "buy" if posi.positionside == 'short' else "sell"

                ret = self.client.insertMarketUOrder("simulator", posi.symbol, posi.positionAmount, side)

                logger.info(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder("simulator",  {posi.symbol}, {posi.positionAmount}, {side} ), {ret=}')

    def CleanOverukdf(self, closeSec:int):

        global ukdf
        global histDays

        overDate = time.strftime("%Y%m%d", time.localtime(closeSec-60*60*24*histDays ) )
        ukdf.drop(ukdf.index[(ukdf['tradeDate'] < overDate)], inplace=True)
        ukdf.reset_index(drop=True, inplace=True)

        print(f'\n--ukdf-hist--: {overDate=} \n', ukdf.iloc[0:5,:] ,'\n' , ukdf.iloc[-5:,:],'\n' )

    def handleOrderNew(self, data: OrderType): #处理新订单
        logger.info(f"handleOrderNew: {data=}")

    def handleOrderFilled(self, data: OrderType):  #处理订单完成
        logger.info(f"handleOrderFilled: {data=}")

        if data.filltrades:
            self.total = float(data.filltrades[0].quantity)*float(data.filltrades[0].price) -float(data.filltrades[0].commission) 

    def handleOrderCanceled(self, data: OrderType):  #处理订单取消
        logger.error(f"handleOrderCanceled: {data=}")

    def handleOrderRejected(self, data: OrderType):  #处理订单取消拒绝
        logger.error(f"handleOrderRejected: {data=}")

    def handleOrderExpired(self, data: OrderType):  #处理订单被撤销
        logger.error(f"handleOrderExpired: {data=}")

    def handleError(self, data): #处理错误
        logger.error(f"error: {data=}")

    def handleTick(self, data:SubTickType):
        logger.info(f"tick opentime:{data.tick.opentime // 1000} closeprice:{data.tick.closeprice}")



def run(argv):

    global ukdf
    global interval
    global intervalSec
    global limit
    global histDays
    global total
    global curDate
    global name
    global logger
    global wid
    global wid2
    global thd
    global divisor
    global remainder
    global symbol
    global df_panel


    input_pro = '-n <name> -s <serverPort> -c <clientPort> -X <symbol> -p <period> -w <wid> -I <wid2> -d <day>  -T <thd> -t <total>'
    try:
        # 优先级i>d>args
        opts, args = getopt.getopt(argv, "n:s:c:X:p:w:I:d:T:t:",
                        ["name",'serverPort','clientPort',"symbol","period","wid","wid2","day","thd","total"])
        print(f'{opts=}')
    except getopt.GetoptError:
        print('--input_pro--: ', input_pro)
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-t", '--total'):
            total = float(arg)
        elif opt in ("-n", '--name'):
            name = arg
        elif opt in ("-X", '--symbol'):
            symbol = arg
        elif opt in ("-p", '--period'):
            interval = arg
            intervalSec = int(interval[0:-1]) * intervalCoef[interval[-1] ]
        elif opt in ("-w", '--wid'):
            wid = int(arg)
        elif opt in ("-I", '--wid2'):
            wid2 = int(arg)
        elif opt in ("-d", '--day'):
            histDays = int(arg)
        elif opt in ("-T", '--thd'):
            thd = float(arg)

            
        elif opt in ("-s", '--serverPort'):
            serverPort = int(arg)
        elif opt in ("-c", '--clientPort'):
            clientPort = int(arg)

    handler = StrategyHandler(name, symbol, total)
    cli = FILClient(handler, timeout=(3, 5),server_url="http://127.0.0.1:%d/strategy" % serverPort, listen_port=clientPort)
    cli.start()

    curDate = time.strftime("%Y%m%d")
    logger = make_logger(name, log_level=logging.DEBUG, log_file= name +"_" + str(curDate)+".log")

    logger.info(f'--cli.start()--{version}--{curDate}--')

    curSec = int(time.time())
    histSec = int(time.mktime(time.strptime(time.strftime("%Y%m%d", time.localtime(time.time()-60*60*24*histDays ) ), '%Y%m%d')))

    interval_pre = interval
    if interval_pre == '10m':
        interval = '5m'
        intervalSec = intervalSec//2

    totalCount = math.ceil( (curSec - histSec )/intervalSec )
    logger.info(f'{interval=}, {histSec=}, {curSec=}, {intervalSec=}, {limit=}, {intervalSec*limit=}, {totalCount=}, {histDays=}')

    ukdfHist = pd.DataFrame(columns=['tradeDate', 'openTime', 'closeTime', 'closeSec', 'open', 'close',  'high',  'low', ])

    count = 1
    for Sec in range(histSec, curSec, intervalSec*limit):

        print(f'{count=}:', "cli.uklines('binance',", f'{symbol=}', ',', f'{interval=}', ',', f'{limit=}', ',', f'{Sec*1000+999=}', ', end=', f'{(Sec+intervalSec*limit-1)*1000+999}' , ' )')

        ukRet = cli.uklines('binance', symbol=symbol, interval=interval, limit=limit, start=Sec*1000+999, end=(Sec+intervalSec*limit-1)*1000+999 )

        # print('\n--ukRet--: ', ukRet)

        kdf = pd.DataFrame([{'tradeDate': time.strftime("%Y%m%d", time.localtime(rs.closetime/1000) ), 'openTime': time.strftime("%H%M%S", time.localtime(rs.opentime/1000) ), 'closeTime': time.strftime("%H%M%S", time.localtime(rs.closetime/1000) ), 'closeSec': rs.closetime//1000, 'open': rs.openprice, 'close': rs.closeprice, 'high': rs.highprice, 'low': rs.lowprice} for rs in ukRet.result])

        # ukdfHist.append(kdf)
        ukdfHist = pd.concat([ukdfHist,kdf],ignore_index=True)
        del kdf

        count += 1
        time.sleep(3)

    logger.info(f'ukdfHist.iloc[:5,:] :\n{ukdfHist.iloc[:5,:]}')
    logger.info(f'ukdfHist.iloc[-5:,:] :\n{ukdfHist.iloc[-5:,:]}')

    if interval_pre == '10m':
        interval = interval_pre
        intervalSec = int(intervalSec*2)
        rePeriod = '10T'

        ukdfHistCp = ukdfHist.copy()
        ukdfHistCp['dateTime'] = ukdfHistCp['closeSec'].apply(lambda x: datetime.datetime.fromtimestamp(x))
        ukdfHistCp = ukdfHistCp.set_index(keys=['dateTime'], drop=True)
        # ukdfHistCp = ukdfHistCp.reindex(ukdfHistCp['dateTime'].sort_values(ascending=True).index)

        logger.info(f'ukdfHistCp.iloc[:5,:] :\n{ukdfHistCp.iloc[:5,:]}')

        if not ukdfHistCp.empty:
            openSr = ukdfHistCp['open'].resample(rePeriod, label='right').first()  
            openTimeSr = ukdfHistCp['openTime'].resample(rePeriod, label='right').first()  
            closeSr = ukdfHistCp['close'].resample(rePeriod, label='right').last()  #last first max min
            closeTimeSr = ukdfHistCp['closeTime'].resample(rePeriod, label='right').last()  
            closeSecSr = ukdfHistCp['closeSec'].resample(rePeriod, label='right').last()  
            tradeDateSr = ukdfHistCp['tradeDate'].resample(rePeriod, label='right').last()  
            highSr = ukdfHistCp['high'].resample(rePeriod, label='right').max()  
            lowSr = ukdfHistCp['low'].resample(rePeriod, label='right').min()  

            ukdf = pd.concat([tradeDateSr, openTimeSr, closeTimeSr, closeSecSr,openSr, closeSr, highSr, lowSr], axis=1) 
            
        ukdf.columns = ['tradeDate', 'openTime', 'closeTime', 'closeSec', 'open', 'close', 'high', 'low']
        ukdf.reset_index(drop=True,inplace=True)

        if ukdf.iloc[-1]['closeSec'] - ukdf.iloc[-2]['closeSec'] < intervalSec:
            ukdf.drop([len(ukdf)-1],inplace=True)

        # ukdf = ukdfHistCp.copy()
        # logger.info(f'{ukdf.iloc[:5,:]=}')
        
        del ukdfHistCp

    else:
        ukdf = ukdfHist.copy()

    del ukdfHist

    ukdf['open'] = ukdf['open'].astype(float)
    ukdf['close'] = ukdf['close'].astype(float)
    ukdf['high'] = ukdf['high'].astype(float)
    ukdf['low'] = ukdf['low'].astype(float)
    ukdf['pct'] = ukdf['close']/ukdf['close'].shift(1)-1  #涨跌幅
    ukdf.fillna(0, inplace=True)

    ukdf['index'] = ukdf.index
    ukdf['idx'] = ukdf.index % divisor #6

    logger.info(f'ukdf.iloc[:5,:] :\n{ukdf.iloc[:5,:]}')
    logger.info(f'ukdf.iloc[-5:,:] :\n{ukdf.iloc[-5:,:]}')



    df_panel = ukdf[ukdf['idx'] == remainder ].copy() #5
    df_panel.dropna(how='any',inplace=True)
    df_panel.reset_index(drop=True,inplace=True)

    # wid_, thd, threshold, direction_ = 40, 50, 0.6, 1
    part1 = (df_panel['high'].rolling(window=wid, min_periods=wid).max() - df_panel['close']) / \
            (df_panel['high'].rolling(window=wid, min_periods=wid).max() - df_panel['low'].rolling(window=wid, min_periods=wid).min())

    df_panel['factor'] = part1.ewm(adjust=False, alpha=float(1) / wid, min_periods=0, ignore_na=False).mean()
    df_panel.dropna(how='any', inplace=True)
    df_panel.reset_index(drop=True, inplace=True)


    # df_panel = ukdf.groupby('tradeDate').apply(modifiedmom,wid,PR,thd) 
    # df_panel.reset_index(level=1, drop=True, inplace=True)
    # df_panel.reset_index(inplace=True)

    logger.info(f'df_panel.iloc[:5,:] :\n{df_panel.iloc[:5,:]}')
    logger.info(f'df_panel.iloc[-5:,:] :\n{df_panel.iloc[-5:,:]}')

    handler.queryContractAssets()
    handler.queryPositions()

    # cli.cancelSubKline(gateway, tradeType, symbol, '10m')
    cli.cancelAllSubKlines()
    cli.subKline(gateway, tradeType, symbol, interval)
    # cli.subKline("simulator", "usdt", "BTCUSDT", "1m")
    # cli.subOrderReport(gateway, 0)
    cli.subOrderReport(gateway)

    cli.cancelAllSubTicks()
    # cli.subTick("simulator", "usdt", "BTCUSDT")

    while True:
        time.sleep(60*60)

def main(argv):
    run(argv)

if __name__ == '__main__':
    print('__main__: ', sys.argv)
    main(sys.argv[1:])

# nohup python3 -u main.py -n factorcheck -s 8808 -c 29094 -X BTCUSDT -p 5m -w 40 -I 50 -d 2 -T 0.6 -t 1000000  >> log.txt 2>&1  &
