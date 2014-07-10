library files;

import 'dart:async';

import 'dart:convert';

import 'dart:io' show IOSink, FileMode;
export 'dart:io' show IOSink, FileMode;

abstract class FileSystem {

  File getFile(String path);

  Directory getDirectory(String path);

}

abstract class FileSystemEntry {

  Future<FileSystemEntry> rename(String newPath);

}

abstract class File extends FileSystemEntry {

  String get path;

  Future<DateTime> lastModified();

  Future<bool> exists();

  Future<int> length();

  Stream<List<int>> read([int start, int end]);

  IOSink openWrite({FileMode mode: FileMode.WRITE,
                    Encoding encoding: UTF8});

  Future<String> readAsString();

  Future<File> rename(String newPath);

}


abstract class Directory extends FileSystemEntry {

  Future<Directory> create({bool recursive: false});

  Future<Directory> rename(String newPath);

}
