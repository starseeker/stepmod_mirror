<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:ap="http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/xml-schema/bo_model"
	xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"
	xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:bom="http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/xml-schema/bo_model"
	xmlns:html="http://www.w3.org/TR/REC-html40" exclude-result-prefixes="fo xsd fn">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		omit-xml-declaration="no" />
	<!-- 	INPUT: CR publication_index.xml
			OUTPUT: WG12 N numbers table (Excel XML format) for each modules for WG12 Convener 
			(next update: consider resources) -->

	<xsl:template match="/">

		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
			xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"
			xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">

			<xsl:call-template name="XslMetaData1" />

			<Worksheet ss:Name="WG NB">
				<Table ss:ExpandedColumnCount="8" ss:ExpandedRowCount="357"
					x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="65"
					ss:DefaultRowHeight="16">
					<Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="93" />
					<Column ss:AutoFitWidth="0" ss:Width="63" ss:Span="1" />
					<Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="424" />
					<Column ss:AutoFitWidth="0" ss:Width="89" />
					<xsl:for-each select="/part1000.publication_index/modules/module">
						<Row>
							<Cell ss:StyleID="s812" />
							<Cell ss:StyleID="s812">
								<Data ss:Type="String">Kevin Le Tutour</Data>
							</Cell>
							<Cell ss:StyleID="s812" />
							<Cell ss:StyleID="s812" />
							<Cell ss:StyleID="s812">
								<Data ss:Type="String">
									<xsl:value-of
										select="concat('ISO 10303-', @number, ' ed', @version, ' ', @name, ' Document')" />
								</Data>
							</Cell>
							<Cell ss:StyleID="s812">
								<Data ss:Type="String">2016-04-15</Data>
							</Cell>
							<Cell ss:StyleID="s812">
								<Data ss:Type="String">
									<xsl:value-of select="@number" />
								</Data>
							</Cell>
							<Cell ss:StyleID="s812">
								<Data ss:Type="String">
									<xsl:value-of select="@name" />
								</Data>
							</Cell>

						</Row>
						<xsl:if test="@arm.change = 'y'">
							<Row>
								<Cell ss:StyleID="s812" />
								<Cell ss:StyleID="s812">
									<Data ss:Type="String">Kevin Le Tutour</Data>
								</Cell>
								<Cell ss:StyleID="s812" />
								<Cell ss:StyleID="s812" />
								<Cell ss:StyleID="s812">
									<Data ss:Type="String">
										<xsl:value-of
											select="concat('ISO 10303-', @number, ' ed', @version, ' ', @name, ' ARM EXPRESS')" />
									</Data>
								</Cell>
								<Cell ss:StyleID="s812">
									<Data ss:Type="String">2016-04-15</Data>
								</Cell>
							</Row>
						</xsl:if>
						<xsl:if test="@mim.change = 'y'">
							<Row>
								<Cell ss:StyleID="s812" />
								<Cell ss:StyleID="s812">
									<Data ss:Type="String">Kevin Le Tutour</Data>
								</Cell>
								<Cell ss:StyleID="s812" />
								<Cell ss:StyleID="s812" />
								<Cell ss:StyleID="s812">
									<Data ss:Type="String">
										<xsl:value-of
											select="concat('ISO 10303-', @number, ' ed', @version, ' ', @name, ' MIM EXPRESS')" />
									</Data>
								</Cell>
								<Cell ss:StyleID="s812">
									<Data ss:Type="String">2016-04-15</Data>
								</Cell>
							</Row>
						</xsl:if>
					</xsl:for-each>


				</Table>
				<xsl:call-template name="XslMetaData2" />
			</Worksheet>
		</Workbook>
	</xsl:template>
	<xsl:template name="XslMetaData1">
		<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
			<Author>Kevin Le Tutour</Author>
			<!-- <LastAuthor>Kevin Le Tutour</LastAuthor> <Created>2015-09-02T08:38:36Z</Created> 
				<LastSaved>2016-04-07T13:17:26Z</LastSaved> -->
			<Company>Boost</Company>
			<Version></Version>
		</DocumentProperties>
		<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
			<AllowPNG />
			<PixelsPerInch>96</PixelsPerInch>
		</OfficeDocumentSettings>
		<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
			<WindowHeight>17460</WindowHeight>
			<WindowWidth>27820</WindowWidth>
			<WindowTopX>380</WindowTopX>
			<WindowTopY>500</WindowTopY>
			<ProtectStructure>False</ProtectStructure>
			<ProtectWindows>False</ProtectWindows>
			<DisplayInkNotes>False</DisplayInkNotes>
		</ExcelWorkbook>
		<Styles>
			<Style ss:ID="Default" ss:Name="Normal">
				<Alignment ss:Vertical="Bottom" />
				<Borders />
				<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"
					ss:Color="#000000" />
				<Interior />
				<NumberFormat />
				<Protection />
			</Style>
			<Style ss:ID="s812">
				<Alignment ss:Horizontal="Center" ss:Vertical="Center" />
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous"
						ss:Weight="1" />
					<Border ss:Position="Left" ss:LineStyle="Continuous"
						ss:Weight="1" />
					<Border ss:Position="Right" ss:LineStyle="Continuous"
						ss:Weight="1" />
					<Border ss:Position="Top" ss:LineStyle="Continuous"
						ss:Weight="1" />
				</Borders>
				<Font ss:FontName="Cambria" ss:Size="12" ss:Color="#000000" />
				<Interior />
			</Style>

		</Styles>
	</xsl:template>
	<xsl:template name="XslMetaData2">
		<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
			<Print>
				<ValidPrinterInfo />
				<PaperSizeIndex>9</PaperSizeIndex>
				<HorizontalResolution>-4</HorizontalResolution>
				<VerticalResolution>-4</VerticalResolution>
			</Print>
			<Zoom>125</Zoom>
			<PageLayoutZoom>125</PageLayoutZoom>
			<Selected />
			<ProtectObjects>False</ProtectObjects>
			<ProtectScenarios>False</ProtectScenarios>
		</WorksheetOptions>

	</xsl:template>


</xsl:stylesheet>