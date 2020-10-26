# Baked-PDF Styles Framework guide

## Overview
A general understanding of SASS is required to use this framework [Official Sass Documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html).
The framework is built on 3 levels, the framework, designs, and books.


**Note:** Files named with a leading `_` do not produce any CSS output during compilation, they are imported in another file. This allows us to have control over the compiling order of our files.

## Definitions
- Design Specs (Specifications): a visual design requirement given a markup structure 
- Design: a named collection of components and shapes historically grouped together by the content genre of textbook. Sometimes used interchanably in conversation with `template or theme` 
  - For example the carnival design/theme is mostly used for science titles. The corn theme is mostly used in math titles.  
- Component: singular book element constructed with a SASS map. The output of which is a CSS selector, properties, and values.
- Settings: where we define component values that have not been previously defined in the componenet definition
- Shape: a collection of componenets merged together into one SASS map. The output of which is a nested CSS selector with CSS properties and values.


## Styles directory organization 
```bash
    |-- `./books`
          |-- `/anatomy` 
              |-- `book.scss` 
    |-- `./build`
          |-- `./build.js`
    |-- `./design-settings`
    |-- `./designs`
          |-- `/cardboard`
          |-- `settings.scss`
          |-- `color-map.scss`
    |-- `./framework`
          |-- `book-name.scss`
    |-- `./output`
    |-- `./test`

```
- `./books` contains book specific styles. The directories inside are named to correspond with a recipe. Each book directry contains a book configuration file used to define book specific styles and import all necessary componenets for generation. 
- `./build` contains build script used to compile SASS to CSS using node-sass. 
- `./design-settings` contains css values for properties defined as optional and required in components
- `./designs` contains directories named for each design in our library. Each named design directory contains the components and shapes, images, and other PDF specific styles that make up the design. There is also a directory for common library wide PDF styles like bleeds page breaks. 
- `./Framework` contains global variables for values such as `$NOT_NULL` and various functions and mixins to use throughout `./styles`
- `./output` contains the `.css` and `.map` files generated from the `build.js` script
- `./test` contains .js scripts to generate code coverage and test code

## Development
### Generating a Styled Baked-PDF Locally

To generate a styled baked-pdf locally you need a .css file and an .xhtml/.html file

3 ways to generate the .css output: 

- `PLATFORM="pdf" node ./styles/build/build.js  styles/books/{book-name}/book.scss ./styles/output/{book-name}-pdf.css`

- `sass ./{book-name}/book.scss.scss ./output/{book-name}-pdf.css`

- `./script/run ./script/build-styles` (builds all book styles)

2 ways to generate the styled baked-pdf: 

- 


### Generating a Styled Baked-PDF via COPS 


Then run Prince on the XTML file with the PrinceXML command `prince --style ./output/{book-file}.css ./data/{book-name}/collection.baked.xhtml`

The output styled PDF will be located in the `./data` directory.

### Framework
If styling a baked-pdf was compared to the construction of a home, the `./framework` would be the steel and wooden beams. It is a necessary component, and you cannot style a baked-pdf without it.

The code in `./framework` should not have to be changed during the development of a book, as it is the basis of baked-pdf styling, and changes to `./framework` will affect **all** previously styled books in the baked-pdf library.


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
3. When the sass is compiled for an individual book, the manifest will update each time `color-scheme-merge` is called.
4. Each new key/value pair that was appended to the `$color-scheme-manifest` is now merged into a new map with the old key/value pairs previously in the `$color-scheme-manifest`. The new values take precedence over the old values.

**Color Maps**
Raw color values are stored in a map in the color-scheme and those values are called in the color-map and assigned to more descriptive names based on what they're used for.
Like color schemes, color maps exist on the framework level and can be created on the theme and book level.

The `scale-uniform` function decreases all values in an RGB by an equal proportion.
Example: `scale-uniform(rgb(100,100,100), 0.6)` -> `rgb(60,60,60)`

**Font and Icon Maps**
The font and icon maps on the framework level have a `default-font-map` function, `$font/icon-manifest` map, and `update-font/icon-config` mixin and works similarly to the color-scheme on the framework level.

**Settings**
Although `./_settings.scss` does not share the same naming conventions as the font and color map files, it works in the same way as them.

**Constants**
Contains functions that return book constants such as page width and height.