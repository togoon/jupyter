# -*- coding: UTF-8 -*-
import pandas as pd
import time
import datetime
import numpy as np
import warnings
from scipy import stats as st
import statsmodels.api as sm
from math import sqrt
from tqdm import tqdm

from matplotlib import pyplot as plt
import pymssql
import pandas as pd
from itertools import product as product
warnings.filterwarnings('ignore')
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号
conn = pymssql.connect("127.0.0.1", "sa", "quant@123", "block")
cursor = conn.cursor()
warnings.filterwarnings("ignore")




def fun_k1(idx, df):
    idx = [int(i) for i in idx]
    # idx=idx-idx[0]
    reg2= np.polyfit(idx,np.array(df['close'][idx]),3)  # slope intercept rvalue pvalue
    k = 3*reg2[0]*idx[-1]**2+2*reg2[1]*idx[-1]+reg2[2]
    return k
def fun_k2(idx, df):
    idx = [int(i) for i in idx]
    # idx=idx-idx[0]
    reg2= np.polyfit(idx,np.array(df['close'][idx]),3)  # slope intercept rvalue pvalue
    k = 6*reg2[0]*idx[-1]+2*reg2[1]
    return k

def func(idx,df_input,thd):
    # thd = 3
    idx = [int(i) for i in idx]
    ds = df_input.iloc[idx]
    thd = thd * 100
    ds = ds[ds['amt']>np.percentile(ds['amt'],thd)]
    return ((ds['pct'] + 1).cumprod()-1).iloc[-1]



def cal_pct(cate_id,wid_,thd):
    cost_ = -0.0016
    sql_str = "SELECT ymd,hms,[open],high,low,[close],amount   from [test_block].[dbo].[adj_data]" \
              "  where category ='" + str(cate_id) + "' and window=5   and ymd >'2020-12-31' order by ymd,hms"
    # print(sql_str)
    cursor.execute(sql_str)
    df_id = pd.DataFrame(cursor.fetchall(), columns=['daytime', 'hms', 'open', 'high', 'low', 'close', 'amt'])
    df_id['pct'] = df_id['close'] / df_id['close'].shift(1) - 1
    df_id.fillna(0, inplace=True)
    df_id['index'] = df_id.index
    df_id['value'] = df_id['index'].rolling(int(wid_)).apply(lambda x: func(x, df_id, thd))
    df_id.to_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\SR_min_test\config\\df_wid_"+str(wid_)+"_thd_"+str(int(thd*100))+".csv")
    return np.nan






#####################################################################################################################
#   Main Code
#####################################################################################################################
if __name__ == '__main__':
    # parameter
    if_print = 0
    wid_=np.arange(12)*4*12 + 144
    thd = np.arange(31)*0.01+0.6

    df_para= pd.DataFrame(list(product(wid_, thd)))
    for index_para, row_para in tqdm(df_para.iterrows(), total=df_para.shape[0]):

        wid_, thd = int(row_para[0]), row_para[1]
        cal_pct('btc', wid_, thd)
        # break
        # df_para['sr'] = df_para['re'] / df_para['std']
        # df_para.to_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\Amihud_illiquidity\results\df_results.csv")
        # break

    # df_para['re']=np.nan
    # df_para['std']=np.nan
    # print(df_para)
    # for index_para,row_para in tqdm(df_para.iterrows(),total=df_para.shape[0]):
    #
    #     # if index_para!=64:
    #     #     if_print = 1
    #     #     continue
    #     wid_,thd=int(row_para[0]),row_para[1]
    #
    #     df_para['re'].iloc[index_para],df_para['std'].iloc[index_para] = loading_data('btc',wid_,thd,if_print)
    #     # break
    #     df_para['sr']=df_para['re']/df_para['std']
    #     df_para.to_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\Amihud_illiquidity\results\df_results.csv")
    #     break