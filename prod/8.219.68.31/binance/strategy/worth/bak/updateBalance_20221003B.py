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

g_version = "1.0.1"

# pd.set_option('display.height', 1000)
# pd.set_option('display.max_rows', 500)	# 显示行数
pd.set_option('display.max_columns', 500)	# 显示列数
pd.set_option('display.width', 1000)		# 显示宽度

g_name = 'similarity'
g_cur_date = time.strftime("%Y%m%d")
g_timestamp = int(round((time.time() ) * 1000) )
g_recvWindow = 5000

g_dir = r'.'
g_cfgfile = r'../similarity/config.json'
g_dbfile = f"{g_dir}/worth.db"

df_balance = pd.DataFrame()
df_posirisk = pd.DataFrame()

formatter = logging.Formatter('%(asctime)s:%(levelname)s:%(name)s:%(filename)s:%(lineno)d:%(funcName)s:%(process)s: %(message)s')

def make_logger(name, log_level=logging.INFO, log_file="log.txt", file_mode="a"): #w写 a追加
    logger = logging.getLogger(name)
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

logger = make_logger(g_name, log_level=logging.DEBUG, log_file= "../logs/%s_%sw.log" % (g_name if ('g_name' in dir() ) else 'similarity', g_cur_date if ('g_cur_date' in dir() ) else time.strftime("%Y%m%d") ) )

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
            rt_df['access'] = 'similarity'

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


if __name__ == '__main__':
    get_config(g_cfgfile)
    qry_serverTime()
    qry_balance()
    time.sleep(3)
    qry_positionRisk() # symbol='btcusdt'
