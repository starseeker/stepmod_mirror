<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_list.xsl,v 1.4 2002/08/07 12:11:10 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display the modules according to ballot packages

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:template name="ballot_header">
          <table>
        <tr>
          <td><h2>Ballot package:</h2></td>
          <td><h2><xsl:value-of select="@name"/></h2></td>
        </tr>
        <tr>
          <td><small>Ballot package WG number:</small></td>
          <td><small><xsl:value-of select="@wg.number.ballot_package"/></small></td>
        </tr>
        <tr>
          <td><small>Ballot package comments:</small></td>
          <td><small><xsl:value-of select="@wg.number.ballot_package_comment"/></small></td>
        </tr>

        <tr>
          <td><small>Proposed submission date:</small></td>
          <td><small><xsl:value-of select="@proposed.submission.date"/></small></td>
        </tr>
       <tr>
          <td><small>Ballot start date:</small></td>
          <td><small><xsl:value-of select="@ballot.start.date"/></small></td>
        </tr>
        <tr>
          <td><small>Ballot close date:</small></td>
          <td><small><xsl:value-of select="@ballot.close.date"/></small></td>
        </tr>
        <tr>
          <td><small>Comments resolved date:</small></td>
          <td><small><xsl:value-of select="@comments.resolved.date"/></small></td>
        </tr>
        <tr>
          <td><small>Ballot complete:</small></td>
          <td><small><xsl:value-of select="@ballot.complete"/></small></td>
        </tr>
        <tr>
          <td><small>Project leader:</small></td>
          <td>
            <small>
              <xsl:apply-templates select="./contacts/projlead"
                mode="no_address"/>
            </small>
          </td>
        </tr>
        <tr>
          <td><small>Description:</small></td>
          <td><small>
            <xsl:apply-templates select="./description"/>
          </small></td>
        </tr>
      </table>
      <hr/>
  </xsl:template>

<xsl:template match="description">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>