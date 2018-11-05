# Baked-PDF Styles Framework guide

## Overview
A general understanding of SASS is required to use this framework. [Official Sass Documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html)
One of the goals of the baked-pdf styling framework is to give the user of the framework the ability generate a styled baked-pdf from the framework and and theme levels without applying book specific designs.

## Development

### Generating a Styled Baked-PDF Locally
**Step 1**
To generate a styled baked-pdf for a new or previously un-styled baked-pdf (skip to step 2 if files exists):
- Create a directory with the book name in `./books`. `./books/book-name`
- Create `_import-config.scss` and `book-name.scss`
- Create `.book-name/config` and inside `./config` create `./config/_color-map.scss` , `./config/_color-scheme.scss`, `./config/_font-map.scss`, `./config/_icon-map.scss`, and `./config/_settings.scss`

**Step 2**
Run the sass command to compile the .scss book file to a .css file `sass ./book-file.scss ./output/book-file.css`

Take the path of the output .css book file and insert it into the head of the `./book-name-baked.xhtml`.

Then  run the PrinceXML command `prince /data/book-name-baked.xhtml`

The styled PDF will be located in the `./data` directory.

### Applying Book Specific Styles to a Baked-PDF
In ./book

#### Maps and Schemes


#### Config Folder

## Directory Explanations
### `.books`




-------

The baked-pdf framework is built in three layers. The outermost layer is `./framework`, the middle layer is `./theme` and the final/bottom layer is `./books`.

Framework

Theme

Books
Data for each individual book is created in this directory.
