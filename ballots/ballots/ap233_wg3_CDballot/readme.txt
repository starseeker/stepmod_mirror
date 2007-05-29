This directory contains files used to generate an package
for distribution to SC4 for balloting.

1) Add the modules to be balloted to ballot_index.xml

2) Generate the build file using ANT
     ant -buildfile buildbuild.xml

3) Run ANT on the build.xml that has just been created:
     ant all

   This will create a directory:
     stepmod/ballots/isohtml/ap233_wg3_CDballot

4) Add the EXPRESS files into a separate directory for the ballot process:
   Run stepmod/utils/getBallotExpress.wsf

   This will copy all the arm.exp and mim.exp files from the modules for
   ballot into a directory:
     stepmod/ballots/isohtml/ap233_wg3_CDballot/express

   Each file will be renamed: 
   part<part_no><status>_<wgnumber><mim|arm>.exp
   e.g.
   part1070cdts_wg12n1346mim.exp

   Note: If you want to collect all the EXPRESS files and concatenate them
   into a single file then run:  stepmod/utils/getExpressIr.wsf
   This will take two files as argument, modlist.txt and irlist.txt
   containing a list of the modules (one per line) and the common resource
   schemas (one per line) respectively.
   The script will produce three concatenated files, one containing all the
   arm.exp, one containing all the mim.exp and one containing all the
   mim.exp and the common resources.

5) Create a zip file of the ballot package.
    ant zip

   This will create a zip file:
     stepmod/ballots/isohtml/ap233_wg3_CDballot/ap233_wg3_CDballotyyyymmdd.zip
   where 

6) If the package is being released for team QC review, convener review or
   submission for ballot, a CVS tag should be created.

   First add the name of the tag and a description to
     stepmod/ballots/isohtml/ap233_wg3_CDballot/ap233_wg3_CDballot/ballot_index.xml
   and check in the file.

   The Tag name should be PLCS_ap233_wg3_CDballot_<date>
   where date takes the form yyyymmdd

   Then create the CVS tag. Using WinCVS, select the stepmod directory then

   Modify -> Create Tag on selection
