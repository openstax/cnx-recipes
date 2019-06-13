const fs = require('fs')

const sass = require('node-sass')

const input = process.argv[2]
const output = process.argv[3]

const inputFile = `./recipes/books/${input}/book.scss`
const outputFile = `./recipes/output/${output}.css`
if (!inputFile || !output) {
  throw new Error('Input/Output arguments not given.')
}

const scssResult = sass.renderSync({
  file: inputFile,
  sourceMap: true,
  outputStyle: 'nested',
  outFile: outputFile
})

fs.writeFileSync(`${outputFile}`, scssResult.css)
fs.writeFileSync(`${outputFile}.map`, scssResult.map)