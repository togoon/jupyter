from .enum_types import *

class JsonDecoder(object):
    def __init__(self):
        self.error = ""
        self.message = ""

    def loads(self, d):
        if "error" in d:
            if "code" in d["error"]:
                self.error = d["error"]["code"]
            if "message" in d["error"]:
                self.message = d["error"]["message"]
        for k in self.__dict__:
            if k in d and type(self.__dict__[k]) == type(d[k]):
                self.__dict__[k] = d[k]
        return self

    def __str__(self):
        d = vars(self).copy()
        if not d["error"]:
            del d["error"]
        if not d["message"]:
            del d["message"]
        return self.__class__.__name__ + str(d)
 
    def __repr__(self):
        return self.__str__()

class SystemID(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.mainID = ""
        self.subID = ""
        self.strategyID = ""

class KlineType(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.gatewaytype = 0
        self.tradetype = 0
        self.symbol = ""
        self.interval = 0
        self.opentime = 0
        self.closetime = 0
        self.openprice = ""
        self.closeprice = ""
        self.highprice = ""
        self.lowprice = ""
        self.volume = ""
        self.number = 0
        self.totalamount = ""
        self.activevolume = ""
        self.activeamount = ""
        self.handletime = 0
        self.fixtype = "none"

    def loads(self, d):
        super().loads(d)
        if "fixtype" in d and len(KlineFixTypeEnum) > d["fixtype"] >= 0:
            self.fixtype = KlineFixTypeEnum[d["fixtype"]]
        return self

class TradeType(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.sysID = SystemID()
        self.symbol = ""                  # 交易对
        self.tradeid = 0                  # 交易id
        self.clientorderid = ""           # 系统订单ID
        self.price = "0"                  # 成交价格
        self.quantity = "0"               # 成交数量
        self.commission = "0"             # 手续费
        self.commissionasset = ""         # 手续费币种
        self.tradetime = 0                # 成交时间
        self.tradetype = "none"           # 交易类型
        self.gatetype = "none"
        self.handletime = 0
    
    def loads(self, d):
        super().loads(d)
        if "sysID" in d:
            self.sysID.loads(d["sysID"])
        if "tradetype" in d and len(TradeTypeEnum) > d["tradetype"] >= 0:
            self.tradetype = TradeTypeEnum[d["tradetype"]]
        if "gatetype" in d and len(GatewayTypeEnum) > d["gatetype"] >= 0:
            self.gatetype = GatewayTypeEnum[d["gatetype"]]
        return self

class OrderType(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.sysID = SystemID()
        self.clientorderid = ""          # 系统订单ID
        self.symbol = ""                 # 交易对
        self.gatewayorderid = 0          # 交易所订单ID
        self.quantity = "0"              # 数量
        self.price = "0"                 # 委托价
        self.stopprice = "0"             # 触发价
        self.ordertype = ""              # 订单类型
        self.side = ""                   # 订单方向
        self.status = ""                 # 状态
        self.positionside = ""           # 持仓方向

        self.createtime = 0              # 订单时间
        self.updatetime = 0              # 更新时间
        self.tradetype = "none"          # 交易类型
        self.selfid = 0                  # 订单ID
        self.filltrades = []             # 订单匹配的交易
        self.gatetype = "none"
        self.handletime = 0
    
    def loads(self, d):
        super().loads(d)
        if "sysID" in d:
            self.sysID.loads(d["sysID"])
        if "tradetype" in d and len(TradeTypeEnum) > d["tradetype"] >= 0:
            self.tradetype = TradeTypeEnum[d["tradetype"]]
        if "filltrades" in d:
            for i, trade in enumerate(d["filltrades"]):
                self.filltrades[i] = TradeType().loads(trade)
        if "gatetype" in d and len(GatewayTypeEnum) > d["gatetype"] >= 0:
            self.gatetype = GatewayTypeEnum[d["gatetype"]]
        return self

class TimeridType(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.timerid = 0
    
    def loads(self, d):
        self.timerid = d
        return self

class ErrorType(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.errnum = 0
        self.errmsg = ""
    
    def loads(self, d):
        super().loads(d)
        return self

class TickType(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.gatewaytype = "none"
        self.tradetype = "none"
        self.symbol = ""
        self.price = "0"
        self.Changes = "0"
        self.percent = "0"
        self.weight = "0"
        self.openpricce = "0"
        self.closeprice = "0"
        self.xprice = "0"
        self.closequantity = "0"
        self.highprice = "0"
        self.lowprice = "0"
        self.totalamount = "0"
        self.volume = "0"
        self.number = 0
        self.buymaxprice = "0"
        self.buymaxquantity = "0"
        self.sellminprice = "0"
        self.sellminquantity = "0"
        self.opentime = 0
        self.closetime = 0
        self.handletime = 0
    
    def loads(self, d):
        super().loads(d)
        if "gatewaytype" in d:
            self.gatewaytype = GatewayTypeEnum[d["gatewaytype"]]
        if "tradetype" in d and len(TradeTypeEnum) > d["tradetype"] >= 0:
            self.tradetype = TradeTypeEnum[d["tradetype"]]
        return self

class DepthType(JsonDecoder):
    class DepthOrder(JsonDecoder):
        def __init__(self):
            super().__init__()
            self.price = "0"
            self.amount = "0"

    def __init__(self):
        super().__init__()
        self.gatewaytype = "none"
        self.tradetype = "none"
        self.symbol = ""
        self.opentime = 0
        self.bids = []
        self.asks = []
    
    def loads(self, d):
        super().loads(d)
        if "bids" in d:
            for i, o in enumerate(d["bids"]):
                self.bids[i] = DepthType.DepthOrder().loads(o)
        if "asks" in d:
            for i, o in enumerate(d["asks"]):
                self.asks[i] = DepthType.DepthOrder().loads(o)
        return self

class SubTickType(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.tick = TickType()
        self.depth = DepthType()
    
    def loads(self, d):
        if "tick" in d:
            self.tick = TickType().loads(d["tick"])
        if "depth" in d:
            self.depth = DepthType().loads(d["depth"])
        return self

class PositionType(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.sysID = SystemID()
        self.symbol = ""           # 交易对
        self.positionAmount = "0"  # 仓位
        self.enterprice = "0"      # 入仓价格
        self.countrevence = "0"    # 累计实现损益
        self.unrealprofit = "0"    # 持仓未实现盈亏
        self.marginmodel = 0       # 保证金模式
        self.isolatedmargin = "0"  # 若为逐仓，仓位保证金
        self.positionside = 2      # 持仓方向
        self.markprice = "0"
        self.status = "none"
        self.closeprice = "0"
        self.closeamount = "0"
        self.opentime = 0
        self.closetime = 0
        self.type = "none"

    def loads(self, d):
        super().loads(d)
        if "sysID" in d:
            self.sysID.loads(d["sysID"])
        if self.positionside == -1:
            self.positionside = "short"
        elif self.positionside == 1:
            self.positionside = "long"
        if "status" in d:
            self.status = PositionStatusEnum[d["status"]]
        if "type" in d:
            self.type = AssetTypeEnum[d["type"]]
        return self

class StrategyInfo(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.sysID = SystemID()
        self.time = 0
        self.name = ""
        self.major_version = 0
        self.minor_version = 0
        self.state = "StrategyState_None"
        self.closetime = 0
    
    def loads(self, d):
        super().loads(d)
        if "sysID" in d:
            self.sysID.loads(d["sysID"])
        if "state" in d and len(StrategyStateEnum) > d["state"] >= 0:
            self.state = StrategyStateEnum[d["state"]]
        return self

class Factor(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.sysID = SystemID()
        self.factorID = 0
        self.time = 0
        self.body = ""
    
    def loads(self, d):
        super().loads(d)
        if "sysID" in d:
            self.sysID.loads(d["sysID"])
        return self

class Worth(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.sysID = SystemID() # 系统id
        self.cashworth = ""
        self.usdtcontractworth = ""
        self.tokencontractworth = ""
        self.time = 0
        self.keyid = 0
    
    def loads(self, d):
        super().loads(d)
        if "sysID" in d:
            self.sysID.loads(d["sysID"])
        return self

class Balance(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.sysID = SystemID() # 系统id
        self.asset = "" # 资产名
        self.free = "" # 可支配数额
        self.locked = "" # 已锁定数额
        self.type = "none"
    
    def loads(self, d):
        super().loads(d)
        if "sysID" in d:
            self.sysID.loads(d["sysID"])
        if "type" in d:
            self.type = AssetTypeEnum[d["type"]]
        return self

class ContractAsset(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.sysID = SystemID() # 系统id
        self.asset = "" # 资产名
        self.free = "" # 可支配数额
        self.total = "" # 钱包余额  total = free + margin + unreal
        self.margin = "" # 保证金
        self.unreal = "" # 未实现盈亏
        self.lock = ""
        self.syslock = ""
        self.longfree = ""
        self.shortfree = ""
        self.type = "none"

    def loads(self, d):
        super().loads(d)
        if "sysID" in d:
            self.sysID.loads(d["sysID"])
        if "type" in d:
            self.type = AssetTypeEnum[d["type"]]
        return self

class StrategyEvaluate(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.sid = SystemID()
        self.time = 0

        self.annualizedReturn = "" # 年化收益率
        self.totalProfit = "" # 总盈亏
        self.totalFee = "" # 手续费
        self.netProfits = "" # 净利润
        self.maxProfits = "" # 账户最高收益
        self.totalAverageProfit = "" # 总交易平均利润
        self.averageProfit = "" # 盈利平均值
        self.averageLoss = "" # 亏损平均值
            #    平均盈利
            #    平均亏损
        self.oneMaxProfit = "" # 最大盈利
        self.oneMaxLoss = "" # 最大亏损
        self.absoluteReturnRate = "" # 绝对收益率

        self.profitCount = 0 # 盈利笔数
        self.lossCount = 0 # 亏损笔数
        self.totalProfitAmount = "" # 总盈利交易金额
        self.totalLossAmount = "" # 总亏损交易金额
        self.winRate = "" # 交易胜率
        self.maxContinuousWinNum = 0 # 最大连续盈利笔数
        self.totalTradeTime = 0 # 总交易时间
        self.totalOpenNum = 0 # 各合约的开仓交易笔数
        self.totalTradeNum = 0 # 各合约的交
        self.totalCloseNum = 0 # 各合约的平仓交易笔数
        
        self.maxDrawdown = "" # 最大回撤
        self.startDrawdownTime = 0 # 最大回撤的开始时间
        self.endDrawdownTime = 0 # 最大回撤的结束时间
            #    净利润/最大回撤值
        self.duringDrwadownTime = 0 # 最大回撤持续时间

    def loads(self, d):
        super().loads(d)
        if "sid" in d:
            self.sid.loads(d["sid"])
        return self

class SharpeRatio(JsonDecoder):
    def __init__(self):
        super().__init__()
        self.sid = SystemID()
        self.value = ""
        self.time = 0

    def loads(self, d):
        super().loads(d)
        if "sid" in d:
            self.sid.loads(d["sid"])
        return self
