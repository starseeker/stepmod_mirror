#! /bin/sh
sed '1,3 !d' concatenated_mim.exp > mim_head.txt
sed '1,3 !d' concatenated_arm.exp > arm_head.txt

java -cp longform.jar modules.LongForm concatenated_mim.exp longform_mim.prop >outmim 2>outerrmim
sed -f sedscr_mim concatenated_mim.exp > junkmim1
~/bin/dos2unix.sh junkmim1 > junkmim2
cat mim_head.txt junkmim2 > concatenated_mim.exp
rm -f concatenated_mim.exp.orig
#/usr/bin/patch --verbose -b concatenated_mim.exp -i concatenated_mim_patch_file
echo 'ap210 mim done'

java -cp longform.jar modules.LongForm concatenated_arm.exp longform_arm.prop >outarm 2>outerrarm
sed -f sedscr_arm concatenated_arm.exp > junkarm1
~/bin/dos2unix.sh junkarm1 > junkarm2
cat arm_head.txt junkarm2 > concatenated_arm.exp
rm -f concatenated_arm.exp.orig
#/usr/bin/patch --verbose -b concatenated_arm.exp -i concatenated_arm_patch_file
echo 'ap210 arm done'
