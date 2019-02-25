#!/bin/bash

echo "TODO: Sending styleguides for commit '$(cat .git/ref)'"

# Host the built styleguide
key_path="${root_dir}"/scp-package-secret-key
echo "${SCP_PACKAGE_SECRET_KEY}" > "${key_path}"


# apt-get update
# apt-get install libxml2-utils xsltproc

# root_dir=$(pwd)

# # so pyenv uses .python-version (& nodenv)
# cd "${root_dir}"/resource-repo/ || exit 111

# # Temp: ensure pyenv is initialized
# eval "$(pyenv init -)"

# npm install --global yarn

# ./script/setup
# ./script/test

# # Host the built styleguide
# key_path="${root_dir}"/scp-package-secret-key
# echo "${SCP_PACKAGE_SECRET_KEY}" > "${key_path}"

# remote_user="rundeck"
# remote_host="packages.cnx.org"
# remote_dir="/var/www/repo/cnx-rulesets/$(cat .git/ref)/"
# remote_master_dir="/var/www/repo/cnx-rulesets/master/"

# local_styleguide_dir="./styleguide/"

# ssh -i "${key_path}" ${remote_user}@${remote_host} "mkdir -p '${remote_dir}'" || exit 5
# rsync -avp -e "ssh -i '${key_path} '-l${remote_user}" "${local_styleguide_dir}" "${remote_host}:${remote_dir}" || exit 6

# rsync -avp -e "ssh -i ${key_path} -l${remote_user}" ${local_styleguide_dir} ${remote_host}:${remote_master_dir} || exit 6
