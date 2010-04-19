echo off

rem Usage:
rem   build <target>
rem
rem See build.xml for the targets.

if not defined SMRL_ROOT (
echo Environment variable SMRL_ROOT not defined
echo Exiting
exit /b 1
)

if not exist %SMRL_ROOT% (
echo Directory %SMRL_ROOT% does not exist
echo Exiting
exit /b 1
)

ant %1
