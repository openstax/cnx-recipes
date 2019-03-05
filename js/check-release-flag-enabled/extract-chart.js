const getStdin = require('get-stdin');
const sassExtract = require('sass-extract');
const order = process.argv[2];

getStdin().then(recipeFeaturesScss => {
  sassExtract.render({
    data: recipeFeaturesScss
  }).then(rendered => {
    recipeName = rendered.vars['global']['$RECIPE_NAME']['value'];
    features = rendered.vars['global']['$RELEASE_FLAGS']['value'];

    if(order == 0) {
      header_row = "| Recipe Name |";
      header_border = "| --- |";
      columns = Object.keys(features).length
      Object.keys(features).forEach(featureName => {
        header_row += ` ${featureName} |`;
        header_border += " --- |";
      });
      header = header_row + "\n" + header_border;
      console.log(header);
    }
    row = `| ${recipeName} |`;
    Object.keys(features).forEach(featureName => {
      enabled = features[featureName]['value']
      mark = (enabled ? ":heavy_check_mark:" : ":x:")
      row += ` ${mark} |`;
    });
    console.log(row);
  }).catch(err => { console.error(err) });
}).catch(err => { console.error(err) });
