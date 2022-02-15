const path = require('path')

module.exports = function () {
  const alreadyImported = []
  return function (url, prev) {
    const asAbsolute = path.isAbsolute(url) ? url : path.join(path.dirname(prev), url)
    const asAbsoluteDirname = path.dirname(asAbsolute)
    const asAbsoluteBaseStrip = path.basename(asAbsolute).replace(/^_/, '').replace(/.s[ca]ss$/, '')
    const isSameFile = (otherPath) => {
      const isSameDir = path.dirname(otherPath) === asAbsoluteDirname
      const otherPathBaseStrip = path.basename(otherPath).replace(/^_/, '').replace(/.s[ca]ss$/, '')
      const isCompatibleBase = otherPathBaseStrip === asAbsoluteBaseStrip
      return (isSameDir && isCompatibleBase)
    }
    if (alreadyImported.some(isSameFile)) {
      console.log(`Not imported: ${asAbsolute}`)
      return {}
    } else {
      alreadyImported.push(asAbsolute)
      console.log(`Imported: ${asAbsolute}`)
      return null
    }
  }
}
