const fs = require('fs')

const sass = require('node-sass')

const input = process.argv[2]
const output = process.argv[3]

if (!input || !output) {
  throw new Error('Input/Output arguments not given.')
}

let scssResult
try {
  scssResult = sass.renderSync({
    file: input,
    sourceMap: true,
    outputStyle: 'nested',
    outFile: output
  })
} catch(error) {
  console.log(error.formatted) 
  process.exit()
}

fs.writeFileSync(`${output}`, scssResult.css)
fs.writeFileSync(`${output}.map`, scssResult.map)