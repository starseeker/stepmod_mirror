This directory contains files used to generate an package
for distribution to SC4 for balloting.

1) Add the modules to be balloted to ballot_index.xml

2) Generate the build file using ANT
     ant -buildfile buildbuild

3) Run ANT on the build.xml that has just been created:
     ant all

   This will create a directory:
     stepmod/ballots/isohtml/plcs_bp4

3) Run ant on plcs_bp4_dependencies then copy

    cp -rf ../../isohtml/plcs_bp4_dependencies/data/modules/* ../../isohtml/plcs_bp4/data/modules/
    cp -rf ../../isohtml/plcs_bp4_dependencies/data/resources/* ../../isohtml/plcs_bp4/data/resources/

4) Add the EXPRESS files into a separate directory for the ballot process:
   Run stepmod/utils/getBallotExpress.wsf

   This will copy all the arm.exp and mim.exp files from the modules for
   ballot into a directory:
   stepmod/ballots/isohtml/plcs_bp4/express

   Each file will be renamed: 
   part<part_no><status>_<wgnumber><mim|arm>.exp
   e.g.
   part1070cdts_wg12n1346mim.exp

5) Create a zip file of the ballot package.
    ant zip

   This will create a zip file:
     stepmod/ballots/isohtml/plcs_bp4/plcs_bp4xxxx.zip

6) If the package is being released for team QC review, convener review or
   submission for ballot, a CVS tag should be created.

   First add the name of the tag and a description to
   stepmod/ballots/ballots/plcs_bp4/ballot_index.xml
   and check in the file.

   The Tag name should be PLCS_<date>_bc4
   where date takes the form yyyymmdd

   Then create the CVS tag. Using WinCVS, select the stepmod directory then

   Modify -> Create Tag on selection


