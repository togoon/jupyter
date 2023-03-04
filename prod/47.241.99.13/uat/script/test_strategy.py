import time
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
        deltatime1 = data.handletime - data.closetime;
        deltatime2 = time.time()*1000 - data.handletime;
        logger.info(f"kline symbol:{data.symbol} opentime:{data.opentime} closetime:{data.closetime} handletime:{data.handletime} closeprice:{data.closeprice} deltatime1:{deltatime1} deltatime2:{deltatime2}")
        logger.info("before insert")
        if self.pos == 1:
            self.client.insertMarketQOrder("simulator_bitmex", "ETHUSD", 1000000, "buy")
        else:
            self.client.insertMarketQOrder("simulator_bitmex", "ETHUSD", 1000000, "sell")
        self.pos = 1 - self.pos
        logger.info("after insert")
    
    def handleOrderNew(self, data:OrderType):
        logger.info(f"new: {data}")
    
    def handleOrderFilled(self, data):
        logger.info(f"filled: {data}")

    def handleError(self, data):
        logger.error(f"error: {data}")

    def handleTimer(self, data):
        logger.info(f"timer: {data}  now:{time.time()}")

def test():
    cli = FILClient(MyFILHandler("test-strategy0"),"http://127.0.0.1:8888/strategy",30,"127.0.0.1",9090)
    cli.start()
    cli.subOrderReport("simulator_bitmex")
    # cli.subTimer(5*1000)

    # cli.cancelAllSubKlines();
    # cli.cancelAllSubTicks();
    cli.subKline("simulator_bitmex", "quanto", "ETHUSD", "1m")
    # cli.subTick("simulator", "quanto", "BTCUSDT")
    logger.info("start")

    # print("info ========> {}",cli.queryStrategyInfo()) 

    # print("contractasset ========> {}",cli.queryContractAssets("USDT")) 

    # print("order ========> {}",cli.queryMarketOrder(1500000000,0,5)) 

    # print("factor ========> {}",cli.queryFactor(1, 1500000000,0,5)) 

    # print("balance ========> {}",cli.queryBalances("USDT")) 

    # print("position ========> {}",cli.queryPositions("ETHUSDT","long")) 
    
    # print("uprice ========> {}",cli.queryUPrice("BTCUSDT")) 

    # cli.cancelAllSubTicks();
    # cli.cancelAllSubKlines();
    # cli.deleteAllOrder();
    # cli.closeAllPosition();
    # cli.close();

    input()

def main():
    test()

if __name__ == '__main__':
    main()
