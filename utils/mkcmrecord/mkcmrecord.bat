set saxon=%SAXON_HOME%
set classpath=.;mkcmrecord.jar;%saxon%/saxon8.jar;%saxon%/saxon8-dom.jar;c:/software/logging-log4j-1.2.14/dist/lib/log4j-1.2.14.jar
java -classpath "%classpath%" MakeCMRecordGui ../.. %1
