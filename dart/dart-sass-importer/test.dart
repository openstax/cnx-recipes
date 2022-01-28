// LOOSE COPY PASTED CODE JUST TO IMPLEMENT DART CODE
// Grab a book
import 'dart:io';
import 'package:sass/sass.dart' as sass;
import 'import-once.dart';

void main() {
    var inputFile = './styles/books/finance/book.scss';
    var importer = new UniqueImporter();

    // importer.load(Uri.file(inputFile));

    sass.compileToResult(inputFile, 
        importers: [importer]
    );

}


// var result = sass.compile(arguments[0]);
//   new File(arguments[1]).writeAsStringSync(result);