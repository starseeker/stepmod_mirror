$Id: readme.txt,v 1.4 2006/07/17 06:18:08 robbod Exp $

WARNING 
- THIS IS WORK IN PROGRESS - so no guarantees about anything

INTRODUCTION
===========
This application allows enables the configuration management of STEPmod and
its components.



INSTALLATION
============
For Unix:
Edit runme.sh so that -root points at your local copy of stepmod

For Windows:
Edit runme.sh so that -root points at your local copy of stepmod

Make sure that you have a copy of CVSNT installed 
See http://www.cvsnt.org/wiki/FrontPage

Setup your SourceForge name, the path to the CVS executable and SSS link
using the StepModProperties command (Tools -> Set Stepod propeorties) 
This will modify the stepmod/stepmod.properties file
Please do not check in this file.



RUNNING THE APPLICATION
=======================
To run the program from Unix:
Execute runme.sh

To run the program from DOS:
Execute runme.bat

TEST CVS CONNECTION
===================
Once the application is installed and you have set up your STEPmod
properties (the SourceForge user name etc), you can test the SSH connection
and CVS access to SourceForge by running Tools -> Test CVS connection
This simply runs a cvs status on stepmod/repository_index.xml