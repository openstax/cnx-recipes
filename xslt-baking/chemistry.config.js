const {writeFileSync} = require('fs')
// chemistry recipe

function counter(name) { return `counter(${name})` }
const CLUSTER_NONE = 'CLUSTER_NONE'
const CLUSTER_SECTION = 'CLUSTER_SECTION'
const CLUSTER_CHAPTER = 'CLUSTER_CHAPTER'
const PAGE_GLOSSARY = 'PAGE_GLOSSARY'
const PAGE_INDEX = 'PAGE_INDEX'
const AREA_EOC = 'AREA_EOC'
const AREA_EOB = 'AREA_EOB'
const AREA_NONE = 'AREA_NONE'
const RESET_CHAPTER = 'RESET_CHAPTER'
const NUMBER_BEFORE_MOVE = 'NUMBER_BEFORE_MOVE'
const CAPTION_TABLE = 'CAPTION_TABLE'



const _exampleTitleContent = [{'os-title-label': "Example "}, {'os-number': [counter('chapter'), ".", counter('example'), {'os-divider': " "}]}]
const _exampleTitleContentAP = [{'os-title-label': "Example "}, {'os-number': [counter('appendix', 'upper-alpha'), counter('example'), {'os-divider': " "}]}]
const _exampleSolutionTitleContent = [{'os-title-label': "Solution "}, {'os-number': [counter('chapter'), ".", counter('example'), {'os-divider': ' '}]}]

const Config_exerciseTitleContent = [{'os-divider': ". "}, {'os-number': counter('exercise')}]
const config = {
  Config_exerciseTitleContent,

  Config_ChapterCompositePages: [
    {className: "glossary", clusterBy: CLUSTER_NONE, specialPageType: PAGE_GLOSSARY, sortBy: "xhtml|dl > xhtml|dt", name: "Key Terms"},
    {className: "key-equations", clusterBy: CLUSTER_NONE, name: "Key Equations"},
    {className: "summary", clusterBy: CLUSTER_SECTION, name: "Summary"},
    {className: "exercises", clusterBy: CLUSTER_SECTION, hasSolutions: true, name: "Exercises"},
  ],
  Config_PartType_Exercise: {moveTo: AREA_EOC, resetAt: RESET_CHAPTER, numberAt: NUMBER_BEFORE_MOVE, titleContent: Config_exerciseTitleContent, },
  Config_BookCompositePages: [
    {className: "solution",    clusterBy: CLUSTER_CHAPTER, compoundComposite: true, moveSolutionsTo: AREA_EOB, name: "Answer Key"},
    {className: "index",      clusterBy: CLUSTER_NONE, specialPageType: PAGE_INDEX, name: "Index"},
  ],
  Config_Notes: [
    {className: 'link-to-learning', labelText: "Link to Learning"},
    {className: 'sciences-interconnect', labelText: "How Sciences Interconnect"},
    {className: 'chemist-portrait', labelText: "Portrait of a Chemist"},
    {className: 'everyday-life', labelText: "Chemistry in Everyday Life"},
  ],

  Config_PartType_Table_CaptionContent: [{'os-title-label': "Table "}, {'os-number': [counter('chapter'), ".", counter('table')]}, {'os-divider': ' '}],
  Config_SetTableCaption: {captionType: CAPTION_TABLE, defaultContainer: 'caption', hasCaption: true, hasTitle: true, hasTopTitle: true},
  Config_PartType_Figure_CaptionContent: [{'os-title-label': "Figure "}, {'os-number': [counter('chapter'), ".", counter('figure')]}, {'os-divider': ' '}],

  Config_PartType_Example: {moveTo: AREA_NONE, titleContent: _exampleTitleContent, apTitleContent: _exampleTitleContentAP, solutionTitleContent: _exampleSolutionTitleContent},
  Config_PartType_Chapter: {outlineTitle: 'Chapter Outline'},
  Config_CustomList: [
    {selector: '.stepwise', name: "stepwise", beforeLabel: "Step ", afterLabel: ". "},
  ],
  Config_hasCompositeChapter: true,

}

writeFileSync('./chemistry.config.json.xml', `<json-root>${JSON.stringify(config, null, 2)}</json-root>`)