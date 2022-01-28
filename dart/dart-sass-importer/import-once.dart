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

    Uri canonicalize(Uri url) { // This is called first in CompileToResult
        print("UniqueImporter.canonicalize(Uri) called");
        print("Url is " + url.toString());
        return url;
    }

    ImporterResult load(Uri url) {
        // super.load(url);
        print("UniqueImporter.load() called");
        return null;
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
