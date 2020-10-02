// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library files.html_test;

import 'dart:html' hide File;

import 'package:files/html.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'file_tests.dart';

main() {
  useHtmlEnhancedConfiguration();
  runFileTests(
      'HtmlFileSystem',
      () =>
          window.requestFileSystem(1000).then((fs) => new HtmlFileSystem(fs)));
}
