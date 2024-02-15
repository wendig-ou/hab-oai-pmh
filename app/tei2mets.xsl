<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dv="http://dfg-viewer.de" xmlns:mets="http://www.loc.gov/METS/" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xs xsi mets tei xlink dv" version="2.0">
    
    <!--
    http://digital.slub-dresden.de/oai/?verb=GetRecord&metadataPrefix=mets&identifier=oai:de:slub-dresden:db:id-263566811
    http://www.dfg-viewer.de/show/?tx_dlf%5Bid%5D=http%3A%2F%2Fdigital.slub-dresden.de%2Foai%2F%3Fverb%3DGetRecord%26metadataPrefix%3Dmets%26identifier%3Doai%3Ade%3Aslub-dresden%3Adb%3Aid-263566811
    -->    
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="xmlid" select="substring-before(substring-after(tei:TEI/@xml:id, 'mss_'), '_tei-msDesc')"/>
        <xsl:variable name="WDBpath" select="concat('https://', descendant::tei:ptr[@type='purl']/substring-before(substring-after(@target, 'http://'), '/start.htm'))"/>
        <xsl:variable name="WDBfolder" select="descendant::tei:ptr[@type='purl']/substring-before(substring-after(@target, 'mss/'), '/start.htm')"/>
        <xsl:variable name="thumbnail" select="substring-after(descendant::tei:ptr[@type='thumbnailForPresentations']/@target, 'thumbs/')"/>
        <mets:mets xmlns:mods="http://www.loc.gov/mods/v3" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/mods.xsd http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/mets.xsd">
            <mets:metsHdr CREATEDATE="{current-dateTime()}">
                <mets:agent OTHERTYPE="SOFTWARE" ROLE="CREATOR" TYPE="OTHER">
                    <mets:name>Handschriftendatenbank der Herzog August Bibliothek Wolfenbüttel</mets:name>
                </mets:agent>
            </mets:metsHdr>
            <mets:dmdSec ID="DMDLOG_0000">
                <mets:mdWrap MDTYPE="TEIHDR">
                    <mets:xmlData>
                        <xsl:copy-of select="descendant::tei:teiHeader"/>
                    </mets:xmlData>
                </mets:mdWrap>
            </mets:dmdSec>
            <xsl:for-each select="descendant::tei:msDesc//tei:msItem">
                <mets:dmdSec ID="DMDLOG_{format-number(count(preceding::tei:msItem), '0000')}">
                    <mets:mdWrap MDTYPE="MODS">
                        <mets:xmlData>
                            <mods:mods>
                                <mods:titleInfo>
                                    <mods:title><xsl:value-of select="tei:title"/></mods:title>
                                </mods:titleInfo>
                            </mods:mods>
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:dmdSec>
            </xsl:for-each>
            <mets:amdSec ID="AMD">
                <mets:rightsMD ID="RIGHTS">
                    <mets:mdWrap MDTYPE="OTHER" MIMETYPE="text/xml" OTHERMDTYPE="DVRIGHTS">
                        <mets:xmlData>
                            <dv:rights>
                                <dv:owner>Herzog August Bibliothek Wolfenbüttel</dv:owner>
                                <dv:ownerLogo>http://www.hab.de/images/logo_dfg_viewer.gif</dv:ownerLogo><!--http://diglib.hab.de/images/logo_trans.gif-->
                                <dv:ownerSiteURL>http://www.hab.de/</dv:ownerSiteURL>
                                <dv:ownerContact>mailto:auskunft@hab.de</dv:ownerContact>
                            </dv:rights>
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:rightsMD>
                <mets:digiprovMD ID="DIGIPROV">
                    <mets:mdWrap MDTYPE="OTHER" MIMETYPE="text/xml" OTHERMDTYPE="DVLINKS">
                        <mets:xmlData>
                            <dv:links>
                                <dv:reference>http://diglib.hab.de/?mss&amp;list=ms&amp;id=<xsl:value-of select="$xmlid"/></dv:reference>
                                <dv:presentation><xsl:value-of select="$WDBpath"/>/start.htm</dv:presentation>
                                <xsl:if test="unparsed-text-available(concat('https://iiif.hab.de/object/mss_', $WDBfolder, '/manifest.json'))">
                                    <dv:iiif><xsl:value-of select="concat('https://iiif.hab.de/object/mss_', $WDBfolder, '/manifest.json')"/></dv:iiif>
                                </xsl:if>
                            </dv:links>
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:digiprovMD>
            </mets:amdSec>
            <mets:fileSec>
                <mets:fileGrp USE="DOWNLOAD">
                    <xsl:for-each select="descendant::tei:graphic">
                        <xsl:variable name="imageID" select="tokenize(@xml:id, '_')[last()]"/>
                        <mets:file ID="FILE_{$imageID}_DOWNLOAD" MIMETYPE="application/pdf">
                            <mets:FLocat LOCTYPE="URL" xlink:href="{$WDBpath}/download/{$imageID}.pdf"/>
                        </mets:file>
                    </xsl:for-each>
                </mets:fileGrp>
                <mets:fileGrp USE="THUMBS">
                    <xsl:for-each select="descendant::tei:graphic">
                        <xsl:variable name="imageID" select="tokenize(@xml:id, '_')[last()]"/>
                        <mets:file ID="FILE_{$imageID}_THUMBS" MIMETYPE="image/jpeg">
                            <xsl:if test="contains(current()/@url, $thumbnail)"><xsl:attribute name="USE" select=" 'PREVIEW' "/></xsl:if>
                            <!--<xsl:if test="position() = 1"><xsl:attribute name="USE" select=" 'PREVIEW' "/></xsl:if>-->
                            <mets:FLocat LOCTYPE="URL" xlink:href="{$WDBpath}/thumbs/{$imageID}.jpg"/>
                        </mets:file>
                    </xsl:for-each>
                </mets:fileGrp>
                <mets:fileGrp USE="DEFAULT">
                    <xsl:for-each select="descendant::tei:graphic">
                        <xsl:variable name="imageID" select="tokenize(@xml:id, '_')[last()]"/>
                        <mets:file ID="FILE_{$imageID}_DEFAULT" MIMETYPE="image/jpeg">
                            <xsl:if test="contains(current()/@url, $thumbnail)"><xsl:attribute name="USE" select=" 'PREVIEW' "/></xsl:if>
                            <!--<xsl:if test="position() = 1"><xsl:attribute name="USE" select=" 'PREVIEW' "/></xsl:if>-->
                            <xsl:choose>
                                <xsl:when test="preceding::tei:name[@type='project'] ='Manuscripts from German-Speaking Lands – A Polonsky Foundation Digitization Project' ">
                                    <mets:FLocat LOCTYPE="URL" xlink:href="https://iiif.hab.de/object/mss_{$WDBfolder}/image/image_{substring-after(@xml:id, concat($WDBfolder, '_'))}/full/full/0/default.jpg"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <mets:FLocat LOCTYPE="URL" xlink:href="{$WDBpath}/{$imageID}.jpg"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </mets:file>
                    </xsl:for-each>
                </mets:fileGrp>
                <mets:fileGrp USE="ORIGINAL">
                    <xsl:for-each select="descendant::tei:graphic">
                        <xsl:variable name="imageID" select="tokenize(@xml:id, '_')[last()]"/>
                        <mets:file ID="FILE_{$imageID}_ORIGINAL" MIMETYPE="image/jpeg">
                            <xsl:if test="contains(current()/@url, $thumbnail)"><xsl:attribute name="USE" select=" 'PREVIEW' "/></xsl:if>
                            <!--<xsl:if test="position() = 1"><xsl:attribute name="USE" select=" 'PREVIEW' "/></xsl:if>-->
                            <mets:FLocat LOCTYPE="URL" xlink:href="{$WDBpath}/max/{$imageID}.jpg"/>
                        </mets:file>
                    </xsl:for-each>
                </mets:fileGrp>
                <mets:fileGrp USE="MAX">
                    <xsl:for-each select="descendant::tei:graphic">
                        <xsl:variable name="imageID" select="tokenize(@xml:id, '_')[last()]"/>
                        <mets:file ID="FILE_{$imageID}_MAX" MIMETYPE="image/jpeg">
                            <xsl:if test="contains(current()/@url, $thumbnail)"><xsl:attribute name="USE" select=" 'PREVIEW' "/></xsl:if>
                            <!--<xsl:if test="position() = 1"><xsl:attribute name="USE" select=" 'PREVIEW' "/></xsl:if>-->
                            <mets:FLocat LOCTYPE="URL" xlink:href="{$WDBpath}/max/{$imageID}.jpg"/>
                        </mets:file>
                    </xsl:for-each>
                </mets:fileGrp>
                <mets:fileGrp USE="MIN">
                    <xsl:for-each select="descendant::tei:graphic">
                        <xsl:variable name="imageID" select="tokenize(@xml:id, '_')[last()]"/>
                        <mets:file ID="FILE_{$imageID}_MIN" MIMETYPE="image/jpeg">
                            <xsl:if test="contains(current()/@url, $thumbnail)"><xsl:attribute name="USE" select=" 'PREVIEW' "/></xsl:if>
                            <!--<xsl:if test="position() = 1"><xsl:attribute name="USE" select=" 'PREVIEW' "/></xsl:if>-->
                            <mets:FLocat LOCTYPE="URL" xlink:href="{$WDBpath}/min/{$imageID}.jpg"/>
                        </mets:file>
                    </xsl:for-each>
                </mets:fileGrp>
            </mets:fileSec>
            <mets:structMap TYPE="LOGICAL">
                <mets:div ADMID="AMD" CONTENTIDS="http://diglib.hab.de/?db=mss&amp;list=ms&amp;id={$xmlid}" DMDID="DMDLOG_0000" ID="LOG_0000" LABEL="{descendant::tei:msDesc/tei:head/tei:title}" TYPE="manuscript">
                </mets:div>
            </mets:structMap>
            <mets:structMap TYPE="PHYSICAL">
                <mets:div ID="PHYS_0000" TYPE="physSequence">
                    <mets:fptr FILEID="FULLDOWNLOAD"/>
                    <xsl:for-each select="descendant::tei:graphic">
                        <xsl:variable name="imageID" select="tokenize(@xml:id, '_')[last()]"/>
                        <mets:div ID="PHYS_{$imageID}" ORDER="{count(preceding-sibling::tei:graphic)+1}" ORDERLABEL="{@n}" TYPE="page">
                            <mets:fptr FILEID="FILE_{$imageID}_DOWNLOAD"/>
                            <mets:fptr FILEID="FILE_{$imageID}_THUMBS"/>
                            <mets:fptr FILEID="FILE_{$imageID}_DEFAULT"/>
                            <!--<mets:fptr FILEID="FILE_{$imageID}_ORIGINAL"/>-->
                            <mets:fptr FILEID="FILE_{$imageID}_MAX"/>
                            <mets:fptr FILEID="FILE_{$imageID}_MIN"/>
                        </mets:div>
                    </xsl:for-each>
                </mets:div>
                <!-- ... -->
            </mets:structMap>
            <mets:structLink>
                <mets:smLink xlink:from="LOG_0000" xlink:to="PHYS_0000"/>
                <xsl:for-each select="descendant::tei:graphic">
                    <xsl:variable name="imageID" select="tokenize(@xml:id, '_')[last()]"/>
                    <mets:smLink xlink:from="LOG_0000" xlink:to="PHYS_{$imageID}"/>
                </xsl:for-each>
            </mets:structLink>
        </mets:mets>
    </xsl:template>
    
</xsl:stylesheet>