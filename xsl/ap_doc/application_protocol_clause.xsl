<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: application_protocol_clause.xsl,v 1.6 2003/03/03 17:15:19 goset1 Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../module_clause.xsl"/>
	
	<xsl:template match="/" >
		<xsl:apply-templates select="./application_protocol_clause"/>
	</xsl:template>
	
	<xsl:template match="application_protocol_clause">
    <xsl:variable name="application_protocol_xml_file" 
				select="concat('../../data/application_protocols/',@directory,'/application_protocol.xml')"/>
		<xsl:variable name="module_xml_file" 
				select="concat('../../data/modules/',@module_directory,'/module.xml')"/>
		
    		<html>
      	<head>
        <title>
         <xsl:apply-templates 
						select="document($application_protocol_xml_file)/application_protocol" mode="title"/>
        </title>
      	</head>
      	<body>
				
        <xsl:apply-templates select="document($application_protocol_xml_file)/application_protocol" mode="TOCmultiplePage"/>
				<xsl:apply-templates select="document($application_protocol_xml_file)/application_protocol"/>

				<xsl:apply-templates select="document($module_xml_file)/module"/>

      	</body>
    		</html>
	</xsl:template>

</xsl:stylesheet>
