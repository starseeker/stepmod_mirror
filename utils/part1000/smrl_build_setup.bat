Rem $Id: smrl_build_setup.bat,v 1.7 2013/08/06 23:51:13 thomasrthurman Exp $
Rem file stepmod/utils/part1000/smrl_build_setup.bat
Rem Copy to data/library/dvlp in local repo for execution ease
REm Java/<version>/lib/tools.jar is required. get it from jdk
set JAVA_HOME=C:\Program Files\Java\jre7
set ANT_HOME=C:\apache-ant\apache-ant-1.9.2
set SAXON_HOME=C:\saxon9\saxonb9-1-0-8j
set PERL_HOME=C:\strawberry\perl
set WINDOZE_PATH=C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem
echo
echo
set PATH=%WINDOZE_PATH%;C:\strawberry\c\bin;C:\strawberry\perl\bin;%ANT_HOME%\bin;%JAVA_HOME%\bin;%SAXON_HOME%
echo %PATH%
set TERM=dumb
set SMRL_ROOT=U:\Documents\2013\SMRLv5\SMRL_v5_rc5
set WORK=U:\Downloads\tmp
