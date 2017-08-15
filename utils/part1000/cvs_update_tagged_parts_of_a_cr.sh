#!/bin/bash
#
#
#This script, update_parts_and_build_cr.sh, update parts included the publication index of a CR
#
#To be run after configuring local stepmod with:
#
#cvs update
#cvs update -RAr SMRLv6 -CdP stepmod/data
#cvs update -RAr HEAD -CdP stepmod/data/basic/
#
# uses /stepmod/utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl
#
# WARNING - UNDER DEVLOPMENT

echo "Two arguments to be specified: 1) absolute path of workspace where stepmod is checked out (e.g.: /Users/klt/Projets/workspace) ---- 2) name of the CR (e.g.: CR_PDM_1)."

if [ -z $1 ] || [ -z $2 ];
then
echo "Error: first, second or both arguments missing. "
exit
fi

java -jar $1/stepmod/etc/saxon6-5-5/saxon.jar $1/stepmod/publication/part1000/$2/publication_index.xml $1/stepmod/utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl | xargs cvs update -RAdr $2 | tee $1/$2_cvs_update_log.txt

#create an incrementable log in workspace

exit
