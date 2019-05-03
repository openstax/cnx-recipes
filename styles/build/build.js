const fs = require('fs')
const sass = require('node-sass')
const toConstantCase = require('to-constant-case')

const { String: SassString } = sass.types

const inputFile = process.argv[2]
const outputFile = process.argv[3]
if (!inputFile) {
  throw new Error('Input argument not given.')
}

const stylesRoot = `${__dirname}/../`
if (!fs.existsSync(stylesRoot)) {
  throw new Error('Cannot find styles root directory.')
}

const platform = (process.env.PLATFORM || 'none')
const platformIncludesPath = `${stylesRoot}/framework/platform/${platform}`
if (!fs.existsSync(platformIncludesPath)) {
  throw new Error(`Specified platform '${platform}' does not have an associated directory.`)
}

const getPlatform = () => {
  return SassString(toConstantCase(platform))
}

let scssResult
try {
  scssResult = sass.renderSync({
    file: inputFile,
    includePaths: [stylesRoot, platformIncludesPath],
    functions: {
      'PLATFORM()': getPlatform
    },
    sourceMap: true,
    outputStyle: 'nested',
    outFile: outputFile
  })
} catch (error) {
  console.log(error.formatted)
  process.exit()
}

if (outputFile) {
  fs.writeFileSync(outputFile, scssResult.css)
  fs.writeFileSync(`${outputFile}.map`, scssResult.map)
} else {
  console.log(scssResult.css.toString())
}
