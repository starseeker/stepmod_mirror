@echo off
REM $Id: make_html.bat,v 1.1 2001/11/21 15:41:20 robbod Exp $

REM Merge a external descriptions with the module.
REM merge [module]


if "%1%"=="" goto HELP
goto SETVARS


REM ******** Usage guide
:HELP
@echo Insufficient arguments.
@echo.
@echo merge [module]
@echo  Create an html version of the module documentation in the 
@echo  directory [module]/html
goto END


REM ******** set the variables
:SETVARS
SETLOCAL
set MODULES_HOME=..

set SAXON=e:\apps\instant-saxon\saxon

set MODULE=%1
set MODULE_PATH=%MODULES_HOME%\data\modules\%MODULE%
set XSL_PATH=%MODULES_HOME%\xsl

REM ******** The main program
:MAIN
echo Merging descriptions for %MODULE%

:MAINHTML
echo.
echo reading .... %MODULE_PATH%\arm.xml
echo writing .... %MODULE_PATH%\arm_merge.xml
REM %SAXON% -a -o "%MODULE_PATH%\arm_merge.xml" "%MODULE_PATH%\arm.xml" output_type="XML"

REM %SAXON% -o "%MODULE_PATH%\arm_merge.xml" "%MODULE_PATH%\arm.xml" "%XSL_PATH%\merge.xsl" output_type="XML" merge_module="%MODULE%" merge_clause="arm"

%SAXON% -o "%MODULE_PATH%\mim_lf_merge.xml" "%MODULE_PATH%\mim_lf.xml" "%XSL_PATH%\merge.xsl" output_type="XML" merge_module="%MODULE%" merge_clause="mim"

GOTO :END

:ERR_HOME
echo.
echo MODULES_HOME has been incorrectly set. 
echo The following directory does not exist:
echo %MODULES_HOME% 
goto END

:ERR_PATH
echo.
echo The module %MODULE% does not exist.
echo Expecting to find this directory:
echo %MODULE_PATH%\model\model.xml
goto END


:END
ENDLOCAL

