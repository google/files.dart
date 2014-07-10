library files.html_test;

import 'dart:html' hide File;

import 'package:quiver/iterables.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';

import 'package:files/html.dart';

main() {
  useHtmlEnhancedConfiguration();

  group('File', () {

    test('read', () {
      InputElement input = querySelector('#file-input');
      return input.onChange.first.then((_) {
        var file = new HtmlFile(input.files[0]);
        return file.read().toList().then(concat).then((bytes) {
          print(bytes);
        });
      });

    });

  });
}