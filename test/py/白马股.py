import datetime

import pandas as pd

import talib

start = '2015-01-01' # 回测起始时间

end = '2016-01-10' # 回测结束时间

benchmark = 'HS300' # 策略参考标准

#universe =DynamicUniverse('A') # 证券池，支持股票和基金

capital_base = 1000000 # 起始资金

freq = 'd' # 策略类型，'d'表示日间策略使用日线回测，'m'表示日内策略使用分钟线回测

refresh_rate = 1 # 调仓频率，表示执行handle_data的时间间隔，若freq = 'd'时间间隔的单位为交易日，若freq = 'm'时间间隔为分钟



'''白马股策略

买入策略：

1.均线多头排列

2.kdj的k值80以下

3.收盘价在布林线中轨以上

卖出策略：

当收盘价回到布林线中轨以下时，卖出

'''

def initialize(account): # 初始化虚拟账户状态

    pass

def handle_data(account): # 每个交易日的买入卖出指令

#找出股票的ma，kdj指标因子

    df = ts.get_hist_data(STOCK)
    ma5 = df[u'ma5']
    ma10 = df[u'ma10']
    ma20 = df[u'ma20']
    ma60 = df[u'ma60']
#找出多头的股票

    df=df[df['ma5']>df['ma10']]

    df=df[df['ma10']>df['ma20']]

    df=df[df['ma20']>df['ma60']]

#找出k指标大于80的股票

df=df[df['KDJ_K']<80]

buy_list=list(df['secID'])

#获取当日持仓的股票

sale_list=account.avail_security_position.keys()

#print buy_list

#找出收盘价在布林线中轨以上的股票

buy_list=list(set(buy_list)-set(sale_list))

df2=DataAPI.MktEqudGet(tradeDate=account.current_date,secID=buy_list,isOpen="",field=u"secID,closePrice",pandas="1")

df_buy=pd.merge(df,df2)

df_buy=df_buy[df_buy['MA20']<df_buy['closePrice']]

#每只股票买入100股

for i in df_buy['secID']:

    order(i,100)

#卖出股价在布林线中轨以下的股票

if sale_list:

    df_s1=DataAPI.MktStockFactorsOneDayGet(tradeDate=account.current_date,secID=sale_list,field=u"secID,MA20",pandas="1")

    df_s2=DataAPI.MktEqudGet(tradeDate=account.current_date,secID=sale_list,isOpen="",field=u"secID,closePrice",pandas="1")

    df_s=pd.merge(df_s1,df_s2)

    df_s=df_s[df_s['MA20']>df_s['closePrice']]

#print df_s['secID']

for j in df_s['secID']:

    order_to(j,0)

#s_list=df_s.index

#df_s.drop(df_s.columns[2],axis=1,inplace=False)

