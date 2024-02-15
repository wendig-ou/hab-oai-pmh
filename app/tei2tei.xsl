<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:dv="http://dfg-viewer.de" xmlns:mets="http://www.loc.gov/METS/" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xs xi mets tei xlink dv" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <xsl:copy-of select="descendant-or-self::tei:TEI"/>
    </xsl:template>
    <xsl:template match="xi:include">
        <xsl:if test="exists(doc(@href))">
            <xsl:apply-templates select="doc(@href)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:facsimile">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="facsimile">
        <xsl:element name="facsimile" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:for-each select="graphic">
                <xsl:element name="graphic" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:copy-of select="@*"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>