<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./pas_document_xsl.xsl" ?>
<!--
	$Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="html"/>
	
	<xsl:template match="/">
		<html>
			<body bgcolor="#FFFFFF">
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="conformance_classes">
	
	 	<p>
			This application protocol provides for a number of options that may be supported by an implementation.
		</p>
		<p>
			These options have been grouped into the following conformance classes:
		</p>	
		<ul>
			<xsl:for-each select="cc">
				<li>
	        			<xsl:choose>
	          				<xsl:when test="position()!=last()">
	           					<xsl:value-of select="concat(@name,';')"/>
	          				</xsl:when>
	          				<xsl:otherwise>
	            					<xsl:value-of select="concat(@name,'.')"/>        
	          				</xsl:otherwise>
	        			</xsl:choose>
	      			</li>
			</xsl:for-each>
	  	</ul>
		<p>
			Support for a particular conformance class requires support of all the options specified in that class.
		</p>
		
		<xsl:variable name="arm_or_aim_element">
			<xsl:choose>
				<xsl:when test="cc/arm_entities">
					application
				</xsl:when>
				<xsl:otherwise>
					AIM
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<p>Conformance to a particular class requires that all <xsl:value-of select="$arm_or_aim_element"/> elements defined as part of that class be supported.  The conformance class elements table (below) defines the classes to which each <xsl:value-of select="$arm_or_aim_element"/> element belongs.</p>
	
		<xsl:for-each select="cc">
			<!-- xsl:sort select="./@name"/ -->
			<h4>6.<xsl:value-of select="position()"/> <xsl:value-of select="concat(' Class ', ./@identifier, ': ', ./@name)"/></h4>
			<p><xsl:value-of select="./description"/></p>
			<xsl:apply-templates select="note"/>
			<xsl:apply-templates select="example"/>
			<p>The following UoFs are fully or partly covered by this conformance class:</p>
			
			<ul>
			<xsl:for-each select="uofs/uof">
				<xsl:sort select="./@name"/>
				<xsl:variable name="href" select="concat('4_info_reqs.xml#uof', ./@name)"/>
				<li>
				 <a href="{$href}">
	        			<xsl:choose>
	          				<xsl:when test="position()!=last()">
	           					<xsl:value-of select="concat(@name,';')"/>
	          				</xsl:when>
	          				<xsl:otherwise>
	            					<xsl:value-of select="concat(@name,'.')"/>        
	          				</xsl:otherwise>
	        			</xsl:choose>
				</a>
	      			</li>
			</xsl:for-each>
	  	</ul>
			
		</xsl:for-each>
		
		<h4>Conformance class elements table</h4>
		<xsl:variable name="no_of_ccs" select="count(cc)"/>
		<table border="1">
			<tr>
				<th rowspan="2">
					<xsl:value-of select="$arm_or_aim_element"/> element
				</th>
				<th colspan="{$no_of_ccs}">
					Class
				</th>
			</tr>
			<tr>
				<xsl:for-each select="cc">
					<td>
						<xsl:value-of select="./@identifier"/>
					</td>
				</xsl:for-each>					
			</tr>
			<xsl:for-each select="cc/arm_entities/cc.ae[not(./@entity=preceding::cc.ae/@entity)]">
				<xsl:sort select="@entity"/>
				<xsl:variable name="entity_name">
					<xsl:value-of select="./@entity"/>
				</xsl:variable>
				<tr>
					<td>
						<xsl:value-of select="$entity_name"/>
					</td>
					<xsl:for-each select="../../../cc">
						<xsl:choose>
							<xsl:when test="./arm_entities/cc.ae/@entity=$entity_name">
								<td>X</td>
							</xsl:when>
							<xsl:otherwise>
								<td>&#160;</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>

</xsl:template>

</xsl:stylesheet>
