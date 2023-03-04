# -*- coding: UTF-8 -*-

import numpy as np
import warnings
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


def loading_data(cate_id,wid_,period,if_print):
    sql_str = "SELECT ymd,hms,[open],high,low,[close],amount/(high+low)*2   from [test_block].[dbo].[adj_data]" \
              "  where category ='"+cate_id+"' and window=10   and ymd >'2020-01-01' order by ymd,hms"
    cursor.execute(sql_str)
    df_all = pd.DataFrame(cursor.fetchall(), columns=['daytime','hms','open','high','low','close','vol'])
    df_panel = pd.pivot_table(df_all,index='daytime',columns='hms',values='close')
    df_panel.dropna(how='any',inplace=True)
    df_panel.reset_index(drop=True,inplace=True)
    # 截取每天前wid_根k线的数据
    df_similarity=df_panel.iloc[:,:wid_]

    df_panel=df_panel.iloc[:,wid_:]
    df_panel['pct']=df_panel.iloc[:,-1]/df_panel.iloc[:,0]-1
    df_panel['bm'] = (1+df_panel['pct']).cumprod()
    df_panel['indicator'] = 0
    for index_panel,row_panel in df_similarity.iterrows():
        if index_panel<period-1:
            continue
        ds = df_similarity.iloc[index_panel-(period-1):index_panel+1,:]
        # 计算与当前wid_根k线相似度最大的历史时刻
        df_corr = ds.T.corr().iloc[:, -1:]
        df_corr.columns=['corr']
        df_corr.sort_values(by='corr',ascending=False,inplace=True)
        df_corr['idx']=df_corr.index
        # df_corr['idx'].iloc[1]
        df_panel['indicator'].iloc[index_panel] = df_panel['pct'].iloc[int(df_corr['idx'].iloc[1])]
        # print(ds)
        # break
    # 当历史上相似度最大的哪天是上涨，那么我们就做多
    df_panel['adj_pct']=np.where(df_panel['indicator']>0.0,df_panel['pct'],0)
    df_panel['nav'] = (1 + df_panel['adj_pct']).cumprod()
    if if_print==1:
        plt.plot(df_panel['nav'],'r-')
        plt.plot(df_panel['bm'],'k-')
        plt.show()
    re_ = (df_panel['nav'].iloc[-1])**(365/df_panel.shape[0]) - 1
    std_ = np.std(df_panel['adj_pct'])*np.sqrt(365)
    return re_,std_







def get_parameter():
    wid_ = (np.arange(12) + 6) * 6
    pred_wid = (np.arange(250) + 30)
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
    # wid_=(np.arange(9)+4)*12
    df_para = get_parameter()
    # print(df_para)
    for index_para,row_para in tqdm(df_para.iterrows(),total=df_para.shape[0]):
        if index_para!=304:
            if_print = 1
            continue
        wid_=int(row_para[0])
        df_para['re_'].iloc[index_para],df_para['std_'].iloc[index_para]=loading_data('btc',int(row_para[0]),int(row_para[1]),if_print)
        # print(df_para)
        # df_para.to_excel(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\similarity_strategy\results\re_10min.xlsx",index=True)
