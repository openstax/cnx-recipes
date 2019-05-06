# Using the BakedStyles framework

## Beginning a design
Let's assume we have an html document in the following form:
```html
<html>
<body>
  <div class="book">
    <div class="chapter">
      <div class="page">
        <div class="title">Lorem Ipsum</div>
        Lorem ipsum...
        <div class="note type-one">
          <div class="title">Lorem Ipsum One</div>
          Lorem ipsum...
        </div>
        <div class="note type-two">
          <div class="title">Lorem Ipsum Two</div>
          Lorem ipsum...
        </div>
        <div class="note type-three">
          <div class="title">Lorem Ipsum Three</div>
          Lorem ipsum...
        </div>
        <div class="note type-four">
          <div class="title">Lorem Ipsum Four</div>
          Lorem ipsum...
        </div>
        <div class="note type-five">
          Lorem ipsum...
        </div>
      </div>
    </div>
  </div>
</body>
</html>
```

### Process

Suppose we would like notes of `type-one` to be given an outlined grey box and a bold title, notes of `type-two` to be given an outlined green box, notes of `type-three` to be given a blue header and dark grey background and white text, and notes of `type-four` to match notes of `type-three`. Lastly, notes of `type-five` will be given an outlined red box.

Let's make a couple observations about the proposed designs above. First, it would seem that notes of `type-one` and `type-two` follow the same html schema and have a similar design, but there needs to be a customization option for the box color and font weight. `type-three` and `type-four` are identical. `type-five` would initially seem to be the same as `type-one` or `type-two`, but we can notice that the schema for `type-five` does not include a title, so using the same design space for these two notes would be overengineering for a note of `type-five` as well as decrease coverage, since a `.type-five > title` selector would miss.

Following from the above, let's plan to make three superspaces. First, one to accomodate notes `type-one` and `type-two`. Second, one to accomodate notes `type-three` and `type-four`. Last, one to accomodate only `type-five`. We will do our best to reuse common components where possible.

Let's get started on the desgin. Enter the cnx-recipes directory, then make an SCSS file for our design
```bash
# bash
mkdir -p ./styles/design/example && touch ./styles/design/example/_design.scss
```

### Schema

The schema for a superspace map is as follows:
```
Superspace -> Map (
  _groups(Optional) -> Map ( String -> ValueSet | String ),
  _components -> List ( ...Component )
  )
)
```
with the schema for a Component being:
```
Component -> Map (
  _name -> String,
  _subselector -> String,
  _properties -> Map ( String -> ValueSet | String ),
  _components(Optional) -> List ( ...Component )
)
```

### Property Values

There are four main options for the values for properties in a superspace, 3 of which are represented in the `ValueSet` enum: `NULLABLE`, `NOT_NULL`, and `GROUPED`. The last option is to set the property to a specific value. Let's explain these options:

`NULLABLE` - Pick this option when it is an option for this property to not be used and you would like the value to be defined by the style author. For example, in notes `type-one` and `type-two`, the font weight can either be set to bold in `type-one` or not used (i.e. null) for `type-two`.

`NOT_NULL` - Pick this option when the property must be present, but also must be determined by the style author. For example, we know that notes `type-one`, `type-two`, and `type-five` are outlined the same way, but with a different color. Thus the color property must be present, but it is up to the style author as to what the color should be.

`GROUPED` - Pick this option if it is desired for properties to share the same values. The `_groups` key of the superset can define a key and value, the key of which is the name for the group, and the value of which is the shared property value. For example, if we were to define our note border colors seperately for some reason, we could group border-left|right|top|bottom-color together to `(enum('ValueSet:::GROUPED'), note-box-color)` and in `_groups` we add the entry `note-box-color: enum('ValueSet:::NOT_NULL')`

### Writing the superspaces

Open the file we just created in your favorite editor to get started writing our design superspaces. We will write our components to variables to that they can be reused.
```scss
// _design.scss
$boxed_note_container: (
  _name: 'container',
  _subselector: '.note',
  _properties: (
    border-color: enum('ValueSet:::NOT_NULL'),
    border-style: solid
  )
);
$boxed_note_title: (
  _name: 'title',
  _subselector: ' > .title',
  _properties: (
    font-weight: enum('ValueSet:::NULLABLE')
  )
);
$bg_note_container: (
  _name: 'container',
  _subselector: '.note',
  _properties: (
    color: (enum('ValueSet:::NULLABLE'), white),
    background-color: enum('ValueSet:::NOT_NULL')
  )
);
$bg_note_title: (
  _name: 'title',
  _subselector: ' > .title',
  _properties: (
    color: (enum('ValueSet:::NULLABLE'), white),
    background-color: (enum('ValueSet:::NULLABLE'), blue)
  )
);
```

Next, let's create superspaces from these components using the framework provided mixin `create_superspace`.

```scss
// _design.scss

// ...variables above

// type-one, type-two
@include create_superspace('BoxedNoteTitled', (
  _components: (
    map-merge($boxed_note_container, (
      _components: (
        $boxed_note_title
      )
    ))
  )
));

// type-three, type-four
@include create_superspace('BgNote', (
  _components: (
    map-merge($bg_note_container, (
      _components: (
        $bg_note_title
      )
    ))
  )
));

// type-five
@include create_superspace('BoxedNote', (
  _components: (
    $boxed_note_container
  )
));

// For the page title, a simpler superspace with a default
@include create_superspace('PageTitle', (
  _components: (
    _name: 'container',
    _subselector: ' > .title',
    _properties: (
      font-size: (enum('ValueSet:::NULLABLE'), 2em)
    )
  )
));
```

That's it! We've now created a basic design to style the given HTML markup!

## Writing a style
This framework is set up so that style authors can use the SCSS compiler to help guide them through building a style. Keep that in mind when authoring.

Start by entering the cnx-recipes directory. Make a book.scss file for the book you would like a style for. Let's call this accounting as an example.
```bash
# bash
mkdir -p ./styles/books/accounting && touch ./styles/books/accounting/book.scss
```

In the blank book.scss file, let's import our framework and the design we have just created.
```scss
// book.scss
@import 'framework/framework';
@import 'design/example/design';
```

Let's try to build our new book.scss. If there is an entry added to books.txt for your book style you can use
```bash
# bash
./script/build-styles # This with output css in the ./styles/output directory
```
otherwise, you can call the build script directly whilst specifying a platform
```bash
# bash
PLATFORM=pdf node ./styles/build/build.js ./styles/books/accounting/book.scss # This will output css to stdout
```

Importing only the framework should have yielded an empty stylesheet.
Let's move on to implmenting our designs in our book. We do this by calling the framework provided mixin `use`. `use` takes two arguments. The first is an identifer for the authors use (i.e. it can be anything you want), and the second is the name of a defined superspace or subspace in the a design.

```scss
// book.scss

// ...imports above

@include use('TypeOne', 'BoxedNoteTitled');
@include use('TypeTwo', 'BoxedNoteTitled');
@include use('TypeThreeFour', 'BgNote'); // Types three and four are EXACTLY the same, so we can have one `use` for both
@include use('TypeFive', 'BoxedNote');
@include use('PageTitleImpl', 'PageTitle');
```

Now that we've specified what designs we would like to use, let's try to build and see what happens.

```bash
PLATFORM=pdf node ./styles/build/build.js ./styles/books/accounting/book.scss
# => Error: Error [ENUM__Error:::INDEX_ERROR]: Unknown setting `TypeOne:::_selectors`.
```

We got an error. The framework has told us we need to specify selectors in our settings. This is a good opportunity to go over how settings work.

### Settings

To add settings, we can call the framework provided mixin `add_settings`. `add_settings` takes a variable number of arguments, but each must be a map of settings. Let's call the `add_settings` mixin to resolve the compiler error we received earlier.

```scss
// book.scss

// ...imports above

@include add_settings((
  'TypeOne:::_selectors': (
    ".page > .type-one"
  )
));

// ...uses below
```

This is sufficient to remove the previous error, but now we get a new one:
```bash
PLATFORM=pdf node ./styles/build/build.js ./styles/books/accounting/book.scss
# => Error: Error [ENUM__Error:::INDEX_ERROR]: Unknown setting `TypeOne:::container:::border-color`.
```

Let's resolve it the same way, by adding to our settings.
```scss
// book.scss

// ...imports above

@include add_settings((
  'TypeOne:::_selectors': (
    ".page > .type-one"
  ),
  'TypeOne:::container:::border-color': grey,
));

// Or alternatively, using nested syntax for settings:
@include add_settings((
  TypeOne: (
    _selectors: (".page > .type-one"),
    'container:::border-color': grey,
  )
));
// Anytime you have a namespace indicator `:::` in your settings file, you can choose to use the nested syntax instead.

// ...uses below
```

This is sufficient to remove the previous error, but a new one arises again. Let's skip ahead to the point where we have resolved each error after a series of failed compilations to the point where we get a successful one. The final result should be:
```scss
// book.scss

// ...imports above

@include add_settings((
  TypeOne: (
    _selectors: (".page > .type-one"),
    container: (
      border-color: grey,
    )
  ),
  TypeTwo: (
    _selectors: (".page > .type-two"),
    container: (
      border-color: green,
    )
  ),
  TypeThreeFour: (
    _selectors: (".page > .type-three", ".page > .type-four"),
    container: (
      background-color: darkgrey,
    ),
    title: (
      background-color: blue,
    )
  ),
  TypeFive: (
    _selectors: (".page > .type-five"),
    container: (
      border-color: red,
    )
  ),
  PageTitleImpl: (
    _selectors: (".page"),
  )
));

// ...uses below
```

### Finishing up

The preceding book file will yield some CSS, but we aren't yet finished. We have to handle the values which we deemed NULLABLE, such as the font weight for our type-one notes. This means to finish our styles, we must add the following to our settings:
```
// somewhere in settings
'TypeOne:::title': (font-weight: bold)
```

After we add this, we have successfully completed our design-driven book style! Link the compiled CSS to the markup and view the result!

![image of completed style in the browser](framework-tutorial.png)
