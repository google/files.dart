library files.io_test;

import 'dart:async';
import 'dart:io';

import 'package:files/io.dart' show IoFileSystem;

import 'file_tests.dart';

main() {
  Directory.current = Directory.systemTemp;
  runFileTests('IoFileSystem', () => new Future.value(new IoFileSystem()));
}
