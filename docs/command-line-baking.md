#SSH into the CTE server:
- `ssh <ldap_username>@cte-cnx-dev.cnx.org`

#Access the virtual environment:
- `cd books`   
  - If you do not already have this, create the directory with `mkdir books`.
  - Then `cd books`
- `virtualenv .`
- `. bin/activate`

#Set up your virtual environment using the following:
- `pip install git+https://github.com/Connexions/cssselect2.git`
- `pip install git+https://github.com/Connexions/rhaptos.cnxmlutils.git`
- `pip install git+https://github.com/Connexions/cnx-archive.git`
- `pip install git+https://github.com/Connexions/cnx-easybake.git`
- `pip install git+https://github.com/Connexions/cnx-epub.git`

#Access a directory for the book:
- `cd <book_title>`   
  - If you do not already have a directory for the book, create one with `mkdir <book_title>`.
  - Then `cd <book_title>`

#Get the book id for cnx-archive-export_epub:
- Open cte-cnx-dev.cnx.org
- Navigate to the book
- Expand "more info" tab at the bottom.
- Copy the id for use in the next step

#Generate an epub from archive: *this step takes 20min.*
- `cnx-archive-export_epub /etc/cnx/archive/app.ini <book_ID> <output_title.epub>`

#Convert epub to HTML + Mathjax:
- `cnx-epub-single_html  <input_book.epub> <output_title.html> -m`

#Get CSS rule-set - `wget https://raw.githubusercontent.com/Connexions/cte/master/books/rulesets/output/<book.css>`

#Bake the HTML and CSS:
- `cnx-easybake <input_style.css> <input_book.html> <output-cooked.html>`

#Download the baked HTML using FileZilla
- Open FileZilla
- Connect to cte-cnx-dev.cnx.org
- Access the directory of the cooked HTML
- Download the file from the remote location
