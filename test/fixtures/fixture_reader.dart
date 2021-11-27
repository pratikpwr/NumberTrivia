import 'dart:io';
// fixtures contains json responses by server for testing
String fixture(String fileName) =>
    File('test/fixtures/$fileName').readAsStringSync();
