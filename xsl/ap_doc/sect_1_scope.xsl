<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_1_scope.xsl,v 1.10 2003/05/22 14:57:14 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="application_protocol">
		<h2>
    			Industrial automation systems and integration &#8212; <br/>
    			Product data representation and exchange &#8212;  <br/>
    			Part <xsl:value-of select="@part"/>:<br/>
    			Application protocol:
			<xsl:call-template name="protocol_display_name">
      				<xsl:with-param name="application_protocol" select="@title"/>
    			</xsl:call-template>
  		</h2>

			<xsl:call-template name="clause_header">
				<xsl:with-param name="heading" select="'1 Scope'"/>
				<xsl:with-param name="aname" select="'scope'"/>
			</xsl:call-template>
			<xsl:variable name="application_protocol_name">
				<xsl:call-template name="module_display_name">
					<xsl:with-param name="module" select="@title"/>
				</xsl:call-template>
			</xsl:variable>
			<p>
                          This part of ISO 10303 specifies the use of the
                          integrated resources necessary for the scope and information 
                          requirements for 
                          <xsl:value-of select="normalize-space(./inscope/@context)"/>
			</p>	
    <!-- TODO - need to check whether there are any notes in the inscope
         statements, if so the note will need to be numbered -->
    <xsl:variable name="note_number" select="''"/>
    <p class="note">
      <small>
        NOTE&#160;
        <xsl:value-of select="$note_number"/>
        &#160;&#160;
        The scope of this part of ISO 10303 is further refined in the
        application activity model in 
        Annex <a href="e_aam{$FILE_EXT}">E</a>.
      </small>
    </p>

    <xsl:apply-templates select="./inscope"/> 
    <xsl:apply-templates select="./outscope"/>             
  </xsl:template>

    <xsl:template match="inscope">
    <p>
      <a name="inscope"/> 
      The following are within the scope of this part of ISO 10303: 
    </p>

    <xsl:variable name="module" select="/application_protocol/@module_name"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="/application_protocol/@module_name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="./@from_module!='NO'">
      <!-- output the scope statements from the module -->
      <xsl:choose>
        <xsl:when test="$module_ok='true'">
            <xsl:variable name="module_dir">
              <xsl:call-template name="ap_module_directory">
                <xsl:with-param name="application_protocol" select="$module"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:apply-templates
              select="document(concat($module_dir,'/module.xml'))/module/inscope/li"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error AP1: The module ',$module,' does not exist.',
                                    '  Correct application_protocol module_name in application_protocol.xml')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
        
    <!-- output the scope statements from the AP doc -->
    <xsl:if test="./li">
      <xsl:apply-templates select="li"/>
    </xsl:if>
    
  </xsl:template>
		
  <xsl:template match="outscope">
    <p>
      <a name="outscope"/>
      The following are outside the scope of this part of ISO 10303: 
    </p>
    <xsl:variable name="module" select="/application_protocol/@module_name"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="/application_protocol/@module_name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="./@from_module!='NO'">
      <!-- output the scope statements from the module -->
      <xsl:choose>
        <xsl:when test="$module_ok='true'">
            <xsl:variable name="module_dir">
              <xsl:call-template name="ap_module_directory">
                <xsl:with-param name="application_protocol" select="$module"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:apply-templates
              select="document(concat($module_dir,'/module.xml'))/module/inscope/li"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error AP1: The module',$module,' does not exist.',
                                    '  Correct application_protocol module_name in application_protocol.xml')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
        
    <!-- output the scope statements from the AP doc -->
    <xsl:if test="./li">
      <xsl:apply-templates select="li"/>
    </xsl:if>
  </xsl:template> 


</xsl:stylesheet>
