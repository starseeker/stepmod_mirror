<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_foreword.xsl,v 1.9 2003/06/06 10:28:22 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- 	<xsl:import href="../sect_foreword.xsl"/> -->
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
  
  <xsl:template match="module"/> 
	
  <xsl:template match="application_protocol">
    <xsl:apply-templates select="." mode="foreword"/>
  </xsl:template>

  <xsl:template match="application_protocol" mode="foreword">
    <xsl:variable name="part_no">
      <xsl:call-template name="get_protocol_stdnumber">
        <xsl:with-param name="application_protocol" select="."/>
      </xsl:call-template>
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
      technical committees. Each member body interested in a subject for
      which a technical committee has been established has the right to be
      represented on that committee. International organizations,
      governmental and non-governmental, in liaison with ISO, also take
      part in the work. ISO collaborates closely with the International
      Electrotechnical Commission (IEC) on all matters of electrotechnical
      standardization.
    </p>
    <p>
      International Standards are drafted in accordance with the rules given in the ISO/IEC Directives, Part 2.
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
      requirement for such documents, a technical committee may decide to publish 
      other types of normative document: 
    </p>
    <ul>
      <li>
        an ISO Publicly Available Specification (ISO/PAS) represents an
        agreement between technical experts in an ISO working group and  is
        accepted for publication if it is approved by more than 50% 
        of the members of the parent committee casting a vote;
      </li>
    </ul>
    <ul>
      <li>
        an ISO Technical Specification (ISO/TS) represents an agreement between 
        the members of a technical committee and is accepted for
        publication if it is approved by 2/3 of the members of the committee
        casting a vote. 
      </li>
    </ul>
    <p>
      An ISO/PAS or ISO/TS is reviewed after three years in order to decide
      whether it will be confirmed for a further three years, revised to become
      an International Standard, or withdrawn.  If the ISO/PAS or ISO/TS is
      confirmed, it is reviewed again after a further three years, at which time
      it must either be transformed into an International Standard or be
      withdrawn. 
    </p>
    <p>
      Attention is drawn to the possibility that some of the elements of this
      part of ISO 10303 may be the subject of patent rights. ISO shall not be
      held responsible for identifying any or all such patent rights.
    </p>
    <p>
      <xsl:choose>
        <xsl:when test="string-length(@part)>0">
          <xsl:value-of select="concat('ISO/TS 10303-',@part)"/>
        </xsl:when>
        <xsl:otherwise>
          ISO/TS 10303-
          <font color="#FF0000">
            <b>
              XXXX
            </b>
          </font>
        </xsl:otherwise>
      </xsl:choose>
      was prepared by Technical Committee ISO/TC 184, 
      <i>Industrial automation systems and integration</i>,
      Subcommittee SC4, <i>Industrial data</i>.
    </p>

    <xsl:if test="@version!='1'">
      <xsl:variable name="this_edition">
        <xsl:apply-templates select="." mode="this_edition"/>
      </xsl:variable>

      <xsl:variable name="prev_edition">
        <xsl:apply-templates select="." mode="previous_edition"/>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="@previous.revision.cancelled='NO'">
          This <xsl:value-of select="$this_edition"/> edition of  
        <xsl:value-of select="$part_no"/> 
        constitutes a technical revision of the
        <xsl:value-of select="$prev_edition"/> edition  
        (<xsl:value-of
        select="@previous.revision.number"/>),
        which is provisionally retained in order to support continued use
        and maintenance of implementations based on the
        <xsl:value-of select="$prev_edition"/> 
        edition and to satisfy the normative references of other parts of
        ISO 10303. 
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
        <xsl:value-of select="@previous.revision.year"/> edition
        (<xsl:value-of
          select="@previous.revision.number"/>), 
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
    <xsl:apply-templates select="./changes" mode="foreword"/>
  </xsl:if>

  <p>
    This International Standard is organized as a series of parts, each
    published separately. The structure of this International Standard is
    described in ISO 10303-1.
  </p>
  <p>
    Each part of this International Standard is a
    member of one of the following series: description methods, implementation
    methods, conformance testing methodology and framework, integrated generic
    resources, integrated application resources, application protocols,
    abstract test suites, application interpreted constructs, and application
    modules. This part is a member of the application protocols series.
  </p>
  <p>
    A complete list of parts of ISO 10303 is available from the Internet: 
  </p>
  <blockquote>
    <a href="http://www.tc184-sc4.org/titles/STEP_Titles.rtf/">
      &lt;http://www.tc184-sc4.org/titles/STEP_Titles.rtf/&gt;
    </a>.
  </blockquote>
  <p>
    Annexes 
    <a href="./annex_exp_lf{$FILE_EXT}">A</a>,
    <a href="./annex_shortnames{$FILE_EXT}">B</a>,
    <a href="./annex_imp_meth{$FILE_EXT}">C</a>,
    <a href="./annex_pics{$FILE_EXT}">D</a> and 
    <a href="./annex_obj_reg{$FILE_EXT}">E</a>
    form an integral part of this part of
    ISO 10303. Subsequent annexes are for information only.
  </p>
  </xsl:template>


  <xsl:template match="changes" mode="foreword">
   <xsl:variable name="annex_list">
     <xsl:apply-templates select="/application_protocol" mode="annex_list"/>
   </xsl:variable>

    <xsl:variable name="al_changes">
      <xsl:call-template name="annex_letter">
        <xsl:with-param name="annex_name" select="'changedetail'"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="./change_summary and ./change_detail">
        <p class="note">
          <small>
            NOTE&#160;&#160;Detailed description of the changes is provided
            in the 
            <a href="./introduction{$FILE_EXT}#changes">
              Introduction
            </a>
            and annex
            <a href="./annex_changes{$FILE_EXT}">
              <xsl:value-of select="$al_changes"/>.
            </a>
          </small>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <p class="note">
          <small>
            NOTE&#160;&#160;Detailed description of the changes is provided
            in the 
            <a href="./introduction{$FILE_EXT}#changes">
              Introduction
            </a>. 
          </small>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
