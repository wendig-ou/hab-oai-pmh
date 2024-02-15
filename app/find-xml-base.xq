xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $doc := doc('/db/data/mss/10-11-aug-4f/tei-msDesc_Westphal.xml'),
    $xb := collection('/db/data/mss')//tei:TEI[@xml:base]
return (
    for $x in $xb
    (:return update delete $x/@xml:base:)
    return $x
)
