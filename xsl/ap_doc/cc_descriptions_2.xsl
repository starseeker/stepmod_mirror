<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./pas_document_xsl.xsl" ?>
<!--
	$Id: cc_descriptions_2.xsl,v 1.2 2003/02/14 15:12:31 darla Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="html"/>
	
	<xsl:template match="/">
		<html>
			<body bgcolor="#FFFFFF">
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="conformance_classes">
	
	 	<p>
			This application protocol provides for a number of options that may be supported by an implementation.
		</p>
		<p>
			These options have been grouped into the following conformance classes:
		</p>	
		<ul>
			<xsl:for-each select="cc">
				<li>
	        			<xsl:choose>
	          				<xsl:when test="position()!=last()">
	           					<xsl:value-of select="concat(@name,';')"/>
	          				</xsl:when>
	          				<xsl:otherwise>
	            					<xsl:value-of select="concat(@name,'.')"/>        
	          				</xsl:otherwise>
	        			</xsl:choose>
	      			</li>
			</xsl:for-each>
	  	</ul>
		<p>
Conformance to a particular class implies the following:</p>
<ul>
<li>an export processor shall write instances of entities defined in the MIM long-form schema and that belong to the considered conformance class, in conformance with the constraints specified in the mapping-table and in the MIM long-form schema;</li>
<li>an import processor shall interpret instances of entities defined in the MIM long-form schema and that belong to the considered conformance class.</li>
</ul>
<p class="note">
<small>
NOTE&#160;&#160;A conformance class specifies a minimum implementation level.
A particular processor may write or read instances of entities that belong to more than one conformance class.
</small>
</p>
<p>
<h3>6.1&#160;Scope of conformance classes</h3>
		<xsl:for-each select="cc">
			<h3>6.1.<xsl:value-of select="position()"/>&#160; 
			<xsl:value-of select="concat('Conformance class for ', ./@name, ' (', ./@id, ')')"/></h3>
			<p><xsl:value-of select="./description"/></p>
			<xsl:apply-templates select="note"/>
			<xsl:apply-templates select="example"/>
		</xsl:for-each>
		


<h3>6.2&#160;Conformance classes per Units of Functionality</h3>
Table 1 identifies the conformance classes to which each UOF of the modules interfaced in the ARM schema, belongs.
</p>
  <p align="center">
	  <a name="table_1">
		<b>
      Table 1 - Conformance classes per UOF
    </b>
		</a>  
		</p>
  <xsl:variable name="no_of_ccs" select="count(cc)"/>
  <div align="center">

		<table border="1">
			<tr>
				<th rowspan="2">
					UOF
				</th>
				<th colspan="{$no_of_ccs}">
					Conformance class
				</th>
			</tr>
			<tr>
				<xsl:for-each select="cc">
					<td>
						<xsl:value-of select="./@id"/>
					</td>
				</xsl:for-each>					
			</tr>
			
			<xsl:for-each select="uofs_in_ccs/uof_in_cc">
					<xsl:sort select="@name"/>
			 		<tr>
							<td>
							<xsl:value-of select="./@name"/>
							</td>
								
							<xsl:variable name="considered_object" select="current()">
							</xsl:variable>
							
							<xsl:for-each select="../../cc">			  		  
								<xsl:variable name="considered_cc">
								<xsl:value-of select="./@id"/>
								</xsl:variable>
															
								<xsl:variable name="column_filled">
									<xsl:for-each select="$considered_object/cc_id">
									  <xsl:if test="@id=$considered_cc">
									  1
									  </xsl:if>
								  </xsl:for-each>								
								</xsl:variable>
								
								<xsl:choose>
      					<xsl:when test="$column_filled=number(1)">
										<td>X</td>
								</xsl:when>
							  <xsl:otherwise>
								  <td>&#160;</td>
							  </xsl:otherwise>
						    </xsl:choose>							
							</xsl:for-each>			
			  	</tr>
	
			</xsl:for-each>
	</table>

	</div>	

<!-- <h3>6.3&#160;Conformance classes per ARM entity</h3>
<p>
Table 2 identifies the conformance classes to which each entity of the ARM long-form schema, belongs.
</p>
  <p align="center">
	  <a name="table_2">
		    <b>
      Table 2 - Conformance classes per ARM entity
    </b>
		</a>
  </p>
  <div align="center">

		<table border="1">
			<tr>
				<th rowspan="2">
					ARM entity
				</th>
				<th colspan="{$no_of_ccs}">
					Conformance class
				</th>
			</tr>
			<tr>
				<xsl:for-each select="cc">
					<td>
						<xsl:value-of select="./@id"/>
					</td>
				</xsl:for-each>					
			</tr>

		<xsl:for-each select="arms_in_ccs/arm_entity_in_cc">
					<xsl:sort select="@name"/>
			 		<tr>
							<td>
							<xsl:value-of select="./@name"/>
							</td>
								
							<xsl:variable name="considered_object" select="current()">
							</xsl:variable>
							
							<xsl:for-each select="../../cc">			  		  
								<xsl:variable name="considered_cc">
								<xsl:value-of select="./@id"/>
								</xsl:variable>
															
								<xsl:variable name="column_filled">
									<xsl:for-each select="$considered_object/cc_id">
									  <xsl:if test="@id=$considered_cc">
									  1
									  </xsl:if>
								  </xsl:for-each>								
								</xsl:variable>
								
								<xsl:choose>
      					<xsl:when test="$column_filled=number(1)">
										<td>X</td>
								</xsl:when>
							  <xsl:otherwise>
								  <td>&#160;</td>
							  </xsl:otherwise>
						    </xsl:choose>							
							</xsl:for-each>			
			  	</tr>

		</xsl:for-each>
	</table>
	</div>
-->	
<h3>6.3 Conformance classes per MIM entity</h3>
<p>
Table 2 identifies the conformance classes to which each entity of the MIM long-form schema, belongs.
</p>
  <p align="center">
	  <a name="table_3">
		    <b>
      Table 2 - Conformance classes per MIM entity
    </b>
		</a>
  </p>
	
  <div align="center">
		<table border="1">
			<tr>
				<th rowspan="2">
					MIM entity
				</th>
				<th colspan="{$no_of_ccs}">
					Conformance class
				</th>
			</tr>
			<tr>
				<xsl:for-each select="cc">
					<td>
						<xsl:value-of select="./@id"/>
					</td>
				</xsl:for-each>					
			</tr>

		<xsl:for-each select="mims_in_ccs/mim_entity_in_cc">
					<xsl:sort select="@name"/>
			 		<tr>
							<td>
							<xsl:value-of select="./@name"/>
							</td>
								
							<xsl:variable name="considered_object" select="current()">
							</xsl:variable>
							
							<xsl:for-each select="../../cc">			  		  
								<xsl:variable name="considered_cc">
								<xsl:value-of select="./@id"/>
								</xsl:variable>
															
								<xsl:variable name="column_filled">
									<xsl:for-each select="$considered_object/cc_id">
									  <xsl:if test="@id=$considered_cc">
									  1
									  </xsl:if>
								  </xsl:for-each>								
								</xsl:variable>
								
								<xsl:choose>
      					<xsl:when test="$column_filled=number(1)">
										<td>X</td>
								</xsl:when>
							  <xsl:otherwise>
								  <td>&#160;</td>
							  </xsl:otherwise>
						    </xsl:choose>							
							</xsl:for-each>			
			  	</tr>

		</xsl:for-each>
	</table>
	</div>
</xsl:template>

</xsl:stylesheet>
