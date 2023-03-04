GatewayTypeEnum = [
    "binance",
    "bitmex",
    "okex",
    "simulator_binance",
    "simulator_bitmex",
    "histest",
    "none"
]

OrderSideEnum = [
    "sell",
    "buy",
    "none"
]

PositionSideEnum = [
    "long",
    "short",
    "none"
]

PositionStatusEnum = [
    "open",
    "close",
    "none"
]

TradeTypeEnum = [
    "cash",
    "usdt",
    "token",
    "quanto",
    "none"
]

MarginTypeEnum = [
    "isolated",
    "crossed",
    "none"
]

KlineIntervalEnum = [
    "1m", # 1分钟
    "3m", # 3分钟
    "5m", # 5分钟
    "15m", # 15分钟
    "30m", # 30分钟
    "1h", # 1小时
    "2h", # 2小时
    "4h", # 4小时
    "6h", # 6小时
    "8h", # 8小时
    "12h", # 12小时
    "1d", # 1天
    "3d", # 3天
    "1w", # 1周
    "1M", # 1月
    "10m", # 10分钟
    "none"
]

KlineFixTypeEnum = [
    "KlineFixType_normal",
    "KlineFixType_remedy",

    "none"
]

DepthLimitEnum = [
    5, 10, 20, 50, 100, 500, 1000
]

StrategyStateEnum = [
    "StrategyState_ON",
    "StrategyState_OFF",

    "none"
]

AccountTransferType = [
    "AccountTransfer_cash2usdt",
    "AccountTransfer_usdt2cash",
    "AccountTransfer_cash2token",
    "AccountTransfer_token2cash",

    "AccountTransfer_cash2quanto",
    "AccountTransfer_quanto2cash",

    "AccountTransfer_mcash2scash",
    "AccountTransfer_scash2mcash",
    "AccountTransfer_musdt2susdt",
    "AccountTransfer_susdt2musdt",
    "AccountTransfer_mtoken2stoken",
    "AccountTransfer_stoken2mtoken",
    "AccountTransfer_mquanto2squanto",
    "AccountTransfer_squanto2mquanto",

    "AccountTransfer_scash2pcash",
    "AccountTransfer_pcash2scash",
    "AccountTransfer_susdt2pusdt",
    "AccountTransfer_pusdt2susdt",
    "AccountTransfer_stoken2ptoken",
    "AccountTransfer_ptoken2stoken",
    "AccountTransfer_squanto2pquanto",
    "AccountTransfer_pquanto2squanto",

    "none"
]

AssetTypeEnum = [
    "AssetType_cash",
    "AssetType_ucontract",
    "AssetType_tcontract",
    "AssetType_quanto",
    "AssetType_leverage",
    "AssetType_options",
    "AssetType_uni",
    "none"
]

