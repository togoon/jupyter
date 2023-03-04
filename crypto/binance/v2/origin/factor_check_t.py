# -*- coding: UTF-8 -*-
import numpy as np
import warnings

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


def f_1(df_input):
    df_input=df_input.iloc[-1:,:]
    return df_input

def s_1(df_input,wid_,threshold_,direction_=1): # 50, 0.6, 1
    df_s = df_input.copy()
    df_s=df_s[['daytime','hms','pct','factor','close']]
    df_s['pct']=df_s['close']/df_s['close'].shift(1) - 1  #涨跌幅
    df_s['pct'].iloc[0] = 0
    df_s['position'] = 0
    df_s['cost'] = 0
    cost_=-0.0016

    for i in range(wid_): #0-50
        df_s['nav'+str(i+1)] = 0
        df_s['cost' + str(i + 1)] = 0


    for index_s,row_s in df_s.iterrows():  #行遍历
        if index_s==df_s.shape[0]-wid_-1:  #行数 -50 -1
            break
        # 开仓
        if direction_==-1:  #1
            if df_s['factor'].iloc[index_s]<threshold_ :
                for i in range(wid_):
                    if df_s['nav'+str(i+1)].iloc[index_s]==0:
                        df_s['nav'+str(i+1)].iloc[index_s+1:index_s+wid_] = 1
                        df_s['cost'+str(i+1)].iloc[index_s] = cost_
                        break
        else:
            if df_s['factor'].iloc[index_s]>threshold_ :  #0.6
                for i in range(wid_): #0-50
                    if df_s['nav'+str(i+1)].iloc[index_s]==0:
                        df_s['nav'+str(i+1)].iloc[index_s+1:index_s+wid_] = 1 #+49
                        df_s['cost'+str(i+1)].iloc[index_s] = cost_  #-0.0016
                        break

    for i in range(wid_): #0-50
        df_s['nav'+str(i+1)] = (df_s['nav'+str(i+1)]*df_s['pct']+1+df_s['cost'+str(i+1)]).cumprod()
    df_s['nav'] = 0
    for i in range(wid_):
        df_s['nav'] = df_s['nav'+str(i+1)]+df_s['nav']
    df_s['nav']=df_s['nav']/wid_
    df_s=df_s.groupby('daytime').apply(f_1)   #df_input=df_input.iloc[-1:,:] #末行
    df_s.reset_index(drop=True,inplace=True)
    df_s.to_excel("data.xlsx")
    plt.plot(df_s['nav'])
    plt.show()


        # # 平仓
        # if df_s['position'].iloc[index_s]==1:
        #     if df_s['factor'].iloc[index_s] > 0.1:
        #         df_s['position'].iloc[index_s + 1] = 0
        #         df_s['cost'].iloc[index_s] = cost_
        #         continue
        # # 仓位不动
        # df_s['position'].iloc[index_s + 1] = df_s['position'].iloc[index_s]

    return np.nan


def loading_data(cate_id,wid_,thd,if_print):
    #
    sql_str = "SELECT ymd,hms,[open],high,low,[close],amount/([high]+low)*2   from [test_block].[dbo].[adj_data]" \
              "  where category ='"+str(cate_id)+"' and window=5   and ymd >'2020-12-31' order by ymd,hms"
    # print(sql_str)
    cursor.execute(sql_str)
    df_id = pd.DataFrame(cursor.fetchall(), columns=['daytime','hms','open','high','low','close','volume'])

    # df_id就是btc5min的时间序列
    df_id['pct']=df_id['close']/df_id['close'].shift(1)-1  #涨跌幅
    df_id.fillna(0,inplace=True)
    df_id['index']=df_id.index

    df_id['idx']=df_id.index%6
    df_id=df_id[df_id['idx']==5]
    df_id.dropna(how='any',inplace=True)
    df_id.reset_index(drop=True,inplace=True)
    # print(df_id)

    # 计算因子，并判断方向
    # factor 72
    wid_, thd, threshold, direction_ = 40, 50, 0.6, 1
    part1 = (df_id['high'].rolling(window=wid_, min_periods=wid_).max() - df_id['close']) / \
            (df_id['high'].rolling(window=wid_, min_periods=wid_).max() - df_id['low'].rolling(window=wid_, min_periods=wid_).min())

    df_id['factor'] = part1.ewm(adjust=False, alpha=float(1) / wid_, min_periods=0, ignore_na=False).mean()


    df_id.dropna(how='any', inplace=True)
    df_id.reset_index(drop=True, inplace=True)

    if if_print==1:
        # s_1即为操作程序
        s_1(df_id,wid_=thd,threshold_=threshold,direction_=direction_)  #50, 0.6, 1 



#####################################################################################################################
#   Main Code
#####################################################################################################################
if __name__ == '__main__':
    # parameter
    if_print = 0
    wid_=np.arange(10)*10 + 30 # 过去多长时间来计算vol等  30~120 :10行
    thd = np.arange(10)*5+5 # 未来多长时间的收益相关性    5~50 :10行
    df_para= pd.DataFrame(list(product(wid_, thd)))   # df_para.shape = (100, 3)
    df_para['corr']=np.nan
    # print(df_para)
    for index_para,row_para in tqdm(df_para.iterrows(),total=df_para.shape[0]):

        if index_para!=9:
            if_print = 1
            continue
        wid_,thd=int(row_para[0]),int(row_para[1])
        df_para['corr'].iloc[index_para]=loading_data('btc',wid_,thd,if_print)  #8 5-50
        # break
        if if_print==0:
            df_para.to_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\factor_check\results\df_corr_results.csv")
