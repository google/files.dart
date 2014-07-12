library files.html_test;

import 'dart:async';
import 'dart:math' show Random;
import 'dart:html' hide File;

import 'package:quiver/iterables.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';

import 'package:files/html.dart';

main() {
  useHtmlEnhancedConfiguration();
  var random = new Random();

  group('File', () {

    test('exists', () {
      return window.requestFileSystem(1000).then((_fs) {
        var fs = new HtmlFileSystem(_fs);
        var file = fs.getFile('test1.txt');
        return file.exists().then((exists) {
          expect(exists, isFalse);
        });
      });
    });

    test('write and read', () {
      return window.requestFileSystem(1000).then((_fs) {
        var fs = new HtmlFileSystem(_fs);
        var name = random.nextInt(1 << 32).toRadixString(32);
        print(name);
        var file = fs.getFile(name);
        return file.exists()
          .then((exists) {
            expect(exists, isFalse);
          })
          .then((_) => file.writeAsString('hello'))
          .then((_) => file.readAsString())
          .then((s) {
            expect(s, 'hello');
          });
      }).catchError((e) {
        if (e is FileError) {
          fail('FileError: ${e.code} ${e.message}');
        } else {
          throw e;
        }
      });
    });


  });
}