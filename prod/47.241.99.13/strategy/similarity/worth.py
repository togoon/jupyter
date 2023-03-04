from datetime import datetime,timedelta
import time
import os

from pandas.core.frame import DataFrame
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

import pymysql
import sqlite3
import sqlalchemy
from sqlalchemy import create_engine

amtSingle = 1000000
amtDict = {'similarity':1000000} #单批下单金额  ,'Pyemd2':10000,'Panel_mom2':10000

csvdf = pd.DataFrame(columns=['name', 'sid', 'starttime', 'curtime', 'runtime', 'amtSingle', 'quota', 'worth', 'profitRate', 'tradeCount', 'profitRateYear', 'note'])

totalWorthdf = pd.DataFrame()

# conn = pymysql.connect(host="127.0.0.1", port=3300, user="root", password="fil2022", database="Trace_testtrace",charset='utf8')  #warning

engine = create_engine('mysql+pymysql://root:fil2022@localhost:3300/Trace_testtrace',encoding='utf-8')
conn = engine.connect()  

infodf = pd.read_sql(f"select * from info" , con=conn) 
mainaccdf = pd.read_sql(f"select * from mainaccount" , con=conn) 
subaccdf = pd.read_sql(f"select * from subaccount" , con=conn) 

# print(f'{infodf=}')

for index, rows in infodf.iterrows():
    if rows['state'] == 1:
        continue

    mainID = rows['mainID']
    subID = rows['subID']
    strategyID = rows['strategyID']
    name = rows['name']
    sid = subID

    mainname = mainaccdf.loc[ mainaccdf.loc[mainaccdf['accountid']==mainID].index[0], 'name']
    subname = subaccdf.loc[ subaccdf.loc[(subaccdf['accountid']==subID) & (subaccdf['mainAccountID']==mainID) ].index[0], 'name']
    strategyname = name

    worthdf = pd.read_sql(f"select * from worth where {mainID=} and {subID=} and {strategyID=}", con=conn)  
    worthdf['totalworth'] = worthdf['cashworth'].astype(float) + worthdf['usdtcontractworth'].astype(float) + worthdf['tokencontractworth'].astype(float)
    worthdf['name'] = name
    worthdf['sid'] = strategyID 

    worthdf['dateTime'] = worthdf['time'].apply(lambda x: datetime.fromtimestamp(x/1000).strftime('%Y-%m-%d %H:%M:%S')) # '%Y-%m-%d %H:%M:%S'
    worthdf['date'] = worthdf['time'].apply(lambda x: datetime.fromtimestamp(x/1000).strftime('%m/%d')) # '%Y-%m-%d %H:%M:%S'

    worthdf['totalworth'].tail(2000).plot( title=f'{name}-worth', figsize=(20,8))
    worthdf.groupby('date').last().plot( y='totalworth', title=f'{name}-worth')
    plt.savefig('%s/%s.jpg' % ("/root/FIL/strategy/worth", name), transparent=True, bbox_inches='tight') #png jpg
    # print(f'{worthdf=}')

    timeSec = infodf.loc[ infodf.loc[infodf['name']==name].index[0] , 'time'] #1655134268142
    starttime = str(datetime.fromtimestamp(timeSec/1000))[:10] #2022-06-14 09:21:43.233000
    curtime = time.strftime("%Y-%m-%d")  #2022-06-16  %Y-%m-%d %H:%M:%S
    difftime = datetime.strptime(curtime, "%Y-%m-%d") - datetime.strptime(starttime, "%Y-%m-%d")
    runtime = difftime.days
    amtSingle = amtSingle  if name not in amtDict else amtDict[name]

    worth = worthdf.loc[worthdf.index[-1], 'totalworth']

    transferdf = pd.read_sql(f"select * from transferlog where {mainname=} and {subname=} and {strategyname=} and asset='USDT' ", con=conn)  
    quota = transferdf['amount'].astype(float).sum()
    profitRate = "%.2f" % ((worth-quota)/quota *100) #amtSingle

    profitRateYear = "%.2f" % (float(profitRate)/runtime *365) 
    note = '--'    

    tradeCountdf = pd.read_sql(f"select count(*) from trades where {mainID=} and {subID=} and {strategyID=} ", conn) 
    tradeCount = tradeCountdf.iloc[0,0]

    csvdf.loc[len(csvdf.index)] = [name, sid, starttime, curtime, runtime, amtSingle, quota, worth, profitRate, tradeCount, profitRateYear, note]

    totalWorthdf = pd.concat([totalWorthdf,worthdf],ignore_index=True)

conn.close()

csvdf.columns = ['策略名称', '策略ID', '启动时间', '截止时间', '运行时间(日)', '单批下单金额', '期初额', '当前净值', '收益率%', '交易次数', '年化收益率%', '备注']

# print(f'{csvdf=}')

csvdf.to_csv('%s/worth_%s.csv' % ("/root/FIL/strategy/worth" , time.strftime("%Y%m%d") ), index=None)
totalWorthdf.to_pickle('%s/%s.pkl' % ("/root/FIL/strategy/worth" , "totalWorthdf" ) )
