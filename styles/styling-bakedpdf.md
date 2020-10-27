# Baked-PDF Styles Framework guide

## Overview
A general understanding of SASS is required to use this framework: [Official Sass Documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html).
The framework is built on 3 levels, the framework, designs, and books.


**Note:** Files named with a leading `_` do not produce any CSS output during compilation, they are imported in another file. This allows us to have control over the compiling order of our files.

### Framework
If styling a baked-pdf was compared to the construction of a home, the `./framework` would be the steel and wooden beams. It is a necessary component, and you cannot style a baked-pdf without it.

The code in `./framework` should not have to be changed during the development of a book, as it is the basis of baked-pdf styling, and changes to `./framework` will affect **all** previously styled books in the baked-pdf library.

## Definitions
- Design Specs (Specifications): a visual design requirement given a markup structure 
- Design: a named collection of components, shapes, and settings historically grouped together by the content genre of textbook. Sometimes used interchanably in conversation with `template or theme` 
  - For example the carnival design/theme is mostly used for science titles. The corn theme is mostly used in math titles.  
- Component: singular book element constructed with a SASS map. The output of which is a CSS selector, properties, and values.
- Settings: where we define component values that have not been previously defined in the componenet definition
- Shape: a collection of componenets merged together into one SASS map. The output of which is a nested CSS selector with CSS properties and values.


## Styles directory organization: 

- `./books` contains book specific styles. The directories inside are named to correspond with a recipe. Each book directry contains a book configuration file used to define book specific styles and import all necessary componenets for generation. 
- `./build` contains build script used to compile SASS to CSS using node-sass. 
- `./design-settings` contains css values for properties defined as optional and required in design components
- `./designs` contains directories named for each design in our library. Each named design directory contains the components and shapes, images, and other PDF specific styles that make up the design. There is also a directory for common library wide PDF styles like bleeds page breaks. 
- `./Framework` contains global variables for values such as `$NOT_NULL` and various functions and mixins to use throughout `./styles` such as `create_shape`
- `./output` contains the `.css` and `.map` files generated from the `build.js` script
- `./test` contains .js scripts to generate code coverage and test code

### Generating Styles

To generate a styled baked-pdf locally you need a .css file and an baked .xhtml/.html file.

3 ways to generate the .css output: 

- `PLATFORM="pdf" node ./styles/build/build.js  styles/books/{book-name}/book.scss ./styles/output/{book-name}-pdf.css`

- `sass ./{book-name}/book.scss.scss ./output/{book-name}-pdf.css`

- `./script/run ./script/build-styles` (builds all book styles)

- `./script/run ./script/build-styles {book-name}` 

**note**: the {book-name} should match the directory name in the `./books` directory and the corresponding recipe