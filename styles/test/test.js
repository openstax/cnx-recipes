const fs = require('fs')
const path = require('path');
const sassTrue = require('sass-true')

const alreadyImported = []
const importOnce = (url, prev) => {
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
    // console.log(`Not imported: ${asAbsolute}`)
    return {};
  } else {
    alreadyImported.push(asAbsolute)
    return null;
  }
}

const coverageReporter = (url, prev) => {
  const asAbsolute = path.isAbsolute(url) ? url : path.join(path.dirname(prev), url)
  const filenameSlug = path.basename(asAbsolute)
  const dirname = path.dirname(asAbsolute)
  let realPath = null
  if (fs.existsSync(path.join(dirname, `${filenameSlug}.scss`))) {
    realPath = path.join(dirname, `${filenameSlug}.scss`)
  } else if (fs.existsSync(path.join(dirname, `_${filenameSlug}.scss`))) {
    realPath = path.join(dirname, `_${filenameSlug}.scss`)
  } else if (fs.existsSync(path.join(dirname, filenameSlug, 'index.scss'))) {
    realPath = path.join(dirname, filenameSlug, 'index.scss')
  } else {
    return null
  }

  // Don't cover packages in node_modules
  if (/node_modules/.test(realPath)) {
    return null
  }
  try {
    const contents = fs.readFileSync(realPath, 'utf-8')
    const allPossibleLines = []
    const originalLines = contents.split('\n')
    let isMultiLineReturn = false // returns can span multiple lines so count the return but don't add a @debug after the return
    const lines = originalLines.map((line, index) => {
      const trimmed = line.trim()
      const firstWord = trimmed.split(' ')[0]
      const lastChar = trimmed[trimmed.length - 1]
      const debugMsg = `@debug '__CODECOVERAGE_COVERED: ${JSON.stringify([realPath, index+1])}';`
      if (firstWord === '@return'
        || firstWord === '@include'
        || firstWord === '@if'
        || firstWord === '@error') {

        isMultiLineReturn = firstWord === '@return' && trimmed.indexOf(';') < 0
        allPossibleLines.push(index+1)
        return `${debugMsg}; ${line}`
      }
      switch (lastChar) {
        case '{':
        case ';': 
          if (isMultiLineReturn && lastChar === ';') {
            isMultiLineReturn = false
            return line
          } 
          allPossibleLines.push(index+1)
          return `${line} ${debugMsg}`
        default: return line
      }
    })
    // Inject all the possible lines at the top
    lines[0] = `@debug '__CODECOVERAGE_ALL_POSSIBLE: ${JSON.stringify([realPath, allPossibleLines])}';${lines[0]}`
    return {contents: lines.join('\n')}
  } catch (err) {
    console.log(err)
    return {file: realPath}
  }
}


const frameworkIncludesPath = path.join(__dirname, '../framework')
const sassFile = path.join(__dirname, 'test-framework.scss')

try {
sassTrue.runSass({
  // sourceMap: true,
  // sourceMapEmbed: true,
  file: sassFile,
  importer: [importOnce, coverageReporter],
  includePaths: [frameworkIncludesPath],
}, describe, it)
} catch (error) {
  console.log(error.formatted)
}
