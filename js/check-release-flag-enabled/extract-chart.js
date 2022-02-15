// DELETE_ME

const getStdin = require('get-stdin')
const sassExtract = require('sass-extract')
const order = Number.parseInt(process.argv[2])

getStdin().then(recipeFeaturesScss => {
  sassExtract.render({
    data: recipeFeaturesScss
  }).then(rendered => {
    const recipeName = rendered.vars['global']['$RECIPE_NAME']['value']
    const features = rendered.vars['global']['$RELEASE_FLAGS']['value']

    if (order === 0) {
      let headerRow = '| Recipe Name |'
      let headerBorder = '| --- |'
      Object.keys(features).forEach(featureName => {
        headerRow += ` ${featureName} |`
        headerBorder += ' --- |'
      })
      const header = headerRow + '\n' + headerBorder
      console.log(header)
    }
    let row = `| ${recipeName} |`
    Object.keys(features).forEach(featureName => {
      const enabled = features[featureName]['value']
      const mark = (enabled ? ':heavy_check_mark:' : ':x:')
      row += ` ${mark} |`
    })
    console.log(row)
  }).catch(err => { console.error(err) })
}).catch(err => { console.error(err) })
