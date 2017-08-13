#!/bin/bash

if [ -z $1 ]
then
    echo "Specify CR name"
exit
fi

java -jar stepmod/etc/saxon6-5-5/saxon.jar stepmod/publication/part1000/$1/publication_index.xml stepmod/utils/part1000/pub_index_to_parts_list_for_cvs_update.xsl | xargs cvs update -RAdr $1


exit
