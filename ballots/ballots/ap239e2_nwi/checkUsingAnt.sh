#
# 
#
MODULE=$1

cd c:/Users/rbn/Documents/sforge/stepmod/utils

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "$MODULE"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/$MODULE clean_module
ant -emacs -q -DMODULES=data/modules/$MODULE modules
ant -emacs -q -DMODULES=data/modules/$MODULE mapping
#ant -emacs -q -DMODULESDIR=data/modules/$MODULE valid_modules
cscript //nologo checkModuleBatch.wsf $MODULE
echo "end: $MODULE"
