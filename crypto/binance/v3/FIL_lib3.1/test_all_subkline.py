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

    def handleTimer(self, data):
        logger.info(f"timer: {data}  now:{time.time()}")

def test():
    cli = FILClient(MyFILHandler("test-strategy"),"http://127.0.0.1:10086/strategy",30,"127.0.0.1",10088)
    cli.start()
    cli.subOrderReport("simulator")
    # cli.subTimer(5*1000)

    # cli.cancelAllSubKlines();
    # cli.cancelAllSubTicks();
    cli.subKline("simulator", "usdt", "BTCUSDT", "5m")
    cli.subKline("simulator", "usdt", "ETHUSDT", "5m")
    cli.subKline("simulator", "usdt", "BCHUSDT", "5m")
    cli.subKline("simulator", "usdt", "XRPUSDT", "5m")
    cli.subKline("simulator", "usdt", "EOSUSDT", "5m")
    cli.subKline("simulator", "usdt", "LTCUSDT", "5m")
    cli.subKline("simulator", "usdt", "TRXUSDT", "5m")
    cli.subKline("simulator", "usdt", "ETCUSDT", "5m")
    cli.subKline("simulator", "usdt", "LINKUSDT", "5m")
    cli.subKline("simulator", "usdt", "XLMUSDT", "5m")
    time.sleep(10)

    cli.subKline("simulator", "usdt", "ADAUSDT", "5m")
    cli.subKline("simulator", "usdt", "XMRUSDT", "5m")
    cli.subKline("simulator", "usdt", "DASHUSDT", "5m")
    cli.subKline("simulator", "usdt", "ZECUSDT", "5m")
    cli.subKline("simulator", "usdt", "XTZUSDT", "5m")
    cli.subKline("simulator", "usdt", "BNBUSDT", "5m")
    cli.subKline("simulator", "usdt", "ATOMUSDT", "5m")
    cli.subKline("simulator", "usdt", "ONTUSDT", "5m")
    cli.subKline("simulator", "usdt", "IOTAUSDT", "5m")
    cli.subKline("simulator", "usdt", "BATUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "VETUSDT", "5m")
    cli.subKline("simulator", "usdt", "NEOUSDT", "5m")
    cli.subKline("simulator", "usdt", "QTUMUSDT", "5m")
    cli.subKline("simulator", "usdt", "IOSTUSDT", "5m")
    cli.subKline("simulator", "usdt", "THETAUSDT", "5m")
    cli.subKline("simulator", "usdt", "ALGOUSDT", "5m")
    cli.subKline("simulator", "usdt", "ZILUSDT", "5m")
    cli.subKline("simulator", "usdt", "KNCUSDT", "5m")
    cli.subKline("simulator", "usdt", "ZRXUSDT", "5m")
    cli.subKline("simulator", "usdt", "COMPUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "OMGUSDT", "5m")
    cli.subKline("simulator", "usdt", "DOGEUSDT", "5m")
    cli.subKline("simulator", "usdt", "SXPUSDT", "5m")
    cli.subKline("simulator", "usdt", "KAVAUSDT", "5m")
    cli.subKline("simulator", "usdt", "BANDUSDT", "5m")
    cli.subKline("simulator", "usdt", "RLCUSDT", "5m")
    cli.subKline("simulator", "usdt", "WAVESUSDT", "5m")
    cli.subKline("simulator", "usdt", "MKRUSDT", "5m")
    cli.subKline("simulator", "usdt", "SNXUSDT", "5m")
    cli.subKline("simulator", "usdt", "DOTUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "DEFIUSDT", "5m")
    cli.subKline("simulator", "usdt", "YFIUSDT", "5m")
    cli.subKline("simulator", "usdt", "BALUSDT", "5m")
    cli.subKline("simulator", "usdt", "CRVUSDT", "5m")
    cli.subKline("simulator", "usdt", "TRBUSDT", "5m")
    cli.subKline("simulator", "usdt", "RUNEUSDT", "5m")
    cli.subKline("simulator", "usdt", "SUSHIUSDT", "5m")
    cli.subKline("simulator", "usdt", "SRMUSDT", "5m")
    cli.subKline("simulator", "usdt", "EGLDUSDT", "5m")
    cli.subKline("simulator", "usdt", "SOLUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "ICXUSDT", "5m")
    cli.subKline("simulator", "usdt", "STORJUSDT", "5m")
    cli.subKline("simulator", "usdt", "BLZUSDT", "5m")
    cli.subKline("simulator", "usdt", "UNIUSDT", "5m")
    cli.subKline("simulator", "usdt", "AVAXUSDT", "5m")
    cli.subKline("simulator", "usdt", "FTMUSDT", "5m")
    cli.subKline("simulator", "usdt", "HNTUSDT", "5m")
    cli.subKline("simulator", "usdt", "ENJUSDT", "5m")
    cli.subKline("simulator", "usdt", "FLMUSDT", "5m")
    cli.subKline("simulator", "usdt", "TOMOUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "RENUSDT", "5m")
    cli.subKline("simulator", "usdt", "KSMUSDT", "5m")
    cli.subKline("simulator", "usdt", "NEARUSDT", "5m")
    cli.subKline("simulator", "usdt", "AAVEUSDT", "5m")
    cli.subKline("simulator", "usdt", "FILUSDT", "5m")
    cli.subKline("simulator", "usdt", "RSRUSDT", "5m")
    cli.subKline("simulator", "usdt", "LRCUSDT", "5m")
    cli.subKline("simulator", "usdt", "MATICUSDT", "5m")
    cli.subKline("simulator", "usdt", "OCEANUSDT", "5m")
    cli.subKline("simulator", "usdt", "CVCUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "BELUSDT", "5m")
    cli.subKline("simulator", "usdt", "CTKUSDT", "5m")
    cli.subKline("simulator", "usdt", "AXSUSDT", "5m")
    cli.subKline("simulator", "usdt", "ALPHAUSDT", "5m")
    cli.subKline("simulator", "usdt", "ZENUSDT", "5m")
    cli.subKline("simulator", "usdt", "SKLUSDT", "5m")
    cli.subKline("simulator", "usdt", "GRTUSDT", "5m")
    cli.subKline("simulator", "usdt", "1INCHUSDT", "5m")
    cli.subKline("simulator", "usdt", "CHZUSDT", "5m")
    cli.subKline("simulator", "usdt", "SANDUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "ANKRUSDT", "5m")
    cli.subKline("simulator", "usdt", "BTSUSDT", "5m")
    cli.subKline("simulator", "usdt", "LITUSDT", "5m")
    cli.subKline("simulator", "usdt", "UNFIUSDT", "5m")
    cli.subKline("simulator", "usdt", "REEFUSDT", "5m")
    cli.subKline("simulator", "usdt", "RVNUSDT", "5m")
    cli.subKline("simulator", "usdt", "SFPUSDT", "5m")
    cli.subKline("simulator", "usdt", "XEMUSDT", "5m")
    cli.subKline("simulator", "usdt", "BTCSTUSDT", "5m")
    cli.subKline("simulator", "usdt", "COTIUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "CHRUSDT", "5m")
    cli.subKline("simulator", "usdt", "MANAUSDT", "5m")
    cli.subKline("simulator", "usdt", "ALICEUSDT", "5m")
    cli.subKline("simulator", "usdt", "HBARUSDT", "5m")
    cli.subKline("simulator", "usdt", "ONEUSDT", "5m")
    cli.subKline("simulator", "usdt", "LINAUSDT", "5m")
    cli.subKline("simulator", "usdt", "STMXUSDT", "5m")
    cli.subKline("simulator", "usdt", "DENTUSDT", "5m")
    cli.subKline("simulator", "usdt", "CELRUSDT", "5m")
    cli.subKline("simulator", "usdt", "HOTUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "MTLUSDT", "5m")
    cli.subKline("simulator", "usdt", "OGNUSDT", "5m")
    cli.subKline("simulator", "usdt", "NKNUSDT", "5m")
    cli.subKline("simulator", "usdt", "SCUSDT", "5m")
    cli.subKline("simulator", "usdt", "DGBUSDT", "5m")
    cli.subKline("simulator", "usdt", "1000SHIBUSDT", "5m")
    cli.subKline("simulator", "usdt", "ICPUSDT", "5m")
    cli.subKline("simulator", "usdt", "BAKEUSDT", "5m")
    cli.subKline("simulator", "usdt", "GTCUSDT", "5m")
    cli.subKline("simulator", "usdt", "BTCDOMUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "TLMUSDT", "5m")
    cli.subKline("simulator", "usdt", "IOTXUSDT", "5m")
    cli.subKline("simulator", "usdt", "AUDIOUSDT", "5m")
    cli.subKline("simulator", "usdt", "RAYUSDT", "5m")
    cli.subKline("simulator", "usdt", "C98USDT", "5m")
    cli.subKline("simulator", "usdt", "MASKUSDT", "5m")
    cli.subKline("simulator", "usdt", "ATAUSDT", "5m")
    cli.subKline("simulator", "usdt", "DYDXUSDT", "5m")
    cli.subKline("simulator", "usdt", "1000XECUSDT", "5m")
    cli.subKline("simulator", "usdt", "GALAUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "CELOUSDT", "5m")
    cli.subKline("simulator", "usdt", "ARUSDT", "5m")
    cli.subKline("simulator", "usdt", "KLAYUSDT", "5m")
    cli.subKline("simulator", "usdt", "ARPAUSDT", "5m")
    cli.subKline("simulator", "usdt", "CTSIUSDT", "5m")
    cli.subKline("simulator", "usdt", "LPTUSDT", "5m")
    cli.subKline("simulator", "usdt", "ENSUSDT", "5m")
    cli.subKline("simulator", "usdt", "PEOPLEUSDT", "5m")
    cli.subKline("simulator", "usdt", "ANTUSDT", "5m")
    cli.subKline("simulator", "usdt", "ROSEUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "DUSKUSDT", "5m")
    cli.subKline("simulator", "usdt", "FLOWUSDT", "5m")
    cli.subKline("simulator", "usdt", "IMXUSDT", "5m")
    cli.subKline("simulator", "usdt", "API3USDT", "5m")
    cli.subKline("simulator", "usdt", "GMTUSDT", "5m")
    cli.subKline("simulator", "usdt", "APEUSDT", "5m")
    cli.subKline("simulator", "usdt", "BNXUSDT", "5m")
    cli.subKline("simulator", "usdt", "WOOUSDT", "5m")
    cli.subKline("simulator", "usdt", "FTTUSDT", "5m")
    cli.subKline("simulator", "usdt", "JASMYUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "DARUSDT", "5m")
    cli.subKline("simulator", "usdt", "GALUSDT", "5m")
    cli.subKline("simulator", "usdt", "OPUSDT", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "ETHBUSD", "5m")
    cli.subKline("simulator", "usdt", "BTCBUSD", "5m")
    cli.subKline("simulator", "usdt", "BNBBUSD", "5m")
    cli.subKline("simulator", "usdt", "ADABUSD", "5m")
    cli.subKline("simulator", "usdt", "XRPBUSD", "5m")
    cli.subKline("simulator", "usdt", "DOGEBUSD", "5m")
    cli.subKline("simulator", "usdt", "SOLBUSD", "5m")
    cli.subKline("simulator", "usdt", "FTTBUSD", "5m")
    cli.subKline("simulator", "usdt", "AVAXBUSD", "5m")
    cli.subKline("simulator", "usdt", "NEARBUSD", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "GMTBUSD", "5m")
    cli.subKline("simulator", "usdt", "APEBUSD", "5m")
    cli.subKline("simulator", "usdt", "GALBUSD", "5m")
    cli.subKline("simulator", "usdt", "FTMBUSD", "5m")
    cli.subKline("simulator", "usdt", "DODOBUSD", "5m")
    cli.subKline("simulator", "usdt", "ANCBUSD", "5m")
    cli.subKline("simulator", "usdt", "GALABUSD", "5m")
    cli.subKline("simulator", "usdt", "TRXBUSD", "5m")
    cli.subKline("simulator", "usdt", "1000LUNCBUSD", "5m")
    cli.subKline("simulator", "usdt", "LUNA2BUSD", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "DOTBUSD", "5m")
    cli.subKline("simulator", "usdt", "TLMBUSD", "5m")
    cli.subKline("simulator", "usdt", "ICPBUSD", "5m")
    cli.subKline("simulator", "usdt", "WAVESBUSD", "5m")
    cli.subKline("simulator", "usdt", "LINKBUSD", "5m")
    cli.subKline("simulator", "usdt", "SANDBUSD", "5m")
    cli.subKline("simulator", "usdt", "LTCBUSD", "5m")
    cli.subKline("simulator", "usdt", "MATICBUSD", "5m")
    cli.subKline("simulator", "usdt", "CVXBUSD", "5m")
    cli.subKline("simulator", "usdt", "FILBUSD", "5m")
    time.sleep(5)

    cli.subKline("simulator", "usdt", "1000SHIBBUSD", "5m")
    cli.subKline("simulator", "usdt", "LEVERBUSD", "5m")

    cli.subKline("simulator", "usdt", "BTCUSDT_220930", "5m")
    cli.subKline("simulator", "usdt", "ETHUSDT_220930", "5m")

    # cli.subTick("simulator", "usdt", "BTCUSDT")
    logger.info("start")

    input()

def main():
    test()

if __name__ == '__main__':
    main()
