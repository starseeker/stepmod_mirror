<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_foreword.xsl,v 1.4 2014/07/02 15:27:14 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: Display the foreword for a BOM document.     
-->

<!-- BOM -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="business_object_model.xsl"/>
 <!-- <xsl:import href="business_object_model_clause.xsl"/>-->
  <xsl:import href="business_object_model_clause_nofooter.xsl"/>
  <xsl:output method="html"/>
  
  <xsl:template match="business_object_model">
    <xsl:apply-templates select="." mode="foreword"/>
  </xsl:template>

  <xsl:template match="business_object_model" mode="foreword">
    <xsl:variable name="part_no" select="./@part"/>
      
    
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


    <xsl:if test="@status='CD-TS' or @status='TS'">
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
     <!-- <p>
	An ISO/PAS or ISO/TS is reviewed after three years in order to decide
	whether it will be confirmed for a further three years, revised to become
	an International Standard, or withdrawn.  If the ISO/PAS or ISO/TS is
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
        may be transformed into an International Standard or be continued as an
        ISO/TS or be withdrawn.
      </p> <!-- MWD 2017-05-17 -->
    </xsl:if>
    <p>
      Attention is drawn to the possibility that some of the elements of this
      document may be the subject of patent rights. ISO shall not be
      held responsible for identifying any or all such patent rights.
    </p>
    <p>
      <xsl:choose>
	<xsl:when test="string-length(@part)>0">
	  <xsl:choose>
	    <xsl:when test="@status='CD-TS' or  @status='TS'">
	      <xsl:value-of select="concat('ISO/TS 10303-',@part)"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="concat('ISO 10303-',@part)"/>
	    </xsl:otherwise>
	  </xsl:choose>
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
      <i>Automation systems and integration</i>,
      Subcommittee SC4, <i>Industrial data</i>.
    </p>
    <xsl:choose>
      <xsl:when test="not(./foreword)">
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
	      cancels and replaces the
	      <xsl:value-of select="$prev_edition"/> edition  
          (<xsl:value-of select="$part_no"/>:<xsl:value-of select="@previous.revision.year"/>),
	      of which it constitutes a technical revision. 

	    </xsl:when>

	    <xsl:otherwise>
	      <!-- cancelled -->
	      This <xsl:value-of select="$this_edition"/> edition of
	      <xsl:value-of select="$part_no"/> cancels and replaces the
          <xsl:value-of select="$prev_edition"/> edition
          (<xsl:value-of select="$part_no"/>:<xsl:value-of select="@previous.revision.year"/>),
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
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="./foreword"/>
      </xsl:otherwise>
    </xsl:choose>

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
    application interpreted constructs, application modules, and business object models. 
    This part is a member of the business object models series.
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


  <xsl:template match="changes" mode="foreword">
   <xsl:variable name="annex_list">
     <xsl:apply-templates select="/business_object_model" mode="annex_list"/>
   </xsl:variable>

    <xsl:variable name="al_changes">
      <xsl:call-template name="annex_letter">
        <xsl:with-param name="annex_name" select="'changedetail'"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="./change_summary and ./change_detail">
            A detailed description of the changes is provided
            in the 
            <a href="./introduction{$FILE_EXT}#changes">
              Introduction
            </a>
            and Annex
            <a href="./annex_changes{$FILE_EXT}">
              <xsl:value-of select="$al_changes"/>.
            </a>
      </xsl:when>
      <xsl:otherwise>
            A detailed description of the changes is provided
            in the 
            <a href="./introduction{$FILE_EXT}#changes">
              Introduction
            </a>. 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
