<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_c_arm_expg.xsl,v 1.12 2005/03/03 09:53:18 robbod Exp $
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
    <xsl:with-param name="annex_no" select="'C'"/>
    <xsl:with-param name="heading" 
      select="'ARM EXPRESS-G'"/>
    <xsl:with-param name="aname" select="'annexc'"/>
  </xsl:call-template>

  <xsl:choose>
    <!-- assume that if there is one image file that it is a schema diagram -->
    <xsl:when test="count(./arm/express-g/imgfile) = 1">
      <p>
        The following diagram provides a graphical representation of the 
        <!-- EXPRESS structure and constructs specified in clause 4. -->
        ARM EXPRESS short listing defined in 
        Clause <a href="./4_info_reqs{$FILE_EXT}">4</a>.
        The diagram is presented in EXPRESS-G.
      </p>
      <p>
        This annex contains a schema level representation of the Application
        Reference Model of this application module. It depicts the import of the
        constructs defined in the ARM schema of other application modules, in
        the ARM schema of this application module, through USE FROM statements.
      </p> 
      <p class="note">
        <small>
          NOTE&#160;&#160;The schema level representation is partial. It
          does not present the ARM schema of modules that are
          indirectly imported. 
        </small>
      </p>
      
    </xsl:when>
  
  <xsl:otherwise>
      <p>
        The following diagrams provide a graphical representation of the 
        <!-- EXPRESS structure and constructs specified in clause 4. -->
        ARM EXPRESS short listing defined in 
        Clause <a href="./4_info_reqs{$FILE_EXT}">4</a>.
        The diagrams are presented in EXPRESS-G.
      </p>
      <p>
        This annex contain two distinct representations of the Application
        Reference Model of this application module:
      </p> 
      <ul>
        <li>
          a schema level representation which depicts the import of the
          constructs defined in the ARM schema of other application modules, in
          the ARM schema of this application module, through USE FROM statements;
        </li> 
        <li>
          an entity level representation which presents the EXPRESS constructs
          defined in the ARM schema of this application module and the
          references to imported constructs that are specialized or referred to
          by the constructs of the ARM schema of this application module.
        </li>
      </ul>
      <p class="note">
        <small>
          NOTE&#160;&#160;Both these representations are partial. The schema level
          representation does not present the ARM schema of modules that are
          indirectly imported. The entity level representation does not present
          the imported constructs that are not specialized or referred to by
          the constructs of the ARM schema of this application module.
        </small>
      </p>
    </xsl:otherwise>
  </xsl:choose>

      <p>
        The EXPRESS-G graphical notation is defined in ISO 10303-11:2004 Annex D.
      </p> 


  <a name="armexpg"/>
  <xsl:apply-templates select="arm/express-g"/>
</xsl:template>

</xsl:stylesheet>
