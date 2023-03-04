# encoding: utf-8

import sys
import os
import logging
import time
import math
import getopt
import threading
import json
import sqlite3
import pickle
from datetime import datetime, timedelta
import hashlib
import hmac
import requests
import traceback
import websocket
import pandas as pd
import numpy as np

g_version = "1.0.3"

# pd.set_option('display.height', 1000)
# pd.set_option('display.max_rows', 500)	# 显示行数
pd.set_option('display.max_columns', 500)	# 显示列数
pd.set_option('display.width', 1000)		# 显示宽度

g_name = 'similarity'
g_cur_date = time.strftime("%Y%m%d")
g_timestamp = int(round((time.time() ) * 1000) )
g_recvWindow = 5000

g_dir = r'.'
# g_cfgfile = r'../similarity/config.json'
g_cfgfile = f"../{g_name}/config.json"
g_dbfile = f"{g_dir}/worth.db"

df_balance = pd.DataFrame()
df_posirisk = pd.DataFrame()
df_order = pd.DataFrame()
df_trade = pd.DataFrame()


def make_logger(name, log_level=logging.INFO, log_file="log.txt", file_mode="a"): #w写 a追加

    formatter = logging.Formatter('%(asctime)s:%(levelname)s:%(name)s:%(filename)s:%(lineno)d:%(funcName)s:%(process)s: %(message)s') # .%(msecs)03d
    
    logger = logging.getLogger(name)
    if not logger.handlers:
        logger.setLevel(level=log_level)
        handler = logging.FileHandler(log_file, mode=file_mode)
        handler.setLevel(level=log_level)
        handler.setFormatter(formatter)
        logger.addHandler(handler)

        handler = logging.StreamHandler(sys.stdout)
        handler.setLevel(level=log_level)
        handler.setFormatter(formatter)
        logger.addHandler(handler)
    return logger

def get_config(cfgfile):
    global g_serverUrl, g_serverName, g_serverUrl, g_api_key, g_secret_key, g_account_encrypt, g_account_name, g_accountAlias, g_strategy_name

    if os.path.exists(cfgfile):
        with open(cfgfile,"rb") as f:
            cfg_dict = json.load(f)
            # logger.info(f'cfg_dict : {cfg_dict}')
            g_serverUrl = cfg_dict[cfg_dict['account_type']]['uhost']
            g_serverName = f"{g_serverUrl.split('.')[1] }"
            g_api_key = cfg_dict['api_key']
            g_secret_key = cfg_dict['secret_key']
            g_account_encrypt = cfg_dict['account_encrypt']
            g_account_name = cfg_dict['account_name']
            g_accountAlias = cfg_dict['accountAlias']
            g_strategy_name = cfg_dict['strategy_name']

def qry_serverTime():
    global g_serverUrl, g_serverTime, g_serverTimeadj

    url = f'{g_serverUrl}/fapi/v1/time'
    res = requests.get(url)
    rt = json.loads(res.text)

    if 'code' in rt and 'msg' in rt:
        logger.error(f'res : {res.text}')
    else:
        g_serverTime = rt['serverTime']  #ms
        g_serverTimeadj = ((rt['serverTime']- int(round((time.time() ) * 1000) )) ) //1000  # s

def qry_balance():
    global df_balance, g_serverUrl, g_serverTimeadj
    global g_secret_key, g_api_key, g_recvWindow, g_strategy_name, g_dbfile

    timestamp = int(round((time.time() +g_serverTimeadj) * 1000) )  # 时间戳ms
    url = f'{g_serverUrl}/fapi/v2/balance'
    query_string = f'recvWindow={g_recvWindow}&timestamp={str(timestamp)}'
    signature = hmac.new(g_secret_key.encode('utf-8'), query_string.encode('utf-8'), hashlib.sha256).hexdigest() #
    params = {"recvWindow":g_recvWindow, "timestamp":timestamp, "signature":signature}
    headers = {"X-MBX-APIKEY":g_api_key}

    res = requests.get(url, headers=headers, params=params)
    rt = json.loads(res.text)

    if 'code' in rt and 'msg' in rt:
        logger.error(f'res: {res.text}')
    else :

        for bal in rt:
            if bal['asset'] != 'USDT':
                continue

            rt_df = pd.DataFrame([bal])

            # rt_df = pd.DataFrame([rt[1] ])
            # rt_df['systemTime'] = rt_df['updateTime'].apply(lambda x: datetime.fromtimestamp(x/1000))
            rt_df['updateDate'] = pd.to_datetime(rt_df['updateTime'], unit="ms", origin="1970-01-01 08:00:00")
            rt_df['queryTime'] = pd.to_datetime(int(time.time()), unit='s', origin="1970-01-01 08:00:00")

            rt_df['availableBalance'] = pd.to_numeric(rt_df['availableBalance'] , errors='coerce', downcast='float')
            rt_df['balance'] = pd.to_numeric(rt_df['balance'] , errors='coerce', downcast='float')
            rt_df['crossWalletBalance'] = pd.to_numeric(rt_df['crossWalletBalance'] , errors='coerce', downcast='float')
            rt_df['crossUnPnl'] = pd.to_numeric(rt_df['crossUnPnl'] , errors='coerce', downcast='float')
            rt_df['maxWithdrawAmount'] = pd.to_numeric(rt_df['maxWithdrawAmount'] , errors='coerce', downcast='float')
            rt_df['access'] = g_strategy_name

            rt_df.sort_index(axis=1, ascending=True, inplace=True)
            # balancedf = rt_df.copy()

            df_balance = pd.concat([df_balance, rt_df ], ignore_index=True)
            df_b = df_balance[['asset','balance','availableBalance','updateTime','queryTime', ] ]

            conn = sqlite3.connect(g_dbfile)
            # df_balance = pd.read_sql(' select * from balance ', conn)
            rt_df.to_sql('balance', con=conn, if_exists='append', index=False) #,
            conn.close()

            df_balance.to_pickle(f'{g_dir}/balancedf.pkl' )
            # df_bal = pd.read_pickle('%s/%s.pkl' % (worthDir, "balancedf" ) )
            logger.info(f'df_b :\n{df_b}')

def qry_positionRisk(symbol='btcusdt'):

    global df_balance, g_serverUrl, g_serverTimeadj
    global g_secret_key, g_api_key, g_recvWindow, g_strategy_name, g_dbfile
    global df_posirisk

    timestamp = int(round((time.time() +g_serverTimeadj) * 1000) )
    url = f'{g_serverUrl}/fapi/v1/positionRisk'

    # symbol = "btcusdt"

    query_string = 'symbol=%s&recvWindow=%s&timestamp=%s' % (symbol,g_recvWindow,str(timestamp))
    signature = hmac.new(g_secret_key.encode('utf-8'), query_string.encode('utf-8'), hashlib.sha256).hexdigest() # 用secret_key时间戳hmac sha256加密
    params = {"symbol":symbol,"recvWindow":g_recvWindow,"timestamp":timestamp,"signature":signature}
    headers = {"X-MBX-APIKEY":g_api_key}

    url2 = '%s?%s&signature=%s' % (url, query_string, signature)

    res = requests.get(url2, headers=headers) #, params=params  urlTest  url2
    rt = json.loads(res.text)

    if 'code' in rt and 'msg' in rt:
        logger.error(f'res : {res.text}')
    else:
        # logger.info(f'res : {res.text}')
        for posi in rt:

            if not abs(float(posi['positionAmt'])) > 0 and symbol!='btcusdt':
                continue

            rt_df = pd.DataFrame([posi])

            # rt_df['systemTime'] = rt_df['updateTime'].apply(lambda x: datetime.fromtimestamp(x/1000))
            rt_df['updateDate'] = pd.to_datetime(rt_df['updateTime'], unit="ms", origin="1970-01-01 08:00:00")
            rt_df['queryTime'] = pd.to_datetime(int(time.time()), unit='s', origin="1970-01-01 08:00:00")

            # rt_df['unRealizedProfit']  = pd.to_numeric(rt_df['unRealizedProfit'] , errors='coerce', downcast='float')  # unRealizedProfit  unrealizedProfit
            # rt_df['entryPrice']  = pd.to_numeric(rt_df['entryPrice'] , errors='coerce', downcast='float')
            # rt_df['positionAmt']  = pd.to_numeric(rt_df['positionAmt'] , errors='coerce', downcast='float')

            # rt_df['leverage']  = pd.to_numeric(rt_df['leverage'] , errors='coerce', downcast='integer')
            rt_df['access'] = g_strategy_name

            rt_df.sort_index(axis=1, ascending=True, inplace=True)
            df_posirisk = pd.concat([df_posirisk, rt_df ], ignore_index=True)
            df_pr = df_posirisk[['symbol','markPrice','unRealizedProfit','entryPrice','positionAmt','notional','updateDate', ] ]

            conn = sqlite3.connect(g_dbfile)
            # df_posirisk = pd.read_sql(' select * from posirisk ', conn)
            rt_df.to_sql('posirisk', con=conn, if_exists='append', index=False) #,
            conn.close()

            df_posirisk.to_pickle(f'{g_dir}/posiriskdf.pkl' )
            # df_posi = pd.read_pickle('%s/%s.pkl' % (worthDir, "posiriskdf" ) )
            logger.info(f'df_pr :\n{df_pr}')

def qry_trades(symbol='btcusdt', limit=200):
    global df_trade, g_serverUrl, g_serverTimeadj
    global g_secret_key, g_api_key, g_recvWindow, g_strategy_name, g_dbfile

    timestamp = int(round((time.time() +g_serverTimeadj) * 1000) )  # 时间戳ms
    url = f'{g_serverUrl}/fapi/v1/userTrades'
    query_string = f'symbol={symbol}&limit={limit}&recvWindow={g_recvWindow}&timestamp={str(timestamp)}'
    signature = hmac.new(g_secret_key.encode('utf-8'), query_string.encode('utf-8'), hashlib.sha256).hexdigest() #
    params = {"symbol":symbol,"limit":limit,"recvWindow":g_recvWindow, "timestamp":timestamp, "signature":signature}
    headers = {"X-MBX-APIKEY":g_api_key}

    res = requests.get(url, headers=headers, params=params)
    rt = json.loads(res.text)

    if 'code' in rt and 'msg' in rt:
        logger.error(f'res: {res.text}')
    else:

        conn = sqlite3.connect(g_dbfile)
        try:
            df_trade = pd.read_sql(' select * from trades ', conn)
        except:
            df_trade = pd.DataFrame()

        for order in rt:
            # if order['symbol'] != 'BTCUSDT':
            #     continue

            rt_df = pd.DataFrame([order])

            # rt_df = pd.DataFrame([rt[1] ])
            # rt_df['systemTime'] = rt_df['updateTime'].apply(lambda x: datetime.fromtimestamp(x/1000))
            rt_df['updateDate'] = pd.to_datetime(rt_df['time'], unit="ms", origin="1970-01-01 08:00:00")
            rt_df['queryTime'] = pd.to_datetime(int(time.time()), unit='s', origin="1970-01-01 08:00:00")

            # rt_df['commission'] = pd.to_numeric(rt_df['commission'] , errors='coerce', downcast='float')
            # rt_df['price'] = pd.to_numeric(rt_df['price'] , errors='coerce', downcast='float')
            # rt_df['qty'] = pd.to_numeric(rt_df['qty'] , errors='coerce', downcast='float')
            # rt_df['quoteQty'] = pd.to_numeric(rt_df['quoteQty'] , errors='coerce', downcast='float')
            # rt_df['realizedPnl'] = pd.to_numeric(rt_df['realizedPnl'] , errors='coerce', downcast='float')
            rt_df['access'] = g_strategy_name

            rt_df.sort_index(axis=1, ascending=True, inplace=True)
            # tradedf = rt_df.copy()


            if  not df_trade.empty and rt_df['id'][0] in df_trade['id'].values:  # 
                # df_trade.sort_index(axis=1, ascending=True, inplace=True)
                # df_trade.loc[ df_trade['id'] == rt_df['id'][0] ] = rt_df.to_numpy()
                continue
            else:
                df_trade = pd.concat([df_trade,rt_df ], ignore_index=True)

                df_tr = rt_df[['id','orderId','symbol','price','qty','side','positionSide','quoteQty', ] ] 
                # df_tr = df_trade[['id','orderId','symbol','price','qty','side','positionSide','quoteQty', ] ] 

                rt_df.to_sql('trades', con=conn, if_exists='append', index=False) #,
                # conn.close()
                logger.info(f'df_tr :\n{df_tr}')

        df_trade.to_pickle(f'{g_dir}/tradedf.pkl' )
        # df_tra = pd.read_pickle('%s/%s.pkl' % (worthDir, "tradedf" ) )    

        # df_trade.to_sql('trades', con=conn, if_exists='replace', index=False) #, replace append
        conn.close()
        logger.info(f'df_trade.tail() :\n{df_trade.tail()}')

def qry_orders(symbol='btcusdt', limit=200):
    global df_order, g_serverUrl, g_serverTimeadj
    global g_secret_key, g_api_key, g_recvWindow, g_strategy_name, g_dbfile

    timestamp = int(round((time.time() +g_serverTimeadj) * 1000) )  # 时间戳ms
    url = f'{g_serverUrl}/fapi/v1/allOrders'
    query_string = f'symbol={symbol}&limit={limit}&recvWindow={g_recvWindow}&timestamp={str(timestamp)}'
    signature = hmac.new(g_secret_key.encode('utf-8'), query_string.encode('utf-8'), hashlib.sha256).hexdigest() #
    params = {"symbol":symbol,"limit":limit,"recvWindow":g_recvWindow, "timestamp":timestamp, "signature":signature}
    headers = {"X-MBX-APIKEY":g_api_key}

    res = requests.get(url, headers=headers, params=params)
    rt = json.loads(res.text)

    if 'code' in rt and 'msg' in rt:
        logger.error(f'res: {res.text}')
    else:

        conn = sqlite3.connect(g_dbfile)
        try:
            df_order = pd.read_sql(' select * from orders ', conn)
        except:
            df_order = pd.DataFrame()

        for order in rt:
            # if order['symbol'] != 'BTCUSDT':
            #     continue

            rt_df = pd.DataFrame([order])

            # rt_df = pd.DataFrame([rt[1] ])
            # rt_df['systemTime'] = rt_df['updateTime'].apply(lambda x: datetime.fromtimestamp(x/1000))
            rt_df['updateDate'] = pd.to_datetime(rt_df['updateTime'], unit="ms", origin="1970-01-01 08:00:00")
            rt_df['queryTime'] = pd.to_datetime(int(time.time()), unit='s', origin="1970-01-01 08:00:00")

            # rt_df['avgPrice'] = pd.to_numeric(rt_df['avgPrice'] , errors='coerce', downcast='float')
            # rt_df['cumQuote'] = pd.to_numeric(rt_df['cumQuote'] , errors='coerce', downcast='float')
            # rt_df['executedQty'] = pd.to_numeric(rt_df['executedQty'] , errors='coerce', downcast='float')
            # rt_df['origQty'] = pd.to_numeric(rt_df['origQty'] , errors='coerce', downcast='float')
            # rt_df['price'] = pd.to_numeric(rt_df['price'] , errors='coerce', downcast='float')
            # rt_df['stopPrice'] = pd.to_numeric(rt_df['stopPrice'] , errors='coerce', downcast='float')
            # rt_df['activatePrice'] = pd.to_numeric(rt_df['activatePrice'] , errors='coerce', downcast='float')
            # rt_df['priceRate'] = pd.to_numeric(rt_df['priceRate'] , errors='coerce', downcast='float')
            rt_df['access'] = g_strategy_name

            rt_df.sort_index(axis=1, ascending=True, inplace=True)
            # tradedf = rt_df.copy()


            if  not df_order.empty and rt_df['orderId'][0] in df_order['orderId'].values:  # and newClientOrderId in df_order['clientOrderId'].values
                # df_order.sort_index(axis=1, ascending=True, inplace=True)
                # df_order.loc[ df_order['orderId'] == rt_df['orderId'][0] ] = rt_df.to_numpy()
                continue
            else:
                df_order = pd.concat([df_order,rt_df ], ignore_index=True)

                df_ord = rt_df[['orderId','symbol','side','price','origQty','status','type','updateDate','clientOrderId', ] ]

                rt_df.to_sql('orders', con=conn, if_exists='append', index=False) #,
                # conn.close()
                logger.info(f'df_ord :\n{df_ord}')

        df_order.to_pickle(f'{g_dir}/orderdf.pkl' )
        # df_ord = pd.read_pickle('%s/%s.pkl' % (worthDir, "orderdf" ) )

        # df_order.to_sql('orders', con=conn, if_exists='replace', index=False) #, replace append
        conn.close()
        logger.info(f'df_order.tail() :\n{df_order.tail()}')

def get_argv() -> dict:
    argv = sys.argv[1:]
    input_pro = '-n <name> -X <symbol> -p <period> -w <wid> -d <day> -c <clientPort>'

    try:
        opts, args = getopt.getopt(argv, "n:X:p:w:d:c",
                        ["name","symbol","period","wid","day","clientPort"])
        print(f'{opts=}, {args=}')
    except getopt.GetoptError:
        print('--input_pro--: ', input_pro)
        sys.exit(2)

    arg_param = {}
    for opt, arg in opts:
        if opt in ("-t", '--total'):
            arg_param['total'] = float(arg)
        elif opt in ("-n", '--name'):
            arg_param['name'] = arg
        elif opt in ("-X", '--symbol'):
            arg_param['symbol'] = arg
        elif opt in ("-p", '--period'):
            arg_param['interval'] = arg
        elif opt in ("-w", '--wid'):
            arg_param['wid'] = int(arg)
        elif opt in ("-d", '--day'):
            arg_param['histDays'] = int(arg)

    #logger.info(f"{arg_param =}")
    return arg_param


if __name__ == '__main__':
    arg_param = get_argv()

    g_name = arg_param['name']
    g_cfgfile = f"../{g_name}/config.json"    

    logger = make_logger(g_name, log_level=logging.DEBUG, log_file= "../logs/%s_%sw.log" % (g_name if ('g_name' in dir() ) else 'similarity', g_cur_date if ('g_cur_date' in dir() ) else time.strftime("%Y%m%d") ) )

    get_config(g_cfgfile)
    qry_serverTime()
    qry_balance()
    time.sleep(2)
    qry_positionRisk() # symbol='btcusdt'
    time.sleep(2)
    qry_trades() # symbol='btcusdt'
    time.sleep(2)
    qry_orders() # symbol='btcusdt'    
