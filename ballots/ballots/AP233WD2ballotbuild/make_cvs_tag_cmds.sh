#!/bin/sh

if [ $# -ne 6 ]
then
	printf "Usage: %s <prop_names_list> <apname> <ed> <stage> <rev> <stepmod_home>\n" $0
	exit 1
fi
prop_list=$1
apname=$2
ed=$3
stage=$4
rev=$5
stepmod_home=$6

dstamp=`date '+%Y%m%d'`

echo "#!/bin/sh" > cvs_tag_cmds.sh
echo "" >> cvs_tag_cmds.sh
printf "TAG=\"ap-%s-%s-%s-%s-%s\"\n" ${apname} ${ed} ${stage} ${rev} ${dstamp} >> cvs_tag_cmds.sh
echo "APDIR=application_protocols/${apname}" >> cvs_tag_cmds.sh
echo "CVS_RSH=ssh ; export CVS_RSH" >> cvs_tag_cmds.sh
echo "cd ${stepmod_home}" >> cvs_tag_cmds.sh

for prop in `cat ${prop_list}`
do
	echo ${prop}
	grep '<property name="'${prop}'"' build.xml | sed 's/\/\*\*//g' | awk -F\" '{ printf("cvs tag ${TAG} %s\n", $4) }' | sed 's/,/ /g' >> cvs_tag_cmds.sh
done
