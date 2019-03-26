// const fs = require('fs') not allowed because this package is used in webpack
const webStyles = require('./output/_web-styles.json')

const suffix = '-rex-web.css'

const books = new Map()

for (const {fileName, content} of webStyles) {
  if (!fileName.endsWith(suffix) || fileName.indexOf('/') >= 0) {
    throw new Error(`BUG: the _web-styles.json file is malformed`)
  }
  const bookName = fileName.replace(suffix, '')
  books.set(bookName, content)
}


function getBookStyles() {
  return books
}

module.exports = { getBookStyles }