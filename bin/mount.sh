#!/bin/bash -e

USER=$(whoami)

mkdir -p dav/
sudo mount -t davfs http://10.0.2.15:8080/exist/webdav/db dav/ -o uid=$USER,username=admin
