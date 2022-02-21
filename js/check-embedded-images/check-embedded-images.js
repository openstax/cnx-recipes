//DELETE_ME

const fs = require('fs')
const path = require('path')
const glob = require('glob')
const csstree = require('css-tree')

const parentDir = path.join(__dirname, '../..', `styles/output`)

glob(`${parentDir}/*.css`, null, function (err, files) {
  if (err) { throw err }

  if (files.length <= 1) {
    throw new Error(`BUG: it seems the styles/output/ directory is no longer used. Please update this test`)
  }

  files.forEach((filePath) => {
    const content = fs.readFileSync(filePath, 'utf-8')
    const ast = csstree.parse(content, { positions: true, filename: path.basename(filePath) })

    csstree.walk(ast, function (node) {
      if (node.type === 'Url') {
        console.log(`Checking ${node.loc.source} #${node.loc.start.line}:${node.loc.start.column}`)

        let url
        if (node.value.type === 'String') {
          // unwrap the quotes around the string
          url = node.value.value.slice(1, -1)
        } else if (node.value.type === 'Raw') {
          url = node.value.value
        } else {
          console.log('ooh, this value for url(...) is interesting... it is ', node.value)
          throw new Error('BUG: Unsupported value for url(...). Please add it to the test')
        }

        if (/^https?:\/\//.test(url)) {
          // absolute, OK for fonts
        } else if (/^data:/.test(url)) {
          // data-uri encoded, OK
        } else {
          console.error(`Error: ${node.loc.source} #${node.loc.start.line}:${node.loc.start.column} contains a url(...) that points to a relative file. In order to be able to reuse the CSS file all images need to be encoded into the CSS file`)
          process.exit(110)
        }
      }
    })
  })
})
