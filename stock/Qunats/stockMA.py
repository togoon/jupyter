##导入模块 初始化 清空#####单股票 MA 批量参数########

import os
import time
import math

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

import akshare as ak
import talib

# print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))

today = time.strftime('%Y%m%d')  # 20220221 #8位
dirPath = '/home/at/ipynb/QL'
eNameFile = 'eName.csv'
eNamePath = os.path.join(dirPath, eNameFile)
eName_df = pd.read_csv(eNamePath)

xgFile = 'XG.EBK'   # XG.blk XG.EBK
xgPath = os.path.join(dirPath, xgFile)

maTacFile = 'maTac.csv'
maTaccsvPath = os.path.join(dirPath, maTacFile)

maTacticFile = 'maTactic.pkl'
maTacticPath = os.path.join(dirPath, maTacticFile)
# maTacticdf = pd.read_pickle(maTacticPath)
maTacticdf = pd.DataFrame(columns=['SecurityID', 'rUpDown', 'Date', 'winRate', 'tradeCount',
                                   'winLim', 'winCount', 'perWin', 'lossLim', 'lossCount', 'perLoss',
                                   'dayLim', 'OverCount', 'perOver', 'cDownLim', 'cDownCount', 'percDown'])

tradeFile = 'trade.pkl'
tradePath = os.path.join(dirPath, tradeFile)
# tradedf = pd.read_pickle(tradePath)
tradedf = pd.DataFrame(columns=['rindex', 'SecurityID', 'TradeDate', 'Close', 'High', 'Low', 'winLim',
                                'lossLim', 'dayLim', 'cDownLim', 'rUpDown', 'posiDay', 'signal', 'buyPrice', 'sellPrice',
                                'curRate', 'winRate', 'tradeCount', 'winCount', 'lossCount', 'OverCount', 'cDownCount'])

kHistFile = 'kHist.pkl'
kHistPath = os.path.join(dirPath, kHistFile)
kHistdf = pd.read_pickle(kHistPath)
# kHistdf.to_pickle(kHistPath)


##单股票 参数 批量 公共数据 kLinedf########

SecurityID = '300942'  # 300390  300942

# stock_zh_a_hist_df = ak.stock_zh_a_hist(symbol=SecurityID, period="daily", adjust="qfq")
# stock_zh_a_hist_df.insert(0, '代码', SecurityID, allow_duplicates=False)
# kHistdf = stock_zh_a_hist_df.copy(deep=True)

kLinedf = kHistdf[kHistdf['代码'] == SecurityID].tail(
    700).copy(deep=True)  # 140 280 420 560 700
kLinedf = kLinedf.reset_index(drop=True)

eName_hist = eName_df[eName_df.dfcf.isin(kLinedf.columns.values.tolist())]
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

for iList in [30, 60, 90, 120, 250]:
    kLinedf['On'+str(iList)] = 0
    kLinedf.loc[kLinedf.Close[(
        kLinedf.Close > kLinedf['Ma'+str(iList)])].index, 'On'+str(iList)] = 1  # 均线之上


##单股票 全部参数 批量循环 ########

print('start:', time.strftime("%Y-%m-%d %H:%M:%S"), '\n')

# SecurityID = '300390'
loopCount = 0
freeRate = 0.997  # 税费率

for i in range(2, 20+1):  # 品种->均线1金叉->循环 range(2, 20+1)  [2]
    cUp = 'cUp'+str(i)
    for cDownLim in [-1, -2]:  # 死叉-1信号 -2禁用 [-1, -2] [-2]
        for j in range(2, 20+1):  # 品种->均线1金叉->均线2死叉->循环 range(2, 20+1)  [2]
            tUpDown = 'tU'+str(i) + 'D'+str(j)  # 交易信号 数组列
            rUpDown = 'rU'+str(i) + 'D'+str(j)  # 收益率 数组列
            cDown = 'cDown'+str(j)  # 死叉信号 数组列

            # 止盈 [0.03, 0.05]  [x/100 for x in range(3, 30, 2) ] + [0.10]
            for winLim in [x/100 for x in range(3, 30, 2)] + [0.10]:
                for lossLim in [-0.03, -0.05, -0.08, -2]:  # 止损 -2禁用 [-0.03, -0.05, -0.08]
                    for dayLim in [3, 5, 7, 10]:  # 持仓天数限制 5

                        # SecurityID = '300390'
                        # winLim = 0.233  # 止盈 0.03, 0.05
                        # lossLim = -0.08  # 止损 -0.05 -0.03,-2
                        # dayLim = 5  # 持仓天数限制 3, 5, 7, 10
                        # cDownLim = -2  # 死叉信号  -1, -2
                        # freeRate = 0.997  # 税费率

                        signal = 0    # 当前交易信号
                        winRate = 1.0  # 总收益率 *
                        curRate = 0.0  # 当前收益率 *
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

                        # i = 2  # 3
                        # j = 2  # 9
                        # Ma = 'Ma'+str(i)
                        # tUpDown = 'tU'+str(i) + 'D'+str(j)  # 交易信号 数组列
                        # rUpDown = 'rU'+str(i) + 'D'+str(j)  # 收益率 数组列

                        # cUp = 'cUp'+str(i)
                        # cDown = 'cDown'+str(j)  # 死叉信号 数组列

                        ####################################

                        kLinedf[rUpDown] = 1.0
                        kLinedf[tUpDown] = 0
                        kLinedf.loc[(kLinedf[cUp] == 1),
                                    tUpDown] = 1  # 交易信号 数组列 金叉

                        # kLinedf.loc[(kLinedf[cUp] == 1) & ((kLinedf['On60'] == 1) | (kLinedf['On90'] == 1) | (
                        # kLinedf['On120'] == 1) | (kLinedf['On250'] == 1)), tUpDown] = 1  # 交易信号 数组列 金叉+均线之上

                        for rindex, row in kLinedf.iterrows():  # 品种->均线1金叉->均线2死叉->行->循环
                            signal = row[tUpDown]
                            if posiDay > 0:  # 持仓
                                kLinedf.at[rindex, rUpDown] = winRate
                                posiDay += 1
                                if row[tUpDown] == 1:  # 屏蔽持仓期的信号
                                    signal = 0
                                    kLinedf.at[rindex, tUpDown] = signal

                                if row["High"] > buyPrice * (1 + winLim):  # 止盈平仓
                                    signal = -1

                                    sellPrice = round(
                                        buyPrice * (1 + winLim), 2)
                                    curRate = round(
                                        sellPrice / buyPrice * freeRate - 1, 3)
                                    winRate = round(
                                        winRate * sellPrice / buyPrice * freeRate, 3)
                                    kLinedf.at[rindex, rUpDown] = winRate
                                    winCount += 1
                                    tradedf.loc[tradedf.shape[0]] = [rindex, SecurityID, row["TradeDate"], row["Close"], row["High"], row["Low"], winLim, lossLim, dayLim,
                                                                     cDownLim, rUpDown, posiDay, signal, buyPrice, sellPrice, curRate, winRate, tradeCount, winCount, lossCount, OverCount, cDownCount]

                                    posiDay = 0

                                elif row["Low"] < buyPrice * (1 + lossLim):  # 止损平仓
                                    signal = -2

                                    sellPrice = round(
                                        buyPrice * (1 + lossLim), 2)
                                    curRate = round(
                                        sellPrice / buyPrice * freeRate - 1, 3)
                                    winRate = round(
                                        winRate * sellPrice / buyPrice * freeRate, 3)
                                    kLinedf.at[rindex, rUpDown] = winRate
                                    lossCount += 1
                                    tradedf.loc[tradedf.shape[0]] = [rindex, SecurityID, row["TradeDate"], row["Close"], row["High"], row["Low"], winLim, lossLim, dayLim,
                                                                     cDownLim, rUpDown, posiDay, signal, buyPrice, sellPrice, curRate, winRate, tradeCount, winCount, lossCount, OverCount, cDownCount]

                                    posiDay = 0

                                elif row[cDown] == cDownLim:  # 死叉平仓
                                    signal = -4

                                    sellPrice = row["Close"]
                                    curRate = round(
                                        sellPrice / buyPrice * freeRate - 1, 3)
                                    winRate = round(
                                        winRate * sellPrice / buyPrice * freeRate, 3)
                                    kLinedf.at[rindex, rUpDown] = winRate
                                    cDownCount += 1
                                    tradedf.loc[tradedf.shape[0]] = [rindex, SecurityID, row["TradeDate"], row["Close"], row["High"], row["Low"], winLim, lossLim, dayLim,
                                                                     cDownLim, rUpDown, posiDay, signal, buyPrice, sellPrice, curRate, winRate, tradeCount, winCount, lossCount, OverCount, cDownCount]
                                    posiDay = 0

                                elif posiDay >= dayLim:  # 超期平仓
                                    signal = -3

                                    sellPrice = row["Close"]
                                    curRate = round(
                                        sellPrice / buyPrice * freeRate - 1, 3)
                                    winRate = round(
                                        winRate * sellPrice / buyPrice * freeRate, 3)
                                    kLinedf.at[rindex, rUpDown] = winRate
                                    OverCount += 1
                                    tradedf.loc[tradedf.shape[0]] = [rindex, SecurityID, row["TradeDate"], row["Close"], row["High"], row["Low"], winLim, lossLim, dayLim,
                                                                     cDownLim, rUpDown, posiDay, signal, buyPrice, sellPrice, curRate, winRate, tradeCount, winCount, lossCount, OverCount, cDownCount]
                                    posiDay = 0

                                kLinedf.at[rindex, tUpDown] = signal

                            elif posiDay == 0:
                                if row[tUpDown] == 1:  # 交易信号，开仓 买入价
                                    signal = 1
                                    posiDay = 1
                                    buyPrice = row["Close"]
                                    tradeCount += 1
                                    curRate = 0.0
                                    # print(rindex, SecurityID, row["TradeDate"], row["Close"], row["High"], row["Low"], rUpDown, posiDay, signal, buyPrice, sellPrice, winRate, tradeCount, winCount, lossCount, OverCount, cDownCount )

                                    tradedf.loc[tradedf.shape[0]] = [rindex, SecurityID, row["TradeDate"], row["Close"], row["High"], row["Low"], winLim, lossLim, dayLim,
                                                                     cDownLim, rUpDown, posiDay, signal, buyPrice, sellPrice, curRate, winRate, tradeCount, winCount, lossCount, OverCount, cDownCount]

                            else:
                                pass

                            kLinedf.at[rindex, rUpDown] = winRate

                        ####################################

                        perWin = round(winCount/tradeCount *
                                       100, 1)  # 止盈平仓次数占比%
                        perLoss = round(lossCount/tradeCount *
                                        100, 1)  # 止盈平仓次数占比%
                        perOver = round(OverCount/tradeCount *
                                        100, 1)  # 超期平仓次数占比%
                        percDown = round(
                            cDownCount/tradeCount * 100, 1)  # 死叉平仓次数占比%

                        loopCount += 1
                        curTime = time.strftime(
                            "%Y-%m-%d %H:%M:%S", time.localtime())
                        # print(f"[{curTime}-{loopCount}-] : {SecurityID} : {rUpDown} : {winRate}: 交易次数:{tradeCount}, {winLim}止盈:{winCount}次{perWin}%, {lossLim}止损:{lossCount}次{perLoss}%, {dayLim}日超期:{OverCount}次{perOver}%, {cDownLim}死叉:{cDownCount}次{percDown}%  ")

                        maTacticdf.loc[maTacticdf.shape[0]] = [SecurityID, rUpDown, today, winRate, tradeCount,
                                                               winLim, winCount, perWin, lossLim, lossCount, perLoss, dayLim, OverCount,
                                                               perOver, cDownLim, cDownCount, percDown]

                        ####################################

            if cDownLim == -2:
                # print(f'{i = }, {cDownLim = }, { j = }')
                break

maTacticdf.to_pickle(maTacticPath)
tradedf.to_pickle(tradePath)

print('end:', time.strftime("%Y-%m-%d %H:%M:%S"), '\n')
