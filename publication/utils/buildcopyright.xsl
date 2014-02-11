<?xml version="1.0" encoding="utf-8"?>
<!--
$Id$
Ant project to run update tasks:
FilePurpose - 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	
	<!-- force the application of the stylesheet  -->
	<xsl:template match="docs">
		<xsl:text>&#xA;</xsl:text>
		<!-- project start -->
<xsl:comment>
Project to update schema header copyright information in resource schemas that
are referenced by the resource_docs in docs.xml with series IGR, AIC, and IAR
</xsl:comment>
		<project name="BuildCopyright" default="main" basedir="../../..">
			<!-- properties of build env -->
			<xsl:text>&#xA;</xsl:text>
			<xsl:comment>Properties</xsl:comment>
			<xsl:element name="property">
				<xsl:attribute name="name">TMPDIR</xsl:attribute>
				<xsl:attribute name="value">./publication/utils/tmp_cw_edit</xsl:attribute>
			</xsl:element>
			<xsl:element name="property">
				<xsl:attribute name="name">TMPDIR_REL</xsl:attribute>
				<xsl:attribute name="value">./tmp_cw_edit</xsl:attribute>
			</xsl:element>
			<xsl:element name="property">
				<xsl:attribute name="name">COPYRIGHTCODE</xsl:attribute>
				<xsl:attribute name="value">./publication/utils</xsl:attribute>
			</xsl:element>
			<xsl:text>&#xA;</xsl:text>
			<xsl:text>&#xA;</xsl:text>
			<!-- properties generated from referenced resources -->
			<xsl:comment>IGR+AIC+IAR (no format filter) = [<xsl:value-of select="count(./doc[(@series='IGR' or @series='AIC' or @series='IAR')])"/>]</xsl:comment>
			<xsl:text>&#xA;</xsl:text>
			<xsl:comment>IGR+AIC+IAR (pdf) = [<xsl:value-of select="count(./doc[(@series='IGR' or @series='AIC' or @series='IAR') and @format='pdf'])"/>]</xsl:comment>
			<xsl:text>&#xA;</xsl:text>
			<xsl:comment>IGR+AIC+IAR (html-stepmod) = [<xsl:value-of select="count(./doc[(@series='IGR' or @series='AIC' or @series='IAR') and @format='html-stepmod'])"/>]</xsl:comment>
			<xsl:text>&#xA;</xsl:text>
			<xsl:comment>IGR (html-stepmod) = [<xsl:value-of select="count(./doc[(@series='IGR') and @format='html-stepmod'])"/>]</xsl:comment>
			<xsl:text>&#xA;</xsl:text>
			<xsl:comment>AIC (html-stepmod) = [<xsl:value-of select="count(./doc[(@series='AIC') and @format='html-stepmod'])"/>]</xsl:comment>
			<xsl:text>&#xA;</xsl:text>
			<xsl:comment>IAR (html-stepmod) = [<xsl:value-of select="count(./doc[(@series='IAR') and @format='html-stepmod'])"/>]</xsl:comment>
			<xsl:text>&#xA;</xsl:text>
			<xsl:element name="property">
				<xsl:attribute name="name">ALL_CW_RESOURCEDOCS</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:apply-templates mode="genRsrcDoc"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="property">
				<xsl:attribute name="name">ALL_CW_RESOURCESPATH</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:apply-templates mode="genPath"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="property">
				<xsl:attribute name="name">ALL_CW_RESOURCESEXP</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:apply-templates mode="genExpPath"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="property">
				<xsl:attribute name="name">ALL_CW_RESOURCESEXPXML</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:apply-templates mode="genExpXMLPath"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:text>&#xA;</xsl:text>
			<!-- properties of build env -->
			<xsl:element name="property">
				<xsl:attribute name="name">STEPMOD_DATA_LIBRARY</xsl:attribute>
				<xsl:attribute name="value">./data/library</xsl:attribute>
			</xsl:element>
			<xsl:element name="property">
				<xsl:attribute name="name">STEPMOD_DATA_RESOURCES</xsl:attribute>
				<xsl:attribute name="value">./data/resources</xsl:attribute>
			</xsl:element>
			<xsl:element name="property">
				<xsl:attribute name="name">STEPMOD_DATA_RESOURCEDOCS</xsl:attribute>
				<xsl:attribute name="value">./data/resource_docs</xsl:attribute>
			</xsl:element>
			<xsl:text>&#xA;</xsl:text>

			<!-- main task -->
			<xsl:call-template name="do.main"/>
			<xsl:text>&#xA;</xsl:text>
			
			<!-- init task -->
			<xsl:call-template name="do.init"/>
			<xsl:text>&#xA;</xsl:text>
			
			<!-- get schema id and remove names task -->
			<xsl:call-template name="do.get_schema_id"/>
			<xsl:text>&#xA;</xsl:text>
			
			<!-- wrap schema file task -->
			<xsl:call-template name="do.wrap_schema_file"/>
			<xsl:text>&#xA;</xsl:text>
			
			<!-- extract schema data task -->
			<xsl:call-template name="do.extract_schema_data"/>
			<xsl:text>&#xA;</xsl:text>
			
			<!-- generate the copyright data task -->
			<xsl:call-template name="do.gen_copyright_data"/>
			<xsl:text>&#xA;</xsl:text>
			
			<!-- concatenate final schema files task -->
			<target name="concat_exp_files" depends="gen_copyright_data" description="Reconstruct the final SCHEMA files">
				<echo message="Reconstruct the final SCHEMA files" />
				 <xsl:apply-templates mode="genConcatTask"/>
			</target>
			<xsl:text>&#xA;</xsl:text>
			
			<!-- concatenate the resource_doc log files -->
			<xsl:call-template name="do.concat_log_files"/>
			<xsl:text>&#xA;</xsl:text>
			
			<!-- clean temporary files from temp build directory -->
			<xsl:call-template name="do.cleanup_folders"/>
			<xsl:text>&#xA;</xsl:text>
			
			<!-- setup the cvs checkout task -->
			<xsl:call-template name="do.cvs_checkout"/>
			<xsl:text>&#xA;</xsl:text>
			
		  </project>
	</xsl:template>	
	
	
	<!-- toplevel ant task templates -->
	<xsl:template name="do.main">
		<target name="main" description="Default empty main task">
			<echo message="Default empty main task" />
		</target>
	</xsl:template>
	
	<xsl:template name="do.init">
		<target name="init" description="Initialize working directories and files">
			<echo message="Initialize temporary directories and files" />
			<delete dir="${{TMPDIR}}/data/*" />
			<mkdir dir="${{TMPDIR}}/data" />
			<concat destfile="${{TMPDIR}}/_expstart_tag.txt">&lt;exp&gt;&lt;![CDATA[</concat>
			<concat destfile="${{TMPDIR}}/_expend_tag.txt">]]&gt;&lt;/exp&gt;</concat>
			<concat destfile="${{TMPDIR}}/_hdrstart_tag.txt">(*</concat>
			<concat destfile="${{TMPDIR}}/_hdrend_tag.txt">*)</concat>
		</target>
	</xsl:template>
	
	<xsl:template name="do.get_schema_id">
		<target name="get_schema_id" depends="init" description="Fetch EXPRESS files to working directory and preprocess">
			<echo message="Fetch EXPRESS files to working directory and preprocess" />
			<copy todir="${{TMPDIR}}">
				<fileset dir="." includes="${{ALL_CW_RESOURCESEXP}}" />
				<globmapper from="*.exp" to="*_id.xml" />
				<filterchain>
					<linecontainsregexp>
						<regexp pattern="\$Id:*" />
					</linecontainsregexp>
					<concatfilter prepend="${{TMPDIR}}/_expstart_tag.txt" />
					<concatfilter append="${{TMPDIR}}/_expend_tag.txt" />
				</filterchain>
			</copy>
			<xslt basedir="${{TMPDIR}}" includes="data/resources/**/*_id.xml" style="${{COPYRIGHTCODE}}/lsmDeleteNameFromIdTag.xsl" destdir="${{TMPDIR}}" extension=".txt">
			</xslt>
		</target>
	</xsl:template>
	
	<xsl:template name="do.wrap_schema_file">
		<target name="wrap_schema_file" depends="get_schema_id" description="Wrap EXPRESS source files with exp element">
			<echo message="Wrap EXPRESS source files with exp element" />
			<copy todir="${{TMPDIR}}">
				<fileset dir="." includes="${{ALL_CW_RESOURCESEXP}}" />
				<globmapper from="*.exp" to="*.xml" />
				<filterchain>
					<concatfilter prepend="${{TMPDIR}}/_expstart_tag.txt" />
					<concatfilter append="${{TMPDIR}}/_expend_tag.txt" />
				</filterchain>
			</copy>
		</target>
	</xsl:template>
	
	<xsl:template name="do.extract_schema_data">
		<target name="extract_schema_data" depends="wrap_schema_file" description="Extract SCHEMA contents from working files">
			<echo message="Extract SCHEMA contents from working files" />
			<xslt basedir="${{TMPDIR}}" includes="${{ALL_CW_RESOURCESEXPXML}}" style="${{COPYRIGHTCODE}}/lsmExtractSchemaContent.xsl" destdir="${{TMPDIR}}" extension=".dat" filenameparameter="infilename">
			</xslt>
		</target>
	</xsl:template>
	
	<xsl:template name="do.gen_copyright_data">
		<target name="gen_copyright_data" depends="extract_schema_data" description="Generate the Copyright text file for each resource">
			<echo message="Generate the Copyright text file for each resource" />
			<xslt basedir="." includes="${{ALL_CW_RESOURCEDOCS}}" style="${{COPYRIGHTCODE}}/lsmGenerateCopyright.xsl" destdir="${{TMPDIR}}" extension="_header.log">
				<param name="output_dir" expression="${{TMPDIR_REL}}/data/resources" />
			</xslt>
		</target>
	</xsl:template>
	
	<xsl:template name="do.concat_log_files">
		<target name="concat_log_files" description="Consolidate the resource_doc log files">
			<echo message="Consolidate the resource_doc log files" />
			<concat destfile="${{TMPDIR}}/resource_doc_update.log">
				<fileset dir="${{TMPDIR}}/data/resource_docs" includes="*/resource_header.log" />
			</concat>
		</target>
	</xsl:template>
	
	<xsl:template name="do.cleanup_folders">
		<echo message="The current temp directory root is:"/>
		<echo message="${{basedir}}/${{TMPDIR}}"/>
		<input message="Delete the resource temporary files after execution (y/n)?" addproperty="do.delete.answer" />
		<condition property="do.delete">
			<equals arg1="y" arg2="${{do.delete.answer}}" />
		</condition>
		<xsl:text>&#xA;</xsl:text>
		<target if="do.delete" name="clean_folders" description="Cleanup the resource directories and temporary files">
			<echo message="Cleanup the resource directories and temporary files" />
			<delete>
				<fileset dir="${{TMPDIR}}/data/resources" includes="**/*.txt" />
				<fileset dir="${{TMPDIR}}/data/resources" includes="**/*.dat" />
				<fileset dir="${{TMPDIR}}/data/resources" includes="**/*.xml" />
			</delete>
	        <delete>
	           <fileset dir="${{TMPDIR}}/data/resource_docs" includes="**/*.log"/>
	        </delete>
			<delete>
				<fileset dir="${{TMPDIR}}" includes="_*_tag.txt" />
			</delete>
		</target>
	</xsl:template>
	
	<xsl:template name="do.cvs_checkout">
		<target name="cvs_checkout" description="CVS checkout of resource express schema files">
			<echo message="CVS checkout of resource express schema files" />
			<property name="cvs.username" value="thomasrthurman" />
    		<property name="cvs.password" value="NOTUSED_cvspassword" />
    		<property name="cvs.rsh" value="ssh" />
    		<property name="cvs.root" value=":extssh:${{cvs.username}}@stepmod.cvs.sourceforge.net:/cvsroot/stepmod" />
    		<property name="cvs.packageroot" value="stepmod" />
    		<property name="cvs.stream" value="HEAD" />
    		<xsl:element name="property">
				<xsl:attribute name="name">cvs.packageroot.modules</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:apply-templates mode="genExpPathCVS"/>
				</xsl:attribute>
			</xsl:element>
			
     		<property name="checkout.dir" value="."/>
 
        	<cvs command="checkout"
	        	 tag="${{cvs.stream}}"
				 cvsrsh="${{cvs.rsh}}"
				 cvsroot="${{cvs.root}}"
				 package="${{cvs.packageroot.modules}}"
				 dest="${{checkout.dir}}"
				 output="${{TMPDIR}}/cvs_checkout.log"
				 quiet="true" />

		</target>
	</xsl:template>
	
	<!-- mode specific doc[IGR,IAC,IAR] handlers -->
	<xsl:template match="doc[(@series='IGR' or @series='AIC' or @series='IAR')]" mode="genRsrcDoc">
		<xsl:variable name="theResourceDOC" select="concat('data/resource_docs/', @name, '/resource.xml')"/>
		<xsl:value-of select="$theResourceDOC"/><xsl:text>,</xsl:text>
	</xsl:template>
	
	<xsl:template match="doc[(@series='IGR' or @series='AIC' or @series='IAR')]" mode="genPath">
		<xsl:variable name="theResourceXML" select="concat('../../data/resource_docs/', @name, '/resource.xml')"/>
		<xsl:variable name="theResource" select="document($theResourceXML)"/>
		<xsl:apply-templates select="$theResource/*/schema" mode="genPath"/>
	</xsl:template>
	
	<xsl:template match="doc[(@series='IGR' or @series='AIC' or @series='IAR')]" mode="genExpPath">
		<xsl:variable name="theResourceXML" select="concat('../../data/resource_docs/', @name, '/resource.xml')"/>
		<xsl:variable name="theResource" select="document($theResourceXML)"/>
		<xsl:apply-templates select="$theResource/*/schema" mode="genExpPath"/>
	</xsl:template>
	
	<xsl:template match="doc[(@series='IGR' or @series='AIC' or @series='IAR')]" mode="genExpPathCVS">
		<xsl:variable name="theResourceXML" select="concat('../../data/resource_docs/', @name, '/resource.xml')"/>
		<xsl:variable name="theResource" select="document($theResourceXML)"/>
		<xsl:apply-templates select="$theResource/*/schema" mode="genExpPathCVS"/>
	</xsl:template>
	
	<xsl:template match="doc[(@series='IGR' or @series='AIC' or @series='IAR')]" mode="genExpXMLPath">
		<xsl:variable name="theResourceXML" select="concat('../../data/resource_docs/', @name, '/resource.xml')"/>
		<xsl:variable name="theResource" select="document($theResourceXML)"/>
		<xsl:apply-templates select="$theResource/*/schema" mode="genExpXMLPath"/>
	</xsl:template>
	
	<xsl:template match="doc[(@series='IGR' or @series='AIC' or @series='IAR')]" mode="genConcatTask">
		<xsl:variable name="theResourceXML" select="concat('../../data/resource_docs/', @name, '/resource.xml')"/>
		<xsl:variable name="theResource" select="document($theResourceXML)"/>
		<xsl:apply-templates select="$theResource/*/schema" mode="genConcatTask"/>
	</xsl:template>
	
	<!-- mode specific schema element handlers -->
	<xsl:template match="schema" mode="genPath">
		<xsl:variable name="theSchemaPATH" select="concat('data/resources/', @name)"/>
		<xsl:value-of select="$theSchemaPATH"/><xsl:text>,</xsl:text>
	</xsl:template>
	
	<xsl:template match="schema" mode="genExpPath">
		<xsl:variable name="theSchemaEXP" select="concat('data/resources/', @name, '/', @name, '.exp')"/>
		<xsl:value-of select="$theSchemaEXP"/><xsl:text>,</xsl:text>
	</xsl:template>
	
	<xsl:template match="schema" mode="genExpPathCVS">
		<xsl:variable name="theSchemaEXPCVS" select="concat('${cvs.packageroot}/data/resources/', @name, '/', @name, '.exp', ' ')"/>
		<xsl:value-of select="$theSchemaEXPCVS"/>
	</xsl:template>
	
	<xsl:template match="schema" mode="genExpXMLPath">
		<xsl:variable name="theSchemaEXPXML" select="concat('data/resources/', @name, '/', @name, '.xml')"/>
		<xsl:value-of select="$theSchemaEXPXML"/><xsl:text>,</xsl:text>
	</xsl:template>
	
	<xsl:template match="schema" mode="genConcatTask">
		<xsl:variable name="theSchemaDIR" select="concat('${TMPDIR}/data/resources/', @name)"/>
		<xsl:variable name="theSchemaEXP" select="concat($theSchemaDIR, '/', @name, '.exp')"/>
		<xsl:variable name="theSchemaDAT" select="concat(@name, '.dat')"/>
		<xsl:variable name="theSchemaTXT" select="concat(@name, '_id.txt')"/>

		<xsl:element name="concat">
			<xsl:attribute name="destfile"><xsl:value-of select="$theSchemaEXP"/></xsl:attribute>
			<xsl:attribute name="fixlastline">yes</xsl:attribute>
			<xsl:element name="filelist">
				<xsl:attribute name="dir"><xsl:value-of select="$theSchemaDIR"/></xsl:attribute>
				<xsl:element name="file">
					<xsl:attribute name="name">../../../_hdrstart_tag.txt</xsl:attribute>
				</xsl:element>
				<xsl:element name="file">
					<xsl:attribute name="name"><xsl:value-of select="$theSchemaTXT"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="file">
					<xsl:attribute name="name">_copyright.txt</xsl:attribute>
				</xsl:element>
				<xsl:element name="file">
					<xsl:attribute name="name">../../../_hdrend_tag.txt</xsl:attribute>
				</xsl:element>
				<xsl:element name="file">
					<xsl:attribute name="name"><xsl:value-of select="$theSchemaDAT"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<!-- default templates -->	
	<xsl:template match="node()|comment()" />
	<xsl:template match="node()|comment()" mode="genRsrcDoc"/>
	<xsl:template match="node()|comment()" mode="genPath"/>
	<xsl:template match="node()|comment()" mode="genExpPath"/>
	<xsl:template match="node()|comment()" mode="genExpPathCVS"/>
	<xsl:template match="node()|comment()" mode="genExpXMLPath"/>
	<xsl:template match="node()|comment()" mode="genConcatTask"/>
	
</xsl:stylesheet>
