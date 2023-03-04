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
import pymssql
warnings.filterwarnings("ignore")
conn = pymssql.connect("127.0.0.1", "sa", "quant@123", "block")
cursor = conn.cursor()
warnings.filterwarnings("ignore")

def count_num(df_input):
    df_input['num']=df_input.shape[0]
    return df_input[['ymd','num']].iloc[0:1,:]

def get_data():
    sql_str = "SELECT  ymd+' '+hms,[open],[close],high,low,amount   from [test_block].[dbo].[adj_data]" \
              "  where category ='btc' and window=30     order by ymd  ,hms "
    cursor.execute(sql_str)
    df_all = pd.DataFrame(cursor.fetchall(), columns=['date', 'open', 'close', 'high', 'low','amount'])
    # df_all.sort_values(by='date',ascending=True,inplace=True)
    # df_all=df_all.groupby('ymd').apply(count_num)
    # df_all.to_excel("df_all.xlsx",index=False)
    # ds=df_all[['ymd']].drop_duplicates()
    df_all.to_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\tsc_dnn\config\btc_latest.csv",index=False)



#####################################################################################################################
#   Main Code
#####################################################################################################################
if __name__ == '__main__':
    # parameter
    get_data()

