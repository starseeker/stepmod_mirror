<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_isocover.xsl,v 1.23 2013/02/07 10:42:11 mikeward Exp $
   Author:  Rob Bodington, Eurostep Limited
   Owner:   Developed by Eurostep Limited http://www.eurostep.com and supplied to NIST under contract.
   Purpose: To output the cover page for a published module.
     copied from pub_isocover
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="exslt"
  version="1.0">
  
  <xsl:import href="ap_doc/common.xsl"/>
  <xsl:import href="res_doc/common.xsl"/>
  <xsl:import href="bom_doc/common.xsl"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


  <!-- 
     This parameter is passed in from ANT build where it is read from publication_index.xml
       -->
  <xsl:param name="SECRETARIAT" select="'ANSI'"/>

  <!-- 
     This parameter is passed in from ANT build where it is read from publication_index.xml
       -->
  <xsl:param name="VOTE_START"/>

  <!-- 
     This parameter is passed in from ANT build where it is read from publication_index.xml
       -->
  <xsl:param name="VOTE_END"/>

  <xsl:template match="/" >
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="application_protocol_clause">
    <!-- the XML file to which the stylesheet will be applied 
         NOTE: that the path used by document is relative to the directory
         of this xsl file
         -->
    <xsl:variable 
      name="apdoc_xml"
      select="document(concat('../data/application_protocols/',@directory,'/application_protocol.xml'))"/>
    <!-- now apply the stylesheet specified in the document -->
    <xsl:apply-templates select="$apdoc_xml/application_protocol"/>

  </xsl:template>
  
  <xsl:template match="business_object_model_clause">
    <!-- the XML file to which the stylesheet will be applied 
      NOTE: that the path used by document is relative to the directory
      of this xsl file
    -->
    <xsl:variable 
      name="bomdoc_xml"
      select="document(concat('../data/business_object_models/',@directory,'/business_object_model.xml'))"/>
    <!-- now apply the stylesheet specified in the document -->
    <xsl:apply-templates select="$bomdoc_xml/business_object_model"/>    
  </xsl:template>

  <xsl:template match="resource_clause">
    <!-- the XML file to which the stylesheet will be applied 
         NOTE: that the path used by document is relative to the directory
         of this xsl file
         -->
    <xsl:variable 
      name="resdoc_xml"
      select="document(concat('../data/resource_docs/',@directory,'/resource.xml'))"/>
    <!-- now apply the stylesheet specified in the document -->
    <xsl:apply-templates select="$resdoc_xml/resource"/>

  </xsl:template>

  <xsl:template match="module_clause">
    <!-- the XML file to which the stylesheet will be applied 
         NOTE: that the path used by document is relative to the directory
         of this xsl file
         -->
    <xsl:variable 
      name="module_xml"
      select="document(concat('../data/modules/',@directory,'/module.xml'))"/>
    <!-- now apply the stylesheet specified in the document -->
    <xsl:apply-templates select="$module_xml/module"/>
  </xsl:template>
  

  <xsl:template match="module|application_protocol|resource|business_object_model">
    <HTML>
      <HEAD>
        <xsl:apply-templates select="." mode="meta_data"/>
        <TITLE>
          <!-- output the part page title -->
          <xsl:apply-templates 
            select="."
            mode="title"/>
        </TITLE>
      </HEAD>
        <BODY>
          <p align="center">
            <img  src="../../../../images/isologo.gif" alt="ISO logo"/>
          </p>

          <xsl:variable name="status_words">
            <xsl:choose>
              <xsl:when test="@status='FDIS'">
                FINAL DRAFT INTERNATIONAL STANDARD ISO
              </xsl:when>
              <xsl:when test="@status='DIS'">
                DRAFT INTERNATIONAL STANDARD ISO
              </xsl:when>
              <xsl:when test="@status='IS'">
                INTERNATIONAL STANDARD ISO
              </xsl:when>
              <xsl:when test="@status='TS'">
                TECHNICAL SPECIFICATION ISO/TS
              </xsl:when>
              <xsl:otherwise>
                Module status not for publication
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <div align="center" style="margin-top=10pt">
            <span style="font-size:16; font-family:sans-serif; font-weight:bold">
              <xsl:value-of select="concat($status_words,' 10303-',@part,':',@publication.year,'(E)')"/>
            </span>
          </div>

          <!-- English title -->
          <div align="center" style="margin-top:20pt">
            <span style="font-size:30; font-family:sans-serif; font-weight:bold">
              Industrial automation systems and integration &#8212; 
              Product data representation and exchange
            </span>
          </div>

          <!-- English part title -->
          <div align="center" style="margin-top:10pt">
            <span style="font-size:30; font-family:sans-serif;">
              Part <xsl:value-of select="@part"/>:
              <br/>
              <b>
                <xsl:apply-templates select="." mode="display_name"/>
              </b>
            </span>
          </div>
          <!-- French title -->
          <div align="center" style="margin-top:25pt">
            <span style="font-size:14; font-family:sans-serif;">
              <i>
                Syst&#232;mes d'automatisation industrielle et int&#233;gration &#8212;
                Repr&#233;sentation et &#233;change de donn&#233;es de produits
              </i>
            </span>
          </div>

          <!-- French Part title -->
          <div align="center" style="margin-top:5pt">
            <span style="font-size:14; font-family:sans-serif;">
              <i>
                Partie <xsl:value-of select="@part"/>: 
               <xsl:apply-templates select="." mode="display_name_french"/>
              </i>
            </span>
          </div>

          <xsl:variable name="this_edition">
            <xsl:choose>
              <xsl:when test="@version='1'">
                First
              </xsl:when>
              <xsl:when test="@version='2'">
                Second
              </xsl:when>
              <xsl:when test="@version='3'">
                Third
              </xsl:when>
              <xsl:when test="@version='4'">
                Fourth
              </xsl:when>
              <xsl:when test="@version='5'">
                Fifth
              </xsl:when>
              <xsl:when test="@version='6'">
                Sixth
              </xsl:when>
              <xsl:when test="@version='7'">
                Seventh
              </xsl:when>
              <xsl:when test="@version='8'">
                Eighth
              </xsl:when>
              <xsl:when test="@version='9'">
                Ninth
              </xsl:when>
              <xsl:otherwise>
                MORE THAN 9 - edit stepmod/xsl/publication/pub_iso_cover
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="previous_edition">
            <xsl:choose>
              <xsl:when test="@version='2'">
                First
              </xsl:when>
              <xsl:when test="@version='3'">
                Second
              </xsl:when>
              <xsl:when test="@version='4'">
                Third
              </xsl:when>
              <xsl:when test="@version='5'">
                Fourth
              </xsl:when>
              <xsl:when test="@version='6'">
                Fifth
              </xsl:when>
              <xsl:when test="@version='7'">
                Sixth
              </xsl:when>
              <xsl:when test="@version='8'">
                Seventh
              </xsl:when>
              <xsl:when test="@version='9'">
                Eighth
              </xsl:when>
              <xsl:when test="@version='10'">
                Ninth
              </xsl:when>
              <xsl:otherwise>
                MORE THAN 9 - edit stepmod/xsl/publication/pub_iso_cover
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>


          <!-- link to main document -->
          <div align="center" style="margin-top:30pt">
            <span style="font-size:30; font-family:sans-serif;">
              <xsl:apply-templates select="." mode="start_link"/>
              <!-- If a DIS and a second edition or more, then reference
                   previous edition -->
              <xsl:if test="@status='DIS' and @version!='1'">
                
                <br/><xsl:value-of select="concat('[Revision of ',$previous_edition, 'edition (ISO 10303-',@part,':',@previous.revision.year,')')"/>
              </xsl:if>
            </span>
          </div>

          <!-- document edition -->
          <xsl:if test="@status!='IS'">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(@publication.date))=0">
                <xsl:choose>
                  <xsl:when test="$ERROR_CHECK_ISOCOVER='YES'">
                    <xsl:call-template name="error_message">
                      
                      <xsl:with-param name="inline" select="'no'"/>
                      <xsl:with-param 
                        name="message" 
                        select="concat('Warning PD: No publication date
(@publication.date) provided for ',@name,' using @publication.year)')"/>
                    </xsl:call-template>
                    <div align="center" style="margin-top:50pt">
                      <span style="font-size:12; font-family:sans-serif;">
                        <b>
                          <xsl:value-of select="concat(normalize-space($this_edition),'&#160;edition&#160;&#160;@to_be_published@')"/>
                        </b>
                      </span>
                    </div>
                    
                </xsl:when>
                <xsl:otherwise>
                    <div align="center" style="margin-top:50pt">
                      <span style="font-size:12; font-family:sans-serif;">
                        <b>
                          <xsl:value-of select="concat(normalize-space($this_edition),'&#160;edition&#160;&#160;',@publication.year)"/>
                        </b>
                      </span>
                    </div>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <div align="center" style="margin-top:50pt">
                <span style="font-size:12; font-family:sans-serif;">
                  <b>
                    <xsl:value-of select="concat(normalize-space($this_edition),'&#160;edition&#160;&#160;',@publication.date)"/>
                  </b>
                </span>
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

          <xsl:choose>
            <xsl:when test="@status='DIS'">
              <xsl:apply-templates select="." mode="dis_copyright">
                <xsl:with-param name="stage" select="'Draft'"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="@status='FDIS'">
              <xsl:apply-templates select="." mode="dis_copyright">
                <xsl:with-param name="stage" select="'Final Draft'"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="@status='IS'">
              <xsl:apply-templates select="." mode="is_ts_copyright"/>
            </xsl:when>
            <xsl:when test="@status='TS'">
              <xsl:apply-templates select="." mode="is_ts_copyright"/>
            </xsl:when>
          </xsl:choose>
        </BODY>
    </HTML>
  </xsl:template>

  <xsl:template  name="empty_para">
    <p class="MsoNormal" align="center" style='text-align:center'>
      <span style="font-size:14.0pt;mso-bidi-font-size:12.0pt;font-family:Arial">
        &#160;
      </span>
    </p>
  </xsl:template>

  <xsl:template match="module|application_protocol|resource|business_object_model" mode="dis_copyright">
    <xsl:param name="stage" select="'Draft'"/>
      
    <!-- ICS number -->
    <div align="center" style="margin-top:30pt">
      <span style="font-size:14; font-family:sans-serif;">
        <b>ICS&#160;&#160;25.040.40</b>
        <!--
        <b>ICS&#160;&#160;##.###.##;&#160;&#160;##.###.##</b> -->
      </span>
    </div>

    <br/><br/>


    <!-- Voting table -->
    <table border="1" align="center">
      <tr style="font-size:14; font-family:sans-serif" align="center">
        <td width="200">
          ISO/TC <b>184</b>/SC&#160;<b>4</b><br/>
          Secretariat: 
            <b>
              <xsl:value-of select="$SECRETARIAT"/>
            </b>
          </td>
        <td width="200">Voting begins on:<br/><b>####-##-##</b></td>
        <td width="200">Voting terminates on:<br/><b>####-##-##</b></td> 
      </tr>
      </table>
      <br/><br/><br/>


      <table border="0" align="center">
        <tr>
          <td><br/></td>
          <td><hr/></td>
          <td><br/></td>
        </tr>
        
        <tr style="font-size:12; font-family:sans-serif" align="center">
          <td colspan="3">
            <b>
              In accordance with the provisions of Council Resolution 15/1993 this document is 
              circulated in the English language only.
            </b>
          </td>
        </tr>

        <tr style="font-size:12; font-family:sans-serif" align="center">
          <td colspan="3">
            <b>
              Conform&#233;ment aux dispositions de la R&#233;solution du Conseil 15/1993, 
              ce document est distribu&#233; en version anglaise seulement.
            </b>
          </td>
        </tr>
        <tr>
          <td><br/></td>
          <td><hr/></td>
          <td><br/></td>
        </tr>
        <tr style="font-size:12; font-family:sans-serif" align="center">
          <td colspan="3">
            <b>
              To expedite distribution, this document is circulated as received from the committee 
              secretariat.
              <br/>
              ISO Central Secretariat work of editing and text composition will be 
              undertaken at publication stage.
            </b>
          </td>
        </tr>
        
        <tr style="font-size:12; font-family:sans-serif" align="center">
          <td colspan="3">
            <b>Pour acc&#233;l&#233;rer la distribution, le pr&#233;sent document est 
            distribu&#233; tel qu'il est parvenu du secr&#233;tariat du comit&#233;.<br/>
            Le travail de r&#233;daction et de composition de texte sera effectu&#233; au
            Secr&#233;tariat central de l'ISO au stade de
            publication.</b>
          </td>
        </tr>
        <tr><td><br/></td>
        <td><hr/></td>
        <td><br/></td></tr>
        <tr style="font-size:10; font-family:sans-serif" align="center">
          <td colspan="3">
            THIS DOCUMENT IS A DRAFT CIRCULATED FOR COMMENT AND APPROVAL. IT IS THEREFORE SUBJECT 
            TO CHANGE
            <br/>
            AND MAY NOT BE REFERRED TO AS AN INTERNATIONAL STANDARD UNTIL
            PUBLISHED AS SUCH.
          </td>
        </tr>
        <tr style="font-size:10; font-family:sans-serif" align="center">
          <td colspan="3">
              IN ADDITION TO THEIR EVALUATION AS BEING ACCEPTABLE FOR INDUSTRIAL, TECHNOLOGICAL, 
              COMMERCIAL AND USER PURPOSES,
              <br/>
              DRAFT INTERNATIONAL STANDARDS MAY ON OCCASION HAVE TO BE CONSIDERED IN THE LIGHT OF 
              THEIR POTENTIAL TO BECOME
              <br/>
              STANDARDS TO WHICH REFERENCE MAY BE MADE IN NATIONAL
              REGULATIONS.
            </td>
          </tr>
          <tr>
            <td width="220"></td>
            <td width="310"></td>
            <td width="220"></td>
          </tr>
        </table>

        <hr/>

        <table border="0" align="center">
          <tr>
            <td colspan="3" align="center" valign="top">
              <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt">
                &#169;&#160;ISO&#160;<xsl:value-of select="substring(@publication.year,1,4)"/>
              </div>
              <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt">
                <a name="copyright"/>
                <b>Copyright notice</b>
              </div>
              <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt">
                This ISO document is a Draft International Standard and is copyright-protected by 
                ISO. Except as permitted under the applicable laws of the user's
                country,
                <br/>
                neither this ISO draft nor any extract from it may be reproduced, stored in a 
                retrieval system or transmitted in any form or by any means,<br/>
                electronic, photocopying, recording or otherwise, without prior written 
                permission being secured.
              </div>
              <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt">
                Requests for permission to reproduce should be addressed to either ISO at the 
                address below or ISO's member body in the country of the
                requester.
              </div>
              <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt">
                ISO copyright office
                <br/>
                Case postale 56&#160;&#160;<span style="font-family:Symbol">&#183;</span>&#160;CH-1211 Geneva 20<br/>
                Tel.&#160;&#160;+ 41 22 749 01 11<br/>
                Fax&#160;&#160;+ 41 22 749 09 47<br/>
                E-mail&#160;&#160;copyright@iso.org<br/>
                Web&#160;&#160;www.iso.org
              </div>
              <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt">
                Reproduction may be subject to royalty payments or a licensing
                agreement.
              </div>
              <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt">
                Violators may be prosecuted.
              </div>
            </td>
          </tr>
          <tr>
            <td width="220"></td><td width="310"></td><td width="220"></td>
          </tr>
        </table>
  </xsl:template>

  <xsl:template match="module|application_protocol|resource|business_object_model" mode="is_ts_copyright">
    <xsl:variable name="page_count">
              <xsl:apply-templates select="." mode="page_count"/> 
    </xsl:variable>
    <hr/>      
    <table border="0" align="center">
        <tr>
          <td width="220" valign="top">
            <span style="font-size:14; font-family:sans-serif;">
              <b>
                ICS&#160;&#160;25.040.40
              </b>
            </span>
          </td>

          <td width="310" align="center" valign="top">
            <span style="font-size:12; font-family:sans-serif;">
              &#169;&#160;&#160;&#160;ISO&#160;<xsl:value-of select="substring(@publication.year,1,4)"/>
            </span>
          </td>

          <!-- RBN - ISO no longer require price on front page - left here and commented in case
            it is needed again
           <td width="220" align="right" valign="top">
            <span style="font-size:14; font-family:sans-serif;">
              <b>Price based on <xsl:value-of select="$page_count"/>  pages</b> 
            </span>
          </td>-->
          <td width="220" align="right" valign="top">&#160;</td>          
        </tr>

        <tr>
          <td width="220"><br/></td>
          <td width="310" align="center" valign="top">
            <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt">
              <a name="copyright"/>
              All rights reserved. Unless otherwise specified, no part of this publication may be 
              reproduced or utilized in any form or by any means, electronic or mechanical, including 
              photocopying and microfilm, without permission in writing from either ISO at the address 
              below or ISO's member body in the country of the requester.
            </div>
            <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt">
              ISO copyright office<br/>
            Case postale 56&#160;&#160;<span style="font-family:Symbol">&#183;</span>&#160;CH-1211 Geneva 20<br/>
              Tel.&#160;&#160;+ 41 22 749 01 11<br/>
              Fax&#160;&#160;+ 41 22 749 09 47<br/>
              E-mail&#160;&#160;copyright@iso.org<br/>
              Web&#160;&#160;www.iso.org
            </div>
            <div style="font-size:12; font-family:sans-serif;">
              Published in Switzerland
            </div>
          </td>
          <td width="220"><br/></td></tr>
        </table>
  </xsl:template>

  <xsl:template match="module" mode="display_name">
    Application module: 
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="module" mode="display_name_french">
    <xsl:choose>
      <xsl:when test="string-length(normalize-space(@name.french))=0">
        Module d'application: 
        <xsl:choose>
          <xsl:when test="$ERROR_CHECK_ISOCOVER='YES'">
            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Error FT: No French title (module/@name.french) provided for ',@name)"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="module_display_name">
              <xsl:with-param name="module" select="@name"/>
            </xsl:call-template>  
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        Module d'application: 
        <xsl:call-template name="module_display_name">
          <xsl:with-param name="module" select="@name.french"/>
        </xsl:call-template>                
      </xsl:otherwise>
    </xsl:choose>


    <xsl:if test="@name.french">
    </xsl:if>
  </xsl:template>

  <xsl:template match="module" mode="page_count">
    <xsl:variable name="expg_count" select="count(.//express-g/imgfile)" />
      <xsl:variable name="usage_guide" select="count(.//usage_guide)" />
          <xsl:value-of select="$expg_count  + 28" />
        </xsl:template>


  <xsl:template match="business_object_model" mode="display_name">
    Business object model: 
    <xsl:call-template name="business_object_model_display_name">
      <xsl:with-param name="model" select="@name"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="business_object_model" mode="display_name_french">
    <xsl:choose>
      <xsl:when test="string-length(normalize-space(@name.french))=0">
        Modèle métier:
        <xsl:choose>
          <xsl:when test="$ERROR_CHECK_ISOCOVER='YES'">
            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Error FT: No French title (module/@name.french) provided for ',@name)"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="business_object_model_display_name">
              <xsl:with-param name="model" select="@name"/>
              </xsl:call-template>  
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        Modèle métier: 
        <xsl:call-template name="business_object_model_display_name">
          <xsl:with-param name="model" select="@name.french"/>
          </xsl:call-template>        
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@name.french">
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="business_object_model" mode="page_count">
    <xsl:variable name="expg_count" select="count(.//express-g/imgfile)" />
    <xsl:variable name="usage_guide" select="count(.//usage_guide)" />
    <xsl:value-of select="$expg_count  + 28" />
  </xsl:template>
  
  <xsl:template match="application_protocol" mode="page_count">
    <xsl:variable name="expg_count" select="count(.//express-g/imgfile)" />
      <xsl:variable name="schema_count" select="count(.//schema)" />
          <xsl:value-of select="$expg_count + $schema_count + 15" />
        </xsl:template>


  <xsl:template match="application_protocol" mode="display_name">
    Application protocol: 
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="@title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="application_protocol" mode="display_name_french">
    <xsl:choose>
      <xsl:when test="string-length(normalize-space(@name.french))=0">
        Protocole d'application: 
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error FT: No French title (application_protocol/@name.french) provided for ',@name)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        Protocole d'application: 
        <xsl:call-template name="module_display_name">
          <xsl:with-param name="module" select="@name.french"/>
          </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="get_stdnumber">
    <xsl:param name="part_xml"/>
    <xsl:variable name="part">
      <xsl:choose>
        <xsl:when test="string-length($part_xml/@part)>0">
          <xsl:value-of select="$part_xml/@part"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;part&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="string-length($part_xml/@status)>0">
          <xsl:value-of select="string($part_xml/@status)"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;status&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- 
         Note, if the standard has a status of CD or CD-TS it has not been
         published - so overide what ever is the @publication.year 
         -->
    <xsl:variable name="pub_year">
      <xsl:choose>
        <xsl:when test="$status='CD' or $status='CD-TS'">&#8212;</xsl:when>
        <xsl:when test="string-length($part_xml/@publication.year)">
          <xsl:value-of select="$part_xml/@publication.year"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;publication.year&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="language">
      <xsl:choose>
        <xsl:when test="string-length($part_xml/@language)">
          <xsl:value-of select="$part_xml/@language"/>
        </xsl:when>
        <xsl:otherwise>
          E
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="orgname" select="'ISO'"/>
    <xsl:choose>
        <xsl:when test="$status='IS'">
          <xsl:value-of 
            select="concat($orgname,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
        </xsl:when>
        <xsl:when test="$status='TS'">
          <xsl:value-of 
            select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
        </xsl:when>
        <xsl:when test="$status='FDIS'">
          <xsl:value-of 
            select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of 
            select="concat($orgname,'/',$status,' 10303-',$part)"/>          
        </xsl:otherwise>
      </xsl:choose>    
  </xsl:template>


  <xsl:template match="module|resource" mode="start_link">
    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_stdnumber">
        <xsl:with-param name="part_xml" select="."/>
      </xsl:call-template>
    </xsl:variable>
    
    <a href="./contents{$FILE_EXT}" target="_self">
      <xsl:value-of select="$stdnumber"/>
    </a>
  </xsl:template>
<!-- BOM -->
  <xsl:template match="business_object_model" mode="start_link">
    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_stdnumber">
        <xsl:with-param name="part_xml" select="."/>
      </xsl:call-template>
    </xsl:variable>    
    <a href="../home{$FILE_EXT}" target="_self">
      <xsl:value-of select="$stdnumber"/>
    </a>
  </xsl:template>
  
  <xsl:template match="application_protocol" mode="start_link">
    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_stdnumber">
        <xsl:with-param name="part_xml" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <a href="../home{$FILE_EXT}" target="_self">
      <xsl:value-of select="$stdnumber"/>
    </a>
  </xsl:template>

</xsl:stylesheet>
