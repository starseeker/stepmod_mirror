<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: introduction.xsl,v 1.1 2002/09/09 07:28:47 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Set up a banner plus menus in the top frame
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>
  <xsl:import href="../../xsl/sect_contents.xsl"/>
  <xsl:import href="modules_list.xsl"/>


  <xsl:output method="html"/>

  <xsl:variable name="mod_file" 
	    select="concat('../../data/modules/',/stylesheet_application[1]/@directory,'/module.xml')"/>

  <xsl:variable name="module_node"
	    select="document($mod_file)"/>


  <xsl:variable name="arm_xml" select="concat('../../data/modules/',/stylesheet_application[1]/@directory,'/arm.xml')"/>
  <xsl:variable name="mim_xml" select="concat('../../data/modules/',/stylesheet_application[1]/@directory,'/mim.xml')"/>
  <xsl:variable name="arm_nodes" select="document($arm_xml)"/>
  <xsl:variable name="mim_nodes" select="document($mim_xml)"/>


  <xsl:variable name="arm-schema-name" select="$arm_nodes//schema/@name"/>

  <xsl:variable name="arm_schemas">
    <xsl:call-template name="depends-on-recurse-no-list-x">
      <xsl:with-param name="todo" select="concat(' ',$arm-schema-name,' ')"/>
      <xsl:with-param name="arm_or_mim" select="'_arm'"/>
      <xsl:with-param name="arm_or_mim_file" select="'arm.xml'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="mim-schema-name" select="$mim_nodes//schema/@name"/>


  <xsl:variable name="mim_schemas">
    <xsl:call-template name="depends-on-recurse-no-list-x">
      <xsl:with-param name="todo" select="concat(' ',$mim-schema-name,' ')"/>
      <xsl:with-param name="arm_or_mim" select="'_mim'"/>
      <xsl:with-param name="arm_or_mim_file" select="'mim.xml'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>


  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">

    <html>
      <head>
        <link rel="stylesheet" type="text/css"
          href="../../../../nav/css/nav.css"/> 
        <title>
          <xsl:value-of select="$module_node/module/@name"/>
        </title>
        <script language="JavaScript"><![CDATA[
        
          function swap(ShowDiv, HideDiv) {
            show(ShowDiv);
            hide(HideDiv);
          }

          function show(DivID) {
            DivID.style.display="block";
          }

          function hide(DivID) {
            DivID.style.display="none";
          }
      ]]></script>
        </head>
        <body>

          <xsl:variable name="ModuleClauseMenu" select="concat('ModuleClauseMenu',$module_node/@name)"/>
          <xsl:variable name="NoModuleClauseMenu" select="concat('NoModuleClauseMenu',$module_node/@name)"/>
          <!-- Module Clauses menu (OPEN) -->
          <div id="{$ModuleClauseMenu}" style="display:none">
            <p class="menulist">
              <a href="javascript:swap({$NoModuleClauseMenu}, {$ModuleClauseMenu});">
                <img src="../../../../images/minus.gif" alt="Close menu" 
                  border="false" align="middle"/>    
              </a>
              <b>Module clauses</b>
            </p>
            <xsl:apply-templates select="$module_node/module" mode="module_clause_menu"/>
          </div>

          <!-- Module Clauses menu (CLOSED) -->
          <div id="{$NoModuleClauseMenu}">
            <p class="menulist">
              <a href="javascript:swap({$ModuleClauseMenu}, {$NoModuleClauseMenu});">
                <img src="../../../../images/plus.gif" alt="Open menu" 
                  border="false" align="middle"/> 
              </a>
              <b>Module clauses</b>
            </p>
          </div>
          

          <xsl:variable name="DeveloperViewMenu" select="concat('DeveloperViewMenu',$module_node/@name)"/>
          <xsl:variable name="NoDeveloperViewMenu" select="concat('NoDeveloperViewMenu',$module_node/@name)"/>
          <!-- ModuleClausesMenu (OPEN) -->
          <div id="{$DeveloperViewMenu}" style="display:none">
            <p class="menulist">
              <a href="javascript:swap({$NoDeveloperViewMenu}, {$DeveloperViewMenu});">
                <img src="../../../../images/minus.gif" alt="Close menu" 
                  border="false" align="middle"/>    
              </a>
              <b>Developer View</b>
            </p>
            <xsl:variable name="module_root" select="concat('NoDeveloperViewMenu',$module_node/@name)"/>
            
            <xsl:apply-templates select="$module_node/module" mode="iso_sub_menus">
              <xsl:with-param name="module_root" select="'..'"/>
              <xsl:with-param name="image_root" select="'../../../../images'"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="$module_node/module" mode="summary_sub_menus">
              <xsl:with-param name="module_root" select="'..'"/>
              <xsl:with-param name="image_root" select="'../../../../images'"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="$module_node/module" mode="developer_sub_menus">
              <xsl:with-param name="module_root" select="'..'"/>
              <xsl:with-param name="image_root" select="'../../../../images'"/>
            </xsl:apply-templates>
            
          </div>  <!-- ModuleClausesMenu (OPEN) -->

          <!-- ModuleClausesMenu (CLOSED) -->
          <div id="{$NoDeveloperViewMenu}">
            <p class="menulist">
              <a href="javascript:swap({$DeveloperViewMenu}, {$NoDeveloperViewMenu});">
                <img src="../../../../images/plus.gif" alt="Open menu" 
                  border="false" align="middle"/> 
              </a>
              <b>Developer View</b>
            </p>
          </div>  <!-- ModuleClausesMenu (CLOSED) -->

          <xsl:variable name="ArmModulesUsedMenu" select="concat('ArmModulesUsedMenu',$module_node/@name)"/>
          <xsl:variable name="NoArmModulesUsedMenu" select="concat('NoArmModulesUsedMenu',$module_node/@name)"/>
          <!-- Modules used menu (OPEN) -->
          <div id="{$ArmModulesUsedMenu}" style="display:none">
            <p class="menulist">
              <a href="javascript:swap({$NoArmModulesUsedMenu}, {$ArmModulesUsedMenu});">
                <img src="../../../../images/minus.gif" alt="Close menu" 
                  border="false" align="middle"/>    
              </a>
              <b>Modules used in ARM</b>
              <xsl:call-template name="modules_used">
                <xsl:with-param name="schemas" select="$arm_schemas"/>
              </xsl:call-template>
            </p>
          </div>

          <!-- Modules used menu  (CLOSED) -->
          <div id="{$NoArmModulesUsedMenu}">
            <p class="menulist">
              <a href="javascript:swap({$ArmModulesUsedMenu}, {$NoArmModulesUsedMenu});">
                <img src="../../../../images/plus.gif" alt="Open menu" 
                  border="false" align="middle"/> 
              </a>
              <b>Modules used in ARM</b>
            </p>
          </div>

          <xsl:variable name="MimModulesUsedMenu" select="concat('MimModulesUsedMenu',$module_node/@name)"/>
          <xsl:variable name="NoMimModulesUsedMenu" select="concat('NoMimModulesUsedMenu',$module_node/@name)"/>
          <!-- Modules used menu (OPEN) -->
          <div id="{$MimModulesUsedMenu}" style="display:none">
            <p class="menulist">
              <a href="javascript:swap({$NoMimModulesUsedMenu}, {$MimModulesUsedMenu});">
                <img src="../../../../images/minus.gif" alt="Close menu" 
                  border="false" align="middle"/>    
              </a>
              <b>Modules used in MIM</b>
              <xsl:call-template name="modules_used">
                <xsl:with-param name="schemas" select="$mim_schemas"/>
              </xsl:call-template>
            </p>
          </div>

          <!-- Modules used menu  (CLOSED) -->
          <div id="{$NoMimModulesUsedMenu}">
            <p class="menulist">
              <a href="javascript:swap({$MimModulesUsedMenu}, {$NoMimModulesUsedMenu});">
                <img src="../../../../images/plus.gif" alt="Open menu" 
                  border="false" align="middle"/> 
              </a>
              <b>Modules used in MIM</b>
            </p>
          </div>

          <xsl:variable name="ArmObjectsMenu" select="concat('ArmObjectsMenu',$module_node/@name)"/>
          <xsl:variable name="NoArmObjectsMenu" select="concat('NoArmObjectsMenu',$module_node/@name)"/>
          <!-- ARM objects menu (OPEN) -->
          <div id="{$ArmObjectsMenu}" style="display:none">
            <p class="menulist">
              <a href="javascript:swap({$NoArmObjectsMenu}, {$ArmObjectsMenu});">
                <img src="../../../../images/minus.gif" alt="Close menu" 
                  border="false" align="middle"/>    
              </a>
              <b>ARM objects</b>
              <xsl:call-template name="arm_objects"/>
            </p>
          </div>

          <!-- ARM objects menu (CLOSED) -->
          <div id="{$NoArmObjectsMenu}">
            <p class="menulist">
              <a href="javascript:swap({$ArmObjectsMenu}, {$NoArmObjectsMenu});">
                <img src="../../../../images/plus.gif" alt="Open menu" 
                  border="false" align="middle"/> 
              </a>
              <b>ARM objects</b>
            </p>
          </div>

          <xsl:variable name="MimObjectsMenu" select="concat('MimObjectsMenu',$module_node/@name)"/>
          <xsl:variable name="NoMimObjectsMenu" select="concat('NoMimObjectsMenu',$module_node/@name)"/>
          <!-- MIM objects menu (OPEN) -->
          <div id="{$MimObjectsMenu}" style="display:none">
            <p class="menulist">
              <a href="javascript:swap({$NoMimObjectsMenu}, {$MimObjectsMenu});">
                <img src="../../../../images/minus.gif" alt="Close menu" 
                  border="false" align="middle"/>    
              </a>
              <b>MIM objects</b>
              <xsl:call-template name="mim_objects"/>
            </p>
          </div>

          <!-- MIM objects menu (CLOSED) -->
          <div id="{$NoMimObjectsMenu}">
            <p class="menulist">
              <a href="javascript:swap({$MimObjectsMenu}, {$NoMimObjectsMenu});">
                <img src="../../../../images/plus.gif" alt="Open menu" 
                  border="false" align="middle"/> 
              </a>
              <b>MIM objects</b>
            </p>
          </div>


        </body>
      </html>
 </xsl:template>


<!-- copied and modified from ../../xsl/sect_contents.xsl -->
<xsl:template match="module" mode="module_clause_menu">
  <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
  <xsl:variable name="mim_schema_name" select="concat(@name,'_mim')"/>

  
  <p class="menuitem1"><a href="../sys/cover{$FILE_EXT}" target="content">Cover page</a></p>
  <p class="menuitem1"><a href="../sys/foreword{$FILE_EXT}" target="content">Foreword</a></p>
  <p class="menuitem1"><a href="../sys/introduction{$FILE_EXT}" target="content">Introduction</a></p>
  <p class="menuitem1"><a href="../sys/1_scope{$FILE_EXT}" target="content">1 Scope</a></p>
  <p class="menuitem1"><a href="../sys/2_refs{$FILE_EXT}" target="content">2 Normative references</a></p>
  
  <xsl:choose>
    <xsl:when test="./definition/term">
      <!-- use #defns to link direct -->
      <p class="menuitem1">
        <a href="../sys/3_defs{$FILE_EXT}" target="content">
          3 Terms, definitions and abbreviations
        </a>
      </p>
    </xsl:when>
    <xsl:otherwise>
      <!-- use #defns to link direct -->
      <p class="menuitem1">
        <a href="../sys/3_defs{$FILE_EXT}" target="content">
          3 Terms and abbreviations
        </a>
      </p>
    </xsl:otherwise>
  </xsl:choose>
  
  <xsl:variable name="Clause4Menu" select="concat('Clause4Menu',$module_node/@name)"/>
  <xsl:variable name="NoClause4Menu" select="concat('NoClause4Menu',$module_node/@name)"/>
  <!-- Clause4Menu (OPEN) -->
  <div id="{$Clause4Menu}" style="display:none">
    <p class="menulist1">
      <a href="javascript:swap({$NoClause4Menu}, {$Clause4Menu});">
        <img src="../../../../images/minus.gif" alt="Close menu" 
          border="false" align="middle"/>    
      </a>
      <a href="../sys/4_info_reqs{$FILE_EXT}" target="content">4 Information requirements</a>
    </p>
    
    <p class="menuitem2">
      <a href="../sys/4_info_reqs{$FILE_EXT}#uof" target="content">4.1 Units of functionality</a>
    </p>
    
    <!-- only output if there are interfaces defined and therefore a
         section -->
    <xsl:variable name="interface_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'interface'"/>
        <xsl:with-param name="schema_name" select="$arm_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$interface_clause != 0">
      <p class="menuitem2">
        <a href="../sys/4_info_reqs{$FILE_EXT}#interfaces" target="content">
          <xsl:value-of select="concat($interface_clause,
                                ' Required AM ARMs')"/>
        </a>
      </p>
    </xsl:if>
    
    <!-- only output if there are constants defined and therefore a
         section -->
    <xsl:variable name="constant_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'constant'"/>
        <xsl:with-param name="schema_name" select="$arm_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$constant_clause != 0">
      <xsl:variable name="ConstantMenu" select="concat('ConstantMenu',$module_node/@name)"/>
      <xsl:variable name="NoConstantMenu" select="concat('NoConstantMenu',$module_node/@name)"/>
      
      <!-- ConstantMenu (OPEN) -->
      <div id="{$ConstantMenu}" style="display:none">
        <p class="menulist2">
          <a href="javascript:swap({$NoConstantMenu}, {$ConstantMenu});">
            <img src="../../../../images/minus.gif" alt="Close menu" 
              border="false" align="middle"/> 
          </a>
          <a href="../sys/4_info_reqs{$FILE_EXT}#constants" target="content">
            <xsl:value-of select="concat($constant_clause,' ARM constant definitions')"/>
          </a>
        </p>
        <xsl:apply-templates 
          select="$arm_nodes/express/schema/constant"
          mode="module_clause_menu"/>
      </div>
      <!-- ConstantMenu (CLOSED) -->
      <div id="{$NoConstantMenu}">
        <p class="menulist2">
          <a href="javascript:swap({$ConstantMenu}, {$NoConstantMenu});">
            <img src="../../../../images/plus.gif" alt="Open menu" 
              border="false" align="middle"/> 
          </a>
          <a href="../sys/4_info_reqs{$FILE_EXT}#constants" target="content">
            <xsl:value-of select="concat($constant_clause,' ARM constant definitions')"/>
          </a>
        </p>
      </div>
    </xsl:if>
    
    <!-- only output if there are imported constants defined and 
         therefore a section -->
    <xsl:variable name="imported_constant_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'imported_constant'"/>
        <xsl:with-param name="schema_name" select="$arm_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$imported_constant_clause != 0">
      <p class="menuitem2">
        &#160; &#160;
        <a href="../sys/4_info_reqs{$FILE_EXT}#imported_constant" target="content">
          <xsl:value-of select="concat($imported_constant_clause,
                                ' ARM imported constant modifications')"/>
        </a>
      </p>
    </xsl:if>
    
    
    <!-- only output if there are types defined and therefore a
         section -->
    <xsl:variable name="type_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'type'"/>
        <xsl:with-param name="schema_name" select="$arm_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$type_clause != 0">
      <xsl:variable name="TypeMenu" select="concat('TypeMenu',$module_node/@name)"/>
      <xsl:variable name="NoTypeMenu" select="concat('NoTypeMenu',$module_node/@name)"/>
      
      <!-- TypeMenu (OPEN) -->
      <div id="{$TypeMenu}" style="display:none">
        <p class="menulist2">
          <a href="javascript:swap({$NoTypeMenu}, {$TypeMenu});">
            <img src="../../../../images/minus.gif" alt="Close menu" 
              border="false" align="middle"/>    
          </a>
          <a href="../sys/4_info_reqs{$FILE_EXT}#types" target="content">
            <xsl:value-of select="concat($type_clause,' ARM type definitions')"/>
          </a>
        </p>
        <xsl:apply-templates 
          select="$arm_nodes/express/schema/type"
          mode="module_clause_menu"/>
      </div>

      <!-- TypeMenu (CLOSED) -->
      <div id="{$NoTypeMenu}">
        <p class="menulist2">
          <a href="javascript:swap({$TypeMenu}, {$NoTypeMenu});">
            <img src="../../../../images/plus.gif" alt="Open menu" 
              border="false" align="middle"/> 
          </a>
          <a href="../sys/4_info_reqs{$FILE_EXT}#types" target="content">
            <xsl:value-of select="concat($type_clause,' ARM type definitions')"/>
          </a>
        </p>
      </div>
    </xsl:if>
    
    
    <!-- only output if there are imported types defined and 
         therefore a section -->
    <xsl:variable name="imported_type_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'imported_type'"/>
        <xsl:with-param name="schema_name" select="$arm_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$imported_type_clause != 0">
      <p class="menuitem2">
        &#160; &#160; 
        <a href="../sys/4_info_reqs{$FILE_EXT}#imported_type" target="content">
          <xsl:value-of select="concat($imported_type_clause,
                                ' ARM imported type modifications')"/>
        </a>
      </p>
    </xsl:if>
    
    
    <!-- only output if there are entitys defined and therefore a
         section -->
    <xsl:variable name="entity_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'entity'"/>
        <xsl:with-param name="schema_name" select="$arm_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$entity_clause != 0">
      <xsl:variable name="EntityMenu" select="concat('EntityMenu',$module_node/@name)"/>
      <xsl:variable name="NoEntityMenu" select="concat('NoEntityMenu',$module_node/@name)"/>
      
      <!-- Entity menu (OPEN) -->
      <div id="{$EntityMenu}" style="display:none">
        <p class="menulist2">
          <a href="javascript:swap({$NoEntityMenu}, {$EntityMenu});">
            <img src="../../../../images/minus.gif" alt="Close menu" 
              border="false" align="middle"/>    
          </a>
          <a href="../sys/4_info_reqs{$FILE_EXT}#entities" target="content">
            <xsl:value-of select="concat($entity_clause,' ARM entity definitions')"/>
          </a>
        </p>
        <xsl:apply-templates 
          select="$arm_nodes/express/schema/entity" mode="module_clause_menu"/>
      </div><!-- Entity menu (OPEN) -->
      <!-- Entity menu (CLOSED) -->
      <div id="{$NoEntityMenu}">
        <p class="menulist2">
          <a href="javascript:swap({$EntityMenu}, {$NoEntityMenu});">
            <img src="../../../../images/plus.gif" alt="Open menu" 
              border="false" align="middle"/> 
          </a>
          <a href="../sys/4_info_reqs{$FILE_EXT}#entities" target="content">
            <xsl:value-of select="concat($entity_clause,' ARM entity definitions')"/>
          </a>
        </p>
      </div><!-- Entity menu (CLOSED) -->
    </xsl:if>
  
    <!-- only output if there are imported entitys defined and 
         therefore a section -->
    <xsl:variable name="imported_entity_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'imported_entity'"/>
        <xsl:with-param name="schema_name" select="$arm_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$imported_entity_clause != 0">
      <p class="menuitem2">
        &#160; &#160;
        <a href="../sys/4_info_reqs{$FILE_EXT}#imported_entity" target="content">
          <xsl:value-of select="concat($imported_entity_clause,
                                ' ARM imported entity modifications')"/>
        </a>
      </p>
    </xsl:if>
    
    
    <!-- only output if there are subtype_constraints defined and therefore a
         section -->
    <xsl:variable name="subtype_constraint_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'subtype.constraint'"/>
        <xsl:with-param name="schema_name" select="$arm_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$subtype_constraint_clause != 0">
      <xsl:variable name="SubConstrMenu" select="concat('SubConstrMenu',$module_node/@name)"/>
      <xsl:variable name="NoSubConstrMenu" select="concat('NoSubConstrMenu',$module_node/@name)"/>
      
      <!-- SubConstrMenu (OPEN) -->
      <div id="{$SubConstrMenu}" style="display:none">
        <p class="menulist2">
          <a href="javascript:swap({$NoSubConstrMenu}, {$SubConstrMenu});">
            <img src="../../../../images/minus.gif" alt="Close menu" 
              border="false" align="middle"/>    
          </a>
          <a href="../sys/4_info_reqs{$FILE_EXT}#subtype_constraints" target="content">
            <xsl:value-of select="concat($subtype_constraint_clause,' ARM subtype constraint definitions')"/>
          </a>
        </p>
        <xsl:apply-templates 
          select="$arm_nodes/express/schema/subtype.constraint" mode="module_clause_menu"/>
      </div> <!-- SubConstrMenu (OPEN) -->

      <!-- SubConstrMenu (CLOSED) -->
      <div id="{$NoSubConstrMenu}">
        <p class="menulist2">
          <a href="javascript:swap({$SubConstrMenu}, {$NoSubConstrMenu});">
            <img src="../../../../images/plus.gif" alt="Open menu" 
              border="false" align="middle"/> 
          </a>
          <a href="../sys/4_info_reqs{$FILE_EXT}#subtype_constraints" target="content">
            <xsl:value-of select="concat($subtype_constraint_clause,' ARM subtype constraint definitions')"/>
          </a>
        </p>
      </div> <!-- SubConstrMenu (CLOSED) -->
    </xsl:if>
    
    
    <!-- only output if there are functions defined and therefore a
         section -->
    <xsl:variable name="function_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'function'"/>
        <xsl:with-param name="schema_name" select="$arm_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$function_clause !=0">
      <xsl:variable name="FunctionMenu" select="concat('FunctionMenu',$module_node/@name)"/>
      <xsl:variable name="NoFunctionMenu" select="concat('NoFunctionMenu',$module_node/@name)"/>
      
    <!-- FunctionMenu (OPEN) -->
    <div id="{$FunctionMenu}" style="display:none">
      <p class="menulist2">
        <a href="javascript:swap({$NoFunctionMenu}, {$FunctionMenu});">
          <img src="../../../../images/minus.gif" alt="Close menu" 
            border="false" align="middle"/>    
        </a>
        <a href="../sys/4_info_reqs{$FILE_EXT}#functions" target="content">
          <xsl:value-of select="concat($function_clause, ' ARM function definitions')"/>
        </a>
      </p>
      <xsl:apply-templates 
        select="$arm_nodes/express/schema/function"
        mode="module_clause_menu"/>
    </div> <!-- FunctionMenu (OPEN) -->
    
    <!-- FunctionMenu (CLOSED) -->
    <div id="{$NoFunctionMenu}">
      <p class="menulist2">
        <a href="javascript:swap({$FunctionMenu}, {$NoFunctionMenu});">
          <img src="../../../../images/plus.gif" alt="Open menu" 
            border="false" align="middle"/> 
        </a>
        <a href="../sys/4_info_reqs{$FILE_EXT}#functions" target="content">
          <xsl:value-of select="concat($function_clause, ' ARM function  definitions')"/>
        </a>
      </p>
    </div> <!-- FunctionMenu (CLOSED) -->
  </xsl:if>
  <!-- only output if there are imported functions defined and 
       therefore a section -->
  <xsl:variable name="imported_function_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_function'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_function_clause != 0">
    <p class="menuitem2">
      &#160; &#160;
      <a href="../sys/4_info_reqs{$FILE_EXT}#imported_function" target="content">
        <xsl:value-of select="concat($imported_function_clause,
                              ' ARM imported function modifications')"/>
      </a>
    </p>
  </xsl:if>
  
  <!-- only output if there are rules defined and therefore a
       section -->
  <xsl:variable name="rule_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'rule'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$rule_clause !=0">
    <xsl:variable name="RuleMenu" select="concat('RuleMenu',$module_node/@name)"/>
    <xsl:variable name="NoRuleMenu" select="concat('NoRuleMenu',$module_node/@name)"/>
    
    <!-- RuleMenu (OPEN) -->
    <div id="{$RuleMenu}" style="display:none">
      <p class="menulist2">
        <a href="javascript:swap({$NoRuleMenu}, {$RuleMenu});">
          <img src="../../../../images/minus.gif" alt="Close menu" 
            border="false" align="middle"/>    
        </a>
        <a href="../sys/4_info_reqs{$FILE_EXT}#rules" target="content">
          <xsl:value-of select="concat($rule_clause,
                                ' ARM rule definitions')"/>
        </a>
      </p>
      <xsl:apply-templates 
        select="$arm_nodes/express/schema/rule" mode="module_clause_menu"/>
    </div> <!-- RuleMenu (OPEN) -->

    <!-- RuleMenu (CLOSED) -->
    <div id="{$NoRuleMenu}">
      <p class="menulist2">
        <a href="javascript:swap({$RuleMenu}, {$NoRuleMenu});">
          <img src="../../../../images/plus.gif" alt="Open menu" 
            border="false" align="middle"/> 
        </a>
        <a href="../sys/4_info_reqs{$FILE_EXT}#rules" target="content">
          <xsl:value-of select="concat($rule_clause,
                                ' ARM rule definitions')"/>
        </a>
      </p>
    </div> <!-- RuleMenu (OPEN) -->
  </xsl:if>
  <!-- only output if there are imported rules defined and 
       therefore a section -->
  <xsl:variable name="imported_rule_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_rule'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_rule_clause != 0">
    <p class="menuitem2">
      &#160; &#160;
      <a href="../sys/4_info_reqs{$FILE_EXT}#imported_rule" target="content">
        <xsl:value-of select="concat($imported_rule_clause,
                              ' ARM imported rule modifications')"/>
      </a>
    </p>
  </xsl:if>
  
  <!-- only output if there are procedures defined and therefore a
       section -->
  <xsl:variable name="procedure_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'procedure'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$procedure_clause != 0">
    <xsl:variable name="ProcMenu" select="concat('ProcMenu',$module_node/@name)"/>
    <xsl:variable name="NoProcMenu" select="concat('NoProcMenu',$module_node/@name)"/>

    <!-- ProcMenu (OPEN) -->
    <div id="{$ProcMenu}" style="display:none">
      <p class="menulist2">
        <a href="javascript:swap({$NoProcMenu}, {$ProcMenu});">
          <img src="../../../../images/minus.gif" alt="Close menu" 
            border="false" align="middle"/>    
        </a>
        <a href="../sys/4_info_reqs{$FILE_EXT}#procedures" target="content">
          <xsl:value-of select="concat($procedure_clause,
                                ' ARM procedure definitions')"/>
        </a>
      </p>
      <xsl:apply-templates 
        select="$arm_nodes/express/schema/procedure"
        mode="module_clause_menu"/>
    </div>

    <!-- ProcMenu (CLOSED) -->
    <div id="{$NoProcMenu}">
      <p class="menulist2">
        <a href="javascript:swap({$ProcMenu}, {$NoProcMenu});">
          <img src="../../../../images/plus.gif" alt="Open menu" 
            border="false" align="middle"/> 
        </a>
        <a href="../sys/4_info_reqs{$FILE_EXT}#procedures" target="content">
          <xsl:value-of select="concat($procedure_clause,
                                ' ARM procedure definitions')"/>
        </a>
      </p>
    </div>
  </xsl:if>
  <!-- only output if there are imported procedures defined and 
       therefore a section -->
  <xsl:variable name="imported_procedure_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_procedure'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_procedure_clause != 0">
    <p class="menuitem2">
      &#160; &#160;
      <a href="../sys/4_info_reqs{$FILE_EXT}#imported_procedure" target="content">
        <xsl:value-of select="concat($imported_procedure_clause,
                              ' ARM imported procedure modifications')"/>
      </a>
    </p>
  </xsl:if>
</div> <!-- Clause4Menu (OPEN) -->

    <!-- Clause4Menu (CLOSED) -->
    <div id="{$NoClause4Menu}">
      <p class="menulist1">
        <a href="javascript:swap({$Clause4Menu}, {$NoClause4Menu});">
          <img src="../../../../images/plus.gif" alt="Open menu" 
            border="false" align="middle"/> 
        </a>
      <a href="../sys/4_info_reqs{$FILE_EXT}" target="content">4 Information requirements</a>
      </p>
    </div><!-- Clause4Menu (CLOSED) -->


  <!-- Output clause 5 index -->
  <!-- use #mim to link direct -->
  <xsl:variable name="Mim5Menu" select="concat('Mim5Menu',$module_node/@name)"/>
  <xsl:variable name="NoMim5Menu" select="concat('NoMim5Menu',$module_node/@name)"/>
  <!-- Mim5Menu (OPEN) -->
  <div id="{$Mim5Menu}" style="display:none">
    <p class="menulist1">
      <a href="javascript:swap({$NoMim5Menu}, {$Mim5Menu});">
        <img src="../../../../images/minus.gif" alt="Close menu" 
          border="false" align="middle"/>    
      </a>
      <a href="../sys/5_main{$FILE_EXT}" target="content">5 Module interpreted model</a>
    </p>

    <xsl:variable name="MappMenu" select="concat('MappMenu',$module_node/@name)"/>
    <xsl:variable name="NoMappMenu" select="concat('NoMappMenu',$module_node/@name)"/>
    <!-- MappMenu (OPEN) -->
    <div id="{$MappMenu}" style="display:none">
      <p class="menulist2">
        <a href="javascript:swap({$NoMappMenu}, {$MappMenu});">
          <img src="../../../../images/minus.gif" alt="Close menu" 
            border="false" align="middle"/>    
        </a>
        <a href="../sys/5_mapping{$FILE_EXT}" target="content">5.1 Mapping specification</a>
      </p>
      <xsl:apply-templates select="./mapping_table/ae" mode="toc"/>
    </div> <!-- MappMenu (OPEN) -->

    <!-- MappMenu (CLOSED) -->
    <div id="{$NoMappMenu}">
      <p class="menulist2">
        <a href="javascript:swap({$MappMenu}, {$NoMappMenu});">
          <img src="../../../../images/plus.gif" alt="Open menu" 
            border="false" align="middle"/> 
        </a>
        <a href="../sys/5_mapping{$FILE_EXT}" target="content">5.1 Mapping specification</a>
      </p>
    </div> <!-- MappMenu (CLOSED) -->


    <xsl:variable name="MimMenu" select="concat('MimMenu',$module_node/@name)"/>
    <xsl:variable name="NoMimMenu" select="concat('NoMimMenu',$module_node/@name)"/>
    
    <!-- MimMenu (OPEN) -->
    <div id="{$MimMenu}" style="display:none">
      <p class="menulist2">
        <a href="javascript:swap({$NoMimMenu}, {$MimMenu});">
          <img src="../../../../images/minus.gif" alt="Close menu" 
            border="false" align="middle"/>    
        </a>
        <a href="../sys/5_mim{$FILE_EXT}#mim_express" target="content">5.2 MIM EXPRESS short listing</a>
      </p>
      
      <!-- only output if there are constants defined and therefore a
           section -->
      <xsl:variable name="constant_mim_clause">
        <xsl:call-template name="express_clause_present">
          <xsl:with-param name="clause" select="'constant'"/>
          <xsl:with-param name="schema_name" select="$mim_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:if test="$constant_mim_clause != 0">
        <xsl:variable name="MimConstantMenu" select="concat('MimConstantMenu',$module_node/@name)"/>
        <xsl:variable name="NoMimConstantMenu" select="concat('NoMimConstantMenu',$module_node/@name)"/>
        
        <!-- MimConstantMenu (OPEN) -->
        <div id="{$MimConstantMenu}" style="display:none">
          <p class="menulist3">
            <a href="javascript:swap({$NoMimConstantMenu}, {$MimConstantMenu});">
              <img src="../../../../images/minus.gif" alt="Close menu" 
                border="false" align="middle"/>    
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#constants" target="content">
              <xsl:value-of select="concat($constant_mim_clause,
                                    ' MIM constant definitions')"/>
            </a>
          </p>
          <xsl:apply-templates 
            select="$mim_nodes/express/schema/constant"
            mode="module_clause_menu"/>
        </div>        <!-- MimConstantMenu (OPEN) -->

        <!-- MimConstantMenu (CLOSED) -->
        <div id="{$NoMimConstantMenu}">
          <p class="menulist3">
            <a href="javascript:swap({$MimConstantMenu},{$NoMimConstantMenu });">
              <img src="../../../../images/plus.gif" alt="Open menu" 
                border="false" align="middle"/> 
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#constants" target="content">
              <xsl:value-of select="concat($constant_mim_clause,
                                    ' MIM constant definitions')"/>
            </a>
          </p>
        </div>        <!-- MimConstantMenu (CLOSED) -->

      </xsl:if> 
         
      <!-- only output if there are imported constants defined and 
           therefore a section -->
      <xsl:variable name="imported_constant_mim_clause">
        <xsl:call-template name="express_clause_present">
          <xsl:with-param name="clause" select="'imported_constant'"/>
          <xsl:with-param name="schema_name" select="$mim_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$imported_constant_mim_clause != 0">
        <p class="menuitem3">
          <a href="../sys/5_mim{$FILE_EXT}#imported_constant" target="content">
            <xsl:value-of select="concat($imported_constant_mim_clause,
                                  ' MIM imported constant modifications')"/>
          </a>
        </p>
      </xsl:if>
      
      
      <!-- only output if there are types defined and therefore a
           section -->
      <xsl:variable name="type_mim_clause">
        <xsl:call-template name="express_clause_present">
          <xsl:with-param name="clause" select="'type'"/>
          <xsl:with-param name="schema_name" select="$mim_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$type_mim_clause != 0">
        <xsl:variable name="MimTypeMenu" select="concat('MimTypeMenu',$module_node/@name)"/>
        <xsl:variable name="NoMimTypeMenu" select="concat('NoMimTypeMenu',$module_node/@name)"/>
        
        <!-- MimTypeMenu (OPEN) -->
        <div id="{$MimTypeMenu}" style="display:none">
          <p class="menulist3">
            <a href="javascript:swap({$NoMimTypeMenu}, {$MimTypeMenu});">
              <img src="../../../../images/minus.gif" alt="Close menu" 
                border="false" align="middle"/>    
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#types" target="content">
              <xsl:value-of select="concat($type_mim_clause,
                                    ' MIM type definitions')"/>
            </a>
          </p>
          <xsl:apply-templates 
            select="$mim_nodes/express/schema/type"
            mode="module_clause_menu"/>
        </div>        <!-- MimTypeMenu (OPEN) -->

        <!-- MimTypeMenu (CLOSED) -->
        <div id="{$NoMimTypeMenu}">
          <p class="menulist3">
            <a href="javascript:swap({$MimTypeMenu},{$NoMimTypeMenu });">
              <img src="../../../../images/plus.gif" alt="Open menu" 
                border="false" align="middle"/> 
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#types" target="content">
              <xsl:value-of select="concat($type_mim_clause,
                                    ' MIM type definitions')"/>
            </a>
          </p>
        </div>        <!-- MimTypeMenu (CLOSED) -->

      </xsl:if>          
      <!-- only output if there are imported types defined and 
           therefore a section -->
      <xsl:variable name="imported_mim_type_clause">
        <xsl:call-template name="express_clause_present">
          <xsl:with-param name="clause" select="'imported_type'"/>
          <xsl:with-param name="schema_name" select="$mim_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$imported_mim_type_clause != 0">
        <p class="menuitem3">
          <a href="../sys/5_mim{$FILE_EXT}#imported_type" target="content">
            <xsl:value-of select="concat($imported_mim_type_clause,
                                  ' MIM imported type modifications')"/>
          </a>
        </p>
      </xsl:if>
      
    <!-- only output if there are entitys defined and therefore a
         section -->
    <xsl:variable name="entity_mim_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'entity'"/>
        <xsl:with-param name="schema_name" select="$mim_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$entity_mim_clause != 0">
      <xsl:variable name="MimEntityMenu" select="concat('MimEntityMenu',$module_node/@name)"/>
      <xsl:variable name="NoMimEntityMenu" select="concat('NoMimEntityMenu',$module_node/@name)"/>
      <!-- MimEntityMenu (OPEN) -->
      <div id="{$MimEntityMenu}" style="display:none">
          <p class="menulist3">
            <a href="javascript:swap({$NoMimEntityMenu}, {$MimEntityMenu});">
              <img src="../../../../images/minus.gif" alt="Close menu" 
                border="false" align="middle"/>    
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#entities" target="content">
              <xsl:value-of select="concat($entity_mim_clause,
                                    ' MIM entity definitions')"/>
            </a>
          </p>
          <xsl:apply-templates 
            select="$mim_nodes/express/schema/entity"
            mode="module_clause_menu"/>
        </div>        <!-- MimEntityMenu (OPEN) -->

        <!-- MimEntityMenu (CLOSED) -->
        <div id="{$NoMimEntityMenu}">
          <p class="menulist3">
            <a href="javascript:swap({$MimEntityMenu},{$NoMimEntityMenu });">
              <img src="../../../../images/plus.gif" alt="Open menu" 
                border="false" align="middle"/> 
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#entities" target="content">
              <xsl:value-of select="concat($entity_mim_clause,
                                    ' MIM entity definitions')"/>
            </a>
          </p>
        </div>        <!-- MimEntityMenu (CLOSED) -->

      </xsl:if>       
      
      <!-- only output if there are imported entitys defined and 
           therefore a section -->
      <xsl:variable name="imported_mim_entity_clause">
        <xsl:call-template name="express_clause_present">
          <xsl:with-param name="clause" select="'imported_entity'"/>
          <xsl:with-param name="schema_name" select="$mim_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$imported_mim_entity_clause != 0">
        <p class="menuitem3">
          <a href="../sys/5_mim{$FILE_EXT}#imported_entity" target="content">
            <xsl:value-of select="concat($imported_mim_entity_clause,
                                  ' MIM imported entity modifications')"/>
          </a>
        </p>
      </xsl:if>
      
      <!-- only output if there are subtype_constraints defined and therefore a
           section -->
      <xsl:variable name="subtype_constraint_mim_clause">
        <xsl:call-template name="express_clause_present">
          <xsl:with-param name="clause" select="'subtype.constraint'"/>
          <xsl:with-param name="schema_name" select="$mim_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$subtype_constraint_mim_clause != 0">
        <xsl:variable name="MimSubCnstrMenu" select="concat('MimSubCnstrMenu',$module_node/@name)"/>
        <xsl:variable name="NoMimSubCnstrMenu" select="concat('NoMimSubCnstrMenu',$module_node/@name)"/>
        
        <!-- MimSubCnstrMenu (OPEN) -->
        <div id="{$MimSubCnstrMenu}" style="display:none">
          <p class="menulist3">
            <a href="javascript:swap({$NoMimSubCnstrMenu}, {$MimSubCnstrMenu});">
              <img src="../../../../images/minus.gif" alt="Close menu" 
                border="false" align="middle"/>    
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#subtype_constraints" target="content">
              <xsl:value-of select="concat($subtype_constraint_mim_clause,
                                    ' MIM subtype constraint definitions')"/>
            </a>
          </p>
          <xsl:apply-templates 
            select="$mim_nodes/express/schema/subtype.constraint"
            mode="module_clause_menu"/>
        </div>        <!-- MimSubCnstrMenu (OPEN) -->
        
        <!-- MimSubCnstrMenu (CLOSED) -->
        <div id="{$NoMimSubCnstrMenu}">
          <p class="menulist3">
            <a href="javascript:swap({$MimSubCnstrMenu},{$NoMimSubCnstrMenu });">
              <img src="../../../../images/plus.gif" alt="Open menu" 
                border="false" align="middle"/> 
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#subtype_constraints" target="content">
              <xsl:value-of select="concat($subtype_constraint_mim_clause,
                                    ' MIM subtype constraint definitions')"/>
            </a>
          </p>
        </div>        <!-- MimSubCnstrMenu (CLOSED) -->
      </xsl:if>
    
      <!-- only output if there are functions defined and therefore a
           section -->
      <xsl:variable name="function_mim_clause">
        <xsl:call-template name="express_clause_present">
          <xsl:with-param name="clause" select="'function'"/>
          <xsl:with-param name="schema_name" select="$mim_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$function_mim_clause != 0">
        <xsl:variable name="MimFunctionMenu" select="concat('MimFunctionMenu',$module_node/@name)"/>
        <xsl:variable name="NoMimFunctionMenu" select="concat('NoMimFunctionMenu',$module_node/@name)"/>
        
        <!-- MimFunctionMenu (OPEN) -->
        <div id="{$MimFunctionMenu}" style="display:none">
          <p class="menulist3">
            <a href="javascript:swap({$NoMimFunctionMenu}, {$MimFunctionMenu});">
              <img src="../../../../images/minus.gif" alt="Close menu" 
                border="false" align="middle"/>    
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#functions" target="content">
              <xsl:value-of select="concat($function_mim_clause,
                                    ' MIM function definitions')"/>
            </a>
          </p>
          <xsl:apply-templates 
            select="$mim_nodes/express/schema/function"
            mode="module_clause_menu"/> 
        </div> <!-- MimFunctionMenu (OPEN) -->

        <!-- MimFunctionMenu (CLOSED) -->
        <div id="{$NoMimFunctionMenu}">
          <p class="menulist3">
            <a href="javascript:swap({$MimFunctionMenu},{$NoMimFunctionMenu });">
              <img src="../../../../images/plus.gif" alt="Open menu" 
                border="false" align="middle"/> 
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#functions" target="content">
              <xsl:value-of select="concat($function_mim_clause,
                                    ' MIM function definitions')"/>
            </a>
          </p>
        </div>        <!-- MimFunctionMenu (CLOSED) -->
      </xsl:if>

      <!-- only output if there are imported functions defined and 
           therefore a section -->
      <xsl:variable name="imported_mim_function_clause">
        <xsl:call-template name="express_clause_present">
          <xsl:with-param name="clause" select="'imported_function'"/>
          <xsl:with-param name="schema_name" select="$mim_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$imported_mim_function_clause != 0">
        <p class="menuitem">
          &#160; &#160; &#160;
          <a href="../sys/5_mim{$FILE_EXT}#imported_function" target="content">
            <xsl:value-of select="concat($imported_mim_function_clause,
                                  ' MIM imported function modifications')"/>
          </a>
        </p>
      </xsl:if>
      
    
      <!-- only output if there are rules defined and therefore a
           section -->
      <xsl:variable name="rule_mim_clause">
        <xsl:call-template name="express_clause_present">
          <xsl:with-param name="clause" select="'rule'"/>
          <xsl:with-param name="schema_name" select="$mim_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$rule_mim_clause != 0">
        <xsl:variable name="MimRuleMenu" select="concat('MimRuleMenu',$module_node/@name)"/>
        <xsl:variable name="NoMimRuleMenu" select="concat('NoMimRuleMenu',$module_node/@name)"/>
        
        <!-- MimRuleMenu (OPEN) -->
        <div id="{$MimRuleMenu}" style="display:none">
          <p class="menulist3">
            <a href="javascript:swap({$NoMimRuleMenu}, {$MimRuleMenu});">
              <img src="../../../../images/minus.gif" alt="Close menu" 
                border="false" align="middle"/>    
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#rules" target="content">
              <xsl:value-of select="concat($rule_mim_clause,
                                    ' MIM rule definitions')"/>
            </a>
          </p>
          <xsl:apply-templates 
            select="$mim_nodes/express/schema/rule"
            mode="module_clause_menu"/> 
        </div>        <!-- MimRuleMenu (OPEN) -->
        
        <!-- MimRuleMenu (CLOSED) -->
        <div id="{$NoMimRuleMenu}">
          <p class="menulist3">
            <a href="javascript:swap({$MimRuleMenu},{$NoMimRuleMenu });">
              <img src="../../../../images/plus.gif" alt="Open menu" 
                border="false" align="middle"/> 
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#rules" target="content">
              <xsl:value-of select="concat($rule_mim_clause,
                                    ' MIM rule definitions')"/>
            </a>
          </p>
        </div>        <!-- MimRuleMenu (CLOSED) -->

      </xsl:if>
      <!-- only output if there are imported rules defined and 
           therefore a section -->
      <xsl:variable name="imported_mim_rule_clause">
        <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'imported_rule'"/>
        <xsl:with-param name="schema_name" select="$mim_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$imported_mim_rule_clause != 0">
      <p class="menuitem3">
        <a href="../sys/5_mim{$FILE_EXT}#imported_rule" target="content">
          <xsl:value-of select="concat($imported_mim_rule_clause,
                                ' MIM imported rule modifications')"/>
        </a>
      </p>
    </xsl:if>
    
    <!-- only output if there are procedures defined and therefore a
         section -->
    <xsl:variable name="procedure_mim_clause">
      <xsl:call-template name="express_clause_present">
        <xsl:with-param name="clause" select="'procedure'"/>
        <xsl:with-param name="schema_name" select="$mim_schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$procedure_mim_clause != 0">
        <xsl:variable name="MimConstantMenu" select="concat('MimConstantMenu',$module_node/@name)"/>
        <xsl:variable name="NoMimConstantMenu" select="concat('NoMimConstantMenu',$module_node/@name)"/>
        
        <!-- MimConstantMenu (OPEN) -->
        <div id="{$MimConstantMenu}" style="display:none">
          <p class="menulist3">
            <a href="javascript:swap({$NoMimConstantMenu}, {$MimConstantMenu});">
              <img src="../../../../images/minus.gif" alt="Close menu" 
                border="false" align="middle"/>    
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#procedures" target="content">
              <xsl:value-of select="concat($procedure_mim_clause,
                                    ' MIM procedure definitions')"/>
            </a>
          </p>
        </div>        <!-- MimConstantMenu (OPEN) -->
        
        <!-- MimConstantMenu (CLOSED) -->
        <div id="{$NoMimConstantMenu}">
          <p class="menulist3">
            <a href="javascript:swap({$MimConstantMenu},{$NoMimConstantMenu });">
              <img src="../../../../images/plus.gif" alt="Open menu" 
                border="false" align="middle"/> 
            </a>
            <a href="../sys/5_mim{$FILE_EXT}#procedures" target="content">
              <xsl:value-of select="concat($procedure_mim_clause,
                                    ' MIM procedure definitions')"/>
            </a>
          </p>
        </div>        <!-- MimConstantMenu (CLOSED) -->
      </xsl:if>          
      <!-- only output if there are imported procedures defined and 
           therefore a section -->
      <xsl:variable name="imported_mim_procedure_clause">
        <xsl:call-template name="express_clause_present">
          <xsl:with-param name="clause" select="'imported_procedure'"/>
          <xsl:with-param name="schema_name" select="$mim_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$imported_mim_procedure_clause != 0">
        <p class="menuitem3">
          <a href="../sys/5_mim{$FILE_EXT}#imported_procedure" target="content">
            <xsl:value-of select="concat($imported_mim_procedure_clause,
                                  ' MIM imported procedure modifications')"/>
          </a>
        </p>
      </xsl:if>
    </div> <!-- MimMenu (OPEN) -->

    <!-- MimMenu (CLOSED) -->
    <div id="{$NoMimMenu}">
      <p class="menulist2">
        <a href="javascript:swap({$MimMenu}, {$NoMimMenu});">
          <img src="../../../../images/plus.gif" alt="Open menu" 
            border="false" align="middle"/> 
        </a>
        <a href="../sys/5_mim{$FILE_EXT}#mim_express" target="content">5.2 MIM EXPRESS short listing</a>
      </p>
    </div> <!-- MimMenu (CLOSED) -->
    
  </div>  <!-- Mim5Menu (CLOSED) -->
  
  <!-- Mim5Menu (CLOSED) -->
  <div id="{$NoMim5Menu}">
    <p class="menulist1">
      <a href="javascript:swap({$Mim5Menu}, {$NoMim5Menu});">
        <img src="../../../../images/plus.gif" alt="Open menu" 
          border="false" align="middle"/> 
      </a>
      <a href="../sys/5_main{$FILE_EXT}" target="content">5 Module interpreted model</a>
    </p>
  </div> <!-- Mim5Menu (CLOSED) -->
  
  
  <!-- use #annexa to link direct -->
  <p class="menuitem1">
    <a href="../sys/a_short_names{$FILE_EXT}" target="content">A AM MIM
    short names</a>
  </p>
  <!-- use #annexb to link direct -->
  <p class="menuitem1">
    <a href="../sys/b_obj_reg{$FILE_EXT}" target="content">B Information requirements object
    registration</a>
  </p>
  
  <!-- use #annexc to link direct -->
  <p class="menuitem1">
    <a href="../sys/c_arm_expg{$FILE_EXT}" target="content">C ARM EXPRESS-G</a>
  </p>
  
  <!-- use #annexd to link direct -->
  <p class="menuitem1">
    <a href="../sys/d_mim_expg{$FILE_EXT}" target="content">D MIM EXPRESS-G</a>
  </p>
  
  <!-- use #annexe to link direct -->
  <p class="menuitem1">
    <a href="../sys/e_exp{$FILE_EXT}" target="content">E AM ARM and MIM EXPRESS
    listings</a>
  </p>
  <xsl:if test="./usage_guide">
    <!-- use #annexa to link direct -->
    <xsl:choose>
      <xsl:when test="./usage_guide/guide_subclause">
        <!-- only add expanding menu if there are sub clauses -->

        <xsl:variable name="UGMenu" select="concat('UGMenu',$module_node/@name)"/>
        <xsl:variable name="NoUGMenu" select="concat('NoUGMenu',$module_node/@name)"/>
        
        <!-- UGMenu (OPEN) -->
        <div id="{$UGMenu}" style="display:none">
          <p class="menulist1">
            <a href="javascript:swap({$NoUGMenu}, {$UGMenu});">
              <img src="../../../../images/minus.gif" alt="Close menu" 
                border="false" align="middle"/>    
            </a>
            <a href="../sys/f_guide{$FILE_EXT}" target="content">
              F Application module implementation and usage guide
            </a>
          </p>
          <xsl:apply-templates 
            select="./usage_guide/guide_subclause"
            mode="module_clause_menu"/>
        </div> <!-- UGMenu (OPEN) -->

        <!-- UGMenu (CLOSED) -->
        <div id="{$NoUGMenu}">
          <p class="menulist1">
            <a href="javascript:swap({$UGMenu},{$NoUGMenu });">
              <img src="../../../../images/plus.gif" alt="Open menu" 
                border="false" align="middle"/> 
            </a>
          </p>
          <p class="menuitem1">
            <a href="../sys/f_guide{$FILE_EXT}" target="content">
              F Application module implementation and usage guide
            </a>
          </p>    
        </div>        <!-- UGMenu (CLOSED) -->

      </xsl:when>
      <xsl:otherwise>
        <p class="menuitem1">
          <a href="../sys/f_guide{$FILE_EXT}" target="content">
            F Application module implementation and usage guide
          </a>
        </p>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <p class="menuitem1">
    <a href="../sys/biblio{$FILE_EXT}#bibliography" target="content">Bibliography</a>
  </p>
  
</xsl:template>


<xsl:template match="constant|type|entity|subtype.constraint|rule|procedure|function" 
  mode="module_clause_menu">
  <xsl:variable name="node_type" select="name(.)"/>
  <xsl:variable name="schema_name" select="../@name"/>
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="$node_type"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    

  <xsl:variable name="xref">
    <xsl:choose>
      <xsl:when test="substring($schema_name, string-length($schema_name)-3)= '_arm'">
        <xsl:value-of select="concat('../sys/4_info_reqs',$FILE_EXT,'#',$aname)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../sys/5_mim',$FILE_EXT,'#',$aname)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="menuclass">
    <xsl:choose>
      <xsl:when test="substring($schema_name, string-length($schema_name)-3)= '_arm'">
        <xsl:value-of select="'menuitem3'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'menuitem4'"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:variable>
  
  <p class="{$menuclass}">
    <a href="{$xref}" target="content">
      <xsl:value-of select="concat($clause_number, '.', position(), ' ', @name)"/>
    </a>
  </p>
</xsl:template>


<xsl:template match="ae" mode="toc">
  <xsl:variable name="ae_aname" select="@entity"/>

  <xsl:variable name="ae_map_aname">
    <xsl:apply-templates select="." mode="map_attr_aname"/>  
  </xsl:variable>

  <xsl:variable 
    name="ae_xref"
    select="concat('../sys/5_mapping',$FILE_EXT,'#',$ae_map_aname)"/>

  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>

  <p class="menuitem3">
    <a href="{$ae_xref}" target="content">
      <xsl:value-of
        select="concat('5.1.',$sect_no,' ',$ae_aname)"/>
    </a>
  </p>

  <!-- no need to go to this depth - there is a bug in the link with
       inherited attributes as well 
  <xsl:apply-templates select="aa" mode="toc">
    <xsl:with-param name="sect" select="concat('5.1.',$sect_no)"/>
  </xsl:apply-templates>
  -->
</xsl:template>


<xsl:template match="guide_subclause" mode="module_clause_menu">
  <p class="menuitem1">
    <xsl:variable name="xref">
      <xsl:value-of select="concat('../sys/f_guide',$FILE_EXT,'#',@title)"/>
    </xsl:variable>
    <A HREF="{$xref}" target="content">
      <xsl:value-of select="concat('F.', position(), ' ', @title)"/>
    </A>
  </p>
</xsl:template>




<xsl:template name="modules_used">
  <xsl:param name="schemas"/>
  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable name="schemas-node-set" select="msxsl:node-set($schemas)"/>
      <xsl:for-each select="$schemas-node-set//x">
        <xsl:sort select="."/>
        <xsl:variable name="href" select="concat('../../',.,'/sys/introduction',$FILE_EXT)"/>
        <p class="menuitem1">
          <a href="{$href}" target="content">
            <xsl:value-of select="."/>
          </a>
        </p>
      </xsl:for-each> 
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="arm_objects">
  NOT YET IMPLEMENTED
</xsl:template>

<xsl:template name="mim_objects">
  NOT YET IMPLEMENTED
</xsl:template>


<xsl:template match="interface" mode="interface-schemas">
  <xsl:param name="done"/>
  <xsl:if test="not(contains($done,@schema))">
    <xsl:value-of select="concat(' ',@schema,' ')"/> 
  </xsl:if>
</xsl:template>

<xsl:template name="depends-on-recurse-no-list-x">
  <xsl:param name="todo" select="' '"/>
  <xsl:param name="done"/>
  <xsl:param name="arm_or_mim"/>
  <xsl:param name="arm_or_mim_file"/>
  <!--
       For each interfaced schema:
       Check if not already done
       Otherwise output and add to todo
       -->
  
  <xsl:variable name="this-schema" select="substring-before(concat(normalize-space($todo),' '),' ')"/>
  
  <xsl:if test="$this-schema">
    
    <xsl:if test="not(contains($done,$this-schema))">
      <xsl:variable name="mod" 
        select="substring-before(translate($this-schema,$UPPER,$LOWER),$arm_or_mim)"/>
      <!-- notes:
           msxml needs addresses relative to the original xml file
           saxon needs addresses relative to the xsl file.
           msxml Only seems to pick up on first file - treating parameter to document() differently from saxon.
           -->
      
      <xsl:variable name="dir" >
        <xsl:choose>
          <xsl:when test="function-available('exslt:node-set')">../../</xsl:when>
          <xsl:otherwise>../../../../</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:message>
        <xsl:value-of select="$this-schema"/>
      </xsl:message>

      <xsl:if test="not(contains($this-schema,'_schema') or starts-with($this-schema,'aic_'))">
        <x>
          <xsl:value-of select="$mod"/>
        </x>
      </xsl:if>
    </xsl:if>
    
    <!-- open up the relevant schema -->
    <xsl:choose>
      <xsl:when test="not(contains($this-schema,'_schema') or starts-with($this-schema,'aic_'))">
        <!-- only proceed if dealing with a module -->
        <xsl:variable name="express_file" 
          select="concat('../../data/modules/',
                  translate(substring-before($this-schema,$arm_or_mim),$UPPER,$LOWER),'/',$arm_or_mim_file)"/>
        
        <xsl:variable name="express-node" select="document($express_file)/express"/>
        
        <!-- get the list of schemas for this level that have not already been done -->
        
        <xsl:variable name="my-kids">          
          <xsl:apply-templates select="$express-node//interface" mode="interface-schemas" >
            <xsl:with-param name="done" select="$done"/>
          </xsl:apply-templates>          
        </xsl:variable>
        <xsl:variable name="after" select="normalize-space(concat(substring-after($todo, $this-schema),$my-kids))"/>
        <xsl:if test="$after" >
          <xsl:call-template name="depends-on-recurse-no-list-x">
            <xsl:with-param name="todo" select="$after"/>
            <xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')"/>
            <xsl:with-param name="arm_or_mim" select="$arm_or_mim"/>
            <xsl:with-param name="arm_or_mim_file" select="$arm_or_mim_file"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="after" select="normalize-space(substring-after($todo, $this-schema))"/>
        <xsl:if test="$after" >
          <xsl:call-template name="depends-on-recurse-no-list-x">
            <xsl:with-param name="todo" select="$after"/>
            <xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')"/>
            <xsl:with-param name="arm_or_mim" select="$arm_or_mim"/>
            <xsl:with-param name="arm_or_mim_file" select="$arm_or_mim_file"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:if>
  
</xsl:template>


</xsl:stylesheet>