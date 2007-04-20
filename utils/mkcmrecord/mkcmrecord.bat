set saxon=%SAXON_HOME%
set classpath=.;mkcmrecord.jar;%saxon%/saxon8.jar;%saxon%/saxon8-dom.jar
java -classpath "%classpath%" MakeCMRecordGui ../.. %1
