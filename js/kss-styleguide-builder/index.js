// DELETE_ME (and the whole folder I'm in)

const path = require('path')
const KssBuilderBaseHandlebars = require('kss/builder/base/handlebars')

const Promise = require('bluebird')
const fs = Promise.promisifyAll(require('fs-extra'))

const markupFileSuffix = '.xhtml-baked.html'
const snippetFileSuffix = '.snippet.xml'

class OpenstaxBuilder extends KssBuilderBaseHandlebars {
  build (styleGuide) {
    // *********************************************
    //   Copy/pasta from KssBuilderBaseHandlebars
    //   because the plugins are not well designed
    // *********************************************
    let options = {}
    // Returns a promise to read/load a template provided by the builder.
    options.readBuilderTemplate = (name) => {
      return fs.readFileAsync(path.resolve(this.options.builder, name + '.hbs'), 'utf8').then(content => {
        // ****************************************
        //   This is the start of the custom code
        // ****************************************
        const handlebar = this.Handlebars.compile(content)
        const wrapper = (context) => {
          context.sections.forEach(section => {
            if (section.markupFile) {
              // Try to find the source snippet
              if (section.markupFile.indexOf(markupFileSuffix) < 0) {
                throw new Error(`KSS Custom builder: markup file format does not end in "${markupFileSuffix}". It is "${section.markupFile}"`)
              }
              const markupSnippetFile = section.markupFile.replace(markupFileSuffix, snippetFileSuffix)
              const root = section.source.path.replace(section.source.filename, '')
              const snippetPath = path.join(root, markupSnippetFile)
              const markupSnippet = fs.readFileSync(snippetPath, 'utf-8')
              section.markupFile = markupSnippetFile
              section.markupSource = markupSnippet
            }
          })
          return handlebar(context)
        }
        return wrapper
        // ****************************************
        //   This is the end of the custom code
        // ****************************************
      })
    }
    // Returns a promise to read/load a template specified by a section.
    options.readSectionTemplate = (name, filepath) => {
      return fs.readFileAsync(filepath, 'utf8').then(contents => {
        this.Handlebars.registerPartial(name, contents)
        return contents
      })
    }
    // Returns a promise to load an inline template from markup.
    options.loadInlineTemplate = (name, markup) => {
      this.Handlebars.registerPartial(name, markup)
      return Promise.resolve()
    }
    // Returns a promise to load the data context given a template file path.
    options.loadContext = filepath => {
      let context
      // Load sample context for the template from the sample .json file.
      try {
        context = require(path.join(path.dirname(filepath), path.basename(filepath, path.extname(filepath)) + '.json'))
        // require() returns a cached object. We want an independent clone of
        // the object so we can make changes without affecting the original.
        context = JSON.parse(JSON.stringify(context))
      } catch (error) {
        context = {}
      }
      return Promise.resolve(context)
    }
    // Returns a promise to get a template by name.
    options.getTemplate = name => {
      // We don't wrap the rendered template in "new handlebars.SafeString()"
      // since we want the ability to display it as a code sample with {{ }} and
      // as rendered HTML with {{{ }}}.
      return Promise.resolve(this.Handlebars.compile('{{> "' + name + '"}}'))
    }
    // Returns a promise to get a template's markup by name.
    options.getTemplateMarkup = name => {
      // We don't wrap the rendered template in "new handlebars.SafeString()"
      // since we want the ability to display it as a code sample with {{ }} and
      // as rendered HTML with {{{ }}}.
      return Promise.resolve(this.Handlebars.partials[name])
    }
    // Renders a template and returns the markup.
    options.templateRender = (template, context) => {
      return template(context)
    }
    // Converts a filename into a Handlebars partial name.
    options.filenameToTemplateRef = filename => {
      // Return the filename without the full path or the file extension.
      return path.basename(filename, path.extname(filename))
    }
    options.templateExtension = 'hbs'
    options.emptyTemplate = '{{! Cannot be an empty string. }}'

    return this.buildGuide(styleGuide, options)
  }

  // buildGuide(styleGuide, options) {
  // }
  // buildPage(templateName, options, pageReference, sections, contextopt) {
  // }
  // clone(builderPath, destinationPath) {
  // }
}
module.exports = OpenstaxBuilder
