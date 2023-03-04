import os
import time
import math

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

import akshare as ak
import talib

print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
# maTacticdf = pd.read_pickle('/home/at/ipynb/QL/maTactic.pkl')
# maTacticdf.head(20).to_csv('/home/at/ipynb/QL/maTac.csv')
# print(time.strftime("%Y-%m-%d %H:%M:%S"))
# print(maTacticdf.head(20))


####################################

today = time.strftime('%Y%m%d')  # 20220221 #8位
dirPath = '/home/at/ipynb/QL'
eNameFile = 'eName.csv'
eNamePath = os.path.join(dirPath, eNameFile)
eName_df = pd.read_csv(eNamePath)

####################################
winLim = 0.05  # 止盈 0.03  0.05
lossLim = -0.03  # 止损 -0.05 -0.03
dayLim = 7  # 持仓天数限制 5 7
cDownLim = -2  # 死叉信号  -1   -2
freeRate = 0.997  # 税费率
SecurityID = '300390'

signal = 0    # 当前交易信号
winRate = 1.0  # 总收益率 *
posiDay = 0   # 持仓天数
posiVol = 0   # 仓位 股数
initAmt = 0   # 初始金额
buyPrice = 0.0  # 买价
sellPrice = 0.0  # 卖价

tradeCount = 0  # 总交易次数 单品种 累计
winCount = 0  # 止盈平仓次数
lossCount = 0  # 止损平仓次数
OverCount = 0  # 超期平仓次数
cDownCount = 0  # 死叉平仓次数

rUpDown = ''
tUpDown = ''


####################################

stock_zh_a_hist_df = ak.stock_zh_a_hist(
    symbol=SecurityID, period="daily", adjust="qfq")

kLinedf = stock_zh_a_hist_df.tail(700).copy(
    deep=True)  # 140 280 420 560 700
kLinedf = kLinedf.reset_index(drop=True)

eName_hist = eName_df[eName_df.dfcf.isin(
    stock_zh_a_hist_df.columns.values.tolist())]
eName_hist = eName_hist[['dfcf', 'En']].reset_index(drop=True)
kLinedf.rename(columns=dict(eName_hist.values.tolist()), inplace=True)

for iList in list(range(2, 20+1)) + [30, 60, 90, 120, 250]:
    kLinedf['Ma'+str(iList)] = talib.MA(kLinedf.Close.values,
                                        timeperiod=iList)  # 多均线

rowCount = 0
sumClose = 0.0
for rindex, row in kLinedf.iterrows():
    rowCount += 1
    sumClose += row['Close']
    maClose = round(sumClose/rowCount, 3)

    for iList in list(range(2, 20+1)) + [30, 60, 90, 120, 250]:
        Ma = 'Ma'+str(iList)
        if math.isnan(row[Ma]):
            kLinedf.at[rindex, Ma] = maClose  # 移动均线 nan 补均值
        else:
            kLinedf.at[rindex, Ma] = round(row[Ma], 3)

for i in range(2, 20+1):
    Ma = 'Ma'+str(i)
    cUp = 'cUp'+str(i)
    kLinedf[cUp] = 0
    kLinedf.loc[kLinedf.Close[(kLinedf.Close > kLinedf[Ma]) & (
        kLinedf.Close.shift() < kLinedf[Ma].shift())].index, cUp] = 1  # 金叉

    cDown = 'cDown'+str(i)
    kLinedf[cDown] = 0
    kLinedf.loc[kLinedf.Close[(kLinedf.Close < kLinedf[Ma]) & (
        kLinedf.Close.shift() > kLinedf[Ma].shift())].index, cDown] = -1  # 死叉

    # kLinedf['cUp'+str(i)] = kLinedf[['Close',Ma]].apply(lambda row: True if row.Close > row[Ma]
    #     and row.Close.shift(periods=-1, axis=0) < row[Ma].shift(periods=-1, axis=0)
    #     else False, axis=1)

for i in [30, 60, 90, 120, 250]:
    Ma = 'Ma'+str(i)
    kLinedf['On'+str(i)] = 0
    kLinedf.loc[kLinedf.Close[(
        kLinedf.Close > kLinedf[Ma])].index, 'On'+str(i)] = 1  # 均线之上

for rindex, row in kLinedf.iterrows():  # 品种->均线1金叉->均线2死叉->行->循环
    signal = row[tUpDown]
    if posiDay > 0:  # 持仓
        kLinedf.at[rindex, rUpDown] = winRate
        posiDay += 1
        if row[tUpDown] == 1:  # 屏蔽持仓期的信号
            signal = 0
            kLinedf.at[rindex, tUpDown] = signal

        # 止盈平仓
        if row["High"] > buyPrice * (1 + winLim):
            signal = -1
            posiDay = 0
            sellPrice = round(
                buyPrice * (1 + winLim), 2)
            winRate = round(winRate * sellPrice /
                            buyPrice * freeRate, 3)
            kLinedf.at[rindex, rUpDown] = winRate
            winCount += 1
            # print(rUpDown, rindex, signal, buyPrice, sellPrice, winRate)

        # 止损平仓
        elif row["Low"] < buyPrice * (1 + lossLim):
            signal = -2
            posiDay = 0
            sellPrice = round(
                buyPrice * (1 + lossLim), 2)
            winRate = round(
                winRate * sellPrice / buyPrice * freeRate, 3)
            kLinedf.at[rindex, rUpDown] = winRate
            lossCount += 1
            # print(rUpDown, rindex, signal, buyPrice, sellPrice, winRate)

        elif row[cDown] == cDownLim:  # 死叉平仓
            signal = -4
            posiDay = 0
            sellPrice = row["Close"]
            winRate = round(winRate * sellPrice /
                            buyPrice * freeRate, 3)
            kLinedf.at[rindex, rUpDown] = winRate
            cDownCount += 1

        elif posiDay >= dayLim:  # 超期平仓
            signal = -3
            posiDay = 0
            sellPrice = row["Close"]
            winRate = round(winRate * sellPrice /
                            buyPrice * freeRate, 3)
            kLinedf.at[rindex, rUpDown] = winRate
            OverCount += 1
            # print(rUpDown, rindex, signal, buyPrice, sellPrice, winRate)

        kLinedf.at[rindex, tUpDown] = signal

    elif posiDay == 0:
        if row[tUpDown] == 1:  # 交易信号，开仓 买入价
            signal = 1
            posiDay = 1
            buyPrice = row["Close"]
            tradeCount += 1

    else:
        pass

    kLinedf.at[rindex, rUpDown] = winRate
####################################

perWin = round(winCount/tradeCount * 100, 1)  # 止盈平仓次数占比%
perLoss = round(lossCount/tradeCount*100, 1)  # 止盈平仓次数占比%
perOver = round(OverCount/tradeCount*100, 1)  # 超期平仓次数占比%
percDown = round(cDownCount/tradeCount*100, 1)  # 死叉平仓次数占比%

# print(f"{SecurityID}:{rUpDown}:{winRate}:交易次数:{tradeCount}, {winLim}止盈:{winCount}次{perWin}%,
# {lossLim}止损:{lossCount}次{perLoss}%, {dayLim}日超期:{OverCount}次{perOver}%,
# {cDownLim}死叉:{cDownCount}次{percDown}%  ")

# maTacticdf.loc[maTacticdf.shape[0]] = [SecurityID, rUpDown, today, winRate, tradeCount,
#                                        winLim, winCount, perWin, lossLim, lossCount, perLoss, dayLim, OverCount,
#                                        perOver, cDownLim, cDownCount, percDown]

####################################
