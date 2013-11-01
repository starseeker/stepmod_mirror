<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: imgfile.xsl,v 1.19 2011/11/09 22:52:17 lothartklein Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: To display an imgfile as an imagemap
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <xsl:import href="sect_4_express.xsl"/>
  <xsl:import href="parameters.xsl" />

  <xsl:import href="res_toc.xsl"/>

  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />

  <xsl:variable name="resdoc_dir">
    <xsl:call-template name="resdoc_directory">
      <xsl:with-param name="resdoc" select="imgfile.content/@module"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="resdoc">
    <xsl:value-of select="imgfile.content/@module"/>
  </xsl:variable>


  <xsl:variable name="resdoc_root" select="concat('../',$resdoc_dir)"/>

  <xsl:variable name="resdoc_file" select="concat($resdoc_dir,'/resource.xml')"/>
  <xsl:variable name="resdoc_xml" select="document($resdoc_file)"/>



<xsl:template match="imgfile.content">
  
                 
  <!-- if a file is specified then might be able to deduce the figure title -->
  <xsl:variable name="fig_title">
    <xsl:choose>
      <xsl:when test="./@file">
        <xsl:apply-templates 
          select="$resdoc_xml/resource/*/express-g/imgfile"
          mode="title">
          <xsl:with-param name="file" select="@file"/>
          
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="contains(@file,'schema_diag')">
        
            <xsl:value-of 
              select="concat('Figure 1 ', 
                      ' &#8212; The relationship of schemas of this part to the standard ISO 10303 integration architecture')" />
      </xsl:when>
      <xsl:when test="contains(@file,'schemaexpg')">       
            <xsl:value-of 
              select="concat('Figure D. ', 
                      ' &#8212; Place calculated title here')" />
            </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <HTML>
    <HEAD>
 
      <xsl:apply-templates select="$resdoc_xml/resource" mode="meta_data"/>

      <TITLE>
        <xsl:choose>
          <xsl:when test="@module">
            <xsl:value-of select="concat(@module,' : ',$fig_title)"/>
          </xsl:when>
          <xsl:otherwise>
            @module not specified.
          </xsl:otherwise>
        </xsl:choose>
      </TITLE>
    </HEAD>

    <body>
      
      <xsl:variable name="module" select="@module"/>
      <xsl:variable name="self" select="."/>
      <xsl:choose>
        <xsl:when test="@module">
          <xsl:apply-templates 
            select="$resdoc_xml/resource"
            mode="TOCmultiplePage">
            <xsl:with-param name="resdoc_root" select="concat('../',$resdoc_dir)"/>
          </xsl:apply-templates>

          <!-- display navigation arrows -->
          <xsl:choose>
            <xsl:when test="./@file">
              <xsl:apply-templates 
                select="$resdoc_xml/resource/*/express-g/imgfile"
                mode="nav_arrows">
                <xsl:with-param name="file" select="@file"/>
                <xsl:with-param name="resdoc" select="$resdoc"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              To enable navigation, add file parameter to expressg file
              <xsl:call-template name="error_message">
                <xsl:with-param name="inline" select="'no'"/>
                <xsl:with-param name="message">
                  <xsl:value-of 
                    select="'Warning IM2: To enable navigation, add file parameter to expressg file'"/>
                </xsl:with-param>
                <xsl:with-param name="warning_gif"
                  select="'../../../images/warning.gif'"/>

              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>

          <!-- now display the image -->
          <xsl:apply-templates select="img">
            <xsl:with-param name="alt" select="$fig_title"/>
          </xsl:apply-templates>
          <div align="center">
            <br/><br/>
            <b>
              <xsl:value-of select="$fig_title"/>
            </b>
            <br/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of 
                select="'Error IM1: Error in image file - module not specified'"/>
            </xsl:with-param>
            <xsl:with-param name="warning_gif"
              select="'../../../images/warning.gif'"/>

          </xsl:call-template>
          <xsl:apply-templates select="img"/>
          <div align="center"><br/><br/><b><xsl:value-of select="@title"/></b><br/></div>
        </xsl:otherwise>
      </xsl:choose>
      <br/><br/>
      <p>&#169; ISO <xsl:value-of select="substring($resdoc_xml/resource/@publication.year,1,4)"/> &#8212; All rights reserved</p>
    </body>
  </HTML>
</xsl:template>


<xsl:template match="img.area">
  <xsl:variable name="href-temp">
  <xsl:choose>
    <xsl:when test="contains(@href,'/sys/')">
      <xsl:value-of select="@href"/>
    </xsl:when>
    <xsl:when test="contains(@href,'expg')">
      <xsl:value-of select="@href"/>
    </xsl:when>
    <xsl:when test="contains(@href,'#')">
    <xsl:variable name="frag" select="substring-after(@href,'#')" />
    <xsl:variable name="this-schema">
      <xsl:choose> 
      <xsl:when test="string-length(substring-before($frag,'.')) > 0" >
        <xsl:value-of select="substring-before($frag,'.')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$frag" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="this-object" select="substring-after($frag,'.')" />
      <xsl:variable name="hash">
        <when test="string-length($this-object) > 0">
          <xsl:value-of select="'#'" />      
        </when>
     </xsl:variable>
      <xsl:variable name="clauseno">
        <xsl:apply-templates select="$resdoc_xml//schema" mode="pos">
          <xsl:with-param name="schema_name" select="$this-schema"/>
        </xsl:apply-templates>
      </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length($clauseno) > 0">
            <xsl:value-of select="concat($resdoc_root,'/sys/',$clauseno,'_schema',$FILE_EXT,$hash,$frag)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('../../resources/',$this-schema,'/',$this-schema,$FILE_EXT,$hash,$frag)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@href"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="href">
    <xsl:choose>
      <xsl:when test="contains($href-temp,'.xml')">
        <xsl:value-of select="concat(substring-before($href-temp,'.xml'),
                              $FILE_EXT,
                              substring-after($href-temp,'.xml'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$href-temp"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!--    <xsl:if test="$output_background ='NO'" >  -->

  <xsl:element name="AREA">
      <xsl:attribute name="href">
        <xsl:value-of select="$href"/>
      </xsl:attribute>
    <xsl:attribute name="shape">
      <xsl:value-of select="@shape"/>
    </xsl:attribute>
    <xsl:attribute name="alt">
      <xsl:value-of select="$href"/>
    </xsl:attribute>
    <xsl:attribute name="coords">
      <xsl:value-of select="@coords" /> 
      </xsl:attribute>
    </xsl:element>
    <!--    </xsl:if> -->

</xsl:template>

<xsl:template match="imgfile" mode="title">
  <xsl:param name="file"/>
  <xsl:if test="$file=@file">
    <xsl:variable name="number">
      <xsl:number/>
    </xsl:variable>
    <xsl:variable name="number_any">
      <xsl:number level="any"/>
    </xsl:variable>
    <xsl:variable name="img_count">
      <xsl:value-of select="count(../imgfile)"/>
    </xsl:variable>
    <xsl:variable name="interface_diag_count">
      <xsl:value-of select="count(//schema_diag//imgfile)"/>
    </xsl:variable>
    <xsl:variable name="fig_no">
      <xsl:choose>
        <xsl:when test="name(../..)='arm'">
          <xsl:choose>
            <xsl:when test="$number=1">
              <xsl:value-of 
                select="concat('Figure C.',$number_any - $interface_diag_count, 
                        ' &#8212; ARM schema level EXPRESS-G diagram ',$number)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of 
                select="concat('Figure C.',$number, 
                        ' &#8212; ARM entity level EXPRESS-G diagram ',($number - 1))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="name(../..)='mim'">
          <xsl:choose>
            <xsl:when test="$number=1">
              <xsl:value-of 
                select="concat('Figure D.',$number, 
                        ' &#8212; MIM schema level EXPRESS-G diagram ',$number)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of 
                select="concat('Figure D.',$number, 
                        ' &#8212; MIM entity level EXPRESS-G diagram ',($number - 1))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!--        <xsl:when test="../../schema">-->
        <xsl:when test="contains(@file,'expg')"> 
          <!-- was 'schemaexpg', but this didn't work for AICs LK?-->
          <!-- this made the code unable to distinguish between 'diagexpg' and 'schemaexpg' and caused a nubmering problem, but I've fixed things now so that AICS work too -->
          
          <xsl:choose>
            <xsl:when test="contains(@file,'diagexpg')">
              <xsl:if test="string-length(@title) > 3" >
                <xsl:value-of 
                  select="concat('Figure  1  &#8212; ',@title)" />
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="schname" select="substring-before(@file,'expg')" />
               <xsl:value-of 
              select="concat('Figure D.',$number_any - $interface_diag_count, 
                      ' &#8212; EXPRESS-G diagram of the ', $schname, ' (', $number,' of ', $img_count, ')' )" />
            </xsl:otherwise>
          </xsl:choose>
          
         
          </xsl:when>
          <xsl:otherwise>
              
              <xsl:if test="string-length(@title) > 3" >
                <xsl:value-of 
                  select="concat('Figure  1  &#8212; ',@title)" />
                </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$fig_no"/>
  </xsl:if>
</xsl:template>


<xsl:template match="imgfile" mode="nav_arrows">
  <xsl:param name="file"/>
  <xsl:param name="resdoc"/>
  <xsl:if test="$file=@file">
    <!-- Page navigation:&#160; -->
      <xsl:variable name="home">
        <xsl:choose>
          <xsl:when test="name(../..)='arm'">
            <xsl:call-template name="set_file_ext">
              <xsl:with-param name="filename" select="'./sys/c_arm_expg.xml'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="name(../..)='mim'">
            <xsl:call-template name="set_file_ext">
              <xsl:with-param name="filename" select="'./sys/d_mim_expg.xml'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="contains(@file,'schemaexpg')">
            <xsl:call-template name="set_file_ext">
              <xsl:with-param name="filename" select="concat('../../resource_docs/',$resdoc,'/sys/d_expg.xml')"/>
            </xsl:call-template>            
          </xsl:when>
          <xsl:when test="contains(@file,'schema_diagexpg')">
            <xsl:call-template name="set_file_ext">
              <xsl:with-param name="filename" select="concat('../../resource_docs/',$resdoc,'/sys/introduction.xml')"/>
            </xsl:call-template>            
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="set_file_ext">
              <xsl:with-param name="filename" select="concat('../../resource_docs/',$resdoc,'/sys/d_expg.xml')"/>
            </xsl:call-template>            
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <a href="./{$home}">
        <img align="middle" border="0" 
          alt="Index of Express-G pages" src="../../../images/home.gif"/>
      </a>
      <xsl:variable name="img_position">
        <xsl:number/>
      </xsl:variable>

      <xsl:if test="$img_position != 1">
        <!-- not first page, so start page and previous page -->
        <xsl:variable name="start">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" select="../imgfile[1]/@file"/>
          </xsl:call-template>
        </xsl:variable>
        <a href="./{$start}">
          <img align="middle" border="0" 
            alt="First page" src="../../../images/start.gif"/>
        </a>
        <xsl:variable name="prevpos" select="$img_position - 1"/>
        <xsl:variable name="previous">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" 
              select="../imgfile[$prevpos]/@file"/>
          </xsl:call-template>
        </xsl:variable>   

        <a href="./{$previous}">
          <img align="middle" border="0" 
            alt="Previous page" src="../../../images/prev.gif"/>
        </a>
      </xsl:if> <!-- end of NOT first page -->
      
      <xsl:if test="count(following-sibling::*)>0">
        <!-- there are subsequent diagrams, so next and end -->
        <xsl:variable name="next">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" 
              select="following-sibling::*/@file"/>
          </xsl:call-template>
        </xsl:variable>
        <a href="./{$next}">
          <img align="middle" border="0" 
            alt="Next page" src="../../../images/next.gif"/>
        </a>
        
        <xsl:variable name="last">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" 
              select="../imgfile[last()]/@file"/>
          </xsl:call-template>
        </xsl:variable>
        
        <a href="./{$last}">
          <img align="middle" border="0" 
            alt="Last page" src="../../../images/end.gif"/>
        </a>
      </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="imgfile">
  <xsl:variable name="href">
    <xsl:call-template name="set_file_ext">
      <xsl:with-param name="filename" select="@file"/>
    </xsl:call-template>
  </xsl:variable>
  <a href="{$href}">
    <xsl:value-of select="position()"/>
  </a>&#160;
</xsl:template>

<xsl:template match="resource" mode="annex_list" >
<!-- returns a list of annexes with content as a string with each annex name as a single word(no spaces)
separated by spaces -->
        <xsl:if test="string-length(./tech_discussion) > 10">
            Technicaldiscussion
        </xsl:if>
        <xsl:if test="string-length(./examples) > 10">
            Examples 
        </xsl:if>
        <xsl:if test="string-length(./add_scope) > 10">
             Additionalscope
        </xsl:if>

</xsl:template>

<xsl:template name="annex_position" >
  <xsl:param name="annex_name" />
  <xsl:param name="annex_list" />
<!-- returns integer count of position of named annex in list of annexes -->
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="annex" select="concat(translate($annex_name,' ',''),' ')" />

  <xsl:value-of select="string-length(
          translate(
            substring-before(
              concat(' ',normalize-space($annex_list),' '),
              $annex
                   ),
            concat($UPPER,$LOWER),
            '')
            )" />
</xsl:template>


</xsl:stylesheet>

