# -*- coding: UTF-8 -*-

import numpy as np
import warnings
from scipy import stats
from math import sqrt
from tqdm import tqdm
import time
from sklearn import preprocessing
from matplotlib import pyplot as plt


import pandas as pd
from itertools import product as product
warnings.filterwarnings('ignore')
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

warnings.filterwarnings("ignore")


def fun_upvar(idx, df):
    idx = [int(i) for i in idx]
    dfs=pd.DataFrame(df['pct'][idx])
    ret = np.std(dfs['pct'][dfs['pct']>0])
    return ret

def fun_upvol(idx, df):
    idx = [int(i) for i in idx]
    dfs=pd.DataFrame(df.iloc[idx])
    ret = np.sum(dfs['amount'][dfs['pct']>0])/np.sum(dfs['amount'])
    return ret
def fun_downvar(idx, df):
    idx = [int(i) for i in idx]
    dfs=pd.DataFrame(df['pct'][idx])
    ret = np.std(dfs['pct'][dfs['pct']<0])
    return ret


def get_nav(df_input):
    #
    print("feature computing...")
    time_x = time.perf_counter()
    df_s = df_input.copy()
    df_s['pct']=df_s['close']/df_s['close'].shift(1) - 1
    df_s['close_next'] = df_s['close'].shift(-1)
    df_s['pct_next_'] = df_s['close'].shift(-1) / df_s['close'] - 1
    df_s['pct_change']=df_s['pct'].shift(-1)

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

    # df_s['status'] = np.where((df_s['close'].rolling(7).mean() > df_s['close'].rolling(30).mean())
    #                           , 1, 0)
    # df_s['status'] = np.where((df_s['close'].rolling(7).mean() < df_s['close'].rolling(30).mean())
    #                           , -1, df_s['status'])
    # df_s['status2'] = np.where( (df_s['close'].rolling(90).mean() > df_s['close'].rolling(180).mean())
    #                           , 1, 0)
    # df_s['status2'] = np.where( (df_s['close'].rolling(90).mean() < df_s['close'].rolling(180).mean())
    #                           , -1, df_s['status2'])

    print("time used is ", time.perf_counter() - time_x)
    # alpha compute
    print("alpha computing...")
    time_x = time.perf_counter()

    # RSV技术指标变种
    part1 = (df_s['high'].rolling(window=30, min_periods=30).max() - df_s['close']) / \
            (df_s['high'].rolling(window=30, min_periods=30).max() - \
             df_s['low'].rolling(window=30, min_periods=30).min()) * 100
    df_s['alpha47'] = part1.ewm(adjust=False, alpha=float(1) / 9, min_periods=0, ignore_na=False).mean()


    # COUNT(CLOSE>DELAY(CLOSE,1),20)/20*100
    df_s['alpha58'] = (df_s['close'].diff(1) > 0.0).rolling(window=240, min_periods=240).sum() / 240.0 * 100

    # SMA(MAX(CLOSE-DELAY(CLOSE,1),0),24,1)/SMA(ABS(CLOSE-DELAY(CLOSE,1)),24,1)*100
    # RSI24
    part1 = (np.maximum(df_s['close'].diff(1), 0.0)).ewm(adjust=False, alpha=float(1) / 50, min_periods=0,
                                                       ignore_na=False).mean()
    part2 = (abs(df_s['close'].diff(1))).ewm(adjust=False, alpha=float(1) / 50, min_periods=0,
                                           ignore_na=False).mean()
    df_s['alpha67'] = part1 / part2


    # SMA((TSMAX(HIGH,6)-CLOSE)/(TSMAX(HIGH,6)-TSMIN(LOW,6))*100,15,1)
    part1 = (df_s['high'].rolling(window=40, min_periods=40).max() - df_s['close']) / \
            (df_s['high'].rolling(window=40, min_periods=40).max() - df_s['low'].rolling(window=40, min_periods=40).min())
    df_s['alpha72'] = part1.ewm(adjust=False, alpha=float(1) / 15, min_periods=0, ignore_na=False).mean()


    print("time used is ", time.perf_counter() - time_x)

    print("data saving...")
    # drop na
    df_s.dropna(how='any', inplace=True)
    df_s.to_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\tsc_dnn\results\feature_v1.csv",index=False)

    # regression
    print(" feature testing")
    col_list = ['skew','max_ret','kurt','vol','upvar','upvol','downvar','max_drawdown','mom_5','mom_30','mom_60','p_v_corr','pct_v_corr',
                'alpha72','alpha67','alpha58','alpha47']
    # col_list = ['alpha3','alpha11','alpha22','alpha24','alpha23','alpha27','alpha29','alpha76','alpha72','alpha71','alpha69'
    #             ,'alpha67','alpha65','alpha59','alpha58','alpha57','alpha55'
    #             ,'alpha53','alpha52','alpha51','alpha50','alpha47']
    col_list=pd.DataFrame(col_list)
    col_list['r2']=0
    for index_col,row_col in col_list.iterrows():
        ret = stats.linregress(df_s[row_col[0]], df_s['pct_next_'])
        col_list['r2'].iloc[index_col]=ret[2]**2
        # print(row_col[0],"k is:", ret[0], "r^square is :", ret[2] ** 2)
    col_list.to_excel(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\tsc_dnn\results\r2.xlsx",index=False)

    # print(df_s.head(10))




#####################################################################################################################
#   Main Code
#####################################################################################################################
if __name__ == '__main__':
    # parameter
    data = pd.read_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\tsc_dnn\config\btc_latest.csv")
    get_nav(data)

