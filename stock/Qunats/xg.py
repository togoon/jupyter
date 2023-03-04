# coding: utf-8

# 1 import
import os
import time
import math

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

import akshare as ak
import talib

# 历史数据-实时数据-开发调试-策略回测-模拟交易-实盘交易-运行监控-风险管理
# 2 define

timeStamp = int(round(time.time() * 1000))  # 1645371358737 #13位 毫秒
# '2017-11-07 16:47:14' %Y-%m-%d %H:%M:%S %Y%m%d
dateTime = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
today = time.strftime('%Y%m%d')  # 20220221 #8位
startTime = time.time()

dirPath = '/home/at/ipynb/QL'
curDir = os.getcwd()  # 获取当前工作目录路径

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
# print(f'{timeStamp = } , {dateTime = } , {today = } ')

# 3 akshare spotStock ST stop
# stock_zh_a_stop_em_df = ak.stock_zh_a_stop_em() #退市
stock_zh_a_st_em_df = ak.stock_zh_a_st_em()  # ST股
eName_st_df = eName_df[eName_df.dfcf.isin(
    stock_zh_a_st_em_df.columns.values.tolist())]
eName_st_df = eName_df[['dfcf', 'En']].reset_index(drop=True)
st_df = stock_zh_a_st_em_df.copy(deep=True)
st_df.rename(columns=dict(eName_st_df.values.tolist()), inplace=True)

stock_tfp_em_df = ak.stock_tfp_em(date=today)  # 停复牌 20220221
eName_stop_df = eName_df[eName_df.dfcf.isin(
    stock_tfp_em_df.columns.values.tolist())]
eName_stop_df = eName_df[['dfcf', 'En']].reset_index(drop=True)
stop_df = stock_tfp_em_df.copy(deep=True)
stop_df.rename(columns=dict(eName_stop_df.values.tolist()), inplace=True)

# time.sleep(1)  # 休眠1秒

stock_zh_a_spot_em_df = ak.stock_zh_a_spot_em()

eName_aSpot = eName_df[eName_df.dfcf.isin(
    stock_zh_a_spot_em_df.columns.values.tolist())]
eName_aSpot = eName_aSpot[['dfcf', 'En']].reset_index(drop=True)
stock_zh_a_spot_em_df.rename(columns=dict(
    eName_aSpot.values.tolist()), inplace=True)

aSpot = stock_zh_a_spot_em_df.copy(deep=True)
aSpot.drop(aSpot.index, inplace=True)  # 表头 空表

# time.sleep(1)  # 休眠1秒

# 4 block load
with open(xgPath, 'r', encoding='utf-8') as f:
    str_data = f.read().splitlines()

print('str_data len:', len(str_data)-1, '\t',
      time.strftime("%Y-%m-%d %H:%M:%S"), '\n', str_data)

stStock = []
stDict = {}
stopStock = []
stopDict = {}

for iXg in str_data:
    SecurityID = iXg[-6:]

    if SecurityID in st_df.SecurityID.values.tolist():
        stStock.append(SecurityID)
        stDict[SecurityID] = st_df.Symbol.loc[st_df["SecurityID"]
                                              == SecurityID].values[0]

    if SecurityID in stop_df.SecurityID.values.tolist():
        stopStock.append(SecurityID)
        stopDict[SecurityID] = stop_df.Symbol.loc[stop_df["SecurityID"]
                                                  == SecurityID].values[0]

    if len(SecurityID) == 6:
        aSpot = aSpot.append(
            stock_zh_a_spot_em_df.loc[stock_zh_a_spot_em_df["SecurityID"] == SecurityID])
    else:
        continue

    if stDict:
        print(f'{stDict = }')

    if stopDict:
        print(f'{stopDict = }', '\n')

aSpot = aSpot.reset_index(drop=True)

for indexA, rowA in aSpot.iterrows():  # 品种循环
    SecurityID = rowA['SecurityID']
    if len(SecurityID) != 6:
        continue

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

    # winLim = 0.03  # 止盈
    # lossLim = -0.05  # 止损
    # dayLim = 5  # 持仓天数限制
    # cDownLim = -1  # 死叉信号

    freeRate = 0.997  # 税费率
    for i in range(2, 20+1):  # 品种->均线1金叉->循环
        cUp = 'cUp'+str(i)

        for cDownLim in [-1, -2]:  # 死叉信号 -2禁用

            for j in range(2, 20+1):  # 品种->均线1金叉->均线2死叉->循环
                tUpDown = 'tU'+str(i) + 'D'+str(j)  # 交易信号 数组列
                kLinedf[tUpDown] = 0

                # bUpDown = 'bU'+str(i) +'D'+str(j)
                # kLinedf[bUpDown] = kLinedf.Close

                # sUpDown = 'sU'+str(i) +'D'+str(j)
                # kLinedf[sUpDown] = kLinedf.Close

                rUpDown = 'rU'+str(i) + 'D'+str(j)  # 收益率 数组列
                kLinedf[rUpDown] = 1.0

                cDown = 'cDown'+str(j)  # 死叉信号 数组列

                for winLim in [0.03, 0.05]:  # 止盈
                    for lossLim in [-0.03, -0.05, -2]:  # 止损 -2禁用
                        for dayLim in [3, 5, 7, 10]:  # 持仓天数限制

                            ####################################
                            # winLim = 0.03  # 止盈
                            # lossLim = -0.05  # 止损
                            # dayLim = 5  # 持仓天数限制
                            # cDownLim = -1  # 死叉信号

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

                            kLinedf.loc[(kLinedf[cUp] == 1) & ((kLinedf['On60'] == 1) | (kLinedf['On90'] == 1) | (
                                kLinedf['On120'] == 1) | (kLinedf['On250'] == 1)), tUpDown] = 1  # 交易信号 数组列 金叉+均线之上

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

                            perWin = round(winCount/tradeCount *
                                           100, 1)  # 止盈平仓次数占比%
                            perLoss = round(
                                lossCount/tradeCount*100, 1)  # 止盈平仓次数占比%
                            perOver = round(
                                OverCount/tradeCount*100, 1)  # 超期平仓次数占比%
                            percDown = round(
                                cDownCount/tradeCount*100, 1)  # 死叉平仓次数占比%

                            # print(f"{SecurityID}:{rUpDown}:{winRate}:交易次数:{tradeCount}, {winLim}止盈:{winCount}次{perWin}%,
                            # {lossLim}止损:{lossCount}次{perLoss}%, {dayLim}日超期:{OverCount}次{perOver}%,
                            # {cDownLim}死叉:{cDownCount}次{percDown}%  ")

                            maTacticdf.loc[maTacticdf.shape[0]] = [SecurityID, rUpDown, today, winRate, tradeCount,
                                        winLim, winCount, perWin, lossLim, lossCount, perLoss, dayLim, OverCount,
                                        perOver, cDownLim, cDownCount, percDown]

                            ####################################

                if cDownLim == -2:
                    print(f'{i = }, {cDownLim = }, { j = }')
                    break

    # time.sleep(1)
    maTacticdf.to_pickle(maTacticPath)

    print(aSpot.shape[0]-1, '-', indexA, '', f'{SecurityID}', ':', time.time() -
          startTime, '\t', time.strftime("%Y-%m-%d %H:%M:%S"))

# 降序 False ,  'winRate', 'perWin' ,
maTacticdf = maTacticdf.sort_values(['winRate'], ascending=[False])
# print(maTacticdf.describe())

maTacticdf.to_pickle(maTacticPath)
maTacticdf.to_csv(maTaccsvPath, index=False)

print("Time used:", time.time() - startTime, '\t',
      time.strftime("%Y-%m-%d %H:%M:%S"), '\t rows:', maTacticdf.shape[0])

print(maTacticdf.describe())

exit
