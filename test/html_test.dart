library files.html_test;

import 'dart:html' hide File;

import 'package:files/html.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'file_tests.dart';

main() {
  useHtmlEnhancedConfiguration();
  runFileTests('IoFileSystem', () => window.requestFileSystem(1000)
      .then((fs) => new HtmlFileSystem(fs)));
}
