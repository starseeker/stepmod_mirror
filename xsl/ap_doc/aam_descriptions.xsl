<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: aam_descriptions.xsl,v 1.6 2003/05/23 15:52:56 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                version="1.0">


  <xsl:output method="html"/>
  
  <!-- RBN not sure why this is needed
       <xsl:template match="/">
         <html>
           <body bgcolor="#FFFFFF">
             <xsl:apply-templates/>
           </body>
         </html>
       </xsl:template> 
       -->
	
  <xsl:template match="idef0">

    <xsl:variable name="application_protocol_xml_file" 
      select="concat('../../data/application_protocols/',@application_protocol,'/application_protocol.xml')"/>

    <xsl:variable name="apdoc_ok">
      <xsl:call-template name="check_application_protocol_exists">
        <xsl:with-param name="application_protocol" select="@application_protocol"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$apdoc_ok!='true'">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error AAM1:', $apdoc_ok,' Correct idef0@application_protocol in aam.xml')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>


    <p>The viewpoint is that of <xsl:value-of select="viewpoint"/>.</p>    
    <h2>F.1 Application activity model definitions</h2>
        
    <xsl:for-each select="./*/*">
      <xsl:sort select="normalize-space(./name)"/>
      <xsl:variable name="asterisk">
        <xsl:if test="@inscope='no'">
          *
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="aname" select="@identifier"/>
      <h2>
        <a aname="$aname">
          F.1.<xsl:value-of select="position()"/>
        </a>
        <xsl:value-of select="concat(' ', ./name)"/>
        <xsl:value-of select="$asterisk"/>
      
        <xsl:if test="name(.)='activity'">
          <xsl:if test="$apdoc_ok='true'">
            <!-- this could be more efficient --> 
            <xsl:variable name="page" select="number(../@number)"/>
            <xsl:variable name="imgfile">
              <xsl:value-of 
                select="document($application_protocol_xml_file)/application_protocol/aam/idef0/imgfile[$page]/@file"/>
            </xsl:variable>
            <xsl:variable name="href">
              <xsl:call-template name="set_file_ext">
                <xsl:with-param name="filename" select="$imgfile"/>
              </xsl:call-template>
            </xsl:variable>
            <a href="../{$href}">
              <img align="middle" border="0" alt="AAM{$href}" 
                src="../../../../images/ap_doc/aam.gif"/>
            </a>
          </xsl:if>
        </xsl:if>
      </h2>
      <p><xsl:value-of select="./description"/></p>
      <xsl:apply-templates select="note"/>
      <xsl:apply-templates select="example"/>      
    </xsl:for-each>  
  </xsl:template>
	
</xsl:stylesheet>
