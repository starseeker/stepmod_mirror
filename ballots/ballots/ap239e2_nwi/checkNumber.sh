#
MODULE=$1

cd c:/Users/rbn/Documents/sforge/stepmod/utils

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "$MODULE"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
cscript //nologo checkModuleBatch.wsf $MODULE
echo "end: $MODULE\n"
