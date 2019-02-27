#!/usr/bin/env node

const fs = require('fs')
const sax = require('sax')
const json2xml = require('jsontoxml')
const filePath = process.argv[2]
const outputPath = process.argv[3]

if (!filePath) {
  console.error('First argument must be the path to an (X)HTML file')
  process.exit(111)
}

const fileContents = fs.readFileSync(filePath)

const ignoreAttr = [
  'id',
  'href',
  'src',
  'cnx-archive-shortid',
  'cnx-archive-uri',
  'data-value',
  'width',
  'start',
  'colspan',
  'alt',
  'data-alt'
]

const ignoreInternal = [
  'math',
  'm:math'
]

function logging() {
  return false
}

const action = {
  none: "none",
  text: "text",
  open: "open",
  close: "close"
}

let latestAction = 'none'

let minJson = []
let parentStack = []

function addStackJson(value) {
  let target = minJson
  parentStack.forEach(({name, attributes}) => {
    const match = (
      target.filter((element) => {
        const namesMatch = element["name"] === name
        const attrsMatch = JSON.stringify(element["attrs"]) === JSON.stringify(attributes)
        return (namesMatch && attrsMatch)
      })[0]
    )
    if (match) {
      target = match["children"]
    } else {
      const element = {
        "name": name,
        "attrs": attributes,
        "children": []
      }
      target.push(element)
      target = element["children"]
    }
  })
  const dupeText = typeof target.slice(-1)[0] === "string"
  if (value && !dupeText) { target.push(value) }
}

const onError = (error) => {
  console.error(`Error: ${error}`)
}

const onText = (text) => {
  const lastOnStack = parentStack.slice(-1)[0]
  const ignoring = lastOnStack && ignoreInternal.includes(lastOnStack.name)
  if (!ignoring) {
    let value = ''
    if (text.replace(/\s/g, '').length) {
      value = 'Text'
    }
    addStackJson(value)
    latestAction = action.text
  }
}

const onOpen = (element) => {
  const lastOnStack = parentStack.slice(-1)[0]
  const ignoring = lastOnStack && ignoreInternal.includes(lastOnStack.name)
  const trackAnyways = ignoreInternal.includes(element.name)
  if (!ignoring || trackAnyways) {
    ignoreAttr.forEach((attrName) => {
      delete element.attributes[attrName]
    })
    parentStack.push(element)
    if (!ignoring) {
      latestAction = action.open
    }
  }
}

const onClose = (name) => {
  const lastOnStack = parentStack.slice(-1)[0]
  const ignoring = lastOnStack && ignoreInternal.includes(lastOnStack.name)
  const popIgnore = ignoreInternal.includes(name)
  if (!ignoring) {
    const isLeaf = latestAction != action.close && latestAction != action.text
    if (isLeaf) { addStackJson() }
    parentStack.pop()
    latestAction = action.close
  } else if (popIgnore) {
    const newLastOnStack = parentStack.slice(-2)[0]
    const stillIgnoring = newLastOnStack && ignoreInternal.includes(newLastOnStack.name)
    if (!stillIgnoring) {
      addStackJson()
      latestAction = action.close
    }
    parentStack.pop()
  }
}

const parserCallbacks = {
  onerror: onError,
  onopentag: onOpen,
  ontext: onText,
  onclosetag: onClose
}

const strict = true
const blankXmlParser = sax.parser(strict)
const xmlParser = Object.assign(blankXmlParser, parserCallbacks)
xmlParser.write(fileContents).close();

const outputXml = json2xml(minJson, {escape: true})

if (outputPath && outputPath !== '-') {
  fs.writeFileSync(outputPath, outputXml)
} else {
  process.stdout.write(outputXml)
}