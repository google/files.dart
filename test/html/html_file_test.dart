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

  group('File', () {

    test('path', () {
      return _getFs().then((fs) {
        var name = randomName();
        var file = fs.getFile(name);
        expect(file.path, name);
      });
    });

    test('exists', () {
      return _getFs().then((fs) {
        var file = fs.getFile(randomName());
        return file.exists().then((exists) {
          expect(exists, isFalse);
        });
      });
    });

    test('write and read as string', () {
      return _getFs().then((fs) {
        var name = randomName();
        var file = fs.getFile(name);
        return file.exists()
          .then((e) => expect(e, isFalse))
          .then((_) => file.writeAsString('hello'))
          .then((_) => file.readAsString())
          .then((s) {
            expect(s, 'hello');
          });
      });
    });

    test('openWrite', () {
      return _getFs().then((fs) {
        var name = randomName();
        var file = fs.getFile(name);
        return file.exists()
          .then((e) => expect(e, isFalse))
          .then((_) {
            FileSink sink = file.openWrite();
            sink.write('hello');
            return sink.close();
          })
          .then((_) => file.readAsString())
          .then((s) {
            expect(s, 'hello');
          });
      });
    });

    test('rename', () {
      return _getFs().then((fs) {
        var name1 = randomName();
        var name2 = randomName();

        var file = fs.getFile(name1);
        var file2 = fs.getFile(name2);

        return file.exists()
          .then((exists) {
            expect(exists, isFalse);
          })
          .then((_) => file2.exists())
          .then((exists) {
            expect(exists, isFalse);
          })
          .then((_) => file.writeAsString('hello'))
          .then((_) => file.exists())
          .then((exists) {
            expect(exists, isTrue);
          })
          .then((_) => file.rename(name2))
          .then((_) => file.exists())
          .then((exists) {
            expect(exists, isFalse);
          })
          .then((_) => file2.exists())
          .then((exists) {
            expect(exists, isTrue);
          })
          .then((_) => file2.readAsString())
          .then((s) {
            expect(s, 'hello');
          });
        });
      });

    });
}

Future<HtmlFileSystem> _getFs() => window.requestFileSystem(1000)
    .then((fs) => new HtmlFileSystem(fs));

var random = new Random();

String randomName() => _32BitString() + _32BitString() + '.txt';

String _32BitString() => random.nextInt(1 << 32).toRadixString(32);
