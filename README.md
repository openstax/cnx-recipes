[![Coverage][coveralls-image]][coveralls-url]

# Install

1. run `./scripts/setup` to install the dependencies. You only have to run this once!

**Note:** To update the dependencies, run `./scripts/update`

# Bake a New Book

1. run `./scripts/fetch-book statistics`
  - **Note:** To see the list of books available see `./books.txt`
  - **Note:** This will require you to log in via ssh.
  - **Note:** You can set the ssh username by running `USER=myusername ./scripts/fetch-book ...`
  - **Note:** You can set the remote server to pull from by running `HOST=dev.cnx.org ./scripts/fetch-book ...`
  - **Note:** You can run `./scripts/fetch-book --all` to fetch all the books
1. run `./scripts/bake-book statistics`

There are 2 major parts to baking a book (_listed above_). You will first need to get the single-file HTML from the server (`fetch-book`) and then convert the single-file HTML locally into the "baked" book via `bake-book`. Once you have done the first part, you can run `./scripts/bake-book statistics` to your :heart:'s content!


## Add a New Book to the config

Sometimes you need to add a new book (like "dark-matter-for-dummies") into this repo. Here are the steps to add it:

1. Find the UUID of the book you want
  - point your browser to `cte-cnx-dev.cnx.org` and find a book you want.
  - click "More Information" and copy the **ID**
1. add an entry to `./books.txt`


# Test

1. run `./scripts/test`

This will run the linter, generate sassdocs, and generate the guides to verify they work.

# Documentation

1. run `./scripts/generate-docs` to generate the SASS Docs
1. run `./scripts/generate-guide statistics` to generate the HTML Guide for a book
1. open the generated file in your browser

## CSS Coverage

1. run `./scripts/fetch-book ${bookName}` to fetch the Raw HTML for a book
1. run `./scripts/bake-book ${bookName}`
1. The HTML Report should now be available at `./coverage/`

You can pass 3 additional arguments to `report-book-coverage` to change how it reports coverage:

- `--verbose` : outputs verbose/debugging output
- `--ignore-source-map` : covers the CSS even if a sourceMappingURL is found.
- `--cover-declarations` : generates coverage based on the declarations, not just the selector
- **Note:** You can run `./scripts/report-book-coverage --all` to generate coverage using all the books

For more details on the commandline options see the [css-coverage](https://www.npmjs.com/package/css-coverage#commandline-options) documentation.


## Deploy

To update a development instance you need to rebake a book.
To do that, you will need to upload a CSS ruleset file, trigger a rebake, and then clear the cache.

1. run `./scripts/compile-books` to generate the rulesets CSS file
1. run `./scripts/bake-book-remote ${BOOK_NAME} ${VERSION}` to upload, trigger, and clear the cache

  - `${BOOK_NAME]` is the book’s name in the book list of `/books.txt`
  - `${VERSION]` is the `@#.##` in the target collection URL

### Example

For example, you want to rebake the "cooking" book:

1. you can run `./scripts/bake-book-remote cooking` and it will tell you to go to `http://foo.cnx.org/contents/${UUID}`
1. find the version (ie `7.16`) by looking at the URL or by clicking “More Information” at the bottom of the page
1. run `./scripts/bake-book-remote cooking 7.16` (using that version you found)


## Regression Testing

To check that there were no regressions in a book what the following process does is:

1. bake the book with the old code
1. bake the book with the new code
1. compare the 2 baked HTML files to see if there were any differences

Here are the steps to run it:

```sh
# Prep work (only have to run once)
./scripts/setup
./scripts/fetch-book statistics # Or any book in ./books.txt

# Check out the old version (ie `master` branch)
# Then run:
./scripts/diff-book-prepare statistics

# Check out the new code (ie `shiny-unincorns` branch)
# Then run:
./scripts/diff-book statistics

# Any differences would pop up here

# Optional: Create a diff and give it to a GUI
diff ./data/statistics-prepared.html ./data/statistics-baked.html > foo.diff
```

**Note:** You can specify `--all` instead of `statistics` to diff all the books (assuming they have been fetched)

## Experimental

To update the Documentation in the gh-pages branch:

1. `git checkout master`
1. `./scripts/generate-and-update-gh-pages`

**Note:** This will push changes if successful


[coveralls-image]: https://img.shields.io/coveralls/connexions/cnx-recipes.svg
[coveralls-url]: https://coveralls.io/github/Connexions/cnx-recipes
