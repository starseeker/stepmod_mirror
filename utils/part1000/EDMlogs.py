
# coding: utf-8

# # EDM log scripts

# ## Launch the script
# 
# * Position yourself in the repository where the output will be created.
# * If the file you want to reformat is a shtolo log, then:
#     * python PATH-TO-SCRIPT-EDM_logs.py PATH-TO-LOG-FILE
# * If the file you want to reformat is the validation log, then:
#     * python PATH-TO-SCRIPT-EDM_logs.py PATH-TO-LOG-FILE PATH-TO-LONGFORM
# 
## Python setup
### For Windows users
# 
# 1. Download last release of python 3 here: 
#     * For 32 bits: https://www.python.org/ftp/python/3.6.2/python-3.6.2-webinstall.exe
#     * For 64 bits: https://www.python.org/ftp/python/3.6.2/python-3.6.2-amd64-webinstall.exe
# 1. Execute the file that has been downloaded and follow the instructions.
# 1. When the installation is finished, you can confirm it by opening up the command prompt and typing the following command: `python -V`
# 1. You will now need to make sure you have the latest version by typing: *python -m pip install -U pip setuptools
# *
# 
# ### For Mac and Linux users
# 
# 1. Download last release of python 3 here: 
#     * For Macs: https://www.python.org/ftp/python/3.6.2/python-3.6.2-macosx10.6.pkg
#     * For Linux: https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tar.xz
# 1. Execute the file that has been downloaded and follow the instructions.
# 1. When the installation is finished, you can confirm it by opening up the command prompt and typing the following command: `python -V`
# 1. You will now need to make sure you have the latest version by typing: `python -m pip install -U pip setuptools
# `
# 
# ### Required package
# 
# 1. For each package type `pip install NAME-OF-THE-PACKAGE` in the command line. Here is the list of packages to install:
#     * pandas
# 
# For example: `pip install pandas`.
# ## Script
# ### Librairies

# In[ ]:

import sys
import pandas as pd
import time
import re
import os


# ### For all EDM logs
# Output a table with the type (Warning or error) , the name of the schema and the error

# In[ ]:

version="1.2"
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
                    data.append([messages[i],schema,messages[i+1]])
df=pd.DataFrame(data,columns=[header,'schema','message'])


# ### For EDM validation checks only

# In[ ]:

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
        line=i-1
        while re.search('\(\*\s*USED|\(\*\s*REFERENCED',express.text[line])==None:
            line=line-1
        text=re.sub('\(\* REFERENCE FROM \(|\(\* USED FROM \(|\); \*\)\n','',express.text[line])
        module.append(text)
    df['module']=module


# ### Last formatting and excel output

# In[ ]:

df.message=df.message.apply(lambda x: re.sub('Line\s+\d+:\s+','',x))
df.drop_duplicates(['message'],inplace=True)
splitted=df.message.apply(lambda x:re.split('(C\d+)',x))
df['C']=splitted.apply(lambda x: x[1])
df.message=df.message.apply(lambda x: re.sub('\s*C\d+:',' ',x))
df.sort_values(by='C',inplace=True)

# To CSV
df.to_csv(title,sep=';',index=False)




