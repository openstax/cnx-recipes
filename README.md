[![Coverage][codecov-image]][codecov-url]

**Note For Windows Users:** If your username contains whitespace, the setup and installation may not work. Create a new user without whitespace in the username in order to succesfully complete installation.

# About 
The cnx-recipes repo contains the recipes and styles framework. The recipe framework is used for content manipulation and the styles framework is used to style the content. The backend of the recipes framework is contained in the [cnx-easybake repo](https://github.com/openstax/cnx-easybake). 

[Baked PDF frameworkguide](./styles/styling-bakedpdf.md)

[Styling framework tutorial](./styles/README.md)

## Installation

Almost all of the scripts that we run to generate outputs at various steps of development require docker and or bakery-cli. 

Run `./script/install-docker` to install docker and docker-compose.

[To install bakery-cli follow the instructions here.](https://www.npmjs.com/package/@openstax/bakery-cli)

There are 6 steps in the PDF generation pipeline: 
 - **fetch** : fetch raw cnxml content from a specified server
 - **assemble** : converts the cnxml to xhtml
 - **link-extras** : 
 - **bake** : based on a given set of instructions, 
 - **mathify** : converts mathjax to svg
 - **build-pdf** : generates a PDF

We perform these steps by running commands locally using either bakery-cli or docker-compose. 

The `./script/` folder contains a variety of scripts relating to installation, book generation, and testing. 

It's recommended to prepend the `./script/run` script when running most scripts from this directory. Although not requried, the `run` script runs the `setup` script and tries to ensure that you have the necessary dependencies by running the script in a docker container. For example, if you want to run `./script/fetch-book`, you would run `./script/run ./script/fetch-book`. 


Then run Prince on the XTML file with the PrinceXML command `prince --style ./output/{book-file}.css ./data/{book-name}/collection.baked.xhtml`

## Create a baked pdf for a new book

There are currently two ways to create a baked PDF. One way is with the `docker-compose` commands listed below, the other is with bakery-cli (documentation linked at the top of this README).

1. Run `docker-compose run --rm -e HOST=katalyst01.cnx.org fetch-book --with-resources intro-business` to download the cnxml from the server.
   - **Note:** To see the list of books available see `./books.txt`
   - `HOST` is optional if one is specified in `./books.txt`
   - `--with-resources` is optional if you do not need images in the content to be fetched
1. Run `docker-compose run --rm assemble-book intro-business` to create the single-file HTML for the book.
   - Exercises are fetched when assembling the book. If the book has exercises that are being fetched from the exercises db, it can take 20+ minutes when first assembling a book. After the first time, it should not take as long
1. Run `docker-compose run --rm bake-book intro-business` to convert the single-file HTML locally into the "baked" book.
1. Run `docker-compose run --rm mathify-book intro-business` to convert all the math to svg.
1. Run `docker-compose run --rm build-pdf intro-business` to create the pdf.

A few things to note when using bakery-cli vs the commands above: 

- The bakery-cli more closely matches what is being used on production via COPS
- The bakery-cli commands will on average run a faster
- When using the bakery-cli, the style file linked in the xhtml is not a path to your local file system. This means that everytime you need to update a style during development, you must either re-bake the file and run the subsequent steps in the process depending on your needed output (baked file, mathified file, or PDF) or manually update the style link in the head of the document. 
- When using bakery-cli you cannot bake without passing it a style file or build a PDF without mathifying 

## Create JSON files for a book

Follow the first few steps above, up to and including the `bake-book` step. Then do the following:

1. Run `docker-compose run --rm disassemble-book intro-business` to split the baked HTML file into mutiple files.
1. Run `docker-compose run --rm jsonify-book intro-business` to create JSON files for each Baked Page.


## Run scripts
You can run commands in Docker:

`docker-compose run --rm command ...`

To run something like:

`./script/build-styles`

just prepend with ./script/run:

`./script/run ./script/build-styles`

or to run tests, run:

`./script/run ./script/test`

## Updating Neb

**Stops and removes container:**
`docker-compose down`

**To pull the latest version of neb:**
`docker-compose pull neb`

**To build the docker image with the latest:**
`docker-compose build neb`

**To check the version of neb:**
`docker-compose run neb neb --version`

## Add a New Book to the books.text config

The steps to add a new book (like `dark-matter-for-dummies`) are:

1. Find the UUID of the book you want
   - point your browser to the server containing the book (ie `cnx.org`) and find a book you want.
   - click "More Information" and copy the **ID**
1. add an entry to `./books.txt`


# Test

1. run `./script/test`

This will run the linter, generate sassdocs, and generate the guides to verify they work.

# Documentation

Recipe documentation can be found at [./recipes/](./recipes/) and an [example config file](./recipes/books/_example/).

1. run `./script/build-docs` to generate the SASS Docs
1. run `./script/build-guide statistics` to generate the HTML Guide for a book
1. open the generated file in your browser

## CSS Coverage

1. run `./script/fetch-html ${book_name}` to fetch the Raw HTML for a book
1. run `./script/bake-book ${book_name}`
1. The HTML Report should now be available at `./coverage/`

You can pass 3 arguments to `report-book-coverage` to change how it reports coverage:

- `--verbose` : outputs verbose/debugging output
- `--ignore-source-map` : covers the CSS even if a sourceMappingURL exists.
- `--cover-declarations` : generates coverage based on the declarations, as well as the selector
- **Note:** You can run `./script/report-book-coverage --all` to generate coverage using all the books

For more details on the commandline options see the [css-coverage](https://www.npmjs.com/package/css-coverage#commandline-options) documentation.


### Why CSS Coverage?

Code coverage is a great way to see if your tests exercises all the features of the codebase.

In the case of this repositoriy, the "codebase" contains all the CSS recipe files and the "tests" are the HTML snippets used to create a style guide.

By checking the code coverage, whenever a new feature in a book is added, a corresponding example in the HTML guide should be added as well (code coverage will complain otherwise).


## Bake Remotely

To rebake a book on a development instance.
To do that, you will need to upload a CSS recipe file, trigger a rebake, and then clear the cache.

1. run `./script/build-recipes` to generate the recipes CSS file
1. run `./script/bake-book-remote ${BOOK_NAME} ${VERSION}` to upload, trigger, and clear the cache

   - `${BOOK_NAME]` is the book’s name in the book list of `/books.txt`
   - `${VERSION]` is the `@#.##` in the target collection URL

### Example

For example, you want to rebake the "cooking" book:

1. you can run `./script/bake-book-remote cooking` and it will tell you to go to `http://foo.cnx.org/contents/${UUID}`
1. find the version (ie `7.16`) by looking at the URL or by clicking “More Information” at the bottom of the page
1. run `./script/bake-book-remote cooking 7.16` (using that version you found)


## Regression Testing

To check that there were no regressions in a book you will need to do the following:

1. bake the book with the old code
1. bake the book with the new code
1. compare the 2 baked HTML files to see if there were any differences

Here are the steps to run it:

```sh
# Prep work (run once)
./script/setup
./script/fetch-html statistics # Or any book in ./books.txt

# Check out the old version from git (ie `master` branch)
# Then run:
./script/diff-book-prepare statistics

# Check out the new code from git (ie `shiny-unincorns` branch)
# Then run:
./script/diff-book statistics

# Any differences would pop up at this point

# Optional: Create a diff and give it to a GUI
diff ./data/statistics-prepared.xhtml ./data/statistics/collection.baked.xhtml > foo.diff
```

**Note:** You can specify `--all` instead of `statistics` to diff all the books (after fetching them earlier)

### Finding differences in the styleguide

Instead of diffing the whole book, you can find differences in the styleguide for a recipe (faster and easier to find errors because the HTML files are much smaller than an entire book).

To do this, just replace every occurrence of `./script/diff-book ${BOOK_NAME}` (and `./script/diff-book-prepare`) with `diff-guide ${RECIPE_NAME}` in the instructions above.


## JavaScript Package

This package provides a few methods for use by other packages:

- `getBookStyles(): Map<string, string>`: returns a `Map` of the CSS contents for each book style

## Experimental

To update the Documentation in the gh-pages branch:

1. `git checkout master`
1. `./script/build-and-update-gh-pages`

**Note:** This will push changes if successful


[codecov-image]: https://img.shields.io/codecov/c/github/connexions/cnx-recipes.svg
[codecov-url]: https://codecov.io/gh/Connexions/cnx-recipes
