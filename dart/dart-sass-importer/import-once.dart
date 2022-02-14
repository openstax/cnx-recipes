// in a folder... Dart-sass importer?

import 'package:sass/sass.dart';
import 'package:path/path.dart' as p; // Similar to the path used in js but not the js?

// The path to the file you want to import
// do I have to import path?

//would it make more sense to check this a level above?

// based off of import-once.js

class UniqueImporter extends Importer {
    // A list of Strings to hold previously imported
    var previouslyImported = new List<String>.empty(growable: true); // mark as string types only?

    Uri canonicalize(Uri url) { // This returns an absolute url, a "canon" url to use
        print("UniqueImporter.canonicalize(Uri) called"); // REMOVE ME

        // To add: a check to 
        var pathList = url.pathSegments;
        var newPath = new List<String>.from(pathList.where((item) => item != "." && item != ".."));
        newPath.last = "_" + newPath.last + ".scss";
        var uriToReturn = new Uri.file(p.absolute("styles", p.joinAll(newPath))); 
        // Will break outside of styles, but all should be in styles

        print(uriToReturn.toString()); // REMOVE ME
        return uriToReturn;
    }

    // something to hold what's already imported?

    ImporterResult load(Uri url) {
        print("UniqueImporter.load() called");

        // Match url with prev url

        if (previouslyImported.contains(url.toString())) {
            print("Already been imported!");
        } else {
            print("Unimported URL!");
        }

        // URL is the canonicalized URL!
        // Do I need to actually load this instead of passing it on to others? 
        // Okay, so we need the contents to make an Importer result, right?
        // but contents have not been gotten yet. 

        // for an actual importer, make use of Uri.parse?

        // I've found someone using it this year, but it's not making any sense?? 

        //ImporterResult(String contents, {Uri? sourceMapUrl, Syntax? syntax})

        // Ask Karina about how it's importing

        // return null; // Null won't move to the next one, it'll throw an exception? :

        return ImporterResult('', sourceMapUrl: url, syntax: Syntax.scss);
        //breaks on colors
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
