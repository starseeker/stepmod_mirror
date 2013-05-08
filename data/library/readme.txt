$Id: readme.txt,v 1.2 2012/12/11 19:55:12 thomasrthurman Exp $
resource_doc_list_dir is a new directory created to resolve the issue that there is no one
place for the list of resources modified for a change.
The only contents of resource_doc_list_dir is a list of files named after resource docs.
each file has the list of resource schemas in that doc.
The application will be to iterate over that directory for a specific smrl version.
A document with further details is in construction.

resource_doc_list_dir is duplicated if needed in the local repository where the smrl build occurs.

The build ant file is stepmod/utils/part1000/build.xml.
It uses saxon saxonb9-1-0-2j