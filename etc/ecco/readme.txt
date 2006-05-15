$id:$

** Disclaimer

This package has not been tested much.   I would rate its maturity around alpha 0.1. If you follow the Usage instructions, you will get something. However, the conversion process itself is not tested. Undoubtedly there are typos, errors, and omissions.

** Purpose
This utility converts EXPRESS from PDTec ECCO XML into the stepmod XML EXPRESS format. 

This is a document root produced by ECCO for the pdm schema: 
<iso_10303_28 representation_category="SCHEMA_DECL" version="TS-1">
  <express_schema express_schema_identifier="pdm_schema"
                  express_version="2">

The ECCO file is close to ISO/PDTS 10303-28 XML format per stepmod/dtds/part_28/iso_10303_28_base_arch.dtd. However I had to make a couple of mods to dtd for it to comply.  I believe this format is to  be deprecated after the second edition of Part 28 is published. To find out more about the provenance of iso_10303_28_base_arch.dtd , consult ISO TC184/SC4WG11.

The architecture of this process was borrowed from its neighbor stepmod/etc/graphicalexpress; also a good bit of the code.

The dvlp dir contains
 - Several EXPRESS XML files generated from p11 format by ECCO.
 - iso_10303_28_base_arch.dtd slightly modified to get ECCO to work (search THX).

NOTE test data and stepmod converter were created in 2nd quarter 2005 .

** Usage
 0. Generate or find an ECCO XML EXPRESS file
 1. copy the ECCO XML EXPRESS file to a new file named "model.xml"
 2. iso_10303_28_base_arch.dtd must be in same (folder) as model.xml
 2. click on etc/ecco/utils/ecco2module.wsf
 4. Navigate to (folder)
 5. it will suggest a schema name. This may not be the one you want, if a concatenated file.
 6. keep saying yes or okay.

 7. It will generate the stepmod xml file in 
(folder)/modules/[(schema_name)|"arm"|"mim"]

 8. It will try to copy to appropriate stepmod folder, or create one.

** Issues/notes
 1. Does not do diagrams (if there are any).
 2. Needs more cleaning up, especially to properly dispose of  aic schemas and reference schemas (i.e. non-stepmod).
 3. Some functions in the  .js file is not used, and there are several  entry points from the .wsf file, which perhaps atypically contains more than one function definition.
 4. The conversion is not properly  tested for completeness and correctness.
