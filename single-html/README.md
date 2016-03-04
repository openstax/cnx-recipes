# Drafting of the Single HTML format

Recreate the `algebra.html` file using:

```
ssh cte-cnx-dev.cnx.org /var/cnx/venvs/archive/bin/cnx-archive-export_epub /etc/cnx/archive/app.ini 9b08c294-057f-4201-9f48-5d6ad992740d@3.278 algebra.epub
scp cte-cnx-dev.cnx.org:~/algebra.epub .
cnx-epub-single_html algebra.epub > algebra.html
```

Note, we choose algebra, because it's about 1/5 the size of physics.
