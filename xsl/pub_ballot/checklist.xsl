<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../module.xsl"/>

  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">

    <!-- the file will contain either -->
    <xsl:apply-templates select="ballot"/>
    <xsl:apply-templates select="publication"/>
  </xsl:template>

  <xsl:template match="ballot">
    <xsl:variable name="ballot_index" 
      select="concat('../../ballots/ballots/',@directory,'/ballot_index.xml')"/>
    <xsl:apply-templates select="document($ballot_index)/ballot_index" mode="html_body"/>
  </xsl:template>


  <xsl:template match="ballot_index" mode="html_body">
    <HTML>
      <head>
        <title></title>
      </head>
      <body>
        <xsl:apply-templates select="/" mode="process_modules"/>
      </body>
    </HTML>
  </xsl:template>

  <xsl:template match="publication">
    <xsl:variable name="publication_index" 
      select="concat('../../publication/publication/',@directory,'/publication_index.xml')"/>
    <xsl:apply-templates select="document($publication_index)/publication_index" mode="html_body"/>
  </xsl:template>

  <xsl:template match="publication_index" mode="html_body">
    <HTML>
      <head>
        <title></title>
        <style type="text/css">
          body { color: black; background: white; font-size:10.0pt; font-family:"Times New Roman";}
          div.box { border: solid; border-width: 0.01em; width: width:30pt; padding: 1em;}
          p.line {margin-top: 0.4em; margin-bottom: 0.4em; margin-left: 0.4em;}
        </style>
      </head>
      <body>
        <xsl:apply-templates select="/" mode="process_modules"/>
      </body>
    </HTML>
  </xsl:template>


 <xsl:template match="module" mode="process_modules">
   <xsl:variable name="mod_path" select="concat('../../data/modules/',@name,'/module.xml')"/>
   <xsl:apply-templates
      select="document($mod_path)/module" 
     mode="checklist_block"/>
 </xsl:template>

 <xsl:template match="module" mode="checklist_block">
   <table  border="1" cellspacing="0" cellpadding="2" width="500">
     <tr>
       <td>
         <p class="line">Standard ISO 10303</p>
         <p class="line">Part <xsl:value-of select="concat(@part,' (',@name,')')"/>  </p>  
         <p class="line">Edition  <xsl:value-of select="@version"/>  </p> 
         <p class="line">Stage  6 (TS) </p>  
         <p class="line">N-number: ISO/TC 184/SC 4/WG 12 N <xsl:value-of select="@wg.number"/></p> 
       </td>
     </tr>
   </table>
   (Please replicate this box if the checklist applies to more than one module)<br/><br/>  
 </xsl:template>

</xsl:stylesheet>
