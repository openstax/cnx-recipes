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


# TitleContent

Describes numbering and labeling of elements. Also known as FigNumber, TableNumber

- `title-label` - string
- `number` - set of counters
- `divider` - string


# setFigure(Table)Caption

- `type` token (can be `table` or `figure`)
- `defaultContainer` token (can be `caption`)
- `hasCaption` bool
- `hasTitle` bool


# $targetLabels

These are used when creating the text for a link (ie `See Figure 4.3`).

## TargetLabel

- `selector` string
- `label` nodes? containing things like `"Figure" counter(chapter) "." counter(figure)`
