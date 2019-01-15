# Baked-PDF Styles Framework guide

## Overview
A general understanding of SASS is required to use this framework [Official Sass Documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html).
The framework is modular, and is built on 3 levels, the framework, theme, and book level.
The baked-pdf styling framework was designed in a way so that the user of the framework has the ability easily generate a styled baked-pdf without applying book specific designs.

**Note:** Files named with a leading `_` are not compiled by the SASS compiler, and are imported in another file. This allows us to have control over the compiling order of our files.

**Note:** Avoid placing raw values into files that are not `_settings.scss`, `_scheme.scss`, or `_map.scss`.

## Development

### Generating a Styled Baked-PDF Locally
(*The Baked-PDF pipeline is currently being developed*)

**Step 1**
To generate a styled baked-pdf for a new or previously un-styled baked-book (skip to step 2 if these files exist):
- Create a directory with the book name in `./books`. `./books/book-name`
- Create `_import-config.scss` and `{book-name}.scss`
- Create `.book-name/config` and inside `./config` create `./config/_color-map.scss` , `./config/_color-scheme.scss`, `./config/_font-map.scss`, `./config/_icon-map.scss`, and `./config/_settings.scss`
- Inside of `./config/{book-name}.scss` import files from the framework and theme and create the `$notes` map to style the book notes. (See [./config/intro-business/book.scss](./config/intro-business/book.scss) for an example)

**Step 2**
Run the sass command to compile the .scss book file to a .css file `sass ./{book-file}.scss ./output/{book-file}.css`

Then run Prince on the XTML file with the PrinceXML command `prince --style ./output/{book-file}.css ./data/{book-name}-baked.xhtml`

The output styled PDF will be located in the `./data` directory.

### Framework
If styling a baked-pdf was compared to the construction of a home, the `./framework` would be the steel and wooden beams. It is a necessary component, and you cannot style a baked-pdf without it.

The code in `./framework` should not have to be changed during the development of a book, as it is the basis of baked-pdf styling, and changes to `./framework` will affect **all** previously styled books in the baked-pdf library.

- `./framework/config/`
    - `_color-map.scss`, `_color-scheme.scss`, `_constants.scss`, `_font-map.scss`, `_icon-map.scss`, `_settings.scss`
      - Explained in the 'Schemes and Maps (How do they work?)' section
- `./framework/_import-config.scss`
  - Contains imported files from ./framework/config.
- `./framework/_import-mixins.scss`
  - Contains imported files from ./framework/mixins
- `./framework/_update-config.scss`
  - Contains `@include`s of the update-config functions.
- `./framework/base.scss`
  - Contains imports and styles related to the elements present in all OpenStax PDFs (ex: default `color` and `font-size` of body text)
- `./framework/import-style.scss`
  - Contains imported files from ./framework/style


### Schemes and Maps (How do they work?)
Mapping is a native functionality of SASS and is used heavily in the baked-pdf styling framework. For general documentation on mapping in SASS refer to this [link](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#maps).

**Assigning Color Values**
- To assign a color to an element, use the `color-scheme` function. Example: `color-scheme(key)`. When `color-scheme(key)` is used, this is what is happening 'behind the scenes':
  * The function `color-scheme` first uses the key passed into it to check if the `$color-scheme` map has that key.
  * Once it confirms that it does exist, it calls the `map-get` function and returns that value of the key passed into the function.

**Color Schemes**
- The default color scheme can be found in [./framework/config/_color-scheme.scss](./framework/config/_color-scheme.scss).

- Hexs and other raw color values are stored in the `_color-scheme.scss` files and can be created at the theme and book level.

When including `color-scheme-merge`, this is what is happening in the background (also applicable to `color-map-merge` and other `-merge` mixins):
1. The `color-scheme-merge` appends the passed function to the `$color-scheme-manifest` map
2. The `update-color-scheme-config` is then called
3. The `!global` flag is then attached to `default-color-scheme()` so that all values merged into the `$color-scheme-manifest` map will be accessible globally. (When the sass is compiled for an individual book, the manifest will update each time `color-scheme-merge` is called.)
4. Each new key/value pair that was appended to the `$color-scheme-manifest` is now merged into a new map with the old key/value pairs previously in the `$color-scheme-manifest`. The new values take precedence over the old values.

**Color Maps**
<!-- todo: what is the scale-uniform function for -->
Raw color values are stored in a map in the color-scheme and those values are called in the color-map and assigned to more descriptive names based on what they're used for.
Like color schemes, color maps exist on the framework level and can be created on the theme and book level.

**Font and Icon Maps**
The font and icon maps on the framework level have a `default-font-map` function, `$font/icon-manifest` map, and `update-font/icon-config` mixin and works similarly to the color-scheme on the framework level.


**Settings**
Although `./_settings.scss` does not share the same naming conventions as the font and color map files, it works in the same way as them.

**Constants**
Contains functions that return book constants such as page width and height.
