#!/bin/bash

apt-get update
apt-get install libxml2-utils xsltproc

npm install --global yarn

$(pwd)/resource-repo/script/setup
$(pwd)/resource-repo/script/test