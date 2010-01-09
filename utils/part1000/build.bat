echo off

rem Usage:
rem   build <target>
rem
rem See build.xml for the targets.

if not defined STEP1000_ROOT (
echo Environment variable STEP1000_ROOT not defined
echo Exiting
exit /b 1
)

if not exist %STEP1000_ROOT% (
echo Directory %STEP1000_ROOT% does not exist
echo Exiting
exit /b 1
)

ant %1
