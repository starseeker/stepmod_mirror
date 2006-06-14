$Id: readme.txt,v 1.1 2006/06/12 15:35:51 robbod Exp $

To set up Netbeans to develop Stepmod

1) create a new Netbeans Java project with existing classes
   E.g.
   Project name: Stepmod
   Project folder: D:\project\stepmod\apps\nbproject

2) Add stepmod/apps/stepmod/src/ as sources
 

3) Set the project properties
   Libraries: Add 
   stepmod/apps/stepmod/swing-layout-1.0.jar
   stepmod/apps/stepmod/ant.jar
   stepmod/apps/stepmod/ant-launcher.jar

   Note that swing-layout-1.0.jar is a netbeans library included for those
   who don't use Netbeans

   Run:
   Main Class = org.stepmod.STEPmod
  
   The arguments passed in need to point to the local root of stepmod i.e.

   Arguments = -root C:\**\**\stepmod
        
   

4) Copy stepmod/apps/stepmod/etc/netbeans/build.xml to the Netbeans project