<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: extract_descriptions.xsl,v 1.13 2004/11/16 07:30:26 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to extract the description elements out of a an EXPRESS XML file
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="../common.xsl"/>

<xsl:output 
  method="xml"
  indent="yes"
  omit-xml-declaration="yes"
  doctype-system="../../../dtd/description.dtd"
  encoding="utf-8"
  />





<xsl:template match="express">

<xsl:processing-instruction name="xml-stylesheet">
  type="text/xsl" 
  href="../../../xsl/descriptions.xsl"</xsl:processing-instruction>

  <xsl:element name="ext_descriptions">
    <xsl:attribute name="module_directory">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="./schema/@name"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:variable name="type"
      select="substring(./schema/@name, string-length(./schema/@name)-3)"/>

    <xsl:attribute name="schema_file">
      <xsl:choose>
        <xsl:when test="$type='_mim'">
          <xsl:value-of select="'mim.xml'"/>
        </xsl:when>
        <xsl:when test="$type='_arm'">
          <xsl:value-of select="'arm.xml'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(string(./schema/@name),'.xml')"/> 
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
		
    <xsl:attribute name="describe.selects">
      <xsl:value-of select="'YES'"/>
    </xsl:attribute>

    <xsl:attribute name="describe.subtype_constraints">
      <xsl:value-of select="'YES'"/>
    </xsl:attribute>

  <xsl:attribute name="rcs.date">
    <xsl:value-of select="'$Date: 2004/11/16 07:30:26 $'"/>
  </xsl:attribute>
  <xsl:attribute name="rcs.revision">
    <xsl:value-of select="'$Revision: 1.13 $'"/>
  </xsl:attribute>

    <xsl:apply-templates select="schema">      
      <xsl:sort select="./schema/@name"/>
    </xsl:apply-templates> 
  </xsl:element>
</xsl:template>

<xsl:template match="description">
  <xsl:apply-templates select="node()" mode="copy"/>
</xsl:template>

<xsl:template match="*" mode="copy">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <!-- recurse through rest of the elements - a deep copy -->
    <xsl:apply-templates select="node()" mode="copy"/>
  </xsl:copy>
</xsl:template>



<xsl:template match="schema">
  <!-- 
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" select="translate(@name,$UPPER, $LOWER)"/>
  -->
  <xsl:variable name="linkend" select="@name"/>

  <xsl:comment> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Schema: <xsl:value-of select="@name"/>
  &#x20;<xsl:call-template name="output_express_ref">
    <xsl:with-param name="schema" select="@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
  <xsl:apply-templates select="./constant"/>
  <xsl:apply-templates select="./type"/>
  <xsl:apply-templates select="./entity"/>
  <xsl:apply-templates select="./rule"/>
  <xsl:apply-templates select="./function"/>
  <xsl:apply-templates select="./procedure"/>
  <xsl:apply-templates select="./subtype.constraint"/>
</xsl:template>


<xsl:template match="entity">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
  -->
  <xsl:variable name="linkend" 
    select="concat(../@name, '.', @name)"/>
  <xsl:variable name="entity"  select="@name"/>

  <xsl:text/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Entity: ',$entity,' ')"/> 
  &#x20;<xsl:call-template name="output_express_ref">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>

  <xsl:variable name="arm_mim"
    select="substring(../@name, string-length(../@name)-2)"/>

  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
    <xsl:choose>
      <!-- needs some work here to iterate through teh supertypes,
           to correctly identify the module -->
      <xsl:when test="string-length(@supertypes) !=0">
        <xsl:variable name="module" select="'module'"/>
        <xsl:variable name="exp_schema" select="'Module'"/>
        <xsl:variable name="supertypes" select="@supertypes"/>
        A <b><xsl:value-of select="$entity"/></b> is a type of
        <xsl:element name="express_ref">
          <xsl:attribute name="linkend">
            <xsl:value-of select="concat($module,':',$arm_mim,':',$exp_schema,'_',$arm_mim,'.',$supertypes)"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        A <b><xsl:value-of select="$entity"/></b> is a
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:element>
  <xsl:apply-templates select="explicit|derived|inverse"/>
  <xsl:apply-templates select="where"/>
  <xsl:apply-templates select="unique"/>
</xsl:template>


<xsl:template match="explicit|derived|inverse">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../../@name,$UPPER, $LOWER),
            '.',
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
  -->
  <xsl:variable name="linkend" 
    select="concat(../../@name,'.',../@name,'.',@name)"/>
  <xsl:variable name="entity"  select="../@name"/>

  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../../@name,' ')"/>
  <xsl:value-of select="concat(' Entity: ',$entity,' ')"/>
  <xsl:value-of select="concat(' Attribute: ',@name,' ')"/>
  &#x20;<xsl:call-template name="output_express_ref">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
    <xsl:choose>
      <xsl:when test="@name='id'">
       the identifier or set of identifiers for the <b><xsl:value-of select="$entity"/></b>.
    <xsl:if test="@optional='YES'">
      The value of this attribute need not be specified.
    </xsl:if>
<note>This attribute supports multi identification in different contexts as described in clause for <b>fundamental concepts</b>.</note>        
      </xsl:when>
      <xsl:when test="@name='name'">
        the words or set of words by which the <b><xsl:value-of select="$entity"/></b> is known.
	    <xsl:if test="@optional='YES'">
	      The value of this attribute need not be specified.
	    </xsl:if>
<note>This attribute supports multiple names in different contexts as well as multi linguism.</note>  
      </xsl:when>
      <xsl:when test="@name='description'">
        the text or the set of texts that provide further information about the <b><xsl:value-of select="$entity"/></b>.
	    <xsl:if test="@optional='YES'">
	      The value of this attribute need not be specified.
	    </xsl:if>
      </xsl:when>
      <xsl:when test="@name='versionId'">
        the identification or set of identifications of a particular version of the <b><xsl:value-of select="$entity"/></b>.
	    <xsl:if test="@optional='YES'">
	      The value of this attribute need not be specified.
	    </xsl:if>
<note>This attribute supports multi identification in different contexts as described in <b>clause for fundamental concepts</b></note>
      </xsl:when>

	      <xsl:when test="@name='classifiedAs'">
	        the classifications of the <b><xsl:value-of select="$entity"/></b>.
		    <xsl:if test="@optional='YES'">
		      The value of this attribute need not be specified.
		    </xsl:if>
	      </xsl:when>
	      <xsl:when test="@name='sameAs'">
	        the proxies of the <b><xsl:value-of select="$entity"/></b>.
		    <xsl:if test="@optional='YES'">
		      The value of this attribute need not be specified.
		    </xsl:if>
	      </xsl:when>
	      <xsl:when test="@name='role'">
	        the meaning of the assignment/association. 
	<xsl:if test="@optional='YES'">
		      The value of this attribute need not be specified.
		    </xsl:if>
		Where applicable, the following values shall be used: 
			<ul>
			<li>'value': value description; </li>
		</ul>
	      </xsl:when>
	
	      <xsl:when test="@name='relating'">
	        one object of <b>--relating_business object--</b> that is part of the relationship. 
		    <xsl:if test="@optional='YES'">
		      The value of this attribute need not be specified.
		    </xsl:if>
<note>The semantics of this attribute are defined by the attribute <b>relation_type</b>.</note>			
	      </xsl:when>
			      <xsl:when test="@name='related'">
			        the other object of <b>--related_business object--</b> that is part of the relationship. 
				    <xsl:if test="@optional='YES'">
				      The value of this attribute need not be specified.
				    </xsl:if>
		<note>The semantics of this attribute are defined by the attribute <b>relation_type</b>.</note>			
			      </xsl:when>
			      <xsl:when test="@name='relationType'">
			        the meaning of the relationship. 
				    <xsl:if test="@optional='YES'">
				      The value of this attribute need not be specified.
				    </xsl:if>
				Where applicable, the following class names shall be used:
						<ul>
						<li>'value': value description; </li>
					</ul>
			      </xsl:when>
    </xsl:choose>
  </xsl:element>
</xsl:template>

<xsl:template match="where">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../../@name,$UPPER, $LOWER),
            '.',
            translate(../@name,$UPPER, $LOWER),
            '.wr:',
            translate(@label,$UPPER, $LOWER))"/>
  -->
  <xsl:variable name="linkend" 
    select="concat(../../@name,'.',../@name,'.wr:',@label)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../../@name,' ')"/>
  <xsl:value-of select="concat(' Entity: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Where: ',@label,' ')"/>
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="rule" select="'wr'"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>

  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>


<xsl:template match="unique">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../../@name,$UPPER, $LOWER),
            '.',
            translate(../@name,$UPPER, $LOWER),
            '.ur:',
            translate(@label,$UPPER, $LOWER))"/>
  -->
  <xsl:variable name="linkend" 
    select="concat(../../@name,'.',../@name,'.ur:',@label)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../../@name,' ')"/>
  <xsl:value-of select="concat(' Entity: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Unique: ',@label,' ')"/>
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="rule" select="'ur'"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>



<xsl:template match="type">

  <xsl:variable name="typetype">
    <xsl:choose>
      <xsl:when test="./enumeration">Enumeration</xsl:when>
      <xsl:otherwise>Type</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
  -->
  <xsl:variable name="linkend" 
    select="concat(../@name,'.',@name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' ',$typetype': ',@name,' ')"/>
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
  <xsl:apply-templates select="./enumeration"/>
</xsl:template>


<xsl:template match="enumeration">
  <xsl:call-template name="output_enums">
    <xsl:with-param name="str" select="normalize-space(@items)"/>
  </xsl:call-template> 
</xsl:template>


<xsl:template name="output_enums">
  <xsl:param name="str"/>
  <xsl:variable name="break_char" select="' '"/>
  <xsl:choose>
    <xsl:when test="contains($str,$break_char)">
      <xsl:variable name="substr" 
        select="substring-before($str,$break_char)"/>
      <xsl:call-template name="output_enum_item">
        <xsl:with-param name="enum_value" select="$substr"/>
      </xsl:call-template> 
      
      <xsl:variable name="rest" select="substring-after($str,$break_char)"/>
      <xsl:call-template name="output_enums">
        <xsl:with-param name="str" select="$rest"/>
      </xsl:call-template> 
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="output_enum_item">
        <xsl:with-param name="enum_value" select="$str"/>
      </xsl:call-template> 
    </xsl:otherwise>        
  </xsl:choose>
</xsl:template>

<xsl:template name="output_enum_item">
  <xsl:param name="enum_value"/>
  <xsl:variable name="schema" select="../../@name"/>
  <xsl:variable name="enum_type" select="../@name"/>

  <xsl:variable name="linkend" 
    select="concat($schema,'.',$enum_type,'.',$enum_value)"/>

  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',$schema,' ')"/>
  <xsl:value-of select="concat(' Enumeration: ',$enum_type,' ')"/>
  <xsl:value-of select="concat(' Item: ',$enum_value,' ')"/>
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="$schema"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>



<xsl:template match="function">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
-->
  <xsl:variable name="linkend" 
    select="concat(../@name,'.',@name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Function: ',@name,' ')"/>
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>

<xsl:template match="rule">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
-->
  <xsl:variable name="linkend" 
    select="concat(../@name,'.',@name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Rule: ',@name,' ')"/>
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
  <xsl:apply-templates select="where"/>	
</xsl:template>

<xsl:template match="procedure">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
-->
  <xsl:variable name="linkend" 
    select="concat(../@name,'.',@name)"/>

  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Procedure: ',@name,' ')"/>
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>

</xsl:template>


<xsl:template match="constant">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
-->
  <xsl:variable name="linkend" 
    select="concat(../@name,'.',@name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Constant: ',@name,' ')"/>
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>


<xsl:template match="subtype.constraint">  
  <xsl:variable name="linkend" 
    select="concat(../@name, '.', @name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Subtype constraint: ',@name,' ')"/> 
  &#x20;<xsl:call-template name="output_express_ref">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>



<xsl:template match="described.item">

</xsl:template>

<xsl:template name="output_express_ref">
  <xsl:param name="schema"/>
  <xsl:param name="linkend"/>
  <xsl:param name="rule"/>
  <xsl:variable name="arm_mim">
    <xsl:choose>
      <xsl:when test="contains($schema,'_arm')">
        <xsl:value-of select="'arm'"/>
      </xsl:when>
      <xsl:when test="contains($schema,'_mim')">
        <xsl:value-of select="'mim'"/>
      </xsl:when>
      <xsl:when test="contains($schema,'_schema')">
        <xsl:value-of select="'ir_express'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="module">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" select="$schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of 
      select="concat('&lt;express_ref linkend=&quot;',
              $module,':',$arm_mim,':'$linkend,'&quot;/&gt;')"/>  
</xsl:template>




</xsl:stylesheet>