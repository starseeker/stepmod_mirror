#!/bin/bash
#
#
# WARNING - UNDER DEVLOPMENT
#
#PURPOSE: Get a list of parts from a CR with N numbers, CR id, edition number, etc. - it uses pub-index_to_wg-n-tables.xsl function 4


if [ -z $1 ] || [ -z $2 ];
then
echo "Error: first, second or both arguments missing. Two arguments to be specified: 1) absolute path of workspace where stepmod is checked out (e.g.: /Users/klt/Projets/workspace); 2) name of the CR (e.g.: CR_PDM_1)."
exit
fi

cd $1

java -jar stepmod/etc/saxon6-5-5/saxon.jar stepmod/publication/part1000/$2/publication_index.xml stepmod/utils/pub-index_to_wg-n-tables.xsl


exit
