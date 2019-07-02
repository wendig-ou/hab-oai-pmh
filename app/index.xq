xquery version "3.1";

declare namespace oais = "http://exist-db.org/apps/hab-oai-pmh/settings";
declare option exist:serialize "method=html media-type=text/html";
import module namespace oai="http://exist-db.org/apps/oai/pmh" at 'oai.xqm';

let $favicon-url := oai:profile()/oais:favicon-url/text(),
    $logo-1-url := oai:profile()/oais:logo-1-url/text(),
    $logo-2-url := oai:profile()/oais:logo-2-url/text()
return
<html>
    <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge" />

        <title>HAB: eXist-db OAI-PMH</title>

        <link rel="icon" href="{$favicon-url}" />
    
        <link rel="stylesheet" href="https://bootswatch.com/4/materia/bootstrap.min.css"/>
        <link rel="stylesheet" href="app.css"/>
    </head>
    
    <nav class="navbar navbar-expand-lg navbar-light bg-light justify-content-start">
        <a class="navbar-brand mr-3 d-none d-md-block">
            <img src="{$logo-1-url}" class="srg-logo-secondary"/>
        </a>
        <a href="http://www.hab.de/en/home.html" target="_blank" rel="noopener" class="navbar-brand">
            Herzog August Bibliothek Wolfenbüttel<br/>
            <small>eXist-db OAI-PMH Interface</small>
        </a>
        <a class="navbar-brand ml-3 d-none d-md-block">
            <img src="{$logo-2-url}" class="srg-logo-secondary"/>
        </a>
    </nav>
  
    <div class="container main">
        <p class="lead my-5">
            This is the
            <a href="https://www.openarchives.org/OAI/openarchivesprotocol.html" target="_bank" rel="noopener">OAI-PMH</a>
            interface for the 
            <a href="http://diglib.hab.de/?db=mss&amp;lang=en" target="_blank" rel="noopener">HAB Manuscript Database</a>.
        </p>
      
        <p class="font-weight-bold mt-5 mb-3">Usage Examples:</p>
        
        <div class="my-3">
            GetRecord
            <div class="small">
                <a href="oai-pmh?verb=GetRecord&amp;identifier=HAB_mss_19-10-aug-4f_tei-msDesc&amp;metadataPrefix=oai_tei" target="_blank">
                    oai-pmh?verb=GetRecord&amp;identifier=HAB_mss_19-10-aug-4f_tei-msDesc&amp;metadataPrefix=oai_tei
                </a>
            </div>
        </div>
        
        <div class="my-3">
            Identify
            <div class="small">
                <a href="oai-pmh?verb=Identify" target="_blank">
                    oai-pmh?verb=Identify
                </a>
            </div>
        </div>
        
        <div class="my-3">
            ListIdentifiers
            <div class="small">
                <a href="oai-pmh?verb=ListIdentifiers&amp;metadataPrefix=oai_dc" target="_blank">
                    oai-pmh?verb=ListIdentifiers&amp;metadataPrefix=oai_dc
                </a>
            </div>
        </div>
        
        <div class="my-3">
            ListMetadataFormats
            <div class="small">
                <a href="oai-pmh?verb=ListMetadataFormats" target="_blank">
                    oai-pmh?verb=ListMetadataFormats
                </a>
            </div>
        </div>
        
        <div class="my-3">
            ListRecords
            <div class="small">
                <a href="oai-pmh?verb=ListRecords&amp;metadataPrefix=oai_dc" target="_blank">
                    oai-pmh?verb=ListRecords&amp;metadataPrefix=oai_dc
                </a>
            </div>
        </div>
        
        <div class="my-3">
            ListSets
            <div class="small">
                <a href="oai-pmh?verb=ListSets" target="_blank">
                    oai-pmh?verb=ListSets
                </a>
            </div>
        </div>
      
    </div>
    
    <div class="p-5 mt-5 border-top footer">
        <p class="lead mb-0 text-center">
            service provided by
            <br/>
            <a href="http://www.hab.de" target="_blank" rel="noopener">Herzog August Bibliothek Wolfenbüttel</a>
            <br/>
            <small class="d-block">implementation by
                <a href="https://wendig.io" target="_blank" rel="noopener">Wendig</a>
            </small>
            <img src="https://upload.wikimedia.org/wikipedia/commons/5/5c/BMBF_Logo.svg" class="srg-logo mt-3"/>
        </p>
    </div>
</html>