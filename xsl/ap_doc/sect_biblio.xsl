<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
    $Id: sect_biblio.xsl,v 1.28 2010/07/01 20:35:20 radack Exp $
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
		exclude-result-prefixes="msxsl exslt"
		version="1.0">

  <xsl:import href="../elt_list.xsl"/>
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:include href="../common/biblio.xsl"/>
  
  <xsl:output method="html"/>
  
  <xsl:template match="module"/>
  
  <xsl:template match="application_protocol">
    
    <div align="center">
      <h2>
        <A NAME="biblio">Bibliography</A>
      </h2>
    </div>
    <xsl:choose>
      <xsl:when test="./bibliography">
        <xsl:apply-templates select="./bibliography"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="document('../../data/basic/ap_doc/bibliography_default.xml')/bibliography/bibitem.inc"/>
      </xsl:otherwise>
    </xsl:choose>

    <!-- check that all bibitems have been published, if not output
         footnote -->
    <xsl:apply-templates select="./bibliography" mode="unpublished_bibitems_footnote"/>    
  </xsl:template>
  

</xsl:stylesheet>
