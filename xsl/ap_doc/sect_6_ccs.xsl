<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_1_scope.xsl,v 1.0 2002-07-15 19:50:08 mwd Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output the Conformance class section as a web page
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:import href="cc_descriptions.xsl"/>
  
	<xsl:output method="html"/>

	<!-- overwrites the template declared in module.xsl -->
	<xsl:template match="application_protocol">
		<xsl:call-template name="clause_header">
			<xsl:with-param name="heading" select="'6 Conformance requirements'"/>
			<xsl:with-param name="aname" select="'ccs'"/>
		</xsl:call-template>
		Conformance to this application protocol includes satisfying the requirements stated in this specification, the requirements of the implementation method(s) supported and the relevant requirements of the normative references.  An implementation shall support at least one of the following implementation methods:
		<ul>
			<xsl:for-each select="imp_meths/imp_meth">
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
			</xsl:for-each>
		</ul>
		
		<p>Requirements with respect to implementation methods-specific requirements are specified in annex B.</p>
The Protocol Implementation Conformance Statement (PICS) form lists the options or the combinations of options that may be included in the implementation.  This PICS form is provided in annex C.


		<xsl:variable name="ap_dir">
			<xsl:value-of select="@name"/>
		</xsl:variable>

		<xsl:variable name="ccs_path">
			<xsl:value-of select="concat('../../data/application_protocols/', $ap_dir, '/ccs.xml')"/>
		</xsl:variable>

		<xsl:apply-templates select="document(string($ccs_path))/conformance_classes"/>
		
	</xsl:template>
  
</xsl:stylesheet>
