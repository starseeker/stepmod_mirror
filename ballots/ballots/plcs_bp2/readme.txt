This directory contains files used to generate an package
for distribution to SC4 for balloting.

1) Add the modules to be balloted to ballot_index.xml

2) Generate the build file using ANT
     ant -buildfile buildbuild

3) Run ANT on the build.xml that has just been created:
     ant all

   This will create a directory:
     stepmod/ballots/isohtml/plcs_bp2

4) Create a zip file of the ballot package.
    ant zip

   This will create a zip file:
     stepmod/ballots/isohtml/plcs_bp2/plcs_bp2xxxx.zip
