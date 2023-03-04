# -*- coding: UTF-8 -*-

import numpy as np
import warnings
from scipy import stats
from matplotlib import pyplot as plt
from sklearn.linear_model import LogisticRegression
import pandas as pd
from itertools import product as product
warnings.filterwarnings('ignore')
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

warnings.filterwarnings("ignore")



def create_X_Y(ts, lag=1, n_ahead=1, target_index=0) -> tuple:
    """
    A method to create X and Y matrix from a time series array for the training of
    deep learning models
    """
    # Extracting the number of features that are passed from the array
    # n_features = ts.shape[1] - 2 #(DNN future)
    ts_0,ts_1=ts[0],ts[1]
    # Creating placeholder lists
    X1,Y = [], []


    if len(ts_0) - lag <= 0:
        X1.append(ts_0)
    else:
        for i in range(len(ts_0)):
            if i<lag:
                continue
            Y.append(ts_0[(i):(i+1), target_index])
            X1.append(ts_1[(i):(i + 1), :])


    X1,Y = np.array(X1), np.array(Y)

    # Reshaping the X array to an RNN input shape
    X1 = np.reshape(X1, (X1.shape[0],X1.shape[2]))
    return X1, Y



#####################################################################################################################
#   Main Code
#####################################################################################################################
if __name__ == '__main__':
    # parameter
    lag_list = [8]
    batch_size=[32,16,64]
    n_layer=[64,256,128]
    df_para = pd.DataFrame(list(product(lag_list, batch_size, n_layer)))
    df_para.columns=['lag','batch','layer']
    df_para['acc']=0
    df_para=pd.concat([df_para,df_para,df_para,df_para,df_para,df_para,df_para,df_para,df_para,df_para,df_para,df_para])
    df_para.sort_values(by=['lag','batch','layer'],ascending=False,inplace=True)
    df_para.reset_index(drop=True,inplace=True)
    # print(df_para)

    df_plot=pd.DataFrame()
    for index_para,row_para in df_para.iterrows():
        data = pd.read_csv(r"C:\Users\wangjian\Desktop\strategy\BTC_strategy\tsc_dnn\results\feature_v1.csv")
        data['pct_']=data['pct_next_'].shift(1)
        data.dropna(how='any',inplace=True)
        del data['date']
        # print(data.columns)
        # features_0 = ['pct_next_', 'skew','max_ret','kurt','vol','upvar','upvol','downvar','max_drawdown'
        #             ,'alpha3','alpha11','alpha22','alpha24','alpha23','alpha27','alpha29','alpha76','alpha72','alpha71','alpha69'
        #             ,'alpha67','alpha65','alpha59','alpha58','alpha57','alpha55'
        #             ,'alpha53','alpha52','alpha51','alpha50','alpha47']
        # features_0 = ['pct_next_', 'skew', 'kurt', 'vol', 'upvar', 'upvol', 'downvar']
        # print(data.columns)
        features_0 = ['pct_next_']
        # features_1=['pct_']
        features_1 = [ 'pct_', 'close','mom_5','mom_30','mom_60','ma_7','ma_30','ma_120']
        features=features_0+features_1
        data_pct=data[['pct_change','pct_next_']]
        ts=[np.array(data[features_0]),np.array(data[features_1])]

        ################################3
        # Number of lags (hours back) to use for models
        lag = int(row_para[0])
        # Steps ahead to forecast
        n_ahead = 1
        # Share of obs in testing
        test_share = 0.1

        # Subseting only the needed columns

        ts = data[features]
        nrows = ts.shape[0]
        # Spliting into train and test sets
        train = ts[0:int(nrows * (1-test_share))]
        test = ts[int(nrows * (1-test_share)):]
        # Scaling the data
        train_max = train.max()
        train_min = train.min()
        train = (train - train_min) / (train_max - train_min)
        test = (test - train_min) / (train_max - train_min)


        # Creating the final scaled frame
        ts_s = pd.concat([train, test])
        pct_median = np.median(ts_s['pct_next_'].iloc[0:int(nrows * (1 - test_share))])
        ts_s['pct_next_']=np.where(ts_s['pct_next_']>pct_median,1,0)

        # Creating the X and Y for training
        X, Y = create_X_Y([np.array(ts_s[features_0]),np.array(ts_s[features_1])], lag=lag, n_ahead=n_ahead)

        # Spliting into train and test sets
        Xtrain, Ytrain = X[0:int(X.shape[0] * (1-test_share))], Y[0:int(X.shape[0] * (1-test_share))]

        model = LogisticRegression()
        model.fit(Xtrain, Ytrain)

        train_score = model.score(Xtrain, Ytrain)
        X_test, y_test = X[int(X.shape[0] * (1 - test_share)):], Y[int(X.shape[0] * (1 - test_share)):]
        cv_score = model.score(X_test, y_test)
        y_pred = pd.DataFrame(model.predict(X_test))
        y_pred.columns=['pred']
        y_prob = pd.DataFrame(model.predict_proba(X_test))
        y_pred['prob_0'],y_pred['prob_1'] = y_prob[0],y_prob[1]
        y_pred['actual'] = pd.DataFrame(y_test)
        y_pred['acc'] = np.where(y_pred['pred'] == y_pred['actual'], 1, 0)
        print(np.mean(y_pred['acc']))

        # print('train_score:{0:.6f}'.format(train_score))
        # print('test_score:{0:.6f}'.format(cv_score))


        # # Training of the model
        # history = model.train()
        # y_output = model.predict(Xval)
        # df = pd.concat([pd.DataFrame(y_output * (train_max.iloc[0] - train_min.iloc[0])+train_min.iloc[0]),
        #                 pd.DataFrame(Yval *  (train_max.iloc[0] - train_min.iloc[0])+train_min.iloc[0])], axis=1)
        # df.columns=['pred','actual']
        # # plt.plot(df['pred'],'r-')
        # # plt.plot(df['actual'],'b-')
        # # plt.show()
        # # check accuracy
        
        col_list = ['pred','actual']
        df = y_pred.copy()
        df_pct=data_pct.iloc[-df.shape[0]:,:]
        df_pct.reset_index(drop=True,inplace=True)
        df.reset_index(drop=True,inplace=True)
        df['pct_change']=df_pct['pct_change']
        df.to_excel("df.xlsx", index=False)
        for col in col_list:
            # df[col]=df[col]/df[col].shift(1) - 1
            df[col]=np.sign(df[col])

        df['acc']=np.where(df['pred']==df['actual'],1,0)
        print('acc is :',np.mean(df['acc']))
        df_para['acc'].iloc[index_para]=np.mean(df['acc'])
        # print(df_para)
        # break

        # case 1
        # df['nav'] = np.where(df['pred'] == 0, -df['pct_change'], df['pct_change'])
        # df['sign'] = np.sign(df['pred'])
        # df['cost_'] = np.where(df['sign'] == df['sign'].shift(1), 0, -0.0000)
        # df['nav'] = (df['nav'] + df['cost_'] + 1).cumprod()
        # df['bm'] = (df['pct_change'] + 1).cumprod()

        # case 2
        threshold = 0.55
        df['nav'] = np.where(df['prob_1']>threshold,-1,np.where(df['prob_0']>threshold,1,np.nan))
        df.fillna(method='pad',inplace=True)
        df['sign'] = np.sign(df['nav'])
        df['cost_'] = np.where(df['sign'] == df['sign'].shift(1), 0, -0.0016)
        df['nav'] = df['nav'] * df['pct_change']
        df['nav'] = (df['nav'] + df['cost_'] + 1).cumprod()
        df['bm'] = (df['pct_change'] + 1).cumprod()




        # if index_para==0:
        #     df_plot=df[['nav']]
        #     df_plot.columns=[str(index_para)]
        # else:
        #     # df_plot[str(index_para)] = 0
        #     df_plot['nav'+str(index_para)]=df['nav']
        df.to_excel("df_plot.xlsx")
        plt.plot(df['nav'])
        plt.show()
        break

