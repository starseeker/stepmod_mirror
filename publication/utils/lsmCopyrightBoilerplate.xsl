<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
$Id:  $
  Author:  J Chris Johnson, Lockheed Martin
  Owner:   StepMod
  Purpose:
     Boilerplate copyright code for EXPRESS schema header. Import as required.
-->

<xsl:template name="theCopyrightExpressSchemaHeader">
		<xsl:param name="theFullNameAndSchemaTitle"/>
		<xsl:text>&#xA;<![CDATA[EXPRESS Source:]]>&#xA;</xsl:text>
		<xsl:value-of select="$theFullNameAndSchemaTitle"/>
		<xsl:text>&#xA;&#xA;<![CDATA[The following permission notice and disclaimer shall be included in all copies of this EXPRESS schema ("the Schema"), 
and derivations of the Schema:

Copyright ISO 2014  All rights reserved
Permission is hereby granted, free of charge in perpetuity, to any person obtaining a copy of the Schema,
to use, copy, modify, merge and distribute free of charge, copies of the Schema for the purposes of developing, 
implementing, installing and using software based on the Schema, and to permit persons to whom the Schema is furnished to do so, 
subject to the following conditions:

THE SCHEMA IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SCHEMA OR THE 
USE OR OTHER DEALINGS IN THE SCHEMA.

In addition, any modified copy of the Schema shall include the following notice:

THIS SCHEMA HAS BEEN MODIFIED FROM THE SCHEMA DEFINED IN]]>&#xA;</xsl:text>
		<xsl:value-of select="$theFullNameAndSchemaTitle"/>
		<xsl:text>&#xA;<![CDATA[AND SHOULD NOT BE INTERPRETED AS COMPLYING WITH THAT STANDARD]]>&#xA;</xsl:text>
</xsl:template>

</xsl:stylesheet>
