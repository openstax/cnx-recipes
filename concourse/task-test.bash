#!/bin/bash

apt-get update
apt-get install libxml2-utils xsltproc rsync

root_dir=$(pwd)

# so pyenv uses .python-version (& nodenv)
cd "${root_dir}"/resource-repo/ || exit 111

# Temp: ensure pyenv is initialized
eval "$(pyenv init -)"

npm install --global yarn

./script/setup
./script/test

# Host the built styleguide
key_path=$(mktemp)
echo "${SCP_PACKAGE_SECRET_KEY}" > "${key_path}"

remote_user="rundeck"
remote_host="packages.cnx.org"
remote_dir="/var/www/repo/cnx-rulesets/$(cat .git/ref)/"

local_styleguide_dir="./styleguide/"

# shellcheck disable=SC2029
ssh -o "StrictHostKeyChecking no" -o UserKnownHostsFile=/dev/null -i "${key_path}" ${remote_user}@${remote_host} "mkdir -p '${remote_dir}'" || exit 5

# shellcheck disable=SC2029
rsync -avp -e "ssh -o 'StrictHostKeyChecking no' -o UserKnownHostsFile=/dev/null -i '${key_path} '-l${remote_user}" "${local_styleguide_dir}" "${remote_host}:${remote_dir}" || exit 6
