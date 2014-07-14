library files.file_tests;

import 'dart:async';
import 'dart:math';

import 'package:files/files.dart';
import 'package:unittest/unittest.dart';

final Random _random = new Random();

String _randomName() => _20BitString() + _20BitString() + '.txt';

String _20BitString() => _random.nextInt(1 << 20).toRadixString(16);

Future<File> _createSampleFile(FileSystem fs, [String content]) {
  var file = fs.getFile(_randomName());

  if (content == null) new Future.value(file);

  return file.writeAsString(content).then((_) => file);
}

runFileTests(String name, Future<FileSystem> getFs()) {
  group(name, () {
    group('File', () {

      test('path', () {
        return getFs().then((fs) {
          var name = _randomName();
          var file = fs.getFile(name);
          expect(file.path, name);
        });
      });

      test('exists', () {
        return getFs().then((fs) {
          var file = fs.getFile(_randomName());
          return file.exists().then((exists) {
            expect(exists, isFalse);
          });
        });
      });

      test('length', () {
        return getFs()
          .then((fs) => _createSampleFile(fs, 'hello'))
          .then((file) => file.length())
          .then((len) {
            expect(len, 5);
          });
      });

      test('lastModified', () {
        return getFs()
          .then((fs) => _createSampleFile(fs, 'hello'))
          .then((file) => file.lastModified())
          .then((dateTime) {
            expect(dateTime, isNotNull);
          });
      });

      test('write and read as string', () {
        return getFs().then((fs) {
          var name = _randomName();
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

      test('openWrite() then write()', () {
        return getFs().then((fs) {
          var name = _randomName();
          var file = fs.getFile(name);
          return file.exists()
            .then((e) => expect(e, isFalse))
            .then((_) {
              FileSink sink = file.openWrite();
              sink.write('hello');
              sink.write(' world');
              return sink.close();
            })
            .then((_) => file.readAsString())
            .then((s) {
              expect(s, 'hello world');
            });
        });
      });

      test('openWrite() then add()', () {
        return getFs().then((fs) {
          var name = _randomName();
          var file = fs.getFile(name);
          return file.exists()
            .then((e) => expect(e, isFalse))
            .then((_) {
              FileSink sink = file.openWrite();
              sink.add([104, 101, 108, 108, 111]);
              return sink.close();
            })
            .then((_) => file.readAsString())
            .then((s) {
              expect(s, 'hello');
            });
        });
      });

      test('openWrite() then addStream()', () {
        return getFs().then((fs) {
          var name = _randomName();
          var file = fs.getFile(name);
          return file.exists()
            .then((e) => expect(e, isFalse))
            .then((_) {
              FileSink sink = file.openWrite();
              var stream = new Stream.fromIterable([[104, 101, 108, 108, 111]]);
              return sink.addStream(stream);
            })
            .then((_) => file.readAsString())
            .then((s) {
              expect(s, 'hello');
            });
        });
      });

      test('rename', () {
        return getFs().then((fs) {
          var name1 = _randomName();
          var name2 = _randomName();

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
  });
}
