<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_pics.xsl,v 1.3 2003/06/11 08:26:54 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="module"/>
	
	<xsl:template match="application_protocol">
		<a name="pics"/>
		<xsl:call-template name="annex_header">
    			<xsl:with-param name="annex_no" select="'D'"/>
    			<xsl:with-param name="heading" 
                          select="'Protocol Implementation Conformance Statement (PICS) form'"/>
    			<xsl:with-param name="aname" select="'annexd'"/>
			<xsl:with-param name="informative" select="'normative'"/>
		</xsl:call-template>
		<xsl:variable name="ap_name" select="@name"/>
		<xsl:variable name="iso_no" select="@std_no"/>	
		 <p>
			This clause lists the optional elements of this part of ISO 10303. 
			An implementation may choose to support any combination of these optional elements.  However, certain combinations of options are likely to be implemented together.  These combinations are called conformance classes and are described in the subclauses of this annex.
		</p>
		<p>
			This annex is in the form of a questionnaire. 
			This  questionnaire is intended to be filled out by an implementor and may be used in preparation for conformance testing by a testing laboratory.  The completed PICS form is referred to as a "PICS".
		</p>
		<h2>D.1 Protocol implementation identification</h2>
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
		<h2>D.2 Implementation method</h2>
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
       <xsl:if test="@general!='y'">
				<tr>
					<th align="left">
						ISO 10303 - <xsl:value-of select="@part"/>
					</th>
					<td>
						&#160;			</td>
					<td>
						&#160;			</td>
				</tr>
				</xsl:if>
			</xsl:for-each>
		</table>
		<h2>D.3 Implemented conformance classes</h2>
		<table border="1">
			<tr>
				<th align="left">Conformance class</th>
				<th>Preprocessor</th>
				<th>Postprocessor</th>
			</tr>
			<xsl:for-each select="document(concat('../../data/application_protocols/', $ap_name, '/ccs.xml'))/conformance/cc">
				<tr>
					<td align="left">
						<xsl:value-of select="concat(@name, ' (', @id, ')')"/>
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
