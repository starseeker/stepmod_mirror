#!/bin/bash
#
#
#
#
# PURPOSE: Update last SMRL with new CR including updated modules and resources
#

echo "Two arguments to be specified: 1) absolute path of workspace where stepmod is checked out (e.g.: /Users/klt/Projets/workspace) ---- 2) name of the CR (e.g.: CR_PDM_1)."

if [ -z $1 ] || [ -z $2 ];
then
echo "Error: first, second or both arguments missing. "
exit
fi

cd $1

if [ -d stepmod -a -d SMRL ]
then

    cp -Riv $1/stepmod/publication/isopub/$2 $1
    cd $1

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
        ls -d $2/part1000/data/modules/* | sed "s/$2\/part1000/SMRL/g" > list1.txt ; xargs rm -rfv < list1.txt

        echo "======================== Copying modules from $2/part1000/data to SMRL/data ========================"
        cd $2/part1000/data/ ; ls -d modules/* | xargs tar -cvf p1000_modules.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../$2/part1000/data/p1000_modules.tar ; cd ../..

    else
        echo "$2/part1000/data/modules doesn't exist."
    fi

#HARD CODED FOR P42, NOT TESTED , to BE CONTINUED FOR ALL IRs

    cd $1

    if [ -d $2/iso10303_42 ]
    then
        echo "======================== Following $2/iso10303_xx/data/resource_docs and resources exist ========================"
        ls -d $2/iso10303_42/data/*/*

        echo "======================== Deleting corresponding SMRL/data/resource_docs and resources ========================"
        ls -d $2/iso10303_42/data/*/* | sed "s/$2\/iso10303_42/SMRL/g" > list1.txt ; xargs rm -rfv < list1.txt

#for i in $( ls $2/iso10303_4*/ )
#do
#	echo "resin cr: $i"
#done
        echo "======================== Copying from $2/iso10303_xx/data/resource_docs|resources to SMRL/data/resource_docs|resources exists ========================"

#P42 res:
        cd $2/iso10303_42/data/ ; ls -d resources/* | xargs tar -cvf p42_resources.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../$2/iso10303_42/data/p42_resources.tar ; cd ../..

#P42 res docs
        cd $2/iso10303_42/data/ ; ls -d resource_docs/* | xargs tar -cvf p42_resource_docs.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../$2/iso10303_42/data/p42_resource_docs.tar ; cd ../..

#P43 res:
#cd $2/iso10303_43/data/ ; ls -d resources/* | xargs tar -cvf p43_resources.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../$2/iso10303_43/data/p43_resources.tar ; cd ../..

#P43 res docs
#cd $2/iso10303_43/data/ ; ls -d resource_docs/* | xargs tar -cvf p43_resource_docs.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../$2/iso10303_43/data/p43_resource_docs.tar ; cd ../..

    else
        echo "No Resource docs in the CR."
    fi

else
    pwd
	echo "Error: stepmod directory and/or SMRL directory not found."
	exit
fi
