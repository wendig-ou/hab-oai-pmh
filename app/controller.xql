xquery version "3.0";

declare option exist:serialize "method=xml media-type=text/xml";

(: import module namespace console="http://exist-db.org/xquery/console"; :)

declare variable $exist:path external;
declare variable $exist:root external;
declare variable $exist:prefix external;
declare variable $exist:controller external;
declare variable $exist:resource external;

declare variable $verb := request:get-parameter('verb', '');
declare variable $identifier := request:get-parameter('identifier', '');
declare variable $metadataPrefix := request:get-parameter('metadataPrefix', '');
declare variable $from := request:get-parameter('from', '');
declare variable $until := request:get-parameter('until', '');
declare variable $set := request:get-parameter('set', '');
declare variable $resumptionToken := request:get-parameter('resumptionToken', '');

(: declare variable $base-path := concat('/exist', $exist:prefix, $exist:controller); :)

(: declare variable $x := console:log($exist:root);
declare variable $y := console:log($exist:prefix);
declare variable $z := console:log($exist:path);
declare variable $u := console:log($exist:controller);
declare variable $v := console:log($exist:resource); :)

import module namespace oai="http://exist-db.org/apps/oai/pmh" at 'oai.xqm';

switch ($exist:path)
    case '/' return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
          <forward url="index.xq" />
        </dispatch>
    case '/app.css' return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
          <forward url="app.css" />
        </dispatch>
    case '/oai-pmh' return
        switch ($verb)
            (: case 'test' return oai:test() :)
            case 'GetRecord' return oai:get-record($identifier, $metadataPrefix)
            case 'Identify' return oai:identify()
            case 'ListIdentifiers' return oai:list-identifiers($from, $until, $metadataPrefix, $set, $resumptionToken)
            case 'ListMetadataFormats' return oai:list-metadata-formats()
            case 'ListRecords' return oai:list-records($from, $until, $metadataPrefix, $set, $resumptionToken)
            case 'ListSets' return oai:list-sets($resumptionToken)
            default return oai:error('badVerb', 'please specify a correct OAI PMH verb')
    default return (
        let $x := response:set-status-code(404)
        return
            <message>The page could not be found</message>
    )
    