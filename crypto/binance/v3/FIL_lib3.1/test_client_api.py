import time
from FIL_lib.client import FILClient, Handler

GATEWAY = "simulator"

class MyFILHandler(Handler):
    def __init__(self):
        super().__init__("test")

    def handleTimer(self, data):
        print("handleTimer:", data)
        return super().handleTimer(data)
    
    def handleTick(self, data):
        print("handleTick:", data)
        return super().handleTick(data)
    
    def handleKline(self, data):
        print("handleKline:", data)
        return super().handleKline(data)

cli = FILClient(MyFILHandler(), server_url="http://127.0.0.1:8081/strategy", listen_port=9091)

def test_cli():
    cli.start()
    input()

def test_klines():
    res = cli.klines(GATEWAY, "BTCUSDT", "1d", 5)
    print(res)

def test_subTimer():
    cli.start()
    print(cli.subTimer(2000))
    print(cli.subTimer(3000))
    input()
    print(cli.cancelSubTimer(2000))
    print(cli.cancelSubTimer(3000))
    input()

def test_subTick():
    cli.start()
    print(cli.subTick(GATEWAY, "cash", "BTCUSDT"))
    input()
    print(cli.cancelSubTick(GATEWAY, "cash", "BTCUSDT"))
    input()

def test_subKline():
    cli.start()
    print(cli.subKline(GATEWAY, "usdt", "BTCUSDT", "15m"))
    input()
    print(cli.cancelSubKline(GATEWAY, "usdt", "BTCUSDT", "15m"))
    input()

def test_subOrderReport():
    cli.start()
    print(cli.subOrderReport(GATEWAY, 8081))
    res = cli.insertLimitUOrder(GATEWAY, 8081, "BTCUSDT", 0.01, 10000, "buy")
    print(res)
    res = cli.deleteUOrder(GATEWAY, 8081, "BTCUSDT", res.clientorderid)
    print(res)
    input()

def test_queryOrder():
    order_res = cli.insertLimitOrder(GATEWAY, 8080, "BTCUSDT", 0.01, 10000, "buy")
    print(order_res)
    res = cli.queryOrder(order_res.clientorderid)
    print(res)
    order_res = cli.deleteOrder(GATEWAY, 8080, "BTCUSDT", order_res.clientorderid)
    print(order_res)
    res = cli.queryOrder(order_res.clientorderid)
    print(res)

def test_queryUOrder():
    order_res = cli.insertLimitUOrder(GATEWAY, 8081, "BTCUSDT", 0.01, 10000, "buy")
    print(order_res)
    res = cli.queryUOrder(order_res.clientorderid)
    print(res)
    order_res = cli.deleteUOrder(GATEWAY, 8081, "BTCUSDT", order_res.clientorderid)
    print(order_res)
    res = cli.queryUOrder(order_res.clientorderid)
    print(res)

def test_insertMarketUOrder():
    cli.start()
    cli.subOrderReport(GATEWAY, 8081)
    print(cli.insertMarketUOrder(GATEWAY, 8081, "BTCUSDT", 0.01, "buy"))
    time.sleep(5)

def main():
    # test_cli()
    # test_klines()
    # test_subTimer()
    # test_subTick()
    # test_subKline()
    # test_subOrderReport()
    # test_queryOrder()
    # test_queryUOrder()
    # test_insertMarketUOrder()
    pass

if __name__ == '__main__':
    main()
