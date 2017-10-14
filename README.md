# files.dart

## Status

This package is deprecated. For a more full-featured replacement, see
[package:file](https://github.com/google/file.dart) or similar.

## Overview

This package defines filesystem APIs that can be implemented for different
environments such as dart:io, Chrome Apps, or network filesystems.

The API includes `FileSystem`, `File` and `Directory` classes with interfaces
similar to those in dart:io, excluding synchronous operations and constructors.

All `File` and `Directory` implementations should not have public constructors,
and instances should only be retreived via a `FileSystem` instance. This ensures
that code that uses the interfaces defined here can work with any implementations.
