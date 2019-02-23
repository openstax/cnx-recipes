#!/bin/bash

apt-get update
apt-get install libxml2-utils xsltproc

$(pwd)/resource-repo/script/setup
$(pwd)/resource-repo/script/test