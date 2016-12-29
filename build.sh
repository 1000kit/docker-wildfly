#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
pwd

echo "build wildfly standalone image"
docker build --rm --force-rm -t 1000kit/wildfly .


#end
