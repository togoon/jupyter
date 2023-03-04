import time
import getopt
import sys
import math
import datetime
from matplotlib.pyplot import xlabel

# from numpy import corrcoef

import pandas as pd
import numpy as np

from FIL_lib.my_logger import make_logger, logging
from FIL_lib.client import FILClient, Handler
from FIL_lib.core_types import *

# =============== 配置策略参数

gateway = "simulator"
name = "Similarity"
symbol = "BTCUSDT"
interval = "10m" #period #1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h, 8h, 12h, 1d, 3d, 1w, 1M
intervalCoef = {'m':60, 'h':60*60, 'd': 60*60*24, 'w':60*60*24*7, 'M':60*60*24*30}
intervalSec = int(interval[0:-1]) * intervalCoef[interval[-1] ]
tradeType = "usdt"

total = 1000 #
totalAdjRate = -1e-3
histDays = 84  # 30 10 84
limit = 998 # 1500  499 998
corrLim = 0  # 0.6
wid = 42

ukdf = pd.DataFrame(columns=['tradeDate', 'openTime', 'closeTime', 'closeSec', 'open', 'close', ])

version = '2.3.13'

print('\n--init--: ', f'{version=}, {gateway=}, {name=}, {symbol=}, {interval=}, {intervalCoef=}, {intervalSec=}, {tradeType=}, {total=}, {histDays=},{limit=}', '\n')

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

        self.flagDict = {'side':"", 'posBuy':0, 'posSell':0,'isNewDay':False, 'isOpenBuy':False, 'isOpenSell':False, 'isCloseBuy':False, 'isCloseSell':False, 'isOpen':False, 'isClose':False,'isTrig':False,'isCorr':False }

        self.count = 1
        self.curDate = ''
        self.tradeDate = self.openTime = self.closeTime = self.closeSec = self.openSec = self.open = self.close = ''
        self.corrVal = self.corrDate = ''

    def handleKline(self, data:KlineType):
        # logger.debug(f"handleKline: data={data}")

        global ukdf
        global intervalSec
        global corrLim
        global interval
        global curDate
        global logger
        global wid

        if data.symbol != self.symbol:
            return

        self.tradeDate = time.strftime("%Y%m%d", time.localtime(data.closetime/1000) )
        self.openTime = time.strftime("%H%M%S", time.localtime(data.opentime/1000) )
        self.closeTime = time.strftime("%H%M%S", time.localtime(data.closetime/1000) )
        self.closeSec = data.closetime//1000
        self.open = data.openprice
        self.close = data.closeprice

        self.openSec = data.opentime//1000

        print('\n--handleKline--: ', f'{self.name=}, {self.symbol=}, {interval=}, {intervalSec=}, {self.count=}', '\n')
        print(f'{self.closeSec=}, {self.tradeDate=}, {self.openTime=}, {self.closeTime=}, {self.symbol=}, {self.open=}, {self.close=}' )

        self.count = self.count +1
        if self.curDate != self.tradeDate:
            self.curDate = self.tradeDate
            self.flagDict['isNewDay'] = True
            # curDate = time.strftime("%Y%m%d")
            # logger = make_logger(name, log_level=logging.DEBUG, log_file= name +"_" + str(curDate)+".log")

        if self.closeSec == int(ukdf.closeSec.iloc[-1]):
            ukdf.close.iloc[-1] = self.close

        if len(ukdf) != 0 and self.closeSec >= int(ukdf.closeSec.iloc[-1]) + intervalSec and self.openSec < int(ukdf.closeSec.iloc[-1]) + 60:            

            ukdf.loc[len(ukdf.index)] = [self.tradeDate,self.openTime,self.closeTime,self.closeSec,self.open,self.close]
            # ukdf.reset_index(drop=True,inplace=True)

            logger.info(f'{self.closeSec=}, {self.tradeDate=}, {self.openTime=}, {self.closeTime=},{self.symbol=},{self.open=}, {self.close=}, {self.count=}'  )
            logger.info(f"ukdf.iloc[-5:,:] :\n{ukdf.iloc[-5:,:]}" )
            logger.info(f"{self.flagDict=}")

            if self.count == 3:
                self.client.closeAllPosition()
                self.queryContractAssets()

            if self.count == 4 or len( ukdf.loc[ukdf.tradeDate == self.tradeDate] ) == wid:  #

                self.CleanOverukdf(self.closeSec)
                corrdf = self.getSimilarity(self.closeTime)  # corrdf.iloc[1,0], corrdf.index[1]
                self.corrVal = corrdf.iloc[1,0]
                self.corrDate = corrdf.index[1]

                print(f'corrdf :\n{corrdf}')
                print(f'{self.closeTime=}, {self.corrDate=}, {self.corrVal=}' )

                # ukdfPm = ukdf[ (ukdf['closeTime'] >= self.closeTime) & (ukdf['tradeDate'] == corrDate) ]
                ukdfPm = ukdf[ ukdf['tradeDate'] == self.corrDate ][wid:]

                self.queryContractAssets()
                
                if ukdfPm.iloc[0, 4] < ukdfPm.iloc[-1, 5]:  #open < close
                    if self.corrVal >= corrLim: #OpenBuy
                        self.openBuy(self.close)
                    elif self.corrVal <= -corrLim: #OpenSell
                        self.openSell(self.close)

                else: #open >= close
                    if self.corrVal >= corrLim: #OpenSell
                        self.openSell(self.close)
                    elif self.corrVal <= -corrLim: #OpenBuy
                        self.openBuy(self.close)

                if self.flagDict['isOpen']:
                    self.flagDict['isTrig'] = True
                    self.flagDict['isClose'] = False
                    self.insertFactor()
         
            elif int(self.closeTime) >= 235559:

                if self.flagDict['isOpen']:
                    self.flagDict['isOpen'] = False
                    self.flagDict['isClose'] = True
                    self.flagDict['isTrig'] = False

                    if self.flagDict['isOpenBuy']:
                        self.flagDict['isOpenBuy'] = False
                        self.flagDict['isCloseBuy'] = True
                        self.closeBuy()

                    elif self.flagDict['isOpenSell']:
                        self.flagDict['isOpenSell'] = False
                        self.flagDict['isCloseSell'] = True
                        self.closeSell()

                    self.insertFactor()                   
                else:
                    # self.clearance()
                    self.client.closeAllPosition()
                    self.insertFactor()

        #     elif int(self.closeTime) <= 3159:
        #         self.clearance()

        # elif int(self.closeTime) <= 3159:
        #     self.clearance()

    def insertFactor(self):
        curDateTime = int(time.strftime("%m%d%H%M")) #"%Y%m%d%H%M%S" %y%m%d%H%M
        # factor = {'symbol':self.symbol, 'side':self.flagDict['side'], 'isTrig':self.flagDict['isTrig'], 'isOpen':self.flagDict['isOpen'], 'isClose':self.flagDict['isClose'], 'tradeDate':self.tradeDate, 'openTime':self.openTime, 'closeTime':self.closeTime, 'closeSec':self.closeSec, 'open':self.open, 'close':self.close, 'corrVal':self.corrVal, 'corrDate':self.corrDate, 'total':self.total, }

        self.client.insertFactor(curDateTime, f"name:{self.name}, symbol:{self.symbol}, tradeDate:{self.tradeDate}, closeTime:{self.closeTime}, close:{self.close}, total:{self.total}, corrDate:{self.corrDate}, corrVal:{self.corrVal}, side:{self.flagDict['side']} " )

        logger.info(f"curDateTime:{curDateTime}, name:{self.name}, symbol:{self.symbol}, tradeDate:{self.tradeDate}, closeTime:{self.closeTime}, close:{self.close}, total:{self.total}, corrDate:{self.corrDate}, corrVal:{self.corrVal}, side:{self.flagDict['side']} " )

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

    def openBuy(self, close):
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenBuy'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "buy"

        quantity = float(self.total*(1 + totalAdjRate) -100)/float(close)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        ret = self.client.insertMarketUOrder(gateway, self.symbol, float(qtyStr), "buy")

        logger.info(f"{self.flagDict=}")
        logger.info(f'ret = self.client.insertMarketUOrder("{gateway}", "{self.symbol}", {qtyStr}, "buy"), {ret=}')

    def openSell(self, close):
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenSell'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "sell"

        quantity = float(self.total*(1 + totalAdjRate) -100)/float(close)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        ret = self.client.insertMarketUOrder(gateway,  self.symbol, float(qtyStr), "sell")

        logger.info(f'ret = self.client.insertMarketUOrder("{gateway}", "{self.symbol}", {qtyStr}, "sell"), {ret=}')

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

                ret = self.client.insertMarketUOrder(gateway,  posi.symbol, posi.positionAmount, side)

                logger.info(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder("{gateway}",  {posi.symbol}, {posi.positionAmount}, {side} ), {ret=}')

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

                ret = self.client.insertMarketUOrder(gateway,  posi.symbol, posi.positionAmount, side)

                logger.info(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder("{gateway}",  {posi.symbol}, {posi.positionAmount}, {side} ), {ret=}')

    def clearance(self):
        positions = self.client.queryPositions(self.symbol)
        print((f"clearance: {self.symbol=}, {positions=}"))
        if positions.result:

            for posi in positions.result:

                side = "buy" if posi.positionside == 'short' else "sell"

                ret = self.client.insertMarketUOrder(gateway, posi.symbol, posi.positionAmount, side)

                logger.info(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder("{gateway}",  {posi.symbol}, {posi.positionAmount}, {side} ), {ret=}')

    def CleanOverukdf(self, closeSec:int):

        global ukdf
        global histDays

        overDate = time.strftime("%Y%m%d", time.localtime(closeSec-60*60*24*histDays ) )
        ukdf.drop(ukdf.index[(ukdf['tradeDate'] < overDate)], inplace=True)
        ukdf.reset_index(drop=True, inplace=True)

        print(f'\n--ukdf-hist--: {overDate=} \n', ukdf.iloc[0:5,:] ,'\n' , ukdf.iloc[-5:,:],'\n' )

    def getSimilarity(self, closeTime:str) -> pd.DataFrame:

        global ukdf
        global wid

        # ukdfAm = ukdf[ukdf['closeTime'] < closeTime ]
        ukdfT = ukdf.pivot(index='closeTime', columns='tradeDate', values='close')
        ukdfAmT = ukdfT.iloc[:wid].copy()
        ukdfAmT.dropna(how='any',inplace=True)
        ukdfAmT.reset_index(drop=True,inplace=True)

        ukdfAmT = ukdfAmT.apply(lambda x: x.astype(float))

        logger.info(f"{ukdfAmT.corr()=}")

        df_corr = ukdfAmT.corr().iloc[:, [-1]]
        df_corr.columns=['corr']
        # df_corr = df_corr.reindex(df_corr['corr'].abs().sort_values(ascending=False).index)
        df_corr = df_corr.reindex(df_corr['corr'].sort_values(ascending=False).index)

        logger.info(f"df_corr: {df_corr}")  # corr: df_corr.iloc[1,0], data: df_corr.index[1]
        return df_corr

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
    global symbol


    input_pro = '-n <name> -s <serverPort> -c <clientPort> -X <symbol> -p <period> -w <wid> -d <day> -t <total>'
    try:
        # 优先级i>d>args
        opts, args = getopt.getopt(argv, "n:s:c:X:p:w:d:t:",
                        ["name",'serverPort','clientPort',"symbol","period","wid","day","total"])
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
        elif opt in ("-d", '--day'):
            histDays = int(arg)
            
        elif opt in ("-s", '--serverPort'):
            serverPort = int(arg)
        elif opt in ("-c", '--clientPort'):
            clientPort = int(arg)

    cli = FILClient(StrategyHandler(name, symbol, total), timeout=(3, 5),server_url="http://127.0.0.1:%d/strategy" % serverPort, listen_port=clientPort)
    cli.start()

    curDate = time.strftime("%Y%m%d")
    logger = make_logger(name, log_level=logging.DEBUG, log_file= name +"_" + str(curDate)+".log")

    logger.info(f'----cli.start()---{curDate}--')

    curSec = int(time.time())
    histSec = int(time.mktime(time.strptime(time.strftime("%Y%m%d", time.localtime(time.time()-60*60*24*histDays ) ), '%Y%m%d')))

    interval_pre = interval
    if interval_pre == '10m':
        interval = '5m'
        intervalSec = intervalSec//2

    totalCount = math.ceil( (curSec - histSec )/intervalSec )
    logger.info(f'{interval=}, {histSec=}, {curSec=}, {intervalSec=}, {limit=}, {intervalSec*limit=}, {totalCount=}, {histDays=}')

    ukdfHist = pd.DataFrame(columns=['tradeDate', 'openTime', 'closeTime', 'closeSec', 'open', 'close', ])

    count = 1

    for Sec in range(histSec, curSec, intervalSec*limit):

        print(f'{count=}:', "cli.uklines('binance',", f'{symbol=}', ',', f'{interval=}', ',', f'{limit=}', ',', f'{Sec*1000+999=}', ', end=', f'{(Sec+intervalSec*limit-1)*1000+999}' , ' )')

        ukRet = cli.uklines('binance', symbol=symbol, interval=interval, limit=limit, start=Sec*1000+999, end=(Sec+intervalSec*limit-1)*1000+999 )

        # print('\n--ukRet--: ', ukRet)

        kdf = pd.DataFrame([{'tradeDate': time.strftime("%Y%m%d", time.localtime(rs.closetime/1000) ), 'openTime': time.strftime("%H%M%S", time.localtime(rs.opentime/1000) ), 'closeTime': time.strftime("%H%M%S", time.localtime(rs.closetime/1000) ), 'closeSec': rs.closetime//1000, 'open': rs.openprice, 'close': rs.closeprice} for rs in ukRet.result])

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

            ukdf = pd.concat([tradeDateSr, openTimeSr, closeTimeSr, closeSecSr,openSr, closeSr], axis=1) 
            
        ukdf.columns = ['tradeDate', 'openTime', 'closeTime', 'closeSec', 'open', 'close']
        ukdf.reset_index(drop=True,inplace=True)

        if ukdf.iloc[-1]['closeSec'] - ukdf.iloc[-2]['closeSec'] < intervalSec:
            ukdf.drop([len(ukdf)-1],inplace=True)

        # ukdf = ukdfHistCp.copy()
        # logger.info(f'{ukdf.iloc[:5,:]=}')
        
        del ukdfHistCp

    else:
        ukdf = ukdfHist.copy()

    del ukdfHist

    logger.info(f'ukdf.iloc[:5,:] :\n{ukdf.iloc[:5,:]}')
    logger.info(f'ukdf.iloc[-5:,:] :\n{ukdf.iloc[-5:,:]}')

    # cli.cancelSubKline(gateway, tradeType, symbol, '10m')
    cli.cancelAllSubKlines()
    cli.subKline(gateway, tradeType, symbol, interval)
    # cli.subKline(gateway, "usdt", "BTCUSDT", "1m")
    # cli.subOrderReport(gateway, 0)
    cli.subOrderReport(gateway)

    cli.cancelAllSubTicks()
    # cli.subTick(gateway, "usdt", "BTCUSDT")

    while True:
        time.sleep(60*60)

def main(argv):
    run(argv)

if __name__ == '__main__':
    print('__main__: ', sys.argv)
    main(sys.argv[1:])

# nohup python3 -u main.py -n testStrategy -s 8808 -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &