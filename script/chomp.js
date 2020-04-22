const fs = require('fs');
const jsdom = require("jsdom");
const { JSDOM } = jsdom;
var xmlserializer = require('xmlserializer');

const bookName = process.argv[2];
const chapterNum = process.argv[3];

const assembledBook = `data/${bookName}/collection.assembled.xhtml`;

const assembledBookContents= fs.readFileSync(assembledBook , 'utf-8');

const dom = new JSDOM(assembledBookContents);

// console.log(dom.window.document.querySelector("#toc ol:first-child li a").textContent);

const chaptersToDelete = dom.window.document.querySelectorAll(`[data-type="chapter"]:not(:nth-of-type(${chapterNum}))`);

chaptersToDelete.forEach(chapter => {
  chapter.remove();
});

let domString = s.serializeToString(dom);
saveXML(domString);

fs.writeFileSync(domString, assembledBook);