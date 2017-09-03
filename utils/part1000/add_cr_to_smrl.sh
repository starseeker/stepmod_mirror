#!/bin/bash
#
#
# WARNING - UNDER DEVLOPMENT - WORKING DRAFT
#
#
# PURPOSE: Update last SMRL with new CR including updated modules and resources
#


exec > >(tee -i $1/../$2_add_to_smrl_log.txt)
exec 2>&1

if [ -z $1 ] || [ -z $2 ];
then
    echo "Error: first, second or both arguments missing. Two arguments to be specified: 1) absolute path of workspace where stepmod is checked out (e.g.: /Users/klt/Projets/workspace); 2) name of the CR (e.g.: CR_PDM_1)."
exit
fi

cd $1/..

if [ -d stepmod -a -d SMRL ]
then

echo "======================== Copying CR build directory from STEPmod to workspace: ========================"

    cp -Riv $1/publication/isopub/$2 $1/..
    cd $1/..

# cp -i Cause mv to write a prompt to standard error before moving a file that would overwrite an existing file.
# cp -R If source_file designates a directory, cp copies the directory and the entire subtree connected at that point.  If the source_file ends in a /, the contents of
#the directory are copied rather than the directory itself.  This option also causes symbolic links to be copied, rather than indirected through, and for cp to
#create special files rather than copying them as normal files.  Created directories have the same mode as the corresponding source directory, unmodified by the
#process' umask.

    if [ -d $2/part1000/data/modules ]
    then
        echo "======================== Following $2/part1000/data/modules exists ========================"

        ls $2/part1000/data/modules/

        echo "======================== Deleting corresponding SMRL/data/modules ========================"
        ls -d $2/part1000/data/modules/* | sed "s/$2\/part1000/SMRL/g" > list.txt ; xargs rm -rfv < list.txt

        echo "======================== Copying modules from $2/part1000/data to SMRL/data ========================"
        cd $2/part1000/data/ ; ls -d modules/* | xargs tar -cvf p1000_modules.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../$2/part1000/data/p1000_modules.tar ; cd ../..

    else
        echo "No modules are in this CR."
    fi

    cd $1/..

    if [ $(find $2/ -type d -name "iso10303_*" | wc -l ) != "0" ]
    then
        for dir_iso10303 in $( ls -d $2/iso10303_* )
        do

            echo "======================== Following $dir_iso10303/data/resource_docs exists ========================"
            echo "cr: $dir_iso10303"

            echo "======================== Deleting corresponding SMRL/data/resource_docs and resources ========================"

            ls -d $dir_iso10303/data/*/* | sed "s/$dir_iso10303/SMRL/g" > list.txt ; xargs rm -rfv < list.txt



            echo "======================== Copying from $dir_iso10303/data/resource_docs|resources to SMRL/data/resource_docs|resources exists ========================"

            #res
            cd $dir_iso10303/data/ ; ls -d resources/* | xargs tar -cvf resources.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../$dir_iso10303/data/resources.tar ; cd ../..

            #res docs
            cd $dir_iso10303/data/ ; ls -d resource_docs/* | xargs tar -cvf resource_docs.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../$dir_iso10303/data/resource_docs.tar ; cd ../..

            #deleting intermediate tar
            rm -rf $dir_iso10303/data/resources.tar
            rm -rf $dir_iso10303/data/resource_docs.tar
            #deleting list.txt
            rm -rf list.txt

        done
    else
        echo "No ressources found in this CR."
    fi
else
    pwd
	echo "Error: stepmod directory and/or SMRL directory not found."
	exit
fi

exit
