<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: build.xsl,v 1.9 2003/02/26 02:12:17 thendrix Exp $
   Author:  Rob Bodington, Eurostep Limited
   Owner:   Developed by Eurostep Limited http://www.eurostep.com and supplied to NIST under contract.
   Purpose: To output the cover page for a published module.
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="exslt"
  version="1.0">
  
  <xsl:import href="../file_ext.xsl"/>
  <xsl:import href="../ap_doc/common.xsl"/>
  <xsl:import href="../res_doc/common.xsl"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/REC-html40/Strict.dtd"
    doctype-public="-//W3C//DTD HTML 4.0//EN"
    indent="yes"
    />


  <!-- 
     This parameter is passed in from ANT build where it is read from publication_index.xml
       -->
  <xsl:param name="SECRETARIAT"/>

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
      select="document(concat('../../data/application_protocols/',@directory,'/application_protocol.xml'))"/>
    <!-- now apply the stylesheet specified in the document -->
    <xsl:apply-templates select="$apdoc_xml/application_protocol"/>

  </xsl:template>

  <xsl:template match="resource_clause">
    <!-- the XML file to which the stylesheet will be applied 
         NOTE: that the path used by document is relative to the directory
         of this xsl file
         -->
    <xsl:variable 
      name="resdoc_xml"
      select="document(concat('../../data/resource_docs/',@directory,'/resource.xml'))"/>
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
      select="document(concat('../../data/modules/',@directory,'/module.xml'))"/>
    <!-- now apply the stylesheet specified in the document -->
    <xsl:apply-templates select="$module_xml/module"/>
  </xsl:template>
  

  <xsl:template match="module|application_protocol|resource">
    <HTML>
      <HEAD>
        <xsl:apply-templates select="." mode="meta_data"/>
      </HEAD>
        <TITLE>
          <!-- output the part page title -->
          <xsl:apply-templates 
            select="."
            mode="title"/>
        </TITLE>
        <BODY>
          <p align="center">
            <img width="59" height="54" src="../../../../images/isologo.gif" alt="ISO logo"/>
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
              <xsl:value-of select="concat($status_words,' 10303-',@part)"/>
            </span>
          </div>

          <!-- English title -->
          <div align="center" style="margin-top:20pt">
            <span style="font-size:30; font-family:sans-serif; font-weight:bold">
              Industrial automation systems and integration &#8212; 
              <br/>
              Product data representation and exchange &#8212;
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
                et &#233;change de donn&#233;es de produits
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

          <!-- link to main document -->
          <div align="center" style="margin-top:30pt">
            <span style="font-size:30; font-family:sans-serif;">
              <xsl:apply-templates select="." mode="start_link"/>
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

          <!-- document edition -->
          <div align="center" style="margin-top:50pt">
            <span style="font-size:12; font-family:sans-serif;">
              <b>
                <xsl:value-of select="concat($this_edition,'&#160;edition&#160;&#160;',@publication.year)"/>
              </b>
            </span>
          </div>

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
              <xsl:apply-templates select="." mode="is_copyright"/>
            </xsl:when>
            <xsl:when test="@status='TS'">
              <xsl:apply-templates select="." mode="ts_copyright"/>
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

  <xsl:template match="module|application_protocol|resource" mode="dis_copyright">
    <xsl:param name="stage" select="'Draft'"/>

    <!-- ICS number -->
    <div align="center" style="margin-top:30pt">
      <span style="font-size:14; font-family:sans-serif;">
        <b>ICS&#160;&#160;##.###.##;&#160;&#160;##.###.##</b>
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
              <xsl:value-of select="string-length($SECRETARIAT)"/>
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
                &#169;&#160;ISO&#160;<xsl:value-of select="@publication.year"/>
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

  <xsl:template match="module|application_protocol|resource" mode="ts_copyright">
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
              &#169;&#160;&#160;&#160;ISO&#160;<xsl:value-of select="@publication.year"/>
            </span>
          </td>

          <td width="220" align="right" valign="top">
            <span style="font-size:14; font-family:sans-serif;">
              <b>Price based on ## pages</b> 
            </span>
          </td>
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

        <!-- OLD
          <td width="274" valign="top" 
            style='width:205.35pt;border:none;border-top:solid windowtext 1.0pt; padding:0pt 5.4pt 0pt 5.4pt'>
            <p class="fdcopy" align="center" 
              style='margin-bottom:3.0pt;text-align:center; line-height:13.5pt;mso-line-height-rule:exactly;border:none;mso-padding-alt: 0pt 0pt 0pt 0pt'>
              <b style='mso-bidi-font-weight:normal'>
                Copyright notice
              </b>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:6.0pt;line-height:11.5pt;mso-line-height-rule: exactly;border:none;mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size: 9.0pt;mso-bidi-font-size:10.0pt'>
                This document is a Technical Specification and is
                copyright-protected by ISO. Except as permitted under the
                applicable laws of the user's country, neither this ISO
                document nor any extract from it may be reproduced, stored in
                a retrieval system or transmitted in any form or by 
                any means, electronic, photocopying, recording, or otherwise,
                without prior written permission being secured.  
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:3.0pt;line-height:11.5pt;mso-line-height-rule: exactly;border:none;mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size: 9.0pt;mso-bidi-font-size:10.0pt'>
                Requests for permission to reproduce should be addressed to
                either ISO at the address below or ISO's member
                body in the country of the requester.
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:0pt;margin-bottom:.0001pt;text-indent: 20.0pt;line-height:11.5pt;mso-line-height-rule:exactly;border:none; mso-padding-alt:0pt 0pt 0pt 0pt'>
            <span style='font-size:9.0pt;mso-bidi-font-size: 10.0pt'>
              ISO copyright office
            </span>
          </p>

            <p class="fdcopy" 
              style='margin-bottom:0pt;margin-bottom:.0001pt;text-indent: 20.0pt;line-height:11.5pt;mso-line-height-rule:exactly;border:none; mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size:9.0pt;mso-bidi-font-size: 10.0pt'>
                Case postale 56&#160;
              </span>
              <span style='font-size:9.0pt;mso-bidi-font-size: 10.0pt;font-family:Symbol;mso-ascii-font-family:Arial;mso-hansi-font-family: Arial;mso-char-type:symbol;mso-symbol-font-family:Symbol'>
                <span style='mso-char-type:symbol;mso-symbol-font-family:Symbol'>&#183;</span>
              </span>
              <span style='font-size:9.0pt;mso-bidi-font-size:10.0pt'>
                &#160;CH-1211 Geneva 20
              </span>
            </p>
            
            <p class="fdcopy" 
              style='margin-bottom:0pt;margin-bottom:.0001pt;text-indent: 20.0pt;line-height:11.5pt;mso-line-height-rule:exactly;border:none; mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size:9.0pt;mso-bidi-font-size: 10.0pt'>
                Tel.&#160;&#160;+41 22 749 01 11
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:0pt;margin-bottom:.0001pt;text-indent: 20.0pt;line-height:11.5pt;mso-line-height-rule:exactly;border:none; mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size:9.0pt;mso-bidi-font-size: 10.0pt'>
                Fax&#160;&#160;+41 22 749 09 47
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:0pt;margin-bottom:.0001pt;text-indent: 20.0pt;line-height:11.5pt;mso-line-height-rule:exactly;border:none; mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span 
                style='font-size:9.0pt;mso-bidi-font-size: 10.0pt'>
                E-mail&#160;&#160;copyright@iso.ch
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:6.0pt;text-indent:20.0pt;line-height: 11.5pt;mso-line-height-rule:exactly;border:none;mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size:9.0pt;mso-bidi-font-size:10.0pt'>
                Web&#160;&#160;www.iso.ch
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:6.0pt;line-height:11.5pt;mso-line-height-rule: exactly;border:none;mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size: 9.0pt;mso-bidi-font-size:10.0pt'>
                Reproduction may be subject to royalty payments or a licensing agreement. 
              </span>
            </p>
            
            <p class="MsoNormal" 
              style='margin-top:0pt;margin-right:5.0pt;margin-bottom: 0pt;margin-left:5.0pt;margin-bottom:.0001pt;text-align:justify'>
              <span style='font-size:9.0pt;mso-bidi-font-size:12.0pt;font-family:Arial'>
                Violators may be prosecuted.
              </span>
            </p>
          </td>

          <td width="199" valign="top" 
            style='width:149.15pt;border:none;border-top:solid windowtext 1.0pt; padding:0pt 0pt 0pt 5.4pt'>
            <p class="MsoNormal" align="right" 
              style='margin-top:2.0pt;text-align:right; line-height:13.5pt;mso-line-height-rule:exactly'>
              <b>
                <span style='font-family:Arial'>
                  &#169;&#160;&#160;&#160;ISO&#160;<xsl:value-of select="@publication.year"/>
              </span>
              </b>
            </p>
          </td>
        </tr>

      </table>      
    </div> 
    -->
  </xsl:template>

  <xsl:template match="module|application_protocol|resource" mode="is_copyright">
    <div align="center">
      <table border="1" cellspacing="0" cellpadding="0" width="800"
        style='width:600.0pt; border-collapse:collapse;border:none;mso-border-top-alt:solid windowtext 1.0pt; mso-padding-alt:0pt 5.4pt 0pt 5.4pt'>
        <tr>
          <td width="199" valign="top" 
            style='width:149.15pt;border:none;border-top:solid windowtext 1.0pt; padding:0pt 5.4pt 0pt 0pt'>
            <p class="MsoNormal" 
              style='margin-top:2.0pt;line-height:13.5pt;mso-line-height-rule: exactly'>
              <b>
                <span style='font-family:Arial'>ICS&#160;&#160;25.040.40</span>
              </b>
            </p>
          </td>

          <td width="274" valign="top" 
            style='width:205.35pt;border:none;border-top:solid windowtext 1.0pt; padding:0pt 5.4pt 0pt 5.4pt'>
            <p class="fdcopy" align="center" 
              style='margin-bottom:3.0pt;text-align:center; line-height:13.5pt;mso-line-height-rule:exactly;border:none;mso-padding-alt: 0pt 0pt 0pt 0pt'>
              <b style='mso-bidi-font-weight:normal'>
                <a name="copyright"/>
                Copyright notice
              </b>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:6.0pt;line-height:11.5pt;mso-line-height-rule: exactly;border:none;mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size: 9.0pt;mso-bidi-font-size:10.0pt'>
                This document is an International Standard and is
                copyright-protected by ISO. Except as permitted under the
                applicable laws of the user's country, neither this ISO
                document nor any extract from it may be reproduced, stored in
                a retrieval system or transmitted in any form or by 
                any means, electronic, photocopying, recording, or otherwise,
                without prior written permission being secured.  
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:3.0pt;line-height:11.5pt;mso-line-height-rule: exactly;border:none;mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size: 9.0pt;mso-bidi-font-size:10.0pt'>
                Requests for permission to reproduce should be addressed to
                either ISO at the address below or ISO's member
                body in the country of the requester.
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:0pt;margin-bottom:.0001pt;text-indent: 20.0pt;line-height:11.5pt;mso-line-height-rule:exactly;border:none; mso-padding-alt:0pt 0pt 0pt 0pt'>
            <span style='font-size:9.0pt;mso-bidi-font-size: 10.0pt'>
              ISO copyright office
            </span>
          </p>

            <p class="fdcopy" 
              style='margin-bottom:0pt;margin-bottom:.0001pt;text-indent: 20.0pt;line-height:11.5pt;mso-line-height-rule:exactly;border:none; mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size:9.0pt;mso-bidi-font-size: 10.0pt'>
                Case postale 56&#160;
              </span>
              <span style='font-size:9.0pt;mso-bidi-font-size: 10.0pt;font-family:Symbol;mso-ascii-font-family:Arial;mso-hansi-font-family: Arial;mso-char-type:symbol;mso-symbol-font-family:Symbol'>
                <span style='mso-char-type:symbol;mso-symbol-font-family:Symbol'>&#183;</span>
              </span>
              <span style='font-size:9.0pt;mso-bidi-font-size:10.0pt'>
                &#160;CH-1211 Geneva 20
              </span>
            </p>
            
            <p class="fdcopy" 
              style='margin-bottom:0pt;margin-bottom:.0001pt;text-indent: 20.0pt;line-height:11.5pt;mso-line-height-rule:exactly;border:none; mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size:9.0pt;mso-bidi-font-size: 10.0pt'>
                Tel.&#160;&#160;+41 22 749 01 11
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:0pt;margin-bottom:.0001pt;text-indent: 20.0pt;line-height:11.5pt;mso-line-height-rule:exactly;border:none; mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size:9.0pt;mso-bidi-font-size: 10.0pt'>
                Fax&#160;&#160;+41 22 749 09 47
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:0pt;margin-bottom:.0001pt;text-indent: 20.0pt;line-height:11.5pt;mso-line-height-rule:exactly;border:none; mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span 
                style='font-size:9.0pt;mso-bidi-font-size: 10.0pt'>
                E-mail&#160;&#160;copyright@iso.ch
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:6.0pt;text-indent:20.0pt;line-height: 11.5pt;mso-line-height-rule:exactly;border:none;mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size:9.0pt;mso-bidi-font-size:10.0pt'>
                Web&#160;&#160;www.iso.ch
              </span>
            </p>

            <p class="fdcopy" 
              style='margin-bottom:6.0pt;line-height:11.5pt;mso-line-height-rule: exactly;border:none;mso-padding-alt:0pt 0pt 0pt 0pt'>
              <span style='font-size: 9.0pt;mso-bidi-font-size:10.0pt'>
                Reproduction may be subject to royalty payments or a licensing agreement. 
              </span>
            </p>
            
            <p class="MsoNormal" 
              style='margin-top:0pt;margin-right:5.0pt;margin-bottom: 0pt;margin-left:5.0pt;margin-bottom:.0001pt;text-align:justify'>
              <span style='font-size:9.0pt;mso-bidi-font-size:12.0pt;font-family:Arial'>
                Violators may be prosecuted.
              </span>
            </p>
          </td>

          <td width="199" valign="top" 
            style='width:149.15pt;border:none;border-top:solid windowtext 1.0pt; padding:0pt 0pt 0pt 5.4pt'>
            <p class="MsoNormal" align="right" 
              style='margin-top:2.0pt;text-align:right; line-height:13.5pt;mso-line-height-rule:exactly'>
              <b>
                <span style='font-family:Arial'>
                  &#169;&#160;&#160;&#160;ISO&#160;<xsl:value-of select="@publication.year"/>
              </span>
              </b>
            </p>
          </td>
        </tr>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="module" mode="display_name">
    Application module: 
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="module" mode="display_name_french">
    Module d'application: 
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="resource" mode="display_name">
    Integrated generic resource: 
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="resource" mode="display_name_french">
    Ressources g&#233;n&#233;riques int&#233;gr&#233;es: 
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="application_protocol" mode="display_name">
    Application protocol: 
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="application_protocol" mode="display_name_french">
    Protocole d'application: 
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
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
    
    <xsl:value-of 
      select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
    
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


  <xsl:template match="application_protocol" mode="start_link">
    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_stdnumber">
        <xsl:with-param name="part_xml" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$stdnumber"/>
  </xsl:template>

</xsl:stylesheet>