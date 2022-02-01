import 'dart:io';
import 'package:sass/sass.dart' as sass;
import '../../dart/dart-sass-importer/import-once.dart';

void main(List<String> arguments) {
  var stylesPath = "${Directory.current.path}/styles/";
  var time1 = DateTime.now();
  var importer = new UniqueImporter();

  var result = sass.compileToResult(arguments[0],
    importers: [importer],
    loadPaths: {stylesPath},
    sourceMap: true,
  );
  var time2 = DateTime.now();
  print("compile time is: ${time2.difference(time1)}");
  new File(arguments[1]).writeAsStringSync(result.css);
}
