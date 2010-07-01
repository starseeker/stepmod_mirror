<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
    $Id: $
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
		exclude-result-prefixes="msxsl exslt"
		version="1.0">

  <xsl:template match="bibliography">
    <!-- output the defaults -->
    <xsl:apply-templates 
       select="document($bibliography_path,.)/bibliography/bibitem.inc"/>   
    <!-- 
         there are no default bibliography items for this document type
      -->
    <xsl:variable name="bibitem_inc_cnt">0</xsl:variable>
    <xsl:apply-templates select="./*">
      <xsl:with-param name="number_start" select="$bibitem_inc_cnt"/>
    </xsl:apply-templates> 
  </xsl:template>
  
  <xsl:template match="bibitem|bibitem.techreport|bibitem.book">
    <!-- the value from which to start the counting. -->
    <xsl:param name="number_start" select="0"/>

    <!-- 
	 the value to be used for the number. This is used if the bibitem
	 is being displayed from a bibitem.inc
      -->
    <xsl:param name="number_inc" select="0"/>

    <xsl:variable name="number">
      <!-- if the number is provided, use it, else count -->
      <xsl:choose>
	<xsl:when test="$number_inc>0">
          <xsl:value-of select="$number_inc"/>
	</xsl:when>
	<xsl:otherwise>
          <xsl:number count="bibitem"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="frag" select="concat('bibitem_',@id)" />
    <p>        
      <A NAME="{$frag}"/>

      [<xsl:value-of select="$number_start+$number"/>] 
      <xsl:apply-templates select="." mode="bibitem_content"/>
      <xsl:apply-templates select="ulink"/>
    </p>
  </xsl:template>

  <!-- item is a standard -->
  <xsl:template match="bibitem" mode="bibitem_content">
    <xsl:if test="stdnumber">
      <xsl:apply-templates select="stdnumber"/>
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="stdtitle"/>

    <xsl:if test="subtitle">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="subtitle"/>

    <xsl:if test="pubdate and not(starts-with(stdnumber,'ISO'))">
      <!-- only going to use pubdate if NON ISO standard, 
           ISO standard will have date in stdnumber - see stdnumber
           template -->
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="pubdate"/>
    <xsl:text>.</xsl:text>
  </xsl:template>

  <!-- item is a technical report -->
  <xsl:template match="bibitem.techreport" mode="bibitem_content">
    <xsl:variable name="elt_list">
      <elt-list separator="." terminator="." name="top-level">
	<elt-list name="primary-responsibility">
	  <elt name="primary-responsibility">
	    <xsl:value-of select="normalize-space(primary-responsibility)"/>
	  </elt>
	</elt-list>
	<elt name="stdtitle">
	  <i>
	    <xsl:value-of select="normalize-space(stdtitle)"/>
	  </i>
	</elt>
	<elt-list separator="," name="report-type,number,institution,pubdate">
	  <elt-list name="report-type,number">
	    <elt name="report-type">
	      <xsl:value-of select="normalize-space(report-type)"/>
	    </elt>
	    <elt name="number">
	      <xsl:value-of select="normalize-space(number)"/>
	    </elt>
	  </elt-list>
	  <elt name="institution">
	    <xsl:value-of select="normalize-space(institution)"/>
	  </elt>
	  <elt name="pubdate">
	    <xsl:value-of select="normalize-space(pubdate)"/>
	  </elt>
	</elt-list>
      </elt-list>
    </xsl:variable>
    <xsl:call-template name="render_elt_list">
      <xsl:with-param name="elt_list" select="$elt_list"/>
    </xsl:call-template>
  </xsl:template>

  <!-- item is a monograph -->
  <xsl:template match="bibitem.book" mode="bibitem_content">
    <xsl:variable name="elt_list">
      <elt-list separator="." terminator="." name="top-level">
	<elt-list name="primary-responsibility">
	  <elt name="primary-responsibility">
	    <xsl:value-of select="normalize-space(primary-responsibility)"/>
	  </elt>
	</elt-list>
	<elt name="stdtitle">
	  <i>
	    <xsl:value-of select="normalize-space(stdtitle)"/>
	  </i>
	</elt>
	<elt name="edition">
	  <xsl:value-of select="normalize-space(edition)"/>
	</elt>
	<elt-list separator="," name="report-type,number,publisher,pubdate">
	  <elt-list name="place,publisher" separator=" :">
	    <elt name="place">
	      <xsl:value-of select="normalize-space(place)"/>
	    </elt>
	    <elt name="publisher">
	      <xsl:value-of select="normalize-space(publisher)"/>
	    </elt>
	  </elt-list>
	  <elt name="pubdate">
	    <xsl:value-of select="normalize-space(pubdate)"/>
	  </elt>
	</elt-list>
      </elt-list>
    </xsl:variable>
    <xsl:call-template name="render_elt_list">
      <xsl:with-param name="elt_list" select="$elt_list"/>
    </xsl:call-template>
  </xsl:template>



  <xsl:template match="bibitem.inc">
    <!-- the value from which to start the counting. -->
    <xsl:param name="number_start" select="0"/>

    <xsl:variable name="ref" select="@ref"/>
    <xsl:variable name="bibitem" 
		  select="document($bibliography_path,.)/bibitem.list/node()[starts-with(local-name(),'bibitem') and (@id=$ref)]"/>
    <xsl:choose>
      <xsl:when test="$bibitem">
	<xsl:apply-templates select="$bibitem">
          <xsl:with-param name="number_start" select="$number_start"/>
          <xsl:with-param name="number_inc" select="position()"/>
	</xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="error_message">
          <xsl:with-param 
             name="message"
             select="concat('Error 13: Can not find bibitem referenced by: ',$ref,
                     'in ../data/basic/bibliography.xml')"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="orgname">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="stdnumber">
    <!-- 
	 ISO documents should be date referenced and have the stdnumber form
	 ISO 10303-41:2000
	 People are inconsistent as to whether they included the date in the stdnumber
	 <stdnumber>ISO 10303-41:2000</stdnumber>
	 or <pubdate> -->
    <xsl:variable name="stdnumber" select="normalize-space(.)"/>
    <xsl:choose>
      <xsl:when test="starts-with($stdnumber,'ISO')">
	<xsl:choose>
          <!-- date in the stdnumber -->
          <xsl:when test="contains($stdnumber,':')">
            <xsl:value-of select="$stdnumber"/>
          </xsl:when>
          <!-- date in the pubdate -->
          <xsl:when test="../pubdate">
            <xsl:value-of select="concat($stdnumber,':',../pubdate)"/>
          </xsl:when>
          <!-- no date provided -->
          <xsl:otherwise>
            <xsl:value-of select="$stdnumber"/>
          </xsl:otherwise>
	</xsl:choose>
      </xsl:when>

      <!-- a non ISO standard -->
      <xsl:otherwise>
	<xsl:value-of select="$stdnumber"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="../@published='n'">
      <sup>
	&#160;<a href="#tobepub">1</a><xsl:text>)</xsl:text>
      </sup>
    </xsl:if>
  </xsl:template>

  <xsl:template match="primary-responsibility">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <xsl:template match="stdtitle">
    <i>
      <xsl:value-of select="normalize-space(.)"/>
    </i>
  </xsl:template>

  <xsl:template match="subtitle">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <xsl:template match="pubdate">
    <!-- If  an ISO standard then the pub date should already be in the
	 stdnumber, so do not output it -->
    <xsl:variable name="stdnumber" select="normalize-space(../stdnumber)"/>
    <xsl:if test="not(starts-with($stdnumber,'ISO'))">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ulink">
    <xsl:text> Available from the World Wide Web: </xsl:text>
    <xsl:variable name="href" select="normalize-space(.)"/>
    <xsl:text>&lt;</xsl:text>
    <a href="{$href}"><xsl:value-of select="$href"/></a>
    <xsl:text>&gt;.</xsl:text>
  </xsl:template>


  <!-- check that all bibitems have been published, if not output
       footnote -->
  <xsl:template match="bibliography" mode="unpublished_bibitems_footnote">
    <!-- collect up all bibitems -->
    <xsl:variable name="bibitems">
      <bibitems>
	<!-- collect up the documents -->
	<xsl:apply-templates
           select="." 
           mode="collect_bibitems"/>
      </bibitems>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
	<xsl:variable name="bibitem_nodes"
		      select="msxsl:node-set($bibitems)"/>
	<xsl:if test="$bibitem_nodes//bibitem[@published='n']">
          <table width="200">
            <tr>
              <td><hr/></td>
            </tr>
            <tr>
              <td>
		<a name="tobepub">
                  <sup>1)</sup> To be published.
		</a>
              </td>
            </tr>
          </table>
	</xsl:if>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
	<xsl:variable name="bibitem_nodes"
		      select="exslt:node-set($bibitems)"/>
	<xsl:if test="$bibitem_nodes//bibitem[@published='n']">
          <table width="200">
            <tr>
              <td><hr/></td>
            </tr>
            <tr>
              <td>
		<a name="tobepub">
                  <sup>1)</sup> To be published.
		</a>
              </td>
            </tr>
          </table>
	</xsl:if>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>

  <!-- collect up all bibitems in order to check for unpublished bib items -->
  <xsl:template match="bibliography"  mode="collect_bibitems">
    <xsl:variable name="bibitem_list" 
		  select="document($bibliography_path)/bibitem.list"/>

    <xsl:for-each select="bibitem">
      <xsl:element name="bibitem">
	<xsl:if test="@published='n'">
          <xsl:attribute name="published">
            <xsl:value-of select="'n'"/>
          </xsl:attribute>
	</xsl:if>
      </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="bibitem.inc">
      <xsl:variable name="ref" select="@ref"/>
      <xsl:variable name="bibitem_inc" select="$bibitem_list/bibitem[@id=$ref]"/>
      <xsl:element name="bibitem">
	<xsl:if test="$bibitem_inc/@published='n'">
          <xsl:attribute name="published">
            <xsl:value-of select="'n'"/>
          </xsl:attribute>
	</xsl:if>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="bibitem.ap">
    <!-- the value from which to start the counting. -->
    <xsl:param name="number_start" select="0"/>     
    <xsl:variable name="part_name" select="@name"/>
    <xsl:variable name="ap_ok">
      <xsl:call-template name="check_application_protocol_exists">
        <xsl:with-param name="application_protocol" select="$part_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string($ap_ok)='true'">
        <xsl:variable name="ap_dir"
		      select="concat('../../data/application_protocols/', $part_name)"/>
        <xsl:variable name="ap_xml" select="concat($ap_dir,'/application_protocol.xml')"/>
        <xsl:variable name="ap_nodes" select="document($ap_xml)"/>
        <xsl:variable name="number" select="position()"/>
        <p>
          [<xsl:value-of select="$number_start+$number"/>] 
          <xsl:apply-templates select="$ap_nodes/application_protocol" mode="bibitem"/>
        </p>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of
               select="concat('Error bib 1: ', $ap_ok,
		       'Check the bibliography ')"
               />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="bibitem.module">
    <!-- the value from which to start the counting. -->
    <xsl:param name="number_start" select="0"/>     
    <xsl:variable name="module" select="@name"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$module_ok='true'">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="$module"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="module_xml" select="concat($module_dir,'/module.xml')"/>
        <xsl:variable name="module_nodes" select="document($module_xml)"/>
        <xsl:variable name="number" select="position()"/>
        <p>
          [<xsl:value-of select="$number_start+$number"/>] 
          <xsl:apply-templates select="$module_nodes/module" mode="bibitem"/>
        </p>
        
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of
               select="concat('Error bib 1: ', $module_ok,
		       'Check the bibliography ')"
               />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="bibitem.resource ">
    <!-- the value from which to start the counting. -->
    <xsl:param name="number_start" select="0"/>     
    <xsl:variable name="resdoc" select="@name"/>
    <xsl:variable name="resdoc_ok">
      <xsl:call-template name="check_resdoc_exists">
        <xsl:with-param name="resdoc" select="$resdoc"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string($resdoc_ok)='true'">
        <xsl:variable name="resdoc_dir"
		      select="concat('../../data/resource_docs/', $resdoc)"/>
        
        <xsl:variable name="resdoc_xml" select="concat($resdoc_dir,'/resource.xml')"/>
        <xsl:variable name="resdoc_nodes" select="document($resdoc_xml)"/>
        <xsl:variable name="number" select="position()"/>
        <p>
          [<xsl:value-of select="$number_start+$number"/>] 
          <xsl:apply-templates select="$resdoc_nodes/resource" mode="bibitem"/>
        </p>
        
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of
               select="concat('Error bib 1: ', $resdoc_ok,
		       'Check the bibliography ')"
               />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
