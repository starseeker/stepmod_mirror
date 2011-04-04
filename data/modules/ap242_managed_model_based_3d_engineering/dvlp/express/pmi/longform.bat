echo on
echo "high"
@java -cp longform.jar modules.LongForm concatenated_arm.exp longform_arm.prop >concatenated_arm_out.txt 2>concatenated_arm_outerr.txt
@java -cp longform.jar modules.LongForm concatenated_mim.exp longform_mim.prop >concatenated_mim_out.txt 2>concatenated_mim_outerr.txt
pause
call longform_edms.bat
