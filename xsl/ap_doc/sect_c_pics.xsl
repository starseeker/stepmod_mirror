<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	 <xsl:output method="html"/>
	<xsl:template match="application_protocol">
		<a name="pics"/>
		<xsl:call-template name="annex_header">
    			<xsl:with-param name="annex_no" select="'C'"/>
    			<xsl:with-param name="heading" select="'Protocol Implementation Conformance Statement (PICS)'"/>
    			<xsl:with-param name="aname" select="'annexc'"/>
			<xsl:with-param name="informative" select="'normative'"/>
		</xsl:call-template>
		<xsl:variable name="schema_name" select="@name"/>
		<xsl:variable name="iso_no" select="@std_no"/>	
		 <p>
			This clause list the optional elements of this part of ISO 10303.  An implementation may choose to support any combination of these optional elements.  However, certain combinations of options are likely to be implemented together.  These combinations are called conformance classes and are described in the subclauses of this annex.
		</p>
		<p>
			This annex is in the form of a questionnaire.  This  questionnaire is intended to be filed in by the implementor and may be used in preparation for conformance testing by a testing laboratory.  The completed PICS form is referred to as a "PICS".
		</p>
		<h4>D.1 Protocol implementation identification</h4>
		<table border="1">
			<tr>
				<th align="left">
					ISO PAS <xsl:value-of select="$iso_no"/> implementation name
				</th>
				<td>
					&#160; &#160; &#160; &#160;
					&#160; &#160; &#160; &#160;
					&#160; &#160; &#160; &#160;
					&#160; &#160; &#160; &#160;
					&#160; &#160; &#160; &#160;
					&#160; &#160; &#160; &#160;
					&#160; &#160; &#160; &#160;
					&#160; &#160; &#160; &#160;
					&#160; &#160; &#160; &#160;
					&#160; &#160; &#160; &#160;
				</td>
			</tr>
			<tr>
				<th align="left">
					Current version and release date
				</th>
				<td>
				     &#160;
				</td>
			</tr>
		</table>
		<h4>D.2 Implementation method</h4>
		<p>
			Indicate the chosen implementation method and supported directions of translation.
		</p>
		<p>
			If more than one implementation method is supported, a separate PICS form is to be filled in for each of them.
		</p>
		<table border="1">
			<tr>
				<th align="left">
					Implementation Method
				</th>
				<th align="left">
					Preprocessor
				</th>
				<th align="left">
					Postprocessor
				</th>
			</tr>
			<xsl:for-each select="imp_meths/imp_meth">
				<tr>
					<th align="left">
						ISO 10303 - <xsl:value-of select="@part"/>
					</th>
					<td>
						&#160;			</td>
					<td>
						&#160;			</td>
				</tr>
			</xsl:for-each>
		</table>
		<h4>D.3 Implemented conformance classes</h4>
		<table border="1">
			<tr>
				<th align="left">Conformance class</th>
				<th>Preprocessor</th>
				<th>Postprocessor</th>
			</tr>
			<xsl:for-each select="document		('../../data/application_protocols/nut_and_bolt/ccs.xml')/conformance_classes/cc">
			<!-- xsl:sort select="@name"/ -->
			<tr>
				<td align="left">
					<xsl:value-of select="concat(@name, ' (CC', @identifier, ')')"/>
				</td>
				<td>
						&#160;			
				</td>
				<td>
						&#160;			
				</td>
			</tr>
		</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>
