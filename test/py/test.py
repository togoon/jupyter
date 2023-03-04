import pandas as pd
def test( ):
    lst1 = pd.Series([1,5,6,12,2])
    lst2 = pd.Series([2,3,5,11,13])
    is_buy    = 0
    buy_val   = pd.Series([])
    sell_val  = pd.Series([])
    idx = len(lst1)
    while idx > 0:
        idx -= 1
        lst1_val = lst1[idx]
        lst2_val = lst2[idx]


        if lst1_val > lst2_val:
            if is_buy == 0:
                is_buy ==1
                buy_val.append(lst1_val)
        elif lst1_val < buy_val:
            if is_buy == 1:
                is_buy == 0
                sell_val.append(lst1_val)
    print('buy_bal',buy_val)
test( )

