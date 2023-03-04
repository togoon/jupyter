def profits(account):
    """profits_df, profits_dict = profits(account)
    """
    ### 持仓个股，当天盈亏情况
    profits = [(i, round(account.referencePrice[i] / account.valid_seccost[i] - 1, 4)) for i in account.valid_secpos]
    profits_df = pd.DataFrame.from_records(profits, columns=['ticker', 'profits']).sort(columns=['profits'], ascending=True)

    profits = dict(profits)

    return profits_df, profits