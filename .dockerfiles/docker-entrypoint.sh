#!/usr/bin/env bash

# This is run every time the docker container starts up.

set -e

if [ ! -d /src/node_modules ]
then
    . $HOME/.nvm/nvm.sh
    cd /src/
    # We need to do this when the container starts up instead of at build time
    # because ./script/setup adds files to /src/ which are wiped
    # when we start the container because we mount cnx-recipes
    ./script/setup
    cd -
fi

exec "$@"
