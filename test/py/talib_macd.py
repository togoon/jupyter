# -*- coding: utf-8 -*-
import os, sys
import tushare as ts
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import talib

if len(sys.argv) ==2:
    code = sys.argv[1]
else:
    print('usage: python talib_macd.py stockcode ')
    sys.exit(1)

if len(code) !=6:
    print('stock code length: 6')
    sys.exit(2)

df = ts.get_k_data(code)
if df.empty ==True:
    print(" df is empty ")
    sys.exit(2)

df = df[ df['date'] > '2020-01-01']
if len(df) <30:
    print(" len(df) <30 ")
    sys.exit(2)

df['ma10'] = df['close'].rolling(window=10).mean()
df.index = pd.to_datetime(df.date)
dw = pd.DataFrame()
#close = np.array(df['close'])

# 调用talib计算指数移动平均线的值
#df['EMA12'] = talib.EMA(close, timeperiod=6)
#df['EMA26'] = talib.EMA(close, timeperiod=12)

# 调用talib 计算 MACD指标
dw['MACD'],dw['MACDsignal'],dw['MACDhist'] = talib.MACD(df.close, fastperiod=12, slowperiod=26, signalperiod=9)
print(dw.tail(5))

# 画股票收盘价图
fig,axes = plt.subplots(2,1)
df[['close', 'ma10']].plot(ax=axes[0], grid=True, title=code)
# 画 MACD 曲线图
dw[['MACD','MACDsignal', 'MACDhist']].plot(ax=axes[1], grid=True)
plt.legend(loc='best', shadow=True)
plt.show()

