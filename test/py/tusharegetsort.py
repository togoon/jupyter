
import tushare as ts
import pandas as pd

df = ts.get_h_data('300334',start = '2017-06-01',end = '2017-09-01')


df1 = df.sort_index(axis=0)

df1['ma20'] =pd.rolling_mean(df1['close'], 20)

df1.dropna(axis=0, how='any', thresh=None, subset=None, inplace=True)


print(df)