#!/bin/bash

# This contains repo-specific setup. It is called by `./script/setup`

# Clone the rhaptos.cnxmlutils repo in here
if [[ ! -d ./vendor/rhaptos.cnxmlutils/.git/ ]]; then
  do_progress_quiet "Installing ./vendor/rhaptos.cnxmlutils/" \
    git clone https://github.com/Connexions/rhaptos.cnxmlutils.git ./vendor/rhaptos.cnxmlutils/
fi

do_progress_quiet "Checking out branch in ./vendor/rhaptos.cnxmlutils/ (see https://github.com/Connexions/rhaptos.cnxmlutils/pull/157)" \
  cd "./vendor/rhaptos.cnxmlutils/" && git checkout rng-fixes && git pull
