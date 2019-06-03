const fs = require('fs')

const sass = require('node-sass')
const { String: SassString } = sass.types

const inputFile = process.argv[2]
const outputFile = process.argv[2]
if (!inputFile) {
    throw new Error('Input/Output arguments not given.')
  }

const scssResult = sass.renderSync({
    file: `./recipes/books/${inputFile}/book.scss`,
    sourceMap: true,
    outputStyle: 'nested',
    outFile: `./recipes/output/${inputFile}.css`
})

fs.writeFileSync(outputFile, scssResult.css)
fs.writeFileSync(`${outputFile}.map`, scssResult.map)