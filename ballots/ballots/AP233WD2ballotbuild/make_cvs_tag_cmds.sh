#!/bin/sh
# $Id: make_cvs_tag_cmds.sh,v 1.3 2006/07/13 19:06:57 hz0wyg Exp $
#
# $Log: make_cvs_tag_cmds.sh,v $
# Revision 1.3  2006/07/13 19:06:57  hz0wyg
# New strategy, we really only need to tag the whole
# directories of the key parts of the balloted modules
#
# Revision 1.2  2006/06/30 03:24:23  hz0wyg
# Added CVS keywords
#
#
#
#


if [ $# -ne 5 ]
then
	printf "Usage: %s <apname> <ed> <stage> <rev> <stepmod_home>\n" $0
	exit 1
fi
apname=$1
ed=$2
stage=$3
rev=$4
stepmod_home=$5

ballotdir=`pwd | sed 's|'${stepmod_home}'/||'`
dstamp=`date '+%Y%m%d'`

echo "#!/bin/sh" > cvs_tag_cmds.sh
echo "" >> cvs_tag_cmds.sh
printf "TAG=\"ap-%s-%s-%s-%s-%s\"\n" ${apname} ${ed} ${stage} ${rev} ${dstamp} >> cvs_tag_cmds.sh
echo "APDIR=data/application_protocols/${apname}" >> cvs_tag_cmds.sh
echo "CVS_RSH=ssh ; export CVS_RSH" >> cvs_tag_cmds.sh
echo "cd ${stepmod_home}" >> cvs_tag_cmds.sh

cat <<EOF >> cvs_tag_cmds.sh
echo "Tagging xsl and ballot build files"
for dir in xsl ballots/xsl ${ballotdir}
do
	echo "Tagging \$dir"
	cd ${stepmod_home}/\${dir}
	cvs tag -R \${TAG}
	cvs status
done
EOF

for prop in DRESOURCESXML
do
	echo ${prop}
	grep '<property name="'${prop}'"' build.xml | \
	sed 's/\/[_-z]*.xml//g' | \
	awk -F\" '{ printf("echo \"Tagging %s\"\nfor dir in %s\ndo\n\tcd '${stepmod_home}'/${dir}\n\t#cvs tag ${TAG}\n\tcvs status\ndone\n", $2, $4, $4) }' | sed 's/,/ /g' >> cvs_tag_cmds.sh
done

for prop in APDOCS DMODMODULES MODULES
do
	echo ${prop}
	grep '<property name="'${prop}'"' build.xml | \
	sed 's/\/\*\*\/\*.xml//g' | \
	awk -F\" '{ printf("echo \"Tagging %s\"\nfor dir in %s\ndo\n\tcd '${stepmod_home}'/${dir}\n\t#cvs tag ${TAG}\n\tcvs status\ndone\n", $2, $4, $4) }' | sed 's/,/ /g' >> cvs_tag_cmds.sh
done
