
** Files

 - These are xsd specific   stepmod "sys"-like files for the schemas in xsd folder

plmxmlannotationschema.xml
plmxmlschema.xml

Create stepmod EXPRESS xml by running saxon.  They will display in IE but not what you want.

 $ saxon -a -o plmxmlschemaEXPRESS.xml plmxmlschema.xml

 - These are the outputs in stepmod EXPRESS XML format
plmxmlannotationschemaEXPRESS.xml
plmxmlschemaEXPRESS.xml


 - test query. Not really working yet, except as used in sys files. 
xsdquery.xml


xsl
xsd

- for emax nxml mode convenience
schemas.xml

** Usage

 1. put schema in xsd folder, in a file named after the xsd schema
 2. create new file in sys folder , change the query schema attr to new schema
 3. run saxon as above
 4. view output in IE.
 5. copy/paste text displayed in IE  into .exp file 