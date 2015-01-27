// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * A [FileSystem] implementation for the `dart:io` library.
 */
library files.io;

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'files.dart';
export 'files.dart';

class IoFileSystem implements FileSystem {

  IoFile getFile(String path) => new IoFile._(new io.File(path));

  IoDirectory getDirectory(String path) =>
      new IoDirectory._(new io.Directory(path));
}

abstract class IoFileSystemEntry implements FileSystemEntry {
  final io.FileSystemEntity _entity;

  IoFileSystemEntry._(this._entity);

  String get path => _entity.path;
}

class IoFile extends IoFileSystemEntry implements File {
  IoFile._(io.File file) : super._(file);

  io.File get _file => _entity;

  Future<DateTime> lastModified() => _file.lastModified();

  Future<bool> exists() => _file.exists();

  Future<int> length() => _file.length();

  Stream<List<int>> openRead([int start, int end]) => _file.openRead(start, end);

  Future<String> readAsString() => _file.readAsString();

  FileSink openWrite({FileMode mode: FileMode.WRITE, Encoding encoding: UTF8}) =>
      new IoFileSink._(_file.openWrite(mode: _ioFileMode(mode), encoding: encoding));

  Future<IoFile> writeAsString(String contents, {Encoding encoding: UTF8}) =>
      _file.writeAsString(contents, encoding: encoding).then((f) => this);

  Future<IoFile> rename(String newPath) =>
      _file.rename(newPath).then((f) => new IoFile._(f));

  Future<IoFile> delete({bool recursive: false}) =>
      _file.delete(recursive: recursive).then((f) => new IoFile._(f));
}

class IoDirectory extends IoFileSystemEntry implements Directory {
  IoDirectory._(io.Directory directory) : super._(directory);

  io.Directory get _directory => _entity;

  Future<IoDirectory> create({bool recursive: false}) =>
      _directory.create(recursive: recursive).then((_) => this);

  Future<IoDirectory> rename(String newPath) =>
      _directory.rename(newPath).then((d) => new IoDirectory._(d));

  Future<IoDirectory> delete({bool recursive: false}) =>
      _directory.delete(recursive: recursive).then((d) => new IoDirectory._(d));

  Stream<FileSystemEntry> list({bool recursive: false,
      bool followLinks: true}) =>
      _directory.list(recursive: recursive, followLinks: followLinks)
          .map(_wrap);
}

FileSystemEntry _wrap(io.FileSystemEntity e) {
  if (e is io.File) return new IoFile._(e);
  if (e is io.Directory) return new IoDirectory._(e);
  if (e is io.Link) throw new UnsupportedError('Links not supported');
  throw new ArgumentError(e);
}

io.FileMode _ioFileMode(FileMode mode) {
  switch (mode) {
    case FileMode.APPEND:
      return io.FileMode.APPEND;
    case FileMode.READ:
      return io.FileMode.READ;
    case FileMode.WRITE:
      return io.FileMode.WRITE;
    default:
      throw new ArgumentError("Unknown FileMode: $mode");
  }
}

class IoFileSink implements FileSink {
  final io.IOSink _sink;

  IoFileSink._(this._sink);

  @override
  void add(List<int> data) => _sink.add(data);

  @override
  void addError(error, [StackTrace stackTrace]) =>
      _sink.addError(error, stackTrace);

  @override
  Future addStream(Stream<List<int>> stream) => _sink.addStream(stream);

  @override
  Future close() => _sink.close();

  @override
  Future get done => _sink.done;

  @override
  void set encoding(Encoding _encoding) { _sink.encoding = _encoding; }

  @override
  Encoding get encoding => _sink.encoding;

  @override
  Future flush() => _sink.flush();

  @override
  void write(Object obj) => _sink.write(obj);

  @override
  void writeAll(Iterable objects, [String separator = ""]) =>
      _sink.writeAll(objects, separator);

  @override
  void writeCharCode(int charCode) => _sink.writeCharCode(charCode);

  @override
  void writeln([Object obj = ""]) => _sink.writeln(obj);
}
