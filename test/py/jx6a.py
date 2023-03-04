#!/usr/bin/python
# coding: UTF-8

"""This script parse stock info"""

import tushare as ts
import numpy as np
import pandas as pd


def parse(code_list):

    is_buy    = 0
    buy_val   = []
    buy_date  = []
    sell_val  = []
    sell_date = []
    df = ts.get_h_data(STOCK,start = '2015-09-01',end = '2017-09-01')
    df1 = df.sort_index(axis=0)
    df1['ma20'] =pd.rolling_mean(df1['close'], 20)
	print(111111111)
    df1.dropna(axis=0, how='any', thresh=None, subset=None, inplace=True)
    df2 = df1.sort_index(axis=0,ascending=False)
    ma20 = df2.ma20
    close = df2.close
    open = df2.open
    rate = 1.0
    idx = len(ma20)
    buy_val1=0
    buy_val2=0
    buy_val3=0
    open_val1=0
    order_val =0
    order_target=0

    while idx > 0:
        idx -= 1
        close_val = close[idx]
        ma20_val = ma20[idx]
        open_val = open[idx]

        if (close_val + open_val) > ma20_val*2 and open_val < ma20_val and close_val > open_val*1.015:#买入条件1:股价金叉20均线且K线上半部分大于下半部分
                if is_buy == 0 and order_target==0:
                        is_buy = 1
                        buy_val.append(close_val)
                        buy_date.append(close.keys()[idx])
                        buy_val1 = close_val #买入价1
                        open_val1 = open_val #买入当天开盘价
                        order_target= 0.3 #仓位

        elif close_val >buy_val1*1.03 :#卖出条件1:股价大于买入价3个点卖出
                if is_buy == 1 and order_target==0.3:
                        is_buy = 0
                        order_target =0
                        sell_val.append(close_val)
                        sell_date.append(close.keys()[idx])
        elif close_val*2 < (buy_val1+open_val1) and close_val>open_val: #买入条件2:股价小于买入1当天K线实体一半且收阳线
                if is_buy ==1 and order_target == 0.3:
                        is_buy = 1
                        buy_val.append(close_val)
                        buy_date.append(close.keys()[idx])
                        buy_val2 = close_val#买入价2
                        order_target = 0.6#仓位
        elif close_val>buy_val1:#卖出条件2:股价反弹至买入价1卖出
                if is_buy ==1 and order_target==0.6:
                        is_buy = 0
                        order_target =0
                        sell_val.append(close_val)
                        sell_date.append(close.keys()[idx])

        elif close_val <buy_val2*0.95 and close_val>open_val:#买入条件3:股价小于买入2价的0.95且收阳线
                if is_buy ==1 and order_target == 0.6:
                        is_buy = 1
                        buy_val.append(close_val)
                        buy_date.append(close.keys()[idx])
                        buy_val3 = close_val#买入价3
                        order_target = 1#仓位
        elif close_val>buy_val2:#卖出条件3:股价反弹至买入价2卖出
                if is_buy ==1 and order_target==1:
                        is_buy = 0
                        order_target =0
                        sell_val.append(close_val)
                        sell_date.append(close.keys()[idx])

        elif close_val <(buy_val1*0.3 + buy_val2*0.3 + buy_val3*0.4)*0.95:#止损:亏损5%平仓
               if is_buy ==1 and target ==1:
                        is_buy = 0
                        order_target =0
                        sell_val.append(close_val)
                        sell_date.append(close.keys()[idx])
        elif idx>20:#持股超过20天平仓
                if is_buy==1:
                        is_buy = 0
                        order_target =0
                        sell_val.append(close_val)
                        sell_date.append(close.keys()[idx])



    buy_v=pd.Series(buy_val)
    buy_d=pd.Series(buy_date)
    sell_v=pd.Series(sell_val)
    sell_d=pd.Series(sell_date)
    df_buy= pd.DataFrame({'date':buy_d,'type':1,'value':buy_v})
    df_sell=pd.DataFrame({'date':sell_d,'type':0,'value':sell_v})
    df3=df_buy.append(df_sell)
    df4=df3.sort_index(axis=0)
    print(df4)




    imcome1 = 0
    imcome2 = 0
    imcome3 = 0
    imcome = [ ]
    sell_d = [ ]
    for i in range(len(df4.type)):
        if df4.type[i] ==1 and df4.type[i+1]==0:
            imcome1=df4.value[i+1] - df4.value[i]
            imcome.append(imcome1)
            sell_d.append(df4.date[i+1])

        elif df4.type[i] ==1 and df4.type[i+1]==1 and df4.type[i+2]==0:
            imcome2=2*df4.value[i+2] - df4.value[i] - df4.value[i+1]
            imcome.append(imcome2)
            sell_d.append(df4.date[i+2])

        elif df4.type[i] ==1 and df4.type[i+1]==1 and df4.type[i+2]==1 and df4.type[i+3]==0:
            imcome3=3*df4.value[i+3] - df4.value[i] - df4.value[i+1]-df4.value[i+2]

            imcome.append(imcome3)
            sell_d.append(df4.date[i+3])

    imcome_v=pd.Series(imcome)
    imcome_d=pd.Series(sell_d)
    df5= pd.DataFrame({'date':imcome_d,'value':imcome_v})
    print(df5)



if __name__ == '__main__':
    STOCK = '002195'       ##浦发银行
    parse(STOCK)