# -*- coding: UTF-8 -*-
import pandas as pd
import time
import datetime
import numpy as np
import warnings
from sklearn import preprocessing
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


def plot_average_cumulative_return(df, factor_name, after=20, title=None, probability=True, prt=True):
    '''
    df 因子计算后的df
    factor_name df中因子的名称
    title 图标的标题
    after 之后N日
    probability True计算概率 False 计算平均收益
    '''
    RSRS = df[['close', factor_name]].copy()
    # 计算未来N日收益率
    RSRS['ret'] = RSRS.close.pct_change(after).shift(-after)
    group = pd.qcut(RSRS[factor_name], 10)
    RSRS['group'] = group
    # print(group)
    if probability:
        # 计算上涨概率
        after_ret = RSRS.groupby('group')['ret'].apply(lambda x: np.sum(np.where(x > 0, 1, 0)) / len(x))
    else:
        after_ret = RSRS.groupby('group')['ret'].mean()
        # after_ret = RSRS.groupby('group')['ret'].count()

    if prt:
        # 画图
        plt.figure(figsize=(18, 6))
        # 设置标题
        plt.title(title)
        size = len(after_ret)
        plt.bar(range(size), after_ret.values, width=0.8, alpha=0.5)
        # rotation旋转x轴标签
        plt.xticks(range(size), after_ret.index.categories.right, rotation=30)


        # 设置y轴标题
        plt.ylabel('上涨概率')
        plt.show()
        return np.nan

    else:
        df = pd.DataFrame(np.array(after_ret.index.categories.right))
        df.columns = ['value']
        dfs = pd.DataFrame(after_ret.values)
        dfs.columns = ['ret']
        df['ret'] = dfs['ret']
        del dfs
        return df['value'].corr(df['ret'])

def f_1(df_input):
    df_input=df_input.iloc[-1:,:]
    return df_input
def s_1(df_input,wid_,threshold_,direction_=1):
    df_s = df_input.copy()
    df_s=df_s[['daytime','hms','pct','factor','close']]
    df_s['pct']=df_s['close']/df_s['close'].shift(1) - 1
    df_s['pct'].iloc[0] = 0
    df_s['position'] = 0
    df_s['cost'] = 0
    cost_=-0.0016

    for i in range(wid_):
        df_s['nav'+str(i+1)] = 0
        df_s['cost' + str(i + 1)] = 0


    for index_s,row_s in df_s.iterrows():
        if index_s==df_s.shape[0]-wid_-1:
            break
        # 开仓
        if direction_==-1:
            if df_s['factor'].iloc[index_s]<threshold_ :
                for i in range(wid_):
                    if df_s['nav'+str(i+1)].iloc[index_s]==0:
                        df_s['nav'+str(i+1)].iloc[index_s+1:index_s+wid_] = 1
                        df_s['cost'+str(i+1)].iloc[index_s] = cost_
                        break
        else:
            if df_s['factor'].iloc[index_s]>threshold_ :
                for i in range(wid_):
                    if df_s['nav'+str(i+1)].iloc[index_s]==0:
                        df_s['nav'+str(i+1)].iloc[index_s+1:index_s+wid_] = 1
                        df_s['cost'+str(i+1)].iloc[index_s] = cost_
                        break

    for i in range(wid_):
        df_s['nav'+str(i+1)] = (df_s['nav'+str(i+1)]*df_s['pct']+1+df_s['cost'+str(i+1)]).cumprod()
    df_s['nav'] = 0
    for i in range(wid_):
        df_s['nav'] = df_s['nav'+str(i+1)]+df_s['nav']
    df_s['nav']=df_s['nav']/wid_
    df_s=df_s.groupby('daytime').apply(f_1)
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

def fun_upvar(idx, df):
    idx = [int(i) for i in idx]
    dfs=pd.DataFrame(df['pct'][idx])
    ret = np.std(dfs['pct'][dfs['pct']>0])
    return ret

def loading_data(cate_id,wid_,thd,if_print):
    #
    sql_str = "SELECT ymd,hms,[open],high,low,[close],amount/([high]+low)*2   from [test_block].[dbo].[adj_data]" \
              "  where category ='"+str(cate_id)+"' and window=5   and ymd >'2020-12-31' order by ymd,hms"
    # print(sql_str)
    cursor.execute(sql_str)
    df_id = pd.DataFrame(cursor.fetchall(), columns=['daytime','hms','open','high','low','close','volume'])

    # df_id就是btc5min的时间序列
    df_id['pct']=df_id['close']/df_id['close'].shift(1)-1
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
            (df_id['high'].rolling(window=wid_, min_periods=wid_).max() - df_id['low'].rolling(window=wid_,
                                                                                               min_periods=wid_).min())
    df_id['factor'] = part1.ewm(adjust=False, alpha=float(1) / wid_, min_periods=0, ignore_na=False).mean()

    # factor alpha47
    # wid_, thd, threshold, direction_ = 30, 40, 0.62, 1
    # part1 = (df_id['high'].rolling(window=wid_, min_periods=wid_).max() - df_id['close']) / \
    #         (df_id['high'].rolling(window=wid_, min_periods=wid_).max() - \
    #          df_id['low'].rolling(window=wid_, min_periods=wid_).min())
    # df_id['factor'] = part1.ewm(adjust=False, alpha=float(1) / wid_, min_periods=0, ignore_na=False).mean()

    # factor 50
    # wid_,thd,threshold,direction_=50,45,0.446,-1
    # part1 = (np.maximum(df_id['close'].diff(1), 0.0)).ewm(adjust=False, alpha=float(1) / wid_, min_periods=0,
    #                                                    ignore_na=False).mean()
    # part2 = (abs(df_id['close'].diff(1))).ewm(adjust=False, alpha=float(1) / wid_, min_periods=0,
    #                                        ignore_na=False).mean()
    # df_id['factor'] = part1 / part2



    # factor 58
    # wid_, thd, threshold, direction_ = 240, 50, 0.54, 1
    # df_id['factor'] = (df_id['close'].diff(1) > 0.0).rolling(window=wid_, min_periods=wid_).sum() / wid_




    df_id.dropna(how='any', inplace=True)
    df_id.reset_index(drop=True, inplace=True)

    if if_print==1:
        # s_1即为操作程序
        s_1(df_id,wid_=thd,threshold_=threshold,direction_=direction_)







#####################################################################################################################
#   Main Code
#####################################################################################################################
if __name__ == '__main__':
    # parameter
    if_print = 0
    wid_=np.arange(10)*10 + 30 # 过去多长时间来计算vol等
    thd = np.arange(10)*5+5 # 未来多长时间的收益相关性
    df_para= pd.DataFrame(list(product(wid_, thd)))
    df_para['corr']=np.nan
    # print(df_para)
    for index_para,row_para in tqdm(df_para.iterrows(),total=df_para.shape[0]):

        if index_para!=9:
            if_print = 1
            continue
        wid_,thd=int(row_para[0]),int(row_para[1])
        df_para['corr'].iloc[index_para]=loading_data('btc',wid_,thd,if_print)
        # break
        if if_print==0:
            df_para.to_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\factor_check\results\df_corr_results.csv")
