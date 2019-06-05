const fs = require('fs')

const sass = require('node-sass')

const input = process.argv[2]

const inputFile = `./recipes/books/${input}/book.scss`
const outputFile = `./recipes/output/${input}`
if (!inputFile) {
    throw new Error('Input/Output arguments not given.')
  }

const scssResult = sass.renderSync({
  file: inputFile,
  sourceMap: true,
  outputStyle: 'nested',
  outFile: outputFile
})

fs.writeFileSync(`${outputFile}.css`, scssResult.css)
fs.writeFileSync(`${outputFile}.css.map`, scssResult.map)