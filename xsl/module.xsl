<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: module.xsl,v 1.233 2016/05/03 16:59:14 mikeward Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"                
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="msxsl exslt"
                version="1.0">

  <xsl:import href="module_toc.xsl"/>

  <xsl:import href="sect_4_express.xsl"/>

  <xsl:import href="projmg/issues.xsl"/> 

  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />
<xsl:template match="/">
  <HTML>
    <HEAD>
      <!-- apply a cascading stylesheet.
           the stylesheet will only be applied if the parameter output_css
           is set in parameter.xsl 
           -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="path" select="'../../../css/'"/>
      </xsl:call-template>
      <TITLE>
        <!-- output the module page title -->
        <xsl:apply-templates select="./module" mode="title"/>
      </TITLE>
    </HEAD>
    <xsl:element name="body">
      <xsl:if test="$output_background='YES'">
        <xsl:attribute name="background">
          <xsl:value-of select="concat('../../../../images/',$background_image)"/>
        </xsl:attribute>
        <!-- can only use this for Internet explorer, so not valid HTML
        <xsl:attribute name="bgproperties" >
          <xsl:value-of select="'fixed'" />
          </xsl:attribute> -->
        </xsl:if>
        
        <xsl:apply-templates select="./module" mode="TOCsinglePage"/>
        <xsl:apply-templates select="./module" />
        </xsl:element>
      </HTML>
    </xsl:template>

<xsl:template match="module">
  <xsl:apply-templates select="." mode="coverpage"/>
  <xsl:apply-templates select="." mode="foreword"/>
  <xsl:apply-templates/>
</xsl:template>


<!-- test the WG number. 
     return a string containing Error if incorrect
     
     -->
<xsl:template name="test_wg_number">
  <xsl:param name="wgnumber"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="ERR" select="'**************************'"/>

  <xsl:variable name="wgnumber_check"
    select="translate(translate($wgnumber,$LOWER,$UPPER),$UPPER,$ERR)"/>

  <xsl:choose>
    <xsl:when test="not($wgnumber) or normalize-space($wgnumber) = ''">
      Error WG-1: No WG number provided.
    </xsl:when>

    <xsl:when test="contains($wgnumber_check,'*')">
      Error WG-3: WG number must be an integer.
    </xsl:when>
    
    <xsl:when test="$wgnumber = 0">
      <!-- the default provided by mkmodule -->
      Error WG-2: No WG number provided (0 is invalid).
    </xsl:when>
   
    <xsl:otherwise>
      'OK'
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Outputs the cover page -->
<xsl:template match="module" mode="coverpage">

  <!-- output any issues -->
  <xsl:apply-templates select="." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'general'"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'keywords'"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'contacts'"/>
  </xsl:apply-templates>

  <xsl:variable name="wg_group">
    <xsl:call-template name="get_module_wg_group"/>
  </xsl:variable>

  <xsl:call-template name="test_module_wg_group">
    <xsl:with-param name="module" select="."/>
  </xsl:call-template>

  <xsl:variable name="n_number"
	  select="concat('ISO/TC&#160;184/SC&#160;4/WG&#160;',$wg_group,'&#160;N',./@wg.number)"/>
  <xsl:variable name="date">
    <xsl:choose>
      <xsl:when test="string-length($coverpage_date)>0 and $output_background='NO'">
        <xsl:value-of select="concat(substring($coverpage_date,1,4),'-',substring($coverpage_date,5,2),'-',substring($coverpage_date,7,2) )"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="translate(
          substring-before(substring-after(@rcs.date,'$Date: '),' '),
          '/','-')"/>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <table width="624">
    <tr>
      <td><h2><xsl:value-of select="$n_number"/></h2></td>
      <td>&#x20;</td>
      <td valign="top" width="200"><b>Date:&#x20;</b><xsl:value-of select="$date"/></td>
    </tr>    

    <xsl:variable name="test_wg_number">
      <xsl:call-template name="test_wg_number">
        <xsl:with-param name="wgnumber" select="./@wg.number"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="contains($test_wg_number,'Error')">
      <tr>
        <td>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error in
                              module.xml/module/@wg.number - ',
                              $test_wg_number)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:if>

    <xsl:if test="@wg.number.supersedes">      
      <tr>
        <td>
          <h3>              
          Supersedes 
            <xsl:choose>
              <xsl:when test="contains(@wg.number.supersedes, 'ISO')">
                <xsl:value-of select="@wg.number.supersedes"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of 
			select="concat('ISO/TC&#160;184/SC&#160;4/WG&#160;',$wg_group,'&#160;N',@wg.number.supersedes)"/>
              </xsl:otherwise>
            </xsl:choose>
          </h3>

          <xsl:variable name="test_wg_number_supersedes">
	    <xsl:if test="not(contains(./@wg.number.supersedes,'ISO'))">
            <xsl:call-template name="test_wg_number">
              <xsl:with-param name="wgnumber" select="./@wg.number.supersedes"/>
            </xsl:call-template>
	    </xsl:if>
          </xsl:variable>
          <xsl:if test="contains($test_wg_number_supersedes,'Error')">
            <tr>
              <td>
                <xsl:call-template name="error_message">
                  <xsl:with-param name="message">
                    <xsl:value-of 
                      select="concat('Error in
                              module.xml/module/@wg.number.supersedes - ',
                              $test_wg_number_supersedes)"/>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:if>

          <xsl:if test="@wg.number.supersedes = @wg.number">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message">
                Error in module.xml/module/@wg.number.supersedes - 
                Error WG-16: New WG number is the same as superseded WG number.
              </xsl:with-param>
            </xsl:call-template>            
          </xsl:if>
        </td>
      </tr>
    </xsl:if>
  </table>

  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="./@name"/>
    </xsl:call-template>           
  </xsl:variable>
    
  <xsl:variable name="stdnumber">
    <xsl:call-template name="get_module_pageheader">
      <xsl:with-param name="module" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <h4>
    <xsl:value-of select="$stdnumber"/><br/>
    Product data representation and exchange: Application module: 
    <xsl:value-of select="$module_name"/>
  </h4>
  
  
  <xsl:variable name="status" select="string(@status)"/>
  <xsl:variable name="status_words">
    <xsl:choose>
      <xsl:when test="@status='CD'">
        Committee Draft
      </xsl:when>
      <xsl:when test="@status='FDIS'">
        Final Draft International Standard
      </xsl:when>
      <xsl:when test="@status='DIS'">
        Draft International Standard
      </xsl:when>
      <xsl:when test="@status='IS'">
        International Standard
      </xsl:when>
      <xsl:when test="@status='CD-TS'">
        draft technical specification 
      </xsl:when>
      <xsl:when test="@status='TS'">
        technical specification 
      </xsl:when>
      <xsl:when test="@status='WD'">
        working draft 
      </xsl:when>
      <xsl:otherwise>
        module status not set.
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <table border="1" cellspacing="1" cellpadding="8" width="624">
    <tr>
      <td valign="TOP" colspan="2" height="26">
        <a name="copyright"/>
        <h3>COPYRIGHT NOTICE:</h3>

        <xsl:choose>
          <xsl:when test="$status='CD'">
            Committee Draft
          </xsl:when>
          <xsl:when test="$status='FDIS'">
            Final Draft International Standard
          </xsl:when>
          <xsl:when test="$status='DIS'">
            Draft International Standard
          </xsl:when>
          <xsl:when test="$status='IS'">
            International Standard
          </xsl:when>

          <xsl:when test="$status='CD-TS'">
            <p>
              This ISO document is a Committee Draft Technical
              Specification and is copyright protected by ISO. While the
              reproduction of working drafts or Committee Drafts in any
              form for use by Participants in the ISO standards development
              process is permitted without prior written permission from
              ISO, neither this document nor any extract from it may be 
              reproduced, stored or transmitted in any form for any other
              purpose without prior written permission from ISO. 
            </p>
            <p>
              Requests for permission to reproduce this document for the
              purposes of selling it should be addressed as shown below
              (via the ISO TC 184/SC4 Secretariat's member body) or to the
              ISO's member body in the country of the requestor 
            </p>
            <div align="center">
                Copyright Manager<br/>
                ANSI<br/>
                11 West 42nd Street<br/>
                New York, New York 10036<br/>
                USA<br/>
                phone:             +1-212-642-4900      <br/>
                fax: +1-212-398-0023<br/>
            </div>
            <p>
              Reproduction for sales purposes may be subject to royalty
              payments or a licensing agreement. 
            </p>
            <p>
              Violators may be prosecuted.
            </p>
          </xsl:when>


          <xsl:when test="$status='TS'">
            <p>
              This document is a Technical Specification and is
              copyright-protected by ISO. Except as permitted under the
              applicable laws of the user's country, neither this ISO
              document nor any extract from it may be reproduced, stored in
              a retrieval system or transmitted in any form or by 
              any means, electronic, photocopying, recording, or otherwise,
              without prior written permission being secured.  
            </p>
            <p>
              Requests for permission to reproduce should be addressed to
              ISO at the address below or ISO's member body in the 
              country of the requester:
            </p>

            <div align="center">
              <!--
              Copyright Manager, ISO Central Secretariat<br/>
              1 rue de Varembe<br/>
              CH-1211 Geneva 20 Switzerland<br/>
              telephone: +41 22 749 0111<br/>
              telefacsimile: +41 22 734 0179<br/>
              Internet: central@isocs.iso.ch, X.400: c=ch; a=400net; p=iso;
o=isocs; s=central<br/>
-->
              ISO copyright office<br/>
              Case postale 56, CH-1211 Geneva 20<br/>
              Tel.             +41 22 749 01 11      <br/>
              Fax +41-22-734-10 79<br/>
              E-mail copyright@iso.ch<br/>
             </div>
 
            <p>
              Reproduction for sales purposes may be subject to
              royalty payments or a licensing agreement.
            </p>
            <p>
              Violators may be prosecuted.
            </p>
          </xsl:when>

          <xsl:when test="$status='WD'">
            working draft 
          </xsl:when>
          <xsl:otherwise>
            module status not set.
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
    <tr>
    <td valign="TOP" colspan="2" height="88">
      <h3>ABSTRACT:</h3>
      <xsl:apply-templates select="." mode="abstract"/>
      <h3>
        <a name="keywords">
          KEYWORDS:
        </a>
      </h3>
      <xsl:apply-templates select="./keywords"/>

      <!-- check that valid keywords provided -->
      <xsl:variable name="keywords" select="normalize-space(translate(./keywords,',&#x9;&#xA;&#x20;&#xD;',''))"/>
      <xsl:if test="$keywords = 'module' or string-length($keywords)=0">
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            Error K-1: Error in module.xml/keywords - no keywords specified.
          </xsl:with-param>
        </xsl:call-template>            
      </xsl:if>
      
      <h3>COMMENTS TO READER:</h3>
      <xsl:apply-templates select="." mode="comments_to_reader"/>
    </td>
  </tr>
 
  <tr>
    <td width="50%" valign="TOP" height="88">
      <a name="contacts"/>
      <xsl:apply-templates select="./contacts/projlead"/>
    </td>
    <td width="50%" valign="TOP" height="88">
      <xsl:apply-templates select="./contacts/editor"/>
    </td>
  </tr>
  </table>
</xsl:template>

<!-- Outputs the comments to reader -->
<xsl:template match="module" mode="comments_to_reader">
  <xsl:variable name="status" select="string(@status)"/>
  <xsl:variable name="wg_group">
    <xsl:call-template name="get_module_wg_group"/>
  </xsl:variable>


  <xsl:variable name="ballot_cycle_or_pub">
    <xsl:choose>
      <xsl:when test="$status='CD-TS'">
        this ballot cycle
      </xsl:when>
      <xsl:when test="$status='TS'">
        publication
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
      
  <xsl:if test="$status='CD-TS'">
    <p>
      Recipients of this draft are invited to submit, with their comments,
      notification of any relevant patent rights of which they are aware and to
      provide supporting documentation.
    </p>
  </xsl:if>

      <xsl:apply-templates select="comments_to_reader" />
<!--	<p>
        The project issues raised against the individual modules are stored on
        <a href="http://locke.dcnicn.com/bugzilla/iso10303/">http://locke.dcnicn.com/bugzilla/iso10303/</a>.
      </p>
TT remove since locke is no longer available.
-->
      <xsl:variable name="dvlp_fldr" select="@development.folder"/>
      <xsl:if test="string-length($dvlp_fldr)>0">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="@name"/>
          </xsl:call-template>
        </xsl:variable>        
        <xsl:variable name="seds" 
          select="document(concat($module_dir,'/dvlp/issues.xml'))/issues/issue[@seds='yes' and @status='closed']"/>
        <xsl:if test="count($seds)>0">
          <p>
            <xsl:variable name="seds_list">
              <xsl:apply-templates select="$seds" mode="seds_cover"/>
            </xsl:variable>
            <xsl:variable name="nseds_list">
              <xsl:call-template name="remove_duplicates">
                <xsl:with-param name="list" select="$seds_list"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="seds_comma_list">
              <xsl:call-template name="output_comma_separated_list">
                <xsl:with-param name="string" select="$nseds_list"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:choose>
              <xsl:when test="contains($seds_comma_list,',')">
                The following SEDS have been addressed by this edition:
              </xsl:when>
              <xsl:otherwise>
                The following SEDS has been addressed by this edition:              
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="normalize-space($seds_comma_list)"/>.
          </p>
        </xsl:if>
      </xsl:if>
</xsl:template>

<xsl:template match="issue" mode="seds_cover">
  <xsl:value-of select="concat(@id,' ')"/>
</xsl:template>

<xsl:template match="issue" mode="seds_coverx">
  <xsl:choose>
    <xsl:when test="position()= last()">
      <xsl:value-of select="concat(@id,'.')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@id,', ')"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template match="module" mode="abstract">
  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="./@name"/>
    </xsl:call-template>           
  </xsl:variable>

  <!-- replaced by below  
  <P>
    This document is the
    <xsl:value-of select="$status_words"/>
    of the application module for 
    <xsl:value-of select="$module_name"/>.
  </P>
  -->
  <P>
    <xsl:call-template name="get_module_stdnumber">
      <xsl:with-param name="module" select="."/>
    </xsl:call-template> specifies the application module for
    <xsl:value-of select="$module_name"/>.       
  </P>

  <xsl:choose>
    <xsl:when test="./abstract">
      <xsl:choose>
        <xsl:when  test="./abstract/li">
          <xsl:choose>
            <xsl:when  test="count(./abstract/li)=1">
              <P>
                The following is within the scope of 
                <xsl:call-template name="get_module_stdnumber">
                  <xsl:with-param name="module" select="."/>
                </xsl:call-template>:
              </P>
            </xsl:when>
            <xsl:otherwise>
              <P>
                The following are within the scope of 
                <xsl:call-template name="get_module_stdnumber">
                  <xsl:with-param name="module" select="."/>
                </xsl:call-template>:
              </P>
            </xsl:otherwise>
          </xsl:choose>
          <ul>
            <xsl:apply-templates select="./abstract/*"/>
          </ul>          
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="./abstract/*"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <P>
        The following are within the scope of 
        <xsl:call-template name="get_module_stdnumber">
          <xsl:with-param name="module" select="."/>
        </xsl:call-template>:
      </P>
      <UL>
        <xsl:apply-templates select="./inscope/li"/>
      </UL>
    </xsl:otherwise>
  </xsl:choose>
      
</xsl:template>

<!--
<xsl:template match="abstract">
  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="/module/@name"/>
    </xsl:call-template>           
  </xsl:variable>

  <P>
    This part of ISO 10303 specifies the application module for 
    <xsl:value-of select="$module_name"/>.
  </P>
  <P>
    The following are within the scope of this part of ISO 10303:
  </P>
  <UL>
    <xsl:apply-templates select="./li"/>
  </UL>  
</xsl:template> -->


<xsl:template match="keywords">
  <xsl:if test="contains(.,'STEP')">
    <xsl:call-template name="error_message">
      <xsl:with-param name="inline" select="'yes'"/>
      <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
      <xsl:with-param 
        name="message" 
        select="'Error key1: Do not include STEP as a keyword.'"/>
    </xsl:call-template>    
  </xsl:if>    

  <xsl:if test="contains(.,'10303')">
    <xsl:call-template name="error_message">
      <xsl:with-param name="inline" select="'yes'"/>
      <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
      <xsl:with-param 
        name="message" 
          select="'Error key1: Do not include ISO 103030 as a keyword.'"/>
    </xsl:call-template>    
  </xsl:if>

  <xsl:variable name="keywords1">
    <xsl:if test="not(contains(.,'module'))">
      module, 
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="keywords2">
    <xsl:value-of select="."/>
  </xsl:variable>

  <xsl:value-of select="normalize-space(concat($keywords1, $keywords2))"/>
</xsl:template>


  <!-- Outputs the a sentnce about the edition -->
  <xsl:template match="module" mode="edition_sentence">    
    <xsl:variable name="part_no">
      <xsl:choose>
        <xsl:when test="string-length(@part)>0">
          <xsl:value-of select="concat('ISO/TS 10303-',@part)"/>
        </xsl:when>
        <xsl:otherwise>
          ISO/TS 10303-XXXX
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p>
      <xsl:variable name="this_edition">
        <xsl:choose>
          <xsl:when test="@version='2'">
            second
          </xsl:when>
          <xsl:when test="@version='3'">
            third
          </xsl:when>
          <xsl:when test="@version='4'">
            fourth
          </xsl:when>
          <xsl:when test="@version='5'">
            fifth
          </xsl:when>
          <xsl:when test="@version='6'">
            sixth
          </xsl:when>
          <xsl:when test="@version='7'">
            seventh
          </xsl:when>
          <xsl:when test="@version='8'">
            eighth
          </xsl:when>
          <xsl:when test="@version='9'">
            ninth
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="prev_edition">
        <xsl:choose>
          <xsl:when test="@version='2'">
            first
          </xsl:when>
          <xsl:when test="@version='3'">
            second
          </xsl:when>
          <xsl:when test="@version='4'">
            third
          </xsl:when>
          <xsl:when test="@version='5'">
            fourth
          </xsl:when>
          <xsl:when test="@version='6'">
            fifth
          </xsl:when>
          <xsl:when test="@version='7'">
            sixth
          </xsl:when>
          <xsl:when test="@version='8'">
            seventh
          </xsl:when>
          <xsl:when test="@version='9'">
            eighth
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:if test="@version != 1">
        <xsl:if test="string-length(normalize-space(@previous.revision.year)) = 0">
          <xsl:call-template name="error_message">
            <xsl:with-param name="inline" select="'yes'"/>
            <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
            <xsl:with-param name="message"
              select="concat('Error F1 module: ',/module/@name,' Attribute module.previous.revision.year not specified')"/>
          </xsl:call-template>   
        </xsl:if>      
      </xsl:if>
      
      <xsl:choose>
        <xsl:when test="@previous.revision.cancelled='NO'">
          This <xsl:value-of select="$this_edition"/> edition of  
          <xsl:value-of select="$part_no"/> 
          cancels and replaces the
          <xsl:value-of select="$prev_edition"/> edition  
          (<xsl:value-of
            select="concat($part_no,':',@previous.revision.year)"/>),
          of which it constitutes a technical revision. 
          
          
          <!-- No longer use @revision.complete
           <xsl:choose>
            <!-\- only changed a section of the document -\->
            <xsl:when test="@revision.complete='NO'">
              <xsl:value-of select="@revision.scope"/>
              of the <xsl:value-of select="$prev_edition"/> 
              edition  
              <xsl:choose>
                <!-\- will be Clauses/Figures/ etc so if contains 'es' 
                  then must be plural-\->
                <xsl:when test="contains(@revision.scope,'es')">
                  have
                </xsl:when>
                <xsl:otherwise>
                  has
                </xsl:otherwise>
              </xsl:choose>
              been technically revised.
            </xsl:when>
            <xsl:otherwise>
              <!-\- complete revision so no extra text -\->
            </xsl:otherwise>
          </xsl:choose>-->
          
        </xsl:when>
        
        <xsl:otherwise>
          <!-- cancelled -->
          This <xsl:value-of select="$this_edition"/> edition of 
          <xsl:value-of select="$part_no"/> cancels and replaces the
          <xsl:value-of select="$prev_edition"/> edition
          (<xsl:value-of
            select="concat($part_no,':',@previous.revision.year)"/>), 
          
          <xsl:choose>
            <!-- only changed a section of the document -->
            <xsl:when test="@revision.complete='NO'">
              of which 
              <xsl:value-of select="@revision.scope"/>
              <xsl:choose>
                <!-- will be Clauses/Figures/ etc so if contains 'es' 
                  then must be plural-->
                <xsl:when test="contains(@revision.scope,'es')">
                  have
                </xsl:when>
                <xsl:otherwise>
                  has
                </xsl:otherwise>
              </xsl:choose>
              been technically revised.
            </xsl:when>
            <xsl:otherwise>
              of which it constitutes a technical revision.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="./changes">
        <xsl:variable name="annex_letter">
          <xsl:choose>
            <xsl:when test="./changes and ./usage_guide">G</xsl:when>
            <xsl:when test="./changes">F</xsl:when>
          </xsl:choose>
        </xsl:variable> A detailed description of the changes is provided in Annex <a
          href="g_change{$FILE_EXT}">
          <xsl:value-of select="$annex_letter"/>
        </a>. 
      </xsl:if>
    </p>    
  </xsl:template> 

<!-- Outputs the foreword -->
<xsl:template match="module" mode="foreword">
    <xsl:variable name="part_no">
      <xsl:choose>
        <xsl:when test="string-length(@part)>0">
          <xsl:value-of select="concat('ISO/TS 10303-',@part)"/>
        </xsl:when>
        <xsl:otherwise>
          ISO/TS 10303-XXXX
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

  <h2>
    <a name="foreword">
      Foreword
    </a>
  </h2>
  <p>
    ISO (the International Organization for Standardization) is a worldwide
    federation of national standards bodies (ISO member bodies). The work of
    preparing International Standards is normally carried out through ISO
    technical committees. Each member body interested in a subject for which a
    technical committee has been established has the right to be represented on
    that committee. International organizations, governmental and
    non-governmental, in liaison with ISO, also take part in the work. ISO
    collaborates closely with the International Electrotechnical Commission
    (IEC) on all matters of electrotechnical standardization.
  </p>
  <p>
    International Standards are drafted in accordance with the rules given
    in the ISO/IEC Directives, Part 2.
  </p>
  <p>
    The main task of technical committees is to prepare International
    Standards. Draft International Standards adopted by the technical
    committees are circulated to the member bodies for voting. Publication as
    an International Standard requires approval by at least 75 % of the member
    bodies casting a vote. 
  </p>
  <p>
    In other circumstances, particularly when there is an urgent market
    requirement for such documents, a technical committee may decide to publish
    other types of normative document: 
  </p>
  
  <ul>
    <li>
      an ISO Publicly Available Specification (ISO/PAS) represents an
      agreement between technical experts in an ISO working group and is accepted
      for publication if it is approved by more than 50 % of the members of the
      parent committee casting a vote;
    </li>
    <li>
      an ISO Technical Specification (ISO/TS) represents an agreement
      between the members of a technical committee and is accepted for
      publication if it is approved by 2/3 of the members of the committee
      casting a vote.
    </li>
  </ul>
  <!--<p>
    An ISO/PAS or ISO/TS is reviewed after three years in order to decide 
    whether it will be confirmed for a further three years, revised to become
    an International Standard, or withdrawn. If the ISO/PAS or ISO/TS is
    confirmed, it is reviewed again after a further three years, at which time
    it must either be transformed into an International Standard or be
    withdrawn.
  </p>-->
  <p>
    An ISO/PAS or ISO/TS is reviewed after three years in order to decide whether
    it will be confirmed for a further three years, revised to become an
    International Standard, or withdrawn. If the ISO/PAS or ISO/TS is confirmed, it
    is reviewed again after a further three years. At that time, an ISO/PAS must
    either be transformed into an International Standard or be withdrawn; an ISO/TS
    can be transformed into an International Standard or be continued as an
    ISO/TS or be withdrawn.
  </p> <!-- MWD 2017-05-17 -->
  <p>
    Attention is drawn to the possibility that some of the elements of
    this document may be the subject of patent rights. ISO shall not be held
    responsible for identifying any or all such patent rights.
  </p>
  <p>
    <xsl:value-of select="$part_no"/>
    was prepared by Technical Committee ISO/TC 184, 
    <i>Automation systems and integration,</i>
    Subcommittee SC4, <i>Industrial data.</i>
  </p>
  
  <xsl:if test="@version!='1'">
    <xsl:apply-templates select="." mode="edition_sentence"/>  
  </xsl:if>
  
  <p>
    ISO 10303 is organized as a series of parts, each published
    separately. The structure of ISO 10303 is described in ISO 10303-1.
    <sup>
      <a href="#10303-1">1</a>)
    </sup>
  </p>
  <p>
    Each part of ISO 10303 is a member of one of the following series:
    description methods, implementation methods, conformance testing
    methodology and framework, integrated generic resources, integrated
    application resources, application protocols, abstract test suites,
    application interpreted constructs and application modules. This part is a
    member of the application modules series. 
  </p>
  <p>
    A complete list of parts of ISO 10303 is available from the following URL: 
  </p>
<div align="center">
  <blockquote>
    <A HREF="http://standards.iso.org/iso/10303/tech/step_titles.htm" target="_blank">
      http://standards.iso.org/iso/10303/tech/step_titles.htm</A>.
  </blockquote>
</div>
  <p>
    <a name="10303-1">
      <sup>1)</sup>A future edition of ISO 10303-1 will describe the application
      modules series.
    </a>
  </p>
</xsl:template>
<xsl:template match="module" mode="forewordold">
    <xsl:variable name="part_no">
      <xsl:choose>
        <xsl:when test="string-length(@part)>0">
          <xsl:value-of select="concat('ISO/TS 10303-',@part)"/>
        </xsl:when>
        <xsl:otherwise>
          ISO/TS 10303-XXXX
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

  <h2>
    <a name="foreword">
      Foreword
    </a>
  </h2>
  <p>
    ISO (the International Organization for Standardization) is a worldwide
    federation of national standards bodies (ISO member bodies). The work of
    preparing International Standards is normally carried out through ISO
    technical committees. Each member body interested in a subject for which a 
    technical committee has been established has the right to be represented on
    that committee. International organizations, governmental and 
    non-governmental, in liaison with ISO, also take part in the work. ISO 
    collaborates closely with the International Electrotechnical Commission
    (IEC) on all matters of electrotechnical  standardization. 
  </p>
  
  <p>
    International Standards are drafted in accordance with the rules given in
    the ISO/IEC Directives, Part 2.
  </p>
  
  <p>
    The main task of technical committees is to prepare International
    Standards. Draft International Standards adopted by the technical
    committees are circulated to the member bodies for voting. Publication as
    an International Standard requires approval by at least 75% of the member
    bodies casting a vote.
  </p>
  
  <p>
    In other circumstances, particularly when there is an urgent market
    requirement for such documents, a technical committee may decide to
    publish other types of normative document: 
  </p>
  
  <ul>
    <li>
      an ISO Publicly Available Specification (ISO/PAS) represents an
      agreement between technical experts in an ISO working group and  is
      accepted for publication if it is approved by more than 50% 
      of the members of the parent committee casting a vote;
    </li>  
    <li>
      an ISO Technical Specification (ISO/TS) represents an agreement between
      the members of a technical committee and is accepted for
      publication if it is approved by 2/3 of the members of the committee
      casting a vote. 
    </li>
  </ul>
  
  <p>
    An ISO/PAS or ISO/TS is reviewed every three years with a view to
    deciding whether it can be transformed into an International Standard.
  </p>
  
  <p>
    Attention is drawn to the possibility that some of the elements of this
    part of ISO 10303 may be the subject of patent rights. ISO shall not be
    held responsible for identifying any or all such patent rights.
  </p>    
  
  <p>  
    <xsl:value-of select="$part_no"/>
    was prepared by Technical Committee ISO/TC 184, 
    <i>Automation systems and integration,</i>
    Subcommittee SC4, <i>Industrial data.</i>
  </p>

  <xsl:if test="@version!='1'">
    <xsl:variable name="this_edition">
      <xsl:choose>
        <xsl:when test="@version='2'">
          second
        </xsl:when>
        <xsl:when test="@version='3'">
          third
        </xsl:when>
        <xsl:when test="@version='4'">
          fourth
        </xsl:when>
        <xsl:when test="@version='5'">
          fifth
        </xsl:when>
        <xsl:when test="@version='6'">
          sixth
        </xsl:when>
        <xsl:when test="@version='7'">
          seventh
        </xsl:when>
        <xsl:when test="@version='8'">
          eighth
        </xsl:when>
        <xsl:when test="@version='9'">
          ninth
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="prev_edition">
      <xsl:choose>
        <xsl:when test="@version='2'">
          first
        </xsl:when>
        <xsl:when test="@version='3'">
          second
        </xsl:when>
        <xsl:when test="@version='4'">
          third
        </xsl:when>
        <xsl:when test="@version='5'">
          fourth
        </xsl:when>
        <xsl:when test="@version='6'">
          fifth
        </xsl:when>
        <xsl:when test="@version='7'">
          sixth
        </xsl:when>
        <xsl:when test="@version='8'">
          seventh
        </xsl:when>
        <xsl:when test="@version='9'">
          eighth
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@previous.revision.cancelled='NO'">
        This <xsl:value-of select="$this_edition"/> edition of  
        <xsl:value-of select="$part_no"/> 
        cancels and replaces the
        <xsl:value-of select="$prev_edition"/> edition  
        (<xsl:value-of
          select="concat($part_no,':',@previous.revision.year)"/>),
        of which it constitutes a technical revision. 


        <xsl:choose>
          <!-- only changed a section of the document -->
          <xsl:when test="@revision.complete='NO'">
            <xsl:value-of select="@revision.scope"/>
            of the <xsl:value-of select="$prev_edition"/> 
            edition  
            <xsl:choose>
            <!-- will be Clauses/Figures/ etc so if contains 'es' 
                 then must be plural-->
              <xsl:when test="contains(@revision.scope,'es')">
                have
              </xsl:when>
              <xsl:otherwise>
                has
              </xsl:otherwise>
            </xsl:choose>
            been technically revised.
          </xsl:when>
          <xsl:otherwise>
            <!-- complete revision so no extra text -->
          </xsl:otherwise>
        </xsl:choose>

      </xsl:when>

      <xsl:otherwise>
        <!-- cancelled -->
        This <xsl:value-of select="$this_edition"/> edition of 
        <xsl:value-of select="$part_no"/> cancels and replaces the
        <xsl:value-of select="$prev_edition"/> edition
        (<xsl:value-of
          select="concat($part_no,':',@previous.revision.year)"/>), 

        <xsl:choose>
          <!-- only changed a section of the document -->
          <xsl:when test="@revision.complete='NO'">
            of which 
            <xsl:value-of select="@revision.scope"/>
            <xsl:choose>
            <!-- will be Clauses/Figures/ etc so if contains 'es' 
                 then must be plural-->
              <xsl:when test="contains(@revision.scope,'es')">
                have
              </xsl:when>
              <xsl:otherwise>
                has
              </xsl:otherwise>
            </xsl:choose>
            been technically revised.
          </xsl:when>
          <xsl:otherwise>
            of which it constitutes a technical revision.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>




  <p>
    This International Standard is organized as a series of parts, each
    published separately. The structure of this International Standard is
    described in ISO 10303-1
    <sup>
      <a href="#10303-1">1</a>)
    </sup>.
  </p>
  <p>
    Each part of this International Standard is a
    member of one of the following series: description methods, implementation
    methods, conformance testing methodology and framework, integrated generic
    resources, integrated application resources, application protocols,
    abstract test suites, application interpreted constructs, and application
    modules. This part is a member of the application modules series. 
  </p>
  <p>
    A complete list of parts of ISO 10303 is available from the following URL: 
  </p>
  <blockquote>
    &lt;
    <A HREF="http://www.tc184-sc4.org/titles/STEP_Titles.htm" target="_blank">
      http://www.tc184-sc4.org/titles/STEP_Titles.htm
    </A>&gt;.
  </blockquote>


  <p>
    Annexes A and B form an integral part of this part of ISO
    10303. Annexes C, 
    <xsl:choose>
      <xsl:when test="./usage_guide">
        D, E and F
      </xsl:when>
      <xsl:otherwise>
        D and E
      </xsl:otherwise>
    </xsl:choose>
    are for information only.  
  </p> 
  <p>
    <!-- <hr width="100" size="2" align="left"/> -->
    <a name="10303-1">
      <sup>1)</sup>A future edition of ISO 10303-1 will describe the application
      modules series.
    </a>
  </p>

</xsl:template>


<xsl:template match="purpose">
  <h2>
    <a name="introduction">
      Introduction
    </a>
  </h2>

  <xsl:if test="not( string-length(normalize-space(.)) > 85)" >
        <xsl:call-template name="error_message">
	  <xsl:with-param name="inline" select="'yes'"/>
	  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
          <xsl:with-param 
		            name="message" 
		            select="'Error P1: Insufficient introduction material provided.'"/>
        </xsl:call-template>    
  </xsl:if>
  <!-- this ensures that a false error maeesage is NOT generated when the part in question is a resource rather than a module MWD 2016-05-03  -->
  <xsl:choose>
    <xsl:when test="name(..)='resource'">
     <!-- we could add a test here MWD -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="not(substring-after(.,'This part of ISO 10303 specifies'))" >
        <xsl:call-template name="error_message">
	  <xsl:with-param name="inline" select="'yes'"/>
	  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
          <xsl:with-param 
		            name="message" 
		            select="'Error P2: Introduction does not start with required text: This part of ISO 10303 specifies .'"/>
        </xsl:call-template>    
  </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
 
  
  

  <p>
    ISO 10303 is an International Standard for the computer-interpretable 
    representation of product information and for the exchange of product data.
    The objective is to provide a neutral mechanism capable of describing
    products throughout their life cycle. This mechanism is suitable not only
    for neutral file exchange, but also as a basis for implementing and
    sharing product databases, and as a basis 
    for retention and archiving.
  </p>

  <!-- output any issues -->
  <xsl:apply-templates select=".." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'purpose'"/>
  </xsl:apply-templates>
  <xsl:apply-templates/>

  <xsl:if test="../changes">  
    <xsl:variable name="annex_letter">
      <xsl:choose>
        <xsl:when test="../changes and ../usage_guide">
          <xsl:value-of select="concat('G.',../@version)"/>
        </xsl:when>
        <xsl:when test="../changes">
          <xsl:value-of select="concat('F.',../@version)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable> 
    <p>      
      <xsl:variable name="aname" select="concat('change_',../@version)"/>
      This 
      <xsl:call-template name="number_to_word">
        <xsl:with-param name="number" select="../@version"/>
      </xsl:call-template>
      edition of this part of ISO 10303 incorporates the modifications to the 
      <xsl:call-template name="number_to_word">
        <xsl:with-param name="number" select="string(../@version - 1)"/>
      </xsl:call-template>
      edition listed in Annex <a
        href="g_change{$FILE_EXT}#{$aname}">
        <xsl:value-of select="$annex_letter"/>
      </a>. 
    </p>
  </xsl:if>
  <p>
    Clause <a href="1_scope{$FILE_EXT}">1</a> defines the scope of the
    application module and summarizes the functionality and data covered. 

    Clause <a href="3_defs{$FILE_EXT}">3</a> lists the words defined in
    this part of ISO 10303 and gives pointers to words defined elsewhere. 

    The information requirements of the application are specified in Clause 
    <a href="4_info_reqs{$FILE_EXT}">4</a> using terminology appropriate to
    the application. 

    A graphical representation of the information requirements, referred to
    as the application reference model, is given in Annex 
    <a href="c_arm_expg{$FILE_EXT}">C</a>. 

    Resource constructs are interpreted to meet the information
    requirements. 
    This interpretation produces the module interpreted model (MIM). 
    This interpretation, given in <a href="5_mapping{$FILE_EXT}#mapping">5.1</a>,
    shows the correspondence between the information requirements and the
    MIM. The short listing of the MIM specifies the interface to the
    resources and is given in <a href="5_mim{$FILE_EXT}#mim_express">5.2</a>.  

    A graphical representation of the short listing of the MIM is given
    in Annex <a href="d_mim_expg{$FILE_EXT}">D</a>.
  </p>
  <p>
    In ISO 10303, the same English language words can be
    used to refer to an object in the real world or concept, and as the
    name of an EXPRESS data type that represents this object or concept. 
  </p>
  <p>
    The following typographical convention is used to distinguish between
    these. If a word or phrase occurs in the same typeface as narrative
    text, the referent is the object or concept. If the word or phrase
    occurs in a bold typeface or as a hyperlink, the referent is the
    EXPRESS data type. 
  </p>
  <p>
    The name of an EXPRESS data type can be used to refer to the data type
    itself, or to an instance of the data type. The distinction between
    these uses is normally clear from the context. If there is a likelihood
    of ambiguity, either the phrase "entity data type" or "instance(s) of" is
    included in the text. 
  </p>
  <p>
    Double quotation marks " " denote quoted text. Single quotation marks ' '
    denote particular text string values.
  </p>
</xsl:template>

<xsl:template match="inscope">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'1 Scope'"/>
    <xsl:with-param name="aname" select="'scope'"/>
  </xsl:call-template>
  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="../@name"/>
    </xsl:call-template>           
  </xsl:variable>
  <p>
    This part of ISO 10303 specifies the application module
    <xsl:value-of select="$module_name"/>.
    <a name="inscope"/>
    The following are within the scope of this part of ISO 10303: 
  </p>

  <!-- output any issues -->
  <xsl:apply-templates select=".." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'inscope'"/>
  </xsl:apply-templates>

  <ul>
    <xsl:apply-templates select="li"/>
  </ul>
</xsl:template>


<xsl:template match="outscope">
  <p>
    <a name="outscope"/>
    The following are outside the scope of this part of ISO 10303: 
  </p>
  <!-- output any issues -->
  <xsl:apply-templates select=".." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'outscope'"/>
  </xsl:apply-templates>

  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>


<xsl:template match="comments_to_reader">
  <xsl:apply-templates/>
</xsl:template>
<xsl:template match="comment_to_reader">
  <p>
    <xsl:apply-templates/>
  </p>
</xsl:template>



<xsl:template match="module" mode="annexe">
  <xsl:param name="annex_no" select="'E'"/>

  <xsl:variable name="arm">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_arm.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_arm.htm')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="mim">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_mim.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_mim.htm')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="UPPER"
    select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER"
    select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="mim_schema"
    select="translate(concat(@name,'_mim'),$LOWER, $UPPER)"/>
    
  <!--
       It has been decided to point to the index instead
  <xsl:variable name="names_url"
      select="concat('http://www.steptools.com/cgi-bin/getnames.cgi?schema=',
              $mim_schema)"/>
  
  <xsl:variable name="parts_url"
  select="concat('http://www.steptools.com/sc4/archive/~checkout~/modules/10303-',@part,'-arm.exp?rev=1.1&amp;content-type=text/plain')"/>
  -->
  <xsl:variable name="names_url"
    select="'http://standards.iso.org/iso/10303/tech/short_names/short-names.txt'"/>
  
  <xsl:variable name="parts_url"
    select="'http://standards.iso.org/iso/10303/smrl/v6/tech/smrlv6.zip'"/>

  <!-- it has been decided that for WG3 modules, a place for additional rules will be
provided  that links throught SC4ONLINE to a new repository --> 

  <!-- <xsl:variable name="information_url"
  select="'http://www.tc184-sc4.org/implementation_information/'"/> -->
  <xsl:variable name="information_url"
       select="concat('http://www.tc184-sc4.org/implementation_information/10303/',format-number(@part, '00000'))"/>
  <p>
    This annex references a listing of the EXPRESS entity names and
    corresponding short names as specified or referenced in this part of ISO
    10303. It also provides a listing of each EXPRESS schema specified in this
    part of ISO 10303 without comments nor other explanatory text. These
    listings are available in computer-interpretable form in Table E.1 and can
    be found at the following URLs:
  </p>
  <table>
    <tr>
      <td>&#160;&#160;</td>
      <td>Short names:</td>
      <td><a href="{$names_url}"  target="_blank"><xsl:value-of select="$names_url"/></a></td>
  </tr>
  <tr>
    <td>&#160;&#160;</td>
    <td>EXPRESS:</td>
     <td><a href="{$parts_url}" target="_blank" ><xsl:value-of select="$parts_url"/></a></td>
   </tr>
  </table>

  <xsl:if test="@sc4.working_group='3' and string-length(@wg.number.mim_lf) > 0" >
    <p>Additional information, such as 
computer-interpretable rules derived from normative text or mappings in 
this part of ISO 10303,  may be provided to support implementations.  If the information is  provided it can be found at the following URL:</p>
  <table>
    <tr>
      <td>&#160;&#160;</td>
      <td>Additional information:</td>      
      <td><a href="{$information_url}"  target="_blank"><xsl:value-of select="$information_url"/></a></td>
  </tr>
  </table>
  </xsl:if>

  <p/>
  <div align="center">
    <a name="table_e1">
      <b>
        <xsl:choose>
          <xsl:when test="./mim_lf or ./arm_lf">
            Table <xsl:value-of select="$annex_no"/>.1 &#8212; ARM and MIM EXPRESS short and long form listings
          </xsl:when>
          <xsl:otherwise>
            Table <xsl:value-of select="$annex_no"/>.1 &#8212; ARM and MIM EXPRESS listings
          </xsl:otherwise>
        </xsl:choose>
      </b>
    </a>
  </div>

  <br/>

  <div align="center">
    <table border="1" cellspacing="1">
      <tr>
        <td><b>Description</b></td>
        <xsl:choose>
          <xsl:when test="$FILE_EXT='.xml'">
            <td><b>XML file</b></td>
          </xsl:when>
          <xsl:otherwise>
            <td><b>HTML file</b></td>
          </xsl:otherwise>
        </xsl:choose>

        <td><b>ASCII file</b></td>
        <td><b>Identifier</b></td>
      </tr>
      
      <!-- ARM HTML row -->
      <tr>
        <xsl:choose>
          <xsl:when test="$FILE_EXT='.xml'">
            <td>ARM short form EXPRESS</td>
          </xsl:when>
          <xsl:otherwise>
            <td>ARM short form EXPRESS</td>
          </xsl:otherwise>
        </xsl:choose>
        <td>
          <a href="{$arm}">
            <!-- <xsl:value-of select="concat('arm',$FILE_EXT)"/> -->
            <xsl:choose>
              <xsl:when test="$FILE_EXT='.xml'">
                XML
              </xsl:when>
              <xsl:otherwise>
                HTML
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </td>

        <xsl:call-template name="output_express_links">
          <xsl:with-param name="module" select="/module/@name"/>
          <xsl:with-param name="wgnumber" select="./@wg.number.arm"/>
          <xsl:with-param name="file" select="'arm.exp'"/>
        </xsl:call-template>        
      </tr>
      <xsl:apply-templates select="arm_lf" mode="annexe"/>

      <!-- MIM HTML row -->
      <tr>
        <xsl:choose>
          <xsl:when test="$FILE_EXT='.xml'">
            <td>MIM short form EXPRESS</td>
          </xsl:when>
          <xsl:otherwise>
            <td>MIM short form EXPRESS</td>
          </xsl:otherwise>
        </xsl:choose>
        <td>
          <a href="{$mim}">
            <!-- <xsl:value-of select="concat('mim',$FILE_EXT)"/> -->
            <xsl:choose>
              <xsl:when test="$FILE_EXT='.xml'">
                XML
              </xsl:when>
              <xsl:otherwise>
                HTML
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </td>
        <xsl:call-template name="output_express_links">
          <xsl:with-param name="module" select="/module/@name"/>
          <xsl:with-param name="wgnumber" 
            select="./@wg.number.mim"/>
          <xsl:with-param name="file" select="'mim.exp'"/>
        </xsl:call-template>        
      </tr>
      <xsl:apply-templates select="mim_lf" mode="annexe"/>

    </table>
  </div>
  <p>
    If there is difficulty accessing these sites, contact ISO Central
    Secretariat.
  </p>
  <p class="note">
    <small>
      NOTE&#160;&#160;The information provided in computer-interpretable
      form at the 
      above URLs is informative. The information that is contained in the
      body of this part of ISO 10303 is normative. 
    </small>
  </p>
</xsl:template>


<xsl:template name="output_express_links">
  <xsl:param name="wgnumber"/>
  <xsl:param name="module"/>
  <xsl:param name="file"/>

  <td>
    <a href="../../../modules/{$module}/{$file}">
      EXPRESS
      <!--  <xsl:value-of select="$file"/> -->
    </a>
  </td>
  <td align="left">
    <xsl:variable name="test_wg_number">
      <xsl:call-template name="test_wg_number">
        <xsl:with-param name="wgnumber" select="$wgnumber"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="$file='arm.exp'">
          arm
        </xsl:when>
        <xsl:otherwise>
          mim
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($test_wg_number,'Error')">
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of select="concat('(Error in
                                  module.xml/module/@wg.number.',$type,' - ',
                                  $test_wg_number)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="wg_group">
          <xsl:call-template name="get_module_wg_group"/>
        </xsl:variable>
        <xsl:value-of select="concat('ISO/TC 184/SC 4/WG ',$wg_group,' N',$wgnumber)"/>
      </xsl:otherwise>
    </xsl:choose>    
  </td>
</xsl:template>

<xsl:template match="arm_lf" mode="annexe">
  <xsl:variable name="arm_lf">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_arm_lf.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_arm_lf.htm')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <tr>
    <td>ARM long form EXPRESS</td>
    <td>
      <a href="{$arm_lf}">
        <!-- <xsl:value-of select="concat('arm_lf',$FILE_EXT)"/> -->
        <xsl:choose>
          <xsl:when test="$FILE_EXT='.xml'">
            XML
          </xsl:when>
          <xsl:otherwise>
            HTML
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </td>
    <xsl:call-template name="output_express_links">
      <xsl:with-param name="module" select="/module/@name"/>
      <xsl:with-param name="wgnumber" 
        select="../@wg.number.arm_lf"/>
      <xsl:with-param name="file" select="'arm_lf.exp'"/>
    </xsl:call-template>        
  </tr>
</xsl:template>

<xsl:template match="mim_lf" mode="annexe">
  <xsl:variable name="mim_lf">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_mim_lf.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_mim_lf.htm')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <tr>
    <td>MIM long form EXPRESS</td>
    <td>
      <a href="{$mim_lf}">
        <!-- <xsl:value-of select="concat('mim_lf',$FILE_EXT)"/> -->
        <xsl:choose>
          <xsl:when test="$FILE_EXT='.xml'">
            XML
          </xsl:when>
          <xsl:otherwise>
            HTML
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </td>
    <xsl:call-template name="output_express_links">
      <xsl:with-param name="module" select="/module/@name"/>
      <xsl:with-param name="wgnumber" 
        select="../@wg.number.mim_lf"/>
      <xsl:with-param name="file" select="'mim_lf.exp'"/>
    </xsl:call-template>        
  </tr>
</xsl:template>

<xsl:template match="arm">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'4 Information requirements'"/>
    <xsl:with-param name="aname" select="'arm'"/>
  </xsl:call-template>
  <xsl:variable name="c_expg"
    select="concat('./c_arm_expg',$FILE_EXT)"/>
  <xsl:variable name="sect51" 
    select="concat('./5_mapping',$FILE_EXT,'#mapping')"/>

  <xsl:variable name="current_module">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="../@name"/>
    </xsl:call-template>           
  </xsl:variable>

  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="../@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>

  <xsl:variable name="arm_node" select="document($arm_xml)"/>


  <p>
    This clause specifies the information requirements for the 
    <b><xsl:value-of select="$current_module"/></b>
    application module. The information requirements are specified as the
    Application Reference Model (ARM) of this application module.
  </p>
  <p class="note">
    <small>
      NOTE&#160;1&#160;&#160;A graphical representation of the information
      requirements is given in 
      Annex <a href="{$c_expg}">C</a>.
    </small>
  </p>
  <p class="note">
    <small>
      NOTE&#160;2&#160;&#160;The mapping specification is specified in 
      <a href="{$sect51}">5.1</a>. It shows how
      the information requirements are met by using common resources and
      constructs defined or imported in the MIM schema of this application
      module. 
    </small>
  </p>
    
  <p>
    This clause defines the information requirements to which implementations shall
    conform using the EXPRESS language as defined in ISO 10303-11.   
    <xsl:choose>
      <xsl:when test="$arm_node/express/schema/interface">
        The following begins the 
        <b><xsl:value-of select="$arm_node/express/schema/@name"/></b>
        schema and identifies the necessary external references.
      </xsl:when>
      <xsl:otherwise>
        The following begins the 
        <b><xsl:value-of select="$current_module"/></b> schema.
      </xsl:otherwise>
    </xsl:choose>
  </p>

  <!-- Just display the description of the schema. -->
  <xsl:apply-templates 
    select="$arm_node/express/schema" mode="description"/>


  <!-- there is only one schema in a module -->
  <xsl:variable 
    name="schema_name" 
    select="$arm_node/express/schema/@name"/>

  <xsl:call-template name="check_schema_name">
    <xsl:with-param name="arm_mim_schema" select="'arm'"/>
    <xsl:with-param name="schema_name" select="$schema_name"/>
  </xsl:call-template>

  <xsl:variable name="xref">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- output any issuess against the schema   -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="$schema_name"/>
  </xsl:call-template> 
    <u>EXPRESS specification: </u>
  <code>
    <br/>    <br/>
    *)<br/>
    <a name="{$xref}">
      SCHEMA <xsl:value-of select="concat($schema_name,';')"/>
  </a>
  <br/>(*<br/>
  </code>

  <!-- Note a UoF section is no longer required so this is commented out 
  <h2>
    <a name="uof">
      4.1&#160;Unit of functionality
    </a>
  </h2>
  <xsl:apply-templates select="." mode="uof"/> -->


  <!-- output all the EXPRESS specifications -->
  <!-- display the EXPRESS for the interfaces in the ARM.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$arm_node/express/schema/interface"/>

  <!-- display the constant EXPRESS. The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$arm_node/express/schema/constant"/>

  <!-- display the EXPRESS for the types in the schema.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$arm_node/express/schema/type"/>
  
  <!-- display the EXPRESS for the entities in the ARM.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$arm_node/express/schema/entity"/>

  <!-- display the EXPRESS for the subtype.contraints in the ARM.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$arm_node/express/schema/subtype.constraint"/>

  <!-- display the EXPRESS for the functions in the ARM
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$arm_node/express/schema/function"/>

  <!-- display the EXPRESS for the entities in the ARM. 
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$arm_node/express/schema/rule"/>

  <!-- display the EXPRESS for the procedures in the ARM. 
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$arm_node/express/schema/procedure"/>

  
  <code>
    <br/>    <br/>
    *)<br/>
    END_SCHEMA;&#160;&#160;--&#160;<xsl:value-of select="$arm_node/express/schema/@name"/>
    <br/>(*
  </code>

</xsl:template>

<!-- Note a UoF section is no longer required -->
<xsl:template match="arm" mode="uof">
      This subclause specifies the units of functionality (UoF) for this
      part of ISO 10303 as well as any support elements needed for the
      application module definition.       
      <xsl:choose>
        <xsl:when test="(./uof.ae)">
          This part of ISO 10303 specifies the following units of
          functionality and application objects:
        </xsl:when>
        <xsl:otherwise>
          This part of ISO 10303 specifies the following units of
          functionality:
        </xsl:otherwise>
      </xsl:choose>
      <ul>
        <xsl:apply-templates select="uof" mode="toc"/>
      </ul>
      <!-- output any UoFs in other modules -->
      <xsl:choose>
        <xsl:when test="(./uoflink)">
          <p>
            This part of ISO 10303 also includes the following units of
            functionality: 
          </p>
          <ul>
            <xsl:apply-templates select="./uoflink" mode="toc"/>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <p>
            <!--
                 This part of ISO 10303 uses no other units of functionality. 
                 -->
            This part of ISO 10303 also includes the units of functionality
            defined in the application modules that are imported with the USE
            FROM statements specified in Clause 4.2  
          </p>        
        </xsl:otherwise>
      </xsl:choose>
      <p>
        The content of the units of functionality is listed below.  
      </p>
      
      <xsl:apply-templates select="uof" mode="uof_toc"/>
      
      <xsl:apply-templates select="uoflink" mode="uof_toc"/>
</xsl:template>

<xsl:template match="uof" mode="toc">
  <xsl:variable name="href" select="concat('#uof',@name)"/>
  <li>
    <a href="{$href}">
      <xsl:choose>
        <xsl:when test="position()!=last()">
          <xsl:value-of select="concat(@name,';')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(@name,'.')"/>        
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </li>
</xsl:template>

<xsl:template match="uoflink" mode="toc">
  <xsl:variable name="module" select="@module"/>
  <xsl:variable name="uof" select="@uof"/>
  <xsl:variable name="xref" 
    select="concat('#uof',$uof)"/>
  <li>
    <xsl:choose>
      <xsl:when test="position()!=last()">
        <a href="{$xref}">
          <xsl:value-of select="concat($uof,';')"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$xref}">
          <xsl:value-of select="concat($uof,'.')"/>        
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </li>
</xsl:template>

<xsl:template match="uof" mode="uof_toc">
  <h2>
    <xsl:variable name="name" select="concat('uof',@name)"/>
    <!-- only number section if more than one UOF -->
    <xsl:choose>
      <xsl:when test="count(../uof) > 1 ">
        <a name="{$name}">
          <xsl:value-of select="concat('4.1.',position(),' ',@name)"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a name="{$name}">
          <xsl:value-of select="@name"/>
        </a>        
      </xsl:otherwise>
    </xsl:choose>
  </h2>

  <!-- The <xsl:value-of select="@name"/> UoF specifies -->
  <xsl:choose>
    <xsl:when test="string-length(./description) > 0">
      <xsl:apply-templates select="description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error 3: No description provided for UoF ',@name)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="uof.ae">
    <p>
      The following application objects are defined in the
      <xsl:value-of select="@name"/> UoF: 
    </p>
  </xsl:if>
  <ul>
    <xsl:apply-templates select="uof.ae"/>
  </ul>
</xsl:template>

<xsl:template match="uoflink" mode="uof_toc">
  <xsl:variable name="module" select="@module"/>
  <xsl:variable name="uof" select="@uof"/>
  <xsl:variable name="xref" 
    select="concat('../../',$module,'/sys/4_info_reqs',$FILE_EXT,'#uof',$uof)"/>
  <xsl:variable name="current_module">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="/module/@name"/>
    </xsl:call-template>           
  </xsl:variable>
  <h2>
    <xsl:variable name="name" select="concat('uof',$uof)"/>
    <a name="{$name}">
      <xsl:value-of select="concat('4.1.',position()+count(../uof),' ',$uof)"/>
    </a>
  </h2>
  This UoF is defined in the
  <a href="{$xref}">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="$module"/>
    </xsl:call-template>   
  </a>
  module. The following application entities from this UoF are referenced
  in the 
  <xsl:value-of select="$current_module"/> module:  
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="$module"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="$module"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$module_ok='true'">
        <!-- check that the UoF is named correctly -->
        <xsl:choose>
          <xsl:when test="document(concat($module_dir,'/module.xml'))/module/arm/uof[@name=$uof]">
            <ul>
              <xsl:apply-templates
                select="document(concat($module_dir,'/module.xml'))/module/arm/uof[@name=$uof]/uof.ae">
                <xsl:with-param name="module" select="$module"/>
              </xsl:apply-templates>
            </ul>            
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param name="message">
                <xsl:value-of select="concat('Error 18: The UoF ',$uof,
                                      ' cannot be found in module ',$module )"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>

    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error 5: ', $module_ok)"/>
        </xsl:with-param>
      </xsl:call-template>

    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="uof.ae">
  <!-- if the UoF AE is in another module i.e. called from uoflink,
       then pass the module as parameter -->
  <xsl:param name="module"/>

  <xsl:variable name="module_name">
    <xsl:choose>
      <xsl:when test="$module">
        <xsl:value-of select="$module"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/module/@name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- check that the entity/type referenced exists -->
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="$module_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm" select="concat($module_dir,'/arm.xml')"/>
  <xsl:variable name="ae" select="@entity"/>
  <xsl:variable name="schema_name">
    <xsl:call-template name="schema_name">
      <xsl:with-param name="module_name" select="$module_name"/>
      <xsl:with-param name="arm_mim" select="'arm'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="document($arm)/express/schema[entity/@name=$ae or type/@name=$ae]">
      <li> 
        <xsl:variable name="aname">
          <xsl:call-template name="express_a_name">
            <xsl:with-param name="section1" select="$schema_name"/>
            <xsl:with-param name="section2" select="$ae"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="xref">
          <xsl:choose>
            <xsl:when test="$module">
              <xsl:value-of 
                select="concat('../../',$module,'/sys/4_info_reqs',$FILE_EXT,
                        '#',$aname)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('#',$aname)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="position()!=last()">
            <a href="{$xref}">
              <xsl:value-of select="$ae"/>
            </a>;
          </xsl:when>
          <xsl:otherwise>
            <a href="{$xref}">
              <xsl:value-of select="$ae"/>
            </a>.
          </xsl:otherwise>
        </xsl:choose>
      </li>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error 6: uof.ae error: The application object ',$ae,' cannot be found in module ',$module)"/>
        </xsl:with-param>
      </xsl:call-template>

    </xsl:otherwise>
  </xsl:choose>  
</xsl:template>




<xsl:template match="mim">
  <!--
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'5 Module interpreted model'"/>
    <xsl:with-param name="aname" select="'mim'"/>
  </xsl:call-template>


  <h2>
    <a name="mapping">5.1 Mapping specification</a>
  </h2>
  <xsl:choose>
    <xsl:when test="string-length(../mapping_table)>0">
      <xsl:apply-templates select="../mapping_table" mode="toc"/>
    </xsl:when>
    <xsl:otherwise>
      No mappings are specified in this application module.
    </xsl:otherwise>
  </xsl:choose>
  -->

  <h2>
    <a name="mim_express">5.2 MIM EXPRESS short listing</a>
  </h2>
  <p>
    This clause specifies the EXPRESS schema derived from the mapping
    table. 
    It uses elements from the common resources or from other application
    modules and defines the EXPRESS constructs that are specific to this
    part of ISO 10303.
  </p> 
  <p>
    This clause constitutes the Module Interpreted Module (MIM) of the
    application module.
  </p>

  <p>This clause also
    specifies the modifications that apply to the constructs 
    imported from the common resources.</p>
  <p>The following restrictions apply to the use, in this schema, of constructs defined in common resources or in application
    modules:</p>
  <ul>
    <li>
      use of a supertype entity does not make applicable any of its
      specializations, unless the specialization is also imported in the
      MIM schema;
    </li> 
    <li>
      use of a SELECT type does not make applicable any of its listed types
      unless the listed type is also imported in the MIM schema.
    </li>
  </ul>

  <!-- output all the EXPRESS specifications -->
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="../@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable 
    name="mim_xml"
    select="concat($module_dir,'/mim.xml')"/>


  <xsl:variable 
    name="mim_nodes" 
    select="document($mim_xml)"/>

  <xsl:variable 
    name="schema_name" 
    select="$mim_nodes/express/schema/@name"/>

  <xsl:variable name="xref">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Just display the description of the schema. -->
  <xsl:apply-templates 
    select="$mim_nodes/express/schema" mode="description"/>

  <!-- output any issuess against the schema   -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="$schema_name"/>
  </xsl:call-template> 


  <xsl:call-template name="check_schema_name">
    <xsl:with-param name="arm_mim_schema" select="'mim'"/>
    <xsl:with-param name="schema_name" select="$schema_name"/>
  </xsl:call-template>


  <xsl:apply-templates select="$mim_nodes/express/schema" mode="check_mim_usefroms"/>
  <u>EXPRESS specification: </u>
  <code>
    <br/>    <br/>
    *)<br/>
    <a name="{$xref}">
      SCHEMA <xsl:value-of select="concat($schema_name,';')"/>
  </a>
</code>

 
  <!-- display the EXPRESS for the interfaces in the MIM.
       The template is in sect4_express.xsl -->
  <!-- there is only one schema in a module -->
  <xsl:apply-templates 
    select="$mim_nodes/express/schema/interface"/>

  <!-- display the constant EXPRESS. The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$mim_nodes/express/schema[@name=$schema_name]/constant"/>
  <!-- display any imported Constant constructs that have been described by 
       description.item in the interface -->
  <xsl:call-template name="imported_constructs">
    <xsl:with-param name="desc_item" 
      select="$mim_nodes/express/schema/interface/described.item[@kind='CONSTANT']"/>
  </xsl:call-template>


  <!-- display the EXPRESS for the types in the schema.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$mim_nodes/express/schema/type"/>
  <!-- display any imported type constructs that have been described by 
       description.item in the interface -->
  <xsl:call-template name="imported_constructs">
    <xsl:with-param name="desc_item" 
      select="$mim_nodes/express/schema/interface/described.item[@kind='TYPE']"/>
  </xsl:call-template>


  
  <!-- display the EXPRESS for the entities in the MIM.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$mim_nodes/express/schema/entity"/>

  <!-- display any imported entity constructs that have been described by 
       description.item in the interface -->
  <xsl:call-template name="imported_constructs">
    <xsl:with-param name="desc_item" 
      select="$mim_nodes/express/schema/interface/described.item[@kind='ENTITY']"/>
  </xsl:call-template>

  <!-- display the EXPRESS for the subtype.contraints in the MIM.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$mim_nodes/express/schema/subtype.constraint"/>
  <!-- display any imported function constructs that have been described by 
       description.item in the interface -->
  <xsl:call-template name="imported_constructs">
    <xsl:with-param name="desc_item" 
      select="$mim_nodes/express/schema/interface/described.item[@kind='SUBTYPE.CONSTRAINT']"/>
  </xsl:call-template>



  <!-- display the EXPRESS for the functions in the MIM
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$mim_nodes/express/schema/function"/>
  <!-- display any imported function constructs that have been described by 
       description.item in the interface -->
  <xsl:call-template name="imported_constructs">
    <xsl:with-param name="desc_item" 
      select="$mim_nodes/express/schema/interface/described.item[@kind='FUNCTION']"/>
  </xsl:call-template>


  <!-- display the EXPRESS for the entities in the MIM. 
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$mim_nodes/express/schema/rule"/>
  <!-- display any imported rule constructs that have been described by 
       description.item in the interface -->
  <xsl:call-template name="imported_constructs">
    <xsl:with-param name="desc_item" 
      select="$mim_nodes/express/schema/interface/described.item[@kind='RULE']"/>
  </xsl:call-template>

  <!-- display the EXPRESS for the procedures in the MIM. 
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="$mim_nodes/express/schema/procedure"/>
  <!-- display any imported procedure constructs that have been described by 
       description.item in the interface -->
  <xsl:call-template name="imported_constructs">
    <xsl:with-param name="desc_item" 
      select="$mim_nodes/express/schema/interface/described.item[@kind='PROCEDURE']"/>
  </xsl:call-template>

  <code>
    <br/>    <br/>
    *)<br/>
    END_SCHEMA;&#160;&#160;--&#160;<xsl:value-of select="$mim_nodes/express/schema/@name"/>
    <br/>(*
  </code>

</xsl:template>

<xsl:template match="mapping_table" mode="toc">
  <xsl:apply-templates select="ae" mode="toc"/> 
</xsl:template>

<!-- Output the application element table of contents for the mapping table
     -->
<xsl:template match="ae" mode="toc">
  <xsl:variable name="xref" 
    select="concat('5_mapping',$FILE_EXT,'#',@entity)"/>
  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>
  <h2>
    <xsl:value-of select="concat('5.1.',$sect_no,' ')"/>
    <a href="{$xref}"><xsl:value-of select="@entity"/></a>
  </h2>
</xsl:template>





<!-- build a list of normrefs that are used by the module.
     The list comprises:
     All default normrefs listed in ../data/basic/normrefs_default.xml
     All normrefs explicitly included in the module by normref.inc
     All default normrefs that define terms for which abbreviations are provided and listed in ../data/basic/abbreviations_default.xml
     All modules referenced by a USE FROM in the ARM
     All modules referenced by a USE FROM in the MIM
     All integrated resources referenced by a USE FROM in the MIM
-->
<xsl:template name="normrefs_list">

  <!-- get all default normrefs listed in ../data/basic/normrefs_default.xml -->
  <xsl:variable name="normref_list1">
    <xsl:call-template name="get_normref">
      <xsl:with-param 
        name="normref_nodes" 
        select="document('../data/basic/normrefs_default.xml')/normrefs/normref.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="''"/>
    </xsl:call-template>    
  </xsl:variable>

  <!-- 
  <xsl:message>
    l1:<xsl:value-of select="$normref_list1"/>:l1
  </xsl:message>
  -->

  <!-- get all normrefs explicitly included in the module by normref.inc -->
  <xsl:variable name="normref_list2">
    <xsl:call-template name="get_normref">
      <xsl:with-param 
        name="normref_nodes" 
        select="/module/normrefs/normref.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list1"/>
    </xsl:call-template>    
  </xsl:variable>

  <!--  
  <xsl:message>
    l2:<xsl:value-of select="$normref_list2"/>:l2
  </xsl:message>
  -->


  <!-- get all normrefs that define terms for which abbreviations are
       provided.
       Get the abbreviation.inc from abbreviations_default.xml, 
       get the referenced abbreviation from abbreviations.xml
       then get the normref in which the term is defined
       -->
  <xsl:variable name="normref_list3">
    <xsl:call-template name="get_normrefs_from_abbr">
      <xsl:with-param 
        name="abbrvinc_nodes" 
        select="document('../data/basic/abbreviations_default.xml')/abbreviations/abbreviation.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list2"/>
    </xsl:call-template>    
  </xsl:variable>

  <!-- 
  <xsl:message>
    l3:<xsl:value-of select="$normref_list3"/>:l3
  </xsl:message>
  -->

  <!-- get all modules referenced by a USE FROM in the ARM -->
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="/module/@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml"
    select="concat($module_dir,'/arm.xml')"/>

  <xsl:variable name="normref_list4">
    <xsl:call-template name="get_normrefs_from_schema">
      <xsl:with-param 
        name="interface_nodes" 
        select="document($arm_xml)/express/schema/interface"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list3"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- 
  <xsl:message>
    l4:<xsl:value-of select="$normref_list4"/>:l4
  </xsl:message>
  -->

  <!-- get all modules referenced by a USE FROM in the MIM -->
  <xsl:variable name="mim_xml"
    select="concat($module_dir,'/mim.xml')"/>

  <xsl:variable name="normref_list5">
    <xsl:call-template name="get_normrefs_from_schema">
      <xsl:with-param 
        name="interface_nodes" 
        select="document($mim_xml)/express/schema/interface"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list4"/>
    </xsl:call-template>
  </xsl:variable>

  <!--   
  <xsl:message>
    l5:<xsl:value-of select="$normref_list5"/>:l5
  </xsl:message>
  -->

  <xsl:value-of select="concat($normref_list5,',')"/>

</xsl:template>

<!-- given a list of normref nodes, add the ids of the normrefs to the
     normref_list, if not already a member. ids in normref_list are
     separated by a , -->
<xsl:template name="get_normref">
  <xsl:param name="normref_nodes"/>
  <xsl:param name="normref_list"/>
  
  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$normref_nodes">

        <xsl:variable name="first">
          <xsl:choose>
            <xsl:when test="$normref_nodes[1]/@normref">
              <xsl:value-of 
                select="concat('normref:',$normref_nodes[1]/@normref)"/>
            </xsl:when>
            <xsl:when test="$normref_nodes[1]/@module.name">
              <xsl:value-of 
                select="concat('module:',$normref_nodes[1]/@module.name)"/>
            </xsl:when>            
            <xsl:when test="$normref_nodes[1]/@resource.name">
              <xsl:value-of 
                select="concat('module:',$normref_nodes[1]/@resource.name)"/>
            </xsl:when>            
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="normref_list1">
          <xsl:call-template name="add_normref">
            <xsl:with-param name="normref" select="$first"/>
            <xsl:with-param name="normref_list" select="$normref_list"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="get_normref">
          <xsl:with-param 
            name="normref_nodes" 
            select="$normref_nodes[position()!=1]"/>
          <xsl:with-param 
            name="normref_list" 
            select="$normref_list1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- end of recursion -->
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$normref_list_ret"/>
</xsl:template>

<!-- given a list of abbreviation.inc nodes, add the ids of the normrefs to the
     normref_list, if not already a member. ids in normref_list are
     separated by a , -->
<xsl:template name="get_normrefs_from_abbr">
  <xsl:param name="abbrvinc_nodes"/>
  <xsl:param name="normref_list"/>
  
  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$abbrvinc_nodes">
        <xsl:variable name="abbr.inc" select="$abbrvinc_nodes[1]/@linkend"/>
        <xsl:variable name="abbr" 
          select="document('../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$abbr.inc]"/>

        <xsl:variable name="first">
          <xsl:choose>
            <xsl:when test="$abbr/term.ref/@normref">
              <xsl:value-of 
                select="concat('normref:',$abbr/term.ref/@normref)"/>
            </xsl:when>
            <xsl:when test="$abbr/term.ref/@module.name">
              <xsl:value-of 
                select="concat('module:',$abbr/term.ref/@module.name)"/>
            </xsl:when>            
            <xsl:when test="$abbr/term.ref/@resource.name">
              <xsl:value-of 
                select="concat('module:',$abbr/term.ref/@resource.name)"/>
            </xsl:when>            
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="normref_list1">
          <xsl:call-template name="add_normref">
            <xsl:with-param name="normref" select="$first"/>
            <xsl:with-param name="normref_list" select="$normref_list"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="get_normrefs_from_abbr">
          <xsl:with-param 
            name="abbrvinc_nodes" 
            select="$abbrvinc_nodes[position()!=1]"/>
          <xsl:with-param 
            name="normref_list" 
            select="$normref_list1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- end of recursion -->
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$normref_list_ret"/>

</xsl:template>


<!-- 
     given a list of interface nodes defined in an express schema,
     add the names of the modules referenced by the interface to the list
     of normative references.
     -->
<xsl:template name="get_normrefs_from_schema">
  <xsl:param name="interface_nodes"/>
  <xsl:param name="normref_list"/>

  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$interface_nodes">
        <xsl:variable name="schema" select="$interface_nodes[1]/@schema"/>
        <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
        <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
        <xsl:variable name="schema_lcase"
          select="translate($schema,$UPPER, $LOWER)"/>
        
        <xsl:variable name="module_name">
          <xsl:choose>
            <xsl:when test="contains($schema_lcase,'_arm')">
              <xsl:value-of 
                select="concat('module:',substring-before($schema_lcase,'_arm'))"/>
            </xsl:when>
            <xsl:when test="contains($schema_lcase,'_mim')">
              <xsl:value-of 
                select="concat('module:',substring-before($schema_lcase,'_mim'))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of 
                select="concat('resource:',$schema_lcase)"/>          
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="normref_list1">
          <xsl:call-template name="add_normref">
            <xsl:with-param name="normref" select="$module_name"/>
            <xsl:with-param name="normref_list" select="$normref_list"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="get_normrefs_from_schema">
          <xsl:with-param 
            name="interface_nodes" 
            select="$interface_nodes[position()!=1]"/>
          <xsl:with-param 
            name="normref_list" 
            select="$normref_list1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- end of recursion -->
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$normref_list_ret"/>
</xsl:template>


<!-- add a normref id to the set of normref ids. -->
<xsl:template name="add_normref">
  <xsl:param name="normref"/>
  <xsl:param name="normref_list"/>
  <!-- end the list with a , -->
  <xsl:variable name="normref_list_term"
    select="concat($normref_list,',')"/>
  <xsl:variable name="normref_list1">
    <xsl:choose>
      <xsl:when test="contains($normref_list_term, concat(',',$normref,','))">
        <xsl:value-of select="$normref_list"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($normref_list,',',$normref,',')"/>      
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$normref_list1"/>
</xsl:template>
     

<xsl:template name="prune_normrefs_list">
  <xsl:param name="normrefs_list"/>
  <xsl:param name="pruned_normrefs_list" select="''"/>
  <xsl:param name="pruned_normrefs_ids" select="''"/>
  <xsl:choose>
    <xsl:when test="$normrefs_list">
      <xsl:variable 
        name="first"
        select="substring-before(substring-after($normrefs_list,','),',')"/>
      <xsl:variable 
        name="rest"
        select="substring-after(substring-after($normrefs_list,','),',')"/>

      <xsl:variable name="add_to_pruned_normrefs_ids">
        <xsl:choose>
          <xsl:when test="contains($first,'normref:')">
            <!--  The default or explicit deal normrefs have
                 already been pruned so just add -->
            <xsl:variable 
              name="id" 
              select="substring-after($first,'normref:')"/>

            <xsl:variable name="normref">
              <xsl:apply-templates 
                select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$id]" mode="prune_normrefs_list"/>
            </xsl:variable>
            <!-- return the normref to be added to the list -->
            <xsl:value-of select="$normref"/>
          </xsl:when>

          <xsl:when test="contains($first,'module:')">
            <xsl:variable 
              name="module" 
              select="substring-after($first,'module:')"/>
            
            <xsl:variable name="module_dir">
              <xsl:call-template name="module_directory">
                <xsl:with-param name="module" select="$module"/>
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="module_ok">
              <xsl:call-template name="check_module_exists">
                <xsl:with-param name="module" select="$module"/>
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="module_xml" 
              select="concat($module_dir,'/module.xml')"/>
            
            <!-- output the normative reference derived from the module -->
            <xsl:variable name="normref">
              <xsl:if test="$module_ok='true'">
                <xsl:apply-templates 
                  select="document($module_xml)/module"
                  mode="prune_normrefs_list"/>
              </xsl:if>
            </xsl:variable>
            
            <!-- if the normref for the module has been already been added,
                 ignore -->
            <xsl:if test="not(contains($pruned_normrefs_ids,$normref))">
              <!-- return the normref to be added to the list -->
              <xsl:value-of select="$normref"/>
            </xsl:if>
          </xsl:when>
          <xsl:when test="contains($first,'resource:')">
            <!-- 
                 NO PRUNING TAKING PLACE - JUST MAKING SURE THAT THE
                 RESOURCE STAY IN THE LIST -->
            <xsl:variable 
              name="resource" 
              select="substring-after($first,'resource:')"/>
            <xsl:value-of select="$resource"/>
          </xsl:when>
          <xsl:otherwise/>
        
        </xsl:choose>
      </xsl:variable> <!-- add_to_pruned_normrefs_ids -->
      
      <xsl:variable name="new_pruned_normrefs_ids">
        <xsl:choose>
          <xsl:when test="string-length($add_to_pruned_normrefs_ids)>0">
            <xsl:value-of 
              select="concat($pruned_normrefs_ids,',',$add_to_pruned_normrefs_ids,',')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$pruned_normrefs_ids"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="new_pruned_normrefs_list">
        <xsl:choose>
          <xsl:when test="string-length($add_to_pruned_normrefs_ids)>0">
            <xsl:value-of 
              select="concat($pruned_normrefs_list,',',$first,',')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$pruned_normrefs_list"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:call-template name="prune_normrefs_list">
        <xsl:with-param name="normrefs_list" select="$rest"/>
        <xsl:with-param name="pruned_normrefs_list" 
          select="$new_pruned_normrefs_list"/>
        <xsl:with-param name="pruned_normrefs_ids" 
          select="$new_pruned_normrefs_ids"/>
      </xsl:call-template>  

    </xsl:when>
    <xsl:otherwise>
      <!-- end of recursion -->
      <xsl:value-of select="$pruned_normrefs_list"/>
    </xsl:otherwise>
  </xsl:choose>   
</xsl:template>

<xsl:template match="normref" mode="prune_normrefs_list">
  <xsl:value-of select="concat(./stdref/stdnumber,./stdref/pubdate)"/>
</xsl:template>


<xsl:template match="module" mode="prune_normrefs_list">
  <xsl:value-of select="concat('10303-',./@part,./@publication.year)"/>
</xsl:template>


<!-- Output the standard set of normative references and then any added by
     the module
     This is the main template for outputting normrefs. It is called from
     the sect_2_refs.xsl
     -->
<xsl:template name="output_normrefs">
  <xsl:param name="module_number"/>
  <xsl:param name="current_module"/>
  <h2>2 Normative references</h2>
  <!-- replace with ISO Directives, Part 2: as requested by WG3 conver 24/2/2004
  <p>
    The following normative documents contain provisions which, through
    reference in this text, constitute provisions of this International
    Standard. For dated references, subsequent amendments to, or revisions of,
    any of these publications do not apply. However, parties to agreements
    based on this International Standard are encouraged to investigate the
    possibility of applying the most recent editions of the normative documents
    indicated below. For undated references, the latest edition of the
    normative document referred to applies. Members of ISO and IEC maintain
    registers of currently valid International Standards. 
  </p> -->

    <p>
      The following referenced documents are indispensable for the application of
      this document. For dated references, only the edition cited applies. For
      undated references, the latest edition of the referenced document
      (including any amendments) applies.
    </p>

  <!-- output any issues -->
  <xsl:apply-templates select="." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'normrefs'"/>
  </xsl:apply-templates>

  <!-- output the normative reference explicitly defined in the module -->
  <xsl:apply-templates select="/module/normrefs/normref">
    <xsl:with-param name="current_module" select="$current_module"/>
  </xsl:apply-templates>

  <!-- output the default normative reference and any implicit in the
       module through the ARM and MIM -->
  <xsl:call-template name="output_default_normrefs">
    <xsl:with-param name="module_number" select="$module_number"/>
    <xsl:with-param name="current_module" select="$current_module"/>
  </xsl:call-template>

</xsl:template>


<!-- output the default normative reference and any implicit in the
     module through the ARM and MIM -->
<xsl:template name="output_default_normrefs">
  <xsl:param name="module_number"/>
  <xsl:param name="current_module"/>
  <xsl:variable name="normrefs">
    <xsl:call-template name="normrefs_list"/>
  </xsl:variable>

  <xsl:variable name="pruned_normrefs">
    <xsl:call-template name="prune_normrefs_list">
      <xsl:with-param name="normrefs_list" select="$normrefs"/>
    </xsl:call-template>  
  </xsl:variable>

  <xsl:variable name="normrefs_to_be_sorted"> 
    <xsl:call-template name="output_normrefs_rec">
      <xsl:with-param name="normrefs" select="$pruned_normrefs"/>
      <xsl:with-param name="module_number" select="$module_number"/>
    </xsl:call-template>  
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable name="normrefs_to_be_sorted_set" select="msxsl:node-set($normrefs_to_be_sorted)"/>
      <xsl:for-each select="$normrefs_to_be_sorted_set/normref">
        <!-- sorting basis is special normalized string, consisting of organization, series and part number all of equal lengths per each element -->
        <xsl:sort select='part'/>
        <xsl:for-each select="string/*">
         <xsl:copy-of select="."/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="function-available('exslt:node-set')">    
      <xsl:variable name="normrefs_to_be_sorted_set" select="exslt:node-set($normrefs_to_be_sorted)"/>
      <xsl:for-each select="$normrefs_to_be_sorted_set/normref">
        <!-- sorting basis is special normalized string, consisting of organization, series and part number all of equal lengths per each element -->
        <xsl:sort select='part'/>
        <xsl:for-each select="string/*">
         <xsl:copy-of select="."/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>

  <!-- output a footnote to say that the normative reference has not been
       published -->
  <xsl:call-template name="output_unpublished_normrefs">
    <xsl:with-param name="normrefs" select="$normrefs"/>
  </xsl:call-template>

  <!-- output a footnote to say that the normative reference has not been
       published -->
  <xsl:call-template name="output_derogated_normrefs">
    <xsl:with-param name="normrefs" select="$normrefs"/>
    <xsl:with-param name="current_module" select="$current_module"/>
  </xsl:call-template>
  
</xsl:template>

<xsl:template name="output_normrefs_rec">
  <xsl:param name="module_number"/>
  <xsl:param name="normrefs"/>
  <xsl:choose>
    <xsl:when test="$normrefs">
      <xsl:variable 
        name="first"
        select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable 
        name="rest"
        select="substring-after(substring-after($normrefs,','),',')"/>      

      <xsl:choose>
        <xsl:when test="contains($first,'normref:')">
          <xsl:variable 
            name="normref" 
            select="substring-after($first,'normref:')"/>

            <xsl:variable 
              name="normref_node"
              select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]"/>
          
          <xsl:choose>
            <xsl:when test="$normref_node">   
            <!-- don't output the normref if referring to current module
                 -->
          <!-- normref stdnumber are 10303-1107 whereas module numbers are
               1107, so remove the 10303- -->
          <xsl:variable name="part_no" 
            select="substring-after($normref_node/stdref/stdnumber,'-')"/>
            <xsl:element name="normref">
               <xsl:element name="string">
                <xsl:if test="$module_number!=$part_no">
                  <!-- OOUTPUT from normative references -->
                    <xsl:apply-templates 
                      select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]"/>
                </xsl:if>
              </xsl:element>
              <xsl:variable name="part">
                <xsl:value-of select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref/stdnumber"/>
              </xsl:variable>
              <xsl:variable name="orgname">
				<xsl:value-of select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref/orgname"/>
              </xsl:variable>
              <!-- eliminate status info like TS, CD-TS, etc -->
              <xsl:variable name="orgname_cleaned">
                <xsl:choose>
                  <xsl:when test="contains($orgname,'ISO')">ISO</xsl:when>
                  <!--  Add 'Z', so that it is placed at the of the list while sorting -->
                  <xsl:otherwise>Z<xsl:value-of select="$orgname"/></xsl:otherwise>
                </xsl:choose>  
              </xsl:variable>
                <!-- Try to 'normalize' part and subpart numbers -->
                <xsl:variable name="series" select="substring-before($part,'-')"/>
                <!-- normalize with longest possible series (10303) -->                    
                <xsl:variable name="series_norm">
                <xsl:choose>
                  <xsl:when test="string-length($series)=1">0000<xsl:value-of select="$series"/></xsl:when>
                  <xsl:when test="string-length($series)=2">000<xsl:value-of select="$series"/></xsl:when>
                  <xsl:when test="string-length($series)=3">00<xsl:value-of select="$series"/></xsl:when>
                  <xsl:when test="string-length($series)=4">0<xsl:value-of select="$series"/></xsl:when>
                  <xsl:when test="string-length($series)=5"><xsl:value-of select="$series"/></xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="error_message">
                      <xsl:with-param name="message">
                        <xsl:value-of select="concat('Unsupported length of series number: ', $series, 'length: ', string-length($series))"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
                </xsl:variable>
                <!-- normalize with longest possible part (4 digits) -->                    
                <xsl:variable name="part_norm">
                <xsl:choose>
                  <xsl:when test="string-length($part_no)=1">-000<xsl:value-of select="$part_no"/></xsl:when>
                  <xsl:when test="string-length($part_no)=2">-00<xsl:value-of select="$part_no"/></xsl:when>
                  <xsl:when test="string-length($part_no)=3">-0<xsl:value-of select="$part_no"/></xsl:when>
                  <xsl:when test="string-length($part_no)=4">-<xsl:value-of select="$part_no"/></xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="error_message">
                      <xsl:with-param name="message">
                        <xsl:value-of select="concat('Unsupported length of part number: ', $part_no, 'length: ', string-length($part_no))"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
                </xsl:variable>
                <xsl:element name="part">
                <!-- Organization name -->
                  <xsl:value-of select="$orgname_cleaned"/>-<xsl:value-of select="$series_norm"/><xsl:value-of select="$part_norm"/>
                </xsl:element>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param name="message">
                <xsl:value-of select="concat('Error 7: ', $normref, 'not found')"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="contains($first,'module:')">
        <xsl:variable 
          name="module" 
          select="substring-after($first,'module:')"/>
        
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="$module"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="module_xml" 
          select="concat($module_dir,'/module.xml')"/>
        
        <!-- OUTPUT the normative reference derived from the module -->
        <xsl:element name="normref">
            <xsl:apply-templates 
              select="document($module_xml)/module" mode="normref">
            </xsl:apply-templates>
        </xsl:element>
        
      </xsl:when>
      
      <xsl:when test="contains($first,'resource:')">
        <xsl:variable 
          name="resource" 
          select="substring-after($first,'resource:')"/>
        <xsl:call-template name="output_resource_normref">
          <xsl:with-param name="resource_schema" select="$resource"/>
        </xsl:call-template>          
      </xsl:when>
    </xsl:choose>
    
    <xsl:call-template name="output_normrefs_rec">
      <xsl:with-param name="normrefs" select="$rest"/>
      <xsl:with-param name="module_number" select="$module_number"/>
    </xsl:call-template>
    
  </xsl:when>
  <xsl:otherwise/>
  <!-- end of recursion -->
</xsl:choose>
</xsl:template>
    

<!-- output a footnote to say that the normative reference has not been
     published 
     Check the normative references in the nodule, then all the auto
     generated normrefs. These should be passed as a parameter the value of
     which is deduced by: template name="normrefs_list"
-->
<xsl:template name="output_unpublished_normrefs">
  <xsl:param name="normrefs"/>

  <xsl:variable name="footnote">
    <xsl:choose>
      <xsl:when test="/module/normrefs/normref/stdref[@published='n']">
        <xsl:value-of select="'y'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="output_unpublished_normrefs_rec">
          <xsl:with-param name="normrefs" select="$normrefs"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$footnote='y'">
    <p>
      <a name="tobepub">
        <sup>1)</sup> To be published.
      </a>      
    </p>
  </xsl:if>
</xsl:template>

<xsl:template name="output_unpublished_normrefs_rec">
  <xsl:param name="normrefs"/>

  <xsl:choose>
    <xsl:when test="$normrefs">
      <xsl:variable 
        name="first"
        select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable 
        name="rest"
        select="substring-after(substring-after($normrefs,','),',')"/>      
      
      <xsl:variable name="footnote">
        <xsl:choose>
          <xsl:when test="contains($first,'normref:')">
            <xsl:variable 
              name="normref" 
              select="substring-after($first,'normref:')"/>
            <xsl:choose>
              <xsl:when
test="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref[@published='n']">
                <xsl:value-of select="'y'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'n'"/>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:when>

          <xsl:when test="contains($first,'module:')">
            <xsl:variable 
              name="module" 
              select="substring-after($first,'module:')"/>
            
            <xsl:variable name="module_dir">
              <xsl:call-template name="module_directory">
                <xsl:with-param name="module" select="$module"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="module_xml" 
              select="concat($module_dir,'/module.xml')"/>
            <xsl:variable name="module_node" 
              select="document($module_xml)"/>
            <xsl:choose>
              <xsl:when test="$module_node/module[@published='n'] and $module_node/module[@version='1']">
               <xsl:value-of select="'y'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'n'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:otherwise>
            <xsl:value-of select="'n'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$footnote='n'">
          <!-- only recurse if no unpublished standard found -->      
          <xsl:call-template name="output_unpublished_normrefs_rec">
            <xsl:with-param name="normrefs" select="$rest"/>
          </xsl:call-template>        
        </xsl:when>
        <xsl:otherwise>
          <!-- footnote found so stop -->
          <xsl:value-of select="'y'"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:when>
    <xsl:otherwise>
      <!-- end of recursion -->
      <!-- <xsl:value-of select="$footnote"/> -->
      <xsl:value-of select="'n'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- output a footnote to say that the normative reference has been
     derogated 
     Check the normative references in the nodule, then all the auto
     generated normrefs. These should be passed as a parameter the value of
     which is deduced by: template name="normrefs_list"
-->
<xsl:template name="output_derogated_normrefs">
  <xsl:param name="current_module"/>
  <xsl:param name="normrefs"/>

  <xsl:variable name="footnote">
    <xsl:choose>
      <xsl:when 
        test="( string($current_module/@status)='TS' or 
                string($current_module/@status)='IS') and
              ( string(./@status)='CD' or string(./@status)='CD-TS')">
        <xsl:value-of select="'y'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="( string($current_module/@status)='TS' or 
                      string($current_module/@status)='IS')">
          <xsl:call-template name="output_derogated_normrefs_rec">
            <xsl:with-param name="normrefs" select="$normrefs"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$footnote='y'">
    <p>
      <a name="derogation">
        <sup>2)</sup> Reference applicable during ballot or review period.
      </a>      
    </p>
  </xsl:if>
</xsl:template>

<xsl:template name="output_derogated_normrefs_rec">
  <xsl:param name="normrefs"/>

  <xsl:choose>
    <xsl:when test="$normrefs">
      <xsl:variable 
        name="first"
        select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable 
        name="rest"
        select="substring-after(substring-after($normrefs,','),',')"/>      
      
      <xsl:variable name="footnote">
        <xsl:choose>
    <!-- ASSUMING THAT ALL NORMREFS IN normrefs.xml ARE
         PUBLISHED THERE FORE CANNOT BE DEROGATED 

          <xsl:when test="contains($first,'normref:')">
            <xsl:variable 
              name="normref" 
              select="substring-after($first,'normref:')"/>
            <xsl:choose>
              <xsl:when
test="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref[@published='n']">
                <xsl:value-of select="'y'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'n'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          -->

          <xsl:when test="contains($first,'module:')">
            <xsl:variable 
              name="module" 
              select="substring-after($first,'module:')"/>
            
            <xsl:variable name="module_dir">
              <xsl:call-template name="module_directory">
                <xsl:with-param name="module" select="$module"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="module_xml" 
              select="concat($module_dir,'/module.xml')"/>

            <xsl:variable name="module_status" 
              select="string(document($module_xml)/module/@status)"/>
            <xsl:choose>
              <xsl:when test="$module_status='CD-TS' or $module_status='CD'">
                <xsl:value-of select="'y'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'n'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:otherwise>
            <xsl:value-of select="'n'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$footnote='n'">
          <!-- only recurse if no unpublished standard found -->      
          <xsl:call-template name="output_derogated_normrefs_rec">
            <xsl:with-param name="normrefs" select="$rest"/>
          </xsl:call-template>        
        </xsl:when>
        <xsl:otherwise>
          <!-- footnote found so stop -->
          <xsl:value-of select="'y'"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:when>
    <xsl:otherwise>
      <!-- end of recursion -->
      <!-- <xsl:value-of select="$footnote"/> -->
      <xsl:value-of select="'n'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- get the normrefs out of the normrefs.xml database -->
<xsl:template match="normref.inc">
  <xsl:param name="current_module"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:apply-templates 
    select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]">

    <xsl:with-param name="current_module" select="$current_module"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template name="output_resource_normref">
  <xsl:param name="resource_schema"/>
  <xsl:variable name="ir_ok">
    <xsl:call-template name="check_resource_exists">
      <xsl:with-param name="schema" select="$resource_schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="ir_ref">
    <xsl:if test="$ir_ok='true'">
      <xsl:value-of 
        select="document(concat('../data/resources/',
                $resource_schema,'/',$resource_schema,'.xml'))/express/@reference"/>
    </xsl:if>
  </xsl:variable>

  <p>
    <xsl:call-template name="error_message">
      <xsl:with-param name="message">
        <xsl:value-of 
          select="concat('Warning 8: MIM uses schema ', 
                  $resource_schema, 
                  '#  Make sure you include Integrated resource (',
                  $ir_ref,
                  ') that defines it as a normative reference. ',
                  '#  Use: normref.inc')"/>
      </xsl:with-param>
      <xsl:with-param name="inline" select="'no'"/>
    </xsl:call-template>
  </p>
</xsl:template>

<xsl:template match="module" mode="normref">
  <xsl:element name="string">
  <p>
    <xsl:variable name="part">
      <xsl:choose>
        <xsl:when test="string-length(@part)>0">
          <xsl:value-of select="@part"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;part&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_module_stdnumber_undated">
        <xsl:with-param name="module" select="."/>
      </xsl:call-template>
    </xsl:variable>

    
    <xsl:variable name="stdtitle"
      select="concat('Industrial automation systems and integration ',
              '&#8212; Product data representation and exchange ')"/>

    <xsl:variable name="module_name">
      <xsl:call-template name="module_display_name">
        <xsl:with-param name="module" select="@name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="subtitle"
      select="concat('&#8212; Part ',$part,': Application module: ', $module_name,'.')"/>
    
    <!-- Printing of standard line starts here -->
    <xsl:value-of select="$stdnumber"/>
    <xsl:choose><!-- if the module is a TS or IS module and is referring to a CD or CD-TS module -->
      <xsl:when 
        test="( string(./@status)='TS' or 
              string(./@status)='IS') and
              ( string(./@status)='CD' or string(./@status)='CD-TS')">
        &#160;<sup><a href="#derogation">2</a>)</sup>
      </xsl:when>
      <!-- See:
        http://locke.dcnicn.com/bugzilla/iso10303/show_bug.cgi?id=3401#c7
        -->
      <xsl:when test="@published='n' and @version='1'">&#160;<sup><a href="#tobepub">1</a>)</sup>
      </xsl:when>
    </xsl:choose>,&#160;
    <i>
      <xsl:value-of select="$stdtitle"/>
      <xsl:value-of select="$subtitle"/>
    </i>
  </p>
  </xsl:element>    
  <xsl:element name="part">
  <!-- Need to 'normalize' the length so that we can easier sort it -->
    <xsl:choose>
      <xsl:when test="string-length(@part)=0">ISO-1            0303-0000      <xsl:value-of select="@part"/></xsl:when>
      <xsl:when test="string-length(@part)=1">ISO-10303-000<xsl:value-of select="@part"/></xsl:when>
      <xsl:when test="string-length(@part)=2">ISO-10303-00<xsl:value-of select="@part"/></xsl:when>
      <xsl:when test="string-length(@part)=3">ISO-10303-0<xsl:value-of select="@part"/></xsl:when>
      <xsl:when test="string-length(@part)=4">ISO-10303-<xsl:value-of select="@part"/></xsl:when>      
      <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param name="message">
                <xsl:value-of select="concat('Unsupported length of part number: ', @part, 'length: ', string-length(@part))"/>
              </xsl:with-param>
            </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
</xsl:template>

<!-- Output the normative reference -->
<xsl:template match="normref">
  <xsl:variable name="stdnumber">
<!--    <xsl:choose>
      <xsl:when test="stdref/pubdate">
        <xsl:value-of select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':',stdref/pubdate)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':&#8212;&#160;')"/>
      </xsl:otherwise>
    </xsl:choose> -->
	  <xsl:value-of 
	    select="concat(stdref/orgname,'&#160;',stdref/stdnumber)"/>
  </xsl:variable>
  <p>
    <xsl:value-of select="$stdnumber"/>
    <xsl:if test="stdref[@published='n']">
      <sup><a href="#tobepub">1</a>)</sup>
    </xsl:if>,&#160;
    <i>
      <xsl:value-of select="stdref/stdtitle"/>
      <xsl:variable name="subtitle" select="normalize-space(stdref/subtitle)"/>
      <xsl:choose>
        <xsl:when test="substring($subtitle, string-length($subtitle)) != '.'">
          <xsl:value-of select="concat($subtitle,'.')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$subtitle"/>
        </xsl:otherwise>
      </xsl:choose>
    </i>
  </p>
</xsl:template>


<!-- Output the standard set of abbreviations and then any added by
     the module
     -->
<xsl:template name="output_abbreviations">
  <xsl:param name="section"/>
  <h2>
    <a name="abbrv">3.2 Abbreviated terms</a>
  </h2>

  <!-- output any issues -->
  <xsl:apply-templates select="." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'abbreviations'"/>
  </xsl:apply-templates>


  <p>
    For the purposes of this document, the following abbreviated terms
    apply:
  </p>
  <!-- get the default abbreviations out of the abbreviations_default.xml
       database -->
  <xsl:variable name="abbr_inc" select="document('../data/basic/abbreviations_default.xml')/abbreviations"/>
  
  <xsl:variable name="abbrevs">
    <abbrevs>
      <xsl:apply-templates select="$abbr_inc/abbreviation.inc" mode="abbr_node"/>
      <xsl:apply-templates select="/module/abbreviations" mode="abbr_node"/>  
    </abbrevs>
  </xsl:variable>
  <!--
  <table width="80%">
    <xsl:apply-templates 
      select="document('../data/basic/abbreviations_default.xml')/abbreviations/abbreviation.inc"/>    
    <xsl:apply-templates select="/module/abbreviations" mode="output"/>    
  </table> -->

  <table width="80%">
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="abbrevs_nodes" select="msxsl:node-set($abbrevs)"/>
        <xsl:apply-templates select="$abbrevs_nodes/abbrevs/*">
          <xsl:sort select="@acronym"/>
        </xsl:apply-templates> 
      </xsl:when>

      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="abbrevs_nodes" select="exslt:node-set($abbrevs)"/>
        <xsl:apply-templates select="$abbrevs_nodes/abbrevs/*">
          <xsl:sort select="@acronym"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </table>
</xsl:template>

<xsl:template match="abbreviation.inc"  mode="abbr_node">
  <xsl:variable name="ref" select="@linkend"/>
  <xsl:variable 
    name="abbrev" 
    select="document('../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$ref]"/>
  <xsl:if test="$abbrev">
    <abbreviation.inc>
      <xsl:attribute name="acronym">
        <xsl:value-of select="normalize-space($abbrev/acronym)"/>
      </xsl:attribute>
      <xsl:attribute name="linkend">
        <xsl:value-of select="$ref"/>
      </xsl:attribute>
    </abbreviation.inc>
  </xsl:if>
</xsl:template>

<xsl:template match="abbreviation"  mode="abbr_node">
  <abbreviation>
    <xsl:attribute name="acronym">
      <xsl:value-of select="normalize-space(./acronym)"/>
    </xsl:attribute>   
    <xsl:copy-of select="*"/>
  </abbreviation>
</xsl:template>

  

<!-- Output the standard set of abbreviations and then any added by
     the module
     -->
<xsl:template match="abbreviations" mode="output">
  <!-- output any abbreviations defined in the module-->
  <xsl:apply-templates select="/module/abbreviations/abbreviation"/>

  <!-- output any abbreviations defined in the module-->
  <xsl:apply-templates select="/module/abbreviations/abbreviation.inc"/>
</xsl:template>

<!-- get the abbreviations out of the abbreviations.xml database -->
<xsl:template match="abbreviation.inc">
  <xsl:variable name="ref" select="@linkend"/>
  <xsl:variable 
    name="abbrev" 
    select="document('../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$ref]"/>
  <xsl:choose>
    <xsl:when test="$abbrev">
      <xsl:apply-templates select="$abbrev"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error 9: abbreviation.inc ',$ref, 'not found: ')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<!-- output the abbreviation. The term is defined in the normative
     references -->
<xsl:template match="abbreviation">
  <tr>
    <td>
      <xsl:value-of select="acronym"/>
    </td>
    <td>
      <xsl:apply-templates select="./term" mode="abbreviation"/>
      <xsl:apply-templates select="term.ref" mode="abbreviation"/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="term.ref" mode="abbreviation">
  <xsl:variable name="termref" select="./@linkend"/>
  <xsl:variable name="normref" select="./@normref"/>
  <xsl:variable 
    name="term"
    select="document('../data/basic/normrefs.xml')/normref.list/normref/term[@id=$termref]"/>
  <xsl:choose>
    <xsl:when test="$term">
      <xsl:value-of select="normalize-space($term)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error 10: term.ref ',$termref, 'not found: ')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="term" mode="abbreviation">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>


<xsl:template match="term">
  <xsl:variable name="nterm" select="normalize-space(.)"/>
  <a name="term-{$nterm}">
    <xsl:value-of select="$nterm"/>
  </a>
  <xsl:apply-templates select="../synonym"/>
</xsl:template>

<xsl:template match="synonym">
  <xsl:text>;&#160;</xsl:text>
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>


<!-- output the normative references, terms, definitions and abbreviated terms -->
<xsl:template name="output_terms">
  <xsl:param name="module_number"/>

  <!-- output any issues -->
  <xsl:apply-templates select="." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'definition'"/>
  </xsl:apply-templates>

  <!-- get a list of normative references that have terms defined -->
  <xsl:variable name="normrefs">
    <xsl:call-template name="normrefs_terms_list"/>
  </xsl:variable>

  <!-- output the included terms -->
  <xsl:call-template name="output_normrefs_terms_rec">
    <xsl:with-param name="normrefs" select="$normrefs"/>
    <xsl:with-param name="normref_ids" select="$normrefs"/>
    <xsl:with-param name="section" select="0"/>
    <xsl:with-param name="module_number" select="$module_number"/>
  </xsl:call-template>

  <xsl:variable name="def_section">
    <xsl:call-template name="length_normrefs_list">
      <xsl:with-param name="module_number" select="$module_number"/>
      <xsl:with-param name="normrefs_list" select="$normrefs"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- output any definitions defined in this module -->
  <xsl:if test="/module/definition">
    <!-- output the section head first -->
    <xsl:call-template name="output_module_term_section">
      <xsl:with-param name="module" select="/module"/>
      <xsl:with-param name="section" select="concat('3.1.',$def_section+1)"/>
    </xsl:call-template>
    For the purposes of this document, 
    the following terms and definitions apply:
  </xsl:if>

  <!-- increment the section number depending on whether a definition
       section has been output -->
  <xsl:variable name="def_section1">
    <xsl:choose>
      <xsl:when test="/module/definition">
        <xsl:value-of select="$def_section+1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$def_section"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:apply-templates select="/module/definition">
    <xsl:with-param name="section" select="concat('3.1.',$def_section1)"/>
    <xsl:sort select="term"/>
  </xsl:apply-templates>

  <xsl:call-template name="output_abbreviations">
    <xsl:with-param name="section" select="$def_section1+1"/>
  </xsl:call-template>
</xsl:template>


<!-- Given a list of normative references, output any terms from them -->
<xsl:template name="output_normrefs_terms_rec">
  <xsl:param name="normrefs"/>
  <xsl:param name="normref_ids"/>
  <xsl:param name="section"/>
  <xsl:param name="module_number"/>
  <xsl:param name="current_module"/>

  <xsl:choose>
    <xsl:when test="$normrefs">

      <xsl:variable 
        name="first"
        select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable 
        name="section_no"
        select="$section+1"/>
      <xsl:variable 
        name="rest"
        select="substring-after(substring-after($normrefs,','),',')"/>      

      <xsl:choose>
        <xsl:when test="contains($first,'normref:')">
          <xsl:variable 
            name="ref" 
            select="substring-after($first,'normref:')"/>
          <xsl:variable 
            name="normref"
            select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]"/>

          <!-- get the number of the standard -->      
          <xsl:variable name="stdnumber" 
            select="concat($normref/stdref/orgname, ' ',$normref/stdref/stdnumber)"/>

          <!-- output the section header for the normative reference that is
               defining terms 
               IGNORE if the normative ref is referring to this module
               -->
          <!-- normref stdnumber are 10303-1107 whereas module numbers are
               1107, so remove the 10303- -->
          <xsl:variable name="part_no" 
            select="substring-after($normref/stdref/stdnumber,'-')"/>
          <xsl:if test="$module_number!=$part_no">
            <h2>
            <xsl:value-of select="concat('3.1.',$section_no,
                                  ' Terms defined in ',$stdnumber)"/>
            </h2>
            <p>
              <!-- RBN Changed due to request from ISO
                   For the purposes of this part of ISO 10303, -->
              For the purposes of this document,
              the following terms defined in 
              <xsl:value-of select="$stdnumber"/>
              apply:
            </p>
            <ul>
              <!-- now output the terms -->
              <xsl:apply-templates 
                select="document('../data/basic/normrefs_default.xml')/normrefs/normref.inc[@normref=$ref]/term.ref" mode="normref">
                <xsl:with-param name="current_module" select="$current_module"/>
              </xsl:apply-templates>
              <!-- check to see if any terms from the same normref are 
                   identified in module -->
              <xsl:apply-templates 
                select="/module/normrefs/normref.inc[@normref=$ref]/term.ref"
                mode="normref"/>
              <xsl:apply-templates 
                select="/module/normrefs/normref.inc"
                mode="normref_check">
                <xsl:with-param name="module_number" select="$part_no"/>
                <xsl:with-param name="current_module" select="$current_module"/>
              </xsl:apply-templates>

            </ul>
          </xsl:if>
        </xsl:when>
          
        <!-- a term defined in another module -->
        <xsl:when test="contains($first,'module:')">
          <xsl:variable 
            name="module" 
            select="substring-after($first,'module:')"/>

          <xsl:variable name="module_dir">
            <xsl:call-template name="module_directory">
              <xsl:with-param name="module" select="$module"/>
            </xsl:call-template>
          </xsl:variable>


          <xsl:variable name="module_ok">
            <xsl:call-template name="check_module_exists">
              <xsl:with-param name="module" select="$module"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$module_ok='true'">
              <xsl:variable name="module_xml" 
                select="concat($module_dir,'/module.xml')"/>
              <xsl:variable name="normrefid"
                select="concat('10303-',document($module_xml)/module/@part)"/>
              
              <!-- check to see if the terms for the module have been output
                   as part of normative references -->
              <xsl:if test="not(contains($normref_ids,$normrefid))">
                <xsl:variable name="module_node" select="document($module_xml)/module"/>
                <xsl:variable name="stdnumber"
                  select="concat('ISO/',$module_node/@status,'&#160;10303-',$module_node/@part)"/>

                
                <!-- output the section header for the normative reference
                     that is defining terms -->              
                <h2>
                  <xsl:value-of select="concat('3.',$section_no,
                                        ' Terms defined in ', $stdnumber)"/>
                </h2>
                <p>
              <!-- RBN Changed due to request from ISO
                  For the purposes of this part of ISO 10303, -->              
                  For the purposes of this document,
                  the following terms defined in 
                  <xsl:value-of select="$stdnumber"/>
                  apply:
                </p>
                <ul>
                  <!-- now output the terms -->
                  <xsl:apply-templates 
                    select="/module/normrefs/normref.inc[@module.name=$module]/term.ref" 
                    mode="module"/>
                </ul>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of select="concat('Error ref 2: ',
$module_ok,' Check the normatives references')"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="contains($first,'resource:')">
          <xsl:variable 
            name="resource" 
            select="substring-after($first,'resource:')"/>
          <!-- should never get here -->
        </xsl:when>
      </xsl:choose>

      <xsl:call-template name="output_normrefs_terms_rec">
        <xsl:with-param name="normrefs" select="$rest"/>
        <xsl:with-param name="normref_ids" select="$normref_ids"/>
        <xsl:with-param name="section" select="$section_no"/>
        <xsl:with-param name="module_number" select="$module_number"/>
        <xsl:with-param name="current_module" select="$current_module"/>
      </xsl:call-template>

    </xsl:when>
    <xsl:otherwise>
      <!-- end of recursion -->
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- build a list of normrefs that are used by the module and have terms
     defined in them 
     The list comprises:
     All default normrefs listed in ../data/basic/normrefs.xml
     All normrefs explicitly included in the module by normref.inc
-->
<xsl:template name="normrefs_terms_list">

  <!-- get all default normrefs listed in ../data/basic/normrefs.xml -->
  <xsl:variable name="normref_list1">
    <xsl:call-template name="get_normref_term">
      <xsl:with-param 
        name="normref_nodes" 
        select="document('../data/basic/normrefs_default.xml')/normrefs/normref.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="''"/>
    </xsl:call-template>    
  </xsl:variable>

  <!-- get all normrefs explicitly included in the module by normref.inc -->
  <xsl:variable name="normref_list2">
    <xsl:call-template name="get_normref_term">
      <xsl:with-param 
        name="normref_nodes" 
        select="/module/normrefs/normref.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list1"/>
    </xsl:call-template>    
  </xsl:variable>

  <!-- get all normrefs that define terms for which abbreviations are
       provided.
       Get the abbreviation.inc from abbreviations_default.xml, 
       get the referenced abbreviation from abbreviations.xml
       then get the normref in which the term is defined

  <xsl:variable name="normref_list3">
    <xsl:call-template name="get_normrefs_from_abbr">
      <xsl:with-param 
        name="abbrvinc_nodes" 
        select="document('../data/basic/abbreviations_default.xml')/abbreviations/abbreviation.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list2"/>
    </xsl:call-template>    
  </xsl:variable>

  <xsl:message>
    l3:<xsl:value-of select="$normref_list3"/>:l3
  </xsl:message>
  -->

  <xsl:value-of select="concat($normref_list2,',')"/>

</xsl:template>


<!-- given a list of normref nodes, add the ids of the normrefs to the
     normref_list, if not already a member. ids in normref_list are
     separated by a , -->
<xsl:template name="get_normref_term">
  <xsl:param name="normref_nodes"/>
  <xsl:param name="normref_list"/>
  
  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$normref_nodes">
        <xsl:choose>
          <xsl:when test="$normref_nodes[1]/term.ref">
            <!-- only add the normref if it is defining terms -->
            <xsl:variable name="first">
              <xsl:choose>
                <xsl:when test="$normref_nodes[1]/@normref">
                  <xsl:value-of 
                    select="concat('normref:',$normref_nodes[1]/@normref)"/>
                </xsl:when>
                <xsl:when test="$normref_nodes[1]/@module.name">
                  <xsl:value-of 
                    select="concat('module:',$normref_nodes[1]/@module.name)"/>
                </xsl:when>            
                <xsl:when test="$normref_nodes[1]/@resource.name">
                  <xsl:value-of 
                    select="concat('module:',$normref_nodes[1]/@resource.name)"/>
                </xsl:when>            
              </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="normref_list1">
              <xsl:call-template name="add_normref">
                <xsl:with-param name="normref" select="$first"/>
                <xsl:with-param name="normref_list" select="$normref_list"/>
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:call-template name="get_normref_term">
              <xsl:with-param 
                name="normref_nodes" 
                select="$normref_nodes[position()!=1]"/>
              <xsl:with-param 
                name="normref_list" 
                select="$normref_list1"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="get_normref_term">
              <xsl:with-param 
                name="normref_nodes" 
                select="$normref_nodes[position()!=1]"/>
              <xsl:with-param 
                name="normref_list" 
                select="$normref_list"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- end of recursion -->
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$normref_list_ret"/>
</xsl:template>


<!-- Given the name of a module, check if there is a corresponding
     normative reference there. If so, remove it. -->
<xsl:template name="remove_module_from_normrefs_list">
  <xsl:param name="normrefs_list"/>
  <xsl:param name="module_number"/>

  <xsl:variable name="nref" 
    select="concat(',normref:ref10303-',$module_number)"/>

  <xsl:variable name="pruned_normrefs_list">
    <xsl:choose>
      <xsl:when test="contains($normrefs_list,$nref)">
        <xsl:variable 
          name="before" 
          select="substring-before($normrefs_list,$nref)"/>
        <xsl:variable 
          name="after" 
          select="substring-after(substring-after($normrefs_list,$nref),',')"/>
        <xsl:value-of select="concat($before,$after)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$normrefs_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$pruned_normrefs_list"/>
</xsl:template>

<!-- return the number of normrefs in the list -->
<xsl:template name="length_normrefs_list">
  <xsl:param name="normrefs_list"/>
  <xsl:param name="module_number"/>
  <!-- check if the current module is included.
       If so, remove the reference -->
  <xsl:variable name="pruned_normrefs_list">
    <xsl:call-template name="remove_module_from_normrefs_list">
      <xsl:with-param name="normrefs_list" select="$normrefs_list"/>
      <xsl:with-param name="module_number" select="$module_number"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="section1">
    <xsl:call-template name="count_substring">
      <xsl:with-param name="substring" select="','"/>
      <xsl:with-param name="string" select="$pruned_normrefs_list"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="floor($section1 div 2)"/>
</xsl:template>


<!-- output the section header for terms defined in a module -->
<xsl:template name="output_module_term_section">
  <xsl:param name="module"/>
  <xsl:param name="section"/>
  
  <xsl:variable name="stdnumber" 
    select="concat('ISO/',$module/@status,'&#160;10303-',$module/@part)"/>


  <h2>
    <xsl:value-of select="concat($section,' Other terms and definitions')"/>
    <!--
    <xsl:value-of select="concat($section,' Terms defined in',$stdnumber)"/>
    -->
</h2>
  </xsl:template>


  <xsl:template match="term.ref" mode="module">
    <xsl:variable name="module" select="../@module.name"/>

    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_xml" 
      select="concat($module_dir,'/module.xml')"/>

    <xsl:choose>
      <xsl:when test="$module_ok='true'">
        <xsl:variable 
          name="ref"
          select="@linkend"/>
        <xsl:variable 
          name="term"
          select="document($module_xml)/module/definition/term[@id=$ref]"/>
        <!-- note any synonym is ignored -->
        <xsl:choose>
          <xsl:when test="$term">
            <xsl:variable name="nterm" select="normalize-space($term)"/>
            <xsl:choose>
              <xsl:when test="position()=last()">
                <li><xsl:value-of select="$nterm"/>.</li>
              </xsl:when>
              <xsl:otherwise>
                <li><xsl:value-of select="$nterm"/>;</li>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <li>
              <xsl:call-template name="error_message">
                <xsl:with-param 
                  name="message"
                  select="concat('Error 11: Can not find term referenced by: ',$ref)"/>
              </xsl:call-template>
            </li>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of select="concat('Error ref1: ', $module_ok)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- output any terms that are defined in normref.inc that is referring
       to a module through @module.name where the module has the same
       number as module_number -->
  <xsl:template match="normref.inc"  mode="normref_check">
    <xsl:param name="module_number"/>
    <xsl:variable name="module" select="@module.name"/>

    <xsl:if test="string-length($module)>0">
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
          <xsl:variable name="module_xml" 
            select="concat($module_dir,'/module.xml')"/>
          <xsl:variable name="part"
            select="document($module_xml)/module/@part"/>
          <xsl:if test="$part=$module_number">
            <xsl:apply-templates select="term.ref" mode="module"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ref 3: ', $module_ok,
                                    'Check the normatives references: ')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="term.ref"  mode="normref">
    <xsl:variable 
      name="ref"
      select="@linkend"/>
    <xsl:variable 
      name="term"
      select="document('../data/basic/normrefs.xml')/normref.list/normref/term[@id=$ref]"/>
    <xsl:choose>
      <xsl:when test="$term">
        <xsl:choose>
          <xsl:when test="position()=last()">
            <li><xsl:apply-templates select="$term"/>.</li>
          </xsl:when>
          <xsl:otherwise>
            <li><xsl:apply-templates select="$term"/>;</li>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <li><xsl:call-template name="error_message">
            <xsl:with-param 
              name="message"
              select="concat('Error 12: Can not find term referenced by: ',$ref)"/>
          </xsl:call-template>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="definition">
    <xsl:param name="section"/>
    <h4>
      <!-- <xsl:value-of select="$section"/>.<xsl:number/><br/> -->
      <xsl:value-of select="concat($section,'.',position())"/><br/> 
      <xsl:apply-templates select="term"/>
    </h4>
    <xsl:apply-templates select="def"/>
  </xsl:template>
  
  <xsl:template match="def">
    <xsl:apply-templates select="." mode="check_phrase"/> 
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="refdata" >
    <xsl:apply-templates select="*[name(.)!='refdata_subclause']" />

    <!-- refdata with sub-clauses -->
    <xsl:for-each select="./refdata_subclause">		
      <xsl:variable name="sect_no">
      	<xsl:number/>
      </xsl:variable>
      <xsl:apply-templates select=".">
	<xsl:with-param name="sect_no" select="$sect_no" />
      </xsl:apply-templates>
    </xsl:for-each>

    <!-- output any issues -->
    <xsl:apply-templates select=".." mode="output_clause_issue">
      <xsl:with-param name="clause" select="'refdata'"/>
    </xsl:apply-templates>

  </xsl:template>

<xsl:template match="refdata_subclause">
<!-- sub-level of refdata sub-clauses -->

    <xsl:param name="sect_no"/>
		
		<xsl:variable name="title">
		<xsl:value-of select="@title"/>
		</xsl:variable>
	
		<A name="{$title}"><h2><xsl:value-of select="concat('6.',$sect_no,' ')"/>
			<xsl:value-of select="@title"/></h2></A>

    <xsl:apply-templates select="*[not(name(.)='refdata_subclause')]" />
			
			<xsl:variable name="sect_sup">
		<xsl:value-of select="concat('6.',$sect_no,'.')"/>
			</xsl:variable>

 
			<xsl:for-each select="./refdata_subclause">	
						<xsl:variable name="sect_nos">
						<xsl:number/>
						</xsl:variable>
	
			<xsl:variable name="subtitle">
			<xsl:value-of select="@title"/>
			</xsl:variable>
									
						<A name="{$subtitle}"><h2>
						<xsl:value-of select="concat($sect_sup,$sect_nos,' ')"/>
						<xsl:value-of select="@title"/></h2></A>

			      <xsl:apply-templates/>
				</xsl:for-each>

</xsl:template>	













	
	
  <xsl:template match="usage_guide" >
    <xsl:apply-templates select="*[name(.)!='guide_subclause']" />

    <!-- usage guide with sub-clauses -->
    <xsl:for-each select="./guide_subclause">		
      <xsl:variable name="sect_no">
	<xsl:number/>
      </xsl:variable>
      <xsl:apply-templates select=".">
	<xsl:with-param name="sect_no" select="$sect_no" />
      </xsl:apply-templates>
    </xsl:for-each>

    <!-- output any issues -->
    <xsl:apply-templates select=".." mode="output_clause_issue">
      <xsl:with-param name="clause" select="'usage_guide'"/>
    </xsl:apply-templates>


  </xsl:template>




<xsl:template match="guide_subclause">
<!-- sub-level of usage guide sub-clauses -->

    <xsl:param name="sect_no"/>
		
		<xsl:variable name="title">
		<xsl:value-of select="@title"/>
		</xsl:variable>
	
		<A name="{$title}"><h2><xsl:value-of select="concat('F.',$sect_no,' ')"/>
			<xsl:value-of select="@title"/></h2></A>

    <xsl:apply-templates select="*[not(name(.)='guide_subclause')]" />
			
			<xsl:variable name="sect_sup">
		<xsl:value-of select="concat('F.',$sect_no,'.')"/>
			</xsl:variable>

 
			<xsl:for-each select="./guide_subclause">	
						<xsl:variable name="sect_nos">
						<xsl:number/>
						</xsl:variable>
	
			<xsl:variable name="subtitle">
			<xsl:value-of select="@title"/>
			</xsl:variable>
									
						<A name="{$subtitle}"><h4>
						<xsl:value-of select="concat($sect_sup,$sect_nos,' ')"/>
						<xsl:value-of select="@title"/></h4></A>

			      <xsl:apply-templates/>
				</xsl:for-each>

</xsl:template>	

	
<xsl:template match="express-g">
    <xsl:apply-templates select="imgfile|img" mode="expressg"/>
</xsl:template>

<xsl:template match="imgfile" mode="expressg">
  <xsl:variable name="file">
    <xsl:call-template name="set_file_ext">
      <xsl:with-param name="filename" select="@file"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="href" select="concat('../',$file)"/>
  <p>
    <a href="{$href}">
      <xsl:apply-templates select="." mode="title"/>
    </a>
  </p>
</xsl:template>

<xsl:template match="imgfile" mode="title">
  <xsl:variable name="number">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="total">
    <xsl:value-of select="count(../imgfile)-1"/>
  </xsl:variable>
  <xsl:variable name="fig_no">
    <xsl:choose>
      <xsl:when test="name(../..)='arm'">
        <xsl:choose>
          <xsl:when test="$number=1">
            <xsl:value-of 
              select="concat('Figure C.',$number, 
                      ' &#8212; ARM schema level EXPRESS-G diagram ',$number,' of 1')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure C.',$number, 
                      ' &#8212; ARM entity level EXPRESS-G diagram ',($number - 1),' of ',$total)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="name(../..)='mim'">
        <xsl:choose>
          <xsl:when test="$number=1">
            <xsl:value-of 
              select="concat('Figure D.',$number, 
                      ' &#8212; MIM schema level EXPRESS-G diagram ',$number,' of 1')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure D.',$number, 
                      ' &#8212; MIM entity level EXPRESS-G diagram ',($number - 1),' of ',$total)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$fig_no"/>
</xsl:template>

  <xsl:template match="bibliography" mode="old">
   
    <xsl:apply-templates select="./*">
      <xsl:with-param name="number_start" select="0"/>
    </xsl:apply-templates>
    
    <!-- 
      count how many bitiem
      and start the numbering of the bibitem from there
    -->
    <xsl:variable name="bibitem_cnt" 
      select="count(./*)"/>
    
    <!-- output the defaults -->
    <xsl:if test="not(@output_default='no')">
      <xsl:apply-templates
        select="document('../data/basic/bibliography_default.xml')/bibliography/bibitem.inc">
        <xsl:with-param name="number_start" select="$bibitem_cnt"/>
      </xsl:apply-templates>
    </xsl:if>
    
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




<!-- check that all of the modules that are used in the ARM are used in the
     MIM 
     -->
<xsl:template match="schema" mode="check_mim_usefroms">
  <xsl:variable name="mim_interfaces" select="./interface"/>
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- iterate through each used ARM and check if there is a mim 
       Note - only compares USE FROMs -->
  <xsl:for-each
    select="document(concat($module_dir,'/arm.xml'))/express/schema/interface[@kind='use']">
    <xsl:variable name="used_mim"
      select="concat(substring-before(concat(@schema,' '),'_arm'),'_mim')"/>
    <xsl:if test="not($mim_interfaces[@schema=$used_mim])">
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message"
          select="concat('MIM USE FROM error 14: ', @schema, ' used in ARM so expect ',$used_mim,' to be used in MIM')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:for-each>

</xsl:template>

</xsl:stylesheet>
