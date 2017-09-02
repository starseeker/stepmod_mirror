<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:ap="http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/xml-schema/bo_model"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:bom="http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/xml-schema/bo_model"
	xmlns:html="http://www.w3.org/TR/REC-html40" 
	exclude-result-prefixes="fo xsd fn">
	
	<xsl:output 
		method="text" 
		encoding="UTF-8" 
		indent="no"
		omit-xml-declaration="yes" />
	
	<!-- INPUT: CR publication_index.xml.
	
		Extract list of parts from a cr publication index to a plain text listing of the parts in one line for cvs update command line 
		
		 		 -->

	<xsl:template match="/">


	<xsl:for-each select="/part1000.publication_index/modules/module">
		<xsl:value-of select="concat('data/modules/', @name, ' ')" />
	</xsl:for-each>
	<xsl:for-each select="/part1000.publication_index/resource_docs/resource_doc">
		<xsl:value-of select="concat('data/resource_docs/', @name, ' ')" />
	</xsl:for-each>
	<xsl:for-each select="/part1000.publication_index/resources/resource">
		<xsl:value-of select="concat('data/resources/', @name, ' ')" />
	</xsl:for-each>

	


</xsl:template>



</xsl:stylesheet>