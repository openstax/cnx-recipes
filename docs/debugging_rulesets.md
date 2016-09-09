Some tips on how to debug (lessons learned):

1. Building Containers:

    If you need a wrapper, use a pseudo-element: ::before, ::after, or
    ::outside.  These are inserted either before the contents (including
    children) of the selected element (but still inside that element), after 
    the contents (still inside), or outside the selected element (wrapping it)

1. Off By One:

    If you have a string or node set that is "off by one": should be:
    chap 1 <stuff 1> chap 2 <stuff  2> ... etc.  but instead you have
    chap <stuff 1> chap 1 <stuff 2> .... Check the 'debug' output (-d)
    for WARNING: Blank string, or WARNING: empty bucket

    This means that the setting is happening _after_ the retrieval, though
    on the same pass. One way this can happen is setting a value using a selector
    that matches a child of the element that uses that value. For example,
    if you have a h1 inside a div that is the title of that div, and want to
    build a node to copy the title elsewhere (end of book list of some sort),
    if you select:

    div > h1:
        string-set: DivTitle contents()

    div::before:
      container: div
      contents: string(divTitle)
      move-to: DivTitleEOB

    .eob:
        content: "Chapter" pending(DivTitleEOB)

    This fails because the div::before happens before the child selector,
    div > h1.  This can be fixed by making the selector div::after, or
    div:deferred::before.

2. All The Same:

    If instead of nice repeating labels, like: chap 1 chap 2 chap 3, you
    end up with all the same label, matching the last item, like: chap 42,
    chap 42, chap 42, make sure that your setting and retrieving the value
    on the same pass. This behavior is diagnostic that the retrieval is on
    a later pass than the setting. Make sure they are on the same pass.


