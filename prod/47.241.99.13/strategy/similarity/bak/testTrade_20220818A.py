import time
import getopt
import sys
import math
import random
import datetime
from matplotlib.pyplot import xlabel
import pandas as pd
import numpy as np

from FIL_lib.my_logger import make_logger, logging
from FIL_lib.client import FILClient, Handler
from FIL_lib.core_types import *



GATEWAY = "simulator"
tradeType = "usdt"

interval = '10m'
total = 1000000
name = "testTrade"
symbol = 'BTCUSDT'
clientPort = 29290
serverPort = 8808

version = "2.1.5"

print( f'Now: {version} : {time.strftime("%Y-%m-%d %H:%M:%S")}')

curDate = time.strftime("%Y%m%d")
# logger = make_logger(name, log_level=logging.DEBUG, log_file= name + "_"+ str(curDate)+".log")
# logger = make_logger("testTrade", log_file="my_log.txt")
logger = ''


class MyFILHandler(Handler):
    def __init__(self, name:str='testTrade', symbol:str='BTCUSDT', total:float=1000000.0):

        self.pos = random.randint(0,9) # 0
        self.name = name

        self.total = total
        self.symbol = symbol

        self.flagDict = {'side':"", 'posBuy':0, 'posSell':0,'isNewDay':False, 'isOpenBuy':False, 'isOpenSell':False, 'isCloseBuy':False, 'isCloseSell':False, 'isOpen':False, 'isClose':False,'isTrig':False,'isCorr':False }

        self.count = 0
        self.curDate = ''
        self.tradeDate = self.openTime = self.closeTime = self.closeSec = self.openSec = self.open = self.close = ''
        self.corrVal = self.corrDate = ''

        # logger.info(f"__init__: {self=}")
        logger.info(f'{self.name=}, {self.symbol=}, {self.total=}, {self.count=}, {self.flagDict=}')

    def handleTimer(self, data:TimeridType):
        logger.info(f"handleTimer: {data=}")

    def handleTick(self, data:SubTickType):
        # logger.info(f"tick opentime:{data.tick.opentime // 1000} closeprice:{data.tick.closeprice}")
        logger.info(f"handleTick: {data=}")


    def handleKline(self, data:KlineType):

        if data.symbol != self.symbol:
            return

        self.tradeDate = time.strftime("%Y%m%d", time.localtime(data.closetime/1000) )
        self.openTime = time.strftime("%H%M%S", time.localtime(data.opentime/1000) )
        self.closeTime = time.strftime("%H%M%S", time.localtime(data.closetime/1000) )
        self.closeSec = data.closetime//1000
        self.open = data.openprice
        self.close = data.closeprice

        self.openSec = data.opentime//1000
        self.count = self.count +1

        logger.info(f'{self.name=}, {self.symbol=}, {self.tradeDate=}, {self.openTime=}, {self.closeTime=}, {self.open=}, {self.close=}, {self.closeSec=}, {self.count=}, {self.pos=}' )

        if self.count == 1:
            positions = self.client.queryPositions(self.symbol, 'long')
            print((f"closeBuy: {self.symbol=}, {positions=}"))

            positions2 = self.client.queryPositions(self.symbol, 'short')
            print((f"closeSelf: {self.symbol=}, {positions2=}"))

            if positions.result or positions2.result:
                self.flagDict['isOpen'] = True               
                self.flagDict['isClose'] = False 
            else:
                self.flagDict['isOpen'] = False               
                self.flagDict['isClose'] = True                 

        elif self.count > self.pos:
            self.insertFactor()

            if self.flagDict['isOpen']:
                self.client.closeAllPosition()
                logger.info(f"closeAllPosition: {self.count=},{self.pos=}") 
                self.flagDict['isOpen'] = False               
                self.flagDict['isClose'] = True   
                self.pos = self.count + random.randint(0,9)

            elif self.flagDict['isClose']:  

                self.queryContractAssets()

                if self.count % 10 > random.randint(0,9):
                    self.openBuy(self.close)             
                else:
                    self.openSell(self.close)    

                self.flagDict['isOpen'] = True               
                self.flagDict['isClose'] = False   
                self.pos = self.count + random.randint(0,9)

        '''
        if self.pos <= -20:
            if self.pos % 4 == 0:
                self.queryContractAssets()
                self.openBuy(self.close)

                # self.client.insertMarketUOrder("simulator", "BTCUSDT", 1, "buy")
            elif self.pos % 4 == 1:
                self.closeBuy()

            elif self.pos % 4 == 2:
                self.queryContractAssets()
                self.openSell(self.close)

            elif self.pos % 4 == 3:
                self.closeSell()

            else:
                self.clearance()

                # self.client.insertMarketUOrder("simulator", "BTCUSDT", 1, "sell")

            self.insertFactor()

        elif self.count == 2:

            # self.insertFactor()

            self.queryContractAssets()

            positions = self.client.queryPositions(self.symbol, 'long')
            print((f"closeBuy: {self.symbol=}, {positions=}"))

            positions2 = self.client.queryPositions(self.symbol, 'short')
            print((f"closeSelf: {self.symbol=}, {positions2=}"))

            # self.client.closeAllPosition()
            # logger.info(f"closeAllPosition count: {self.count}")

            # self.client.closePosition(self.symbol, side='long' )
            # logger.info(f"closePosition count: {self.count}")            

            # self.openBuy(self.close) 
        '''

        # self.pos += 1

    
    def handleOrderNew(self, data:OrderType):
        logger.info(f"new: {data}")
    
    def handleOrderFilled(self, data):
        logger.info(f"filled: {data}")

    def handleError(self, data):
        logger.error(f"error: {data}")

    def queryContractAssets(self):

        global tradeType
        assets = self.client.queryContractAssets(tradeType)
        # logger.info(f"queryContractAssets: {assets=}")

        if assets.result:
            for item in assets.result:
                if item.asset.upper() == tradeType.upper():
                    self.total = float(item.free)


    def insertFactor(self):
        curDateTime = int(time.strftime("%m%d%H%M"))  #"%Y%m%d%H%M%S"
        # factor = {'symbol':self.symbol, 'side':self.flagDict['side'], 'isTrig':self.flagDict['isTrig'], 'isOpen':self.flagDict['isOpen'], 'isClose':self.flagDict['isClose'], 'tradeDate':self.tradeDate, 'openTime':self.openTime, 'closeTime':self.closeTime, 'closeSec':self.closeSec, 'open':self.open, 'close':self.close, 'corrVal':self.corrVal, 'corrDate':self.corrDate, 'total':self.total, }

        ret = self.client.insertFactor(curDateTime, f"name:{self.name}, symbol:{self.symbol}, closeTime:{self.closeTime}, close:{self.close}, total:{self.total}, side:{self.flagDict['side']}, side:{self.flagDict['isOpen']}, side:{self.flagDict['isClose']} " )

        # print(f'{ret=}')

        logger.info( f"name:{self.name}, symbol:{self.symbol}, closeTime:{self.closeTime}, close:{self.close}, total:{self.total}, side:{self.flagDict['side']}, side:{self.flagDict['isOpen']}, side:{self.flagDict['isClose']}  " )  

    def openBuy(self, close):
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenBuy'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "buy"
    
        quantity = float(self.total-100)/float(close)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        self.client.insertMarketUOrder("simulator", self.symbol, float(qtyStr), "buy")
        logger.info(f'self.client.insertMarketUOrder("simulator", {self.symbol}, {qtyStr}, "buy")')

        # self.client.insertLimitUOrder("simulator", self.symbol, float(qtyStr), close, "buy")
        # logger.info(f'self.client.insertLimitUOrder("simulator", "{self.symbol}", {qtyStr}, {close}, "buy")')

        logger.info(f"{self.flagDict=}")
      


    def openSell(self, close):
        self.flagDict['isOpen'] = True
        self.flagDict['isClose'] = False
        self.flagDict['isOpenSell'] = True
        self.flagDict['isCloseBuy'] = False
        self.flagDict['side'] = "sell"

        quantity = float(self.total-1)/float(close)
        qtyStr = str(quantity).split('.')[0] + '.' + str(quantity).split('.')[1][:3]

        self.client.insertMarketUOrder("simulator", self.symbol, float(qtyStr), "sell")

        logger.info(f'self.client.insertMarketUOrder("simulator", {self.symbol}, {qtyStr}, "sell")')

        # logger.info(f"{self.flagDict=}")

    def closeBuy(self):
        self.flagDict['isOpen'] = False
        self.flagDict['isClose'] = True
        self.flagDict['isOpenBuy'] = False
        self.flagDict['isCloseBuy'] = True
        self.flagDict['side'] = "sell"

        positions = self.client.queryPositions(self.symbol, 'long')
        print((f"closeBuy: {self.symbol=}, {positions=}"))
        if positions.result:

            for posi in positions.result:

                side = "buy" if posi.positionside == 'short' else "sell"

                self.client.insertMarketUOrder("simulator", posi.symbol, posi.positionAmount, side)

                logger.info(f"{self.flagDict=}")
                logger.info(f'self.client.insertMarketUOrder("simulator",  {posi.symbol}, {posi.positionAmount}, {side} )')

    def closeSell(self):
        self.flagDict['isOpen'] = False
        self.flagDict['isClose'] = True
        self.flagDict['isOpenSell'] = False
        self.flagDict['isCloseBuy'] = True
        self.flagDict['side'] = "buy"

        positions = self.client.queryPositions(self.symbol, 'short')
        print((f"closeSell: {self.symbol=}, {positions=}"))
        if positions.result:

            for posi in positions.result:

                side = "buy" if posi.positionside == 'short' else "sell"

                self.client.insertMarketUOrder("simulator", posi.symbol, posi.positionAmount, side)

                logger.info(f"{self.flagDict=}")
                logger.info(f'self.client.insertMarketUOrder("simulator", {posi.symbol}, {posi.positionAmount}, {side} )')

    def clearance(self):
        positions = self.client.queryPositions(self.symbol)
        print((f"clearance: {self.symbol=}, {positions=}"))
        if positions.result:

            for posi in positions.result:

                side = "buy" if posi.positionside == 'short' else "sell"

                self.client.insertMarketUOrder("simulator",  posi.symbol, posi.positionAmount, side)

                logger.info(f"{self.flagDict=}")
                logger.info(f'self.client.insertMarketUOrder("simulator", {posi.symbol}, {posi.positionAmount}, {side} )')


def test(argv):

    global interval
    global total
    global name
    global logger
    global symbol
    global curDate
    global GATEWAY
    global tradeType
    global clientPort
    global serverPort


    input_pro = '-n <name>  -s <serverPort>  -c <clientPort> -X <symbol> -p <period>  -t <total>'
    try:
        # 优先级i>d>args
        opts, args = getopt.getopt(argv, "n:s:c:X:p:t:", ["name",'serverPort','clientPort',"symbol","period","total"])
        print(f'{opts=}')

    except getopt.GetoptError:
        print('--input_pro--: ', input_pro)
        sys.exit(2)

    for opt, arg in opts:
        if opt in ("-t", '--total'):
            total = float(arg)
        elif opt in ("-n", '--name'):
            name = arg
        elif opt in ("-X", '--symbol'):
            symbol = arg
        elif opt in ("-p", '--period'):
            interval = arg

        elif opt in ("-s", '--serverPort'):
            serverPort = int(arg)
        elif opt in ("-c", '--clientPort'):
            clientPort = int(arg)

    curDate = time.strftime("%Y%m%d")
    logger = make_logger(name, log_level=logging.DEBUG, log_file= name +"_" + str(curDate)+".log")

    logger.info(f'{name=},{curDate=},{GATEWAY=},{symbol=},{tradeType=},{total=},{interval=},{serverPort=},{clientPort=}')

    # cli = FILClient(MyFILHandler("testTrade","BTCUSDT",1000000.0), listen_port=29290)

    # cli = FILClient(MyFILHandler("testTrade","BTCUSDT",1000000.0), timeout=(3, 5),server_url="http://127.0.0.1:8808/strategy" , listen_port=29290)  

    cli = FILClient(MyFILHandler(name,symbol,total), timeout=(3,5), server_url="http://127.0.0.1:%d/strategy" % serverPort, listen_port=clientPort)

    cli.start()

    cli.subOrderReport(GATEWAY) # "simulator"
    cli.cancelAllSubKlines()
    cli.subKline(GATEWAY, tradeType, symbol, interval) # "simulator","usdt","BTCUSDT", "10m" 

    cli.cancelAllSubTicks()
    # cli.subTick("simulator", "usdt", "BTCUSDT")

    # cli.cancelSubTimer(5*1000)
    # cli.subTimer(5*1000)

    # cli.deleteAllOrder()
    # cli.closeAllPosition()
    # cli.close()

    # input()
    while True:
        time.sleep(60*60)

# def main():
#     test()

# if __name__ == '__main__':
#     main()

def main(argv):
    test(argv)

if __name__ == '__main__':
    print('__main__: ', sys.argv)
    main(sys.argv[1:])
