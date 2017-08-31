#!/bin/bash
#
#
#This script, cvs_update_tagged_parts_of_a_cr.sh, update parts included the publication index of a CR
#
#To be run after configuring local stepmod with:
#
#cvs update
#cvs update -RAr SMRLv6 -CdP stepmod/data
#
# uses /stepmod/utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl
#
# WARNING - UNDER DEVLOPMENT



if [ -z $1 ] || [ -z $2 ];
then
    echo "Error: first, second or both arguments missing. Two arguments to be specified: 1) absolute path of workspace where stepmod is checked out (e.g.: /Users/klt/Projets/workspace); 2) name of the CR (e.g.: CR_PDM_1)."
exit
fi

cd $1

java -jar stepmod/etc/saxon6-5-5/saxon.jar stepmod/publication/part1000/$2/publication_index.xml stepmod/utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl | xargs cvs update -RAdr $2 | tee stepmod/publication/part1000/$2/cvs_update_log.txt

#tee creates log in workspace

cvs update -RAr $2 -CdP stepmod/data/basic | tee stepmod/publication/part1000/$2/cvs_update_log.txt

exit
