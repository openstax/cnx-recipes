const path = require('path');
const sassTrue = require('sass-true')

const frameworkIncludesPath = `${__dirname}/../framework`
const sassFile = path.join(__dirname, 'test-framework.scss')

sassTrue.runSass({
  file: sassFile,
  includePaths: [frameworkIncludesPath]
}, describe, it)