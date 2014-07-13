library files.file_tests;

import 'dart:async';

import 'package:files/files.dart';
import 'package:unittest/unittest.dart';
import 'dart:math';

var random = new Random();

String randomName() => _32BitString() + _32BitString() + '.txt';

String _32BitString() => random.nextInt(1 << 32).toRadixString(32);

runFileTests(String name, Future<FileSystem> getFs()) {
  group(name, () {
    group('File', () {

      test('path', () {
        return getFs().then((fs) {
          var name = randomName();
          var file = fs.getFile(name);
          expect(file.path, name);
        });
      });

      test('exists', () {
        return getFs().then((fs) {
          var file = fs.getFile(randomName());
          return file.exists().then((exists) {
            expect(exists, isFalse);
          });
        });
      });

      test('write and read as string', () {
        return getFs().then((fs) {
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

      test('openWrite() then write()', () {
        return getFs().then((fs) {
          var name = randomName();
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
          var name = randomName();
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
          var name = randomName();
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
  });
}
