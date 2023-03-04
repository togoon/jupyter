import numpy as np
import pandas as pd
from gplearn.functions import make_function
from scipy.stats import rankdata
import warnings

warnings.filterwarnings("ignore")
pd.set_option('mode.use_inf_as_na', True)

def _rolling_rank(data):
    value = rankdata(data)[-1]

    return value

def _ts_rank(data):
    window = 10
    value = np.array(pd.Series(data.flatten()).rolling(10).apply(_rolling_rank).tolist())
    value = np.nan_to_num(value)

    return value


def _delta(data):
    value = np.diff(data.flatten())
    value = np.append(0, value)

    return value

def _delay_2(data):
    period = 1
    value = pd.Series(data.flatten()).shift(5)
    value = np.nan_to_num(value)

    return value

def _delay(data):
    period = 1
    value = pd.Series(data.flatten()).shift(1)
    value = np.nan_to_num(value)

    return value






def _ts_argmin(data):
    value = pd.Series(data.flatten()).rolling(10).apply(np.argmin) + 1
    value = np.nan_to_num(value)

    return value

def _ts_zscore(x1):
    value = (pd.Series(x1.flatten())-pd.Series(x1.flatten()).rolling(10).mean())/pd.Series(x1.flatten()).rolling(10).std()
    value = np.nan_to_num(value)
    return value

def _ts_min_diff(x1):
    value = pd.Series(x1.flatten())/pd.Series(x1.flatten()).rolling(10).min()-1
    value = np.nan_to_num(value)
    return value


# make_function函数群
delta = make_function(function=_delta, name='delta', arity=1)
ts_rank = make_function(function=_ts_rank, name='ts_rank', arity=1)
ts_argmin = make_function(function=_ts_argmin, name='ts_argmin', arity=1)
ts_zscore= make_function(function=_ts_zscore, name='ts_zscore', arity=1)
ts_min_diff= make_function(function=_ts_min_diff, name='ts_min_diff', arity=1)



# def factor1(df):
#     df['vol'] = ts_rank(delta(np.array(df['close'].tolist())))
#     return df

def factor2(df):
    # thd<4
    df['v1'] = df['close']-ts_argmin(np.array(df['value'].tolist()))
    df['vol'] = ts_rank(delta(np.array(df['v1'].tolist())))

    return df
def factor3(df):
    # thd<0
    df['v1'] = df['close']+ts_min_diff(np.array(df['low'].tolist()))
    df['vol'] = delta(ts_zscore(np.array(df['v1'].tolist())))

    return df

def factor4(df):
    # thd<0
    df['vol'] = delta(ts_min_diff(np.array(df['close'].tolist())))
    return df
def factor5(df):
    # thd <0
    df['vol'] = delta(ts_zscore(np.array(df['low'].tolist())))
    return df

def factor6(df):
    # thd <4
    df['v1'] = ts_zscore(delta(np.array(df['close'].tolist()))) - ts_argmin(np.array(df['value'].tolist()))
    df['vol'] = ts_rank(delta(np.array(df['v1'].tolist())))
    return df



factor_ckeck = {
    "factor2": "thd<4",
    "factor3": "thd<0",
    "factor4": "thd<0",
    "factor5": "thd <0",
    "factor6": "thd <4",
}
