#!/bin/bash -e

FROM=app
TO=dav/apps/hab-oai-pmh

DATE=$(date +"%Y-%m-%d %H:%M:%S")
echo "$DATE: synchronizing"

rsync -a --delete $FROM/ $TO/
