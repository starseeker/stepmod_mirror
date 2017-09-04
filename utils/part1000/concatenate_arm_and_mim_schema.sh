#!/bin/bash
#
# WARNING : WORKING DRAFT - DEVLOPMENT IN PROGRESS
#
# PURPOSE: takes one short form schema and a stepmod directory and creates a concatenated file of eash called short form schemas.
# LOGS: logs are produced in the workspace.
# PRECONDITION: Express Engine 4.3.3 or later is installed and linked to the command line name "eengine"


exec > >(tee -i $1/../$2_concat_log.txt)
exec 2>&1

if [ -z $1 ] || [ -z $2 ];
then
	echo "Error: first, second or both arguments missing. Two arguments to be specified: 1) absolute path ending in 'stepmod', with no trailing slash, of checked-out stepmod repository (e.g.: /Users/klt/Projets/workspace/stepmod); 2) name a of a module (e.g.: ap210_electronic_assembly_interconnect_and_packaging_design)."
exit
fi

read -r -p "Do you want to generate concatenated files from STEPmod? [y/N] " response_stepmod
echo
if [[ "$response_stepmod" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    eengine --concat_schema -schema $1/data/modules/$2/arm.exp -stepmod $1 -mode arm_shortform
    eengine --concat_schema -schema $1/data/modules/$2/mim.exp -stepmod $1 -mode mim_shortform
    #do we need to specify  -stepmod_vcs option ?
else
    echo "No concatenated files generated from STEPmod."
    echo
fi

read -r -p "Do you want to generate concatenated files from SMRL? WARNING: If you intent to say yes and if you replied yes to the first question: before replying please move or rename the previously generated concatenated files to avoid to overwrite them. [y/N]" response_smrl
    # how to add an option to eegine to specify the output file name ?
echo
if [[ "$response_smrl" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    eengine --concat_schema -schema $1/../SMRL/data/modules/$2/arm.exp -stepmod $1/../SMRL -mode arm_shortform
    eengine --concat_schema -schema $1/../SMRL/data/modules/$2/mim.exp -stepmod $1/../SMRL -mode mim_shortform
    #do we need to specify  -stepmod_vcs option ?
else
echo "No concatenated files generated from SMRL."
echo
fi

exit



###########################################################################
##### Preconditions:
# needs concatenate_schema.jar, concatenate_mim.prop, concatenate_arm.prop and in the same directory
## commands using the old java scripts from stepmod
#echo "stepmod=$1/stepmod" > concatenate_arm.prop
#echo "type=arm" >> concatenate_arm.prop
#echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> concatenate_arm.prop
#
#echo "stepmod=$1/stepmod" > concatenate_mim.prop
#echo "type=mim" >> concatenate_mim.prop
#echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> concatenate_mim.prop
#
#more concatenate_arm.prop
#more concatenate_mim.prop
#
#java -cp concatenate_schema.jar modules.LongForm concatenated_mim.exp concatenate_mim.prop >outmim 2>outerrmim
#java -cp concatenate_schema.jar modules.LongForm concatenated_arm.exp concatenate_arm.prop >outarm 2>outerrarm
#
#more outmim
#more outarm
#more outerrmim
#more outerrarm
###########################################################################
