#!/usr/bin/env bash

#  cvs_initialize_smrlv6.sh
#  
#
#  Created by Thomas Thurman on 10/5/17.
#  
#
#
#This script, cvs_initialize_smrlv6.sh, initializes local stepmod directory with the data content of
#SMRLv6 and the supporting content of HEAD
#
# WARNING - $1 must end in 'stepmod', with no trailing slash.



if [ -z $1 ];
then
echo "Error: first, argument missing. Two arguments to be specified: 1) absolute path of workspace where stepmod is to be checked out (e.g.: /Users/klt/Projets/workspace)."
exit
fi

cd $1

cvs checkout -r SMRLv6 stepmod
#following items need to be at HEAD
cvs checkout -A stepmod/etc/saxon6-5-5
cvs checkout -A stepmod/dtd
cvs checkout -A stepmod/nav
cvs checkout -A stepmod/publication
cvs checkout -A stepmod/repository_index.xml
cvs checkout -A stepmod/utils
cvs checkout -A stepmod/xsl

exit
