# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import tushare as ts
import pandas as pd
import numpy as np


class MAStrategy(object):
    def __init__(self, bars, short_window=5, long_window=60):
        self.bars = bars
        self.short_window = short_window
        self.long_window = long_window

    def MA(self, price, windows=5, period=1):
        MAprice = pd.Series(price).rolling(window=windows).mean()
        return MAprice

    def gen_signal(self):
        signals = pd.DataFrame(index=self.bars.index)
        signals['flag'] = 0
        signals['sma'] = self.MA(self.bars['close'], self.short_window, 1)
        signals['lma'] = self.MA(self.bars['close'], self.long_window, 1)
        signals.loc[self.short_window:, ['flag']] = np.where(
            signals['sma'][self.short_window:] > signals['lma'][self.short_window:], 1, 0)
        signals['signal'] = signals['flag'].diff().fillna(signals['flag'][0])
        return signals


class MATrade(object):
    def __init__(self, bars, signals, init_capital=100000):
        self.bar = bars
        self.init_capital = init_capital
        self.signals = signals

    def gen_position(self):
        positions = self.signals['flag']*1000
        return positions

    def trade_positions(self):
        positions = self.signals['signal']*1000
        return positions

    def trade_tracing(self):
        capital = pd.DataFrame(index=self.signals.index)
        capital['hold'] = self.gen_position()*self.bar['close']  # 持仓
        capital['rest'] = self.init_capital - \
            (self.trade_positions()*bars['close']
             ).cumsum()  # 用总资金减去每天的市值得出剩余资金
        capital['total'] = capital['hold']+capital['rest']  # 总资产变化
        capital['return'] = capital['total'].pct_change().fillna(
            capital['total'][0]/self.init_capital-1)
        return capital


if __name__ == '__main__':
    bars = ts.get_hist_data('002211', start='2020-01-01',
                            end='2021-03-01').sort_index()
    test_strategy = MAStrategy(bars)
    signals = test_strategy.gen_signal()
    test_trade = MATrade(bars, signals)
    capital = test_trade.trade_tracing()
    print(capital, signals)
