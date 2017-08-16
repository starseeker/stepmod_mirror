#!/bin/bash

### or /bin/sh?
#
#
# WARNING : WORKING DRAFT - DEVLOPMENT IN PROGRESS
#
#
##### Preconditions:
# needs concatenate_schema.jar, concatenate_mim.prop, concatenate_arm.prop and in the same directory


# arg 1: workspace absolute path
# NOT YET IMPLETMENTED arg 2: part number of the AP module, e.g. 410
# Hard corded for 410

if [ -z $1 ];
then
echo "Error: workspace absolute path argument missing. "
exit
fi

echo "stepmod=$1/stepmod" > concatenate_arm.prop
echo "type=arm" >> concatenate_arm.prop
echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> concatenate_arm.prop

echo "stepmod=$1/stepmod" > concatenate_mim.prop
echo "type=mim" >> concatenate_mim.prop
echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> concatenate_mim.prop

more concatenate_arm.prop
more concatenate_mim.prop

java -cp concatenate_schema.jar modules.LongForm concatenated_mim.exp concatenate_mim.prop >outmim 2>outerrmim
java -cp concatenate_schema.jar modules.LongForm concatenated_arm.exp concatenate_arm.prop >outarm 2>outerrarm

more outmim
more outarm
more outerrmim
more outerrarm


exit
