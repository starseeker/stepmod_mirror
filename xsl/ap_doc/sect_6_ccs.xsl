<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: sect_6_ccs.xsl,v 1.5 2003/02/08 21:33:08 goset1 Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:import href="cc_descriptions_2.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="module"/>
	
	<xsl:template match="application_protocol">
		<xsl:call-template name="clause_header">
			<xsl:with-param name="heading" select="'6 Conformance requirements'"/>
			<xsl:with-param name="aname" select="'ccs'"/>
		</xsl:call-template>
				
		<xsl:variable name="annB" select="concat('./b_imp_meth',$FILE_EXT)"/>
		Conformance to this application protocol includes satisfying the requirements stated in this specification, 
		the requirements of the implementation method(s) supported and the relevant requirements of the normative references.  
		<p>A conforming implementation shall support at least one of the following implementation methods:</p>
		<ul>
			<xsl:for-each select="imp_meths/imp_meth">
       <xsl:if test="@general!='y'">
				<li>

        		<xsl:choose>
          			<xsl:when test="position()!=last()">
           			<xsl:value-of select="concat('ISO 10303-', @part,';')"/>
          			</xsl:when>
          	<xsl:otherwise>
            		<xsl:value-of select="concat('ISO 10303-', @part,'.')"/>        
          	</xsl:otherwise>
        		</xsl:choose>
      		</li>
       </xsl:if>
			 </xsl:for-each>
		</ul>
		<note>
			Implementation methods-specific requirements are specified in <a href="{$annB}">
annex B</a>.
		</note>

		<xsl:variable name="ap_dir">
			<xsl:value-of select="@name"/>
		</xsl:variable>
		<xsl:variable name="ccs_path">
			<xsl:value-of select="concat('../../data/application_protocols/', $ap_dir, '/ccs.xml')"/>
		</xsl:variable>
		<xsl:apply-templates select="document(string($ccs_path))/conformance_classes"/>

	</xsl:template>
</xsl:stylesheet>
