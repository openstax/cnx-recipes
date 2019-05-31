const fs = require('fs')
const sass = require('node-sass')

const recipeName = process.argv[2]

//change this path later
const booksDir = '/Users/bj20/openstax/cnx-recipes/recipes/books/' 

// let sassFile = `./recipes/books/${}/book.scss`
// let cssFile = `./recipes/output/${}.css`

let recipeNames = []

//TODO: 
//look in the books directory 
//put all of the nested directory names into a 'books' array 
//run a loop that on each pass injects sthe name of the book into a sass and css path and then runs the node sass command
//if no speicifc book name is given, compile all book css from books.txt

//change this path later
//NEXT STEP: currently trying to make this thing compile all of the book scss in the array 
fs.readdirSync('/Users/bj20/openstax/cnx-recipes/recipes/books', function(err, books) {

    for (let i=0; i<books.length; i++) {
        let sassFile = `./recipes/books/${books[i]}/book.scss`
        let cssFile = `./recipes/output/${books[i]}new.css`
        
        if (fs.statSync(booksDir + books[i]).isDirectory()) {
            recipeNames.push(books[i])
          
        } else if (fs.statSync(booksDir + books[i]).isFile()) {
            continue
        }

        let scssResult = sass.renderSync({
            file: sassFile, 
            outFile: cssFile
        })

        fs.writeFileSync(cssFile, scssResult.css)
    }
    // console.log(recipeNames)

})

console.log(recipeNames)

//use fs.writeFileSync to compiile to scss. ex in build-style.js