$Id: readme.txt,v 1.5 2004/07/07 14:27:01 rocc Exp $

The module repository is organized as follows::

dtd/
Contains the repository DTD files

etc/
Contains extra files which may be useful for repository developers
Typically these are files for specific development tools.

etc/emacs
Emacs customization files that provide usefule menus 
 
xsl/
Contains everything pertaining to transforming the XML to HTML
and possibly other formats such as PDF. This would include XSLT and
CSS stylesheets.

data/
XML data for the module repository. The directory structure is similar
to that of the module web.

dtd/module.dtd
The DTD's system idenfifier. The root element is "module".

dtd/mapping.ent
Markup declarations for the units of functionality, application
objects, and mapping specification.

dtd/express.dtd
Markup declarations for EXPRESS code.

dtd/refs-and-defs.ent
Markup declarations for normative references, terms, definitions, and
abbreviations.

dtd/text.ent
Markup declarations for descriptive text, notes, examples, figures,
etcetera.

data/basic/
Contains boilerplate XML document fragments common to all modules.

data/[module-name]/
Contains files specific to the module [module-name] including XML
data, express-g graphics, etc.



