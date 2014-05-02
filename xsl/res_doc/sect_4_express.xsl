<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: sect_4_express.xsl,v 1.38 2013/11/12 16:58:59 thomasrthurman Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the commented XML encoded Express
     in the schema clauses 4, etc of a resource.
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="express_link.xsl"/> 
  <xsl:import href="express_description.xsl"/> 
  <xsl:import href="../projmg/resource_issues.xsl"/> 

  <xsl:output method="html"/>

  <!-- +++++++++++++++++++
         Global variables
       +++++++++++++++++++ -->

  <xsl:variable name="resdoc_name">
    <xsl:choose>  
    <xsl:when test="/resource_clause">
      <xsl:value-of select="/resource_clause/@directory" />
      </xsl:when>
      <xsl:when test="/resource">
        <xsl:value-of select="/resource/@name"/>
      </xsl:when>
      <xsl:when test="/issues">
        <xsl:value-of select="/issues/@resource"/>
      </xsl:when>
      <xsl:when test="/imgfile.content">
        <xsl:value-of select="/imgfile.content/@module"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="resdoc_dir">
    <xsl:choose>
      <xsl:when test="imgfile.area">    
      <xsl:value-of select="$resdoc_name"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="resdoc_directory">
        <xsl:with-param name="resdoc" select="$resdoc_name" />
        </xsl:call-template>      
      </xsl:otherwise>
    </xsl:choose>  
  </xsl:variable>

  <xsl:variable name="resdoc_xml" select="document(concat($resdoc_dir,'/','resource.xml'))"/>

  <!-- 
       Global variable used in express_link.xsl by:
         link_object
         link_list
       Provides a lookup table of all the references for the entities and
       types indexed through all the interface specifications in the
       express.
       Note:  This variable must defined in each XSL that is used for
       formatting express. (TEH guessing here at the list)
         sect_4_schema.xsl
         sect_e_exp.xsl
         sect_e_exp_1.xsl
       build_xref_list is defined in express_link
       -->
  <xsl:variable name="global_xref_list">
    <!-- debug 
    <xsl:message>
      global_xref_list defined in sect_4_express.xsl
    </xsl:message> -->
    <xsl:choose>
      <xsl:when test="/resource_clause">
        <xsl:variable name="resdoc_dir">
          <xsl:call-template name="resdoc_directory">
            <xsl:with-param name="resdoc" select="/resource_clause/@directory"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="resdoc_name">
          <xsl:value-of select="/resource_clause/@directory" />
        </xsl:variable>
        <!-- 
         <xsl:message>
          resdoc_dir  :<xsl:value-of select="$resdoc_dir"/>: resdoc_dir
        </xsl:message> -->
        
        <xsl:variable name="resdoc_xml" select="concat($resdoc_dir,'/','resource.xml')"/>
        <!--
        <xsl:message>
          resdoc_xml  :<xsl:value-of select="$resdoc_xml"/>
        count schemas: <xsl:value-of select="count(document($resdoc_xml)/resource/schema)"/> 
        </xsl:message> -->
        <xsl:variable name="resdoc_node" select="document($resdoc_xml)"/>
                
        <!-- <xsl:for-each select="document($resdoc_xml)/resource/schema"> -->
        <xsl:for-each select="$resdoc_node/resource/schema">
          <xsl:variable name="resource_dir">
            <xsl:call-template name="resource_directory">
              <xsl:with-param name="resource" select="./@name"/>            
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="express_xml" select="concat($resource_dir,'/',@name,'.xml')"/>
          <xsl:call-template name="build_xref_list">
            <xsl:with-param name="express" select="document($express_xml)/express"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="/resource">
        <xsl:variable name="resdoc_dir">
          <xsl:call-template name="resdoc_directory">
            <xsl:with-param name="resdoc" select="/resource/@name"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="resdoc_name">
          <xsl:value-of select="/resource_clause/@directory" />
        </xsl:variable>
        <!--      <xsl:message>
          resdoc_dir  :<xsl:value-of select="$resdoc_dir"/>: resdoc_dir
        </xsl:message> -->
        
        <xsl:variable name="resdoc_xml" select="concat($resdoc_dir,'/','resource.xml')"/>

        <!--        <xsl:message>
          resdoc_xml  :<xsl:value-of select="$resdoc_xml"/>
        count schemas: <xsl:value-of select="count(document($resdoc_xml)/resource/schema)"/> 
        </xsl:message> -->


        <xsl:variable name="resdoc_node" select="document($resdoc_xml)"/>
                
        <!-- <xsl:for-each select="document($resdoc_xml)/resource/schema"> -->
        <xsl:for-each select="$resdoc_node/resource/schema">
          <xsl:variable name="resource_dir">
            <xsl:call-template name="resource_directory">
              <xsl:with-param name="resource" select="./@name"/>
            
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="express_xml" select="concat($resource_dir,'/',$resource_dir,'.xml')"/>
          <xsl:call-template name="build_xref_list">
            <xsl:with-param name="express" select="document($express_xml)/express"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       sect_4_express.xsl stylesheet is normally applied from file in:
         stepmod/data/resource/?resource?/sys/
       Hence the relative root is: ../../../
       -->
  <xsl:variable name="relative_root">
    <xsl:value-of select="'../../../../'"/>       
  </xsl:variable>



  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->
<xsl:template match="interface">
  <xsl:param name="doctype"/>
  <xsl:variable name="schema_name" select="../@name"/>      
  <xsl:if test="position()=1">
    <xsl:variable name="clause_number">
      <xsl:call-template name="express_clause_number">
        <xsl:with-param name="clause" select="'interface'"/>
        <xsl:with-param name="schema_name" select="$schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="clause_header">
          <xsl:value-of select="concat($clause_number, $schema_name)"/>
    </xsl:variable>

    </xsl:if>
  <p>
    <code>

      <xsl:choose>
        <xsl:when test="@kind='reference'">
          REFERENCE FROM 
          <xsl:call-template name="link_schema">
            <xsl:with-param 
              name="schema_name" 
              select="@schema"/>
            <xsl:with-param name="clause" select="'section'"/>
          </xsl:call-template>

          <xsl:choose>
            <xsl:when test="./interfaced.item">
              <!-- if interface items then output source tail comment now -->
              &#160;&#160;&#160;--&#160;
              <xsl:apply-templates select="." mode="source"/>
              <xsl:apply-templates select="./interfaced.item"/>;
              <xsl:if test="position()=last()"><br/>(*</xsl:if>
              <br/><br/>          
            </xsl:when>
            <xsl:otherwise>;
              &#160;&#160;&#160;--&#160;              
              <xsl:apply-templates select="." mode="source"/>
              <xsl:if test="position()=last()"><br/>(*</xsl:if>
              <br/><br/>
            </xsl:otherwise>
          </xsl:choose> 

        </xsl:when>
        <xsl:when test="@kind='use'">
          USE FROM
          <xsl:call-template name="link_schema">
            <!-- defined in express_link.xsl -->
            <xsl:with-param 
              name="schema_name" 
              select="@schema"/>
            <xsl:with-param name="clause" select="'section'"/>
          </xsl:call-template>

          <xsl:choose>
            <xsl:when test="./interfaced.item">
              <!-- if interface items then out put source tail comment now -->
              &#160;&#160;&#160;--&#160;
              <xsl:apply-templates select="." mode="source"/>
              <xsl:apply-templates select="./interfaced.item"/>;
              <xsl:if test="position()=last()"><br/>(*</xsl:if>
              <br/><br/>          
            </xsl:when>
            <xsl:otherwise>;
              &#160;&#160;&#160;--&#160;
              <xsl:apply-templates select="." mode="source"/>
              <xsl:if test="position()=last()"><br/>(*</xsl:if>
              <br/><br/>
            </xsl:otherwise>
          </xsl:choose> 

      </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e1: Interface in schema ', 
                      $schema_name, 
                      ' is incorrectly specified')"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </code>
  <!-- end blockquote -->
  </p>
  <xsl:if test="position()=last()">
    <xsl:call-template name="interface_notes">
      <xsl:with-param name="schema_node" select=".."/>
      <xsl:with-param name="doctype" select="$doctype"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- output the trailing comment that shows where the express came from -->
<xsl:template match="interface" mode="source">
  <xsl:variable name="resource" select="string(@schema)"/> 
  <xsl:choose>
    <xsl:when 
      test="contains($resource,'_arm') or contains($resource,'_mim')">
      <!-- must be a resource -->
      <xsl:variable name="resource_ok">
        <xsl:call-template name="check_resource_exists">
          <xsl:with-param name="schema" select="$resource"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$resource_ok='true'">
          <xsl:variable name="mod_dir">
            <xsl:call-template name="resource_directory">
              <xsl:with-param name="resource" select="$resource"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="part">
            <xsl:value-of
              select="document(concat($mod_dir,'/resource.xml'))/resource/@part"/>
          </xsl:variable>
          <xsl:variable name="status">
            <xsl:value-of
              select="document(concat($mod_dir,'/resource.xml'))/resource/@status"/>
          </xsl:variable>
          <xsl:value-of select="concat('ISO/',$status,'&#160;10303-',$part)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of 
                select="concat('Error IF-1: The resource ',
                        $resource,' cannot be found in repository_index.xml ')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:otherwise>
      <!-- must be an integrated resource -->
      <xsl:variable name="resource_ok">
        <xsl:call-template name="check_resource_exists">
          <xsl:with-param name="schema" select="$resource"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$resource_ok='true'">
          <!-- found integrated resource schema, so get IR title -->
          <xsl:variable name="reference">
            <xsl:value-of
              select="document(concat('../../data/resources/',$resource,'/',$resource,'.xml'))/express/@reference"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="string-length($reference)>0">
              <xsl:value-of select="$reference"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of 
                    select="concat('Error IF-3: The reference parameter for ',
                            $resource,' has not been specified ')"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message" 
              select="concat('Error IF-2: ',$resource_ok)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- output a note detailing the interface -->
<xsl:template name="interface_notes">
  <xsl:param name="schema_node"/>
  <xsl:param name="doctype"/>
    <p class="note">
      <small>
        NOTE&#160;1&#160;&#160;
	<xsl:variable name="used-count" select="count(used-schema[not(.=preceding-sibling::used-schema)])" />
	<xsl:choose>
		<xsl:when test="$used-count = 1" >
		        The schemas referenced above are specified in the following 
		        part:
		</xsl:when>
		<xsl:otherwise >
		        The schemas referenced above are specified in the following 
		        parts:
		</xsl:otherwise>
	</xsl:choose>
      </small>
    </p>
    <blockquote>
        <table>  
        <xsl:for-each select="$schema_node/interface[not(@schema = node()/preceding::node()/@schema)]">
          <xsl:variable name="schema_name" select="./@schema"/>      
          <tr>
            <td width="266">
              <b>
                <small>
                  <xsl:value-of select="$schema_name"/>
                </small>
              </b>
            </td>
            <td width="127">
              <small>
                <xsl:apply-templates select="." mode="source"/>
              </small>
            </td>
          </tr>
        </xsl:for-each>
      </table>
  </blockquote>
    <p class="note">
      <small>
        NOTE&#160;2&#160;&#160;
        <xsl:variable name="resource_dir">
          <xsl:call-template name="resource_directory">
            <xsl:with-param name="resource" select="$schema_node/@name"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="resource_file"
          select="concat($resource_dir,'/resource.xml')"/>
            See Annex <a href="d_expg{$FILE_EXT}">D</a>
            for a graphical representation of this schema.
      </small>
    </p>

	<xsl:choose>
		<xsl:when test="$doctype='aic'">
			<p class="note">
				<small>
					NOTE&#160;3&#160;&#160;
					There may be subtypes and items of select lists that appear in
					the integrated resources that are
					not imported into the AIC. Constructs are eliminated from the subtype
					tree or select list through the use of
					the implicit interface rules of ISO 10303-11. References to eliminated
					constructs are outside the scope of the
					AIC. In some cases, all items of the select list are eliminated. Because
					AICs are intended to be implemented
					in the context of an application protocol, the items of the select
					list will be defined by the scope of the
					application protocol
      			</small>
			</p>
		</xsl:when>
	</xsl:choose>
	
</xsl:template>

<xsl:template match="interfaced.item">
  <xsl:choose>
    <xsl:when test="position()=1">
      <br/><xsl:text>&#160;&#160;(</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        &#160;&#160;
    </xsl:otherwise>
  </xsl:choose>

  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@name"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>

  <xsl:if test="position()!=last()">,<br/></xsl:if>

  <xsl:if test="position()=last()">)</xsl:if>

</xsl:template>

<xsl:template match="constant">
  <!-- some day add the support for constant that is aggregate. -->
  <xsl:param name="main_clause"/>
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable name="clause_number">
	<xsl:call-template name="express_clause_number">
	  <xsl:with-param name="main_clause" select="$main_clause"/>
	  <xsl:with-param name="clause" select="'constant'"/>
	  <xsl:with-param name="schema_name" select="$schema_name"/>
	</xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">
    <xsl:variable name="clause_header">
          <xsl:choose>
            <xsl:when test="count(../constant)>1">
			  <xsl:value-of select="concat($main_clause,$clause_number,' ',$schema_name,' constant definitions')"/>
            </xsl:when>
            <xsl:otherwise>
			  <xsl:value-of select="concat($main_clause,$clause_number,' ',$schema_name,' constant definition')"/>
            </xsl:otherwise>
          </xsl:choose>
    </xsl:variable>

    <xsl:variable name="clause_intro" select="''"/>

    <h2>
      <A NAME="constants">
        <xsl:value-of select="$clause_header"/>
      </A>
    </h2>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:if test="position()=1">
    <p><u>EXPRESS specification:</u></p>
    <p>
    <!-- start blockquote -->
      <code>
        *)<br/>
        CONSTANT
      <br/>(*
      </code>
    <!-- end blockquote  -->
  </p>
  </xsl:if>
  
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    
  <h2>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($main_clause, $clause_number,'.',position(),' ',@name)"/>
    </A>
  </h2>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 
  <!-- output description from express -->
  <p>
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../@name"/>
            <xsl:with-param name="entity" select="./@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e2: No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </p>
  <!-- output any issue against constant   -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 


    <!-- output EXPRESS -->
    <p><u>EXPRESS specification:</u></p>
    <p>
    <!--  start blockquote -->
      <code>
        *)<br/>
        &#160;&#160;<xsl:value-of select="@name"/> 
: <xsl:apply-templates select="./*" mode="underlyingconstant"/><xsl:apply-templates select="./*" mode="underlying"/> := <xsl:choose>
    
    <xsl:when test="./aggregate and contains(@expression,',')"><br/>
      &#160;&#160;&#160;<xsl:value-of select="concat(substring-before(@expression,','),',')"/>
      <xsl:call-template name="output_constant_expression">
        <xsl:with-param name="expression" select="substring-after(@expression,',')"/>
      </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@expression"/>;
      </xsl:otherwise>
  </xsl:choose>
     <br/>(*
      </code>
    <!-- end blockquote  -->
    </p>
    
    <xsl:if test="position()=last()">
      <br/>
      <p>
      <!--  start blockquote -->
        <code>
          *)<br/>
          END_CONSTANT;
          <br/>(*
        </code>
      <!--  end blockquote  -->
    </p>
    </xsl:if>

</xsl:template>



<!-- THX added to support constants that are aggregates -->


<xsl:template name="output_constant_expression">
  <xsl:param name="expression"/>
  <!--  <xsl:value-of select="','" /> -->
    <br/>
    &#160;&#160;&#160;&#160;<xsl:value-of select="substring-before($expression,',')"/>
    
    <xsl:choose>
      <xsl:when test="contains($expression,',')">,
        <xsl:call-template name="output_constant_expression">
          <xsl:with-param name="expression" select="substring-after($expression,',')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$expression"/>;
      </xsl:otherwise>
    </xsl:choose>


</xsl:template>

<xsl:template match="type" >
  <xsl:param name="main_clause"/>
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="main_clause" select="$main_clause"/>
      <xsl:with-param name="clause" select="'type'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">

    <xsl:variable name="clause_header">
          <xsl:choose>
            <xsl:when test="count(../type)>1">
			  <xsl:value-of select="concat($main_clause,$clause_number,' ',$schema_name,' type definitions')"/>
            </xsl:when>
            <xsl:otherwise>
			  <xsl:value-of select="concat($main_clause,$clause_number,' ',$schema_name,' type definition')"/>
            </xsl:otherwise>
          </xsl:choose>
    </xsl:variable>

    <xsl:variable name="clause_intro" select="''"/>

    <h2>
      <A NAME="types">
        <xsl:value-of select="$clause_header"/>
      </A>
    </h2>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    
  <h2>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($main_clause,$clause_number, '.', position(), ' ', @name)"/>
    </A>
    <xsl:apply-templates select="." mode="expressg_icon"/>
  </h2>

  <xsl:call-template name="check_type_name">
    <xsl:with-param name="type_name" select="@name"/>
  </xsl:call-template>


  <xsl:apply-templates select="./select" mode="description"/>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
    <xsl:with-param name="type" select="./@name"/>

  </xsl:call-template> 
  <!-- output description from express -->

  <p>
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>

        <!-- 
             disable error checking for selects as boiler plate
             should output text -->
        <xsl:if test="not(./select)">
          <xsl:variable name="external_description">
            <xsl:call-template name="check_external_description">
              <xsl:with-param name="schema" select="../@name"/>
              <xsl:with-param name="entity" select="@name"/>
            </xsl:call-template>        
          </xsl:variable>
          <xsl:if test="$external_description='false'">
            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Error e3: No description provided for ',$aname)"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </p>
  <!-- output any issue against type -->
 
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
  </xsl:call-template> 

  <p><u>EXPRESS specification:</u></p>
  <p>
  <!-- start blockquote -->
    <code>
      *)<br/>
      TYPE 
      <xsl:value-of select="@name" />
        =
        <xsl:apply-templates select="./aggregate" mode="code"/>        
        <xsl:choose>
          <xsl:when test="./where">
            <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
            <xsl:apply-templates select="./where" mode="code"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
          </xsl:otherwise>
        </xsl:choose>
        END_TYPE; <br/>
        (*
    </code>
  <!--  end blockquote  -->
</p>
  <xsl:apply-templates select="enumeration" mode="describe_enums"/>
  <xsl:call-template name="output_where_formal"/>
  <xsl:call-template name="output_where_informal"/>

</xsl:template>

<!-- empty template to prevent the description element being out put along
     with the code -->
<xsl:template match="description" mode="underlying"/>  

<xsl:template match="typename" mode="underlying">
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@name"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>
</xsl:template>


<xsl:template match="builtintype" mode="underlying">
  <xsl:choose>
    <xsl:when test="@type='GENERICENTITY'">GENERIC_ENTITY</xsl:when>
    <xsl:otherwise>  
      <xsl:value-of select="@type"/>
    </xsl:otherwise>
  </xsl:choose> 
</xsl:template>


<xsl:template match="select" mode="underlying">
  <xsl:if test="@extensible='YES' or @extensible='yes'">
    EXTENSIBLE
  </xsl:if>

  <xsl:if test="@genericentity='YES' or @genericentity='yes'">
    GENERIC_ENTITY
  </xsl:if>

  SELECT<xsl:if test="@basedon">
    BASED_ON 
      <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="@basedon"/>
        <xsl:with-param name="object_used_in_schema_name" 
          select="../../@name"/>
        <xsl:with-param name="clause" select="'section'"/>
      </xsl:call-template>  
  </xsl:if>
  <xsl:if test="@selectitems and 
                (string-length(@selectitems)!=0)">
    <xsl:if test="@basedon">
      WITH 
    </xsl:if><br/>
    &#160;&#160;&#160;(<xsl:call-template name="link_list">
    <xsl:with-param name="linebreak" select="'yes'"/>
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="prefix" select="'&#160;&#160;&#160;&#160;'"/>
    <xsl:with-param name="first_prefix" select="'no'"/>
    <xsl:with-param name="list" select="@selectitems"/>
    <xsl:with-param name="object_used_in_schema_name"
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>)</xsl:if></xsl:template>


<xsl:template match="enumeration" mode="underlying">
  <xsl:if test="@extensible='YES' or @extensible='yes'">
    EXTENSIBLE
  </xsl:if>
  ENUMERATION
  <xsl:if test="@basedon">
    BASED_ON 
    <xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@basedon"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>  
  </xsl:if>

  <xsl:if test="@items and (string-length(@items)!=0)">
    <xsl:choose>
      <xsl:when test="@basedon">
        WITH 
      </xsl:when>
      <xsl:otherwise>
        OF
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    &#160;&#160; 
    <xsl:variable name="enum"
      select="concat('(',translate(normalize-space(@items),' ',','),')')"/>
    <xsl:call-template name="output_line_breaks">
      <xsl:with-param name="str" select="$enum"/>
      <xsl:with-param name="break_char" select="','"/>
    </xsl:call-template>
  </xsl:if>

</xsl:template>


<xsl:template match="enumeration" mode="describe_enums">
  <xsl:if test="string-length(normalize-space(@items))>0">
    <p><u>Enumerated item definitions:</u></p>
    <xsl:call-template name="output_enums">
      <xsl:with-param name="str" select="normalize-space(@items)"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template name="output_enums">
  <xsl:param name="str"/>
  <xsl:variable name="break_char" select="' '"/>
  <xsl:choose>
    <xsl:when test="contains($str,$break_char)">
      <xsl:variable name="substr" 
        select="substring-before($str,$break_char)"/>
      <xsl:call-template name="output_enum_description">
        <xsl:with-param name="enum_value" select="$substr"/>
      </xsl:call-template> 
      
      <xsl:variable name="rest" select="substring-after($str,$break_char)"/>
      <xsl:call-template name="output_enums">
        <xsl:with-param name="str" select="$rest"/>
      </xsl:call-template> 
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="output_enum_description">
        <xsl:with-param name="enum_value" select="$str"/>
      </xsl:call-template> 
    </xsl:otherwise>        
  </xsl:choose>
</xsl:template>

<xsl:template name="output_enum_description">
  <xsl:param name="enum_value"/>
  <xsl:variable name="schema" select="../../@name"/>
  <xsl:variable name="enum_type" select="../@name"/>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema"/>
      <xsl:with-param name="section2" select="$enum_type"/>
      <xsl:with-param name="section3" select="$enum_value"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- removed an now implemented in express_descriptions
       template match="p" mode="first_paragraph_attribute"
       template match="ext_description" mode="output_attr_descr   
  <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="$enum_value"/>:
      </a>
    </b> -->
    



    <!-- get description from external file -->
    <xsl:call-template name="output_external_description">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="entity" select="$enum_type"/>
      <xsl:with-param name="attribute" select="$enum_value"/>
      <xsl:with-param name="inline_aname" select="$aname"/>
      <xsl:with-param name="inline_name" select="$enum_value"/>
    </xsl:call-template>

    <xsl:variable name="external_description">
      <xsl:call-template name="check_external_description">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="entity" select="$enum_type"/>
      <xsl:with-param name="attribute" select="$enum_value"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$external_description='false'">
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error e15: No description provided for ',$enum_value)"/>
      </xsl:call-template>
    </xsl:if>
</xsl:template>


<xsl:template match="entity">
  <xsl:param name="main_clause"/>
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="main_clause" select="$main_clause"/>
      <xsl:with-param name="clause" select="'entity'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">
    <xsl:variable name="clause_header">
	<xsl:choose>
	  <xsl:when test="count(../type)>1">
		<xsl:value-of select="concat($main_clause,$clause_number,' ',$schema_name,' entity definitions')"/>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:value-of select="concat($main_clause,$clause_number,' ',$schema_name,' entity definition')"/>
	  </xsl:otherwise>
	</xsl:choose>
	</xsl:variable>

    <xsl:variable name="clause_intro" select="''"/>

    <h2>
      <A NAME="entities">
        <xsl:value-of select="$clause_header"/>
      </A>
    </h2>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <h2>
    <A NAME="{$aname}">
     <xsl:value-of select="concat($main_clause,$clause_number,'.',position(),' ',@name)"/>
    </A>
    <xsl:apply-templates select="." mode="expressg_icon"/>
    <xsl:if test="substring($schema_name, string-length($schema_name)-3)=
'_arm'">

      <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
      <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
      <xsl:variable name="ae_map_aname"
        select="translate(concat('aeentity',@name),$UPPER,$LOWER)"/>

      <xsl:variable name="maphref" 
        select="concat('./5_mapping',$FILE_EXT,'#',$ae_map_aname)"/>
      <a href="{$maphref}">
        <img align="middle" border="0" 
          alt="Mapping table" src="../../../../images/mapping.gif"/>
      </a>
    </xsl:if>
  </h2>
  <!--
      <xsl:call-template name="check_entity_name">
        <xsl:with-param name="entity_name" select="@name"/>
      </xsl:call-template>
-->
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="supertypes" select="@supertypes"/>
  </xsl:call-template> 
  <!-- output description from express -->
  <p>
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../@name"/>
            <xsl:with-param name="entity" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e4: No description provided for ',@name)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </p>

  <!-- output any issue against entity   -->

  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 

  <p><u>EXPRESS specification:</u></p>
  <p>
  <!--  start blockquote -->
    <code>
      *)<br/>
      ENTITY <xsl:value-of select="@name"/>
      <xsl:call-template name="abstract.entity"/>
      <xsl:call-template name="super.expression-code"/>
      <xsl:call-template name="supertypes-code"/><xsl:text>;</xsl:text>
      <br/>
      <xsl:apply-templates select="./explicit" mode="code"/>
      <xsl:apply-templates select="./derived" mode="code"/>
      <xsl:apply-templates select="./inverse" mode="code"/>
      <xsl:apply-templates select="./unique" mode="code"/>
      <xsl:apply-templates select="./where[@expression]" mode="code"/>
      END_ENTITY;<br/>(*
    </code>
  <!--  end blockquote -->
  </p>
  <xsl:apply-templates select="./explicit" mode="description"/>    
  <xsl:apply-templates select="./derived" mode="description"/>    
  <xsl:apply-templates select="./inverse" mode="description"/>  
  <xsl:apply-templates select="./unique" mode="description"/>
  <xsl:call-template name="output_where_formal"/>
  <xsl:call-template name="output_where_informal"/>
</xsl:template>


<xsl:template name="abstract.entity">
  <xsl:if test="@abstract.entity='YES' or @abstract.entity='yes'">
    ABSTRACT</xsl:if>
</xsl:template>

<xsl:template name="super.expression-code">
  <!-- Always enclose the expression in parentheses -->
  <xsl:variable name="sup_expr"
    select="concat('(',@super.expression,')')"/>

  <xsl:choose>
    <xsl:when test="@abstract.supertype='YES' or @abstract.supertype='yes'">
      <br/>
      &#160;&#160;ABSTRACT SUPERTYPE
      <xsl:if test="@super.expression">
        OF&#160;<xsl:call-template name="link_super_expression_list">
          <xsl:with-param name="list" select="$sup_expr"/>
          <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
          <xsl:with-param name="clause" select="'section'"/>
          <xsl:with-param name="indent" select="25"/>
        </xsl:call-template>

      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="@super.expression">
      <br/>
&#160;&#160;SUPERTYPE OF&#160;<xsl:call-template name="link_super_expression_list">
        <xsl:with-param name="list" select="$sup_expr"/>
        <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
        <xsl:with-param name="clause" select="'section'"/>
        <xsl:with-param name="indent" select="16"/>
      </xsl:call-template>

    </xsl:if>      
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template name="supertypes-code">
  <xsl:if test="@supertypes">
<br/>
    &#160;&#160;SUBTYPE OF (<xsl:call-template name="link_list">
      <xsl:with-param name="list" select="@supertypes"/>
        <xsl:with-param name="suffix" select="', '"/>
      <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template><xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="explicit" mode="code">

  <xsl:if test="@name='id' or @name='identifier' or substring-after(@name,'_')='id'" >

    <xsl:if test="not(preceding-sibling::explicit[1][@name='id' or substring-after(@name,'_')='id']) and preceding-sibling::explicit[1]">
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error a1:   ','identifier',' must be first attribute')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>

  <xsl:if test="contains(@name,'relating' ) and ./preceding-sibling::explicit[contains(@name,'related')]" >
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error a2:   ','&quot;relating&quot;','  attribute must precede ','&quot;related&quot;',' attribute')"/>
      </xsl:call-template>
    </xsl:if>

<xsl:if test="@name='name' and ./preceding-sibling::explicit[@name='description']">
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error',' a3:   ','&quot;name&quot;','  attribute must precede ','&quot;description&quot;',' attribute')"/>
      </xsl:call-template>
    </xsl:if>

<xsl:if test="@name='name' and ./preceding-sibling::explicit[@name!='id' and @name!='identifier' and substring-after(@name,'_')!='id']">
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error',' a4:   ','&quot;name&quot;','  attribute must precede any attribute except an identifier attribute')"/>
      </xsl:call-template>
    </xsl:if>



<xsl:if test="@name='description' and ./preceding-sibling::explicit[contains(@name,'related')]">
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error a5:   ','&quot;description&quot;','  attribute must precede ','&quot;relating&quot;',' attribute')"/>
      </xsl:call-template>
    </xsl:if>


&#160;&#160;<xsl:apply-templates select="./redeclaration" mode="code"/>
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:if test="@optional='YES' or @optional='yes'">
    OPTIONAL 
  </xsl:if>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
</xsl:template>

<xsl:template match="redeclaration" mode="code">SELF\<xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@entity-ref"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="@old_name">
        <xsl:value-of select="concat('.',@old_name,' RENAMED ')"/>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="derived" mode="code">
  <xsl:if test="position()=1">DERIVE<br/>
  </xsl:if>
  &#160;&#160;<xsl:apply-templates select="./redeclaration" mode="code"/>
  <!-- need to clarify the XML for derive --> 
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>
  <xsl:value-of select="concat(' := ',@expression,';')"/><br/>
</xsl:template>

<xsl:template match="inverse" mode="code">
  <xsl:if test="position()=1">INVERSE<br/>
  </xsl:if>
  &#160;&#160;<xsl:apply-templates select="./redeclaration" mode="code"/>
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:apply-templates select="./inverse.aggregate" mode="code"/>
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@entity"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>  
  <xsl:value-of select="concat(' FOR ', @attribute)"/>;<br/>
</xsl:template>

<xsl:template match="inverse.aggregate" mode="code">
  <xsl:choose>
    <xsl:when test="@lower">
      <xsl:value-of select="concat(@type, '[', @lower, ':', @upper, '] OF ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@type, ' OF ')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="unique" mode="code">
  <xsl:if test="position()=1">UNIQUE<br/>
  </xsl:if>
  &#160;&#160;<xsl:value-of select="concat(@label, ': ')"/>
  <xsl:apply-templates select="./unique.attribute" mode="code"/>
  <br/>
</xsl:template>


<xsl:template match="unique.attribute" mode="code">
  <xsl:choose>
    <xsl:when test="position()!=last()">
      <xsl:value-of select="concat(@attribute,', ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@attribute,';')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="aggregate" mode="code">
  <xsl:choose>
    <xsl:when test="@lower">
      <xsl:value-of select="concat(@type, '[', @lower, ':', @upper, '] OF ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@type, ' OF ')"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="@optional='YES'">
    OPTIONAL
  </xsl:if>
  <xsl:if test="@unique='YES'">
    UNIQUE
  </xsl:if>
</xsl:template>

<xsl:template match="where" mode="code">
  <xsl:if test="position()=1">WHERE<br/></xsl:if> 
  &#160;&#160;<xsl:value-of select="concat(@label, ': ', @expression, ';')"/>
  <br/>
</xsl:template>

<xsl:template match="graphic.element" mode="code">
</xsl:template>


<xsl:template match="explicit" mode="description">
  <xsl:if test="position()=1">
    <p><u>Attribute definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- removed - see modules version 
    <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b>
-->
  <!-- get description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
    <xsl:with-param name="optional" select="@optional"/>
    <xsl:with-param name="inline_aname" select="$aname"/>
    <xsl:with-param name="inline_name" select="@name"/>
  </xsl:call-template>
  
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>      
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../../@name"/>
          <xsl:with-param name="entity" select="../@name"/>
          <xsl:with-param name="attribute" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e4: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <!-- output any issue against attribute  -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="derived" mode="description">
  <!-- check that this is the first derived attribute and that the
       there are no explicit attribute - if there were then Attribute
       definitions" would have already been output -->
  <xsl:if test="position()=1 and not(../explicit)">
    <p><u>Attribute definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <!--
    <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b> -->
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
    <xsl:with-param name="optional" select="@optional"/>
    <xsl:with-param name="inline_aname" select="$aname"/>
    <xsl:with-param name="inline_name" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="attribute" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e6: No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  <!-- output any issues against derived attributes -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template>

</xsl:template>

<xsl:template match="inverse" mode="description">

  <xsl:if test="position()=1 and not(../explicit | ../derived)">
    <p><u>Attribute definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  
  <!-- removed an now implemented in express_descriptions
       template match="p" mode="first_paragraph_attribute"
       template match="ext_description" mode="output_attr_descr
    <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b> -->

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
    <xsl:with-param name="inline_aname" select="$aname"/>
    <xsl:with-param name="inline_name" select="@name"/>
  </xsl:call-template>

  <!-- output description from express -->
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="attribute" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e7: No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  <!-- output any issues against inverse attribute -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template>

</xsl:template>



<xsl:template match="unique" mode="description">
  <xsl:if test="position()=1">
    <p><u>Formal propositions:</u></p>
  </xsl:if>  

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@label"/>
      <xsl:with-param name="section3separator" select="'.ur:'"/>
    </xsl:call-template>
  </xsl:variable>

  <!--    
    <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="concat(@label,' : ')"/>
      </a>
    </b> -->
    <!-- output description from external file -->
    <xsl:call-template name="output_external_description">
      <xsl:with-param name="schema" select="../../@name"/>
      <xsl:with-param name="entity" select="../@name"/>
      <xsl:with-param name="unique" select="./@label"/>
	  <xsl:with-param name="inline_aname" select="$aname"/>
	  <xsl:with-param name="inline_name" select="@label"/>

    </xsl:call-template>
    <!-- output description from express -->
    
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description">
		</xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="unique" select="./@label"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e8: No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <!-- output issues against unique rule -->
    <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
      <xsl:with-param name="schema" select="../../@name"/>
      <xsl:with-param name="entity" select="../@name"/>
      <xsl:with-param name="unique" select="./@label"/>
    </xsl:call-template>

</xsl:template>

<xsl:template name="output_where_formal">
  <xsl:if test="./where[@expression] and not(./unique)">
    <p><u>Formal propositions:</u></p>
  </xsl:if>
  <xsl:apply-templates select="./where[@expression]" mode="description"/>
</xsl:template>

<xsl:template name="output_where_informal">
  <xsl:if test="./where[not(@expression)]">
    <p><u>Informal propositions:</u></p>
  </xsl:if>
  <xsl:apply-templates select="./where[not(@expression)]" mode="description"/>
</xsl:template>


<xsl:template match="where" mode="description">

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@label"/>
      <xsl:with-param name="section3separator" select="'.wr:'"/>
    </xsl:call-template>
  </xsl:variable>
  <!--
    <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="concat(@label,' : ')"/>
      </a>
    </b>
-->

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
	<xsl:with-param name="schema" select="../../@name"/>
	<xsl:with-param name="entity" select="../@name"/>
	<xsl:with-param name="where" select="@label"/>
	<xsl:with-param name="inline_aname" select="$aname"/>
	<xsl:with-param name="inline_name" select="@label"/>
  </xsl:call-template>
  <!-- output description from express -->

    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="where" select="@label"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e9: No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  <!-- output issue against entity -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="where" select="@label"/>
  </xsl:call-template>

</xsl:template>


<xsl:template match="subtype.constraint">
  <xsl:param name="main_clause"/>
 <xsl:variable 
   name="schema_name" 
   select="../@name"/>      

  <xsl:variable name="clause_number">
     <xsl:call-template name="express_clause_number">
      <xsl:with-param name="main_clause" select="$main_clause"/>
      <xsl:with-param name="clause" select="'subtype.constraint'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first subtype constraint so output the intro -->
    <xsl:variable name="clause_header">
          <xsl:choose>
            <xsl:when test="count(../subtype.constraint)>1">
              <xsl:value-of select="concat($main_clause, $clause_number,' ',$schema_name,' subtype constraint definitions')"/>
            </xsl:when>
            <xsl:otherwise>
          <xsl:value-of select="concat($main_clause, $clause_number,' ',$schema_name,' subtype constraint definition')"/>
            </xsl:otherwise>
          </xsl:choose>

    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          This subclause specifies the application subtype constraints for
          this resource.  Each subtype constraint places constraints on the
          possible super-type / subtype instantiation.
          The application subtype constraints and their definitions are
          specified below. 
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h2>
      <a NAME="subtype_constraints">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h2>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
             
  <h2>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($main_clause, $clause_number,'.',position(),' ',@name)"/>
    </A>
    <xsl:apply-templates select="." mode="expressg_icon"/> 
  </h2>
  
  <xsl:apply-templates select="." mode="description"/>

  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>
  
  <p>
    <code>
  *)<br/>
  <A NAME="{$aname}">SUBTYPE_CONSTRAINT <b>
	<xsl:value-of select="@name"/></b></A>
  <xsl:text> FOR </xsl:text>
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@entity"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>;<br/>

  <xsl:if test="@abstract.supertype='YES' or @abstract.supertype='yes'">
      &#160;&#160;ABSTRACT SUPERTYPE;<br/>
  </xsl:if>

  <xsl:if test="@totalover and 
                (string-length(@totalover)!=0)">
    &#160;&#160;TOTAL_OVER&#160;(<xsl:call-template name="link_list">
    <xsl:with-param name="list" select="@totalover"/>
    <xsl:with-param name="linebreak" select="'yes'"/>
    <xsl:with-param name="prefix" select="'&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;'"/>
    <xsl:with-param name="first_prefix" select="'no'"/>
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>);<br/>
  </xsl:if>

  
  <xsl:variable name="sup_expr" select="@super.expression"/>
  <xsl:if test="@super.expression">
    &#160;&#160;<xsl:call-template name="link_super_expression_list">
        <xsl:with-param name="list" select="$sup_expr"/>
        <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
        <xsl:with-param name="clause" select="'section'"/>
        <xsl:with-param name="indent" select="3"/>
      </xsl:call-template>;<br/>
    </xsl:if>      
  END_SUBTYPE_CONSTRAINT;<br/>(*
  </code></p>
</xsl:template>

<xsl:template match="subtype.constraint" mode="description">
  <!--  output the boilerplate select descriptions for selects. -->
  <xsl:variable name="description_file"
    select="/express/@description.file"/>
  <xsl:variable name="sc_description">
    <xsl:choose>
      <xsl:when test="$description_file">
        <xsl:value-of select="document($description_file)/ext_descriptions/@describe.subtype_constraints"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'NO'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="one_of"
    select="substring-before(normalize-space(@super.expression),'(')"/>
  <xsl:variable name="sc_list" 
    select="normalize-space( translate( substring-after(@super.expression,'('),',)',' '))"/>

  <xsl:if test="$sc_description='YES'">
    <xsl:choose>
      <!-- an ABSTRACT ONEOF -->
      <xsl:when test="(./@abstract.supertype='YES') and ($one_of = 'ONEOF')">
        <p>
          The
          <b>
            <xsl:value-of select="@name"/>
          </b> 
          constraint specifies that 
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>
          is an abstract supertype and that instances of subtypes of
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>
          shall not be simultaneously of type 
          <xsl:call-template name="link_list">
            <xsl:with-param name="list" select="$sc_list"/>
            <xsl:with-param name="suffix" select="', '"/>
            <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
            <xsl:with-param name="clause" select="'section'"/>
            <xsl:with-param name="and_for_last_pair" select="'yes'"/>
          </xsl:call-template>.
        </p>
      </xsl:when>
      
      <xsl:when test="($one_of = 'ONEOF')">
        <p>
          The
          <b>
            <xsl:value-of select="@name"/>
          </b> 
          constraint specifies that instances of subtypes of
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>
          shall not be simultaneously of type 
          <xsl:call-template name="link_list">
            <xsl:with-param name="list" select="$sc_list"/>
            <xsl:with-param name="suffix" select="', '"/>
            <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
            <xsl:with-param name="clause" select="'section'"/>
            <xsl:with-param name="and_for_last_pair" select="'yes'"/>
          </xsl:call-template>.
        </p>
      </xsl:when>

      <!-- an ABSTRACT EXPRESSION -->
      <xsl:when test="(./@abstract.supertype='YES') and ./@super.expression">
        <p>
          The
          <b>
            <xsl:value-of select="@name"/>
          </b> 
          constraint specifies that 
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>
          is an abstract supertype and that defines 
          a constraint that applies to instances of subtypes of
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>.
        </p>
      </xsl:when>

      <!-- an subtype expression -->
      <xsl:when test="./@super.expression">
        <p>
          The
          <b>
            <xsl:value-of select="@name"/>
          </b> 
          constraint specifies a constraint that applies to instances of subtypes of
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>.
        </p>
      </xsl:when>

      <!-- an ABSTRACT supertype -->
      <xsl:when test="./@abstract.supertype='YES'">
          The
          <b>
            <xsl:value-of select="@name"/>
          </b> 
          constraint specifies that 
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>
          is an abstract supertype.
      </xsl:when>
    </xsl:choose>

  </xsl:if>
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="type" select="@name"/>
   </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description" mode="exp_description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false' and $sc_description!='YES'">
        <xsl:variable name="aname">
          <xsl:call-template name="express_a_name">
            <xsl:with-param name="section1" select="../@name"/>
            <xsl:with-param name="section2" select="@name"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e10: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="function">
	<xsl:param name="main_clause"/>
  <xsl:variable 
    name="schema_name" select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'function'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->
    <xsl:variable name="clause_header">
          <xsl:value-of select="concat($main_clause, $clause_number,' ',$schema_name,' function definitions')"/>
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <!-- no intro for the MIM or IR -->
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h2>
      <a name="functions">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h2>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
             
  <h2>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($main_clause, $clause_number,'.',position(),' ',@name)"/>
    </A>
  </h2>
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="type" select="@name"/>
    <xsl:with-param name="function" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e10: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <!-- output issues against function -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
  </xsl:call-template>

  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>

  <!--  start blockquote  -->
    <code>
      *)<br/>
      FUNCTION <xsl:value-of select="@name"/>
      <xsl:apply-templates select="./parameter" mode="code"/><xsl:text> : </xsl:text>
      <xsl:apply-templates select="./aggregate" mode="code"/>
      <xsl:apply-templates select="./*" mode="underlying"/>;
    </code>
      <xsl:apply-templates select="./algorithm" mode="code"/>
      <code>
      END_FUNCTION;
      <br/>(*
    </code>
  <!-- end blockquote -->

  <xsl:apply-templates select="./parameter" mode="description"/>
</xsl:template>

<xsl:template match="procedure">  
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'procedure'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first procedure so output the intro -->
    <xsl:variable name="clause_header">
    </xsl:variable>
          <xsl:value-of select="concat($clause_number,' ',$schema_name,' procedure definitions')"/>
    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <!-- no intro for the MIM -->
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h2>
      <a name="procedures">
        <xsl:value-of 
          select="$clause_header"/>
      </a>
      </h2> 
      <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <h2>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
    </A>
  </h2>
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="type" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e11: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  <!-- output any issue against procedure -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 
  
  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>
  <!--  start blockquote  -->
    <code>
      *)<br/>     
      PROCEDURE <xsl:value-of select="@name"/>
    <xsl:apply-templates select="./parameter" mode="code"/><xsl:text> : </xsl:text>
    <xsl:apply-templates select="./aggregate" mode="code"/>
    <xsl:apply-templates select="./*" mode="underlying"/>;
  </code>
    <xsl:apply-templates select="./algorithm" mode="code"/><br/>
    <code>
    END_PROCEDURE;
    <br/>(*
    </code>
  <!-- end blockquote -->
  <xsl:apply-templates select="./explicit" mode="description"/>
</xsl:template>

<!-- empty template to prevent the algorithm element being out put along
     with the code -->
<xsl:template match="parameter" mode="underlying"/>


<xsl:template match="parameter" mode="code">
  <xsl:if test="position()=1">&#160;(</xsl:if>
  <xsl:value-of select="@name"/><xsl:text> : </xsl:text>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>
  <xsl:choose>
    <xsl:when test="position()!=last()">
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="parameter" mode="description">
  <xsl:if test="position()=1">
    <p><u>Argument definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <!--  <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b>
-->
  <!-- get description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
    <xsl:with-param name="inline_aname" select="$aname"/>
    <xsl:with-param name="inline_name" select="@name"/>
  </xsl:call-template>
  
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../../@name"/>
          <xsl:with-param name="entity" select="../@name"/>
          <xsl:with-param name="attribute" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e12: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  <!-- output issues against parameter -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="algorithm" mode="code">
  <!-- empty algorithms are sometimes output so ignore -->
  <xsl:if test="string-length(normalize-space(.))>0">
    <pre>
      <xsl:value-of select="."/>
    </pre>
  </xsl:if>
</xsl:template>

<!-- empty template to prevent the algorithm element being out put along
     with the code -->
<xsl:template match="algorithm" mode="underlying"/>


<xsl:template match="rule">
  <xsl:param name="main_clause"/>  
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="main_clause" select="$main_clause"/>
      <xsl:with-param name="clause" select="'rule'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first rule so output the intro -->
    <xsl:variable name="clause_header">
          <xsl:choose>
            <xsl:when test="count(../type)>1">
			  <xsl:value-of select="concat($main_clause,$clause_number,' ',$schema_name,' rule definitions')"/>
            </xsl:when>
            <xsl:otherwise>
			  <xsl:value-of select="concat($main_clause,$clause_number,' ',$schema_name,' rule definition')"/>
            </xsl:otherwise>
          </xsl:choose>

    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <!-- no intro for the MIM -->
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>
    <h2>
      <a name="rules">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h2>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <h2>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($main_clause, $clause_number,'.',position(),' ',@name)"/>
    </A>
  </h2>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="type" select="@name"/>
    <xsl:with-param name="rule" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e13: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <!-- output any issue against algorithm -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="resdoc_name" select="$resdoc_name"/>
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 
  
  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>
 <p>
  <!-- start blockquote -->
    <code>
      *)<br/>
      RULE <xsl:value-of select="@name"/> FOR
    <br/>
      (<xsl:value-of select="translate(@appliesto,' ',', ')"/>);<br/>
  </code>
    <xsl:apply-templates select="./algorithm" mode="code"/>
    <code>
    <xsl:apply-templates select="./where" mode="code"/>
      END_RULE;
    <br/>(*
    </code>
  <!-- end blockquote -->
   </p>
  <p><u>Argument definitions:</u></p>
  <xsl:call-template name="process_rule_arguments">
    <xsl:with-param name="args" select="@appliesto"/>
  </xsl:call-template>

  <xsl:call-template name="output_where_formal"/>
  <xsl:call-template name="output_where_informal"/>
</xsl:template>

<xsl:template name="process_rule_arguments">
  <xsl:param name="args"/>
  <xsl:choose>
    <!-- single argument -->
    <xsl:when test="not(contains($args,' '))">
      <xsl:call-template name="output_rule_argument">
        <xsl:with-param name="arg" select="$args"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="arg1" select="substring-before($args,' ')"/>
      <xsl:variable name="rest" select="substring-after($args,' ')"/>
      <xsl:call-template name="output_rule_argument">
        <xsl:with-param name="arg" select="$arg1"/>
      </xsl:call-template>
      <xsl:if test="$rest">
        <xsl:call-template name="process_rule_arguments">
          <xsl:with-param name="args" select="$rest"/>
        </xsl:call-template>
      </xsl:if>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="output_rule_argument">
  <xsl:param name="arg"/>
  <p class="expressdescription">
    <b>
      <xsl:value-of select="concat($arg,' : ')"/>
    </b>
    <!-- output the default description -->
    the set of all instances of 
    <xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="$arg"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>.</p>
</xsl:template>


<!-- 
     Express is displayed in clauses: 
     Interfaces
     Constants
     Imported Constants
     Types
     Imported Types
     Entities
     Imported Entities
		 Subtype_constraints
     Functions
     Imported Functions
     Rules
     Imported Rules
     Procedures
     Imported Procedures
     Template checks to see whether a particular clause is present in the
     schema. 
     If it is the clause number is returned. If not 0 is returned.
     The clause argument is: 
     interface constant type entity function rule procedure
     imported_constant imported_type imported_entity 
     imported_function imported_rule imported_procedure
-->
<xsl:template name="express_clause_present">
  <xsl:param name="main_clause" />
  <xsl:param name="clause"/>
  <xsl:param name="schema_name"/>
  <!--
  <xsl:message >
main_clause in exp_cl_pres   :<xsl:value-of select="$main_clause"/>
  </xsl:message>
-->
  <xsl:variable name="resource_dir">
    <xsl:call-template name="resource_directory">
      <xsl:with-param name="resource" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <!--
  <xsl:message>
    resource_dir :<xsl:value-of select="$resource_dir"/>:  resource_dir 
  </xsl:message>
-->
  <xsl:variable name="xml_file">
    <!--
    <xsl:message>
        <xsl:value-of select="concat($resource_dir,'/',$schema_name,'.xml')"/>
    </xsl:message>
--> 
   <xsl:choose>
      <xsl:when test="contains($schema_name,'_schema')">
        <xsl:value-of select="concat($resource_dir,'/',$schema_name,'.xml')"/>
      </xsl:when>
      <xsl:when test="contains($schema_name,'aic_')">
        <xsl:value-of select="concat($resource_dir,'/',$schema_name,'.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- should never get here -->
        9999
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:variable>

  <xsl:variable name="clause_present">
    <xsl:choose>
      <xsl:when test="$clause='interface'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/interface">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>
              <xsl:with-param name="clause" select="'interface'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='constant'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/constant">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>
              <xsl:with-param name="clause" select="'constant'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='type'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/type">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>
              <xsl:with-param name="clause" select="'type'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>


      <xsl:when test="$clause='entity'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/entity">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>
              <xsl:with-param name="clause" select="'entity'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='subtype.constraint'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/subtype.constraint">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>
              <xsl:with-param name="clause" select="'subtype.constraint'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>


      <xsl:when test="$clause='function'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/function">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>
              <xsl:with-param name="clause" select="'function'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='rule'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/rule">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>

              <xsl:with-param name="clause" select="'rule'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='procedure'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/procedure">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>

              <xsl:with-param name="clause" select="'procedure'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
      <xsl:when test="$clause='imported_constant'">
        <xsl:choose>          
        <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='CONSTANT']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>

              <xsl:with-param name="clause" select="'imported_constant'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_type'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='TYPE']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>

              <xsl:with-param name="clause" select="'imported_type'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_entity'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='ENTITY']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>

              <xsl:with-param name="clause" select="'imported_entity'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_function'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='FUNCTION']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>

              <xsl:with-param name="clause" select="'imported_function'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_rule'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='RULE']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>

              <xsl:with-param name="clause" select="'imported_rule'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_procedure'">
        <xsl:choose>          
        <!-- There seems to be a bug in MXSL3. 
             Should not need to convert $xml_file to a string --> 
        <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='PROCEDURE']"> 
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="main_clause" select="$main_clause"/>
              <xsl:with-param name="clause" select="'imported_procedure'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$clause_present"/>
  <!--  <xsl:message>
  clause_present :<xsl:value-of select="$clause_present"/>    
  </xsl:message> -->
</xsl:template>


<!--
     The order of the clauses describing the express is:
     Interfaces
     Constants
     Imported Constants
     Types
     Imported Types
     Entities
     Imported Entities
		 Subtype_constraints
     Functions
     Imported Functions
     Rules
     Imported Rules
     Procedures
     Imported Procedures
     Each set of constructs is in a separate clause. The clauses are
     numbered consecutively.
     If the express does not contain a particular set of express
     constructs, then the clause is not output. This will obviously affect
     the numbering of the clauses.
          
     This template will return the number of the clause according to
     whether any of the previous express clauses are required.
     the clause argument is: 
     interface 
     constant type entity function rule procedure
     imported_constant imported_type imported_entity 
     imported_function imported_rule imported_procedure
-->
<xsl:template name="express_clause_number">
  <xsl:param name="main_clause" />
  <xsl:param name="clause"/>
  <xsl:param name="schema_name"/>

  <!--  <xsl:message>
    main_clause  in express_cl_num  :<xsl:value-of select="$main_clause"/>
  </xsl:message> -->

  <xsl:variable name="resource_dir">
    <xsl:call-template name="resource_directory">
      <xsl:with-param name="resource" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="xml_file">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_schema')">
        <xsl:value-of select="concat($resource_dir,'/',$schema_name,'.xml')"/>
      </xsl:when>
      <xsl:when test="contains($schema_name,'aic_')">
        <xsl:value-of select="concat($resource_dir,'/',$schema_name,'.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- should never get here -->
        1000
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:variable>


  <!-- create a variable for each clause then assign 1 to it if the clause
       exists in the express. Then add them together to give the number       
       -->
  <xsl:variable name="interface_clause">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_schema')">
        <xsl:choose>
          <xsl:when
            test="document(string($xml_file))/express/schema/interface">
            1
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>

  </xsl:variable>

  <xsl:variable name="constant_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/constant">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_constant_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='CONSTANT']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="type_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/type">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_type_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='TYPE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="entity_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/entity">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_entity_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='ENTITY' or @kind='ATTRIBUTE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="subtype_constraint_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/subtype.constraint">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="function_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/function">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_function_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='FUNCTION']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="rule_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/rule">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_rule_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='RULE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="procedure_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/procedure">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_procedure_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='PROCEDURE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <!-- now add the clause variables together according to which clause
       number is required -->

  <xsl:variable name="clause_number">
    <xsl:choose>
      <xsl:when test="$clause='interface'">
        <xsl:value-of select="$interface_clause"/>
      </xsl:when>

      <xsl:when test="$clause='constant'">
        <xsl:value-of select="$interface_clause + $constant_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_constant'">
        <!-- temporary kludge to deal with the fact that in an IR 
             there is not a separate subclause for the interfaced schemas.
             -->
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause"/>
      </xsl:when>

      <xsl:when test="$clause='type'">
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause + 
                              $type_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_type'">
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause + 
                              $type_clause + $imported_type_clause"/>
      </xsl:when>

      <xsl:when test="$clause='entity'">
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause +
                              $entity_clause"/>

        <!--        <xsl:message>
          in clause number
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause +
                              $entity_clause"/>
          
        </xsl:message>  -->
      </xsl:when>
      <xsl:when test="$clause='imported_entity'">
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause"/>
      </xsl:when>

      <xsl:when test="$clause='subtype.constraint'">
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
                              $subtype_constraint_clause"/>
      </xsl:when>

      <xsl:when test="$clause='function'">
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause +
			      $subtype_constraint_clause + 
                              $function_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_function'">
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
															$subtype_constraint_clause + 
                              $function_clause + $imported_function_clause"/>
      </xsl:when>

      <xsl:when test="$clause='rule'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
															$subtype_constraint_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_rule'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
															$subtype_constraint_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause + $imported_rule_clause"/>
      </xsl:when>

      <xsl:when test="$clause='procedure'">
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause +
                              $entity_clause + $imported_entity_clause + 
															$subtype_constraint_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause + $imported_rule_clause +
                              $procedure_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_procedure'">
        <xsl:value-of select="1 + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
															$subtype_constraint_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause + $imported_rule_clause +
                              $procedure_clause + $imported_procedure_clause"/>
      </xsl:when>

    </xsl:choose>    
  </xsl:variable>
  <!-- if the schema ends in _arm then it is clause 4
       if it ends in _mim then it is clause 5.2
       -->
  <!--  <xsl:message>
    main_clause  :<xsl:value-of select="$main_clause" />   
  </xsl:message> -->
  <xsl:value-of select="concat('.',$clause_number+1)"/>
</xsl:template>



<xsl:template name="imported_constructs">
  <xsl:param name="desc_item"/>
  <xsl:if test="$desc_item">
    <xsl:variable name="kind" select="$desc_item/@kind"/>
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="lkind" select="translate($kind,$UPPER, $LOWER)"/>

    <xsl:variable name="imported_kind" select="concat('imported_',$lkind)"/>
    <xsl:variable name="schema_name" select="$desc_item/../../@name"/>
        <xsl:variable name="clause_number">
          <xsl:call-template name="express_clause_number">
            <xsl:with-param name="clause" select="$imported_kind"/>
            <xsl:with-param name="schema_name" select="$schema_name"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="clause_header">
          <xsl:choose>
            <xsl:when test="contains($schema_name,'_schema')">
              <xsl:value-of select="concat($clause_number, 
                                    ' EXPRESS imported ',
                                    $lkind,' modifications')"/>
            </xsl:when>
            <xsl:when test="contains($schema_name,'aic_')">
              <xsl:value-of select="concat($clause_number, 
                                    ' EXPRESS imported '
                                    ,$lkind,' modifications')"/>
            </xsl:when>
          </xsl:choose>      
        </xsl:variable>

        <xsl:variable name="aname" select="concat('imported_',$lkind)"/>
        <h2>
          <A NAME="{$aname}">
            <xsl:value-of select="$clause_header"/>
          </A>
        </h2>
        <xsl:apply-templates select="$desc_item"/>                    
      </xsl:if>
</xsl:template>

<xsl:template match="described.item">
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="lkind" select="translate(@kind,$UPPER, $LOWER)"/>
  <xsl:variable name="imported_kind" select="concat('imported_',$lkind)"/>

  <xsl:variable name="schema_name" select="../../@name"/>
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="$imported_kind"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  
  <h4>
    <xsl:value-of select="concat($clause_number,'.',position(),' ',@item )"/>
  </h4>
  <!-- get information about the resource from which the construct is being
       imported -->
  <xsl:variable name="resource_dir">
    <xsl:call-template name="resource_directory">
      <xsl:with-param name="resource" select="../@schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="resource_no"
    select="document(concat($resource_dir,'/resource.xml'))/resource/@part"/>
  <xsl:variable name="resdoc_name">
    <xsl:call-template name="resdoc_name">
      <xsl:with-param name="resdoc" select="../@schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="resource_href"
    select="concat('../../',$resdoc_name,'/sys/1_scope',$FILE_EXT)"/>
  
  The base definition of the 
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@item"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>
  <xsl:value-of select="concat(' ',$lkind)"/>
  is specified in 
  <a href="{$resource_href}">
    <xsl:value-of select="concat('ISO 10303-',$resource_no)"/>
  </a>
  The following modifications apply to this part of ISO 10303.
  <p>
    The definition of 
    <xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@item"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>
    is modified as follows:
  </p>
  <ul>
    <li>
      <xsl:apply-templates/>
    </li>
  </ul>
</xsl:template>


<xsl:template match="select" mode="description">
  <!--  output the boilerplate select descriptions for selects. -->
  <xsl:variable name="description_file"
    select="/express/@description.file"/>
  <xsl:variable name="select_description">
    <xsl:choose>
      <xsl:when test="$description_file">
        <xsl:value-of select="document($description_file)/ext_descriptions/@describe.selects"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'NO'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="typename" select="../@name"/>

  <xsl:if test="$select_description='YES'">    
    <xsl:choose>
      <xsl:when test="@basedon and @extensible='YES'">
        <!-- an extended and extensible SELECT type -->
         <!-- <p><b><i><font color="#FF0000">an extended and extensible SELECT type</font></i></b></p> -->
        The <b><xsl:value-of select="$typename"/></b> type is an extension
        of the 
        <b>
          <xsl:call-template name="link_object">
            <xsl:with-param name="object_name" select="@basedon"/>
            <xsl:with-param name="object_used_in_schema_name" 
              select="../../@name"/>
            <xsl:with-param name="clause" select="'section'"/>
          </xsl:call-template>  
        </b> type. 
        <xsl:if test="@selectitems and (string-length(@selectitems)!=0)">
          It adds the data 
          <xsl:choose>
            <!-- if the list has a space there must be more than one item -->
            <xsl:when test="contains(normalize-space(@selectitems),' ')">
              types
            </xsl:when>
            <xsl:otherwise>
              type
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="link_list">
            <xsl:with-param name="suffix" select="', '"/>
            <xsl:with-param name="list" select="@selectitems"/>
            <xsl:with-param name="object_used_in_schema_name"
              select="../../@name"/>
            <xsl:with-param name="clause" select="'section'"/>
            <xsl:with-param name="and_for_last_pair" select="'yes'"/>
          </xsl:call-template>
          to the list of alternate data types.
        </xsl:if>
        <p class="note">
          <small>
            NOTE&#160;&#160;The list of entity data types will be
            extended in application resources that use the constructs of
            this resource.                 
          </small>
        </p>
      </xsl:when>

      <xsl:when test="(@basedon and @extensible='NO') or @basedon">
        <!-- an extended not extensible SELECT type  -->
         <!-- <p><b><i><font color="#FF0000">an extended not extensible SELECT type</font></i></b></p> -->
        The <b><xsl:value-of select="$typename"/></b> type is an extension
        of the 
        <b>
          <xsl:call-template name="link_object">
            <xsl:with-param name="object_name" select="@basedon"/>
            <xsl:with-param name="object_used_in_schema_name" 
              select="../../@name"/>
            <xsl:with-param name="clause" select="'section'"/>
          </xsl:call-template>  
        </b> type. 
        <xsl:if test="@selectitems and (string-length(@selectitems)!=0)">
          It adds the data 
          <xsl:choose>
            <!-- if the list has a space there must be more than one item -->
            <xsl:when test="contains(normalize-space(@selectitems),' ')">
              types
            </xsl:when>
            <xsl:otherwise>
              type
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="link_list">
            <xsl:with-param name="suffix" select="', '"/>
            <xsl:with-param name="list" select="@selectitems"/>
            <xsl:with-param name="object_used_in_schema_name"
              select="../../@name"/>
            <xsl:with-param name="clause" select="'section'"/>
            <xsl:with-param name="and_for_last_pair" select="'yes'"/>
          </xsl:call-template>
          to the list of alternate data types.
        </xsl:if>
      </xsl:when>

      <xsl:when test="@extensible='YES'">
        <!-- extensible SELECT type -->
        <xsl:choose>

          <xsl:when test="@selectitems">
            <!-- an extensible non-empty SELECT type -->
             <!-- <p><b><i><font color="#FF0000">an extensible non-empty SELECT type</font></i></b></p> -->
            The <b><xsl:value-of select="$typename"/></b> type is an
            extensible list of alternate data types. It provides a
            mechanism to refer to instances of the data types included in
            the <b><xsl:value-of select="$typename"/></b> type or in its
            extensions.  
            <p class="note">
              <small>
                NOTE&#160;&#160;The list of entity data types will be
                extended in application resources that use the constructs of
                this resource.                 
              </small>
            </p>
          </xsl:when>

          <xsl:otherwise>
            <!-- an extensible empty SELECT type -->
            <!-- <p><b><i><font color="#FF0000">an extensible empty SELECT type</font></i></b></p> -->
            The <b><xsl:value-of select="$typename"/></b> type is an
            extensible list of alternate data types. It provides a
            mechanism to refer to instances of the data types included in
            the types that extend the 
            <b><xsl:value-of select="$typename"/></b> type. 
            <!--
              The <b><xsl:value-of select="$typename"/></b> type shall be
            extended in schemas that use the constructs of this
            resource.
                 -->
            <p class="note">
              <small>
                NOTE&#160;&#160;This empty extensible select requires
                extension in a further schema to ensure that entities that refer to it have
                at least one valid instantiation.
              </small>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- a non extensible SELECT type -->
         <!-- <p><b><i><font color="#FF0000">a non extensible SELECT type</font></i></b></p> -->
        The <b><xsl:value-of select="$typename"/></b> type is a list of
        alternate data types. It provides a mechanism to refer to an
        instance of one of these data types.  
      </xsl:otherwise>
      
    </xsl:choose>    
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
