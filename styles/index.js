const fs = require('fs')
const path = require('path')

const root = path.join(__dirname, 'output')

function getSuffix(platform) {
  return `-${platform}.css`
}

function getStyleFilenames(platform) {
  const files = fs.readdirSync(root)
  const styleFiles = files.filter(filename => filename.endsWith(getSuffix(platform)))
  if (styleFiles.length === 0) {
    throw new Error(`BUG: Could not find files for the "${platform}" platform`)
  }
  return styleFiles.map(filename => path.join(root, filename))
}

function getStyleFiles(platform) {
  const styleFiles = getStyleFilenames(platform)
  const styleMap = new Map()
  styleFiles.forEach(styleFile => {
    const styleName = path.basename(styleFile.replace(getSuffix(platform), ''))
    styleMap.set(styleName, styleFile)
  })

  return styleMap
}

function getStyleContents(platform) {
  const styleFiles = getStyleFilenames(platform)
  const styleMap = new Map()
  styleFiles.forEach(styleFile => {
    const styleName = path.basename(styleFile.replace(getSuffix(platform), ''))
    styleMap.set(styleName, fs.readFileSync(styleFile, 'utf-8'))
  })

  return styleMap
}

module.exports = { getStyleFiles, getStyleContents }