import time
import getopt
import sys
import math
import datetime
from matplotlib.pyplot import xlabel
import pandas as pd
import numpy as np


from FIL_lib.my_logger import make_logger
from FIL_lib.client import FILClient, Handler
from FIL_lib.core_types import *

GATEWAY = "simulator"

logger = make_logger("my", log_file="my_log.txt")

class MyFILHandler(Handler):
    def __init__(self, name):
        self.pos = 1
        self.name = name

    def handleTick(self, data:SubTickType):
        logger.info(f"tick opentime:{data.tick.opentime // 1000} closeprice:{data.tick.closeprice}")

    def handleKline(self, data:KlineType):

        self.closeTime = time.strftime("%H%M%S", time.localtime(data.closetime/1000) )
        logger.info(f"kline closeSec:{data.closetime // 1000}, closeTime:{self.closeTime}, closeprice:{data.closeprice}")

        # logger.info("before insert")
        # if self.pos == 1:
        #     self.client.insertMarketUOrder("simulator", "BTCUSDT", 1, "buy")
        # else:
        #     self.client.insertMarketUOrder("simulator", "BTCUSDT", 1, "sell")
        # self.pos = 1 - self.pos
        # logger.info("after insert")
    
    def handleOrderNew(self, data:OrderType):
        logger.info(f"new: {data}")
    
    def handleOrderFilled(self, data):
        logger.info(f"filled: {data}")

    def handleError(self, data):
        logger.error(f"error: {data}")

def test():
    cli = FILClient(MyFILHandler("test-strategy"), listen_port=29090)
    cli.start()
    cli.subOrderReport("simulator")
    cli.cancelAllSubKlines()
    cli.subKline("simulator", "usdt", "BTCUSDT", "1m")
    logger.info("start")

    # cli.cancelAllSubKlines();
    # cli.deleteAllOrder();
    # cli.closeAllPosition();
    # cli.close();

    # input()
    while True:
        time.sleep(60*60)


def main():
    test()

if __name__ == '__main__':
    main()
