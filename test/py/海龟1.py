import tushare as ts
import pandas as pd

def tur10(stock_list):

    '''''process stock'''
    is_buy    = 0
    buy_val   = []
    buy_date  = []
    sell_val  = []
    sell_date = []

    df = ts.get_hist_data(STOCK)
    close = df.close
    open = df.open
    highest = pd.rolling_max(df['close'], 10)
    lower = pd.rolling_min(df['close'], 10)
    rate = 1.0
    idx = len(close)

    while idx > 0:
        idx -= 1
        close_val = close[idx]
        open_val = open[idx]
        highest_val = highest.shift(1)[idx]
        lower_val = lower.shift(1)[idx]

        if close_val > highest_val:
                if is_buy == 0:
                        is_buy = 1
                        buy_val.append(close_val)
                        buy_date.append(close.keys()[idx])
        elif close_val<lower_val:
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
    STOCK = '600898'       ##婵炶揪绠戣ぐ鍌炴煣閹偊鏀?
    tur10(STOCK)