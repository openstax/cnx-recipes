#!/bin/bash
ssh -L 65432:localhost:5432 -qNTf -o ControlMaster=auto -o ControlPath=/tmp/tea.tunnel tea.cnx.org

echo "Will bake: "
psql -h localhost -p 65432 repository rhaptos -c "select ms.statename, m.name, m.revised, f.sha1 from files f join module_files mf on f.fileid=mf.fileid join modules m on mf.module_ident=m.module_ident join modulestates ms on m.stateid = ms.stateid where filename = 'ruleset.css' and ident_hash(uuid,major_version,minor_version)='$1'" | cat

# shellcheck disable=SC2029
ssh tea.cnx.org  "grep -h  \"$1\" /var/log/supervisor/{channel_processing-stdout,publishing_celery_worker0-stdout}* |sort"

read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    psql -h localhost -p 65432 repository rhaptos -c "update modules set stateid=5 where ident_hash(uuid,major_version,minor_version)='$1'" | cat
    psql -h localhost -p 65432 repository rhaptos -c "select ms.statename from  modules m join modulestates ms on m.stateid = ms.stateid where ident_hash(uuid,major_version,minor_version)='$1'" | cat

else
    echo "Skipped"
fi

ssh -q -o ControlPath=/tmp/tea.tunnel -O exit tea.cnx.org
