
Usage of cnx-recipes scripts
-----------------------------

**fetch-html**

This script is used to download a specified book from a specified server. It then combines all of the page HTML into a single HTML file for the book and saves the file. The details (UUID, Collection id, location, etc.) about the book are in the books.txt file.

 Parameters
 * Book name from books.txt file

Example usage
 * `./script/fetch-html intro-business`


**bake-book**

This script is used bake the HTML using the recipe in cnx-recipes for the book. The details (UUID, Collection id, location, etc.) about the book are in the books.txt file.

 Parameters
 * Book name from books.txt file
 *  -d to turn debugging on

Example usage
 * `./script/bake-book intro-business`

**build-recipes**

This script is used to compile the Sass files for the given book recipe into CSS. The details (UUID, Collection id, location, etc.) about the book are in the books.txt file.

 Parameters
 * Book name from books.txt file

Example usage
 * `./script/build-recipes intro-business`

**build-styles**

This script is used to compile the Sass files for the given book PDF style into CSS. The details (UUID, Collection id, location, etc.) about the book are in the books.txt file.

 Parameters
 * Book name from books.txt file

Example usage
 * `./script/build-styles intro-business`


Recipe Development Workflow
----------------------------

1. Fetch the data 
   * `./script/fetch-html intro-business`
2. Build the recipe
    *  `./script/build-recipes intro-business`
3. Open the raw HTML file (Book HTML file) 
   * `atom ./data/intro-business-raw.xhtml`
4. Add the style link to the \<head>` of the HTML
    * add <link rel="stylesheet" type="text/css"  href="../styles/output/intro-business.css" />`
5. Bake the HTML 
    * `./script/bake-book intro-business`
6. Test the baked results in the browser


PDF Style Development Workflow
------------------------------

**NOTE**: This workflow assumes the recipe workflow has been completed

1. Move the baked HTML file to the location of the book resources
    * `cp ./data/intro-business-baked.xhtml ./data/intro-business-baked/contents`
2.  Update path to the style CSS file in the baked HTML
3.  Build the styles
    * `./script/build-styles intro-business`
4.  Test the styles by viewing the baked HTML in the browser
5.  Convert the baked HTML and style into a PDF
    * `prince -s styles/output/intro-business.css ./data/intro-business-baked/contents/intro-business-baked.xhtml -o bakedEcon.pdf`
6. View the PDF to test the results.


Installation of Neb and cnx-recipes on Ubuntu
----------------------------------------------

**Install pyenv**
 * `sudo apt-get install build-essential git libreadline-dev zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev`
 * `curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash`

**Install libicu-dev** 
 * `sudo apt-get install libicu-dev`

**Install libxml2-utils**
 * `sudo apt-get install libxml2-utils`

**Install xsltproc**
 * `sudo apt-get install xsltproc`

**Install virtualenv**
 * `sudo pip install virtualenv`

**Install Neb**
 * `pip install nebuchadnezzar`

**Create git folder**
 * `mkdir git`

**Install git**
 * `sudo apt install git`

**cd to git folder**
 * `cd git`

**Clone cnx-recipes**
 * `git clone https://github.com/openstax/cnx-recipes.git`

**Install yarn**
 * `curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -`
 * `echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list`
* `sudo apt-get update && sudo apt-get install yarn`

**Install nvm**
* `sudo apt-get install npm`

**Install node 8.9.4**
 * It must be downloaded from the Node JS web site - https://nodejs.org/dist/v8.9.4/
 * Select the file for your environment
 * Unzip the tar ball into a directory
 * Create symlinks to node in the expected locations
   * `ln -sf <YOUR_FOLDER>/bin/node /usr/bin/node`
   * `ln -sf <YOUR_FOLDER>/bin/node /usr/bin/nodejs`
 * Test installation
   * `node -v`
        
**Checkout the correct branch of cnx-recipes**
 * `git checkout origin/baked-pdf-mathify`

**cd to cnx-recipes**
 * `cd cnx-recipes`

**Run setup**
 * `./script/setup`

**Run tests**
 * `./script/test`






