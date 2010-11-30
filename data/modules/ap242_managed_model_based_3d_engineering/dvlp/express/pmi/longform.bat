echo on
echo "high"
copy W:\stepmod\data\modules\ap242_managed_model_based_3d_engineering\arm.exp r:
copy W:\stepmod\data\modules\ap242_managed_model_based_3d_engineering\mim.exp r:
@java -cp longform.jar modules.LongForm concatenated_arm.exp longform_arm.prop >concatenated_arm_out.txt 2>concatenated_arm_outerr.txt
@java -cp longform.jar modules.LongForm concatenated_mim.exp longform_mim.prop >concatenated_mim_out.txt 2>concatenated_mim_outerr.txt
pause
call r:\longform_edms.bat
