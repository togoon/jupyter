from .core_types import *

class CommonReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = ""

class InsertOrderReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = ""
        self.clientorderid = ""

class KlinesReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []

    def loads(self, d):
        if "result" in d:
            for kline in d["result"]:
                self.result.append(KlineType().loads(kline))
        return self

class QueryTradeReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []
    
    def loads(self, d):
        if "result" in d:
            for item in d["result"]:
                self.result.append(TradeType().loads(item))
        return self

class QueryOrderReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []
    
    def loads(self, d):
        if "result" in d:
            for item in d["result"]:
                self.result.append(OrderType().loads(item))
        return self

class PositionsReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []

    def loads(self, d):
        if "result" in d and type(d["result"]) == type(list()):
            for item in d["result"]:
                self.result.append(PositionType().loads(item))
        return self

class StrategyInfoReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []

    def loads(self, d):
        if "result" in d and type(d["result"]) == type(list()):
            for item in d["result"]:
                self.result.append(StrategyInfo().loads(item))
        return self

class FactorReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []

    def loads(self, d):
        if "result" in d:
            for item in d["result"]:
                self.result.append(Factor().loads(item))
        return self

class WorthReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []

    def loads(self, d):
        if "result" in d:
            for item in d["result"]:
                self.result.append(Worth().loads(item))
        return self

class BalanceReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []

    def loads(self, d):
        if "result" in d:
            for item in d["result"]:
                self.result.append(Balance().loads(item))
        return self

class ContractAssetReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []

    def loads(self, d):
        if "result" in d:
            for item in d["result"]:
                self.result.append(ContractAsset().loads(item))
        return self

class StrategyEvaluateReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []

    def loads(self, d):
        if "result" in d:
            for item in d["result"]:
                self.result.append(StrategyEvaluate().loads(item))
        return self

class SharpeRatioReturn(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.result = []

    def loads(self, d):
        if "result" in d:
            for item in d["result"]:
                self.result.append(SharpeRatio().loads(item))
        return self