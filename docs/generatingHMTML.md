# Retrieving html from cte-cnx-dev.cnx.org

The full ID of a book can be found in the more information tab for each book
For example for http://cte-cnx-dev.cnx.org/contents/Ax2o07Ul@9.4:HR_VN3f7@3/Introduction-to-Science-and-th, the full ID is:
031da8d3-b525-429c-80cf-6c8ed997733a@9.4

###SSH to cte-cnx-dev.cnx.org and execute:
- create the epub:

````/var/cnx/venvs/publishing/bin/cnx-archive-export_epub /etc/cnx/publishing/app.ini [full_ID] ~/physics.internal.epub````

- create the single-html:

````/var/cnx/venvs/publishing/bin/cnx-epub-single_html [Book_Name].internal.epub > [Book_Name].html````


###Then, on your local machine execute:

````scp cte-cnx-dev.cnx.org:~/[Book_Name].html .````

