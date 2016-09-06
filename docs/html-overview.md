Each Page contains the following:

- `div[data-type='page']` : Everything in here is specific to the page
  - `div[data-type='metadata']` : Attribution information for the page
  - `h2[data-type='document-title']` : The title of the Page
    - ~`.text`~ Artifacts that may change so do not use those
    - `.number` : The section number in the book (ie `3.2`)
    - `.divider` : A character like ` | `
    - `.text` : The title of the section in the book
  - `cnx-pi` Ignore these; they will disappear in the future


Then, within a Page (chapter/section), the following elements may occur:

- `.figure`
  - `[data-type='title']`: An optional title of the figure
  - `figure`
    - `[data-type='media']` : a wrapper element which may disappear in the future
      - `img[src][alt]` : The image for the Figure
  - `.caption-container` : contains the figure number and caption (may be renamed to `figcaption` in the future and moved into `figure`)
    - `.title-label` : The word `Figure`
    - `.number` : The number of the figure (ie `3.1`)
    - `.caption`

- `[data-type='note']` : A "feature" in a book that usually has a border so it stands out from the normal flow of content in the book
  - These have an additional class on them to be able to have additional custom styling applied
  - `[data-type='title']` : The title of the feature

- `p` : A paragraph of text
  - `[data-type='term']` : A term that is defined in the glossary
  - `strong`
  - `em`
  - `[data-type='list']` : an inline list
    - `[data-type='item']` : an item in the list
  - `math` : MathML

- `section`: A (sub)section of text with a title
  - `h3[data-type='title']` : The title of the section

- `[data-type='example']` : This has the same structure as a `[data-type='note']`
- `[data-type='exercise']` : An exercise which contains a problem, optional title, and optional solution(s)
  - `[data-type='problem']`
  - `.title`
  - `[data-type='solution']`
  

- `[data-type='glossary']` : The glossary at the end of a chapter or book
  - `dl`
    - `dt` : The term
    - `dd` : Definition(s) of the term

# TODO

These elements either need descriptions or need to be removed

- `[data-type='footnote-refs']`
- `[data-type='footnote-title']`
- `[data-type='footnote-ref']`
- `[data-type='footnote-number']`
- `[data-type='equation']`
- `[data-type='image']`
- `.term-section`
- `.term-section-link`
- `.index-item`
- `.group-by`
- `.group-label`


Any other attributes on elements should not be used for styling; they are artifacts of our internal transformation. If you would like to use them, please let us know.



```js
// Broser-Code to obtain all the attributes (paste into dev tools)

Array.prototype.slice.call(document.querySelectorAll('*')).map(function(el) { if (el.getAttribute('data-type')) { return "[data-type='" + el.getAttribute('data-type') + "']"; } else if (el.className) {return "." + el.className.split(' ').join('.') } else {return el.tagName.toLowerCase()} })
```
