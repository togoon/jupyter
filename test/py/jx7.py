
import numpy as np
from pandas import DataFrame,Series
import pandas as pd
a=pd.Series([1,2,3,4])
b=pd.Series([5,6,7,8])
c=pd.Series([9,10,11,12])
d=pd.Series([13,14,15,16])

e= pd.DataFrame({'date':a,'type':1,'value':c})

f= pd.DataFrame({'date':b,'type':0,'value':d})

g=e.append(f)

print(g)