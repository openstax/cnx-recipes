import 'dart:io';
import 'package:sass/sass.dart' as sass;

void main(List<String> arguments) {
  var stylesPath = "${Directory.current.path}/styles/";
  var time1 = DateTime.now();
  var result = sass.compileToResult(
    arguments[0],
    loadPaths: {stylesPath}
  );
  var time2 = DateTime.now();
  print("compile time is: ${time2.difference(time1)}");
  new File(arguments[1]).writeAsStringSync(result.css);
}
