echo off

rem Usage:
rem   build <target>
rem
rem See build.xml for the targets.
rem smrl_build_setup.bat must be executed to create variables

if not defined SMRL_ROOT (
echo Environment variable SMRL_ROOT not defined
echo Exiting
exit /b 1
)
rem users\Gerry\cm-work\part1000\trunk

if not defined WORK (
echo Environment variable WORK not defined
echo Exiting
exit /b 1
)
rem 
if not exist %SMRL_ROOT% (
echo Directory %SMRL_ROOT% does not exist
echo Exiting
exit /b 1
)

if not exist %WORK% (
echo Directory %WORK% does not exist
echo Exiting
exit /b 1
)

echo buiding...
ant %1
