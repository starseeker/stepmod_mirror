<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: sect_foreword.xsl,v 1.3 2002/10/08 10:17:45 mikeward Exp $
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
      <xsl:choose>
        <xsl:when test="string-length(@part)>0">
          <xsl:value-of select="concat('ISO/TS 10303-',@part)"/>
        </xsl:when>
        <xsl:otherwise>
          ISO/TS 10303-XXXX
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

		<h3>
			<a name="foreword">
				Foreword
			</a>
		</h3>
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
			    An ISO/PAS or ISO/TS is reviewed every three years with a view to
			    deciding whether it can be transformed into an International Standard.
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
			<i>Industrial automation systems and integration,
			</i>
			Subcommittee SC4, 
			<i>Industrial data.
			</i>
		</p>
		
		<xsl:if test="string-length(@previous.revision.year)>0">
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
        constitutes a technical revision of the
        <xsl:value-of select="@previous.revision.year"/> edition  
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
			Annexes A, B, C and D form an integral part of this part of ISO 10303. Annexe E 
			and subsequent annexes are for information only.
		</p> 
	</xsl:template>

</xsl:stylesheet>
