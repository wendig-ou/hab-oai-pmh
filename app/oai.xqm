xquery version "3.0";

(: 
 : 
 : While this OAI-PMH interface exposes Dublin Core, the format is actually not
 : stored in the database but generated on the fly from tei:TEI elements, see
 : function oai:tei-to-dc below.
 : 
 :  :)

module namespace oai = "http://exist-db.org/apps/oai/pmh";

(: import module namespace console="http://exist-db.org/xquery/console"; :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace mets = "http://www.loc.gov/METS/";
declare namespace dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace oais = "http://exist-db.org/apps/hab-oai-pmh/settings";
declare namespace oaid = "http://exist-db.org/apps/hab-oai-pmh/data";

declare variable $oai:profile-name := request:get-parameter('profile', 'default');

(: switch these lines to enable/disable sending an xslt include to the browser :)
declare variable $oai:xslt-pi := processing-instruction xml-stylesheet {'type="text/xsl" href="oai.xsl"'};
(: declare variable $oai:xslt-pi := (); :)

(: oai-pmh verbs and error responses :)

declare function oai:get-record(
    $identifier as xs:string,
    $metadataPrefix as xs:string
) as node()
{
    let $profile := oai:profile(),
        $result := oai:find($profile, $identifier)
    return
        if (not($identifier) or not($metadataPrefix))
        then
            oai:error('badArgument', 'please specify identifier and metadataPrefix')
        else if (not($result))
        then
            oai:error('idDoesNotExist', 'the requested identifier could not be found')
        else if (not($metadataPrefix = 'oai_dc') and not($metadataPrefix = 'oai_tei') and not($metadataPrefix = 'oai_mets'))
        then
            oai:error('cannotDisseminateFormat', 'the requested format is not available for this identifier')
        else
            document {
                $oai:xslt-pi,
                <OAI-PMH
                    xmlns="http://www.openarchives.org/OAI/2.0/"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
                >
                    <responseDate>{oai:ts()}</responseDate>
                    {oai:request()}
                    <GetRecord>
                        <record>
                            {oai:header-for($result)}
                            <metadata>
                                {oai:format($result, $metadataPrefix)}
                            </metadata>
                        </record>
                    </GetRecord>
                </OAI-PMH>
            }
            
};

declare function oai:identify() as node()
{
    let $profile := oai:profile()
    
    return (
        document {
            $oai:xslt-pi,
            <OAI-PMH
                xmlns="http://www.openarchives.org/OAI/2.0/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
            >
                <responseDate>{oai:ts()}</responseDate>
                {oai:request()}
                <Identify>
                    <repositoryName>{$profile/oais:repository-name/text()}</repositoryName>
                    <baseURL>{oai:base-url()}</baseURL>
                    <protocolVersion>2.0</protocolVersion>
                    <adminEmail>{string($profile/oais:admin-email/text())}</adminEmail>
                    <earliestDatestamp>{oai:format-date-time(oai:earliest($profile))}</earliestDatestamp>
                    <deletedRecord>no</deletedRecord>
                    <granularity>YYYY-MM-DDThh:mm:ssZ</granularity>
                </Identify>
            </OAI-PMH>
        }
    )
};

declare function oai:list-identifiers(
    $from_str as xs:string,
    $until_str as xs:string,
    $metadataPrefix_str as xs:string,
    $set_str as xs:string,
    $resumptionToken as xs:string
) as node()
{
    let $profile := oai:profile(),
        $token := oai:find-token('ListIdentifiers', $resumptionToken),
        $from :=  if ($token) then string($token/@from) else $from_str,
        $until :=  if ($token) then string($token/@until) else $until_str,
        $metadataPrefix :=  if ($token) then string($token/@metadataPrefix) else $metadataPrefix_str,
        $set :=  if ($token) then string($token/@set) else $set_str,
        $page := if ($token) then number($token/@page) else 1,
        $per-page := xs:integer($profile/oais:per-page/text())
    
    return
        if ($resumptionToken and not($token))
        then
            oai:error('badResumptionToken', 'the resumptionToken is invalid')
        else if (not($metadataPrefix))
        then
            oai:error('badArgument', 'metadataPrefix must be specified (oai_dc or oai_tei or oai_mets)')
        else if (not($metadataPrefix = 'oai_tei') and not($metadataPrefix = 'oai_dc') and not($metadataPrefix = 'oai_mets'))
        then 
            oai:error('cannotDisseminateFormat', "only 'oai_dc', 'oai_tei', and 'oai_mets' are valid formats")
        else if ($from and not(oai:parse-date-time($from) instance of xs:dateTime))
        then
            oai:error('badArgument', 'from parameter is not in form YYYY-MM-DDTHH:MM:SSZ')
        else if ($until and not(oai:parse-date-time($until) instance of xs:dateTime))
        then
            oai:error('badArgument', 'from parameter is not in form YYYY-MM-DDTHH:MM:SSZ')
        else
            let $filtered := oai:filter(
                    $profile,
                    $from,
                    $until,
                    $set
                ),
                $total := count($filtered),
                $results := oai:paginate($profile, $filtered, $page),
                $new-token := if ($total > $page * $per-page)
                then
                    oai:insert-token(
                        'ListIdentifiers',
                        $metadataPrefix,
                        $from,
                        $until,
                        $set,
                        string($page + 1)
                    )
                else
                    ''
            return (
                if ($total = 0)
                then
                    oai:error('noRecordsMatch', 'no records match your criteria')
                else
                    document {
                        $oai:xslt-pi,
                        <OAI-PMH
                            xmlns="http://www.openarchives.org/OAI/2.0/"
                            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
                        >
                            <responseDate>{oai:ts()}</responseDate>
                            {oai:request()}
                            <ListIdentifiers>
                                {
                                    for $result in $results
                                    return oai:header-for($result)
                                }
                                {
                                    if ($new-token)
                                    then
                                        <resumptionToken completeListSize="{$total}">
                                            {string($new-token/@id)}
                                        </resumptionToken>
                                    else
                                        ''
                                }
                            </ListIdentifiers>
                        </OAI-PMH>
                    }
            )
};

declare function oai:list-metadata-formats() as node()
{
    let $profile := oai:profile()
    
    return
        document {
            $oai:xslt-pi,
            <OAI-PMH
                xmlns="http://www.openarchives.org/OAI/2.0/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
            >
                <responseDate>{oai:ts()}</responseDate>
                {oai:request()}
                <ListMetadataFormats>
                    <metadataFormat>
                        <metadataPrefix>oai_dc</metadataPrefix>
                        <metadataNamespace>http://www.openarchives.org/OAI/2.0/oai_dc/</metadataNamespace>
                        <schema>http://www.openarchives.org/OAI/2.0/oai_dc.xsd</schema>
                    </metadataFormat>
                    <metadataFormat>
                        <metadataPrefix>oai_tei</metadataPrefix>
                        <metadataNamespace>http://www.tei-c.org/ns/1.0</metadataNamespace>
                        <schema>http://diglib.hab.de/rules/schema/mss/v1.0/cataloguing.xsd</schema>
                    </metadataFormat>
                    <metadataFormat>
                        <metadataPrefix>oai_mets</metadataPrefix>
                        <metadataNamespace>http://www.loc.gov/METS/</metadataNamespace>
                        <schema>http://www.loc.gov/standards/mets/mets.xsd</schema>
                    </metadataFormat>
                </ListMetadataFormats>
            </OAI-PMH>
        }
};

declare function oai:list-records(
    $from_str as xs:string,
    $until_str as xs:string,
    $metadataPrefix_str as xs:string,
    $set_str as xs:string,
    $resumptionToken as xs:string
) as node()
{
    let $profile := oai:profile(),
        $token := oai:find-token('ListRecords', $resumptionToken),
        $from :=  if ($token) then string($token/@from) else $from_str,
        $until :=  if ($token) then string($token/@until) else $until_str,
        $metadataPrefix :=  if ($token) then string($token/@metadataPrefix) else $metadataPrefix_str,
        $set :=  if ($token) then string($token/@set) else $set_str,
        $page := if ($token) then number($token/@page) else 1,
        $per-page := xs:integer($profile/oais:per-page/text())
    
    return
        if ($resumptionToken and not($token))
        then
            oai:error('badResumptionToken', 'the resumptionToken is invalid')
        else if (not($metadataPrefix))
        then
            oai:error('badArgument', 'metadataPrefix must be specified (oai_dc or oai_tei or oai_mets)')
        else if (not($metadataPrefix = 'oai_tei') and not($metadataPrefix = 'oai_dc') and not($metadataPrefix = 'oai_mets'))
        then 
            oai:error('cannotDisseminateFormat', "only 'oai_dc', 'oai_tei', and 'oai_mets' are valid formats")
        else if ($from and not(oai:parse-date-time($from) instance of xs:dateTime))
        then
            oai:error('badArgument', 'from parameter is not in form YYYY-MM-DDTHH:MM:SSZ')
        else if ($until and not(oai:parse-date-time($until) instance of xs:dateTime))
        then
            oai:error('badArgument', 'from parameter is not in form YYYY-MM-DDTHH:MM:SSZ')
        else
            let $filtered := oai:filter(
                    $profile,
                    $from,
                    $until,
                    $set
                ),
                $total := count($filtered),
                $results := oai:paginate($profile, $filtered, $page),
                $new-token := if ($total > $page * $per-page)
                then
                    oai:insert-token(
                        'ListRecords',
                        $metadataPrefix,
                        $from,
                        $until,
                        $set,
                        string($page + 1)
                    )
                else
                    ''
            return (
                if ($total = 0)
                then
                    oai:error('noRecordsMatch', 'no records match your criteria')
                else
                    document {
                        $oai:xslt-pi,
                        <OAI-PMH
                            xmlns="http://www.openarchives.org/OAI/2.0/"
                            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
                        >
                            <responseDate>{oai:ts()}</responseDate>
                            {oai:request()}
                            <ListRecords>
                                {
                                    for $result in $results
                                    return
                                        <record>
                                            {oai:header-for($result)}
                                            <metadata>
                                                {oai:format($result, $metadataPrefix)}
                                            </metadata>
                                        </record>
                                }
                                {
                                    if ($new-token)
                                    then
                                        <resumptionToken completeListSize="{$total}">
                                            {string($new-token/@id)}
                                        </resumptionToken>
                                    else
                                        ''
                                }
                            </ListRecords>
                        </OAI-PMH>
                    }
            )
};

(:
($data//tei:msIdentifier[tei:repository='Herzog August Bibliothek']/tei:collection/text(), 
                   $data//tei:msIdentifier[not(tei:repository='Herzog August Bibliothek')]/tei:settlement/text(), 
                   $data//tei:name[@type='project'][not(parent::tei:name[@type='project'])])
:)
declare function oai:list-sets($resumptionToken as xs:string) as node()
{
    let $profile := oai:profile(),
        $data := collection($profile/oais:data-root/text()),
        $names := ($data//tei:msIdentifier/tei:collection/text(), $data//tei:name[@type='project']/normalize-space(text()[1]))
    return
        if ($resumptionToken)
        then
            oai:error(
                'badResumptionToken',
                'this repository will always deliver all sets in one request'
            )
        else
            document {
                $oai:xslt-pi,
                <OAI-PMH
                    xmlns="http://www.openarchives.org/OAI/2.0/"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
                >
                    <responseDate>{oai:ts()}</responseDate>
                    {oai:request()}
                    <ListSets>
                        { 
                            for $name in distinct-values($names)
                            order by $name
                            return
                                <set>
                                    <setSpec>{oai:name-to-spec($name)}</setSpec>
                                    <setName>{$name}</setName>
                                </set>
                        }
                    </ListSets>
                </OAI-PMH>
            }
};

declare function oai:error($code as xs:string, $message as xs:string)
as node()
{
    document {
        $oai:xslt-pi,
        <OAI-PMH
            xmlns="http://www.openarchives.org/OAI/2.0/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
        >
            <responseDate>{oai:ts()}</responseDate>
            {oai:request()}
            <error code="{$code}">{$message}</error>
        </OAI-PMH>
    }
};


(: resumptionToken handling :)

declare function oai:purge-tokens() as node()*
{
    let $state := doc('state.xml')/oaid:state,
        $tokens := $state/oaid:resumptionTokens,
        $ts := oai:utc(current-dateTime()),
        $threshold := $ts - 1000 * 60 * 5,
        $expired := $tokens/oaid:resumptionToken[number(@created-at) < $threshold]
        
    return (
        update delete $expired
    )
};

declare function oai:find-token(
    $verb as xs:string,
    $token as xs:string
) as node()*
{
    let $purged := oai:purge-tokens(),
        $state := doc('state.xml')/oaid:state,
        $tokens := $state/oaid:resumptionTokens,
        $token := $tokens/oaid:resumptionToken[@id=$token][@verb=$verb]
    return
        $token
};

declare function oai:insert-token(
    $verb as xs:string,
    $metadataPrefix as xs:string,
    $from as xs:string,
    $until as xs:string,
    $set as xs:string,
    $page as xs:string
) as node()
{
    let $state := doc('state.xml')/oaid:state,
        $tokens := $state/oaid:resumptionTokens,
        $uuid := util:uuid(),
        $ts := oai:utc(current-dateTime()),
        $token := <oaid:resumptionToken
          id="{$uuid}"
          verb="{$verb}"
          metadataPrefix="{$metadataPrefix}"
          from="{$from}"
          until="{$until}"
          set="{$set}"
          page="{$page}"
          created-at="{$ts}"
        />
    return (
        update insert $token into $tokens,
        $token
    )
};


(: partials :)

declare function oai:header-for($result as node()) as node()
{
    let $datestamp := oai:format-date-time(oai:last-modified($result))
    return
        <header xmlns="http://www.openarchives.org/OAI/2.0/">
            <identifier>{oai:identifier($result)}</identifier>
            <datestamp>{$datestamp}</datestamp>
            {
                for $set in oai:sets($result)
                return <setSpec>{oai:name-to-spec($set)}</setSpec>
            }
        </header>
};

declare function oai:request() as node()
{
    let $params := request:get-parameter-names()
    return
        element {fn:QName("http://www.openarchives.org/OAI/2.0/", "request")} {
            for $name in $params
            return attribute {$name} {request:get-parameter($name, ())},
            oai:base-url()
        }
        
};


(: finding/filtering/pagination :)

declare function oai:all-tei($profile as node())
{
    let $path := $profile/oais:data-root/text()
    return collection($path)//tei:TEI
};

declare function oai:filter(
    $profile as node(),
    $from as xs:string,
    $until as xs:string,
    $set as xs:string
) as node()*
{
    let $results := oai:all-tei($profile)
    for $result in $results
    (: 
    problems might result from usage of @xml:base
    check for occurences here: view-source:http://exist1.hab.local:8080/exist/rest/db/apps/hab-oai-pmh/find-xml-base.xq
    :)
    let $rlm := oai:utcs(oai:last-modified($result)),
        $fc := if ($from)
               then oai:utcs(oai:parse-date-time($from)) <= $rlm
               else 1,
        $uc := if ($until)
               then oai:utcs(oai:parse-date-time($until)) >= $rlm
               else 1,
        $sc := (not($set) or index-of(oai:setSpecs($result), $set) >= 1)
    where (
        $fc and $uc and $sc
        
    )
    return $result
};

declare function oai:paginate(
    $profile as node(),
    $results as node()*,
    $page as xs:string
) as node()*
{
    let $p := xs:integer($page),
        $per-page := xs:integer($profile/oais:per-page/text()),
        $f := xs:integer(($p - 1) * $per-page + 1),
        $t := xs:integer($p * $per-page)
    return $results[position() = ($f to $t)]
};

declare function oai:find(
    $profile as node(),
    $identifier as xs:string
) as node()*
{
    oai:all-tei($profile)[@xml:id=$identifier]
};


(: doc accessors :)

declare function oai:setSpecs($result as node()) as xs:string*
{
    if ($result)
    then
        for $r in oai:sets($result)
        return oai:name-to-spec($r)
    else
        ()
};

declare function oai:sets($result as node()) as xs:string*
{
    distinct-values($result//tei:msIdentifier/tei:collection/text()), 
    distinct-values($result//tei:name[@type='project']/normalize-space(text()[1]))
};

declare function oai:identifier($result as node()) as xs:string
{
    string($result/@xml:id)
};

(:
declare function oai:last-modified($result as node())
{
    let $uri := fn:base-uri($result),
        $c := fn:replace($uri, '/[^/]+$', ''),
        $d := fn:replace($uri, '^.*/([^/]+)$', '$1')
    return
        xmldb:last-modified($c, $d)
};
:)

declare function oai:last-modified($result as node())
{
   let $uri := fn:base-uri($result),
       $c := fn:replace($uri, '/[^/]+$', ''),
       $d := fn:replace($uri, '^.*/([^/]+)$', '$1'),
       $ts := xmldb:last-modified($c, $d),
       $debug := if (fn:count($ts) eq 0) then
           error(QName('', 'debug'), $uri)
       else
           'none'
   return $ts
}; 

(: util functions :)

declare function oai:profile()
as node()
{
    let $profiles := doc('profiles.xml')/oais:profiles,
        $profile := $profiles/oais:profile[oais:name/text() eq $oai:profile-name],
        $default := $profiles/oais:profile[oais:name/text() eq 'default']
    return
        if ($profile) then $profile else $default
};

declare function oai:format($result as node(), $metadataPrefix as xs:string)
as node()
{
         if ($metadataPrefix = 'oai_tei')  then oai:tei-to-tei($result)
    else if ($metadataPrefix = 'oai_mets') then oai:tei-to-mets($result)
    else oai:tei-to-dc($result)
};

declare function oai:tei-to-tei($result as node()) as node()
{
    let $identifier := string($result/@xml:id)
    return
        transform:transform($result, 'xmldb:exist:///db/apps/hab-oai-pmh/tei2tei.xsl', <parameters xmlns="http://www.w3.org/1999/xhtml"><param name="idno" value="{$identifier}"/></parameters>)
};

declare function oai:tei-to-mets($result as node()) as node()
{
    let $identifier := string($result/@xml:id)
    return
        transform:transform($result, 'xmldb:exist:///db/apps/hab-oai-pmh/tei2mets.xsl', <parameters xmlns="http://www.w3.org/1999/xhtml"><param name="idno" value="{$identifier}"/></parameters>)
};
(: Beispiel http://dbs.hab.de/oai/wdb?verb=GetRecord&metadataPrefix=mets&identifier=oai:diglib.hab.de:ppn_549836969 :)

declare function oai:tei-to-dc($result as node()) as node()
{
    let $identifier := string($result/@xml:id),
        $title := $result//tei:title[parent::tei:titleStmt]/text(),
        $publisher := $result//tei:publisher/tei:name/text()
    return
        <oai_dc:dc 
            xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" 
            xmlns:dc="http://purl.org/dc/elements/1.1/" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd"
        >
            <dc:identifier>{$identifier}</dc:identifier>
            <dc:type>Text</dc:type>
            {if ($title) then <dc:title>{$title}</dc:title> else ()}
            {if ($publisher) then <dc:publisher>{$publisher}</dc:publisher> else ()}
        </oai_dc:dc>
};

declare function oai:utc($datetime as xs:dateTime) as xs:integer
{
    let $result := ($datetime - xs:dateTime("1970-01-01T00:00:00-00:00")) div xs:dayTimeDuration('PT0.001S')
    return $result
};

declare function oai:utcs($datetime as xs:dateTime) as xs:integer
{
    oai:utc($datetime) idiv 1000
};

declare function oai:earliest($profile as node()+) as xs:dateTime
{
    let $result := (
        let $sigs := $profile/oais:data-root/text()
        for $sig in xmldb:get-child-collections($sigs)
        let $sig-url := concat($sigs, '/', $sig)
        for $res in xmldb:get-child-resources($sig-url)
        order by xmldb:last-modified($sig-url, $res) ascending
        return xmldb:last-modified($sig-url, $res)
    )[1]
    return $result
};

declare function oai:ts() as xs:string
{
    let $now := current-dateTime()
    return fn:format-dateTime($now, '[Y0000]-[M00]-[D00]T[H00]:[m00]:[s00]Z')
};

declare function oai:use-https() as xs:boolean
{
    oai:profile()/oais:use-https/text() = 'true'
};

declare function oai:full-url() as xs:string
{
    let $base := request:get-url(),
        $ssl := if (oai:use-https()) then replace($base, '^http:', 'https:') else $base,
        $qs := request:get-query-string()
    return
        if ($qs) then concat($ssl, '?', $qs) else $ssl
};

declare function oai:base-url() as xs:string
{
    let $base := replace(oai:full-url(), '\?.*$', '')
    return $base
};

declare function oai:name-to-spec($name as xs:string) as xs:string
{
    let $spec := replace($name, '[^a-zA-Z0-9]', '')
    return $spec
};

declare function oai:parse-date-time($string as xs:string)
{
    try {
        (:let $result := datetime:parse-dateTime($string, "y-M-d'T'H:m:s'Z'"):)
        let $result := $string
        return $result
    } catch * {
        ''
    }
};

declare function oai:format-date-time($input as xs:dateTime) as xs:string
{
    (:
    let $ts := datetime:timestamp($input),
        $utc := datetime:timestamp-to-datetime($ts)
    return datetime:format-dateTime($utc, "yyyy-MM-dd'T'HH:mm:ss'Z'")
    :)
    let $ts := $input
    return concat(substring($ts, 1, 19), 'Z')
};
