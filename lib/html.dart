library files.html;

import 'dart:async';
import 'dart:html' as html;

import 'package:path/path.dart' as pathlib;

import 'files.dart';

class HtmlFileSystem implements FileSystem {
  final html.FileSystem _fileSystem;

  HtmlFileSystem(this._fileSystem);

  HtmlFile getFile(String path) {
    var parts = pathlib.split(path);
    var dir = _fileSystem.root;
    dir.getFile(path);
  }

}

class HtmlFile implements File {
  final HtmlFileSystem _fs;
  final String _path;
  html.File __file;

  HtmlFile._(this._fs, this._path);

  String get path => _path;

  Future<html.File> _getFile() {
    if (__file != null) return new Future.value(__file);
    return _fs._fileSystem.root.getFile(_path).then((f) {
      __file = f as html.File;
      return f;
    });
  }

  Future<DateTime> lastModified() => _getFile().then((f) => f.lastModifiedDate);

  Future<bool> exists() => _fs._fileSystem.root.getFile(_path)
      .then((_) => true)
      .catchError((e) {
        print(e);
        return false;
      });

  Future<int> length() => _getFile().then((f) => f.size);

  Stream<List<int>> read([int start, int end]) {
    var file = _file;

    if (start != null || end != null) {
      file = _file.slice(start, end);
    }

    html.FileReader reader = new html.FileReader();
    var stream = reader.onLoadEnd.first.then((_) {
      print(reader.result.runtimeType);
      return reader.result;
    }).asStream();
    reader.readAsArrayBuffer(file);
    return stream;
  }

  Future<String> readAsString() {
    html.FileReader reader = new html.FileReader();
    var stream = reader.onLoadEnd.first.then((_) {
      print(reader.result.runtimeType);
      return reader.result;
    });
    reader.readAsText(_file);
    return stream;
  }
}
