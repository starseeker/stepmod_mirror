$Id: readme.txt,v 1.4 2001/06/29 18:45:27 lubell Exp $

The module repository is organized as follows:

dtd/
Contains the repository DTD files
 
xsl/
Contains everything pertaining to transforming the XML to HTML
and possibly other formats such as PDF. This would include XSLT and
CSS stylesheets.

data/
XML data for the module repository. The directory structure is similar
to that of the module web.

dtd/module.dtd
The DTD's system idenfifier. The root element is "module".

dtd/arm.ent
Markup declarations for the units of functionality, application
objects, and mapping specification.

dtd/common.ent
Markup declarations used throughout the DTD.

dtd/language.ent
Markup declarations for EXPRESS code.

dtd/refs-and-defs.ent
Markup declarations for normative references, terms, definitions, and
abbreviations.

dtd/text.ent
Markup declarations for descriptive text, notes, examples, figures,
etcetera.

data/basic/
Contains boilerplate XML document fragments common to all modules.

data/applobj
Contains application object data

data/appltype
Contains application types

data/mapping
Contains application entity mappings

data/[module-name]/
Contains files specific to the module [module-name] include XML data,
express-g graphics, etc.
