// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library files.io_test;

import 'dart:async';
import 'dart:io';

import 'package:files/io.dart' show IoFileSystem;

import 'file_tests.dart';

main() {
  Directory.current = Directory.systemTemp;
  runFileTests('IoFileSystem', () => new Future.value(new IoFileSystem()));
}
