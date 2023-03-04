# -*- coding: UTF-8 -*-

import numpy as np
import warnings
from tqdm import tqdm
from PyEMD import EMD, Visualisation
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

def pymed(df_input,wid_):
    df_s = df_input.copy()
    df_s['pct'] = df_s['close'].iloc[-1] / df_s['close'].iloc[wid_-1] - 1
    df_s['pct_pre']=df_s['close'].iloc[wid_-1]/df_s['close'].iloc[0] - 1

    df_s=df_s.iloc[0:wid_]
    tmp = np.array(df_s['close'])
    emd = EMD()
    emd.emd(tmp)
    imfs, res = emd.get_imfs_and_residue()
    delta = tmp-res
    df_s['emd'] = np.log(np.std(delta))-np.log(np.std(tmp))

    return df_s[['emd','pct','pct_pre']].iloc[0:1]

def loading_data(cate_id,wid_,period,if_print):
    sql_str = "SELECT ymd,hms,[open],high,low,[close]   from [test_block].[dbo].[adj_data]" \
              "  where category ='"+cate_id+"' and window=10   and ymd >'2020-01-01' order by ymd,hms"
    cursor.execute(sql_str)
    df_all = pd.DataFrame(cursor.fetchall(), columns=['daytime','hms','open','high','low','close'])

    # 利用经验模态分解算法计算前一段时间（wid_个10分钟k线）信噪比
    df_panel = df_all.groupby('daytime').apply(pymed,wid_)
    df_panel.reset_index(inplace=True)
    del df_panel['level_1']
    # 计算当前的信噪比与过去一段时间历史平均值的差值，我们定义为thd
    df_panel['thd']=df_panel['emd']-df_panel['emd'].rolling(window=period).mean()
    df_panel.dropna(how='any', inplace=True)
    df_panel.reset_index(inplace=True)
    # 当thd大于0时，且wid_个10分钟的涨幅是大于0
    df_panel['pct_adj']=np.where((df_panel['thd']>0) &(df_panel['pct_pre']>0),df_panel['pct'],0)
    std_=np.std(df_panel['pct_adj'])*np.sqrt(365.0)
    df_panel['pct_adj'] = (1+df_panel['pct_adj']).cumprod()-1
    re_ = df_panel['pct_adj'].iloc[-1]**(365.0/df_panel.shape[0])
    if if_print:
        plt.plot(df_panel['pct_adj'],'r-')
        plt.show()
    return re_,std_

def get_parameter():
    wid_ = (np.arange(12) + 6) * 6
    pred_wid = (np.arange(24)*5 + 30)
    df_para = pd.DataFrame(list(product(wid_, pred_wid)))
    df_para.columns = ['wid', 'period']
    df_para['re_'] = np.nan
    df_para['std_'] = np.nan
    # print(df_para)
    return df_para


#####################################################################################################################
#   Main Code
#####################################################################################################################
if __name__ == '__main__':
    # parameter
    if_print = 0
    df_para = get_parameter()

    for index_para,row_para in tqdm(df_para.iterrows(),total=df_para.shape[0]):
        if index_para!=130:
            if_print = 1
            continue
        df_para['re_'].iloc[index_para],df_para['std_'].iloc[index_para]=loading_data('btc',int(row_para[0]),int(row_para[1]),if_print)
        # print(df_para)
        if if_print==0:
            df_para.to_excel(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\pyemd\results\results_10min.xlsx")
        # break





