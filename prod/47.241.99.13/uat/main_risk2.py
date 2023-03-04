# -*- coding: UTF-8 -*-
import time
import getopt
import sys
import math
from datetime import datetime, timedelta
import os
import sqlite3

# from matplotlib.pyplot import xlabel
# from PyEMD import EMD, Visualisation
# from numpy import corrcoef

import pandas as pd 
import numpy as np

import warnings
from scipy import stats
# from math import sqrt
from tqdm import tqdm
from sklearn import preprocessing
from matplotlib import pyplot as plt
from itertools import product as product

from sklearn.linear_model import LogisticRegression

from FIL_lib.my_logger import make_logger, logging
from FIL_lib.client import FILClient, Handler
from FIL_lib.core_types import *

warnings.filterwarnings('ignore')

# =============== 配置策略参数

gateway = "binance"
name = "testrisk2"
symbol = "BTCUSDT"
interval = "3m" #period #1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h, 8h, 12h, 1d, 3d, 1w, 1M
intervalCoef = {'m':60, 'h':60*60, 'd': 60*60*24, 'w':60*60*24*7, 'M':60*60*24*30}
intervalSec = int(interval[0:-1]) * intervalCoef[interval[-1] ]
tradeType = "usdt"

total = 1000 # 
totalAdjRate = -3e-3 # -1e-3 -3e-3
histDays = 2  # 30 10 84 120 60 2 
limit = 998 # 1500  499 998
wid = 40  #  42 108 83 
thd = 0.55  # 阈值0  0.6 


ukdf = pd.DataFrame()
df_panel = pd.DataFrame()

version = '3.2.1'

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

        self.flagDict = {'side':"", 'positionside':2, 'posBuy':0, 'posSell':0,'isNewDay':False, 'isOpenBuy':False, 'isOpenSell':False, 'isCloseBuy':False, 'isCloseSell':False, 'isOpen':False, 'isClose':False,'isTrig':False } 

        self.count = self.tradeCount = 0
        self.curDate = time.strftime("%Y%m%d")
        self.tradeDate = self.openTime = self.closeTime = self.closeSec = self.openSec = self.open = self.close = ''
        self.sign = 1
        self.uPrice = self.markPrice = 0
        self.iniTime = datetime.now()
        self.curTimeSec = int(time.time())

        self.df_order = pd.DataFrame()
        self.df_filltrades = pd.DataFrame()
        self.df_assets = pd.DataFrame()
        self.df_position = pd.DataFrame()        
        self.df_uprice = pd.DataFrame() 
        self.df_umarkprice = pd.DataFrame()        

    def handleKline(self, data:KlineType):
        # logger.debug(f"handleKline: data={data}")
        global ukdf
        global intervalSec
        global interval
        global version
        global curDate
        global logger
        global wid
        global histDays
        global df_panel
        global thd

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
            ukdf.loc[len(ukdf.index)] = [self.tradeDate,self.openTime,self.closeTime,self.closeSec,self.open,self.close,self.high,self.low,self.vol,self.amt,closePct ]
            # ukdf.reset_index(drop=True,inplace=True)

        logger.info(f'{self.closeSec=}, {self.tradeDate=}, {self.openTime=}, {self.closeTime=},{self.symbol=},{self.open=}, {self.close=}, {self.high=}, {self.low=}, {self.vol=}, {self.amt=} ' )
        logger.info(f"ukdf.iloc[-5:,:] :\n{ukdf.iloc[-5:,:]}" )
        # logger.info(f"{self.flagDict=}")
        
        # self.getModel()
        self.queryPositions()
        
        # curSign = int(df_panel['sign'].iloc[-1])

        if self.count >= 5:
            return

        # if len( ukdf.loc[ukdf.tradeDate == self.tradeDate] ) == wid:  #
        if self.count % 3 == 1 :  # and self.count <= 2
            self.queryContractAssets()
            self.handlebackTrade()
            
            # self.client.closeAllPosition()
            # self.clearance() 
            
            self.insertFactor()
        
        # if self.sign != curSign:
        #     self.sign = curSign
        #     self.handlebackTrade()
        #     self.insertFactor()

    def getModel(self):
        global ukdf
        global df_panel

    def insertFactor(self):
        curDateTime = int(time.strftime("%m%d%H%M")) #"%Y%m%d%H%M%S" %y%m%d%H%M
        
        factor = f"name:{self.name}, symbol:{self.symbol}, tradeDate:{self.tradeDate}, closeTime:{self.closeTime}, close:{self.close}, sign:{self.sign}, total:{self.total}, count:{self.count}, side:{self.flagDict['side']}, uPrice:{self.uPrice}, markPrice:{self.markPrice} "

        self.client.insertFactor(curDateTime, factor )

        logger.info(f"curDateTime:{curDateTime}, {factor} " )

    def queryContractAssets(self):

        global tradeType
        # assets = self.client.queryContractAssets(tradeType)
        # logger.info(f"queryContractAssets: {assets=}")
        assets = self.client.queryTradeContractAssets(tradeType, self.symbol)
        logger.info(f"queryTradeContractAssets: {assets=}")

        if assets.result:
            for item in assets.result:
                if item.asset.upper() == tradeType.upper() and float(item.free) > 0:
                    self.total = float(item.free)

                    rt_df = pd.DataFrame([{'asset': item.asset, 'free': item.free, 'total': item.total, 'margin': item.margin, 'unreal': item.unreal, 'lock': item.lock, 'syslock': item.syslock, 'longfree': item.longfree, 'shortfree': item.shortfree, 'type': item.type, 'update': time.strftime('%Y%m%d %H:%M:%S')}])
                    self.savePickle(rt_df, self.df_assets, 'assets')
                else:
                    self.total = 0

    def queryPositions(self):

        positions = self.client.queryPositions(self.symbol)
        print((f"queryPositions: {self.symbol=}, {positions=}"))
        if positions.result:
            for item in positions.result:
                self.flagDict['isOpen'] = True
                self.sign = -1 if item.positionside == 'short' else 1

                rt_df = pd.DataFrame([{'symbol': item.symbol, 'positionAmount': item.positionAmount, 'enterprice': item.enterprice, 'countrevence': item.countrevence, 'unrealprofit': item.unrealprofit, 'marginmodel': item.marginmodel, 'isolatedmargin': item.isolatedmargin, 'positionside': item.positionside, 'markprice': item.markprice, 'update': time.strftime('%Y%m%d %H:%M:%S')}])  
                self.savePickle(rt_df, self.df_position, 'position') 

    def queryBinanceUPremiumIndex(self):
        ret = self.client.queryBinanceUPremiumIndex(self.symbol)
        print((f"queryBinanceUPremiumIndex: {self.symbol=}, {ret=}"))

        self.markPrice = ret.result[0].markPrice 

        rt_df = pd.DataFrame([{'symbol': item.symbol, 'markPrice': item.markPrice, 'indexPrice': item.indexPrice, 'estimatedSettlePrice': item.estimatedSettlePrice, 'lastFundingRate': item.lastFundingRate, 'nextFundingTime': item.nextFundingTime, 'interestRate': item.interestRate, 'time': item.time, 'update': time.strftime('%Y%m%d %H:%M:%S')}  for item in ret.result ])  
        self.savePickle(rt_df, self.df_umarkprice, 'umarkprice') 

    def queryUPrice(self):
        global gateway
        ret = self.client.queryUPrice(gateway, self.symbol)
        print((f"queryUPrice: {gateway=}, {self.symbol=}, {ret=}"))

        self.uPrice = ret.result 

        rt_df = pd.DataFrame([{'symbol': self.symbol, 'uPrice': ret.result, 'update': time.strftime('%Y%m%d %H:%M:%S')}  ])  
        self.savePickle(rt_df, self.df_uprice, 'uprice')     

    def deleteAllOrder(self):
        ret = self.client.deleteAllOrder()
        print((f"deleteAllOrder: {ret=}"))        

    def queryLimitOrder(self):
        starttime = int( (datetime.now()- timedelta(days=30) ).strftime("%s000") )
        ret = self.client.queryLimitOrder(starttime)
        print((f"queryLimitOrder: {starttime=}, {ret=}")) 

    def queryAccPx(self):
        self.queryContractAssets() #
        self.queryPositions()  #        
        self.queryBinanceUPremiumIndex()
        self.queryUPrice()

    def savePickle(self, src_df, dest_df, flag):

        pklFile = f"{os.getcwd()}/pkl/{flag}8.pkl"

        if dest_df.empty:
            if os.path.exists(pklFile):
                dest_df = pd.read_pickle(pklFile)

        dest_df = pd.concat([dest_df, src_df], ignore_index=True)
        dest_df.to_pickle(pklFile)


    def handlebackTrade(self):
        global gateway

        positions = self.client.queryPositions(self.symbol)
        print((f"handlebackTrade > queryPositions: {self.symbol=}, {positions=}"))
        if positions.result:
            for posi in positions.result:

                # self.flagDict['side'] = "buy" if posi.positionside == 'short' else "sell"             
                # positionAmount = float( posi.positionAmount)  # handback

                # if (self.sign == 1 and self.flagDict['side'] == "buy") or  (self.sign == -1 and self.flagDict['side'] == "sell"):
                #     ret = self.client.insertMarketUOrder(gateway, posi.symbol, positionAmount, self.flagDict['side'], self.flagDict['positionside'])

                #     # debug.info(f"{self.flagDict=}")
                #     logger.info(f"ret = self.client.insertMarketUOrder('{gateway}',  '{posi.symbol}', '{positionAmount}', '{self.flagDict['side']}' , {self.flagDict['positionside']}), {ret=}")
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

            ret = self.client.insertMarketUOrder(gateway, self.symbol, float(qtyStr), self.flagDict['side'], self.flagDict['positionside'])

            # logger.debug(f"{self.flagDict=}")
            logger.info(f"ret = self.client.insertMarketUOrder('{gateway}',  '{self.symbol}', '{qtyStr}', '{self.flagDict['side']}' , {self.flagDict['positionside']} ), {ret=}")   
            self.tradeCount += 1         

    def openBuy(self, price):
        global gateway
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenBuy'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "buy"

        quantity = float(self.total*(1 + totalAdjRate) )/float(price)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        logger.debug(f"--{self.flagDict['isOpen']=}--{self.total=}--{qtyStr=}--{price=}--")

        if float(qtyStr) >0 and float(self.total) >0:
            ret = self.client.insertMarketUOrder(gateway, self.symbol, float(qtyStr), "buy", self.flagDict['positionside'])

            logger.debug(f"{self.flagDict=}")
            logger.info( f"(ret = self.client.insertMarketUOrder('{gateway}', '{self.symbol}', {qtyStr}, 'buy', {self.flagDict['positionside']} ), {ret=}") 

    def openSell(self, price):
        global gateway
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenSell'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "sell"

        quantity = float(self.total*(1 + totalAdjRate) )/float(price)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        logger.debug(f"--{self.flagDict['isOpen']=}--{self.total=}--{qtyStr=}--{price=}--")

        if float(qtyStr) >0 and float(self.total) >0:

            ret = self.client.insertMarketUOrder(gateway,  self.symbol, float(qtyStr), "sell", self.flagDict['positionside'])

            logger.info(f"ret = self.client.insertMarketUOrder('{gateway}', '{self.symbol}', {qtyStr}, 'sell', {self.flagDict['positionside']} ), {ret=}")

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

                ret = self.client.insertMarketUOrder(gateway,  posi.symbol, posi.positionAmount, side, self.flagDict['positionside'])

                logger.debug(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder("{gateway}",  {posi.symbol}, {posi.positionAmount}, {side}, {self.flagDict["positionside"]} ), {ret=}')

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

                ret = self.client.insertMarketUOrder(gateway,  posi.symbol, posi.positionAmount, side, self.flagDict['positionside'])

                logger.debug(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder("{gateway}",  {posi.symbol}, {posi.positionAmount}, {side}, {self.flagDict["positionside"]}  ), {ret=}')

    def clearance(self):
        global gateway
        self.flagDict['isOpen'] = False
        self.flagDict['isClose'] = True

        positions = self.client.queryPositions(self.symbol)
        print((f"clearance: {self.symbol=}, {positions=}"))
        if positions.result:

            for posi in positions.result:

                side = "buy" if posi.positionside == 'short' else "sell"

                ret = self.client.insertMarketUOrder(gateway, posi.symbol, posi.positionAmount, side, self.flagDict['positionside'])

                logger.debug(f"{self.flagDict=}")
                logger.info(f'ret = self.client.insertMarketUOrder(gateway,  {posi.symbol}, {posi.positionAmount}, {side}, {self.flagDict["positionside"]} ), {ret=}')

    def CleanOverukdf(self, closeSec:int):

        global ukdf
        global histDays

        overDate = time.strftime("%Y%m%d", time.localtime(closeSec-60*60*24*histDays ) )
        ukdf.drop(ukdf.index[(ukdf['tradeDate'] < overDate)], inplace=True)
        ukdf.reset_index(drop=True, inplace=True)

        print(f'\n--ukdf-hist--: {overDate=} \n', ukdf.iloc[0:5,:] ,'\n' , ukdf.iloc[-5:,:],'\n' )

    def handleOrderNew(self, item: OrderType): #处理新订单 data 
        logger.info(f"handleOrderNew: {item=}")

        rt_df = pd.DataFrame([{'symbol': item.symbol, 'clientorderid': item.clientorderid, 'gatewayorderid': item.gatewayorderid, 'quantity': item.quantity, 'price': item.price, 'stopprice': item.stopprice, 'ordertype': item.ordertype, 'side': item.side, 'status': item.status, 'positionside': item.positionside, 'createtime': item.createtime, 'updatetime': item.updatetime, 'tradetype': item.tradetype, 'selfid': item.selfid, 'gatetype': item.gatetype, 'handletime': item.handletime, 'update': time.strftime('%Y%m%d %H:%M:%S')} ])  
        self.savePickle(rt_df, self.df_order, 'order') 


    def handleOrderFilled(self, data: OrderType):  #处理订单完成
        logger.info(f"handleOrderFilled: {data=}")

        if data.filltrades:
            self.total = float(data.filltrades[0].quantity)*float(data.filltrades[0].price) -float(data.filltrades[0].commission) 

            rt_df = pd.DataFrame([{'symbol': item.symbol, 'tradeid': item.tradeid, 'clientorderid': item.clientorderid, 'side': data.side, 'price': item.price, 'quantity': item.quantity, 'commission': item.commission, 'commissionasset': item.commissionasset, 'tradetime': item.tradetime,  'tradetype': item.tradetype, 'gatetype': item.gatetype, 'handletime': item.handletime, 'update': time.strftime('%Y%m%d %H:%M:%S')}  for item in data.filltrades ])  
            self.savePickle(rt_df, self.df_filltrades, 'filltrades')
            
        self.queryContractAssets() 
        self.queryPositions()  

    def handleOrderCanceled(self, data: OrderType):  #处理订单取消
        logger.error(f"handleOrderCanceled: {data=}")
        
        self.queryContractAssets() 
        self.queryPositions()       
        
    def handleOrderRejected(self, data: OrderType):  #处理订单取消拒绝
        logger.error(f"handleOrderRejected: {data=}")

        self.queryContractAssets() 
        self.queryPositions()        
        
    def handleOrderExpired(self, data: OrderType):  #处理订单被撤销
        logger.error(f"handleOrderExpired: {data=}")

        self.queryContractAssets() 
        self.queryPositions()       
        
    def handleError(self, data): #处理错误
        
        logger.error(f"handleError: {data=}")
        self.queryContractAssets() 
        self.queryPositions()       

    def handleRiskLimit(self, data): #风控
        
        logger.error(f"handleRiskLimit: {data=}")
        self.queryContractAssets() 
        self.queryPositions()    

    def handleTick(self, data:SubTickType):
        logger.info(f"tick opentime:{data.tick.opentime // 1000} closeprice:{data.tick.closeprice}")

    def handleTimer(self, data:TimeridType):
        global gateway
        self.count += 1 
        hhmm = int(datetime.now().strftime("%H%M"))
        nowTime = datetime.now()
        diffTime = (nowTime - self.iniTime).seconds

        logger.info(f"handleTimer: {self.count=} : {self.curTimeSec=} : {hhmm=} : {diffTime=} : {data=}")

        if int(time.time()) - self.curTimeSec < 60:
            return
        else:
            self.curTimeSec = int(time.time())

        if hhmm == 1610 and not self.flagDict['isOpen']:
            self.queryAccPx()
            price = max(float(self.uPrice), float(self.markPrice))
            logger.info(f"--{hhmm=}--{self.flagDict['isOpen']=}--{price=}--")
            self.openBuy(price)
            time.sleep(5)
            self.queryAccPx()

        elif hhmm == 1620 and not self.flagDict['isClose']:
            self.queryAccPx()
            logger.info(f"--{hhmm=}--{self.flagDict['isClose']=}--")
            self.clearance()
            time.sleep(5)
            self.queryAccPx()

    def handleTimer2(self, data:TimeridType):
        global gateway
        self.count += 1 
        logger.info(f"handleTimer: {self.count=} : {data=}")

        if self.count >= 41: 
            return 
        
        qtyStr =  "0.001" 
        if self.count % 10 == 5:  # and self.count <= 2
            # self.handlebackTrade()   
            
            self.queryAccPx() #  queryContractAssets  queryPositions queryBinanceUPremiumIndex queryUPrice 

            side = "buy"  

            print(f"self.client.insertMarketUOrder({gateway}, {self.symbol}, {float(qtyStr)}, {side}, 2)")
            ret = self.client.insertMarketUOrder(gateway, self.symbol, float(qtyStr), side, 2) # positionside 单向持仓 2:NONE
            logger.info(f"self.client.insertMarketUOrder({gateway}, {self.symbol}, {float(qtyStr)}, {side}, 2), {ret =} ")
            self.insertFactor() 

            self.queryAccPx() #  queryContractAssets  queryPositions queryBinanceUPremiumIndex queryUPrice    

        elif self.count % 10 == 0:  
            self.queryAccPx() #  queryContractAssets  queryPositions queryBinanceUPremiumIndex queryUPrice    

            side = "sell"  

            print(f"self.client.insertMarketUOrder({gateway}, {self.symbol}, {float(qtyStr)}, {side}, 2)")
            ret = self.client.insertMarketUOrder(gateway, self.symbol, float(qtyStr), side, 2) # positionside 单向持仓 2:NONE
            logger.info(f"self.client.insertMarketUOrder({gateway}, {self.symbol}, {float(qtyStr)}, {side}, 2), {ret =} ")
            self.insertFactor()   

            self.queryAccPx() # handler queryContractAssets  queryPositions queryBinanceUPremiumIndex queryUPrice    

def getuklines(cli):
    global ukdf
    global interval
    global intervalSec
    global limit
    global histDays
    global logger
    global symbol
    global gateway
    
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

        print(f'{count=}:', f"cli.uklines({gateway},", f'{symbol=}', ',', f'{interval=}', ',', f'{limit=}', ',', f'{Sec*1000+999=}', ', end=', f'{(Sec+intervalSec*limit-1)*1000+999}' , ' )')

        ukRet = cli.uklines(gateway, symbol=symbol, interval=interval, limit=limit, start=Sec*1000+999, end=(Sec+intervalSec*limit-1)*1000+999 )

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
        ukdfHistCp['dateTime'] = ukdfHistCp['closeSec'].apply(lambda x: datetime.fromtimestamp(x))
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
    global thd
    global symbol
    global df_panel
    global gateway

    input_pro = '-n <name> -s <serverPort> -c <clientPort> -X <symbol> -p <period> -w <wid> -d <day>  -T <thd> -t <total>'
    try:
        # 优先级i>d>args
        opts, args = getopt.getopt(argv, "n:s:c:X:p:w:I:d:T:t:",
                        ["name",'serverPort','clientPort',"symbol","period","wid","day","thd","total"])
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
        elif opt in ("-T", '--thd'):
            thd = float(arg)
            
        elif opt in ("-s", '--serverPort'):
            serverPort = int(arg)
        elif opt in ("-c", '--clientPort'):
            clientPort = int(arg)

    handler = StrategyHandler(name, symbol, total)
    cli = FILClient(handler, timeout=(3, 5), server_url="http://127.0.0.1:%d/strategy" % serverPort, listen_port=clientPort)
    cli.start()

    #cli.cancelAllSubKlines()
    curDate = time.strftime("%Y%m%d")
    logger = make_logger(name, log_level=logging.DEBUG, log_file= name +"_" + str(curDate)+".log")

    logger.info(f'--cli.start()--{version}--{curDate}--{gateway}--')

    # getuklines(cli)
    # handler.getModel()

    handler.queryAccPx() # queryContractAssets  queryPositions queryBinanceUPremiumIndex queryUPrice

    # cli.cancelSubKline(gateway, tradeType, symbol, '30m')
    #cli.cancelAllSubKlines()
    # cli.subKline(gateway, tradeType, symbol, interval)
    
    # cli.subKline(gateway, "usdt", "BTCUSDT", "30m")
    
    cli.subOrderReport(gateway) # # cli.subOrderReport(gateway, 0)

    #cli.cancelAllSubTicks()
    # cli.subTick(gateway, "usdt", "BTCUSDT")
    
    # qtyStr = "0.001" 
    # side = "sell"
    # price = "26000"  
    # ret = cli.insertLimitUOrder(gateway, symbol, float(qtyStr), float(price), side, 2) # positionside 单向持仓 2:NONE
    # logger.info(f"2. cli.insertLimitUOrder({gateway}, {symbol}, {float(qtyStr)}, {float(price)}, {side}, 2), {ret =} ")


    # qtyStr = "0.001" 
    # side = "buy" 
    # ret = cli.insertMarketUOrder(gateway, symbol, float(qtyStr), side, 2) # positionside 单向持仓 2:NONE
    # logger.info(f"1. cli.insertMarketUOrder({gateway}, {symbol}, {float(qtyStr)}, {side}, 2), {ret =} ")


    handler.queryLimitOrder()
    # handler.deleteAllOrder()
    # handler.queryLimitOrder()


    # cli.cancelSubTimer(1*1000*60) 
    cli.subTimer(1*1000*60)


    while True:
        time.sleep(60*60)

def main(argv):
    run(argv)

if __name__ == '__main__':
    print('__main__: ', sys.argv)
    main(sys.argv[1:])


# nohup python3 -u main_kline8.py -n testrisk8 -s 8889 -c 39095 -X BTCUSDT -p 3m -w 40 -d 3 -T 0.5 -t 5000  >> log_kline8.log 2>&1 &

# nohup python3 -u main_risk2.py -n testrisk2 -s 8889 -c 39192 -X BTCUSDT -p 3m -w 40 -d 3 -T 0.5 -t 7500  >> log_risk2.log 2>&1 &

