Rem filename: smrl_build_setup.bat
Rem in data/part1000/dvlp
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
set SMRL_ROOT=U:\2011\SMRL_build_2011_10_19\SMRL_v4_2011_10_24 work
set WORK=U:\Downloads\tmp
