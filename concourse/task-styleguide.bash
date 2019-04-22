#!/bin/bash
set -e

apt-get update && \
    apt-get install -y libxml2-utils xsltproc rsync && \

root_dir=$(pwd)

# so pyenv uses .python-version (& nodenv)
cd "${root_dir}"/resource-repo/ || exit 111

# .git/resource/version.json format: {pr: "123", commit: "c1a2f3e", committed: "2000-01-01T00:00:00Z"}
# .git/resource/metadata.json format: array of "name" and "value" pairs where "name" is
# one of https://github.com/telia-oss/github-pr-resource/blob/72bb329c7996232ddc72bf70d1fd6ef257f6116c/in.go#L51-L60
commit_sha=$(python3 -c "import sys, json; print(json.load(sys.stdin)['commit'])" < .git/resource/version.json)
if [[ ${commit_sha} == '' ]]; then
    echo "Could not determine commit sha"
    exit 111
fi

# ensure pyenv is initialized
eval "$(pyenv init -)"

# Set the npm user to root so we do not get permission errors for postinstall
npm config set user 0
npm config set unsafe-perm true

# Install yarn for the specific version of node we are using
nodenv local "$(< .node-version)"
nodenv exec npm install --global yarn


./script/setup
./script/test

# Host the built styleguide
key_path=$(mktemp)
echo "${SCP_PACKAGE_SECRET_KEY}" > "${key_path}"

remote_user="rundeck"
remote_host="packages.cnx.org"
remote_dir="/var/www/repo/cnx-rulesets/${commit_sha}/"

local_styleguide_dir="./styleguide/"

# shellcheck disable=SC2029
ssh -o "StrictHostKeyChecking no" -o UserKnownHostsFile=/dev/null -i "${key_path}" ${remote_user}@${remote_host} "mkdir -p '${remote_dir}'" || exit 5

# shellcheck disable=SC2029
rsync -avp -e "ssh -o 'StrictHostKeyChecking no' -o UserKnownHostsFile=/dev/null -i '${key_path}' -l${remote_user}" "${local_styleguide_dir}" "${remote_host}:${remote_dir}" || exit 6

echo "Done. See https://${remote_host}/cnx-rulesets/${commit_sha}/"