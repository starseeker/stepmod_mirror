set saxon_home=c:\software\saxonb8-8j
set saxon8=%saxon_home%/saxon8.jar
set saxon8_dom=%saxon_home%/saxon8-dom.jar
set log4j=c:/software/logging-log4j-1.2.14/dist/lib/log4j-1.2.14.jar
set netbeans_cvs=c:/software/javacvs/org-netbeans-lib-cvsclient.jar
set classpath=.;mkcmrecord.jar;%saxon8%;%saxon8_dom%;%log4j%;%netbeans_cvs%
set cvsroot=:pserver:anonymous@stepmod.cvs.sourceforge.net:/cvsroot/stepmod
java -Dcvs.root=%cvsroot% -classpath "%classpath%" MakeCMRecordGui ../.. %1
