#!/bin/bash
#
# WARNING : WORKING DRAFT - DEVLOPMENT IN PROGRESS
#
# PURPOSE: takes one short form schema and a stepmod directory and creates a concatenated file of eash called short form schemas.
# LOGS: logs are produced in the workspace.
# PRECONDITION: Express Engine 4.3.3 or later is installed and linked to the command line name "eengine"


if [ -z $1 ] || [ -z $2 ];
then
    echo "Error: one or two arguments are missing. Argument 1 is workspace's absolute path argument and argument 2 is a name of a module. Note: path should not end by the character '/'."
exit
fi

eengine --concat_schema -schema $1/stepmod/data/modules/$2/arm.exp -stepmod $1/stepmod/ -mode arm_shortform | tee $1/stepmod/data/modules/$2/arm_concat_ee_log.txt

eengine --concat_schema -schema $1/stepmod/data/modules/$2/mim.exp -stepmod $1/stepmod/ -mode mim_shortform | tee $1/stepmod/data/modules/$2/mim_concat_ee_log.txt




###########################################################################
##### Preconditions:
# needs concatenate_schema.jar, concatenate_mim.prop, concatenate_arm.prop and in the same directory
## commands using the old java scripts from stepmod
#echo "stepmod=$1/stepmod" > concatenate_arm.prop
#echo "type=arm" >> concatenate_arm.prop
#echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> concatenate_arm.prop

#echo "stepmod=$1/stepmod" > concatenate_mim.prop
#echo "type=mim" >> concatenate_mim.prop
#echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> concatenate_mim.prop

#more concatenate_arm.prop
#more concatenate_mim.prop

#java -cp concatenate_schema.jar modules.LongForm concatenated_mim.exp concatenate_mim.prop >outmim 2>outerrmim
#java -cp concatenate_schema.jar modules.LongForm concatenated_arm.exp concatenate_arm.prop >outarm 2>outerrarm

#more outmim
#more outarm
#more outerrmim
#more outerrarm
###########################################################################


exit
