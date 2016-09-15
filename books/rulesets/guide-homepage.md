# Output HTML conventions

The purpose of this part is to document and centralize the output HTML decisions and conventions. These are the cooked formats that are delivered to the cnx.org website, the PDF generation system, and external consumers like TEA.

- Use `data-*` whenever possible. This applies to anything we use internally.
- Classes are used when several attributes are needed on one element: `class="eoc practice-container"` `data-type="composite-page"`.
- No numbering or titling should be accomplished via display css, it needs to be present in the unstyled cooked HTML
- All book specific strings are handled via the ruleset, this includes titles for notes/features and “generic” strings like “Chapter” or “Figure”. Instead of using labels in the content, we create all the titles via the ruleset, this provides one location to look for errors if titles are incorrect and prevents localised error when creating content. This is needed for internationalization. The ruleset handles them via variables, none of those should be hard coded.
- Address the risk of CSS input by author interacting with our base CSS. `data-*` vs `.class`. Need for class prefix? `.cnx-eoc `
    **Questions:** how do we handle our internal markup
    - Existing: the tagging legend for a given book would be .critical-thinking but the actual style class would be prefixed, is that desirable?
    - Future: we can craft content with prefixed class
- If it’s not needed for styling, it shouldn’t be in the dom.
- If it’s empty, it should not be included in the HTML

``` html
<title>
  <span class=”divider”></span>
  <span class=”title-text”>My title</span>
</title>
```

should be

```html
<title>
  <span class=”title-text”>My title</span>
</title>
```
