<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: aam_descriptions.xsl,v 1.11 2003/07/28 12:32:41 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.0">

  <xsl:output method="html"/>
  
  <!-- no longer only display AAM
       <xsl:template match="/">
         <html>
           <body bgcolor="#FFFFFF">
             <xsl:apply-templates/>
           </body>
         </html>
       </xsl:template> -->

	
  <xsl:template match="idef0">

    <xsl:variable name="application_protocol_xml_file" 
      select="concat('../../data/application_protocols/',@application_protocol,'/application_protocol.xml')"/>

    <xsl:variable name="apdoc_ok">
      <xsl:call-template name="check_application_protocol_exists">
        <xsl:with-param name="application_protocol" select="@application_protocol"/>
      </xsl:call-template>
    </xsl:variable>


    <xsl:variable name="application_protocol_xml" 
      select="document($application_protocol_xml_file)"/>

    <xsl:if test="$apdoc_ok!='true'">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error AAM1:', $apdoc_ok,' Correct idef0@application_protocol in aam.xml')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>


    <p>The viewpoint is that of <xsl:value-of select="viewpoint"/>.</p>    
    <h2>
      <a name="activity_defn">
        F.1 Application activity model definitions
      </a>
    </h2>
    <p>
      The following terms are used in the application activity model.  Terms
      marked with an asterisk are outside the scope of this application
      protocol.
    </p>
    <p>
      The definitions given in this annex do not supersede the definitions
      given in the main body of the text.
    </p>
    <xsl:for-each select="./page/activity|./icoms/icom">
      <xsl:sort select="normalize-space(./name)"/>
      <xsl:variable name="asterisk"><xsl:if test="@inscope='no'">*</xsl:if></xsl:variable>
      <xsl:variable name="aname">
        <xsl:value-of select="translate(normalize-space(./name),' ','_')"/>
      </xsl:variable>
      <h2>
        <a name="{$aname}">
          F.1.<xsl:value-of select="position()"/>
        </a>
        <xsl:value-of select="concat(' ', normalize-space(./name),$asterisk)"/>
        <xsl:if test="name(.)='activity'">
          <xsl:if test="$apdoc_ok='true'">
            <!-- this could be more efficient --> 
            <xsl:variable name="page" select="number(../@number)"/>
            <xsl:variable name="imgfile">
              <xsl:value-of 
                select="$application_protocol_xml/application_protocol/aam/idef0/imgfile[$page]/@file"/>
            </xsl:variable>
            <xsl:variable name="href">
              <xsl:call-template name="set_file_ext">
                <xsl:with-param name="filename" select="$imgfile"/>
              </xsl:call-template>
            </xsl:variable>
            &#160;<a href="../{$href}">
              <img align="middle" border="0" alt="AAM{$href}" 
                src="../../../../images/ap_doc/aam.gif"/>
            </a>
          </xsl:if>
        </xsl:if>
      </h2>
      <xsl:apply-templates select="./description" mode="check_phrase"/> 
      <p><xsl:value-of select="./description"/></p>
      <xsl:apply-templates select="note"/>
      <xsl:apply-templates select="example"/>      
    </xsl:for-each>  
  </xsl:template>
	
</xsl:stylesheet>
