// console.log('STARTED UP THE BUILDER!')
const KssBuilderBase = require('kss/builder/base')

class OpenstaxBuilder extends KssBuilderBase {
  constructor() {
    super()
    this.API = "3.0" // This is the kss version, not this builder's version
  }
  build(styleGuide) {
    debugger
    console.log('CUSTOM: calling build!', ...arguments)
    return super.build(...arguments)
  }
  // buildGuide(styleGuide, options) {
  //   console.log('CUSTOM: calling buildGuide!', ...arguments)
  //   return super.buildGuide(...arguments)
  // }
  // buildPage(templateName, options, pageReference, sections, contextopt) {
  //   console.log('CUSTOM: calling buildPage!', ...arguments)
  //   return super.buildPage(...arguments)
  // }
  // clone(builderPath, destinationPath) {
  //   console.log('CUSTOM: calling clone!', ...arguments)
  //   return super.clone(...arguments)
  // }
}
module.exports = OpenstaxBuilder