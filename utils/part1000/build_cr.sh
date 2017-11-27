#!/bin/bash
#
#
#
#This script build a CR from its publication index xml file and stepmod xsl / ant scripts.
#
#
# WARNING - UNDER DEVLOPMENT

exec > >(tee -i $1/../$2_cr_build_log.txt)
exec 2>&1

if [ -z $1 ] || [ -z $2 ];
then
echo "Error: first, second or both arguments missing. Two arguments to be specified: 1) absolute path ending in 'stepmod', with no trailing slash, of checked-out stepmod repository (e.g.: /Users/klt/Projets/workspace/stepmod); 2) name of the CR (e.g.: CR_PDM_1)."
exit
fi

echo "============================ Deleting eventual provious build directory and build.xml: ============================"

if [ -d $1/publication/isopub/$2 ];
then
rm -rfv stepmod/publication/isopub/$2
fi

cd $1/publication/part1000/$2/

if [ -f build.xml ];
then
rm -rfv build.xml

ant -lib $1/etc/saxon6-5-5/saxon.jar -lib $1/etc/saxon6-5-5/saxon-xml-apis.jar -lib $1/etc/saxon6-5-5/saxon-jdom.jar -f buildbuild.xml

ant -lib $1/etc/saxon6-5-5/saxon.jar -lib $1/etc/saxon6-5-5/saxon-xml-apis.jar -lib $1/etc/saxon6-5-5/saxon-jdom.jar all

fi

exit

