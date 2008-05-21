<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_introduction.xsl,v 1.10 2008/01/30 21:39:41 darla Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output introduction as a web page
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">

  <xsl:import href="resource.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="resource_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="resource">
  <xsl:apply-templates select="purpose"/>
</xsl:template>


<!-- =============================================== -->

<xsl:template match="purpose">
  <h2>
    <a name="introduction">
      Introduction
    </a>
  </h2>

  <p>
    ISO 10303 is an International Standard for the computer-interpretable 
    representation of product information and for the exchange of product data.
    The objective is to provide a neutral mechanism capable of describing
    products throughout their life cycle. This mechanism is suitable not only
    for neutral file exchange, but also as a basis for implementing and
    sharing product databases, and as a basis 
    for archiving.
  </p>
  <xsl:variable name="doctype" >
    <xsl:apply-templates select="ancestor::*[last()]" mode="doctype"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$doctype='igr' or $doctype='iar'">
      <xsl:choose>
	<xsl:when test="count(../schema)>1">
	  <p>This part of ISO 10303 is a member of the 
	  

	  <xsl:apply-templates select="ancestor::resource" mode="intro_type"/>

	  series. 


	  Major subdivisions of this part of ISO 10303 are: 
	  </p>
	  <ul>
	    <xsl:for-each select="../schema"> 
	      <li>
		<xsl:choose>
		  <xsl:when test="position()!=last()">
		    <xsl:value-of select="concat(@name,';')"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="concat(@name,'.')"/>        
		  </xsl:otherwise>
		</xsl:choose>
	      </li>
	    </xsl:for-each>

	  </ul>
	</xsl:when>

	<xsl:otherwise>

	  <p>This part of ISO 10303 is a member of the integrated resource series. This part of ISO 10303 specifies the 
	  <xsl:value-of select="../schema[1]/@name" />.</p>
	</xsl:otherwise>
      </xsl:choose>


      <!-- output any issues -->
      <xsl:apply-templates select=".." mode="output_clause_issue">
	<xsl:with-param name="clause" select="'purpose'"/>
      </xsl:apply-templates>
<!-- output explicit text from the purpose tag -->
      <xsl:apply-templates/>

      <!-- prepare variables to output list of used schemas and parts -->
      
      <p>The relationships of the schemas in this part of ISO 10303 to other schemas that define the integrated resources of ISO 10303 are illustrated in Figure 1 using the EXPRESS-G notation. 
      EXPRESS-G is defined in ISO 10303-11.  
      </p>
      <xsl:variable name="used" >
	<xsl:apply-templates select="../schema_diag" mode="use_reference_list" />
      </xsl:variable>
      <xsl:choose>
	<xsl:when test="function-available('msxsl:node-set')">

	  <xsl:variable name="used-node-set" select="msxsl:node-set($used)" />

	  <xsl:apply-templates select="$used-node-set/ref-list" />

	</xsl:when>
	
	<xsl:when test="function-available('exslt:node-set')">

	  <xsl:variable name="used-node-set" select="exslt:node-set($used)"/>

	  <xsl:apply-templates select="$used-node-set/ref-list" />


	</xsl:when>

      </xsl:choose>

      <p>The schemas illustrated in Figure 1 are components of the integrated resources.</p>

  <xsl:apply-templates select="//schema_diag" />

    </xsl:when>

    <xsl:when test="$doctype='aic'">

      An application interpreted construct (AIC) provides a logical grouping of interpreted constructs that supports a specific functionality for the usage of product data across multiple application contexts. An interpreted construct is a common interpretation of the integrated resources that supports shared information requirements among application protocols.
<!-- output explicit text from the purpose tag -->. 
      <xsl:apply-templates/>

    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<xsl:template match="schema_diag" mode="use_reference_list" >
	<xsl:variable name="local-schemas" select="../schema" />
	<ref-list>
	  <xsl:for-each select="express-g/imgfile">
	    <xsl:for-each select="document(@file)//img.area[@href]" >
		<xsl:variable name="this-schema" select="substring-after(@href,'#')" />
		<xsl:if test="not($local-schemas[@name=$this-schema])" >    
		<used-schema><xsl:value-of select="$this-schema" /></used-schema>
		</xsl:if>
	    </xsl:for-each>
    </xsl:for-each>
	</ref-list>
</xsl:template>


<xsl:template match="ref-list" >
	<xsl:variable name="used-count" select="count(used-schema[not(.=preceding-sibling::used-schema)])" />
	<xsl:choose>
		<xsl:when test="$used-count = 1" >
			<p>The <xsl:value-of select="./used-schema[1]" /> shown in Figure 1 is found in 
				<xsl:apply-templates select="./used-schema[1]" mode="reference" />
			</p>
		</xsl:when>

		<xsl:when test="$used-count > 1" >
			<p>
			The following schemas shown in Figure 1 are not found in this part of ISO 10303, but are found in ISO 10303-41:
			</p>
			<ul>
			  <xsl:for-each select="used-schema[not(.=preceding-sibling::used-schema)]">
			  	<xsl:sort />
				<li>
				<xsl:value-of select="." /> <!-- is found in
				<xsl:apply-templates select="." mode="reference" /> -->
                                  <xsl:choose>
                                    <xsl:when test="position()!=last()">
                                      <xsl:value-of select="';'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:value-of select="'.'"/>        
                                    </xsl:otherwise>
                                  </xsl:choose>
				</li>
			    </xsl:for-each>
			</ul>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="used-schema" mode="reference" >
	<xsl:variable name="schema-name" select="string(.)" />
  <xsl:variable name="resource_dir">
    <xsl:call-template name="resource_directory">
      <xsl:with-param name="resource" select="$schema-name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="express_xml" select="concat($resource_dir,'/',$schema-name,'.xml')"/>

  <xsl:variable name="ref" select="document($express_xml)/express/@reference"/>

	<xsl:choose>
		<xsl:when test="$ref" >
			<xsl:value-of select="$ref" />
		</xsl:when>
		<xsl:otherwise>
	          <xsl:call-template name="error_message">
        	    <xsl:with-param name="message">
	              <xsl:value-of select="concat('@reference not specified in express entity for resource schema',
		      $schema-name)"/>
        	    </xsl:with-param>
	          </xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>	

</xsl:template>

<xsl:template match="resource" mode="intro_type">
  <xsl:choose>
	<xsl:when test="@part >  499">
	  application interpreted construct</xsl:when>
	<xsl:when test="@part >  99">
	  integrated resource</xsl:when>
	<xsl:when test="@part &lt;  99">
	  integrated resource</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="error_message">
		<xsl:with-param 
			name="message" 
			select="concat('Error : unknown type,  part number:', @part)"/>
	  </xsl:call-template>
	</xsl:otherwise>
  </xsl:choose>

</xsl:template>

</xsl:stylesheet>