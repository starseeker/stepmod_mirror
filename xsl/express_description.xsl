<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: express_description.xsl,v 1.29 2003/07/21 21:54:07 thendrix Exp $
  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the commented XML encoded Express
     in clause 4 and 5 of a module.
-->


<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>


  <xsl:output method="html"/>


<!-- Output the description for an Express object, but first check that it
     is valid -->
<xsl:template match="description" mode="exp_description">
  <xsl:apply-templates select="." mode="validate_external_description"/>
  <xsl:apply-templates/>
</xsl:template>


<!-- check that the description is valid. If not, output a warning -->
<xsl:template match="description|ext_description" mode="validate_external_description">
  <!-- the checks need to be written.
       it would be useful if output_external_description used the same check
</xsl:template>


<xsl:template name="output_external_description">
  <!--
       The name of the express schema 
       Compulsory parameter -->
  <xsl:param name="schema"/>
  
  <!-- the name of the entity, type, function, rule, procedure, constant 
       Optional parameter -->
  <xsl:param name="entity" select="''"/>
  
  
  <!-- if a type, the name of the type 
       Optional parameter -->
  <xsl:param name="type" select="''"/>
  
<!-- if a function, the name of the function
       Optional parameter -->
  
  <xsl:param name="function" select="''"/>

<!-- if a  rule, the name of the rule
       Optional parameter -->

  <xsl:param name="rule" select="''"/>

<!-- if a procedure, the name of the procedure
       Optional parameter -->
  <xsl:param name="procedure" select="''"/>

<!-- if a constant , the name of the  constant
       Optional parameter -->

  <xsl:param name="constant" select="''"/>
  

  <!-- if an entity, the name of an attribute 
       Optional exclusive parameter -->
  <xsl:param name="attribute" select="''"/>
  
  <!-- if an entity, the name of a where rule 
       Optional exclusive parameter -->
  <xsl:param name="where" select="''"/>

  <!-- if an entity, the name of a unique rule 
       Optional exclusive parameter -->
  <xsl:param name="unique" select="''"/>

  <!-- if an entity, the node
       Optional exclusive parameter -->

      <xsl:param name="supertypes" select="''"/>


  <xsl:variable name="description_file"
    select="/express/@description.file"/>
  
  <xsl:variable name="object" select="."/>

  <!-- 
       only proceed if there is a description file specified in the
       express 
       -->
  <xsl:if test="$description_file">
    <xsl:variable name="xref">
      <xsl:variable name="return1">
        <xsl:choose>
          <xsl:when test="$entity">
            <xsl:value-of select="concat($schema,'.',$entity)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$schema"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="return2">
        <xsl:choose>
          <xsl:when test="$attribute">
            <xsl:value-of select="concat($return1,'.',$attribute)"/>
          </xsl:when>
          <xsl:when test="$where">
            <xsl:value-of select="concat($return1,'.wr:',$where)"/>
          </xsl:when>
          <xsl:when test="$unique">
            <xsl:value-of select="concat($return1,'.ur:',$unique)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$return1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$return2"/>
    </xsl:variable>

    <xsl:variable name="descriptions"
      select="document($description_file)/ext_descriptions"/>    

    <xsl:variable name="description"

      select="$descriptions/ext_description[@linkend=$xref]"/>

    <xsl:if test="string-length($object/description)>0 and /express/@description.file">
      <xsl:variable name="arm_mim_file" select="concat(substring-before($description_file,'_'),'.xml')"/>
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error d1: description provided for ',@name, 
                  ' in ',$arm_mim_file,' and ', $description_file)"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="string-length($attribute)>0">
      <xsl:variable name="attr_start_char"
        select="substring(normalize-space($description),1,1)"/>
      <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

      <xsl:if test="contains($UPPER,$attr_start_char)">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Attr1: The first word of the attribute
                    definition should be lower case. It is: ',$attr_start_char)"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

    <!-- this test is not commmitted, as it does not apply to all projects
    <xsl:if test="$description/@linkend and contains($schema,$description/@linkend) and string-length(normalize-space($description)) > 1">
      <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Schem1: Description is provided for schema','')"/>
        </xsl:call-template>        


    </xsl:if>
 -->

      <xsl:for-each select="$description//b">

        <xsl:variable name="candidate-express-ref">
          <xsl:choose>
            <xsl:when test="string-length(substring-before(substring-after($description/@linkend,'.'),'.'))=0">
              <xsl:value-of select="concat(substring-before($description/@linkend,'.'),'.',substring-after($description/@linkend,'.'),'.',.)"/>
            </xsl:when>
            <xsl:otherwise>
           <xsl:value-of select="concat(substring-before($description/@linkend,'.'),'.', substring-before(substring-after($description/@linkend,'.'),'.'),'.',.)"/>              
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>

          <xsl:when test="(
(
not(contains(.,substring-before(substring-after($description/@linkend,'.'),'.'))) 
and  
string-length(substring-before(substring-after($description/@linkend,'.'),'.'))>0)
 or
(
not(contains(.,substring-after($description/@linkend,'.'))) 
and 
string-length(substring-before(substring-after($description/@linkend,'.'),'.'))=0)
)

and
            not($descriptions/ext_description[@linkend =  $candidate-express-ref])">


            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Warning Ent7: bold text &quot;', . , '&quot; found in definition of express identifier  &quot;',$description/@linkend,'&quot;','  If an express identifier, consider tagging as &lt;express_ref&gt;.')"/>
            </xsl:call-template>

            <!--
            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Test1 Ent7  cand-ex-ref: ', $candidate-express-ref)"/>
            </xsl:call-template>

            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Test2 Ent7  match cand-ex-ref: ', count($descriptions/ext_description[@linkend =  $candidate-express-ref]))"/>
            </xsl:call-template>

-->

          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      


      <xsl:variable name="ent_start_char"
        select="substring(normalize-space($entity),1,1)"/>
      <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
      
<!-- -->

<!-- if an entity , that is 
if 
    not a type rule function procedure constant 
and only one dot in string (hence not an attribute) 
and  string is more than the schema name ( hence not the  schema ) 
  ....  

-->

    <xsl:if test="string-length($type)=0 and not(contains(substring-after($description/@linkend,'.'),'.')) and not(contains($schema,$description/@linkend))">


      <xsl:if test="string-length($rule)=0 and not(contains(substring(normalize-space($description//text()),1),'A'))">
        
      <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Ent1: ',$description/@linkend,  '. Description of entity should start with A or An')"/>
        </xsl:call-template>        
        
      </xsl:if>

      <!--      <xsl:call-template name ="error_message">
        <xsl:with-param name="message">
        <xsl:value-of select="concat('global_xref_list: ' , $global_xref_list)" />
        </xsl:with-param>     
 </xsl:call-template> -->


 <xsl:if test="not($description//b/text()) and not($description//express_ref)">
      <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Ent2:' , $description/@linkend, '. Should be at least one bold text or express ref in the description of entity. It should contains the entity name ')"/>
        </xsl:call-template>        
      </xsl:if>


      <!-- if -->
      <!--      <xsl:if test="not(contains('is',substring-before(normalize-space($description/text()[position()=2]),' ')))"> -->
<xsl:if test="string-length($rule)=0 and not(contains('is',substring-before(substring-after(substring-after(normalize-space($description),' '),' '),' ')))">
      <xsl:call-template name="error_message">
          <xsl:with-param  name="message"  >
            <xsl:value-of select="concat('Warning Ent3: ', $description/@linkend, '. Check that the description starts with' )"/>
          &quot;    <xsl:value-of select="concat(' A or an ',$entity,' is ')" />
          &quot;  </xsl:with-param>
        </xsl:call-template>        
      </xsl:if>

      <xsl:if test="not(contains($description/@linkend,$description/b/text())) and not(contains($description/@linkend,$description/express_ref/@linkend))">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Ent4: ',  $description/@linkend, '. There should be at least one bold text or express_ref in the entity description that contains the entity name. ')"/>
        </xsl:call-template>
        
      </xsl:if>
      
      <!--       NOTE this does not work when supertype is an express_ref

<xsl:if test="string-length($supertypes)>0 and not(contains(normalize-space($description),concat('is a type of ',substring-before($supertypes,' ')))) and not(contains(normalize-space($description),concat('is a type of ',substring-after($supertypes,' '))))" >
        
        <xsl:call-template name="error_message">
          <xsl:with-param  name="message" >
            <xsl:value-of select="concat('Warning Ent5: ',$description/@linkend, ' check for')" />

&quot;              <xsl:value-of select="concat(' is a type of ', $supertypes,'.')" /> 
      &quot; . Supertype(s) should be tagged as express_ref    </xsl:with-param>
        </xsl:call-template>        
        
      </xsl:if>
-->

<xsl:if test="string-length($supertypes)>0 and not(contains(normalize-space($description),'is a type of '))" >
        
        <xsl:call-template name="error_message">
          <xsl:with-param  name="message" >
            <xsl:value-of select="concat('Warning Ent5: ',$description/@linkend, ' check for')" />

&quot;              <xsl:value-of select="concat(' is a type of ', $supertypes,'.')" /> 
      &quot; . Supertype(s) should be tagged as express_ref    </xsl:with-param>
        </xsl:call-template>        
        
      </xsl:if>





    </xsl:if>

    <xsl:variable name="d" select="$description" />
      <xsl:variable name="p" select="$d//text()"/>
      <xsl:variable name="q" select="$d//b/text()" />
        <xsl:variable name="q1" select="$d//express_ref/text()" />
          <xsl:variable name="q2" select="$q | $q1" />
            
            <xsl:variable name="tnodes" select="$p [count( . | $q2) != count( $q2 ) ]" />
              <!-- <xsl:call-template name="chktxt">
                   <xsl:with-param name="tnodes" select="$p [count( . | $q2) != count( $q2 ) ]" />      
                   </xsl:call-template>
                   -->
               
                   <xsl:apply-templates select="$tnodes" mode="chktxt" />
                 
                 <xsl:apply-templates select="$description" />
                   
                 </xsl:if>  
               </xsl:template>


<xsl:template match="text()" mode="chktxt" >
  <xsl:if test="contains(.,'_')">
    <xsl:call-template name="error_message">
      <xsl:with-param name="message" >       
      <xsl:value-of     select="concat('Warning Ent6: ',' check for express identifier not bold nor linked ')"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- return false if the description does not exist in an external file -->
<xsl:template name="check_external_description">
  <!--
       The name of the express schema 
       Compulsory parameter -->
  <xsl:param name="schema"/>
  
  <!-- the name of the entity, type, function, rule, procedure, constant 
       Optional parameter -->
  <xsl:param name="entity" select="''"/>

  <!-- if a type, the name of the type 
       Optional parameter -->
  <xsl:param name="type" select="''"/>
  
  <!-- if an entity, the name of an attribute 
       Optional exclusive parameter -->
  <xsl:param name="attribute" select="''"/>
  
  <!-- if an entity, the name of a where rule 
       Optional exclusive parameter -->
  <xsl:param name="where" select="''"/>

  <!-- if an entity, the name of a unique rule 
       Optional exclusive parameter -->
  <xsl:param name="unique" select="''"/>

  <xsl:variable name="description_file"
    select="/express/@description.file"/>

  <xsl:variable name="found_description">
    <xsl:choose>
      <xsl:when test="$description_file">
        <xsl:variable name="xref">
          <xsl:variable name="return1">
            <xsl:choose>
              <xsl:when test="$entity">
                <xsl:value-of select="concat($schema,'.',$entity)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$schema"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          
          <xsl:variable name="return2">
            <xsl:choose>
              <xsl:when test="$attribute">
                <xsl:value-of select="concat($return1,'.',$attribute)"/>
              </xsl:when>
              <xsl:when test="$where">
                <xsl:value-of select="concat($return1,'.wr:',$where)"/>
              </xsl:when>
              <xsl:when test="$unique">
                <xsl:value-of select="concat($return1,'.ur:',$unique)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$return1"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:value-of select="$return2"/>
        </xsl:variable> <!-- xref -->



        <xsl:variable name="description"
          select="document($description_file)/ext_descriptions/ext_description[@linkend=$xref]"/>
        <!-- debug
        <xsl:message>
          <xsl:value-of select="concat($xref,' -',string-length($description))"/></xsl:message>
          -->

        <xsl:choose>
          <xsl:when test="$description and string-length($description)>1">
            <xsl:value-of select="'true'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'false'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'false'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> <!-- found_description -->
  <xsl:value-of select="$found_description"/>
</xsl:template>

<xsl:template match="ext_description">
  <xsl:apply-templates />
</xsl:template>


<!-- return the string "notes" if there are any note in the external
     description -->
<xsl:template name="notes_in_external_description">
  <!--
       The name of the express schema 
       Compulsory parameter -->
  <xsl:param name="schema"/>
  
  <!-- the name of the entity, type, function, rule, procedure, constant 
       Optional parameter -->
  <xsl:param name="entity" select="''"/>
  
  <!-- if an entity, the name of an attribute 
       Optional exclusive parameter -->
  <xsl:param name="attribute" select="''"/>
  
  <!-- if an entity, the name of a where rule 
       Optional exclusive parameter -->
  <xsl:param name="where" select="''"/>

  <!-- if an entity, the name of a unique rule 
       Optional exclusive parameter -->
  <xsl:param name="unique" select="''"/>

  <xsl:variable name="description_file"
    select="/express/@description.file"/>
  
  <!-- 
       only proceed if there is a description file specified in the
       express 
       -->
  <xsl:if test="$description_file">
    <xsl:variable name="xref">
      <xsl:variable name="return1">
        <xsl:choose>
          <xsl:when test="$entity">
            <xsl:value-of select="concat($schema,'.',$entity)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$schema"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="return2">
        <xsl:choose>
          <xsl:when test="$attribute">
            <xsl:value-of select="concat($return1,'.',$attribute)"/>
          </xsl:when>
          <xsl:when test="$where">
            <xsl:value-of select="concat($return1,'.wr:',$where)"/>
          </xsl:when>
          <xsl:when test="$unique">
            <xsl:value-of select="concat($return1,'.ur:',$unique)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$return1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$return2"/>
    </xsl:variable>
    
    <xsl:variable name="description"
      select="document($description_file)/ext_descriptions/ext_description[@linkend=$xref]"/>
    <xsl:choose>
      <xsl:when test="$description//note">
        <xsl:value-of select="'notes'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:if>
</xsl:template>

</xsl:stylesheet>