#!/bin/sh

ANT_HOME=/usr/local/ant ; export ANT_HOME
ANT_OPTS=-Xmx1024m ; export ANT_OPTS
PATH=$PATH:$ANT_HOME/bin ; export PATH
SAXON_HOME=/usr/local/saxon6 ; export SAXON_HOME
CLASSPATH=$SAXON_HOME/saxon.jar ; export CLASSPATH

ant clean
rm build.xml
ant -f buildbuild.xml | tee buildbuild.log 2>&1
ant all | tee build.log 2>&1
ant zip
# Grab the build file and the logs package them for reference
top=`pwd`
ballot=`basename ${top}`
tar cvzf ../../isohtml/${ballot}/`date '+%Y%m%d'`_build_logs.tar.gz buildbuild.log build.log build.xml


