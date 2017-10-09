#!/bin/bash
ssh qa.cnx.org  "grep -h  \"$1\" /var/log/supervisor/{channel_processing-stdout,publishing_celery_worker0-stdout}* |sort"

