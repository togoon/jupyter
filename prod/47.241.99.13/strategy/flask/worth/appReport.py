import sqlite3
from datetime import datetime,timedelta
import time
import os

from pandas.core.frame import DataFrame
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from flask import Flask, request, jsonify, render_template, session, redirect, send_from_directory, url_for

import requests
import json
import time
import base64

import pymysql
import sqlalchemy
from sqlalchemy import create_engine


version = '2.2.0'

worthDir = '/root/FIL/strategy/flask/worth'
dbfile = '%s/%s' % ('/root/FIL_test/trace', 'trace.db')

###############################################################################

nameList1 = ['similarity','Panel_mom2']  #策略名称 , 'Panel_mom', 'Pyemd2', 'similarity'
amtDict1 = {'similarity':10000,'Pyemd2':10000,'Panel_mom2':10000} #单笔下单金额 
sidDict1 = {}
totalWorthdf1 = pd.DataFrame()
csvdf1 = pd.DataFrame()
qryTime1 = 0

def getWorth1(nameList):
    
    global totalWorthdf1, csvdf1, qryTime1
    
    if time.time() - qryTime1 < 300:
        return
    else:
        qryTime1 = time.time()

    conn = sqlite3.connect(dbfile)
    infodf = pd.read_sql(' select name, sid, time from info ', conn) 

    #print(f'{infodf=}')

    csvdf1 = pd.DataFrame(columns=['name', 'sid', 'starttime', 'curtime', 'runtime', 'amtSingle', 'quota', 'worth', 'profitRate', 'tradeCount', 'profitRateYear', 'note'])

    totalWorthdf1 = pd.DataFrame()

    for name in nameList:
        #print(f'{name=}')
        sid = infodf.loc[ infodf.loc[infodf['name']==name].index[0] , 'sid'] #5
        sidDict1[name] = sid

        timeSec = infodf.loc[ infodf.loc[infodf['name']==name].index[0] , 'time'] #1655134268142
        starttime = str(datetime.fromtimestamp(timeSec/1000))[:10] #2022-06-14 09:21:43.233000
        curtime = time.strftime("%Y-%m-%d")  #2022-06-16  %Y-%m-%d %H:%M:%S
        difftime = datetime.strptime(curtime, "%Y-%m-%d") - datetime.strptime(starttime, "%Y-%m-%d")
        runtime = difftime.days
        amtSingle = amtDict1[name]

        # quotadf = pd.read_sql(f" select * from worth where {sid=} and time in ( select min(time) from worth where {sid=} ) ", conn) 
        # print(f'{quotadf=}')
        # quota = quotadf.loc[0, 'cashworth']
        
        # worthdf = pd.read_sql(f" select * from worth where {sid=} and time in ( select max(time) from worth where {sid=} ) ", conn) 
        worthdf = pd.read_sql(f" select * from worth where {sid=} ", conn)  
        worthdf['totalworth'] = worthdf['cashworth'] + worthdf['usdtcontractworth'] + worthdf['tokencontractworth']
        worthdf['name'] = name
        worthdf['sid'] = sid 
        
        worthdf['dateTime'] = worthdf['time'].apply(lambda x: datetime.fromtimestamp(x/1000).strftime('%Y-%m-%d %H:%M:%S')) # '%Y-%m-%d %H:%M:%S'
        worthdf['date'] = worthdf['time'].apply(lambda x: datetime.fromtimestamp(x/1000).strftime('%Y%m%d')) # '%Y-%m-%d %H:%M:%S'

        worthdf['totalworth'].plot( figsize=(20,8))

        quota = worthdf.loc[0, 'totalworth']
        worth = worthdf.loc[worthdf.index[-1], 'totalworth']
        # worth = float(worthdf.loc[worthdf.index[-1], 'cashworth']) + float(worthdf.loc[worthdf.index[-1], 'usdtcontractworth']) + float(worthdf.loc[worthdf.index[-1], 'tokencontractworth'])

        profitRate = "%.2f" % ((worth-quota)/quota *100) #amtSingle

        tradeCountdf = pd.read_sql(f" select count(*) from trades where {sid=} ", conn) 
        tradeCount = tradeCountdf.iloc[0,0]

        profitRateYear = "%.2f" % (float(profitRate)/runtime *365) 
        note = '--'

        csvdf1.loc[len(csvdf1.index)] = [name, sid, starttime, curtime, runtime, amtSingle, quota, worth, profitRate, tradeCount, profitRateYear, note]

        totalWorthdf1 = pd.concat([totalWorthdf1,worthdf],ignore_index=True)

        fig = plt.figure(figsize=(13, 4) )
        ax1 = plt.subplot2grid((1, 50), (0, 0), colspan=19, rowspan=1) 
        ax2 = plt.subplot2grid((1, 50), (0, 25), colspan=24, rowspan=1) 
        
        worthdf['totalworth'].plot( title=f'{name}-worth-5min', ax=ax2) #20,8 , figsize=(7,3)
        # plt.savefig('%s/%s/%s_5min.jpg' % (worthDir,'static', name), transparent=True, bbox_inches='tight') #png jpg 

        worthdf.groupby('date').last().plot( y='totalworth', title=f'{name}-worth-day', label=None, rot=60, ax=ax1)  #, figsize=(5,3)
        plt.savefig('%s/%s/%s.jpg' % (worthDir,'static', name), transparent=True, bbox_inches='tight') #png jpg
        plt.cla()
        plt.close("all")


    csvdf1.columns = ['策略名称', '策略ID', '启动时间', '截止时间', '运行时间(日)', '单笔下单金额', '期初额', '当前净值', '收益率%', '交易次数', '年化收益率%', '备注']

    # print(f'{csvdf}')

    #csvdf.to_csv('%s/worth_%s1.csv' % (os.getcwd() , time.strftime("%Y%m%d") ), index=None)
    #csvdf1.to_csv('%s/%s/worth_%s1.csv' % (worthDir, 'static',time.strftime("%Y%m%d") ), index=None) #
    #totalWorthdf1.to_pickle('%s/%s/%s1.pkl' % (worthDir, 'static', "totalWorthdf" ) )

    conn.close()

###############################################################################


amtDict2 = {'similarity2':1000000} #单批下单金额  ,'Pyemd2':10000,'Panel_mom2':10000
debugList2 = ['Panel_mom2', 'Panel_mom3', 'factorcheck' ] # 调试运行的策略 'logic'

totalWorthdf2 = pd.DataFrame()
csvdf2 = pd.DataFrame()
qryTime2 = 0

def getWorth2():
    global totalWorthdf2, csvdf2, qryTime2
    
    if time.time() - qryTime2 < 300:
        return
    else:
        qryTime2 = time.time()

    amtSingle = 1000000

    csvdf2 = pd.DataFrame(columns=['name', 'sid', 'starttime', 'curtime', 'runtime', 'amtSingle', 'quota', 'worth', 'profitRate', 'tradeCount', 'profitRateYear', 'note'])

    totalWorthdf2 = pd.DataFrame()

    # conn = pymysql.connect(host="127.0.0.1", port=3300, user="root", password="fil2022", database="Trace_testtrace",charset='utf8')  #warning

    engine = create_engine('mysql+pymysql://root:fil2022@localhost:3300/Trace_testtrace',encoding='utf-8')
    conn = engine.connect()  

    infodf = pd.read_sql(f"select * from info" , con=conn) 
    mainaccdf = pd.read_sql(f"select * from mainaccount" , con=conn) 
    subaccdf = pd.read_sql(f"select * from subaccount" , con=conn) 

    # print(f'{infodf=}')

    for index, rows in infodf.iterrows():
        if rows['state'] == 1 or rows['name'] in debugList2 : # or rows['name'] == 'modifiedmom':
            continue

        mainID = rows['mainID']
        subID = rows['subID']
        strategyID = rows['strategyID']
        name = rows['name']
        sid = subID

        # if strategyID != 2:  # 仅 similarity2  2  
        #     continue

        mainname = mainaccdf.loc[ mainaccdf.loc[mainaccdf['accountid']==mainID].index[0], 'name']
        subname = subaccdf.loc[ subaccdf.loc[(subaccdf['accountid']==subID) & (subaccdf['mainAccountID']==mainID) ].index[0], 'name']
        strategyname = name

        worthdf = pd.read_sql(f"select * from worth where {mainID=} and {subID=} and {strategyID=}", con=conn)  
        worthdf['totalworth'] = worthdf['cashworth'].astype(float) + worthdf['usdtcontractworth'].astype(float) + worthdf['tokencontractworth'].astype(float)
        worthdf['name'] = name
        worthdf['sid'] = strategyID 

        worthdf['dateTime'] = worthdf['time'].apply(lambda x: datetime.fromtimestamp(x/1000).strftime('%Y-%m-%d %H:%M:%S')) # '%Y-%m-%d %H:%M:%S'
        worthdf['date'] = worthdf['time'].apply(lambda x: datetime.fromtimestamp(x/1000).strftime('%Y%m%d')) # '%Y-%m-%d %H:%M:%S'

        # print(f'{worthdf=}')

        timeSec = infodf.loc[ infodf.loc[infodf['name']==name].index[0] , 'time'] #1655134268142
        starttime = str(datetime.fromtimestamp(timeSec/1000))[:10] #2022-06-14 09:21:43.233000
        curtime = time.strftime("%Y-%m-%d")  #2022-06-16  %Y-%m-%d %H:%M:%S
        difftime = datetime.strptime(curtime, "%Y-%m-%d") - datetime.strptime(starttime, "%Y-%m-%d")
        runtime = difftime.days
        amtSingle = amtSingle  if name not in amtDict2 else amtDict2[name]

        worth = worthdf.loc[worthdf.index[-1], 'totalworth']

        transferdf = pd.read_sql(f"select * from transferlog where {mainname=} and {subname=} and {strategyname=} and asset='USDT' ", con=conn)  
        quota = transferdf['amount'].astype(float).sum()
        profitRate = "%.2f" % ((worth-quota)/quota *100) if quota > 0 else 0  #amtSingle

        profitRateYear = "%.2f" % (float(profitRate)/runtime *365) if runtime != 0 else 0 
        note = '--'    

        tradeCountdf = pd.read_sql(f"select count(*) from trades where {mainID=} and {subID=} and {strategyID=} ", conn) 
        tradeCount = tradeCountdf.iloc[0,0]

        name = name if name != 'testStrategy' else 'similarity2'

        fig = plt.figure(figsize=(13, 4) )
        ax1 = plt.subplot2grid((1, 50), (0, 0), colspan=19, rowspan=1) 
        ax2 = plt.subplot2grid((1, 50), (0, 25), colspan=24, rowspan=1) 
        
        worthdf['totalworth'].plot( title=f'{name}-worth-5min', ax=ax2) #20,8 , figsize=(7,3)
        # plt.savefig('%s/%s/%s_5min.jpg' % (worthDir,'static', name), transparent=True, bbox_inches='tight') #png jpg 

        worthdf.groupby('date').last().plot( y='totalworth', title=f'{name}-worth-day', label=None, rot=60, ax=ax1)  #, figsize=(5,3)
        plt.savefig('%s/%s/%s.jpg' % (worthDir,'static', name), transparent=True, bbox_inches='tight') #png jpg
        plt.cla()
        plt.close("all")

        if 'test' not in name:
            csvdf2.loc[len(csvdf2.index)] = [name, strategyID, starttime, curtime, runtime, amtSingle, quota, worth, profitRate, tradeCount, profitRateYear, note]

        totalWorthdf2 = pd.concat([totalWorthdf2,worthdf],ignore_index=True)

    conn.close()

    csvdf2.columns = ['策略名称', '策略ID', '启动时间', '截止时间', '运行时间(日)', '单批下单金额', '期初额', '当前净值', '收益率%', '交易次数', '年化收益率%', '备注']

    # print(f'{csvdf=}')

    #csvdf2.to_csv('%s/%s/worth_%s2.csv' % (worthDir , 'static', time.strftime("%Y%m%d") ), index=None)
    # totalWorthdf2.to_pickle('%s/%s/%s2.pkl' % (worthDir , 'static', "totalWorthdf" ) ) #



###############################################################################



html_string = '''
    <html>
    <head>
        <meta charset="utf-8">
        <title>Worth Curve</title>

        <style type="text/css">
            .worth {{
                border-collapse: collapse;
                text-align: center;
            }}
            .worth td, th {{
                border: 1px solid #cad9ea;
                color: #666;
                height: 30px;
                padding: 5px; 
                font-family:verdana,arial,sans-serif;
                font-size: 10pt;
            }}
            .worth thead th {{
                background-color: #CCE8EB;
                width:auto ;
                min-width: 30px;
                overflow:hidden;
                white-space:nowrap;
                text-overflow:ellipsis;   
            }}
            .worth tr:nth-child(odd) {{
                background: #fff;
            }}
            .worth tr:nth-child(even) {{
                background: #F5FAFA;
            }}
            .worth tr:hover {{
                background: #eee;
                cursor: pointer;
            }}
        </style>
        <link rel="stylesheet" type="text/css" href="static/worth.css"/>
    </head>
    <body>
        <h1 >一. V2.4版策略净值(模拟盘): </h1>
        <div style="max-width:1000px; text-align:right;"> 更新时间: {updateTimeEle}</div>
        <h2 >1. 策略净值表: </h2>
        {tableEle2}
        <br/>
        <h2 >2. 净值曲线图: </h2>
        {plotEle2}

        <br/><br/>

        <h1 >二. V1版策略净值(模拟盘旧版本): </h1>
        <h2 >1. 策略净值表: </h2>
        {tableEle1}
        <br/>
        <h2 >2. 净值曲线图: </h2>
        {plotEle1}

        <br/><br/><br/><br/><br/><br/>

    </body>
    </html>
'''

app = Flask(__name__)

@app.route('/worth', methods=("POST", "GET"))
def setworthhtml():
    
    getWorth1(nameList1) 
    plotEleList1 = []
    for index, rows in csvdf1.iterrows():
        imgStr = '<h3 >2.{index} {name}策略(模拟盘): </h3> <img src="static/{name}.jpg" ><br/>'.format(name=rows['策略名称'], index=index+1)
        plotEleList1.append(imgStr)

    getWorth2()
    plotEleList2 = []
    for index, rows in csvdf2.iterrows():
        imgStr = '<h3 >2.{index} {name}策略(模拟盘): </h3> <img src="static/{name}.jpg" ><br/>'.format(name=rows['策略名称'], index=index+1)
        plotEleList2.append(imgStr)

    updatetime = time.strftime("%Y-%m-%d %H:%M:%S")

    with open('templates/worth.html', 'w') as f:
        f.write(html_string.format( tableEle1=csvdf1.to_html(classes='worth'), plotEle1=''.join(plotEleList1), tableEle2=csvdf2.to_html(classes='worth'), plotEle2=''.join(plotEleList2), updateTimeEle=updatetime ) )

    return render_template('worth.html')

def getImgStream(imgPath):
    imgStream = ''
    with open(imgPath, 'rb') as f:
        img_byte = f.read()
    imgStream = base64.b64encode( img_byte ).decode('ascii')  #'utf8' 'ascii'
    return imgStream

@app.route('/worthpt', methods=("POST", "GET"))
def setworthpthtml():
    
    print(f'--setworthpthtml--1--')
    getWorth1(nameList1) 
    plotEleList1 = []
    for index, rows in csvdf1.iterrows():
        imgStream = getImgStream('%s/%s/%s.jpg' % (worthDir,'static', rows['策略名称']))
        imgStr = '<h3 >2.{index} {name}策略: </h3> <img src="data:image/jpg;base64,{imgStream}" ><br/>'.format(index=index+1, name=rows['策略名称'], imgStream=imgStream)
        plotEleList1.append(imgStr)

    print(f'--setworthpthtml--2--')
    getWorth2()
    plotEleList2 = []
    for index, rows in csvdf2.iterrows():
        imgStream = getImgStream('%s/%s/%s.jpg' % (worthDir,'static', rows['策略名称']))
        imgStr = '<h3 >2.{index} {name}策略(模拟盘): </h3> <img src="data:image/jpg;base64,{imgStream}" ><br/>'.format(name=rows['策略名称'], index=index+1, imgStream=imgStream)
        plotEleList2.append(imgStr)

    updatetime = time.strftime("%Y-%m-%d %H:%M:%S")

    print(f'--setworthpthtml--3--')    
    with open('templates/worth.html', 'w') as f:
        f.write(html_string.format(tableEle1=csvdf1.to_html(classes='worth'), plotEle1=''.join(plotEleList1), tableEle2=csvdf2.to_html(classes='worth'), plotEle2=''.join(plotEleList2), updateTimeEle=updatetime  ) )

    print(f'--setworthpthtml--4--')
    return render_template('worth.html')


getWorth1(nameList1)
getWorth2()

if __name__ == '__main__':
    
    # app.run(debug=True,host='127.0.0.1', port=8088)
    # app.run(debug=True)
    # app.config['DEBUG'] = True
    
    app.jinja_env.auto_reload = True
    app.config['TEMPLATES_AUTO_RELOAD'] = True
    app.config['SEND_FILE_MAX_AGE_DEFAULT'] = timedelta(seconds=10)
    # app.config['FLASK_ENV'] = 'development'

    app.run(host='127.0.0.1', port=5555)

    
# nohup python3 -u  -m flask run >> log.txt 2>&1  &
# python -m flask run -p 8088 -h 127.0.0.2     # FLASK_APP=hello
# export FLASK_ENV=development #development开发 production生产
# export FLASK_DEBUG=1 #调试器 1为开启，0为关闭。
# curl http://localhost:5000/worthpt
