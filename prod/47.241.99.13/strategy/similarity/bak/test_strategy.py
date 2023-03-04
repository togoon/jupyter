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
        logger.info(f"kline opentime:{data.opentime // 1000} closeprice:{data.closeprice}")
        logger.info("before insert")
        if self.pos == 1:
            self.client.insertMarketUOrder("simulator", "BTCUSDT", 1, "buy")
        else:
            self.client.insertMarketUOrder("simulator", "BTCUSDT", 1, "sell")
        self.pos = 1 - self.pos
        logger.info("after insert")
    
    def handleOrderNew(self, data:OrderType):
        logger.info(f"new: {data}")
    
    def handleOrderFilled(self, data):
        logger.info(f"filled: {data}")

    def handleError(self, data):
        logger.error(f"error: {data}")

def test():
    cli = FILClient(MyFILHandler("test-strategy"))
    cli.start()
    cli.subOrderReport("simulator")
    cli.subKline("simulator", "usdt", "BTCUSDT", "1m")
    logger.info("start")

    # cli.cancelAllSubKlines();
    # cli.deleteAllOrder();
    # cli.closeAllPosition();
    # cli.close();

    input()

def main():
    test()

if __name__ == '__main__':
    main()
