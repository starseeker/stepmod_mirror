<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_b_obj_reg.xsl,v 1.5 2004/11/05 01:00:58 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="resource.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="resource_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="resource">
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="'B'"/>
    <xsl:with-param name="heading" 
      select="'Information object registration'"/>
    <xsl:with-param name="aname" select="'annexb'"/>
    <xsl:with-param name="informative" select="'normative'"/>
  </xsl:call-template>

  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ_</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz-</xsl:variable>
  
  <xsl:variable name="resdoc_dir">
    <xsl:call-template name="resdoc_directory">
      <xsl:with-param name="resdoc" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable
    name="object_reg" 
    select="concat('{ iso standard 10303 part(',@part,') version(',@version,')')"/>
  <h2>
    <a name="b1">
      B.1 Document Identification 
    </a>
    </h2>
    <p>
  To provide for unambiguous identification of an information object in an
  open system, the object identifier
    </p>
    <p align="center">
      <xsl:value-of 
      select="concat($object_reg,' }' )"/>
    </p>
    <p>
      is assigned to this part of ISO 10303. The meaning of this value is defined
  in ISO/IEC 8824-1, and is described in ISO 10303-1.  
    </p>
    <h2>
    <a name="b2">
      B.2 Schema identification
    </a>
  </h2>
  

  <!-- there is are potentially several  schemas in an integrated resource -->
  <!-- for now I will just get the names from the resource.xml rather than go to the schemas --> 
 
 <xsl:for-each select="./schema">
   <xsl:variable name="schema" select="@name"/>

   <h2>B.2.<xsl:value-of select="concat(position(),  ' ')"/><xsl:value-of select="$schema"/> schema identification</h2>

  <p>
    To provide for unambiguous identification of the schema specifications
    given in this application module in an open information system, the object
    identifiers are assigned as follows: 
  </p>
  <p align="center">
    <xsl:value-of 
      select="concat($object_reg,' schema(1) ', $schema,'(1) }' )"/>
  </p>
  <p>
    is assigned to the <xsl:value-of select="$schema"/> schema. 
    The meaning of this value is defined in ISO/IEC 8824-1, and is described in
    ISO 10303-1.  
  </p>


</xsl:for-each>

</xsl:template>
  
</xsl:stylesheet>

