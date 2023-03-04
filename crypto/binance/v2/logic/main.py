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

gateway = "simulator"
name = "logic"
symbol = "BTCUSDT"
interval = "30m" #period #1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h, 8h, 12h, 1d, 3d, 1w, 1M
intervalCoef = {'m':60, 'h':60*60, 'd': 60*60*24, 'w':60*60*24*7, 'M':60*60*24*30}
intervalSec = int(interval[0:-1]) * intervalCoef[interval[-1] ]
tradeType = "usdt"

total = 1000 #
totalAdjRate = -3e-3 # -1e-3 -3e-3
histDays = 120  # 30 10 84 120 60 2 
limit = 998 # 1500  499 998
wid = 40  #  42  108  83
thd = 0.55  # 阈值0  0.6 


ukdf = pd.DataFrame()
df_panel = pd.DataFrame()

version = '2.0.2'

print('\n--init--: ', f'{version=}, {gateway=}, {name=}, {symbol=}, {interval=}, {intervalCoef=}, {intervalSec=}, {tradeType=}, {total=}, {histDays=}, {wid=},{limit=}', '\n')

# ===============

curDate = time.strftime("%Y%m%d")
# logger = make_logger(name, log_level=logging.DEBUG, log_file= name + "_"+ str(curDate)+".log")
logger = ''


def fun_upvar(idx, df):
    idx = [int(i) for i in idx]
    dfs = pd.DataFrame(df['pct'][idx])
    ret = np.std(dfs['pct'][dfs['pct']>0])
    return ret

def fun_upvol(idx, df):
    idx = [int(i) for i in idx]
    dfs = pd.DataFrame(df.iloc[idx])
    ret = np.sum(dfs['amount'][dfs['pct']>0])/np.sum(dfs['amount'])
    return ret

def fun_downvar(idx, df):
    idx = [int(i) for i in idx]
    dfs=pd.DataFrame(df['pct'][idx])
    ret = np.std(dfs['pct'][dfs['pct']<0])
    return ret

def get_nav(df_input):
    print("feature computing...")
    time_x = time.perf_counter()
    df_s = df_input.copy()
    df_s['pct'] = df_s['close']/df_s['close'].shift(1) - 1  # 前收  前涨跌幅 # df_s['close'].shift(1) 昨收 # shift(1) +下移
    df_s['close_next'] = df_s['close'].shift(-1) # 后收盘价  # shift(-1) -上移
    df_s['pct_next_'] = df_s['close'].shift(-1) / df_s['close'] - 1 # 后涨跌幅  pct上移
    df_s['pct_change'] = df_s['pct'].shift(-1)  # df_s['pct_next_']

    df_s['max_ret'] = df_s['close']/df_s['close'].rolling(365).max()-1
    df_s['skew'] = df_s['pct'].rolling(365).skew()
    df_s['kurt'] = df_s['pct'].rolling(365).kurt()
    df_s[['vol']] = df_s[['pct']].rolling(365).var()
    df_s['p_v_corr'] = df_s['close'].rolling(365).corr(df_s['amount'])
    df_s['pct_v_corr'] = df_s['pct'].rolling(365).corr(df_s['amount'])
    print("time used is ",time.perf_counter()-time_x)

    # up_var
    print("upvar computing...")
    time_x = time.perf_counter()
    df_s['index']=df_s.index
    df_s['upvar'] = df_s['index'].rolling(365).apply(lambda x: fun_upvar(x, df_s))
    df_s['upvol'] = df_s['index'].rolling(365).apply(lambda x: fun_upvol(x, df_s))

    df_s['downvar'] = df_s['index'].rolling(365).apply(lambda x: fun_downvar(x, df_s))
    print("time used is ", time.perf_counter() - time_x)

    # max_drawdown
    print("max drawdown computing")
    time_x = time.perf_counter()
    df_s[['max_drawdown']] = df_s[['pct']].rolling(365).min()
    print("time used is ", time.perf_counter() - time_x)

    # mom
    print("momentum computing...")
    time_x = time.perf_counter()
    df_s['mom_5'] =df_s['close']/df_s['close'].shift(5) - 1
    df_s['mom_30'] = df_s['close'] / df_s['close'].shift(30) - 1
    df_s['mom_60'] = df_s['close'] / df_s['close'].shift(60) - 1
    df_s['ma_7']=df_s['close'].rolling(7).mean()
    df_s['ma_30'] = df_s['close'].rolling(30).mean()
    df_s['ma_120'] = df_s['close'].rolling(120).mean()
    print("time used is ", time.perf_counter() - time_x)

    #   status
    print("status computing...")
    time_x = time.perf_counter()
    df_s['status']=np.where((df_s['close'].rolling(7).mean()>df_s['close'].rolling(30).mean())
                            &(df_s['close'].rolling(30).mean()>df_s['close'].rolling(90).mean())
                            &(df_s['close'].rolling(90).mean()>df_s['close'].rolling(180).mean())
                            ,1,0)
    df_s['status'] = np.where((df_s['close'].rolling(7).mean() < df_s['close'].rolling(30).mean())
                              & (df_s['close'].rolling(30).mean() < df_s['close'].rolling(90).mean())
                              & (df_s['close'].rolling(90).mean() < df_s['close'].rolling(180).mean())
                              , -1, df_s['status'])

    print("time used is ", time.perf_counter() - time_x)
    # alpha compute
    print("alpha computing...")
    time_x = time.perf_counter()

    # RSV技术指标变种
    part1 = (df_s['high'].rolling(window=30, min_periods=30).max() - df_s['close']) / \
            (df_s['high'].rolling(window=30, min_periods=30).max() - \
             df_s['low'].rolling(window=30, min_periods=30).min()) * 100
    df_s['alpha47'] = part1.ewm(adjust=False, alpha=float(1) / 9, min_periods=0, ignore_na=False).mean()
    df_s['alpha58'] = (df_s['close'].diff(1) > 0.0).rolling(window=240, min_periods=240).sum() / 240.0 * 100
    part1 = (np.maximum(df_s['close'].diff(1), 0.0)).ewm(adjust=False, alpha=float(1) / 50, min_periods=0, ignore_na=False).mean()                                         
    part2 = (abs(df_s['close'].diff(1))).ewm(adjust=False, alpha=float(1) / 50, min_periods=0, ignore_na=False).mean()          
    df_s['alpha67'] = part1 / part2

    # SMA((TSMAX(HIGH,6)-CLOSE)/(TSMAX(HIGH,6)-TSMIN(LOW,6))*100,15,1)
    part1 = (df_s['high'].rolling(window=40, min_periods=40).max() - df_s['close']) / \
            (df_s['high'].rolling(window=40, min_periods=40).max() - df_s['low'].rolling(window=40, min_periods=40).min())
    df_s['alpha72'] = part1.ewm(adjust=False, alpha=float(1) / 15, min_periods=0, ignore_na=False).mean()

    print("time used is ", time.perf_counter() - time_x)

    print("data saving...")
    # drop na
    df_s.dropna(how='any', inplace=True)
    # df_s.to_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\tsc_dnn\results\feature_v1.csv",index=False)

    # regression
    print(" feature testing")
    col_list = ['skew','max_ret','kurt','vol','upvar','upvol','downvar','max_drawdown','mom_5','mom_30','mom_60','p_v_corr','pct_v_corr',  'alpha72','alpha67','alpha58','alpha47']
               
    # col_list = ['alpha3','alpha11','alpha22','alpha24','alpha23','alpha27','alpha29','alpha76','alpha72','alpha71','alpha69'
    #             ,'alpha67','alpha65','alpha59','alpha58','alpha57','alpha55'
    #             ,'alpha53','alpha52','alpha51','alpha50','alpha47']
    col_list = pd.DataFrame(col_list)
    col_list['r2'] = 0
    for index_col,row_col in col_list.iterrows():
        ret = stats.linregress(df_s[row_col[0]], df_s['pct_next_'])
        col_list['r2'].iloc[index_col] = ret[2]**2
        # print(row_col[0],"k is:", ret[0], "r^square is :", ret[2] ** 2)
    # col_list.to_excel(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\tsc_dnn\results\r2.xlsx",index=False)
    
    logger.debug(f'col_list :\n{col_list}')
    col_list.to_pickle(f"bak/col_list.pkl" )
  
    return df_s

def create_X_Y(ts, lag=1, n_ahead=1, target_index=0) -> tuple:
    ts_0,ts_1=ts[0],ts[1]
    # Creating placeholder lists
    X1,Y = [], []

    if len(ts_0) - lag <= 0:
        X1.append(ts_0)
    else:
        for i in range(len(ts_0)):
            if i<lag:
                continue
            Y.append(ts_0[(i):(i+1), target_index])
            X1.append(ts_1[(i):(i + 1), :])

    X1,Y = np.array(X1), np.array(Y)
    # Reshaping the X array to an RNN input shape
    X1 = np.reshape(X1, (X1.shape[0],X1.shape[2]))
    return X1, Y

def logicpred(df_s):
    global thd
    # parameter
    lag_list = [8]
    batch_size=[32,16,64]
    n_layer=[64,256,128]
    df_para = pd.DataFrame(list(product(lag_list, batch_size, n_layer)))  # 9
    df_para.columns=['lag','batch','layer']
    df_para['acc']=0
    df_para=pd.concat([df_para,df_para,df_para,df_para,df_para,df_para,df_para,df_para,df_para,df_para,df_para,df_para])  # 108 = 9*12
    df_para.sort_values(by=['lag','batch','layer'],ascending=False,inplace=True)
    df_para.reset_index(drop=True,inplace=True)
    # print(df_para)

    df_plot=pd.DataFrame()
    for index_para,row_para in df_para.iterrows():
        # 0      8     64    256    0  : lag 8  batch 64  layer 256  acc 0
        
        # data = pd.read_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\tsc_dnn\results\feature_v1.csv")
        data = df_s.copy()
        data['pct_'] = data['pct_next_'].shift(1)
        data.dropna(how='any', inplace=True)
        del data['date']
        # print(data.columns)
        # features_0 = ['pct_next_', 'skew','max_ret','kurt','vol','upvar','upvol','downvar','max_drawdown'
        #             ,'alpha3','alpha11','alpha22','alpha24','alpha23','alpha27','alpha29','alpha76','alpha72','alpha71','alpha69'
        #             ,'alpha67','alpha65','alpha59','alpha58','alpha57','alpha55'
        #             ,'alpha53','alpha52','alpha51','alpha50','alpha47']
        # features_0 = ['pct_next_', 'skew', 'kurt', 'vol', 'upvar', 'upvol', 'downvar']
        # print(data.columns)
        features_0 = ['pct_next_']
        # features_1=['pct_']
        features_1 = [ 'pct_', 'close','mom_5','mom_30','mom_60','ma_7','ma_30','ma_120']
        features=features_0+features_1
        data_pct=data[['pct_change','pct_next_']]
        ts=[np.array(data[features_0]),np.array(data[features_1])]

        ################################3
        # Number of lags (hours back) to use for models
        lag = int(row_para[0])
        # Steps ahead to forecast
        n_ahead = 1
        # Share of obs in testing
        test_share = 0.1

        # Subseting only the needed columns

        ts = data[features]
        nrows = ts.shape[0]
        # Spliting into train and test sets
        train = ts[0:int(nrows * (1-test_share))]  # 0.1 0.9
        test = ts[int(nrows * (1-test_share)):]
        # Scaling the data
        train_max = train.max()
        train_min = train.min()
        train = (train - train_min) / (train_max - train_min)
        test = (test - train_min) / (train_max - train_min)


        # Creating the final scaled frame
        ts_s = pd.concat([train, test])
        pct_median = np.median(ts_s['pct_next_'].iloc[0:int(nrows * (1 - test_share))])
        ts_s['pct_next_']=np.where(ts_s['pct_next_']>pct_median,1,0)

        # Creating the X and Y for training
        X, Y = create_X_Y([np.array(ts_s[features_0]),np.array(ts_s[features_1])], lag=lag, n_ahead=n_ahead)

        # Spliting into train and test sets
        Xtrain, Ytrain = X[0:int(X.shape[0] * (1-test_share))], Y[0:int(X.shape[0] * (1-test_share))]

        model = LogisticRegression()
        model.fit(Xtrain, Ytrain)

        train_score = model.score(Xtrain, Ytrain)
        X_test, y_test = X[int(X.shape[0] * (1 - test_share)):], Y[int(X.shape[0] * (1 - test_share)):]
        cv_score = model.score(X_test, y_test)
        y_pred = pd.DataFrame(model.predict(X_test))
        y_pred.columns=['pred']
        y_prob = pd.DataFrame(model.predict_proba(X_test))
        y_pred['prob_0'],y_pred['prob_1'] = y_prob[0],y_prob[1]
        y_pred['actual'] = pd.DataFrame(y_test)
        y_pred['acc'] = np.where(y_pred['pred'] == y_pred['actual'], 1, 0)
        print(np.mean(y_pred['acc']))

        # print('train_score:{0:.6f}'.format(train_score))
        # print('test_score:{0:.6f}'.format(cv_score))


        # # Training of the model
        # history = model.train()
        # y_output = model.predict(Xval)
        # df = pd.concat([pd.DataFrame(y_output * (train_max.iloc[0] - train_min.iloc[0])+train_min.iloc[0]),
        #                 pd.DataFrame(Yval *  (train_max.iloc[0] - train_min.iloc[0])+train_min.iloc[0])], axis=1)
        # df.columns=['pred','actual']
        # # plt.plot(df['pred'],'r-')
        # # plt.plot(df['actual'],'b-')
        # # plt.show()
        # # check accuracy
        
        col_list = ['pred','actual']
        df = y_pred.copy()
        df_pct=data_pct.iloc[-df.shape[0]:,:]
        df_pct.reset_index(drop=True,inplace=True)
        df.reset_index(drop=True,inplace=True)
        df['pct_change']=df_pct['pct_change']
        # df.to_excel("df.xlsx", index=False)
        df.to_pickle(f"bak/df.pkl" )
        
        for col in col_list: #  ['pred','actual']
            # df[col]=df[col]/df[col].shift(1) - 1
            df[col]=np.sign(df[col]) 

        df['acc']=np.where(df['pred']==df['actual'],1,0)
        print('acc is :',np.mean(df['acc']))
        df_para['acc'].iloc[index_para]=np.mean(df['acc'])
        # print(df_para)
        # break

        # case 1
        # df['nav'] = np.where(df['pred'] == 0, -df['pct_change'], df['pct_change'])
        # df['sign'] = np.sign(df['pred'])
        # df['cost_'] = np.where(df['sign'] == df['sign'].shift(1), 0, -0.0000)
        # df['nav'] = (df['nav'] + df['cost_'] + 1).cumprod()
        # df['bm'] = (df['pct_change'] + 1).cumprod()

        # case 2
        # threshold = 0.55
        threshold = thd # 0.55
        df['nav'] = np.where(df['prob_1']>threshold,-1,np.where(df['prob_0']>threshold,1,np.nan))
        # df['nav_0'] = df['nav']
        df.fillna(method='pad',inplace=True)
        df['sign'] = np.sign(df['nav'])

        df['cost_'] = np.where(df['sign'] == df['sign'].shift(1), 0, -0.0016)
        df['nav'] = df['nav'] * df['pct_change']
        df['nav'] = (df['nav'] + df['cost_'] + 1).cumprod()  # 累积乘积
        df['bm'] = (df['pct_change'] + 1).cumprod()  # 累积乘积

        # if index_para==0:
        #     df_plot=df[['nav']]
        #     df_plot.columns=[str(index_para)]
        # else:
        #     # df_plot[str(index_para)] = 0
        #     df_plot['nav'+str(index_para)]=df['nav']
        # df.to_excel("df_plot.xlsx")
        
        # plt.plot(df['nav'])
        # plt.plot(df['bm'])
        # plt.legend(['nav','bm'])
        # plt.show()      
       
        return df
        # break

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
        
        self.getModel()
        self.queryPositions()
        
        # curSign = int(df_panel['sign'].iloc[-1])
        curSign = 0 if np.isnan(df_panel['sign'].iloc[-1]) else int(df_panel['sign'].iloc[-1])
        
        # if self.sign != curSign:
        if curSign != 0 and (self.sign == 0 or self.sign * curSign == -1):
            self.sign = curSign
            self.handlebackTrade()
            self.insertFactor()

    def getModel(self):
        global ukdf
        global df_panel
        
        df_input = pd.DataFrame()
        df_input['date'] = ukdf['tradeDate']
        df_input['closeTime'] = ukdf['closeTime']
        df_input['open'] = ukdf['open']
        df_input['close'] = ukdf['close']
        df_input['high'] = ukdf['high']
        df_input['low'] = ukdf['low']
        df_input['amount'] = ukdf['amt']    

        df_s = get_nav(df_input) 
        
        # logger.debug(f'df_s.iloc[:5,:] :\n{df_s.iloc[:5,:]}')
        logger.debug(f'df_s.iloc[-5:,:] :\n{df_s.iloc[-5:,:]}')       
        
        df_pred = logicpred(df_s) 

        # logger.debug(f'df_pred.iloc[:5,:] :\n{df_pred.iloc[:5,:]}')
        logger.info(f'df_pred.iloc[-5:,:] :\n{df_pred.iloc[-5:,:]}')
        
        df_pred_last = df_pred.iloc[-1:,:]
        df_panel = pd.concat([df_panel, df_pred_last],ignore_index=True)
        
        if len(df_panel) > 50:
            df_panel.drop(index=0, inplace=True)
        
        df_panel.reset_index(drop=True,inplace=True)
        # logger.info(f'df_panel.iloc[:5,:] :\n{df_panel.iloc[:5,:]}')
        logger.info(f'df_panel.iloc[-5:,:] :\n{df_panel.iloc[-5:,:]}')        
        
        
        df_input.to_pickle(f"bak/df_input.pkl" )
        ukdf.to_pickle(f"bak/ukdf.pkl" )
        df_s.to_pickle(f"bak/df_s.pkl" )
        df_pred.to_pickle(f"bak/df_pred.pkl" )
        df_panel.to_pickle(f"bak/df_panel.pkl" )

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

    curDate = time.strftime("%Y%m%d")
    logger = make_logger(name, log_level=logging.DEBUG, log_file= name +"_" + str(curDate)+".log")

    logger.info(f'--cli.start()--{version}--{curDate}--')

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

            ukdf = pd.concat([tradeDateSr, openTimeSr, closeTimeSr, closeSecSr,openSr, closeSr, highSr, lowSr, lowSr, volSr, amtSr], axis=1) 
            
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
    
    # handler.getModel()

    handler.queryContractAssets()
    handler.queryPositions()

    # cli.cancelSubKline(gateway, tradeType, symbol, '30m')
    cli.cancelAllSubKlines()
    cli.subKline(gateway, tradeType, symbol, interval)
    # cli.subKline(gateway, "usdt", "BTCUSDT", "30m")
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

# nohup python3 -u main.py -n logic -s 8808 -c 29096 -X BTCUSDT -p 30m -w 40 -d 120 -T 0.55 -t 1000000  >> log.txt 2>&1  &

# python3 -u main.py -n logic -s 8808 -c 29096 -X BTCUSDT -p 30m -w 40 -d 120 -T 0.55 -t 1000000

