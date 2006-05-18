<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_6_refdata.xsl,v 1.0 2003/05/04 08:15:03 robbod Exp $
  Author:  David Price, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to OSJTF under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>

  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'6 Module reference data'"/>
    <xsl:with-param name="aname" select="'refdata'"/>
  </xsl:call-template>

	  <xsl:choose>
    <xsl:when test="refdata">
		
		<p>Implementations of this part of ISO 10303 shall make use of the capability to classify an 
       entity type using <b>Classification_assignment</b> (see ISO 10303-1114), <b>Class</b> (see ISO 10303-1070) and <b>External_class</b> (see ISO 10303-1275).
       This annex contains a subclause for each entity type defined in or used by this part of ISO 10303 for which that capability
       shall be applied. The specified Uniform Resource Identifier (URI) is used to identify each class.</p>

     <p>For the purpose of diagramming possible classifications of EXPRESS entity types, UML 1.4 or later class diagrams with stereotypes
        are used. The W3C OWL Web Ontology Language is used to represent the
        classes that may be applied to an EXPRESS entity type both in the diagrams and as example OWL files.</p>

    <p class="note">
      <small>
        NOTE &#160;&#160;The standards related to the specification of reference data are:
				<ul>
				<li>the  <a target="_blank" href="http://www.omg.org/technology/documents/formal/uml.htm">UML 2 specification</a> is available from the OMG Web site;</li>
				<li>the <a target="_blank" href="http://www.omg.org/cgi-bin/doc?formal/05-04-01">ISO UML 1.4.2 specification</a> published as ISO/IEC 19501:2005(E) is available from the OMG Web site
and from the <a href="http://www.iso.org">ISO</a> Web site;</li>
				<li>the <a target="_blank" href="http://www.w3.org/TR/owl-ref/">OWL Web Ontology Language Reference</a> is available from the W3C Web site.</li>
				</ul>
     </small>
    </p>

     <p>The diagram notation is interpreted as follows:</p>
       <ul>
      <li>the <code>&lt;&lt;expressEntityType&gt;&gt;</code> stereotype applied to a UML Class denotes an EXPRESS entity type;</li>
      <li>the <code>&lt;&lt;owlClass&gt;&gt;</code> stereotype applied to a UML Class denotes the related class(es);</li>
        <li>if all OWL classes on a diagram have the same namespace it may be omitted, otherwise the XML namespace of the OWL ontology
            containing each class is
             represented as the UML Package name which appears under the class name enclosed in parentheses;</li>
       <li>the <code>&lt;&lt;classificationAssignment&gt;&gt;</code> stereotype applied to a UML Generalization denotes
			       the fact that the EXPRESS entity type can be classified
             using the more specific class;</li>
       <li>the <code>&lt;&lt;disjointWith&gt;&gt;</code> stereotype applied to a UML constraint note is included where appropriate
			     to specify the set of OWL classes are mutually exclusive</li>
       <li>the OWL <code>subClassOf</code> relationship between OWL classes is denoted using unstereotyped generalizations
			      between the stereotyped UML classes;</li>
        <li>no other UML, EXPRESS or OWL concepts appear in these diagrams.</li>
        </ul>		
		
      <xsl:apply-templates select="refdata"/>
    </xsl:when>
    <xsl:otherwise>
      <p>
        An Application module reference data has not been provided.
      </p>
    </xsl:otherwise>
  </xsl:choose>

	</xsl:template>


</xsl:stylesheet>
