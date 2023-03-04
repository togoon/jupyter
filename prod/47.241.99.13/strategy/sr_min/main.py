# -*- coding: UTF-8 -*-
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

import warnings
from scipy import stats
# from math import sqrt
# from tqdm import tqdm
# from sklearn import preprocessing
# from matplotlib import pyplot as plt
from itertools import product as product
# from sklearn.linear_model import LogisticRegression
# import statsmodels.api as sm

from FIL_lib.my_logger import make_logger, logging
from FIL_lib.client import FILClient, Handler
from FIL_lib.core_types import *

warnings.filterwarnings('ignore')
# plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
# plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

# =============== 配置策略参数

gateway = "simulator"
name = "sr_min"
symbol = "BTCUSDT"
interval = "5m" #period #1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h, 8h, 12h, 1d, 3d, 1w, 1M
intervalCoef = {'m':60, 'h':60*60, 'd': 60*60*24, 'w':60*60*24*7, 'M':60*60*24*30}
intervalSec = int(interval[0:-1]) * intervalCoef[interval[-1] ]
tradeType = "usdt"

total = 1000 #
totalAdjRate = -3e-3 # -1e-3 -3e-3
histDays = 20  # 30 10 84 120 60 2 20
limit = 998 # 1500  499 998
wid = 192  #  42  108  83 40 10
wid2 = 10  # 90
thd = 0.88  # 阈值0  0.6  0.55 0.88
thd2 = 4.0  # 

ukdf = pd.DataFrame()
df_panel = pd.DataFrame()

version = '2.0.0'
print('\n--init--: ', f'{version=}, {gateway=}, {name=}, {symbol=}, {interval=}, {intervalCoef=}, {intervalSec=}, {tradeType=}, {total=}, {histDays=}, {wid=},{wid2=},{thd=},{thd2=},{limit=}', '\n')

curDate = time.strftime("%Y%m%d")
# logger = make_logger(name, log_level=logging.DEBUG, log_file= name + "_"+ str(curDate)+".log")
logger = ''

def func(idx,df_input,thd):  # thd 0.88
    # thd = 3
    # print(f"{idx = }")
    idx = [int(i) for i in idx] # 192: 0~143
    ds = df_input.iloc[idx]
    thd = thd * 100

    # ds['amt'] = ds['amt'] * (ds['high'] + ds['low']) / 2
    # amt_sum = np.sum(ds['amt'])
    amt_sum = np.sum(ds['amount']) # amount 库中原始成交金额

    ds = ds[ds['indicator']>np.percentile(ds['indicator'],thd)]  # 分位数 80% 
    # amt_pct = np.sum(ds['amt'])
    amt_pct = np.sum(ds['amount'])
    # ds['pct'] = np.sum(ds['amt']*(ds['high']+ds['low']))
    return amt_pct / amt_sum / (1-thd/100)

class StrategyHandler(Handler):
    def __init__(self, name, symbol, total):
        # super().__init__(name)
        self.name = name
        self.total = total
        self.symbol = symbol

        self.flagDict = {'side':"", 'posBuy':0, 'posSell':0,'isNewDay':False, 'isOpenBuy':False, 'isOpenSell':False, 'isCloseBuy':False, 'isCloseSell':False, 'isOpen':False, 'isClose':False,'isTrig':False }

        self.count = self.tradeCount = 0
        self.curDate = time.strftime("%Y%m%d")
        self.tradeDate = self.openTime = self.closeTime = self.closeSec = self.openSec = self.open = self.close = ''
        self.sign = 0

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

        if data.symbol != self.symbol or ukdf.empty:
            return

        self.tradeDate = time.strftime("%Y%m%d", time.localtime(data.closetime/1000) )
        self.openTime = time.strftime("%H%M%S", time.localtime(data.opentime/1000) )
        self.closeTime = time.strftime("%H%M%S", time.localtime(data.closetime/1000) )
        self.closeSec = data.closetime//1000
        self.open = float(data.openprice)
        self.close = float(data.closeprice)
        self.high = float(data.highprice)
        self.low = float(data.lowprice)
        self.vol = float(data.volume)
        self.amt = float(data.totalamount)

        self.openSec = data.opentime//1000

        print('--handleKline--: ', f"{version=}, {self.name=}, {self.symbol=}, {interval=}, {intervalSec=}, {wid=}, {thd=}, {self.sign=}, {self.total=}, {self.flagDict['side']=}, {self.tradeCount=}, {self.count=}")
        print(f'{self.closeSec=}, {self.tradeDate=}, {self.openTime=}, {self.closeTime=}, {self.symbol=}, {self.open=}, {self.close=}, {self.high=}, {self.low=}, {self.vol=}, {self.amt=} ' )

        self.count += 1
        if self.curDate != self.tradeDate:
            self.curDate = self.tradeDate
            self.flagDict['isNewDay'] = True

            self.CleanOverukdf(self.closeSec)
            # logger = make_logger(name, log_level=logging.DEBUG, log_file= name +"_" + str(self.curDate)+".log")

        if len(ukdf) != 0 and self.closeSec == int(ukdf.closeSec.iloc[-1]):
            ukdf.iloc[-1, ukdf.columns.get_loc('close')] = self.close
            ukdf.iloc[-1, ukdf.columns.get_loc('high')] = self.high
            ukdf.iloc[-1, ukdf.columns.get_loc('low')] = self.low
            ukdf.iloc[-1, ukdf.columns.get_loc('vol')] = self.vol
            ukdf.iloc[-1, ukdf.columns.get_loc('amt')] = self.amt
            ukdf.iloc[-1, ukdf.columns.get_loc('pct')] = self.close/ukdf.iloc[-2, ukdf.columns.get_loc('close')]   -1

        # if len(ukdf) != 0 and self.closeSec >= int(ukdf.closeSec.iloc[-1]) + intervalSec and self.openSec < int(ukdf.closeSec.iloc[-1]) + 60:            
        else:
            closePct = round(self.close/ukdf['close'].iloc[-1] -1 , 6)
            ukdf.loc[len(ukdf.index)] = [self.tradeDate,self.openTime,self.closeTime,self.closeSec,self.open,self.close,self.high,self.low,self.vol,self.amt,closePct,0,0,len(ukdf.index),0,0,0,0 ]
            # ukdf.reset_index(drop=True,inplace=True)

            # tradeDate,openTime,closeTime,closeSec,open,close,high,low,vol,amt,pct,    amount,indicator,index,value,value_mean,signal,value_std
            # 20221126,001500,001959,1669393199,16479.9,16487.2,16491.3,16479.1,373.194,373.2113024409775,0.00043689320388362596,   6152462.963,1.1706322960374964e-06,8643,4.351258502359494e-05,3.810630045776722e-05,0,7.507786014055943e-06

        ukdf.iloc[-1, ukdf.columns.get_loc('amount')] = self.amt
        ukdf.iloc[-1, ukdf.columns.get_loc('amt')] = self.amt/( self.high+ self.low)*2

        ds = ukdf.tail(wid)
        amt_sum = np.sum(ds['amount']) # idx rolling(int(wid_) wid 192
        ds1 = ds[ds['indicator']>np.percentile(ds['indicator'],thd*100)]   # thd 0.88
        amt_pct = np.sum(ds1['amount'])

        value = amt_pct / amt_sum / (1-thd) # thd 0.88
        ukdf.iloc[-1, ukdf.columns.get_loc('value')] = value

        value_mean = np.mean(ukdf['value'].tail(wid * wid2) ) # wid 192 , wid2 10
        value_std = np.std(ukdf['value'].tail(wid * wid2) ) # wid 192 , wid2 10
        ukdf.iloc[-1, ukdf.columns.get_loc('value_mean')] = value_mean
        ukdf.iloc[-1, ukdf.columns.get_loc('value_std')] = value_std

        # signal = np.where((value > value_mean +thd2*value_std), 1, np.where((value < value_mean -thd2*value_std), -1, 0) ) # thd2 4.0
        signal = 1 if value > value_mean +thd2*value_std else ( -1 if value < value_mean -thd2*value_std else 0)  # thd2 4.0
        
        ukdf.iloc[-1, ukdf.columns.get_loc('signal')] = signal


        logger.info(f"ukdf.iloc[-5:,:] :\n{ukdf.iloc[-5:,:]}" )
        # ukdf.to_csv(r"ukdf.csv",index=False)

        logger.info(f"{self.closeSec=}, {self.tradeDate=}, {self.openTime=}, {self.closeTime=},{self.symbol=},{self.open=}, {self.close=}, {self.high=}, {self.low=}, {self.vol=}, {self.amt=}, {ukdf['pct'].iloc[-1]=} , {ukdf['amount'].iloc[-1]=}, {ukdf['indicator'].iloc[-1]=}, {ukdf['index'].iloc[-1]=}, {value=}, {value_mean=}, {signal=}, {value_std=} " ) 

        # logger.info(f"{self.flagDict=}")   

        # self.getModel()  
        self.queryPositions()
        
        curSign = signal
        print(f"{type(curSign)=}, {curSign=}, {self.sign=}")        
        if curSign != 0 and (self.sign == 0 or self.sign * curSign == -1):
            self.sign = curSign
            self.handlebackTrade()
            self.insertFactor() 

    def getModel(self):
        global ukdf
        global df_panel

    def insertFactor(self):
        curDateTime = int(time.strftime("%m%d%H%M")) #"%Y%m%d%H%M%S" %y%m%d%H%M
        
        factor = f"name:{self.name}, symbol:{self.symbol}, tradeDate:{self.tradeDate}, closeTime:{self.closeTime}, close:{self.close}, sign:{self.sign}, total:{self.total}, side:{self.flagDict['side']} "

        self.client.insertFactor(curDateTime, factor )

        logger.info(f"curDateTime:{curDateTime}, {factor} " )

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
                self.sign = -1 if posi.positionside == 'short' else 1

    def handlebackTrade(self):
        global gateway

        positions = self.client.queryPositions(self.symbol)
        print((f"handlebackTrade > queryPositions: {self.symbol=}, {positions=}"))
        if positions.result:
            for posi in positions.result:

                # self.flagDict['side'] = "buy" if posi.positionside == 'short' else "sell"             
                # positionAmount = float( posi.positionAmount)  # handback

                # if (self.sign == 1 and self.flagDict['side'] == "buy") or  (self.sign == -1 and self.flagDict['side'] == "sell"):
                #     ret = self.client.insertMarketUOrder(gateway,  posi.symbol, positionAmount, self.flagDict['side'])

                #     # debug.info(f"{self.flagDict=}")
                #     logger.info(f"ret = self.client.insertMarketUOrder('{gateway}',  '{posi.symbol}', '{positionAmount}', '{self.flagDict['side']}' ), {ret=}")
                #     self.tradeCount += 1
                
                self.client.closeAllPosition()
                time.sleep(5)
                self.queryContractAssets()
                if posi.positionside == 'short':
                    self.openBuy(self.close)
                elif posi.positionside == 'long':
                    self.openSell(self.close)
                    
                self.tradeCount += 1
            
        else:
            self.flagDict['side'] = "buy" if self.sign == 1 else ("sell" if self.sign == -1 else "")

            quantity = float(self.total*(1 + totalAdjRate) )/float(self.close)
            qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

            ret = self.client.insertMarketUOrder(gateway, self.symbol, float(qtyStr), self.flagDict['side'])

            # logger.debug(f"{self.flagDict=}")
            logger.info(f"ret = self.client.insertMarketUOrder('{gateway}',  '{self.symbol}', '{qtyStr}', '{self.flagDict['side']}' ), {ret=}")   
            self.tradeCount += 1         

    def openBuy(self, close):
        global gateway
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenBuy'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "buy"

        quantity = float(self.total*(1 + totalAdjRate) )/float(close)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        ret = self.client.insertMarketUOrder(gateway, self.symbol, float(qtyStr), "buy")

        logger.debug(f"{self.flagDict=}")
        logger.info(f'ret = self.client.insertMarketUOrder("{gateway}", "{self.symbol}", {qtyStr}, "buy"), {ret=}')

    def openSell(self, close):
        global gateway
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenSell'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "sell"

        quantity = float(self.total*(1 + totalAdjRate) )/float(close)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        ret = self.client.insertMarketUOrder(gateway,  self.symbol, float(qtyStr), "sell")

        logger.info(f'ret = self.client.insertMarketUOrder("{gateway}", "{self.symbol}", {qtyStr}, "sell"), {ret=}')

    def closeBuy(self):
        global gateway
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

                logger.debug(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder("{gateway}",  {posi.symbol}, {posi.positionAmount}, {side} ), {ret=}')

    def closeSell(self):
        global gateway
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

                logger.debug(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder("{gateway}",  {posi.symbol}, {posi.positionAmount}, {side} ), {ret=}')

    def clearance(self):
        global gateway
        self.flagDict['isOpen'] = False
        self.flagDict['isClose'] = True

        positions = self.client.queryPositions(self.symbol)
        print((f"clearance: {self.symbol=}, {positions=}"))
        if positions.result:

            for posi in positions.result:

                side = "buy" if posi.positionside == 'short' else "sell"

                ret = self.client.insertMarketUOrder(gateway, posi.symbol, posi.positionAmount, side)

                logger.debug(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder(gateway,  {posi.symbol}, {posi.positionAmount}, {side} ), {ret=}')

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

    def handleTimer(self, data:TimeridType):
        logger.info(f"handleTimer: {data=}")

def getuklines(cli):
    global ukdf
    global interval
    global intervalSec
    global limit
    global histDays
    global logger
    global symbol
    
    curSec = int(time.time())
    histSec = int(time.mktime(time.strptime(time.strftime("%Y%m%d", time.localtime(time.time()-60*60*24*histDays ) ), '%Y%m%d'))) -1
    
    interval_pre = interval
    if interval_pre == '10m':
        interval = '5m'
        intervalSec = intervalSec//2

    totalCount = math.ceil( (curSec - histSec )/intervalSec )
    logger.info(f'{interval=}, {histSec=}, {curSec=}, {intervalSec=}, {limit=}, {intervalSec*limit=}, {totalCount=}, {histDays=}')

    ukdfHist = pd.DataFrame(columns=['tradeDate', 'openTime', 'closeTime', 'closeSec', 'open', 'close',  'high',  'low','vol','amt' ])

    count = 1
    for Sec in range(histSec, curSec, intervalSec*limit):

        print(f'{count=}:', "cli.uklines('binance',", f'{symbol=}', ',', f'{interval=}', ',', f'{limit=}', ',', f'{Sec*1000+999=}', ', end=', f'{(Sec+intervalSec*limit-1)*1000+999}' , ' )')

        ukRet = cli.uklines('binance', symbol=symbol, interval=interval, limit=limit, start=Sec*1000+999, end=(Sec+intervalSec*limit-1)*1000+999 )

        # print('\n--ukRet--: ', ukRet)

        kdf = pd.DataFrame([{'tradeDate': time.strftime("%Y%m%d", time.localtime(rs.closetime/1000) ), 'openTime': time.strftime("%H%M%S", time.localtime(rs.opentime/1000) ), 'closeTime': time.strftime("%H%M%S", time.localtime(rs.closetime/1000) ), 'closeSec': rs.closetime//1000, 'open': rs.openprice, 'close': rs.closeprice, 'high': rs.highprice, 'low': rs.lowprice, 'vol': float(rs.volume), 'amt': float(rs.totalamount)} for rs in ukRet.result])

        # ukdfHist.append(kdf)
        ukdfHist = pd.concat([ukdfHist,kdf],ignore_index=True)
        del kdf

        count += 1
        time.sleep(3)

    logger.debug(f'ukdfHist.iloc[:5,:] :\n{ukdfHist.iloc[:5,:]}')
    logger.debug(f'ukdfHist.iloc[-5:,:] :\n{ukdfHist.iloc[-5:,:]}')

    if interval_pre == '10m':
        interval = interval_pre
        intervalSec = int(intervalSec*2)
        rePeriod = '10T'

        ukdfHistCp = ukdfHist.copy()
        ukdfHistCp['dateTime'] = ukdfHistCp['closeSec'].apply(lambda x: datetime.datetime.fromtimestamp(x))
        ukdfHistCp = ukdfHistCp.set_index(keys=['dateTime'], drop=True)
        # ukdfHistCp = ukdfHistCp.reindex(ukdfHistCp['dateTime'].sort_values(ascending=True).index)

        logger.debug(f'ukdfHistCp.iloc[:5,:] :\n{ukdfHistCp.iloc[:5,:]}')

        if not ukdfHistCp.empty:
            openSr = ukdfHistCp['open'].resample(rePeriod, label='right').first()  
            openTimeSr = ukdfHistCp['openTime'].resample(rePeriod, label='right').first()  
            closeSr = ukdfHistCp['close'].resample(rePeriod, label='right').last()  #last first max min
            closeTimeSr = ukdfHistCp['closeTime'].resample(rePeriod, label='right').last()  
            closeSecSr = ukdfHistCp['closeSec'].resample(rePeriod, label='right').last()  
            tradeDateSr = ukdfHistCp['tradeDate'].resample(rePeriod, label='right').last()  
            highSr = ukdfHistCp['high'].resample(rePeriod, label='right').max()  
            lowSr = ukdfHistCp['low'].resample(rePeriod, label='right').min()  
            volSr = ukdfHistCp['vol'].resample(rePeriod, label='right').sum()  
            amtSr = ukdfHistCp['amt'].resample(rePeriod, label='right').sum()  

            ukdf = pd.concat([tradeDateSr, openTimeSr, closeTimeSr, closeSecSr,openSr, closeSr, highSr, lowSr,  volSr, amtSr], axis=1) 
            
        ukdf.columns = ['tradeDate', 'openTime', 'closeTime', 'closeSec', 'open', 'close', 'high', 'low', 'vol', 'amt']
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
    ukdf['vol'] = ukdf['vol'].astype(float)
    ukdf['amt'] = ukdf['amt'].astype(float)
    ukdf['pct'] = ukdf['close']/ukdf['close'].shift(1)-1  #涨跌幅
    ukdf.fillna(0, inplace=True)

    logger.info(f'ukdf.iloc[:5,:] :\n{ukdf.iloc[:5,:]}')
    logger.info(f'ukdf.iloc[-5:,:] :\n{ukdf.iloc[-5:,:]}')


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
    global symbol
    global df_panel
    global gateway


    input_pro = '-n <name> -s <serverPort> -c <clientPort> -X <symbol> -p <period> -w <wid> -I <wid2> -d <day> -T <thd> -H <thd2> -t <total>'
    try:
        # 优先级i>d>args
        opts, args = getopt.getopt(argv, "n:s:c:X:p:w:I:d:T:H:t:",
                        ["name",'serverPort','clientPort',"symbol","period","wid","wid2","day","thd","thd2","total"])
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
        elif opt in ("-H", '--thd2'):
            thd2 = float(arg)

        elif opt in ("-s", '--serverPort'):
            serverPort = int(arg)
        elif opt in ("-c", '--clientPort'):
            clientPort = int(arg)

    handler = StrategyHandler(name, symbol, total)
    cli = FILClient(handler, timeout=(3, 5), server_url="http://127.0.0.1:%d/strategy" % serverPort, listen_port=clientPort)
    cli.start()

    curDate = time.strftime("%Y%m%d")
    logger = make_logger(name, log_level=logging.DEBUG, log_file= name +"_" + str(curDate)+".log")

    logger.info(f'--cli.start()--{version}--{curDate}--')

    getuklines(cli) # ukdf

    ukdf['amount'] = ukdf['amt'] 
    ukdf['amt'] = ukdf['amt']/( ukdf['high']+ ukdf['low'])*2
    ukdf.fillna(0, inplace=True)
    ukdf['indicator'] = abs(ukdf['pct']) /ukdf['amt']
    ukdf['index'] = ukdf.index
    ukdf['value'] = ukdf['index'].rolling(int(wid)).apply(lambda x: func(x, ukdf, thd)) # wid_ 192, thd 0.88

    ukdf['value_mean'] = ukdf['value'].rolling(int(wid*int(wid2)) ).mean()  # wid_back 10 , 3600
    ukdf['value_std'] = ukdf['value'].rolling(int(wid*int(wid2)) ).std()  # wid_back 10

    ukdf['signal'] = np.where((ukdf['value'] > ukdf['value_mean']+thd2*ukdf['value_std']), 1, np.where((ukdf['value'] < ukdf['value_mean']-thd2*ukdf['value_std']), -1, 0 ) )   # thd_std 4.0

    logger.info(f'ukdf.iloc[-5:,:] :\n{ukdf.iloc[-5:,:]}')
    # ukdf.to_csv(r"ukdf.csv",index=False)

    handler.queryContractAssets()
    handler.queryPositions()

    # cli.cancelSubKline(gateway, tradeType, symbol, '5m')
    cli.cancelAllSubKlines()

    cli.subKline(gateway, tradeType, symbol, interval)
    # cli.subKline(gateway, "usdt", "BTCUSDT", "5m")
    # cli.subOrderReport(gateway, 0)
    cli.subOrderReport(gateway)

    cli.cancelAllSubTicks()
    # cli.subTick(gateway, "usdt", "BTCUSDT")

    # cli.cancelSubTimer(1*1000*60)
    # cli.subTimer(1*1000*60)

    while True:
        time.sleep(60*60) 

def main(argv):
    run(argv)

if __name__ == '__main__':
    print('__main__: ', sys.argv)
    main(sys.argv[1:])

# nohup python3 -u main.py -n sr_min -s 8808 -c 29099 -X BTCUSDT -p 5m -w 192 -I 10 -d 20 -T 0.88 -H 4.0 -t 1000000 >> log.txt 2>&1 & 

# python3 -u main.py -n sr_min -s 8808 -c 29099 -X BTCUSDT -p 5m -w 192 -I 10 -d 20 -T 0.88 -H 4.0 -t 1000000 

