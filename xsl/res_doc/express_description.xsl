<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: express_description.xsl,v 1.7 2009/11/07 09:50:49 lothartklein Exp $
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
  <xsl:param name="inline_aname"/>
  <xsl:param name="inline_name"/>
  <xsl:apply-templates select="." mode="validate_external_description"/>
  <xsl:choose>
    <!-- the name is to be included in the first line of the definition -->
    <xsl:when test="string-length($inline_name)>0">
      <xsl:apply-templates select="." mode="output_inline_descr">
        <xsl:with-param name="inline_aname" select="$inline_aname"/>
        <xsl:with-param name="inline_name" select="$inline_name"/>
      </xsl:apply-templates>        
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- check that the description is valid. If not, output a warning -->
<xsl:template match="description|ext_description" mode="validate_external_description">
  <!-- the checks need to be written.
       it would be useful if output_external_description used the same
       check -->
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

  <!-- if an entity, the name of an attribute 
       Optional parameter -->
  <xsl:param name="optional" select="''"/>

  
  <!-- if an entity, the name of a where rule 
       Optional exclusive parameter -->
  <xsl:param name="where" select="''"/>

  <!-- if an entity, the name of a unique rule 
       Optional exclusive parameter -->
  <xsl:param name="unique" select="''"/>

  <!-- if an entity, the node
       Optional exclusive parameter -->
  <xsl:param name="supertypes" select="''"/>

  <!-- if outputting a definition that should include the name of the thing
       being defined on one line, such as an attribute or where rule,
       (explicit derived inverse where)
       then include these attributes -->
  <xsl:param name="inline_name" select="''"/>
  <xsl:param name="inline_aname" select="''"/>

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

    <xsl:variable name="flat_description">
      <xsl:apply-templates select="$description" mode="flatten_description"/>
    </xsl:variable>


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


          <!--<xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Warning Ent7: bold text &quot;', . , '&quot; found in definition of express identifier  &quot;',$description/@linkend,'&quot;','  If an express identifier, consider tagging as &lt;express_ref&gt;.')"/>
                </xsl:call-template> MWD this warning removed as bold is sometimes required in EXPRESS descriptions other than for (mis-)tagging EXPRESS object references -->
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
      
      
<!-- if an attribute, should start with a or an, not is -->

    <xsl:if test="string-length($type)=0 and contains(substring-after($description/@linkend,'.'),'.') and not(contains($schema,$description/@linkend)) and not(contains($description/@linkend,'.wr:'))">



      <xsl:if test="$ERROR_CHECK_ATTRIBUTES='YES'">
        <xsl:variable name="raw_phrase">
          <xsl:apply-templates select="$description" mode="phrase_text"/>
        </xsl:variable>
        <xsl:variable name="phrase" select="normalize-space($raw_phrase)"/>
        <!--        <xsl:variable name="phrase" select="normalize-space($description/text())"/> -->

        <xsl:variable name="first_word"
          select="substring-before($phrase,' ')"/>
        <xsl:variable name="second_word"
          select="substring-before(substring-after($phrase,' '),' ')"/>
        
        <xsl:if test="string-length($attribute)>0">
          <xsl:choose>
            <!-- check for description: the description -->
            <xsl:when test="$attribute=$second_word">
              <xsl:call-template name="error_message">
                <xsl:with-param 
                  name="message" 
                  select="concat('Warning Attr1 ', $description/@linkend,
                          '. Circular definition. 
                          The attribute description should not start with the name of the attribute#
                          Phrase:',$phrase)"/>
              </xsl:call-template>
            </xsl:when>
            
            <xsl:when test="$attribute='id'">
              <xsl:if test="not(contains($phrase,'identifier'))">
                <xsl:call-template name="error_message">
                  <xsl:with-param 
                    name="message" 
                    select="concat('Warning Attr2 ' ,
                            $description/@linkend,
                            '. Id attribute description should be a phrase.#
                            is:',$phrase,'#
                            Usually will start with &quot;the identifier for xxx&quot;.')"/>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>

            <xsl:when test="$attribute='name'">
              <xsl:if test="not(contains($phrase,'label'))">
                <xsl:call-template name="error_message">
                  <xsl:with-param 
                    name="message" 
                    select="concat('Warning Attr3 ' ,
                            $description/@linkend,
                            '. Name attribute description should be a phrase.#
                            is: &quot;',$phrase,'&quot;#
                            Usually will start with &quot;the label by which the xxx is known&quot;.')"/>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <xsl:when test="$attribute='description'">
              <xsl:if test="not(contains($phrase,'the text that characterizes the'))">
                <xsl:call-template name="error_message">
                  <xsl:with-param 
                    name="message" 
                    select="concat('Warning Attr4 ' ,
                            $description/@linkend,
                            '. Description attribute description should be a phrase.#
                            is: &quot;',$phrase,'&quot;#
                            Usually will start with &quot;the text that characterizes the&quot;.')"/>
                </xsl:call-template>
              </xsl:if>              
            </xsl:when>
            <xsl:when test="$attribute='purpose'">
              <xsl:if test="not(contains($phrase,'the text that'))">
                <xsl:call-template name="error_message">
                  <xsl:with-param 
                    name="message" 
                    select="concat('Warning Attr5 ' ,
                            $description/@linkend,
                            '. Purpose attribute description should be a phrase.#
                            is: &quot;',$phrase,'&quot;#
                            Usually will start with &quot;the text that&quot;.')"/>
                </xsl:call-template>
              </xsl:if>              
            </xsl:when>

            <xsl:when test="$attribute='restriction'">
              <xsl:if test="not(contains($phrase,'the text that'))">
                <xsl:call-template name="error_message">
                  <xsl:with-param 
                    name="message" 
                    select="concat('Warning Attr6 ' ,
                            $description/@linkend,
                            '. Name attribute description should be a phrase.#
                            is: &quot;',$phrase,'&quot;#
                            Usually will start with &quot;the text that&quot;.')"/>
                </xsl:call-template>
              </xsl:if>              
            </xsl:when>
          </xsl:choose>
        </xsl:if>


        <xsl:if test="not(contains('the a an one specifies', $first_word))">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Warning Ent9 ' , $description/@linkend, '. Attribute description should be a phrase. Usually will start with &quot;the&quot;, &quot;a&quot;, &quot;an&quot;, or &quot;one&quot;, but not &quot;is&quot; or &quot;this&quot;.')"/>
          </xsl:call-template>     
        </xsl:if>
      
        <!-- if the attribute is a relating or related attribute check that
             the phrase contains an instance -->             
        <xsl:if test="string-length($attribute)>0 and
          (contains($attribute,'relating') or contains($attribute,'related'))">
          <xsl:if test="not(contains($flat_description,'instance'))">
            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Warning Ent99 ' , $description/@linkend, 
                        '. The attribute is a relating or related so it should contain the
                        phrase &quot;instance&quot;.')"/>
            </xsl:call-template>            
          </xsl:if>
        </xsl:if>

        <!-- If the attribute is OPTIONAL, then it must have the phrase.
             The value of the attribute need not be specified.
             -->
        
        <xsl:variable name="optional_text1" select="'The value of the attribute need not be specified.'"/>
        <xsl:variable name="optional_text2" select="'The value of this attribute need not be specified.'"/>
        <xsl:choose>
          <xsl:when test="$optional='YES'">
            <xsl:if
              test="not(contains(normalize-space($flat_description),$optional_text1)) and
                    not(contains(normalize-space($flat_description),$optional_text2))">
              <xsl:call-template name="error_message">
                <xsl:with-param 
                  name="message" 
                  select="concat('Warning Ent10 ' , $description/@linkend, 
                          '. The attribute is optional. It should contain the
                          phrase &quot;The value of this attribute need not be specified.&quot;.')"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if
              test="(contains(normalize-space($flat_description),$optional_text1)) or
                    (contains(normalize-space($flat_description),$optional_text2))">
              <xsl:call-template name="error_message">
                <xsl:with-param 
                  name="message" 
                  select="concat('Warning Ent10:' , $description/@linkend, 
                          '. The attribute is NOT optional. It should NOT contain the
                          phrase &quot;The value of this attribute need not be specified.&quot;.')"/>
              </xsl:call-template>
            </xsl:if>          
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      

      
      <xsl:if test="contains(substring-before(normalize-space($description/text()[position()=1]),' '),'is')">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Ent9:' , $description/@linkend, '. Attribute description should be a phrase. Usually will start with &quot;the&quot;, &quot;a&quot;, &quot;an&quot;, or &quot;one&quot;, but not &quot;is&quot; or &quot;this&quot;.')"/>
        </xsl:call-template>        
      </xsl:if>
    </xsl:if>
    
    <!-- if an entity , that is 
         if 
         not a type rule function procedure constant 
         and only one dot in string (hence not an attribute) 
         and  string is more than the schema name ( hence not the  schema ) 
         ....  
         -->

    <xsl:if test="string-length($type)=0 and not(contains(substring-after($description/@linkend,'.'),'.')) and not(contains($schema,$description/@linkend))">
      <xsl:if test="string-length($rule)=0 and string-length($function)=0 and not(contains(substring(normalize-space($flat_description),1),'A'))">
        
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

      <xsl:if test="string-length($supertypes)>0 and not(contains(normalize-space($description),'is a type of '))">
        <xsl:call-template name="error_message">
          <xsl:with-param  name="message">
            <xsl:value-of select="concat('Warning Ent6: ',$description/@linkend, ' check for')"/>
            
&quot;              <xsl:value-of select="concat(' is a type of ', $supertypes,'.')" /> 
      &quot; . Supertype(s) should be tagged as express_ref    </xsl:with-param>
        </xsl:call-template>        
        
      </xsl:if>

    </xsl:if>

    <xsl:variable name="d" select="$description"/>
    <xsl:variable name="p" select="$d//text()"/>
    <xsl:variable name="q" select="$d//b/text()"/>
    <xsl:variable name="q1" select="$d//express_ref/text()"/>
    <xsl:variable name="q2" select="$q | $q1"/>
            
    <xsl:variable name="tnodes" select="$p [count( . | $q2) != count( $q2 ) ]"/>
    <!-- <xsl:call-template name="chktxt">
         <xsl:with-param name="tnodes" select="$p [count( . | $q2) != count( $q2 ) ]" />      
         </xsl:call-template>
         -->
    <xsl:apply-templates select="$tnodes" mode="chktxt"/>
    

    <xsl:choose>
      <!-- the name is to be included in the first line of the definition -->
      <xsl:when test="string-length($inline_name)>0">
        <xsl:apply-templates select="$description" mode="output_inline_descr">
          <xsl:with-param name="inline_aname" select="$inline_aname"/>
          <xsl:with-param name="inline_name" select="$inline_name"/>
        </xsl:apply-templates>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$description"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:if>  
     </xsl:template>

<xsl:template match="text()|b|p" mode="flatten_description">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="express_ref" mode="flatten_description">
  <xsl:variable name="express_ref" select="substring-after(@linkend,'.')"/>
  <xsl:value-of select="concat('ext{',$express_ref,'}')"/>
</xsl:template>

<xsl:template match="text" mode="phrase_text">
  <xsl:apply-templates mode="phrase_text"/>
</xsl:template>

<xsl:template match="express_ref" mode="phrase_text">
  <xsl:value-of select="substring-after(./@linkend,'.')" />
</xsl:template>

<xsl:template match="p" mode="phrase_text">
  <xsl:apply-templates mode="phrase_text"/>
</xsl:template>


<xsl:template match="text()" mode="chktxt" >
  <xsl:if test="contains(.,'_')">
    <xsl:call-template name="error_message">
      <xsl:with-param name="message" >       
      <xsl:value-of     select="concat('Warning Ent7: ',' check for express identifier not bold nor linked ')"/>
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
  <xsl:apply-templates/>
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


<xsl:template match="ext_description|description" mode="output_inline_descr">
  <xsl:param name="inline_aname"/>
  <xsl:param name="inline_name"/>

  <xsl:variable name="text_str" select="normalize-space(text())"/>
  <xsl:choose>
    <!-- expect the attribute to be plain text, or if starts with <p> not
         contain any block elements. If not flag an error -->
    <xsl:when test="string-length($text_str) != 0 and ./child::*[name()='p' or name()='screen' or name()='ul' or name()='example' or name()='note']">
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error ATTR1: attribute descriptions (',$inline_aname,') containing block elements such as ', name(./child::*[name()='p' or name()='screen' or name()='ul' or name()='note' or name()='example']), ' should start with p not text#Currently starts with:#',$text_str)"/>
      </xsl:call-template>
      <p class="expressdescription">
        <b>
          <a name="{$inline_aname}">
            <xsl:value-of select="$inline_name"/>:
          </a>
        </b>
        <xsl:apply-templates/>
      </p>
    </xsl:when>

    <!-- plain text -->
    <xsl:when test="string-length($text_str) != 0">
      <p class="expressdescription">
        <b>
          <a name="{$inline_aname}">
            <xsl:value-of select="$inline_name"/>:
          </a>
        </b>
        <xsl:apply-templates/>
      </p>
    </xsl:when>

    <!-- check that the first element is p -->
    <xsl:when test="name(child::*[1]) != 'p'">
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error ATTR2: attribute descriptions (',$inline_aname,') must start with a p element, not ', name(./child::*[1]))"/>
      </xsl:call-template>
      <p class="expressdescription">
        <b>
          <a name="{$inline_aname}">
            <xsl:value-of select="$inline_name"/>:
          </a>
        </b>
        <xsl:apply-templates/>
      </p>
    </xsl:when>

    <xsl:otherwise>
      <xsl:apply-templates select="./p[1]" mode="first_paragraph_attribute">
        <xsl:with-param name="inline_aname" select="$inline_aname"/>
        <xsl:with-param name="inline_name" select="$inline_name"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="./child::*[position() &gt; 1]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template match="p" mode="first_paragraph_attribute">
  <xsl:param name="inline_aname"/>
  <xsl:param name="inline_name"/>
  <xsl:apply-templates select="." mode="check_html"/>
  <p class="expressdescription">
    <b>
      <a name="{$inline_aname}">
        <xsl:value-of select="$inline_name"/>:
      </a>
    </b>
    <xsl:apply-templates/>
  </p>  
</xsl:template>


</xsl:stylesheet>