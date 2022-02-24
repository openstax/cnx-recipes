import 'dart:io';
import 'dart:convert';
import 'package:sass/sass.dart' as sass;
import 'package:source_maps/source_maps.dart';

void main(List<String> arguments) {
  if (arguments.length < 1) {
    throw Exception('Input argument not given.');
  }

  var inputFile = arguments[0];
  var outputFile = arguments[1];

  var stylesPath = "${Directory.current.path}/styles/";
  if (File(stylesPath).existsSync()) {
    throw Exception('Cannot find styles root directory.');
  }

  sass.Callable toDataUri = new sass.Callable.function('toDataUri', r'$type, $path', (arguments) {
    var pathString = arguments[1].toString().replaceAll('"', '');
    var typeString = arguments[0].toString().replaceAll('"', '');
    var fileData = File("${stylesPath}${pathString}").readAsBytesSync();
    var encoded = base64Encode(fileData);
    var dataUri = "data:image/${typeString};base64,${encoded}";
    return sass.SassString(dataUri);
  });

  var startTime = DateTime.now();
  var result = sass.compileToResult(
    inputFile,
    loadPaths: {stylesPath},
    sourceMap: true,
    functions: [toDataUri]
  );
  var endTime = DateTime.now();
  print("compile time is: ${endTime.difference(startTime)}");

  if ((result.css.length > 0) & (outputFile.length > 0)) {
    new File(outputFile).writeAsStringSync(result.css);
    new File("${outputFile}.map").writeAsStringSync(json.encode(result.sourceMap.toJson()));
  } else {
    throw Exception("Empty output");
  }
}
