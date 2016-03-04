# Drafting of the Single HTML format

## Structure

Recreate the `structure.html` file using:

```py
>>> import os
>>> import cnxepub
>>> cnxepub_dir = os.path.abspath(os.path.dirname(cnxepub.__file__))
>>> book_dir = os.path.join(cnxepub_dir, 'tests', 'data', 'book')
>>> epub = cnxepub.EPUB.from_file(book_dir)
>>> binder = cnxepub.adapt_package(epub[0])
>>> html = bytes(cnxepub.SingleHTMLFormatter(binder))
>>> with open('structure.html', 'w') as f:
...    f.write(html)
```


## Example: Algebra

Recreate the `algebra.html` file using:

```
ssh cte-cnx-dev.cnx.org /var/cnx/venvs/archive/bin/cnx-archive-export_epub /etc/cnx/archive/app.ini 9b08c294-057f-4201-9f48-5d6ad992740d@3.278 algebra.epub
scp cte-cnx-dev.cnx.org:~/algebra.epub .
cnx-epub-single_html algebra.epub > algebra.html
```

Note, we choose algebra, because it's about 1/5 the size of physics.
