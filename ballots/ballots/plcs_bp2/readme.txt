This directory contains files used to generate an package
for distribution to SC4 for balloting.

1) Add the modules to be balloted to ballot_index.xml

2) Generate the build file using ANT
     ant -buildfile buildbuild.xml

3) Run ANT on the build.xml that has just been created:
     ant all

   This will create a directory:
     stepmod/ballots/isohtml/plcs_bp2

3) Run ant on plcs_bp2_dependencies then copy

    cp -rf ../../isohtml/plcs_bp2_dependencies/data/modules/* ../../isohtml/plcs_bp2/data/modules/
    cp -rf ../../isohtml/plcs_bp2_dependencies/data/resources/* ../../isohtml/plcs_bp2/data/resources/

4) Create a zip file of the ballot package.
    ant zip

   This will create a zip file:
     stepmod/ballots/isohtml/plcs_bp2/plcs_bp2xxxx.zip

------------------------------------------------------------
To generate the EXPRESS

1) run stepmod\utils\getExpressIr.wsf

   pass the list of modules and Integrated Resources whose EXPRESS is to be
   concatenate as argument:
   stepmod/ballots/ballots/plcs_bp2/modlist.txt
   stepmod/ballots/ballots/plcs_bp2/irlist.txt


   This will create a directory of the EXPRESS files of the modules listed
   in modlist.txt

   The concatenated EXPRESS of the module will be:
     ARM:                    stepmod/ballots/ballots/plcs_bp2/express/arm/arm_xxxx.exp
     MIM+Resource EXPRESS:   stepmod/ballots/ballots/plcs_bp2/express/arm/mim_resources_xxxx.exp

   where xxxx is the date.


------------------------------------------------------------   
To validate the HTML

1) build plcs_bp2
 This will create isohtml/plcs_bp2

------------------------------------------------------------
