<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
-->
<!--
$Id: index_arm_mappings_inner.xsl,v 1.30 2013/10/01 20:19:17 thomasrthurman Exp $
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep Limited for NIST.
  Purpose: 
  	1) To display a complete index of mappings from the ARM level model of the AP
	2) To check that the index mappings exist. 
	NOTE: Mappings are indexed by examining the ARM EXPRESS and deriving the list of mappings,
	not by reading the list of mappings that are existant.
	
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="msxsl exslt"
                version="1.0">


<!--	<xsl:import href="../../xsl/express.xsl"/>
-->

  <xsl:import href="common.xsl"/>


  <xsl:variable name="selected_ap" select="/application_protocol/@directory"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/> 

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="UPPER_BACKSLASH" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ\'"/>
  <xsl:variable name="LOWER_FORWARDSLASH" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="ap_file" 
	    select="concat('../../data/application_protocols/',$selected_ap,'/application_protocol.xml')"/>
	    
  <xsl:variable name="ap_node"
	    select="document($ap_file)"/>

  <xsl:variable name="ap_top_module"
	    select="$ap_node/application_protocol/@module_name"/>

  <xsl:variable name="iframe-width"
	    select="150"/>

  <xsl:variable name="top_module_file" 
	    select="concat('../../data/modules/',$ap_top_module,'/arm.xml')"/>


  <xsl:template match="/" >
    <HTML>
    <head>
<!--      <link rel="stylesheet" type="text/css" 
        href="../../../../nav/css/developer.css"/>
-->
      <xsl:apply-templates select="$ap_node" mode="meta_data"/>
      <title>
        <xsl:value-of select="concat('AP Index for ',$selected_ap)"/>
      </title>

    </head>
  <body>
    <xsl:apply-templates select="/" mode="arm_mappings"/>	

  </body>
</HTML>
</xsl:template>

<xsl:template match="/" mode="arm_mappings" >


	<xsl:variable name="top_module_node"
	    select="document($top_module_file)/express"/>

	<xsl:variable name="schema-name"
	    select="$top_module_node//schema/@name"/>

			
	<xsl:variable name="arm_schemas" >
		<xsl:call-template name="depends-on-recurse-no-list-x">
			<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')" />
			<xsl:with-param name="done" select="' '" />
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="modules-list" >
		<xsl:call-template name="depends-on-recurse-no-list-x-modules">
			<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')" />
			<xsl:with-param name="done" select="' '" />
		</xsl:call-template>
	</xsl:variable>

      
      <xsl:choose>
	<xsl:when test="function-available('msxsl:node-set')">


		<xsl:variable name="schemas-node-set" select="msxsl:node-set($arm_schemas)" />

		<xsl:variable name="dep-schemas3">
			<xsl:for-each select="$schemas-node-set//x" >
				<xsl:sort /> <!-- added sort here which is not in the saxon version below -->
				<xsl:copy-of select="document(.)" />
			</xsl:for-each> -->
		</xsl:variable>

		<xsl:variable name="dep-schemas" 
		  	select="msxsl:node-set($dep-schemas3)" />
				
		<xsl:variable name="modules-node-set" select="msxsl:node-set($modules-list)" />

		<xsl:variable name="dep-modules1">
			<xsl:for-each select="$modules-node-set//x" >
				<xsl:sort /> <!-- added sort here which is not in the saxon version below -->
				<xsl:copy-of select="document(.)" />
			</xsl:for-each> -->
		</xsl:variable>


		<xsl:variable name="modules-node" 
		  	select="msxsl:node-set($dep-modules1)" />


			<xsl:call-template name="modules_index" >
				<xsl:with-param name="this-schema" select="$top_module_node" />
				<xsl:with-param name="called-schemas" select="$dep-schemas" />
				<xsl:with-param name="called-modules" select="$modules-node" />
			</xsl:call-template>

	</xsl:when>


	<xsl:when test="function-available('exslt:node-set')">

		  <xsl:variable name="schemas-node-set2">
		      <xsl:choose>
			<xsl:when test="2 > string-length($arm_schemas)" >
		        </xsl:when>
		        <xsl:otherwise>
		          <xsl:copy-of select="exslt:node-set($arm_schemas)"/>
		        </xsl:otherwise>
		      </xsl:choose>
		    </xsl:variable>

		<xsl:variable name="dep-schemas" select="document(exslt:node-set($schemas-node-set2)//x)" />

		  <xsl:variable name="modules-nodes2">
		      <xsl:choose>
			<xsl:when test="2 > string-length($modules-list)" >
		        </xsl:when>
		        <xsl:otherwise>
		          <xsl:copy-of select="exslt:node-set($modules-list)"/>
		        </xsl:otherwise>
		      </xsl:choose>
		    </xsl:variable>

		<xsl:variable name="modules-node" select="document(exslt:node-set($modules-nodes2)//x)" />



			<xsl:call-template name="modules_index" >
				<xsl:with-param name="this-schema" select="$top_module_node" />
				<xsl:with-param name="called-schemas" select="$dep-schemas" />
				<xsl:with-param name="called-modules" select="$modules-node" />
			</xsl:call-template>



			</xsl:when>

			</xsl:choose>

</xsl:template>



<xsl:template name="modules_index" >
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />
	<xsl:param name="called-modules" />

<!--	<xsl:apply-templates select="$called-schemas//schema" mode="module-index" >
		<xsl:sort select="@name" />		
	</xsl:apply-templates>
-->
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$called-schemas//entity" />
			<xsl:with-param name="internal-link-root" select="'letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
			<xsl:with-param name="called-modules" select="$called-modules" />
		</xsl:call-template>


</xsl:template>


<xsl:template match="entity" mode="module-index" >
	<xsl:param name="called-schemas" />
	<xsl:param name="called-modules" />

		<xsl:variable name="mod-name" select="translate(substring-before(../@name,'_arm'),$UPPER,$LOWER)" />

		<xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)" />
		<xsl:variable name="ent-name" select="@name" />
		<xsl:variable name="lc-ent" select="translate(@name,$UPPER,$LOWER)" />

		<br/>
		<A HREF="{$mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$lc-ent}" target="info">
                  <xsl:value-of select="@name"/>
		</A>
		<br/>
                <!-- check that mapping exists -->
		<xsl:if test="not($called-modules//module[@name=$mod-name]//ae[@entity=$ent-name])" >
<!--			Mapping NOT found -->
			<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="concat('Error APmapindex1: Unable to locate mapping for entity ',
			    $ent-name,' in module ',$mod-name)"/>
			</xsl:call-template>    	

		</xsl:if>
		
<!-- are there any attributes? -->
		
		<xsl:if test="explicit" >
			<TABLE>
			<TR>
			<TD><small>&#160;&#160;</small></TD>
			<TD ALIGN="LEFT" >
			<xsl:apply-templates select="explicit" mode="module-index" >
				<xsl:with-param name="called-schemas" select="$called-schemas" />
				<xsl:with-param name="called-modules" select="$called-modules" />
			</xsl:apply-templates> 
			</TD>
			</TR>
			</TABLE>
		</xsl:if>

		
		
</xsl:template>

<xsl:template match="explicit" mode="module-index" >
	<xsl:param name="called-schemas" />
	<xsl:param name="called-modules" />

<!--	<small> -->
		<xsl:variable name="current-schema" select="../../@name" />

		<xsl:variable name="mod-name" select="translate(substring-before(../../@name,'_arm'),$UPPER,$LOWER)" />

		<xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)" />
		<xsl:variable name="lc-ent" select="translate(../@name,$UPPER,$LOWER)"/>
		<xsl:variable name="ent-name" select="../@name"/>

<!--		&#160;&#160;<A HREF="{$mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$lc-ent}aaattribute{@name}" target="info">
		<xsl:value-of select="concat(' ',../@name,'.',@name)"/>
		</A>
		<br/>
-->

<!-- if attribute points to an extensible select then may have further mappings in other modules -->
		
		<xsl:variable name="attr-name" select="@name" />
		<xsl:variable name="lc-attr" select="@name"/>
		<xsl:variable name="attr-type-name" select="./typename/@name" />
		<xsl:variable name="lc-typename" select="translate(./typename/@name,$UPPER,$LOWER)" />
		<xsl:variable name="found-type" 
			select="$called-schemas//type[@name=$attr-type-name][select/@extensible='YES']" />
		
	<xsl:choose>	
		<xsl:when test="$found-type" >
		
<!--			<xsl:value-of select="concat(' ',../@name,'.',@name)"/> -->
                    <small>
			<A 
			HREF="{$mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$lc-ent}aaattribute{@name}assertion_to{$lc-typename}" 
			target="info">
			<xsl:value-of select="concat(' ',../@name,'.',@name)"/>
			</A>
                      </small>
		<TABLE>
			<TR>
			<TD><small>&#160;&#160;</small></TD>
			<TD ALIGN="LEFT" >
			<xsl:variable name="extensions" >
				<xsl:text> </xsl:text>
				<xsl:value-of select="$found-type/@name" />
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="$found-type" mode="basedon-up" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="done" select="concat(' ',$found-type/@name,' ')" />
				</xsl:apply-templates>
			</xsl:variable>


			<small>
			EXTENDED BY:
			<br/>
                      </small>
			
			<xsl:for-each select="$called-schemas//type[select]
				[contains($extensions,concat(' ',@name,' '))][string-length(select/@selectitems) > 0] " >
				<xsl:sort select="concat(../@name,'.',@name)" />

				<xsl:variable name="the-mod-name" 
					select="translate(substring-before(../@name,'_arm'),$UPPER,$LOWER)" />

				<xsl:variable name="the-select-mod-dir" 
					select="concat($STEPMOD_DATA_MODULES, $the-mod-name)" />
                                  <small>
				<A HREF="{$the-select-mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$the-mod-name}_arm.{@name}" 
					target="info"><xsl:value-of select="@name"/></A>
                              </small>
				<br/>
                                <small>TO INCLUDE:</small>
				<TABLE>
				<TR>
				<TD><small>&#160;&#160;</small></TD>
				<TD ALIGN="LEFT" >


                                <small>
				<xsl:call-template name="assertion-links-for-select">
					<xsl:with-param name="select-items" select="./select/@selectitems" />
					<xsl:with-param name="this-select" select="." />
<!--					<xsl:with-param name="this-select-mod" select="../@name" /> -->
					<xsl:with-param name="this-attribute" select="$lc-attr" />
					<xsl:with-param name="this-entity" select="$lc-ent" />
					<xsl:with-param name="this-module" select="$the-mod-name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:call-template>
                              </small>

				</TD>
				</TR>
				</TABLE>

				
			</xsl:for-each>
			</TD>
			</TR>
		</TABLE>
		</xsl:when>
		<xsl:when test="./typename and $called-schemas//type[@name=$attr-type-name][select]" >
		<!-- non extensible select case so multiple mappings -->
                <small>
			<xsl:value-of select="concat(../@name,'.',@name)"/>
			<br/>
			Select items:
			<br/>
			
			<xsl:variable name="this-select" select="$called-schemas//type[@name=$attr-type-name][select]" />
<!--			<xsl:variable name="this-select-mod" select="$this-select/ancestor::schema/@name" /> -->

				<xsl:call-template name="assertion-links-for-select">
					<xsl:with-param name="select-items" select="$this-select/select/@selectitems" />
					<xsl:with-param name="this-select" select="$this-select" />
<!--					<xsl:with-param name="this-select-mod" select="$this-select-mod" /> -->
					<xsl:with-param name="this-attribute" select="$lc-attr" />
					<xsl:with-param name="this-entity" select="$lc-ent" />
					<xsl:with-param name="this-module" select="$mod-name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:call-template>
                              </small>
			<br/>
		</xsl:when>
		<xsl:when test="./typename">
<!--		
			<A 
			HREF="{$mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$lc-ent}aaattribute{@name}assertion_to{$lc-typename}" 
			target="info">
			<xsl:value-of select="concat(' ',../@name,'.',@name)"/>
			</A>
-->
			<!-- check that mapping exists -->
			<xsl:choose>
			<xsl:when test="$called-modules//module[@name=$mod-name]//ae[@entity=$ent-name]//aa[@attribute=$attr-name][@assertion_to=$attr-type-name]">
				<!-- Mapping found q -->
				<A 
			HREF="{$mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$lc-ent}aaattribute{@name}assertion_to{$lc-typename}" 
				target="info">
                                  <small><xsl:value-of select="concat(' ',../@name,'.',@name)"/></small>
				</A>
			</xsl:when>
			<xsl:when 
			  test="$called-modules//module[@name=$mod-name]//ae[@entity=$ent-name]//aa[@attribute=$attr-name]">
				<!-- Mapping found q -->
				<!-- may be a locally declared select type in which case multiple mappings defined here 
					with different assertion to values -->

				
				<A 
			HREF="{$mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$lc-ent}aaattribute{@name}" 
				target="info">
                                  <small><xsl:value-of select="concat(' ',../@name,'.',@name)"/></small>
				</A>
				<br/>
				<xsl:if test="not($called-schemas//type[@name=$attr-type-name]
								[enumeration or typename or builtintype])" >
<!--			Mapping NOT found -->
			<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="concat('WARNING: Missing assertion_to=&#x22;',
			    $attr-type-name,'&#x22; in mapping of entity ',$lc-ent,' in module ',$mod-name)" />
			</xsl:call-template>    	

		</xsl:if>
		
			</xsl:when>
			<xsl:when 
			  test="$called-modules//module[@name=$mod-name]//ae[@entity=$ent-name]//aa
			  	[contains(@attribute,$attr-name) and starts-with(@attribute,'SELF')]">
				<!-- Mapping found q -->
				<xsl:variable name="redeclared-from" 
				  select="translate(./redeclaration/@entity-ref,$UPPER,$LOWER)" />

				<A 
                                  HREF="{$mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$lc-ent}aaattributeself{$redeclared-from}.{@name}assertion_to{$lc-typename}" 
				target="info">
                                  <small><xsl:value-of select="concat(' ',../@name,'.',@name)"/></small>
				</A>
<!--				<br/>WARNING: Attribute in mapping contains SELF !!! -->
			</xsl:when>
			<xsl:otherwise>
<!--				Mapping NOT found q -->
				<!-- Mapping found q -->
				<xsl:value-of select="concat(' ',../@name,'.',@name)"/>

				<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="concat('Error APmapindex1: Unable to locate mapping for attribute ',
				    ../@name,'.',@name)"/>
				</xsl:call-template>    	
			</xsl:otherwise>
			
			</xsl:choose>
			<br/>
		</xsl:when>
		<xsl:otherwise>
			<A HREF="{$mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$lc-ent}aaattribute{@name}" target="info">
                          <small><xsl:value-of select="concat(' ',../@name,'.',@name)"/></small>
			</A>

			<!-- check that mapping exists -->
			<xsl:if test="not($called-modules//module[@name=$mod-name]//ae[@entity=$ent-name]//aa[@attribute=$attr-name])">
<!--				Mapping NOT found p -->
				<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="concat('Error APmapindex2: Unable to locate mapping for attribute ',
				    $ent-name,'.',$attr-name)"/>
				</xsl:call-template>    	
			</xsl:if>

			<br/>
		</xsl:otherwise>
		
	</xsl:choose>
<!--	</small> -->
</xsl:template>

<xsl:template name="assertion-links-for-select" >
	<xsl:param name="select-items" />
	<xsl:param name="this-select" />
<!--	<xsl:param name="this-select-mod" /> -->
	<xsl:param name="this-attribute" />
	<xsl:param name="this-entity" />
	<xsl:param name="this-module" />
	<xsl:param name="called-schemas" />
	<xsl:param name="called-modules" />

	<xsl:variable name="test" >
		<xsl:call-template name="find-first-word-in-list" >
			<xsl:with-param name="word-list" select="$select-items"/>
		</xsl:call-template>
	</xsl:variable>


	<xsl:variable name="this-item" select="substring-before(concat(normalize-space($select-items),' '),' ')" />
	<xsl:variable name="Uc-this-entity" select="concat(
						translate(substring($this-entity,1,1),$LOWER,$UPPER),
						substring($this-entity,2))" />

	<xsl:variable name="this-select-mod" select="translate(substring-before( $this-select/../@name, '_arm'), $UPPER,$LOWER)" />

	<xsl:if test="string-length($this-item) > 0" >

<!-- this may fail if a select type contains another select type -->

		<xsl:choose>

			<xsl:when test="$called-schemas//schema/entity[@name=$this-item]" >

<!-- named item is an entity -->

				<xsl:variable name="this-item-mod" 
					select="translate($called-schemas//schema[entity/@name=$this-item]/@name,$UPPER,$LOWER)" />

				<xsl:variable name="entity-module" 
					select="translate(substring-before(
							$called-schemas//schema[entity/@name=$Uc-this-entity]/@name,
							'_arm'),
						$UPPER,$LOWER)" />
	
				<xsl:variable name="this-item-dir" 
					select="concat($STEPMOD_DATA_MODULES,
					substring-before($this-item-mod,'_arm'))" />
						
				<xsl:variable name="lc-this-item" 
					select="translate($this-item,$UPPER,$LOWER)" />

				<A HREF="{$this-item-dir}/sys/4_info_reqs{$FILE_EXT}#{$this-item-mod}.{$lc-this-item}" 
					target="info"><xsl:value-of select="$this-item" /></A>
				<xsl:text>  </xsl:text>
				<xsl:variable name="the-mod-dir" 
					select="concat($STEPMOD_DATA_MODULES,$this-module)" />
				<br/>&#160;&#160;

				<xsl:choose>

					<xsl:when test="$called-modules//module[@name=$this-module]//ae[@entity=$Uc-this-entity]//aa[@attribute=$this-attribute and @assertion_to=$this-item]" >

						<A HREF="{$the-mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$this-entity}aaattribute{$this-attribute}assertion_to{$lc-this-item}" 
							target="info">map</A>
						<xsl:text> </xsl:text>		
					</xsl:when>
					<xsl:when test="$called-modules//module[@name=$entity-module]//ae[@entity=$Uc-this-entity]//aa[@attribute=$this-attribute and @assertion_to=$this-item]" >
						<A HREF="{$STEPMOD_DATA_MODULES}{$entity-module}/sys/5_mapping{$FILE_EXT}#aeentity{$this-entity}aaattribute{$this-attribute}assertion_to{$lc-this-item}" 
							target="info">map</A>
						<xsl:text> </xsl:text>		
						
					</xsl:when>

					<xsl:when test="$called-modules//module[@name=$this-module]//ae[@entity=$Uc-this-entity]//aa[starts-with(@attribute,'SELF') and substring-after(@attribute,'.')=$this-attribute and @assertion_to=$this-item]" >
						<!-- added to del with attribute names using SELF\ -->

						<xsl:variable name="SELF-attribute" select="translate($called-modules//module[@name=$this-module]//ae[@entity=$Uc-this-entity]//aa[starts-with(@attribute,'SELF') and substring-after(@attribute,'.')=$this-attribute and @assertion_to=$this-item]/@attribute, $UPPER_BACKSLASH,$LOWER_FORWARDSLASH)" />


						<A HREF="{$the-mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$this-entity}aaattribute{$SELF-attribute}assertion_to{$lc-this-item}" 
							target="info">map</A>
						<xsl:text> </xsl:text>		
						
					</xsl:when>

					<xsl:when test="$called-modules//module[@name=$this-module]//ae[@entity=$Uc-this-entity]//aa[@attribute=$this-attribute and @assertion_to='*']" >
                                          <!-- added to deal with new mapping -->
                                          <xsl:variable name="path"
                                            select="$called-modules//module[@name=$this-module]//ae[@entity=$Uc-this-entity]//aa[@attribute=$this-attribute and @assertion_to='*']//refpath_extend"/>
                                          <xsl:variable name="MAPPING_OF" select="concat('(/MAPPING_OF(',$this-item,')/)')"/>
                                          <xsl:choose>
                                            <xsl:when test="contains($path,$MAPPING_OF)">
                                            	<A HREF="{$the-mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$this-entity}aaattribute{$this-attribute}assertion_to*" 
                                            		target="info">map</A>
                                            	<xsl:text> </xsl:text>	
                                            </xsl:when>
                                            <xsl:otherwise>
                                            	<xsl:call-template name="error_message">
                                            		<xsl:with-param name="inline" select="'yes'"/>
                                            		<xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
                                            		<xsl:with-param 
                                            			name="message" 
                                            			select="concat('Error APmapindex4: Unable to locate mapping for select item: ', $this-select/@name ,' in module: ',$this-select/../@name,' for entity: ', $this-item,' attribute ',$this-attribute,' in ',$entity-module,' - Expected ',$MAPPING_OF,' in path')"/>                                                  
                                            	</xsl:call-template>
                                            </xsl:otherwise>
                                          </xsl:choose>
                                        </xsl:when>
					<xsl:when test="$called-modules//module[@name=$this-select-mod]//ae//aa[@attribute=$this-attribute and @assertion_to=$this-item]" >
						<!-- this will work provided there are not two selects being extended with the same attribute name and assertion to -->
						<xsl:variable name="found-mapping" select="$called-modules//module[@name=$this-select-mod]//ae//aa[@attribute=$this-attribute and @assertion_to=$this-item]" />
						<xsl:variable name="found-mapping-ent" select="translate($found-mapping/../@entity,$UPPER,$LOWER)" />

						<A HREF="{$STEPMOD_DATA_MODULES}{$this-select-mod}/sys/5_mapping{$FILE_EXT}#aeentity{$found-mapping-ent}aaattribute{$this-attribute}assertion_to{$lc-this-item}" 
						target="info">map</A>
						<xsl:text> </xsl:text>

	                                 </xsl:when>

					<xsl:otherwise>
<!--						Mapping NOT found select -->
						<xsl:call-template name="error_message">
						  <xsl:with-param name="inline" select="'yes'"/>
						  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			        		  <xsl:with-param 
					            name="message" 
               select="concat('Error APmapindex3: Unable to locate mapping for select item: ', 
                               $this-select/@name ,
                               ' in module: ',
                               $this-select/../@name,
                               ' for entity: ',
                               $this-item,
                               ' attribute ',
                               $this-attribute,
                               ' in module ',
                               $entity-module,
                               ' [Hint:',$this-entity,'.',$this-attribute,']')"/>                                                  
						</xsl:call-template>    				
 					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>
			
			<xsl:when test="$called-schemas//schema/type[@name=$this-item]" >

<!-- named item is a type -->
				<xsl:variable name="this-type-item" 
					select="$called-schemas//schema/type[@name=$this-item]" />



				<xsl:choose>
					<xsl:when test="$this-type-item/select" >
						<!-- select type - so recurse again -->

		<xsl:call-template name="assertion-links-for-select" >
			<xsl:with-param name="select-items" select="substring-after(normalize-space($this-type-item/select/@selectitems),' ')" />
			<xsl:with-param name="this-select" select="$this-select"/>
<!--			<xsl:with-param name="this-select-mod" select="$this-select-mod" /> -->
			<xsl:with-param name="this-attribute" select="$this-attribute" />
			<xsl:with-param name="this-entity" select="$this-entity" />
			<xsl:with-param name="this-module" select="$this-module" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
			<xsl:with-param name="called-modules" select="$called-modules" />
		</xsl:call-template>

						
					</xsl:when>
					<xsl:otherwise>
						<!-- named type -->
						<xsl:value-of select="$this-item" /><br/>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:when>

		</xsl:choose>


		<xsl:call-template name="assertion-links-for-select" >
			<xsl:with-param name="select-items" select="substring-after(normalize-space($select-items),' ')" />
			<xsl:with-param name="this-select" select="$this-select"/>
<!--			<xsl:with-param name="this-select-mod" select="$this-select-mod" /> -->
			<xsl:with-param name="this-attribute" select="$this-attribute" />
			<xsl:with-param name="this-entity" select="$this-entity" />
			<xsl:with-param name="this-module" select="$this-module" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
			<xsl:with-param name="called-modules" select="$called-modules" />
		</xsl:call-template>

	</xsl:if>

</xsl:template>



<xsl:template name="depends-on-recurse-no-list-x" >
	<xsl:param name="todo" select="' '"/>
	<xsl:param name="done" />
	<!--
	For each interfaced schema:
		Check if not already done
		Otherwise output and add to todo
	-->

	<xsl:variable name="this-schema" select="substring-before(concat(normalize-space($todo),' '),' ')" />

		<xsl:if test="$this-schema" >

			<xsl:if test="not(contains($done,$this-schema))" >
				<xsl:variable name="mod" 
				select="substring-before(translate($this-schema,$UPPER,$LOWER),'_arm')" />
<!-- notes:
msxml needs addresses relative to the original xml file
saxon needs addresses relative to the xsl file.
msxml Only seems to pick up on first file - treating parameter to document() differently from saxon.
-->

				<xsl:variable name="dir" >
					<xsl:choose>
						<xsl:when test="function-available('exslt:node-set')">../../../</xsl:when>
					<xsl:otherwise>../../../../../</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>


				<x>
                                  <xsl:variable name="prefix">
                                    <xsl:call-template name="get_last_section">
                                      <xsl:with-param name="path" select="$this-schema"/>
                                      <xsl:with-param name="divider" select="'_'"/>
                                    </xsl:call-template>
                                  </xsl:variable>
                                  <xsl:choose>
                                    <xsl:when test="$prefix='schema'">
                                      <xsl:value-of 
			select="concat($dir,'data/resources/',$this-schema,'/',$this-schema,'.xml ')" />
						</xsl:when>
						<xsl:when test="starts-with($this-schema,'aic_')">
							<xsl:value-of 
			select="concat($dir,'data/resources/',$this-schema,'/',$this-schema,'.xml ')" />
						</xsl:when>
						<xsl:otherwise>
                                                  <xsl:value-of select="concat($dir,'stepmod/data/modules/',$mod,'/arm.xml ')" />
						</xsl:otherwise>
					</xsl:choose>
				</x>
			</xsl:if>

<!-- open up the relevant schema -->

			<xsl:variable name="arm_file" 
			    select="concat('../../data/modules/',
			    		translate(substring-before($this-schema,'_arm'),$UPPER,$LOWER),'/arm.xml')"/>

			<xsl:variable name="arm-node"
			    select="document($arm_file)/express"/>


<!-- get the list of schemas for this level that have not already been done -->

			<xsl:variable name="my-kids" >
				<xsl:apply-templates select="$arm-node//interface" mode="interface-schemas" >
					<xsl:with-param name="done" select="$done" />
				</xsl:apply-templates>
			</xsl:variable>

		<xsl:variable name="after" select="normalize-space(concat(substring-after($todo, $this-schema),$my-kids))" />


			<xsl:if test="$after" >
				<xsl:call-template name="depends-on-recurse-no-list-x">
					<xsl:with-param name="todo" select="$after" />
					<xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')" />
				</xsl:call-template>

	
			</xsl:if>

		</xsl:if>

</xsl:template>

<xsl:template match="interface" mode="interface-schemas">
  <xsl:param name="done"/>
  <xsl:variable name="schema" select="concat(' ',@schema,' ')"/>
  <xsl:if test="not(contains($done,$schema))">
    <xsl:value-of select="$schema"/> 
  </xsl:if>
</xsl:template>

<xsl:template name="alph-list" >
	<xsl:param name="items" />
	<xsl:param name="internal-link-root" />
	<xsl:param name="called-schemas" />
	<xsl:param name="called-modules" />

		<xsl:variable name="name-list" >
			<xsl:for-each select="$items">
				<xsl:value-of select="concat(' ',translate(@name, $LOWER,$UPPER),' ')" />
			</xsl:for-each>
		</xsl:variable>

			<xsl:if test="contains($name-list,' A')" >
				<br/>
				<A NAME="{$internal-link-root}-a"  ><B>A</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='A']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' B')" >
				<br/>
				<A NAME="{$internal-link-root}-b"  ><B>B</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='B']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' C')" >
				<br/>
				<A NAME="{$internal-link-root}-c"  ><B>C</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='C']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' D')" >
				<br/>
				<A NAME="{$internal-link-root}-d"  ><B>D</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='D']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' E')" >
				<br/>
				<A NAME="{$internal-link-root}-e"  ><B>E</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='E']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' F')" >
				<br/>
				<A NAME="{$internal-link-root}-f"  ><B>F</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='F']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' G')" >
				<br/>
				<A NAME="{$internal-link-root}-g"  ><B>G</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='G']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' H')" >
				<br/>
				<A NAME="{$internal-link-root}-h"  ><B>H</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='H']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' I')" >
				<br/>
				<A NAME="{$internal-link-root}-i"  ><B>I</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='I']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' J')" >
				<br/>
				<A NAME="{$internal-link-root}-j"  ><B>J</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='J']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' K')" >
				<br/>
				<A NAME="{$internal-link-root}-k"  ><B>K</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='K']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' L')" >
				<br/>
				<A NAME="{$internal-link-root}-l"  ><B>L</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='L']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' M')" >
				<br/>
				<A NAME="{$internal-link-root}-m"  ><B>M</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='M']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' N')" >
				<br/>
				<A NAME="{$internal-link-root}-n"  ><B>N</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='N']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' O')" >
				<br/>
				<A NAME="{$internal-link-root}-o"  ><B>O</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='O']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' P')" >
				<br/>
				<A NAME="{$internal-link-root}-p"  ><B>P</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='P']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Q')" >
				<br/>
				<A NAME="{$internal-link-root}-q"  ><B>Q</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Q']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' R')" >
				<br/>
				<A NAME="{$internal-link-root}-r"  ><B>R</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='R']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' S')" >
				<br/>
				<A NAME="{$internal-link-root}-s"  ><B>S</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='S']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' T')" >
				<br/>
				<A NAME="{$internal-link-root}-t"  ><B>T</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='T']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' U')" >
				<br/>
				<A NAME="{$internal-link-root}-u"  ><B>U</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='U']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' V')" >
			
				<br/>
				<A NAME="{$internal-link-root}-v"  ><B>V</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='V']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' W')" >
				<br/>
				<A NAME="{$internal-link-root}-w"  ><B>W</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='W']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' X')" >
				<br/>
				<A NAME="{$internal-link-root}-x"  ><B>X</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='X']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Y')" >
				<br/>
				<A NAME="{$internal-link-root}-y"  ><B>Y</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Y']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Z')" >
				<br/>
				<A NAME="{$internal-link-root}-z"  ><B>Z</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Z']" mode="module-index" >
					<xsl:sort select="@name" />
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="called-modules" select="$called-modules" />
				</xsl:apply-templates>
			</xsl:if>
</xsl:template>


<xsl:template match="type" mode="basedon-up">
	<xsl:param name="called-schemas" />
	<xsl:param name="done" select="' '" />

	<xsl:variable name="this_select" select="@name" />

	<xsl:if test="not(contains($done, concat(' ',@name,' ')))" >
	
		<xsl:value-of select="concat(' ',@name,' ')" /> 

	</xsl:if>
			
		<xsl:apply-templates select="$called-schemas//type[select/@basedon=$this_select]" 
						mode="basedon-up">
			<xsl:with-param name="called-schemas" select="$called-schemas" />
			<xsl:with-param name="done" select="concat($done,' ',$this_select,' ')" />
		</xsl:apply-templates>


</xsl:template>


<xsl:template name="depends-on-recurse-no-list-x-modules" >
<!-- this version assumes dealing with ARM level modules only and outputs a list of X elements containing module addresses
-->
	<xsl:param name="todo" select="' '"/>
	<xsl:param name="done" />
	<!--
	For each interfaced schema:
		Check if not already done
		Otherwise output and add to todo
	-->

	<xsl:variable name="this-schema" select="substring-before(concat(normalize-space($todo),' '),' ')" />

		<xsl:if test="$this-schema" >

			<xsl:if test="not(contains($done,$this-schema))" >
				<xsl:variable name="mod" 
				select="substring-before(translate($this-schema,$UPPER,$LOWER),'_arm')" />
<!-- notes:
msxml needs addresses relative to the original xml file
saxon needs addresses relative to the xsl file.
msxml Only seems to pick up on first file - treating parameter to document() differently from saxon.
-->

				<xsl:variable name="dir" >
					<xsl:choose>
						<xsl:when test="function-available('exslt:node-set')">../../../</xsl:when>
					<xsl:otherwise>../../../../../</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>


				<x>
                                  <xsl:value-of select="concat($dir,'stepmod/data/modules/',$mod,'/module.xml ')" />
				</x>
			</xsl:if>

<!-- open up the relevant schema -->

			<xsl:variable name="arm_file" 
			    select="concat('../../data/modules/',
			    		translate(substring-before($this-schema,'_arm'),$UPPER,$LOWER),'/arm.xml')"/>

			<xsl:variable name="arm-node"
			    select="document($arm_file)/express"/>


<!-- get the list of schemas for this level that have not already been done -->

			<xsl:variable name="my-kids" >
				<xsl:apply-templates select="$arm-node//interface" mode="interface-schemas" >
					<xsl:with-param name="done" select="$done" />
				</xsl:apply-templates>
			</xsl:variable>

		<xsl:variable name="after" select="normalize-space(concat(substring-after($todo, $this-schema),$my-kids))" />


			<xsl:if test="$after" >
				<xsl:call-template name="depends-on-recurse-no-list-x-modules">
					<xsl:with-param name="todo" select="$after" />
					<xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')" />
				</xsl:call-template>

	
			</xsl:if>

		</xsl:if>

</xsl:template>

<xsl:template name="find-first-word-in-list" >
	<xsl:param name="word-list" />
	<xsl:param name="top-word" select="' '"/>

	<!-- outputs the word from word-list that comes first in alphabetic order -->

	<!-- get first item in list -->

	<xsl:variable name="first" select="substring-before(concat(normalize-space($word-list),' '),' ')" />
	<xsl:variable name="rest" select="normalize-space(substring-after($word-list, concat(first,' ')))" />

<!-- ZZ1:<xsl:value-of select="$first" />ZZ2:<xsl:value-of select="$top-word" />XX -->

	<xsl:choose>
	<xsl:when test="$top-word=' '" >
	<!-- at first call so select first word as new top word and recurse -->
		<xsl:call-template name="find-first-word-in-list">
			<xsl:with-param name="word-list" select="substring-after($word-list,$first)" />
			<xsl:with-param name="top-word" select="$first" />
		</xsl:call-template>
	</xsl:when>
	<xsl:when test="not($first)" >
		<xsl:value-of select="$top-word" /> 
	</xsl:when>
	<xsl:when test="string-length(translate($rest,' ','')) = 0 " >
		<xsl:choose>
			<xsl:when test="not($top-word > $first)" >
				<xsl:value-of select="$top-word" /> 
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$first" /> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:when>
	<xsl:otherwise>
		<xsl:choose>
			<xsl:when test="not($top-word > $first)" >
				<xsl:call-template name="find-first-word-in-list">
					<xsl:with-param name="word-list" select="substring-after($word-list,$first)" />
					<xsl:with-param name="top-word" select="$top-word" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="find-first-word-in-list">
					<xsl:with-param name="word-list" select="substring-after($word-list,$first)" />
					<xsl:with-param name="top-word" select="$first" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>


</xsl:stylesheet>
