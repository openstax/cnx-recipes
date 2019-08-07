const fs = require('fs')
const sass = require('node-sass')
const toConstantCase = require('to-constant-case')

const { String: SassString } = sass.types

const input = process.argv[2]
const output = process.argv[3]

if (!input || !output) {
  throw new Error('Input/Output arguments not given.')
}

const template = (process.env.TEMPLATE || 'none')

const getTemplate = () => {
  return SassString(toConstantCase(template))
}

let scssResult
try {
  scssResult = sass.renderSync({
    file: input,
    functions: {
      'TEMPLATE()': getTemplate
    },
    sourceMap: true,
    outputStyle: 'nested',
    outFile: output
  })
} catch (error) {
  console.log(error.formatted)
  process.exit()
}

fs.writeFileSync(`${output}`, scssResult.css)
fs.writeFileSync(`${output}.map`, scssResult.map)
