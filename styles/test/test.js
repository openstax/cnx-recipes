const path = require('path');
const sassTrue = require('sass-true')
const globImporter = require('node-sass-glob-importer')

const alreadyImported = []
const importOnce = (url, prev, done) => {
  const asAbsolute = path.isAbsolute(url) ? url : path.join(path.dirname(prev), url)
  const asAbsoluteDirname = path.dirname(asAbsolute)
  const asAbsoluteBaseStrip = path.basename(asAbsolute).replace(/^_/, '').replace(/.s[ca]ss$/, '')
  const isSameFile = (otherPath) => {
    const isSameDir = path.dirname(otherPath) === asAbsoluteDirname
    const otherPathBaseStrip = path.basename(otherPath).replace(/^_/, '').replace(/.s[ca]ss$/, '')
    const isCompatibleBase = otherPathBaseStrip === asAbsoluteBaseStrip
    return (isSameDir && isCompatibleBase)
  }
  if (alreadyImported.some(isSameFile)) {
    return {};
  } else {
    alreadyImported.push(asAbsolute)
    return null;
  }
}


const frameworkIncludesPath = path.join(__dirname, '../framework')
const sassFile = path.join(__dirname, 'test-framework.scss')

sassTrue.runSass({
  file: sassFile,
  importer: [globImporter(), importOnce],
  includePaths: [frameworkIncludesPath],
}, describe, it)
