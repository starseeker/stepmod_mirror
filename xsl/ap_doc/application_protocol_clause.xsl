<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!-- last edited by mwd 2002-08-14 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	
	<xsl:template match="/" >
		<xsl:apply-templates select="./application_protocol_clause"/>
	</xsl:template>
	
	<xsl:template match="application_protocol_clause">
    		<xsl:variable name="application_protocol_xml_file" select="concat('../../data/application_protocols/',@directory,'/application_protocol.xml')"/>
		<xsl:variable name="module_xml_file" select="concat('../../data/modules/',@directory,'/module.xml')"/>

    		<HTML>
      			<HEAD>
        			<TITLE>
          				<xsl:apply-templates select="document($application_protocol_xml_file)/application_protocol" mode="title"/>
        			</TITLE>
      			</HEAD>
      			<BODY>
        			<xsl:apply-templates select="document($application_protocol_xml_file)/application_protocol" mode="TOCmultiplePage"/>
				<xsl:apply-templates select="document($application_protocol_xml_file)/application_protocol"/>
				<xsl:apply-templates select="document($module_xml_file)/module"/>
      			</BODY>
    		</HTML>
	</xsl:template>
	
</xsl:stylesheet>
