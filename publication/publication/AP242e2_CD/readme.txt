This directory contains files used to generate a package
for distribution to ISO for publication.

To build the publication package:

1) Add the modules, resources documents, application protocols, and/or business object models to be
   published to: publication_index.xml      

2) Generate the ANT build file using ANT
     ant -buildfile buildbuild.xml

3) CVS tag the repository

4) Run ANT on the build.xml that has just been created:
     ant all
   NOTE - this process will ask for the name of the CVS tag used in stage 3

   This will create a directory:
     stepmod/publication/isopub/AP242e2_CD

5) The HTML for each part to be published will be generated and stored in a
   zip file in: 
     stepmod/publication/isopub/AP242e2_CD/zip/iso<part>.zip
   where <part> is the ISO part number of the part being published.
   These are the files to be sent to ISO
   The complete directory:
    stepmod/publication/isopub/AP242e2_CD
   is also zipped to WG???.zip. This is the file to send to the convener for sign off

