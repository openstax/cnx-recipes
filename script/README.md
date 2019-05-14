
Baked Output CLI Documentation
==============================

Setup
-----

1. If you're concerned about messing up your work directory, feel free to clone this in a different directory:

   ```
   git clone -b cli-master https://github.com/openstax/cnx-recipes.git cnx-recipes-cli
   cd cnx-recipes-cli
   ```

1. Install docker and docker-compose (docker-compose may already be bundled with docker):

   ```
   ./script/install-docker
   ```

   This should work for people using ubuntu and brew on Mac OS. For everyone else, you probably need to download docker here: https://www.docker.com/products/docker-desktop

   There is no need to run other setup scripts.

1. Remove any outdated docker images (this step only needs to be done once in a while when the code is stable):

   ```
   docker rmi openstax/cnx-recipes:latest openstax/ci-image:latest openstax/princexml:latest openstax/mathify:latest
   ```

   It is ok if this command returns `Error: No such image:`.

   1. Rebuild docker images (this step takes some time):

      ```
      docker-compose build fetch-book neb mathify pdf
      ```

---

CLI Usage
---------

1. Fetch a book:

   ```
   docker-compose run --rm fetch-book --with-resources intro-business
   ```

   This downloads the cnxml and resources for the book in `./data/intro-business/raw`.

   1. If you want to download from a specific host:

      ```
      docker-compose run --rm -e HOST=katalyst01.cnx.org fetch-book --with-resources intro-business
      ```

    2. To download all of the books in books.txt, use the --all flag. If a book in books.txt is not found, the process will fail:

        ```
        docker-compose run --rm fetch-book --all
        
        ```
    3. If downloading a single book, a short book name must be used as detailed in books.txt. An example is `intro-business` in the first example.

    4. The `--rm` flag is used to remove the docker container after the command has completed.


2. Generate the single html file for the book:

   ```
   docker-compose run --rm assemble-book intro-business
   ```

     The output is in `./data/intro-business/collection.assembled.xhtml`.

    1. To assemble all of the books in books.txt, use the --all flag. If a book in books.txt is not found, the process will fail:

        ```
        docker-compose run --rm assemble-book --all
        
        ```
    2. If assembling a single book, a short book name must be used as detailed in books.txt. An example is `intro-business` in the first example.

    3. The `--rm` flag is used to remove the docker container after the command has completed.

3. Bake the book:

   ```
   docker-compose run --rm bake-book intro-business
   ```

   This creates the baked html file in `./data/intro-business/collection.baked.xhtml`.  It automatically adds the style file `styles/output/<style-name>-pdf.css` to the html file.

   1. If you want to specify your own recipe and / or style css:

      ```
      docker-compose run --rm -e RECIPE=recipes/output/my-recipe.css -e STYLE=styles/output/my-style.css bake-book intro-business
      ``` 

    1. If you want to bake all of the books, use the --all flag. If a book in books.txt is not found, the process will fail:

        ```
        docker-compose run --rm bake-book --all
        ```
    2. For additional debugging information, use the -d flag
   
        ```
        docker-compose run --rm bake-book -d intro-business
        ```
    3. If baking a single book, a short book name must be used as detailed in books.txt. An example is `intro-business` in the first example.

    4. The `--rm` flag is used to remove the docker container after the command has completed.

4. (*Optional*) Transform the math in the book:

   ```
   docker-compose run --rm mathify-book intro-business
   ```

   This creates `./data/intro-business/collection.mathified.xhtml`.

   1. If you want to mathify all of the books, use the --all flag. If a book in books.txt is not found, the process will fail:

        ```
        docker-compose run --rm mathify-book --all
        ```

    2. If mathifying a single book, a short book name must be used as detailed in books.txt. An example is `intro-business` in the first example.

    3. The `--rm` flag is used to remove the docker container after the command has completed.
   
5. Create a pdf for the book:

   ```
   docker-compose run --rm build-pdf intro-business
   ```

   This creates `./data/intro-business/collection.pdf`.  It automatically pulls in the style file `styles/output/<style-name>-pdf.css` if it is defined in books.txt.

   1. If you want to pass in a different style css:

      ```
      docker-compose run --rm -e STYLE=recipes/output/my-style.css build-pdf intro-business
      ```
    2. If you want to generate pdfs for all of the books, use the --all flag. If a book in books.txt is not found, the process will fail:

        ```
        docker-compose run --rm build-pdf --all
        ```

    3. If generating a pdf for a single book, a short book name must be used as detailed in books.txt. An example is `intro-business` in the first example.

    4. The `--rm` flag is used to remove the docker container after the command has completed.













