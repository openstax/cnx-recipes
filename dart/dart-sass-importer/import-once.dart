// in a folder... Dart-sass importer?

import 'package:sass/sass.dart';
import 'package:path/path.dart' as p; // Similar to the path used in js but not the js?

// The path to the file you want to import
// do I have to import path?

//would it make more sense to check this a level above?

// based off of import-once.js

class UniqueImporter extends Importer {
    bool test() {
        print("UniqueImporter.test() called");
        return true;
    }

    Uri canonicalize(Uri url) { // This is called first in CompileToResult. Return the absolute URL?
        print("UniqueImporter.canonicalize(Uri) called");
        // get the directory styles code is in, do the code/styles (and then the relative url)
        // return relative url for now! Worry about depreciation LATER
        // take 'framework/framework' to .../code/styles/framework/_framework.scss
        // if (url.toString()=='framework/framework') {
        //     print("canonicalized returned " + url.toString());
        //     return url;
        // } else {
        //     print("Url is " + url.toString());
        //     return url;
        // }
        // print(p.absolute(url.normalizePath().toString())); // still needs "styles" in there.
        // Overwrite UniqueImporter url with the absolute URL?
        // print(_sourceMapUrl.toString());
        print(this.contents);
        return new Uri.file('code/styles/framework/_framework.scss'); // This gets us past canonicalize?
    }

// something to hold what's already imported?

    ImporterResult load(Uri url) {
        // super.load(url);
        print("UniqueImporter.load() called");
        return null; // Null won't move to the next one, it'll throw an exception? :
    }

// A legacy importer 
// Have we imported this file already, if yes, pass {} if no, run usual importer. by returning null
// if this returns null, it will move on

//override to string to describe that "checks if the file has already been imported"

}

// A legacy importer 
// Have we imported this file already, if yes, pass {} if no, run usual importer. 

// Test file and test data,
// Run the importer while we are compliling
