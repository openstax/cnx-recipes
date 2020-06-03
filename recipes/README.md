# About the Recipes

The generated CSS is stored in the [./output](./output) directory.

## Relevant Scripts

```sh
./script/fetch-html ${book_name}     # Stores result in `./data/`
./script/bake-book ${book_name}      # Uses the results of `./script/fetch-html`
./script/build-guide ${book_name}
```


# Guide Documentation

The source for the documentation is in CSS comments and is split into `common` and book-specific.

[An example config file with documentation](./books/_example/)

## Directory Organizational Map

- `./recipes/mixins/styleguide/*.snippet.xml` : The Raw HTML snippets for "common" elements in a Page
- `./recipes/mixins/styleguide/_all.scss`: The documentation for "common" elements in a Page
- `./recipes/books/${book_name}/styleguide/*.snippet.xml` : The Raw HTML snippets for book-specific collated pages and any other customizations
- `./recipes/books/${book_name}/book.scss`: Added CSS docs that are slurped in when generating the styleguide

## Book-Agnostic Documentation

The common documentation is in `./recipes/mixins/styleguide/_all.scss` only because phil didn't know of a better place to put them but wanted them "near" the common code. That directory also contains the Raw HTML snippets.

## Book-Specific Documentation

The book-specific documentation is done as comments in the `./recipes/books/${book_name}/book.scss` and `./recipes/books/${book_name}/_config.scss` files and the Raw HTML snippets are in `./books/${book_name}/styleguide/`.


# Variable Naming Conventions

There are 4 different types of variables used in the SASS files:

- starts with `Config_`: these are defined in the config file and are the **only** ones used as input to `_generator.scss`
- `$UPPER_CASE`: these are enums (SASS does not have native enums) and are used when you must select 1 of several options.
    - Example: `$AREA_NONE`, `$AREA_EOC`, `$AREA_EOB`
- `$_privateVar`: these are declared and used **within** the SCSS file
- `$PascalCase`: these are defined in one `_config.scss` file but are used in another `_config.scss` file


# Config Settings Hierarchy

The config settings are variables that start with `$Config_` and have the following structure:

## `$GRAMMATICAL_CASES`

This describes the different ways to say "Figure". The content has an attribute that belongs to the katalyst namespace that describes the different cases.

The attribute is `cmlnle:case` and has namespace "http://katalysteducation.org/cmlnle/1.0"

These are used when building links. See `$Config_TargetLabels` for more information

Each link target (e.g. figure) has multiple options for link text depending on the `cmlnle:case="..."` attribute on the link.

```less
a:target-is-a(figure) {
    &[cmlnle|case="nominative"]   { content: "Rysunek" }
    &[cmlnle|case="genitive"]     { content: "Rysunku" }
    &[cmlnle|case="dative"]       { content: "Rysunkowi" }
    &[cmlnle|case="accusative"]   { content: "Rysunek" }
    &[cmlnle|case="instrumental"] { content: "Rysunkiem" }
    &[cmlnle|case="locative"]     { content: "Rysunku" }
    &[cmlnle|case="vocative"]     { content: "Rysunku" }
}
```


## `$Config_hasCompositeChapter`

- not sure if this is the same thing as a ChapterCompositePages
- add an h1 for each one (e.g. "Key Terms", "Index")
- heading levels are "sane" meaning they are nested properly in the baked file (composite chapter title is like h2 and the compositepage inside it is h3 for accessibility)
- copy the book metadata into each composite pages (this is because the code that imports back into the DB requires a metadata element)
- implicitly, a non-leaf entry is added to the ToC


## `$Config_ChapterCompositePages`

A list of Pages
- composite pages are given an id attribute so that they can be linked to from the ToC
- create a Page (contains a data-uuid-key, title, metadata, etc) whose contents is collected from items that match `className` from each entry in the list

A `Page` contains the following fields:
- `$page.className`: the class name (and bucket) of the page
- `$page.name`: The title of the new page (TODO rename?)
- `$page.hasSolutions`: `true` when this item contains exercises that contain solutions
    - (TODO: why is this necessary?)
- `$page.clusterBy`: `$CLUSTER_SECTION`, `$CLUSTER_CHAPTER`, or `$CLUSTER_NONE` when items on this page should be organized by Section/Chapter
    - A header is added which contains the section number and title
- `$page.specialPageType`: (optional) There are also a few "special" pages which contain additional configuration fields: 
    - `$PAGE_INDEX`
    - `$PAGE_GLOSSARY`
    - `$PAGE_INDEX_PARTIAL` : A few books contain multiple indexes. Each term contains an attribute that defines which index it should be added to (`[cxlxt|index]`)
        - `$page.indexType`: which type of index this is. This string should match the possible values of the `term/@cxlxt:index` attribute on each term.
        - `$page.defaultIndex`: `true` if this index is the default. Terms that do not have a `cxlxt:index="..."` attribute on them will be added to this index (hopefully there is only one default index!) 
    - `$PAGE_CITATIONS` : collects each note that has a class name of `$page.className`
- `$page.childPages`: (optional) Some generated pages are just a container for other Pages. This contains the list of child Pages that need to be generated
- ``


### `$page.clusterBy == $CLUSTER_NONE`

Example HTML that is injected:

```xml
<!-- <div data-type="chapter"> -->
<!-- ... Normal chapter content -->
    <div data-type="page" id="{generate-id()}" class="{$page.className}">
        <h#>{page.name}</h#>

        <!-- bucket contents -->
        <!-- <div data-type="section"> Ex1 ...</div> -->
        <!-- <div data-type="section"> Ex2 ...</div> -->
        <!-- <div data-type="section"> Ex3 ...</div> -->

    </div>
<!-- </chapter> -->
```

### `$page.clusterBy == $CLUSTER_SECTION`

```xml
<!-- <div data-type="chapter"> -->
<!-- ... Normal chapter content -->
    <div data-type="page" id="{generate-id()}" class="{$page.className}">
        <h1>{page.name}</h1>

        <!-- bucket contents grouped by which section it came from -->
        <h2><a href="#...">4.1 Kinematics in One Dimension</a></h2>
        <!-- <div data-type="section"> Ex1 ...</div> -->
        <!-- <div data-type="section"> Ex2 ...</div> -->
        <!-- <div data-type="section"> Ex3 ...</div> -->

        <h2><a href="#...">4.2 Kinematics in Two Dimensions</h2>
        <!-- <div data-type="section"> Ex1 ...</div> -->
        <!-- <div data-type="section"> Ex2 ...</div> -->
        <!-- <div data-type="section"> Ex3 ...</div> -->

    </div>
<!-- </chapter> -->
```


## `$Config_SectionCompositePages`

A list of [Pages](#page)
- Each one has a `h1[data-type="document-title"]` added to it 
- the line Phil commented just moves the solutions but this area does all this: Creates a Page, moves exercises to it, groups the exercises by section, and adds the section title to the group (with a link back to the section). At this point the exercises & solutions seem to be numbered
- exercises within them need to be numbered


## `$Config_BookCompositePages`

A list of [Pages](#page)

These tend to be Indexes, an Answer Key, a References Page, or a book-wide Glossary.


### `$page.specialPageType == $PAGE_INDEX`

An index links to all terms in the book. The terms are sorted alphabetically but there is a language-specific regular expression that defines what goes in the Symbols section (`$Config_Index_SymbolRegexp` and `$Config_Index_NotSymbolRegexp`). A book may have **multiple indexes**.

Here is a quick "template" of an index followed by a more concrete example:

```
<h#>Index</h#>
<div.group-by>
    <span.group-label>A</>
    <span.os-index-item>
    <span.os-term group-by="A">Accessibility Improvements</>
    <a.os-term-section-link href="..." >
        <span.os-term-section>Preface</>
    </>
    <span.os-index-link-separator>,</>
    </>
</>
<div.group-by>
    <span.group-label>B</>
    ...
</>
```


```xml
<!-- <body> -->
<!-- ... Chapters and Appendixes -->

<div data-type="composite-page" data-uuid-key="index" class="os-eob os-{$page.specialPageType}-container">
    <h1 data-type="document-title">{$page.name}</h1>
    <!-- metadata copied from the book but the title is replaced with "Index" -->
    <div data-type="metadata" style="display: none;">...</div>

    <div class="group-by">
        <span class="group-label">Symbols</span>
        <div class="os-index-item">
            <span class="os-term">{$theTermName}</span>
            <a href="#{$uniqueIdToTheTerm}" class="os-term-section-link">{$autogeneratedLinkTextToTheSection}</a>
        </div>
        <div class="os-index-item"><!-- 1998 Telecommunications Act --></div>
        <div class="os-index-item"><!-- +1 Spin --></div>
    </div>

    <div class="group-by"><!-- A --></div>
    <div class="group-by"><!-- B --></div>
    <div class="group-by"><!-- C --></div>
    <div class="group-by"><!-- D --></div>
</div>
<!-- </body> -->
```

#### Additional things pertaining to an Index

Add an autogenerated id attribute to each term that does not have one because we will link to it from the index


### `$page.clusterBy == $CLUSTER_CHAPTER` and `$page.chapterPages == true`

This is used when generating the answer key at the back of the book. Answers are grouped by chapter.

```xml
<!-- <body> -->
<!-- ... Normal book content including Appendixes but not the Index -->
    <div data-type="composite-page" data-uuid-key=".{$page.className}" id="{generate-id()}" class="os-{$page.className}-container">
        <!-- metadata copied from the book but the title is replaced with "Index" -->
        <div data-type="metadata" style="display: none;">...</div>

        <h1 data-type="document-title">{page.name}</h1>

        <!-- bucket contents grouped by which chapter it came from -->
        <div data-type="page" data-uuid-key="..." id="{generate-id()}">
            <h2><a href="#...">4 Kinematics</a></h2>
            <!-- <div data-type="section"> 4.1 C ...</div> -->
            <!-- <div data-type="section"> 4.2 C ...</div> -->
            <!-- <div data-type="section"> 4.3 C ...</div> -->
        </div>
        
        <div data-type="page" data-uuid-key="..." id="{generate-id()}">
            <h2><a href="#...">5 Force</a></h2>
            <!-- <div data-type="section"> 4.1 C ...</div> -->
            <!-- <div data-type="section"> 4.2 C ...</div> -->
            <!-- <div data-type="section"> 4.3 C ...</div> -->
        </div>
    </div>
<!-- </body> -->
```


## ToC
## Unit
## Appendix
## Chapter
## Section
## Table
## Figure
## Note
## Exercise
### Solution
## Example
## Equation
## Link



## `$Config_SetTableCaption`

A [Caption](#caption)

Additionally, there is a `hasTopTitle` which moves the title above the table instead of below it




- `$Config_SetFigureCaption`: A [Caption](#caption)
- `$Config_Notes`: A list of [Notes](#note)
  - Every note changes from `<data-type="note"><data-type="title" id>X</>Y</>` to `<data-type="note"><h#.os-title data-type="title"><span.os-title-label id>X</></><div.os-note-body>Y</></>`
- `$Config_UnnumberedElements`: A list of [UnnumberedElements](#unnumberedelements)
- `$Config_PartType_*`
  - FOR_STYLING_ONLY: gets a class on it when it has a FirstElement
  - `$Config_PartType_Exercise`: A [CustomPart](#custompart)
    - gets a class on it when it has a FirstElement FOR_STYLING_ONLY
    - gets a `.os-hasStimulus` class on in the exercise when it `:has(.exercise-stimulus)`
  - `$Config_PartType_Example`: A [CustomPart](#custompart)
    - Examples are Numbered. The numbering can be set to reset at the section or not (`resetAt`)
      - `<.os-title><.os-title-label>Example </><.os-number>B12</><.os-divider> </.os-divider></>`
    - Feature flags define whether Examples in an Appendix are numbered or not (`appendix-has-numbered-examples`) and if the subtitle is numbered (`subtitled-examples`)
    - Change the subtitle from a span to an `<h#>` (flag: `subtitled-examples`)
    - Wrap the contents of an example with `<div.body>`
  - `$Config_PartType_Chapter`: A [CustomPart](#custompart)
    - if `outlineTitle` is truthy, it causes the `.os-chapter-outline` to move **into** the top of the `.introduction` Page
    - Autogenerate a chapter outline (older books use this) and remove it for newer books (Note: We should only generate an outline if the book is configured for that. Not this build-for-every-book-and-discard-for-some). older books use the metadata to build a chapter outline section in the intro module. It must be created at the chapter level then moved.
  - `$Config_PartType_Equation`: A [CustomPart](#custompart)
  - `$Config_PartType_Solution`: A [CustomPart](#custompart)
    - change the solutions exercise number (`<span.os-number>12</>`) into a link back to the exercise
    - add `.os-has-solution` to the exercise if it contains a solution and if the recipe is not discarding all solutions
    - wrap the solution content in an element (e.g. from `<data-type="solution">...</>` to `<data-type="solution"><div.os-solution-container>...</></>`)
  - `$Config_PartType_Chapter_TitleContent`: A [TitleContent](#titlecontent)
    - The title of a chapter (`[data-type="document-title"]`) gets an id attribute (assuming so that we can link to it but not sure)
    - add `<span class="os-number">Chapter 1</span><span class="os-divider"> </span>` to the chapter title (`[data-type="chapter"] > [data-type="document-title"]`)
  - `$Config_PartType_Unit_TitleContent`: A [TitleContent](#titlecontent)
  - `$Config_PartType_Appendix_TitleContent`: A [TitleContent](#titlecontent)
    - Appendixes are numbered (just like `$Config_PartType_Section_TitleContent`). By adding `<.os-number>Appendix M</><.os-divider> </>` to `[data-type="document-title"]`
    - Section titles are converted from an `<h1 data-type="document-title">` to a `<div data-type=...>`
    - Section titles are converted from a `<h1 data-type="document-title" itemprop="name">` to a `<span.os-text data-type="" itemprop="">`
  - `$Config_PartType_Section_TitleContent`: A [TitleContent](#titlecontent)
    - Sections are numbered. By adding `<.os-number>1.6</><.os-divider> </>` to `[data-type="document-title"]`
    - Section titles are converted from an `<h2 data-type="document-title">` to a `<div data-type=...>`
    - Sections have a `.chapter-content-module` added to them (feature flag)
    - Replace the section title with the title from the ToC and wrap it in an `<h#>`
      - e.g. from `<div data-type="document-title" id="auto_m68867_87869">Introduction: Ionization Constants of Weak Bases</div>` to ` <div data-type="document-title" id="auto_m68867_87869"><h1 data-type="document-title" itemprop="name">Ionization Constants of Weak Bases</h1></div>`
  - `$Config_PartType_Table*`
    - move the summary element from inside the caption into the `div.os-table`
    - autogenerate a summary attribute on the table from the table's caption
    - wrap table inside a `div.os-table` (for styling and REX depends on this)
    - when `hasTopTitle` is set do both of the following:
      1. move the title above the table instead of below it
      1. delete the `thead` when the FEATURE_FLAG table-move-fake-title is set
    - wrap the title in a `.os-table-title` FOR_STYLING_ONLY

  - `$Config_PartType_Table_CaptionContent`: A [TitleContent](#titlecontent)
    - create a below the Table inside a chapter and label it according to an array of classname, value pairs. The Value can be literal text or a counter and generates something like: `<.os-text>Table </.os-text><.os-number>4.3</.os-number><.os-divider>: </.os-divider>`. The elements (& class names) are FOR_STYLING_ONLY. Actually, they're also used for building the slugs & some are discarded during the slug generation
  - `$Config_PartType_Table_CaptionContentAp`: A [TitleContent](#titlecontent)
    - same as above but this applies to tables in the Appendix. Usually just the counter changes (e.g. `A3` instead of `4.3`)
  - `$Config_PartType_Figure`
    - FOR_STYLING_ONLY: gets a class on it when it contains a splash image
  - `$Config_PartType_Figure_CaptionContent`: A [TitleContent](#titlecontent)
    - same as the `$Config_PartType_Table_CaptionContent`
  - `$Config_PartType_Figure_CaptionContentAp`: A [TitleContent](#titlecontent)
- `$Config_Coverage_*`
  - `$Config_Coverage_MayHaveSimlinks`: a boolean
    - change `<a.os-interactive-link/>` to `<a.os-interactive-link target="_blank"/>`
  - `$Config_Coverage_MayHaveIframes`: a boolean
    - add attributes on the iframe parent so that CSS can choose which alternative to show from several different options without relying on `:has(...)`
      - change `<iframe/>` to `<data-type="alternatives" .os-has-iframe.os-has-link.os-has-image><iframe.os-is-iframe/><a.os-is-link/><img.os-is-image/></>` 
  - `$Config_Coverage_MayHaveMissingExercises`: a boolean
- `$Config_HACK_modifyAnyContainerTitleSelector`: a boolean
- `$Config_hasCompositeAppendixes`: a boolean (used for some TEA books)
- `$Config_hasCitation`: a boolean used for References.

- `$Config_Toc*`
  - a flag to unwrap the span elements in the ToC (for the carnival theme)
  - `$Config_TocTitleWord` : Add the word "Contents" to the ToC

- `$Config_addSolutionHeader`
  - seems to define whether solutions are discarded or kept
- `$Config_hasStimuli`
- The Book Preface
  - change the `<.preface><data-type="document-title">` to a `<.preface><h1 data-type="document-title">`

## TitleContent

This is a map whose keys are the `className` of the element that will be created (ie `os-divider` or `os-number`) and the values are the css that will be used (ie `"|"` or `counter(exercise)`).

Example:

```scss
(
  os-title-label: "Example",
  os-divider: " ",
  os-number: counter(chapter) "." counter(example),
  os-divider: ":",
)
```


## Page

These are the end-of-chapter/book pages that are autogenerated.

A `Page` contains the following fields:
- `className`: the class name (and bucket) of the page
- `name`: The title of the new page (TODO rename?)
- `hasSolutions`: `true` when this item contains exercises that contain solutions
  - (TODO: why is this necessary?)
- `clusterBy`: `$CLUSTER_SECTION`, `$CLUSTER_CHAPTER`, or `$CLUSTER_NONE` when items on this page should be organized by Section/Chapter
  - A header is added which contains the section number and title
- `specialPageType`: (optional) There are also a couple of "special" pages: `$PAGE_INDEX` and `$PAGE_GLOSSARY`
which contain additional configuration fields.
- `childPages`: (optional) Some generated pages are just a container for other Pages. This contains the list of child Pages that need to be generated

Also, a set of styleguide comments occur above for each composite page.
Having it here makes it easy to remember to update the documentation and by having it above the `$Config_ChapterCompositePages` helps make this area
more readable (since it sort of looks like a table).


## Caption

This configures a Table or Figure caption.

A `Caption` contains the following fields:

- `captionType`: whether this is for a table or a figure
  - `$CAPTION_TABLE`
  - `$CAPTION_FIGURE`
- `defaultContainer`: An element that is created to contain the caption
- `hasCaption`: a boolean
- `hasTitle`: a boolean
- `resetAt`: en enum. The numbering either resets at the chapter (empty) or at the section (`moduleReset`)

## TargetLabel

Configure the labels of links. You will likely just extend the default set with a label for items specific to this book, like links to `Try It` notes.

(TODO: maybe this should be the default for links to Notes?)
**NOTE:** These selectors MUST match the counting selectors or be more specific
otherwise, the increment and the counter() call may fire in the wrong order.

A `TargetLabel` contains the following fields:

- `selector`: This a selector that matches the target of a link
- `labelText`: This is the text that will be inside the link
  - It can be a list or a map. If it is a map (used in i18n), the key corresponds to the `@cmlnle:case="..."` attribute. see #353


## Note

These are a Set of "Feature boxes" that are specific to the book.

A `Note` contains the following fields:
- `className`: the class name of the Note
- `moveSolutionTo`: Where the solution can be moved to.
  - `$AREA_NONE` keeps the solution in place
  - `$AREA_TRASH` discards the solution
  - `$AREA_EOC` moves the solutions to the end of a chapter
  - `$AREA_EOB` moves the solutions to the end of the book
- One of the following:
  - `useHeader`
  - `replaceHeader`
    - `labelText`: A simple string for the title. cannot be used with `titleContent`
      - Wrap the note body with a `<.os-note-body>` and create a `<h#.os-title data-type="title">{labelText}</>` as the first child of the note
    - `titleContent`: what the autogenerated title should look like.
      - Most notes are just a string but some, like "Try It"
        are prefaced with which section they occur in

- `counterName`: (optional) used in conjunction with titleContent to specify the name of the counter



## UnnumberedExercise

Sometimes exercises (or equations) in notes should not be numbered. This shows which ones.

The name of this type is currently a little confusing but it is this because the need for unnumbered Exercises came before the need for unnumbered Equations.

TODO: It would be nice to move these into the note config but it seems like
the context is not always a note, and the child is not always an exercise/equation.
so the proper place to put this requires a bit more thought

It contains the following fields:

- `contextSelector`
- `childSelector`: (optional)


## CustomPart

This contains additional elements in the book (like an equation, exercises, solutions)
Each entry has a few common fields that can be set:
- `moveTo`: specifies where to move this element to
  - `$AREA_TRASH_HALF` (only for Config_PartType_Solution) will mark half of solutions for deletion before collation to the answer key
- `resetAt`: specifies when the counters should reset
  - `$RESET_SECTION` resets for each module
  - `$RESET_CHAPTER` resets for each chapter
  - `$RESET_COMPOSITE_PAGE` resets for each autogenerated page
- `titleContent`: The generated title for this element

- `outlineTitle`: (optional) Only used by `Chapter`
- `numberAt`: (optional) Only used by `Exercise`
- `solutionTitleContent`: (optional) Only used by `Example`
- `excludeNumberingInClassName`: (optional) Only used by `Equation`
- `hasLearningObjectives`: (optional) Only used by `Chapter Outline`
