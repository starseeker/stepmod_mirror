$Id: readme.txt,v 1.7 2006/08/02 13:07:22 robbod Exp $

WARNING 
- THIS IS WORK IN PROGRESS - so no guarantees about anything

INTRODUCTION
===========
This application allows enables the configuration management of STEPmod and
its components.


INSTALLATION
============
Make sure that you have a copy of CVSNT installed 
See http://www.cvsnt.org/wiki/FrontPage


RUNNING THE APPLICATION
=======================
To run the program from Unix:
Execute runme.sh

To run the program from DOS:
Execute runme.bat

Setup the application properties.
You only need to do this once and a properties file will be stored and
reused next time you run the application.
Use the Tools -> Set Stepmod properties menu to setup the properties

Setup the path to STEPmod, your SourceForge name, the path to the CVS executable and SSH link


TEST CVS CONNECTION
===================
Once the application is installed and you have set up your STEPmod
properties (the SourceForge user name etc), you can test the SSH connection
and CVS access to SourceForge by running Tools -> Test CVS connection
This simply runs a cvs status on stepmod/repository_index.xml