import tushare as ts
import pandas as pd
import numpy as np


data=ts.get_hist_data('002211',start='2021-01-01',end='2022-01-01').sort_index()


def get_macd_data(data,short=0,long1=0,mid=0):
    if short==0:
        short=12
    if long1==0:
        long1=26
    if mid==0:
        mid=9
    data["sema"]=pd.ewma(data["close"],span=short)
    data['lema']=pd.ewma(data['closeL'],span=long1)
    data.fillna(0,inplace=True)
    data['data_dif']=data['sema']-data['lema']
    data['data_dea']=pd.ewma(data['data_dif'],span=mid)
    data['data_macd']=2*(data['data_dif']-data['data_dea'])
    data.fillna(0,inplace=True)
    return data[['data_dif','data_dea','data_macd']]
    print(data[['data_dif','data_dea','data_macd']])