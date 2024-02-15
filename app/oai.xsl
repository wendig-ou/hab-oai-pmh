<!--

  XSL Transform to convert OAI 2.0 responses into XHTML

  By Christopher Gutteridge, University of Southampton

  v1.1

--><!--

Copyright (c) 2000-2004 University of Southampton, UK. SO17 1BJ.

EPrints 2 is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

EPrints 2 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with EPrints 2; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

This version was adapted for the Wolfenbuettel Digital Libray (http://www.hab.de/bibliothek/wdb/); it supports MODS and METS and provides a link to the so-called DFG Viewer (www.dfg-viewer.de).

By Thomas Staecker, Herzog August Bibliothek Wolfenbuettel, 2008

This version was adapted for the Wolfenbuettel Digital Libray (http://www.hab.de/bibliothek/wdb/); it adds a TEI link to the record output

By Moritz Schepp, Wendig OÜ, 2019

This version was adapted to add an OAI-MPH for the manuscripts; it adds a METS link and a link to the DFG-Viewer to the record output

By Torsten Schassan, Herzog August Bibliothek Wolfenbuettel, 2020
--><!--

  All the elements really needed for EPrints are done but if
  you want to use this XSL for other OAI archive you may want
  to make some minor changes or additions.

  Not Done
    The 'about' section of 'record'
    The 'compession' part of 'identify'
    The optional attributes of 'resumptionToken'
    The optional 'setDescription' container of 'set'

  All the links just link to oai_dc versions of records.

--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:file="http://exist-db.org/xquery/file" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:rights="http://www.openarchives.org/OAI/2.0/rights/" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">
    <xsl:output method="html"/>
    <xsl:template name="style"> 
        td.value {
            vertical-align: top; 
            padding-left: 1em; 
            padding: 3px; 
        }
        td.key { 
            background-color: #e0e0ff; 
            padding: 3px; 
            text-align: right; 
            border: 1px solid #c0c0c0; 
            white-space: nowrap; 
            font-weight: bold; 
            vertical-align: top; 
        } 
        .dcdata td.key {
            background-color: #ffffe0; 
        } 
        body { 
            margin: 1em 2em 1em 2em; 
        } 
        h1, h2, h3 {
            font-family:verdana,arial,helvetica,sans-serif; 
            color:#900129; 
            font-weight:600; 
            clear: left;
        } 
        h1 { 
            padding-bottom: 4px; 
            margin-bottom: 0px; 
            font-size:12pt; 
        } 
        h2 { 
            margin-bottom: 0.5em;
            font-size:12pt; 
        } 
        h3 { 
            margin-bottom: 0.3em; 
            font-size: medium; 
        } 
        a {
            font-family:verdana,arial,helvetica,sans-serif; 
            color:#900129; 
            text-decoration:none;
            text-align:left; 
        } 
        a:hover { 
            color:#900129; 
            font-weight: bold; 
            text-decoration:none;
            text-align:left; 
        } 
        .link { 
            border: 1px outset #88f; 
            background-color: #B9B1B7; 
            padding: 1px 4px 1px 4px; 
            font-size: 80%; 
            text-decoration: none; 
            font-weight: bold; 
            font-family: sans-serif; 
            color: #900129; 
        } 
        .link:hover { 
            background-color: #EEE; 
            color: #900129; 
        }
        .link:active { 
            color: red; 
            border: 1px inset #88f; 
            background-color: #a0a0df; 
        } 
        .oaiRecord, .oaiRecordTitle { 
            background-color: #f0f0ff; 
            border-style: solid; 
            border-color: #d0d0d0; 
        }
        h2.oaiRecordTitle { 
            background-color: #e0e0ff; 
            font-size: medium; 
            font-weight: bold;
            padding: 10px; 
            border-width: 2px 2px 0px 2px; 
            margin: 0px; 
        } 
        .oaiRecord { 
            margin-bottom: 3em; 
            border-width: 2px; 
            padding: 10px; 
        } 
        .results { 
            margin-bottom: 1.5em; 
        } 
        ul.quicklinks { 
            margin-top: 2px; 
            padding: 4px; 
            text-align: left; 
            border-bottom: 2px solid #ccc; 
            border-top: 2px solid #ccc; 
            clear: left; 
        } 
        ul.quicklinks li { 
            font-size: 80%; 
            display: inline;
            list-stlye: none; 
            font-family: sans-serif; 
        } 
        p.intro { font-family:verdana,arial,helvetica,sans-serif; font-size: 80%; } 
        <xsl:call-template name="xmlstyle"/>
    </xsl:template>
    <xsl:variable name="identifier" select="/oai:OAI-PMH/oai:request/@identifier"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>OAI 2.0 Request Results - WDB</title>
                <style>
                    <xsl:call-template name="style"/>
                </style>
            </head>
            <body>
                <h1>
                    <a href="http://www.hab.de"><img src="https://diglib.hab.de/rules/styles/images/HAB_Logo_violett-100Pixel.jpg" alt="" style="border: 0;"/></a> 
                       OAI 2.0 Request Results - <a href="https://diglib.hab.de/">Wolfenbuettel Digital Library</a>
                </h1>
                <xsl:call-template name="quicklinks"/>
                <p class="intro">You are viewing an HTML version of the XML OAI response. To see the underlying XML use your web browsers view source option. More information about this XSLT is at the <a href="#moreinfo">bottom of the page</a>.</p>
                <xsl:apply-templates select="/oai:OAI-PMH"/>
                <xsl:call-template name="quicklinks"/>
                <h3>
                    <a name="moreinfo">About the XSLT</a>
                </h3>
                <p class="intro">An XSLT file has converted the <a href="http://www.openarchives.org">OAI-PMH 2.0</a> responses into XHTML which looks nice in a browser which supports XSLT such as Mozilla, Firebird and Internet Explorer. The XSLT file was created by <a href="http://www.ecs.soton.ac.uk/people/cjg">Christopher Gutteridge</a> at the University of Southampton as part of the <a href="http://software.eprints.org">GNU EPrints system</a>, and is freely redistributable under the <a href="http://www.gnu.org">GPL</a>. It was slightly adapted for the Wolfenbuettel Digital Libary.</p>
                <p class="intro">If you want to use the XSL file on your own OAI interface you may but due to the way XSLT works you must install the XSL file on the same server as the OAI script, you can't just link to this copy.</p>
                <p class="intro">For more information or to download the XSL file please see the <a href="http://software.eprints.org/xslt.php">OAI to XHTML XSLT homepage</a>. The Wolfenbuettel version containing minor changes can be downloaded <a href="oai.xsl">here</a>.</p>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="quicklinks">
        <ul class="quicklinks">
            <li><a href="?verb=Identify">Identify</a> | </li>
            <li><a href="?verb=ListRecords&amp;metadataPrefix=oai_dc">ListRecords</a> | </li>
            <li><a href="?verb=ListSets">ListSets</a> | </li>
            <li><a href="?verb=ListMetadataFormats">ListMetadataFormats</a> | </li>
            <li><a href="?verb=ListIdentifiers&amp;metadataPrefix=oai_dc">ListIdentifiers</a></li>
        </ul>
    </xsl:template>
    <xsl:template match="/oai:OAI-PMH">
        <table class="values">
            <tr>
                <td class="key">Datestamp of response</td>
                <td class="value">
                    <xsl:value-of select="oai:responseDate"/>
                </td>
            </tr>
            <tr>
                <td class="key">Request URL</td>
                <td class="value">
                    <!--<xsl:value-of select="oai:request"/>-->
                    <xsl:value-of select=" 'https://oaimss.hab.de/oai-pmh' "/>
                </td>
            </tr>
        </table>
        <!--  verb: [<xsl:value-of select="oai:request/@verb" />]<br /> -->
        <xsl:choose>
            <xsl:when test="oai:error">
                <h2>OAI Error(s)</h2>
                <p>The request could not be completed due to the following error or errors.</p>
                <div class="results">
                    <xsl:apply-templates select="oai:error"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <p>Request was of type <xsl:value-of select="oai:request/@verb"/>.</p>
                <div class="results">
                    <xsl:apply-templates select="oai:Identify"/>
                    <xsl:apply-templates select="oai:GetRecord"/>
                    <xsl:apply-templates select="oai:ListRecords"/>
                    <xsl:apply-templates select="oai:ListSets"/>
                    <xsl:apply-templates select="oai:ListMetadataFormats"/>
                    <xsl:apply-templates select="oai:ListIdentifiers"/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ERROR -->
    <xsl:template match="/oai:OAI-PMH/oai:error">
        <table class="values">
            <tr>
                <td class="key">Error Code</td>
                <td class="value">
                    <xsl:value-of select="@code"/>
                </td>
            </tr>
        </table>
        <p class="error">
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    <!-- IDENTIFY -->
    <xsl:template match="/oai:OAI-PMH/oai:Identify">
        <table class="values">
            <tr>
                <td class="key">Repository Name</td>
                <td class="value"><xsl:value-of select="oai:repositoryName"/></td>
            </tr>
            <tr>
                <td class="key">Base URL</td>
                <td class="value"><xsl:value-of select="oai:baseURL"/></td>
            </tr>
            <tr>
                <td class="key">Protocol Version</td>
                <td class="value"><xsl:value-of select="oai:protocolVersion"/></td>
            </tr>
            <tr>
                <td class="key">Earliest Datestamp</td>
                <td class="value"><xsl:value-of select="oai:earliestDatestamp"/></td>
            </tr>
            <tr>
                <td class="key">Deleted Record Policy</td>
                <td class="value"><xsl:value-of select="oai:deletedRecord"/></td>
            </tr>
            <tr>
                <td class="key">Granularity</td>
                <td class="value"><xsl:value-of select="oai:granularity"/></td>
            </tr>
            <xsl:apply-templates select="oai:adminEmail"/>
        </table>
        <xsl:apply-templates select="oai:description"/>
        <!--no warning about unsupported descriptions -->
    </xsl:template>
    <xsl:template match="/oai:OAI-PMH/oai:Identify/oai:adminEmail">
        <tr>
            <td class="key">Admin Email</td>
            <td class="value"><xsl:value-of select="."/></td>
        </tr>
    </xsl:template>
    <!-- Identify / Unsupported Description
-->
    <xsl:template match="oai:description/*" priority="-100">
        <h2>Unsupported Description Type</h2>
        <p>The XSL currently does not support this type of description.</p>
        <div class="xmlSource">
            <xsl:apply-templates select="." mode="xmlMarkup"/>
        </div>
    </xsl:template>
    <!-- Identify / OAI-Identifier
-->
    <xsl:template xmlns:id="http://www.openarchives.org/OAI/2.0/oai-identifier" match="id:oai-identifier">
        <h2>OAI-Identifier</h2>
        <table class="values">
            <tr>
                <td class="key">Scheme</td>
                <td class="value">
                    <xsl:value-of select="id:scheme"/>
                </td>
            </tr>
            <tr>
                <td class="key">Repository Identifier</td>
                <td class="value">
                    <xsl:value-of select="id:repositoryIdentifier"/>
                </td>
            </tr>
            <tr>
                <td class="key">Delimiter</td>
                <td class="value">
                    <xsl:value-of select="id:delimiter"/>
                </td>
            </tr>
            <tr>
                <td class="key">Sample OAI Identifier</td>
                <td class="value">
                    <xsl:value-of select="id:sampleIdentifier"/>
                </td>
            </tr>
        </table>
    </xsl:template>
    <!-- Identify / EPrints -->
    <xsl:template xmlns:ep="http://www.openarchives.org/OAI/1.1/eprints" match="ep:eprints">
        <h2>EPrints Description</h2>
        <xsl:if test="ep:content">
            <h3>Content</h3>
            <xsl:apply-templates select="ep:content"/>
        </xsl:if>
        <xsl:if test="ep:submissionPolicy">
            <h3>Submission Policy</h3>
            <xsl:apply-templates select="ep:submissionPolicy"/>
        </xsl:if>
        <h3>Metadata Policy</h3>
        <xsl:apply-templates select="ep:metadataPolicy"/>
        <h3>Data Policy</h3>
        <xsl:apply-templates select="ep:dataPolicy"/>
        <xsl:apply-templates select="ep:comment"/>
    </xsl:template>
    <xsl:template xmlns:ep="http://www.openarchives.org/OAI/1.1/eprints" match="ep:content | ep:dataPolicy | ep:metadataPolicy | ep:submissionPolicy">
        <xsl:if test="ep:text">
            <p>
                <xsl:value-of select="ep:text"/>
            </p>
        </xsl:if>
        <xsl:if test="ep:URL">
            <div>
                <a href="{ep:URL}">
                    <xsl:value-of select="ep:URL"/>
                </a>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template xmlns:ep="http://www.openarchives.org/OAI/1.1/eprints" match="ep:comment">
        <h3>Comment</h3>
        <div>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <!-- Identify / Friends -->
    <xsl:template xmlns:fr="http://www.openarchives.org/OAI/2.0/friends/" match="fr:friends">
        <h2>Friends</h2>
        <ul>
            <xsl:apply-templates select="fr:baseURL"/>
        </ul>
    </xsl:template>
    <xsl:template xmlns:fr="http://www.openarchives.org/OAI/2.0/friends/" match="fr:baseURL">
        <li>
            <xsl:value-of select="."/>
            <xsl:text> </xsl:text>
            <a class="link" href="{.}?verb=Identify">Identify</a>
        </li>
    </xsl:template>
    <!-- Identify / Branding -->
    <xsl:template xmlns:br="http://www.openarchives.org/OAI/2.0/branding/" match="br:branding">
        <h2>Branding</h2>
        <xsl:apply-templates select="br:collectionIcon"/>
        <xsl:apply-templates select="br:metadataRendering"/>
    </xsl:template>
    <xsl:template xmlns:br="http://www.openarchives.org/OAI/2.0/branding/" match="br:collectionIcon">
        <h3>Icon</h3>
        <xsl:choose>
            <xsl:when test="link != ''">
                <a href="{br:link}">
                    <img src="{br:url}" alt="{br:title}" width="{br:width}" height="{br:height}" border="0"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <img src="{br:url}" alt="{br:title}" width="{br:width}" height="{br:height}" border="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template xmlns:br="http://www.openarchives.org/OAI/2.0/branding/" match="br:metadataRendering">
        <h3>Metadata Rendering Rule</h3>
        <table class="values">
            <tr>
                <td class="key">URL</td>
                <td class="value">
                    <xsl:value-of select="."/>
                </td>
            </tr>
            <tr>
                <td class="key">Namespace</td>
                <td class="value">
                    <xsl:value-of select="@metadataNamespace"/>
                </td>
            </tr>
            <tr>
                <td class="key">Mime Type</td>
                <td class="value">
                    <xsl:value-of select="@mimetype"/>
                </td>
            </tr>
        </table>
    </xsl:template>
    <!-- Identify / Gateway -->
    <xsl:template xmlns:gw="http://www.openarchives.org/OAI/2.0/gateway/x" match="gw:gateway">
        <h2>Gateway Information</h2>
        <table class="values">
            <tr>
                <td class="key">Source</td>
                <td class="value">
                    <xsl:value-of select="gw:source"/>
                </td>
            </tr>
            <tr>
                <td class="key">Description</td>
                <td class="value">
                    <xsl:value-of select="gw:gatewayDescription"/>
                </td>
            </tr>
            <xsl:apply-templates select="gw:gatewayAdmin"/>
            <xsl:if test="gw:gatewayURL">
                <tr>
                    <td class="key">URL</td>
                    <td class="value">
                        <xsl:value-of select="gw:gatewayURL"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="gw:gatewayNotes">
                <tr>
                    <td class="key">Notes</td>
                    <td class="value">
                        <xsl:value-of select="gw:gatewayNotes"/>
                    </td>
                </tr>
            </xsl:if>
        </table>
    </xsl:template>
    <xsl:template xmlns:gw="http://www.openarchives.org/OAI/2.0/gateway/" match="gw:gatewayAdmin">
        <tr>
            <td class="key">Admin</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <!-- GetRecord -->
    <xsl:template match="oai:GetRecord">
        <xsl:apply-templates select="oai:record"/>
    </xsl:template>
    <!-- ListRecords -->
    <xsl:template match="oai:ListRecords">
        <xsl:apply-templates select="oai:record"/>
        <xsl:apply-templates select="oai:resumptionToken"/>
    </xsl:template>
    <!-- ListIdentifiers -->
    <xsl:template match="oai:ListIdentifiers">
        <xsl:apply-templates select="oai:header"/>
        <xsl:apply-templates select="oai:resumptionToken"/>
    </xsl:template>
    <!-- ListSets -->
    <xsl:template match="oai:ListSets">
        <xsl:apply-templates select="oai:set"/>
        <xsl:apply-templates select="oai:resumptionToken"/>
    </xsl:template>
    <xsl:template match="oai:set">
        <h2>Set</h2>
        <table class="values">
            <tr>
                <td class="key">setName</td>
                <td class="value">
                    <xsl:value-of select="oai:setName"/>
                </td>
            </tr>
            <xsl:apply-templates select="oai:setSpec"/>
        </table>
    </xsl:template>
    <!-- ListMetadataFormats -->
    <xsl:template match="oai:ListMetadataFormats">
        <xsl:choose>
            <xsl:when test="$identifier">
                <p>This is a list of metadata formats available for the record "<xsl:value-of select="$identifier"/>". Use these links to view the metadata:
                    <xsl:apply-templates select="oai:metadataFormat/oai:metadataPrefix"/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>This is a list of metadata formats available from this archive.</p>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="oai:metadataFormat"/>
    </xsl:template>
    <xsl:template match="oai:metadataFormat">
        <h2>Metadata Format</h2>
        <table class="values">
            <tr>
                <td class="key">metadataPrefix</td>
                <td class="value"><xsl:value-of select="oai:metadataPrefix"/></td>
            </tr>
            <tr>
                <td class="key">metadataNamespace</td>
                <td class="value"><xsl:value-of select="oai:metadataNamespace"/></td>
            </tr>
            <tr>
                <td class="key">schema</td>
                <td class="value"><a href="{oai:schema}"><xsl:value-of select="oai:schema"/></a></td>
            </tr>
        </table>
    </xsl:template>
    <xsl:template match="oai:metadataPrefix">
         <a class="link" href="?verb=GetRecord&amp;metadataPrefix={.}&amp;identifier={$identifier}">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    <!-- record object -->
    <xsl:template match="oai:record">
        <h2 class="oaiRecordTitle">OAI Record: <xsl:value-of select="oai:header/oai:identifier"/></h2>
        <div class="oaiRecord">
            <xsl:apply-templates select="oai:header"/>
            <xsl:apply-templates select="oai:metadata"/>
            <xsl:apply-templates select="oai:about"/>
        </div>
    </xsl:template>
    <xsl:template match="oai:header">
        <h3>OAI Record Header</h3>
        <table class="values">
            <tr>
                <td class="key">OAI Identifier</td>
                <td class="value">
                    <xsl:value-of select="oai:identifier"/>
                     <a class="link" href="?verb=GetRecord&amp;metadataPrefix=oai_dc&amp;identifier={oai:identifier}">oai_dc</a>
                     <a class="link" href="?verb=GetRecord&amp;metadataPrefix=oai_tei&amp;identifier={oai:identifier}">oai_tei</a>
                     <a class="link" href="?verb=GetRecord&amp;metadataPrefix=oai_mets&amp;identifier={oai:identifier}">oai_mets</a>
                    <!--<xsl:if test="oai:metadata/descendant::tei:date[@type='digitised']">-->
                         <a class="link" href="http://dfg-viewer.de/show/?tx_dlf[id]=https%3A%2F%2Foaimss.hab.de%2Foai-pmh%3Fverb%3DGetRecord%26metadataPrefix%3Doai_mets%26identifier%3D{oai:identifier}">display in DFG viewer</a>
                    <!--</xsl:if>-->
                </td>
            </tr>
            <tr>
                <td class="key">Datestamp</td>
                <td class="value">
                    <xsl:value-of select="oai:datestamp"/>
                </td>
            </tr>
            <xsl:apply-templates select="oai:setSpec"/>
        </table>
        <xsl:if test="@status = 'deleted'">
            <p>This record has been deleted.</p>
        </xsl:if>
    </xsl:template>
    <xsl:template match="oai:about">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="rights:rights">
        <h3>Rights</h3>
        <div class="xmlSource">
            <xsl:apply-templates select="." mode="xmlMarkup"/>
        </div>
    </xsl:template>
    <xsl:template match="oai:metadata">
        <div class="metadata">
            <xsl:apply-templates select="*"/>
        </div>
    </xsl:template>
    <!-- oai setSpec object -->
    <xsl:template match="oai:setSpec">
        <tr>
            <td class="key">setSpec</td>
            <td class="value">
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
                <a class="link" href="?verb=ListIdentifiers&amp;metadataPrefix=oai_dc&amp;set={.}">Identifiers</a>
                <xsl:text> </xsl:text>
                <a class="link" href="?verb=ListRecords&amp;metadataPrefix=oai_dc&amp;set={.}">Records</a>
            </td>
        </tr>
    </xsl:template>
    <!-- oai resumptionToken -->
    <xsl:template match="oai:resumptionToken">
        <xsl:if test="./text()">
            <p>There are more results.</p>
            <table class="values">
                <tr>
                    <td class="key">resumptionToken:</td>
                    <td class="value">
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                        <a class="link" href="?verb={/oai:OAI-PMH/oai:request/@verb}&amp;resumptionToken={.}">Resume</a>
                    </td>
                </tr>
                <xsl:if test="@completeListSize">
                    <tr>
                        <td class="key">completeListSize</td>
                        <td class="value">
                            <xsl:value-of select="@completeListSize"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="@cursor">
                    <tr>
                        <td class="key">cursor</td>
                        <td class="value">
                            <xsl:value-of select="@cursor"/>
                        </td>
                    </tr>
                </xsl:if>
            </table>
        </xsl:if>
    </xsl:template>
    <!-- unknown metadata format -->
    <xsl:template match="oai:metadata/*" priority="-100">
        <h3>Unknown Metadata Format</h3>
        <div class="xmlSource">
            <xsl:apply-templates select="." mode="xmlMarkup"/>
        </div>
    </xsl:template>
    <!-- oai_dc record -->
    <xsl:template xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" match="oai_dc:dc">
        <div class="dcdata">
            <h3>Dublin Core Metadata (oai_dc)</h3>
            <table class="dcdata">
                <xsl:apply-templates select="*"/>
            </table>
        </div>
    </xsl:template>
    <!-- mods record -->
    <xsl:template xmlns:mods="http://www.loc.gov/mods/v3" match="mods:mods">
        <h3>Metadata Object Description Schema (mods)</h3>
        <div class="xmlSource">
            <xsl:apply-templates select="." mode="xmlMarkup"/>
        </div>
    </xsl:template>
    <!-- mets record -->
    <xsl:template xmlns:mets="http://www.loc.gov/METS/" match="mets:mets">
        <h3>Metadata Encoding and Transmission Standard (mets)</h3>
        <div class="xmlSource">
            <xsl:apply-templates select="." mode="xmlMarkup"/>
        </div>
    </xsl:template>
    <!-- tei record -->
    <xsl:template match="tei:TEI">
        <h3>Text Encoding and Interchange Standard (tei)</h3>
        <div class="xmlSource">
            <xsl:apply-templates select="." mode="xmlMarkup"/>
        </div>
    </xsl:template>
    <!-- museumdat record -->
    <xsl:template xmlns:museumdat="http://museum.zib.de/museumdat" match="museumdat:museumdat">
        <h3>Museumdat (museumdat)</h3>
        <div class="xmlSource">
            <xsl:apply-templates select="." mode="xmlMarkup"/>
        </div>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:title">
        <tr>
            <td class="key">Title</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:creator">
        <tr>
            <td class="key">Author or Creator</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:subject">
        <tr>
            <td class="key">Subject and Keywords</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:description">
        <tr>
            <td class="key">Description</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:publisher">
        <tr>
            <td class="key">Publisher</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:contributor">
        <tr>
            <td class="key">Other Contributor</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:date">
        <tr>
            <td class="key">Date</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:type">
        <tr>
            <td class="key">Resource Type</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:format">
        <tr>
            <td class="key">Format</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:identifier">
        <tr>
            <td class="key">Resource Identifier</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:source">
        <tr>
            <td class="key">Source</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:language">
        <tr>
            <td class="key">Language</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:relation">
        <tr>
            <td class="key">Relation</td>
            <td class="value">
                <xsl:choose>
                    <xsl:when test="starts-with(.,&#34;http&#34; )">
                        <xsl:choose>
                            <xsl:when test="string-length(.) &gt; 50">
                                <a class="link" href="{.}">URL</a>
                                <i>URL not shown as it is very long.</i>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="{.}">
                                    <xsl:value-of select="."/>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:coverage">
        <tr>
            <td class="key">Coverage</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template xmlns:dc="http://purl.org/dc/elements/1.1/" match="dc:rights">
        <tr>
            <td class="key">Rights Management</td>
            <td class="value">
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <!-- XML Pretty Maker -->
    <xsl:template match="node()" mode="xmlMarkup">
        <div class="xmlBlock">
            &lt;<span class="xmlTagName"><xsl:value-of select="name(.)"/></span><xsl:apply-templates select="@*" mode="xmlMarkup"/>&gt;
                <xsl:apply-templates select="node()" mode="xmlMarkup"/>
            &lt;/<span class="xmlTagName"><xsl:value-of select="name(.)"/></span>&gt;
        </div>
    </xsl:template>
    <xsl:template match="text()" mode="xmlMarkup">
        <span class="xmlText">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <xsl:template match="@*" mode="xmlMarkup">
         <span class="xmlAttrName"><xsl:value-of select="name()"/></span>="<span class="xmlAttrValue"><xsl:value-of select="."/></span>"
    </xsl:template>
    <xsl:template name="xmlstyle"> 
        .xmlSource { 
            font-size: 70%; 
            border: solid #c0c0a0 1px;
            background-color: #ffffe0; 
            padding: 2em 2em 2em 0em; 
        } 
        .xmlBlock { padding-left: 2em; }
        .xmlTagName { color: #800000; font-weight: bold; } 
        .xmlAttrName { font-weight: bold; }
        .xmlAttrValue { color: #0000c0; }
    </xsl:template>
</xsl:stylesheet>