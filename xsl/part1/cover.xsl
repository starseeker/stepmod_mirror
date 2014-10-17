<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
    $Id: cover.xsl,v 1.4 2010/10/18 22:16:21 radack Exp $
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
		exclude-result-prefixes="msxsl exslt"
		version="1.0">

  <xsl:template match="cover-page">
      <p align="center"><img src="../../../images/isologo.gif" alt="ISO logo"/></p>
      <div align="center" style="margin-top=10pt"><span style="font-size:16; font-family:sans-serif; font-weight:bold">
            SMRL <xsl:value-of select="document('../part.xml',.)/part/@publication.year"/>(E)
            	</span></div>
      <div align="center" style="margin-top:20pt"><span style="font-size:30; font-family:sans-serif; font-weight:bold"><xsl:value-of select="document('../part.xml',.)/part/@title"/></span></div>
      <div align="center" style="margin-top:25pt"><span style="font-size:14; font-family:sans-serif;"><i><xsl:value-of select="document('../part.xml',.)/part/@title.fr"/></i></span></div>
      <div align="center" style="margin-top:30pt"><span style="font-size:30; font-family:sans-serif;"><a href="list_by_name.htm">SMRL <xsl:value-of select="document('../part.xml',.)/part/@publication.year"/>(E)</a></span></div>
      <div align="center" style="margin-top:50pt"><span style="font-size:12; font-family:sans-serif;"><b>
               	    Version <xsl:value-of select="document('../part.xml',.)/part/@version.number"/>: <xsl:value-of select="document('../part.xml',.)/part/@publication.date"/></b></span></div>
      <hr/>
      <table border="0" align="center">
         <tr>
            <td width="220" valign="top"><span style="font-size:14; font-family:sans-serif;"><b>ICS&#160;&#160;25.040.40</b></span></td>
            <td width="310" align="center" valign="top"><span style="font-size:12; font-family:sans-serif;">
                  ©&#160;&#160;&#160;ISO&#160;<xsl:value-of select="$pub_year"/>
                  	      </span></td>
            <td width="220" align="right" valign="top">Price group: <xsl:value-of select="document('../part.xml',.)/part/@price_group"/></td>
         </tr>
         <tr>
            <td width="220"><br/></td>
            <td width="310" align="center" valign="top">
               <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt"><a name="copyright"></a>
                  All rights reserved. Unless otherwise specified, no part of this publication may be 
                  reproduced or utilized in any form or by any means, electronic or mechanical, including 
                  photocopying and microfilm, without permission in writing from either ISO at the address 
                  below or ISO's member body in the country of the requester.
                  
                  
               </div>
               <div style="font-size:12; font-family:sans-serif; margin-bottom:3pt">
                  ISO copyright office<br/>
                  Case postale 56&#160;&#160;<span style="font-family:Symbol">·</span>&#160;CH-1211 Geneva 20<br/>
                  Tel.&#160;&#160;+ 41 22 749 01 11<br/>
                  Fax&#160;&#160;+ 41 22 749 09 47<br/>
                  E-mail&#160;&#160;copyright@iso.org<br/>
                  Web&#160;&#160;www.iso.org
                  
                  
               </div>
               <div style="font-size:12; font-family:sans-serif;">
                  Published in Switzerland
                  
                  
               </div>
            </td>
            <td width="220"><br/></td>
         </tr>
      </table>
      
  </xsl:template>
  
</xsl:stylesheet>
