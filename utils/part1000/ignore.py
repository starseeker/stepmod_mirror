#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov 10 10:24:19 2017

@author: aminatambengue
"""


import sys
import pandas as pd
import time

date=time.strftime("%y%m%d-%I%M%p")
title=date+'-log_with_ignored.csv'

df=pd.read_csv(sys.argv[1],sep=';')
ignore=pd.read_csv(sys.argv[2],sep=';')
ignore=ignore.iloc[:,:2]
col=list(set(ignore.iloc[:,1]))

df_left=pd.merge(df,ignore,how='outer',on='message',indicator=True)
df_left=df_left[df_left._merge=='left_only']
df_left=df_left.iloc[:,:-3]

# To CSV
df_left.to_csv(title,sep=';',index=False)