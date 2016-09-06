# Install

1. run `./scripts/setup` to install the dependencies. You only have to run this once!

**Note:** To update the dependencies, run `./scripts/update`

# Cook a New Book

1. Find the UUID of the book you want
  - point your browser to `cte-cnx-dev.cnx.org` and find a book you want.
  - click "More Information" and copy the **ID**
1. run `./scripts/fetch-book statistics ${ID}`
  - **Note:** This will require you to log in via ssh. Also, make sure the **ID** contains the version.
1. run `./scripts/bake-book statistics`

Once you have the book, you can just run `./scripts/bake-book` to your :heart:'s content!

# Documentation

1. run `./scripts/generate-docs`
2. open the generated file in your browser
