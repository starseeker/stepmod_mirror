Rem $Id: smrl_build_setup.bat,v 1.5 2012/01/07 17:15:26 thomasrthurman Exp $
Rem Copy to data/part1000/dvlp in local repo for execution ease
set JAVA_HOME=C:\Program Files\Java\jdk1.6.0
set ANT_HOME=C:\apache-ant\apache-ant-1.8.0RC1
set SAXON_HOME=C:\saxon9\saxonb9-1-0-8j
set PERL_HOME=C:\strawberry\perl
set WINDOZE_PATH=C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem
echo
echo
set PATH=%WINDOZE_PATH%;C:\strawberry\c\bin;C:\strawberry\perl\bin;%ANT_HOME%\bin;%JAVA_HOME%\bin
echo %PATH%
set TERM=dumb
set SMRL_ROOT=U:\2012\SMRL_v5
set WORK=U:\Downloads\tmp
