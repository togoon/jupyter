from symtable import Symbol
import time
import os
from collections import defaultdict as ddict
import logging

import pandas as pd
import numpy as np

from FIL_lib.client import FILClient, Handler
from FIL_lib.core_types import KlineType, OrderType

from cal_factor import factor2, factor3, factor4, factor5, factor6, factor_ckeck


logger = logging.getLogger("factor_strategy")
logger.setLevel(logging.INFO)
logger.addHandler(logging.StreamHandler())


GATEWAY = "binance"
KEYID = 8081
SYMBOL = "BTCUSDT"
order_unit = 0.01

class FactorStrategy(Handler):
    def __init__(self, name) -> None:
        super().__init__()
        self.name = name
        self.factor_used = ddict(bool)
        self.cli = FILClient(self)
        self.orders = {}

    def init(self):
        if not os.path.exists(self.name):
            os.makedirs(self.name)
        res = self.cli.subOrderReport(GATEWAY, KEYID)
        if res.error:
            logger.error(f"subOrderReport failed: {res.error}")
        self.cli.start()
    
    def handleOrderNew(self, data):
        logger.info(f"OrderNew: {data}")
        if type(data) == type(OrderType()):
            self.orders[data.clientorderid] = data
            logger.info(f"self.orders: {self.orders}")
        else:
            logger.error("wrong order type")
        
    def handleOrderFilled(self, data):
        logger.info(f"handleOrderFilled: {data}")
        if type(data) == type(OrderType()):
            self.orders[data.clientorderid] = data
            logger.info(f"self.orders: {self.orders}")
        else:
            logger.error("wrong order type")

    def get_kline_data(self, interval="1d", limit=730, startTime=0, endTime=0):
        res = self.cli.uklines(GATEWAY, SYMBOL, interval, limit, startTime, endTime)
        df = pd.DataFrame(None, columns=["openTime","open","high","low","close","value"])
        for kline in res.result:
            if type(kline) != type(KlineType()):
                continue
            df = df.append({
                "openTime": kline.opentime,
                "open": kline.openprice,
                "high": kline.highprice,
                "low": kline.lowprice,
                "close": kline.closeprice,
                "value": kline.totalamount
            }, ignore_index=True)
        for col in df.columns:
            df[col] = pd.to_numeric(df[col])
        return df
    
    def run(self):
        # get history data
        all_data=self.get_kline_data()
        all_data.to_csv(os.path.join(self.name, "all_data.csv"),index=False)
        while True:
            # sleep to next day
            now = time.time()
            job_time = int(86400 + now // 86400 * 86400)
            sleep_time = job_time - now
            logger.info(f"now:{now} sleep_time:{sleep_time} job_time:{job_time}")
            '''
            try:
                time.sleep(sleep_time)
            except KeyboardInterrupt as _:
                print()
                return
            '''

            logger.info(f"start job at {time.time()}")

            # make result record dir
            dir_name = os.path.join(self.name, f"result_{job_time}")
            if not os.path.exists(dir_name):
                os.makedirs(dir_name)

            # add one more new kline to data
            one_data = self.get_kline_data(limit=1, endTime=job_time*1000-1)
            all_data = all_data.merge(one_data, how="outer")
            all_data.drop_duplicates(["openTime"], keep="last",inplace=True)
            all_data = all_data.reset_index(drop=True)

            # save input data
            all_data.to_csv(os.path.join(self.name, "all_data.csv"),index=False)

            data = all_data.iloc[len(all_data) - 730:len(all_data)]
            data = data.reset_index(drop=True)
            data.to_csv(os.path.join(dir_name, "data.csv"),index=False)

            # process data
            fields=np.array(data.columns)
            fields=fields[1:-1]
            stock_price=data.copy()
            data = stock_price[fields].values
            # target = stock_price['pct_next'].values
            stock_price = stock_price[["open","high","low","close","value"]]
            # return

            for factor in factor_ckeck:
                if self.factor_used[factor]:
                    logger.info(f"{factor} used")
                    continue
                df = eval(factor + "(stock_price)")
                df.dropna(how='any',inplace=True)
                df.to_csv(os.path.join(dir_name, f"d_{factor}.csv"),index=False)
                thd = df.loc[len(df)-1,"vol"]
                logger.info(f"{factor} thd:, {thd}")
                if eval(factor_ckeck[factor]):
                    logger.info(f"{factor}: buy")
                    res = self.cli.insertMarketUOrder(GATEWAY, KEYID, SYMBOL, order_unit, "buy")
                    if res.error:
                        logger.error(f"insertMarketUOrder failed: {res.error}")
                    else:
                        self.factor_used[factor] = True
                        logger.info(f"{factor}: buy success")
            
            time.sleep(60)

def main():
    stg = FactorStrategy("py_strategy_1")
    stg.init()
    stg.run()

if __name__ == '__main__':
    main()
