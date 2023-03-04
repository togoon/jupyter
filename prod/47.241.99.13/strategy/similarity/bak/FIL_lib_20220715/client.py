import traceback
import requests
import json
import logging
from flask import Flask, request
from threading import Thread, Event, Lock
from collections import deque

from .return_types import *
from .my_logger import make_logger

logger = make_logger("client", logging.DEBUG)

class Handler(object):
    def __init__(self, name):
        self.client = None
        self.name = name

    def handleOrderNew(self, data:OrderType):
        logger.debug(f"OrderNew: {data}")

    def handleOrderFilled(self, data:OrderType):
        logger.debug(f"OrderFilled: {data}")

    def handleOrderCanceled(self, data:OrderType):
        logger.debug(f"OrderCanceled: {data}")

    def handleOrderRejected(self, data:OrderType):
        logger.debug(f"OrderRejected: {data}")

    def handleOrderCancelRejected(self, data:OrderType):
        logger.debug(f"OrderCancelRejected: {data}")

    def handleOrderExpired(self, data:OrderType):
        logger.debug(f"OrderExpired: {data}")

    def handleTimer(self, data:TimeridType):
        logger.debug(f"Timer: {data}")

    def handleTick(self, data:SubTickType):
        logger.debug(f"Tick: {data}")

    def handleKline(self, data:KlineType):
        logger.debug(f"Kline: {data}")

    def handleError(self, data:ErrorType):
        logger.debug(f"Error: {data}")

HandleType = {
    "OrderNew": OrderType,
	"OrderFilled": OrderType,
	"OrderCanceled": OrderType,
	"OrderRejected": OrderType,
	"OrderCancelRejected": OrderType,
	"OrderExpired": OrderType,
	"Timer": TimeridType,
	"Tick": SubTickType,
	"Kline": KlineType,
    "Error": ErrorType
}

class FILClient(object):
    def __init__(self, handler:Handler, server_url:str="http://127.0.0.1:8888/strategy", timeout:int=(3,30), listen_host="127.0.0.1", listen_port:int=9090):
        self.handler = handler
        self.handler.client = self
        self.name = self.handler.name
        self.server_url = server_url
        self.timeout = timeout
        self.listen_host = listen_host
        self.listen_port = listen_port

        self._msg_queue = deque()
        self._msg_queue_lk = Lock()
        self._msg_queue_evt = Event()
    
    def start(self):
        t = Thread(target=self.__start_handle)
        t.setDaemon(True)
        t.start()
        t = Thread(target=self.__start_listen, args=(self.listen_host, self.listen_port,))
        t.setDaemon(True)
        t.start()
    
    def __start_handle(self):
        while True:
            self._msg_queue_evt.wait()
            self._msg_queue_lk.acquire()
            while self._msg_queue:
                msg = self._msg_queue.popleft()
                try:
                    method = "handle" + msg["method"]
                    handle_call = getattr(self.handler, method)
                    handle_type = HandleType[msg["method"]]
                    handle_data = handle_type().loads(msg["message"])
                    handle_call(handle_data)
                except Exception as e:
                    traceback.print_exc()
            self._msg_queue_evt.clear()
            self._msg_queue_lk.release()
    
    def __start_listen(self, host:str, port:int):
        app = Flask(__name__)

        @app.route("/", methods = ['POST'])
        def handle():
            try:
                msg = json.loads(request.get_data())
                # logger.info(f'msg:{msg}')
            except Exception as e:
                traceback.print_exc()
                return "error"
            self._msg_queue_lk.acquire()
            self._msg_queue.append(msg)
            self._msg_queue_evt.set()
            self._msg_queue_lk.release()
            return "ok"

        app.run(host, port)
    
    def __post(self, data:dict, obj_type=CommonReturn):
        try:
            res = requests.post(self.server_url, json=data, timeout=self.timeout)
            # logger.info(f'res.text:{res.text}')
            if res.status_code != 200:
                logger.error(f"http status errod: res.status_code:{res.status_code}, res.headers:{res.headers}, res.text:{res.text}")
                return obj_type()
            return obj_type().loads(json.loads(res.text))
        except requests.exceptions.ConnectionError as e:
            logger.error("connect error")
            return obj_type()
    
    def subTick(self, gateway_type:str, tade_type:str, symbol:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return CommonReturn()
        tade_enum = TradeTypeEnum.index(tade_type)
        if tade_enum == -1:
            logger.error("wrong tade type")
            return CommonReturn()
        data = {
            "method": "subTick",
            "params": [self.name, gateway_enum, tade_enum, symbol]
        }
        return self.__post(data, CommonReturn)

    def subOrderReport(self, gateway_type:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return CommonReturn()
        data = {
            "method": "subOrderReport",
            "params": [self.name, gateway_enum]
        }
        return self.__post(data, CommonReturn)

    def subKline(self, gateway_type:str, tade_type:str, symbol:str, kline_interval:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return CommonReturn()
        tade_enum = TradeTypeEnum.index(tade_type)
        if tade_enum == -1:
            logger.error("wrong tade type")
            return CommonReturn()
        kline_enum = KlineIntervalEnum.index(kline_interval)
        if kline_enum == -1:
            logger.error("wrong kline interval")
            return CommonReturn()
        data = {
            "method": "subKline",
            "params": [self.name, gateway_enum, tade_enum, symbol, kline_enum]
        }
        return self.__post(data, CommonReturn)

    def subTimer(self, microsecond:int):
        data = {
            "method": "subTimer",
            "params": [self.name, microsecond]
        }
        return self.__post(data, CommonReturn)

    def cancelSubTick(self, gateway_type:str, tade_type:str, symbol:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return CommonReturn()
        tade_enum = TradeTypeEnum.index(tade_type)
        if tade_enum == -1:
            logger.error("wrong tade type")
            return CommonReturn()
        data = {
            "method": "cancelSubTick",
            "params": [self.name, gateway_enum, tade_enum, symbol]
        }
        return self.__post(data, CommonReturn)

    def cancelSubOrderReport(self, gateway_type:str, key_id:int):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return CommonReturn()
        data = {
            "method": "cancelSubOrderReport",
            "params": [self.name, gateway_enum]
        }
        return self.__post(data, CommonReturn)

    def cancelSubKline(self, gateway_type:str, tade_type:str, symbol:str, kline_interval:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return CommonReturn()
        tade_enum = TradeTypeEnum.index(tade_type)
        if tade_enum == -1:
            logger.error("wrong tade type")
            return CommonReturn()
        kline_enum = KlineIntervalEnum.index(kline_interval)
        if kline_enum == -1:
            logger.error("wrong kline interval")
            return CommonReturn()
        data = {
            "method": "cancelSubKline",
            "params": [self.name, gateway_enum, tade_enum, symbol, kline_enum]
        }
        return self.__post(data, CommonReturn)

    def cancelSubTimer(self, microsecond:int):
        data = {
            "method": "cancelSubTimer",
            "params": [self.name, microsecond]
        }
        return self.__post(data, CommonReturn)

    def cancelAllSubTicks(self):
        data = {
            "method": "cancelAllSubTicks",
            "params": [self.name]
        }
        return self.__post(data, CommonReturn)

    def cancelAllSubKlines(self):
        data = {
            "method": "cancelAllSubKlines",
            "params": [self.name]
        }
        return self.__post(data, CommonReturn)

    def klines(self, gateway_type:str, symbol:str, interval:str, limit:int = 1000, start:int = 0, end:int = 0):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return KlinesReturn()
        interval_enum = KlineIntervalEnum.index(interval)
        if interval_enum == -1:
            logger.error("wrong gateway type")
            return KlinesReturn()
        data = {
            "method": "klines",
            "params": [gateway_enum, symbol, interval_enum, limit, start, end]
        }
        return self.__post(data, KlinesReturn)

    def uklines(self, gateway_type:str, symbol:str, interval:str, limit:int = 1000, start:int = 0, end:int = 0):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return KlinesReturn()
        interval_enum = KlineIntervalEnum.index(interval)
        if interval_enum == -1:
            logger.error("wrong gateway type")
            return KlinesReturn()
        data = {
            "method": "uklines",
            "params": [gateway_enum, symbol, interval_enum, limit, start, end]
        }
        return self.__post(data, KlinesReturn)

    def tklines(self, gateway_type:str, symbol:str, interval:str, limit:int = 1000, start:int = 0, end:int = 0):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return KlinesReturn()
        interval_enum = KlineIntervalEnum.index(interval)
        if interval_enum == -1:
            logger.error("wrong gateway type")
            return KlinesReturn()
        data = {
            "method": "tklines",
            "params": [gateway_enum, symbol, interval_enum, limit, start, end]
        }
        return self.__post(data, KlinesReturn)
    
    def queryPrice(self, symbol:str):
        data = {
            "method": "queryPrice",
            "params": [symbol]
        }
        return self.__post(data, CommonReturn)

    def queryUPrice(self, symbol:str):
        data = {
            "method": "queryUPrice",
            "params": [symbol]
        }
        return self.__post(data, CommonReturn)

    def queryTPrice(self, symbol:str):
        data = {
            "method": "queryTPrice",
            "params": [symbol]
        }
        return self.__post(data, CommonReturn)

    def queryPositions(self, symbol:str, side:str="none"):
        side_enum = PositionSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side type")
            return PositionsReturn()
        data = {
            "method": "queryPositions",
            "params": [self.name, symbol, side_enum]
        }
        return self.__post(data, PositionsReturn)

    def queryContractAssets(self, asset:str):
        data = {
            "method": "queryContractAssets",
            "params": [self.name, asset]
        }
        return self.__post(data, ContractAssetReturn)

    def queryBalances(self, asset:str):
        data = {
            "method": "queryBalances",
            "params": [self.name, asset]
        }
        return self.__post(data, BalanceReturn)

    def queryMarketOrder(self, starttime:int, page:int=0, limit:int=50):
        data = {
            "method": "queryMarketOrder",
            "params": [self.name, starttime, page, limit]
        }
        return self.__post(data, QueryOrderReturn)

    def queryLimitOrder(self, starttime:int, page:int=0, limit:int=50):
        data = {
            "method": "queryLimitOrder",
            "params": [self.name, starttime, page, limit]
        }
        return self.__post(data, QueryOrderReturn)

    def insertLimitOrder(self, gateway_type:str, symbol:str, quantity:float, price:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["price"] = str(price)
        order["side"] = side.upper()
        data = {
            "method": "insertLimitOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertMarketOrder(self, gateway_type:str, symbol:str, quantity:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["side"] = side.upper()
        data = {
            "method": "insertMarketOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertLimitMakerOrder(self, gateway_type:str, symbol:str, quantity:float, price:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["price"] = str(price)
        order["side"] = side.upper()
        data = {
            "method": "insertLimitMakerOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertLossMarketOrder(self, gateway_type:str, symbol:str, quantity:float, stopPrice:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["stopPrice"] = str(stopPrice)
        order["side"] = side.upper()
        data = {
            "method": "insertLossMarketOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertLossLimitOrder(self, gateway_type:str, symbol:str, quantity:float, price:float, stopPrice:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["price"] = str(price)
        order["stopPrice"] = str(stopPrice)
        order["side"] = side.upper()
        data = {
            "method": "insertLossLimitOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertProfitMarketOrder(self, gateway_type:str, symbol:str, quantity:float, stopPrice:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["stopPrice"] = str(stopPrice)
        order["side"] = side.upper()
        data = {
            "method": "insertProfitMarketOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertProfitLimitOrder(self, gateway_type:str, key_id:int, symbol:str, quantity:float, price:float, stopPrice:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["price"] = str(price)
        order["stopPrice"] = str(stopPrice)
        order["side"] = side.upper()
        data = {
            "method": "insertProfitLimitOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def deleteOrder(self, gateway_type:str, symbol:str, clientorderid:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return CommonReturn()
        # order = dict()
        # order["symbol"] = symbol
        # order["clientorderid"] = clientorderid
        data = {
            "method": "deleteOrder",
            "params": [self.name, gateway_enum, symbol, clientorderid]
        }
        return self.__post(data, CommonReturn)

    def insertLimitUOrder(self, gateway_type:str, symbol:str, quantity:float, price:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["price"] = str(price)
        order["side"] = side.upper()
        data = {
            "method": "insertLimitUOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertMarketUOrder(self, gateway_type:str, symbol:str, quantity:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["side"] = side.upper()
        data = {
            "method": "insertMarketUOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertLimitMakerUOrder(self, gateway_type:str, symbol:str, quantity:float, price:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["price"] = str(price)
        order["side"] = side.upper()
        data = {
            "method": "insertLimitMakerUOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertLossMarketUOrder(self, gateway_type:str, symbol:str, quantity:float, stopPrice:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["stopPrice"] = str(stopPrice)
        order["side"] = side.upper()
        data = {
            "method": "insertLossMarketUOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertLossLimitUOrder(self, gateway_type:str, symbol:str, quantity:float, price:float, stopPrice:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["price"] = str(price)
        order["stopPrice"] = str(stopPrice)
        order["side"] = side.upper()
        data = {
            "method": "insertLossLimitUOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertProfitMarketUOrder(self, gateway_type:str, symbol:str, quantity:float, stopPrice:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["stopPrice"] = str(stopPrice)
        order["side"] = side.upper()
        data = {
            "method": "insertProfitMarketUOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def insertProfitLimitUOrder(self, gateway_type:str, key_id:int, symbol:str, quantity:float, price:float, stopPrice:float, side:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return InsertOrderReturn()
        side_enum = OrderSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side")
            return InsertOrderReturn()
        order = dict()
        order["symbol"] = symbol
        order["quantity"] = str(quantity)
        order["price"] = str(price)
        order["stopPrice"] = str(stopPrice)
        order["side"] = side.upper()
        data = {
            "method": "insertProfitLimitUOrder",
            "params": [self.name, gateway_enum, order]
        }
        return self.__post(data, InsertOrderReturn)

    def deleteUOrder(self, gateway_type:str, symbol:str, clientorderid:str):
        gateway_enum = GatewayTypeEnum.index(gateway_type)
        if gateway_enum == -1:
            logger.error("wrong gateway type")
            return CommonReturn()
        # order = dict()
        # order["symbol"] = symbol
        # order["clientorderid"] = clientorderid
        data = {
            "method": "deleteUOrder",
            "params": [self.name, gateway_enum, symbol, clientorderid]
        }
        return self.__post(data, CommonReturn)

    def deleteAllOrder(self):
        data = {
            "method": "deleteAllOrder",
            "params": [self.name]
        }
        return self.__post(data, CommonReturn)

    def closePosition(self, symbol:str, side:str="none"):
        side_enum = PositionSideEnum.index(side)
        if side_enum == -1:
            logger.error("wrong side type")
            return PositionsReturn()
        data = {
            "method": "closePosition",
            "params": [self.name, side_enum, symbol]
        }
        return self.__post(data, CommonReturn)

    def closeAllPosition(self):
        data = {
            "method": "closeAllPosition",
            "params": [self.name]
        }
        return self.__post(data, CommonReturn)

    def hello(self, mainname:str, subname:str, push_host:str="127.0.0.1", push_port:int=9090):
        data = {
            "method": "hello",
            "params": [self.name, mainname, subname, push_host, push_port]
        }
        return self.__post(data, CommonReturn)

    def close(self):
        data = {
            "method": "close",
            "params": [self.name]
        }
        return self.__post(data, CommonReturn)

    def queryStrategyInfo(self, ):
        data = {
            "method": "queryStrategyInfo",
            "params": [self.name]
        }
        return self.__post(data, StrategyInfoReturn)

    def insertFactor(self, factorid:int, body:str):
        data = {
            "method": "insertFactor",
            "params": [self.name, factorid, body]
        }
        return self.__post(data, CommonReturn)

    def queryFactor(self, factorid:int, starttime:int, page:int=0, limit:int=50):
        data = {
            "method": "queryFactor",
            "params": [self.name, factorid, starttime, page, limit]
        }
        return self.__post(data, FactorReturn)

    def insertStrategyRunSnap(self, body:str):
        data = {
            "method": "insertStrategyRunSnap",
            "params": [self.name, body]
        }
        return self.__post(data, CommonReturn)
