$Id: readme.txt,v 1.2 2003/01/23 08:45:43 robbod Exp $
------------------------------------------------------------

This directory contains files used to generate an package
for distribution to SC4 for balloting.

1) Add the modules to be balloted to ballot_index.xml

2) Generate the build file using ANT
     ant -buildfile buildbuild

     Note: this only needs to be done when a new module is added to the
     ballot package.

3) Run ANT on the build.xml that has just been created:
     ant all

   This will create a directory:
     stepmod/ballots/isohtml/plcs_bp3
   

4) Add the EXPRESS files into a separate directory for the ballot process:
   Run stepmod/utils/getBallotExpress.wsf

   This will copy all the arm.exp and mim.exp files from the modules for
   ballot into a directory:
   stepmod/ballots/isohtml/plcs_bp3/express

   Each file will be renamed: 
   part<part_no><status>_<wgnumber><mim|arm>.exp
   e.g.
   part1070cdts_wg12n1346mim.exp

5) Create a zip file of the ballot package.
    ant zip

   This will create a zip file:
     stepmod/ballots/isohtml/plcs_bp3/plcs_bp3xxxx.zip

6) If the package is being released for team QC review, convener review or
   submission for ballot, a CVS tag should be created.

   First add the name of the tag and a description to
   stepmod/ballots/ballots/plcs_bp3/ballot_index.xml
   and check in the file.

   The Tag name should be PLCS_<date>_bc3
   where date takes the form yyyymmdd

   Then create the CVS tag. Using WinCVS, select the stepmod directory then

   Modify -> Create Tag on selection


