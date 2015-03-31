<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: application_protocol.xsl,v 1.33 2005/03/03 16:33:17 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- <xsl:import href="../module.xsl"/> -->
  <xsl:import href="application_protocol_toc.xsl"/>
  <xsl:import href="../express_code.xsl"/>
  <xsl:import href="common.xsl"/>
  <xsl:import href="../projmg/apdoc_issues.xsl"/>

  <xsl:variable name="global_xref_list">
    <!-- debug 
    <xsl:message>
      global_xref_list defined in sect_4_express.xsl
    </xsl:message> -->
    <xsl:choose>
      <xsl:when test="/module_clause">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module_clause/@directory"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/arm.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="/module">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module/@name"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/arm.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>        
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       sect_4_express.xsl stylesheet is normally applied from file in:
         stepmod/data/module/?module?/sys/
       Hence the relative root is: ../../../
       -->
  <xsl:variable 
    name="relative_root"
    select="'../../../../'"/>


  
  <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/loose.dtd" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>

  <xsl:template match="/">
    <HTML>
      <HEAD>
        <TITLE>
          <xsl:apply-templates select="./application_protocol" mode="title"/>
        </TITLE>
      </HEAD>
      <BODY>
        <xsl:apply-templates select="./application_protocol" mode="TOCsinglePage"/>
        <xsl:apply-templates select="./application_protocol"/>
      </BODY>
    </HTML>
  </xsl:template>
 

  <!-- returns a list of annexes with content as a string with each annex name as a single word(no spaces)
       separated by spaces -->
  <xsl:template match="application_protocol" mode="annex_list" >
    <xsl:variable name="module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="@module_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="annex_list">
      <xsl:if
        test="document(concat($module_dir,'/module.xml'))/module/arm_lf/express-g">
        <xsl:value-of select="' ARMexpressG '"/>
      </xsl:if>
      <xsl:if
        test="document(concat($module_dir,'/module.xml'))/module/mim_lf/express-g">
        <xsl:value-of select="' MIMexpressG '"/>
      </xsl:if>
      <xsl:value-of select="' computerinterpretablelisting '"/>
      <xsl:if test="./usage_guide">
        <xsl:value-of select="' usageguide '"/>
      </xsl:if>
      <xsl:if test="./tech_disc">
        <xsl:value-of select="' techdisc '"/>
      </xsl:if>
      <xsl:if test="./changes/change_detail">
        <xsl:value-of select="' changedetail '"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="concat(' ',normalize-space($annex_list),' ')"/>
  </xsl:template>


<xsl:template name="annex_letter" >
  <xsl:param name="annex_name"/>
  <xsl:param name="annex_list"/>
  <!-- returns integer count of position of named annex in list of annexes -->
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="annex" select="concat(translate($annex_name,' ',''),' ')"/>

  <xsl:variable name="pos"
    select="string-length(translate(substring-before($annex_list,$annex),concat($UPPER,$LOWER),''))"/>

  <xsl:value-of select="substring('GHIJK',$pos,1)"/> 
</xsl:template>




  <xsl:template match="application_protocol" mode="abstract">

    <xsl:variable name="std_number">
      <xsl:call-template name="get_protocol_dated_stdnumber">
        <xsl:with-param name="application_protocol" select="."/>
      </xsl:call-template>      
    </xsl:variable>

    
    <xsl:choose>
      <xsl:when test="./abstract">
        <xsl:choose>
          <xsl:when  test="./abstract/li">
            <xsl:choose>
              <xsl:when  test="count(./abstract/li)=1">
                <P>
                  The following is within the scope of 
                  <xsl:value-of select="$std_number"/>
                </P>
              </xsl:when>
              <xsl:otherwise>
                <P>
                  The following are within the scope of 
                  <xsl:value-of select="$std_number"/>
                </P>
              </xsl:otherwise>
            </xsl:choose>
            <ul>
              <xsl:apply-templates select="./abstract/*"/>
            </ul>          
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="./abstract/*"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <p>
          <xsl:value-of select="$std_number"/>       
          specifies the application protocol for
          <xsl:call-template name="protocol_display_name">
            <xsl:with-param name="application_protocol" select="@name"/>
          </xsl:call-template>. 
        </p>        
        <xsl:apply-templates select="./inscope">          
          <xsl:with-param name="abstract" select="'yes'"/>
        </xsl:apply-templates> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="inscope">
    <xsl:param name="abstract" select="'no'"/>
    <p>
      <xsl:choose>
        <xsl:when test="$abstract='yes'">
          The following are within the scope of
          <xsl:call-template name="get_protocol_dated_stdnumber">
            <xsl:with-param name="application_protocol" select=".."/>
          </xsl:call-template>:
        </xsl:when>
        <xsl:otherwise>
          <a name="inscope"/> 
          The following are within the scope of this part of ISO 10303:                     
        </xsl:otherwise>
      </xsl:choose>
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
            <ul>
              <xsl:apply-templates
                select="document(concat($module_dir,'/module.xml'))/module/inscope/li"/>
            </ul>
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
      <ul>
        <xsl:apply-templates select="li"/>
      </ul>
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
            <ul>
              <xsl:apply-templates
                select="document(concat($module_dir,'/module.xml'))/module/outscope/li"/>
            </ul>
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
      <ul>
        <xsl:apply-templates select="li"/>
      </ul>
    </xsl:if>
  </xsl:template> 

  <xsl:template match="express_ref_inline">

  <xsl:variable name="linkend" select="@linkend"/>

  <xsl:variable name="first_sect">
    <xsl:call-template name="check_express_ref_first_section">
      <xsl:with-param name="linkend" select="$linkend"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$first_sect = 'OK'">
      
      <!-- remove all whitespace -->
      <xsl:variable
        name="nlinkend"
        select="translate($linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>

      <xsl:variable
        name="module"
        select="substring-before($nlinkend,':')"/>

      <xsl:variable name="mod_dir">
        <xsl:call-template name="ap_module_directory">
          <xsl:with-param name="application_protocol" select="$module"/>
        </xsl:call-template>
      </xsl:variable>


      <xsl:variable name="express_path"
        select="substring-after(substring-after($nlinkend,':'),':')"/>
      
      <xsl:variable name="schema">
        <xsl:choose>
          <xsl:when test="contains($express_path,'.')">
            <xsl:value-of select="substring-before($express_path,'.')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$express_path"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="express_path1"
        select="substring-after($express_path,'.')"/>
      
      <xsl:variable name="entity_type">
        <xsl:choose>
          <xsl:when test="contains($express_path1,'.')">
            <xsl:value-of select="substring-before($express_path1,'.')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$express_path1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="express_path2"
        select="substring-after($express_path1,'.')"/>

      <xsl:variable name="attribute">
        <xsl:choose>
          <xsl:when test="starts-with($express_path2,'wr:') 
                          or starts-with($express_path2,'ur:')">
            <xsl:value-of select="''"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$express_path2"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="wr">
        <xsl:choose>
          <xsl:when test="starts-with($express_path2,'wr:')">
            <xsl:value-of select="substring-after($express_path2,'wr:')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ur">
        <xsl:choose>
          <xsl:when test="starts-with($express_path2,'ur:')">
            <xsl:value-of select="substring-after($express_path2,'ur:')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>



      <xsl:variable name="arm_mim_res"
        select="substring-before(substring-after($nlinkend,':'),':')"/>

      <xsl:variable name="express_file">
        <xsl:choose>
          <xsl:when test="$arm_mim_res='arm'
                          or $arm_mim_res='arm_express'">
            <xsl:value-of select="concat($mod_dir,'/arm.xml')"/>
          </xsl:when>
          <xsl:when test="$arm_mim_res='mim'
                          or $arm_mim_res='mim_express'">
            <xsl:value-of select="concat($mod_dir,'/mim.xml')"/>
          </xsl:when>
          <xsl:when test="$arm_mim_res='mim_lf_express'">
            <xsl:value-of select="concat($mod_dir,'/mim_lf.xml')"/>
          </xsl:when>
          <xsl:when test="$arm_mim_res='ir_express'">
            <xsl:value-of select="concat('../data/resources/',$schema,'/',$schema,'.xml')"/>
          </xsl:when>
          <xsl:when test="$arm_mim_res='reference'">
            <xsl:value-of select="concat('../../data/reference/',$schema,'/',$schema,'.xml')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="express_nodes"
        select="document(string($express_file))"/>
      <xsl:choose>
        <xsl:when test="string-length($wr) != 0">
          <xsl:if test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/where[@label=$wr])">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message" 
                select="concat('Error ER-4: The express_ref linkend #', 
                        $linkend, 
                        '# is incorrectly specified. 
                        #The WHERE rule does not exist.
                        #Note linkend is case sensitive.')"/>
            </xsl:call-template>
          </xsl:if>
                 <xsl:if test="$express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/where[@label=$wr]">
                   <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]" mode="code"/>           </xsl:if>
        </xsl:when>

        <xsl:when test="string-length($ur) != 0">
          <xsl:if test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/unique[@label=$ur])">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message" 
                select="concat('Error ER-5: The express_ref linkend ', 
                        $linkend, 
                        '# is incorrectly specified.# 
                        The UNIQUE rule does not exist.
                        #Note linkend is case sensitive.')"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>

        <xsl:when test="string-length($attribute) != 0">
          <xsl:if
            test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/explicit[@name=$attribute]
                  or 
                  $express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/inverse[@name=$attribute]
                  or
                  $express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/derived[@name=$attribute]
                  or
                  $express_nodes/express/schema[@name=$schema]/type[@name=$entity_type]/enumeration/@items[contains(.,$attribute)]
)">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message" 
                select="concat('Error ER-6: The express_ref linkend# ', 
                        $linkend, 
                        '# is incorrectly specified. 
                        The attribute does not exist.#
                        Note linkend
is case sensitive.')"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>


        <xsl:when test="string-length($entity_type) != 0">
          <xsl:if
            test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]
                  or 
                  $express_nodes/express/schema[@name=$schema]/type[@name=$entity_type]
                  or
                  $express_nodes/express/schema[@name=$schema]/rule[@name=$entity_type]
                  or 
                  $express_nodes/express/schema[@name=$schema]/function[@name=$entity_type]
                  or
                  $express_nodes/express/schema[@name=$schema]/procedure[@name=$entity_type]
                  )">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message" 
                select="concat('Error ER-7: The express_ref linkend#', 
                              $linkend, 
                              '# is incorrectly specified.# 
                        The entity does not exist.#Note linkend
is case sensitive.')"/>
            </xsl:call-template>

          </xsl:if>

            <xsl:if test="$express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]">
              <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]" mode="code"/>
              
            </xsl:if>

            <xsl:if test="$express_nodes/express/schema[@name=$schema]/type[@name=$entity_type]">
              <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/type[@name=$entity_type]" mode="code"/>

              
            </xsl:if>
            <xsl:if test="$express_nodes/express/schema[@name=$schema]/rule[@name=$entity_type]">
              <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/rule[@name=$entity_type]" mode="code"/>
              
            </xsl:if>
            <xsl:if test="$express_nodes/express/schema[@name=$schema]/function[@name=$entity_type]">
              <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/function[@name=$entity_type]" mode="code"/>
              
            </xsl:if>
            <xsl:if test="$express_nodes/express/schema[@name=$schema]/procedure[@name=$entity_type]">
              <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/procedure[@name=$entity_type]" mode="code"/>
            </xsl:if>            
        </xsl:when>

        <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param name="message" 
                select="concat('Error ER-9: The express_ref linkend #', 
                        $linkend, 
                        '# is incorrectly specified.')"/>
            </xsl:call-template>          
        </xsl:otherwise>

      </xsl:choose>

    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message" select="$first_sect"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
 



</xsl:stylesheet>
