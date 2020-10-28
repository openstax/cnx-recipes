### Easybake: Structured Text Manipulation via CSS Extensions
(Taken from cnx-easybake repo)



###  CSS3 Syntax for Collation and Numbering - OpenStax easybake

## Moving and copying nodes:

Implement parts of the CSS-generated-content spec. Four declarations and
two content functions:  

    move-to: <bucketname>  
    copy-to: <bucketname>  
    string-set: <stringname> "my string" attr(<attrname>) content()  
    node-set: <setname>

    content: pending(<bucketname>)  string(<stringname>)  nodes(<setname>) clear(<bucketname>)


Declarations `move-to` and `copy-to`  will "mark" the  matching node (and all
of its descendants) for moving or copying to the place identified by the
`bucketname`. The two `-set` declarations, `string-set` and `node-set`, serve
to make a reusable copy of their value. The `node-set` will copy the current node,
while `string-set` assigns a concatenation of all its arguments to the first,
stringname.

The CSS function `pending()` is valid as the value of a `content:` declaration,
esp. inside a pseudo-element (`::after` or `::before`). When this node is
reached when walking the HTML tree in recursive descent, the pending moves and
copies land here. `string(<stringname>)` and `nodes(<setname>)` retrieve  values
stored by `string-set` and `node-set`, respectively. `attr(<attrname>)` evaluates
to the value of an attribute on the current node, while content() (in a string-set)
expands to the textual value of the node contents. In other contexts, it expands
to the node's current content.

As an extension, since we are targeting output of HTML, rather than another
rendering tree (page or screen display), we will create an actual wrapper node
for each pseudo-element area. This wrapper node is created whenever an included
`content` declaration resolves to non-empty content, or if the ruleset contains no `content` declaration at all. In support of this, we are adding additional
declarations, and two new pseudo-element selectors:  

    container: div|span|h1|...  
    class: myclassvalue  
    data-type: mydatatypevalue
    attr-my-new-attr: mynewattibutevalue

    sort-by: dl>dt::attr(sortby), nocase
    group-by: span, span::first-letter(mylabel), nocase

    pass: 2

The class declaration will set the value of that attribute on the generated
wrapper node. The data-*  and attr-* allows for setting any data or other
arbitrary attributes on the wrapper. Note that the `attr-*` declaration strips
 the `attr-` prefix, so that the example above would create an attibute named `my-new-attr`. The `container` declaration will make the wrapper a node of whatever type you specify, rather than the default of `div`.

Note that `move-to:` and `copy-to:` may be used as part of a pseudo-element
rule as well. In that case, the wrapping node and its content will be moved or
copied to the declared bucketname, as well. This would allow generation of, for
example, a title string, in the context of one node, using local values of
counters or content, but moving that generated node inside a different node
elsewhere. The value of this over string-set is that it generates a structured node set, rather than being constrained to a string.

The `copy-to` declaration will modify any 'id' values in the nodes it copies,
to keep them unique within the HTML document tree as a whole. FIXME add details
of heuristic used to make them unique.

The `sort-by` and `group-by` declarations take comma separated arguments. The `sort-by` declaration takes one CSS selector and an optional flag argument, while
'group-by' takes two selectors, and the optional flags. These directives apply to nodes moved (or copied) into the current context's `content` declaration that match the sort/group selector - _i.e._ anything brought in via `pending()` or `nodes()` that matches the selector. The value used in the sort or grouping comparisons is the text at the node selected by applying the CSS selector to the pending nodes. This includes text of child nodes. For example, the selector `span` applied to the node `<span data-type="term">velocity</span>` resolves to the string `velocity`.
Applying the same to `<span><em>𝛾</em>-radiation</span>` resolves to `𝛾-radiation`. If the flag `nocase` is provided, these comparisons are case-insensitive. If the selector does not match the node being added, the node will be appended at that point.

There are also pseudo-element selectors that can be used in this context:
`::first-letter`, `::attr(name)`, and `::first-letter(name)`. The first two of
these are not custom to us. The first will select the first character
of the text as described above. The next returns the value of the
named attribute at the selected node, _i.e._, given `<dt
sort-by="alpha-helix"><em>𝛼</em>-helix</dt>` the selector `dl >
dt::attr(sort-by)` would yield `alpha-helix`, rather than `𝛼-helix`. The last
pseudo-element, `::first-letter(name)` applies the first character logic to
the retrieved attribute value.

The `group-by` declaration is the most complex as well as the least general of all our extensions, designed to
meet the needs of constructing glossaries and indexes. This declaration takes one
or two CSS selectors. The first selector works just like `sort-by` in terms of ordering. The difference is that if two nodes have the same `group-by` value, we assume that they contain the same first-child node, and combine the two nodes by discarding the first child of the second node, then appending any further children to the first node. For example, this allows us to build index entries by passing in index-term link pairs, like so:

    <div class="index-item">  
      <span class="term">velocity</span>
      <a href="#idterm34">page 5</a>
    </div>
    <div class="index-item">
      <span class="term">velocity</span>
      <a href="#idterm66">page 7</a>
    </div>
Applying `group-by: span` yields:

    <div class="index-item">
      <span class="term">velocity</span>
      <a href="#idterm34">page 5</a>
      <a href="#idterm66">page 7</a>
    </div>

Note that `group-by` also takes a second, optional selector. This selector is
used to create labeled subgroups. All terms that evaluate to equal when this
selector is applied will be group under a <div> that starts with a <span> that
contains that value. Again, an example:

Applying `group-by: span, span::first-letter` results in:

    <div class="group-by">
      <span class="group-label">v</span>
      <div class="index-item">
        <span class="term">velocity</span>
        <a href="#idterm34">page 5</a>
        <a href="#idterm66">page 7</a>
      </div>
    </div>

Note that the `nocase` flag can be used with group-by as well, and affects both
sorting/grouping behavior and subgrouping. An current side effect of the current implementation of `nocase` for subgroups is that the generated labels will be up-cased.

## Multi-Pass

The last new declaration is `pass`. All this moving and copying leads eventually to a new HTML tree. Sometimes, you want to do things on the new tree, for example number sections that where created by copying. By specifying a `pass` to operate on, any ruleset can access this modified tree. The `pass:` declaration takes a list of comma separated arguments that define the passes this ruleset will apply to. No `pass:` declaration is equivalent to the `default` pass, which always runs first. Other passes may be either string names or integer numbers. If only integer numbers are used, then the additional passes will run in numeric order, _i.e._ 1, 2, 3 ... 10. If string labels are used, they will run in lexicographical order: i.e. 'alpha', 'my-step', 'other-step'. Note that the default pass is special, and not considered in this logic, so a declaration like: `pass: default, 10, 3` will match three passes, and execute them in the order `default`, then `3`, then `10`, since all the _additional_ passnames are numeric.

For example, this ruleset:

    div[data-type="page"]::before,
    div[data-type="composite-page"]::before {
        pass: second;
        counter-increment: page;
        container: h1;
        content: "Chapter " counter(page);
    }

Will generate `h1` first children for both `page` and `composite-page` divs. Presumably
`composite-page`s are added to the tree in an earlier step. Without the `pass:` declaration, the `composite-page`s would not be numbered, since they are not in the tree to match the rule.

In addition, variables that have accumulated during a CSS pass are accessible from
successive passes. These are `string`, `counter`, and `pending`/`nodeset` buckets.
If a ruleset references one of these names that has not been set in the current pass, the value from a previous pass will be used. This is particularly useful for summary information that should appear at the beginning of a document, like a table of contents, or list of figures. These may be built up is a bucket using `copy-to` and other commands in an early pass, then placed near the top of the document with `pending()` in a subsequent pass.
