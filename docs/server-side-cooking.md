Instructions for cooking content on the server
==============================================

 - From cnx-recipes in Github, get URL to the CSS version of the recipe needed. Path: cnx-recipes/books/recipes/output/
 >https://raw.githubusercontent.com/Connexions/cnx-recipes/master/books/recipes/output/statistics.css

 - ssh into server

 - wget the recipe
 >wget https://raw.githubusercontent.com/Connexions/cnx-recipes/master/books/recipes/output/statistics.css

 - Pro Tip: Remove recipe if it already exists before running wget

 - Run this command to install the recipe into the book as an attached resource.
 >/var/cnx/venvs/archive/bin/cnx-archive-inject_resource --resource-filename "recipe.css" --media-type "text/css" /etc/cnx/archive/app.ini [book UUID with version] [recipe file]

 - Example
 >/var/cnx/venvs/archive/bin/cnx-archive-inject_resource --resource-filename "recipe.css" --media-type "text/css" /etc/cnx/archive/app.ini b4aa4ae4-f51e-47da-9938-d3973caf1964@1.1 statistics.css

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
