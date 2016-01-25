Testing proof-of-concept for using CSS (and perhaps less?) to define
the rules necessary to do collation (and numbering) of "raw" html
to a "cooked" html form.

Test code is contained in the command-line utility 'poc.py'
This takes 1-3 arguments:

a required css file, then optional html input, and html output

example rule set is in poc.less.

convert to css via 'lessc poc.less > poc.css'
requires lessc >= 1.7

run test as:

./poc.py poc.css poc-raw.html poc-cooked.html

