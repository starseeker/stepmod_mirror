This set of utilities adds EXPRESS header and SCHEMA asn.1 info to an existing resource schema
based on source data found in resource_docs/<resourcename>/resource.xml

It operates on all resource schemas listed in buildbuildcopyright.xml
execute ant -f buildbuildcopyright.xml
execute ant build.xml

The build can be run on the updated schema files also, so if the copyright text changes or the N numbers or versions
 etc are updated, the process can be repeated using schemas that have the copyright and info object id text in them.
 One of the original design intents was that the process could be re-used on the updated express. 
 While this hasn’t thoroughly tested it, it appears to work.
 When needed, it can be verified.
