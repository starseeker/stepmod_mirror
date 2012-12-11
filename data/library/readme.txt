$Id:$
resource_doc_list_dir is a new directory created to resolve the issue that there is no one
place for the list of resources modified for a change.
The only contents of resource_doc_list_dir is a list of files named after resource docs.
each file has the list of resource schemas in that doc.
The application will be to iterate over that directory for a specific smrl version.
A document with further details is in construction.