const getStdin = require('get-stdin');
const sassExtract = require('sass-extract');
const order = process.argv[2];

getStdin().then(recipeFeaturesScss => {
  sassExtract.render({
    data: recipeFeaturesScss
  }).then(rendered => {
    recipeName = rendered.vars['global']['$RECIPE_NAME']['value'];
    features = rendered.vars['global']['$FEATURES']['value'];
    
    if(order == 0) {
      header = "| Recipe Name |";
      columns = Object.keys(features).length
      Object.keys(features).forEach(featureName => {
        header += ` ${featureName} |`;
      });
      header += "\n";
      header += "| --- |"
      for(i = 0; i < columns;  i++) {
        header += " --- |"
      }
      console.log(header);
    }
    row = `| ${recipeName} |`;
    Object.keys(features).forEach(featureName => {
      enabled = features[featureName]['value']
      mark = 
      row += ` ${(enabled ? ":heavy_check_mark:" : ":x:")} |`;
    });
    console.log(row);
  }).catch(err => { console.log(err) });
}).catch(err => { console.log(err) });
