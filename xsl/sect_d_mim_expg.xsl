<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_d_mim_expg.xsl,v 1.7 2002/04/29 13:41:48 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="'D'"/>
    <xsl:with-param name="heading" 
      select="'MIM EXPRESS-G'"/>
    <xsl:with-param name="aname" select="'annexd'"/>
  </xsl:call-template>

  <xsl:variable name="href"
    select="concat('./5_mim',$FILE_EXT,'#mim_express')"/>
       
  The following diagrams provide a graphical representation of the 
  <a href="{$href}">MIM EXPRESS short listing</a> defined in
  Clause 5.2. The diagrams are presented in EXPRESS-G.
  <p>
    This annex contain two distinct representations of the Module
    Interpreted Model of this application module:
  </p>
  <ul>
    <li>
      a schema level representation which depicts the import of the
      constructs defined in the MIM schema of other application modules or in a
      schema of Common Resources documents,  
      in the MIM schema of this application module, through USE FROM
      statements;
    </li>  
    <li>
      an entity level representation which presents the Express constructs
      defined in the MIM schema of this application module and the
      references to imported constructs that are specialized or referred to
      by the constructs of the MIM schema of this application module.
    </li> 
  </ul>
  <p class="note">
    <small>
      NOTE&#160;&#160;Both these representations are partial. The schema
      level representation does not present the MIM schema of modules that are
      indirectly imported. 
      The entity level representation does not present the imported
      constructs that are not specialized or referred to by the constructs
      of the MIM schema of this application module. 
    </small>
  </p>
  <p>
    The EXPRESS-G graphical notation is defined in annex D of ISO 10303-11.
  </p>
  <a name="mimexpg"/>
  <xsl:apply-templates select="mim/express-g"/>
</xsl:template>
  
</xsl:stylesheet>
