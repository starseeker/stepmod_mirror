This directory contains files used to generate a Part 1000 change request package

To build the change request package:

1) Add the modules, resources, or bo models to be published to: publication_index.xml 

2) Generate the ANT build file using ANT
     ant -buildfile buildbuild.xml

3) CVS tag the repository using CR_composites as the tag

4) Run ANT on the build.xml that has just been created:
     ant all
   NOTE - this process will ask for the name of the CVS tag used in stage 3

   This will create a directory:
     stepmod/publication/isopub/CR_composites

5) The HTML for each part to be published will be generated and stored in 
     stepmod/publication/isopub/CR_composites/part1000
   The directory:
     stepmod/publication/isopub/CR_composites/part1000/data/modules
     contains the modules
   The directory:
     stepmod/publication/isopub/CR_composites/part1000/data/resources
     contains the integrated resources schemas referenced by the modules
   The directory:
     stepmod/publication/isopub/CR_composites/part1000/express
     contains the EXPRESS for all the modules and integrated resources schemas.
   The complete directory:
     stepmod/publication/isopub/CR_composites/part1000
   is added to the zip file: 
     stepmod/publication/isopub/CR_composites/CR_composites<YYYYMMDD>.zip
   where <YYYMMDD> is the date of the build.
   The zip file is to be sent to the modules validation team for sign off


To merge the change request into Part1000
1) Check out part1000 to the same directory that contains stepmod
2) Run ANT on the build.xml that has been created in 2) above:
     ant mergePart1000
