@echo off
REM $Id: make_html.bat,v 1.12 2001-09-12 09:56:17+01 rob Exp rob $

REM Generate the html for a module.
REM make_html [module]


if "%1%"=="" goto HELP
goto SETVARS


REM ******** Usage guide
:HELP
@echo Insufficient arguments.
@echo.
@echo make_html [module]
@echo  Create an html version of the module documentation in the 
@echo  directory [module]/html
goto END


REM ******** set the variables
:SETVARS
SETLOCAL
set MODULES_HOME=..
REM This line does not seem to work on Windows95
REM if not exist "%MODULES_HOME%"\src\make_html.bat goto ERR_HOME

set SAXON=e:\apps\instant-saxon\saxon

set MODULE=%1
set MODULE_PATH=%MODULES_HOME%\data\modules\%MODULE%\sys
REM This line does not seem to work on Windows95
REM if not exist "%MODULE_PATH%"\model\model.xml goto ERR_PATH


REM ******** The main program
:MAIN
echo Making html for %MODULE%
rem goto :4_INFO_REQS
rem goto :5_MIM
rem goto :5_MAP
rem goto :E_EXP_ARM

:MAINHTML
echo.
echo .... %MODULE_PATH%\main.htm
%SAXON% -a -o "%MODULE_PATH%\main.htm" "%MODULE_PATH%\main.xml" output_type="HTM"

:COVER
echo.
echo .... %MODULE_PATH%\cover.htm
%SAXON% -a -o "%MODULE_PATH%\cover.htm" "%MODULE_PATH%\cover.xml" output_type="HTM"

:INTRODUCTION
echo.
echo .... %MODULE_PATH%\introduction.htm
%SAXON% -a -o "%MODULE_PATH%\introduction.htm" "%MODULE_PATH%\introduction.xml" output_type="HTM"

:FOREWORD
echo.
echo .... %MODULE_PATH%\foreword.htm
%SAXON% -a -o "%MODULE_PATH%\foreword.htm" "%MODULE_PATH%\foreword.xml" output_type="HTM"

:1_SCOPE
echo.
echo .... %MODULE_PATH%\1_scope.htm
%SAXON% -a -o "%MODULE_PATH%\1_scope.htm" "%MODULE_PATH%\1_scope.xml" output_type="HTM"

:2_REFS
echo.
echo .... %MODULE_PATH%\2_refs.htm
%SAXON% -a -o "%MODULE_PATH%\2_refs.htm" "%MODULE_PATH%\2_refs.xml" output_type="HTM"

:3_DEFS
echo.
echo .... %MODULE_PATH%\3_defs.htm
%SAXON% -a -o "%MODULE_PATH%\3_defs.htm" "%MODULE_PATH%\3_defs.xml" output_type="HTM"

:4_INFO_REQS
echo.
echo .... %MODULE_PATH%\4_info_reqs.htm
%SAXON% -a -o "%MODULE_PATH%\4_info_reqs.htm" "%MODULE_PATH%\4_info_reqs.xml" output_type="HTM"
rem goto :END

:5_MIM
echo.
echo .... %MODULE_PATH%\5_mim.htm
%SAXON% -a -o "%MODULE_PATH%\5_mim.htm" "%MODULE_PATH%\5_mim.xml" output_type="HTM"
rem goto :END

:5_MAP
echo.
echo .... %MODULE_PATH%\5_mapping.htm
%SAXON% -a -o "%MODULE_PATH%\5_mapping.htm" "%MODULE_PATH%\5_mapping.xml" output_type="HTM"
rem goto :END

:A_SHORT_NAMES
echo.
echo .... %MODULE_PATH%\a_short_names.htm
%SAXON% -a -o "%MODULE_PATH%\a_short_names.htm" "%MODULE_PATH%\a_short_names.xml" output_type="HTM"


:B_OBJ_REG
echo.
echo .... %MODULE_PATH%\b_obj_reg.htm
%SAXON% -a -o "%MODULE_PATH%\b_obj_reg.htm" "%MODULE_PATH%\b_obj_reg.xml" output_type="HTM"


:C_ARM_EXPG
echo.
echo .... %MODULE_PATH%\c_arm_expg.htm
%SAXON% -a -o "%MODULE_PATH%\c_arm_expg.htm" "%MODULE_PATH%\c_arm_expg.xml" output_type="HTM"


:D_MIM_EXPG
echo.
echo .... %MODULE_PATH%\d_mim_expg.htm
%SAXON% -a -o "%MODULE_PATH%\d_mim_expg.htm" "%MODULE_PATH%\d_mim_expg.xml" output_type="HTM"


:E_EXP
echo.
echo .... %MODULE_PATH%\e_exp.htm
%SAXON% -a -o "%MODULE_PATH%\e_exp.htm" "%MODULE_PATH%\e_exp.xml" output_type="HTM"


:E_EXP_ARM
echo.
echo .... %MODULE_PATH%\e_exp_arm.htm
%SAXON% -a -o "%MODULE_PATH%\e_exp_arm.htm" "%MODULE_PATH%\e_exp_arm.xml" output_type="HTM"


:E_EXP_MIM
echo.
echo .... %MODULE_PATH%\e_exp_mim.htm
%SAXON% -a -o "%MODULE_PATH%\e_exp_mim.htm" "%MODULE_PATH%\e_exp_mim.xml" output_type="HTM"
rem goto :END

:E_EXP_MIMLF
echo.
echo .... %MODULE_PATH%\e_exp_mim_lf.htm
%SAXON% -a -o "%MODULE_PATH%\e_exp_mim_lf.htm" "%MODULE_PATH%\e_exp_mim_lf.xml" output_type="HTM"
rem goto :END

:F_GUIDE
echo.
echo .... %MODULE_PATH%\f_guide.htm
%SAXON% -a -o "%MODULE_PATH%\f_guide.htm" "%MODULE_PATH%\f_guide.xml" output_type="HTM"


:BIBLIO
echo.
echo .... %MODULE_PATH%\biblio.htm
%SAXON% -a -o "%MODULE_PATH%\biblio.htm" "%MODULE_PATH%\biblio.xml" output_type="HTM"


:ARM
echo.
echo .... %MODULE_PATH%\..\arm.htm
%SAXON% -a -o "%MODULE_PATH%\..\arm.htm" "%MODULE_PATH%\..\arm.xml" output_type="HTM"


:MIM
echo.
echo .... %MODULE_PATH%\..\mim.htm
%SAXON% -a -o "%MODULE_PATH%\..\mim.htm" "%MODULE_PATH%\..\mim.xml" output_type="HTM"


echo.
echo ---------------------------------------------------
echo HTML created in:  
echo   %MODULE_PATH%\html
echo Browse:
echo   %MODULE_PATH%\html\module.htm
goto END

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
