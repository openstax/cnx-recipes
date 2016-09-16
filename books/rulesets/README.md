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
