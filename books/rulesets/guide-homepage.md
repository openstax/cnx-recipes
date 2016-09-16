# Output HTML conventions

The purpose of this part is to document and centralize the output HTML decisions and conventions. These are the cooked formats that are delivered to the cnx.org website, the PDF generation system, and external consumers like TEA.

- Use `data-*` whenever possible. This applies to anything we use internally.
- Classes are used when several attributes are needed on one element: `class="eoc practice-container"` `data-type="composite-page"`.
- No numbering or titling should be accomplished via display css, it needs to be present in the unstyled cooked HTML
- All book specific strings are handled via the ruleset, this includes titles for notes/features and “generic” strings like “Chapter” or “Figure”. Instead of using labels in the content, we create all the titles via the ruleset, this provides one location to look for errors if titles are incorrect and prevents localised error when creating content. This is needed for internationalization. The ruleset handles them via variables, none of those should be hard coded.
- Prefix classes that are created in the ruleset and preserve the classes in the Raw HTML intact.
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
