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

from scipy.signal import argrelextrema
import statsmodels.formula.api as smf

from FIL_lib.my_logger import make_logger, logging
from FIL_lib.client import FILClient, Handler
from FIL_lib.core_types import *

warnings.filterwarnings('ignore')
# plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
# plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

# =============== 配置策略参数

gateway = "simulator"
# name = "percentile_regression_"
# interval = "30m" #period #1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h, 8h, 12h, 1d, 3d, 1w, 1M
intervalCoef = {'m':60, 'h':60*60, 'd': 60*60*24, 'w':60*60*24*7, 'M':60*60*24*30}
# intervalSec = int(interval[0:-1]) * intervalCoef[interval[-1] ]
tradeType = "usdt"

totalAdjRate = -3e-3 # -1e-3 -3e-3
# histDays = 120  # 30 10 84 120 60 2
limit = 998 # 1500  499 998
# 多少个window计算
# wid = 140  # 用在percentile_regression.py上面进行计算数据
# wid2 = 20  # 持仓多少个周期
# thd = 10  # 阈值0  0.6  0.55


ukdf = pd.DataFrame()

# [opentime, tradetime, position_p, qty] 建仓k线时间，成交时间，持仓周期，成交数量[带方向]
df_positions = pd.DataFrame()

version = '1.0.0'

# print('\n--init--: ', f'{version=}, {gateway=}, {name=}, {symbol=}, {interval=}, {intervalCoef=}, {intervalSec=}, {tradeType=}, {total=}, {histDays=}, {wid=},{limit=}', '\n')

# ===============

curDate = time.strftime("%Y%m%d")
# logger = make_logger(name, log_level=logging.DEBUG, log_file= name + "_"+ str(curDate)+".log")
logger = ''



def func_max(idx, df):
    idx = [int(i) for i in idx]
    ds = df.iloc[idx]
    ds.reset_index(drop=True,inplace=True)
    df_id = ds.copy()

    # Find local peaks
    n = 5
    df_id['max'] = df_id.iloc[argrelextrema(df_id.close.values, np.greater_equal, order=n)[0]]['close']
    df_max = df_id[~np.isnan(df_id['max'])]
    df_max['x'] = df_max.index
    mod = smf.quantreg('max ~ x', df_max)
    res = mod.fit(q=.9)
    slope_max = res.params['x']

    return slope_max

def func_min(idx, df):

    idx = [int(i) for i in idx]
    ds = df.iloc[idx]
    ds.reset_index(drop=True,inplace=True)
    df_id = ds.copy()

    # Find local peaks
    n = 5
    df_id['min'] = df_id.iloc[argrelextrema(df_id.close.values, np.less_equal, order=n)[0]]['close']

    df_min = df_id[~np.isnan(df_id['min'])]
    df_min['x'] = df_min.index
    mod = smf.quantreg('min ~ x', df_min)
    res = mod.fit(q=.1)
    slope_min = res.params['x']
    return slope_min


class StrategyHandler(Handler):
    def __init__(self, name, symbol, total, wid, wid2, thd):
        # super().__init__(name)
        self.wid = wid
        self.wid2 = wid2
        self.thd = thd
        self.name = name
        self.total = total
        self.symbol = symbol


        self.count = self.tradeCount = 0
        self.curDate = time.strftime("%Y%m%d")
        self.tradeDate = self.openTime = self.closeTime = self.closeSec = self.openSec = self.open = self.close = ''

    def get_signal(self, curKline):

        global ukdf
        thd = self.thd
        wid = self.wid
        local_open = time.localtime(curKline.opentime / 1000)
        ukdf.loc[ukdf.index[-1] + 1] = {
            'daytime': time.strftime('%Y/%m/%d %H:%M:%S', local_open),
            'open': curKline.openprice,
            'high': curKline.highprice,
            'low': curKline.lowprice,
            'close': curKline.closeprice,
            'ymd': time.strftime("%Y%m%d", local_open),
            'hms': time.strftime("%H%M%S", local_open)
        }
        ukdf.drop(ukdf.index[0], inplace=True)
        df_id = ukdf.copy()
        df_id['pct'] = df_id['close'] / df_id['close'].shift(1) - 1
        df_id.fillna(0, inplace=True)
        df_id['index'] = df_id.index
        df_id['min_s'] = df_id['index'].rolling(int(wid)).apply(lambda x: func_min(x, df_id))
        df_id['max_s'] = df_id['index'].rolling(int(wid)).apply(lambda x: func_max(x, df_id))
        df_id = df_id[['daytime', 'hms', 'close', 'pct', 'min_s', 'max_s']]
        df_id['pct_5'] = df_id['close'].shift(-5) / df_id['close'] - 1
        df_id['pct_10'] = df_id['close'].shift(-10) / df_id['close'] - 1
        df_id['pct_20'] = df_id['close'].shift(-20) / df_id['close'] - 1
        con_2 = (df_id['max_s'] < -thd) & (df_id['max_s'] > -3 * thd) & (df_id['min_s'] > thd) & (
                    df_id['min_s'] < 3 * thd)
        con_3 = (df_id['max_s'] < thd) & (df_id['max_s'] > -thd) & (df_id['min_s'] > -3 * thd) & (df_id['min_s'] < -thd)
        df_id['factor'] = 0
        df_id['factor'][con_2] = 1
        df_id['factor'][con_3] = 1
        return df_id['factor'].iloc[-1]

    def handleKline(self, data:KlineType):
        # logger.debug(f"handleKline: data={data}")


        global ukdf

        global version
        global curDate
        global logger

        global df_positions
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

        # print('--handleKline--: ', f"{version=}, {self.name=}, {self.symbol=}, {interval=}, {intervalSec=}, {wid=}, {thd=}, {self.sign=}, {self.total=}, {self.flagDict['side']=}, {self.tradeCount=}, {self.count=}")
        # print(f'{self.closeSec=}, {self.tradeDate=}, {self.openTime=}, {self.closeTime=}, {self.symbol=}, {self.open=}, {self.close=}, {self.high=}, {self.low=}, {self.vol=}, {self.amt=} ' )

        self.count += 1
        factor = self.get_signal(data)
        df_positions['position_p'] = df_positions['position_p'] + 1
        # 选择持仓周期满的记录， 理论上最多只有一条,
        con = df_positions['position_p'] >= self.wid2
        balance = self.total / (self.wid2 - len(df_positions))
        df_close = df_positions[con]
        if factor == 1:
            if len(df_close):
                # 如果有记录，则重新计算开仓周期
                df_positions.loc[con, 'position_p'] = 0
            else:
                # 没有满周期的记录则新开仓
                # 真实交易环境需要考虑委托失败的情况
                self.openBuy(balance, self.close)
        else:
            for idx, row in df_close.iterrows():
                # 真实交易环境需要考虑委托失败的情况
                self.closeBuy(float(row['qty']))
            df_positions.drop(df_close)

    def insertFactor(self):
        curDateTime = int(time.strftime("%m%d%H%M")) #"%Y%m%d%H%M%S" %y%m%d%H%M
        
        factor = f"name:{self.name}, symbol:{self.symbol}, tradeDate:{self.tradeDate}, closeTime:{self.closeTime}, close:{self.close}, sign:{self.sign}, total:{self.total}, side:{self.flagDict['side']} "

        self.client.insertFactor(curDateTime, factor)

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

    def openBuy(self, balance, close):
        global gateway
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenBuy'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "buy"

        quantity = float(balance * (1 + totalAdjRate) )/float(close)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        ret = self.client.insertMarketUOrder(gateway, self.symbol, float(qtyStr), "buy")

        logger.debug(f"{self.flagDict=}")
        logger.info(f'ret = self.client.insertMarketUOrder("{gateway}", "{self.symbol}", {qtyStr}, "buy"), {ret=}')

    def closeBuy(self, qyt):
        self.flagDict['isOpen'] = False
        self.flagDict['isClose'] = True
        self.flagDict['isOpenBuy'] = False
        self.flagDict['isCloseBuy'] = True
        self.flagDict['side'] = "sell"
        side = "sell"
        ret = self.client.insertMarketUOrder("simulator",  self.symbol, qyt, side)

        logger.info(f"{self.flagDict=}")
        logger.info(f'ret = self.client.insertMarketUOrder("simulator",  {self.symbol}, {qyt}, {side} ), {ret=}')

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
        global df_positions
        global ukdf
        corr = 1
        if data.filltrades:
            #
            qty = float(data.filltrades[0].quantity)
            if OrderSideEnum.index(data.side)  == 1:
                corr = -1
                # opentime, tradetime, position_p, qty] 建仓k线时间，成交时间，持仓周期，成交数量[带方向]
                df_positions.loc[df_positions.index[-1] + 1] = \
                    [ukdf.loc[ukdf.index[-1]]['daytime'],
                     data.filltrades[0].tradetime,
                     0,
                     qty
                    ]

            self.total = self.total + corr * abs(qty) *float(data.filltrades[0].price)
            self.total = self. total - abs(float(data.filltrades[0].commission))

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

    global limit
    global curDate
    global logger
    global gateway
    global intervalCoef


    input_pro = '-n <name> -s <serverPort> -c <clientPort> -X <symbol> -p <period> -w <wid> -I <wid2> -T <thd> -t <total>'
    try:
        # 优先级i>d>args
        opts, args = getopt.getopt(argv, "n:s:c:X:p:w:I:T:t:",
                        ["name",'serverPort','clientPort',"symbol","period","wid","wid2","thd","total"])
        print(f'{opts}')
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
        # K线级别
        elif opt in ("-p", '--period'):
            interval = arg
            # 讲时间转换为秒
            intervalSec = int(interval[0:-1]) * intervalCoef[interval[-1] ]
        # 计算时用多少根k线
        elif opt in ("-w", '--wid'):
            wid = int(arg)
        # 持仓多长周期
        elif opt in ("-I", '--wid2'):
            wid2 = int(arg)
        elif opt in ("-T", '--thd'):
            thd = float(arg)
        elif opt in ("-s", '--serverPort'):
            serverPort = int(arg)
        elif opt in ("-c", '--clientPort'):
            clientPort = int(arg)

    handler = StrategyHandler(name, symbol, total, wid, wid2, thd)
    cli = FILClient(handler, timeout=(3, 5), server_url="http://127.0.0.1:%d/strategy" % serverPort, listen_port=clientPort)
    cli.start()

    curDate = time.strftime("%Y%m%d")
    logger = make_logger(name, log_level=logging.DEBUG, log_file= name +"_" + str(curDate)+".log")

    logger.info(f'--cli.start()--{version}--{curDate}--')

    curSec = int(time.time())
    #
    histSec = int(time.mktime(time.strptime(time.strftime("%Y%m%d", time.localtime(time.time()- (wid+1) * intervalSec ) ), '%Y%m%d'))) -1

    totalCount = math.ceil( (curSec - histSec )/intervalSec )
    logger.info(f'{interval=}, {histSec=}, {curSec=}, {intervalSec=}, {limit}, {intervalSec*limit}, {totalCount=}, {wid}')
    # 'daytime': time.strftime('%Y/%m/%d %H:%M:%S', local_open),
    # 'open': curKline.openprice,
    # 'high': curKline.highprice,
    # 'low': curKline.lowprice,
    # 'close': curKline.closeprice,
    # 'ymd': time.strftime("%Y%m%d", local_open),
    # 'hms': time.strftime("%H%M%S", local_open),

    ukdfHist = pd.DataFrame(columns=['daytime', 'open', 'high', 'low', 'close', 'ymd',  'hms'])

    count = 1
    for Sec in range(histSec, curSec, intervalSec*limit):

        print(f'{count}:', "cli.uklines('binance',", f'{symbol}', ',', f'{interval}', ',', f'{limit}', ',', f'{Sec*1000+999}', ', end=', f'{(Sec+intervalSec*limit-1)*1000+999}' , ' )')

        ukRet = cli.uklines('binance', symbol=symbol, interval=interval, limit=limit, start=Sec*1000+999, end=(Sec+intervalSec*limit-1)*1000+999 )

        kdf = pd.DataFrame([{'daytime': time.strftime('%Y/%m/%d %H:%M:%S', time.localtime(rs.opentime/1000) ),
                             'open': float(rs.openprice), 'high': float(rs.highprice),
                             'low': float(rs.lowprice), 'close': float(rs.closeprice),
                             'ymd': time.strftime("%Y%m%d", time.localtime(rs.opentime/1000) ),
                             'hms': time.strftime("%H%M%S", time.localtime(rs.opentime/1000) )
                             }
                            for rs in ukRet.result])
        ukdfHist = pd.concat([ukdfHist,kdf],ignore_index=True)
        del kdf

        count += 1
        time.sleep(3)


    logger.debug(f'ukdfHist.iloc[:5,:] :\n{ukdfHist.iloc[:5,:]}')
    logger.debug(f'ukdfHist.iloc[-5:,:] :\n{ukdfHist.iloc[-5:,:]}')
    # 最后一根K线不全，忽略掉
    ukdf = ukdfHist[:-1]


    logger.info(f'ukdf.iloc[:5,:] :\n{ukdf.iloc[:5,:]}')
    logger.info(f'ukdf.iloc[-5:,:] :\n{ukdf.iloc[-5:,:]}')  
    
    cli.cancelAllSubKlines()
    cli.subKline(gateway, tradeType, symbol, interval)
    cli.subOrderReport(gateway)

    cli.cancelAllSubTicks()

    while True:
        time.sleep(60*60)

def main(argv):
    run(argv)

if __name__ == '__main__':
    print('__main__: ', sys.argv)
    main(sys.argv[1:])

# nohup python3 -u main.py -n s_rsrs -s 8808 -c 29097 -X BTCUSDT -p 4h -w 25 -w 90 -d 120 -T 0.6 -t 1000000 >> log.txt 2>&1 & 

# python3 -u main.py -n s_rsrs -s 8808 -c 29097 -X BTCUSDT -p 4h -w 25 -I 90 -d 120 -T 0.6 -t 1000000

