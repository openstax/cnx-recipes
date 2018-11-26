# Baked-PDF Styles Framework guide
<!--
- Any place that a filename is mentioned, make sure it links to the actual file.
- This will prob be a long file, so make a table of contents.
- Write error messages for all functions and mixins
 -->

## Overview
A general understanding of SASS is required to use this framework. [Official Sass Documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html)
One of the goals of the baked-pdf styling framework is to give the user of the framework the ability generate a styled baked-pdf from the framework and and theme levels without applying book specific designs.

**Note:** Files named with a leading `_` are not compiled by the SASS compiler, and are imported in another file. This allows us to have control over the compiling order of our files.

**Note:** If you don’t want Sass to use caching, set the :cache option to false

**Note:** Raw values should not be placed into files that are not `_settings.scss` or `-scheme.scss`.

## Development

### Generating a Styled Baked-PDF Locally
**Step 1**
To generate a styled baked-pdf for a new or previously un-styled baked-book (skip to step 2 if these files exists):
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
**Assigning Color Values**
- To assign a color to an element, use the `color-scheme` function. Example: `color-scheme(key)`. When `color-scheme(key)` is used, this is what is happening 'behind the scenes':
- The function `color-scheme` first uses the key passed into it to check if the `$color-scheme` map has that key.
- Once it confirms that it does exist, it calls the `map-get` function and returns that value of the key passed into the function.

**Color Schemes**
- The default color scheme can be found in `./framework/config/_color-scheme.scss`.
- Hexs and other raw color values are stored in the `_color-scheme.scss` files and can be created at the theme and book level.

When including `color-scheme-merge`, this is what is happening in the background (also applicable to `color-map-merge`):
1. The `color-scheme-merge` appends the passed function to the `$color-scheme-manifest` map
2. The `update-color-scheme-config` is then called
3. The `!global` flag is then attached to `default-color-scheme()` so that all values merged into the `$color-scheme-manifest` map will be accessible globally. (When the sass is compiled for an individual book, the manifest will update each time `color-scheme-merge` is called.)
4. Each new key/value pair that was appended to the `$color-scheme-manifest` is now merged into a new map with the old key/value pairs previously in the `$color-scheme-manifest`. The new values take precedence over the old values.
<!-- todo: explain why the `update-color-scheme-config()` mixin is necessary -->
<!-- This is needed because we need the FUNCTIONS to re-evaluate each time a merge happens -->

**Color Maps**
<!-- todo: what is the scale-uniform function for -->
Raw color values are stored in a map in the color-scheme and those values are called in the color-map and assigned to more descriptive names based on what they're used for.
Like color schemes, color maps exist on the framework level and can be created on the theme and book level.


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
