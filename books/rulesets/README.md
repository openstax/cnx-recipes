# About the Rulesets

The generated CSS is stored in the [./output](./output) directory.

## Relevant Scripts

```sh
./scripts/bake-book ${BOOK_NAME}  # Uses the results of `./scripts/fetch-book` stored in `/data`
./scripts/generate-guide ${BOOK_NAME}
```


# Guide Documentation

The source for the documentation is in CSS comments and is split into `common` and book-specific.

## Directory Organizational Map

- `./common/examples/*.html` : The Raw HTML snippets for "common" elements in a Page
- `./common/examples/_all.scss`: The documentation for "common" elmeents in a Page
- `./examples/*.html` : The Raw HTML snippets for book-specific collated pages and any other customizations
- `./${BOOK_NAME}.scss`: Added CSS docs that are slurped in when generating the guide

## Book-Agnostic Documentation

The common documentation is in `./common/examples/_all.scss` only because phil didn't know of a better place to put them but wanted them "near" the common code. That directory also contains the Raw HTML snippets.

## Book-Specific Documentation

The book-specific documentation is done as comments in the `${BOOK_NAME}.scss` and `${BOOK_NAME}-config.scss` files and the Raw HTML snippets are in `./examples/` because each book does not have a directory (yet?).


# Mixin Types

These are the Types used to configure the numbering an collation of a book.

# Page

- `name` - string
- `source` - string class name (usually) sometimes it gets converted to a data-type (should probably be a data-type)
- `isGlossary` - bool
- `sortBy` string (selector)
- `sectionSeparated` - bool
- `chapterSeparated` - bool
- `hasSolutions` - bool
- `isIndex` - bool
- `compoundComposite` - bool
- `isAnswerKey` - bool

These are collected into a list as `$chapterCompositePages` and `$bookCompositePages` in the config file.


### Mixins

```sass
@include reference_refSectionHeaderNodeAs(sectionHeaderNode);
@include compose_createChapterComposites($chapterCompositePages, sectionHeaderNode);

//After: ???
@include reference_refSectionHeaderNodeAs(sectionHeaderNode);
@include reference_refSectionHeaderStringAs(sectionHeaderString);
@include compose_prepBookComposites($bookCompositePages, sectionHeaderNode, sectionHeaderString);

//Only move solutions after exercises/solutions are numbered
@include reference_refSectionHeaderNodeAs(sectionHeaderNode);
@include compose_createEOBSolutions($chapterCompositePages, $pageSolutions, sectionHeaderNode);

//After: prepBookComposites
@include reference_refChapterHeaderNodeAs(chapterHeaderNode);
@include compose_prepChapterAreas($bookCompositePages, chapterHeaderNode);

//After: prepBookComposites, prepChapterAreas
@include compose_createBookComposites($bookCompositePages);

//After: createChapterComposites, createEOCSolutions, createBookComposites
@include compose_titleEOCComposites($chapterCompositePages);
@include compose_titleEOBComposites($bookCompositePages);

//After: createChapterComposites, createEOCSolutions, createBookComposites
@include modify_compositeAutoID();
@include modify_chapterAutoID();

@include modify_retitleCompositeMetadata();
```

# TitleContent

Describes numbering and labeling of elements. Also known as FigNumber, TableNumber

- `title-label` - string
- `number` - set of counters
- `divider` - string

### Mixins

```sass
//Come up with mixins for common numbering schemes as per Phil's suggestion
@include count_countChapters(chapter);
@include number_numberChapters($chapterTitleContent);
@include count_countAppendices(appendix);
@include number_numberAppendices($appendixTitleContent);
@include count_countSections(section);
@include number_numberSections($sectionTitleContent);
@include count_countExamples(example);
@include number_numberExamples($exampleTitleContent, $exampleSolutionTitleContent);
@include count_countNote(Try, "try");
@include number_numberNote("try", $tryTitleContent);
@include number_numberNote("calculator", $calcTitleContent);


//After: createChapterComposites
@include count_countEOCExercises(exercise);
@include number_numberEOCExercises($exerciseTitleContent, $exerciseTitleContent);
```

# setFigure(Table)Caption(Number)

- `type` token (can be `table` or `figure`)
- `defaultContainer` token (can be `caption`)
- `hasCaption` bool
- `hasTitle` bool

### Mixins

```sass
@include count_countTables(table);
@include count_countFigures(figure);
@include number_setCaptions($setTableCaption, $captionTableNumber, $captionTableNumberAp);
@include number_setCaptions($setFigureCaption, $captionFigNumber, $captionFigNumberAp);
```

# TargetLabel

These are used when creating the text for a link (ie `See Figure 4.3`).

- `selector` string
- `label` nodes? containing things like `"Figure" counter(chapter) "." counter(figure)`

These are collected in `$targetLabels`.

```sass
//After: composite page creation
@include count_countChapters(chapter);
@include count_countAppendices(appendix);
@include count_countEOCExercises(exercise);
@include count_countExamples(example);
@include link_setTargetLabels($targetLabels);
@include link_setLinkLabels();
```


# ToC

Generating to Table of Contents requires the following mixins (each done in a separate pass).

```sass
@include toc_prepTOCElements();
@include toc_putTOCElements();
@include toc_navTOCUnwrap();
```


# Misc mixins

These are a grab-bag of the rest of mixins that are used. They should eventually be grouped into categories.

```sass
//Some modifications to be done to the book before any collation
@include modify_titlePreface();
@include modify_spanWrapTitles();
@include modify_simLinkTarget();
@include modify_trash('.try [data-type="solution"]');
@include utils_hasSolution();

@include count_countTerms(term);
@include reference_refPageIDStringAs(pageID);
@include modify_prepIndexTerms(term, pageID);

//After: createChapterComposites, numberEOCExercises
@include count_countExercises(exerciseAll);
@include link_linkToProblemsFromSolutionsEOC("number", "number", exerciseAll);

//After: prepIndexTerms, createBookComposites
@include modify_addIndexSymbolGroup("index", $symbolsSectionTitle);

@include reference_refBookMetadataNodeAs(bookMetadata);
@include modify_compositeMetadata(bookMetadata);

//After: All metadata tasks are completed
@include modify_suppressURI();

@include utils_clearTrash();
```
