library files.io;

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'files.dart';

class IoFileSystem implements FileSystem {

  IoFile getFile(String path) => new IoFile(new io.File(path));

  IoDirectory getDirectory(String path) =>
      new IoDirectory(new io.Directory(path));
}

class IoFile implements File {
  final io.File _file;

  IoFile(this._file);

  String get path => _file.path;

  Future<DateTime> lastModified() => _file.lastModified();

  Future<bool> exists() => _file.exists();

  Future<int> length() => _file.length();

  Stream<List<int>> read([int start, int end]) => _file.openRead(start, end);

  Future<String> readAsString() => _file.readAsString();

  IOSink openWrite({FileMode mode: FileMode.WRITE, Encoding encoding: UTF8}) =>
      _file.openWrite(mode: mode, encoding: encoding);

  Future<File> rename(String newPath) =>
      _file.rename(newPath).then((f) => new IoFile(f));
}

class IoDirectory implements Directory {
  final io.Directory _directory;

  IoDirectory(this._directory);

  Future<IoDirectory> create({bool recursive: false}) =>
      _directory.create(recursive: recursive).then((_) => this);

  Future<IoDirectory> rename(String newPath) =>
      _directory.rename(newPath).then((d) => new IoDirectory(d));
}
