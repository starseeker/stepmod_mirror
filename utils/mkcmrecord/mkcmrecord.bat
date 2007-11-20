set classpath=.;mkcmrecord.jar;lib/saxon8.jar;lib/saxon8-dom.jar;lib/log4j-1.2.14.jar;lib/org-netbeans-lib-cvsclient.jar
set cvsroot=:pserver:anonymous@stepmod.cvs.sourceforge.net:/cvsroot/stepmod
java -Dcvs.root=%cvsroot% -classpath "%classpath%" MakeCMRecordGui ../.. %1
