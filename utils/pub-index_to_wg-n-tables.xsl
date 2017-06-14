<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:ap="http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/xml-schema/bo_model"
	xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"
	xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:bom="http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/xml-schema/bo_model"
	xmlns:html="http://www.w3.org/TR/REC-html40" exclude-result-prefixes="fo xsd fn">
	<xsl:output method="text" encoding="UTF-8" indent="no"
		omit-xml-declaration="yes" />
	<!-- INPUT: CR publication_index.xml.
		 OUTPUTS: 3 options
		 1 )To be completed
		 2) To be completed 
		 3)WG12 N numbers of the CR part list as plain text, which can be used to produce the excel table 
		 
		 
		 Next update: consider resources and resource docs) 
		 
		 
		 ##### IMPORTANT NOTE: FOR NEW MODULE (ED1) arm and mim are set as "n" for their changes - so it will not create a line to get a WG numbers !! 
		 
		 -->

	<xsl:template match="/">


<!--1) For a plain text listing of the parts in one line : 	
	<xsl:for-each select="/part1000.publication_index/modules/module">
		<xsl:value-of select="concat(@name, ' ')" />
	</xsl:for-each>
	<xsl:for-each select="/part1000.publication_index/resource_docs/resource_doc">
		<xsl:value-of select="concat(@name, ' ')" />
	</xsl:for-each>
	<xsl:for-each select="/part1000.publication_index/resources/resource">
		<xsl:value-of select="concat(@name, ' ')" />
	</xsl:for-each>
-->
	
<!--2)  For a plain text listing of the parts with carriage return :
	
	<xsl:for-each select="/part1000.publication_index/modules/module">
		<xsl:value-of select="@name" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>
	<xsl:for-each select="/part1000.publication_index/resource_docs/resource_doc">
		<xsl:value-of select="@name" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>
	<xsl:for-each select="/part1000.publication_index/resources/resource">
		<xsl:value-of select="@name" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>	 -->
	
	<!--3) For WG N number table : (AP Modules, Resources and resource docs not supported yet) --> 
	<xsl:for-each select="/part1000.publication_index/modules/module">		
		<xsl:value-of
			select="concat('ISO 10303-', @number, ' ed', @version, ' ', @name, ' Document')" />
		<xsl:text>&#xa;</xsl:text>
		<xsl:if test="@arm.change = 'y'">
			<xsl:value-of
				select="concat('ISO 10303-', @number, ' ed', @version, ' ', @name, ' ARM EXPRESS')" />
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		<xsl:if test="@mim.change = 'y'">
			<xsl:value-of
				select="concat('ISO 10303-', @number, ' ed', @version, ' ', @name, ' MIM EXPRESS')" />
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		<xsl:if test="@version = '1'">
			<xsl:value-of
				select="concat('ISO 10303-', @number, ' ed', @version, ' ', @name, ' ARM EXPRESS')" />
			<xsl:text>&#xa;</xsl:text>
			<xsl:value-of
				select="concat('ISO 10303-', @number, ' ed', @version, ' ', @name, ' MIM EXPRESS')" />
			<xsl:text>&#xa;</xsl:text>
		</xsl:if> 
	</xsl:for-each>
	

</xsl:template>



</xsl:stylesheet>