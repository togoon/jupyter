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

g_version = "1.0.4"

# pd.set_option('display.height', 1000)
# pd.set_option('display.max_rows', 500)	# 显示行数
pd.set_option('display.max_columns', 500)	# 显示列数
pd.set_option('display.width', 1000)		# 显示宽度

g_pkl_dir = r'../pkl'

g_name = 'similarity_big' # similarity  similarity_big 
g_cur_date = time.strftime("%Y%m%d")
g_timestamp = int(round((time.time() ) * 1000) )
g_interval_coef = {'m':60, 'h':60*60, 'd': 60*60*24, 'w':60*60*24*7, 'M':60*60*24*30}

df_balance = pd.DataFrame()
df_account = pd.DataFrame()
df_position = pd.DataFrame()
df_order = pd.DataFrame()
df_trade = pd.DataFrame()


def make_logger(log_name, log_level=logging.INFO, log_file="log.txt", file_mode="a"): #w写 a追加
    formatter = logging.Formatter('%(asctime)s:%(levelname)s:%(name)s:%(filename)s:%(lineno)d:%(funcName)s:%(process)s: %(message)s')
    log = logging.getLogger(log_name)
    log.setLevel(level=log_level)
    handler = logging.FileHandler(log_file, mode=file_mode)
    handler.setLevel(level=log_level)
    handler.setFormatter(formatter)
    log.addHandler(handler)
    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(level=log_level)
    handler.setFormatter(formatter)
    log.addHandler(handler)
    return log

logger = make_logger(g_name, log_level=logging.DEBUG, log_file= "../logs/%s_%s.log" %  \
    (g_name if ('g_name' in dir() ) else 'similarity', g_cur_date if ('g_cur_date' in dir() ) else time.strftime('%Y%m%d') ) )

class Binance(object):
    def __init__(self, name, symbol, interval, wid, histDays):
        # super().__init__(name)
        self.name = name
        self.symbol = symbol
        self.interval = interval
        self.wid = wid
        self.histDays = histDays

        self.flagDict = {'side':"", 'dirction':"", 'qty':0, 'posBuy':0, 'posSell':0,'isNewDay':False, 'isOpenBuy':False, 'isOpenSell':False, 'isCloseBuy':False, 'isCloseSell':False, 'isOpen':False, 'isClose':False,'isTrig':False,'isCorr':False }

        self.count = 1
        self.curDate = ''
        self.tradeDate = self.openTime = self.closeTime = self.closeSec = self.openSec = self.open = self.close = ''
        self.corrVal = self.corrDate = ''

        self.cfgfile = f"config.json"
        self.dbfile = f"{g_pkl_dir}/binance.db"
        self.serverName = ''  #binance binancefuture
        self.account_name = ''
        self.leverage = 2  # 杠杆倍数 1  2

        self.recvWindow = '5000'
        self.newClientOrderId = ''
        self.orderId = ''
        self.serverTime = 0
        self.serverTimeadj = 1   # 服务器时间调整
        self.locTimeadj = int(28800 - datetime.utcnow().astimezone().utcoffset().total_seconds() )  # 时区调整 东八区 60*60*8

        self.tcikerPrice = -1.0
        self.markPrice = -1.0
        self.total = 0.0
        self.orderPrice = 0.0
        self.orderType = ''
        self.totalAdjRate = -0.5  # -1e-3  -2e-2   -0.5
        self.minQtyDigit = 3
        self.corrLim = 0
        self.depth_limit = 5
        self.bids_price = 0
        self.asks_price = 0
        self.multiplierUp = 1.05
        self.multiplierDown = 0.95
        self.minQty = 0
        self.market_minQty = 0

        self.ukdf = pd.DataFrame()
        self.balancedf = pd.DataFrame()
        self.accountdf = pd.DataFrame()
        self.positiondf = pd.DataFrame()
        self.orderdf = pd.DataFrame()
        self.tradedf = pd.DataFrame()

        self.get_config()

        self.access = f"bi_{self.name}_{self.account_name}_{self.secret_key[:4]}" #交易所2 策略名 key4

    def get_config(self):
        if os.path.exists(self.cfgfile):
            with open(self.cfgfile,"rb") as f:
                cfg_dict = json.load(f)
                logger.info(f'cfg_dict : {cfg_dict}')
                self.serverUrl = cfg_dict[cfg_dict['account_type']]['uhost']
                self.serverName = f"{self.serverUrl.split('.')[1] }"
                self.api_key = cfg_dict['api_key']
                self.secret_key = cfg_dict['secret_key']
                self.leverage = cfg_dict['leverage']
                self.account_encrypt = cfg_dict['account_encrypt']
                self.account_name = cfg_dict['account_name']
                self.depth_limit = cfg_dict['depth_limit']
                self.totalAdjRate = cfg_dict['totalAdjRate']

    def set_leverage(self):
        timestamp = int(round((time.time() +self.serverTimeadj) * 1000) )  # 时间戳ms
        url = f'{self.serverUrl}/fapi/v1/leverage'
        query_string = f'symbol={self.symbol}&leverage={self.leverage}&recvWindow={self.recvWindow}&timestamp={str(timestamp)}'
        signature = hmac.new(self.secret_key.encode('utf-8'), query_string.encode('utf-8'), hashlib.sha256).hexdigest() #

        params = {"symbol":self.symbol, "leverage":self.leverage,"recvWindow":self.recvWindow,"timestamp":timestamp, "signature":signature}

        headers = {"X-MBX-APIKEY":self.api_key}
        url2 = f"{url}?{query_string}&signature={signature}"

        res = requests.post(url2, headers=headers) # , params=params
        # {"symbol":"BTCUSDT","leverage":2,"maxNotionalValue":"15000000"}
        # {"code":-1022,"msg":"Signature for this request is not valid."}

        rt = json.loads(res.text)

        if 'code' in rt and 'msg' in rt:
            logger.error(f'res: {res.text}')
        else:

            self.leverage = rt["leverage"]

    def qry_balance(self):
        global df_balance

        timestamp = int(round((time.time() +self.serverTimeadj) * 1000) )  # 时间戳ms
        url = f'{self.serverUrl}/fapi/v2/balance'

        query_string = f'recvWindow={self.recvWindow}&timestamp={str(timestamp)}'
        signature = hmac.new(self.secret_key.encode('utf-8'), query_string.encode('utf-8'), hashlib.sha256).hexdigest() #
        params = {"recvWindow":self.recvWindow, "timestamp":timestamp, "signature":signature}
        headers = {"X-MBX-APIKEY":self.api_key}

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
                rt_df['access'] = self.access

                rt_df.sort_index(axis=1, ascending=True, inplace=True)
                self.balancedf = rt_df.copy()

                df_balance = pd.concat([df_balance, rt_df ], ignore_index=True)
                df_b = df_balance[['accountAlias','asset','balance','availableBalance','updateTime','queryTime', ] ]

                conn = sqlite3.connect(self.dbfile)
                # df_balance = pd.read_sql(' select * from balance ', conn)
                rt_df.to_sql('balance', con=conn, if_exists='append', index=False) #,
                conn.close()

                df_balance.to_pickle(f'{g_pkl_dir}/balance_big_df.pkl' )
                # df_bal = pd.read_pickle('%s/%s.pkl' % (worthDir, "balancedf" ) )

                logger.info(f'df_b :\n{df_b}')

    def qry_account(self):
        global df_account, df_position

        timestamp = int(round((time.time() +self.serverTimeadj) * 1000) )  # 时间戳ms
        url = f'{self.serverUrl}/fapi/v2/account'
        query_string = f'recvWindow={self.recvWindow}&timestamp={str(timestamp)}'
        signature = hmac.new(self.secret_key.encode('utf-8'), query_string.encode('utf-8'), hashlib.sha256).hexdigest() #
        params = {"recvWindow":self.recvWindow, "timestamp":timestamp, "signature":signature}
        headers = {"X-MBX-APIKEY":self.api_key}

        res = requests.get(url, headers=headers, params=params)
        rt = json.loads(res.text)
        # logger.info(f'res.text :\n{res.text}')

        if 'code' in rt and 'msg' in rt:
            logger.error(f'res : {res.text}')
        else :
            for ass in rt["assets"]:
                if ass['asset'] != 'USDT':
                    continue

                rt_df = pd.DataFrame([ass])

                # rt_df['systemTime'] = rt_df['updateTime'].apply(lambda x: datetime.fromtimestamp(x/1000))
                rt_df['updateDate'] = pd.to_datetime(rt_df['updateTime'], unit="ms", origin="1970-01-01 08:00:00")
                rt_df['queryTime'] = pd.to_datetime(int(time.time()), unit='s', origin="1970-01-01 08:00:00")

                rt_df['availableBalance']  = pd.to_numeric(rt_df['availableBalance'] , errors='coerce', downcast='float')
                rt_df['crossUnPnl']  = pd.to_numeric(rt_df['crossUnPnl'] , errors='coerce', downcast='float')
                rt_df['crossWalletBalance']  = pd.to_numeric(rt_df['crossWalletBalance'] , errors='coerce', downcast='float')
                rt_df['maintMargin']  = pd.to_numeric(rt_df['maintMargin'] , errors='coerce', downcast='float')
                rt_df['marginBalance']  = pd.to_numeric(rt_df['marginBalance'] , errors='coerce', downcast='float')
                rt_df['maxWithdrawAmount']  = pd.to_numeric(rt_df['maxWithdrawAmount'] , errors='coerce', downcast='float')
                rt_df['openOrderInitialMargin']  = pd.to_numeric(rt_df['openOrderInitialMargin'] , errors='coerce', downcast='float')
                rt_df['positionInitialMargin']  = pd.to_numeric(rt_df['positionInitialMargin'] , errors='coerce', downcast='float')
                rt_df['unrealizedProfit']  = pd.to_numeric(rt_df['unrealizedProfit'] , errors='coerce', downcast='float')
                rt_df['walletBalance']  = pd.to_numeric(rt_df['walletBalance'] , errors='coerce', downcast='float')
                rt_df['access'] = self.access

                rt_df.sort_index(axis=1, ascending=True, inplace=True)
                self.accountdf = rt_df.copy()
                df_account = pd.concat([df_account,rt_df ], ignore_index=True)
                df_a = df_account[['asset','walletBalance','availableBalance','maintMargin','marginBalance','unrealizedProfit','updateDate','queryTime', ] ]

                conn = sqlite3.connect(self.dbfile)
                # df_account = pd.read_sql(' select * from account ', conn)
                rt_df.to_sql('account', con=conn, if_exists='append', index=False) #,
                conn.close()

                df_account.to_pickle('%s/%s.pkl' % (g_pkl_dir, "account_big_df" ) )
                # df_acc = pd.read_pickle('%s/%s.pkl' % (worthDir, "accountdf" ) )

                self.total = float(rt_df['availableBalance'].values[-1])

                logger.info(f'df_a :\n{df_a}')

            for posi in rt["positions"]:
                if not abs(float(posi['positionAmt'])) > 0 :
                    continue

                rt_df = pd.DataFrame([posi])

                # rt_df['systemTime'] = rt_df['updateTime'].apply(lambda x: datetime.fromtimestamp(x/1000))
                rt_df['updateDate'] = pd.to_datetime(rt_df['updateTime'], unit="ms", origin="1970-01-01 08:00:00")
                rt_df['queryTime'] = pd.to_datetime(int(time.time()), unit='s', origin="1970-01-01 08:00:00")

                rt_df['initialMargin'] = pd.to_numeric(rt_df['initialMargin'] , errors='coerce', downcast='float')
                rt_df['maintMargin'] = pd.to_numeric(rt_df['maintMargin'] , errors='coerce', downcast='float')
                rt_df['unrealizedProfit'] = pd.to_numeric(rt_df['unrealizedProfit'] , errors='coerce', downcast='float')
                rt_df['positionInitialMargin'] = pd.to_numeric(rt_df['positionInitialMargin'] , errors='coerce', downcast='float')
                rt_df['openOrderInitialMargin'] = pd.to_numeric(rt_df['openOrderInitialMargin'] , errors='coerce', downcast='float')
                rt_df['entryPrice'] = pd.to_numeric(rt_df['entryPrice'] , errors='coerce', downcast='float')
                rt_df['maxNotional'] = pd.to_numeric(rt_df['maxNotional'] , errors='coerce', downcast='float')
                rt_df['bidNotional'] = pd.to_numeric(rt_df['bidNotional'] , errors='coerce', downcast='float')
                rt_df['askNotional'] = pd.to_numeric(rt_df['askNotional'] , errors='coerce', downcast='float')
                # rt_df['positionAmt'] = pd.to_numeric(rt_df['positionAmt'] , errors='coerce', downcast='float')
                rt_df['leverage'] = pd.to_numeric(rt_df['leverage'] , errors='coerce', downcast='integer')
                rt_df['access'] = self.access

                rt_df.sort_index(axis=1, ascending=True, inplace=True)
                self.positiondf = rt_df.copy()

                df_position = pd.concat([df_position, rt_df ], ignore_index=True)
                df_p = df_position[['symbol','initialMargin','maintMargin','unrealizedProfit','positionInitialMargin','openOrderInitialMargin','leverage','entryPrice','maxNotional','positionAmt','notional','updateDate','queryTime', ] ]

                conn = sqlite3.connect(self.dbfile)
                # df_position = pd.read_sql(' select * from position ', conn)
                rt_df.to_sql('position', con=conn, if_exists='append', index=False) #,
                conn.close()

                df_position.to_pickle('%s/%s.pkl' % (g_pkl_dir, "position_big_df" ) )
                # df_posi = pd.read_pickle('%s/%s.pkl' % (worthDir, "positiondf" ) )

                logger.info(f'df_p :\n{df_p}')

    def trade_future(self, symbol='btcusdt', side='BUY', price=-1, quantity=0.001, orderType='MARKET', timeInForce='GTC'):
        # , callbackRate=5, stopPrice=20000, activationPrice=20000, reduceOnly='false', priceProtect='false', closePosition='true'
        global df_order

        timestamp = int(round((time.time() +self.serverTimeadj) * 1000) )  # 时间戳ms
        url = f'{self.serverUrl}/fapi/v1/order'
        # symbol = 'btcusdt'  #交易对
        # side = 'BUY'        #买卖方向 BUY 买入, SELL 卖出
        # orderType = 'LIMIT'      #订单类型 LIMIT限价单, MARKET市价单, STOP止损限价单, STOP_MARKET止损市价单, TAKE_PROFIT止盈限价单, TAKE_PROFIT_MARKET止盈市价单, TRAILING_STOP_MARKET跟踪止损单,
        # price = 19000.1  #委托价格
        # quantity = 0.001  #下单数量
        # timeInForce = 'GTC' #有效方法 GTC-Good Till Cancel 成交为止, IOC-Immediate or Cancel 无法立即成交(吃单)的部分就撤销, FOK-Fill or Kill 无法全部立即成交就撤销, GTX-Good Till Crossing 无法成为挂单方就撤销

        reduceOnly = 'false' #仅减仓 false true
        workingType = 'CONTRACT_PRICE'  #stopPrice 触发类型: MARK_PRICE(标记价格), CONTRACT_PRICE(合约最新价). 默认 CONTRACT_PRICE
        priceProtect = 'false' #条件单触发保护："TRUE","FALSE", 默认"FALSE". 仅 STOP, STOP_MARKET, TAKE_PROFIT, TAKE_PROFIT_MARKET 需要此参数
        newOrderRespType = "ACK"  #"ACK", "RESULT", 默认 "ACK"
        sideDict = {'BUY':'B', 'SELL':'S', }
        typeDict = {'LIMIT':'LMT', 'MARKET':'MKT', 'STOP':'STP','STOP_MARKET':'STP','TAKE_PROFIT':'TKP','TAKE_PROFIT_MARKET':'TPM','TRAILING_STOP_MARKET':'TSM', }
        reduceOnlyDict = {'false':0, 'true':1,}
        workingTypeDict = {'CONTRACT_PRICE':'C', 'MARK_PRICE':'M',}
        priceProtectDict = {'false':0, 'true':1,}
        newOrderRespTypeDict = {'ACK':'A', 'RESULT':'R',}

        positionSide = 'BOTH' #持仓方向，单向持仓模式下非必填，默认且仅可填BOTH;在双向持仓模式下必填,且仅可选择 LONG 或 SHORT, BOTH 单一持仓方向, LONG 多头(双向持仓下), SHORT 空头(双向持仓下)
        callbackRate = 5 # 追踪止损回调比例，可取值范围[0.1, 5],其中 1代表1% ,仅TRAILING_STOP_MARKET 需要此参数
        stopPrice = 20000   #触发价, 仅 STOP, STOP_MARKET, TAKE_PROFIT, TAKE_PROFIT_MARKET 需要此参数
        closePosition = 'true' #触发后全部平仓，true, false；仅支持STOP_MARKET和TAKE_PROFIT_MARKET；不与quantity合用；自带只平仓效果，不与reduceOnly 合用
        activationPrice = 20000 #追踪止损激活价格，仅TRAILING_STOP_MARKET 需要此参数, 默认为下单当前市场价格(支持不同workingType)
        closePositionDict = {'false':0, 'true':1,}
        positionSideDict = {'BOTH':'B', 'LONG':'L', 'SHORT':'S', }

        tailStr = f"{reduceOnlyDict[reduceOnly]}{workingTypeDict[workingType]}{priceProtectDict[priceProtect]}{newOrderRespTypeDict[newOrderRespType]}{closePositionDict[closePosition]}{positionSideDict[positionSide] }"
        symbolStr = f"{symbol.lower()}-------"
        tacticName = g_name[:2].upper() # 'T0'
        newClientOrderId = f"{tacticName}{sideDict[side]}{time.strftime('%Y%m%d%H%M%S', time.localtime(time.time()+self.locTimeadj) )}{typeDict[orderType]}{symbolStr[:7]}{timeInForce}{tailStr}"  #自定义订单号 ^[\.A-Z\:/a-z0-9_-]{1,36}$    2+1+14+3 +7+3+6

        # orderType = 'LIMIT'      #订单类型 LIMIT 限价单, MARKET 市价单, STOP 止损限价单, STOP_MARKET 止损市价单, TAKE_PROFIT 止盈限价单, TAKE_PROFIT_MARKET 止盈市价单, TRAILING_STOP_MARKET 跟踪止损单,

        if orderType == 'LIMIT':
            query_string = f"newClientOrderId={newClientOrderId}&symbol={symbol}&side={side}&type={orderType}&price={price}&quantity={quantity}&timeInForce={timeInForce}&recvWindow={self.recvWindow}&timestamp={str(timestamp)}"
        elif orderType == 'MARKET':
            query_string = f"newClientOrderId={newClientOrderId}&symbol={symbol}&side={side}&type={orderType}&quantity={quantity}&recvWindow={self.recvWindow}&timestamp={str(timestamp)}"
        else:
            query_string = f"newClientOrderId={newClientOrderId}&symbol={symbol}&side={side}&type={orderType}&price={price}&quantity={quantity}&timeInForce={timeInForce}&recvWindow={self.recvWindow}&timestamp={str(timestamp)}"

        signature = hmac.new(self.secret_key.encode('utf-8'), query_string.encode('utf-8'), hashlib.sha256).hexdigest() # 用secret_key时间戳hmac sha256加密
        # params = {"newClientOrderId":newClientOrderId,"symbol":symbol,"side":side,"type":orderType,"price":price,"quantity":quantity,"timeInForce":timeInForce, "recvWindow":self.recvWindow,"timestamp":timestamp,"signature":signature}
        headers = {"X-MBX-APIKEY":self.api_key}
        url2 = f"{url}?{query_string}&signature={signature}"
        # res = requests.post(url, headers=headers, params=params) #, params=params  urlTest  url2

        logger.debug(f"cls_var: { {k: v for k, v in self.__dict__.items() if not k.startswith('__')} }")

        res = requests.post(url2, headers=headers) #, params=params  urlTest  url2
        rt = json.loads(res.text)

        logger.info(f'url2 : {url2} \n rt : {rt}')

        if 'code' in rt and 'msg' in rt:
            logger.error(f'res : {res.text}')
        else:
            del rt['cumQty'] #弃用
            rt_df = pd.DataFrame([rt])

            rt_df['updateDate'] = pd.to_datetime(rt_df['updateTime'], unit="ms", origin="1970-01-01 08:00:00")
            rt_df['time'] = pd.to_datetime(int(time.time()), unit='s', origin="1970-01-01 08:00:00")
            # rt_df['time'] = timestamp

            # rt_df['cumQuote']  = pd.to_numeric(rt_df['cumQuote'] , errors='coerce', downcast='float')
            # rt_df['executedQty']  = pd.to_numeric(rt_df['executedQty'] , errors='coerce', downcast='float')
            # rt_df['avgPrice']  = pd.to_numeric(rt_df['avgPrice'] , errors='coerce', downcast='float')
            # rt_df['origQty']  = pd.to_numeric(rt_df['origQty'] , errors='coerce', downcast='float')
            # rt_df['price']  = pd.to_numeric(rt_df['price'] , errors='coerce', downcast='float')
            # rt_df['stopPrice']  = pd.to_numeric(rt_df['stopPrice'] , errors='coerce', downcast='float')

            # rt_df['activatePrice']  = pd.to_numeric(rt_df['activatePrice'] , errors='coerce', downcast='float')
            # rt_df['priceRate']  = pd.to_numeric(rt_df['priceRate'] , errors='coerce', downcast='float')
            rt_df['access'] = self.access

            rt_df.sort_index(axis=1, ascending=True, inplace=True)

            if  not df_order.empty and newClientOrderId in df_order['clientOrderId'].values and rt['orderId'] in df_order['orderId'].values:
                df_order.sort_index(axis=1, ascending=True, inplace=True)
                df_order.loc[ df_order['orderId'] == rt['orderId'] ] = rt_df.to_numpy()
            else:
                df_order = pd.concat([df_order,rt_df ], ignore_index=True)

            self.orderId = rt['orderId']
            self.newClientOrderId = rt['clientOrderId']

            df_o = df_order[['orderId','symbol','price','origQty','status','updateDate','clientOrderId', ] ]

            conn = sqlite3.connect(self.dbfile)
            # ##df_order = pd.read_sql(' select * from order ', conn)
            rt_df.to_sql('orders', con=conn, if_exists='append', index=False) #,
            conn.close()

            df_order.to_pickle(f'{g_pkl_dir}/order_big_df.pkl' )
            # ##df_ord = pd.read_pickle('%s/%s.pkl' % (worthDir, "orderdf" ) )

            logger.info(f'df_o :\n{df_o}')

    def CancelAllOpenOrders(self):
        timestamp = int(round((time.time() +self.serverTimeadj) * 1000) )  # 时间戳ms
        url = f'{self.serverUrl}/fapi/v1/allOpenOrders'
        query_string = f'symbol={self.symbol}&recvWindow={self.recvWindow}&timestamp={str(timestamp)}'
        signature = hmac.new(self.secret_key.encode('utf-8'), query_string.encode('utf-8'), hashlib.sha256).hexdigest() #

        params = {"symbol":self.symbol, "recvWindow":self.recvWindow,"timestamp":timestamp, "signature":signature}

        headers = {"X-MBX-APIKEY":self.api_key}
        url2 = f"{url}?{query_string}&signature={signature}"

        res = requests.delete(url2, headers=headers) # , params=params
        # {"symbol":"BTCUSDT","leverage":2,"maxNotionalValue":"15000000"}
        # {"code":-1022,"msg":"Signature for this request is not valid."}

        rt = json.loads(res.text)

        if 'code' in rt and 'msg' in rt :
            if rt['code'] == '200':
                logger.info(f'res : {res.text}')
            else :
                logger.error(f'res : {res.text}')

    def qry_serverTime(self):
        url = f'{self.serverUrl}/fapi/v1/time'
        res = requests.get(url)
        rt = json.loads(res.text)

        if 'code' in rt and 'msg' in rt:
            logger.error(f'res : {res.text}')
        else:
            self.serverTime = rt['serverTime']  #ms
            self.serverTimeadj = ((rt['serverTime']- int(round((time.time() ) * 1000) )) ) //1000  # s

    def qry_exchangeInfo(self):
        url = f'{self.serverUrl}/fapi/v1/exchangeInfo'
        res = requests.get(url) #
        rt = json.loads(res.text)

        if 'code' in rt and 'msg' in rt :
            logger.error(f'res : {res.text}')
        else :
            logger.info(f'res : {len(res.text)}')  #
            with open(f"{g_pkl_dir}/exchangeInfo_u.pkl","wb") as handle:
                pickle.dump(rt, handle)   #保存
                self.set_symbolsFilters(rt)
                self.rateLimits = rt['rateLimits']

    def set_exchangeInfo(self):
        eufile = f"{g_pkl_dir}/exchangeInfo_u.pkl"
        if os.path.exists(eufile):
            with open(eufile,"rb") as f:
                exchangeInfo_u = pickle.load(f)  #读取
                self.set_symbolsFilters(exchangeInfo_u)
                self.rateLimits = exchangeInfo_u['rateLimits']  #流量限制[]
        else:
            self.qry_exchangeInfo()

    def set_symbolsFilters(self, exchangeInfo_dict):
        for item in exchangeInfo_dict['symbols']:
            if item['symbol'] == self.symbol : # 'BTCUSDT' pair 标的交易对
                self.status = item['status'] # 交易对状态

                for ite in item['filters']:
                    if ite['filterType'] == 'LOT_SIZE':
                        self.maxQty = float(ite['maxQty']) # 数量限制 数量上限, 最大数量
                        self.minQty = float(ite['minQty']) # 数量下限, 最小数量
                        self.minQtyDigit = len(ite['minQty'].split(".")[1]) # 数量限制 精度
                    elif ite['filterType'] == 'PERCENT_PRICE':
                        self.multiplierUp = float(ite['multiplierUp']) # 价格比限制 价格上限百分比
                        self.multiplierDown = float(ite['multiplierDown']) # 价格下限百分比
                    elif ite['filterType'] == 'PRICE_FILTER':
                        self.maxPrice = float(ite['maxPrice']) # 价格限制 价格上限, 最大价格
                        self.minPrice = float(ite['minPrice']) # 价格下限, 最小价格
                    elif ite['filterType'] == 'MARKET_LOT_SIZE':
                        self.market_maxQty = float(ite['maxQty']) # 市价订单 数量上限, 最大数量
                        self.market_minQty = float(ite['minQty']) # 市价订单 数量下限, 最小数量
                    elif ite['filterType'] == 'MAX_NUM_ORDERS':
                        self.max_num_order = float(ite['limit']) # 最多订单数限制
                    elif ite['filterType'] == 'MAX_NUM_ALGO_ORDERS':
                        self.max_num_algo_orders = float(ite['limit']) # 最多条件订单数限制
                    elif ite['filterType'] == 'MIN_NOTIONAL':
                        self.min_notional = float(ite['notional']) # 最小名义价值

    def qry_tcikerPrice(self):
        url = f'{self.serverUrl}/fapi/v1/ticker/price'
        params = {"symbol":self.symbol, }
        res = requests.get(url, params=params) #
        rt = json.loads(res.text)  #{"symbol":"BTCUSDT","price":"20137.10","time":1661961001841}

        if 'code' in rt and 'msg' in rt :
            logger.error(f'res : {res.text}')
        else:
            self.tcikerPrice = float(rt["price"])
            self.curDate = datetime.fromtimestamp( rt["time"]//1000 +self.locTimeadj).strftime('%Y%m%d')

    def qry_premiumIndex(self):
        url = f'{self.serverUrl}/fapi/v1/premiumIndex'
        params = {"symbol":self.symbol, }
        res = requests.get(url, params=params) #
        rt = json.loads(res.text)

        # {"symbol":"BTCUSDT","markPrice":"20133.32973555","indexPrice":"20133.75155317","estimatedSettlePrice":"20056.77850121","lastFundingRate":"-0.00194053","interestRate":"0.00010000","nextFundingTime":1661961600000,"time":1661961098000}

        if 'code' in rt and 'msg' in rt :
            logger.error(f'res : {res.text}')
        else :
            self.markPrice = float(rt["markPrice"])

    def qry_depth(self):
        url = f'{self.serverUrl}/fapi/v1/depth'
        params = {"symbol":self.symbol, "limit":self.depth_limit, }
        res = requests.get(url, params=params) #
        rt = json.loads(res.text)

        # {"lastUpdateId":27532317617,"E":1664272323243,"T":1664272323241,"bids":[["20173.30","4.937"],["20173.00","0.001"],["20172.90","4.228"],["20172.50","18.436"],["20171.30","14.832"]],"asks":[["20183.40","1.430"],["20183.80","61.862"],["20184.20","128.430"],["20184.60","71.158"],["20185.00","3.459"]]}

        if 'code' in rt and 'msg' in rt :
            logger.error(f'res : {res.text}')
        else :
            self.bids_price = float(rt['bids'][0][0]) # 买0价
            self.asks_price = float(rt['asks'][0][0]) # 卖0价

    def continuousKlines(self, pair='btcusdt', contractType='PERPETUAL', interval='1m', startTime=0, endTime=0, limit=499 ):

        url = f'{self.serverUrl}/fapi/v1/continuousKlines'

        # pair = 'btcusdt'
        # contractType = 'PERPETUAL'
        # interval = '5m' #period #1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h, 8h, 12h, 1d, 3d, 1w, 1M
        # startTime = 0
        # endTime = 0
        # limit = 3 #499

        if limit < 0 or startTime < 0 or endTime < 0 or (startTime > endTime):
            k_df = pd.DataFrame()
            logger.error(f'res : {{"code":-1130,"msg":"Data sent for parameter "limit" or "startTime" or "endTime" is not valid."}}')
            return k_df

        elif limit == 0:
            if startTime == 0 and endTime == 0:
                k_df = pd.DataFrame()
                logger.error(f'res : {{"code":-1130,"msg":"Data sent for parameter "limit" is not valid."}}')
                return k_df

            elif startTime == 0:
                params = {"pair":pair, "contractType":contractType, "interval":interval, "endTime":endTime }
            elif endTime == 0 :
                params = {"pair":pair, "contractType":contractType, "interval":interval,"startTime":startTime }
        elif limit > 0:
            if startTime == 0 and endTime == 0:
                params = {"pair":pair, "contractType":contractType, "interval":interval, "limit":limit, }
            elif startTime == 0:
                params = {"pair":pair, "contractType":contractType, "interval":interval, "endTime":endTime }
            elif endTime == 0 :
                params = {"pair":pair, "contractType":contractType, "interval":interval,"startTime":startTime, "limit":limit, }
            elif startTime > 0 and endTime > 0:  # startTime + limit < endTime
                params = {"pair":pair, "contractType":contractType, "interval":interval,"startTime":startTime, "endTime":endTime, "limit":limit, }

        logger.info(f'{params=}')

        res = requests.get(url, params=params)

        rt = json.loads(res.text)

        if 'code' in rt and 'msg' in rt:
            k_df = pd.DataFrame()
            logger.error(f'res : {res.text}')
        else:
            k_df = pd.DataFrame(rt)
            if k_df.empty:
                return k_df

            k_df.columns = ['openTime','open','high','low','close','vol','closeTime','Amt','numTrade','bidVol','bidAmt','ignore'] #

            k_df['open']  = pd.to_numeric(k_df['open'] , errors='coerce', downcast='float')
            k_df['high']  = pd.to_numeric(k_df['high'] , errors='coerce', downcast='float')
            k_df['low']  = pd.to_numeric(k_df['low'] , errors='coerce', downcast='float')
            k_df['close']  = pd.to_numeric(k_df['close'] , errors='coerce', downcast='float')
            k_df['vol']  = pd.to_numeric(k_df['vol'] , errors='coerce', downcast='float')
            k_df['Amt']  = pd.to_numeric(k_df['Amt'] , errors='coerce', downcast='float')
            k_df['bidVol']  = pd.to_numeric(k_df['bidVol'] , errors='coerce', downcast='float')
            k_df['bidAmt']  = pd.to_numeric(k_df['bidAmt'] , errors='coerce', downcast='float')
            k_df['openTime']  = pd.to_numeric(k_df['openTime'] , errors='coerce', downcast='integer')
            k_df['closeTime']  = pd.to_numeric(k_df['closeTime'] , errors='coerce', downcast='integer')
            k_df['numTrade']  = pd.to_numeric(k_df['numTrade'] , errors='coerce', downcast='integer')

            k_df['openDateTime'] = pd.to_datetime(k_df['openTime'], unit="ms") #, origin="1970-01-01 08:00:00" , unit="ms"
            k_df['closeDateTime'] = pd.to_datetime(k_df['closeTime']//1000, unit="s")
            # k_df['time'] = pd.to_datetime(int(time.time()), unit='s', unorigin="1970-01-01 08:00:00")

            k_df.drop(['ignore'], axis=1, inplace=True)
            k_df.sort_index(axis=1, ascending=True, inplace=True)

        return k_df

    def histUKline(self, symbol="BTCUSDT", interval="1m", histDays=1, limit=998):
        intervalSec = int(interval[0:-1]) * g_interval_coef[interval[-1] ]
        curSec = int(time.time())
        startSec = int(time.mktime(time.strptime(time.strftime("%Y%m%d", time.localtime(time.time()-60*60*24*histDays+self.locTimeadj ) ), '%Y%m%d')))
        startSec = startSec -self.locTimeadj -1

        interval_pre = interval
        if interval_pre == '10m':
            interval = '5m'
            intervalSec = intervalSec//2

        totalCount = math.ceil( (curSec - startSec )/intervalSec )
        logger.info(f'{interval=}, {startSec=}, {curSec=}, {intervalSec=}, {limit=}, {intervalSec*limit=}, {totalCount=}, {histDays=}')

        # ukdfHist = pd.DataFrame(columns=['tradeDate', 'openTime', 'closeTime', 'closeSec', 'open', 'close', ])
        ukdfHist = pd.DataFrame()
        count = 1
        for Sec in range(startSec, curSec, intervalSec*limit):
            print(f'{count=}:', "continuousKlines(", f'{symbol=}', ',', f'{interval=}', ',', f'{limit=}', ',', f'{Sec*1000+999=}', ', endTime=', f'{(Sec+intervalSec*limit-1)*1000+999}' , ' )')

            ukRet = self.continuousKlines(pair=symbol, interval=interval, limit=limit, startTime=Sec*1000+999, endTime=(Sec+intervalSec*limit-1)*1000+999 )
            kdf = pd.DataFrame([{'tradeDate': time.strftime("%Y%m%d", time.localtime(rs.closeTime/1000+self.locTimeadj) ), 'openTime': time.strftime("%H%M%S", time.localtime(rs.openTime/1000+self.locTimeadj) ), 'closeTime': time.strftime("%H%M%S", time.localtime(rs.closeTime/1000+self.locTimeadj) ), 'closeSec': rs.closeTime//1000, 'open': rs.open, 'close': rs.close} for _, rs in ukRet.iterrows() ])
            # ukdfHist.append(kdf)
            ukdfHist = pd.concat([ukdfHist,kdf],ignore_index=True)
            del kdf
            count += 1
            time.sleep(3)

        logger.info(f'ukdfHist.iloc[:5,:] :\n{ukdfHist.iloc[:5,:]}')
        logger.info(f'ukdfHist.iloc[-5:,:] :\n{ukdfHist.iloc[-5:,:]}')

        if interval_pre == '10m':
            interval = interval_pre
            intervalSec = int(intervalSec*2)
            rePeriod = '10T'

            ukdfHistCp = ukdfHist.copy()
            ukdfHistCp['dateTime'] = ukdfHistCp['closeSec'].apply(lambda x: datetime.fromtimestamp(x))
            ukdfHistCp = ukdfHistCp.set_index(keys=['dateTime'], drop=True)
            # ukdfHistCp = ukdfHistCp.reindex(ukdfHistCp['dateTime'].sort_values(ascending=True).index)

            logger.info(f'ukdfHistCp.iloc[:5,:] :\n{ukdfHistCp.iloc[:5,:]}')

            if not ukdfHistCp.empty:
                openSr = ukdfHistCp['open'].resample(rePeriod, label='right').first()
                openTimeSr = ukdfHistCp['openTime'].resample(rePeriod, label='right').first()
                closeSr = ukdfHistCp['close'].resample(rePeriod, label='right').last()  #last first max min
                closeTimeSr = ukdfHistCp['closeTime'].resample(rePeriod, label='right').last()
                closeSecSr = ukdfHistCp['closeSec'].resample(rePeriod, label='right').last()
                tradeDateSr = ukdfHistCp['tradeDate'].resample(rePeriod, label='right').last()

                ukdf = pd.concat([tradeDateSr, openTimeSr, closeTimeSr, closeSecSr,openSr, closeSr], axis=1)

            ukdf.columns = ['tradeDate', 'openTime', 'closeTime', 'closeSec', 'open', 'close']
            ukdf.reset_index(drop=True,inplace=True)

            if ukdf.iloc[-1]['closeSec'] - ukdf.iloc[-2]['closeSec'] < intervalSec:
                ukdf.drop([len(ukdf)-1],inplace=True)

            # ukdf = ukdfHistCp.copy()
            # logger.info(f'{ukdf.iloc[:5,:]=}')
            del ukdfHistCp
        else:
            ukdf = ukdfHist.copy()
        del ukdfHist

        ukdf['close'] = ukdf['close'].astype(float)
        ukdf['pct'] = ukdf['close']/ukdf['close'].shift(1)-1  #涨跌幅
        ukdf.fillna(0, inplace=True)

        logger.info(f'ukdf.iloc[:5,:] :\n{ukdf.iloc[:5,:]}')
        logger.info(f'ukdf.iloc[-5:,:] :\n{ukdf.iloc[-5:,:]}')

        self.ukdf = ukdf.copy()
        self.closeSec = ukdf['closeSec'].values[-1]
        self.close = ukdf['close'].values[-1]
        self.tradeDate = time.strftime("%Y%m%d", time.localtime(self.closeSec) )
        self.closeTime = time.strftime("%H%M%S", time.localtime(self.closeSec) )

    def mod_histUKline(self, symbol="BTCUSDT", interval="1m"):
        startTime = int(f"{self.ukdf.loc[self.ukdf.index[-2],'closeSec']}000")
        endTime = int(time.time() * 1000)
        if interval == '10m':
            interval_mod = '5m'

        ukRet = self.continuousKlines(pair=symbol, interval=interval_mod, startTime=startTime, endTime=endTime )  # limit=4
        kdf = pd.DataFrame([{'tradeDate': time.strftime("%Y%m%d", time.localtime(rs.closeTime/1000+self.locTimeadj) ), 'openTime': time.strftime("%H%M%S", time.localtime(rs.openTime/1000+self.locTimeadj) ), 'closeTime': time.strftime("%H%M%S", time.localtime(rs.closeTime/1000+self.locTimeadj) ), 'closeSec': rs.closeTime//1000, 'open': rs.open, 'close': rs.close} for _, rs in ukRet.iterrows() ])

        self.ukdf.loc[self.ukdf.index[-1],'close'] = kdf.loc[kdf['closeSec']==self.ukdf['closeSec'].iloc[-1],'close'].iloc[-1]
        self.ukdf.loc[self.ukdf.index[-1],'pct'] = self.ukdf['close'].iloc[-1]/self.ukdf['close'].iloc[-2]-1  #涨跌幅

        logger.info(f'ukdf.iloc[-5:,:] :\n{self.ukdf.iloc[-5:,:]}')

    def insertFactor(self):
        curDateTime = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time()+self.locTimeadj)) # s19 "%Y%m%d%H%M%S" %y%m%d%H%M%S  ms13
        factor = f"corrDate:{self.corrDate}, corrVal:{self.corrVal}"

        factor_df = pd.DataFrame(columns=['name', 'updateDateTime', 'clientOrderId', 'status', 'symbol', 'side', 'dirction','total', 'orderPrice', 'quantity', 'orderType', 'factor', 'updateTime', 'note'])
        factor_df.loc[len(factor_df.index)] = [self.name, curDateTime, self.newClientOrderId, self.name, self.symbol, self.flagDict['side'], self.flagDict['dirction'], self.total, self.orderPrice, self.flagDict['qty'], self.orderType, factor, int(time.time()*1000), '--']

        conn = sqlite3.connect(self.dbfile)
        # factor_df = pd.read_sql(' select * from factor ', conn)
        factor_df.to_sql('factor', con=conn, if_exists='append', index=False) #
        conn.close()

        logger.info(f"curDateTime:{curDateTime}, name:{self.name}, symbol:{self.symbol}, tradeDate:{self.tradeDate}, closeTime:{self.closeTime}, close:{self.close}, orderPrice:{self.orderPrice}, total:{self.total}, corrDate:{self.corrDate}, corrVal:{self.corrVal}, side:{self.flagDict['side']}, dirction:{self.flagDict['dirction']} " )

    def handle_signal(self):
        self.CleanOverukdf()
        corrdf = getSimilarity(self.ukdf, self.wid)
        self.corrVal = corrdf.iloc[1,0]
        self.corrDate = corrdf.index[1]

        print(f'corrdf :\n{corrdf}')
        print(f'{self.closeTime=}, {self.corrDate=}, {self.corrVal=}' )

        # ukdfPm = ukdf[ (ukdf['closeTime'] >= self.closeTime) & (ukdf['tradeDate'] == corrDate) ]
        ukdfPm = self.ukdf[ self.ukdf['tradeDate'] == self.corrDate ][self.wid:]

        if ukdfPm.iloc[0, 4] < ukdfPm.iloc[-1, 5]:  #open < close
            if self.corrVal >= self.corrLim: #OpenBuy
                self.flagDict['side'] = 'BUY'
                self.flagDict['isOpenBuy'] = True
            elif self.corrVal <= -self.corrLim: #OpenSell
                self.flagDict['side'] = 'SELL'
                self.flagDict['isOpenSell'] = True

        else: # open >= close
            if self.corrVal >= self.corrLim: #OpenSell
                self.flagDict['side'] = 'SELL'
                self.flagDict['isOpenSell'] = True
            elif self.corrVal <= -self.corrLim: #OpenBuy
                self.flagDict['side'] = 'BUY'
                self.flagDict['isOpenBuy'] = True

        self.flagDict['isOpen'] = True
        self.flagDict['isTrig'] = True
        self.flagDict['dirction'] = 'Open'

        self.trade_open_market()

    def trade_open_limit_test(self):
        self.orderPrice = self.tcikerPrice
        self.orderType = 'LIMIT'
        # self.set_quantity()
        self.flagDict['side'] = 'SELL'
        self.flagDict['qty'] = '0.001'
        self.orderPrice='88888.8'

        if float( self.flagDict['qty']) >= self.market_minQty:
            self.trade_future(symbol=self.symbol, side=self.flagDict['side'], price=self.orderPrice, quantity=self.flagDict['qty'], orderType=self.orderType, timeInForce='GTC')

            logger.info(f"{self.flagDict = }")
            logger.info(f"trade_future(symbol={self.symbol}, side={self.flagDict['side']}, price={self.orderPrice}, quantity={self.flagDict['qty']}, orderType={self.orderType}, timeInForce='GTC') ")
            self.insertFactor()
        else:
            logger.error(f"quantity error: {self.flagDict = }")
            logger.error(f"trade_future(symbol={self.symbol}, side={self.flagDict['side']}, price={self.orderPrice}, quantity={self.flagDict['qty']}, orderType={self.orderType}, timeInForce='GTC') ")

        self.reset_flagDict()

    def trade_open_market(self):
        self.orderPrice = self.tcikerPrice
        self.orderType = 'MARKET'
        self.set_quantity()

        if float( self.flagDict['qty']) > self.market_minQty:
            self.trade_future(symbol=self.symbol, side=self.flagDict['side'], price=self.orderPrice, quantity=self.flagDict['qty'], orderType=self.orderType, timeInForce='GTC')

            logger.info(f"{self.flagDict = }")
            logger.info(f"trade_future(symbol={self.symbol}, side={self.flagDict['side']}, price={self.orderPrice}, quantity={self.flagDict['qty']}, orderType={self.orderType}, timeInForce='GTC') ")
            self.insertFactor()
        else:
            logger.error(f"quantity error: {self.flagDict = }")
            logger.error(f"trade_future(symbol={self.symbol}, side={self.flagDict['side']}, price={self.orderPrice}, quantity={self.flagDict['qty']}, orderType={self.orderType}, timeInForce='GTC') ")

        self.reset_flagDict()

    def set_quantity(self):
        if self.totalAdjRate < -0.1:
            quantity = self.total*self.leverage*(1 + self.totalAdjRate) /self.tcikerPrice
        else:
            if self.orderType == 'LIMIT':
                self.evalPrice = self.tcikerPrice  # 预估价格
                if self.flagDict['side'] == 'BUY':
                    self.lossadjPrice = abs( min(0, 1* (self.markPrice - self.evalPrice) ) ) # 开仓亏损调整
                elif self.flagDict['side'] == 'SELL':
                    self.lossadjPrice = abs( min(0, -1* (self.markPrice - self.evalPrice) ) ) # 开仓亏损调整

            elif self.orderType == 'MARKET':
                if self.flagDict['side'] == 'BUY':
                    self.evalPrice = self.asks_price * self.multiplierUp  # 预估价格
                    self.lossadjPrice = abs( min(0, 1* (self.markPrice - self.evalPrice) ) ) # 开仓亏损调整
                elif self.flagDict['side'] == 'SELL':
                    self.evalPrice = max(self.bids_price, self.markPrice )
                    self.lossadjPrice = abs( min(0, -1* (self.markPrice - self.evalPrice) ) ) # 开仓亏损调整

            self.orderPrice = self.evalPrice + self.lossadjPrice
            quantity = self.total*self.leverage*(1 + self.totalAdjRate) / self.orderPrice

        self.flagDict['qty'] = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:self.minQtyDigit]

    def trade_close_market(self):
        if self.positiondf.empty:
            self.flagDict['side'] = ''
            logger.error(f"positiondf.empty error, clearance end : {self.flagDict=}")
        else:
            for index, rows in self.positiondf.iterrows():
                if float(rows['positionAmt']) == 0:
                    continue
                elif float(rows['positionAmt']) < 0:
                    self.flagDict['side'] = 'BUY'
                    self.flagDict['isOpenSell'] = False
                    self.flagDict['isCloseSell'] = True

                elif float(rows['positionAmt']) > 0:
                    self.flagDict['side'] = 'SELL'
                    self.flagDict['isOpenBuy'] = False
                    self.flagDict['isCloseBuy'] = True

                self.flagDict['dirction'] = 'Close'
                self.flagDict['isOpen'] = False
                self.flagDict['isClose'] = True
                quantity = abs(float(rows['positionAmt']))
                # self.flagDict['qty'] = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:self.minQtyDigit]
                self.flagDict['qty'] = rows['positionAmt'].replace('-','')

                logger.debug(f"positionAmt : {rows['positionAmt']} , quantity : {quantity}  , qty : {self.flagDict['qty']} ")

                self.orderPrice = self.tcikerPrice
                self.orderType = 'MARKET'
                self.trade_future(symbol=self.symbol, side=self.flagDict['side'], price=self.orderPrice, quantity=self.flagDict['qty'], orderType=self.orderType, timeInForce='GTC')

                logger.info(f"{self.flagDict = }")
                logger.info(f"trade_future(symbol={self.symbol}, side={self.flagDict['side']}, price={self.orderPrice}, quantity={self.flagDict['qty']}, orderType={self.orderType}, timeInForce='GTC') ")

                self.insertFactor()
                self.reset_flagDict()

    def reset_flagDict(self):
        self.flagDict = {'side':"", 'dirction':"", 'qty':0, 'posBuy':0, 'posSell':0,'isNewDay':False, 'isOpenBuy':False, 'isOpenSell':False, 'isCloseBuy':False, 'isCloseSell':False, 'isOpen':False, 'isClose':False,'isTrig':False,'isCorr':False }

    def CleanOverukdf(self):
        overDate = time.strftime("%Y%m%d", time.localtime(self.closeSec-60*60*24*self.histDays+self.locTimeadj ) )
        self.ukdf.drop(self.ukdf.index[(self.ukdf['tradeDate'] < overDate)], inplace=True)
        self.ukdf.reset_index(drop=True, inplace=True)

        print(f'\n--ukdf-hist--: {overDate=} \n', self.ukdf.iloc[0:5,:] ,'\n' , self.ukdf.iloc[-5:,:],'\n' )

def getSimilarity(ukdf, wid) -> pd.DataFrame:
    ukdfT = ukdf.pivot(index='closeTime', columns='tradeDate', values='close')
    ukdfAmT = ukdfT.iloc[:wid].copy()
    ukdfAmT.dropna(how='any',inplace=True)
    ukdfAmT.reset_index(drop=True,inplace=True)
    ukdfAmT = ukdfAmT.apply(lambda x: x.astype(float))

    corrdf = ukdfAmT.corr()

    # logger.info(f'corrdf.iloc[:5,:] :\n{corrdf.iloc[:5,:]}')
    # logger.info(f'corrdf.iloc[-5:,:] :\n{corrdf.iloc[-5:,:]}')

    df_corr = corrdf.iloc[:, [-1]]
    df_corr.columns=['corr']
    # df_corr = df_corr.reindex(df_corr['corr'].abs().sort_values(ascending=False).index)
    df_corr = df_corr.reindex(df_corr['corr'].sort_values(ascending=False).index)
    # logger.info(f"df_corr :\n{df_corr}")  # corr: df_corr.iloc[1,0], data: df_corr.index[1]
    return df_corr

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
        elif opt in ("-c", '--clientPort'):
            arg_param['clientPort'] = arg

    logger.info(f"{arg_param =}")
    return arg_param

def run():
    logger.info(f"--{g_name}--start--{g_version}----------")
    arg_param = get_argv()

    binan = Binance(arg_param['name'], arg_param['symbol'], arg_param['interval'], arg_param['wid'], arg_param['histDays'] )
    binan.qry_account()
    binan.set_exchangeInfo()

    binan.qry_serverTime()
    curDateTime = datetime.fromtimestamp( binan.serverTime//1000 +binan.locTimeadj).strftime('%Y%m%d %H%M%S %w')
    hhmm = int(curDateTime[9:13]) # 1358
    weekday = int(curDateTime[-1:]) # 0

    if hhmm >= 2355 or hhmm <= 5: # 5 2355 1605
        binan.qry_tcikerPrice()
        binan.trade_close_market()
        binan.qry_account()

        if not weekday:
            binan.qry_exchangeInfo()

    elif 657 <= hhmm <= 710: # 657  710 700
        binan.histUKline(symbol=binan.symbol, interval=binan.interval, histDays=binan.histDays)

        while True:
            curDateTime = datetime.fromtimestamp( time.time() +binan.serverTimeadj).strftime('%Y%m%d %H%M%S %w')
            hhmm = int(curDateTime[9:13]) # 1358
            hhmmss = int(curDateTime[9:15]) # 1358

            if 700 <= hhmm :
                time.sleep(3*1)   #秒s
                binan.mod_histUKline(symbol=binan.symbol, interval=binan.interval)
                binan.set_leverage()
                binan.qry_tcikerPrice()
                binan.qry_premiumIndex()
                binan.qry_depth()
                binan.handle_signal()
                binan.qry_account()
                break
            time.sleep(3*1)   #秒s

    # elif 700 <= hhmm <= 710: # 710 2340
    #     binan.histUKline(symbol=binan.symbol, interval=binan.interval, histDays=binan.histDays)
    #     binan.set_leverage()
    #     binan.qry_tcikerPrice()
    #     binan.qry_premiumIndex()
    #     binan.qry_depth()
    #     binan.handle_signal()
    #     binan.qry_account()

    else:
        # binan.histUKline(symbol=binan.symbol, interval=binan.interval, histDays=binan.histDays)

        # binan.set_leverage()
        # binan.qry_tcikerPrice()
        # binan.qry_premiumIndex()
        # binan.qry_depth()
        binan.trade_open_limit_test()
        # binan.CancelAllOpenOrders()
        binan.qry_balance()
        binan.qry_account()
        print(f"3. {hhmm = } zzZ------------")

    logger.debug(f"cls_var:  { {k: v for k, v in binan.__dict__.items() if not k.startswith('__')} }")

    # while True:
    #     time.sleep(60*1)   #秒s

if __name__ == '__main__':
    run()

# nohup python3 -u main.py -n testStrategy -s 8808 -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &
# nohup python3 -u main.py -n similarity_big -X BTCUSDT -p 10m -w 42 -d 84  >> log.txt 2>&1  &
