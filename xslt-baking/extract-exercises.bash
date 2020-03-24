#!/bin/bash

xsltproc ./extract-exercises.xsl ../data/apbiology/collection.baked.xhtml | ./xsltproc3.bash ./to-json.xsl -