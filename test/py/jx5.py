#!/usr/bin/python
# coding: UTF-8

"""This script parse stock info"""

import tushare as ts
import pandas as pd

def parse(code_list):
    '''''process stock'''
    is_buy    = 0
    buy_val   = []
    buy_date  = []
    sell_val  = []
    sell_date = []
    df = ts.get_h_data(STOCK,start = '2015-09-01',end = '2017-09-01')
    df1 = df.sort_index(axis=0)
    df1['ma20'] =pd.rolling_mean(df1['close'], 20)
    df1.dropna(axis=0, how='any', thresh=None, subset=None, inplace=True)
    df2 = df1.sort_index(axis=0,ascending=False)
    ma20 = df2.ma20
    close = df2.close
    open = df2.open
    rate = 1.0
    idx = len(ma20)
    lastbuy_val=0

    while idx > 0:
        idx -= 1
        close_val = close[idx]
        ma20_val = ma20[idx]
        open_val = open[idx]

        if close_val + open_val > ma20_val*2 and open_val < ma20_val and close_val > open_val*1.015:
                if is_buy == 0:
                        is_buy = 1
                        buy_val.append(close_val)
                        buy_date.append(close.keys()[idx])
                        lastbuy_val = close_val
        elif close_val >lastbuy_val*1.05 or close_val < lastbuy_val *0.05:
                if is_buy == 1:
                        is_buy = 0
                        sell_val.append(close_val)
                        sell_date.append(close.keys()[idx])

    print ("stock number: %s" %STOCK)
    print ("buy count   : %d" %len(buy_val))
    print ("sell count  : %d" %len(sell_val))

    for i in range(len(sell_val)):
        rate = rate * (sell_val[i] * (1 - 0.002) / buy_val[i])
        print ("buy date : %s, buy price : %.2f" %(buy_date[i], buy_val[i]))
        print ("sell date: %s, sell price: %.2f" %(sell_date[i], sell_val[i]))

    print ("rate: %.2f" % rate)

if __name__ == '__main__':
    STOCK = '600898'       ##浦发银行
    parse(STOCK)