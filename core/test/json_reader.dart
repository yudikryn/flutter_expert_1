import 'dart:io';

String readJson(String name) {
  try {
    var dir = Directory.current.path;
    if (dir.endsWith('/test')) {
      dir = dir.replaceAll('/test', '');
    }
    return File('$dir/test/$name').readAsStringSync();
  } catch (e) {
    var dir = Directory.current.path;
    if (dir.endsWith('/core/test')) {
      dir = dir.replaceAll('/core/test', '');
    }
    return File('$dir/core/test/$name').readAsStringSync();
  }
}