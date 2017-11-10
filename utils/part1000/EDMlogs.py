#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 28 13:25:06 2017

@author: aminatambengue
"""


# Libraries
import sys
import pandas as pd
import time
import re
import os

version='1.6'
file= sys.argv[1]
repo=os.getcwd()
date=time.strftime("%y%m%d-%I%M%p")
script=re.split('/',sys.argv[0])[-1].strip('.py')+' version '+version
log=re.split('/',file)[-1]
title=date+'-log.csv'
header=log+' '+script


data=list()
with open(file) as f:
    inside='n'
    schema=str()
    message=str()
    for line in f:
        if re.match('Compilation result of',line):
            inside='y'
            schema=next(iter(f))
            schema=re.sub('EXPRESS Schema\s+:\s+|\n*','',schema).strip(' ')
            message=str()
        if inside == 'y':
            message=message+line+' '
        if re.search('ERROR.+detected',line):
            inside='n'
            message=re.sub('\d+\s+\w+\s+detected.|\n|in line:\s+\d+','',message)
            message=re.sub('\s{2,}',' ',message)
            message=re.sub('MESSAGE:\s+','\n\t\t',message)
            messages=re.split('(WARNING:|ERROR\s*:)',message)
            for m in messages[:]:
                if re.match('Compilation',m):
                    messages.remove(m)
            l=len(messages)
            for i in range(l):
                if re.match('WARNING:|ERROR\s*:',messages[i]):
                    data.append([messages[i],schema,messages[i+1].strip()])
df=pd.DataFrame(data,columns=[header,'schema','message'])

# ### For EDM validation checks only

if len(sys.argv) == 3:
    lf=sys.argv[2]
    #df['line']=df.message.apply(lambda x: int(re.findall('Line\s+\d+',x)[0].strip('Line ')))
    Line=df.message.apply(lambda x: int(re.findall('Line\s+\d+',x)[0].strip('Line '))) 
    h=open(lf)
    express=list()
    for line in iter(h):
        express.append(line)
    h.close()
    express=pd.DataFrame(express,columns=['text'])
    module=list()
    for i in Line:
        #does not work with concatenated file as search files.
        
        line=i-1
        while re.search('\(\*\s*USED|\(\*\s*REFERENCED|\(\*\s*Implicit|^SCHEMA ',express.text[line])==None:
            line=line-1
        text=re.sub("\(\* REFERENCE FROM \(|\(\* USED FROM \(|\); \*\)\n|\(\*\s*Implicit interfaced from:\s*|\s*\*\)|SCHEMA |;|\'\{.*$","",express.text[line])
        module.append(text.strip())
    df['module']=module


df.message=df.message.apply(lambda x: re.sub('Line\s+\d+:\s+','',x))
df.drop_duplicates(['message'],inplace=True)
splitted=df.message.apply(lambda x:re.split('(C\d+)',x))
df['C']=splitted.apply(lambda x: x[1])
df.message=df.message.apply(lambda x: re.sub('\s*C\d+:',' ',x))
df.message=df.message.apply(lambda x: x.strip())
df.sort_values(by='C',inplace=True)
print(df.head())

# To CSV
df.to_csv(title,sep=';',index=False)