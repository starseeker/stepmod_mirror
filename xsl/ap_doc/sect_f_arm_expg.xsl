<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_f_arm_expg.xsl,v 1.0 2002-07-16 09:22:41 mwd Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="application_protocol.xsl"/>
	
	<!-- the stylesheet that allows different stylesheets to be applied -->
	
	<xsl:import href="application_protocol_clause.xsl"/>
	
	<xsl:output method="html"/>
	
	<!-- overwrites the template declared in module.xsl -->
	
	<xsl:template match="application_protocol">
		<xsl:call-template name="annex_header">
			<xsl:with-param name="annex_no" select="'F'"/>
			<xsl:with-param name="heading" select="'ARM EXPRESS-G'"/>
			<xsl:with-param name="aname" select="'annexf'"/>
		</xsl:call-template>
	
		<p>
			The following diagrams provide a graphical representation of the EXPRESS structure and constructs specified in clause 4. The 	diagrams are presented in EXPRESS-G.
		</p>
		<p>
			This annex contain two distinct representations of the Application Reference Model of this part of ISO 10303:
		</p>
		<ul>
			<li>
				a schema level representation which depicts the import of the constructs defined in the ARM schemas of the application modules through USE FROM statements;
			</li>
			<li>
				an entity level representation which presents the Express constructs imported from the ARM schemas of the application modules.
			</li>
		</ul>
		<p>The EXPRESS-G  graphical notation is defined in annex D of ISO 10303-11.</p>
		<a name="armexpg"/>
			<xsl:apply-templates select="arm/express-g"/>
		</xsl:template>
</xsl:stylesheet>
