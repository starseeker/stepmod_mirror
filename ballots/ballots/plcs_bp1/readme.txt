This directory contains files used to generate a package
for distribution to SC4 for balloting.

1) Add the modules to be balloted to ballot_index.xml

2) Generate the build file using ANT
   ant -buildfile buildbuild.xml

3) Run ANT on the build.xml that has just been created:
     ant all

   This will create a directory:
     stepmod/ballots/isohtml/plcs_bp1

4) Create a zip file of the ballot package.
    ant zip

   This will create a zip file:
     stepmod/ballots/isohtml/plcs_bp1/plcs_bp1xxxx.zip


------------------------------------------------------------
To generate the express

1) run stepmod\utils\getExpress.wsf

   pass stepmod/ballots/ballots/plcs_bp1/modlist.txt as argument.

   This will create a directory of the express files of the modules listed
   in modlist.txt