const path = require('path');
const sassTrue = require('sass-true')
const globImporter = require('node-sass-glob-importer');

const frameworkIncludesPath = `${__dirname}/../framework`
const sassFile = path.join(__dirname, 'test-framework.scss')

sassTrue.runSass({
  file: sassFile,
  importer: [globImporter()],
  includePaths: [frameworkIncludesPath],
}, describe, it)