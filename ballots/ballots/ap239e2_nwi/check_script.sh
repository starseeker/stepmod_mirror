# Script for running each module in turm
MODULE=$1

echo "************************************************************"
echo "Checking $MODULE/sys/5_mapping.htm"
java -jar c:/apps/saxon6-5-5/saxon.jar -a -o  C:/Users/rbn/Documents/sforge/stepmod/data/modules/$MODULE/sys/5_mapping.htm C:/Users/rbn/Documents/sforge/stepmod/data/modules/$MODULE/sys/5_mapping.xml 
echo "--"
echo "Checking $MODULE/nav/mapping_view.htm"
java -jar c:/apps/saxon6-5-5/saxon.jar -a -o C:/Users/rbn/Documents/sforge/stepmod/data/modules/$MODULE/nav/mapping_view.htm C:/Users/rbn/Documents/sforge/stepmod/data/modules/$MODULE/nav/mapping_view.xml 
echo "--"
echo "checkModuleBatch $MODULE"
cd c:/Users/rbn/Documents/sforge/stepmod/utils/
cscript //nologo checkModuleBatch.wsf activity_as_realized

