const fs = require('fs')

const sass = require('node-sass')

const input = process.argv[2]
const output = process.argv[3]

if (!input || !output) {
  throw new Error('Input/Output arguments not given.')
}

const scssResult = sass.renderSync({
  file: input,
  sourceMap: true,
  outputStyle: 'nested',
  outFile: output
})

fs.writeFileSync(output, scssResult.css)
fs.writeFileSync(`${output}.map`, scssResult.map)
