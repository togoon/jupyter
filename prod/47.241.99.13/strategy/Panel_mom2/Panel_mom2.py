import time
import getopt
import sys

from FIL_lib.my_logger import make_logger, logging
from FIL_lib.client import FILClient, Handler
from FIL_lib.core_types import *
import pandas as pd
import os

GATEWAY = "simulator"


logger = make_logger("my", log_level=logging.DEBUG, log_file="my_log.txt")


class StrategyHandler(Handler):
    def __init__(self, name, quote, kline_interval, window, k_number, open_number, id_list):
        # K线级别
        # kline_interval = '12h'
        # 滚动窗口数，资产分包数，平仓周期
        # window = 20
        # 计算多少根K线
        # k_number = 30
        # 开仓标的数量(单边数量）
        # open_number = 15
        # 待选标的列表
        # id_list = []
        self.name = name
        self.quote = quote
        self.kline_interval = kline_interval
        self.window = window
        self.k_number = k_number
        self.open_number = open_number
        self.count_of_symbols = len(id_list)
        # 已开仓列表，最多20组，平仓后从列表中清除
        # 列表中元素为如下的列表
        # side = ["BUY", "SELL"]
        # symbol        qyt     price side
        # "BTCUSDT"     1       1      "BUY"
        self.open_list = []
        # k_number根k线的列表，k_number行
        self.k_line_close = pd.DataFrame()
        self.id_list = id_list
        # time "BTCUSDT"  ....."ETHUSDT"
        # 2022-05-01 00:00:00 39000 ..... 2000
        # 2022-05-01 12:00:00 40000 ..... 2100

        # k线临时字典，所有合约的某刻的k线完整获取时清空字典，入k_line_close列表
        self.k_line_temp = {}
        # window个窗口滚动下，每次多空各open_number笔不同合约
        self.per_quote = self.quote / self.window / (self.open_number * 2)

    def handleKline(self, data:KlineType):
        logger.debug(f"handleKline: data={data}")
        self.k_line_temp[data.symbol] = float(data.closeprice)
        logger.debug(len(self.k_line_temp))
        if len(self.k_line_temp) == self.count_of_symbols:
            balance = 0
            if len(self.open_list) >= self.window:
                # 平仓
                df_holder = self.open_list.pop(0)
                # 平仓以后的下单金额，按照平仓后剩余资金进行处理，此处近视按照委托价计算
                for symbol in df_holder.index:
                    qyt = float(df_holder.loc[symbol]['qyt'])
                    side = int(df_holder.loc[symbol]['side'])
                    cost_price = float(df_holder.loc[symbol]['price'])
                    closeprice = float(self.k_line_close.loc[self.k_line_close.index[-1]][symbol])
                    # 计算成交后余额

                    #
                    if side == OrderSideEnum[1]:
                        # 先买后卖
                        this_balance = closeprice * qyt
                        self.client.insertMarketUOrder(GATEWAY, 0, symbol, abs(qyt), "sell")
                    elif side == OrderSideEnum[0]:
                        # 先卖后买
                        this_balance = (cost_price - closeprice) * qyt + cost_price * qyt
                        self.client.insertMarketUOrder(GATEWAY, 0, symbol, abs(qyt), "buy")
                    balance += this_balance
                self.per_quote = balance / (self.open_number * 2)
            # 删除第一行k线数据
            self.k_line_close.drop(self.k_line_close.index[0], inplace=True)
            # k_line_temp 里面的顺序根据k线来的先后顺序不同而不同，因此需要按照id_list的顺序进行排序以便对齐
            # 增加一行新k线数据
            self.k_line_close.loc[data.opentime] = [self.k_line_temp[symbol] for symbol in self.id_list]
            index = self.k_line_close.index
            chg = self.k_line_close.loc[index[-1]] / self.k_line_close.loc[index[0]]
            # 默认由小到大排列
            chg = chg.sort_values()
            # 最近一次的所有symbol收盘价
            last_close_series = self.k_line_close.loc[index[-1]]
            # 小的为跌，开空头
            print(chg)
            for i in range(0, self.open_number):
                # 开空
                symbol = chg.index[i]
                logger.debug(f"start sell order:{symbol}")
                self.client.insertMarketUOrder(GATEWAY, 0, symbol,
                                               self.per_quote / float(last_close_series[symbol]), "sell")
            #  大的为涨，开多头
            for i in range(- self.open_number, 0):
                symbol = chg.index[i]
                # 开多
                logger.debug(f"start buy order:{symbol}")
                self.client.insertMarketUOrder(GATEWAY, 0, symbol,
                                               self.per_quote / float(last_close_series[symbol]), "buy")
            self.k_line_temp.clear()

    def handleOrderNew(self, data: OrderType):
        logger.info(f"new: {data}")
    
    def handleOrderFilled(self, data: OrderType):
        logger.info(f"filled: {data}")
        # 市价成交，filltrades理应只有一条记录，做简化处理
        lines = pd.DataFrame(data=[[data.quantity, data.filltrades[0].price, data.side]],
                             columns=['qyt', 'price', 'side'], index=[data.symbol])
        # 当窗口没有满，且本轮预成交全部处理完成才说明开启新一轮下单
        if (len(self.open_list) == 0) or \
                (len(self.open_list) < self.window and (len(self.open_list[-1]) == self.open_number * 2)):
            self.open_list.append(lines)
        else:
            self.open_list[-1] = pd.concat([self.open_list[-1], lines])
        print(self.open_list)

    def handleOrderRejected(self, data: OrderType):
        logger.error(f"order rejected: {data}")


# 将k线数据转换为需要的数据格式
# data为KlinesReturn 类型
def cast_kline(data):
    print(data)
    # fmt = '%Y-%m-%d %H:%M:%S'
    df = pd.DataFrame([{'open_time': rs.opentime, 'close_price': float(rs.closeprice)} for rs in data.result])
    return df


def run(argv):
    logger.info("Panel_mon2.0.0.0......")
    input_pro = '-Q <quote> -N <name> -i <interval> -w <window> -n ' \
                '<k_number> -o <open_number> -f <file_name> -p <server_port> -c <client_port>'
    try:
        # 优先级i>d>args
        opts, args = getopt.getopt(argv, "Q:N:i:w:n:o:f:p:c:",
                                   ["quote","name", "interval", "window", "k_number", "open_number", "file_name",
                                    'server_port', 'client_port'])
    except getopt.GetoptError:
        print(input_pro)
        sys.exit(2)
    #  python3 Panel_mom.py -Q 100000 -N Panel_mon2 -i 12h -n 30 -w 20 -o 15 -f symbols_ba.csv -p 8382 -c 9392
    for opt, arg in opts:
        if opt in ("-Q", '--quote'):
            QUOTE = float(arg)
        if opt in ("-N", '--name'):
            NAME = arg
        elif opt in ("-i", '--interval'):
            interval = arg
        elif opt in ("-n", '--k_number'):
            k_line_number = int(arg)
        elif opt in ("-w", '--window'):
            k_window = int(arg)
        elif opt in ("-o", '--open_number'):
            holder_number = int(arg)
        elif opt in ("-p", '--server_port'):
            server_port = int(arg)
        elif opt in ("-c", '--client_port'):
            client_port = int(arg)
        elif opt in ("-f", '--file_name'):
            path_name = arg
    id_list = list(pd.read_csv(path_name)['symbol'])

    # def __init__(self, name, quote, kline_interval, window, k_number, open_number, id_list):
    cli = FILClient(StrategyHandler(NAME, QUOTE, interval, k_window, k_line_number, holder_number, id_list),
                    timeout=(3, 5),
                    server_url="http://127.0.0.1:%d/strategy" % server_port,
                    listen_host="127.0.0.1", listen_port=client_port)
    #
    logger.info("query his......")
    for symbol in id_list:
        logger.info("query his symbol=%s" % symbol)
        result = cast_kline(cli.uklines('binance', symbol=symbol, interval=interval, limit=k_line_number+1))
        print(result)
        cli.handler.k_line_close[symbol] = result[:k_line_number]['close_price']
        time.sleep(0.4)
    print(cli.handler.k_line_close)
    logger.info("query his finished")
    cli.start()
    cli.subOrderReport(GATEWAY, 0)
    for symbol in id_list:
        logger.debug('sub symbol=%s' % symbol)
        result = cli.subKline(GATEWAY, "usdt", symbol, interval)
        logger.debug(result)
    logger.info("start")
    while True:
        time.sleep(60*60)


def main(argv):
    run(argv)


if __name__ == '__main__':
    main(sys.argv[1:])
