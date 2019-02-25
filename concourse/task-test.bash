#!/bin/bash

apt-get update
apt-get install libxml2-utils xsltproc

# so pyenv uses .python-version (& nodenv)
cd "$(pwd)"/resource-repo/ || exit 111

npm install --global yarn

./script/setup
./script/test