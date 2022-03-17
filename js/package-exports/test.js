// DELETE_ME

const main = require('.')

const introBusiness = 'intro-business'

function assertTrue (value, message) {
  if (value !== true) {
    throw new Error(message)
  }
}

const bookStyles = main.getBookStyles()
assertTrue(bookStyles.has(introBusiness), `Missing "${introBusiness}" in the style map`)
assertTrue(bookStyles.get(introBusiness).length > 100, `Missing "${introBusiness}" in the style contents map`)

console.log(`Success: Found ${bookStyles.size} styles`)
