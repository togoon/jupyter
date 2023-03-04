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


def fun_polyfit(df_input,wid_,thd,if_print):
    # thd = 3
    cost_=-0.001
    df_s = df_input.copy()
    df_s=df_s[['hms','close','pct']]
    df_s.reset_index(drop=True,inplace=True)
    # mom = df_s['close'].iloc[wid_]/df_s['close'].iloc[0] -1

    df_s_upside = df_s.iloc[0:wid_,:] #截取 0~wid_ 行
    df_s_upside['abs_pct'] = np.abs(df_s_upside['pct'])  #绝对值
    thd_pct = np.percentile(df_s_upside['abs_pct'],85)  #分位数 85%
    df_s_upside['pct'] = np.where(df_s_upside['abs_pct']<thd_pct,df_s_upside['pct'],0)
    df_s_upside['pct'] = (1+df_s_upside['pct']).cumprod() #累积连乘

    mom = df_s_upside['pct'].iloc[-1]/df_s_upside['pct'].iloc[0] - 1  #末wid_/首0  -1 


    re_ = 0
    if mom>thd : #thd 0
        re_ = df_s['close'].iloc[-1]/df_s['close'].iloc[wid_] - 1   #末/首wid_  -1 
    if mom < thd :
        re_ = df_s['close'].iloc[-1] / df_s['close'].iloc[wid_] - 1
        re_ = - re_
    df_s['pct']= re_-0.0008
    return df_s.iloc[-1:,:]

def loading_data(cate_id,wid_,thd,if_print): #wid_ 24~83 ,
    sql_str = "SELECT ymd,hms,[open],high,low,[close]   from [test_block].[dbo].[adj_data]" \
              "  where category ='"+str(cate_id)+"' and window=10   and ymd >'2020-12-31' order by ymd,hms"
    # print(sql_str)
    cursor.execute(sql_str)
    df_id = pd.DataFrame(cursor.fetchall(), columns=['daytime','hms','open','high','low','close'])
    df_id['pct']=df_id['close']/df_id['close'].shift(1)-1  #涨跌幅
    df_id.fillna(0,inplace=True)
    # print(df_id.head())
    df_id=df_id.groupby('daytime').apply(fun_polyfit,wid_,thd,if_print) #每日
    df_id.reset_index(inplace=True,drop=False)
    del df_id['level_1']
    # print(df_id)
    # df_id['pct'] = df_id['pct'] -1
    std_pct = np.std(df_id['pct'])*sqrt(365)
    df_id['pct']=(df_id['pct']+1).cumprod()  #累积连乘
    re_pct=df_id['pct'].iloc[-1]**(365/len(df_id.index))-1

    if if_print==1:
        df_id.to_excel("data.xlsx", index=False)
        plt.plot(df_id['pct'],'r-')
        plt.show()

    return re_pct,std_pct  


#####################################################################################################################
#   Main Code
#####################################################################################################################
if __name__ == '__main__':
    # parameter
    if_print = 0
    timespan=6 # 6代表10分钟，12代表5分钟，
    wid_=np.arange(10*timespan) + 4*timespan  # 60, [24, ..., 83]
    thd = np.arange(1)*0.2+0  # array([0.])
    df_para= pd.DataFrame(list(product(wid_, thd)))
    df_para['re']=np.nan
    df_para['std']=np.nan
    # print(df_para)  #60,  [ 0~59, 24~83 , 0.0, NaN, NaN ]
    for index_para,row_para in tqdm(df_para.iterrows(),total=df_para.shape[0]):

        if index_para!=47:
            if_print = 1
            continue
        wid_,thd=int(row_para[0]),int(row_para[1])
        df_para['re'].iloc[index_para],df_para['std'].iloc[index_para] = loading_data('btc',wid_,thd,if_print)
    df_para['sr']=df_para['re']/df_para['std']

    if if_print==0:
        df_para.to_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\modified_mom\results\df_results.csv")
        # break