const main = require('./')

const platform = 'rex-web'
const introBusiness = 'intro-business'

function assertTrue(value, message) {
  if (value !== true) {
    throw new Error(message)
  }
}

const styleMap = main.getStyleFiles(platform)
assertTrue(styleMap.size > 0, `Test failed. styleMap.size is greater than zero. It is "${styleMap.size}"`)

const styleContentsMap = main.getStyleContents(platform)
assertTrue(styleMap.size === styleContentsMap.size, `FAILED: style maps do not match`)
assertTrue(styleMap.has(introBusiness), `Missing "${introBusiness}" in the style map`)
assertTrue(styleContentsMap.has(introBusiness), `Missing "${introBusiness}" in the style contents map`)
assertTrue(styleContentsMap.get(introBusiness).length > 1, `Missing "${introBusiness}" in the style contents map`)

console.log(`Success: Found ${styleMap.size} styles`)
