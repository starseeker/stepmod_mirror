<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:param name="filename_root"/>
  <xsl:template match="list" priority="2.0">
    <xsl:variable name="sort" select="replace(replace(@type,'BY_NAME','name'),'BY_NUMBER','number')"/>
    <xsl:call-template name="doc_list">
      <xsl:with-param name="sort" select="$sort"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="doc_list">
    <xsl:param name="sort"/>
    <xsl:variable name="pairs">
      <xsl:call-template name="get_pairs">
	<xsl:with-param name="sort" select="$sort"/>
	<xsl:with-param name="series"/>
      </xsl:call-template>
    </xsl:variable>
    <table border="1">
      <col align="right" valign="top"/>
      <col align="left" valign="top"/>
      <col align="right" valign="top"/>
      <col align="left" valign="top"/>
      <tr>
	<th align="center">Part</th>
	<th align="center">Name</th>
	<th align="center">Edition</th>
	<th align="center">Published</th>
      </tr>
      <xsl:for-each select="$pairs/pair">
	<xsl:variable name="directory">
	  <xsl:call-template name="get_directory"/>
	</xsl:variable>
	<xsl:variable name="file_ref">
	  <xsl:call-template name="get_file_ref">
	    <xsl:with-param name="model"/>
	    <xsl:with-param name="type"/>
	    <xsl:with-param name="pound"/>
	  </xsl:call-template>
	</xsl:variable>
	<tr>
	  <td><xsl:value-of select="doc/@part"/></td>
	  <td>
	    <a href="{$file_ref}" target="info">
	      <xsl:value-of select="doc/@name"/>
	    </a>
	    <xsl:if test="doc/tc">
	      <xsl:for-each select="doc/tc">
		<xsl:variable name="file_ref1">
		  <xsl:value-of select="concat('../../resource_docs/',$directory,'/',@filename)"/>
		</xsl:variable>
		<br/>
		&#160;&#160;&#160;&#160;<a href="{$file_ref1}" target="info"><xsl:value-of select="concat('TC ',@cor,': ',@pub_year_mo)"/></a>
	      </xsl:for-each>
	    </xsl:if>
	  	<xsl:if test="doc/dam">
	  		<xsl:for-each select="doc/dam">
	  			<xsl:variable name="file_ref1">
	  				<xsl:value-of select="concat('../../resource_docs/',$directory,'/',@filename)"/>
	  			</xsl:variable>
	  			<br/>
	  			&#160;&#160;&#160;&#160;<a href="{$file_ref1}" target="info"><xsl:value-of select="concat('DAM ',@cor,': ',@pub_year_mo)"/></a>
	  		</xsl:for-each>
	  	</xsl:if>
	  	<xsl:if test="doc/fdam">
	  		<xsl:for-each select="doc/fdam">
	  			<xsl:variable name="file_ref1">
	  				<xsl:value-of select="concat('../../resource_docs/',$directory,'/',@filename)"/>
	  			</xsl:variable>
	  			<br/>
	  			&#160;&#160;&#160;&#160;<a href="{$file_ref1}" target="info"><xsl:value-of select="concat('FDAM ',@cor,': ',@pub_year_mo)"/></a>
	  		</xsl:for-each>
	  	</xsl:if>
	  	<xsl:if test="doc/amendment">
	  		<xsl:for-each select="doc/amendment">
	  			<xsl:variable name="file_ref1">
	  				<xsl:value-of select="concat('../../resource_docs/',$directory,'/',@filename)"/>
	  			</xsl:variable>
	  			<br/>
	  			&#160;&#160;&#160;&#160;<a href="{$file_ref1}" target="info"><xsl:value-of select="concat('AMENDMENT ',@cor,': ',@pub_year_mo)"/></a>
	  		</xsl:for-each>
	  	</xsl:if>
	  </td>
	  <td><xsl:value-of select="doc/@edition"/></td>
	  <td><xsl:value-of select="doc/@pub_year_mo"/></td>
	</tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  <xsl:template match="index" priority="2.0">
    <xsl:if test="@method = 'top'">
      <small>
	<a href="frame_index.htm" target="index">Back to navigation indices</a>
      </small>
      <br/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@index_type eq 'BY_NAME'">
	<xsl:if test="@method = 'top'">
	  <b>Parts</b>
	  <br/>
	</xsl:if>
	<xsl:call-template name="doc_index">
	  <xsl:with-param name="sort">name</xsl:with-param>
	  <xsl:with-param name="series"/>
	  <xsl:with-param name="model"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="@index_type eq 'BY_NUMBER'">
	<xsl:if test="@method = 'top'">
	  <b>Parts</b>
	  <br/>
	</xsl:if>
	<xsl:call-template name="doc_index">
	  <xsl:with-param name="sort">number</xsl:with-param>
	  <xsl:with-param name="series"/>
	  <xsl:with-param name="model"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="@index_type eq 'RESOURCE_SCHEMAS'">
	<xsl:if test="@method = 'top'">
	  <b>Resource schemas</b>
	  <br/>
	</xsl:if>
	<xsl:call-template name="section">
	  <xsl:with-param name="anchor">resource_schemas</xsl:with-param>
	  <xsl:with-param name="title"/>
	  <xsl:with-param name="local_name">schema</xsl:with-param>
	  <xsl:with-param name="type">resource</xsl:with-param>
	  <xsl:with-param name="model">mim</xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="@index_type eq 'MODULE_ARMS'">
	<xsl:if test="@method = 'top'">
	  <b>Module ARMs</b>
	  <br/>
	</xsl:if>
	<xsl:call-template name="doc_index">
	  <xsl:with-param name="sort">name</xsl:with-param>
	  <xsl:with-param name="series">AM</xsl:with-param>
	  <xsl:with-param name="model">arm</xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="@index_type eq 'MODULE_MIMS'">
	<xsl:if test="@method = 'top'">
	  <b>Module MIMs</b>
	  <br/>
	</xsl:if>
	<xsl:call-template name="doc_index">
	  <xsl:with-param name="sort">name</xsl:with-param>
	  <xsl:with-param name="series">AM</xsl:with-param>
	  <xsl:with-param name="model">mim</xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="@index_type eq 'ARM_EXPRESS'">
	<xsl:if test="@method = 'top'">
	  <b>ARM EXPRESS</b>
	  <br/>
	</xsl:if>
	<xsl:call-template name="do_sections">
	  <xsl:with-param name="model">arm</xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="@index_type eq 'MIM_EXPRESS'">
	<xsl:if test="@method = 'top'">
	  <b>MIM EXPRESS</b>
	  <br/>
	</xsl:if>
	<xsl:call-template name="do_sections">
	  <xsl:with-param name="model">mim</xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>Error: Invalid index_type: <xsl:value-of select="@index_type"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get_directory">
    <xsl:variable name="cdr" select="element()[2]"/>
  	<!--<xsl:message select="$cdr"></xsl:message>-->
    <xsl:choose>
      <xsl:when test="$cdr/@directory">
	<xsl:value-of select="$cdr/@directory"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$cdr/@name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get_pairs">
    <xsl:param name="sort"/>
    <xsl:param name="series"/>
    <xsl:choose>
      <xsl:when test="$sort eq 'name'">
	<xsl:apply-templates select="document('../../library/docs.xml',.)/docs/doc[(string-length($series) eq 0) or (@series eq $series)]" mode="index">
	  <xsl:with-param name="sort" select="$sort"/>
	  <xsl:sort select="@name"/>
	</xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$sort eq 'number'">
	<xsl:apply-templates select="document('../../library/docs.xml',.)/docs/doc[(string-length($series) eq 0) or (@series eq $series)]" mode="index">
	  <xsl:with-param name="sort" select="$sort"/>
	  <xsl:sort select="@part" data-type="number"/>
	</xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="doc_index">
    <xsl:param name="sort"/>
    <xsl:param name="series"/>
    <xsl:param name="model"/>
    <xsl:variable name="pairs">
      <xsl:call-template name="get_pairs">
	<xsl:with-param name="sort" select="$sort"/>
	<xsl:with-param name="series" select="$series"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="generate_index">
      <xsl:with-param name="anchor">docs</xsl:with-param>
      <xsl:with-param name="title"/>
      <xsl:with-param name="model" select="$model"/>
      <xsl:with-param name="type"/>
      <xsl:with-param name="pairs" select="$pairs"/>
      <xsl:with-param name="pound" select="'false'"/>
      <xsl:with-param name="numeric">
	<xsl:choose>
	  <xsl:when test="$sort eq 'number'">
	    <xsl:text>true</xsl:text>
	  </xsl:when>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="doc" mode="index">
    <xsl:param name="sort"/>
    <xsl:choose>
      <xsl:when test="$sort eq 'name'">
	<pair>
	  <key-str><xsl:value-of select="@name"/></key-str>
	  <xsl:copy-of select="."/>
	</pair>
      </xsl:when>
      <xsl:when test="$sort eq 'number'">
	<pair>
	  <key-str><xsl:value-of select="@part"/></key-str>
	  <xsl:copy-of select="."/>
	</pair>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>Error: invalid sort: <xsl:value-of select="$sort"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="do_sections">
    <xsl:param name="model"/>
    <xsl:call-template name="section">
      <xsl:with-param name="anchor">constants</xsl:with-param>
      <xsl:with-param name="title">Constants</xsl:with-param>
      <xsl:with-param name="local_name">constant</xsl:with-param>
      <xsl:with-param name="type">module</xsl:with-param>
      <xsl:with-param name="model" select="$model"/>
    </xsl:call-template>
    <br/>
    <xsl:call-template name="section">
      <xsl:with-param name="anchor">types</xsl:with-param>
      <xsl:with-param name="title">Types</xsl:with-param>
      <xsl:with-param name="local_name">type</xsl:with-param>
      <xsl:with-param name="type">module</xsl:with-param>
      <xsl:with-param name="model" select="$model"/>
    </xsl:call-template>
    <br/>
    <xsl:call-template name="section">
      <xsl:with-param name="anchor">entities</xsl:with-param>
      <xsl:with-param name="title">Entities</xsl:with-param>
      <xsl:with-param name="local_name">entity</xsl:with-param>
      <xsl:with-param name="type">module</xsl:with-param>
      <xsl:with-param name="model" select="$model"/>
    </xsl:call-template>
    <br/>
    <xsl:call-template name="section">
      <xsl:with-param name="anchor">rules</xsl:with-param>
      <xsl:with-param name="title">Rules</xsl:with-param>
      <xsl:with-param name="local_name">rule</xsl:with-param>
      <xsl:with-param name="type">module</xsl:with-param>
      <xsl:with-param name="model" select="$model"/>
    </xsl:call-template>
    <br/>
    <xsl:call-template name="section">
      <xsl:with-param name="anchor">algorithms</xsl:with-param>
      <xsl:with-param name="title">Algorithms</xsl:with-param>
      <xsl:with-param name="local_name">algorithm</xsl:with-param>
      <xsl:with-param name="type">module</xsl:with-param>
      <xsl:with-param name="model" select="$model"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="section">
    <xsl:param name="anchor"/>
    <xsl:param name="title"/>
    <xsl:param name="local_name"/>
    <xsl:param name="type"/>
    <xsl:param name="model"/>
    <xsl:variable name="xmlfile">
      <xsl:choose>
	<xsl:when test="$model eq 'arm'">
	  <xsl:text>../../library/arm_index.xml</xsl:text>
	</xsl:when>
	<xsl:when test="$model eq 'mim'">
	  <xsl:text>../../library/mim_ir_index.xml</xsl:text>
	</xsl:when>
	<xsl:otherwise>	  
		<xsl:text>../../library/docs.xml</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pairs">
      <xsl:apply-templates select="document($xmlfile,.)/express_index/element()[fn:local-name() eq $local_name and @type = $type]" mode="generate-pv">
	<xsl:sort select="fn:lower-case(@name)"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="pound">
      <xsl:choose>
	<xsl:when test="$type eq 'resource'">
	  <xsl:value-of select="'false'"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="'true'"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="generate_index">
      <xsl:with-param name="anchor" select="$anchor"/>
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="model" select="$model"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:with-param name="pairs" select="$pairs"/>
      <xsl:with-param name="pound" select="$pound"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="generate_index">
    <xsl:param name="anchor"/>
    <xsl:param name="title"/>
    <xsl:param name="model"/>
    <xsl:param name="type"/>
    <xsl:param name="pairs"/>
    <xsl:param name="pound"/>
    <xsl:param name="numeric"/>
    <small>
      <xsl:choose>
	<xsl:when test="@method = 'top'">
	  <xsl:if test="fn:string-length($title) gt 0">
	    <a href="index_{$model}_express_inner.htm#{$anchor}" target="toc_inner">
	      <b>
		<xsl:value-of select="concat($title,':')"/>
	      </b>
	    </a>
	  </xsl:if>
	  <xsl:call-template name="generate_index_top">
	    <xsl:with-param name="pairs" select="$pairs"/>
	    <xsl:with-param name="anchor" select="$anchor"/>
	    <xsl:with-param name="model" select="$model"/>
	    <xsl:with-param name="numeric" select="$numeric"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="@method = 'inner'">
	  <xsl:if test="fn:string-length($title) gt 0">
	    <a name="{$anchor}">
	      <b>
		<xsl:value-of select="$title"/>
	      </b>
	    </a>
	    <br/>
	  </xsl:if>
	  <xsl:call-template name="generate_index_inner">
	    <xsl:with-param name="pairs" select="$pairs"/>
	    <xsl:with-param name="anchor" select="$anchor"/>
	    <xsl:with-param name="model" select="$model"/>
	    <xsl:with-param name="type" select="$type"/>
	    <xsl:with-param name="pound" select="$pound"/>
	    <xsl:with-param name="numeric" select="$numeric"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message>Error: Invalid method</xsl:message>
	</xsl:otherwise>
      </xsl:choose>
    </small>
  </xsl:template>
  <xsl:template match="schema|constant|type|entity|rule|algorithm" mode="generate-pv">
    <pair>
      <key-str><xsl:value-of select="@name"/></key-str>
      <xsl:copy-of select="."/>
    </pair>
  </xsl:template>
  <xsl:template name="generate_index_top">
    <xsl:param name="pairs"/>
    <xsl:param name="anchor"/>
    <xsl:param name="model"/>
    <xsl:param name="numeric"/>
    <xsl:for-each select="$pairs/pair">
      <xsl:variable name="c1">
	<xsl:choose>
	  <xsl:when test="$numeric eq 'true'">
	    <xsl:value-of select="floor(number(key-str) div 100)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="fn:lower-case(substring(key-str,1,1))"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:variable name="c1_prev">
	<xsl:choose>
	  <xsl:when test="$numeric eq 'true'">
	    <xsl:value-of select="floor(number(preceding-sibling::pair[1]/key-str) div 100)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="fn:lower-case(substring(preceding-sibling::pair[1]/key-str,1,1))"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:if test="$c1 != $c1_prev">
	<xsl:text> </xsl:text>
	<a href="{fn:replace($filename_root,'_top$','')}_inner.htm#{$anchor}-letter-{$c1}" target="toc_inner">
	  <xsl:value-of select="fn:upper-case($c1)"/>
	</a>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="generate_index_inner">
    <xsl:param name="pairs"/>
    <xsl:param name="anchor"/>
    <xsl:param name="model"/>
    <xsl:param name="type"/>
    <xsl:param name="pound"/>
    <xsl:param name="numeric"/>
    <!-- <xsl:message>type = <xsl:value-of select="type"/></xsl:message> -->
    <!-- <xsl:message>model = <xsl:value-of select="model"/></xsl:message> -->
    <xsl:for-each select="$pairs/pair">
      <!-- <xsl:message>loop: <xsl:copy-of select="."/></xsl:message> -->
      <xsl:variable name="c1">
	<xsl:choose>
	  <xsl:when test="$numeric eq 'true'">
	    <xsl:value-of select="floor(number(key-str) div 100)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="fn:lower-case(substring(key-str,1,1))"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:variable name="c1_prev">
	<xsl:choose>
	  <xsl:when test="$numeric eq 'true'">
	    <xsl:value-of select="floor(number(preceding-sibling::pair[1]/key-str) div 100)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="fn:lower-case(substring(preceding-sibling::pair[1]/key-str,1,1))"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:if test="$c1 != $c1_prev">
	<xsl:if test="preceding-sibling::pair[1]">
	  <br/>
	</xsl:if>
	<br/>
	<a name="{$anchor}-letter-{$c1}">
	  <b>
	    <xsl:value-of select="fn:upper-case($c1)"/>
	  </b>
	</a>
	<br/>
      </xsl:if>
      <br/>
      <xsl:variable name="file_ref">
	<xsl:call-template name="get_file_ref">
	  <xsl:with-param name="model" select="$model"/>
	  <xsl:with-param name="type" select="$type"/>
	  <xsl:with-param name="pound" select="$pound"/>
	</xsl:call-template>
      </xsl:variable>
      <!-- <xsl:message>file_ref = <xsl:value-of select="$file_ref"/></xsl:message> -->
      <a href="{$file_ref}" target="info">
	<xsl:value-of select="key-str"/>
	<xsl:if test="($numeric ne 'true') and (doc/@series ne 'AM')">
	  <xsl:variable name="doc_kind" select="replace(replace(doc/@series,'IAR','IR'),'IGR','IR')"/>
	  <xsl:text> (</xsl:text>
	  <xsl:value-of select="$doc_kind"/>
	  <xsl:text>)</xsl:text>
	</xsl:if>
      </a>
      <xsl:if test="doc/tc">
	<xsl:variable name="directory">
	  <xsl:call-template name="get_directory"/>
	</xsl:variable>
	<xsl:text> [TC </xsl:text>
	<xsl:for-each select="doc/tc">
	  <xsl:variable name="file_ref1">
	    <xsl:value-of select="concat('../../resource_docs/',$directory,'/',@filename)"/>
	  </xsl:variable>
	  <a href="{$file_ref1}" target="info"><xsl:value-of select="@cor"/></a>
	  <xsl:if test="position() lt last()">
	    <xsl:text>, </xsl:text>
	  </xsl:if>
	</xsl:for-each>
	<xsl:text>]</xsl:text>
      </xsl:if>
    	<xsl:if test="doc/dam">
    		<xsl:variable name="directory">
    			<xsl:call-template name="get_directory"/>
    		</xsl:variable>
    		<xsl:text> [DAM </xsl:text>
    		<xsl:for-each select="doc/dam">
    			<xsl:variable name="file_ref1">
    				<xsl:value-of select="concat('../../resource_docs/',$directory,'/',@filename)"/>
    			</xsl:variable>
    			<a href="{$file_ref1}" target="info"><xsl:value-of select="@cor"/></a>
    			<xsl:if test="position() lt last()">
    				<xsl:text>, </xsl:text>
    			</xsl:if>
    		</xsl:for-each>
    		<xsl:text>]</xsl:text>
    	</xsl:if>
    	<xsl:if test="doc/fdam">
    		<xsl:variable name="directory">
    			<xsl:call-template name="get_directory"/>
    		</xsl:variable>
    		<xsl:text> [FDAM </xsl:text>
    		<xsl:for-each select="doc/fdam">
    			<xsl:variable name="file_ref1">
    				<xsl:value-of select="concat('../../resource_docs/',$directory,'/',@filename)"/>
    			</xsl:variable>
    			<a href="{$file_ref1}" target="info"><xsl:value-of select="@cor"/></a>
    			<xsl:if test="position() lt last()">
    				<xsl:text>, </xsl:text>
    			</xsl:if>
    		</xsl:for-each>
    		<xsl:text>]</xsl:text>
    	</xsl:if>
    	<xsl:if test="doc/amendment">
    		<xsl:variable name="directory">
    			<xsl:call-template name="get_directory"/>
    		</xsl:variable>
    		<xsl:text> [AMENDMENT </xsl:text>
    		<xsl:for-each select="doc/amendment">
    			<xsl:variable name="file_ref1">
    				<xsl:value-of select="concat('../../resource_docs/',$directory,'/',@filename)"/>
    			</xsl:variable>
    			<a href="{$file_ref1}" target="info"><xsl:value-of select="@cor"/></a>
    			<xsl:if test="position() lt last()">
    				<xsl:text>, </xsl:text>
    			</xsl:if>
    		</xsl:for-each>
    		<xsl:text>]</xsl:text>
    	</xsl:if>
    </xsl:for-each>
    <br/>
  </xsl:template>
  <xsl:template name="get_file_ref">
    <xsl:param name="model"/>
    <xsl:param name="type"/>
    <xsl:param name="pound"/>
    <xsl:variable name="eltname" select="element()[2]/@name"/>
    <!-- <xsl:message>eltname = <xsl:value-of select="$eltname"/></xsl:message> -->
    <xsl:variable name="filename">
      <xsl:choose>
	<xsl:when test="$type eq 'resource'">
	  <xsl:value-of select="concat($eltname,'.htm')"/>
	</xsl:when>
	<xsl:when test="$model eq 'arm'">
	  <xsl:text>4_info_reqs.htm</xsl:text>
	</xsl:when>
	<xsl:when test="$model eq 'mim'">
	  <xsl:text>5_mim.htm</xsl:text>
	</xsl:when>
	<xsl:when test="doc/@filename">
	  <xsl:value-of select="doc/@filename"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>cover.htm</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
     <!--<xsl:message>filename = <xsl:value-of select="$filename"/></xsl:message>--> 
    <xsl:variable name="directory">
      <xsl:call-template name="get_directory"/>
    </xsl:variable>
     <!--<xsl:message>directory = <xsl:value-of select="$directory"/></xsl:message>--> 
    <xsl:variable name="suffix">
      <xsl:choose>
	<xsl:when test="$pound eq 'true'">
	  <xsl:value-of select="concat('#',$directory,'_',$model,'.',$eltname)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
     <!--<xsl:message>suffix = <xsl:value-of select="$suffix"/></xsl:message>--> 
    <xsl:choose>
      <xsl:when test="$type eq 'resource'">
	<xsl:value-of select="concat('../../resources/',$directory,'/',$filename)"/>
      </xsl:when>
      <xsl:when test="(string-length(doc/@series) eq 0) or (doc/@series eq 'AM')">
	<xsl:value-of select="concat('../../modules/',$directory,'/sys/',$filename,$suffix)"/>
      </xsl:when>
      <xsl:when test="doc/@format eq 'html-stepmod'">
	<xsl:value-of select="concat('../../resource_docs/',$directory,'/sys/',$filename,$suffix)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('../../resource_docs/',$directory,'/',$filename)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
