This directory contains files used to generate an package
for distribution to SC4 for balloting.

1) Add the resource parts to be balloted to ballot_index.xml

2) Generate the build file using ANT
     ant -buildfile buildbuild.xml

3) Run ANT on the build.xml that has just been created:
     ant all

   This will create a directory:
     stepmod/ballots/isohtml/ap233_wg12_IR_CDballot

4) Create a zip file of the ballot package.
    ant zip

   This will create a zip file:
     stepmod/ballots/isohtml/ap233_wg12_IR_CDballot/ap233_wg12_IR_CDballotxxxx.zip
