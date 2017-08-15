#!/bin/bash

# WARNING : WORKING DRAFT - DEVLOPMENT IN PROGRESS
#
#
# using last published SMRL, build SMRL_v_8.x using delete/past bash script, first working version:
#
# TO DO : use argument for stepmod dir “stepmod=$stepmod_dir"
#
#
#



##### Preconditions: TBD PASTED

##### Scripts called:
# cvs_update_tagged_parts_of_a_cr.sh
# build_cr.sh
# add_cr_to_smrl.sh
#
#
#
#


cd data/modules/ap210_electronic_assembly_interconnect_and_packaging_design/dvlp/pmi

# echo “stepmod=$stepmod_dir" > longform_arm.prop

echo "stepmod=/Users/klt/Projets/Eclipse_SMRL_v8.8/stepmod" > longform_arm.prop
echo "type=arm" >> longform_arm.prop
echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> longform_arm.prop

echo "stepmod=/Users/klt/Projets/Eclipse_SMRL_v8.8/stepmod" > longform_mim.prop
echo "type=mim" >> longform_mim.prop

echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> longform_mim.prop

#TO DO: same for 442 and 409

more longform_arm.prop
more longform_mim.prop

./longform_mim.sh



# other items: 2) format EDM log, 3) run EDM from this script
# # to be cross platform

exit
