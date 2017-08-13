#!/bin/bash
#
#
#To be run from ./stepmod
#
#This script, update_parts_and_build_cr.sh, update parts included the publication index of a CR, then build it.
#
#One argument for the moment: the CR id, e.g. CR_210_1
#
#To be run after configuring local stepmod with:
#
#cvs update
#cvs update -RAr SMRLv6 -CdP stepmod/data
#cvs update -RAr HEAD -CdP stepmod/data/basic/
#
# uses /stepmod/utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl
#
#
# operational on my machine / environment, still work in progress

if [ -z $1 ]
then
echo "Specify CR name"
exit
fi

java -jar stepmod/etc/saxon6-5-5/saxon.jar stepmod/publication/part1000/$1/publication_index.xml stepmod/utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl | xargs cvs update -RAdr $1

cd stepmod/publication/part1000/$1/

ant -lib ../../../etc/saxon6-5-5/saxon.jar -lib ../../../etc/saxon6-5-5/saxon-xml-apis.jar -lib ../../../etc/saxon6-5-5/saxon-jdom.jar -f buildbuild.xml

ant -lib ../../../etc/saxon6-5-5/saxon.jar -lib ../../../etc/saxon6-5-5/saxon-xml-apis.jar -lib ../../../etc/saxon6-5-5/saxon-jdom.jar all


exit
