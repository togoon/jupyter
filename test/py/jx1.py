#!/usr/bin/python
# coding: UTF-8

"""This script parse stock info"""

import tushare as ts

def parse(code_list):
    '''''process stock'''
    is_buy    = 0
    buy_val   = []
    buy_date  = []
    sell_val  = []
    sell_date = []
    df = ts.get_hist_data(STOCK)
    ma20 = df[u'ma20']
    close = df[u'close']
    open = df[u'open']
    high = df[u'high']
    low = df[u'low']
    rate = 1.0
    idx = len(ma20)
    last_buy_price    = 0
    buy_days = 0

    while idx > 0:
        idx -= 1
        close_val = close[idx]
        open_val = open[idx]
        high_val = high[idx]
        low_val = low[idx]
        ma20_val = ma20[idx]
        ma20_val_1 = ma20[idx-1]
        buy_days = buy_days + 1
        if close_val > ma20_val and open_val < ma20_val and ma20_val_1 < ma20_val :
                if is_buy == 0:
                        is_buy = 1
                        buy_days = 0
                        buy_val.append(close_val)
                        buy_date.append(close.keys()[idx])
                        last_buy_price = close_val
        #elif close_val < ma20_val: #把这个地方改成超出买入价3%卖出


        elif high_val >= last_buy_price * (1 +0.03) : #把这个地方改成超出买入价3%卖出
                if is_buy == 1:
                        is_buy = 0
                        buy_days = 0
                        sell_val.append(last_buy_price * (1 +0.03))
                        sell_date.append(close.keys()[idx])

        elif  buy_days >= 5: #把这个地方改成超出买入价3%卖出
                if is_buy == 1:
                        is_buy = 0
                        buy_days = 0
                        sell_val.append(close_val)
                        sell_date.append(close.keys()[idx])





    for i in range(len(close)):

        print ("date : %s, open : %.2f, close : %.2f, high : %.2f, low : %.2f, ma20 : %.2f" %(close.keys()[i], open[i], close[i],  high[i], low[i], ma20[i]))


    for i in range(len(sell_val)):
        rate = rate * (sell_val[i] * (1 - 0.002) / buy_val[i])
        print ("buy date : %s, buy price : %.2f" %(buy_date[i], buy_val[i]))
        print ("sell date: %s, sell price: %.2f" %(sell_date[i], sell_val[i]))

    print ("rate: %.2f" % rate)

    print ("stock number: %s" %STOCK)
    print ("buy count   : %d" %len(buy_val))
    print ("sell count  : %d" %len(sell_val))

if __name__ == '__main__':
    STOCK = '600900'       ##浦发银行
    parse(STOCK)