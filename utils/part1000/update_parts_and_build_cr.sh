#!/bin/bash
#
#
#
#This script build a CR from its publication index and stepmod scripts.
#
#
# WARNING - UNDER DEVLOPMENT

if [ -z $1 ] || [ -z $2 ];
then
    echo "Error: first, second or both arguments missing. Two arguments to be specified: 1) absolute path of workspace where stepmod is checked out (e.g.: /Users/klt/Projets/workspace); 2) name of the CR (e.g.: CR_PDM_1)."
exit
fi

cd $1

java -jar stepmod/etc/saxon6-5-5/saxon.jar stepmod/publication/part1000/$2/publication_index.xml stepmod/utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl | xargs cvs update -RAdr $2 | tee $1/$2_cvs_update_log.txt

#tee creates log in workspace

cvs update -RAr $2 -CdP stepmod/data/basic | tee $1/$2_data_basic_cvs_update_log.txt

cd $1/stepmod/publication/part1000/$2/

ant -lib $1/stepmod/etc/saxon6-5-5/saxon.jar -lib $1/stepmod/etc/saxon6-5-5/saxon-xml-apis.jar -lib $1/stepmod/etc/saxon6-5-5/saxon-jdom.jar -f buildbuild.xml | tee $1/$2_buildbuid_log.txt

# tee used to output to get put to the screen as well as a log file

ant -lib $1/stepmod/etc/saxon6-5-5/saxon.jar -lib $1/stepmod/etc/saxon6-5-5/saxon-xml-apis.jar -lib $1/stepmod/etc/saxon6-5-5/saxon-jdom.jar all | tee -a $1/$2_build_log.txt


exit
