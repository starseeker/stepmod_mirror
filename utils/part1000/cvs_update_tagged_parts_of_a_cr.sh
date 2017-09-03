#!/usr/bin/env bash
#
#
#This script, cvs_update_tagged_parts_of_a_cr.sh, update parts included the publication index of a CR
#
#To be run after configuring local stepmod with:
#
#cvs update
#cvs update -RAr SMRLv6 -CdP data
#
# uses /stepmod/utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl
#
# WARNING - UNDER DEVLOPMENT
# WARNING - $1 must end in 'stepmod', with no trailing slash.

exec > >(tee -i $1/../$2_cvs_update_log.txt)
exec 2>&1

if [ -z $1 ] || [ -z $2 ];
then
	echo "Error: first, second or both arguments missing. Two arguments to be specified: 1) absolute path ending in 'stepmod', with no trailing slash, of checked-out stepmod repository (e.g.: /Users/klt/Projets/workspace/stepmod); 2) name of the CR (e.g.: CR_PDM_1)."
exit
fi

cd $1

java -jar etc/saxon6-5-5/saxon.jar publication/part1000/$2/publication_index.xml utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl | xargs cvs -q -z 3 update -A
java -jar etc/saxon6-5-5/saxon.jar publication/part1000/$2/publication_index.xml utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl | xargs cvs -q -z 3 update -dPr $2

#tee creates log in workspace

cvs -q -z 3 update -A data/basic

cvs -q -z 3 update -dPr $2 data/basic

exit
