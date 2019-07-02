xquery version "3.0";

declare variable $state-file := concat(repo:get-root(), '/hab-oai-pmh/state.xml');

sm:chgrp(xs:anyURI($state-file), 'guest'),
sm:chmod(xs:anyURI($state-file), 'rw-rw-r--')
