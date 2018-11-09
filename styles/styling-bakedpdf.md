# Baked-PDF Styles Framework guide
<!--
- Any place that a filename is mentioned, make sure it links to the actual file.
- This will prob be a long file, so make a table of contents.
- 
 -->

## Overview
A general understanding of SASS is required to use this framework. [Official Sass Documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html)
One of the goals of the baked-pdf styling framework is to give the user of the framework the ability generate a styled baked-pdf from the framework and and theme levels without applying book specific designs.

**Note:** Files named with a leading `_` are not compiled by the SASS compiler, and are imported in another file. This allows us to have control over the compiling order of our files.

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
A book without
In ./book

#### Framework
If styling a baked-pdf was compared to the construction of a home, the `./framework` would be the steel and wooden beams. It is necessary component, and you cannot style a baked-pdf without it.

The code in `./framework` should not have to be changed during the development of a book, as it is the basis of baked-pdf styling, and changes to `./framework` will affect *all* previously styled books in the baked-pdf library.

`./framework/config`


`./framework/_import-config.scss`
  Contains imported files from ./framework/config.
`./framework/_import-mixins.scss`
  Contains imported files from ./framework/mixins
`./framework/_update-config.scss`
  Contains `@include`s of the update-config functions. (See the file for an explanation of the function)
`./framework/base.scss`
  Contains imports and styles related to the elements present in all OpenStax PDFs (ex: default `color` and `font-size` of body text)
`./framework/import-style.scss`
  Contains imported files from ./framework/style


##### Settings

##### Maps
Mapping is a native functionality of SASS and is used heavily in the baked-pdf styling framework. For general documentation on mapping in SASS refer to this [link](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#maps).

###### Color Schemes and Maps (How do they work?)
**Color Schemes**
- `./framework/config/_color-scheme.scss`
Hexs and other raw color values are stored in the `$DEFAULT_COLOR_SCHEME`. This map is returned in `default-color-scheme()`

- `default-color-scheme()`is the assigned to `$color-scheme` and is made the `!default`

- `update-color-scheme-config()`

**Color Maps**
The `$DEFAULT_COLOR_MAP` map is located `./framework/config/_color-map.scss`. The map is contained in a function named `default-color-map`, and the function returns `$DEFAULT_COLOR_MAP`.

The `default-color-map()` is then assigned to `$color-map` and made the `!default`.

Using `!default` after assigning a value to a variable means that if the variable hasn't already been assigned to a value, the variable will take the suggested value. If the variable does already have a value, it will not take the suggested value. This helps to prevent overwriting important variables.



###### Font Maps

###### Icon Maps




#### Themes
#### Books




#### Config Folder

## Directory Explanations
### `.books`




-------

The baked-pdf framework is built in three layers. The outermost layer is `./framework`, the middle layer is `./theme` and the final/bottom layer is `./books`.

Framework

Theme

Books
Data for each individual book is created in this directory.
