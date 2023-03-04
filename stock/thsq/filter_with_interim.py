#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Apr  4 09:49:43 2019

@author: ZCY
"""
import pandas as pd 
import numpy as np
import pymongo 
import MySQLdb
import datetime as dt
import pytz
import time
import os
import arch
import warnings
warnings.simplefilter('ignore')
t0=time.time() #calculation for executing time
tz = pytz.timezone(pytz.country_timezones('cn')[0])
tz_utc = pytz.timezone('utc')
today=str(dt.datetime.today().date())  # update time for sql 
end=dt.datetime.today()
start=end-dt.timedelta(days=90)
pre2month=(end- dt.timedelta(days=180)).date()
import gc




def get_option_conn(use_testdb=False):             #get volatility data from sql
    mysql_config = dict()
    mysql_config['host'] = 'rdsqtehrv8tqh7v60yvujpublic.mysql.rds.aliyuncs.com'
    if use_testdb:
        mysql_config['username'] = 'optiontest'
        mysql_config['password'] = 'ThdJHe2nrDQCVFe4'
        mysql_config['database'] = 'optiondbtest'
    else:
        mysql_config['username'] = 'optionadmin'
        mysql_config['password'] = 'BAO2Ehu7nOi3m3LZ'
        mysql_config['database'] = 'optiondb'
    conn = MySQLdb.connect(mysql_config['host'], mysql_config['username'], mysql_config['password'],
                           mysql_config['database'],charset='utf8')
    conn.ping(True)
    return conn
conn=get_option_conn(use_testdb=False)
def get_mongo_cursor(col='qfq_data',db='Daily_data'):     #get mongo cursor
    client = pymongo.MongoClient(host='121.40.212.219')
    cur = client[db][col]
    return cur
def get_close_historic_price(symbol, endDate):
    field = {'close':1,'_id':0,'dateTime':1,'amount':1,'volume':1,'symbol':1,'high':1,'low':1}
    cur = cur_mongo.find({'symbol': symbol,'dateTime':{'$lte':endDate}}, field). sort('dateTime', pymongo.DESCENDING).limit(125)
    df = pd.DataFrame(list(cur)).sort_index(ascending=False)
    df['dateTime'] = df['dateTime'].apply(lambda x: tz_utc.localize(x))
    df['dateTime'] = df['dateTime'].apply(lambda x: x.astimezone(tz))
    df.set_index('dateTime',inplace=True)   
    df.sort_index(ascending=True,inplace=True)
    return df

def get_1mins_data(symbol,date):
    startDate=date-dt.timedelta(days=1)
    endDate=date+dt.timedelta(days=1)
    field = {'_id':0,'close':1,'symbol':1,'dateTime':1,'open':1,'symbol':1,'high':1,'low':1}
    cur = cur_mongo_min.find({'symbol':symbol,'dateTime':{'$gte':startDate,'$lte':endDate}},field). sort('dateTime', pymongo.DESCENDING)			  
    df = pd.DataFrame(list(cur))
    df=df.sort_values('dateTime')
    df['dateTime']=df['dateTime']+dt.timedelta(hours=8)
    df=df[['dateTime','open','close','symbol','high','low']]
    return df.reset_index()
def symbolconverter(symbol):
    if symbol[0]=='6':
        symbol='SH'+symbol
    else:
        symbol='SZ'+symbol
    return symbol

cur_mongo = get_mongo_cursor()   #mongo cursor for daily data
cur_mongo_min=get_mongo_cursor(col='one_min_data',db='Minute_data') #mongo cursor for 1min data

def initalbuyable():
    cursor=conn.cursor()
    sql="update stock set buyable= '1' where note='python' "
    cursor.execute(sql)
    conn.commit()
    cursor=conn.cursor()
    sql1="update stock set note= NULL  where note='python' "
    cursor.execute(sql1)
    conn.commit()
    
def dropsymbols(symbol,today=today):
    symbol=symbol[2:]
    cursor=conn.cursor()
    sql="update stock set buyable= '0' where stock_code='%s' " %symbol
    cursor.execute(sql)
    conn.commit()
    cursor=conn.cursor()
    sql1="update stock set note= 'python' where stock_code='%s' " %symbol
    cursor.execute(sql1)
    conn.commit()
    cursor=conn.cursor()
    sql2="update stock set add_rate_update_time= '%s' where stock_code='%s' "  %(today,symbol)
    cursor.execute(sql2)
    conn.commit()
#    return 1
    
def add_rate(symbol,rate=1,today=today):   
#    rate=1.2  #for test
    symbol=symbol[2:]
    cursor=conn.cursor()
    sql="update stock set add_rate_update_time= '%s' where stock_code='%s' " %(today,symbol)
    
    cursor.execute(sql)
    conn.commit()
    cursor=conn.cursor()
    sql1="update stock set add_rate= '%s' where stock_code='%s' "  %(rate,symbol)
    cursor.execute(sql1)
    conn.commit()
#    return 1
#def interium_rate_addition(symbol,rate=0.003,today=today):
#    symbol=symbol[2:]
#    cursor=conn.cursor()
#    sql="update stock set add_rate_update_time= '%s' where stock_code='%s' " %(today,symbol)
#    cursor.execute(sql)
#    conn.commit()
#    cursor=conn.cursor()
#    sql1="update stock set add_rate= '%s' where stock_code='%s' "  %(rate,symbol)
#

def getvol(symbol):
    cursor=conn.cursor()
    symbol=str(symbol)
    symbol=symbol.strip()
    sql="SELECT symbol,date,vol,model FROM optiondb.vol_hist where symbol='%s' order by date desc limit 125" %symbol

    cursor.execute(sql)
    vol=pd.DataFrame(list(cursor),columns=['symbol','date','vol','model'])    
    vol.sort_values(by=['date'],ascending=True,inplace=True) 
    vol.reset_index(drop=True,inplace=True)
    return vol
path='/home/hanyu/ZCY/filter/test/'
stock=pd.read_excel('quote_customized.xls')
stock['symbol']=stock['stock_code'].astype(str)
stock['symbol']=stock['symbol'].apply(lambda x: x.zfill(6))
stock['stock_code']=stock['symbol']
stock['symbol']=stock['symbol'].apply(lambda x: symbolconverter(x))
stock['symbol']=stock['symbol'].astype(str)

def check_(symbol):
    print symbol,list(stock['symbol']).index(symbol)
    status='safe'   
    premium_status=False
    premium_rate=1.0
    vol=getvol(symbol)
    interim_stock=False
    if not vol.empty:   #always check volatility first
        vol['symbol']=vol['symbol'].apply(lambda x:x.strip())
        hist_vol=list(vol['vol'])
        last_vol=hist_vol[-1]
        mark=1
        if last_vol<=np.percentile(hist_vol,mark):                      
            status='drop'
            print 'low vol and dropped',symbol    
        if last_vol>np.percentile(hist_vol,1) and last_vol<=np.percentile(hist_vol,50):                        
            status='safe'
            premium_status=True
            premium_rate=np.percentile(hist_vol,50)/last_vol
            print 'add rate ',premium_rate,symbol
    else:
        status='drop'
    if status!='drop':   #fetching data first
        print 'volatility is alright and next check for volume',symbol
        try:
            df=get_close_historic_price(symbol,end)
#            try:
#                df=df.drop(df.loc['2019-05-20'].name)        ##### drop date
#                df=df.drop(df.loc['2018-12-06'].name)        ##### drop date
#                
#                print 'dropping 20181206'
#            except:
#                pass 
#                print df.shape,symbol
        except:
            df=pd.DataFrame()   
            status='drop'                
    else:
        print 'already dropped,',symbol
    if status!='drop' and df.shape[0]>120:    #check for data availability
        mean20volume=df['volume'].values[-20:].mean()
        mean120volume=df['volume'].values[-120:].mean()
        df['up']=df['close']+0.01
        df['down']=df['close']-0.01
        df['pre_close']=df['close'].shift(1)
        df['upchange']=df['up']/df['pre_close'] -1
        df['dpchange']=df['down']/df['pre_close'] -1
        df['date']=df.index.date
        df.reset_index(drop=False,inplace=True)
        if mean20volume>=mean120volume*4.0:
#        if mean20volume<0:
            status='drop'
            print 'volume abnormal and this stock will be dropped',symbol
        else:
            print 'no problem with volume and program will continue',symbol
    else:
        status='drop'
        print 'unavailibity data  and it willed be droped',symbol
    if status!='drop':   # volume is alright and now check for amount 
        last1Mdata=df.tail(22)
        if last1Mdata[last1Mdata['amount']>=0.0].shape[0]<last1Mdata.shape[0]:
            status='drop'
            print 'amount less than critirion',symbol
        else:
            print 'amount for this stock is alright then continue',symbol
    else:
        print 'already dropped',symbol
    if status!='drop':      #check for uplimit during last 3 months
        last3m=df.tail(66)
        if last3m[last3m['upchange']>=0.1].shape[0]==1:
            status='interim'
            premium_status='interim'
            
            premium_rate=1.1*max(1.0,np.percentile(hist_vol,50)/last_vol)
            print '50% percentile',np.percentile(hist_vol,50),last_vol
            print 'interim stock will be add extra 0.3%',symbol
        
        elif last3m[last3m['upchange']>=0.1].shape[0]>1:
            status='drop'
            print 'last 3 month reach uplimit more than once' ,symbol
        else:
            print 'last 3mths is okay and continue',symbol
    else:
        print 'already droped ',symbol
    if status!='drop':
        c1=df['upchange']>=0.1
        c2=df['dpchange']<=-0.1
        cf1=df[c1]
        cf1=cf1[cf1.date>=pre2month]
        cf2=df[c2]
        cf2=cf2[cf2.date>=pre2month]
        print 'cheking consecutive limits',symbol
        if cf1.shape[0]>1:
            upindex=list(cf1.index)
            if 1 in np.diff(upindex):
                status='drop'
                print 'consecutive uplimit during last 6mths',symbol
            else:
                print 'non-consecutive uplimit happened',symbol
        else:
            print 'non-consecutive uplimit happened',symbol
        if cf2.shape[0]>1:
            downindex=list(cf2.index)
            if 1 in np.diff(downindex):
                status='drop'
                print 'consecutive downlimit during last 6mths',symbol
            else:
                print 'non-consecutive downlimit happened'
        else:
            print 'non-consecutive downlimit happened',symbol

    else:
        print 'already droped',symbol
    if status!='drop':
        df=df.tail(66)
        df['uphigh']=(df['high']+0.01)/df['pre_close'] -1
        df['downlow']=(df['low']-0.01)/df['pre_close'] -1
        up=df[df['uphigh']>=0.1]
        down=df[df['downlow']<=-0.1]
        if up.shape[0]>0 or down.shape[0]>0:
            dates_up=list(up['date'])
#            high_up=list(up['high'])
            dates_down=list(down['date'])
#            low_down=list(down['low'])
            if len(dates_up)>0:
                for i in xrange(len(dates_up)):
                    d1=dates_up[i]
                    try:
                        df_1min=get_1mins_data(symbol,pd.to_datetime(d1))
                        print df_1min.shape,d1
                        df_1min['date']=df_1min['dateTime'].apply(lambda x:x.date())        
                    except:
                        df_1min=pd.DataFrame()
                        status='drop'
                    if not df_1min.empty:
                        df_1min=df_1min[df_1min['date']==d1]
                        h1=df_1min['high'].max()
                        idx=df_1min[df_1min['high']==h1].index[0]                                    
                        df_1min=df_1min[df_1min.index<=idx]
                        df_1min=df_1min.tail(5)
                        if df_1min.shape[0]>=2:
                            open_1min=list(df_1min['open'])[0]
                            high_1min=list(df_1min['high'])[-1]
                            if high_1min/open_1min >=1.05:
                                status='drop'
                                print 'reach high limit in 5mins',symbol
                        else:
                            status='drop'
                            print 'no data for this stock',symbol
            if len(dates_down)>0 and status!='drop':
                for i in xrange(len(dates_down)):
                    d2=dates_down[i]
                    try:
                        df_1min=get_1mins_data(symbol,pd.to_datetime(d2))
                        df_1min['date']=df_1min['dateTime'].apply(lambda x:x.date())
                    except:
                        df_1min=pd.DataFrame()
                        status='drop'
                    if not df_1min.empty:
                        l1=df_1min['low'].min()
                        idx=df_1min[df_1min['low']==l1].index[0]                        
                        df_1min=df_1min[df_1min['date']==d2]
                        df_1min=df_1min[df_1min.index<=idx]
                        df_1min=df_1min.tail(5)
                        if df_1min.shape[0]>=2:
                            open_1min=list(df_1min['open'])[0]
                            low_1min=list(df_1min['low'])[-1]
                            if low_1min/open_1min<=-1.05:
                                status='drop'
                                print 'reach low limit in 5mins',symbol
                        else:
                            status='drop'
                            print 'no enough data for this stock ',symbol
        else:
            print 'this stock is perfect',symbol
            
    else:
        print 'already dropped',symbol
    if status=='drop':
        premium_status=False
    try:
        del df
        gc.collect()
    except:
        pass
    try:
        del df_1min
        gc.collect()
    except:
        pass
    try:
        del vol
        gc.collect()
    except:
        pass
    return status,symbol,premium_status,premium_rate

res=[]
for symbol in list(stock['symbol']):
    print symbol
    i=check_(symbol)
    res.append(i)

    
stock=stock.set_index('symbol')
initalbuyable()
collectionfordrop=[]
symbol_list=list(stock.index)
for i in res:
    result=i[0]
    symbol=i[1]
    print 'processing-----------',result,symbol,symbol_list.index(symbol)
    addratestatus=i[2]
    multiplyer=i[3]
    if result=='drop':
#        print 'drop',symbol
        stock=stock.drop(symbol)
        dropsymbols(symbol)
        collectionfordrop.append(symbol)
    if addratestatus==True and result=='safe':
#        print 'add_rate',symbol
        stock.loc[symbol,'premium']='YES'
        stock.loc[symbol,'multiplyer']=str(multiplyer*100)
        add_rate(symbol,multiplyer)
        for col in stock.columns:
            try:
                stock.loc[symbol,col]*=multiplyer
            except:
                pass
    if result=='interim':
#        print 'interium',symbol
        stock.loc[symbol,'premium']='interim'
        
        stock.loc[symbol,'multiplyer']=str(multiplyer*100)
        add_rate(symbol,multiplyer)
        for col in stock.columns:
            try:
                stock.loc[symbol,col]*=multiplyer
            except:
                pass
        
stock=stock[stock['stock_code'].notnull()]
print stock.shape
stock.to_csv('pifajiafortoday.csv',index=False,encoding='utf-8')
collectionfordrop=pd.DataFrame(collectionfordrop,columns=['symbol'])
collectionfordrop.to_csv('dropped.csv',index=False)
print "finishied in %s s" %(time.time()-t0)



print "Please Do not close the window---------"
def get_close_historic_price_plot(symbol, endDate):
    field = {'close':1,'_id':0,'dateTime':1}
    cur = cur_mongo.find({'symbol': symbol,'dateTime':{'$lte':endDate}}, field). sort('dateTime', pymongo.DESCENDING)
    df = pd.DataFrame(list(cur)).sort_index(ascending=False)
    df['dateTime'] = df['dateTime'].apply(lambda x: tz_utc.localize(x))
    df['dateTime'] = df['dateTime'].apply(lambda x: x.astimezone(tz))
    df.set_index('dateTime',inplace=True)   
    df.sort_index(ascending=True,inplace=True)
    df['date']=df.index.date
    df.set_index('date',inplace=True)
    return df

vol_box=[]
stocksymbols=['SH1A0001','SZ399006','SZ399001','SZ399005']
end=dt.datetime.today().replace(hour=0,minute=0,second=0,microsecond=0)
counter=0
for symbol in stocksymbols[:]:
    counter+=1
    print symbol,(counter,len(stocksymbols))
    df=get_close_historic_price_plot(symbol,end)
    if df.shape[0]>300:
        target_date=list(df[df.index>pd.to_datetime("2014-12-31").date()].index)
                
        df['pchange']=df.close.pct_change()
        for date in target_date:
#            print date
            cf=df[df.index<=date]               
            r_garch=list(cf['pchange'])[-150:]
            vol_ma=cf['pchange'].rolling(90).std()[-1]
            garch=arch.arch_model(r_garch,mean='AR',lags=3,vol='Garch',p=1,q=1)
            res=garch.fit(update_freq=0,disp=0,show_warning=False)
            if res.convergence_flag==0:
                daily_vol=list(res.conditional_volatility)[-1]
                model='garch'
            else:
                daily_vol=vol_ma
                model='std'
            vol_box.append((date,symbol,daily_vol,model))   

vol_box=pd.DataFrame(vol_box,columns=['date','symbol','vol','model'])
def get_fig(symbol,df=vol_box):
    import matplotlib.pyplot as plt
    df=df[df['symbol']==symbol]
    df.sort_values(by=['date'],ascending=True,inplace=True)
    df.reset_index(drop=True,inplace=True)
    std_index=list(df[df.model=='std']['vol'].index)
#    print df
    plt.figure(figsize=(15,5))
    plt.title(df.symbol[0])
    
    plt.plot(df.date.values,df.vol,c='r',
         marker='o',mec='black',ms=5,markevery=std_index)
    plt.gcf().autofmt_xdate()
    fig_dir="D://Filter//vol_hist_%s.png" %symbol 
#        fig_dir=path+"vol_hist_%s.png" %symbol 
    plt.savefig(fig_dir) 
    plt.clf()


get_fig(symbol='SH1A0001')
get_fig(symbol='SZ399006')
get_fig(symbol='SZ399001')
get_fig(symbol='SZ399005')
#    
#    
#
#
#
#
#
#
#
##
##
#
#
#










































