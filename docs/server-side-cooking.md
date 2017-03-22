Instructions for cooking content on the server
==============================================

 - From cnx-rulesets in Github, get URL to the CSS version of the ruleset needed. Path: cnx-rulesets/books/rulesets/output/
 >https://raw.githubusercontent.com/Connexions/cnx-rulesets/master/books/rulesets/output/statistics.css

 - ssh into server

 - wget the ruleset
 >wget https://raw.githubusercontent.com/Connexions/cnx-rulesets/master/books/rulesets/output/statistics.css

 - Pro Tip: Remove ruleset if it already exists before running wget

 - Run this command to install the ruleset into the book as an attached resource.
 >/var/cnx/venvs/archive/bin/cnx-archive-inject_resource --resource-filename "ruleset.css" --media-type "text/css" /etc/cnx/archive/app.ini [book UUID with version] [ruleset file]

 - Example
 >/var/cnx/venvs/archive/bin/cnx-archive-inject_resource --resource-filename "ruleset.css" --media-type "text/css" /etc/cnx/archive/app.ini b4aa4ae4-f51e-47da-9938-d3973caf1964@1.1 statistics.css

 - Open Python prompt
  > type python and hit Enter

 - run
 >import requests; resp = requests.post('http://cte-cnx-dev.cnx.org:6543/contents/[Book UUID with Version]/collate-content', headers={'x-api-key': 'cte-dev--sprint-6.7'}); print(resp)

 - Example
 >import requests; resp = requests.post('http://cte-cnx-dev.cnx.org:6543/contents/b4aa4ae4-f51e-47da-9938-d3973caf1964@1.1/collate-content', headers={'x-api-key': 'cte-dev--sprint-6.7'}); print(resp)

 - Should get
  >Response [200]

 - Clear cache
 >varnishadm 'ban req.url ~ .'
