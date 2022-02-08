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

    Uri canonicalize(Uri url) { // This returns an absolute url, a "canon" url to use
        print("UniqueImporter.canonicalize(Uri) called"); // REMOVE ME
        var pathList = url.pathSegments;
        var newPath = new List<String>.from(pathList.where((item) => item != "." && item != ".."));
        newPath.last = "_" + newPath.last + ".scss";
        var uriToReturn = new Uri.file(p.absolute("styles", p.joinAll(newPath)));
        print(uriToReturn.toString());
        return uriToReturn;
    }

// something to hold what's already imported?

    ImporterResult load(Uri url) {
        print("UniqueImporter.load() called");
        // Okay, so we need the contents to make an Importer result, right?
        // How do we 

        //ImporterResult(String contents, {Uri? sourceMapUrl, Syntax? syntax})
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
