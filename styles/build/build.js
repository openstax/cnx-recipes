const fs = require('fs')

const sass = require('node-sass')
const { String: SassString } = sass.types

const platform = (process.env.PLATFORM || 'NONE').toLowerCase()
const platformIncludesPath = `${__dirname}/../platforms/${platform}`
if (!fs.existsSync(platformIncludesPath)) {
  throw new Error(`Specified platform '${platform}' does not have an associated directory.`)
}

const inputFile = process.argv[2]
const outputFile = process.argv[3]
if (!inputFile) {
  throw new Error('Input argument not given.')
}

const getPlatform = () => {
  return SassString(platform)
}

let scssResult
try {
  scssResult = sass.renderSync({
    file: inputFile,
    includePaths: [platformIncludesPath],
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
