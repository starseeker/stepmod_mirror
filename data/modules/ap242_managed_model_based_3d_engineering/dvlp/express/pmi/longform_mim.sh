#! /bin/sh
java -cp longform.jar modules.LongForm concatenated_mim.exp longform_mim.prop >outmim 2>outerrmim
java -cp longform.jar modules.LongForm concatenated_arm.exp longform_arm.prop >outarm 2>outerrarm
