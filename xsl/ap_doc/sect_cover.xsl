<?xml version="1.0" encoding="utf-8"?>

<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--

$Id: sect_cover.xsl,v 1.16 2012/10/29 16:38:09 mikeward Exp $

  Author:  Mike Ward, Rob Bodington, Eurostep Limited

  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.

  Purpose: Display the main set of frames for an AP document.     

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">



  <xsl:import href="application_protocol.xsl"/>

  <xsl:import href="application_protocol_clause_nofooter.xsl"/>

  <xsl:import href="../common.xsl"/>

  

  <xsl:output method="html"/>

	

	

  <xsl:template match="application_protocol">

    <xsl:apply-templates select="." mode="coverpage"/>

  </xsl:template>







<xsl:template match="application_protocol" mode="coverpage">

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



  <xsl:variable name="wg_group" select="3"/>

  <xsl:variable name="n_number"

    select="concat('ISO/TC 184/SC 4/WG ',$wg_group,'&#160;N',./@wg.number)"/>

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

            <xsl:call-template name="test_wg_number">

              <xsl:with-param name="wgnumber" select="./@wg.number.supersedes"/>

            </xsl:call-template>

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

    <xsl:call-template name="protocol_display_name">

      <xsl:with-param name="application_protocol" select="@title"/>

    </xsl:call-template>

  </xsl:variable>

    

  <xsl:variable name="stdnumber">

    <xsl:call-template name="get_protocol_stdnumber">

      <xsl:with-param name="application_protocol" select="."/>

    </xsl:call-template>

  </xsl:variable>
  
  <h4>

    <xsl:value-of select="$stdnumber"/><br/>

    Product data representation and exchange: Application protocol: 

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

      <h3><a name="copyright">COPYRIGHT NOTICE:</a></h3>

        <xsl:choose>

          <xsl:when test="$status='CD'">

            <p>

              This ISO document is a Committee Draft and is copyright protected by ISO. While the

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

                phone: +1-212-642-4900<br/>

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

          <xsl:when test="$status='FDIS'">

            Final Draft International Standard

          </xsl:when>



          <xsl:when test="$status='DIS'">

            <p>

              This ISO document is a Draft International Standard and is

              copyright-protected by ISO. Except as permitted under the applicable laws

              of the user's country, neither this ISO draft nor any extract

              from it may be reproduced, stored in a retrieval system or

              transmitted in any form or by any means, electronic, photocopying,

              recording, or otherwise, without prior written permission being

              secured.

            </p>

            <p>

              Requests for permission to reproduce should be addressed to

              ISO at the address below or ISO's member body in the country

              of the requester:

            </p>

            <div align="center">

              ISO copyright office<br/>

              Case postale 56. CH-1211 Geneva 20<br/>

              Tel. + 41 22 749 01 11<br/>

              Fax + 41 22 734 10 79<br/>

              E-mail copyright@iso.ch<br/>

            </div>

            <p>

              Reproduction for sales purposes for any of the above-mentioned documents may be subject to royalty

              payments or a licensing agreement.

            </p>

            <p>

              Violators may be prosecuted.

            </p>

          </xsl:when>



          <xsl:when test="$status='IS'">

All rights reserved. Unless otherwise specified, no part of this publication may be reproduced or utilized in any form or by any means, electronic or mechanical, including photocopying and microfilm, without permission in writing from either ISO at the address below or ISO's member body in the country of the requester.

            <div align="center">

              ISO copyright office<br/>

              Case postale 56. CH-1211 Geneva 20<br/>

              Tel. + 41 22 749 01 11<br/>

              Fax + 41 22 749 09 47<br/>

              E-mail copyright@iso.ch<br/>

              Web  www.iso.org<br/>

              Published in Switzerland<br/>                

            </div>

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

                phone: +1-212-642-4900<br/>

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

              Tel. +41 22 749 01 11<br/>

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

      <xsl:apply-templates select="." mode="abstract" />

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



      <xsl:variable name="ballot_cycle_or_pub">

        <xsl:choose>

          <xsl:when test="$status='IS'">

            publication

          </xsl:when>

          <xsl:otherwise>

            this ballot cycle

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>

  

      <xsl:if test="$status='CD-TS' or $status='DIS'">

        <p>

          Recipients of this draft are invited to submit, with their comments,

          notification of any relevant patent rights of which they are aware and to

          provide supporting documentation.

        </p>

      </xsl:if>



      This document has been reviewed using the internal review checklist 

      (see <xsl:value-of select="concat('WG',$wg_group,'&#160;N',@checklist.internal_review)"/>),

      <!-- test the checklist WG number for checklist.internal_review -->

      <xsl:variable name="test_cl_internal_review">

        <xsl:call-template name="test_wg_number">

          <xsl:with-param name="wgnumber" select="./@checklist.internal_review"/>

        </xsl:call-template>

      </xsl:variable>

      <xsl:if test="contains($test_cl_internal_review,'Error')">

        <p>

          <xsl:call-template name="error_message">

            <xsl:with-param name="message">

              <xsl:value-of 

                select="concat('Error in

                        module.xml/module/@checklist.internal_review - ', 

                        $test_cl_internal_review)"/>

            </xsl:with-param>

          </xsl:call-template>

        </p>

      </xsl:if>





      the project leader checklist 

      (see <xsl:value-of

      select="concat('WG',$wg_group,'&#160;N',@checklist.project_leader)"/>),



      <!-- test the checklist WG number for checklist.project_leader -->

      <xsl:variable name="test_cl_project_leader">

        <xsl:call-template name="test_wg_number">

          <xsl:with-param name="wgnumber" select="./@checklist.project_leader"/>

        </xsl:call-template>

      </xsl:variable>

      <xsl:if test="contains($test_cl_project_leader,'Error')">

        <p>

          <xsl:call-template name="error_message">

            <xsl:with-param name="message">

              <xsl:value-of 

                select="concat('Error in

                        module.xml/module/@checklist.project_leader - ', 

                        $test_cl_project_leader)"/>

            </xsl:with-param>

          </xsl:call-template>

        </p>

      </xsl:if>



      and the convener checklist

      (see <xsl:value-of select="concat('WG',$wg_group,'&#160;N',@checklist.convener)"/>),



      <!-- test the checklist WG number for checklist.convener -->

      <xsl:variable name="test_cl_convener">

        <xsl:call-template name="test_wg_number">

          <xsl:with-param name="wgnumber" select="./@checklist.convener"/>

        </xsl:call-template>

      </xsl:variable>

      <xsl:if test="contains($test_cl_convener,'Error')">

        <p>

          <xsl:call-template name="error_message">

            <xsl:with-param name="message">

              <xsl:value-of 

                select="concat('Error in

                        module.xml/module/@checklist.convener - ', 

                        $test_cl_convener)"/>

            </xsl:with-param>

          </xsl:call-template>

        </p>

      </xsl:if>

      and is ready for 

      <xsl:value-of select="normalize-space($ballot_cycle_or_pub)"/>.



      <xsl:if test="$confirmatory_ballot='YES'">

	<p>

	  This document is being submitted for a confirmatory 

<xsl:value-of select="$status" /> ballot in accordance with clause 2.5 of the SC4 Handbook (SC4 N1620)

	</p>

      </xsl:if>

      <xsl:variable name="dvlp_fldr" select="@development.folder"/>

      <xsl:if test="string-length($dvlp_fldr)>0">

        <xsl:variable name="seds" 

          select="document(concat('../../data/application_protocols/',@name,'/dvlp/issues.xml'))/issues/issue[@seds='yes' and @status='closed']"/>

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



<xsl:template match="projlead">

  <xsl:variable name="ref" select="@ref"/>

  <xsl:variable name="projlead" select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>

  <b>

    Project leader: 

  </b>

  <xsl:choose>

    <xsl:when test="$projlead">

      <xsl:apply-templates select="$projlead"/>

    </xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="message">

          Error 1: No contact provided for project leader.

        </xsl:with-param>

      </xsl:call-template>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template match="editor">

  <xsl:variable name="ref" select="@ref"/>

  <xsl:variable name="editor" select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>

  <b>

    Project editor: 

  </b>

  <xsl:choose>

    <xsl:when test="$editor">

      <xsl:apply-templates select="$editor"/>

    </xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="message">

          Error 2: No contact provided for project editor.

        </xsl:with-param>

      </xsl:call-template>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>







<xsl:template match="issue" mode="seds_cover">

  <xsl:value-of select="concat(@id,' ')"/>

</xsl:template>



</xsl:stylesheet>

