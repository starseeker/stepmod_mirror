#!/bin/bash
#
#
#
#This script build a CR from its publication index and stepmod scripts.
#
#
# WARNING - UNDER DEVLOPMENT

echo "Two arguments to be specified: 1) absolute path of workspace where stepmod is checked out (e.g.: /Users/klt/Projets/workspace) ---- 2) name of the CR (e.g.: CR_PDM_1)."

if [ -z $1 ] || [ -z $2 ];
then
echo "Error: first, second or both arguments missing. "
exit
fi

cd $1/stepmod/publication/part1000/$2/

ant -lib $1/stepmod/etc/saxon6-5-5/saxon.jar -lib $1/stepmod/etc/saxon6-5-5/saxon-xml-apis.jar -lib $1/stepmod/etc/saxon6-5-5/saxon-jdom.jar -f buildbuild.xml | tee $1/$2_buildbuid_log.txt

# tee used to output to get put to the screen as well as a log file

ant -lib $1/stepmod/etc/saxon6-5-5/saxon.jar -lib $1/stepmod/etc/saxon6-5-5/saxon-xml-apis.jar -lib $1/stepmod/etc/saxon6-5-5/saxon-jdom.jar all | tee -a $1/$2_build_log.txt


exit
