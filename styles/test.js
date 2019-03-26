const main = require('./')

const platform = 'rex-web'
const introBusiness = 'intro-business'

function assertTrue(value, message) {
  if (value !== true) {
    throw new Error(message)
  }
}

main.getStyleFiles(platform).then(styleMap => {
  assertTrue(styleMap.size > 0, `Test failed. styleMap.size is greater than zero. It is "${styleMap.size}"`)
  
  return main.getStyleContents(platform).then(styleContentsMap => {
    assertTrue(styleMap.size === styleContentsMap.size, `FAILED: style maps do not match`)
    assertTrue(styleMap.has(introBusiness), `Missing "${introBusiness}" in the style map`)
    assertTrue(styleContentsMap.has(introBusiness), `Missing "${introBusiness}" in the style contents map`)
    assertTrue(styleContentsMap.get(introBusiness).length > 1, `Missing "${introBusiness}" in the style contents map`)

    console.log(`Succes: Found ${styleMap.size} styles`)
  })
}, err => {
  console.error('FAILED')
  console.error(err)
  process.exit(1)
})

