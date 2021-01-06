#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
datapath = "/some/path_to_input_file"
datapath_output = "some/filename_for_output"

df = pd.read_csv(datapath)
df_old_cols = list(df.columns)
print (list(df.columns))

cols_to_comp = ["countTurn", "sumSamples", "veryShortTurnCount", "sumPauses", "sumPercentPause", "countInter", "smoothSwitch", "interSwitch"]

# keep "silentSamples"
# totalSamples', 'countTurnA', 'countTurnB', 'sumSamplesA', 'sumSamplesB', 'veryShortTurnCountA', 'veryShortTurnCountB', 
#'sumPausesA', 'sumPausesB', 'sumPercentPauseA', 'sumPercentPauseB', 'silentSamples', 'noholdSamples', 
#'countInterA', 'countInterB', 'smoothSwitchA', 'smoothSwitchB', 'interSwitchA', 'interSwitchB'


# In[2]:


def cleanVals(x):
    if isinstance(x, float):
        return x
    if x.strip() == "" or x is np.nan or x is None:
        return None
    else:
        return float(x)

def diffAndTotal(df, cols):
    new_cols = []
    for col in cols:
        # clean old vars
        df[col+"A"] = df[col+"A"].apply(cleanVals)
        df[col+"B"] = df[col+"B"].apply(cleanVals)
        # compute new vars
        df[col+"Diff"] = abs(df[col+"A"] - df[col+"B"])
        df[col+"Total"] = df[col+"A"] + df[col+"B"]
        # append new column names
        new_cols.append(col+"Diff")
        new_cols.append(col+"Total")
    return (df, new_cols)

df, new_cols = diffAndTotal(df, cols_to_comp)

print (list(df.columns))
# print (df)
df.to_csv(datapath_output, columns = df_old_cols + new_cols)



# In[ ]:




