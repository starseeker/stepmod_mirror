#!/bin/bash

# WARNING : WORKING DRAFT - DEVLOPMENT IN PROGRESS
#
#
#
##### PURPOSE : Update STEPmod based on a CR sequence defined in pub indexes, and generates APs modules concatenated schema
#
#
#
##### Preconditions:
# TO BE COMPELTED
# needs concatenate_schema.jar, concatenate_mim.prop, concatenate_arm.prop and in the same directory
#
#
#
##### Scripts called:
# cvs_update_tagged_parts_of_a_cr.sh
# build_cr.sh
# add_cr_to_smrl.sh
# TBC
#
#
#


echo "stepmod=$1/stepmod" > concatenate_arm.prop
echo "type=arm" >> concatenate_arm.prop
echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> concatenate_arm.prop

echo "stepmod=$1/stepmod" > concatenate_mim.prop
echo "type=mim" >> concatenate_mim.prop
echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> concatenate_mim.prop


more concatenate_arm.prop
more concatenate_mim.prop

#./$1/stepmod/utils/part1000/concatenate_arm_and_mim_schema.sh
./concatenate_arm_and_mim_schema.sh


java -cp concatenate_schema.jar modules.LongForm concatenated_mim.exp concatenate_mim.prop >outmim 2>outerrmim
java -cp concatenate_schema.jar modules.LongForm concatenated_arm.exp concatenate_arm.prop >outarm 2>outerrarm

more outmim
more outarm
more outerrmim
more outerrarm


exit
