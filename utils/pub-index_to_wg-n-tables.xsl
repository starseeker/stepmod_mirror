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
	
	<xsl:output method="text" encoding="UTF-8" indent="no"
		omit-xml-declaration="yes" />
	<!-- INPUT: CR publication_index.xml.
		 OUTPUTS: 3 options
		 1 ) For a plain text listing of the parts in one line 
		 2)  For a plain text listing of the parts with carriage return
		 3)  Produce the list of items in order to request WG12 N numbers of the CR part listed in the selected publication index. 
		 	   Supports modules, resources, resources docs, check lists, and updated modules versus new modules.
	 	4) get all parts with CR id and N numbers to a simple text line
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
	</xsl:for-each>	-->

	
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
	
	<!--3) For WG N number table:-->

	<xsl:value-of
		select="concat(/part1000.publication_index/@name, ' wg.number.publication_set')" />
	<xsl:text>&#xa;</xsl:text>
	<xsl:if test="/part1000.publication_index/modules/module">
	<xsl:value-of
		select="concat(/part1000.publication_index/@name, ' checklist.internal_review for updated modules')" />
	<xsl:text>&#xa;</xsl:text>
	<xsl:value-of
		select="concat(/part1000.publication_index/@name, ' checklist.project_leader for updated modules')" />
	<xsl:text>&#xa;</xsl:text>
	</xsl:if>
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
			<xsl:value-of
				select="concat(/part1000.publication_index/@name, ' checklist.internal_review for new module ', @number)" />
			<xsl:text>&#xa;</xsl:text>
			<xsl:value-of
				select="concat(/part1000.publication_index/@name, ' checklist.project_leader for new module ', @number)" />
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:for-each select="/part1000.publication_index/resource_docs/resource_doc">
		<xsl:value-of
			select="concat('ISO 10303-', @number, ' ed', @version, ' ', @name, ' Document')" />
		<xsl:text>&#xa;</xsl:text>
		<xsl:value-of
			select="concat(/part1000.publication_index/@name, ' checklist.internal_review for IR ', @number)" />
		<xsl:text>&#xa;</xsl:text>
		<xsl:value-of
			select="concat(/part1000.publication_index/@name, ' checklist.project_leader for IR ', @number)" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>
	<xsl:for-each select="/part1000.publication_index/resources/resource">
		<xsl:value-of
			select="concat('ISO 10303-', @number, ' ', @name, ' version ', @version, ' EXPRESS')" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>  

<!-- 4) get all parts with CR id and N numbers to a simple text line 

	<xsl:for-each select="/part1000.publication_index/modules/module">
		<xsl:value-of
			select="concat(/part1000.publication_index/@name, ' ', /part1000.publication_index/@date.iso_submission, ' ISO 10303-', @number, ' ed', @version, ' ', @name, ' Document N', @wg_number)" />
		<xsl:text>&#xa;</xsl:text>
		<xsl:if test="@arm.change = 'y'">
			<xsl:value-of
				select="concat(/part1000.publication_index/@name, ' ', /part1000.publication_index/@date.iso_submission, ' ISO 10303-', @number, ' ed', @version, ' ', @name, ' ARM EXPRESS N', @arm_express_wg_number)" />
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		<xsl:if test="@mim.change = 'y'">
			<xsl:value-of
				select="concat(/part1000.publication_index/@name, ' ', /part1000.publication_index/@date.iso_submission, ' ISO 10303-', @number, ' ed', @version, ' ', @name, ' MIM EXPRESS N', @mim_express_wg_number)" />
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		<xsl:if test="@version = '1'">
			<xsl:value-of
				select="concat(/part1000.publication_index/@name, ' ', /part1000.publication_index/@date.iso_submission, ' ISO 10303-', @number, ' ed', @version, ' ', @name, ' ARM EXPRESS N', @arm_express_wg_number)" />
			<xsl:text>&#xa;</xsl:text>
			<xsl:value-of
				select="concat(/part1000.publication_index/@name, ' ', /part1000.publication_index/@date.iso_submission, ' ISO 10303-', @number, ' ed', @version, ' ', @name, ' MIM EXPRESS N', @mim_express_wg_number)" />
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:for-each select="/part1000.publication_index/resource_docs/resource_doc">
		<xsl:value-of
			select="concat(/part1000.publication_index/@name, ' ', /part1000.publication_index/@date.iso_submission, ' ISO 10303-', @number, ' ed', @version, ' ', @name, ' Document N', @wg_number)" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>
	<xsl:for-each select="/part1000.publication_index/resources/resource">
		<xsl:value-of
			select="concat(/part1000.publication_index/@name, ' ', /part1000.publication_index/@date.iso_submission, ' ISO 10303-', @number, ' ', @name, ' version ', @version, ' EXPRESS N', @wg_number)" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each> -->

</xsl:template>



</xsl:stylesheet>