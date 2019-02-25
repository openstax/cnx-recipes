#!/bin/bash

apt-get update
apt-get install libxml2-utils xsltproc

root_dir=$(pwd)
cd "${root_dir}"/resource-repo/ && npm install --global yarn

"${root_dir}"/resource-repo/script/setup
"${root_dir}"/resource-repo/script/test